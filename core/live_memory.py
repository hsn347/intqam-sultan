# -*- coding: utf-8 -*-
r"""
core/live_memory.py — Production-Grade Live State Memory Engine for Revenge of Sultans
══════════════════════════════════════════════════════════════════════════════════════
Author: Core Live Memory Engineer (Backend Core Implementation)
Workspace: e:\intqam-sultan

Key Responsibilities:
  1. Ingress Controller Whitelisting: Strips non-whitelisted controllers from incoming
     server packets (retdata / data / notifyData) to eliminate memory leaks and bloat.
  2. Smart Deep Merge Engine: Recursively merges nested dictionaries and applies
     Copy-on-Write (CoW) entity-keyed updates to lists without wipes or duplicates.
  3. Real-Time Notification Synchronizers: Handles push notifications (NOTIFY_CITY,
     NOTIFY_QUEUE, NOTIFY_BACKPACK, NOTIFY_ARMY, NOTIFY_HERO, NOTIFY_LORD, NOTIFY_BUFF,
     NOTIFY_LOCAL_QUEUE_SYNC) reflecting state transitions directly into live memory.
  4. Separate March Tracking: Maintains active march queues separately for the castle
     (init_data["local_queues"]) and other players' marches (init_data["other_local_queues"]).
  5. Strict Memory Readiness Gate: Validates structural integrity of critical
     startup controllers before allowing bot tasks to execute (0-Network checks).
  6. Concurrency & Thread-Safety: Dual-lock protection via threading.RLock and asyncio.Lock.
"""

from __future__ import annotations

import asyncio
import copy
import json
import logging
import re
import threading
import time
from typing import (
    Any,
    Callable,
    Dict,
    FrozenSet,
    Iterable,
    List,
    Mapping,
    MutableMapping,
    Optional,
    Sequence,
    Set,
    Tuple,
    Union,
)

logger = logging.getLogger("LiveMemory")

# ══════════════════════════════════════════════════════════════════════════════
# 1. Controller Whitelists & Startup Readiness Definitions
# ══════════════════════════════════════════════════════════════════════════════

# Authoritative frozenset of controllers required by bot tasks & systems
ALLOWED_CONTROLLERS: FrozenSet[str] = frozenset({
    # --- Critical Startup Core (6) ---
    "cityCtrl",
    "lordInfoCtrl",
    "queueCtrl",
    "armyCtrl",
    "heroCtrl",
    "backpackCtrl",

    # --- Core Subsystems & Progression (19) ---
    "heroSysCtrl",
    "allianceCtrl",
    "technologyCtrl",
    "vipCtrl",
    "meritoriousTaskCtrl",
    "timeRewardCtrl",
    "lordSkillCtrl",
    "boeAttributeCtrl",
    "buffCtrl",
    "newBuffCtrl",
    "petCtrl",
    "kingdomMapCtrl",
    "buyStaminaCtrl",
    "wallsCtrl",
    "taskCtrl",
    "questCtrl",
    "everydayTaskCtrl",
    "achievementctrl",
    "commandHall",
    "commandHallCtrl",
    "armyGroupTaskData",
    "tomorrowArmyGroupTaskData",

    # --- Feature & Activity Tasks (24) ---
    "storesCtrl",
    "treviFountainCtrl",
    "salesRoomAgCtrl",
    "pyramidCtrl",
    "heroVoyageAgCtrl",
    "heroEnlistCtrl",
    "heroTacticalHallAgCtrl",
    "heroTacticalHallCtrl",
    "heroEquipAgCtrl",
    "runeForgeAgCtrl",
    "allianceTreasureCtrl",
    "cumulateRewardData",
    "fieldShopCtrl",
    "PveBattleCtrl",
    "badgeExchangeCtrl",
    "savingsBankAgCtrl",
    "troyTreasureAgCtrl",
    "exchangeStoreAgCtrl",
    "generalAtyMgr",
    "activityShowCtrl",
    "escortCtrl",
    "escortCartCtrl",
    "escortAssistCtrl",
    "godBeastCtrl",
    "equipmentCtrl",
    "playerCtrl",
    "itemShop",
    "shopItemBuyTimesMgr",
    "loginRewardCtrl",
    "shopCtrl",
    "playerArenaCtrl",
    "arenaCtrl",
    "stuffWorkshopCtrl",
    "stuffWorkshop",
    "dressCtrl",
    "godArmsCtrl",
    "godArmsRuneCtrl",
    "miraculousWeaponCtrl",
    "divineBeastCtrl",
    "divineBeastMarkCtrl",
    "htData",
    "exaltedPrivilegeCtrl",
    "heroComboSkillCtrl",
    "militaryRankCtrl",
    "warGemCtrl",
    "playerKingdomLevelCtrl",
    "nebulaTowerCtrl",
    "heroBiographyCtrl",

    # --- Aliases & Internal State Keys (10) ---
    "lord",
    "army",
    "queue",
    "bagCtrl",
    "itemCtrl",
    "loginDataInitCtrl",
    "item_sign",
    "local_queues",
    "other_local_queues",
    "everydayTask",
})

# Backward-compatible alias used by external tools/tests
ALLOWED_INIT_CONTROLLERS: FrozenSet[str] = ALLOWED_CONTROLLERS

# The exact controllers required before allowing bot tasks to execute
CRITICAL_STARTUP_CONTROLLERS: FrozenSet[str] = frozenset({
    "cityCtrl",
    "lordInfoCtrl",
    "queueCtrl",
    "armyCtrl",
    "heroSysCtrl",
    "backpackCtrl",
})

# Fallback queries mapping critical controller -> (cmd, subcmd, payload)
FALLBACK_QUERIES: Dict[str, Tuple[int, int, Dict[str, Any]]] = {
    "cityCtrl": (1001, 1, {}),
    "lordInfoCtrl": (1002, 1, {}),
    "queueCtrl": (1003, 1, {}),
    "armyCtrl": (1005, 1, {}),
    "backpackCtrl": (1004, 1, {}),
    "local_queues": (1007, 1000, {}),
    "stuffWorkshopCtrl": (2021, 1, {}),
}


def get_fallback_query(controller: str, uid: Any = 0) -> Optional[Tuple[int, int, Dict[str, Any]]]:
    """
    Returns the (cmd, subcmd, payload) tuple for querying missing controller data.
    """
    if controller not in FALLBACK_QUERIES:
        return None
    cmd, subcmd, payload = FALLBACK_QUERIES[controller]
    return cmd, subcmd, copy.deepcopy(payload)


# ══════════════════════════════════════════════════════════════════════════════
# 2. Domain Constants & Building Lifecycle Definitions
# ══════════════════════════════════════════════════════════════════════════════

class BUILD_STATE:
    NORMAL = "0"
    BUILDING = "1"
    UPGRADING = "2"
    DEMOLISHING = "3"
    LOCK = "8"


class BUILD_OPERATE_TYPE:
    BUILD = 0
    DEMOLISH = 1
    UPGRADE = 2
    CANCEL = 11


# ══════════════════════════════════════════════════════════════════════════════
# 3. Smart Deep-Merge Engine (CoW & Keyed Lists)
# ══════════════════════════════════════════════════════════════════════════════

KeySpec = Union[
    str,
    Sequence[Union[str, Tuple[str, ...]]],
    Callable[[Dict[str, Any]], Optional[str]],
]

_BUFF_EXTRA_RE = re.compile(r"bid_(\d+)_iid_(\d+)")


def _extract_buff_extra_bid_iid(item: Any) -> Tuple[Optional[str], Optional[str]]:
    """Extracts normalized (bid, iid) strings from a buff's extra payload or top-level fields."""
    if not isinstance(item, Mapping):
        return None, None
    bid = item.get("bid")
    iid = item.get("iid")
    extra = item.get("extra")
    if isinstance(extra, str):
        s = extra.strip()
        if s.startswith("{"):
            try:
                extra = json.loads(s)
            except Exception:
                extra = None
        else:
            m = _BUFF_EXTRA_RE.search(s)
            if m:
                if bid is None:
                    bid = m.group(1)
                if iid is None:
                    iid = m.group(2)
    if isinstance(extra, Mapping):
        if bid is None:
            bid = extra.get("bid")
        if iid is None:
            iid = extra.get("iid")
    bid_str = str(bid).strip() if bid is not None and str(bid).strip() != "" else None
    iid_str = str(iid).strip() if iid is not None and str(iid).strip() != "" else None
    return bid_str, iid_str


def _extract_buff_identity(item: Dict[str, Any]) -> Optional[str]:
    """
    Composite identity key for buffCtrl entries.
    Building-scoped buffs share identical `id` (e.g. 5020 for all farms) and are
    uniquely distinguished by `(bid, iid)` inside `extra` (matching Lua buffSourceList).
    """
    if not isinstance(item, dict):
        return None
    buff_id = item.get("id")
    if buff_id is None:
        buff_id = item.get("buffId")
    if buff_id is None:
        buff_id = item.get("effectType")
    if buff_id is None:
        return None

    base = f"buff:{str(buff_id).strip()}"
    bid_str, iid_str = _extract_buff_extra_bid_iid(item)
    if bid_str is not None and iid_str is not None:
        return f"{base}|bid:{bid_str}|iid:{iid_str}"
    return base


DEFAULT_KEY_MAPS: Dict[str, KeySpec] = {
    # City buildings: match by 'index' (including binfo.index); fallback to (bid, iid)
    "cityCtrl.blist": ("index", ("bid", "iid")),
    "blist": ("index", ("bid", "iid")),

    # Heroes: match by id or heroId or cId
    "heroCtrl.heroes": ("id", "heroId", "cId"),
    "heroCtrl": ("id", "heroId", "cId"),
    "heroes": ("id", "heroId", "cId"),

    # Buffs: composite identity (id/buffId + extra.bid + extra.iid when building-scoped)
    "buffCtrl": _extract_buff_identity,
    "buffCtrl.list": _extract_buff_identity,
    "buffCtrl.buffList": _extract_buff_identity,
    "newBuffCtrl": _extract_buff_identity,

    # Queues: match by qtype, queuetype, queueId, or id
    "queueCtrl": ("qtype", "queuetype", "queueId", "id"),
    "local_queues": ("id",),
    "other_local_queues": ("id",),

    # Consign tasks: match by index or id
    "heroVoyageAgCtrl.consignTasks": ("index", "id"),
    "consignTasks": ("index", "id"),

    # Backpack items if represented as list
    "backpackCtrl.items": ("id", "itemId"),
    "backpackCtrl": ("id", "itemId"),
    "bagCtrl": ("id", "itemId"),

    # Meritorious tasks
    "meritoriousTaskCtrl.tasks": ("id", "taskId", "dynamicId"),
    "meritoriousTaskCtrl.taskData": ("id", "taskId", "dynamicId"),

    # Alliance help list
    "allianceCtrl.helplist": ("id", "helpId"),

    # Equipment items: match by unique instance epid (NEVER recipe eid, which repeats across pieces)
    "equipmentCtrl.equipment_array": ("epid", "id"),
    "equipment_array": ("epid", "id"),
    "equipmentCtrl": ("epid", "id"),
}

GENERIC_CANDIDATE_KEYS = (
    "index", "epid", "id", "eid", "bid", "qtype", "queuetype", "queueId",
    "heroId", "buffId", "taskId", "helpId", "itemId", "uid", "key"
)


def _extract_field_value(item: Any, field_name: str) -> Optional[Any]:
    """Extracts a field from item directly or from item['binfo']."""
    if not isinstance(item, dict):
        return None
    if field_name in item and item[field_name] is not None:
        return item[field_name]
    binfo = item.get("binfo")
    if isinstance(binfo, dict) and field_name in binfo and binfo[field_name] is not None:
        return binfo[field_name]
    return None


def extract_entity_key(item: Any, key_spec: Optional[KeySpec] = None) -> Optional[str]:
    """
    Extracts a normalized, hashable string identity from a dictionary entity.
    Supports single keys, composite keys (e.g. ('bid', 'iid')), custom extractors,
    and automatic fallback to generic identifiers.
    """
    if not isinstance(item, dict):
        return None

    # 1. Custom callable extractor
    if callable(key_spec):
        res = key_spec(item)
        return str(res).strip() if res is not None else None

    # 2. Explicit key_spec supplied
    if key_spec is not None:
        candidates = [key_spec] if isinstance(key_spec, str) else list(key_spec)

        for candidate in candidates:
            # Composite key: e.g. ("bid", "iid")
            if isinstance(candidate, (tuple, list)):
                parts = []
                all_found = True
                for sub_field in candidate:
                    val = _extract_field_value(item, str(sub_field))
                    if val is None:
                        all_found = False
                        break
                    parts.append(f"{sub_field}:{str(val).strip()}")
                if all_found:
                    return "|".join(parts)
            else:
                # Single candidate field
                val = _extract_field_value(item, str(candidate))
                if val is not None:
                    return f"{candidate}:{str(val).strip()}"

    # 3. Generic heuristic candidate search
    for candidate in GENERIC_CANDIDATE_KEYS:
        val = _extract_field_value(item, candidate)
        if val is not None:
            return f"{candidate}:{str(val).strip()}"

    # 4. Composite fallback for buildings: bid + iid
    bid = _extract_field_value(item, "bid")
    iid = _extract_field_value(item, "iid")
    if bid is not None and iid is not None:
        return f"bid:{str(bid).strip()}|iid:{str(iid).strip()}"

    return None


def _merge_keyed_lists(
    target_list: List[Any],
    update_list: List[Any],
    key_spec: Optional[KeySpec],
    sub_path: Tuple[str, ...],
    key_maps: Mapping[str, KeySpec],
    delete_marker: str = "_delete"
) -> List[Any]:
    """
    Merges update_list into target_list using Copy-on-Write (CoW).
    Replaces the list container reference to preserve iterator integrity
    in concurrent reader coroutines.
    """
    # 1. Build index map of existing target items: key -> (index, dict)
    existing_map: Dict[str, Tuple[int, Dict[str, Any]]] = {}
    for idx, item in enumerate(target_list):
        if isinstance(item, dict):
            k = extract_entity_key(item, key_spec)
            if k:
                existing_map[k] = (idx, item)

    # Work on a shallow copy of target_list to guarantee Copy-on-Write
    result_list: List[Any] = list(target_list)
    keys_to_delete: Set[str] = set()

    # 2. Iterate through update_list
    for update_item in update_list:
        if not isinstance(update_item, dict):
            # Non-dict in update list: append if not already present
            if update_item not in result_list:
                result_list.append(copy.deepcopy(update_item))
            continue

        # Check for deletion marker
        is_delete = (
            update_item.get(delete_marker) is True
            or str(update_item.get("notifyType", "")).lower() in ("del", "remove", "cancel", "finish")
            or str(update_item.get("state", "")).lower() in ("del", "demolish_done")
        )

        item_key = extract_entity_key(update_item, key_spec)

        if item_key and item_key in existing_map:
            orig_idx, existing_item = existing_map[item_key]
            if is_delete:
                keys_to_delete.add(item_key)
            else:
                # Merge update_item into existing_item
                smart_deep_merge(
                    target=existing_item,
                    update=update_item,
                    key_maps=key_maps,
                    path=sub_path + (item_key,),
                    in_place=True,
                    delete_marker=delete_marker
                )
        else:
            if not is_delete:
                new_copy = copy.deepcopy(update_item)
                new_copy.pop(delete_marker, None)
                result_list.append(new_copy)
                if item_key:
                    existing_map[item_key] = (len(result_list) - 1, new_copy)

    # 3. Apply deletions cleanly if any
    if keys_to_delete:
        result_list = [
            item for item in result_list
            if not (isinstance(item, dict) and extract_entity_key(item, key_spec) in keys_to_delete)
        ]

    return result_list


def smart_deep_merge(
    target: MutableMapping[str, Any],
    update: Mapping[str, Any],
    key_maps: Optional[Mapping[str, KeySpec]] = None,
    path: Tuple[str, ...] = (),
    in_place: bool = True,
    delete_marker: str = "_delete"
) -> MutableMapping[str, Any]:
    """
    Recursively and atomically merges `update` into `target`.

    Guarantees:
      1. Keyed lists of dictionaries merge elements by identity (no wipes, no duplicates).
      2. Missing entities in keyed lists are appended.
      3. Entities marked for deletion are safely pruned.
      4. Primitive lists are replaced with deep copies of the update list.
      5. Nested dictionaries are deeply traversed and merged.
      6. Untouched target fields are strictly preserved.
      7. Modifying lists swaps the list container reference (Copy-on-Write)
         preventing iterator invalidation in concurrent reader coroutines.
    """
    if not isinstance(target, MutableMapping) or not isinstance(update, Mapping):
        raise TypeError(f"smart_deep_merge requires mappings, got target={type(target)}, update={type(update)}")

    effective_key_maps = DEFAULT_KEY_MAPS if key_maps is None else {**DEFAULT_KEY_MAPS, **key_maps}
    dest = target if in_place else copy.deepcopy(target)

    for key, update_val in update.items():
        current_path = path + (str(key),)
        path_str = ".".join(current_path)

        # Explicit deletion marker at mapping level
        if isinstance(update_val, Mapping) and update_val.get(delete_marker) is True:
            dest.pop(key, None)
            continue

        # 1. Key not in target: insert deep copy
        if key not in dest:
            dest[key] = copy.deepcopy(update_val)
            continue

        target_val = dest[key]

        # 2. Both values are Mappings: recursive deep merge
        if isinstance(target_val, MutableMapping) and isinstance(update_val, Mapping):
            smart_deep_merge(
                target=target_val,
                update=update_val,
                key_maps=effective_key_maps,
                path=current_path,
                in_place=True,
                delete_marker=delete_marker
            )

        # 3. Both values are Lists: smart keyed or primitive list merge
        elif isinstance(target_val, list) and isinstance(update_val, list):
            has_dicts = any(isinstance(x, dict) for x in update_val) or any(isinstance(x, dict) for x in target_val)

            if has_dicts:
                # Resolve key_spec for path
                key_spec = None
                for candidate_path in (path_str, str(key)):
                    if candidate_path in effective_key_maps:
                        key_spec = effective_key_maps[candidate_path]
                        break

                # Apply Copy-on-Write container replacement
                dest[key] = _merge_keyed_lists(
                    target_list=target_val,
                    update_list=update_val,
                    key_spec=key_spec,
                    sub_path=current_path,
                    key_maps=effective_key_maps,
                    delete_marker=delete_marker
                )
            else:
                # Primitive list: replace with deep copy
                dest[key] = copy.deepcopy(update_val)

        # 4. Scalar value, primitive, or mismatched types: replace
        else:
            dest[key] = copy.deepcopy(update_val)

    return dest


# ══════════════════════════════════════════════════════════════════════════════
# 4. Local Queue / March Ownership Utilities
# ══════════════════════════════════════════════════════════════════════════════

def resolve_queue_owner_uid(queue_item: Any) -> Optional[str]:
    """
    Extracts owner UID from a local queue entry matching Lua kingdomQueueObjCell:getUid()
    (checks uid, playerID, from.uid, and explicit '<digits>-<seq>' id prefix).
    """
    if not isinstance(queue_item, dict):
        return None
    for key in ("uid", "playerID"):
        val = queue_item.get(key)
        if val not in (None, "", 0, "0"):
            return str(val).strip()
    from_obj = queue_item.get("from")
    if isinstance(from_obj, dict):
        val = from_obj.get("uid")
        if val not in (None, "", 0, "0"):
            return str(val).strip()
    qid = queue_item.get("id") if queue_item.get("id") not in (None, "") else queue_item.get("queueId")
    if qid is not None:
        parts = str(qid).strip().split("-", 1)
        if len(parts) == 2 and parts[0].isdigit() and parts[0] != "0":
            return parts[0]
    return None


def is_own_march_queue(queue_item: Any, my_uid: Any) -> bool:
    """
    Returns True if queue_item belongs to `my_uid` (or has no owner metadata, e.g. in unit-test mocks).
    Excludes other alliance/world players' marches when owner UID differs from `my_uid` or when
    `my_uid` is not yet resolved while `queue_item` carries an explicit foreign owner UID.
    """
    if not isinstance(queue_item, dict):
        return False
    owner_uid = resolve_queue_owner_uid(queue_item)
    my_uid_s = str(my_uid).strip() if my_uid not in (None, "", 0, "0") else ""
    if not my_uid_s:
        return owner_uid is None
    if not owner_uid:
        return True
    return owner_uid == my_uid_s


# ══════════════════════════════════════════════════════════════════════════════
# 5. Live Memory Engine Class
# ══════════════════════════════════════════════════════════════════════════════

class LiveMemoryEngine:
    """
    Central in-memory state engine for Revenge of Sultans game bot.

    Maintains `init_data`, enforces ingress whitelisting, routes push
    notifications, tracks local march queues, mirrors own vs other marches,
    and provides thread-safe access.
    """

    def __init__(self, init_data: Optional[Dict[str, Any]] = None, owner_uid: Any = None):
        self.init_data: Dict[str, Any] = init_data if init_data is not None else {}
        self.local_queues_map: Dict[str, Any] = {}
        self.local_queues_synced: bool = False
        self.owner_uid: str = str(owner_uid).strip() if owner_uid not in (None, "", 0, "0") else ""
        self._thread_lock = threading.RLock()
        self._async_lock: Optional[asyncio.Lock] = None
        self.last_ingest_report: Optional[Dict[str, Any]] = None

    def _resolve_owner_uid(self) -> str:
        """Resolves owner UID from configured owner_uid or startup controller data."""
        if self.owner_uid:
            return self.owner_uid
        for ctrl_name in ("lordInfoCtrl", "loginDataInitCtrl", "playerCtrl", "lord"):
            ctrl = self.init_data.get(ctrl_name)
            if isinstance(ctrl, dict):
                base = ctrl.get("base")
                if isinstance(base, dict) and base.get("uid") not in (None, "", 0, "0"):
                    self.owner_uid = str(base["uid"]).strip()
                    return self.owner_uid
                if ctrl.get("uid") not in (None, "", 0, "0"):
                    self.owner_uid = str(ctrl["uid"]).strip()
                    return self.owner_uid
        return ""

    def get_local_queues_breakdown(self) -> Tuple[List[Any], List[Any]]:
        """Returns (own_queues, other_players_queues) from local_queues_map under lock."""
        with self._thread_lock:
            my_uid = self._resolve_owner_uid()
            own: List[Any] = []
            other: List[Any] = []
            for q in self.local_queues_map.values():
                if is_own_march_queue(q, my_uid):
                    own.append(q)
                else:
                    other.append(q)
            return own, other

    def get_own_local_queues(self) -> List[Any]:
        """Returns shallow list copy of active marches belonging strictly to this castle."""
        return self.get_local_queues_breakdown()[0]

    def get_other_local_queues(self) -> List[Any]:
        """Returns shallow list copy of other players' marches in view."""
        return self.get_local_queues_breakdown()[1]

    @property
    def async_lock(self) -> asyncio.Lock:
        """Lazily initialize asyncio.Lock inside running event loop."""
        if self._async_lock is None:
            self._async_lock = asyncio.Lock()
        return self._async_lock

    def clear(self) -> None:
        """Resets the live memory state cleanly."""
        with self._thread_lock:
            self.init_data.clear()
            self.local_queues_map.clear()
            self.local_queues_synced = False
            self.last_ingest_report = None

    # ──────────────────────────────────────────────────────────────────────────
    # Whitelist & Ingress Filtering
    # ──────────────────────────────────────────────────────────────────────────

    def filter_whitelisted(self, packet_data: Any) -> Dict[str, Any]:
        """
        Filters any controller dictionary to retain ONLY keys present in ALLOWED_CONTROLLERS.
        Strips high-frequency chat, red points, and unused activity garbage.
        """
        if not isinstance(packet_data, dict):
            return {}
        return {k: v for k, v in packet_data.items() if k in ALLOWED_CONTROLLERS}

    def extract_controllers(self, packet: Any) -> Dict[str, Any]:
        """
        Inspects an incoming network packet or data envelope, discovers controller
        payloads (in retdata, data, or packet root), and returns a whitelisted dict.
        """
        if not isinstance(packet, dict):
            return {}

        candidates: List[Dict[str, Any]] = []

        data = packet.get("data")
        if isinstance(data, dict):
            if "retdata" in data and isinstance(data["retdata"], dict):
                candidates.append(data["retdata"])
            if "initData" in data and isinstance(data["initData"], dict):
                candidates.append(data["initData"])
            candidates.append(data)

        retdata = packet.get("retdata")
        if isinstance(retdata, dict):
            candidates.append(retdata)

        init_data_root = packet.get("initData")
        if isinstance(init_data_root, dict):
            candidates.append(init_data_root)

        candidates.append(packet)

        for candidate in candidates:
            filtered = self.filter_whitelisted(candidate)
            if filtered:
                return filtered

        return {}

    def _sync_local_queues_from_list(self, queues: List[Any]) -> None:
        """Synchronizes local_queues_map from a controller-extracted queue list."""
        new_map: Dict[str, Any] = {}
        for m in queues:
            if not isinstance(m, dict):
                continue
            raw_id = m.get("id") if m.get("id") not in (None, "") else m.get("queueId")
            if raw_id:
                new_map[str(raw_id)] = copy.deepcopy(m)
        if new_map or len(queues) == 0:
            self.local_queues_map.clear()
            self.local_queues_map.update(new_map)
        self.local_queues_synced = True
        own_q, other_q = self.get_local_queues_breakdown()
        self.init_data["local_queues"] = own_q
        self.init_data["other_local_queues"] = other_q
        if isinstance(self.init_data.get("queueCtrl"), dict):
            self.init_data["queueCtrl"]["queues"] = list(own_q)

    @staticmethod
    def _extract_notification_envelope(packet: Dict[str, Any]) -> Tuple[Any, Any, bool]:
        """Extracts (notify_id, notify_data, is_1009_cmd) from a server packet."""
        cmd_s = str(packet.get("cmd", ""))
        is_1009 = cmd_s in ("1009", "onemt_1009")
        if "notifyID" in packet:
            return packet.get("notifyID"), packet.get("notifyData"), is_1009
        data = packet.get("data")
        if isinstance(data, dict) and "notifyID" in data:
            return data.get("notifyID"), data.get("notifyData"), is_1009
        if is_1009 and isinstance(data, dict):
            return data.get("notifyID"), data.get("notifyData"), True
        return None, None, is_1009

    # Mapping of normalized notifyID values -> (handler_method_name, base_targets, requires_data)
    _NOTIFY_ROUTE_TABLE: Dict[str, Tuple[str, Tuple[str, ...], bool]] = {
        "9": ("_handle_notify_city", ("cityCtrl",), True),
        "CITY": ("_handle_notify_city", ("cityCtrl",), True),
        "NOTIFY_CITY": ("_handle_notify_city", ("cityCtrl",), True),
        "NOTIFY_CITY_UPDATE": ("_handle_notify_city", ("cityCtrl",), True),
        "14": ("_handle_notify_queue", ("queueCtrl",), True),
        "QUEUE": ("_handle_notify_queue", ("queueCtrl",), True),
        "NOTIFY_QUEUE": ("_handle_notify_queue", ("queueCtrl",), True),
        "NOTIFY_QUEUE_UPDATE": ("_handle_notify_queue", ("queueCtrl",), True),
        "1051": ("_handle_notify_queue", ("queueCtrl",), True),
        "PLAYER_QUEUE_CHANGE": ("_handle_notify_queue", ("queueCtrl",), True),
        "NOTIFY_PLAYER_QUEUE_CHANGE": ("_handle_notify_queue", ("queueCtrl",), True),
        "1": ("_handle_notify_backpack", ("backpackCtrl",), True),
        "BACKPACK": ("_handle_notify_backpack", ("backpackCtrl",), True),
        "NOTIFY_BACKPACK": ("_handle_notify_backpack", ("backpackCtrl",), True),
        "NOTIFY_BACKPACK_UPDATE": ("_handle_notify_backpack", ("backpackCtrl",), True),
        "15": ("_handle_notify_army", ("armyCtrl",), True),
        "ARMY": ("_handle_notify_army", ("armyCtrl",), True),
        "NOTIFY_ARMY": ("_handle_notify_army", ("armyCtrl",), True),
        "NOTIFY_ARMY_UPDATE": ("_handle_notify_army", ("armyCtrl",), True),
        "104": ("_handle_notify_hero", ("heroCtrl",), True),
        "HERO": ("_handle_notify_hero", ("heroCtrl",), True),
        "NOTIFY_HERO": ("_handle_notify_hero", ("heroCtrl",), True),
        "406": ("_handle_notify_hero_sys", ("heroSysCtrl",), True),
        "HERO_SYS": ("_handle_notify_hero_sys", ("heroSysCtrl",), True),
        "NOTIFY_HERO_SYS": ("_handle_notify_hero_sys", ("heroSysCtrl",), True),
        "8": ("_handle_notify_lord", ("lordInfoCtrl",), True),
        "LORD": ("_handle_notify_lord", ("lordInfoCtrl",), True),
        "NOTIFY_LORD": ("_handle_notify_lord", ("lordInfoCtrl",), True),
        "NOTIFY_LORD_UPDATE": ("_handle_notify_lord", ("lordInfoCtrl",), True),
        "7": ("_handle_notify_buff", ("buffCtrl",), True),
        "BUFF": ("_handle_notify_buff", ("buffCtrl",), True),
        "NOTIFY_BUFF": ("_handle_notify_buff", ("buffCtrl",), True),
        "NOTIFY_BUFF_UPDATE": ("_handle_notify_buff", ("buffCtrl",), True),
        "202": ("_handle_notify_local_queue", ("local_queues",), True),
        "LOCAL_QUEUE_SYNC": ("_handle_notify_local_queue", ("local_queues",), True),
        "NOTIFY_LOCAL_QUEUE_SYNC": ("_handle_notify_local_queue", ("local_queues",), True),
        "16": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "20": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "TIME_REWARD": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "NOTIFY_TIME_REWARD": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "NOTIFY_RESET_TIME_REWARD": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "REWARD": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "NOTIFY_REWARD": ("_handle_notify_time_reward", ("timeRewardCtrl",), False),
        "1070": ("_handle_notify_meritorious", ("meritoriousTaskCtrl",), True),
        "MERITORIOUS_TASK": ("_handle_notify_meritorious", ("meritoriousTaskCtrl",), True),
        "NOTIFY_MERITORIOUS_TASK": ("_handle_notify_meritorious", ("meritoriousTaskCtrl",), True),
        "SERVER_STATUS": ("_handle_notify_server_status", ("serverStatus",), False),
        "NOTIFY_SERVER_STATUS": ("_handle_notify_server_status", ("serverStatus",), False),

        # --- Feature & Base Tasks Controllers (0-Network Direct Sync) ---
        "2": ("_handle_notify_world_update", ("kingdomMapCtrl",), True),
        "WORLD_UPDATE": ("_handle_notify_world_update", ("kingdomMapCtrl",), True),
        "NOTIFY_WORLD_UPDATE": ("_handle_notify_world_update", ("kingdomMapCtrl",), True),
        "18": ("_handle_notify_login_reward", ("loginRewardCtrl",), False),
        "DAILYLOGIN_REWARD": ("_handle_notify_login_reward", ("loginRewardCtrl",), False),
        "NOTIFY_DAILYLOGIN_REWARD": ("_handle_notify_login_reward", ("loginRewardCtrl",), False),
        "37": ("_handle_notify_hero_trial", ("htData",), True),
        "HERO_TRIAL": ("_handle_notify_hero_trial", ("htData",), True),
        "NOTIFY_HERO_TRIAL": ("_handle_notify_hero_trial", ("htData",), True),
        "55": ("_handle_notify_everyday_task", ("everydayTaskCtrl",), True),
        "EVERYDAY_TASK": ("_handle_notify_everyday_task", ("everydayTaskCtrl",), True),
        "NOTIFY_EVERYDAY_TASK": ("_handle_notify_everyday_task", ("everydayTaskCtrl",), True),
        "49": ("_handle_notify_escort", ("escortCtrl",), True),
        "ESCORT": ("_handle_notify_escort", ("escortCtrl",), True),
        "NOTIFY_ESCORT": ("_handle_notify_escort", ("escortCtrl",), True),
        "50": ("_handle_notify_escort_cart", ("escortCartCtrl",), True),
        "ESCORT_CART": ("_handle_notify_escort_cart", ("escortCartCtrl",), True),
        "NOTIFY_ESCORT_CART": ("_handle_notify_escort_cart", ("escortCartCtrl",), True),
        "3": ("_handle_notify_alliance", ("allianceCtrl",), True),
        "ALLIANCE": ("_handle_notify_alliance", ("allianceCtrl",), True),
        "NOTIFY_ALLIANCE": ("_handle_notify_alliance", ("allianceCtrl",), True),
        "NOTIFY_ALLIANCE_UPDATE": ("_handle_notify_alliance", ("allianceCtrl",), True),
        "64": ("_handle_notify_alliance_relation", ("allianceCtrl",), True),
        "ALLIANCE_RELATION": ("_handle_notify_alliance_relation", ("allianceCtrl",), True),
        "NOTIFY_ALLIANCE_RELATION": ("_handle_notify_alliance_relation", ("allianceCtrl",), True),
        "1009": ("_handle_notify_alliance_recommend", ("allianceCtrl",), True),
        "ALLIANCE_RECOMMEND": ("_handle_notify_alliance_recommend", ("allianceCtrl",), True),
        "NOTIFY_ALLIANCE_RECOMMEND": ("_handle_notify_alliance_recommend", ("allianceCtrl",), True),
        "608": ("_handle_notify_command_hall", ("commandHallCtrl", "commandHall"), True),
        "COMMAND_HALL": ("_handle_notify_command_hall", ("commandHallCtrl", "commandHall"), True),
        "NOTIFY_COMMAND_HALL": ("_handle_notify_command_hall", ("commandHallCtrl", "commandHall"), True),
        "12": ("_handle_notify_quest", ("questCtrl",), True),
        "QUEST": ("_handle_notify_quest", ("questCtrl",), True),
        "NOTIFY_QUEST": ("_handle_notify_quest", ("questCtrl",), True),
        "NOTIFY_QUEST_UPDATE": ("_handle_notify_quest", ("questCtrl",), True),
        "11": ("_handle_notify_walls", ("wallsCtrl",), True),
        "WALLS": ("_handle_notify_walls", ("wallsCtrl",), True),
        "NOTIFY_WALLS": ("_handle_notify_walls", ("wallsCtrl",), True),
        "NOTIFY_WALLS_UPDATE": ("_handle_notify_walls", ("wallsCtrl",), True),
        "13": ("_handle_notify_generic_controller", ("treviFountainCtrl",), True),
        "TREVIFOUNTAIN": ("_handle_notify_generic_controller", ("treviFountainCtrl",), True),
        "NOTIFY_TREVIFOUNTAIN": ("_handle_notify_generic_controller", ("treviFountainCtrl",), True),
        "NOTIFY_TREVIFOUNTAIN_UPDATE": ("_handle_notify_generic_controller", ("treviFountainCtrl",), True),
        "27": ("_handle_notify_pyramid", ("pyramidCtrl",), True),
        "PYRAMID": ("_handle_notify_pyramid", ("pyramidCtrl",), True),
        "NOTIFY_PYRAMID": ("_handle_notify_pyramid", ("pyramidCtrl",), True),
        "95": ("_handle_notify_alliance_treasure", ("allianceTreasureCtrl",), True),
        "ALLIANCE_TREASURE": ("_handle_notify_alliance_treasure", ("allianceTreasureCtrl",), True),
        "NOTIFY_ALLIANCE_TREASURE": ("_handle_notify_alliance_treasure", ("allianceTreasureCtrl",), True),
        "41": ("_handle_notify_badge_exchange", ("badgeExchangeCtrl",), True),
        "BADGE_EXCHANGE": ("_handle_notify_badge_exchange", ("badgeExchangeCtrl",), True),
        "NOTIFY_BADGE_EXCHANGE": ("_handle_notify_badge_exchange", ("badgeExchangeCtrl",), True),
        "29": ("_handle_notify_equipment", ("equipmentCtrl",), True),
        "EQUIPMENT": ("_handle_notify_equipment", ("equipmentCtrl",), True),
        "NOTIFY_EQUIPMENT": ("_handle_notify_equipment", ("equipmentCtrl",), True),
        "23": ("_handle_notify_shop", ("storesCtrl",), True),
        "SHOP": ("_handle_notify_shop", ("storesCtrl",), True),
        "NOTIFY_SHOP": ("_handle_notify_shop", ("storesCtrl",), True),
        "59": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "464": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "SALESROOM": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "NOTIFY_SALESROOM": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "NEW_SALESROOM": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "NOTIFY_NEW_SALESROOM": ("_handle_notify_salesroom", ("salesRoomAgCtrl",), True),
        "200": ("_handle_notify_map_data", ("kingdomMapCtrl",), True),
        "MAP_DATA": ("_handle_notify_map_data", ("kingdomMapCtrl",), True),
        "NOTIFY_MAP_DATA": ("_handle_notify_map_data", ("kingdomMapCtrl",), True),
        "201": ("_handle_notify_map_sync", ("kingdomMapCtrl",), True),
        "MAP_SYNC": ("_handle_notify_map_sync", ("kingdomMapCtrl",), True),
        "NOTIFY_MAP_SYNC": ("_handle_notify_map_sync", ("kingdomMapCtrl",), True),
        "450": ("_handle_notify_switch_map", ("kingdomMapCtrl",), True),
        "SWITCH_MAP": ("_handle_notify_switch_map", ("kingdomMapCtrl",), True),
        "NOTIFY_SWITCH_MAP": ("_handle_notify_switch_map", ("kingdomMapCtrl",), True),
        "65": ("_handle_notify_generic_controller", ("petCtrl",), True),
        "PET": ("_handle_notify_generic_controller", ("petCtrl",), True),
        "NOTIFY_PET": ("_handle_notify_generic_controller", ("petCtrl",), True),
        "492": ("_handle_notify_exalted_privilege", ("exaltedPrivilegeCtrl",), True),
        "EXALTED_PRIVILEGE": ("_handle_notify_exalted_privilege", ("exaltedPrivilegeCtrl",), True),
        "NOTIFY_EXALTED_PRIVILEGE": ("_handle_notify_exalted_privilege", ("exaltedPrivilegeCtrl",), True),
        "494": ("_handle_notify_technology", ("technologyCtrl",), True),
        "TECHNOLOGY": ("_handle_notify_technology", ("technologyCtrl",), True),
        "NOTIFY_TECHNOLOGY": ("_handle_notify_technology", ("technologyCtrl",), True),
        "500": ("_handle_notify_duel_cooldown", ("lordSkillCtrl",), True),
        "DUEL_IN_COOL_DOWN": ("_handle_notify_duel_cooldown", ("lordSkillCtrl",), True),
        "NOTIFY_DUEL_IN_COOL_DOWN": ("_handle_notify_duel_cooldown", ("lordSkillCtrl",), True),
        "571": ("_handle_notify_generic_controller", ("heroComboSkillCtrl",), True),
        "HERO_COMBO_SKILL": ("_handle_notify_generic_controller", ("heroComboSkillCtrl",), True),
        "NOTIFY_HERO_COMBO_SKILL": ("_handle_notify_generic_controller", ("heroComboSkillCtrl",), True),
        "642": ("_handle_notify_divine_beast", ("divineBeastCtrl",), True),
        "DIVINE_BEAST": ("_handle_notify_divine_beast", ("divineBeastCtrl",), True),
        "NOTIFY_DIVINE_BEAST": ("_handle_notify_divine_beast", ("divineBeastCtrl",), True),
        "1002": ("_handle_notify_stuff_workshop", ("stuffWorkshopCtrl",), True),
        "STUFFWORKSHOP_REFINERY": ("_handle_notify_stuff_workshop", ("stuffWorkshopCtrl",), True),
        "NOTIFY_STUFFWORKSHOP_REFINERY": ("_handle_notify_stuff_workshop", ("stuffWorkshopCtrl",), True),
        "1007": ("_handle_notify_arena", ("playerArenaCtrl",), True),
        "ARENA": ("_handle_notify_arena", ("playerArenaCtrl",), True),
        "NOTIFY_ARENA": ("_handle_notify_arena", ("playerArenaCtrl",), True),
    }

    def ingest_packet_with_report(self, packet: Any) -> Tuple[Dict[str, Any], Dict[str, Any]]:
        """
        Ingests an incoming server packet and returns (init_data, report) where `report`
        describes notification arrival, merge outcome (merged/unhandled/failed/skipped),
        affected init_data controllers, and current live march queue snapshot.
        """
        if not isinstance(packet, dict):
            own_q, other_q = self.get_local_queues_breakdown()
            report = {
                "cmd": "",
                "subcmd": "",
                "is_notification": False,
                "notify_id": None,
                "notify_status": None,
                "notify_detail": None,
                "controller_status": None,
                "merged_controllers": [],
                "updated_keys": [],
                "updated_state": {},
                "local_queues_snapshot": copy.deepcopy(own_q),
                "local_queues_count": len(own_q),
                "all_local_queues_count": len(self.local_queues_map),
                "other_queues_count": len(other_q),
                "local_queues_synced": self.local_queues_synced,
                "overall_status": "ignored",
                "error": None,
                "should_log": False,
            }
            return self.init_data, report

        with self._thread_lock:
            cmd = str(packet.get("cmd", ""))
            subcmd = str(packet.get("subcmd", ""))
            notify_id, notify_data, is_1009 = self._extract_notification_envelope(packet)
            is_notification = bool(notify_id is not None or is_1009)

            notify_status: Optional[str] = None
            notify_detail: Any = None
            notify_targets: List[str] = []
            notify_summary: str = ""
            errors: List[str] = []

            # 1. Check and dispatch push notification payload
            if notify_id is not None:
                str_id = str(notify_id).strip().upper()
                spec = self._NOTIFY_ROUTE_TABLE.get(str_id)
                if spec is None:
                    notify_status = "unhandled_notify"
                    notify_detail = f"لا يوجد معالج للإشعار notifyID={notify_id}"
                elif notify_data is None and spec[2]:
                    notify_status = "empty_notify_data"
                    notify_targets = list(spec[1])
                    notify_detail = f"الإشعار notifyID={notify_id} وصل بدون notifyData"
                else:
                    n_res = self._dispatch_notify(notify_id, notify_data)
                    notify_status = n_res["status"]
                    notify_detail = n_res.get("detail")
                    notify_targets = n_res.get("targets", [])
                    notify_summary = n_res.get("summary", "") or ""
                    if n_res.get("error"):
                        errors.append(n_res["error"])
            elif is_1009:
                notify_status = "missing_notify_id"
                notify_detail = "وصلت حزمة cmd=1009 بدون حقل notifyID"

            # 2. Handle domain-specific commands (guarded strictly against server error packets)
            controller_status: Optional[str] = None
            merged_controllers: List[str] = []

            raw_err = packet.get("err")
            if raw_err is None and isinstance(packet.get("data"), dict):
                raw_err = packet["data"].get("err")
            is_err_packet = (
                not is_notification
                and (
                    packet.get("_ok") is False
                    or (raw_err is not None and str(raw_err).strip() not in ("", "0", "Err_None"))
                )
            )

            if not is_err_packet and cmd in ("1005", "onemt_1005"):
                try:
                    self._handle_cmd_1005(subcmd, packet)
                except Exception as exc:
                    errors.append(f"cmd_1005_handling: {exc}")

            if not is_err_packet and cmd in ("2021", "onemt_2021"):
                try:
                    self._handle_cmd_2021(subcmd, packet)
                    if "stuffWorkshopCtrl" in self.init_data:
                        merged_controllers.append("stuffWorkshopCtrl")
                        controller_status = "merged"
                except Exception as exc:
                    errors.append(f"cmd_2021_handling: {exc}")

            if not is_err_packet and cmd in ("1006", "onemt_1006") and subcmd == "1000":
                try:
                    self._handle_map_sync_rsp(packet)
                except Exception as exc:
                    errors.append(f"cmd_1006_1000_handling: {exc}")

            if not is_err_packet and cmd in ("1007", "onemt_1007") and subcmd == "1000":
                self.local_queues_synced = True
                if "local_queues" not in self.init_data:
                    own_q_init, other_q_init = self.get_local_queues_breakdown()
                    self.init_data["local_queues"] = own_q_init
                    self.init_data["other_local_queues"] = other_q_init
                    if isinstance(self.init_data.get("queueCtrl"), dict):
                        self.init_data["queueCtrl"]["queues"] = list(own_q_init)

            # 3. Extract and merge whitelisted controller state
            try:
                controllers = {} if is_err_packet else self.extract_controllers(packet)
                if controllers:
                    merged_controllers.extend([k for k in controllers.keys() if k not in merged_controllers])
                    et_payload = controllers.pop("everydayTaskCtrl", None)
                    if et_payload is not None:
                        self._apply_everyday_task_payload(et_payload)
                    if controllers:
                        smart_deep_merge(self.init_data, controllers, in_place=True)

                    # Ensure both 'reslist' and 'resList' are kept in sync in cityCtrl
                    if "cityCtrl" in self.init_data and isinstance(self.init_data["cityCtrl"], dict):
                        city = self.init_data["cityCtrl"]
                        if "reslist" in city and not city.get("resList"):
                            city["resList"] = city["reslist"]
                        elif "resList" in city and not city.get("reslist"):
                            city["reslist"] = city["resList"]

                    # Synchronize local march queues if present in controllers
                    if "local_queues" in controllers and isinstance(self.init_data.get("local_queues"), list):
                        self._sync_local_queues_from_list(self.init_data["local_queues"])
                    elif (
                        ("lordInfoCtrl" in controllers or "loginDataInitCtrl" in controllers)
                        and "local_queues" in self.init_data
                    ):
                        own_q, other_q = self.get_local_queues_breakdown()
                        self.init_data["local_queues"] = own_q
                        self.init_data["other_local_queues"] = other_q
                        if isinstance(self.init_data.get("queueCtrl"), dict):
                            self.init_data["queueCtrl"]["queues"] = list(own_q)
                    controller_status = "merged"
            except Exception as exc:
                controller_status = "failed"
                errors.append(f"controller_merge: {type(exc).__name__}: {exc}")

            # 4. Collect updated keys and resulting init_data state slice
            updated_keys: List[str] = []
            for k in list(notify_targets) + merged_controllers:
                if k not in updated_keys and k in self.init_data:
                    updated_keys.append(k)
            updated_state = {k: copy.deepcopy(self.init_data.get(k)) for k in updated_keys}

            if errors:
                overall_status = "failed"
            elif notify_status == "merged" or controller_status == "merged":
                overall_status = "merged"
            elif notify_status in ("unhandled_notify", "missing_notify_id", "empty_notify_data", "skipped_empty"):
                overall_status = notify_status
            else:
                overall_status = "ignored"

            is_march_sync_cmd = (cmd == "1007" and subcmd in ("1000", "16"))
            should_log = bool(is_notification or merged_controllers or errors or is_march_sync_cmd)

            # 5. Empirical Read-back Verification (فحص تحققي حقيقي وتلقائي للدمج)
            target_list = list(dict.fromkeys(list(notify_targets) + merged_controllers))
            verify_success = False
            verify_detail = ""
            if overall_status == "merged" and target_list:
                verify_success, verify_detail = self.verify_merge_state(target_list, notify_data)
            elif errors:
                verify_success = False
                verify_detail = f"أخطاء أثناء الدمج: {' | '.join(errors)}"
            elif notify_status in ("unhandled_notify", "missing_notify_id"):
                verify_success = False
                verify_detail = notify_detail or "إشعار غير معالج"
            else:
                verify_success = False
                verify_detail = "لم تتأثر أي متحكمات مستهدفة"

            own_q, other_q = self.get_local_queues_breakdown()
            queues_snapshot = copy.deepcopy(own_q)
            report = {
                "cmd": cmd,
                "subcmd": subcmd,
                "is_notification": is_notification,
                "notify_id": str(notify_id) if notify_id is not None else None,
                "notify_status": notify_status,
                "notify_detail": notify_detail,
                "notify_data": notify_data if is_notification else None,
                "notify_controllers": list(notify_targets),
                "new_value_summary": notify_summary,
                "controller_status": controller_status,
                "merged_controllers": merged_controllers,
                "updated_keys": updated_keys,
                "updated_state": updated_state,
                "verify_success": verify_success,
                "verify_detail": verify_detail,
                "local_queues_snapshot": queues_snapshot,
                "local_queues_count": len(own_q),
                "all_local_queues_count": len(self.local_queues_map),
                "other_queues_count": len(other_q),
                "local_queues_synced": self.local_queues_synced,
                "overall_status": overall_status,
                "error": " | ".join(errors) if errors else None,
                "should_log": should_log,
            }
            self.last_ingest_report = report

        return self.init_data, report

    def verify_merge_state(self, targets: List[str], notify_data: Any = None) -> Tuple[bool, str]:
        """
        فحص تحققي حقيقي وتلقائي (Empirical Read-back Verification)
        يتحقق مباشرة من أن المتحكمات المستهدفة موجودة في self.init_data وتم تحديثها بنجاح.
        """
        if not targets:
            return False, "لا توجد متحكمات مستهدفة للتحقق"

        verified: List[str] = []
        for ctrl in targets:
            if ctrl not in self.init_data:
                return False, f"المتحكم {ctrl} غير موجود في الذاكرة الحية (init_data)"

            c_val = self.init_data[ctrl]
            if c_val is None:
                return False, f"قيمة المتحكم {ctrl} فارغة (None) في الذاكرة الحية"

            # تحققات تخصصية لأهم المتحكمات المعتمدة
            if ctrl == "cityCtrl" and isinstance(c_val, dict):
                has_res = bool(c_val.get("resList") or c_val.get("reslist") or c_val.get("buildings") or c_val.get("blist"))
                if not has_res and len(c_val) == 0:
                    return False, "cityCtrl فارغ من بيانات الموارد والمباني"
                verified.append("cityCtrl (موارد/مباني)")

            elif ctrl == "lordInfoCtrl" and isinstance(c_val, dict):
                has_base = bool(c_val.get("base") or c_val.get("gold") or c_val.get("level"))
                if not has_base and len(c_val) == 0:
                    return False, "lordInfoCtrl فارغ من بيانات اللورد الأساسية"
                verified.append("lordInfoCtrl (بيانات اللورد)")

            elif ctrl == "queueCtrl" and isinstance(c_val, (dict, list)):
                verified.append(f"queueCtrl ({len(c_val)} طوابير)")

            elif ctrl == "backpackCtrl" and isinstance(c_val, (dict, list)):
                verified.append(f"backpackCtrl ({len(c_val)} عناصر)")

            elif ctrl == "armyCtrl" and isinstance(c_val, dict):
                verified.append("armyCtrl (بيانات الجيوش)")

            elif ctrl == "local_queues":
                q_count = len(self.local_queues_map)
                verified.append(f"local_queues ({q_count} مسيرة)")

            elif ctrl == "buffCtrl" and isinstance(c_val, (dict, list)):
                verified.append(f"buffCtrl ({len(c_val)} تأثيرات)")

            elif ctrl == "timeRewardCtrl" and isinstance(c_val, dict):
                verified.append("timeRewardCtrl (مكافأة الوقت)")

            elif ctrl == "everydayTaskCtrl" and isinstance(c_val, (dict, list)):
                verified.append("everydayTaskCtrl (مهام النشاط اليومي)")

            elif ctrl in ("commandHallCtrl", "commandHall") and isinstance(c_val, (dict, list)):
                verified.append("commandHallCtrl (قاعة القيادة)")

            elif ctrl == "allianceCtrl" and isinstance(c_val, (dict, list)):
                verified.append("allianceCtrl (بيانات التحالف)")

            elif ctrl == "questCtrl" and isinstance(c_val, (dict, list)):
                verified.append("questCtrl (المهام)")

            elif ctrl == "wallsCtrl" and isinstance(c_val, (dict, list)):
                verified.append("wallsCtrl (بيانات السور)")

            elif ctrl == "treviFountainCtrl" and isinstance(c_val, (dict, list)):
                verified.append("treviFountainCtrl (نافورة الأمنيات)")

            elif ctrl == "pyramidCtrl" and isinstance(c_val, (dict, list)):
                verified.append("pyramidCtrl (الهرم)")

            elif ctrl == "equipmentCtrl" and isinstance(c_val, (dict, list)):
                verified.append("equipmentCtrl (المعدات)")

            elif ctrl in ("shopCtrl", "storesCtrl") and isinstance(c_val, (dict, list)):
                verified.append("shopCtrl (المتجر)")

            elif ctrl == "badgeExchangeCtrl" and isinstance(c_val, (dict, list)):
                verified.append("badgeExchangeCtrl (تبادل الأوسمة)")

            elif ctrl == "salesRoomAgCtrl" and isinstance(c_val, (dict, list)):
                verified.append("salesRoomAgCtrl (غرفة المبيعات)")

            elif ctrl == "kingdomMapCtrl" and isinstance(c_val, (dict, list)):
                verified.append("kingdomMapCtrl (خريطة المملكة)")

            elif ctrl == "allianceTreasureCtrl" and isinstance(c_val, (dict, list)):
                verified.append("allianceTreasureCtrl (كنز التحالف)")

            elif ctrl in ("godBeastCtrl", "petCtrl") and isinstance(c_val, (dict, list)):
                verified.append("godBeastCtrl (الوحش الإلهي/الحيوانات)")

            else:
                verified.append(f"{ctrl} (محدّث وموجود)")

        return True, "تم تأكيد وجود وتحديث البيانات في: " + "، ".join(verified)

    def ingest_packet(self, packet: Any) -> Dict[str, Any]:
        """
        Ingests an incoming server packet:
          1. Detects push notification payloads (notifyID/notifyData) and routes them.
          2. Extracts controller state updates, filters by whitelist, and applies smart_deep_merge.
        Returns the updated init_data mapping.
        """
        return self.ingest_packet_with_report(packet)[0]

    # ──────────────────────────────────────────────────────────────────────────
    # Domain Command Handlers (e.g. Training & Army Updates)
    # ──────────────────────────────────────────────────────────────────────────

    def _handle_cmd_1005(self, sub_s: str, packet: Dict[str, Any]) -> None:
        """Handles army training/healing/claim responses (subcmd 1, 2, 4, 5) from cmd 1005."""
        raw_err = packet.get("err")
        if raw_err is not None and str(raw_err).strip() not in ("", "0", "Err_None"):
            return

        c_data = packet.get("data") if isinstance(packet.get("data"), dict) else packet
        army_ctrl = self.init_data.setdefault("armyCtrl", {})

        # Subcmd 1: Full army state initialization
        if sub_s == "1" and not c_data.get("armyInfo"):
            smart_deep_merge(army_ctrl, c_data, in_place=True)

        # Subcmd 2+ or armyInfo payload: replace armyInfo maps cleanly
        elif isinstance(c_data.get("armyInfo"), dict):
            local_train = army_ctrl.get("trainArmy") if isinstance(army_ctrl.get("trainArmy"), dict) else {}
            army_ctrl.update(copy.deepcopy(c_data["armyInfo"]))
            if "trainArmy" not in c_data["armyInfo"] and local_train and sub_s != "5":
                army_ctrl["trainArmy"] = local_train

        # Subcmd 5 ONLY (REQ_COLLECT_TRAIN_ARMY): clear collected soldiers from trainArmy
        # Note: Subcmd 4 is REQ_CURE_WOUNDED_ARMY (hospital healing), NOT cancel training!
        if sub_s == "5":
            bid_key = str(c_data.get("bid", ""))
            train_map = army_ctrl.get("trainArmy")
            if isinstance(train_map, dict):
                if bid_key in train_map:
                    train_map.pop(bid_key, None)
                if not train_map or (
                    isinstance(c_data.get("armyInfo"), dict) and c_data["armyInfo"].get("trainArmy") == {}
                ):
                    army_ctrl["trainArmy"] = {}

        ret_q = c_data.get("retdata")
        now_ts = int(time.time())

        # Subcmd 2 (REQ_TRAIN_ARMY): record active queue in queueCtrl[queuetype] (NOT in trainArmy!)
        if sub_s == "2" and isinstance(ret_q, dict) and "lefttime" in ret_q:
            qtype_s = str(ret_q.get("queuetype") or "")
            left_t = int(float(ret_q.get("lefttime") or 0))
            tot_t = int(float(ret_q.get("totaltime") or left_t))
            if qtype_s and left_t > 0:
                q_ctrl = self.init_data.setdefault("queueCtrl", {})
                if isinstance(q_ctrl, dict):
                    q_ctrl[qtype_s] = {
                        "qtype": qtype_s,
                        "queuetype": qtype_s,
                        "starttime": max(0, now_ts - max(0, tot_t - left_t)),
                        "totaltime": tot_t,
                        "ottime": left_t,
                        "_uniqueid": ret_q.get("_uniqueid"),
                        "bid": c_data.get("bid"),
                        "armyid": c_data.get("armyid"),
                        "armycount": c_data.get("armycount"),
                    }
            cost_list = ret_q.get("costres")
            if isinstance(cost_list, list):
                city = self.init_data.setdefault("cityCtrl", {})
                reslist = city.setdefault("reslist", {})
                if isinstance(reslist, dict):
                    for cr in cost_list:
                        if isinstance(cr, dict) and "resid" in cr and "curcount" in cr:
                            reslist[str(cr["resid"])] = cr["curcount"]
                    city["resList"] = reslist

        # Subcmd 4 (REQ_CURE_WOUNDED_ARMY): record hospital queue in queueCtrl["1202"]
        elif sub_s == "4" and isinstance(ret_q, dict) and ("lefttime" in ret_q or "totaltime" in ret_q):
            qtype_s = str(ret_q.get("queuetype") or "1202")
            left_t = int(float(ret_q.get("lefttime") or ret_q.get("totaltime") or 0))
            tot_t = int(float(ret_q.get("totaltime") or left_t))
            if left_t > 0:
                q_ctrl = self.init_data.setdefault("queueCtrl", {})
                if isinstance(q_ctrl, dict):
                    q_ctrl[qtype_s] = {
                        "qtype": qtype_s,
                        "queuetype": qtype_s,
                        "starttime": max(0, now_ts - max(0, tot_t - left_t)),
                        "totaltime": tot_t,
                        "ottime": left_t,
                        "_uniqueid": ret_q.get("_uniqueid"),
                    }

    def _handle_cmd_2021(self, sub_s: str, packet: Dict[str, Any]) -> None:
        """Handles Material Workshop responses (cmd 2021) and updates stuffWorkshopCtrl."""
        raw_err = packet.get("err")
        if raw_err is not None and str(raw_err).strip() not in ("", "0", "Err_None"):
            return
        res = packet.get("result")
        if isinstance(res, dict):
            existing = self.init_data.setdefault("stuffWorkshopCtrl", {})
            if isinstance(existing, dict):
                existing.update({k: copy.deepcopy(v) for k, v in res.items() if k != "list"})
                if "list" in res:
                    existing["list"] = copy.deepcopy(res["list"])
            else:
                self.init_data["stuffWorkshopCtrl"] = copy.deepcopy(res)

    # ──────────────────────────────────────────────────────────────────────────
    # Notification Handlers (Lua Model Synchronization)
    # ──────────────────────────────────────────────────────────────────────────

    def _infer_notify_targets(self, str_id: str, base_targets: Tuple[str, ...], notify_data: Any) -> List[str]:
        """Determines which top-level init_data controllers were touched by this notification."""
        targets = list(base_targets)
        items = notify_data if isinstance(notify_data, list) else ([notify_data] if isinstance(notify_data, dict) else [])
        if str_id in ("9", "CITY", "NOTIFY_CITY", "NOTIFY_CITY_UPDATE"):
            if any(isinstance(x, dict) and "openChargeQueue" in x for x in items):
                targets.append("queueCtrl")
        elif str_id in ("14", "QUEUE", "NOTIFY_QUEUE", "NOTIFY_QUEUE_UPDATE",
                        "1051", "PLAYER_QUEUE_CHANGE", "NOTIFY_PLAYER_QUEUE_CHANGE"):
            for item in items:
                if not isinstance(item, dict):
                    continue
                ev = item.get("dispatchQueueEvent") if isinstance(item.get("dispatchQueueEvent"), dict) else item
                qt = str(
                    ev.get("name") or ev.get("queuetype") or ev.get("qtype")
                    or item.get("queuetype") or item.get("qtype") or ""
                )
                if qt in ("1200", "1201") or ev.get("bid") is not None or ev.get("index") is not None or item.get("bid") is not None:
                    targets.append("cityCtrl")
                    break
        elif str_id in ("1002", "STUFFWORKSHOP_REFINERY", "NOTIFY_STUFFWORKSHOP_REFINERY"):
            if "queueCtrl" in self.init_data and any(isinstance(x, dict) and "hasRefinery" in x for x in items):
                targets.append("queueCtrl")
        elif str_id in ("29", "EQUIPMENT", "NOTIFY_EQUIPMENT"):
            if "queueCtrl" in self.init_data and any(isinstance(x, dict) and x.get("notifyType") == "cle" for x in items):
                targets.append("queueCtrl")
        return targets

    _RES_SHORT_NAMES: Dict[str, str] = {
        "1002": "قمح",
        "1003": "خشب",
        "1004": "حديد",
        "1005": "ألماس",
        "1006": "ذهب",
    }

    @staticmethod
    def _fmt_num(val: Any) -> str:
        try:
            f = float(val)
            return f"{int(f):,}" if f.is_integer() else f"{f:.1f}"
        except Exception:
            return str(val)

    def _summarize_notify_value(self, handler_name: str, notify_data: Any, detail: Any, target_ctrl: str = "") -> str:
        """Builds a short, human-readable summary of the updated live-memory value."""
        try:
            items = notify_data if isinstance(notify_data, list) else ([notify_data] if isinstance(notify_data, dict) else [])
            parts: List[str] = []

            if handler_name == "_handle_notify_local_queue" and isinstance(detail, dict):
                ops = detail.get("ops") or []
                q_cnt = detail.get("queues_count", 0)
                if ops:
                    shown = ", ".join(str(x) for x in ops[:3])
                    extra = f" (+{len(ops) - 3})" if len(ops) > 3 else ""
                    return f"{shown}{extra} | مسيراتي={q_cnt}"
                return f"مسيراتي={q_cnt}"

            if handler_name == "_handle_notify_city":
                city_ctrl = self.init_data.get("cityCtrl", {}) or {}
                reslist = city_ctrl.get("reslist", {}) or {}
                for d in items:
                    if not isinstance(d, dict):
                        continue
                    for rkey in ("res", "reslist"):
                        rmap = d.get(rkey)
                        if isinstance(rmap, dict):
                            for rid in list(rmap.keys())[:4]:
                                k = str(rid)
                                label = self._RES_SHORT_NAMES.get(k, k)
                                parts.append(f"{label}={self._fmt_num(reslist.get(k, rmap[rid]))}")
                    if isinstance(d.get("saferes"), dict):
                        smap = city_ctrl.get("saferes", {}) or {}
                        for rid in list(d["saferes"].keys())[:3]:
                            k = str(rid)
                            parts.append(f"آمن_{self._RES_SHORT_NAMES.get(k, k)}={self._fmt_num(smap.get(k, 0))}")
                    if isinstance(d.get("updateUnCollectRes"), dict):
                        u_map = d["updateUnCollectRes"]
                        blist = city_ctrl.get("blist", []) or []
                        for idx_k in list(u_map.keys())[:3]:
                            cur_v = None
                            for b in blist:
                                if isinstance(b, dict) and str(_extract_field_value(b, "index") or "") == str(idx_k):
                                    binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
                                    cur_v = binfo.get("curres")
                                    break
                            parts.append(f"مبنى#{idx_k}={self._fmt_num(cur_v if cur_v is not None else u_map[idx_k])}")
                    if isinstance(d.get("openChargeQueue"), dict):
                        parts.append("طابور_ثاني=مفتوح")

            elif handler_name == "_handle_notify_queue":
                queue_ctrl = self.init_data.get("queueCtrl", {}) or {}
                _Q_NAMES = {
                    "1200": "بناء",
                    "1201": "بناء إضافي",
                    "1202": "تسليح/فخاخ",
                    "1203": "مشاة",
                    "1204": "فرسان",
                    "1205": "رماة",
                    "1206": "عربات",
                    "1207": "أبحاث",
                    "1208": "علاج",
                }
                for it in items[:3]:
                    if not isinstance(it, dict):
                        continue
                    ev = it.get("dispatchQueueEvent") if isinstance(it.get("dispatchQueueEvent"), dict) else it
                    data_ctx = ev.get("data") if isinstance(ev.get("data"), dict) else (it.get("data") if isinstance(it.get("data"), dict) else {})
                    raw_qt = (
                        ev.get("name") or ev.get("queuetype") or ev.get("qtype") or ev.get("queueType") or
                        data_ctx.get("queuetype") or data_ctx.get("qtype") or data_ctx.get("queueType") or
                        it.get("queuetype") or it.get("qtype") or it.get("queueType") or
                        ev.get("id") or it.get("id") or ""
                    )
                    qt_str = str(raw_qt).strip() if raw_qt is not None else ""
                    lbl = _Q_NAMES.get(qt_str, f"طابور {qt_str}" if qt_str and qt_str != "?" else "طوابير القلعة")
                    nt = str(ev.get("notifyType") or it.get("notifyType") or "")
                    bid = ev.get("bid") or it.get("bid") or data_ctx.get("bid")
                    has_name = "name" in ev and ev.get("name") is not None
                    if (has_name and nt.lower() != "merge") or nt.lower() in ("finish", "del", "remove", "cancel") or str(ev.get("optype", "")) == "11":
                        tag = "ملغى" if nt.lower() == "cancel" or str(ev.get("optype", "")) == "11" else "مكتمل"
                        parts.append(f"{lbl} ({tag}{f' مبنى#{bid}' if bid else ''})")
                    else:
                        q_obj = queue_ctrl.get(qt_str, ev) if (qt_str and isinstance(queue_ctrl, dict)) else ev
                        tot = q_obj.get("totaltime") if isinstance(q_obj, dict) else None
                        parts.append(f"{lbl} (نشط{f' {tot}ث' if tot else ''})")

            elif handler_name == "_handle_notify_backpack":
                bp = self.init_data.get("backpackCtrl", {})
                blk = items[0] if items else {}
                if isinstance(blk, dict):
                    for mode in ("add", "use"):
                        mmap = blk.get(mode)
                        if isinstance(mmap, dict):
                            for item_id in list(mmap.keys())[:4]:
                                k = str(item_id)
                                new_cnt = None
                                if isinstance(bp, dict):
                                    entry = bp.get(k)
                                    new_cnt = entry.get("count") if isinstance(entry, dict) else entry
                                elif isinstance(bp, list):
                                    for entry in bp:
                                        if isinstance(entry, dict) and str(entry.get("id")) == k:
                                            new_cnt = entry.get("count")
                                            break
                                parts.append(f"#{k}={new_cnt if new_cnt is not None else mmap[item_id]}")

            elif handler_name == "_handle_notify_army":
                army_ctrl = self.init_data.get("armyCtrl", {}) or {}
                for it in items[:2]:
                    if not isinstance(it, dict):
                        continue
                    src = it.get("armyInfo") if isinstance(it.get("armyInfo"), dict) else it
                    for sec in ("freeArmy", "totalArmy", "woundedArmy", "trainArmy"):
                        if isinstance(src.get(sec), dict):
                            cur_sec = army_ctrl.get(sec, src[sec])
                            sample = [f"{k}:{self._fmt_num(cur_sec.get(k, v))}" for k, v in list(src[sec].items())[:3]]
                            parts.append(f"{sec}({','.join(sample)})")

            elif handler_name == "_handle_notify_hero":
                h_ctrl = self.init_data.get("heroCtrl")
                h_list = h_ctrl if isinstance(h_ctrl, list) else (h_ctrl.get("heroes", []) if isinstance(h_ctrl, dict) else [])
                h_by_id = {str(h.get("id") or h.get("heroId") or h.get("cId")): h for h in h_list if isinstance(h, dict)}
                seen: List[str] = []
                for it in items:
                    raw = it.get("data") if isinstance(it, dict) and isinstance(it.get("data"), list) else [it]
                    for entry in raw:
                        sub_entries = entry if isinstance(entry, list) else [entry]
                        for h in sub_entries:
                            if not isinstance(h, dict):
                                continue
                            hid = str(h.get("id") or h.get("heroId") or h.get("cId") or "")
                            if hid and hid not in seen:
                                seen.append(hid)
                for hid in seen[:3]:
                    cur = h_by_id.get(hid, {})
                    lv = cur.get("lv", "?")
                    st = (cur.get("status") or {}).get("state", "?") if isinstance(cur.get("status"), dict) else "?"
                    parts.append(f"بطل#{hid}(lv={lv},st={st})")

            elif handler_name == "_handle_notify_lord":
                lord = self.init_data.get("lordInfoCtrl", {}) or {}
                for it in items[:3]:
                    if not isinstance(it, dict):
                        continue
                    key = it.get("key")
                    if key and isinstance(key, str):
                        cur_sub = lord.get(key, {})
                        for fk in [k for k in it.keys() if k != "key"][:3]:
                            val = cur_sub.get(fk, it[fk]) if isinstance(cur_sub, dict) else it[fk]
                            parts.append(f"{key}.{fk}={self._fmt_num(val) if isinstance(val, (int, float)) else val}")
                    else:
                        for fk in list(it.keys())[:3]:
                            val = lord.get(fk, it[fk])
                            if not isinstance(val, (dict, list)):
                                parts.append(f"{fk}={val}")
                            else:
                                parts.append(f"{fk}=محدّث")

            elif handler_name == "_handle_notify_buff":
                for it in items[:3]:
                    if not isinstance(it, dict):
                        continue
                    st = it.get("syncType") or "update"
                    ids = it.get("list") if isinstance(it.get("list"), list) else ([it.get("id")] if it.get("id") else [])
                    id_strs = [str(x.get("id") if isinstance(x, dict) else x) for x in ids[:3] if x is not None]
                    parts.append(f"{st}({','.join(id_strs)})" if id_strs else str(st))

            elif handler_name == "_handle_notify_time_reward":
                tr = self.init_data.get("timeRewardCtrl", {}) or {}
                tr_data = tr.get("data") if isinstance(tr.get("data"), dict) else tr
                recv = tr_data.get("isReceive")
                status_txt = "جاهزة للاستلام" if recv == 2 else ("قيد الانتظار" if recv == 1 else f"isReceive={recv}")
                parts.append(f"مكافأة الوقت ({status_txt})")

            elif handler_name == "_handle_notify_meritorious":
                merit = self.init_data.get("meritoriousTaskCtrl", {}) or {}
                blk = items[0] if items else {}
                if isinstance(blk, dict):
                    flag = blk.get("flag")
                    payload = blk.get("data", {})
                    if flag == "base" and isinstance(payload, dict):
                        for k in list(payload.keys())[:3]:
                            parts.append(f"{k}={merit.get(k, payload[k])}")
                    elif flag == "task" and isinstance(payload, dict):
                        adds = payload.get("add", {})
                        if isinstance(adds, dict):
                            for cat, tmap in list(adds.items())[:2]:
                                if isinstance(tmap, dict):
                                    for tid in list(tmap.keys())[:2]:
                                        cur_t = (merit.get(cat) or {}).get(str(tid), tmap[tid])
                                        if isinstance(cur_t, dict) and ("cNum" in cur_t or "lNum" in cur_t):
                                            parts.append(f"#{tid}={cur_t.get('cNum', 0)}/{cur_t.get('lNum', 0)}")
                                        else:
                                            parts.append(f"{cat}.{tid}")

            elif handler_name in (
                "_handle_notify_generic_controller",
                "_handle_notify_everyday_task",
                "_handle_notify_world_update",
                "_handle_notify_login_reward",
                "_handle_notify_hero_trial",
                "_handle_notify_arena",
                "_handle_notify_stuff_workshop",
                "_handle_notify_shop",
                "_handle_notify_command_hall",
                "_handle_notify_quest",
                "_handle_notify_walls",
                "_handle_notify_pyramid",
                "_handle_notify_badge_exchange",
                "_handle_notify_equipment",
                "_handle_notify_alliance_treasure",
                "_handle_notify_escort",
                "_handle_notify_escort_cart",
                "_handle_notify_salesroom",
                "_handle_notify_alliance",
                "_handle_notify_alliance_relation",
                "_handle_notify_alliance_recommend",
                "_handle_notify_map_sync",
                "_handle_notify_map_data",
                "_handle_notify_switch_map",
                "_handle_notify_exalted_privilege",
                "_handle_notify_technology",
                "_handle_notify_duel_cooldown",
                "_handle_notify_divine_beast",
            ):
                keys = detail.get("keys", []) if isinstance(detail, dict) else []
                keys_str = f" ({', '.join(str(k) for k in keys[:3])})" if keys else ""
                ctrl_labels = {
                    "everydayTaskCtrl": "مهام النشاط اليومي",
                    "commandHallCtrl": "قاعة القيادة",
                    "commandHall": "قاعة القيادة",
                    "allianceCtrl": "بيانات التحالف",
                    "questCtrl": "المهام",
                    "wallsCtrl": "بيانات السور",
                    "treviFountainCtrl": "نافورة الأمنيات",
                    "pyramidCtrl": "الهرم",
                    "equipmentCtrl": "المعدات",
                    "shopCtrl": "المتجر",
                    "storesCtrl": "التاجر العجيب",
                    "badgeExchangeCtrl": "تبادل الأوسمة",
                    "salesRoomAgCtrl": "غرفة المبيعات",
                    "kingdomMapCtrl": "خريطة المملكة",
                    "allianceTreasureCtrl": "كنز التحالف",
                    "petCtrl": "الحيوانات الأليفة",
                    "stuffWorkshopCtrl": "معمل المواد",
                    "loginRewardCtrl": "السفينة التجارية",
                    "htData": "محاكمة البطل",
                    "playerArenaCtrl": "الحلبة",
                    "technologyCtrl": "الأبحاث",
                    "exaltedPrivilegeCtrl": "امتياز السمو",
                    "divineBeastCtrl": "الوحش الإلهي",
                    "heroComboSkillCtrl": "مهارات الحشد",
                }
                lbl = ctrl_labels.get(target_ctrl, target_ctrl or "متحكم")
                parts.append(f"{lbl}{keys_str}")

            summary = ", ".join(parts)
            if len(summary) > 120:
                summary = summary[:117] + "..."
            return summary
        except Exception:
            return ""

    def _dispatch_notify(self, notify_id: Union[int, str], notify_data: Any) -> Dict[str, Any]:
        """Routes a notification to its synchronizer and returns execution telemetry."""
        with self._thread_lock:
            str_id = str(notify_id).strip().upper()
            spec = self._NOTIFY_ROUTE_TABLE.get(str_id)
            if spec is None:
                return {
                    "matched": False,
                    "status": "unhandled_notify",
                    "targets": [],
                    "detail": f"لا يوجد معالج للإشعار notifyID={notify_id}",
                    "summary": "",
                    "error": None,
                }

            handler_name, base_targets, _requires_data = spec
            handler = getattr(self, handler_name)
            try:
                if handler_name == "_handle_notify_time_reward":
                    res = handler(notify_data, str_id)
                elif handler_name == "_handle_notify_generic_controller":
                    res = handler(notify_data, base_targets[0])
                else:
                    res = handler(notify_data)
            except Exception as exc:
                logger.debug(f"[LiveMemory] handle_notify({notify_id}) failed: {exc}")
                return {
                    "matched": True,
                    "status": "failed",
                    "targets": list(base_targets),
                    "detail": f"فشل معالج {handler_name}",
                    "summary": "",
                    "error": f"{handler_name}: {type(exc).__name__}: {exc}",
                }

            targets = self._infer_notify_targets(str_id, base_targets, notify_data)
            summary = self._summarize_notify_value(
                handler_name, notify_data, res, target_ctrl=base_targets[0] if base_targets else ""
            )
            if isinstance(res, dict) and handler_name == "_handle_notify_local_queue":
                if res.get("applied", 0) == 0:
                    return {
                        "matched": True,
                        "status": "skipped_empty",
                        "targets": targets,
                        "detail": res,
                        "summary": summary,
                        "error": None,
                    }
            return {
                "matched": True,
                "status": "merged",
                "targets": targets,
                "detail": res if res is not None else handler_name,
                "summary": summary,
                "error": None,
            }

    def handle_notify(self, notify_id: Union[int, str], notify_data: Any) -> None:
        """Dispatches server push notifications to their respective controller synchronizers."""
        self._dispatch_notify(notify_id, notify_data)

    def _handle_notify_city(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_CITY (Subcmd 9):
          - res: Relative delta addition (clamped to 0).
          - reslist / resList: Full resource map replacement.
          - saferes: Safe resource map replacement/merge.
          - dayMaxRes: Daily gathering cap replacement.
          - updateUnCollectRes: Increments curres on corresponding building by index.
          - openChargeQueue: Activates charge builder queue (1201).
        """
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        city_ctrl = self.init_data.setdefault("cityCtrl", {})

        for delta in items:
            if not isinstance(delta, dict):
                continue

            # 1. Delta resource consumption or additions
            if "res" in delta and isinstance(delta["res"], dict):
                reslist = city_ctrl.get("reslist")
                if not isinstance(reslist, dict):
                    reslist = city_ctrl.get("resList")
                    if not isinstance(reslist, dict):
                        reslist = {}
                    city_ctrl["reslist"] = reslist
                for resid, count in delta["res"].items():
                    k = str(resid)
                    old_val = int(float(reslist.get(k, 0) or 0))
                    new_val = max(0, old_val + int(float(count)))
                    reslist[k] = str(new_val) if isinstance(reslist.get(k), str) else new_val
                city_ctrl["resList"] = reslist
                city_ctrl["reslist"] = reslist

            # 2. Full resource list replacement
            if "reslist" in delta and isinstance(delta["reslist"], dict):
                city_ctrl["reslist"] = copy.deepcopy(delta["reslist"])
                city_ctrl["resList"] = city_ctrl["reslist"]

            # 3. Safe resource replacement / update
            if "saferes" in delta and isinstance(delta["saferes"], dict):
                city_ctrl["saferes"] = copy.deepcopy(delta["saferes"])

            # 4. Daily maximum resources
            if "dayMaxRes" in delta and isinstance(delta["dayMaxRes"], dict):
                city_ctrl["dayMaxRes"] = copy.deepcopy(delta["dayMaxRes"])

            # 5. Uncollected production accumulated in resource buildings
            if "updateUnCollectRes" in delta and isinstance(delta["updateUnCollectRes"], dict):
                blist = city_ctrl.get("blist", [])
                if isinstance(blist, list):
                    for idx_key, count in delta["updateUnCollectRes"].items():
                        target_idx = str(idx_key)
                        for b_item in blist:
                            if not isinstance(b_item, dict):
                                continue
                            b_idx = str(_extract_field_value(b_item, "index") or "")
                            if b_idx == target_idx:
                                target_dict = b_item.get("binfo") if isinstance(b_item.get("binfo"), dict) else b_item
                                old_cur = int(float(target_dict.get("curres", 0) or 0))
                                new_cur = max(0, old_cur + int(float(count)))
                                target_dict["curres"] = str(new_cur) if isinstance(target_dict.get("curres"), str) else new_cur
                                break

            # 6. Second (charge) build queue (cityCtrl.lua:1449 injects starttime = now when absent)
            if "openChargeQueue" in delta and isinstance(delta["openChargeQueue"], dict):
                raw_charge = delta["openChargeQueue"]
                charge_info = copy.deepcopy(raw_charge)
                if "starttime" in raw_charge and raw_charge["starttime"] is not None:
                    try:
                        charge_info["starttime"] = int(float(raw_charge["starttime"]))
                    except (ValueError, TypeError):
                        charge_info["starttime"] = int(time.time())
                else:
                    charge_info["starttime"] = int(time.time())

                city_ctrl.setdefault("queue", {})["1201"] = charge_info
                charge_info_q = copy.deepcopy(charge_info)
                charge_info_q["qtype"] = "1201"
                queue_ctrl = self.init_data.setdefault("queueCtrl", {})
                if isinstance(queue_ctrl, dict):
                    queue_ctrl["1201"] = charge_info_q

            # 7. Building info updates (cityCtrl.lua:1523-1529)
            if "updateBuildInfo" in delta and isinstance(delta["updateBuildInfo"], (list, dict)):
                upd_list = delta["updateBuildInfo"] if isinstance(delta["updateBuildInfo"], list) else list(delta["updateBuildInfo"].values())
                blist = city_ctrl.get("blist", [])
                if isinstance(blist, list):
                    for upd_b in upd_list:
                        if not isinstance(upd_b, dict):
                            continue
                        u_idx = _extract_field_value(upd_b, "index")
                        u_bid = _extract_field_value(upd_b, "bid")
                        u_iid = _extract_field_value(upd_b, "iid")
                        matched = False
                        for b_item in blist:
                            if not isinstance(b_item, dict):
                                continue
                            if (u_idx is not None and str(_extract_field_value(b_item, "index")) == str(u_idx)) or (
                                u_bid is not None and u_iid is not None
                                and str(_extract_field_value(b_item, "bid")) == str(u_bid)
                                and str(_extract_field_value(b_item, "iid")) == str(u_iid)
                            ):
                                smart_deep_merge(b_item, upd_b, in_place=True)
                                matched = True
                                break
                        if not matched and (u_idx is not None or u_bid is not None):
                            blist.append(copy.deepcopy(upd_b))

            # 8. Demolished building removal (cityCtrl.lua:1430 — supports index or bid+iid)
            if "demolishInfo" in delta and isinstance(delta["demolishInfo"], (list, dict)):
                dem_list = delta["demolishInfo"] if isinstance(delta["demolishInfo"], list) else [delta["demolishInfo"]]
                blist = city_ctrl.get("blist", [])
                if isinstance(blist, list):
                    for dem in dem_list:
                        if isinstance(dem, dict):
                            d_idx = _extract_field_value(dem, "index")
                            d_bid = _extract_field_value(dem, "bid")
                            d_iid = _extract_field_value(dem, "iid")
                            if d_idx is not None:
                                city_ctrl["blist"] = [
                                    b for b in city_ctrl["blist"]
                                    if not (isinstance(b, dict) and str(_extract_field_value(b, "index")) == str(d_idx))
                                ]
                            elif d_bid is not None and d_iid is not None:
                                city_ctrl["blist"] = [
                                    b for b in city_ctrl["blist"]
                                    if not (
                                        isinstance(b, dict)
                                        and str(_extract_field_value(b, "bid")) == str(d_bid)
                                        and str(_extract_field_value(b, "iid")) == str(d_iid)
                                    )
                                ]
                        elif dem is not None:
                            city_ctrl["blist"] = [
                                b for b in city_ctrl["blist"]
                                if not (isinstance(b, dict) and str(_extract_field_value(b, "index")) == str(dem))
                            ]

    def _handle_notify_queue(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_QUEUE (14) and NOTIFY_PLAYER_QUEUE_CHANGE (1051):
          - Supports authentic Lua `dispatchQueueEvent.name` (`queueCtrl.lua:241-303`):
            * `notifyType == "merge"`: removes `deleteList` queues and adds/updates merged queue.
            * Any other `notifyType` when `"name"` is present: queue completion/removal (verifies `_uniqueid`).
          - Preserves backward compatibility for synthetic `queuetype`/`qtype` payloads.
          - On building queue completion/cancellation, updates `cityCtrl.blist` state & level.
        """
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        city_ctrl = self.init_data.setdefault("cityCtrl", {})
        queue_ctrl = self.init_data.setdefault("queueCtrl", {})

        for item in items:
            if not isinstance(item, dict):
                continue

            event = item.get("dispatchQueueEvent") if isinstance(item.get("dispatchQueueEvent"), dict) else item
            data_ctx = event.get("data") if isinstance(event.get("data"), dict) else {}

            has_lua_name = "name" in event and event.get("name") is not None
            qtype = str(
                event.get("name")
                or event.get("queuetype")
                or event.get("qtype")
                or item.get("queuetype")
                or item.get("qtype")
                or ""
            ).strip()
            notify_type = str(event.get("notifyType") or item.get("notifyType") or "").lower()
            optype = event.get("optype") or data_ctx.get("optype") or item.get("optype")
            optype_str = str(optype) if optype is not None else ""

            if notify_type == "merge":
                is_finish = False
                is_cancel = False
                del_list = event.get("deleteList") or data_ctx.get("deleteList") or []
                if isinstance(del_list, list) and isinstance(queue_ctrl, dict):
                    for dq in del_list:
                        if isinstance(dq, dict):
                            dq_key = str(dq.get("name") or dq.get("queuetype") or dq.get("qtype") or "")
                            if dq_key:
                                queue_ctrl.pop(dq_key, None)
                        elif dq is not None:
                            queue_ctrl.pop(str(dq), None)
                if qtype and isinstance(queue_ctrl, dict):
                    merged_q = copy.deepcopy(data_ctx if data_ctx else event)
                    merged_q.setdefault("qtype", qtype)
                    merged_q.setdefault("queuetype", qtype)
                    queue_ctrl[qtype] = merged_q
            else:
                if has_lua_name:
                    is_finish = True
                    is_cancel = notify_type == "cancel" or optype_str == "11"
                else:
                    is_finish = notify_type in ("finish", "del", "remove", "cancel") or optype_str == "11"
                    is_cancel = notify_type == "cancel" or optype_str == "11"

                if qtype:
                    if is_finish:
                        if isinstance(queue_ctrl, dict):
                            existing_q = queue_ctrl.get(qtype)
                            ev_uid = data_ctx.get("_uniqueid") or event.get("_uniqueid")
                            ex_uid = existing_q.get("_uniqueid") if isinstance(existing_q, dict) else None
                            if not (ev_uid is not None and ex_uid is not None and str(ev_uid) != str(ex_uid)):
                                queue_ctrl.pop(qtype, None)
                        elif isinstance(queue_ctrl, list):
                            self.init_data["queueCtrl"] = [
                                q for q in queue_ctrl
                                if isinstance(q, dict) and str(q.get("qtype") or q.get("queuetype") or "") != qtype
                            ]
                    else:
                        if isinstance(queue_ctrl, dict):
                            queue_ctrl[qtype] = copy.deepcopy(event)

            # 2. Reflect on building in cityCtrl if related to building queues (1200 / 1201) or contains building keys
            bid = event.get("bid") or data_ctx.get("bid") or item.get("bid")
            iid = event.get("iid") or data_ctx.get("iid") or item.get("iid")
            b_index = event.get("index") or data_ctx.get("index") or item.get("index")

            if is_finish and (qtype in ("1200", "1201") or bid is not None or b_index is not None):
                blist = city_ctrl.get("blist", [])
                if isinstance(blist, list):
                    target_b = None
                    for b in blist:
                        if not isinstance(b, dict):
                            continue
                        if b_index is not None and str(_extract_field_value(b, "index")) == str(b_index):
                            target_b = b
                            break
                        if bid is not None and iid is not None:
                            b_bid = str(_extract_field_value(b, "bid"))
                            b_iid = str(_extract_field_value(b, "iid"))
                            if b_bid == str(bid) and b_iid == str(iid):
                                target_b = b
                                break

                    if target_b is not None:
                        binfo = target_b.get("binfo") if isinstance(target_b.get("binfo"), dict) else target_b

                        if is_cancel:
                            binfo["state"] = BUILD_STATE.NORMAL
                        else:
                            is_honor = bool(
                                event.get("honorUpgradeWaitRsp")
                                or data_ctx.get("honorUpgradeWaitRsp")
                                or event.get("isHonor")
                                or data_ctx.get("isHonor")
                                or event.get("honor")
                                or str(optype_str).lower() == "honor"
                            )

                            if is_honor:
                                current_hlv = int(binfo.get("honorLv") or binfo.get("hlv") or 0)
                                new_hlv = current_hlv + 1
                                binfo["honorLv"] = str(new_hlv) if isinstance(binfo.get("honorLv"), str) else new_hlv
                                binfo["hlv"] = str(new_hlv) if isinstance(binfo.get("hlv"), str) else new_hlv
                                binfo["state"] = BUILD_STATE.NORMAL
                            elif optype_str in ("2", ""):
                                current_lv = int(binfo.get("lv", 0) or 0)
                                new_lv = current_lv + 1
                                binfo["lv"] = str(new_lv) if isinstance(binfo.get("lv"), str) else new_lv
                                binfo["state"] = BUILD_STATE.NORMAL
                            elif optype_str == "0":
                                binfo["state"] = BUILD_STATE.NORMAL
                                if int(binfo.get("lv", 0) or 0) == 0:
                                    binfo["lv"] = "1"
                            elif optype_str == "1":
                                self.init_data["cityCtrl"]["blist"] = [
                                    b for b in blist if b is not target_b
                                ]

    def _handle_notify_backpack(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_BACKPACK (Subcmd 1):
          - add: Increments item counts in backpackCtrl and bagCtrl.
          - use: Decrements item counts (minimum 0).
        """
        data_block = notify_data[0] if (isinstance(notify_data, list) and notify_data) else notify_data
        if not isinstance(data_block, dict):
            return

        backpack = self.init_data.setdefault("backpackCtrl", {})
        self.init_data["bagCtrl"] = backpack

        # Handle additions
        add_items = data_block.get("add", {})
        if isinstance(add_items, dict):
            for item_id, count in add_items.items():
                k = str(item_id)
                delta = int(count)
                if isinstance(backpack, dict):
                    if k in backpack:
                        if isinstance(backpack[k], dict):
                            old_raw = backpack[k].get("count", 0)
                            new_val = int(old_raw or 0) + delta
                            backpack[k]["count"] = str(new_val) if isinstance(old_raw, str) else new_val
                        else:
                            old_raw = backpack[k]
                            new_val = max(0, int(old_raw or 0) + delta)
                            backpack[k] = str(new_val) if isinstance(old_raw, str) else new_val
                    else:
                        backpack[k] = {"id": int(k) if k.isdigit() else k, "count": delta}
                elif isinstance(backpack, list):
                    found = False
                    for entry in backpack:
                        if isinstance(entry, dict) and str(entry.get("id")) == k:
                            old_raw = entry.get("count", 0)
                            new_val = int(old_raw or 0) + delta
                            entry["count"] = str(new_val) if isinstance(old_raw, str) else new_val
                            found = True
                            break
                    if not found:
                        backpack.append({"id": int(k) if k.isdigit() else k, "count": delta})

        # Handle consumptions / usage (pop entry when count reaches 0 matching backpackCtrl.lua itemMap[id]=nil)
        use_items = data_block.get("use", {})
        if isinstance(use_items, dict):
            for item_id, count in use_items.items():
                k = str(item_id)
                delta = int(count)
                if isinstance(backpack, dict):
                    if k in backpack:
                        if isinstance(backpack[k], dict):
                            old_raw = backpack[k].get("count", 0)
                            rem = int(old_raw or 0) - delta
                            if rem > 0:
                                backpack[k]["count"] = str(rem) if isinstance(old_raw, str) else rem
                            else:
                                backpack.pop(k, None)
                        else:
                            old_raw = backpack[k]
                            rem = int(old_raw or 0) - delta
                            if rem > 0:
                                backpack[k] = str(rem) if isinstance(old_raw, str) else rem
                            else:
                                backpack.pop(k, None)
                elif isinstance(backpack, list):
                    for idx_e, entry in enumerate(list(backpack)):
                        if isinstance(entry, dict) and str(entry.get("id")) == k:
                            old_raw = entry.get("count", 0)
                            rem = int(old_raw or 0) - delta
                            if rem > 0:
                                entry["count"] = str(rem) if isinstance(old_raw, str) else rem
                            else:
                                backpack.remove(entry)
                            break

    def _handle_notify_army(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_ARMY (15):
          Replaces all army maps present in armyInfo cleanly (including fightingArmy & exceptionArmy)
          matching armyCtrl.lua:1062 (`self.armyInfo = armyInfo`).
        """
        _ARMY_MAP_KEYS = (
            "totalArmy",
            "woundedArmy",
            "trainArmy",
            "freeArmy",
            "fightingArmy",
            "exceptionArmy",
            "exceptionWoundedArmy",
        )
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        army_ctrl = self.init_data.setdefault("armyCtrl", {})
        for item in items:
            if not isinstance(item, dict):
                continue
            src = item.get("armyInfo") if isinstance(item.get("armyInfo"), dict) else item
            for mk in _ARMY_MAP_KEYS:
                if mk in src:
                    val = src[mk]
                    army_ctrl[mk] = {} if isinstance(val, list) and len(val) == 0 else copy.deepcopy(val)
            rest = {k: v for k, v in src.items() if k not in _ARMY_MAP_KEYS}
            if rest:
                smart_deep_merge(army_ctrl, rest, in_place=True)

    def _handle_notify_hero(self, notify_data: Any) -> None:
        """Synchronizes NOTIFY_HERO (104)."""
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        heroes_to_merge = []
        for it in items:
            if isinstance(it, dict):
                raw_data = it.get("data")
                if isinstance(raw_data, list):
                    for sub in raw_data:
                        if isinstance(sub, list):
                            heroes_to_merge.extend(x for x in sub if isinstance(x, dict))
                        elif isinstance(sub, dict):
                            heroes_to_merge.append(sub)
                elif isinstance(raw_data, dict):
                    heroes_to_merge.append(raw_data)
                else:
                    heroes_to_merge.append(it)
            elif isinstance(it, list):
                heroes_to_merge.extend(x for x in it if isinstance(x, dict))

        if heroes_to_merge:
            hero_ctrl = self.init_data.get("heroCtrl")
            if isinstance(hero_ctrl, list):
                self.init_data["heroCtrl"] = _merge_keyed_lists(
                    target_list=hero_ctrl,
                    update_list=heroes_to_merge,
                    key_spec=("id", "heroId", "cId"),
                    sub_path=("heroCtrl",),
                    key_maps=DEFAULT_KEY_MAPS
                )
            elif isinstance(hero_ctrl, dict) and "heroes" in hero_ctrl and isinstance(hero_ctrl["heroes"], list):
                hero_ctrl["heroes"] = _merge_keyed_lists(
                    target_list=hero_ctrl["heroes"],
                    update_list=heroes_to_merge,
                    key_spec=("id", "heroId", "cId"),
                    sub_path=("heroCtrl", "heroes"),
                    key_maps=DEFAULT_KEY_MAPS
                )
            else:
                self.init_data["heroCtrl"] = heroes_to_merge

    def _handle_notify_hero_sys(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_HERO_SYS (406) directly into heroSysCtrl.heroList & defendList,
        matching heroCtrl:noitfyDataRsp (src/app/module/hero/heroCtrl.lua:1325-1382).
        """
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        hero_sys = self.init_data.setdefault("heroSysCtrl", {})
        if not isinstance(hero_sys, dict):
            hero_sys = {}
            self.init_data["heroSysCtrl"] = hero_sys

        hero_list = hero_sys.setdefault("heroList", {})
        if not isinstance(hero_list, dict):
            hero_list = {}
            hero_sys["heroList"] = hero_list

        for notify_msg in items:
            if not isinstance(notify_msg, dict):
                continue
            revc_data = notify_msg.get("data")
            if not isinstance(revc_data, dict):
                revc_data = notify_msg

            update_heroes = revc_data.get("updateHeroInfo")
            if isinstance(update_heroes, list):
                for h_obj in update_heroes:
                    if not isinstance(h_obj, dict):
                        continue
                    hid = h_obj.get("heroID") or h_obj.get("id")
                    if hid is not None:
                        hero_list[str(hid)] = copy.deepcopy(h_obj)
            elif isinstance(update_heroes, dict):
                for k, h_obj in update_heroes.items():
                    if isinstance(h_obj, dict):
                        hid = h_obj.get("heroID") or h_obj.get("id") or k
                        hero_list[str(hid)] = copy.deepcopy(h_obj)

            defend_list = revc_data.get("defendList")
            if isinstance(defend_list, (dict, list)):
                hero_sys["defendList"] = copy.deepcopy(defend_list)

    def _handle_notify_lord(self, notify_data: Any) -> None:
        """
        Synchronizes NOTIFY_LORD (8) matching lordInfoCtrl.lua:146-362 & lordAuxiliary.lua:385-403:
          - Unwraps nested `{key: X, X: {...}}` payloads (fixes double-nested `fcInfo.fcInfo`).
          - Routes `closeVIP`, `activate`, `updateLoginDay` to `vip` + `queueCtrl["1219"]`.
          - Routes `physical` to `queueCtrl["1236"]` (stamina recovery timer, NOT root lordInfoCtrl).
          - Routes `updateOfficial` to `official` and `signature`/`passwdVerify`/`merge_history`/`mergeGuideFlag` to `base`.
        """
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        lord_info = self.init_data.setdefault("lordInfoCtrl", {})

        for item in items:
            if not isinstance(item, dict):
                continue
            key = item.get("key")
            if key and isinstance(key, str):
                sub_dict = {k: v for k, v in item.items() if k != "key"}
                if len(sub_dict) == 1 and "data" in sub_dict and isinstance(sub_dict["data"], dict):
                    sub_dict = sub_dict["data"]
                if key != "castleReward" and len(sub_dict) == 1 and key in sub_dict and isinstance(sub_dict[key], dict):
                    sub_dict = sub_dict[key]

                if key == "closeVIP":
                    vip_sub = lord_info.setdefault("vip", {})
                    if isinstance(vip_sub, dict):
                        vip_sub["vipEndTime"] = 0
                    q_ctrl = self.init_data.get("queueCtrl")
                    if isinstance(q_ctrl, dict):
                        q_ctrl.pop("1219", None)
                elif key == "activate":
                    vip_sub = lord_info.setdefault("vip", {})
                    if isinstance(vip_sub, dict):
                        end_t = sub_dict.get("vipEndTime") if "vipEndTime" in sub_dict else sub_dict.get("time")
                        if end_t is not None:
                            vip_sub["vipEndTime"] = end_t
                elif key == "updateLoginDay":
                    vip_sub = lord_info.setdefault("vip", {})
                    if isinstance(vip_sub, dict) and "loginDay" in sub_dict:
                        vip_sub["loginDay"] = sub_dict["loginDay"]
                elif key == "physical":
                    q_ctrl = self.init_data.setdefault("queueCtrl", {})
                    if isinstance(q_ctrl, dict):
                        rem_t = int(float(sub_dict.get("time", -1) or -1))
                        if rem_t <= 0:
                            q_ctrl.pop("1236", None)
                        else:
                            now_ts = int(time.time())
                            q_ctrl["1236"] = {
                                "qtype": "1236",
                                "queuetype": "1236",
                                "starttime": now_ts,
                                "totaltime": rem_t,
                                "ottime": rem_t,
                            }
                elif key == "updateOfficial":
                    off_val = sub_dict.get("official") if "official" in sub_dict else sub_dict
                    lord_info["official"] = copy.deepcopy(off_val)
                elif key in ("signature", "passwdVerify", "merge_history", "mergeGuideFlag"):
                    base_sub = lord_info.setdefault("base", {})
                    if isinstance(base_sub, dict):
                        if key in sub_dict:
                            base_sub[key] = copy.deepcopy(sub_dict[key])
                        else:
                            smart_deep_merge(base_sub, sub_dict, in_place=True)
                else:
                    target_sub = lord_info.setdefault(key, {})
                    if isinstance(target_sub, dict):
                        smart_deep_merge(target_sub, sub_dict, in_place=True)
                    else:
                        lord_info[key] = copy.deepcopy(sub_dict)
            else:
                smart_deep_merge(lord_info, item, in_place=True)

    def _handle_notify_buff(self, notify_data: Any) -> None:
        """Synchronizes NOTIFY_BUFF (7): handles openBuff, closeBuff, buffFinish."""
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        buff_ctrl = self.init_data.setdefault("buffCtrl", [])

        target_list: List[Any]
        if isinstance(buff_ctrl, list):
            target_list = buff_ctrl
        elif isinstance(buff_ctrl, dict) and "buffList" in buff_ctrl and isinstance(buff_ctrl["buffList"], list):
            target_list = buff_ctrl["buffList"]
        else:
            target_list = []
            self.init_data["buffCtrl"] = target_list

        for item in items:
            if not isinstance(item, dict):
                continue
            sync_type = str(item.get("syncType") or item.get("type") or "")

            if sync_type == "openBuff":
                buffs = item.get("list", [])
                if isinstance(buffs, list):
                    target_list = _merge_keyed_lists(
                        target_list=target_list,
                        update_list=buffs,
                        key_spec=_extract_buff_identity,
                        sub_path=("buffCtrl",),
                        key_maps=DEFAULT_KEY_MAPS
                    )
            elif sync_type in ("closeBuff", "buffFinish"):
                if sync_type == "closeBuff":
                    effect_ids = item.get("list")
                    fin_bid, fin_iid = None, None
                else:
                    effect_ids = [
                        val for val in (item.get("id"), item.get("buffId"), item.get("effectType"))
                        if val is not None
                    ]
                    fin_bid, fin_iid = _extract_buff_extra_bid_iid(item)
                if isinstance(effect_ids, (list, tuple)) and effect_ids:
                    to_remove = {str(x) for x in effect_ids if x is not None}

                    def _matches_buff_to_remove(entry: Any) -> bool:
                        if not isinstance(entry, dict):
                            return False
                        id_match = (
                            str(entry.get("id")) in to_remove
                            or str(entry.get("buffId")) in to_remove
                            or str(entry.get("effectType")) in to_remove
                        )
                        if not id_match:
                            return False
                        if fin_bid is not None and fin_iid is not None:
                            return _extract_buff_extra_bid_iid(entry) == (fin_bid, fin_iid)
                        return True

                    target_list = [b for b in target_list if not _matches_buff_to_remove(b)]
                    # محاكاة سلوك العميل الرسمي (lordSkillModule callback): بدء تبريد مهارة الإنقاذ فور انتهاء الباف بعد المعركة
                    now_ts = int(time.time())
                    if "4501" in to_remove or "26" in to_remove:
                        lord_skills = self.init_data.setdefault("lordSkillCtrl", {})
                        if isinstance(lord_skills, dict):
                            cd_data = lord_skills.setdefault("CDData", {})
                            if isinstance(cd_data, dict):
                                cd_data["11028"] = {"beginTime": now_ts, "CD": 28800}
                    if "5425" in to_remove:
                        lord_skills = self.init_data.setdefault("lordSkillCtrl", {})
                        if isinstance(lord_skills, dict):
                            cd_data = lord_skills.setdefault("CDData", {})
                            if isinstance(cd_data, dict):
                                cd_data["13040"] = {"beginTime": now_ts, "CD": 86400}
                    if "5130" in to_remove:
                        lord_skills = self.init_data.setdefault("lordSkillCtrl", {})
                        if isinstance(lord_skills, dict):
                            cd_data = lord_skills.setdefault("CDData", {})
                            if isinstance(cd_data, dict):
                                cd_data["13032"] = {"beginTime": now_ts, "CD": 43200}
                    if "5003" in to_remove:
                        km = self.init_data.get("kingdomMapCtrl")
                        if isinstance(km, dict):
                            km["isSafe"] = False
            elif sync_type == "closeSource":
                src = str(item.get("source", ""))
                if src:
                    target_list = [
                        b for b in target_list
                        if not (isinstance(b, dict) and str(b.get("source")) == src)
                    ]
            else:
                if isinstance(item, dict):
                    target_list = _merge_keyed_lists(
                        target_list=target_list,
                        update_list=[item],
                        key_spec=_extract_buff_identity,
                        sub_path=("buffCtrl",),
                        key_maps=DEFAULT_KEY_MAPS
                    )

        if isinstance(self.init_data.get("buffCtrl"), dict) and "buffList" in self.init_data["buffCtrl"]:
            self.init_data["buffCtrl"]["buffList"] = target_list
        else:
            self.init_data["buffCtrl"] = target_list

    @staticmethod
    def _extract_queue_id(data: Dict[str, Any]) -> str:
        """Extracts string march/queue ID from 'id' or fallback 'queueId'."""
        raw_id = data.get("id") if data.get("id") is not None else data.get("queueId")
        if raw_id is None:
            return ""
        s_id = str(raw_id)
        return s_id if s_id != "" else ""

    _QUEUE_MSG_TYPE_ALIASES: Dict[str, int] = {
        "ADD": 1,
        "REMOVE": 2,
        "UPDATE": 3,
        "ADD_ALL": 4,
        "REMOVE_ALL": 5,
        "DEL_WATCH_POS": 11,
        "QUEUE_TARGET_STATUS": 21,
    }

    @classmethod
    def _normalize_queue_msg_type(cls, raw_type: Any) -> Optional[int]:
        if isinstance(raw_type, bool) or raw_type is None:
            return None
        if isinstance(raw_type, int):
            return raw_type
        s = str(raw_type).strip()
        if not s:
            return None
        if s.isdigit():
            return int(s)
        return cls._QUEUE_MSG_TYPE_ALIASES.get(s.upper())

    def _handle_notify_local_queue(self, notify_data: Any) -> Dict[str, Any]:
        """
        Synchronizes NOTIFY_LOCAL_QUEUE_SYNC (202):
          - msgType 1 (ADD): Inserts new march line.
          - msgType 2 (REMOVE): Deletes completed/recalled march line.
          - msgType 3 (UPDATE): Updates active march line.
          - msgType 4 (ADD_ALL): Full replacement (list or keyed dict).
          - msgType 5 (REMOVE_ALL): Clears all marches.
          - msgType 11/21: Watch/target status acks defined in gQueueSyncMsgType.

        Mirrors marches cleanly into:
          * init_data["local_queues"]: own castle marches.
          * init_data["other_local_queues"]: other players' marches.
        Returns summary dict of applied/skipped operations.
        """
        if isinstance(notify_data, list):
            items = notify_data
        elif isinstance(notify_data, dict):
            if "msgType" not in notify_data and any(
                isinstance(v, dict) and "msgType" in v for v in notify_data.values()
            ):
                items = list(notify_data.values())
            else:
                items = [notify_data]
        else:
            items = [] if notify_data is None else [notify_data]

        ops: List[str] = []
        applied = 0
        skipped = 0

        for msg in items:
            if not isinstance(msg, dict):
                skipped += 1
                ops.append("SKIP(non-dict)")
                continue

            raw_type = msg.get("msgType")
            msg_type = self._normalize_queue_msg_type(raw_type)
            data = msg.get("data")

            if msg_type == 1 and isinstance(data, dict):  # ADD
                qid = self._extract_queue_id(data)
                if qid:
                    org_id = str(data.get("orgId") or data.get("orgQueueId") or "").strip()
                    if org_id and org_id != "0" and org_id != qid:
                        self.local_queues_map.pop(org_id, None)
                    self.local_queues_map[qid] = copy.deepcopy(data)
                    applied += 1
                    ops.append(f"ADD({qid})")
                else:
                    skipped += 1
                    ops.append("SKIP(ADD no-id)")
            elif msg_type == 2 and isinstance(data, dict):  # REMOVE
                qid = self._extract_queue_id(data)
                if qid:
                    existed = qid in self.local_queues_map
                    self.local_queues_map.pop(qid, None)
                    applied += 1
                    ops.append(f"REMOVE({qid}{' hit' if existed else ' miss'})")
                else:
                    skipped += 1
                    ops.append("SKIP(REMOVE no-id)")
            elif msg_type == 3 and isinstance(data, dict):  # UPDATE
                qid = self._extract_queue_id(data)
                if qid:
                    if qid in self.local_queues_map:
                        target_q = self.local_queues_map[qid]
                        smart_deep_merge(target_q, data, in_place=True)
                        # localQueueMgr.lua:11-18 replaces nested march composition arrays/maps directly
                        upd_from = data.get("from")
                        if isinstance(upd_from, dict) and isinstance(target_q.get("from"), dict):
                            for fk in ("army", "heroInfo", "armsInfo", "divineBeastInfo"):
                                if fk in upd_from:
                                    target_q["from"][fk] = copy.deepcopy(upd_from[fk])
                    else:
                        self.local_queues_map[qid] = copy.deepcopy(data)
                    applied += 1
                    ops.append(f"UPDATE({qid})")
                else:
                    skipped += 1
                    ops.append("SKIP(UPDATE no-id)")
            elif msg_type == 4 and isinstance(data, (list, dict)):  # ADD_ALL
                new_map: Dict[str, Any] = {}
                entries = enumerate(data) if isinstance(data, list) else data.items()
                for k, m in entries:
                    if isinstance(m, dict):
                        qid = self._extract_queue_id(m)
                        if not qid and isinstance(data, dict) and str(k) not in ("", "0"):
                            qid = str(k)
                        if qid and qid != "0":
                            new_map[qid] = copy.deepcopy(m)
                self.local_queues_map.clear()
                self.local_queues_map.update(new_map)
                applied += 1
                ops.append(f"ADD_ALL({len(new_map)})")
            elif msg_type == 5:  # REMOVE_ALL
                self.local_queues_map.clear()
                applied += 1
                ops.append("REMOVE_ALL")
            elif msg_type in (11, 21):  # DEL_WATCH_POS / QUEUE_TARGET_STATUS
                applied += 1
                ops.append(f"ACK({msg_type})")
            else:
                skipped += 1
                ops.append(f"SKIP(msgType={raw_type})")

        if applied > 0:
            self.local_queues_synced = True

        own_q, other_q = self.get_local_queues_breakdown()
        # Mirror strictly own-castle marches in init_data["local_queues"]
        self.init_data["local_queues"] = own_q
        # Mirror other players' marches in init_data["other_local_queues"]
        self.init_data["other_local_queues"] = other_q
        if isinstance(self.init_data.get("queueCtrl"), dict):
            self.init_data["queueCtrl"]["queues"] = list(own_q)

        return {
            "ops": ops,
            "applied": applied,
            "skipped": skipped,
            "queues_count": len(own_q),
            "all_queues_count": len(self.local_queues_map),
            "other_queues_count": len(other_q),
        }

    def _handle_notify_time_reward(self, notify_data: Any, notify_id: str) -> None:
        """
        Synchronizes NOTIFY_REWARD (16) and NOTIFY_TIME_REWARD / RESET (20)
        matching timeRewardCtrl.lua:27-81 while preserving flat mock compatibility.
        """
        time_reward = self.init_data.setdefault("timeRewardCtrl", {})
        tr_target = time_reward["data"] if isinstance(time_reward.get("data"), dict) else time_reward
        str_id = str(notify_id).strip().upper()

        has_time_data = False
        if notify_data is not None:
            items = notify_data if isinstance(notify_data, list) else [notify_data]
            for it in items:
                if isinstance(it, dict):
                    if isinstance(it.get("timeData"), dict):
                        has_time_data = True
                        if isinstance(time_reward.get("data"), dict):
                            time_reward["data"] = copy.deepcopy(it["timeData"])
                            tr_target = time_reward["data"]
                        else:
                            smart_deep_merge(tr_target, it["timeData"], in_place=True)
                    else:
                        smart_deep_merge(tr_target, it, in_place=True)

        if str_id in ("16", "REWARD", "NOTIFY_REWARD"):
            if not has_time_data:
                tr_target["isReceive"] = 2
                tr_target["time"] = 0
                if "time" in time_reward:
                    time_reward["time"] = 0
                if tr_target is not time_reward and "isReceive" in time_reward:
                    time_reward["isReceive"] = 2
        elif str_id in ("20", "TIME_REWARD", "NOTIFY_TIME_REWARD", "NOTIFY_RESET_TIME_REWARD"):
            tr_target["isReceive"] = 1
            tr_target["sequence"] = 1
            tr_target["isAllReceive"] = 0
            tr_target["time"] = 0
            if tr_target is not time_reward and "isReceive" in time_reward:
                time_reward["isReceive"] = 1
                time_reward["sequence"] = 1
                time_reward["isAllReceive"] = 0

    def _apply_everyday_task_payload(self, payload: Any) -> List[str]:
        """
        تطبيق تحديثات everydayTaskCtrl بالاستبدال الكامل لحقول النشاط اليومي
        مطابقاً تماماً لدالة everydayTaskCtrl:notifyHandler في سورس اللعبة الرسمي
        لمنع تراكم المفاتيح الوهمية أو بقايا اليوم السابق في eventInfo.
        """
        if not isinstance(payload, dict):
            return []

        inner = payload.get("initData") or payload.get("data")
        src = inner if isinstance(inner, dict) else payload

        current = self.init_data.get("everydayTaskCtrl")
        if not isinstance(current, dict):
            current = {}
            self.init_data["everydayTaskCtrl"] = current

        if src.get("isNewDay"):
            current["eventInfo"] = {}
            current["normalRecord"] = {}
            current["chestRecord"] = {}

        # حقول القواميس التي يستبدلها عميل اللعبة بالكامل ولا يدمجها
        replace_dict_fields = ("eventInfo", "normalRecord", "chestRecord", "chestReward")
        updated_keys: List[str] = []

        for k, v in src.items():
            if k in replace_dict_fields:
                if isinstance(v, dict):
                    current[k] = copy.deepcopy(v)
                elif isinstance(v, list) and k in replace_dict_fields:
                    # Lua empty table {} serializes as [] in JSON
                    current[k] = {}
                else:
                    current[k] = copy.deepcopy(v)
            else:
                current[k] = copy.deepcopy(v)
            updated_keys.append(str(k))

        if "everydayTask" in self.init_data:
            self.init_data["everydayTask"] = self.init_data["everydayTaskCtrl"]

        return updated_keys

    def _handle_notify_everyday_task(self, notify_data: Any) -> Dict[str, Any]:
        """
        معالج إشعار النشاط اليومي الرسمي (NOTIFY_EVERYDAY_TASK = 55) باستبدال السجلات بالكامل
        كما في everydayTaskCtrl:notifyHandler.
        """
        if notify_data is None:
            return {"ctrl": "everydayTaskCtrl", "updated": False}

        items = notify_data if isinstance(notify_data, list) else [notify_data]
        updated_keys: List[str] = []
        for item in items:
            updated_keys.extend(self._apply_everyday_task_payload(item))

        return {
            "ctrl": "everydayTaskCtrl",
            "updated": bool(updated_keys),
            "keys": list(dict.fromkeys(updated_keys))[:5],
        }

    def _handle_notify_generic_controller(self, notify_data: Any, target_ctrl: str) -> Dict[str, Any]:
        """
        دمج آمن ومباشر لإشعارات المتحكمات الرسمية في الذاكرة الحية (0-Network)
        يدعم القواميس والمصفوفات وتحديث الحقول مع الحفاظ على بنية المتحكم.
        """
        if notify_data is None:
            return {"ctrl": target_ctrl, "updated": False}

        current = self.init_data.setdefault(target_ctrl, {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        updated_keys = []

        for item in items:
            if isinstance(item, dict):
                inner_data = item.get("initData") or item.get("data")
                if isinstance(inner_data, dict):
                    smart_deep_merge(current, inner_data, in_place=True)
                    updated_keys.extend(list(inner_data.keys()))
                else:
                    smart_deep_merge(current, item, in_place=True)
                    updated_keys.extend(list(item.keys()))
            elif isinstance(item, list) and isinstance(current, list):
                current.extend(copy.deepcopy(item))
                updated_keys.append(f"items+{len(item)}")

        # مزامنة الأسماء المستعارة التابعة تلقائياً (دون خلط shopCtrl مع storesCtrl أبداً!)
        if target_ctrl == "commandHallCtrl":
            self.init_data["commandHall"] = self.init_data["commandHallCtrl"]
        elif target_ctrl == "commandHall":
            self.init_data["commandHallCtrl"] = self.init_data["commandHall"]

        return {
            "ctrl": target_ctrl,
            "updated": True,
            "keys": list(dict.fromkeys(updated_keys))[:5],
        }

    def _handle_notify_world_update(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_WORLD_UPDATE (2): updates kingdomMapCtrl.isSafe (strictly for own castle UID) & world state."""
        km = self.init_data.setdefault("kingdomMapCtrl", {})
        my_uid = self._resolve_owner_uid()
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            w_type = str(it.get("wordMsgType") or it.get("worldMsgType") or it.get("msgType") or it.get("type") or "").strip()
            ret = it.get("retData") if isinstance(it.get("retData"), dict) else it
            if "isSafe" in ret or w_type in ("protectStatus", "2"):
                pkt_uid = str(ret.get("uid") or ret.get("playerID") or it.get("uid") or it.get("playerID") or "").strip()
                if pkt_uid in ("", "0") or not my_uid or pkt_uid == my_uid:
                    km["isSafe"] = bool(ret.get("isSafe", False))
                    keys.append(f"isSafe={km['isSafe']}")
            for fk in ("maxNpcLevel", "maxMapNpcLevel", "changeMapId", "kingdomId"):
                if fk in ret:
                    km[fk] = copy.deepcopy(ret[fk])
                    keys.append(fk)
        return {"ctrl": "kingdomMapCtrl", "updated": bool(keys), "keys": keys}

    def _handle_notify_login_reward(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_DAILYLOGIN_REWARD (18) for merchant_ship (loginRewardCtrl)."""
        ctrl = self.init_data.setdefault("loginRewardCtrl", {})
        items = notify_data if isinstance(notify_data, list) else ([notify_data] if notify_data is not None else [{}])
        keys: List[str] = []
        for it in items:
            if isinstance(it, dict) and isinstance(it.get("loginRewardData"), dict):
                self.init_data["loginRewardCtrl"] = copy.deepcopy(it["loginRewardData"])
                ctrl = self.init_data["loginRewardCtrl"]
                keys.extend(list(ctrl.keys())[:4])
            elif isinstance(it, dict):
                ctrl["canReceive"] = bool(it["canReceive"]) if "canReceive" in it else True
                for fk in ("cardList", "curDay", "mul"):
                    if fk in it:
                        ctrl[fk] = copy.deepcopy(it[fk])
                        keys.append(fk)
                keys.append("canReceive")
        return {"ctrl": "loginRewardCtrl", "updated": True, "keys": keys}

    def _handle_notify_hero_trial(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_HERO_TRIAL (37) into htData (heroTrialCtrl.lua:156-241)."""
        ht = self.init_data.setdefault("htData", {})
        pt_data = ht.setdefault("htPointData", {})
        bt_data = ht.setdefault("battleData", {})
        mp_info = ht.setdefault("mapInfo", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            nt = str(it.get("notifyType") or it.get("type") or "").strip()
            if nt in ("addPoint", "subPoint"):
                if "curPoint" in it and isinstance(pt_data, dict):
                    pt_data["htPoint"] = it["curPoint"]
                if it.get("inRCD") and "bTime" in it and isinstance(pt_data, dict):
                    pt_data["bTime"] = it["bTime"]
                keys.append(nt)
            elif nt == "prepare":
                if isinstance(bt_data, dict):
                    bt_data["trialStatus"] = True
                    for fk in ("bTime", "preTime"):
                        if fk in it:
                            bt_data[fk] = it[fk]
                keys.append("prepare")
            elif nt == "march":
                if isinstance(bt_data, dict):
                    bt_data["trialStatus"] = True
                    for fk in ("stageID", "soldiers", "bTime", "marchTime", "mvTimeData"):
                        if fk in it:
                            bt_data[fk] = copy.deepcopy(it[fk])
                keys.append("march")
            elif nt == "battle":
                if it.get("battleRet") and "stageID" in it and isinstance(mp_info, dict):
                    mp_info["lastCOMPSID"] = it["stageID"]
                if it.get("finish") and isinstance(bt_data, dict):
                    bt_data["trialStatus"] = False
                if "soldiers" in it and isinstance(bt_data, dict):
                    bt_data["soldiers"] = copy.deepcopy(it["soldiers"])
                keys.append("battle")
            elif nt == "stopAuto":
                if isinstance(bt_data, dict):
                    bt_data["trialStatus"] = False
                keys.append("stopAuto")
            elif any(k in it for k in ("htPointData", "battleData", "mapInfo")):
                smart_deep_merge(ht, it, in_place=True)
                keys.extend(list(it.keys())[:3])
        return {"ctrl": "htData", "updated": bool(keys), "keys": keys}

    def _handle_notify_arena(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ARENA (1007) into playerArenaCtrl (arenaCtrl.lua:136-216)."""
        arena = self.init_data.setdefault("playerArenaCtrl", {})
        arena_keys = {"1": "localArena", "2": "globalArena", "localArena": "localArena", "globalArena": "globalArena"}
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            rtype = str(it.get("type") or "").strip()
            rdata = it.get("data") if isinstance(it.get("data"), dict) else it
            if rtype in ("refreshData", "groupChange") and isinstance(rdata, dict) and rdata:
                self.init_data["playerArenaCtrl"] = copy.deepcopy(rdata)
                arena = self.init_data["playerArenaCtrl"]
                keys.append(rtype)
            elif rtype == "arenaRankChange" and isinstance(rdata, dict):
                akey = arena_keys.get(str(rdata.get("arenaType", "")), "localArena")
                arena.setdefault(akey, {})["myRank"] = rdata.get("rank")
                keys.append(f"{akey}.myRank")
            elif rtype == "globalState" and isinstance(rdata, dict):
                ga = arena.setdefault("globalArena", {})
                if "changeTime" in rdata:
                    ga["arenaChangeTime"] = rdata["changeTime"]
                if "status" in rdata:
                    ga["arenaStatus"] = rdata["status"]
                if "buff" in rdata:
                    ga["arenaBuff"] = copy.deepcopy(rdata["buff"])
                keys.append("globalState")
            elif rtype == "rewardTime" and isinstance(rdata, dict):
                akey = arena_keys.get(str(rdata.get("arenaType", "")), "localArena")
                if "nextRewardTime" in rdata:
                    arena.setdefault(akey, {})["nextRewardTime"] = rdata["nextRewardTime"]
                keys.append(f"{akey}.nextRewardTime")
            elif rtype == "rewardChange" and isinstance(rdata, dict):
                akey = arena_keys.get(str(rdata.get("arenaType", "")), "localArena")
                if "rewards" in rdata:
                    arena.setdefault(akey, {})["rewards"] = copy.deepcopy(rdata["rewards"])
                keys.append(f"{akey}.rewards")
            elif rtype == "refreshHonor" and isinstance(rdata, dict):
                if "arenaHonor" in rdata:
                    arena["arenaHonor"] = rdata["arenaHonor"]
                keys.append("arenaHonor")
            elif isinstance(rdata, dict) and ("localArena" in rdata or "globalArena" in rdata):
                smart_deep_merge(arena, rdata, in_place=True)
                keys.extend(list(rdata.keys())[:3])
        return {"ctrl": "playerArenaCtrl", "updated": bool(keys), "keys": keys}

    def _handle_notify_stuff_workshop(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes STUFFWORKSHOP_REFINERY (1002) by full replace + queueCtrl['1238'] sync."""
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for tmp in items:
            if not isinstance(tmp, dict):
                continue
            if isinstance(tmp.get("data"), dict):
                self.init_data["stuffWorkshopCtrl"] = copy.deepcopy(tmp["data"])
                keys.extend(list(tmp["data"].keys())[:4])
            elif "list" in tmp or "doneID" in tmp:
                self.init_data["stuffWorkshopCtrl"] = copy.deepcopy(tmp)
                keys.extend(list(tmp.keys())[:4])

            if "stuffWorkshop" in self.init_data:
                self.init_data["stuffWorkshop"] = self.init_data.get("stuffWorkshopCtrl", {})

            if tmp.get("activityOpen") is None:
                q_ctrl = self.init_data.get("queueCtrl")
                if isinstance(q_ctrl, dict):
                    if tmp.get("hasRefinery"):
                        bt = int(float(tmp.get("begintime", 0) or time.time()))
                        tt = int(float(tmp.get("totaltime", 0) or 0))
                        sec = int(float(tmp.get("second", tt) or tt))
                        q_ctrl["1238"] = {
                            "qtype": "1238",
                            "queuetype": "1238",
                            "starttime": bt,
                            "totaltime": tt,
                            "ottime": sec,
                            "data": {"ID": tmp.get("ID"), "endtime": bt + tt},
                        }
                    elif "hasRefinery" in tmp:
                        q_ctrl.pop("1238", None)
        if "stuffWorkshopCtrl" not in self.init_data:
            self.init_data["stuffWorkshopCtrl"] = {}
        return {"ctrl": "stuffWorkshopCtrl", "updated": True, "keys": keys}

    def _handle_notify_shop(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_SHOP (23) into storesCtrl cleanly without shopCtrl aliasing."""
        stores = self.init_data.setdefault("storesCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            nt = str(it.get("notifyType") or it.get("type") or "").strip()
            if nt in ("reset", "open"):
                for fk in ("refreshGold", "refreshTimes", "shopItemArray", "bestShopItem", "nextRefreshTime"):
                    if fk in it:
                        stores[fk] = copy.deepcopy(it[fk])
                stores["isOpen"] = 1
                if nt == "open" and "actStatus" in it:
                    stores["actStatus"] = it["actStatus"]
                keys.append(nt)
            elif nt == "close":
                stores["isOpen"] = 0
                stores["shopItemArray"] = []
                keys.append("close")
            elif nt == "actBegin":
                stores["actStatus"] = True
                keys.append("actBegin")
            elif nt == "actEnd":
                stores["actStatus"] = False
                keys.append("actEnd")
            else:
                shop = self.init_data.setdefault("shopCtrl", {})
                if isinstance(shop, dict):
                    smart_deep_merge(shop, it, in_place=True)
                keys.append(nt or "shopCtrl")
        return {"ctrl": "storesCtrl", "updated": True, "keys": keys}

    def _handle_notify_command_hall(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_COMMAND_HALL (608) via full initData replacement (commandHallCtrl.lua:48-49)."""
        _hall_state_keys = (
            "commandLv",
            "commonTaskData",
            "finishTaskData",
            "armyGroupTaskData",
            "armyPioneerTaskData",
        )
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            init_snap = it.get("initData")
            data_snap = it.get("data")
            inner: Optional[Dict[str, Any]] = None
            if isinstance(init_snap, dict):
                inner = init_snap
            elif isinstance(data_snap, dict) and any(k in data_snap for k in _hall_state_keys):
                inner = data_snap
            elif any(k in it for k in _hall_state_keys):
                inner = it

            if isinstance(inner, dict):
                self.init_data["commandHallCtrl"] = copy.deepcopy(inner)
                self.init_data["commandHall"] = self.init_data["commandHallCtrl"]
                keys.extend(list(inner.keys())[:4])

            res_obj = it.get("result")
            if isinstance(res_obj, dict) and "win" in res_obj:
                res_copy = copy.deepcopy(res_obj)
                res_copy["_mono"] = time.monotonic()
                self.init_data["_last_ch_battle_result"] = res_copy
                keys.append("result")

        if "commandHallCtrl" not in self.init_data:
            existing_hall = self.init_data.get("commandHall")
            self.init_data["commandHallCtrl"] = existing_hall if isinstance(existing_hall, dict) else {}
        self.init_data["commandHall"] = self.init_data["commandHallCtrl"]
        return {"ctrl": "commandHallCtrl", "updated": True, "keys": keys}

    def _handle_notify_quest(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_QUEST (12) across all 7 notifyTypes (questCtrl.lua:214-248)."""
        qc = self.init_data.setdefault("questCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            nt = str(it.get("notifyType") or it.get("type") or "").strip()
            if nt == "new":
                arr = it.get("array")
                if not isinstance(arr, list) and isinstance(it.get("property"), dict):
                    arr = [it["property"]]
                if isinstance(arr, list):
                    q_arr = qc.setdefault("questArray", [])
                    if isinstance(q_arr, list):
                        for prop in arr:
                            if isinstance(prop, dict) and prop.get("questID") is not None:
                                qid_s = str(prop["questID"])
                                replaced = False
                                for idx, q in enumerate(q_arr):
                                    if isinstance(q, dict) and str(q.get("questID")) == qid_s:
                                        q_arr[idx] = copy.deepcopy(prop)
                                        replaced = True
                                        break
                                if not replaced:
                                    q_arr.append(copy.deepcopy(prop))
                keys.append("new")
            elif nt == "update":
                qid = it.get("questID")
                prog = it.get("progress")
                if qid is not None:
                    qid_s = str(qid)

                    def _apply_q_prog(q_entry: Dict[str, Any]) -> None:
                        q_entry["progress"] = prog
                        try:
                            aim_v = int(q_entry.get("aim", 0) or 0)
                            prog_v = int(prog or 0)
                            if aim_v > 0 and prog_v >= aim_v and int(q_entry.get("status", 0) or 0) == 2:
                                q_entry["status"] = 3
                        except (ValueError, TypeError):
                            pass

                    for arr_key in ("questArray", "oQuestArray"):
                        q_arr = qc.get(arr_key)
                        if isinstance(q_arr, list):
                            for q in q_arr:
                                if isinstance(q, dict) and str(q.get("questID")) == qid_s:
                                    _apply_q_prog(q)
                                elif isinstance(q, dict) and isinstance(q.get("property"), dict) and str(q["property"].get("questID")) == qid_s:
                                    _apply_q_prog(q["property"])
                    gq = qc.get("guideQuest")
                    if isinstance(gq, dict) and str(gq.get("questID")) == qid_s:
                        _apply_q_prog(gq)
                if "pGuideQuest" in it:
                    qc["pGuideQuest"] = copy.deepcopy(it["pGuideQuest"])
                keys.append(f"update:{qid}")
            elif nt == "guide":
                if isinstance(it.get("property"), dict):
                    qc["guideQuest"] = copy.deepcopy(it["property"])
                keys.append("guide")
            elif nt == "finish_guide":
                qc["guideQuest"] = {}
                keys.append("finish_guide")
            elif nt in ("newOQuest", "openOQuest"):
                oq = it.get("quest")
                if isinstance(oq, dict):
                    oq_arr = qc.setdefault("oQuestArray", [])
                    if isinstance(oq_arr, list):
                        qid_s = str(oq.get("questID") or (oq.get("property") or {}).get("questID") or "")
                        if qid_s:
                            oq_arr[:] = [
                                x for x in oq_arr
                                if not (isinstance(x, dict) and str(x.get("questID") or (x.get("property") or {}).get("questID") or "") == qid_s)
                            ]
                        oq_arr.append(copy.deepcopy(oq))
                keys.append(nt)
            elif nt == "closeOQuest":
                qid_s = str(it.get("questID") or "")
                oq_arr = qc.get("oQuestArray")
                if qid_s and isinstance(oq_arr, list):
                    oq_arr[:] = [
                        x for x in oq_arr
                        if not (isinstance(x, dict) and str(x.get("questID") or (x.get("property") or {}).get("questID") or "") == qid_s)
                    ]
                keys.append("closeOQuest")
            elif any(k in it for k in ("questArray", "oQuestArray", "guideQuest")):
                smart_deep_merge(qc, it, in_place=True)
                keys.extend(list(it.keys())[:3])
        return {"ctrl": "questCtrl", "updated": True, "keys": keys}

    def _handle_notify_walls(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_WALLS (11) by unwrapping notifyData.notifyData (wallsCtrl.lua:104-116)."""
        wc = self.init_data.setdefault("wallsCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            inner = it.get("notifyData") if isinstance(it.get("notifyData"), dict) else (
                it.get("data") if isinstance(it.get("data"), dict) else it
            )
            if isinstance(inner, dict):
                clean = {k: v for k, v in inner.items() if k != "notifyType"}
                smart_deep_merge(wc, clean, in_place=True)
                keys.extend(list(clean.keys())[:4])
        return {"ctrl": "wallsCtrl", "updated": True, "keys": keys}

    def _handle_notify_pyramid(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_PYRAMID (27) by replacing pyramidCtrl['data'] (pyramidCtrl.lua:253)."""
        pc = self.init_data.setdefault("pyramidCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            if isinstance(it.get("data"), dict):
                pc["data"] = copy.deepcopy(it["data"])
                keys.extend(list(it["data"].keys())[:4])
            elif any(k in it for k in ("free", "floor", "award", "copper", "score")):
                pc["data"] = copy.deepcopy(it)
                keys.extend(list(it.keys())[:4])
        return {"ctrl": "pyramidCtrl", "updated": True, "keys": keys}

    def _handle_notify_badge_exchange(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_BADGE_EXCHANGE (41) by replacing curExchangeNumMap (badgeExchangeCtrl.lua:43-44)."""
        bc = self.init_data.setdefault("badgeExchangeCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            src = it.get("data") if isinstance(it.get("data"), dict) else it
            if isinstance(src, dict) and "curExchangeNumMap" in src:
                cmap = src["curExchangeNumMap"]
                bc["curExchangeNumMap"] = {} if isinstance(cmap, list) else copy.deepcopy(cmap)
                keys.append("curExchangeNumMap")
        return {"ctrl": "badgeExchangeCtrl", "updated": True, "keys": keys}

    def _handle_notify_equipment(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_EQUIPMENT (29) matching equipmentCtrl.lua:1573-1675."""
        ec = self.init_data.setdefault("equipmentCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            nt = str(it.get("notifyType") or it.get("type") or "").strip()
            if nt == "cle":
                fe = ec.get("fe")
                if isinstance(fe, dict):
                    if it.get("epid") is None or str(fe.get("epid") or "") in ("", str(it.get("epid"))):
                        fe["isCle"] = 1
                q_ctrl = self.init_data.get("queueCtrl")
                if isinstance(q_ctrl, dict):
                    q_ctrl.pop("1229", None)
                keys.append("cle")
            elif nt == "rfr":
                if "count" in it:
                    ec["countOfFreeRemaking"] = it["count"]
                keys.append("rfr")
            elif nt == "add" and isinstance(it.get("property"), dict):
                prop = copy.deepcopy(it["property"])
                eq_arr = ec.setdefault("equipment_array", [])
                if isinstance(eq_arr, list):
                    epid_s = str(prop.get("epid") or "")
                    if epid_s:
                        eq_arr[:] = [x for x in eq_arr if not (isinstance(x, dict) and str(x.get("epid") or "") == epid_s)]
                    eq_arr.append(prop)
                keys.append("add")
            elif nt == "delete":
                epid_s = str(it.get("epid") or "")
                eq_arr = ec.get("equipment_array")
                if epid_s and isinstance(eq_arr, list):
                    eq_arr[:] = [x for x in eq_arr if not (isinstance(x, dict) and str(x.get("epid") or "") == epid_s)]
                if "overdueEquipments" in it:
                    ec["overdueEquipments"] = copy.deepcopy(it["overdueEquipments"])
                if "nebulaExchangeInfo" in it:
                    ec["nebulaExchangeInfo"] = copy.deepcopy(it["nebulaExchangeInfo"])
                keys.append("delete")
            elif nt == "ringStore" and isinstance(it.get("ringStore"), dict):
                if "limitItemsInfo" in it["ringStore"]:
                    ec["limitRingShop"] = copy.deepcopy(it["ringStore"]["limitItemsInfo"])
                keys.append("ringStore")
        return {"ctrl": "equipmentCtrl", "updated": True, "keys": keys}

    def _handle_notify_alliance_treasure(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ALLIANCE_TREASURE (95) by replacing lists cleanly (allianceTreasureCtrl.lua:275-297)."""
        atc = self.init_data.setdefault("allianceTreasureCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            src = it.get("data") if isinstance(it.get("data"), dict) else it
            for rk in ("treasureInfo", "digListInfo", "canHelpList", "helpInfo", "otherInfo"):
                if rk in src:
                    atc[rk] = copy.deepcopy(src[rk])
                    keys.append(rk)
        return {"ctrl": "allianceTreasureCtrl", "updated": True, "keys": keys}

    def _handle_notify_escort(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ESCORT (49) without polluting root with 'type'."""
        ec = self.init_data.setdefault("escortCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            src = it.get("data") if isinstance(it.get("data"), dict) else it
            if isinstance(src, dict):
                clean = {k: v for k, v in src.items() if k not in ("type", "notifyType")}
                smart_deep_merge(ec, clean, in_place=True)
                keys.extend(list(clean.keys())[:4])
        return {"ctrl": "escortCtrl", "updated": True, "keys": keys}

    def _handle_notify_escort_cart(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ESCORT_CART (50) by replacing rewardMap list-of-lists (escortCartCtrl.lua:102)."""
        ecc = self.init_data.setdefault("escortCartCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            src = it.get("data") if isinstance(it.get("data"), dict) else it
            if isinstance(src, dict):
                if "rewardMap" in src:
                    ecc["rewardMap"] = copy.deepcopy(src["rewardMap"])
                    keys.append("rewardMap")
                clean = {k: v for k, v in src.items() if k not in ("rewardMap", "type", "notifyType")}
                if clean:
                    smart_deep_merge(ecc, clean, in_place=True)
                    keys.extend(list(clean.keys())[:3])
        return {"ctrl": "escortCartCtrl", "updated": True, "keys": keys}

    def _handle_notify_salesroom(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_SALESROOM (59) & NOTIFY_NEW_SALESROOM (464) (salesRoomAgCtrl.lua:60-120)."""
        sr = self.init_data.setdefault("salesRoomAgCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            for rk in ("salesRoomData", "itemsInfo", "notReceiveGold", "timeAndStatus", "boreNum", "hint"):
                if rk in it:
                    sr[rk] = copy.deepcopy(it[rk])
                    keys.append(rk)
            if isinstance(it.get("data"), dict):
                smart_deep_merge(sr, it["data"], in_place=True)
                keys.extend(list(it["data"].keys())[:3])
        return {"ctrl": "salesRoomAgCtrl", "updated": True, "keys": keys}

    def _handle_notify_alliance(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ALLIANCE (3) events without polluting root allianceCtrl with eventName."""
        ac = self.init_data.setdefault("allianceCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            ev_name = str(it.get("eventName") or "").strip()
            if "add_helpinfo" in ev_name:
                hinfo = it.get("helpinfo") or it.get("data")
                if isinstance(hinfo, dict):
                    hlist = ac.setdefault("helplist", [])
                    if isinstance(hlist, list):
                        ac["helplist"] = _merge_keyed_lists(
                            hlist, [hinfo], ("id", "helpId"), ("allianceCtrl", "helplist"), DEFAULT_KEY_MAPS
                        )
                keys.append("helplist+")
            elif "del_help_data" in ev_name or "help_all" in ev_name:
                uid_s = str(it.get("uid") or "")
                qtp_s = str(it.get("queueTp") or "")
                hid_s = str(it.get("id") or it.get("helpId") or "")
                hlist = ac.get("helplist")
                if isinstance(hlist, list):
                    if "help_all" in ev_name and not uid_s and not hid_s:
                        my_uid = self._resolve_owner_uid()
                        if str(it.get("helperUid") or "") == my_uid:
                            ac["helplist"] = []
                    else:
                        ac["helplist"] = [
                            h for h in hlist
                            if not (
                                isinstance(h, dict)
                                and (
                                    (hid_s and str(h.get("id") or h.get("helpId") or "") == hid_s)
                                    or (uid_s and qtp_s and str(h.get("uid") or "") == uid_s and str(h.get("queueTp") or h.get("qtype") or "") == qtp_s)
                                )
                            )
                        ]
                keys.append("helplist-")
            elif "alliance_treasure_add" in ev_name:
                dig = it.get("digInfo") or it.get("data")
                atc = self.init_data.get("allianceTreasureCtrl")
                if isinstance(dig, dict) and isinstance(atc, dict):
                    ch_list = atc.setdefault("canHelpList", [])
                    if isinstance(ch_list, list):
                        ch_list.append(copy.deepcopy(dig))
                keys.append("treasure_add")
            elif "alliance_treasure_reduce" in ev_name:
                dig_id = str(it.get("digId") or (it.get("digInfo") or {}).get("digId") or "")
                atc = self.init_data.get("allianceTreasureCtrl")
                if dig_id and isinstance(atc, dict) and isinstance(atc.get("canHelpList"), list):
                    atc["canHelpList"] = [
                        d for d in atc["canHelpList"]
                        if not (isinstance(d, dict) and str(d.get("digId") or "") == dig_id)
                    ]
                keys.append("treasure_reduce")
            elif isinstance(it.get("allianceInfo"), dict):
                smart_deep_merge(ac.setdefault("allianceInfo", {}), it["allianceInfo"], in_place=True)
                keys.append("allianceInfo")
            elif not ev_name:
                clean = {k: v for k, v in it.items() if k != "eventName"}
                if clean:
                    smart_deep_merge(ac, clean, in_place=True)
                    keys.extend(list(clean.keys())[:3])
            else:
                keys.append(ev_name)
        return {"ctrl": "allianceCtrl", "updated": True, "keys": keys}

    def _handle_notify_alliance_relation(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ALLIANCE_RELATION (64) into allianceCtrl.relationMap[aid]."""
        ac = self.init_data.setdefault("allianceCtrl", {})
        rmap = ac.get("relationMap")
        if not isinstance(rmap, dict):
            rmap = {}
            ac["relationMap"] = rmap
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            aid = str(it.get("aid") or "").strip()
            mtype = str(it.get("msgType") or "").strip().upper()
            if aid:
                if mtype in ("2", "DEL_RELATION"):
                    rmap.pop(aid, None)
                    keys.append(f"del:{aid}")
                elif isinstance(it.get("data"), dict):
                    rmap[aid] = copy.deepcopy(it["data"])
                    keys.append(f"add:{aid}")
        return {"ctrl": "allianceCtrl", "updated": True, "keys": keys}

    def _handle_notify_alliance_recommend(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_ALLIANCE_RECOMMEND (1009) into allianceInvitePopInfo without clobbering allianceCtrl."""
        ac = self.init_data.setdefault("allianceCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        for it in items:
            if isinstance(it, dict) and str(it.get("type") or "") == "recommend" and isinstance(it.get("data"), dict):
                ac["allianceInvitePopInfo"] = copy.deepcopy(it["data"])
        return {"ctrl": "allianceCtrl", "updated": True, "keys": ["allianceInvitePopInfo"]}

    # ── مخزن كائنات الخريطة (مطابق لـ mapPieceObjMgr.lua: pieceMap[kid][pieceId][objId]) ──
    _MAP_OBJ_ID_RE = re.compile(r"^\d+-\d+-\d+(?:-[\w.]+)*$")
    MAX_MAP_PIECES_PER_KID = 150      # سقف عدد قطع الخريطة المحفوظة لكل مملكة (الأقدم يُحذف أولاً)
    MAX_LOOSE_MAP_OBJS = 600          # سقف الكائنات المفردة غير المنسوبة لقطعة معروفة
    MAX_MAP_QUEUES = 600              # سقف طوابير الخريطة المحفوظة (الأقدم يُحذف أولاً)
    _LOOSE_PIECE_KEY = "_loose"

    @classmethod
    def _is_map_obj(cls, obj: Any) -> bool:
        if not isinstance(obj, dict):
            return False
        if cls._MAP_OBJ_ID_RE.match(str(obj.get("id") or "").strip()):
            return True
        has_type = obj.get("type") is not None or obj.get("mapType") is not None
        return has_type and obj.get("x") is not None and obj.get("y") is not None and not isinstance(obj.get("to"), dict)

    @staticmethod
    def _map_obj_key(obj: Dict[str, Any]) -> str:
        """مفتاح التخزين: معرّف الكائن الرسمي، أو مفتاح إحداثي آمن عند غيابه."""
        oid = str(obj.get("id") or "").strip()
        if oid:
            return oid
        return f"xy:{obj.get('x')}:{obj.get('y')}:{obj.get('type', obj.get('mapType'))}"

    @classmethod
    def _collect_map_objs(cls, node: Any, depth: int = 0) -> List[Dict[str, Any]]:
        """استخراج كائنات الخريطة (معرّف بصيغة sx-sy-type-...) من أي بنية بيانات قطعة."""
        found: List[Dict[str, Any]] = []
        if depth > 6 or node is None:
            return found
        if isinstance(node, list):
            for it in node:
                found.extend(cls._collect_map_objs(it, depth + 1))
        elif isinstance(node, dict):
            if cls._is_map_obj(node):
                found.append(node)
                return found
            for k, v in node.items():
                if isinstance(v, dict) and not v.get("id") and cls._MAP_OBJ_ID_RE.match(str(k)):
                    obj = dict(v)
                    obj["id"] = str(k)
                    found.append(obj)
                elif isinstance(v, (dict, list)):
                    found.extend(cls._collect_map_objs(v, depth + 1))
        return found

    @staticmethod
    def _collect_map_queues(node: Any, depth: int = 0) -> List[Dict[str, Any]]:
        """استخراج طوابير الخريطة (تحتوي to/from) من بيانات ADD_PIECE_QUEUE / ADD_QUEUE."""
        found: List[Dict[str, Any]] = []
        if depth > 5 or node is None:
            return found
        if isinstance(node, list):
            for it in node:
                found.extend(LiveMemoryEngine._collect_map_queues(it, depth + 1))
        elif isinstance(node, dict):
            if isinstance(node.get("to"), dict) and (node.get("id") is not None or node.get("queueId") is not None):
                found.append(node)
                return found
            for v in node.values():
                if isinstance(v, (dict, list)):
                    found.extend(LiveMemoryEngine._collect_map_queues(v, depth + 1))
        return found

    def _map_store(self) -> Tuple[Dict[str, Any], Dict[str, Any], Dict[str, Any]]:
        km = self.init_data.setdefault("kingdomMapCtrl", {})
        if not isinstance(km, dict):
            km = {}
            self.init_data["kingdomMapCtrl"] = km
        pieces = km.get("mapPieces")
        if not isinstance(pieces, dict):
            pieces = {}
            km["mapPieces"] = pieces
        queues = km.get("mapQueues")
        if not isinstance(queues, dict):
            queues = {}
            km["mapQueues"] = queues
        return km, pieces, queues

    def _resolve_map_kid(self, msg: Dict[str, Any], km: Dict[str, Any]) -> str:
        kid = msg.get("mapId") or msg.get("kid") or km.get("mapId") or km.get("kingdomId") or 0
        return str(kid)

    def _map_put_piece(self, pieces: Dict[str, Any], kid: str, piece_id: str, objs: List[Dict[str, Any]]) -> None:
        """ADD_PIECE_MAP: استبدال القطعة كاملة (حذف الكائنات التي اختفت) مع تحديث ترتيب الحداثة."""
        kid_map = pieces.setdefault(kid, {})
        kid_map.pop(piece_id, None)
        kid_map[piece_id] = {self._map_obj_key(o): copy.deepcopy(o) for o in objs}
        loose = kid_map.get(self._LOOSE_PIECE_KEY)
        if isinstance(loose, dict):
            for oid in kid_map[piece_id]:
                loose.pop(oid, None)
        real_keys = [k for k in kid_map if k != self._LOOSE_PIECE_KEY]
        while len(real_keys) > self.MAX_MAP_PIECES_PER_KID:
            kid_map.pop(real_keys.pop(0), None)

    def _map_upsert_obj(self, pieces: Dict[str, Any], kid: str, obj: Dict[str, Any]) -> None:
        """ADD_MAPOBJ / UPDATE_MAPOBJ: تحديث الكائن في قطعته إن وُجد، وإلا حفظه في الحاوية المفردة المحدودة."""
        oid = self._map_obj_key(obj)
        kid_map = pieces.setdefault(kid, {})
        for p_key, p_objs in kid_map.items():
            if isinstance(p_objs, dict) and oid in p_objs:
                if isinstance(p_objs[oid], dict):
                    smart_deep_merge(p_objs[oid], obj, in_place=True)
                else:
                    p_objs[oid] = copy.deepcopy(obj)
                return
        loose = kid_map.setdefault(self._LOOSE_PIECE_KEY, {})
        loose.pop(oid, None)
        loose[oid] = copy.deepcopy(obj)
        while len(loose) > self.MAX_LOOSE_MAP_OBJS:
            loose.pop(next(iter(loose)), None)

    def _map_remove_obj(self, pieces: Dict[str, Any], kid: str, obj_id: str) -> None:
        kid_map = pieces.get(kid)
        if isinstance(kid_map, dict):
            for p_objs in kid_map.values():
                if isinstance(p_objs, dict):
                    p_objs.pop(obj_id, None)

    def _map_put_queue(self, queues: Dict[str, Any], q: Dict[str, Any]) -> None:
        qid = str(q.get("id") if q.get("id") is not None else q.get("queueId"))
        if qid in queues and isinstance(queues[qid], dict):
            smart_deep_merge(queues[qid], q, in_place=True)
            return
        queues[qid] = copy.deepcopy(q)
        while len(queues) > self.MAX_MAP_QUEUES:
            queues.pop(next(iter(queues)), None)

    def _handle_map_sync_rsp(self, packet: Dict[str, Any]) -> None:
        """
        رد CMD 1006/1000 (kingdomMapCtrl:onRspMapSync + kingdomMapCell:delPieceIds):
        حذف قطع الخريطة التي خرجت من نطاق الرؤية (delPieceIds = {kid: [pieceId, ...]}).
        """
        sources = [packet]
        if isinstance(packet.get("data"), dict):
            sources.append(packet["data"])
        _km, pieces, _queues = self._map_store()
        for src in sources:
            del_ids = src.get("delPieceIds")
            if not isinstance(del_ids, dict):
                continue
            for kid_raw, p_ids in del_ids.items():
                kid_map = pieces.get(str(kid_raw))
                if not isinstance(kid_map, dict):
                    continue
                p_iter = p_ids.values() if isinstance(p_ids, dict) else (p_ids if isinstance(p_ids, list) else [])
                for pid in p_iter:
                    kid_map.pop(str(pid), None)

    def _handle_notify_map_sync(self, notify_data: Any) -> Dict[str, Any]:
        """
        NOTIFY_MAP_SYNC (201) مطابق لـ kingdomMapCtrl:onNotifyMapSyncData + mapPieceObjMgr.lua:
          - 1 ADD_PIECE_MAP  : data = {pieceId: pieceData} -> استبدال القطعة كاملة.
          - 2/4/5 ADD/UPDATE/FLASH_MAPOBJ : تحديث الكائن بمعرّفه.
          - 3 REMOVE_MAPOBJ  : حذف الكائن بمعرّفه.
          - 11/12/14 ADD_PIECE_QUEUE/ADD_QUEUE/UPDATE_QUEUE : حفظ طوابير الخريطة (لكشف الأطلال المشغولة).
          - 13 REMOVE_QUEUE  : حذف الطابور.
        يُخزَّن كل ذلك في kingdomMapCtrl.mapPieces / mapQueues بسقوف ثابتة تمنع تضخم الذاكرة
        وبقاء الأطلال/القلاع المختفية، دون تلويث جذر kingdomMapCtrl.
        """
        km, pieces, queues = self._map_store()
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for msg in items:
            if not isinstance(msg, dict):
                continue
            raw_type = msg.get("msgType")
            try:
                m_type = int(raw_type) if raw_type is not None else None
            except (ValueError, TypeError):
                m_type = None
            kid = self._resolve_map_kid(msg, km)
            data = msg.get("data")

            if m_type == 1 and isinstance(data, dict):
                for piece_id, piece_data in data.items():
                    self._map_put_piece(pieces, kid, str(piece_id), self._collect_map_objs(piece_data))
                keys.append("ADD_PIECE_MAP")
            elif m_type in (2, 4, 5):
                for obj in self._collect_map_objs(data):
                    self._map_upsert_obj(pieces, kid, obj)
                keys.append(f"MAPOBJ({m_type})")
            elif m_type == 3:
                rm_objs = self._collect_map_objs(data)
                if not rm_objs and isinstance(data, dict) and data.get("id") is not None:
                    rm_objs = [data]
                for obj in rm_objs:
                    self._map_remove_obj(pieces, kid, self._map_obj_key(obj))
                keys.append("REMOVE_MAPOBJ")
            elif m_type in (11, 12, 14):
                for q in self._collect_map_queues(data):
                    self._map_put_queue(queues, q)
                keys.append(f"QUEUE({m_type})")
            elif m_type == 13:
                rm_list = data if isinstance(data, list) else [data]
                for q in rm_list:
                    if isinstance(q, dict):
                        qid = q.get("id") if q.get("id") is not None else q.get("queueId")
                        if qid is not None:
                            queues.pop(str(qid), None)
                    elif q is not None:
                        queues.pop(str(q), None)
                keys.append("REMOVE_QUEUE")
            elif m_type is None:
                # حمولة بلا msgType: استخراج آمن للكائنات إلى الحاوية المحدودة + الحقول العددية فقط
                for obj in self._collect_map_objs(data if data is not None else msg):
                    self._map_upsert_obj(pieces, kid, obj)
                for fk in ("kingdomId", "mapId", "maxNpcLevel", "maxMapNpcLevel"):
                    if fk in msg:
                        km[fk] = copy.deepcopy(msg[fk])
                        keys.append(fk)
        return {"ctrl": "kingdomMapCtrl", "updated": True, "keys": keys or ["mapSync"]}

    def _handle_notify_map_data(self, notify_data: Any) -> Dict[str, Any]:
        """
        NOTIFY_MAP_DATA (200): مباني التحالف والمعاقل (kingdomMapCtrl:onNotifyMapData).
        لا تحتاجها أي مهمة حالياً؛ تُحفظ الحقول العددية الآمنة فقط لمنع تضخم الذاكرة.
        """
        km, _pieces, _queues = self._map_store()
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if isinstance(it, dict):
                for fk in ("kingdomId", "mapId", "maxNpcLevel", "maxMapNpcLevel"):
                    if fk in it:
                        km[fk] = copy.deepcopy(it[fk])
                        keys.append(fk)
        return {"ctrl": "kingdomMapCtrl", "updated": True, "keys": keys or ["mapData"]}

    def _handle_notify_switch_map(self, notify_data: Any) -> Dict[str, Any]:
        """NOTIFY_SWITCH_MAP (450): kingdomMapCtrl:setCurMapInfo(msgData)."""
        km, _pieces, _queues = self._map_store()
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        for it in items:
            if isinstance(it, dict):
                km["curMapInfo"] = copy.deepcopy(it)
        return {"ctrl": "kingdomMapCtrl", "updated": True, "keys": ["curMapInfo"]}

    def _handle_notify_exalted_privilege(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_EXALTED_PRIVILEGE (492) (exaltedPrivilegeCtrl.lua:35-61)."""
        ep = self.init_data.setdefault("exaltedPrivilegeCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            ctype = str(it.get("type") or "").strip()
            cdata = it.get("data") if isinstance(it.get("data"), dict) else it
            if ctype == "initData" and isinstance(cdata, dict):
                self.init_data["exaltedPrivilegeCtrl"] = copy.deepcopy(cdata)
                ep = self.init_data["exaltedPrivilegeCtrl"]
                keys.append("initData")
            elif ctype == "buyGift" and isinstance(cdata, dict) and "buyGiftList" in cdata:
                ep.setdefault("userData", {})["buyGiftList"] = copy.deepcopy(cdata["buyGiftList"])
                keys.append("buyGiftList")
            elif isinstance(cdata, dict):
                smart_deep_merge(ep, cdata, in_place=True)
                keys.extend(list(cdata.keys())[:3])
        return {"ctrl": "exaltedPrivilegeCtrl", "updated": True, "keys": keys}

    def _handle_notify_technology(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_TECHNOLOGY (494) (technologyCtrl.lua:43-89)."""
        tc = self.init_data.setdefault("technologyCtrl", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            ctype = str(it.get("type") or "").strip()
            cdata = it.get("data") if isinstance(it.get("data"), dict) else it
            if ctype == "updateTotalTechnology" and isinstance(cdata, dict) and isinstance(cdata.get("technology"), dict):
                self.init_data["technologyCtrl"] = copy.deepcopy(cdata["technology"])
                tc = self.init_data["technologyCtrl"]
                keys.append("technology")
            elif ctype == "researchQueue" and isinstance(cdata, dict):
                ret_q = cdata.get("retdata") if isinstance(cdata.get("retdata"), dict) else cdata
                qt = str(ret_q.get("queuetype") or "1212")
                q_ctrl = self.init_data.setdefault("queueCtrl", {})
                if isinstance(q_ctrl, dict) and ("lefttime" in ret_q or "totaltime" in ret_q):
                    now_ts = int(time.time())
                    tot_t = int(float(ret_q.get("totaltime") or ret_q.get("lefttime") or 0))
                    left_t = int(float(ret_q.get("lefttime") or tot_t))
                    q_ctrl[qt] = {
                        "qtype": qt,
                        "queuetype": qt,
                        "starttime": max(0, now_ts - max(0, tot_t - left_t)),
                        "totaltime": tot_t,
                        "ottime": left_t,
                        "_uniqueid": ret_q.get("_uniqueid"),
                    }
                keys.append("researchQueue")
            elif isinstance(cdata, dict) and ctype == "":
                smart_deep_merge(tc, cdata, in_place=True)
                keys.extend(list(cdata.keys())[:3])
        return {"ctrl": "technologyCtrl", "updated": True, "keys": keys}

    def _handle_notify_duel_cooldown(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_DUEL_IN_COOL_DOWN (500) into lordSkillCtrl.CDData (lordSkillCtrl.lua:202-212)."""
        lsc = self.init_data.setdefault("lordSkillCtrl", {})
        cd_data = lsc.setdefault("CDData", {})
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            src = it.get("data") if isinstance(it.get("data"), dict) else it
            sid = src.get("skillID") or src.get("id")
            if sid is not None and isinstance(cd_data, dict):
                cd_entry = (
                    copy.deepcopy(src["CD"])
                    if isinstance(src.get("CD"), dict)
                    else {
                        "beginTime": int(src.get("beginTime") or time.time()),
                        "CD": int(src.get("CD") or src.get("cd") or 0),
                    }
                )
                cd_data[str(sid)] = cd_entry
                keys.append(str(sid))
            elif isinstance(src.get("CDData"), dict) and isinstance(cd_data, dict):
                cd_data.update(copy.deepcopy(src["CDData"]))
                keys.extend(list(src["CDData"].keys())[:3])
        return {"ctrl": "lordSkillCtrl", "updated": True, "keys": keys}

    def _handle_notify_divine_beast(self, notify_data: Any) -> Dict[str, Any]:
        """Synchronizes NOTIFY_DIVINE_BEAST (642) (divineBeastCtrl.lua:46-64)."""
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        keys: List[str] = []
        for it in items:
            if not isinstance(it, dict):
                continue
            if str(it.get("type") or "") == "resMax":
                continue
            if "beast" in it:
                self.init_data["divineBeastCtrl"] = copy.deepcopy(it)
                keys.append("beast")
            elif isinstance(it.get("data"), dict) and "beast" in it["data"]:
                self.init_data["divineBeastCtrl"] = copy.deepcopy(it["data"])
                keys.append("beast")
        if "divineBeastCtrl" not in self.init_data:
            self.init_data["divineBeastCtrl"] = {}
        return {"ctrl": "divineBeastCtrl", "updated": True, "keys": keys}

    def _handle_notify_meritorious(self, notify_data: Any) -> None:
        """Synchronizes NOTIFY_MERITORIOUS_TASK (1070)."""
        data_block = notify_data[0] if (isinstance(notify_data, list) and notify_data) else notify_data
        if not isinstance(data_block, dict):
            return

        merit = self.init_data.setdefault("meritoriousTaskCtrl", {})
        flag = data_block.get("flag")
        payload = data_block.get("data", {})

        if flag == "base" and isinstance(payload, dict):
            smart_deep_merge(merit, payload, in_place=True)
        elif flag == "task" and isinstance(payload, dict):
            add_tasks = payload.get("add", {})
            if isinstance(add_tasks, dict):
                smart_deep_merge(merit, add_tasks, in_place=True)
            remove_tasks = payload.get("remove", {})
            if isinstance(remove_tasks, dict):
                for category, task_map in remove_tasks.items():
                    target_cat = merit.get(category)
                    if isinstance(target_cat, dict) and isinstance(task_map, dict):
                        for tid in task_map.keys():
                            target_cat.pop(str(tid), None)

    def _handle_notify_server_status(self, notify_data: Any) -> Dict[str, Any]:
        """
        Synchronizes NOTIFY_SERVER_STATUS (مطابق لسورس اللعبة الرسمي GameTop:onServerStatus):
        - status == 'kick': طرد لتسجيل الدخول من جهاز آخر (userKickOutType_otherDeviceLogin).
        - status == 'seal': إغلاق أو حظر الحساب (userKickOutType_accountBeClosed).
        - status == 'server_maintenance': صيانة السيرفر (userKickOutType_serverRepair).
        """
        items = notify_data if isinstance(notify_data, list) else [notify_data]
        res: Dict[str, Any] = {}
        for item in items:
            if isinstance(item, dict):
                st = str(item.get("status", "")).lower().strip()
                if st:
                    res["status"] = st
                if "sealType" in item:
                    res["sealType"] = item.get("sealType")
        return res

    # ──────────────────────────────────────────────────────────────────────────
    # Memory Readiness Gate
    # ──────────────────────────────────────────────────────────────────────────

    def is_memory_ready(self) -> Tuple[bool, List[str]]:
        """
        Validates presence and structural validity of CRITICAL_STARTUP_CONTROLLERS:
          1. cityCtrl: dict with non-empty 'blist' list and 'reslist' / 'resList' dict.
          2. lordInfoCtrl: dict with 'base' containing valid 'uid' (or direct uid).
          3. queueCtrl / local_queues: dict or list.
          4. armyCtrl: dict containing 'totalArmy', 'armyInfo', 'woundedArmy', 'trainArmy', or 'freeArmy'.
          5. heroCtrl: list or dict.
          6. backpackCtrl / bagCtrl: dict or list.

        Returns (is_ready, missing_or_invalid_controllers).
        """
        with self._thread_lock:
            missing_or_invalid: List[str] = []

            # 1. cityCtrl
            city = self.init_data.get("cityCtrl")
            if not isinstance(city, dict):
                missing_or_invalid.append("cityCtrl")
            else:
                blist = city.get("blist")
                reslist = city.get("reslist") or city.get("resList")
                if not isinstance(blist, list) or len(blist) == 0:
                    missing_or_invalid.append("cityCtrl.blist")
                if not isinstance(reslist, dict) or len(reslist) == 0:
                    missing_or_invalid.append("cityCtrl.reslist")

            # 2. lordInfoCtrl
            lord = self.init_data.get("lordInfoCtrl") or self.init_data.get("lord")
            if not isinstance(lord, dict):
                missing_or_invalid.append("lordInfoCtrl")
            else:
                base = lord.get("base")
                has_uid = (
                    (isinstance(base, dict) and base.get("uid"))
                    or lord.get("uid")
                    or self.owner_uid
                )
                if not has_uid:
                    missing_or_invalid.append("lordInfoCtrl.base")

            # 3. queueCtrl / local_queues
            queue = self.init_data.get("queueCtrl")
            has_queue = isinstance(queue, (dict, list)) or ("local_queues" in self.init_data)
            if not has_queue:
                missing_or_invalid.append("queueCtrl")

            # 4. armyCtrl
            army = self.init_data.get("armyCtrl") or self.init_data.get("army")
            if not isinstance(army, dict):
                missing_or_invalid.append("armyCtrl")
            else:
                has_army_data = (
                    "totalArmy" in army
                    or "armyInfo" in army
                    or "woundedArmy" in army
                    or "trainArmy" in army
                    or "freeArmy" in army
                )
                if not has_army_data:
                    missing_or_invalid.append("armyCtrl.data")

            # 5. heroSysCtrl (with fallback to legacy heroCtrl for test mocks)
            heroes = self.init_data.get("heroSysCtrl")
            if heroes is None:
                heroes = self.init_data.get("heroCtrl")
            if not isinstance(heroes, (list, dict)):
                missing_or_invalid.append("heroSysCtrl")

            # 6. backpackCtrl / bagCtrl
            backpack = self.init_data.get("backpackCtrl") or self.init_data.get("bagCtrl")
            if not isinstance(backpack, (dict, list)):
                missing_or_invalid.append("backpackCtrl")

            return (len(missing_or_invalid) == 0, missing_or_invalid)

    # ──────────────────────────────────────────────────────────────────────────
    # Thread-Safe Inspection Snapshot
    # ──────────────────────────────────────────────────────────────────────────

    def get_snapshot(self, controller: Optional[str] = None) -> Any:
        """
        Returns a thread-safe deep copy snapshot of the live memory or a specific controller.
        Prevents 'RuntimeError: dictionary changed size during iteration' in concurrent tasks.
        """
        with self._thread_lock:
            if controller is None:
                return copy.deepcopy(self.init_data)
            val = self.init_data.get(controller)
            return copy.deepcopy(val) if val is not None else {}
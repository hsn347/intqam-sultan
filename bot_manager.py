# -*- coding: utf-8 -*-
"""
python bot_manager.py --email oorrnn44@gmail.com -p asdfghjkl150
"""

from __future__ import annotations

import argparse
import asyncio
import copy
import gc
import json
import logging
import os
import random
import sys
import threading
import time
from datetime import datetime
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
if _ROOT_DIR not in sys.path:
    sys.path.insert(0, _ROOT_DIR)

from core.game_client import (
    AccountSession,
    GateCredentials,
    GameConnection,
    SessionCache,
    async_login,
    ERROR_CODES,
    ConcurrentLoginError,
)
from tasks import (
    BaseTask,
    TaskResult,
    ConnectionCircuitBreakerError,
    PortTask,
    MerchantShipTask,
    TreasureTask,
    CityHarvestTask,
    TrainTask,
    ShieldTask,
    ResearchTask,
    FlowerTask,
    WonderMerchantTask,
    ImperialMausoleumTask,
    PetTask,
    MaterialSynthesisTask,
    ForgeEquipmentTask,
    CureWoundedTask,
    AllianceTask,
    WarMedalTask,
    DailyTrainTask,
    BuildingTask,
    ArenaTask,
    HeroTrialTask,
    CommandHallTask,
    DailyQuestTask,
    SkillsTask,
    MaterialWorkshopTask,
    StaminaTask,
    WatermillTask,
)

# قائمة المهام المسجلة في دورة البوت التلقائية
REGISTERED_TASKS = [
    PortTask,
    MerchantShipTask,
    ImperialMausoleumTask,
    CityHarvestTask,
    WatermillTask,
    ShieldTask,
    BuildingTask,
    ResearchTask,
    FlowerTask,
    WonderMerchantTask,
    MaterialSynthesisTask,
    MaterialWorkshopTask,
    ForgeEquipmentTask,
    CureWoundedTask,
    AllianceTask,
    WarMedalTask,
    DailyTrainTask,
    PetTask,
    TreasureTask,
    TrainTask,
    ArenaTask,
    HeroTrialTask,
    StaminaTask,
    CommandHallTask,
    SkillsTask,
    DailyQuestTask,
]

log = logging.getLogger("bot_manager")
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s][%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)

# ═════════════════════════════════════════════════════════════════════════════
# خريطة بيانات المهام (Task Metadata: Emoji & Arabic Title)
# ═════════════════════════════════════════════════════════════════════════════

TASK_METADATA: Dict[str, Tuple[str, str]] = {
    "port": ("⚓", "الميناء"),
    "merchant_ship": ("🚢", "سفينة التجار"),
    "treasure": ("🎰", "عجلة الحظ"),
    "city_harvest": ("🌾", "حصاد الموارد"),
    "train": ("⚔️", "تدريب الجنود"),
    "daily_train": ("⚔️", "التدريب اليومي"),
    "shield": ("🛡️", "درع السلام"),
    "research": ("🔬", "أبحاث الأكاديمية"),
    "building": ("🏰", "طابور البناء"),
    "flower": ("🌸", "بستان الزهور"),
    "wonder_merchant": ("👳", "تاجر العجائب"),
    "imperial_mausoleum": ("🏛️", "الضريح الإمبراطوري"),
    "pet": ("🦅", "الوحش الأليف"),
    "material_synthesis": ("💎", "دمج المواد"),
    "material_workshop": ("🧵", "ورشة المواد"),
    "forge_equipment": ("🔨", "ورشة الحدادة"),
    "cure_wounded": ("🏥", "علاج الجرحى"),
    "alliance": ("🤝", "شؤون التحالف"),
    "war_medal": ("🎖️", "ميدالية الحرب"),
    "arena": ("🏟️", "حلبة الفرسان"),
    "hero_trial": ("🗡️", "محاكمة الأبطال"),
    "stamina": ("⚡", "استهلاك الطاقة"),
    "command_hall": ("🏛️", "قاعة القيادة"),
    "daily_quest": ("📋", "المهام اليومية"),
    "skills": ("⚡", "مهارات اللورد"),
    "watermill": ("🌾", "مكافأة الحقول"),
}

# ═════════════════════════════════════════════════════════════════════════════
# 1. تصنيف المهام والإعدادات الافتراضية (Tasks Classification & Config)
# ═════════════════════════════════════════════════════════════════════════════

# المهام التلقائية الإلزامية: تعمل دائماً بدون اشتراط إذن المستخدم ما لم يعطلها صراحة
ALWAYS_AUTO_TASKS: Set[str] = {"port", "merchant_ship", "daily_sign", "city_harvest", "imperial_mausoleum", "war_medal", "daily_quest"}

# المهام الخلفية الإلزامية المطلقة: تعمل دائماً وبشكل قطعي دون أخذ رأي المستخدم ولا تقبل التعطيل
MANDATORY_CORE_TASKS: Set[str] = {"daily_quest"}

DEFAULT_BOT_CONFIG: Dict[str, Any] = {
    "enabled": True,
    "min_loop_interval_minutes": 40,   # الحد الأدنى لفاصل الدورة (40 دقيقة)
    "max_loop_interval_minutes": 60,   # الحد الأقصى لفاصل الدورة (60 دقيقة)
    "task_delay_min_seconds": 1.0,     # الفاصل الأدنى بين المهمة والتي تليها (1 ثانية)
    "task_delay_max_seconds": 3.0,     # الفاصل الأقصى بين المهمة والتي تليها (3 ثوانٍ)
    "reconnect_wait_seconds": 30,      # مدة الانتظار قبل محاولة إعادة الاتصال
    "max_reconnect_attempts": 2,       # الحد الأقصى لمحاولات إعادة الاتصال (لا يزيد عن محاولتين)
    "tasks": {
        "port": {"enabled": True},            # مهمة الميناء: تلقائية دائماً
        "merchant_ship": {"enabled": True},   # السفينة التجارية: تلقائية دائماً
        "city_harvest": {"enabled": True},    # حصاد مزارع ومناجم القلعة: تلقائية دائماً
        "imperial_mausoleum": {"enabled": True}, # إستكشاف الهرم: تلقائية إلزامية دائماً
        "war_medal": {"enabled": True},       # متجر وسام الحرب: تلقائية بالخلفية للنشاط اليومي
        "fountain": {                         # نافورة الكنوز: برأي المستخدم
            "enabled": False,
            "resources": ["food", "wood", "iron", "steel", "mithril", "crystal"],
            "gold_times": 0,
        },
        "daily_train": {                      # تدريب جنود النشاط اليومي (250 وحدة Lv.1)
            "enabled": False,
        },
        "train": {                            # تدريب الجنود: اختياري برأي المستخدم
            "enabled": False,
            "levels": {
                "infantry": 0,
                "cavalry": 0,
                "archers": 0,
                "chariots": 0,
            },
            "level": 10,
            "count": "max",
        },
        "shield": {                           # درع السلام: اختياري برأي المستخدم
            "enabled": False,
            "duration": "8h",
            "allow_gold": False,
        },
        "research": {                         # أبحاث المعهد التلقائية (الموصى بها)
            "enabled": False,
        },
        "flower": {                           # إهداء الزهور (النشاط اليومي)
            "enabled": False,
            "allow_gold": False,
        },
        "wonder_merchant": {                  # التاجر العجيب (النشاط اليومي)
            "enabled": False,
        },
        "material_synthesis": {               # تجميع المواد بورشة الحدادة (النشاط اليومي)
            "enabled": False,
        },
        "forge_equipment": {                  # تصنيع العتاد بورشة الحدادة (النشاط اليومي)
            "enabled": False,
            "category": "weapon",
        },
        "cure_wounded": {                     # علاج المصابين بالخيمة الطبية (النشاط اليومي)
            "enabled": False,
            "mode": "daily",                  # "daily" (إتمام المهمة اليومية 500 جندي) أو "all" (علاج الكل)
        },
        "pet": {                              # مهمة الحيوان: استلام الجوائز والإطعام المجاني
            "enabled": False,
            "target_pet": 1256,
        },
        "alliance": {
            "enabled": False,
        },
        "building": {                         # ترقية القلعة والمباني المتقدمة
            "enabled": False,
            "upgrade_castle": True,
            "speedup_castle": False,
            "auto_open_chests": True,
            "upgrade_support_buildings": True,
            "target_buildings": {
                "farm": True,
                "sawmill": True,
                "iron_mine": True,
                "quartz_mine": True,
                "hospital": True,
                "military_tent": True,
            },
        },
        "arena": {                            # تحدي الحلبة: مهام النشاط اليومي واستلام الجوائز التراكمية
            "enabled": False,
            "arena_type": "kingdom",          # "kingdom" (حلبة المملكة) أو "global" (حلبة العالم)
            "auto_claim_rewards": True,       # استلام جوائز الترتيب التراكمية تلقائياً
        },
        "hero_trial": {                       # كفاءة الجندي: مهمة النشاط اليومي رقم 25 (20 نقطة)
            "enabled": False,
        },
        "command_hall": {                     # مهام قاعة القيادة: المعارك والمسير واستلام الجوائز
            "enabled": False,
            "mode": "daily",                  # "daily" أو "full"
            "allow_marches": True,            # السماح بالمسير القتالي
            "allow_snipe": True,              # السماح بمهام القناص الصامت
            "allow_rescue": True,             # السماح بمهام إنقاذ القرويين
            "allow_dialogue": True,           # السماح بمهام المعلومات العسكرية
            "allow_army_group": True,         # القضاء على فيلق الغزاة وتجديد المهام تلقائياً
            "auto_claim_rewards": True,       # استلام جوائز المهام المكتملة
            "auto_upgrade_hall": True,        # ترقية مستوى قاعة القيادة تلقائياً
            "min_safety_stamina": 10,         # حد أمان طاقة اللورد بالقلعة
        },
        "daily_quest": {                      # استلام صناديق النشاط اليومي (إلزامية وتلقائية)
            "enabled": True,
        },
        "watermill": {                        # مكافأة الطاحونة (زيادة إنتاج الموارد: قمح، خشب، حديد، فضة، بلور)
            "enabled": False,
            "resources": ["food", "wood", "iron", "silver", "crystal"],
            "types": "all",
        },
        "skills": {                           # مهارات الأمير الـ 16 (تفعيل المواهب النشطة التلقائية)
            "enabled": False,
            "target_skills": [],
        },
        "material_workshop": {                # معمل المواد: تكرير المواد تلقائياً
            "enabled": False,
            "selected_materials": [200101, 200201, 200301, 200401, 200501, 200601],
        },
        "stamina": {                          # تعويض طاقة اللورد
            "enabled": False,
            "gold_buy_enabled": False,        # السماح بالشراء بالذهب عند نفاذ الحزم المجانية
            "gold_trigger_stamina": 50,       # سقف طاقة القلعة لتفعيل الشراء بالذهب
            "gold_buy_stamina_amount": 50,    # كمية الطاقة للشراء في المرة الواحدة بالذهب
        },
    }
}

# ═════════════════════════════════════════════════════════════════════════════
# 2. كلاس إدارة حساب واحد (CastleBot)
# ═════════════════════════════════════════════════════════════════════════════

class CastleBot:
    """
    يدير دورة حياة حساب قلعة واحد بشكل مستقل وغير متزامن (Async):
    - بدء وإيقاف الاتصال.
    - تنفيذ دورات العمل والانتظار.
    - استخراج الحالة اللحظية (Live Info) للـ API أو واجهة المستخدم.
    """

    def __init__(
        self,
        email: str,
        password: Optional[str] = None,
        config: Optional[Dict[str, Any]] = None,
        log_callback: Optional[Callable[[str], None]] = None,
        stop_event: Optional[threading.Event] = None,
    ):
        self.email = email
        self.password = password
        self.config = copy.deepcopy(DEFAULT_BOT_CONFIG)

        # تحميل إعدادات الحساب وتفضيلات المستخدم المحفوظة في قاعدة البيانات
        self.reload_config_from_db()

        if config:
            if "tasks" in config and isinstance(config["tasks"], dict):
                self.config.setdefault("tasks", {}).update(config["tasks"])
            for k, v in config.items():
                if k != "tasks":
                    self.config[k] = v
                    if k in self.config.get("tasks", {}):
                        self.config["tasks"][k] = v

        self._log_callback = log_callback
        self._stop_event = stop_event or threading.Event()
        self._async_stop = asyncio.Event()

        # بيانات الجلسة والاتصال
        self.account: Optional[AccountSession] = None
        self.conn: Optional[GameConnection] = None
        self.creds: Optional[GateCredentials] = None

        # متغيرات الحالة اللحظية (Live Monitoring State)
        self.is_running: bool = False
        self.is_sealed: bool = False
        self.is_password_error: bool = False
        self.seal_reason: str = ""
        self.conn_state: str = "initialized"   # initialized, starting, connected, waiting, disconnected, sealed, stopped
        self.status_message: str = "تمت التهيئة"
        self.start_time: float = 0.0
        self.last_activity_time: float = 0.0
        self.iteration: int = 0
        self.next_run_time: Optional[str] = None
        self.last_kick_reason: str = ""
        self.reconnect_attempt: int = 0

    @property
    def short_name(self) -> str:
        """اسم الحساب المختصر النظيف بدون نطاق الإيميل"""
        em = str(self.email)
        return em.split("@")[0] if "@" in em else em

    def log_brief(self, line: str, print_to_term: bool = True):
        """
        طباعة سطر موجز ومباشر في التيرمنال وتمريره لموجه السجلات
        مع إيموجي وعلامة النجاح أو الفشل وبدون إغراق أو تكرار
        """
        if print_to_term:
            print(line, flush=True)
        if self._log_callback:
            try:
                self._log_callback(line)
            except Exception:
                pass

    def log(self, message: str):
        """طباعة السجلات وتمريرها لموجه السجلات أو واجهة الـ API إن وجدت"""
        formatted = f"[{self.email}] {message}"
        if self._log_callback:
            try:
                self._log_callback(formatted)
            except Exception:
                pass
        print(f"[{datetime.now().strftime('%H:%M:%S')}] {formatted}", flush=True)

    def reload_config_from_db(self):
        """إعادة تحميل إعدادات وتفضيلات الحساب المحدثة من قاعدة البيانات فوراً."""
        try:
            import core.database as db
            c_data = db.get_castle_by_id(self.email)
            if not c_data or not c_data.get("config"):
                return
            saved_cfg = c_data["config"] if isinstance(c_data["config"], dict) else json.loads(c_data["config"])
            if not isinstance(saved_cfg, dict):
                return

            tasks_cfg = self.config.setdefault("tasks", {})
            # قراءة أي إعدادات سابقة من كائن tasks الفرعي أولاً كقاعدة أولية
            if "tasks" in saved_cfg and isinstance(saved_cfg["tasks"], dict):
                tasks_cfg.update(saved_cfg["tasks"])

            # إعدادات المهام المباشرة في جذر config هي صاحبة الأولوية المطلقة (تعديلات المستخدم في الواجهة)
            for t_name in ("fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "material_workshop", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "arena", "hero_trial", "command_hall", "daily_quest", "watermill", "skills", "stamina"):
                if t_name in saved_cfg:
                    tasks_cfg[t_name] = saved_cfg[t_name]

            # ضمان وجود وتفعيل مهمة صناديق النشاط اليومي الإلزامية دائماً
            tasks_cfg.setdefault("daily_quest", {"enabled": True})

            for k, v in saved_cfg.items():
                if k not in ("tasks", "fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "material_workshop", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "arena", "hero_trial", "command_hall", "daily_quest", "watermill", "skills", "stamina"):
                    self.config[k] = v
        except Exception:
            pass

    def _set_state(self, state: str, message: str, next_run: Optional[str] = None):
        self.conn_state = state
        self.status_message = message
        self.last_activity_time = time.time()
        self.next_run_time = next_run
        try:
            import core.database as db
            db.upsert_castle_conn_state(
                self.email,
                conn_state=self.conn_state,
                state="running" if self.is_running else ("error" if state == "error" else ("sealed" if state == "sealed" else "idle")),
                status_message=self.status_message,
                next_run_time=self.next_run_time or ""
            )
        except Exception:
            pass

    def get_live_info(self) -> Dict[str, Any]:
        """استخراج بيانات التشغيل اللحظية الحية في الذاكرة (لربطها بـ api_server)"""
        now = time.time()
        uptime_sec = int(now - self.start_time) if self.start_time > 0 else 0
        return {
            "email": self.email,
            "conn_state": self.conn_state,
            "status_message": self.status_message,
            "is_running": self.is_running,
            "is_sealed": self.is_sealed,
            "is_password_error": self.is_password_error,
            "seal_reason": self.seal_reason,
            "uptime_seconds": uptime_sec,
            "iteration": self.iteration,
            "next_run_time": self.next_run_time,
            "last_activity": datetime.fromtimestamp(self.last_activity_time).strftime("%H:%M:%S") if self.last_activity_time else None,
            "gate_info": {
                "uid": self.creds.uid if self.creds else None,
                "kingdom_id": self.creds.kingdom_id if self.creds else None,
                "server_name": self.creds.server_name if self.creds else None,
                "gate_ip": self.creds.gate_ip if self.creds else None,
            } if self.creds else None,
            "reconnect_attempt": self.reconnect_attempt,
        }

    async def connect(self) -> bool:
        """تحميل الجلسة والمصادقة والاتصال بمقبس البوابة الرسمي"""
        self._set_state("starting", "جاري قراءة الجلسة والمصادقة...")

        # قراءة بيانات الحساب من session_cache.json
        user_id, session_id, matched_email = SessionCache.get_account(self.email)
        if not user_id or not session_id:
            pwd = self.password
            if not pwd:
                try:
                    import core.database as db
                    c_data = db.get_castle_by_id(self.email)
                    if c_data and c_data.get("password"):
                        pwd = c_data["password"]
                except Exception:
                    pass

            if pwd:
                self.log("جاري توثيق الحساب عبر خادم SDK بكلمة المرور...")
                from core.game_client import sdk_login, get_account_device_profile
                # يجب تمرير device_id لضمان تطابق بصمة الجهاز بين SDK وخادم الدخول
                _prof = get_account_device_profile(self.email)
                auth_res = sdk_login(self.email, pwd, device_id=_prof["deviceId"])
                if auth_res.get("success"):
                    user_id = auth_res["userId"]
                    session_id = auth_res["sessionId"]
                    matched_email = self.email
                    SessionCache.set_account(
                        self.email, user_id, session_id,
                        device_id=_prof["deviceId"],
                        model=_prof["model"],
                        os_version=_prof["osVersion"]
                    )
                    self.log("✓ تم توثيق الحساب بنجاح واستخراج الجلسة.")
                else:
                    is_pwd = auth_res.get("is_password_error") or "PASSWORD" in str(auth_res.get("error_code", "")).upper() or "EMAIL_NOT_EXISTS" in str(auth_res.get("error_code", "")).upper() or "كلمة" in str(auth_res.get("error_msg", ""))
                    if is_pwd:
                        self.is_password_error = True
                        self.is_running = False
                        msg = auth_res.get("error_msg") or "كلمة المرور غير صحيحة"
                        self.log(f"🛑 [خطأ كلمة المرور] {msg} — تم إيقاف البوت فوراً وبشكل نهائي لحماية الحساب من الحظر.")
                        self._set_state("error", msg)
                        try:
                            import core.database as db
                            db.upsert_castle_conn_state(
                                castle_id=self.email,
                                conn_state="error",
                                state="error",
                                status_message=msg,
                            )
                        except Exception:
                            pass
                        return False

                    msg = f"فشلت مصادقة الحساب: {auth_res.get('error_msg')} (كود: {auth_res.get('error_code')})"
                    self.log(f"[-] {msg}")
                    self._set_state("error", msg)
                    return False
            else:
                msg = f"الحساب غير مسجل في session_cache.json ولا تتوفر كلمة المرور!"
                self.log(f"[-] {msg}")
                self._set_state("error", msg)
                return False

        self.account = AccountSession(
            email=matched_email or self.email,
            user_id=user_id,
            session_id=session_id,
            password=self.password  # ← ضروري لتجديد التوكن تلقائياً عند 504
        )

        # المصادقة مع خادم تسجيل الدخول عبر تبادل مفاتيح DH (بحد أقصى محاولتين)
        self.log("جاري الاتصال بخادم تسجيل الدخول...")
        creds = await async_login(self.account)
        if not creds:
            if self.account and getattr(self.account, "is_password_error", False):
                self.is_password_error = True
                self.is_running = False
                msg = getattr(self.account, "error_msg", "") or getattr(self.account, "auth_error_msg", "") or "كلمة المرور غير صحيحة"
                self.log(f"🛑 [خطأ كلمة المرور] {msg} — تم إيقاف البوت فوراً وبشكل نهائي لحماية الحساب من الحظر.")
                self._set_state("error", msg)
                try:
                    import core.database as db
                    db.upsert_castle_conn_state(
                        castle_id=self.email,
                        conn_state="error",
                        state="error",
                        status_message=msg,
                    )
                except Exception:
                    pass
                return False

            if self.account and self.account.is_sealed:
                self.is_sealed = True
                self.seal_reason = self.account.seal_reason
                msg = f"❌ [حساب محظور] الحساب مجمد أو محظور من إدارة اللعبة: {self.seal_reason}"
                self.log(msg)
                self._set_state("sealed", msg)
                try:
                    import core.database as db
                    db.upsert_castle_conn_state(
                        castle_id=self.email,
                        conn_state="sealed",
                        state="stopped",
                        status_message=msg,
                    )
                except Exception:
                    pass
                return False

            msg = "فشلت المصادقة مع خادم تسجيل الدخول (Login Handshake Failed)"
            self.log(f"[-] {msg}")
            self._set_state("disconnected", msg)
            return False

        self.creds = creds
        self.log(f"✓ تم استخراج البوابة ({creds.gate_ip}:{creds.gate_port}) للمملكة {creds.kingdom_id} (UID={creds.uid})")

        if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set():
            return False

        # إغلاق أي اتصال مقبس قديم بأمان لمنع بقاء مهام استماع معلقة في الذاكرة
        if self.conn:
            try:
                await self.conn.close()
            except Exception:
                pass
            self.conn = None

        # فتح اتصال البوابة غير المتزامن بـ asyncio
        self.conn = GameConnection(self.account, creds)
        self.conn.notify_log_callback = self.log
        self.conn.brief_log_callback = lambda line: self.log_brief(line, print_to_term=False)
        if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set():
            if self.conn:
                await self.conn.close()
                self.conn = None
            return False

        ok = await self.conn.connect()
        if not ok:
            if getattr(self.conn, "is_other_device", False):
                return False
            msg = "فشلت مصافحة خادم البوابة (Gate Handshake Failed)"
            self.log(f"[-] {msg}")
            self._set_state("disconnected", msg)
            return False

        # انتظار اكتمال تفريغ متحكمات القلعة في الذاكرة الحية (CMD 1000)
        try:
            await asyncio.wait_for(self.conn.controllers_ready.wait(), timeout=12.0)
        except asyncio.TimeoutError:
            msg = "فشل تحميل متحكمات القلعة بعد الاتصال (Timeout 12s) — قطع الاتصال بأمان لحماية الحساب من الحظر."
            self.log(f"⚠️ {msg}")
            if self.conn:
                await self.conn.close()
            self._set_state("error", msg)
            return False

        self._set_state("connected", f"متصل بالبوابة بنجاح (المملكة {creds.kingdom_id})")
        self.log(f"👑 تم الاتصال بالبوابة بنجاح! الحساب نشط الآن 100%.")
        self.sync_live_data_to_db()
        return True

    def sync_live_data_to_db(self):
        """استخراج فوري (0 استهلاك شبكي) للموارد والصورة والبيانات وحفظها في SQLite"""
        if not self.conn or not getattr(self.conn, "init_data", None):
            return
        try:
            data = self.conn.init_data
            lord = data.get("lordInfoCtrl", {})
            base = (lord.get("base") or {}) if isinstance(lord, dict) else {}
            fc = (lord.get("fcInfo") or {}) if isinstance(lord, dict) else {}
            city = data.get("cityCtrl", {})
            res_raw = city.get("resList", {}) or city.get("reslist", {}) if isinstance(city, dict) else {}
            safe_raw = city.get("saferes", {}) if isinstance(city, dict) else {}

            gold = int(base.get("gold", 0))
            food = int(float(res_raw.get("1002", res_raw.get("food", 0))))
            wood = int(float(res_raw.get("1003", res_raw.get("wood", 0))))
            iron = int(float(res_raw.get("1004", res_raw.get("iron", 0))))
            steel = int(float(res_raw.get("1006", res_raw.get("steel", 0))))
            mithril = int(float(res_raw.get("1005", res_raw.get("mithril", 0))))
            crystal = int(float(res_raw.get("1027", res_raw.get("crystal", 0))))
            stamina = int(base.get("health", 100))

            safe_food = int(float(safe_raw.get("1002", 0)))
            safe_wood = int(float(safe_raw.get("1003", 0)))
            safe_iron = int(float(safe_raw.get("1004", 0)))
            safe_silver = int(float(safe_raw.get("1005", 0)))
            safe_crystal = int(float(safe_raw.get("1027", 0)))

            resources = {
                "food": food,
                "wood": wood,
                "iron": iron,
                "silver": mithril,
                "mithril": mithril,
                "steel": steel,
                "crystal": crystal,
                "diamond": crystal,
                "gold": gold,
                "stamina": stamina,
                "unprotected_food": max(0, food - safe_food),
                "unprotected_wood": max(0, wood - safe_wood),
                "unprotected_iron": max(0, iron - safe_iron),
                "unprotected_silver": max(0, mithril - safe_silver),
                "unprotected_diamond": max(0, crystal - safe_crystal),
                "safe_food": safe_food,
                "safe_wood": safe_wood,
                "safe_iron": safe_iron,
                "safe_silver": safe_silver,
                "safe_diamond": safe_crystal,
            }

            # 1. استخراج مستوى قصر القلعة الحقيقي من cityCtrl['blist'] (المبنى bid == 101)
            c_lv = int(city.get("level", 1) or 1) if isinstance(city, dict) else 1
            blist = city.get("blist", []) if isinstance(city, dict) else []
            if isinstance(blist, list):
                for b in blist:
                    if isinstance(b, dict):
                        binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
                        if str(binfo.get("bid", "")) == "101":
                            c_lv = int(binfo.get("lv", c_lv))
                            break

            # 2. استخراج القوة القتالية الكلية من lordInfoCtrl['fcInfo']['totalFc']
            power = int(fc.get("totalFc", 0) or base.get("power", 0) or base.get("totalFc", 0))

            # 3. إحداثيات القلعة
            cinfo = city.get("cinfo", {}) if isinstance(city, dict) else {}
            pos = cinfo.get("pos", {}) if isinstance(cinfo, dict) else {}
            coord_x = int(pos.get("x", 0)) if pos.get("x") else 0
            coord_y = int(pos.get("y", 0)) if pos.get("y") else 0

            lord_name = base.get("nickName") or base.get("name") or f"قلعة {self.email.split('@')[0]}"
            alliance = data.get("allianceCtrl", {}) if isinstance(data.get("allianceCtrl"), dict) else {}
            alliance_name = alliance.get("allianceName") or base.get("alliancename") or ""

            castle_info = {
                "lord_name": lord_name,
                "castle_name": f"قلعة {lord_name}",
                "castle_level": c_lv,
                "lord_level": int(base.get("level", 1)),
                "power": power,
                "lord_power": power,
                "gold": gold,
                "imageId": base.get("imageId", ""),
                "avatar": base.get("avatar", ""),
                "server_id": self.creds.kingdom_id if self.creds else None,
                "alliance_name": alliance_name,
                "coordinates": {"x": coord_x, "y": coord_y},
                "coord_x": coord_x,
                "coord_y": coord_y,
                "uid": self.creds.uid if self.creds else None,
            }

            import core.database as db
            db.update_castle_live_snapshot(
                self.email,
                resources=resources,
                castle_info=castle_info,
                castle_name=f"قلعة {lord_name}"
            )
            self.log(f"📊 [الذاكرة الحية] تم تحديث بيانات وموارد وصورة القلعة ({lord_name} - Lv.{c_lv}) في قاعدة البيانات.")
        except Exception as e:
            self.log(f"⚠️ خطأ أثناء حفظ لقطة الذاكرة الحية: {e}")

    # ═════════════════════════════════════════════════════════════════════════
    # خط أنابيب المهام التلقائي (Automated Tasks Pipeline)
    # ═════════════════════════════════════════════════════════════════════════

    async def execute_tasks(self):
        """
        تشغيل كافة المهام المسجلة في REGISTERED_TASKS تلقائياً:
        - لا حاجة لتعديل هذه الدالة عند إضافة أي مهمة جديدة مستقبلاً.
        - تفحص رغبة المستخدم صراحة لكل مهمة قبل الاستدعاء.
        - تدير قياس الزمن، عزل الأخطاء، وحماية الذاكرة ذاتياً.
        """
        self.reload_config_from_db()
        self.log("⚡ [المهام] بدء دورة الفحص والتنفيذ...")
        tasks_config = self.config.get("tasks", {})
        task_delay_min = float(self.config.get("task_delay_min_seconds", 1.0))
        task_delay_max = float(self.config.get("task_delay_max_seconds", 3.0))
        executed_count = 0

        for task_cls in REGISTERED_TASKS:
            t_name = getattr(task_cls, "name", task_cls.__name__)
            is_auto = t_name in ALWAYS_AUTO_TASKS
            alias = getattr(task_cls, "alias", "")
            t_cfg = tasks_config.get(t_name) or (tasks_config.get(alias) if alias else None) or self.config.get(t_name) or {}

            # فحص قرار المستخدم صراحة في bot_manager قبل استدعاء ملف المهمة:
            # - المهام الإلزامية المطلقة (مثل صناديق النشاط): تعمل دائماً دون أخذ رأي المستخدم ولا تُعطل
            # - المهام التلقائية (مثل الميناء): تعمل تلقائياً ما لم يطلب المستخدم إيقافها
            # - المهام الاختيارية (مثل نافورة الكنوز): لا تعمل إطلاقاً إلا إذا وافق المستخدم صراحة
            if t_name in MANDATORY_CORE_TASKS or (alias and alias in MANDATORY_CORE_TASKS):
                is_user_enabled = True
            else:
                default_enabled = True if is_auto else False
                is_user_enabled = t_cfg.get("enabled", default_enabled)

            if not is_user_enabled:
                self.log(f"⏭️ [{t_name}] تم التخطي (معطلة وفق رغبة المستخدم في الإعدادات).")
                continue

            # ⚡ قاطع الاتصال المركزي (Central Connection Circuit Breaker):
            # التحقق الصارم من حيوية الاتصال قبل بدء أي مهمة لتفادي تشغيل المهام على مقبس ميت
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log(f"⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال قبل بدء مهمة [{t_name}] — تفعيل قاطع الاتصال وإيقاف دورة المهام فوراً.")
                raise ConnectionCircuitBreakerError(f"انقطع الاتصال بالبوابة قبل تنفيذ مهمة [{t_name}]")

            # فاصل زمني بشري عشوائي بين المهمة والتي تليها (من 1 إلى 3 ثوانٍ)
            if executed_count > 0 and task_delay_max > 0:
                delay_sec = round(random.uniform(task_delay_min, task_delay_max), 2)
                await asyncio.sleep(delay_sec)

            # تشغيل المهمة وتفريغ كائنها فوراً بعد الانتهاء
            try:
                task_instance = task_cls(self.conn, self.log, t_cfg)
                res = await task_instance.safe_execute()
                executed_count += 1
                emoji, title = TASK_METADATA.get(t_name, ("📌", t_name))
                short_acc = self.short_name
                if res.skipped:
                    msg = f": {res.message}" if res.message else ""
                    self.log_brief(f"{emoji} [{short_acc}] {title}{msg} ⏭️")
                elif res.success:
                    msg = f": {res.message}" if res.message else ""
                    self.log_brief(f"{emoji} [{short_acc}] {title}{msg} ✅")
                else:
                    msg = f": {res.message}" if res.message else ""
                    self.log_brief(f"{emoji} [{short_acc}] {title}{msg} ❌")
            except ConcurrentLoginError:
                raise
            except ConnectionCircuitBreakerError as cbe:
                emoji, title = TASK_METADATA.get(t_name, ("📌", t_name))
                self.log_brief(f"⚡ [{self.short_name}] قاطع الاتصال: انقطع الاتصال أثناء {title} — إيقاف دورة المهام فوراً 🔌")
                raise
            except Exception as e:
                emoji, title = TASK_METADATA.get(t_name, ("📌", t_name))
                self.log_brief(f"{emoji} [{self.short_name}] {title}: خطأ ({e}) ❌")
            finally:
                # تحرير مرجع الكائن فوراً لضمان عدم تراكم الذاكرة
                task_instance = None
                res = None

            # فحص فوري بعد تنفيذ المهمة للتأكد من استمرار الاتصال قبل الانتقال للمهمة التالية
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log(f"🛑 [المهام] قاطع الاتصال: انقطع الاتصال أثناء تنفيذ [{t_name}] — إيقاف باقي دورة المهام فوراً.")
                if self.conn and getattr(self.conn, "is_other_device", False):
                    raise ConcurrentLoginError("تم رصد تسجيل دخول للقلعة من جهاز آخر (KICK / Concurrent Login)")
                raise ConnectionCircuitBreakerError(f"انقطع الاتصال بالبوابة أثناء تنفيذ مهمة [{t_name}]")

        self.log("✓ [المهام] اكتملت الدورة بنجاح.")
        self.sync_live_data_to_db()

    async def run(self):
        """الحلقة الرئيسية للتشغيل المستمر مع ضمان التنظيف الحتمي عند الإلغاء (Main Lifecycle Loop)"""
        self.is_running = True
        self.conn_state = "starting"
        self.start_time = time.time()
        self._async_stop.clear()

        reconnect_wait = int(self.config.get("reconnect_wait_seconds", 30))
        # فرض عدم تجاوز محاولتين كحد أقصى في أي حال
        max_reconnect = min(int(self.config.get("max_reconnect_attempts", 2)), 2)

        self.log(f"🚀 انطلقت حلقة تشغيل البوت (أقصى محاولات إعادة اتصال: {max_reconnect}).")

        try:
            while self.is_running and not self._stop_event.is_set() and not self._async_stop.is_set():
                self.iteration += 1
                self.log(f"\n{'═' * 55}\n  🔄 بدء الدورة رقم #{self.iteration}\n{'═' * 55}")

                # 1. الاتصال باللعبة إن لم يكن متصلاً
                if not self.conn or not self.conn.is_connected:
                    ok = await self.connect()
                    if not ok:
                        if getattr(self, "is_password_error", False) or (self.conn_state == "error" and ("كلمة" in self.status_message or "password" in self.status_message.lower())):
                            self.log("🛑 تم إيقاف تشغيل البوت نهائياً بسبب خطأ في كلمة المرور — يرجى تصحيح كلمة المرور من واجهة المستخدم.")
                            self.is_running = False
                            break

                        if self.is_sealed or self.conn_state == "sealed":
                            self.log("🛑 الحساب محظور نهائياً من اللعبة — إيقاف تشغيل البوت فوراً وبدون أي محاولات إعادة اتصال.")
                            break

                        if getattr(self.conn, "is_other_device", False):
                            await self.handle_concurrent_login()
                            continue

                        self.reconnect_attempt += 1
                        if self.reconnect_attempt >= max_reconnect:
                            self.log(f"🛑 تم استنفاد الحد الأقصى لمحاولات إعادة الاتصال ({max_reconnect}). إيقاف البوت لحماية الحساب.")
                            self._set_state("error", "فشل الاتصال بعد محاولتين")
                            break
                        wait_t = reconnect_wait + random.randint(2, 5)
                        self.log(f"⏳ إعادة المحاولة ({self.reconnect_attempt}/{max_reconnect}) بعد {wait_t} ثانية...")
                        self._set_state("reconnecting", f"إعادة الاتصال خلال {wait_t} ثانية...")
                        await asyncio.sleep(wait_t)
                        continue

                    self.reconnect_attempt = 0

                # 2. تنفيذ المهام النشطة
                try:
                    await self.execute_tasks()
                except ConcurrentLoginError:
                    await self.handle_concurrent_login()
                    continue
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض دورة المهام بواسطة قاطع الاتصال: {e}")
                    if self.conn and getattr(self.conn, "is_other_device", False):
                        await self.handle_concurrent_login()
                        continue
                    self.log("🔄 جاري تنظيف المقبس والاستعداد لإعادة الاتصال الآمنة...")
                    if self.conn:
                        try:
                            await self.conn.close()
                        except Exception:
                            pass
                        self.conn = None

                    # حماية من محاولات إعادة الاتصال السريعة المتتالية (Ban Prevention)
                    self.reconnect_attempt += 1
                    if self.reconnect_attempt >= max_reconnect:
                        self.log(f"🛑 تم استنفاد الحد الأقصى لمحاولات إعادة الاتصال بعد قاطع الاتصال ({max_reconnect}). إيقاف البوت مؤقتاً لحماية الحساب.")
                        self._set_state("error", "انقطع الاتصال بالسيرفر وتكرر فشل استعادة الجلسة")
                        break

                    backoff_delay = min(reconnect_wait, random.randint(5, 12))
                    self.log(f"⏳ تهدئة واستعادة الاتصال ({self.reconnect_attempt}/{max_reconnect}) بعد {backoff_delay} ثانية...")
                    self._set_state("reconnecting", f"إعادة الاتصال بعد قاطع الاتصال خلال {backoff_delay} ثانية...")
                    # الحفاظ على رقم الدورة الحالي حتى لا تتزايد الدورات خلال الاستعادة
                    self.iteration = max(0, self.iteration - 1)
                    await asyncio.sleep(backoff_delay)
                    continue
                except asyncio.CancelledError:
                    raise
                except Exception as e:
                    self.log(f"⚠️ خطأ أثناء تنفيذ دورة المهام: {e}")

                # فحص قاطع الاتصال بعد دورة المهام: إذا انقطع الاتصال أو تم طرد الحساب
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    if self.conn and getattr(self.conn, "is_other_device", False):
                        await self.handle_concurrent_login()
                        continue
                    self.log("⚠️ انقطع اتصال البوابة بعد دورة المهام — الانتقال لإعادة الاتصال الآمنة.")
                    if self.conn:
                        try:
                            await self.conn.close()
                        except Exception:
                            pass
                        self.conn = None
                    self.reconnect_attempt += 1
                    if self.reconnect_attempt >= max_reconnect:
                        self.log(f"🛑 تم استنفاد الحد الأقصى لمحاولات إعادة الاتصال ({max_reconnect}). إيقاف البوت مؤقتاً لحماية الحساب.")
                        self._set_state("error", "انقطع الاتصال بالسيرفر بعد دورة المهام")
                        break
                    backoff_delay = min(reconnect_wait, random.randint(5, 12))
                    self.iteration = max(0, self.iteration - 1)
                    await asyncio.sleep(backoff_delay)
                    continue

                # 3. إغلاق اتصال البوابة بأمان وتفريغ ذاكرة القلعة قبل النوم (40-60 دقيقة)
                # يرسل إشعار الخروج الرسمي (1037/2 switch=False) ويوقف الـ Heartbeat ويمسح init_data
                if self.conn:
                    try:
                        await self.conn.close()
                    except Exception:
                        pass
                    self.conn = None

                # تنظيف صريح لمجمّع الذاكرة بعد تحرير كائن الاتصال وبيانات القلعة
                try:
                    gc.collect()
                except Exception:
                    pass

                # 4. حساب موعد الدورة القادمة والانتظار (عشوائي بين 40 إلى 60 دقيقة)
                min_m = int(self.config.get("min_loop_interval_minutes", 40))
                max_m = int(self.config.get("max_loop_interval_minutes", 60))
                if min_m > max_m:
                    min_m, max_m = max_m, min_m
                sleep_duration = random.randint(min_m * 60, max_m * 60)
                next_ts = time.time() + sleep_duration
                next_iso = datetime.fromtimestamp(next_ts).isoformat()
                next_dt = datetime.fromtimestamp(next_ts).strftime("%H:%M:%S")
                wait_minutes = round(sleep_duration / 60, 1)

                self._set_state(
                    "waiting",
                    f"انتظار الدورة (متبقي {int(wait_minutes)} دقيقة - الساعة {next_dt})",
                    next_run=next_iso
                )
                self.log(f"😴 انتهت الدورة. الدورة التالية #{self.iteration + 1} في تمام الساعة [{next_dt}] (بعد {int(wait_minutes)} دقيقة)...")

                # انتظار هادئ بدون استهلاك للمعالج (Zero CPU Wait) وقابل للمقاطعة الفورية عند طلب الإيقاف
                try:
                    await asyncio.wait_for(self._async_stop.wait(), timeout=float(sleep_duration))
                except (asyncio.TimeoutError, TimeoutError):
                    pass
        except asyncio.CancelledError:
            self.log("🛑 تم استلام إشارة إلغاء المهمة الرئيسية للبوت.")
        except Exception as e:
            self.log(f"⚠️ خطأ غير متوقع في الحلقة الرئيسية: {e}")
        finally:
            # تنظيف حتمي لا يفشل أبداً حتى عند مقاطعة الكود
            await self.stop()

    async def handle_concurrent_login(self):
        """
        التعامل مع رصد تسجيل الدخول من جهاز آخر (404 User Not Found):
        1. إغلاق مقبس الاتصال فوراً لإعطاء اللاعب البشري الأولوية والتحكم الكامل بالقلعة.
        2. ضبط حالة كارد القلعة في لوحة التحكم وقاعدة البيانات إلى 'disconnected' (دخول من جهاز آخر).
        3. التوقف الكامل والهدوء لمدة 4 دقائق (240 ثانية) مع إمكانية مقاطعة الانتظار فوراً إذا طلب المستخدم إيقاف البوت.
        4. فحص استعادة الاتصال بعد انقضاء الـ 4 دقائق بهدوء تام دون أي حرب طرد للجلسات.
        """
        if self.conn:
            try:
                await self.conn.close()
            except Exception:
                pass

        wait_seconds = 240  # 4 دقائق كاملة
        next_ts = time.time() + wait_seconds
        next_iso = datetime.fromtimestamp(next_ts).isoformat()
        next_dt = datetime.fromtimestamp(next_ts).strftime("%H:%M:%S")

        # ضبط الحالة على 'disconnected' لتعكس كارد القلعة في الواجهة شارة "دخول من جهاز آخر" مباشرة
        self._set_state(
            "disconnected",
            f"دخول من جهاز آخر: تم تعليق البوت لمدة 4 دقائق لمنح اللاعب التحكم الكامل (استئناف الساعة {next_dt})",
            next_run=next_iso
        )
        self.log("⚠️ تم رصد تسجيل دخول للقلعة من جهاز آخر (404 User Not Found).")
        self.log(f"⏸️ سيتم إيقاف البوت مؤقتاً لمدة 4 دقائق للسماح للمستخدم باللعب بحرية تامة دون أي فصل (العودة في [{next_dt}])...")

        try:
            await asyncio.wait_for(self._async_stop.wait(), timeout=float(wait_seconds))
        except (asyncio.TimeoutError, TimeoutError):
            pass

        if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set():
            return

        self.log("🔄 انتهت فترة الانتظار (4 دقائق). جاري فحص استعادة الاتصال بالقلعة...")
        if self.conn:
            self.conn.is_other_device = False

    async def stop(self):
        """إيقاف البوت بأمان وإغلاق كافة مقابس الاتصال وتفريغ الموارد"""
        if not self.is_running and self.conn_state == "stopped":
            return
        self.is_running = False
        self._async_stop.set()
        self.log("🛑 جاري إيقاف البوت وفصل الاتصال...")
        if self.conn:
            try:
                await self.conn.close()
            except Exception:
                pass
            self.conn = None
        self.account = None
        self.creds = None
        try:
            gc.collect()
        except Exception:
            pass
        if getattr(self, "is_password_error", False):
            self.conn_state = "error"
            try:
                import core.database as db
                db.upsert_castle_conn_state(
                    self.email,
                    conn_state="error",
                    state="error",
                    status_message=self.status_message or "كلمة المرور غير صحيحة",
                )
            except Exception:
                pass
        elif getattr(self, "is_sealed", False) or self.conn_state == "sealed":
            self.conn_state = "sealed"
            try:
                import core.database as db
                db.upsert_castle_conn_state(
                    self.email,
                    conn_state="sealed",
                    state="stopped",
                    status_message=self.status_message or "الحساب محظور",
                )
            except Exception:
                pass
        else:
            self._set_state("stopped", "متوقف")
        self.log("✓ تم إيقاف البوت بنجاح وتفريغ كافة كائناته من الذاكرة.")

# ═════════════════════════════════════════════════════════════════════════════
# 3. المدير المركزي لتعدد البوتات (BotManager)
# ═════════════════════════════════════════════════════════════════════════════

class BotManager:
    """
    المدير المركزي لإدارة وتنسيق تشغيل عدة حسابات بالتوازي:
    - تشغيل / إيقاف بوت معين.
    - تشغيل / إيقاف جميع الحسابات.
    - استعلام الحالات الحية (Live States) لتغذية الـ Dashboard و api_server.
    """

    def __init__(self):
        self.bots: Dict[str, CastleBot] = {}
        self.tasks: Dict[str, asyncio.Task] = {}
        self._start_locks: Dict[str, asyncio.Lock] = {}
        self._lock = asyncio.Lock()

    def _get_castle_lock(self, email: str) -> asyncio.Lock:
        if email not in self._start_locks:
            self._start_locks[email] = asyncio.Lock()
        return self._start_locks[email]

    def get_bot(self, email: str) -> Optional[CastleBot]:
        return self.bots.get(email)

    def list_all_bots(self) -> List[Dict[str, Any]]:
        """إرجاع البوتات النشطة فقط وتصفية البوتات المتوقفة لمنع ظهور Zombie Processes"""
        active_list = []
        for em, bot in list(self.bots.items()):
            task = self.tasks.get(em)
            if bot.is_running or (task and not task.done()):
                active_list.append(bot.get_live_info())
        return active_list

    async def start_bot(
        self,
        email: str,
        config: Optional[Dict[str, Any]] = None,
        password: Optional[str] = None,
        log_callback: Optional[Callable[[str], None]] = None,
    ) -> bool:
        """تشغيل بوت لحساب محدد مع منع التكرار وضمان تنظيف أي بقايا سابقة"""
        castle_lock = self._get_castle_lock(email)
        async with castle_lock:
            # 1. التحقق إذا كان البوت يعمل حالياً بالفعل أو في طور الإقلاع
            existing_bot = self.bots.get(email)
            existing_task = self.tasks.get(email)
            if existing_bot and (existing_bot.is_running or existing_bot.conn_state in ("starting", "running", "waiting")):
                if existing_task and not existing_task.done():
                    if log_callback:
                        existing_bot._log_callback = log_callback
                    log.warning(f"[Manager] الحساب {email} قيد التشغيل بالفعل — تم رفض طلب التشغيل المكرر.")
                    return True

            # 2. تنظيف أي مهمة قديمة عالقة وانتظار إنهائها
            if existing_task and not existing_task.done():
                existing_task.cancel()
                try:
                    await asyncio.wait_for(existing_task, timeout=3.0)
                except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
                    pass
            self.tasks.pop(email, None)

            if existing_bot:
                await existing_bot.stop()
                self.bots.pop(email, None)

            # 3. إنشاء وتشغيل البوت الجديد
            bot = CastleBot(
                email=email,
                password=password,
                config=config,
                log_callback=log_callback,
            )
            bot.conn_state = "starting"
            self.bots[email] = bot
            task = asyncio.create_task(bot.run(), name=f"bot_{email}")
            self.tasks[email] = task
            log.info(f"[Manager] تم بدء تشغيل البوت للحساب: {email}")
            return True

    async def stop_bot(self, email: str) -> bool:
        """إيقاف البوت وإنهاء كافة مهامه ومقابسه وإزالته من سجل العمليات الحية"""
        castle_lock = self._get_castle_lock(email)
        async with castle_lock:
            bot = self.bots.get(email)
            task = self.tasks.pop(email, None)

            if not bot and not task:
                return False

            if bot:
                bot.conn_state = "stopping"
                await bot.stop()

            if task and not task.done():
                task.cancel()
                try:
                    await asyncio.wait_for(task, timeout=4.0)
                except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
                    pass

            # إزالة البوت من سجل العمليات النشطة لتحرير الذاكرة وتحديث الواجهة
            self.bots.pop(email, None)
            log.info(f"[Manager] تم تفريغ وإيقاف البوت بنجاح للحساب: {email} (Zero Zombie Workers)")
            return True

    async def start_all(self, config_override: Optional[Dict[str, Any]] = None):
        """تشغيل جميع الحسابات المسجلة في session_cache.json بالتوازي"""
        accs = SessionCache.load_all()
        if not accs:
            log.warning("[Manager] لا توجد أي حسابات مسجلة في session_cache.json!")
            return

        log.info(f"[Manager] بدء تشغيل كافة الحسابات المتاحة ({len(accs)} حساب)...")
        for email in accs:
            await self.start_bot(email, config=config_override)

    async def stop_all(self):
        """إيقاف جميع البوتات النشطة بالتوازي مع ضمان انتهاء كافة المهام"""
        log.info("[Manager] جاري إيقاف جميع البوتات النشطة...")
        emails = list(set(list(self.bots.keys()) + list(self.tasks.keys())))
        if emails:
            await asyncio.gather(*(self.stop_bot(em) for em in emails), return_exceptions=True)
        log.info("[Manager] تم إيقاف وتفريغ جميع البوتات بنجاح (100% Clean Shutdown).")

    def get_status_summary(self) -> Dict[str, Any]:
        """ملخص حالة النظام العام لـ API"""
        active_bots = [b for b in self.bots.values() if b.is_running]
        total = len(active_bots)
        running = sum(1 for b in active_bots if b.is_running)
        connected = sum(1 for b in active_bots if b.conn_state == "connected")
        return {
            "total_bots": total,
            "running_bots": running,
            "connected_bots": connected,
            "bots": [b.get_live_info() for b in active_bots],
        }

# ═════════════════════════════════════════════════════════════════════════════
# 4. واجهة التشغيل المباشرة (CLI Runner)
# ═════════════════════════════════════════════════════════════════════════════

async def async_main():
    parser = argparse.ArgumentParser(description="مدير البوتات وحلقات التشغيل (bot_manager.py)")
    parser.add_argument("--email", type=str, default="", help="تشغيل بوت لحساب محدد")
    parser.add_argument("--password", "-p", type=str, default="", help="كلمة المرور لتوثيق الحساب لأول مرة وتخزينه تلقائياً")
    parser.add_argument("--all", action="store_true", help="تشغيل جميع الحسابات المسجلة")
    parser.add_argument("--interval", type=int, default=0, help="تحديد فاصل ثابت بالدقائق بين الدورات (افتراضياً: عشوائي بين 40 و 60 دقيقة)")
    parser.add_argument("--treasure", action="store_true", help="تفعيل مهمة نافورة الكنوز (وفق اختيار المستخدم)")
    parser.add_argument("--no-port", action="store_true", help="تعطيل مهمة الميناء التلقائية")
    parser.add_argument("--list", action="store_true", help="عرض قائمة الحسابات وحالتها")
    args = parser.parse_args()

    if args.list:
        accs = SessionCache.load_all()
        print("\n" + "=" * 65)
        print("  📋 قائمة الحسابات المتوفرة في النظام:")
        print("=" * 65)
        for i, (em, d) in enumerate(accs.items(), 1):
            print(f" [{i}] {em} (UID: {d.get('userId')})")
        print(f"💡 الإجمالي: {len(accs)} حساب مسجل.\n")
        return

    mgr = BotManager()
    cfg: Dict[str, Any] = {"tasks": {}}
    if args.interval and args.interval > 0:
        cfg["min_loop_interval_minutes"] = args.interval
        cfg["max_loop_interval_minutes"] = args.interval
    if args.treasure:
        cfg["tasks"]["fountain"] = {"enabled": True}
        cfg["tasks"]["treasure_hunt"] = {"enabled": True}
    if args.no_port:
        cfg["tasks"]["port"] = {"enabled": False}

    if args.email:
        await mgr.start_bot(args.email, config=cfg, password=args.password or None)
    elif args.all:
        await mgr.start_all(config_override=cfg)
    else:
        # إذا لم يُحدد إيميل، نشغل الحساب الأول من الكاش كعينة
        accs = SessionCache.load_all()
        if not accs:
            print("[-] لا توجد حسابات مسجلة في session_cache.json. يرجى إضافة حساب أولاً.")
            return
        first_email = list(accs.keys())[0]
        print(f"[*] لم يُحدد إيميل، تشغيل البوت للحساب الأول افتراضياً: {first_email}")
        await mgr.start_bot(first_email, config=cfg)

    # حلقة إبقاء البرنامج الرئيسي حياً واستقبال إشارة الإيقاف Ctrl+C
    try:
        while True:
            await asyncio.sleep(2)
    except (KeyboardInterrupt, asyncio.CancelledError):
        print("\n[!] تم استلام إشارة الإيقاف (Ctrl+C)...")
        await mgr.stop_all()

def main():
    try:
        asyncio.run(async_main())
    except (KeyboardInterrupt, SystemExit):
        pass

if __name__ == "__main__":
    main()

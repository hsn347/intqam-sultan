// ════════════════════════════════════════════════════
//  Firebase Types — مشتقة من firebase_schema.json
// ════════════════════════════════════════════════════

export interface Subscription {
  plan_id?: string
  plan_name: string
  status: 'active' | 'expired' | 'suspended' | 'pending_approval'
  started_at: string
  expires_at: string
  days_remaining: number
  months_duration?: number
  max_castles_allowed: number
  current_castles_count: number
  pending_castles_count?: number
}

export interface User {
  uid: string
  username: string
  email: string
  phone?: string
  role: 'user' | 'admin' | 'merchant_admin' | string
  tenant_domain?: string
  is_super_admin?: boolean
  is_merchant_admin?: boolean
  created_at: string
  is_banned: boolean
  banned_reason?: string
  subscription: Subscription
}

export interface CastleInfo {
  lord_name: string
  castle_name: string
  server_id: number
  castle_level: number
  lord_power: number
  vip_level: number
  alliance_name: string
  coordinates: { x: number; y: number }
  avatar?: string
  image_id?: number
}

export interface Resources {
  food: number
  wood: number
  iron: number
  silver?: number
  diamond: number
  gold: number
  stamina: number
  unprotected_food?: number
  unprotected_wood?: number
  unprotected_iron?: number
  unprotected_silver?: number
  unprotected_diamond?: number
  safe_food?: number
  safe_wood?: number
  safe_iron?: number
  safe_silver?: number
  safe_diamond?: number
  last_updated: string
}

export type BotState = 'running' | 'idle' | 'error' | 'paused' | 'pending' | 'disconnected' | 'reconnecting' | 'waiting' | 'deploying'

export interface BotStatus {
  state: BotState
  last_run_time: string
  next_run_time: string
  last_run_message: string
  active_marches: number
  max_marches: number
  last_error: string | null
  // حالة الاتصال الفعلية (connected | disconnected | reconnecting | waiting | idle)
  conn_state?: string
  conn_message?: string
  conn_updated?: string
}

// ─── Task Configs ─────────────────────────────────────
export interface BaseTaskConfig {
  enabled: boolean
}
export type SimpleToggleConfig = BaseTaskConfig

export interface ArenaConfig extends BaseTaskConfig {
  mode?: 'daily' | 'per_cycle'
  arena_type: 'kingdom' | 'global'
  auto_claim_rewards: boolean
}

export interface CommandHallConfig extends BaseTaskConfig {
  mode: 'daily' | 'full'
  allow_marches: boolean
  allow_snipe?: boolean
  allow_rescue?: boolean
  allow_dialogue?: boolean
  allow_army_group?: boolean
  auto_claim_rewards: boolean
  auto_upgrade_hall: boolean
  min_safety_stamina?: number
}

export interface StaminaConfig {
  enabled: boolean
  gold_buy_enabled: boolean
  gold_trigger_stamina: number
  gold_buy_stamina_amount: number
}

export type EquipmentCategory = 'weapon' | 'clothes' | 'helmet' | 'trousers' | 'shoes' | 'ring'

export interface TrainLevels {
  infantry: number
  cavalry: number
  archers: number
  chariots: number
}

export interface MaterialWorkshopConfig extends BaseTaskConfig {
  selected_materials?: number[]
  materials?: string[]
}

export interface TreasureEscortConfig extends BaseTaskConfig {
  free_refresh: boolean
  formation_id: number
  use_saved_formation: boolean
  use_auto_fill: boolean
  require_full_legion: boolean
  exclude_defend: boolean
}

export interface MarchManagerConfig extends BaseTaskConfig {
  max_duration_minutes?: number
  formation_id?: number
  gather_speed_buff: { enabled: boolean }
  treasure_escort: { enabled: boolean }
  daily_hunt: { enabled: boolean }
  daily_gather: { enabled: boolean }
  explore_ruins: { enabled: boolean; explore_time: number; formation: number }
  resource_help: { enabled: boolean; target_x: number | null; target_y: number | null; resources: string }
  hunt_monsters: { enabled: boolean; monster_type: 'normal' | 'nebula'; monster_level: number }
  gather_resources: { enabled: boolean; resource: string; level: number }
}

export interface PrestigeSubtasks {
  smuggler: boolean
  watermill: boolean
  train: boolean
  fortress: boolean
}

export interface CastleConfig {
  city_harvest: BaseTaskConfig
  research: BaseTaskConfig
  alliance: BaseTaskConfig
  port: BaseTaskConfig
  train: BaseTaskConfig & { levels: TrainLevels }
  pet: BaseTaskConfig & { target_pet: number }
  territory_expansion: BaseTaskConfig
  torch_chest?: BaseTaskConfig
  open_torch_chest?: BaseTaskConfig
  hero_consign?: BaseTaskConfig
  shield: BaseTaskConfig & { duration: '8h' | '24h' | '3d'; allow_gold: boolean }
  flower?: BaseTaskConfig & { allow_gold: boolean }
  wonder_merchant?: BaseTaskConfig
  material_synthesis?: BaseTaskConfig
  cure_wounded?: BaseTaskConfig & { mode: 'daily' | 'all' }
  forge_equipment?: BaseTaskConfig & { category: EquipmentCategory }
  daily_train?: BaseTaskConfig
  daily_quest?: BaseTaskConfig
  arena?: ArenaConfig
  hero_trial?: SimpleToggleConfig
  command_hall?: CommandHallConfig
  stamina?: StaminaConfig
  skills: BaseTaskConfig & { target_skills: string[] }
  hero_draw: BaseTaskConfig
  treasure_pavilion: BaseTaskConfig
  blacksmith_forge: BaseTaskConfig
  imperial_mausoleum: BaseTaskConfig
  alliance_treasure: BaseTaskConfig & { index?: number }
  daily_luxury_gift: BaseTaskConfig
  vip_gift: BaseTaskConfig
  tactics_hall: BaseTaskConfig & { tactic: string }
  watermill: BaseTaskConfig & { resources?: string[]; types?: string | string[]; allow_shop_buy?: boolean }
  fountain: BaseTaskConfig & { resources: string[]; allow_gold: boolean; gold_times: number; use_gold?: boolean }
  material_workshop?: MaterialWorkshopConfig
  caravan: BaseTaskConfig
  port_delegate: BaseTaskConfig & { shop_item: string }
  savings_bank: BaseTaskConfig & { days: number }
  building: BaseTaskConfig & { upgrade_castle: boolean; speedup_castle: boolean; upgrade_support_buildings: boolean; target_buildings?: Record<string, boolean> }
  prestige: BaseTaskConfig & { subtasks: PrestigeSubtasks }
  march_manager: MarchManagerConfig
  troy_treasure?: BaseTaskConfig & {
    subtasks?: {
      claim_quests?: boolean
      [key: string]: any
    }
  }
  warrior_exchange?: BaseTaskConfig & { count: number }
  gather_boost?: BaseTaskConfig
  gold_gather?: { enabled: boolean; locations: GoldLocation[] }
}

export type BotConfig = CastleConfig


export interface Castle {
  id: string
  castle_id: string
  email: string
  password?: string
  is_active: boolean
  created_at: string
  castle_info: CastleInfo
  resources: Resources
  bot_status: BotStatus
  config: CastleConfig
}

export const DEFAULT_CASTLE_CONFIG: CastleConfig = {
  // جميع المهام مغلقة افتراضياً عند إضافة قلعة جديدة باستثناء جمع القمح لفل 4
  city_harvest: { enabled: false },
  research: { enabled: false },
  alliance: { enabled: false },
  port: { enabled: false },
  train: { enabled: false, levels: { infantry: 0, cavalry: 0, archers: 0, chariots: 0 } },
  pet: { enabled: false, target_pet: 1256 },
  territory_expansion: { enabled: false },
  torch_chest: { enabled: false },
  open_torch_chest: { enabled: false },
  hero_consign: { enabled: false },
  shield: { enabled: false, duration: '8h', allow_gold: false },
  flower: { enabled: false, allow_gold: false },
  wonder_merchant: { enabled: false },
  material_synthesis: { enabled: false },
  cure_wounded: { enabled: false, mode: 'daily' },
  forge_equipment: { enabled: false, category: 'weapon' },
  daily_quest: { enabled: true },
  arena: { enabled: false, mode: 'daily', arena_type: 'kingdom', auto_claim_rewards: true },
  hero_trial: { enabled: false },
  command_hall: { enabled: false, mode: 'daily', allow_marches: true, allow_snipe: true, allow_rescue: true, allow_dialogue: true, allow_army_group: true, auto_claim_rewards: true, auto_upgrade_hall: true, min_safety_stamina: 10 },
  stamina: {
    enabled: false,
    gold_buy_enabled: false,
    gold_trigger_stamina: 50,
    gold_buy_stamina_amount: 50,
  },
  skills: { enabled: false, target_skills: [] },
  hero_draw: { enabled: false },
  treasure_pavilion: { enabled: false },
  blacksmith_forge: { enabled: false },
  imperial_mausoleum: { enabled: false },
  alliance_treasure: { enabled: false, index: 1 },
  daily_luxury_gift: { enabled: false },
  vip_gift: { enabled: false },
  tactics_hall: { enabled: false, tactic: 'القلعة الفارغة' },
  watermill: { enabled: false, resources: ['food', 'wood', 'iron', 'silver', 'crystal'], types: 'all', allow_shop_buy: false },
  fountain: { enabled: false, resources: ['food', 'wood', 'iron', 'diamond'], allow_gold: false, gold_times: 0 },
  material_workshop: { enabled: false, selected_materials: [200101, 200201, 200301, 200401, 200501, 200601] },
  caravan: { enabled: false },
  port_delegate: { enabled: false, shop_item: 'all' },
  savings_bank: { enabled: false, days: 7 },
  building: { enabled: false, upgrade_castle: false, speedup_castle: false, upgrade_support_buildings: false },
  prestige: {
    enabled: false,
    subtasks: {
      smuggler: false,
      watermill: false,
      train: false,
      fortress: false,
    },
  },
  troy_treasure: {
    enabled: false,
    subtasks: {
      claim_quests: false,
    },
  },
  warrior_exchange: { enabled: false, count: 15 },
  gather_boost: { enabled: false },
  march_manager: {
    enabled: false,
    max_duration_minutes: 20,
    formation_id: 1,
    gather_speed_buff: { enabled: false },
    treasure_escort: { enabled: false },
    daily_hunt: { enabled: false },
    daily_gather: { enabled: false },
    explore_ruins: { enabled: false, explore_time: 14400, formation: 1 },
    resource_help: { enabled: false, target_x: null, target_y: null, resources: 'food,wood,iron' },
    hunt_monsters: { enabled: false, monster_type: 'normal', monster_level: 0 },
    gather_resources: { enabled: false, resource: 'wood', level: 0 },
  },
}

export const FIXED_PRESET_CONFIG: CastleConfig = {
  // 1. جمع الموارد بتحديد مورد الحديد
  march_manager: {
    enabled: true,
    max_duration_minutes: 20,
    formation_id: 1,
    gather_speed_buff: { enabled: true },
    treasure_escort: { enabled: false },
    daily_hunt: { enabled: false },
    daily_gather: { enabled: false },
    explore_ruins: { enabled: false, explore_time: 14400, formation: 1 },
    resource_help: { enabled: false, target_x: null, target_y: null, resources: 'food,wood,iron' },
    hunt_monsters: { enabled: false, monster_type: 'normal', monster_level: 0 },
    gather_resources: { enabled: true, resource: 'iron', level: 0 },
  },
  // 2. دعم الموارد لكل الموارد مع حزم الدعم المجانية
  watermill: { enabled: true, resources: ['food', 'wood', 'iron', 'silver', 'crystal'], types: 'all', allow_shop_buy: false },
  // 3. مهمة قافلة الغنيمة
  caravan: { enabled: true },
  // 4. مهام التحالف مع التبرع للتحالف
  alliance: { enabled: true },
  // 5. مهمة الحيوان (استلام الجوائز والإطعام المجاني)
  pet: { enabled: true, target_pet: 1256 },
  // 6. دراسة الاستراتيجيات على القلعة الفارغة
  tactics_hall: { enabled: true, tactic: 'القلعة الفارغة' },
  // 7. نافورة الأمنيات على كل الموارد بدون شراء من المتجر
  fountain: { enabled: true, resources: ['food', 'wood', 'iron', 'coal', 'diamond'], allow_gold: false, gold_times: 0 },
  // 8. ورشة المواد على كل المواد
  material_workshop: { enabled: true, selected_materials: [200101, 200201, 200301, 200401, 200501, 200601] },
  // 9 & 10. مكافأة الجمع السريع ومكافأة الحصاد
  skills: { enabled: true, target_skills: ['harvest', 'gather'] },
  // 11. الزنزانة الأساسية لكل العناصر
  port_delegate: { enabled: true, shop_item: 'all' },
  // 12. التوسع الإقليمي
  territory_expansion: { enabled: true },
  torch_chest: { enabled: false },
  open_torch_chest: { enabled: false },
  hero_consign: { enabled: false },

  // المهام الأساسية
  city_harvest: { enabled: true },
  research: { enabled: false },
  port: { enabled: false },
  train: { enabled: false, levels: { infantry: 0, cavalry: 0, archers: 0, chariots: 0 } },
  shield: { enabled: false, duration: '8h', allow_gold: false },
  flower: { enabled: false, allow_gold: false },
  wonder_merchant: { enabled: false },
  material_synthesis: { enabled: false },
  cure_wounded: { enabled: false, mode: 'daily' },
  forge_equipment: { enabled: false, category: 'weapon' },
  stamina: {
    enabled: false,
    gold_buy_enabled: false,
    gold_trigger_stamina: 50,
    gold_buy_stamina_amount: 50,
  },
  hero_draw: { enabled: false },
  treasure_pavilion: { enabled: true },
  blacksmith_forge: { enabled: true },
  imperial_mausoleum: { enabled: true },
  alliance_treasure: { enabled: true, index: 1 },
  daily_luxury_gift: { enabled: true },
  vip_gift: { enabled: true },
  savings_bank: { enabled: false, days: 7 },
  building: { enabled: false, upgrade_castle: false, speedup_castle: false, upgrade_support_buildings: false },
  prestige: {
    enabled: false,
    subtasks: {
      smuggler: false,
      watermill: false,
      train: false,
      fortress: false,
    },
  },
  troy_treasure: {
    enabled: true,
    subtasks: {
      claim_quests: true,
    },
  },
  warrior_exchange: { enabled: false, count: 15 },
  gather_boost: { enabled: false },
}

export interface CastleLog {
  id: string
  timestamp: string
  step: string
  title: string
  status: 'success' | 'error' | 'warning' | 'info'
  details: Record<string, unknown>
  message: string
}

// ─── UI Types ────────────────────────────────────────
export type Theme = 'dark' | 'light'
export type Language = 'ar' | 'en' | 'tr'

export type TaskTab =
  | 'gather'
  | 'train'
  | 'combat'
  | 'watermill'
  | 'transport'
  | 'daily'
  | 'building'

export interface GoldLocation {
  x: number
  y: number
  alliance_tag?: string
}

export interface StatsCard {
  label: string
  value: string | number
  icon: string
  color: string
  delta?: string
}

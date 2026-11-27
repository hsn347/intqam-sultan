// ════════════════════════════════════════════════════════════════════
//  botApi.ts — عميل API للتواصل مع api_server.py (خادم البوت و SQLite)
// ════════════════════════════════════════════════════════════════════
// يعتمد كلياً على SQLite عبر REST API وخادم FastAPI، بدون Firestore.
// المحلي:   http://localhost:8000
// VPS:      https://sultan.ibraabot.online (عبر متغير البيئة VITE_BOT_API_URL)
// ════════════════════════════════════════════════════════════════════

import { auth } from './firebase'
import type { AdminStats, Castle, CastleConfig, User } from '../types'
import i18n from './i18n'
import { localizeApiError } from './localize'

export function parseAndLocalizeApiError(errText: string): string {
  let detail = errText
  try {
    const parsed = JSON.parse(errText)
    if (parsed.detail) detail = parsed.detail
  } catch { /* empty */ }
  return localizeApiError(detail, i18n.t)
}

export function getApiBaseUrl(): string {
  // 1. إذا كان الكود يعمل في المتصفح على نطاق عام
  if (typeof window !== 'undefined' && window.location?.origin) {
    const origin = window.location.origin
    if (!origin.includes('localhost') && !origin.includes('127.0.0.1')) {
      return origin
    }
  }

  // 2. متغير البيئة إذا وُجد
  const envUrl = (import.meta.env.VITE_BOT_API_URL as string | undefined)?.trim()
  if (envUrl) {
    return envUrl.replace(/\/+$/, '')
  }

  // 3. الوضع الافتراضي للتطوير المحلي
  if (typeof window !== 'undefined' && window.location?.origin) {
    return window.location.origin
  }
  return 'http://localhost:8765'
}

export function getWsBaseUrl(): string {
  const base = getApiBaseUrl()
  if (base.startsWith('https://')) {
    return base.replace(/^https:\/\//, 'wss://')
  }
  return base.replace(/^http:\/\//, 'ws://')
}

export interface BotStartPayload {
  castle_id:     string
  user_id:       string
  email:         string
  password?:     string
  config?:       Record<string, unknown>
  loop_interval?: number
}

export interface BotStatusResult {
  castle_id: string
  status:    'running' | 'starting' | 'idle' | 'error' | 'disconnected' | 'reconnecting' | 'waiting'
}

// ── استخراج توكن الأمان من Firebase Authentication ────────────────
export async function getAuthHeader(): Promise<Record<string, string>> {
  const headers: Record<string, string> = {}
  try {
    // 🛡️ انتظار اكتمال تهيئة جلسة فايربيس في المتصفح إذا كانت قيد الاسترجاع من الذاكرة
    if (typeof (auth as any).authStateReady === 'function') {
      await (auth as any).authStateReady()
    }
    const user = auth.currentUser
    if (user) {
      const token = await user.getIdToken()
      headers['Authorization'] = `Bearer ${token}`
    }
  } catch (err) {
    console.warn('Failed to retrieve Firebase auth token for API request:', err)
  }
  if (typeof window !== 'undefined' && window.location?.hostname) {
    headers['X-Tenant-Domain'] = window.location.hostname
  }
  return headers
}

// ── هل الخادم متاح؟ ───────────────────────────────────────────────
export async function checkApiAvailable(): Promise<boolean> {
  try {
    const api = getApiBaseUrl()
    const res = await fetch(`${api}/api/system/health`, { signal: AbortSignal.timeout(3000) })
    if (res.ok) return true
    const fallback = await fetch(`${api}/`, { signal: AbortSignal.timeout(3000) })
    return fallback.ok
  } catch {
    return false
  }
}

// ══════════════════════════════════════════════════════════════════
// 👤 دوال إدارة المستخدمين (User REST APIs)
// ══════════════════════════════════════════════════════════════════

export async function getUserProfile(): Promise<User | null> {
  const authHeaders = await getAuthHeader()
  if (!authHeaders.Authorization) return null
  const res = await fetch(`${getApiBaseUrl()}/api/users/profile`, {
    headers: authHeaders,
  })
  if (res.status === 403) {
    const data = await res.json().catch(() => ({}))
    const msg = data.detail || 'هذا الحساب غير مسجل في هذا النظام'
    const err = new Error(msg)
    ;(err as any).status = 403
    ;(err as any).code = 'auth/tenant-mismatch'
    throw err
  }
  if (!res.ok) return null
  const data = await res.json()
  return data.user ? formatUserFromApi(data.user) : null
}

export async function registerUser(payload: {
  uid:            string
  email:          string
  username?:      string
  phone?:         string
  tenant_domain?: string
}): Promise<{ status: string; user: User }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/users/register`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل تسجيل المستخدم: ${err}`)
  }
  const data = await res.json()
  return { status: data.status, user: formatUserFromApi(data.user) }
}

export async function updateUserProfileApi(payload: {
  username?: string
  phone?:    string
}): Promise<{ status: string; user: User }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/users/profile`, {
    method:  'PUT',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل تحديث الملف الشخصي: ${err}`)
  }
  const data = await res.json()
  return { status: data.status, user: formatUserFromApi(data.user) }
}

export async function getUserSubscription(): Promise<Record<string, unknown>> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/users/subscription`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب تفاصيل الاشتراك')
  return res.json()
}

// ══════════════════════════════════════════════════════════════════
// 🏰 دوال إدارة القلاع (Castles REST APIs)
// ══════════════════════════════════════════════════════════════════

export async function fetchCastles(userId?: string): Promise<Castle[]> {
  const authHeaders = await getAuthHeader()
  // 🛡️ إذا طُلب جلب قلاع مستخدم محدد ولكن التوكن لم يجهز بعد، لا نرسل طلباً غير موثق يمسح الكاش
  if (userId && !authHeaders['Authorization']) {
    throw new Error('في انتظار اكتمال توكن المصادقة...')
  }
  const url = userId && userId.trim()
    ? `${getApiBaseUrl()}/api/castles?user_id=${encodeURIComponent(userId.trim())}`
    : `${getApiBaseUrl()}/api/castles`
  const res = await fetch(url, {
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل جلب القلاع: ${err}`)
  }
  const data = await res.json()
  return (data.castles || []).map((c: any) => formatCastleFromApi(c))
}

export async function fetchCastle(castleId: string): Promise<Castle> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/castles/${castleId}`, {
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل جلب بيانات القلعة: ${err}`)
  }
  const data = await res.json()
  return formatCastleFromApi(data.castle)
}

export async function createCastle(payload: {
  castle_id?:   string
  email:         string
  password?:     string
  castle_name?:  string
  config?:       Record<string, unknown>
}): Promise<{ status: string; castle: Castle }> {
  const authHeaders = await getAuthHeader()
  const cleanPayload = { ...payload }
  delete cleanPayload.config
  const res = await fetch(`${getApiBaseUrl()}/api/castles`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(cleanPayload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  const data = await res.json()
  return { status: data.status, castle: formatCastleFromApi(data.castle) }
}

export async function updateCastle(castleId: string, payload: {
  castle_name?: string
  config?:      Record<string, unknown>
}): Promise<{ status: string; castle: Castle }> {
  const authHeaders = await getAuthHeader()
  const cleanPayload: { castle_name?: string; config?: Record<string, unknown> } = {}
  if (payload.castle_name !== undefined) {
    cleanPayload.castle_name = payload.castle_name
  }
  if (payload.config !== undefined) {
    // إرسال كافة إعدادات المهام المحددة دون استبعاد أي مهمة
    const rawCfg = (payload.config || {}) as Record<string, unknown>
    const cfgToSend: Record<string, unknown> = {}
    for (const [key, val] of Object.entries(rawCfg)) {
      if (val !== undefined) {
        cfgToSend[key] = val
      }
    }
    cleanPayload.config = cfgToSend
  }
  const res = await fetch(`${getApiBaseUrl()}/api/castles/${castleId}`, {
    method:  'PUT',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(cleanPayload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  const data = await res.json()
  return { status: data.status, castle: formatCastleFromApi(data.castle) }
}

export async function updateCastlesLoopIntervals(
  intervals: Record<string, number>
): Promise<{ status: string; message: string; live_updated?: number }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/castles/loop-intervals`, {
    method:  'PUT',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify({ intervals }),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function updateCastleCredentials(castleId: string, payload: {
  email:    string
  password?: string
}): Promise<{ status: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/castles/${castleId}/credentials`, {
    method:  'PUT',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function toggleCastleActive(castleId: string, isActive: boolean): Promise<{ status: string; is_active: boolean }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/castles/${castleId}/toggle`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify({ is_active: isActive }),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function deleteCastle(castleId: string): Promise<{ status: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/castles/${castleId}`, {
    method:  'DELETE',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function fetchCastleDataLive(email: string, userId?: string, castleId?: string): Promise<Record<string, unknown>> {
  const authHeaders = await getAuthHeader()
  const query = new URLSearchParams()
  if (userId) query.set('user_id', userId)
  if (castleId) query.set('castle_id', castleId)

  const res = await fetch(`${getApiBaseUrl()}/api/castles/data/${encodeURIComponent(email)}?${query.toString()}`, {
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل استعلام بيانات القلعة الحية: ${err}`)
  }
  return res.json()
}

// ══════════════════════════════════════════════════════════════════
// 👑 دوال لوحة الإدارة (Admin REST APIs)
// ══════════════════════════════════════════════════════════════════

export async function getAdminStats(): Promise<AdminStats> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/stats`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب الإحصائيات')
  const raw = await res.json()
  return {
    totalUsers:          Number(raw.total_users ?? raw.totalUsers ?? 0),
    activeSubscriptions: Number(raw.active_subscriptions ?? raw.activeSubscriptions ?? 0),
    pendingUsers:        Number(raw.pending_users ?? raw.pendingUsers ?? 0),
    expiredUsers:        Number(raw.expired_users ?? raw.expiredUsers ?? 0),
    bannedUsers:         Number(raw.banned_users ?? raw.bannedUsers ?? 0),
    totalCastles:        Number(raw.total_castles ?? raw.totalCastles ?? 0),
    allowedCastles:      Number(raw.allowed_castles ?? raw.allowedCastles ?? 0),
    allowedCastlesQuota: Number(raw.allowed_castles_quota ?? raw.allowedCastlesQuota ?? 0),
    runningCastles:      Number(raw.running_castles ?? raw.runningCastles ?? raw.active_bots ?? raw.activeBots ?? 0),
    activeBots:          Number(raw.active_bots ?? raw.activeBots ?? raw.running_castles ?? 0),
    connectedBots:       Number(raw.connected_bots ?? raw.connectedBots ?? 0),
  }
}

export async function getAdminUsers(): Promise<User[]> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب المستخدمين')
  const data = await res.json()
  return (data.users || []).map((u: any) => formatUserFromApi(u))
}

export interface MerchantStats {
  id: string
  brand_name: string
  domains: string[]
  admin_email: string
  primary_color: string
  tagline?: string
  total_users: number
  total_castles: number
  running_castles: number
}

export async function getMerchantsOverview(): Promise<{ status: string; merchants: MerchantStats[] }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/merchants/overview`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب إحصائيات التجار')
  return res.json()
}

export async function updateAdminSubscription(uid: string, payload: {
  plan_id:             string
  plan_name:           string
  subscription_status?: string
  expires_at:          string
  max_castles_allowed: number
}): Promise<{ status: string; user: User }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users/${uid}/subscription`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل تعديل الاشتراك: ${err}`)
  }
  const data = await res.json()
  return { status: data.status, user: formatUserFromApi(data.user) }
}

export async function banAdminUser(uid: string, payload: {
  is_banned: boolean
  reason?:   string
}): Promise<{ status: string; user: User }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users/${uid}/ban`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل حظر/إلغاء حظر المستخدم: ${err}`)
  }
  const data = await res.json()
  return { status: data.status, user: formatUserFromApi(data.user) }
}

export async function deleteAdminUser(uid: string): Promise<{ status: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users/${uid}`, {
    method:  'DELETE',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل حذف المستخدم: ${err}`)
  }
  return res.json()
}

export async function approveAdminUser(
  uid: string,
  days = 3,
  maxCastles = 10
): Promise<{ status: string; message: string; user: User }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users/${uid}/approve`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify({ days, max_castles: maxCastles }),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل تفعيل باقة المستخدم: ${err}`)
  }
  const data = await res.json()
  return { status: data.status, message: data.message, user: formatUserFromApi(data.user) }
}

export async function approveAllPendingAdminUsers(
  days = 3,
  maxCastles = 10
): Promise<{ status: string; message: string; approved_count: number }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users/approve-all`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify({ days, max_castles: maxCastles }),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`فشل تفعيل باقة المستخدمين: ${err}`)
  }
  return res.json()
}

export async function approveCastleAdmin(castleId: string): Promise<{ status: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/castles/${castleId}/approve`, {
    method:  'POST',
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل قبول القلعة')
  return res.json()
}

export async function rejectCastleAdmin(castleId: string, reason?: string): Promise<{ status: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/castles/${castleId}/reject`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify({ reason }),
  })
  if (!res.ok) throw new Error('فشل رفض القلعة')
  return res.json()
}

// ══════════════════════════════════════════════════════════════════
// 🤖 التحكم في البوت (Bot Execution Controls)
// ══════════════════════════════════════════════════════════════════

export async function startBot(payload: BotStartPayload): Promise<{ status: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/start`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json', ...authHeaders },
    body:    JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function stopBot(castleId: string): Promise<{ status: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/stop/${castleId}`, {
    method:  'POST',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function stopUserBots(userId: string): Promise<{ status: string; stopped_count: number }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/stop-user/${userId}`, {
    method:  'POST',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function stopAllBotsAdmin(): Promise<{ status: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/stop-all`, {
    method:  'POST',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function getBotStatus(castleId: string): Promise<BotStatusResult> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/status/${castleId}`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب حالة البوت')
  return res.json()
}

export async function getAllBotStatus(): Promise<Record<string, string>> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/bots/status`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب الحالات')
  const data = await res.json()
  return data.bots ?? {}
}

export async function getLogsWsUrl(castleId: string): Promise<string> {
  const wsBase = getWsBaseUrl()
  return `${wsBase}/ws/logs/${castleId}${await getWsAuthQuery()}`
}

// ── توكن توثيق قنوات WebSocket (يُرسل كـ query لأن المتصفح لا يدعم ترويسات WS) ──
export async function getWsAuthQuery(): Promise<string> {
  try {
    if (typeof (auth as any).authStateReady === 'function') {
      await (auth as any).authStateReady()
    }
    const user = auth.currentUser
    if (user) {
      const token = await user.getIdToken()
      return `?token=${encodeURIComponent(token)}`
    }
  } catch {}
  return ''
}

// ══════════════════════════════════════════════════════════════════
// 🔄 Helpers لتحويل هياكل البيانات القادمة من SQLite لتطابق الواجهة
// ══════════════════════════════════════════════════════════════════

export function formatCastleFromApi(raw: any): Castle {
  if (!raw) return {} as Castle

  const cfg = typeof raw.config === 'string' ? JSON.parse(raw.config || '{}') : (raw.config || {})
  const cInfo = typeof raw.castle_info === 'string' ? JSON.parse(raw.castle_info || '{}') : (raw.castle_info || {})
  const res = typeof raw.resources === 'string' ? JSON.parse(raw.resources || '{}') : (raw.resources || {})

  const lordName = cInfo.lord_name || raw.lord_name || raw.castle_name || (raw.email ? raw.email.split('@')[0] : 'قلعة')
  const castleName = raw.castle_name || cInfo.castle_name || lordName

  return {
    id:          raw.castle_id || raw.id,
    castle_id:   raw.castle_id || raw.id,
    email:       raw.email || '',
    user_id:     raw.user_id,
    is_active:   raw.is_active !== undefined ? Boolean(raw.is_active) : true,
    created_at:  raw.created_at || new Date().toISOString(),
    castle_info: {
      lord_name:    lordName,
      castle_name:  castleName,
      server_id:    cInfo.server_id ?? raw.server_id ?? 1,
      castle_level: cInfo.castle_level ?? raw.castle_level ?? 1,
      walls_level:  cInfo.walls_level ?? raw.walls_level ?? 0,
      lord_power:   cInfo.power ?? cInfo.lord_power ?? raw.lord_power ?? raw.power ?? 0,
      vip_level:    cInfo.vip_level ?? raw.vip_level ?? 0,
      alliance_name:cInfo.alliance_name || raw.alliance_name || '',
      coordinates:  {
        x: cInfo.coordinates?.x ?? cInfo.coord_x ?? raw.coord_x ?? (raw.coordinates?.x ?? 0),
        y: cInfo.coordinates?.y ?? cInfo.coord_y ?? raw.coord_y ?? (raw.coordinates?.y ?? 0)
      },
      avatar:       cInfo.avatar || raw.avatar || '',
      image_id:     cInfo.imageId ?? cInfo.image_id ?? raw.image_id ?? 0,
    },
    resources: {
      food:                res.food ?? raw.food ?? 0,
      wood:                res.wood ?? raw.wood ?? 0,
      iron:                res.iron ?? raw.iron ?? 0,
      silver:              res.silver ?? res.mithril ?? raw.silver ?? raw.mithril ?? 0,
      diamond:             res.diamond ?? res.crystal ?? raw.diamond ?? raw.crystal ?? 0,
      gold:                res.gold ?? cInfo.gold ?? raw.gold ?? 0,
      stamina:             res.stamina ?? raw.stamina ?? 100,
      unprotected_food:    res.unprotected_food ?? raw.unprotected_food ?? (res.unprotected_food ?? 0),
      unprotected_wood:    res.unprotected_wood ?? raw.unprotected_wood ?? (res.unprotected_wood ?? 0),
      unprotected_iron:    res.unprotected_iron ?? raw.unprotected_iron ?? (res.unprotected_iron ?? 0),
      unprotected_silver:  res.unprotected_silver ?? raw.unprotected_silver ?? 0,
      unprotected_diamond: res.unprotected_diamond ?? raw.unprotected_diamond ?? (res.unprotected_diamond ?? 0),
      safe_food:           res.safe_food ?? raw.safe_food ?? (res.safe_food ?? 0),
      safe_wood:           res.safe_wood ?? raw.safe_wood ?? (res.safe_wood ?? 0),
      safe_iron:           res.safe_iron ?? raw.safe_iron ?? (res.safe_iron ?? 0),
      safe_silver:         res.safe_silver ?? raw.safe_silver ?? 0,
      safe_diamond:        res.safe_diamond ?? raw.safe_diamond ?? (res.safe_diamond ?? 0),
      last_updated:        res.last_updated || raw.last_updated || new Date().toISOString(),
    },
    bot_status: (() => {
      const isSealed = raw.state === 'sealed' || raw.conn_state === 'sealed' || Boolean(raw.is_sealed)
      const resolvedMsg = raw.seal_reason || raw.conn_message || raw.status_message || ''
      return {
        state:            isSealed ? 'sealed' : (raw.state || 'idle'),
        conn_state:       isSealed ? 'sealed' : (raw.conn_state || raw.state || 'idle'),
        conn_message:     raw.conn_message || raw.status_message || '',
        conn_updated:     raw.last_updated || new Date().toISOString(),
        last_run_time:    raw.last_run_time || null,
        next_run_time:    raw.next_run_time || null,
        last_run_message: raw.last_run_message || (isSealed ? resolvedMsg : (raw.state === 'running' ? 'البوت يعمل الآن...' : 'جاهز للتشغيل')),
        active_marches:   0,
        max_marches:      2,
        last_error:       (raw.state === 'error' || raw.conn_state === 'error' || isSealed) ? (resolvedMsg || 'خطأ في المصادقة أو الاتصال') : (raw.last_error || null),
        is_sealed:        isSealed,
        seal_type:        raw.seal_type ?? null,
        seal_reason:      raw.seal_reason ?? null,
      }
    })(),
    loop_interval: raw.loop_interval ? Number(raw.loop_interval) : 40,
    config: cfg,
  } as Castle
}

export function formatUserFromApi(raw: any): User {
  if (!raw) return {} as User

  const expRaw = raw.subscription_expires_at || raw.subscription?.expires_at || raw.subscription_end || null
  const expDate = expRaw ? new Date(expRaw) : null
  const now = new Date()
  const daysRemaining = (expDate && !isNaN(expDate.getTime()))
    ? Math.max(0, Math.ceil((expDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24)))
    : (raw.subscription?.days_remaining ?? 0)

  // حالة الاعتماد والاشتراك الحقيقية
  const rawStatus = raw.subscription_status || raw.subscription?.status || raw.status || 'pending'
  const isPending = rawStatus === 'pending' || rawStatus === 'pending_approval'

  let status: 'active' | 'expired' | 'suspended' | 'pending_approval' = 'active'
  if (isPending) {
    status = 'pending_approval'
  } else if (raw.is_banned || rawStatus === 'suspended') {
    status = 'suspended'
  } else if (!expDate || (expDate && !isNaN(expDate.getTime()) && expDate.getTime() < now.getTime())) {
    status = 'expired'
  } else {
    status = 'active'
  }

  return {
    uid:        raw.uid,
    email:      raw.email,
    username:   raw.username || (raw.email ? raw.email.split('@')[0] : ''),
    phone:      raw.phone || '',
    role:       raw.role || 'user',
    tenant_domain: raw.tenant_domain || '',
    is_banned:  Boolean(raw.is_banned),
    banned_reason: raw.banned_reason || '',
    created_at: raw.created_at || new Date().toISOString(),
    subscription: {
      plan_id:               raw.plan_id || raw.subscription?.plan_id || (isPending ? 'pending_trial' : 'free'),
      plan_name:             raw.plan_name || raw.subscription?.plan_name || (isPending ? 'بانتظار موافقة الإدارة' : 'مجاني'),
      status:                status,
      started_at:            raw.subscription_started_at || raw.subscription?.started_at || '',
      expires_at:            expRaw || '',
      days_remaining:        isPending ? 0 : daysRemaining,
      max_castles_allowed:   raw.max_castles_allowed ?? raw.subscription?.max_castles_allowed ?? raw.max_castles ?? (isPending ? 0 : 10),
      current_castles_count: Number(raw.current_castles_count ?? raw.subscription?.current_castles_count ?? 0),
      pending_castles_count: Number(raw.pending_castles_count ?? raw.subscription?.pending_castles_count ?? 0),
      total_castles_count:   Number(raw.total_castles_count ?? raw.subscription?.total_castles_count ?? (raw.current_castles_count ?? 0)),
      allowed_castles_count: Number(raw.allowed_castles_count ?? raw.subscription?.allowed_castles_count ?? 0),
      running_castles_count: Number(raw.running_castles_count ?? raw.subscription?.running_castles_count ?? 0),
    },
  } as User
}

// ══════════════════════════════════════════════════════════════════
// ⚡ العمليات الحية (Live Runtime Threads API)
// ══════════════════════════════════════════════════════════════════

export interface LiveProcessInfo {
  castle_id: string
  email: string
  castle_name?: string
  lord_name?: string
  server_id?: number | null
  user_id: string
  user_email?: string
  owner_name?: string
  thread_id: number | null
  thread_name: string
  thread_alive: boolean
  state: string
  live_category: 'running' | 'waiting' | 'other_login' | 'reconnecting' | 'starting' | string
  category_label?: string
  current_step?: string
  status_message: string
  iteration: number
  loop_interval_minutes: number
  next_run_time: string | null
  reconnect_attempt: number
  max_reconnect_attempts: number
  last_kick_reason: string
  uptime_seconds: number
  step_duration_seconds?: number
  is_connection_alive: boolean
  is_stopped: boolean
  start_time: number
  proxy_ip?: string
  real_ip?: string
  real_ip_type?: 'socks5' | 'direct' | string
  socket_peer?: string
  is_proxied?: boolean
  is_live_socket?: boolean
}


export interface GradualStartupStatus {
  running: boolean
  total: number
  started: number
  skipped: number
  remaining: number
}

export interface LiveProcessesResponse {
  status: string
  source: string
  timestamp: string
  summary: {
    total_active: number
    running: number
    waiting: number
    other_login: number
    reconnecting: number
    starting: number
  }
  processes: LiveProcessInfo[]
  eligible_idle_count?: number
  gradual_startup?: GradualStartupStatus
}

export async function getAdminLiveProcesses(): Promise<LiveProcessesResponse> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/live-bots`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب العمليات الحية من السيرفر')
  return res.json()
}

export async function startEligibleBotsGradualAdmin(): Promise<{
  status: 'started' | 'empty' | 'already_running' | string
  total?: number
  message?: string
  gradual_startup?: GradualStartupStatus
}> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/live-bots/start-eligible`, {
    method: 'POST',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

export async function cancelGradualStartAdmin(): Promise<{
  status: string
  gradual_startup?: GradualStartupStatus
}> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/live-bots/cancel-gradual`, {
    method: 'POST',
    headers: authHeaders,
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(parseAndLocalizeApiError(err))
  }
  return res.json()
}

// ─── Proxies & Network Mode Management API ────────────────────────────────
export interface ProxyCardInfo {
  index?: number
  ip: string
  port: number
  country: string
  city?: string
  asn?: string
  type?: 'residential' | 'free'
  assigned_castles: string[]
  assigned_users: string[]
  full_url: string
}

export type NetworkMode = 'residential' | 'free' | 'direct' | 'socks5'

export interface ProxiesStatusResponse {
  enabled: boolean
  network_mode?: NetworkMode
  server_ip?: string
  total_proxies: number
  residential_count?: number
  free_count?: number
  active_pool_name?: string
  total_bound_castles: number
  total_bound_users: number
  proxies_list: ProxyCardInfo[]
}

export async function getAdminProxies(): Promise<ProxiesStatusResponse> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/proxies`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب بيانات البروكسيات من السيرفر')
  return res.json()
}

export async function testAdminProxy(proxyUrl: string): Promise<{ ok: boolean; ping?: number; msg: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/proxies/test`, {
    method: 'POST',
    headers: { ...authHeaders, 'Content-Type': 'application/json' },
    body: JSON.stringify({ proxy_url: proxyUrl })
  })
  if (!res.ok) throw new Error('فشل اختبار البروكسي')
  return res.json()
}

// ─── Manual proxy assignment (super admin) ───────────────────
export interface ProxyLookupItem {
  castle_id: string
  email: string
  castle_name: string
  lord_name: string
  state: string
  is_running: boolean
  proxy_index: number | null
  proxy_ip: string
  owner: { uid: string; email: string; username: string }
}

export interface ProxyOpResult {
  moved: number
  running_count: number
  proxy_index?: number
  ip?: string
  targets?: Record<string, number>
}

async function adminProxyPost(path: string, body: Record<string, unknown>): Promise<ProxyOpResult> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/proxies/${path}`, {
    method: 'POST',
    headers: { ...authHeaders, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  const data = await res.json().catch(() => ({}))
  if (!res.ok) throw new Error(data.detail || 'فشلت العملية')
  return data as ProxyOpResult
}

export async function lookupAdminProxyCastles(q: string): Promise<ProxyLookupItem[]> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/proxies/lookup?q=${encodeURIComponent(q)}`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل البحث')
  const data = await res.json()
  return data?.items || []
}

export const assignCastleProxy = (castleEmail: string, proxyIndex: number) =>
  adminProxyPost('assign-castle', { castle_email: castleEmail, proxy_index: proxyIndex })

export const assignUserProxy = (userId: string, proxyIndex: number) =>
  adminProxyPost('assign-user', { user_id: userId, proxy_index: proxyIndex })

export const drainAdminProxy = (proxyIndex: number) =>
  adminProxyPost('drain', { proxy_index: proxyIndex })

export const unbindAdminProxy = (target: { castle_email: string } | { user_id: string }) =>
  adminProxyPost('unbind', target)

export interface NetworkModeResponse {
  status: string
  network_mode: NetworkMode
  server_ip?: string
  enabled: boolean
  total_proxies: number
  residential_count?: number
  free_count?: number
  active_pool_name?: string
  total_bound_castles: number
  total_bound_users: number
}

export async function getAdminNetworkMode(): Promise<NetworkModeResponse> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/network-mode`, {
    headers: authHeaders,
  })
  if (!res.ok) throw new Error('فشل جلب نمط شبكة الاتصال')
  return res.json()
}

export async function toggleAdminNetworkMode(
  mode: NetworkMode
): Promise<{ status: string; network_mode: string; message: string }> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/network-mode/toggle`, {
    method: 'POST',
    headers: { ...authHeaders, 'Content-Type': 'application/json' },
    body: JSON.stringify({ mode })
  })
  if (!res.ok) {
    const data = await res.json().catch(() => ({}))
    throw new Error(data.detail || 'فشل تغيير نمط الشبكة')
  }
  return res.json()
}

// ─── Super Admin: Banned Castles (sealed by game admins) ───────
export interface AdminBannedCastle {
  castle_id: string
  game_email: string
  castle_name: string
  lord_name: string
  castle_level: number | null
  lord_level: number | null
  power: number | null
  server_id: string
  alliance_name: string
  is_active: boolean
  state: string
  conn_state: string
  seal_type: number | null
  seal_reason: string
  status_message: string
  banned_at: string
  created_at: string
  proxy_index: number | null
  owner: {
    uid: string
    email: string
    username: string
    phone: string
    tenant_domain: string
    is_banned: boolean
    subscription_end: string
  }
}

export async function fetchAdminBannedCastles(): Promise<AdminBannedCastle[]> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/banned-castles`, {
    headers: authHeaders,
  })
  if (!res.ok) {
    const data = await res.json().catch(() => ({}))
    throw new Error(data.detail || 'فشل جلب القلاع المحظورة')
  }
  const data = await res.json()
  return data?.castles || []
}

// ─── Super Admin: Users with full Castles List ────────────────
export interface AdminUserWithCastles {
  uid: string
  email: string
  display_name: string
  role: string
  is_banned: boolean
  created_at: string
  tenant_domain: string
  subscription: {
    plan_id: string
    plan_name: string
    status: string
    expires_at: string
    max_castles_allowed: number
  }
  castles: Castle[]
  castles_count: number
  running_count: number
}

export async function fetchAdminUsersCastles(): Promise<AdminUserWithCastles[]> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(`${getApiBaseUrl()}/api/admin/users-castles`, {
    headers: authHeaders,
  })
  if (!res.ok) {
    const data = await res.json().catch(() => ({}))
    throw new Error(data.detail || 'فشل جلب المستخدمين وقلاعهم')
  }
  const data = await res.json()
  const users = data?.users || []
  return users.map((u: any) => ({
    ...u,
    castles: (u.castles || []).map((c: any) => formatCastleFromApi(c)),
  }))
}

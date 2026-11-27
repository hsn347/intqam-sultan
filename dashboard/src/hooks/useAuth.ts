import { useState, useEffect, createContext, useContext, useCallback, useRef } from 'react'
import {
  onAuthStateChanged,
  signInWithEmailAndPassword,
  signOut,
  type User as FirebaseUser,
} from 'firebase/auth'
import { auth } from '../lib/firebase'
import { getUserProfile, updateUserProfileApi } from '../lib/botApi'
import { queryClient } from '../lib/queryClient'
import {
  getSavedAccounts,
  saveOrUpdateAccount,
  removeSavedAccount,
  getAccountCredentials,
  type SavedAccount,
} from '../lib/savedAccounts'
import type { User } from '../types'
import {
  MERCHANTS_CONFIG,
  DEFAULT_TENANT,
  getCurrentTenant,
  isUserAllowedForTenant,
} from '../config/tenants'

export function checkIsSuperAdmin(email: string): boolean {
  if (!email) return false
  const clean = email.trim().toLowerCase()
  return clean === 'ibraboths@gmail.com'
}

export function checkIsMerchantAdmin(email: string): boolean {
  if (!email) return false
  const clean = email.trim().toLowerCase()
  return MERCHANTS_CONFIG.some(m => m.adminEmail.trim().toLowerCase() === clean)
}

interface AuthContextType {
  firebaseUser: FirebaseUser | null
  user: User | null
  loading: boolean
  isSwitching: boolean
  savedAccounts: SavedAccount[]
  login: (email: string, password: string, rememberAccount?: boolean) => Promise<{ isAdmin: boolean }>
  switchAccount: (email: string, password?: string) => Promise<{ isAdmin: boolean }>
  logout: () => Promise<void>
  removeAccount: (email: string) => void
  refreshSavedAccounts: () => void
  isAdmin: boolean
  isSuperAdmin: boolean
  isMerchantAdmin: boolean
  updateUserProfile: (data: Partial<User>) => void
  refreshUserProfile: () => Promise<void>
}

export const AuthContext = createContext<AuthContextType | null>(null)

export function useAuth(): AuthContextType {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider')
  return ctx
}

// ─── Local Storage User Cache for Instant 0ms App Boot (Isolated per Tenant) ──────
function getTenantCacheKey(): string {
  if (typeof window === 'undefined') return 'ibra_auth_profile_main'
  try {
    const tenant = getCurrentTenant()
    return `ibra_auth_profile_${tenant.id || 'main'}`
  } catch {
    return 'ibra_auth_profile_main'
  }
}

function getInitialCachedUser(): User | null {
  if (typeof window === 'undefined') return null
  try {
    const tenant = getCurrentTenant()
    const key = getTenantCacheKey()
    let raw = localStorage.getItem(key)
    // 🛡️ التوافق الرجعي التام للدخول الفوري: فحص المفتاح العام الأصلي ibra_auth_profile واسترجاعه
    if (!raw) {
      raw = localStorage.getItem('ibra_auth_profile')
      if (raw) {
        try {
          localStorage.setItem(key, raw)
        } catch {}
      }
    }
    if (raw) {
      const parsed = JSON.parse(raw) as User
      if (parsed && parsed.uid) {
        if (tenant.id === 'main' || isUserAllowedForTenant(parsed, tenant)) {
          const email = String(parsed.email || '').trim().toLowerCase()
          const isSuper = checkIsSuperAdmin(email)
          const isMerchant = checkIsMerchantAdmin(email)
          if (!isSuper && !isMerchant && (parsed.role === 'admin' || parsed.role === 'merchant_admin')) {
            parsed.role = 'user'
          }
          return parsed
        }
      }
    }
  } catch {
    // ignore
  }
  return null
}

function saveCachedUser(user: User | null) {
  if (typeof window === 'undefined') return
  try {
    const key = getTenantCacheKey()
    if (user) {
      const email = String(user.email || '').trim().toLowerCase()
      const isSuper = checkIsSuperAdmin(email)
      const isMerchant = checkIsMerchantAdmin(email)
      if (!isSuper && !isMerchant && (user.role === 'admin' || user.role === 'merchant_admin')) {
        user.role = 'user'
      }
      const serialized = JSON.stringify(user)
      localStorage.setItem(key, serialized)
      // حفظ في المفتاح العام أيضاً لضمان استمرار الدخول الفوري دون انقطاع
      localStorage.setItem('ibra_auth_profile', serialized)
    } else {
      localStorage.removeItem(key)
      localStorage.removeItem('ibra_auth_profile')
    }
  } catch {
    // ignore
  }
}

export function useAuthProvider(): AuthContextType {
  const initialUser = getInitialCachedUser()
  const [firebaseUser, setFirebaseUser] = useState<FirebaseUser | null>(null)
  const [user, setUser] = useState<User | null>(initialUser)
  // If we have a cached user from a previous session, do not block app startup!
  const [loading, setLoading] = useState<boolean>(!initialUser)
  const [isSwitching, setIsSwitching] = useState<boolean>(false)
  const [savedAccounts, setSavedAccounts] = useState<SavedAccount[]>(() => getSavedAccounts())

  const refreshSavedAccounts = useCallback(() => {
    setSavedAccounts(getSavedAccounts())
  }, [])

  const profileSyncInFlightRef = useRef(false)
  const lastProfileSyncRef = useRef(0)

  const refreshUserProfile = useCallback(async (force: boolean = false) => {
    const fbUser = auth.currentUser
    if (!fbUser) return
    const now = Date.now()
    if (profileSyncInFlightRef.current) return
    if (!force && now - lastProfileSyncRef.current < 3000) return

    profileSyncInFlightRef.current = true
    lastProfileSyncRef.current = now
    try {
      const profile = await getUserProfile()
      if (!profile) return
      const tenant = getCurrentTenant()
      if (tenant.id !== 'main' && !isUserAllowedForTenant(profile, tenant)) {
        return
      }
      const userEmail = (fbUser.email || profile.email || '').trim().toLowerCase()
      const isSuperAdminEmail = checkIsSuperAdmin(userEmail)
      const isMerchantAdminEmail = checkIsMerchantAdmin(userEmail)
      if (isSuperAdminEmail) {
        profile.role = 'admin'
        profile.subscription = {
          ...(profile.subscription || {}),
          plan_id: 'super_admin_unlimited',
          plan_name: 'باقة المشرف الأعلى (غير محدود)',
          status: 'active',
          max_castles_allowed: 999999,
          expires_at: '2099-01-01T00:00:00Z',
          days_remaining: 99999,
        }
      } else if (isMerchantAdminEmail) {
        profile.role = 'merchant_admin'
      } else {
        profile.role = 'user'
      }

      let castlesStateChanged = false
      setUser(prev => {
        const sig = (u: User | null) => u ? JSON.stringify({
          role: u.role,
          username: u.username,
          phone: u.phone,
          is_banned: Boolean(u.is_banned),
          banned_reason: u.banned_reason || '',
          sub: u.subscription ? {
            status: u.subscription.status,
            plan_id: u.subscription.plan_id,
            plan_name: u.subscription.plan_name,
            expires_at: u.subscription.expires_at,
            max_castles_allowed: u.subscription.max_castles_allowed,
            current_castles_count: u.subscription.current_castles_count,
            pending_castles_count: u.subscription.pending_castles_count,
          } : null,
        }) : ''

        if (sig(prev) === sig(profile)) {
          return prev
        }
        castlesStateChanged = Boolean(
          !prev ||
          prev.is_banned !== profile.is_banned ||
          prev.subscription?.status !== profile.subscription?.status ||
          prev.subscription?.max_castles_allowed !== profile.subscription?.max_castles_allowed ||
          prev.subscription?.current_castles_count !== profile.subscription?.current_castles_count ||
          prev.subscription?.pending_castles_count !== profile.subscription?.pending_castles_count ||
          prev.subscription?.expires_at !== profile.subscription?.expires_at
        )
        saveCachedUser(profile)
        return profile
      })

      if (castlesStateChanged) {
        void queryClient.invalidateQueries({ queryKey: ['castles', profile.uid] })
      }
    } catch {
      // مزامنة صامتة في الخلفية بدون إزعاج المستخدم
    } finally {
      profileSyncInFlightRef.current = false
    }
  }, [])

  // مزامنة صامتة وخفيفة لملف المستخدم واشتراكه عند عودة التركيز للنافذة أو كل 15 ثانية (في التبويب المرئي فقط)
  useEffect(() => {
    if (!firebaseUser) return

    const onVisibleOrFocus = () => {
      if (document.visibilityState === 'visible') {
        void refreshUserProfile(false)
      }
    }
    const onForceRefresh = () => {
      void refreshUserProfile(true)
    }

    window.addEventListener('focus', onVisibleOrFocus)
    document.addEventListener('visibilitychange', onVisibleOrFocus)
    window.addEventListener('ibra:refresh-profile', onForceRefresh)
    const timer = window.setInterval(() => {
      if (document.visibilityState === 'visible') {
        void refreshUserProfile(false)
      }
    }, 15_000)

    return () => {
      window.removeEventListener('focus', onVisibleOrFocus)
      document.removeEventListener('visibilitychange', onVisibleOrFocus)
      window.removeEventListener('ibra:refresh-profile', onForceRefresh)
      window.clearInterval(timer)
    }
  }, [firebaseUser, refreshUserProfile])

  useEffect(() => {
    const unsubAuth = onAuthStateChanged(auth, async (fbUser) => {
      const tenant = getCurrentTenant()
      setFirebaseUser(fbUser)
      if (fbUser) {
        const userEmail = (fbUser.email || '').trim().toLowerCase()
        const isSuperAdminEmail = checkIsSuperAdmin(userEmail)
        const isMerchantAdminEmail = checkIsMerchantAdmin(userEmail)

        try {
          const profile = await getUserProfile()
          if (profile) {
            // 🛡️ التحقق الصارم من عزل النطاقات: النظام الرئيسي (main) متاح لجميع الحسابات الحالية دائماً ولا يسجل خروجها أبداً
            if (tenant.id !== 'main' && !isUserAllowedForTenant(profile, tenant)) {
              console.warn(`[useAuth] Account ${userEmail} does not belong to merchant ${tenant.id}. Forcing logout.`)
              await signOut(auth)
              setUser(null)
              saveCachedUser(null)
              setLoading(false)
              return
            }

            if (isSuperAdminEmail) {
              profile.role = 'admin'
              profile.subscription = {
                ...(profile.subscription || {}),
                plan_id: 'super_admin_unlimited',
                plan_name: 'باقة المشرف الأعلى (غير محدود)',
                status: 'active',
                max_castles_allowed: 999999,
                expires_at: '2099-01-01T00:00:00Z',
                days_remaining: 99999,
              }
            } else if (isMerchantAdminEmail) {
              profile.role = 'merchant_admin'
            } else {
              profile.role = 'user'
            }
            setUser(profile)
            saveCachedUser(profile)
            saveOrUpdateAccount({
              uid: profile.uid,
              email: profile.email,
              username: profile.username,
              role: profile.role,
              planName: profile.subscription?.plan_name,
            })
            refreshSavedAccounts()
          } else {
            // مستخدم مبدئي إذا تعذر الاتصال بالـ API مؤقتاً
            const fallback: User = {
              uid: fbUser.uid,
              email: userEmail,
              username: fbUser.displayName || userEmail.split('@')[0],
              role: isSuperAdminEmail ? 'admin' : (isMerchantAdminEmail ? 'merchant_admin' : 'user'),
              tenant_domain: isMerchantAdminEmail ? (tenant.domains[0] || '') : '',
              is_banned: false,
              created_at: new Date().toISOString(),
              subscription: {
                plan_id: isSuperAdminEmail ? 'super_admin_unlimited' : 'free',
                plan_name: isSuperAdminEmail ? 'المشرف الأعلى' : 'مجاني',
                status: 'active',
                max_castles_allowed: isSuperAdminEmail ? 999999 : 1,
                current_castles_count: 0,
                started_at: new Date().toISOString(),
                expires_at: '2099-01-01T00:00:00Z',
                days_remaining: 99999,
              }
            }

            if (tenant.id !== 'main' && !isUserAllowedForTenant(fallback, tenant)) {
              console.warn(`[useAuth] Fallback user ${userEmail} does not belong to merchant ${tenant.id}. Forcing logout.`)
              await signOut(auth)
              setUser(null)
              saveCachedUser(null)
              setLoading(false)
              return
            }

            setUser(fallback)
            saveCachedUser(fallback)
            saveOrUpdateAccount({
              uid: fallback.uid,
              email: fallback.email,
              username: fallback.username,
              role: fallback.role,
              planName: fallback.subscription?.plan_name,
            })
            refreshSavedAccounts()
          }
        } catch (err) {
          console.warn('[useAuth] Auth state error or domain rejected:', err)
          await signOut(auth)
          setUser(null)
          saveCachedUser(null)
        } finally {
          setLoading(false)
        }
      } else {
        setUser(null)
        saveCachedUser(null)
        setLoading(false)
      }
    })

    return () => unsubAuth()
  }, [refreshSavedAccounts])

  const login = async (
    email: string,
    password: string,
    rememberAccount: boolean = true
  ): Promise<{ isAdmin: boolean }> => {
    const tenant = getCurrentTenant()
    const cleanEmail = email.trim().toLowerCase()

    // 1. تسجيل الدخول عبر Firebase Auth
    const cred = await signInWithEmailAndPassword(auth, cleanEmail, password)
    const uid = cred.user.uid
    const userEmail = (cred.user.email || cleanEmail).trim().toLowerCase()
    const isSuperAdminEmail = checkIsSuperAdmin(userEmail)
    const isMerchantAdminEmail = checkIsMerchantAdmin(userEmail)
    const isAdmin = isSuperAdminEmail || isMerchantAdminEmail

    // 2. جلب الملف الشخصي والتحقق الصارم من تطابق النطاق
    let profile: User | null = null
    try {
      profile = await getUserProfile()
    } catch (e: any) {
      console.warn('Profile fetch error during login:', e)
      // إذا رفض الخادم المصادقة بسبب دومين غير مصرح به (403)
      await signOut(auth)
      saveCachedUser(null)
      const mismatchErr = new Error('هذا الحساب غير مسجل في هذا النظام')
      ;(mismatchErr as any).code = 'auth/tenant-mismatch'
      throw mismatchErr
    }

    const candidate: User = profile || ({
      uid,
      email: userEmail,
      username: cred.user.displayName || userEmail.split('@')[0],
      role: isSuperAdminEmail ? 'admin' : (isMerchantAdminEmail ? 'merchant_admin' : 'user'),
      tenant_domain: isMerchantAdminEmail ? (tenant.domains[0] || '') : '',
    } as User)

    // 🛡️ فحص العزل التام: منع أي حساب تابع لنظام آخر من الدخول
    if (!isUserAllowedForTenant(candidate, tenant)) {
      await signOut(auth)
      saveCachedUser(null)
      const mismatchErr = new Error('هذا الحساب غير مسجل في هذا النظام')
      ;(mismatchErr as any).code = 'auth/tenant-mismatch'
      throw mismatchErr
    }

    if (profile) {
      if (isSuperAdminEmail) {
        profile.role = 'admin'
      } else if (isMerchantAdminEmail) {
        profile.role = 'merchant_admin'
      } else {
        profile.role = 'user'
      }
      saveCachedUser(profile)
      setUser(profile)
    } else {
      saveCachedUser(candidate)
      setUser(candidate)
    }

    if (isAdmin) {
      const sessionToken = `sec_admin_${uid}_${Date.now()}`
      const sessionData = {
        uid,
        email: userEmail,
        role: isSuperAdminEmail ? 'admin' : 'merchant_admin',
        expiresAt: Date.now() + 60 * 60 * 1000,
        token: sessionToken,
      }
      sessionStorage.setItem('osmanli_admin_session_token', JSON.stringify(sessionData))
    }

    // حفظ الحساب في قائمة التبديل السريع الخاصة بهذا النطاق
    saveOrUpdateAccount(
      {
        uid,
        email: userEmail,
        username: profile?.username || cred.user.displayName || userEmail.split('@')[0],
        role: isSuperAdminEmail ? 'admin' : (isMerchantAdminEmail ? 'merchant_admin' : 'user'),
        planName: profile?.subscription?.plan_name,
      },
      rememberAccount ? password : undefined
    )
    refreshSavedAccounts()

    return { isAdmin }
  }

  const switchAccount = async (
    email: string,
    inputPassword?: string
  ): Promise<{ isAdmin: boolean }> => {
    setIsSwitching(true)
    try {
      const cleanEmail = email.trim().toLowerCase()
      let pass = inputPassword
      if (!pass) {
        const creds = getAccountCredentials(cleanEmail)
        pass = creds?.password
      }
      if (!pass) {
        throw new Error('PASSWORD_REQUIRED')
      }

      // إبطال الكاش الخاص بالحساب السابق فوراً لتفادي تداخل بيانات العملاء
      queryClient.clear()
      sessionStorage.removeItem('osmanli_admin_session_token')
      saveCachedUser(null)

      const cred = await signInWithEmailAndPassword(auth, cleanEmail, pass)
      const uid = cred.user.uid
      const isSuperAdminEmail = checkIsSuperAdmin(cleanEmail)
      const isMerchantAdminEmail = checkIsMerchantAdmin(cleanEmail)
      const isAdmin = isSuperAdminEmail || isMerchantAdminEmail

      let profile: User | null = null
      try {
        profile = await getUserProfile()
        if (profile) {
          if (isSuperAdminEmail) {
            profile.role = 'admin'
          } else if (isMerchantAdminEmail) {
            profile.role = 'merchant_admin'
          } else {
            profile.role = 'user'
          }
        }
      } catch (e) {
        console.warn('Profile fetch error during switch:', e)
        await signOut(auth)
        saveCachedUser(null)
        const mismatchErr = new Error('هذا الحساب غير مسجل في هذا النظام')
        ;(mismatchErr as any).code = 'auth/tenant-mismatch'
        throw mismatchErr
      }

      const tenant = getCurrentTenant()
      const candidate: User = profile || ({
        uid,
        email: cleanEmail,
        username: cred.user.displayName || cleanEmail.split('@')[0],
        role: isSuperAdminEmail ? 'admin' : (isMerchantAdminEmail ? 'merchant_admin' : 'user'),
        tenant_domain: isMerchantAdminEmail ? (tenant.domains[0] || '') : '',
      } as User)

      if (!isUserAllowedForTenant(candidate, tenant)) {
        await signOut(auth)
        saveCachedUser(null)
        const mismatchErr = new Error('هذا الحساب غير مسجل في هذا النظام')
        ;(mismatchErr as any).code = 'auth/tenant-mismatch'
        throw mismatchErr
      }

      if (isAdmin) {
        const sessionToken = `sec_admin_${uid}_${Date.now()}`
        const sessionData = {
          uid,
          email: cleanEmail,
          role: isSuperAdminEmail ? 'admin' : 'merchant_admin',
          expiresAt: Date.now() + 60 * 60 * 1000,
          token: sessionToken,
        }
        sessionStorage.setItem('osmanli_admin_session_token', JSON.stringify(sessionData))
      }

      const assignedRole = isSuperAdminEmail ? 'admin' : (isMerchantAdminEmail ? 'merchant_admin' : 'user')
      const effectiveUser: User = profile || ({
        uid,
        email: cleanEmail,
        username: cred.user.displayName || cleanEmail.split('@')[0],
        role: assignedRole,
        is_banned: false,
        created_at: new Date().toISOString(),
        subscription: {
          plan_id: isAdmin ? 'super_admin_unlimited' : 'free',
          plan_name: isSuperAdminEmail ? 'المشرف الأعلى' : (isMerchantAdminEmail ? 'مشرف التاجر' : 'مجاني'),
          status: 'active',
          max_castles_allowed: isAdmin ? 999999 : 1,
          current_castles_count: 0,
          started_at: new Date().toISOString(),
          expires_at: '2099-01-01T00:00:00Z',
          days_remaining: 99999,
        }
      } as User)

      setUser(effectiveUser)
      saveCachedUser(effectiveUser)

      // تحديث الحساب المحفوظ
      saveOrUpdateAccount(
        {
          uid,
          email: cleanEmail,
          username: effectiveUser.username,
          role: effectiveUser.role,
          planName: effectiveUser.subscription?.plan_name,
        },
        pass
      )
      refreshSavedAccounts()

      return { isAdmin }
    } finally {
      setIsSwitching(false)
    }
  }

  const logout = async () => {
    sessionStorage.removeItem('osmanli_admin_session_token')
    saveCachedUser(null)
    queryClient.clear()
    await signOut(auth)
    setUser(null)
  }

  const removeAccount = (email: string) => {
    removeSavedAccount(email)
    refreshSavedAccounts()
  }

  const updateUserProfile = (data: Partial<User>) => {
    setUser(prev => {
      const updated = prev ? { ...prev, ...data } : null
      saveCachedUser(updated)
      if (updated) {
        saveOrUpdateAccount({
          uid: updated.uid,
          email: updated.email,
          username: updated.username,
          role: updated.role,
          planName: updated.subscription?.plan_name,
        })
        refreshSavedAccounts()
      }
      return updated
    })
    updateUserProfileApi({ username: data.username, phone: data.phone }).catch(() => {})
  }

  const currentEmail = (firebaseUser?.email || user?.email || '').trim().toLowerCase()
  const isSuper = checkIsSuperAdmin(currentEmail)
  const isMerchant = checkIsMerchantAdmin(currentEmail)
  const isAnyAdmin = isSuper || (isMerchant && user?.role === 'merchant_admin')

  return {
    firebaseUser,
    user,
    loading,
    isSwitching,
    savedAccounts,
    login,
    switchAccount,
    logout,
    removeAccount,
    refreshSavedAccounts,
    isAdmin: isAnyAdmin,
    isSuperAdmin: isSuper,
    isMerchantAdmin: isMerchant,
    updateUserProfile,
    refreshUserProfile: () => refreshUserProfile(true),
  }
}


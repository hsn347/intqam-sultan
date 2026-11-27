import type { TFunction } from 'i18next'

/**
 * Localizes subscription plan names dynamically across AR, EN, and TR.
 * Handles:
 * - "باقة المشرف الأعلى (SuperAdmin)", "باقة المشرف الأعلى", "SuperAdmin" -> plans.superAdmin
 * - "X حساب" / "X accounts" / "X hesap" -> plans.accountsCount (e.g. "20 حساب" in AR, "20 Accounts" in EN, "20 Hesap" in TR)
 * - "مجاني" / "Free" -> plans.free
 * - "تجريبي" / "Trial" -> plans.trial
 */
export function localizePlanName(planName?: string | null, t?: TFunction): string {
  if (!planName) return '—'
  const raw = planName.trim()
  if (!t) return raw

  // 1. SuperAdmin plan
  if (
    raw.includes('المشرف الأعلى') ||
    raw.includes('المشرفة الاعلى') ||
    /superadmin/i.test(raw)
  ) {
    return t('plans.superAdmin', 'باقة المشرف الأعلى')
  }

  // 1b. Pending approval
  if (
    raw.includes('بانتظار موافقة الإدارة') ||
    raw.includes('بانتظار الموافقة') ||
    /pending/i.test(raw)
  ) {
    return t('dashboard.pendingApprovalStatus', 'بانتظار موافقة الإدارة')
  }

  // 2. Standalone expired
  if (/^(منتهي|منتهي الصلاحية|expired|süresi doldu)$/i.test(raw)) {
    return t('dashboard.expiredBadge', 'منتهي')
  }

  // 3. Free plan
  if (/^(مجاني|free|ücretsiz)$/i.test(raw)) {
    return t('plans.free', 'مجاني')
  }

  // 4. Trial plan
  if (/^(تجريبي|trial|deneme)$/i.test(raw)) {
    return t('plans.trial', 'تجريبي')
  }

  // 5. Account count with optional bracketed status (e.g. "25 حساب (منتهي)", "1 حساب", "5 accounts (expired)")
  const bracketMatch = raw.match(/^(\d+)\s*(?:حساب|accounts?|hesap)?(?:\s*\((.*?)\))?$/i)
  if (bracketMatch) {
    const count = parseInt(bracketMatch[1], 10)
    const suffix = bracketMatch[2]?.trim()

    const baseText = t('plans.accountsCount', {
      count,
      defaultValue: count === 1
        ? `1 ${t('accounts.accountUnit', 'حساب')}`
        : `${count} ${t('accounts.accountUnit', 'حساب')}`
    })

    if (suffix) {
      if (/^(منتهي|منتهي الصلاحية|expired|süresi doldu)$/i.test(suffix)) {
        return baseText
      }
      const daysMatch = suffix.match(/^(\d+)\s*(?:يوم|أيام|ايام|days?|gün)?$/i)
      if (daysMatch) {
        const days = parseInt(daysMatch[1], 10)
        return `${baseText} (${t('dashboard.daysRemaining', { count: days })})`
      }
      return `${baseText} (${suffix})`
    }
    return baseText
  }

  // 6. Fallback: strip any (منتهي) and replace known tokens in custom strings
  let result = raw.replace(/\s*\((?:منتهي|منتهي الصلاحية|expired|süresi doldu)\)/gi, '').trim()
  if (result.includes('منتهي')) {
    result = result.replace(/منتهي/g, t('dashboard.expiredBadge', 'منتهي'))
  }
  if (result.includes('حساب')) {
    const unit = t('accounts.accountUnit', 'حساب')
    result = result.replace(/حساب/g, unit)
  }

  return result.trim()
}

/**
 * Localizes known administrative usernames (e.g. "المشرف الأعلى (SuperAdmin)")
 */
export function localizeUsername(username?: string | null, t?: TFunction): string {
  if (!username) return ''
  const raw = username.trim()

  if (
    raw.includes('المشرف الأعلى') ||
    raw.includes('المشرفة الاعلى') ||
    raw === 'SuperAdmin' ||
    raw === 'Super Admin'
  ) {
    return t ? t('roles.superAdmin', 'المشرف الأعلى') : raw
  }

  return raw
}

/**
 * Localizes backend and API server errors into the active language (AR, EN, TR).
 * Handles messages like:
 * - "البريد الإلكتروني لهذه القلعة مسجل بالفعل في النظام، لا يمكن إضافة نفس القلعة مرتين" -> apiErrors.castleAlreadyExists
 * - "البريد الإلكتروني لهذه القلعة مسجل بالفعل لقلعة أخرى" -> apiErrors.emailBelongsToAnotherCastle
 * - Quota, banning, and server state messages.
 */
export function localizeApiError(rawError?: string | null, t?: TFunction): string {
  if (!rawError) return ''
  const str = String(rawError).trim()
  if (!t) return str

  // 1. Castle duplicate email
  if (
    str.includes('مسجل بالفعل في النظام') ||
    str.includes('لا يمكن إضافة نفس القلعة مرتين') ||
    str.includes('already registered in the system') ||
    str.includes('already exists')
  ) {
    return t('apiErrors.castleAlreadyExists', 'البريد الإلكتروني لهذه القلعة مسجل بالفعل في النظام، لا يمكن إضافة نفس القلعة مرتين')
  }

  // 2. Email belongs to another castle
  if (
    str.includes('مسجل بالفعل لقلعة أخرى') ||
    str.includes('already registered to another castle')
  ) {
    return t('apiErrors.emailBelongsToAnotherCastle', 'البريد الإلكتروني لهذه القلعة مسجل بالفعل لقلعة أخرى')
  }

  // 3. User banned from adding castles
  if (
    str.includes('حسابك محظور من قبل الإدارة، لا يمكنك إضافة قلاع جديدة') ||
    (str.includes('محظور من قبل الإدارة') && str.includes('إضافة قلاع'))
  ) {
    return t('apiErrors.bannedCannotAddCastles', 'حسابك محظور من قبل الإدارة، لا يمكنك إضافة قلاع جديدة')
  }

  // 4. Pending approval trial plan & cannot start bot pending
  if (
    str.includes('بانتظار موافقة الإدارة لتفعيل الباقة التجريبية') ||
    str.includes('لتفعيل الباقة التجريبية') ||
    (str.includes('لا يمكن تشغيل البوت') && str.includes('بانتظار موافقة الإدارة'))
  ) {
    return t('apiErrors.cannotStartPendingApproval', 'لا يمكن تشغيل البوت: حسابك بانتظار موافقة الإدارة لتفعيل الباقة التجريبية')
  }

  if (
    str.includes('بانتظار موافقة الإدارة أولاً لتفعيل باقة التجربة') ||
    str.includes('لتفعيل باقة التجربة') ||
    str.includes('بانتظار موافقة الإدارة')
  ) {
    return t('apiErrors.pendingApprovalTrial', 'الحساب بانتظار موافقة الإدارة أولاً لتفعيل باقة التجربة')
  }

  // 4b. Subscription suspended
  if (
    str.includes('تم تعليق اشتراكك مؤقتاً') ||
    str.includes('suspended')
  ) {
    return t('apiErrors.subscriptionSuspended', 'تم تعليق اشتراكك مؤقتاً من قبل الإدارة')
  }

  // 4b2. No active subscription
  if (
    str.includes('لا يوجد اشتراك نشط') ||
    str.includes('No active subscription')
  ) {
    return t('apiErrors.noActiveSubscription', 'لا يمكن تشغيل البوت: لا يوجد اشتراك نشط لحسابك، بانتظار موافقة وتفعيل الإدارة')
  }

  // 4c. Subscription expired on start
  if (
    str.includes('انتهت فترة اشتراكك') ||
    str.includes('انتهت صلاحية اشتراكك')
  ) {
    return t('apiErrors.subscriptionExpired', 'لا يمكن تشغيل البوت: انتهت فترة اشتراكك، يرجى التواصل مع الإدارة للتجديد')
  }

  // 4d. Castle frozen or inactive
  if (
    str.includes('هذه القلعة مجمدة أو غير مفعلة') ||
    str.includes('castle is currently frozen or inactive')
  ) {
    return t('apiErrors.castleInactive', 'هذه القلعة مجمدة أو غير مفعلة حالياً')
  }

  // 4e. Cannot stop other users' bots
  if (
    str.includes('غير مصرح بإيقاف بوتات مستخدم آخر') ||
    str.includes('Not authorized to stop other users')
  ) {
    return t('apiErrors.cannotStopOthers', 'غير مصرح بإيقاف بوتات مستخدم آخر')
  }

  // 4f. Admin only operation
  if (
    str.includes('هذه العملية مخصصة لمدير النظام فقط') ||
    str.includes('restricted to system administrators')
  ) {
    return t('apiErrors.adminOnlyOperation', 'هذه العملية مخصصة لمدير النظام فقط')
  }

  // 5. Max castles during pending approval (10 max)
  if (
    str.includes('وصلت للحد الأقصى المسموح به للقلاع المعلقة') ||
    str.includes('للقلاع المعلقة')
  ) {
    return t('apiErrors.pendingCastlesMaxLimit', {
      count: 30,
      defaultValue: 'وصلت للحد الأقصى المسموح به للقلاع المعلقة (30 قلعة كحد أقصى)',
    })
  }

  if (
    str.includes('أثناء انتظار الموافقة') ||
    str.includes('10 قلاع كحد أقصى')
  ) {
    return t('apiErrors.pendingApprovalMaxCastles', 'وصلت للحد الأقصى المسموح به أثناء انتظار الموافقة (10 قلاع كحد أقصى)')
  }

  // 5b. Cannot approve castle for banned or invalid owner
  if (
    str.includes('لا يمكن الموافقة على قلعة لمستخدم محظور') ||
    str.includes('لا يمكن الموافقة على القلعة')
  ) {
    return t('apiErrors.cannotApproveInvalidOwner', 'لا يمكن الموافقة على القلعة: اشتراك المالك غير نشط أو محظور')
  }

  // 6. Plan quota exceeded
  if (
    str.includes('وصلت للحد الأقصى من القلاع المسموح بها في باقتك') ||
    str.includes('تم تجاوز الحد المسموح') ||
    str.includes('quota exceeded')
  ) {
    return t('apiErrors.planQuotaExceeded', 'وصلت للحد الأقصى من القلاع المسموح بها في باقتك')
  }

  // 7. Castle not found
  if (
    str.includes('القلعة غير موجودة') ||
    str.includes('Castle not found')
  ) {
    return t('apiErrors.castleNotFound', 'القلعة غير موجودة')
  }

  // 8. User not found
  if (
    str.includes('المستخدم غير موجود') ||
    str.includes('User not found')
  ) {
    return t('apiErrors.userNotFound', 'المستخدم غير موجود')
  }

  // 9. Account banned general
  if (
    str.includes('الحساب محظور من قبل الإدارة') ||
    str.includes('تم حظر حسابك') ||
    str.includes('account is banned')
  ) {
    return t('apiErrors.accountBanned', 'الحساب محظور من قبل الإدارة')
  }

  // 9b. Password error / attempts left
  if (
    str.includes('كلمة السر خاطئة') ||
    str.includes('كلمة المرور غير صحيحة') ||
    str.includes('كلمة المرور خاطئة') ||
    str.includes('BUSINESS_ACCOUNT_PASSWORD_LIMIT') ||
    str.toLowerCase().includes('password error') ||
    str.toLowerCase().includes('wrong password') ||
    str.toLowerCase().includes('incorrect password')
  ) {
    const m = str.match(/(\d+)\s*(?:فرص|فرصة|attempts?|hak)/i)
    if (m) {
      const attempts = parseInt(m[1], 10)
      return t('apiErrors.passwordErrorWithAttempts', {
        count: attempts,
        defaultValue: `كلمة السر خاطئة، ولديك ${attempts} فرص`
      })
    }
    return t('apiErrors.passwordError', 'كلمة المرور غير صحيحة')
  }

  // 10. Game server connection failed
  if (
    str.includes('تعذر الاتصال بسيرفر اللعبة') ||
    str.includes('failed to connect to game server')
  ) {
    return t('apiErrors.gameServerConnectionFailed', 'تعذر الاتصال بسيرفر اللعبة')
  }

  // 11. Game server timeout
  if (
    str.includes('انتهت مهلة الاتصال بسيرفر اللعبة') ||
    (str.includes('timeout') && str.includes('سيرفر اللعبة'))
  ) {
    return t('apiErrors.gameServerTimeout', 'انتهت مهلة الاتصال بسيرفر اللعبة')
  }

  // 12. Update credentials failed
  if (str.includes('تعذر تحديث بيانات تسجيل الدخول للقلعة')) {
    return t('apiErrors.updateCredentialsFailed', 'تعذر تحديث بيانات تسجيل الدخول للقلعة')
  }

  // 13. Toggle active failed
  if (str.includes('تعذر تغيير حالة تفعيل القلعة')) {
    return t('apiErrors.toggleActiveFailed', 'تعذر تغيير حالة تفعيل القلعة')
  }

  // 14. Delete castle failed
  if (str.includes('تعذر حذف القلعة')) {
    return t('apiErrors.deleteCastleFailed', 'تعذر حذف القلعة')
  }

  // 15. Save castle failed in DB
  if (str.includes('تعذر حفظ القلعة في قاعدة البيانات')) {
    return t('apiErrors.saveCastleFailed', 'تعذر حفظ القلعة في قاعدة البيانات')
  }

  // 16. Update profile failed
  if (str.includes('تعذر تحديث الملف الشخصي')) {
    return t('apiErrors.updateProfileFailed', 'تعذر تحديث الملف الشخصي')
  }

  // 17. Castle suspended or inactive
  if (str.includes('لا يمكن تشغيل هذه القلعة لأنها معلقة أو غير مفعلة')) {
    return t('apiErrors.castleSuspendedOrInactive', 'لا يمكن تشغيل هذه القلعة لأنها معلقة أو غير مفعلة ضمن باقتك الحالية')
  }

  // 18. Account not registered
  if (str.includes('هذا الحساب غير مسجل في هذا النظام')) {
    return t('apiErrors.accountNotRegistered', 'هذا الحساب غير مسجل في هذا النظام')
  }

  // 19. Access denied
  if (
    str.includes('وصول مرفوض: لا تملك صلاحيات إدارة النظام') ||
    str.includes('لا تملك صلاحيات')
  ) {
    return t('apiErrors.accessDenied', 'وصول مرفوض: لا تملك صلاحيات إدارة النظام')
  }

  // 20. Server deploying / maintenance
  if (
    str.includes('السيرفر في وضع التحديث حالياً') ||
    str.includes('يرجى الانتظار حتى اكتمال التحديث')
  ) {
    return t('accounts.deployingToast', 'جاري رفع التغييرات إلى السيرفر... يرجى الانتظار حتى اكتمال التحديث واستئناف البوت تلقائياً')
  }

  return str
}

/**
 * Translates in-game castle ban/seal codes & raw backend seal reasons into concise localized text (AR, EN, TR).
 */
export function localizeCastleSealReason(
  sealType?: number | null,
  rawReason?: string | null,
  t?: TFunction
): string {
  const cleanRaw = String(rawReason || '')
    .replace(/❌\s*\[حساب محظور\]\s*(الحساب مجمد أو محظور من إدارة اللعبة:\s*)?/g, '')
    .trim()

  const inferCode = (): string | null => {
    if (sealType !== null && sealType !== undefined && !Number.isNaN(Number(sealType))) {
      return String(sealType)
    }
    const low = cleanRaw.toLowerCase()
    if (!low) return null
    if (cleanRaw.includes('بيع أو نقل') || low.includes('sell resource')) return '1'
    if (cleanRaw.includes('حسابات متعددة') || low.includes('too many accounts')) return '2'
    if (cleanRaw.includes('الدردشة') || cleanRaw.includes('الشتائم') || low.includes('curse') || low.includes('chat violation')) return '3'
    if (cleanRaw.includes('محذوف') || cleanRaw.includes('ملغى') || low.includes('account deleted')) return '4'
    if (cleanRaw.includes('تجميد') || low.includes('suspended') || low.includes('abnormal')) return '5'
    if (cleanRaw.includes('شحن غير قانوني') || low.includes('illegal recharge')) return '10'
    if (cleanRaw.includes('دعوة') || low.includes('invite')) return '11'
    if (cleanRaw.includes('بصمة الجهاز') || low.includes('device signature')) return '99'
    if (cleanRaw.includes('حظر عام') || low.includes('default seal')) return '0'
    return null
  }

  const code = inferCode()
  if (t && code !== null) {
    const defaults: Record<string, string> = {
      '0': 'حظر من إدارة اللعبة',
      '1': 'حظر بسبب بيع أو نقل الموارد',
      '2': 'حظر بسبب تعدد الحسابات',
      '3': 'حظر بسبب مخالفة الدردشة',
      '4': 'الحساب محذوف أو ملغى',
      '5': 'تجميد الحساب (نشاط غير طبيعي)',
      '10': 'حظر بسبب شحن غير قانوني',
      '11': 'حظر بسبب رسائل الدعوة في الدردشة',
      '99': 'حظر بصمة الجهاز',
    }
    if (code in defaults) {
      return t(`sealReasons.${code}`, defaults[code])
    }
  }

  if (cleanRaw) {
    return cleanRaw
  }
  return t ? t('sealReasons.fallback', 'تم حظر أو تجميد الحساب من إدارة اللعبة') : 'تم حظر أو تجميد الحساب من إدارة اللعبة'
}


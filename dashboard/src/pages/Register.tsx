import React, { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useNavigate, Link } from 'react-router-dom'
import { Eye, EyeOff, UserPlus, AlertCircle } from 'lucide-react'
import { createUserWithEmailAndPassword } from 'firebase/auth'
import { auth } from '../lib/firebase'
import { registerUser } from '../lib/botApi'
import { motion } from 'framer-motion'
import toast from 'react-hot-toast'
import clsx from 'clsx'
import {
  normalizeEmail,
  validateEmail,
  validateRegisterPassword,
  validateConfirmPassword,
  validateUsername,
  getPasswordStrength,
  mapFirebaseAuthError,
} from '../lib/validation'
import { AuthHeaderBar } from '../components/common/AuthHeaderBar'
import { useTenant } from '../context/TenantContext'

export function RegisterPage() {
  const { t } = useTranslation()
  const { brandName, tagline, logoUrl, isCustomTenant, tenant } = useTenant()
  const navigate = useNavigate()

  const [username, setUsername] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [showPw, setShowPw] = useState(false)
  const [loading, setLoading] = useState(false)

  // Validation errors
  const [errors, setErrors] = useState<{
    username?: string
    email?: string
    password?: string
    confirm?: string
    general?: string
  }>({})

  // Real-time password strength
  const pwStrength = getPasswordStrength(password, t)

  const handleUsernameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUsername(e.target.value)
    if (errors.username || errors.general) {
      setErrors(prev => ({ ...prev, username: undefined, general: undefined }))
    }
  }

  const handleEmailChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEmail(e.target.value)
    if (errors.email || errors.general) {
      setErrors(prev => ({ ...prev, email: undefined, general: undefined }))
    }
  }

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value
    setPassword(val)
    if (errors.password || errors.general) {
      setErrors(prev => ({ ...prev, password: undefined, general: undefined }))
    }
    // Also re-check confirm mismatch if confirm was already entered
    if (confirm && val !== confirm) {
      setErrors(prev => ({ ...prev, confirm: t('validation.passwordMismatch', 'كلمتا المرور غير متطابقتين') }))
    } else if (confirm && val === confirm) {
      setErrors(prev => ({ ...prev, confirm: undefined }))
    }
  }

  const handleConfirmChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value
    setConfirm(val)
    if (errors.confirm || errors.general) {
      setErrors(prev => ({ ...prev, confirm: undefined, general: undefined }))
    }
  }

  const handleUsernameBlur = () => {
    if (username.trim()) {
      const err = validateUsername(username, t)
      if (err) setErrors(prev => ({ ...prev, username: err }))
    }
  }

  const handleEmailBlur = () => {
    if (email.trim()) {
      const err = validateEmail(email, t)
      if (err) setErrors(prev => ({ ...prev, email: err }))
    }
  }

  const handlePasswordBlur = () => {
    if (password) {
      const err = validateRegisterPassword(password, t)
      if (err) setErrors(prev => ({ ...prev, password: err }))
    }
  }

  const handleConfirmBlur = () => {
    if (confirm) {
      const err = validateConfirmPassword(password, confirm, t)
      if (err) setErrors(prev => ({ ...prev, confirm: err }))
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    // Comprehensive validation of all fields before network call
    const cleanEmail = normalizeEmail(email)
    const usernameErr = validateUsername(username, t)
    const emailErr = validateEmail(cleanEmail, t)
    const passwordErr = validateRegisterPassword(password, t)
    const confirmErr = validateConfirmPassword(password, confirm, t)

    if (usernameErr || emailErr || passwordErr || confirmErr) {
      setErrors({
        username: usernameErr || undefined,
        email: emailErr || undefined,
        password: passwordErr || undefined,
        confirm: confirmErr || undefined,
      })
      return
    }

    setLoading(true)
    setErrors({})

    try {
      const cred = await createUserWithEmailAndPassword(auth, cleanEmail, password)
      // تسجيل المستخدم في قاعدة بيانات SQLite المحلية عبر REST API مع تحديد الدومين
      const tenantDomain = (isCustomTenant && tenant?.domains?.[0])
        ? tenant.domains[0]
        : (typeof window !== 'undefined' ? window.location.hostname : '')

      await registerUser({
        uid: cred.user.uid,
        email: cleanEmail,
        username: username.trim() || cleanEmail.split('@')[0],
        tenant_domain: tenantDomain,
      })
      toast.success(t('register.success'))
      navigate('/dashboard')
    } catch (err: unknown) {
      const mapped = mapFirebaseAuthError(err, t)
      if (mapped.field === 'email') {
        setErrors(prev => ({ ...prev, email: mapped.message }))
      } else {
        setErrors(prev => ({ ...prev, general: mapped.message }))
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="relative flex justify-center items-center bg-[#f1f5f2] dark:bg-[#0a0f0a] p-4 min-h-screen overflow-hidden text-gray-900 dark:text-white transition-colors duration-200">
      {/* Top Header Bar with Theme & Language Switches */}
      <AuthHeaderBar />

      {/* Background ambient glow */}
      <div
        className="top-1/4 left-1/2 absolute opacity-20 blur-3xl rounded-full w-96 h-96 -translate-x-1/2 pointer-events-none"
        style={{ backgroundColor: 'var(--theme-primary)' }}
      />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
        style={{
          borderColor: 'rgba(var(--theme-primary-rgb), 0.25)',
          boxShadow: '0 24px 64px rgba(var(--theme-primary-rgb), 0.12)',
        }}
        className="z-10 relative bg-white dark:bg-[#0c120f] p-6 sm:p-8 border rounded-2xl w-full max-w-sm overflow-hidden"
      >
        {/* Top Accent */}
        <div
          className="top-0 absolute inset-x-0 h-1"
          style={{
            background: 'linear-gradient(90deg, var(--theme-primary), var(--theme-primary-light), var(--theme-primary))',
          }}
        />

        {/* Logo */}
        <div className="mb-6 text-center">
          <div
            className="flex justify-center items-center bg-gray-100 dark:bg-white/5 shadow-xs mx-auto mb-3 border rounded-2xl w-14 h-14 overflow-hidden"
            style={{ borderColor: 'rgba(var(--theme-primary-rgb), 0.35)' }}
          >
            <img
              src={logoUrl || '/logo.png?v=2'}
              alt={brandName}
              className="w-full h-full object-cover"
            />
          </div>
          <h1 className="font-bold text-gray-900 dark:text-white text-xl tracking-wide">{t('register.title')}</h1>
          {tagline ? (
            <p className="mt-1 font-bold text-xs" style={{ color: 'var(--theme-primary)' }}>{tagline}</p>
          ) : null}
          <p className="mt-1 text-gray-500 dark:text-gray-400 text-xs">{t('register.subtitle', { brand: brandName })}</p>
        </div>

        {/* General server error alert */}
        {errors.general && (
          <div className="flex items-center gap-2 bg-rose-500/15 mb-3.5 p-3 border border-rose-500/35 rounded-xl text-rose-600 dark:text-rose-300 text-xs">
            <AlertCircle size={15} className="text-rose-500 shrink-0" />
            <span>{errors.general}</span>
          </div>
        )}

        {/* Form with noValidate to prevent native browser tooltip bubbles */}
        <form noValidate onSubmit={handleSubmit} className="space-y-3.5">
          {/* Username */}
          <div>
            <label className="block mb-1.5 font-medium text-gray-700 dark:text-gray-300 text-sm">{t('register.username')}</label>
            <input
              id="reg-username"
              type="text"
              value={username}
              onChange={handleUsernameChange}
              onBlur={handleUsernameBlur}
              className={clsx(
                'bg-gray-50/70 focus:bg-white dark:focus:bg-dark-surface dark:bg-dark-surface/60 border-gray-300 dark:border-white/10 text-gray-900 dark:text-white input-field',
                errors.username && '!border-rose-500/80 !ring-1 !ring-rose-500/30 bg-rose-500/5'
              )}
              placeholder={t('register.usernamePlaceholder')}
            />
            {errors.username && (
              <p className="flex items-center gap-1.5 mt-1.5 text-rose-500 dark:text-rose-400 text-xs">
                <AlertCircle size={13} className="shrink-0" />
                <span>{errors.username}</span>
              </p>
            )}
          </div>

          {/* Email */}
          <div>
            <label className="block mb-1.5 font-medium text-gray-700 dark:text-gray-300 text-sm">{t('register.email')}</label>
            <input
              id="reg-email"
              type="email"
              inputMode="email"
              autoComplete="email"
              autoCapitalize="none"
              autoCorrect="off"
              spellCheck={false}
              value={email}
              onChange={handleEmailChange}
              onBlur={handleEmailBlur}
              className={clsx(
                'bg-gray-50/70 focus:bg-white dark:focus:bg-dark-surface dark:bg-dark-surface/60 border-gray-300 dark:border-white/10 text-gray-900 dark:text-white input-field',
                errors.email && '!border-rose-500/80 !ring-1 !ring-rose-500/30 bg-rose-500/5'
              )}
              placeholder="name@example.com"
              dir="ltr"
            />
            {errors.email && (
              <p className="flex items-center gap-1.5 mt-1.5 text-rose-500 dark:text-rose-400 text-xs">
                <AlertCircle size={13} className="shrink-0" />
                <span>{errors.email}</span>
              </p>
            )}
          </div>

          {/* Password */}
          <div>
            <label className="block mb-1.5 font-medium text-gray-700 dark:text-gray-300 text-sm">{t('register.password')}</label>
            <div className="relative">
              <input
                id="reg-password"
                type={showPw ? 'text' : 'password'}
                autoComplete="new-password"
                value={password}
                onChange={handlePasswordChange}
                onBlur={handlePasswordBlur}
                className={clsx(
                  'bg-gray-50/70 focus:bg-white dark:focus:bg-dark-surface dark:bg-dark-surface/60 pe-10 border-gray-300 dark:border-white/10 text-gray-900 dark:text-white input-field',
                  errors.password &&
                    '!border-rose-500/80 !ring-1 !ring-rose-500/30 bg-rose-500/5'
                )}
                placeholder="••••••••"
              />
              <button
                type="button"
                onClick={() => setShowPw(v => !v)}
                className="absolute inset-y-0 flex items-center text-gray-400 end-3"
                tabIndex={-1}
              >
                {showPw ? <EyeOff size={15} /> : <Eye size={15} />}
              </button>
            </div>

            {/* Password Strength Indicator */}
            {password && pwStrength && (
              <div className="space-y-1.5 mt-2">
                <div className="flex justify-between items-center text-[11px]">
                  <span className="text-gray-500 dark:text-gray-400">{t('validation.passwordStrength', 'قوة كلمة المرور:')}</span>
                  <span className={clsx('font-bold', pwStrength.colorClass)}>
                    {pwStrength.label}
                  </span>
                </div>
                <div className="gap-1.5 grid grid-cols-3 h-1">
                  <div
                    className={clsx(
                      'rounded-full transition-colors duration-300',
                      pwStrength.score >= 1 ? pwStrength.bgClass : 'bg-gray-200 dark:bg-gray-700/50'
                    )}
                  />
                  <div
                    className={clsx(
                      'rounded-full transition-colors duration-300',
                      pwStrength.score >= 2 ? pwStrength.bgClass : 'bg-gray-200 dark:bg-gray-700/50'
                    )}
                  />
                  <div
                    className={clsx(
                      'rounded-full transition-colors duration-300',
                      pwStrength.score >= 3 ? pwStrength.bgClass : 'bg-gray-200 dark:bg-gray-700/50'
                    )}
                  />
                </div>
              </div>
            )}

            {errors.password && (
              <p className="flex items-center gap-1.5 mt-1.5 text-rose-500 dark:text-rose-400 text-xs">
                <AlertCircle size={13} className="shrink-0" />
                <span>{errors.password}</span>
              </p>
            )}
          </div>

          {/* Confirm Password */}
          <div>
            <label className="block mb-1.5 font-medium text-gray-700 dark:text-gray-300 text-sm">{t('register.confirmPassword')}</label>
            <input
              id="reg-confirm"
              type="password"
              autoComplete="new-password"
              value={confirm}
              onChange={handleConfirmChange}
              onBlur={handleConfirmBlur}
              className={clsx(
                'bg-gray-50/70 focus:bg-white dark:focus:bg-dark-surface dark:bg-dark-surface/60 border-gray-300 dark:border-white/10 text-gray-900 dark:text-white input-field',
                errors.confirm && '!border-rose-500/80 !ring-1 !ring-rose-500/30 bg-rose-500/5'
              )}
              placeholder="••••••••"
            />
            {errors.confirm && (
              <p className="flex items-center gap-1.5 mt-1.5 text-rose-500 dark:text-rose-400 text-xs">
                <AlertCircle size={13} className="shrink-0" />
                <span>{errors.confirm}</span>
              </p>
            )}
          </div>

          {/* Free plan notice */}
          <div
            className="flex items-center gap-2 p-3 border rounded-xl text-xs"
            style={{
              backgroundColor: 'rgba(var(--theme-primary-rgb), 0.08)',
              borderColor: 'rgba(var(--theme-primary-rgb), 0.25)',
              color: 'var(--theme-primary)',
            }}
          >
            <span>🎁</span>
            <span>{t('register.freePlanNotice')}</span>
          </div>

          {/* Submit */}
          <button
            id="register-submit"
            type="submit"
            disabled={loading}
            style={{ backgroundColor: 'var(--theme-primary)', color: '#ffffff' }}
            className="flex justify-center items-center gap-2 shadow-sm mt-1 py-3 rounded-xl w-full font-bold active:scale-[0.99] cursor-pointer"
          >
            {loading ? (
              t('register.loading')
            ) : (
              <>
                <UserPlus size={16} />
                {t('register.submit')}
              </>
            )}
          </button>
        </form>

        {/* Back to login */}
        <p className="mt-5 text-gray-500 dark:text-gray-400 text-sm text-center">
          {t('register.hasAccount')}{' '}
          <Link
            to="/login"
            style={{ color: 'var(--theme-primary)' }}
            className="font-bold"
          >
            {t('register.signIn')}
          </Link>
        </p>
      </motion.div>
    </div>
  )
}

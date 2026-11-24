import React, { useState, useEffect, useRef } from 'react'
import { createPortal } from 'react-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { X, Plus, Loader2, Mail, Sparkles, Eye, EyeOff } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { useAddCastle } from '../../hooks/useCastles'
import { localizeApiError } from '../../lib/localize'
import toast from 'react-hot-toast'

interface AddCastleModalProps {
  isOpen: boolean
  onClose: () => void
  userId: string
}

export function AddCastleModal({ isOpen, onClose, userId }: AddCastleModalProps) {
  const { t } = useTranslation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const emailRef = useRef<HTMLInputElement>(null)

  const addCastleMutation = useAddCastle(userId)

  // Focus email on open
  useEffect(() => {
    if (isOpen) {
      setTimeout(() => emailRef.current?.focus(), 80)
    }
  }, [isOpen])

  // Close on Escape
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) onClose()
    }
    document.addEventListener('keydown', handler)
    return () => document.removeEventListener('keydown', handler)
  }, [isOpen, onClose])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!email.trim() || !password) {
      toast.error(t('modals.fillAllFields'))
      return
    }

    try {
      const result = await addCastleMutation.mutateAsync({
        email: email.trim(),
        password,
      })

      if (result.isPending) {
        toast(t('modals.pendingQueueNotice'), {
          icon: '🕒',
          duration: 5000,
        })
      } else {
        toast.success('✅ ' + t('modals.castleAddedSuccess'))
      }

      setEmail('')
      setPassword('')
      setShowPassword(false)
      onClose()
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : t('common.error')
      toast.error(localizeApiError(msg, t))
    }
  }

  const handleClose = () => {
    if (addCastleMutation.isPending) return
    setEmail('')
    setPassword('')
    setShowPassword(false)
    onClose()
  }

  return createPortal(
    <AnimatePresence>
      {isOpen && (
        <>
          {/* ─── Backdrop ─── */}
          <motion.div
            key="modal-backdrop"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.18 }}
            onClick={handleClose}
            className="modal-backdrop"
            style={{
              position: 'fixed',
              inset: 0,
              zIndex: 9998,
              background: 'rgba(0,0,0,0.72)',
              backdropFilter: 'blur(8px)',
              WebkitBackdropFilter: 'blur(8px)',
            }}
          />

          {/* ─── Modal Panel ─── */}
          <div
            style={{
              position: 'fixed',
              inset: 0,
              zIndex: 9999,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              padding: '1rem',
              pointerEvents: 'none',
            }}
          >
            <motion.div
              key="modal-panel"
              initial={{ scale: 0.94, opacity: 0, y: 16 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              exit={{ scale: 0.94, opacity: 0, y: 12 }}
              transition={{ duration: 0.2, ease: 'easeOut' }}
              onClick={e => e.stopPropagation()}
              className="relative shadow-2xl rounded-2xl w-full max-w-[440px] overflow-hidden edit-castle-modal-box"
              style={{
                pointerEvents: 'all',
              }}
            >
              {/* Glow accent bar at the top */}
              <div
                style={{
                  height: '2px',
                  background: 'linear-gradient(90deg, transparent 0%, var(--theme-primary) 40%, var(--theme-primary-light, var(--theme-primary)) 60%, transparent 100%)',
                  opacity: 0.9,
                }}
              />

              <div className="p-6 sm:p-7">
                {/* ─ Header ─ */}
                <div className="flex justify-between items-start mb-5">
                  <div className="flex items-center gap-3">
                    <div
                      className="flex justify-center items-center bg-primary-500/15 shadow-sm border border-primary-500/30 rounded-xl w-10 h-10 shrink-0"
                    >
                      <Sparkles size={18} className="text-primary-500" />
                    </div>
                    <div>
                      <h2 className="m-0 font-bold text-gray-900 dark:text-white text-base edit-modal-title">
                        {t('modals.addCastleTitle')}
                      </h2>
                      <p className="m-0 mt-0.5 text-gray-500 dark:text-gray-400 text-xs edit-modal-subtitle">
                        {t('modals.addCastleSubtitle')}
                      </p>
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={handleClose}
                    disabled={addCastleMutation.isPending}
                    className="bg-gray-100 dark:bg-white/5 p-1.5 border border-gray-200 dark:border-white/8 rounded-lg text-gray-400 cursor-pointer edit-modal-btn-close"
                    title={t('modals.close')}
                  >
                    <X size={16} />
                  </button>
                </div>

                {/* ─ Form ─ */}
                <form onSubmit={handleSubmit} autoComplete="off">
                  {/* Email */}
                  <div className="mb-4">
                    <label className="block mb-1.5 font-semibold text-gray-700 dark:text-gray-300 text-xs edit-modal-label">
                      {t('modals.email', t('settings.email', 'البريد الإلكتروني'))}
                    </label>
                    <div className="relative">
                      <Mail size={15} className="top-1/2 absolute text-gray-400 -translate-y-1/2 pointer-events-none end-3" />
                      <input
                        id="new-castle-email"
                        name="new_castle_account_email"
                        ref={emailRef}
                        type="email"
                        required
                        value={email}
                        onChange={e => setEmail(e.target.value)}
                        placeholder="example@gmail.com"
                        dir="ltr"
                        autoComplete="off"
                        className="bg-white dark:bg-white/5 py-2.5 ps-3.5 pe-9 border border-gray-300 focus:border-primary-500 dark:border-white/10 rounded-xl outline-none focus:ring-2 focus:ring-primary-500/20 w-full text-gray-900 dark:text-white text-sm transition-all edit-modal-input placeholder-gray-400 dark:placeholder-gray-500"
                      />
                    </div>
                  </div>

                  {/* Password */}
                  <div className="mb-6">
                    <label className="block mb-1.5 font-semibold text-gray-700 dark:text-gray-300 text-xs edit-modal-label">
                      {t('modals.password', t('settings.password', 'كلمة المرور'))}
                    </label>
                    <div className="relative">
                      <input
                        id="new-castle-password"
                        name="new_castle_account_password"
                        type={showPassword ? 'text' : 'password'}
                        required
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        placeholder="••••••••"
                        dir="ltr"
                        autoComplete="new-password"
                        className="bg-white dark:bg-white/5 py-2.5 ps-3.5 pe-9 border border-gray-300 focus:border-primary-500 dark:border-white/10 rounded-xl outline-none focus:ring-2 focus:ring-primary-500/20 w-full text-gray-900 dark:text-white text-sm transition-all edit-modal-input placeholder-gray-400 dark:placeholder-gray-500"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(v => !v)}
                        className="top-1/2 absolute flex justify-center items-center p-1 rounded-md focus:outline-none text-gray-400 -translate-y-1/2 cursor-pointer end-3"
                        title={showPassword ? t('modals.hidePassword') : t('modals.showPassword')}
                        aria-label={showPassword ? t('modals.hidePassword') : t('modals.showPassword')}
                      >
                        {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                      </button>
                    </div>
                  </div>

                  {/* ─ Divider ─ */}
                  <div className="bg-gray-200 dark:bg-white/8 mb-5 h-[1px] edit-modal-divider" />

                  {/* ─ Buttons ─ */}
                  <div className="flex gap-2.5">
                    {/* Cancel */}
                    <button
                      type="button"
                      onClick={handleClose}
                      disabled={addCastleMutation.isPending}
                      className="flex-1 bg-gray-100 dark:bg-white/5 disabled:opacity-50 px-3 py-2.5 border border-gray-300 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-xs sm:text-sm cursor-pointer edit-modal-btn-cancel"
                    >
                      {t('modals.cancel')}
                    </button>

                    {/* Submit */}
                    <button
                      type="submit"
                      id="submit-add-castle"
                      disabled={addCastleMutation.isPending}
                      className="flex flex-1 justify-center items-center gap-1.5 bg-primary-600 disabled:opacity-50 px-3 py-2.5 rounded-xl font-bold text-white text-xs sm:text-sm active:scale-98 cursor-pointer edit-modal-btn-submit"
                    >
                      {addCastleMutation.isPending ? (
                        <>
                          <Loader2 size={15} className="animate-spin" />
                          <span>{t('modals.adding')}</span>
                        </>
                      ) : (
                        <>
                          <Plus size={16} />
                          <span>{t('accounts.addAccount')}</span>
                        </>
                      )}
                    </button>
                  </div>
                </form>
              </div>
            </motion.div>
          </div>
        </>
      )}
    </AnimatePresence>,
    document.body
  )
}

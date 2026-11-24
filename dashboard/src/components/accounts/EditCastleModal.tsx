import React, { useState, useEffect } from 'react'
import { createPortal } from 'react-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { X, RotateCw, Loader2, Mail, Lock, Edit3 } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { useUpdateCastleCredentials } from '../../hooks/useCastles'
import { localizeApiError } from '../../lib/localize'
import type { Castle } from '../../types'
import toast from 'react-hot-toast'

interface EditCastleModalProps {
  castle: Castle | null
  isOpen: boolean
  onClose: () => void
  userId: string
}

export function EditCastleModal({ castle, isOpen, onClose, userId }: EditCastleModalProps) {
  const { t } = useTranslation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const updateMutation = useUpdateCastleCredentials(userId)

  useEffect(() => {
    if (castle) {
      setEmail(castle.email || '')
      setPassword('') // أبداً لا يتم ملء أو استرجاع كلمة المرور الحالية
    }
  }, [castle, isOpen])

  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) onClose()
    }
    document.addEventListener('keydown', handler)
    return () => document.removeEventListener('keydown', handler)
  }, [isOpen, onClose])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!email.trim()) {
      toast.error(t('modals.fillAllFields'))
      return
    }

    try {
      await updateMutation.mutateAsync({
        castleId: castle!.id,
        email: email.trim(),
        password: password.trim() || undefined,
      })
      toast.success('✅ ' + t('common.success'))
      onClose()
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : t('common.error')
      toast.error(localizeApiError(msg, t))
    }
  }

  const handleClose = () => {
    if (updateMutation.isPending) return
    onClose()
  }

  return createPortal(
    <AnimatePresence>
      {isOpen && castle && (
        <>
          {/* Backdrop */}
          <motion.div
            key="edit-backdrop"
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

          {/* Modal Panel Container */}
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
              key="edit-panel"
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
              {/* Glow accent bar */}
              <div
                style={{
                  height: '2px',
                  background: 'linear-gradient(90deg, transparent 0%, var(--theme-primary) 40%, var(--theme-primary-light, var(--theme-primary)) 60%, transparent 100%)',
                  opacity: 0.9,
                }}
              />

              <div className="p-6 sm:p-7">
                {/* Header */}
                <div className="flex justify-between items-start mb-5">
                  <div className="flex items-center gap-3">
                    <div
                      className="flex justify-center items-center bg-primary-500/15 shadow-sm border border-primary-500/30 rounded-xl w-10 h-10 shrink-0"
                    >
                      <Edit3 size={18} className="text-primary-500" />
                    </div>
                    <div>
                      <h2 className="m-0 font-bold text-gray-900 dark:text-white text-base edit-modal-title">
                        {t('modals.editCastleTitle')}
                      </h2>
                      <p className="m-0 mt-0.5 max-w-[240px] text-gray-500 dark:text-gray-400 text-xs truncate edit-modal-subtitle">
                        {castle.email}
                      </p>
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={handleClose}
                    disabled={updateMutation.isPending}
                    className="bg-gray-100 dark:bg-white/5 p-1.5 border border-gray-200 dark:border-white/8 rounded-lg text-gray-400 cursor-pointer edit-modal-btn-close"
                    title={t('modals.close')}
                  >
                    <X size={16} />
                  </button>
                </div>

                {/* Form */}
                <form onSubmit={handleSubmit} autoComplete="off">
                  {/* Email Field */}
                  <div className="mb-4">
                    <label className="block mb-1.5 font-semibold text-gray-700 dark:text-gray-300 text-xs edit-modal-label">
                      {t('modals.email', t('settings.email', 'البريد الإلكتروني'))}
                    </label>
                    <div className="relative">
                      <Mail size={15} className="top-1/2 absolute text-gray-400 -translate-y-1/2 pointer-events-none end-3" />
                      <input
                        id="edit-castle-email"
                        name="edit_castle_account_email"
                        type="email"
                        required
                        value={email}
                        onChange={e => setEmail(e.target.value)}
                        dir="ltr"
                        autoComplete="off"
                        className="bg-white dark:bg-white/5 py-2.5 ps-3.5 pe-9 border border-gray-300 focus:border-primary-500 dark:border-white/10 rounded-xl outline-none focus:ring-2 focus:ring-primary-500/20 w-full text-gray-900 dark:text-white text-sm transition-all edit-modal-input placeholder-gray-400 dark:placeholder-gray-500"
                      />
                    </div>
                  </div>

                  {/* Password Field */}
                  <div className="mb-6">
                    <label className="block mb-1.5 font-semibold text-gray-700 dark:text-gray-300 text-xs edit-modal-label">
                      {t('settings.newPassword', 'كلمة المرور الجديدة')}
                    </label>
                    <div className="relative">
                      <Lock size={15} className="top-1/2 absolute text-gray-400 -translate-y-1/2 pointer-events-none end-3" />
                      <input
                        id="edit-castle-password"
                        name="edit_castle_account_password"
                        type="password"
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        placeholder={t('modals.leaveEmptyToKeep')}
                        dir="ltr"
                        autoComplete="new-password"
                        className="bg-white dark:bg-white/5 py-2.5 ps-3.5 pe-9 border border-gray-300 focus:border-primary-500 dark:border-white/10 rounded-xl outline-none focus:ring-2 focus:ring-primary-500/20 w-full text-gray-900 dark:text-white text-sm transition-all edit-modal-input placeholder-gray-400 dark:placeholder-gray-500"
                      />
                    </div>
                  </div>

                  {/* Divider */}
                  <div className="bg-gray-200 dark:bg-white/8 mb-5 h-[1px] edit-modal-divider" />

                  {/* Action Buttons */}
                  <div className="flex gap-2.5">
                    <button
                      type="button"
                      onClick={handleClose}
                      disabled={updateMutation.isPending}
                      className="flex-1 bg-gray-100 dark:bg-white/5 disabled:opacity-50 px-3 py-2.5 border border-gray-300 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-xs sm:text-sm cursor-pointer edit-modal-btn-cancel"
                    >
                      {t('modals.cancel')}
                    </button>

                    <button
                      type="submit"
                      id="submit-edit-castle"
                      disabled={updateMutation.isPending}
                      className="flex flex-1 justify-center items-center gap-1.5 bg-primary-600 disabled:opacity-50 px-3 py-2.5 rounded-xl font-bold text-white text-xs sm:text-sm active:scale-98 cursor-pointer edit-modal-btn-submit"
                    >
                      {updateMutation.isPending ? (
                        <>
                          <Loader2 size={15} className="animate-spin" />
                          <span>{t('modals.saving')}</span>
                        </>
                      ) : (
                        <>
                          <RotateCw size={14} />
                          <span>{t('modals.saveChanges')}</span>
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

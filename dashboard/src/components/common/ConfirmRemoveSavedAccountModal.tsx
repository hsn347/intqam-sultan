import React, { useEffect } from 'react'
import { createPortal } from 'react-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { Trash2, X } from 'lucide-react'
import { useTranslation } from 'react-i18next'

export interface ConfirmRemoveSavedAccountModalProps {
  isOpen: boolean
  onClose: () => void
  onConfirm: () => void
  email: string
}

export function ConfirmRemoveSavedAccountModal({
  isOpen,
  onClose,
  onConfirm,
  email,
}: ConfirmRemoveSavedAccountModalProps) {
  const { t } = useTranslation()

  useEffect(() => {
    if (!isOpen) return
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, onClose])

  if (typeof document === 'undefined') return null

  return createPortal(
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            key="confirm-remove-account-backdrop"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.15 }}
            onClick={onClose}
            style={{
              position: 'fixed',
              inset: 0,
              zIndex: 99998,
              background: 'rgba(0, 0, 0, 0.72)',
              backdropFilter: 'blur(6px)',
              WebkitBackdropFilter: 'blur(6px)',
            }}
          />

          {/* Modal Container */}
          <div
            style={{
              position: 'fixed',
              inset: 0,
              zIndex: 99999,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              padding: '1rem',
              pointerEvents: 'none',
            }}
          >
            <motion.div
              key="confirm-remove-account-panel"
              initial={{ scale: 0.95, opacity: 0, y: 10 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              exit={{ scale: 0.95, opacity: 0, y: 10 }}
              transition={{ duration: 0.18, ease: 'easeOut' }}
              onClick={e => e.stopPropagation()}
              className="relative bg-white dark:bg-[#12161f] shadow-2xl border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-[390px] overflow-hidden confirm-logout-modal-box"
              style={{
                pointerEvents: 'all',
              }}
            >
              {/* Top Accent Gradient Line */}
              <div className="bg-gradient-to-r from-rose-500 via-red-500 to-rose-500 w-full h-1" />

              <div className="relative p-5 sm:p-6 text-center">
                {/* Close Button */}
                <button
                  type="button"
                  onClick={onClose}
                  className="top-4 absolute p-1.5 rounded-lg text-gray-400 cursor-pointer modal-close-btn start-4"
                  title={t('modals.close', 'إغلاق')}
                >
                  <X size={17} />
                </button>

                {/* Trash Icon Badge */}
                <div className="flex justify-center items-center bg-rose-500/15 mx-auto mb-3.5 border border-rose-500/30 rounded-2xl w-12 h-12 text-rose-500">
                  <Trash2 size={22} className="text-rose-500" />
                </div>

                {/* Title */}
                <h3 className="mb-2 font-bold text-gray-900 dark:text-white text-base sm:text-lg modal-title">
                  {t('modals.removeSavedAccountTitle', 'إزالة الحساب المحفوظ')}
                </h3>

                {/* Description with highlighted email */}
                <p className="mb-2 text-gray-600 dark:text-gray-400 text-xs sm:text-sm leading-relaxed modal-desc">
                  {t('modals.removeSavedAccountDesc', 'هل أنت متأكد من رغبتك في إزالة هذا الحساب من قائمة الدخول السريع؟')}
                </p>

                {email && (
                  <div className="inline-block bg-gray-100 dark:bg-white/5 mb-5 px-3 py-1 border border-gray-200 dark:border-white/10 rounded-lg max-w-full font-semibold text-gray-800 dark:text-gray-200 text-xs truncate dir-ltr">
                    {email}
                  </div>
                )}

                {/* Action Buttons */}
                <div className="flex items-center gap-2.5 mt-2">
                  <button
                    type="button"
                    onClick={onClose}
                    className="flex-1 bg-gray-100 dark:bg-white/5 px-4 py-2.5 border border-gray-300 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-xs sm:text-sm cursor-pointer modal-btn-cancel"
                  >
                    {t('modals.cancel', 'إلغاء')}
                  </button>
                  <button
                    type="button"
                    onClick={onConfirm}
                    className="flex flex-1 justify-center items-center gap-1.5 bg-rose-600 px-4 py-2.5 rounded-xl font-bold text-white text-xs sm:text-sm active:scale-98 cursor-pointer modal-btn-confirm"
                  >
                    <Trash2 size={14} />
                    <span>{t('modals.confirmRemoveBtn', 'إزالة الحساب')}</span>
                  </button>
                </div>
              </div>
            </motion.div>
          </div>
        </>
      )}
    </AnimatePresence>,
    document.body
  )
}

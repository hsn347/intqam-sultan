import React, { useEffect } from 'react'
import { createPortal } from 'react-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { Trash2, X, Loader2 } from 'lucide-react'
import { useTranslation } from 'react-i18next'

export interface ConfirmDeleteCastleModalProps {
  isOpen: boolean
  onClose: () => void
  onConfirm: () => void
  isPending?: boolean
}

export function ConfirmDeleteCastleModal({
  isOpen,
  onClose,
  onConfirm,
  isPending = false,
}: ConfirmDeleteCastleModalProps) {
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
            key="confirm-delete-backdrop"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.15 }}
            onClick={onClose}
            style={{
              position: 'fixed',
              inset: 0,
              zIndex: 9998,
              background: 'rgba(0, 0, 0, 0.72)',
              backdropFilter: 'blur(6px)',
              WebkitBackdropFilter: 'blur(6px)',
            }}
          />

          {/* Modal Centered Container */}
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
              key="confirm-delete-panel"
              initial={{ scale: 0.95, opacity: 0, y: 10 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              exit={{ scale: 0.95, opacity: 0, y: 10 }}
              transition={{ duration: 0.18, ease: 'easeOut' }}
              onClick={e => e.stopPropagation()}
              className="relative shadow-2xl rounded-2xl w-full max-w-[380px] overflow-hidden confirm-logout-modal-box"
              style={{
                pointerEvents: 'all',
              }}
            >
              {/* Top Accent Line */}
              <div className="bg-gradient-to-r from-rose-500 via-red-500 to-rose-500 w-full h-1" />

              <div className="relative p-5 sm:p-6 text-center">
                {/* Close Button */}
                <button
                  type="button"
                  onClick={onClose}
                  className="top-4 absolute p-1.5 rounded-lg text-gray-400 cursor-pointer modal-close-btn start-4"
                  title={t('modals.close')}
                >
                  <X size={17} />
                </button>

                {/* Refined Trash Icon */}
                <div className="flex justify-center items-center bg-rose-500/15 mx-auto mb-3.5 border border-rose-500/30 rounded-2xl w-12 h-12 text-rose-400">
                  <Trash2 size={22} className="text-rose-400" />
                </div>

                {/* Title */}
                <h3 className="mb-1.5 font-bold text-gray-900 dark:text-white text-base sm:text-lg modal-title">
                  {t('modals.deleteCastleTitle')}
                </h3>

                {/* Description */}
                <p className="mb-6 text-gray-500 dark:text-gray-400 text-xs sm:text-sm leading-relaxed modal-desc">
                  {t('modals.deleteCastleDesc')}
                </p>

                {/* Action Buttons */}
                <div className="flex items-center gap-2.5">
                  <button
                    type="button"
                    onClick={onClose}
                    disabled={isPending}
                    className="flex-1 bg-gray-100 dark:bg-white/5 disabled:opacity-50 px-4 py-2.5 border border-gray-300 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-xs sm:text-sm cursor-pointer modal-btn-cancel"
                  >
                    {t('modals.cancel')}
                  </button>
                  <button
                    type="button"
                    onClick={onConfirm}
                    disabled={isPending}
                    className="flex flex-1 justify-center items-center gap-1.5 bg-rose-600 disabled:opacity-50 px-4 py-2.5 rounded-xl font-bold text-white text-xs sm:text-sm active:scale-98 cursor-pointer modal-btn-confirm"
                  >
                    {isPending ? (
                      <>
                        <Loader2 size={14} className="animate-spin" />
                        <span>{t('modals.deleting')}</span>
                      </>
                    ) : (
                      <>
                        <Trash2 size={14} />
                        <span>{t('modals.deleteCastleTitle')}</span>
                      </>
                    )}
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

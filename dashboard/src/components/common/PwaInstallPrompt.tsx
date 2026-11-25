import { useState, useEffect } from 'react'
import { useLocation } from 'react-router-dom'
import { Download, Share2, PlusSquare, X, CheckCircle, WifiOff, RefreshCw } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import toast from 'react-hot-toast'
import { useTenant } from '../../context/TenantContext'
import { usePwaStore } from '../../lib/pwa'

const DISMISS_KEY = 'osmanli_pwa_dismissed'
const SNOOZE_MS = 3 * 24 * 60 * 60 * 1000 // "Later" / close: ask again after 3 days
const FOREVER = 'forever'

/** Returns true while the install card should stay hidden (snoozed or permanently dismissed). */
function isDismissed(): boolean {
  try {
    const raw = localStorage.getItem(DISMISS_KEY)
    if (!raw) return false
    if (raw === FOREVER) return true
    const until = Number(raw)
    return Number.isFinite(until) && until > Date.now()
  } catch {
    return false
  }
}

function storeDismiss(permanent: boolean) {
  try {
    localStorage.setItem(DISMISS_KEY, permanent ? FOREVER : String(Date.now() + SNOOZE_MS))
  } catch {
    // ignore storage quota errors
  }
}

export function PwaInstallPrompt() {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { brandName, tagline, logoUrl } = useTenant()
  const {
    deferredPrompt,
    isStandalone,
    isOnline,
    waitingWorker,
    setDeferredPrompt,
    applyUpdate,
  } = usePwaStore()

  const [isIOS, setIsIOS] = useState(false)
  const [dismissed, setDismissed] = useState<boolean>(() =>
    typeof window !== 'undefined' ? isDismissed() : false
  )

  useEffect(() => {
    if (typeof window === 'undefined') return
    const ua = window.navigator.userAgent.toLowerCase()
    setIsIOS(/iphone|ipad|ipod/.test(ua))
  }, [])

  const hasBottomNav =
    pathname === '/dashboard' ||
    pathname === '/' ||
    pathname.startsWith('/accounts') ||
    pathname.startsWith('/settings')

  const bottomOffsetClass = hasBottomNav ? 'bottom-20 md:bottom-6' : 'bottom-4 md:bottom-6'
  const showInstallBanner = !isStandalone && !dismissed && (Boolean(deferredPrompt) || isIOS)

  const handleInstallClick = async () => {
    if (!deferredPrompt) return
    try {
      await deferredPrompt.prompt()
      const { outcome } = await deferredPrompt.userChoice
      if (outcome === 'accepted') {
        toast.success(t('pwa.installSuccess'))
      }
    } catch {
      // ignore cancelled prompt
    } finally {
      setDeferredPrompt(null)
    }
  }

  const handleDismiss = (permanent = false) => {
    setDismissed(true)
    storeDismiss(permanent)
  }

  const primaryBtnStyle = { backgroundColor: 'var(--theme-primary)', color: '#ffffff' }
  const stepBadge =
    'flex justify-center items-center bg-gray-100 dark:bg-white/10 rounded-full w-5 h-5 font-bold text-[10px] text-gray-700 dark:text-white shrink-0'

  return (
    <>
      {/* Offline Status Pill */}
      {!isOnline && (
        <div
          role="status"
          className="top-3 left-1/2 z-[120] fixed flex items-center gap-2 bg-rose-50 dark:bg-rose-950 shadow-lg px-3.5 py-1.5 border border-rose-300 dark:border-rose-500/40 rounded-full font-bold text-rose-700 dark:text-rose-100 text-xs -translate-x-1/2 pointer-events-none"
          style={{ marginTop: 'env(safe-area-inset-top, 0px)' }}
        >
          <WifiOff size={13} className="text-rose-500 dark:text-rose-400 shrink-0" />
          <span className="whitespace-nowrap">{t('pwa.offline')}</span>
        </div>
      )}

      {/* App Update Banner (when a new SW version is ready) */}
      {waitingWorker && (
        <div
          role="status"
          className="top-3 left-1/2 z-[120] fixed flex items-center gap-2.5 bg-white dark:bg-[#0c120f] shadow-lg px-3.5 py-2 border rounded-2xl text-gray-900 dark:text-white text-xs -translate-x-1/2"
          style={{
            borderColor: 'rgba(var(--theme-primary-rgb), 0.4)',
            marginTop: isOnline ? 'env(safe-area-inset-top, 0px)' : 'calc(env(safe-area-inset-top, 0px) + 2.5rem)',
          }}
        >
          <RefreshCw size={13} className="shrink-0" style={{ color: 'var(--theme-primary)' }} />
          <span className="font-semibold whitespace-nowrap">{t('pwa.updateAvailable')}</span>
          <button
            type="button"
            onClick={applyUpdate}
            style={primaryBtnStyle}
            className="px-2.5 py-1 rounded-lg font-bold text-[11px] whitespace-nowrap active:scale-95 cursor-pointer"
          >
            {t('pwa.updateNow')}
          </button>
        </div>
      )}

      {/* Install Helper Card */}
      {showInstallBanner && (
        <aside
          aria-label={t('pwa.title', { brand: brandName })}
          className={`${bottomOffsetClass} z-50 fixed inset-x-3 sm:inset-x-auto sm:end-6 bg-white dark:bg-[#0c120f] shadow-lg border rounded-2xl sm:max-w-md overflow-hidden text-gray-900 dark:text-white`}
          style={{
            borderColor: 'rgba(var(--theme-primary-rgb), 0.3)',
            marginBottom: hasBottomNav ? undefined : 'env(safe-area-inset-bottom, 0px)',
          }}
        >
          {/* Top accent */}
          <div className="w-full h-1" style={{ backgroundColor: 'var(--theme-primary)' }} />

          <div className="p-4">
            <div className="flex justify-between items-start gap-3">
              <div className="flex items-center gap-3 min-w-0">
                <div
                  className="flex justify-center items-center bg-gray-100 dark:bg-white/5 border rounded-xl w-10 h-10 overflow-hidden shrink-0"
                  style={{ borderColor: 'rgba(var(--theme-primary-rgb), 0.35)' }}
                >
                  <img src={logoUrl || '/logo.png?v=2'} alt={brandName} className="w-full h-full object-cover" />
                </div>
                <div className="min-w-0">
                  <h2 className="flex flex-wrap items-center gap-1.5 font-bold text-gray-900 dark:text-white text-sm">
                    {t('pwa.title', { brand: brandName })}
                    {tagline ? (
                      <span
                        className="px-1.5 py-0.5 border rounded-full font-semibold text-[10px]"
                        style={{
                          color: 'var(--theme-primary)',
                          backgroundColor: 'rgba(var(--theme-primary-rgb), 0.12)',
                          borderColor: 'rgba(var(--theme-primary-rgb), 0.3)',
                        }}
                      >
                        {tagline}
                      </span>
                    ) : null}
                  </h2>
                  <p className="mt-0.5 text-gray-500 dark:text-gray-300 text-xs">{t('pwa.desc')}</p>
                </div>
              </div>

              <button
                type="button"
                onClick={() => handleDismiss()}
                className="p-1.5 rounded-lg text-gray-400 shrink-0 cursor-pointer"
                title={t('pwa.close')}
                aria-label={t('pwa.close')}
              >
                <X size={16} />
              </button>
            </div>

            {isIOS && !deferredPrompt ? (
              <div className="space-y-2 mt-3 pt-3 border-gray-200 dark:border-white/10 border-t text-gray-600 dark:text-gray-300 text-xs">
                <p className="font-semibold" style={{ color: 'var(--theme-primary)' }}>
                  {t('pwa.iosGuideTitle')}
                </p>
                <ol className="space-y-1.5 ps-1 text-[11px] leading-relaxed">
                  <li className="flex items-center gap-2">
                    <span className={stepBadge}>1</span>
                    <span>
                      {t('pwa.iosStep1')}{' '}
                      <Share2 size={13} className="inline mx-0.5 text-sky-500" />{' '}
                      {t('pwa.iosStep1Suffix')}
                    </span>
                  </li>
                  <li className="flex items-center gap-2">
                    <span className={stepBadge}>2</span>
                    <span>
                      {t('pwa.iosStep2')}{' '}
                      <strong className="text-gray-900 dark:text-white">{t('pwa.iosStep2Highlight')}</strong>{' '}
                      <PlusSquare size={13} className="inline mx-0.5" style={{ color: 'var(--theme-primary)' }} />.
                    </span>
                  </li>
                  <li className="flex items-center gap-2">
                    <span className={stepBadge}>3</span>
                    <span>
                      {t('pwa.iosStep3')}{' '}
                      <strong className="text-gray-900 dark:text-white">{t('pwa.iosStep3Highlight')}</strong>{' '}
                      {t('pwa.iosStep3Suffix')}
                    </span>
                  </li>
                </ol>
                <button
                  type="button"
                  onClick={() => handleDismiss(true)}
                  style={primaryBtnStyle}
                  className="flex justify-center items-center gap-1.5 mt-2 px-3 py-2 rounded-xl w-full font-bold text-xs cursor-pointer"
                >
                  <CheckCircle size={14} />
                  <span>{t('pwa.gotIt')}</span>
                </button>
              </div>
            ) : (
              <div className="flex items-center gap-2 mt-3 pt-3 border-gray-200 dark:border-white/10 border-t">
                {deferredPrompt && (
                  <button
                    type="button"
                    onClick={handleInstallClick}
                    style={primaryBtnStyle}
                    className="flex flex-1 justify-center items-center gap-1.5 px-3 py-2 rounded-xl font-bold text-xs cursor-pointer"
                  >
                    <Download size={14} />
                    <span>{t('pwa.installNow')}</span>
                  </button>
                )}
                <button
                  type="button"
                  onClick={() => handleDismiss()}
                  className="bg-gray-100 dark:bg-white/10 px-3 py-2 rounded-xl font-semibold text-gray-600 dark:text-gray-300 text-xs cursor-pointer"
                >
                  {t('pwa.later')}
                </button>
              </div>
            )}
          </div>
        </aside>
      )}
    </>
  )
}

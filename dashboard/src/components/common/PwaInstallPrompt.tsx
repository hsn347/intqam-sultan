import React, { useState, useEffect } from 'react'
import { Download, Share2, PlusSquare, X, CheckCircle } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { useTenant } from '../../context/TenantContext'

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>
}

export function PwaInstallPrompt() {
  const { t } = useTranslation()
  const { brandName, tagline, logoUrl } = useTenant()
  const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null)
  const [isIOS, setIsIOS] = useState(false)
  const [isStandalone, setIsStandalone] = useState(false)
  const [showPrompt, setShowPrompt] = useState(false)

  useEffect(() => {
    // Check if already installed / running in standalone mode
    const isRunningStandalone =
      window.matchMedia('(display-mode: standalone)').matches ||
      (window.navigator as unknown as { standalone?: boolean }).standalone === true

    setIsStandalone(isRunningStandalone)
    if (isRunningStandalone) return

    // Detect iOS
    const userAgent = window.navigator.userAgent.toLowerCase()
    const isIosDevice = /iphone|ipad|ipod/.test(userAgent)
    setIsIOS(isIosDevice)

    // Capture Android/Chrome install event
    const handleBeforeInstall = (e: Event) => {
      e.preventDefault()
      setDeferredPrompt(e as BeforeInstallPromptEvent)
      const dismissed = localStorage.getItem('osmanli_pwa_dismissed')
      if (!dismissed) {
        setShowPrompt(true)
      }
    }

    window.addEventListener('beforeinstallprompt', handleBeforeInstall)

    // Check if iOS prompt was previously dismissed
    const dismissed = localStorage.getItem('osmanli_pwa_dismissed')
    if (isIosDevice && !dismissed) {
      // Delay prompt slightly for great UX
      const timer = setTimeout(() => setShowPrompt(true), 1800)
      return () => clearTimeout(timer)
    }

    return () => {
      window.removeEventListener('beforeinstallprompt', handleBeforeInstall)
    }
  }, [])

  const handleInstallClick = async () => {
    if (deferredPrompt) {
      await deferredPrompt.prompt()
      const { outcome } = await deferredPrompt.userChoice
      if (outcome === 'accepted') {
        setShowPrompt(false)
      }
      setDeferredPrompt(null)
    }
  }

  const handleDismiss = () => {
    setShowPrompt(false)
    localStorage.setItem('osmanli_pwa_dismissed', 'true')
  }

  if (isStandalone || !showPrompt) return null

  return (
    <aside
      aria-label="PWA Installation Helper"
      className="bottom-16 md:bottom-6 z-50 fixed inset-x-3 sm:inset-x-auto bg-gray-950 shadow-lg p-4 border border-primary-500/35 rounded-2xl sm:max-w-md text-white sm:end-6"
    >
      <div className="flex justify-between items-start gap-3">
        <div className="flex items-center gap-3">
          <div className="flex justify-center items-center bg-gray-900 shadow-sm border border-primary-500/30 rounded-xl w-10 h-10 overflow-hidden shrink-0">
            <img src={logoUrl || '/logo.png?v=2'} alt={brandName} className="w-full h-full object-cover" />
          </div>
          <div>
            <h2 className="flex items-center gap-1.5 font-bold text-white text-sm">
              {t('pwa.title', { brand: brandName })}
              {tagline ? (
                <span className="bg-primary-500/20 px-1.5 py-0.5 border border-primary-500/30 rounded-full text-[10px] text-primary-400">
                  {tagline}
                </span>
              ) : null}
            </h2>
            <p className="mt-0.5 text-gray-300 text-xs">
              {t('pwa.desc')}
            </p>
          </div>
        </div>

        <button
          onClick={handleDismiss}
          className="p-1 rounded-lg text-gray-400 cursor-pointer"
          title={t('pwa.close')}
        >
          <X size={16} />
        </button>
      </div>

      {isIOS ? (
        <div className="space-y-2 mt-3 pt-3 border-white/10 border-t text-gray-300 text-xs">
          <p className="flex items-center gap-1.5 font-semibold text-primary-400">
            {t('pwa.iosGuideTitle')}
          </p>
          <ol className="space-y-1.5 ps-1 text-[11px] leading-relaxed">
            <li className="flex items-center gap-2">
              <span className="flex justify-center items-center bg-white/10 rounded-full w-5 h-5 font-bold text-[10px] text-white shrink-0">1</span>
              <span>
                {t('pwa.iosStep1')}{' '}
                <Share2 size={13} className="inline mx-0.5 text-sky-400" />{' '}
                {t('pwa.iosStep1Suffix')}
              </span>
            </li>
            <li className="flex items-center gap-2">
              <span className="flex justify-center items-center bg-white/10 rounded-full w-5 h-5 font-bold text-[10px] text-white shrink-0">2</span>
              <span>
                {t('pwa.iosStep2')}{' '}
                <strong className="text-white">{t('pwa.iosStep2Highlight')}</strong>{' '}
                <PlusSquare size={13} className="inline mx-0.5 text-primary-400" />.
              </span>
            </li>
            <li className="flex items-center gap-2">
              <span className="flex justify-center items-center bg-white/10 rounded-full w-5 h-5 font-bold text-[10px] text-white shrink-0">3</span>
              <span>
                {t('pwa.iosStep3')}{' '}
                <strong className="text-white">{t('pwa.iosStep3Highlight')}</strong>{' '}
                {t('pwa.iosStep3Suffix')}
              </span>
            </li>
          </ol>
          <button
            onClick={handleDismiss}
            className="flex justify-center items-center gap-1.5 bg-primary-600 mt-2 px-3 py-1.5 rounded-xl w-full font-bold text-white text-xs cursor-pointer"
          >
            <CheckCircle size={14} />
            <span>{t('pwa.gotIt')}</span>
          </button>
        </div>
      ) : (
        <div className="flex items-center gap-2 mt-3 pt-3 border-white/10 border-t">
          {deferredPrompt && (
            <button
              onClick={handleInstallClick}
              className="flex flex-1 justify-center items-center gap-1.5 bg-primary-600 px-3 py-2 rounded-xl font-bold text-white text-xs cursor-pointer"
            >
              <Download size={14} />
              <span>{t('pwa.installNow')}</span>
            </button>
          )}
          <button
            onClick={handleDismiss}
            className="bg-white/10 px-3 py-2 rounded-xl text-gray-300 text-xs cursor-pointer"
          >
            {t('pwa.later')}
          </button>
        </div>
      )}
    </aside>
  )
}

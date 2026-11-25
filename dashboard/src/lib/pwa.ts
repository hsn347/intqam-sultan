import { create } from 'zustand'

export interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>
}

interface PwaState {
  deferredPrompt: BeforeInstallPromptEvent | null
  isStandalone: boolean
  isOnline: boolean
  waitingWorker: ServiceWorker | null
  setDeferredPrompt: (ev: BeforeInstallPromptEvent | null) => void
  setIsStandalone: (val: boolean) => void
  setIsOnline: (val: boolean) => void
  setWaitingWorker: (sw: ServiceWorker | null) => void
  applyUpdate: () => void
}

export const usePwaStore = create<PwaState>((set, get) => ({
  deferredPrompt: null,
  isStandalone:
    typeof window !== 'undefined' &&
    (window.matchMedia('(display-mode: standalone)').matches ||
      (window.navigator as unknown as { standalone?: boolean }).standalone === true),
  isOnline: typeof navigator !== 'undefined' ? navigator.onLine : true,
  waitingWorker: null,
  setDeferredPrompt: (deferredPrompt) => set({ deferredPrompt }),
  setIsStandalone: (isStandalone) => set({ isStandalone }),
  setIsOnline: (isOnline) => set({ isOnline }),
  setWaitingWorker: (waitingWorker) => set({ waitingWorker }),
  applyUpdate: () => {
    const sw = get().waitingWorker
    if (!sw) {
      window.location.reload()
      return
    }
    sw.postMessage({ type: 'SKIP_WAITING' })
  },
}))

let initialized = false

export function initPwaListeners() {
  if (initialized || typeof window === 'undefined') return
  initialized = true

  const updateStandalone = () => {
    const standalone =
      window.matchMedia('(display-mode: standalone)').matches ||
      (window.navigator as unknown as { standalone?: boolean }).standalone === true
    usePwaStore.getState().setIsStandalone(standalone)
  }

  updateStandalone()

  const mediaQuery = window.matchMedia('(display-mode: standalone)')
  if (typeof mediaQuery.addEventListener === 'function') {
    mediaQuery.addEventListener('change', updateStandalone)
  }

  window.addEventListener('beforeinstallprompt', (e: Event) => {
    e.preventDefault()
    usePwaStore.getState().setDeferredPrompt(e as BeforeInstallPromptEvent)
  })

  window.addEventListener('appinstalled', () => {
    usePwaStore.getState().setDeferredPrompt(null)
    usePwaStore.getState().setIsStandalone(true)
  })

  window.addEventListener('online', () => usePwaStore.getState().setIsOnline(true))
  window.addEventListener('offline', () => usePwaStore.getState().setIsOnline(false))
}

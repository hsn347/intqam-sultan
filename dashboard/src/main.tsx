import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'
import { initPwaListeners, usePwaStore } from './lib/pwa'

// Attach global install & connectivity listeners before initial route renders (prevents missing events on /login)
initPwaListeners()

const CURRENT_CACHE_NAME = 'ibrabot-pwa-v6'

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    if (import.meta.env.DEV) {
      // In Vite dev mode, purge SW and caches to prevent stale HMR modules
      navigator.serviceWorker.getRegistrations().then((regs) => {
        regs.forEach((reg) => reg.unregister())
      })
      if ('caches' in window) {
        caches.keys().then((names) => names.forEach((name) => caches.delete(name)))
      }
      return
    }

    // Production: Clear obsolete caches
    if ('caches' in window) {
      caches.keys().then((names) => {
        names.forEach((name) => {
          if (name !== CURRENT_CACHE_NAME) {
            caches.delete(name)
          }
        })
      })
    }

    let refreshing = false
    const hadController = Boolean(navigator.serviceWorker.controller)
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      if (!hadController || refreshing) return
      refreshing = true
      window.location.reload()
    })

    navigator.serviceWorker
      .register('/sw.js')
      .then((reg) => {
        if (reg.waiting && navigator.serviceWorker.controller) {
          usePwaStore.getState().setWaitingWorker(reg.waiting)
        }

        reg.addEventListener('updatefound', () => {
          const newWorker = reg.installing
          if (!newWorker) return
          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              usePwaStore.getState().setWaitingWorker(newWorker)
            }
          })
        })

        reg.update().catch(() => {})
      })
      .catch((err) => {
        console.warn('PWA service worker registration failed:', err)
      })
  })
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <App />
)

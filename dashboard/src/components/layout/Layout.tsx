import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { Sidebar } from './Sidebar'
import { BottomNav } from './BottomNav'
import { ConfirmLogoutModal } from '../common/ConfirmLogoutModal'
import { AccountSwitcherModal } from '../common/AccountSwitcherModal'
import { LanguageDropdown } from '../common/LanguageDropdown'
import { Sun, Moon, LogOut, Users } from 'lucide-react'
import { clsx } from 'clsx'
import { useAppStore } from '../../store/appStore'
import { useAuth } from '../../hooks/useAuth'
import { useTenant } from '../../context/TenantContext'

interface LayoutProps {
  children: React.ReactNode
  title?: string
}

export function Layout({ children, title }: LayoutProps) {
  const { t, i18n } = useTranslation()
  const { brandName, tagline, logoUrl } = useTenant()
  const navigate = useNavigate()
  const { logout, savedAccounts } = useAuth()
  const { theme, setTheme } = useAppStore()
  const [showLogoutModal, setShowLogoutModal] = useState(false)
  const [showAccountModal, setShowAccountModal] = useState(false)
  const [isLoggingOut, setIsLoggingOut] = useState(false)

  const handleConfirmLogout = async () => {
    setIsLoggingOut(true)
    try {
      await logout()
      navigate('/login')
    } finally {
      setIsLoggingOut(false)
      setShowLogoutModal(false)
    }
  }

  const toggleTheme = () => {
    setTheme(theme === 'dark' ? 'light' : 'dark')
  }

  return (
    <div className="bg-mesh min-h-screen" style={{ minHeight: '100vh' }}>
      <Sidebar onLogoutClick={() => setShowLogoutModal(true)} />

      {/* Main content */}
      <main className="min-h-screen main-offset">
        {/* Mobile App Header (mobile only) */}
        <header
          className="md:hidden top-0 z-30 sticky flex justify-between items-center bg-white dark:bg-gray-950 px-3 py-1.5 border-gray-200 dark:border-white/8 border-b mobile-app-header"
          style={{ paddingTop: 'max(0.375rem, env(safe-area-inset-top, 0px))' }}
        >
          {/* Brand Identity */}
          <div className="flex items-center gap-2 min-w-0">
            <div className="flex justify-center items-center bg-gray-100 dark:bg-white/5 border border-amber-500/30 rounded-lg w-7 h-7 overflow-hidden shrink-0">
              <img
                src={logoUrl || '/logo.png?v=2'}
                alt={brandName}
                className="w-full h-full object-cover"
              />
            </div>
            <div className="min-w-0">
              <span className="block font-bold text-sm truncate leading-tight tracking-wide brand-title">{brandName}</span>
            </div>
          </div>

          {/* Quick Header Actions: Switch Account + Language + Theme + Logout */}
          <div className="flex items-center gap-1.5 shrink-0">
            {/* Quick Switch Account Button */}
            <button
              onClick={() => setShowAccountModal(true)}
              style={{
                color: 'var(--theme-primary)',
                backgroundColor: 'rgba(var(--theme-primary-rgb), 0.1)',
                borderColor: 'rgba(var(--theme-primary-rgb), 0.25)',
              }}
              className="flex items-center gap-1 p-1.5 border rounded-lg cursor-pointer"
              title={t('accountSwitcher.title', 'تبديل الحساب')}
            >
              <Users size={15} />
              {savedAccounts.length > 1 && (
                <span
                  style={{ backgroundColor: 'rgba(var(--theme-primary-rgb), 0.2)' }}
                  className="px-1 rounded-full font-mono font-bold text-[10px] leading-tight"
                >
                  {savedAccounts.length}
                </span>
              )}
            </button>

            {/* Language Dropdown */}
            <LanguageDropdown placement="bottom" variant="compact" />

            {/* Quick theme toggle */}
            <button
              onClick={toggleTheme}
              className="bg-gray-100 dark:bg-white/6 p-1.5 border border-gray-200 dark:border-white/10 rounded-lg text-gray-500 dark:text-gray-400"
              title={theme === 'dark' ? t('common.lightMode') : t('common.darkMode')}
            >
              {theme === 'dark' ? <Sun size={15} className="text-amber-400" /> : <Moon size={15} className="text-primary-600" />}
            </button>

            {/* Logout button */}
            <button
              onClick={() => setShowLogoutModal(true)}
              className="bg-rose-500/10 p-1.5 border border-rose-500/20 rounded-lg text-rose-500 dark:text-rose-400 cursor-pointer"
              title={t('nav.logout')}
            >
              <LogOut size={15} />
            </button>
          </div>
        </header>

        {/* Page content - pb-28 ensures full visibility above the mobile bottom nav */}
        <div className="p-3 sm:p-4 md:p-6 pb-28 md:pb-24 animate-fade-up">
          {children}
        </div>
      </main>

      {/* Mobile App Bottom Navigation Bar */}
      <BottomNav />

      {/* Account Switcher Modal */}
      <AccountSwitcherModal
        isOpen={showAccountModal}
        onClose={() => setShowAccountModal(false)}
      />

      {/* Confirm Logout Modal */}
      <ConfirmLogoutModal
        isOpen={showLogoutModal}
        onClose={() => setShowLogoutModal(false)}
        onConfirm={handleConfirmLogout}
        isPending={isLoggingOut}
      />
    </div>
  )
}


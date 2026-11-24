import React, { useState } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import {
  LayoutDashboard, Users, Settings, LogOut,
  Moon, Sun, Bot, Menu, X, Shield, ChevronsUpDown,
} from 'lucide-react'
import { clsx } from 'clsx'
import { useAppStore } from '../../store/appStore'
import { useAuth } from '../../hooks/useAuth'
import { localizeUsername } from '../../lib/localize'
import { AccountSwitcherModal } from '../common/AccountSwitcherModal'
import { LanguageDropdown } from '../common/LanguageDropdown'
import { useTenant } from '../../context/TenantContext'
import toast from 'react-hot-toast'

export interface SidebarProps {
  onLogoutClick?: () => void
}

export function Sidebar({ onLogoutClick }: SidebarProps = {}) {
  const { t, i18n } = useTranslation()
  const { brandName, tagline, logoUrl } = useTenant()
  const navigate    = useNavigate()
  const { user, logout, isAdmin, savedAccounts } = useAuth()
  const { theme, sidebarOpen, setTheme, toggleSidebar } = useAppStore()
  const [showAccountSwitcher, setShowAccountSwitcher] = useState(false)

  const handleLogout = async () => {
    if (onLogoutClick) {
      onLogoutClick()
      return
    }
    await logout()
    navigate('/login')
  }

  const toggleTheme = () => {
    setTheme(theme === 'dark' ? 'light' : 'dark')
  }

  const navLinks = [
    { to: '/dashboard', icon: LayoutDashboard, label: t('nav.dashboard') },
    { to: '/accounts',  icon: Users,           label: t('nav.accounts')  },
    { to: '/settings',  icon: Settings,        label: t('nav.settings')  },
    ...(isAdmin ? [
      {
        to: '/admin',
        icon: Shield,
        label: t('nav.admin', 'الإدارة'),
        badge: 'ROOT',
        isSpecial: true,
      }
    ] : []),
  ]

  return (
    <>
      {/* Sidebar - Desktop Only (Hidden on Mobile) */}
      <aside
        dir="ltr"
        className="hidden top-0 left-0 z-50 fixed md:flex flex-col border-gray-200 dark:border-white/8 border-r h-full glass-sidebar sidebar-width"
      >
        {/* Logo */}
        <div className="flex justify-between items-center px-4 py-3.5 border-gray-200 dark:border-white/8 border-b">
          <div className="flex items-center gap-2.5 min-w-0">
            <div className="flex justify-center items-center bg-gray-100 dark:bg-white/5 border border-amber-500/30 dark:border-amber-500/35 rounded-xl w-9 h-9 overflow-hidden shrink-0">
              <img
                src={logoUrl || '/logo.png?v=2'}
                alt={brandName}
                className="w-full h-full object-cover"
              />
            </div>
            <div className="min-w-0">
              <span className="block font-bold text-sm leading-tight tracking-wide brand-title">{brandName}</span>
              {tagline ? (
                <span className="block mt-0.5 font-bold text-[11px] truncate leading-tight brand-tagline">
                  {tagline}
                </span>
              ) : null}
            </div>
          </div>
        </div>

        {/* User info & Quick Account Switcher trigger */}
        {user && (
          <div className="p-2 border-gray-200 dark:border-white/8 border-b">
            <button
              type="button"
              onClick={() => setShowAccountSwitcher(true)}
              className="flex justify-between items-center p-2 border border-transparent rounded-xl w-full text-left cursor-pointer"
              title={t('accountSwitcher.title', 'تبديل الحساب')}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="flex justify-center items-center bg-primary-600 dark:bg-primary-600 rounded-full w-8 h-8 font-bold text-white text-xs shrink-0">
                  {user.username?.[0]?.toUpperCase() ?? user.email?.[0]?.toUpperCase() ?? '?'}
                </div>
                <div className="min-w-0 text-left">
                  <div className="font-bold text-gray-900 dark:text-white text-xs truncate">
                    {localizeUsername(user.username, t) || user.email}
                  </div>
                  <div className="flex items-center gap-1 text-[10px] text-gray-500 dark:text-gray-400">
                    <span>{isAdmin ? t('roles.admin', 'Admin') : t('roles.user', 'User')}</span>
                    {savedAccounts.length > 1 && (
                      <span className="bg-primary-500/15 px-1 py-0.2 rounded font-mono font-bold text-[9px] text-primary-600 dark:text-primary-400">
                        {savedAccounts.length}
                      </span>
                    )}
                  </div>
                </div>
              </div>
              <ChevronsUpDown size={14} className="text-gray-400 shrink-0" />
            </button>
          </div>
        )}

        {/* Navigation */}
        <nav className="flex-1 space-y-1 px-3 py-4 overflow-y-auto">
          {navLinks.map(({ to, icon: Icon, label, badge, isSpecial }: any) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) => clsx(
                'flex justify-between items-center nav-item',
                isActive && 'active',
                isSpecial && !isActive && 'text-emerald-400/90'
              )}
              onClick={() => window.innerWidth < 768 && toggleSidebar()}
            >
              <div className="flex items-center gap-2.5">
                <Icon size={18} className={isSpecial ? 'text-emerald-400' : undefined} />
                <span>{label}</span>
              </div>
              {badge && (
                <span className="bg-emerald-500/15 px-1.5 py-0.5 border border-emerald-500/30 rounded font-mono font-extrabold text-[10px] text-emerald-400 tracking-wider">
                  {badge}
                </span>
              )}
            </NavLink>
          ))}
        </nav>

        {/* Bottom: Language + Theme + Logout */}
        <div className="space-y-2 px-3 py-3 border-white/8 border-t">
          {/* Language selector */}
          <div className="flex justify-between items-center px-1">
            <span className="text-gray-500 text-xs">{t('settings.language')}</span>
            <LanguageDropdown placement="top" variant="compact" />
          </div>

          {/* Theme toggle */}
          <button
            onClick={toggleTheme}
            className="w-full nav-item"
          >
            {theme === 'dark' ? <Sun size={16} /> : <Moon size={16} />}
            <span className="text-sm">{theme === 'dark' ? t('common.lightMode') : t('common.darkMode')}</span>
          </button>

          {/* Logout */}
          <button onClick={handleLogout} className="w-full text-red-600 dark:text-red-400 nav-item">
            <LogOut size={16} />
            <span className="text-sm">{t('nav.logout')}</span>
          </button>
        </div>
      </aside>

      {/* Account Switcher Modal */}
      <AccountSwitcherModal
        isOpen={showAccountSwitcher}
        onClose={() => setShowAccountSwitcher(false)}
      />
    </>
  )
}

// Mobile menu button — separate export for Layout usage
export function MobileMenuBtn() {
  return null
}

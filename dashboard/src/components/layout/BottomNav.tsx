import React from 'react'
import { NavLink, useLocation } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { LayoutDashboard, Users, Settings, Shield } from 'lucide-react'
import { clsx } from 'clsx'
import { useAuth } from '../../hooks/useAuth'
import { useCastles } from '../../hooks/useCastles'

export function BottomNav() {
  const { t } = useTranslation()
  const location = useLocation()
  const { user, isAdmin } = useAuth()
  const uid = user?.uid ?? ''
  const { data } = useCastles(uid)

  const allCastles = data?.pages.flatMap(p => p.items) ?? []
  const runningCount = allCastles.filter(c => c.is_active && c.bot_status?.state === 'running').length

  const navItems = [
    {
      to: '/dashboard',
      icon: LayoutDashboard,
      label: t('nav.dashboard', 'الرئيسية'),
      isActive: (path: string) => path === '/dashboard' || path === '/',
    },
    {
      to: '/accounts',
      icon: Users,
      label: t('nav.accounts', 'الحسابات'),
      badge: runningCount > 0 ? runningCount : undefined,
      isActive: (path: string) => path.startsWith('/accounts'),
    },
    {
      to: '/settings',
      icon: Settings,
      label: t('nav.settings', 'الإعدادات'),
      isActive: (path: string) => path.startsWith('/settings'),
    },
    ...(isAdmin ? [{
      to: '/admin',
      icon: Shield,
      label: t('nav.admin', 'الإدارة'),
      isActive: (path: string) => path.startsWith('/admin'),
    }] : []),
  ]

  return (
    <nav
      aria-label="Mobile Navigation"
      className="md:hidden right-0 bottom-0 bottom-nav-glass left-0 z-50 fixed m-0 p-0 border-b-0 w-full"
      style={{
        bottom: 0,
        left: 0,
        right: 0,
        width: '100%',
        margin: 0,
        marginBottom: 0,
        paddingBottom: 'env(safe-area-inset-bottom, 0px)',
      }}
    >
      <div className="flex justify-around items-center mx-auto px-3 pt-1 pb-0.5 max-w-lg">
        {navItems.map((item) => {
          const active = item.isActive(location.pathname)
          const Icon = item.icon

          return (
            <NavLink
              key={item.to}
              to={item.to}
              className={clsx(
                'bottom-nav-item relative flex flex-col justify-center items-center px-2 pt-1 pb-0 rounded-xl min-w-[70px] active:scale-95 select-none',
                active ? 'bottom-nav-item-active font-bold' : 'bottom-nav-item-inactive font-medium'
              )}
            >
              {/* Active top bar indicator */}
              {active && (
                <span
                  className="-top-2 bottom-nav-active-pill absolute inset-x-3 bg-primary-500 rounded-full h-[3px]"
                  style={{
                    backgroundColor: 'var(--theme-primary)',
                  }}
                />
              )}

              <div className="relative">
                <Icon
                  size={20}
                  className={clsx(
                    'bottom-nav-icon',
                    active ? 'text-primary-400' : 'text-gray-400'
                  )}
                />

                {/* Badge for running accounts */}
                {item.badge !== undefined && (
                  <span className="-top-1 absolute flex justify-center items-center bg-emerald-500 px-1 rounded-full ring-2 ring-gray-950 min-w-[16px] h-4 font-black text-[10px] text-black -end-2.5">
                    {item.badge}
                  </span>
                )}
              </div>

              <span
                className={clsx(
                  'bottom-nav-label mt-1 max-w-[80px] text-[11px] truncate tracking-tight',
                  active ? 'text-primary-400 font-bold' : 'text-gray-400'
                )}
              >
                {item.label}
              </span>
            </NavLink>
          )
        })}
      </div>
    </nav>
  )
}

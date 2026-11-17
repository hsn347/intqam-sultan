import React from 'react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { Layout } from '../components/layout/Layout'
import { StatusBadge } from '../components/ui/StatusBadge'
import { useAuth } from '../hooks/useAuth'
import { useCastles } from '../hooks/useCastles'
import { motion } from 'framer-motion'
import { Plus, Users, Shield, Zap, Bot, Crown, AlertTriangle, AlertCircle, ShieldAlert, Clock } from 'lucide-react'

import { localizePlanName, localizeUsername } from '../lib/localize'
import { useTenant } from '../context/TenantContext'

export function DashboardPage() {
  const { t, i18n } = useTranslation()
  const { brandName, tagline, logoUrl } = useTenant()
  const { user, isAdmin } = useAuth()
  const castlesQuery = useCastles(user?.uid ?? '')
  const allCastles = castlesQuery.data?.pages.flatMap(p => p.items) ?? []
  const running = allCastles.filter(c => c.bot_status.state === 'running').length
  const idle    = allCastles.filter(c => c.bot_status.state === 'idle').length
  const errors  = allCastles.filter(c => c.bot_status.state === 'error').length
  const sub = user?.subscription

  const planDisplayName = localizePlanName(sub?.plan_name, t)
  const usernameDisplay = localizeUsername(user?.username, t) || user?.email

  // Expiration & countdown checks
  const now = Date.now()
  const expDate = sub?.expires_at ? new Date(sub.expires_at) : null
  const isLifetime = expDate ? expDate.getFullYear() >= 2090 : false
  const isPendingApproval = !isAdmin && sub?.status === 'pending_approval'
  const isExpired = !isLifetime && !isPendingApproval && (sub?.status === 'expired' || (expDate && !isNaN(expDate.getTime()) ? expDate.getTime() < now : false))
  const daysRemaining = isLifetime ? 99999 : isPendingApproval ? 0 : (expDate && !isNaN(expDate.getTime())) ? Math.ceil((expDate.getTime() - now) / 86400000) : (sub?.days_remaining ?? 0)
  const isExpiringSoon = !isAdmin && !isExpired && !isPendingApproval && Boolean(expDate && !isNaN(expDate.getTime())) && daysRemaining <= 3 && daysRemaining >= 0
  const isBanned = !isAdmin && Boolean(user?.is_banned)

  const stats = [
    { label: t('dashboard.totalCastles'),  value: allCastles.length, icon: '🏰', color: 'text-blue-400',   bg: 'bg-blue-600/10 border-blue-600/20' },
    { label: t('dashboard.activeCastles'), value: running,            icon: '▶️', color: 'text-green-400',  bg: 'bg-green-600/10 border-green-600/20' },
    { label: t('dashboard.idleCastles'),   value: idle,               icon: '⏸️', color: 'text-gray-400',   bg: 'bg-gray-600/10 border-gray-600/20' },
    {
      label: t('dashboard.subscription'),
      value: isAdmin ? t('dashboard.superAdminUnlimited') : isBanned ? t('dashboard.bannedBadge') : isPendingApproval ? t('admin.pendingApproval') : (planDisplayName || '—'),
      icon: isAdmin ? '👑' : isBanned ? '🚫' : isPendingApproval ? '⏳' : isExpired ? '⚠️' : isExpiringSoon ? '⏳' : '⭐',
      color: isAdmin
        ? 'text-amber-400'
        : isBanned || isExpired
        ? 'text-rose-500 dark:text-rose-400'
        : isPendingApproval || isExpiringSoon
        ? 'text-amber-500 dark:text-amber-400'
        : 'text-yellow-400',
      bg: isAdmin
        ? 'bg-amber-600/10 border-amber-600/20'
        : isBanned || isExpired
        ? 'bg-rose-500/15 border-rose-500/40 ring-1 ring-rose-500/30'
        : isPendingApproval || isExpiringSoon
        ? 'bg-amber-500/15 border-amber-500/40 ring-1 ring-amber-500/30'
        : 'bg-yellow-600/10 border-yellow-600/20',
      badge: isBanned ? t('dashboard.bannedBadge') : isPendingApproval ? t('dashboard.underReview', 'قيد المراجعة') : isExpired ? t('dashboard.expiredBadge') : isExpiringSoon ? t('dashboard.daysRemainingShort', { count: daysRemaining }) : undefined,
    },
  ]

  return (
    <Layout title={t('dashboard.title')}>
      <div className="space-y-6">
        {/* Page header */}
        <div className="flex flex-wrap justify-between items-center gap-3">
          <div>
            <div className="flex flex-wrap items-center gap-2 mb-1">
              <h1 className="font-bold text-2xl brand-title">{t('dashboard.title')}</h1>
              {tagline ? (
                <span className="inline-flex items-center gap-1.5 bg-primary-500/15 px-2.5 py-0.5 border border-primary-500/30 rounded-full font-bold text-xs brand-tagline brand-tagline-badge">
                  <span className="bg-primary-500 rounded-full w-1.5 h-1.5" />
                  {brandName} — {tagline}
                </span>
              ) : (
                <span className="inline-flex items-center gap-1.5 bg-primary-500/15 px-2.5 py-0.5 border border-primary-500/30 rounded-full font-bold text-xs brand-tagline brand-tagline-badge">
                  <span className="bg-primary-500 rounded-full w-1.5 h-1.5" />
                  {brandName}
                </span>
              )}
            </div>
          </div>
        </div>

        {/* ── Pending Approval Alert ── */}
        {isPendingApproval && (
          <motion.div
            initial={{ opacity: 0, y: -6 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex items-center gap-3.5 bg-amber-500/10 dark:bg-amber-500/15 shadow-xs p-4 border border-amber-500/30 rounded-2xl text-amber-900 dark:text-amber-100"
          >
            <div className="flex justify-center items-center bg-amber-500/20 border border-amber-500/30 rounded-xl w-10 h-10 text-amber-600 dark:text-amber-400 shrink-0">
              <Clock size={22} className="animate-pulse" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="font-bold text-amber-950 dark:text-amber-100 text-sm">
                  {t('dashboard.pendingApprovalTitle')}
                </h3>

              </div>
              <p className="mt-0.5 text-amber-800 dark:text-amber-300/90 text-xs">
                {t('dashboard.pendingApprovalDesc')}
              </p>
            </div>
          </motion.div>
        )}

        {/* ── Banned Alert ── */}
        {isBanned && (
          <motion.div
            initial={{ opacity: 0, y: -6 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex items-center gap-3.5 bg-rose-500/15 shadow-xs p-3.5 sm:p-4 border border-rose-500/40 rounded-2xl text-rose-950 dark:text-rose-100 dashboard-banner-banned"
          >
            <div className="flex justify-center items-center bg-rose-500/20 border border-rose-500/40 rounded-xl w-10 h-10 text-rose-400 banner-icon-box shrink-0">
              <ShieldAlert size={22} />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="font-bold text-rose-950 dark:text-rose-100 text-sm banner-title">
                  {t('dashboard.bannedTitle')}
                </h3>
                <span className="py-0.5 text-[10px] badge badge-red">{t('dashboard.bannedBadge')}</span>
              </div>
              <p className="mt-0.5 text-rose-800 dark:text-rose-300/90 text-xs banner-desc">
                {t('dashboard.bannedDesc')}
              </p>
            </div>
          </motion.div>
        )}

        {/* ── Expiry Alert: Expired ── */}
        {isExpired && (
          <motion.div
            initial={{ opacity: 0, y: -6 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex items-center gap-3.5 bg-rose-500/10 dark:bg-rose-500/15 shadow-xs p-3.5 sm:p-4 border border-rose-500/30 rounded-2xl text-rose-900 dark:text-rose-100"
          >
            <div className="flex justify-center items-center bg-rose-500/20 border border-rose-500/30 rounded-xl w-10 h-10 text-rose-600 dark:text-rose-400 shrink-0">
              <AlertCircle size={22} />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="font-bold text-rose-900 dark:text-rose-100 text-sm">
                  {t('dashboard.expiredTitle')}
                </h3>

              </div>
              <p className="mt-0.5 text-rose-700 dark:text-rose-300/90 text-xs">
                {t('dashboard.expiredDesc')}
              </p>
            </div>
          </motion.div>
        )}

        {/* ── Expiry Alert: Expiring Soon (3 days or less) ── */}
        {isExpiringSoon && (
          <motion.div
            initial={{ opacity: 0, y: -6 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex items-center gap-3.5 bg-amber-500/10 dark:bg-amber-500/15 shadow-xs p-3.5 sm:p-4 border border-amber-500/35 rounded-2xl text-amber-900 dark:text-amber-100"
          >
            <div className="flex justify-center items-center bg-amber-500/20 border border-amber-500/30 rounded-xl w-10 h-10 text-amber-600 dark:text-amber-400 shrink-0">
              <AlertTriangle size={22} />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="font-bold text-amber-900 dark:text-amber-100 text-sm">
                  {daysRemaining === 0
                    ? t('dashboard.expiringTodayTitle')
                    : daysRemaining === 1
                    ? t('dashboard.expiringOneDayTitle')
                    : t('dashboard.expiringSoonTitle', { days: daysRemaining })}
                </h3>
                <span className="py-0.5 text-[10px] animate-pulse badge badge-yellow">
                  {daysRemaining === 0 ? t('dashboard.lastDay') : t('dashboard.daysRemainingBadge', { count: daysRemaining })}
                </span>
              </div>
              <p className="mt-0.5 text-amber-700 dark:text-amber-300/90 text-xs">
                {t('dashboard.expiringSoonDesc')}
              </p>
            </div>
          </motion.div>
        )}

        {/* ── Empty State ─────────────────────────────────── */}
        {!castlesQuery.isLoading && allCastles.length === 0 && (
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-6 p-8 text-center glass-card"
          >
            <div className="flex justify-center items-center bg-gray-100 dark:bg-white/5 shadow-md mx-auto border border-gray-200 dark:border-primary-500/30 rounded-2xl w-20 h-20 overflow-hidden">
              <img src={logoUrl || "/logo.png?v=2"} alt={brandName} className="w-full h-full object-cover" />
            </div>
            <div>
              {tagline ? (
                <div className="inline-block bg-primary-500/15 mb-2 px-2.5 py-0.5 border border-primary-500/30 rounded-full font-bold text-xs brand-tagline brand-tagline-badge">
                  {tagline}
                </div>
              ) : null}
              <h2 className="mb-2 font-bold text-xl brand-title">{t('dashboard.welcomeTitle', { brand: brandName })}</h2>
              <p className="mx-auto max-w-sm text-gray-500 dark:text-gray-400 text-sm">
                {t('dashboard.welcomeDesc')}
              </p>
            </div>
            <div className="gap-4 grid grid-cols-1 sm:grid-cols-3 text-start">
              {[
                { icon: <Plus size={18} />, step: '1', title: t('dashboard.step1Title'), desc: t('dashboard.step1Desc'), clr: 'border-primary-500/30 text-primary-600 dark:text-primary-400 bg-primary-500/10' },
                { icon: <Zap  size={18} />, step: '2', title: t('dashboard.step2Title'), desc: t('dashboard.step2Desc'), clr: 'border-blue-500/30 text-blue-600 dark:text-blue-400 bg-blue-500/10' },
                { icon: <Bot  size={18} />, step: '3', title: t('dashboard.step3Title'), desc: t('dashboard.step3Desc'), clr: 'border-primary-500/30 text-primary-600 dark:text-primary-400 bg-primary-500/10' },
              ].map(s => (
                <div key={s.step} className={`p-4 rounded-xl border ${s.clr} space-y-2`}>
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center border ${s.clr}`}>{s.icon}</div>
                  <div className="text-gray-500 text-xs">{t('dashboard.stepPrefix')} {s.step}</div>
                  <div className="font-semibold text-sm brand-title">{s.title}</div>
                  <div className="text-gray-500 text-xs">{s.desc}</div>
                </div>
              ))}
            </div>
            <Link to="/accounts" className="inline-flex gap-2 btn-primary">
              <Plus size={16} />
              {t('dashboard.addFirstCastle')}
            </Link>
          </motion.div>
        )}

        {/* Stats cards */}
        {allCastles.length > 0 && (
          <div className="gap-4 grid grid-cols-2 lg:grid-cols-4">
            {stats.map((s, i) => (
              <motion.div
                key={s.label}
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.07 }}
                className={`glass-card p-5 border ${s.bg}`}
              >
                <div className="flex justify-between items-center mb-3">
                  <span className="text-2xl">{s.icon}</span>
                  {errors > 0 && s.label === t('dashboard.activeCastles') && (
                    <span className="badge badge-red">{t('dashboard.errorCount', { count: errors })}</span>
                  )}
                  {s.badge && (
                    <span className={`badge ${isExpired ? 'badge-red' : 'badge-yellow animate-pulse'} text-[10px]`}>
                      {s.badge}
                    </span>
                  )}
                </div>
                <div className={`text-2xl font-bold ${s.color}`}>{s.value}</div>
                <div className="mt-1 text-gray-500 text-xs">{s.label}</div>
              </motion.div>
            ))}
          </div>
        )}

        {/* Subscription info */}
        {sub && (
          <div className={`glass-card p-4 flex items-center justify-between flex-wrap gap-3 transition-all ${
            isExpired
              ? 'border-rose-500/40 bg-rose-50/50 dark:bg-rose-950/20 shadow-xs'
              : isExpiringSoon
              ? 'border-amber-500/40 bg-amber-50/50 dark:bg-amber-950/20 shadow-xs'
              : ''
          }`}>
            <div>
              <div className="flex flex-wrap items-center gap-2 font-medium text-sm brand-title">
                {isAdmin && <Crown size={15} className="inline text-amber-500" />}
                <span>{isAdmin ? t('dashboard.superAdminFull') : isPendingApproval ? t('dashboard.pendingApprovalStatus') : planDisplayName}</span>
                {isExpired && <span className="text-[10px] badge badge-red">{t('dashboard.expiredBadge')}</span>}
                {isExpiringSoon && <span className="text-[10px] animate-pulse badge badge-yellow">{t('dashboard.expiringSoonBadge')}</span>}
              </div>

            </div>
            <div className="flex items-center gap-3 text-sm">
              <span className="text-gray-400">
                {t('dashboard.castlesCount')}:{' '}
                <span className="font-medium brand-title">
                  {isAdmin ? `${sub.current_castles_count} / ${t('dashboard.unlimited')}` : `${sub.current_castles_count}/${sub.max_castles_allowed}`}
                </span>
              </span>
              {!isAdmin && (
                <div className="bg-slate-200 dark:bg-white/10 rounded-full w-32 h-2 overflow-hidden">
                  <div
                    className={`h-full rounded-full transition-all ${
                      isExpired ? 'bg-rose-500' : isExpiringSoon ? 'bg-amber-500' : 'bg-primary-500'
                    }`}
                    style={{ width: `${Math.min(100, ((sub.current_castles_count ?? 0) / (sub.max_castles_allowed || 1)) * 100)}%` }}
                  />
                </div>
              )}
            </div>
          </div>
        )}

        {/* Recent castles */}
        {allCastles.length > 0 && (
          <div className="overflow-hidden glass-card">
            <div className="flex justify-between items-center px-5 py-3.5 border-gray-100 dark:border-white/8 border-b">
              <div className="flex items-center gap-2">
                <img
                  src="/images/castles/main_castle_square.png"
                  alt=""
                  className="w-5 h-5 object-contain select-none"
                  loading="lazy"
                />
                <h2 className="font-semibold text-sm sm:text-base brand-title">{t('dashboard.recentActivity')}</h2>
                <span className="bg-primary-500/15 px-2 py-0.5 border border-primary-500/30 rounded-full font-bold text-[10px] text-primary-700 dark:text-primary-300">
                  {allCastles.length}
                </span>
              </div>
              <Link
                to="/accounts"
                className="text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 text-xs font-semibold transition-colors"
              >
                {t('dashboard.viewAllAccounts')} &larr;
              </Link>
            </div>
            <div className="divide-y divide-gray-100 dark:divide-white/6">
              {allCastles.map(c => {
                const info = c.castle_info
                const emailPrefix = (c.email || '').split('@')[0] || t('common.castle', 'قلعة')
                const isGenericName = !info?.lord_name || ['لورد الإمبراطورية', 'القلعة الملكية', 'قلعة جديدة', 'غير معروف', 'قلعة'].includes(info.lord_name)
                const displayLordName = isGenericName ? emailPrefix : info.lord_name
                const castleLevel = info?.castle_level || 1

                return (
                  <Link
                    key={c.id}
                    to="/accounts"
                    className="flex justify-between items-center hover:bg-black/2 dark:hover:bg-white/3 px-4 sm:px-5 py-3.5 transition-colors group"
                  >
                    <div className="flex items-center gap-3.5 sm:gap-4 min-w-0">
                      {/* أيقونة القلعة الكبيرة والواضحة جداً */}
                      <div className="relative flex-shrink-0">
                        <div className="flex justify-center items-center bg-gradient-to-br from-amber-500/15 via-orange-500/10 to-amber-500/5 dark:from-amber-400/20 dark:to-transparent border border-amber-500/30 dark:border-amber-500/35 rounded-2xl w-14 h-14 sm:w-16 sm:h-16 p-1 shadow-sm overflow-hidden group-hover:scale-105 transition-transform duration-200">
                          <img
                            src="/images/castles/main_castle_square.png"
                            alt={displayLordName}
                            className="w-full h-full object-contain filter drop-shadow-md select-none"
                            loading="lazy"
                          />
                        </div>
                        {castleLevel > 0 && (
                          <span className="absolute -bottom-1 -end-1 bg-gradient-to-r from-amber-600 to-amber-700 text-white font-black text-[9px] sm:text-[10px] px-1.5 py-0.5 rounded-full border border-amber-300/40 shadow-sm leading-none select-none">
                            {castleLevel}
                          </span>
                        )}
                      </div>

                      <div className="min-w-0 flex-1">
                        <div className="flex flex-wrap items-center gap-1.5 sm:gap-2">
                          <span className="font-bold text-gray-900 dark:text-white text-sm sm:text-base brand-title truncate">
                            {displayLordName}
                          </span>

                          {castleLevel > 0 && (
                            <span className="inline-flex items-center gap-1 bg-amber-500/15 px-1.5 sm:px-2 py-0.5 border border-amber-500/30 rounded-md font-bold text-[10px] sm:text-xs text-amber-800 dark:text-amber-300 select-none">
                              {t('accounts.castleLevelPrefix', 'قلعة')} {castleLevel}
                            </span>
                          )}

                          {info?.server_id ? (
                            <span className="bg-blue-500/10 px-1.5 py-0.5 border border-blue-500/25 rounded-md font-semibold text-[10px] text-blue-700 dark:text-blue-300 select-none">
                              #{info.server_id}
                            </span>
                          ) : null}

                          {info?.alliance_name ? (
                            <span className="bg-primary-500/15 px-1.5 py-0.5 border border-primary-500/30 rounded-md font-semibold text-[10px] text-primary-700 dark:text-primary-300 select-none">
                              [{info.alliance_name.split(' ')[0]}]
                            </span>
                          ) : null}
                        </div>

                        <div className="text-gray-500 dark:text-gray-400 text-xs font-mono truncate mt-0.5">
                          {c.email}
                        </div>
                      </div>
                    </div>

                    <div className="flex-shrink-0 ms-3">
                      <StatusBadge state={c.bot_status.state} label={t(`status.${c.bot_status.state}`)} />
                    </div>
                  </Link>
                )
              })}
            </div>
          </div>
        )}
      </div>
    </Layout>
  )
}

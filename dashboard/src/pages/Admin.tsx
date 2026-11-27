import React, { useState, useEffect } from 'react'
import { createPortal } from 'react-dom'
import { useTranslation } from 'react-i18next'
import {
  Search, Shield, Trash2, Edit, Ban, CheckCircle, Clock, X,
  Layers, Calendar, Plus, Minus, AlertTriangle, Users,
  Infinity, RotateCcw, UserCheck, CheckCheck, RefreshCw, Activity, ShieldCheck, MoreHorizontal,
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { AdminLayout } from '../components/layout/AdminLayout'
import {
  useAllUsers, useBanUser, useDeleteUser,
  useApproveCastle, useRejectCastle
} from '../hooks/useUsers'
import { useCastles, useDeleteCastle } from '../hooks/useCastles'
import { useQueryClient } from '@tanstack/react-query'
import { updateAdminSubscription, banAdminUser, approveAdminUser, approveAllPendingAdminUsers } from '../lib/botApi'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { AdminLiveProcessesView } from './AdminLiveProcesses'
import type { User, Subscription, Castle } from '../types'
import toast from 'react-hot-toast'

export const isSuperAdminUser = (u?: Partial<User> | null) => {
  if (!u) return false
  const email = (u.email || '').toLowerCase().trim()
  return email === 'ibraboths@gmail.com'
}

const formatDate = (d: Date | null) => {
  if (!d || isNaN(d.getTime())) return '—'
  return `${d.getFullYear()}/${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}`
}

const toYMD = (d: Date | null) => {
  if (!d || isNaN(d.getTime())) return ''
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

// فئات قرب الانتهاء (باليوم التقويمي المحلي): اليوم / غداً / 2–3 أيام / 4–7 أيام
type ExpiryBucket = 'today' | 'tomorrow' | 'days3' | 'days7'
type AdminUserFilter = 'all' | ExpiryBucket | 'expired' | 'pending' | 'banned'
type UserMeta = ReturnType<typeof getUserStatusMeta>

function getUserStatusMeta(u: User) {
  const expDate = u.subscription?.expires_at ? new Date(u.subscription.expires_at) : null
  const hasValidExp = Boolean(expDate && !isNaN(expDate.getTime()))
  const isLifetime = hasValidExp && expDate!.getFullYear() >= 2090
  const isPending = u.subscription?.status === 'pending_approval'
  const isBanned = Boolean(u.is_banned)
  const isSuspended = u.subscription?.status === 'suspended'
  const isExpired = !isPending && !isLifetime && (!hasValidExp || expDate!.getTime() <= Date.now())
  const daysLeft = isLifetime
    ? 999999
    : (hasValidExp ? Math.ceil((expDate!.getTime() - Date.now()) / 86400000) : -999999)

  let statusKey: 'banned' | 'suspended' | 'pending' | 'expired' | 'active' = 'active'
  if (isBanned) statusKey = 'banned'
  else if (isSuspended) statusKey = 'suspended'
  else if (isPending) statusKey = 'pending'
  else if (isExpired) statusKey = 'expired'

  // فرق الأيام التقويمية المحلية: 0 = اليوم، 1 = غداً، سالب = انتهى قبل اليوم
  let dayDiff: number | null = null
  if (hasValidExp && !isLifetime) {
    const startOfDay = (d: Date) => new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime()
    dayDiff = Math.round((startOfDay(expDate!) - startOfDay(new Date())) / 86400000)
  }
  let expiryBucket: ExpiryBucket | null = null
  if (dayDiff !== null && (statusKey === 'active' || statusKey === 'expired')) {
    if (dayDiff === 0) expiryBucket = 'today'
    else if (dayDiff === 1) expiryBucket = 'tomorrow'
    else if (dayDiff >= 2 && dayDiff <= 3) expiryBucket = 'days3'
    else if (dayDiff >= 4 && dayDiff <= 7) expiryBucket = 'days7'
  }

  const currentCastles = Number(u.subscription?.current_castles_count ?? 0)
  const maxCastles = Number(u.subscription?.max_castles_allowed ?? 0)
  const pendingCastles = Number(u.subscription?.pending_castles_count ?? 0)
  const allowedCastles = Number(
    u.subscription?.allowed_castles_count ?? (statusKey === 'active' && maxCastles > 0 ? currentCastles : 0)
  )
  const runningCastles = Number(u.subscription?.running_castles_count ?? 0)

  return {
    expDate: hasValidExp ? expDate : null,
    isLifetime,
    isPending,
    isBanned,
    isSuspended,
    isExpired,
    daysLeft,
    dayDiff,
    expiryBucket,
    statusKey,
    currentCastles,
    maxCastles,
    pendingCastles,
    allowedCastles,
    runningCastles,
  }
}

function UserStatusBadge({
  meta,
  compact = false,
  t,
}: {
  meta: ReturnType<typeof getUserStatusMeta>
  compact?: boolean
  t: (k: string, opts?: any) => string
}) {
  const sz = compact ? 'text-[10px] py-0.5' : ''
  const iconSz = compact ? 10 : 11
  if (meta.statusKey === 'banned') {
    return <span className={`badge badge-red ${sz}`}>{t('dashboard.bannedBadge')}</span>
  }
  if (meta.statusKey === 'suspended') {
    return <span className={`badge badge-yellow ${sz}`}>{t('admin.table.suspended')}</span>
  }
  if (meta.statusKey === 'pending') {
    return (
      <span className={`flex items-center gap-1 font-bold badge badge-yellow ${sz}`}>
        <Clock size={iconSz} /> {t('admin.pendingApproval')}
      </span>
    )
  }
  if (meta.isLifetime) {
    return (
      <span className={`flex items-center gap-1 badge badge-green ${sz}`}>
        <Infinity size={iconSz} /> {t('admin.table.lifetimeShort')}
      </span>
    )
  }
  if (meta.statusKey === 'expired') {
    return <span className={`badge badge-red ${sz}`}>{t('dashboard.expiredBadge')}</span>
  }
  return <span className={`badge badge-green ${sz}`}>{t('admin.table.active')}</span>
}

// ─── Confirm Dialog ──────────────────────────────────────────
function ConfirmDialog({
  title, message, email, onConfirm, onCancel, loading = false,
}: {
  title: string; message: string; email?: string;
  onConfirm: () => void; onCancel: () => void; loading?: boolean
}) {
  const { t } = useTranslation()
  return createPortal(
    <div className="z-[100] fixed inset-0 flex justify-center items-center p-3 sm:p-4 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 bg-black/65 dark:bg-black/80"
        onClick={onCancel}
      />
      <motion.div
        initial={{ opacity: 0, scale: 0.92, y: 16 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.92, y: 16 }}
        transition={{ duration: 0.18, ease: 'easeOut' }}
        className="z-10 relative bg-white dark:bg-[#0c1410] shadow-2xl border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-xs sm:max-w-sm overflow-hidden text-gray-900 dark:text-gray-100 admin-modal"
      >
        {/* Red accent top line */}
        <div className="bg-red-500 w-full h-1" />

        <div className="space-y-4 p-4 sm:p-6">
          {/* Icon + Title */}
          <div className="flex flex-col items-center gap-2.5 text-center">
            <div className="flex justify-center items-center bg-red-500/10 border border-red-500/20 rounded-2xl w-12 h-12">
              <AlertTriangle size={24} className="text-red-500 dark:text-red-400" />
            </div>
            <div>
              <h3 className="font-bold text-gray-900 dark:text-white text-base">{title}</h3>
              <p className="mt-1 text-gray-500 dark:text-gray-400 text-xs leading-relaxed">{message}</p>
            </div>
          </div>

          {/* Email badge */}
          {email && (
            <div className="bg-gray-50 dark:bg-white/[0.03] px-3 py-2 border border-gray-200 dark:border-white/8 rounded-xl text-center">
              <span className="block font-mono text-gray-700 dark:text-gray-300 text-xs truncate select-all">{email}</span>
            </div>
          )}

          {/* Buttons */}
          <div className="flex gap-2 pt-1">
            <button
              type="button"
              onClick={onCancel}
              disabled={loading}
              className="flex-1 py-2.5 border border-gray-200 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-sm cursor-pointer"
            >
              {t('common.cancel')}
            </button>
            <button
              type="button"
              onClick={onConfirm}
              disabled={loading}
              className="flex flex-1 justify-center items-center gap-1.5 bg-red-600 disabled:opacity-50 shadow-sm py-2.5 rounded-xl font-bold text-white text-sm active:scale-[0.98] cursor-pointer"
            >
              {loading ? (
                <><div className="border-2 border-white/30 border-t-white rounded-full w-3.5 h-3.5 animate-spin" />{t('admin.modals.deleting')}</>
              ) : (
                <><Trash2 size={13} />{t('admin.modals.deletePermanent')}</>
              )}
            </button>
          </div>
        </div>
      </motion.div>
    </div>,
    document.body
  )
}

// Stepper Component
// Stepper Component
function Stepper({
  value, min = 1, max = 3650, onChange, color = 'emerald', unit = '',
}: {
  value: number; min?: number; max?: number; onChange: (v: number) => void; color?: 'emerald' | 'primary'; unit?: string
}) {
  const accent = color === 'emerald' ? 'text-emerald-600 dark:text-emerald-400' : 'text-primary-600 dark:text-primary-400'
  const btnBg = color === 'emerald'
    ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-500/15 dark:text-emerald-300'
    : 'bg-primary-100 text-primary-800 dark:bg-primary-500/15 dark:text-primary-300'
  return (
    <div className="flex justify-center items-center gap-3 sm:gap-4">
      <button
        type="button"
        onClick={() => onChange(Math.max(min, value - 1))}
        disabled={value <= min}
        className={`w-10 h-10 sm:w-11 sm:h-11 rounded-full flex items-center justify-center active:scale-90 disabled:opacity-25 ${btnBg} cursor-pointer shrink-0`}
      >
        <Minus size={18} />
      </button>
      <div className="flex justify-center items-center gap-1">
        <input
          type="number"
          min={min}
          max={max}
          value={value || ''}
          onFocus={e => e.currentTarget.select()}
          onClick={e => e.currentTarget.select()}
          onChange={e => {
            const parsed = parseInt(e.target.value, 10)
            if (isNaN(parsed)) onChange(min)
            else onChange(Math.max(min, Math.min(max, parsed)))
          }}
          className={`w-20 sm:w-24 text-center font-black text-2xl sm:text-3xl bg-transparent border-0 focus:ring-0 p-0 cursor-text select-all ${accent}`}
          dir="ltr"
        />
        {unit && <span className="font-bold text-slate-500 dark:text-slate-400 text-xs select-none">{unit}</span>}
      </div>
      <button
        type="button"
        onClick={() => onChange(Math.min(max, value + 1))}
        disabled={value >= max}
        className={`w-10 h-10 sm:w-11 sm:h-11 rounded-full flex items-center justify-center active:scale-90 disabled:opacity-25 ${btnBg} cursor-pointer shrink-0`}
      >
        <Plus size={18} />
      </button>
    </div>
  )
}

// Quick Chips
function QuickChips({ options, value, onSelect, color = 'emerald' }: {
  options: { label: string; value: number }[]; value: number; onSelect: (v: number) => void; color?: 'emerald' | 'primary'
}) {
  const activeClass = color === 'emerald'
    ? 'bg-emerald-600 text-white shadow-xs dark:bg-emerald-500 dark:text-black'
    : 'bg-primary-600 text-white shadow-xs dark:bg-primary-500 dark:text-black'
  const inactiveClass = 'bg-gray-100 dark:bg-white/5 text-gray-700 dark:text-gray-300'
  return (
    <div className="flex flex-wrap justify-center items-center gap-1.5 pt-1">
      {options.map(opt => (
        <button
          key={opt.value}
          type="button"
          onClick={() => onSelect(opt.value)}
          className={`px-3 py-1.5 rounded-xl text-xs font-bold cursor-pointer ${
            value === opt.value ? activeClass : inactiveClass
          }`}
        >
          {opt.label}
        </button>
      ))}
    </div>
  )
}

// Modal 1: Edit User Subscription & Status
function EditUserModal({ user, onClose }: { user: User; onClose: () => void }) {
  const { t } = useTranslation()
  const qc = useQueryClient()
  const [saving, setSaving] = useState(false)
  const isPendingApproval = user.subscription?.status === 'pending_approval'
  const [castles, setCastles] = useState<number>(
    isPendingApproval ? 10 : Number(user.subscription?.max_castles_allowed ?? 1)
  )
  const [isBanned, setIsBanned] = useState<boolean>(Boolean(user.is_banned))

  const now = new Date()
  const currentExp = user.subscription?.expires_at ? new Date(user.subscription.expires_at) : null
  const isCurrentValid = currentExp && currentExp.getTime() > now.getTime()
  const initialBase = isCurrentValid ? currentExp : (isPendingApproval ? new Date(now.getTime() + 3 * 86400000) : now)

  // targetDate starts from current valid expiration date, or from now if expired
  const [targetDate, setTargetDate] = useState<Date>(initialBase)

  const isZero = targetDate.getTime() <= now.getTime()
  const daysRemaining = isZero ? 0 : Math.ceil((targetDate.getTime() - now.getTime()) / 86400000)

  // Handlers for adding duration onto current target
  const addDays = (numDays: number) => {
    setTargetDate(prev => {
      // If currently zeroed or expired, start adding from today
      const base = prev.getTime() > now.getTime() ? prev : now
      return new Date(base.getTime() + numDays * 86400000)
    })
  }

  const handleReset = () => {
    setTargetDate(now)
  }

  const handleDirectApprove = async () => {
    setSaving(true)
    try {
      await approveAdminUser(user.uid, 3, 10)
      qc.invalidateQueries({ queryKey: ['admin_users'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['castles', user.uid] })
      qc.invalidateQueries({ queryKey: ['castles'] })
      toast.success(t('admin.quickApproveSuccess', { name: user.username || user.email }))
      onClose()
    } catch {
      toast.error(t('common.error'))
    } finally {
      setSaving(false)
    }
  }

  const handleSave = async () => {
    setSaving(true)
    try {
      const isZeroed = targetDate.getTime() <= now.getTime()
      const finalDays = isZeroed ? 0 : daysRemaining
      const finalStatus = isZeroed ? 'expired' : 'active'
      const finalExpiresAt = isZeroed ? now.toISOString() : targetDate.toISOString()

      await updateAdminSubscription(user.uid, {
        plan_id: `${castles}_castles_${finalDays}d`,
        plan_name: isZeroed ? `${castles} حساب (منتهي)` : `${castles} حساب (${finalDays} يوم)`,
        subscription_status: finalStatus,
        expires_at: finalExpiresAt,
        max_castles_allowed: castles,
      })

      if (isBanned !== user.is_banned) {
        await banAdminUser(user.uid, { is_banned: isBanned })
      }

      qc.invalidateQueries({ queryKey: ['admin_users'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['castles', user.uid] })
      qc.invalidateQueries({ queryKey: ['castles'] })
      toast.success(t('admin.modals.saveSuccess'))
      onClose()
    } catch {
      toast.error(t('admin.modals.saveError'))
    } finally {
      setSaving(false)
    }
  }

  return createPortal(
    <div className="z-[100] fixed inset-0 flex justify-center items-center p-3 sm:p-4 overflow-y-auto" onClick={onClose}>
      <div className="fixed inset-0 bg-black/65 dark:bg-black/75" />
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: 16 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: 16 }}
        transition={{ duration: 0.15 }}
        className="z-10 relative bg-white dark:bg-[#0c1410] shadow-2xl my-auto border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-sm sm:max-w-md overflow-hidden text-gray-900 dark:text-gray-100 admin-modal"
        onClick={e => e.stopPropagation()}
      >
        <div className="bg-emerald-500 w-full h-1" />
        <div className="space-y-4 p-4 sm:p-5">
          {/* Header */}
          <div className="flex justify-between items-center gap-3 pb-3 border-gray-200 dark:border-white/8 border-b">
            <div className="flex items-center gap-3 min-w-0">
              <div className="flex justify-center items-center bg-emerald-100/90 dark:bg-emerald-950/70 border border-emerald-200 dark:border-emerald-500/30 rounded-xl w-10 h-10 font-black text-emerald-800 dark:text-emerald-400 text-xs shrink-0">
                {(user.username || user.email)?.[0]?.toUpperCase()}
              </div>
              <div className="min-w-0">
                <div className="flex items-center gap-2">
                  <h3 className="font-bold text-gray-900 dark:text-white text-base truncate">
                    {user.username || t('admin.modals.editUserTitle')}
                  </h3>
                  {isBanned && (
                    <span className="py-0.5 text-[10px] badge badge-red shrink-0">{t('dashboard.bannedBadge', 'محظور')}</span>
                  )}
                </div>
                <p className="mt-0.5 font-mono text-gray-500 dark:text-gray-400 text-xs truncate select-all">
                  {user.email}
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="flex justify-center items-center bg-gray-100 dark:bg-white/5 rounded-full w-8 h-8 text-gray-500 dark:text-gray-400 cursor-pointer shrink-0"
            >
              <X size={16} />
            </button>
          </div>

          {/* Pending Approval Banner */}
          {isPendingApproval && (
            <div className="flex justify-between items-center gap-2 bg-amber-500/10 p-3 border border-amber-500/30 rounded-xl">
              <div className="flex items-center gap-2 min-w-0">
                <Clock className="text-amber-500 shrink-0" size={16} />
                <span className="font-semibold text-amber-800 dark:text-amber-300 text-xs truncate">
                  {t('admin.modalPendingNotice')}
                </span>
              </div>
              <button
                type="button"
                onClick={handleDirectApprove}
                disabled={saving}
                className="flex items-center gap-1 bg-emerald-600 shadow-xs px-2.5 py-1.5 rounded-lg font-bold text-white text-xs cursor-pointer shrink-0"
              >
                <UserCheck size={13} />
                <span>{t('admin.modalActivateBtn')}</span>
              </button>
            </div>
          )}

          {/* Section 1: Castles Quota */}
          <div className="space-y-2.5 bg-gray-50 dark:bg-white/[0.03] p-3 sm:p-3.5 border border-gray-200 dark:border-white/8 rounded-xl">
            <div className="flex justify-between items-center text-xs">
              <div className="flex items-center gap-1.5 font-semibold text-gray-700 dark:text-gray-300">
                <Layers size={14} className="text-primary-600 dark:text-primary-400" />
                <span>{t('admin.modals.allowedQuota')}</span>
              </div>
              <div className="flex flex-wrap items-center gap-2 font-mono text-slate-500 dark:text-slate-400 text-xs">
                <span>({t('admin.modals.actualExisting', { count: user.subscription?.current_castles_count ?? 0 })})</span>
                {(user.subscription?.running_castles_count ?? 0) > 0 && (
                  <span className="bg-emerald-500/10 px-1.5 py-0.5 border border-emerald-500/25 rounded font-sans font-bold text-[10px] text-emerald-600 dark:text-emerald-400">
                    {t('admin.table.runningCount', { count: user.subscription?.running_castles_count ?? 0 })}
                  </span>
                )}
              </div>
            </div>
            <div className="flex justify-center py-0.5">
              <Stepper value={castles} onChange={setCastles} max={500} color="primary" unit="" />
            </div>
            <QuickChips
              options={[{label:'1',value:1},{label:'3',value:3},{label:'5',value:5},{label:'10',value:10},{label:'20',value:20}]}
              value={castles}
              onSelect={setCastles}
              color="primary"
            />
          </div>

          {/* Section 2: Subscription Duration (فقط زر شهر وزر أسبوع وزر تصفير مع عرض فوري) */}
          <div className="space-y-3.5 bg-gray-50 dark:bg-white/[0.03] p-3.5 sm:p-4 border border-gray-200 dark:border-white/8 rounded-xl">
            <div className="flex items-center gap-1.5 font-semibold text-gray-700 dark:text-gray-300 text-xs">
              <Calendar size={14} className="text-emerald-600 dark:text-emerald-400" />
              <span>{t('admin.modals.subDuration')}</span>
            </div>

            {/* Live Instant Expiry & Days Display with Editable Date Picker */}
            <div className={`p-3 sm:p-3.5 rounded-xl border ${
              isZero
                ? 'bg-rose-50/80 dark:bg-rose-950/20 border-rose-200 dark:border-rose-500/30'
                : 'bg-emerald-50/80 dark:bg-emerald-950/20 border-emerald-200 dark:border-emerald-500/30'
            }`}>
              <div className="flex justify-between items-center gap-2 text-xs">
                <span className="font-semibold text-slate-700 dark:text-slate-300 shrink-0">{t('admin.modals.expiryDate')}</span>
                <input
                  type="date"
                  value={toYMD(targetDate)}
                  onChange={e => {
                    const [y, m, d] = e.target.value.split('-').map(Number)
                    if (y && m && d) {
                      setTargetDate(new Date(y, m - 1, d, 23, 59, 59))
                    }
                  }}
                  className="bg-white dark:bg-black/40 px-2.5 py-1 border border-slate-300 dark:border-white/15 rounded-lg focus:outline-none focus:ring-1 focus:ring-emerald-500 font-mono font-bold text-slate-900 dark:text-white text-xs cursor-pointer [color-scheme:light] dark:[color-scheme:dark]"
                />
              </div>
              <div className="flex justify-between items-center mt-2 pt-2 border-slate-200/60 dark:border-white/5 border-t text-xs">
                <span className="font-medium text-slate-600 dark:text-slate-400">{t('admin.modals.daysRemaining')}</span>
                <span className={`font-bold text-sm ${isZero ? 'text-rose-600 dark:text-rose-400' : 'text-emerald-700 dark:text-emerald-300'}`}>
                  {isZero ? t('admin.modals.expiredNow') : `${daysRemaining} ${t('common.days')}`}
                </span>
              </div>
            </div>

            {/* Duration Action Buttons: + شهر | + أسبوع | تصفير */}
            <div className="gap-2 grid grid-cols-3 pt-0.5">
              <button
                type="button"
                onClick={() => addDays(30)}
                className="flex justify-center items-center gap-1.5 bg-emerald-600 shadow-xs px-2 py-2.5 rounded-xl font-bold text-white text-xs active:scale-95 cursor-pointer"
              >
                <Plus size={14} />
                <span>{t('admin.modals.addMonth')}</span>
              </button>

              <button
                type="button"
                onClick={() => addDays(7)}
                className="flex justify-center items-center gap-1.5 bg-primary-600 shadow-xs px-2 py-2.5 rounded-xl font-bold text-white text-xs active:scale-95 cursor-pointer"
              >
                <Plus size={14} />
                <span>{t('admin.modals.addWeek')}</span>
              </button>

              <button
                type="button"
                onClick={handleReset}
                className="flex justify-center items-center gap-1.5 bg-gray-100 dark:bg-white/5 px-2 py-2.5 border border-gray-200 dark:border-white/10 rounded-xl font-bold text-gray-700 dark:text-gray-300 text-xs active:scale-95 cursor-pointer"
              >
                <RotateCcw size={13} />
                <span>{t('admin.modals.reset')}</span>
              </button>
            </div>
          </div>

          {/* Section 3: Ban Account Action Button (حظر الحساب) */}
          <div className="pt-0.5">
            <button
              type="button"
              onClick={() => setIsBanned(v => !v)}
              className={`w-full flex items-center justify-center gap-2 py-2.5 px-4 rounded-xl text-xs font-bold border cursor-pointer active:scale-[0.99] ${
                isBanned
                  ? 'bg-emerald-50 dark:bg-emerald-950/30 text-emerald-700 dark:text-emerald-300 border-emerald-300 dark:border-emerald-500/40'
                  : 'bg-rose-50 dark:bg-rose-950/30 text-rose-700 dark:text-rose-400 border-rose-200 dark:border-rose-500/30'
              }`}
            >
              {isBanned ? (
                <>
                  <CheckCircle size={15} />
                  <span>{t('admin.modals.unbanAccount')}</span>
                </>
              ) : (
                <>
                  <Ban size={15} />
                  <span>{t('admin.modals.banAccount')}</span>
                </>
              )}
            </button>
          </div>

          {/* Footer Actions */}
          <div className="flex gap-2.5 pt-1">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-3 border border-gray-200 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-sm cursor-pointer"
            >
              {t('common.cancel')}
            </button>
            <button
              type="button"
              onClick={handleSave}
              disabled={saving}
              className="flex-1 bg-emerald-600 disabled:opacity-50 shadow-sm py-3 rounded-xl font-bold text-white text-sm active:scale-[0.98] cursor-pointer"
            >
              {saving ? t('common.loading') : t('common.save')}
            </button>
          </div>
        </div>
      </motion.div>
    </div>,
    document.body
  )
}

// Modal 2: Manage User Castles
function UserCastlesModal({ user, onClose }: { user: User; onClose: () => void }) {
  const { t } = useTranslation()
  const { data, isLoading, refetch } = useCastles(user.uid)
  useEffect(() => {
    void refetch()
  }, [user.uid, refetch])
  const castlesList: Castle[] = data?.pages.flatMap(p => p.items) ?? []
  const approveCastle = useApproveCastle()
  const rejectCastle = useRejectCastle()
  const deleteCastle = useDeleteCastle(user.uid)
  const pending = castlesList.filter((c: Castle) => !c.is_active || c.bot_status?.state === 'pending')
  const active = castlesList.filter((c: Castle) => c.is_active && c.bot_status?.state !== 'pending')

  return createPortal(
    <div className="z-[100] fixed inset-0 flex justify-center items-center p-3 sm:p-4 overflow-y-auto" onClick={onClose}>
      <div className="fixed inset-0 bg-black/65 dark:bg-black/75" />
      <motion.div
        initial={{ opacity: 0, scale: 0.96, y: 12 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.96, y: 12 }}
        transition={{ duration: 0.15 }}
        className="z-10 relative flex flex-col bg-white dark:bg-[#0c1410] shadow-2xl my-auto border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-lg max-h-[88vh] overflow-hidden text-gray-900 dark:text-gray-100 admin-modal"
        onClick={e => e.stopPropagation()}
      >
        <div className="bg-primary-500 w-full h-1 shrink-0" />

        {/* Header */}
        <div className="flex justify-between items-center px-4 sm:px-5 py-3.5 sm:py-4 border-gray-200 dark:border-white/8 border-b shrink-0">
          <div className="flex items-center gap-3 min-w-0">
            <div className="flex justify-center items-center bg-primary-500/10 border border-primary-500/20 rounded-xl w-9 h-9 text-lg shrink-0">🏰</div>
            <div className="min-w-0">
              <h3 className="font-bold text-gray-900 dark:text-white text-sm truncate">
                {user.username ? t('admin.modals.castlesTitle', { name: user.username }) : t('admin.modals.castlesTitleGeneric')}
              </h3>
              <p className="font-mono text-[11px] text-gray-500 dark:text-gray-400 truncate select-all">{user.email}</p>
            </div>
          </div>
          <button onClick={onClose} className="flex justify-center items-center bg-gray-100 dark:bg-white/5 rounded-full w-8 h-8 text-gray-500 dark:text-gray-400 cursor-pointer shrink-0">
            <X size={15} />
          </button>
        </div>

        {/* Stats bar */}
        <div className="flex bg-gray-50 dark:bg-black/20 border-gray-200 dark:border-white/8 border-b shrink-0">
          {[
            { label: t('admin.modals.quotaLimit'), value: user.subscription?.max_castles_allowed ?? 1, color: 'text-primary-600 dark:text-primary-400' },
            { label: t('admin.modals.activeCastles'), value: active.length, color: 'text-emerald-600 dark:text-emerald-400' },
            { label: t('admin.modals.waitingCastles'), value: pending.length, color: pending.length > 0 ? 'text-amber-600 dark:text-yellow-400' : 'text-gray-400' },
          ].map((s, i) => (
            <div key={i} className="flex-1 py-2.5 sm:py-3 border-gray-200 dark:border-white/8 border-l first:border-l-0 text-center">
              <div className={`font-bold font-mono text-base sm:text-lg ${s.color}`}>{s.value}</div>
              <div className="mt-0.5 text-[10px] text-gray-500 dark:text-gray-400">{s.label}</div>
            </div>
          ))}
        </div>

        {/* Body */}
        <div className="flex-1 space-y-4 p-3.5 sm:p-5 overflow-y-auto">
          {isLoading ? (
            <div className="py-10 text-gray-500 dark:text-gray-400 text-sm text-center">{t('common.loading')}</div>
          ) : castlesList.length === 0 ? (
            <div className="py-10 text-gray-500 dark:text-gray-400 text-sm text-center">{t('admin.modals.noCastlesFound')}</div>
          ) : (
            <>
              {pending.length > 0 && (
                <div className="space-y-2">
                  <div className="flex items-center gap-2 font-bold text-amber-600 dark:text-yellow-400 text-xs">
                    <Clock size={13} /><span>{t('admin.modals.pendingApprovalCount', { count: pending.length })}</span>
                  </div>
                  {pending.map(c => (
                    <div key={c.id} className="flex justify-between items-center gap-2.5 bg-amber-50 dark:bg-yellow-500/5 p-3 border border-amber-200 dark:border-yellow-500/20 rounded-xl">
                      <div className="min-w-0">
                        <div className="font-semibold text-gray-900 dark:text-white text-sm truncate">{c.castle_info?.castle_name || c.castle_info?.lord_name || t('admin.modals.castleFallback')}</div>
                        <div className="font-mono text-[11px] text-gray-500 dark:text-gray-400 truncate">{c.email}</div>
                      </div>
                      <div className="flex items-center gap-1.5 shrink-0">
                        <button disabled={approveCastle.isPending}
                          onClick={() => approveCastle.mutate({userId:user.uid,castleId:c.id},{onSuccess:()=>toast.success(t('admin.modals.approveSuccess')),onError:()=>toast.error(t('common.error'))})}
                          className="flex items-center gap-1 bg-emerald-600 shadow-xs px-2.5 sm:px-3 py-1.5 rounded-lg font-bold text-white text-xs active:scale-95 cursor-pointer">
                          <CheckCircle size={12} />{t('admin.modals.acceptBtn')}
                        </button>
                        <button disabled={rejectCastle.isPending}
                          onClick={() => { if(!confirm(t('admin.modals.confirmReject', { email: c.email }))) return; rejectCastle.mutate({userId:user.uid,castleId:c.id},{onSuccess:()=>toast.success(t('admin.modals.rejectSuccess')),onError:()=>toast.error(t('common.error'))}) }}
                          className="flex justify-center items-center bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-transparent rounded-lg w-8 h-8 text-red-600 dark:text-red-400 active:scale-95 cursor-pointer">
                          <Trash2 size={13} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              {active.length > 0 && (
                <div className="space-y-2">
                  <div className="flex items-center gap-2 font-bold text-emerald-600 dark:text-emerald-400 text-xs">
                    <span className="inline-block bg-emerald-500 rounded-full w-1.5 h-1.5" />
                    <span>{t('admin.modals.activeCastlesCount', { count: active.length })}</span>
                  </div>
                  {active.map(c => {
                    const isCastleRunning =
                      c.bot_status?.state === 'running' ||
                      c.bot_status?.conn_state === 'connected' ||
                      c.bot_status?.conn_state === 'waiting'
                    return (
                    <div key={c.id} className="flex justify-between items-center gap-2.5 bg-gray-50 dark:bg-white/[0.02] p-3 border border-gray-200 dark:border-white/8 rounded-xl">
                      <div className="min-w-0">
                        <div className="font-medium text-gray-900 dark:text-white text-sm truncate">{c.castle_info?.castle_name || c.castle_info?.lord_name || t('admin.modals.castleFallback')}</div>
                        <div className="font-mono text-[11px] text-gray-500 dark:text-gray-400 truncate">{c.email}</div>
                      </div>
                      <div className="flex items-center gap-2 shrink-0">
                        <span className={`py-0.5 text-[10px] badge ${isCastleRunning ? 'badge-green font-bold' : 'badge-gray'}`}>
                          {isCastleRunning ? t('admin.table.runningBadge') : t('admin.modals.activeBadge')}
                        </span>
                        <button
                          onClick={() => { if(!confirm(t('admin.modals.confirmDeleteCastle', { email: c.email }))) return; deleteCastle.mutate({castleId:c.id,wasActive:true},{onSuccess:()=>toast.success(t('admin.modals.deleteCastleSuccess')),onError:()=>toast.error(t('common.error'))}) }}
                          className="flex justify-center items-center rounded-lg w-7 h-7 text-gray-400 cursor-pointer"
                        >
                          <Trash2 size={13} />
                        </button>
                      </div>
                    </div>
                  )})}
                </div>
              )}
            </>
          )}
        </div>

        {/* Footer */}
        <div className="px-4 sm:px-5 py-3 border-gray-200 dark:border-white/8 border-t shrink-0">
          <button onClick={onClose} className="py-2.5 border border-gray-200 dark:border-white/10 rounded-xl w-full font-semibold text-gray-700 dark:text-gray-300 text-sm cursor-pointer">{t('common.close')}</button>
        </div>
      </motion.div>
    </div>,
    document.body
  )
}

// Main Admin Page
export function AdminPage() {
  const { t } = useTranslation()
  const { firebaseUser, user, isAdmin, isSuperAdmin, loading: authLoading } = useAuth()
  const location = useLocation()
  const isLiveTab = location.pathname.startsWith('/admin/live-processes')
  const [search, setSearch] = useState('')
  const [editUser, setEditUser] = useState<User | null>(null)
  const [manageCastlesUser, setManageCastlesUser] = useState<User | null>(null)
  const [confirmDeleteUser, setConfirmDeleteUser] = useState<User | null>(null)
  const [deleting, setDeleting] = useState(false)
  const [menuUser, setMenuUser] = useState<User | null>(null)
  const [extendingUid, setExtendingUid] = useState<string | null>(null)
  const [statusFilter, setStatusFilter] = useState<AdminUserFilter>('all')
  const [approvingAll, setApprovingAll] = useState(false)
  const qc = useQueryClient()
  const { data: users = [], isLoading, isRefetching: isRefetchingUsers, refetch: refetchUsers } = useAllUsers()
  const banUser = useBanUser()
  const deleteUser = useDeleteUser()

  if (authLoading) {
    return (
      <div className="flex justify-center items-center bg-gray-50 dark:bg-[#060a08] min-h-screen text-emerald-500">
        <div className="flex flex-col items-center gap-3">
          <div className="border-2 border-emerald-500/30 border-t-emerald-500 rounded-full w-8 h-8 animate-spin" />
          <span className="font-mono text-xs">{t('admin.checkingAuth')}</span>
        </div>
      </div>
    )
  }

  const adminEmail = (firebaseUser?.email || user?.email || '').trim().toLowerCase()
  if ((!firebaseUser && !user) || !isAdmin) {
    return <Navigate to="/login" replace />
  }


  // فلترة قائمة المستخدمين لعرض العملاء والمشتركين فقط واستبعاد حساب المشرف الأعلى وحساب المشرف نفسه نهائياً
  const clientUsers = users.filter(
    u => !isSuperAdminUser(u) && u.role !== 'admin' && u.email?.toLowerCase().trim() !== adminEmail
  )

  // عدّادات فئات الانتهاء: كل مستخدم يقع في فئة واحدة فقط (لا تداخل)
  const counts = { all: 0, today: 0, tomorrow: 0, days3: 0, days7: 0, expired: 0, pending: 0, banned: 0 }

  const enrichedUsers = clientUsers.map(u => {
    const meta = getUserStatusMeta(u)
    counts.all += 1
    if (meta.statusKey === 'banned') counts.banned += 1
    else if (meta.statusKey === 'pending') counts.pending += 1
    else if (meta.expiryBucket) counts[meta.expiryBucket] += 1
    else if (meta.statusKey === 'expired') counts.expired += 1
    return { user: u, meta }
  })

  const pendingUsersCount = counts.pending

  const matchesFilter = (meta: UserMeta) => {
    switch (statusFilter) {
      case 'all': return true
      case 'pending': return meta.statusKey === 'pending'
      case 'banned': return meta.statusKey === 'banned'
      case 'expired': return meta.statusKey === 'expired' && !meta.expiryBucket
      default: return meta.expiryBucket === statusFilter
    }
  }

  // الترتيب الافتراضي: المعلّقون للموافقة ← الأقرب انتهاءً (اليوم ثم غداً ...) ← المنتهون الأحدث ← البقية
  const sortTier = (m: UserMeta) => {
    if (m.isPending) return 0
    if (m.statusKey === 'banned' || m.statusKey === 'suspended' || m.dayDiff === null) return 3
    return m.dayDiff >= 0 ? 1 : 2
  }

  const searchClean = search.trim().toLowerCase()
  const filteredEntries = enrichedUsers
    .filter(({ user: u, meta }) => {
      if (!matchesFilter(meta)) return false
      if (!searchClean) return true
      return (
        (u.email || '').toLowerCase().includes(searchClean) ||
        (u.username || '').toLowerCase().includes(searchClean) ||
        (u.phone || '').toLowerCase().includes(searchClean) ||
        (u.uid || '').toLowerCase().includes(searchClean)
      )
    })
    .sort((a, b) => {
      const ta = sortTier(a.meta)
      const tb = sortTier(b.meta)
      if (ta !== tb) return ta - tb
      const ea = a.meta.expDate?.getTime() ?? 0
      const eb = b.meta.expDate?.getTime() ?? 0
      if (ta === 1 && ea !== eb) return ea - eb
      if (ta === 2 && ea !== eb) return eb - ea
      if (a.meta.runningCastles !== b.meta.runningCastles) {
        return b.meta.runningCastles - a.meta.runningCastles
      }
      return b.meta.currentCastles - a.meta.currentCastles
    })

  const isRefreshing = isRefetchingUsers
  const handleRefreshAll = () => {
    void refetchUsers()
  }

  // تمديد سريع من الصف: يبدأ من تاريخ الانتهاء إن كان ساري المفعول، وإلا من الآن (نفس منطق نافذة التعديل)
  const handleQuickExtend = async (u: User, meta: UserMeta, days: number) => {
    if (extendingUid) return
    setExtendingUid(u.uid)
    try {
      const now = Date.now()
      const base = meta.expDate && meta.expDate.getTime() > now ? meta.expDate.getTime() : now
      const target = new Date(base + days * 86400000)
      const totalDays = Math.max(1, Math.ceil((target.getTime() - now) / 86400000))
      const castles = Math.max(1, meta.maxCastles)
      await updateAdminSubscription(u.uid, {
        plan_id: `${castles}_castles_${totalDays}d`,
        plan_name: `${castles} حساب (${totalDays} يوم)`,
        subscription_status: 'active',
        expires_at: target.toISOString(),
        max_castles_allowed: castles,
      })
      qc.invalidateQueries({ queryKey: ['admin_users'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['castles', u.uid] })
      qc.invalidateQueries({ queryKey: ['castles'] })
      toast.success(t('admin.expiry.extendSuccess', { name: u.username || u.email, count: days }))
    } catch {
      toast.error(t('admin.modals.saveError'))
    } finally {
      setExtendingUid(null)
    }
  }

  const renderQuickExtend = (u: User, meta: UserMeta, full = false) => {
    if (meta.isPending || meta.isBanned || meta.isSuspended || meta.isLifetime) return null
    const busy = extendingUid === u.uid
    const cls = `px-2.5 py-1.5 rounded-xl border font-bold text-xs active:scale-95 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed bg-emerald-50 dark:bg-emerald-500/10 border-emerald-200 dark:border-emerald-500/25 text-emerald-700 dark:text-emerald-400 ${full ? 'flex-1 py-2' : ''}`
    return (
      <>
        <button type="button" disabled={busy} onClick={e => { e.stopPropagation(); handleQuickExtend(u, meta, 7) }} className={cls}>
          {t('admin.expiry.extendWeek')}
        </button>
        <button type="button" disabled={busy} onClick={e => { e.stopPropagation(); handleQuickExtend(u, meta, 30) }} className={cls}>
          {t('admin.expiry.extendMonth')}
        </button>
      </>
    )
  }

  const handleQuickApprove = async (u: User) => {
    if (!confirm(t('admin.quickApproveConfirm', { name: u.username || u.email }))) {
      return
    }
    try {
      await approveAdminUser(u.uid, 3, 10)
      qc.invalidateQueries({ queryKey: ['admin_users'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['castles', u.uid] })
      qc.invalidateQueries({ queryKey: ['castles'] })
      toast.success(t('admin.quickApproveSuccess', { name: u.username || u.email }))
    } catch {
      toast.error(t('common.error'))
    }
  }

  const handleApproveAllPending = async () => {
    if (pendingUsersCount === 0) return
    if (!confirm(t('admin.approveAllConfirm', { count: pendingUsersCount }))) {
      return
    }
    setApprovingAll(true)
    try {
      const res = await approveAllPendingAdminUsers(3, 10)
      qc.invalidateQueries({ queryKey: ['admin_users'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['castles'] })
      toast.success(t('admin.approveAllSuccess', { count: res.approved_count ?? pendingUsersCount }))
    } catch (err: any) {
      toast.error(err?.message || t('common.error'))
    } finally {
      setApprovingAll(false)
    }
  }

  const handleBan = (u: User) => {
    if (isSuperAdminUser(u) || u.email?.toLowerCase().trim() === adminEmail) {
      toast.error(t('admin.cannotBanAdmin'))
      return
    }
    if (!confirm(u.is_banned ? t('admin.unbanConfirm') : t('admin.banConfirm'))) return
    banUser.mutate({uid:u.uid,ban:!u.is_banned},{onSuccess:()=>toast.success(t('common.success')),onError:()=>toast.error(t('common.error'))})
  }

  const handleDelete = (u: User) => {
    if (isSuperAdminUser(u) || u.email?.toLowerCase().trim() === adminEmail) {
      toast.error(t('admin.cannotDeleteAdmin'))
      return
    }
    setConfirmDeleteUser(u)
  }

  const doDelete = () => {
    if (!confirmDeleteUser) return
    setDeleting(true)
    deleteUser.mutate(confirmDeleteUser.uid, {
      onSuccess: () => {
        toast.success(t('admin.deleteUserSuccess'))
        setConfirmDeleteUser(null)
        setDeleting(false)
      },
      onError: () => {
        toast.error(t('admin.deleteUserError'))
        setDeleting(false)
      },
    })
  }

  return (
    <AdminLayout title={isLiveTab ? t('admin.live.title') : t('admin.title')}>
      {/* ── Users Management Tab View ── */}
      <div style={{ display: isLiveTab ? 'none' : 'block' }}>
        <div className="space-y-4 sm:space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center gap-3">
          <div>
            <div className="flex items-center gap-2.5">
              <h1 className="flex items-center gap-2 font-black text-gray-900 dark:text-white text-xl sm:text-2xl">
                <Shield size={22} className="text-emerald-600 dark:text-emerald-400" />
                <span>{t('admin.title')}</span>
              </h1>
              <span className="bg-emerald-500/10 px-2 py-0.5 border border-emerald-500/20 rounded-md font-mono font-semibold text-[11px] text-emerald-600 dark:text-emerald-400">
                {t('admin.usersCountBadge', { count: counts.all })}
              </span>
            </div>
            <p className="mt-0.5 text-slate-500 dark:text-slate-400 text-xs">
              {t('admin.subtitle')}
            </p>
          </div>

          <button
            type="button"
            onClick={handleRefreshAll}
            disabled={isRefreshing}
            title={t('admin.refreshData')}
            className="flex items-center gap-1.5 bg-white dark:bg-white/5 disabled:opacity-60 shadow-xs px-3 py-2 border border-slate-200/80 dark:border-white/10 rounded-xl font-semibold text-slate-700 dark:text-slate-200 text-xs active:scale-95 cursor-pointer shrink-0"
          >
            <RefreshCw size={14} className={isRefreshing ? 'animate-spin text-emerald-500' : 'text-slate-500 dark:text-slate-400'} />
            <span className="hidden sm:inline">{t('admin.refreshData')}</span>
          </button>
        </div>

        {/* Smart expiry bar: من ينتهي اليوم / غداً / قريباً — ضغطة واحدة تصفّي القائمة */}
        <div className="gap-2 sm:gap-3 grid grid-cols-3 sm:grid-cols-5">
          {[
            { id: 'today' as AdminUserFilter, label: t('admin.expiry.today'), count: counts.today, num: 'text-rose-600 dark:text-rose-400', on: 'border-rose-500/50 ring-1 ring-rose-500/25' },
            { id: 'tomorrow' as AdminUserFilter, label: t('admin.expiry.tomorrow'), count: counts.tomorrow, num: 'text-orange-600 dark:text-orange-400', on: 'border-orange-500/50 ring-1 ring-orange-500/25' },
            { id: 'days3' as AdminUserFilter, label: t('admin.expiry.d2to3'), count: counts.days3, num: 'text-amber-600 dark:text-amber-400', on: 'border-amber-500/50 ring-1 ring-amber-500/25' },
            { id: 'days7' as AdminUserFilter, label: t('admin.expiry.d4to7'), count: counts.days7, num: 'text-yellow-600 dark:text-yellow-400', on: 'border-yellow-500/50 ring-1 ring-yellow-500/25' },
            { id: 'expired' as AdminUserFilter, label: t('admin.expiry.expired'), count: counts.expired, num: 'text-slate-600 dark:text-slate-300', on: 'border-slate-500/50 ring-1 ring-slate-500/25' },
          ].map(s => {
            const isActive = statusFilter === s.id
            return (
              <button
                key={s.id}
                type="button"
                onClick={() => setStatusFilter(prev => (prev === s.id ? 'all' : s.id))}
                className={`flex flex-col items-start gap-1 p-3 sm:p-4 rounded-2xl border shadow-xs bg-white dark:bg-white/[0.03] text-start cursor-pointer active:scale-[0.99] ${
                  isActive ? s.on : 'border-slate-200/80 dark:border-white/8'
                } ${s.count === 0 && !isActive ? 'opacity-60' : ''}`}
              >
                <span className="font-semibold text-[11px] text-slate-600 dark:text-slate-300 sm:text-xs leading-snug">{s.label}</span>
                <span className={`font-mono font-black text-2xl sm:text-3xl ${s.count > 0 ? s.num : 'text-slate-400 dark:text-slate-500'}`}>{s.count}</span>
              </button>
            )
          })}
        </div>

        {/* Users Section */}
        <div className="admin-table-container bg-white dark:bg-[#0c1410] shadow-xs border border-slate-200/80 dark:border-white/8 rounded-2xl overflow-hidden admin-card">
          {/* Header & Search */}
          <div className="space-y-3 bg-slate-50/50 dark:bg-white/[0.01] px-4 sm:px-6 py-3.5 sm:py-4 border-slate-200/80 dark:border-white/8 border-b">
            <div className="flex sm:flex-row flex-col justify-between sm:items-center gap-3">
              <h2 className="flex items-center gap-2 font-bold text-slate-900 dark:text-white text-base">
                <Users size={18} className="text-emerald-600 dark:text-emerald-400" />
                <span>{t('admin.users')}</span>
                <span className="bg-slate-200/70 dark:bg-white/10 px-2 py-0.5 border border-slate-300/60 dark:border-white/10 rounded-full font-bold text-slate-700 dark:text-slate-300 text-xs">
                  {filteredEntries.length}
                </span>
              </h2>
              <div className="flex sm:flex-row flex-col sm:items-center gap-2 w-full sm:w-auto">
                <div className="relative w-full sm:w-72">
                  <Search size={15} className="top-1/2 z-10 absolute text-slate-400 -translate-y-1/2 pointer-events-none start-3" />
                  <input
                    id="admin-search"
                    name="admin_users_filter"
                    type="text"
                    dir="auto"
                    autoComplete="off"
                    autoCorrect="off"
                    autoCapitalize="none"
                    spellCheck={false}
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                    placeholder={t('admin.searchUsers')}
                    className="shadow-xs py-2 rounded-xl outline-none w-full min-h-[42px] sm:min-h-[38px] sm:text-sm text-base admin-search-input"
                    style={{ paddingInlineStart: '2.35rem', paddingInlineEnd: '2.35rem' }}
                  />
                  {search && (
                    <button
                      type="button"
                      onClick={() => setSearch('')}
                      className="top-1/2 z-10 absolute flex justify-center items-center w-7 h-7 text-slate-400 -translate-y-1/2 cursor-pointer end-2"
                      aria-label={t('accounts.clearSearch')}
                      title={t('accounts.clearSearch')}
                    >
                      <X size={14} />
                    </button>
                  )}
                </div>
                <div className="flex flex-wrap sm:flex-nowrap items-center gap-2">
                {pendingUsersCount > 0 && (
                  <button
                    type="button"
                    id="admin-approve-all-pending"
                    onClick={handleApproveAllPending}
                    disabled={approvingAll}
                    title={t('admin.approveAllBtn', { count: pendingUsersCount })}
                    className="flex items-center gap-1.5 bg-emerald-600 disabled:opacity-50 shadow-xs px-3 py-2 border border-emerald-600/80 rounded-xl font-bold text-white text-xs sm:text-sm cursor-pointer disabled:cursor-not-allowed shrink-0"
                  >
                    <CheckCheck size={16} className={approvingAll ? 'animate-spin' : ''} />
                    <span>{approvingAll ? t('admin.approvingAll') : t('admin.approveAllBtn', { count: pendingUsersCount })}</span>
                  </button>
                )}
                </div>
              </div>
            </div>

            {/* Quick filters: الكل + بانتظار الموافقة + محظور (فئات الانتهاء في الشريط الذكي أعلاه) */}
            <div className="flex items-center gap-1.5 pb-0.5 overflow-x-auto select-none">
              {([
                { id: 'all', label: t('admin.filters.all'), count: counts.all },
                ...(counts.pending > 0 || statusFilter === 'pending'
                  ? [{ id: 'pending', label: t('admin.filters.pending'), count: counts.pending }]
                  : []),
                ...(counts.banned > 0 || statusFilter === 'banned'
                  ? [{ id: 'banned', label: t('admin.filters.banned'), count: counts.banned }]
                  : []),
              ] as { id: AdminUserFilter; label: string; count: number }[]).map(f => {
                const isSelected = statusFilter === f.id
                return (
                  <button
                    key={f.id}
                    type="button"
                    onClick={() => setStatusFilter(f.id)}
                    className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-xs font-semibold border shrink-0 cursor-pointer ${
                      isSelected
                        ? 'bg-emerald-600 text-white border-emerald-600 shadow-xs'
                        : 'bg-white dark:bg-white/5 text-slate-600 dark:text-slate-300 border-slate-200/80 dark:border-white/10'
                    }`}
                  >
                    <span>{f.label}</span>
                    <span className={`font-mono text-[10px] px-1.5 py-0.2 rounded-full ${
                      isSelected
                        ? 'bg-white/20 text-white'
                        : 'bg-slate-100 dark:bg-white/10 text-slate-600 dark:text-slate-400'
                    }`}>
                      {f.count}
                    </span>
                  </button>
                )
              })}
            </div>
          </div>

          {isLoading ? (
            <div className="py-16 text-slate-400 text-center">{t('common.loading')}</div>
          ) : (
            <>
              {/* ── Desktop Table (md: and up) ── */}
              <div className="hidden md:block overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="admin-table-head bg-slate-50/75 dark:bg-white/[0.01] border-slate-200/80 dark:border-white/8 border-b font-semibold text-slate-500 dark:text-slate-400 text-xs uppercase">
                      <th className="px-5 py-3 text-start">{t('admin.table.user')}</th>
                      <th className="px-3 py-3 text-center">{t('admin.table.castles')}</th>
                      <th className="px-3 py-3 text-start">{t('admin.table.subscriptionEnd')}</th>
                      <th className="px-3 py-3 text-start">{t('admin.table.status')}</th>
                      <th className="px-5 py-3 text-end">{t('admin.table.actions')}</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 dark:divide-white/5">
                    {filteredEntries.map(({ user: u, meta }) => (
                        <tr
                          key={u.uid}
                          onClick={() => setEditUser(u)}
                          className="admin-table-row cursor-pointer"
                        >
                          <td className="px-5 py-3.5">
                            <div className="flex items-center gap-3">
                              <div className="flex flex-shrink-0 justify-center items-center bg-emerald-100/80 dark:bg-emerald-900/60 border border-emerald-200 dark:border-emerald-700/30 rounded-xl w-9 h-9 font-black text-emerald-800 dark:text-emerald-400 text-xs">
                                {(u.username||u.email)?.[0]?.toUpperCase()}
                              </div>
                              <div className="min-w-0">
                                <div className="font-bold text-slate-900 dark:text-white truncate">
                                  {u.username || '—'}
                                </div>
                                <div className="font-mono text-slate-500 dark:text-slate-400 text-xs truncate">{u.email}</div>
                              </div>
                            </div>
                          </td>
                          <td className="px-3 py-3.5 text-center">
                            <div className="flex flex-col items-center gap-1">
                              <div className="font-mono text-sm">
                                <span className={`font-black ${
                                  meta.isBanned
                                    ? 'text-red-500'
                                    : meta.statusKey === 'active'
                                      ? 'text-emerald-600 dark:text-emerald-400'
                                      : 'text-amber-600 dark:text-amber-400'
                                }`}>
                                  {meta.currentCastles}
                                </span>
                                <span className="font-normal text-slate-400"> / {meta.maxCastles}</span>
                              </div>
                              {meta.runningCastles > 0 && (
                                <span className="flex items-center gap-1 bg-emerald-500/10 px-1.5 py-0.5 border border-emerald-500/25 rounded font-bold text-[10px] text-emerald-600 dark:text-emerald-400">
                                  <span className="bg-emerald-500 rounded-full w-1.5 h-1.5" />
                                  <span>{t('admin.table.runningCount', { count: meta.runningCastles })}</span>
                                </span>
                              )}
                              {meta.isBanned && (
                                <span className="font-semibold text-[10px] text-red-500 leading-none">{t('admin.table.bannedPill')}</span>
                              )}
                              {!meta.isBanned && meta.pendingCastles > 0 && (
                                <button onClick={e => { e.stopPropagation(); setManageCastlesUser(u) }} className="flex items-center gap-1 text-[10px] cursor-pointer badge badge-yellow">
                                  <Clock size={10} /><span>{t('admin.table.waitingCount', { count: meta.pendingCastles })}</span>
                                </button>
                              )}
                            </div>
                          </td>
                          <td className="px-3 py-3.5 text-xs">
                            {meta.expDate ? (
                              <div>
                                <div className={`font-semibold font-mono ${meta.isLifetime ? 'text-emerald-700 dark:text-emerald-400' : meta.isExpired ? 'text-rose-600 dark:text-red-400' : 'text-slate-900 dark:text-gray-200'}`} dir="ltr">
                                  {meta.isLifetime ? t('admin.table.lifetime') : formatDate(meta.expDate)}
                                </div>
                                <div className="mt-0.5 text-[11px]">
                                  <ExpiryLabel meta={meta} t={t} />
                                </div>
                              </div>
                            ) : <span className="text-slate-400">—</span>}
                          </td>
                          <td className="px-3 py-3.5">
                            <UserStatusBadge meta={meta} t={t} />
                          </td>
                          <td className="px-5 py-3.5">
                            <div className="flex justify-end items-center gap-1.5">
                              {meta.isPending && (
                                <button
                                  onClick={e => { e.stopPropagation(); handleQuickApprove(u) }}
                                  className="flex items-center gap-1 bg-emerald-600 shadow-xs px-2.5 py-1.5 rounded-xl font-bold text-white text-xs cursor-pointer"
                                  title={t('admin.quickApproveBtn')}
                                >
                                  <UserCheck size={14} />
                                  <span>{t('admin.quickApproveBtn')}</span>
                                </button>
                              )}
                              {renderQuickExtend(u, meta)}
                              <button onClick={e=>{e.stopPropagation();setMenuUser(u)}} className="relative p-2 rounded-xl text-slate-600 dark:text-gray-300 cursor-pointer" title={t('admin.expiry.more')} aria-label={t('admin.expiry.more')}>
                                <MoreHorizontal size={16}/>
                                {!meta.isBanned && meta.pendingCastles > 0 && (
                                  <span className="top-1 absolute bg-amber-500 rounded-full w-2 h-2 end-1" />
                                )}
                              </button>
                            </div>
                          </td>
                        </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* ── Mobile User Cards (md:hidden) ── */}
              <div className="md:hidden block space-y-3 bg-slate-50/50 dark:bg-black/10 p-3">
                {filteredEntries.map(({ user: u, meta }) => (
                    <div
                      key={u.uid}
                      onClick={() => setEditUser(u)}
                      className="space-y-3 bg-white dark:bg-white/[0.025] shadow-xs p-4 border border-slate-200/90 dark:border-white/8 rounded-2xl active:scale-[0.99] cursor-pointer admin-user-card"
                    >
                      {/* Top: User info + badges */}
                      <div className="flex justify-between items-start gap-2">
                        <div className="flex items-center gap-2.5 min-w-0">
                          <div className="flex justify-center items-center bg-emerald-100/90 dark:bg-emerald-950/70 border border-emerald-200 dark:border-emerald-500/30 rounded-xl w-10 h-10 font-black text-emerald-800 dark:text-emerald-400 text-xs shrink-0">
                            {(u.username||u.email)?.[0]?.toUpperCase()}
                          </div>
                          <div className="min-w-0">
                            <div className="font-bold text-slate-900 dark:text-white text-sm truncate">{u.username || '—'}</div>
                            <div className="font-mono text-slate-500 dark:text-slate-400 text-xs truncate select-all">{u.email}</div>
                          </div>
                        </div>

                        <div className="flex items-center gap-1.5 shrink-0">
                          <UserStatusBadge meta={meta} compact t={t} />
                        </div>
                      </div>

                      {/* Metrics Pill Grid */}
                      <div className="gap-2.5 grid grid-cols-2 bg-slate-50 dark:bg-black/30 p-2.5 border border-slate-100 dark:border-white/5 rounded-xl text-xs">
                        <div className="flex items-center gap-2">
                          <div className="flex justify-center items-center bg-primary-50 dark:bg-primary-500/10 border border-primary-100 dark:border-primary-500/20 rounded-lg w-7 h-7 shrink-0">
                            <Layers size={13} className="text-primary-600 dark:text-primary-400" />
                          </div>
                          <div className="min-w-0">
                            <div className="font-semibold text-[10px] text-slate-500 dark:text-slate-400">{t('admin.mobile.castlesRatio')}</div>
                            <div className="flex flex-wrap items-center gap-1 font-mono text-xs">
                              <span className={`font-black text-sm ${
                                meta.isBanned
                                  ? 'text-red-500'
                                  : meta.statusKey === 'active'
                                    ? 'text-emerald-600 dark:text-emerald-400'
                                    : 'text-amber-600 dark:text-amber-400'
                              }`}>
                                {meta.currentCastles}
                              </span>
                              <span className="font-medium text-slate-400">
                                / {meta.maxCastles}
                              </span>
                              {meta.runningCastles > 0 && (
                                <span className="bg-emerald-500/15 px-1.5 py-0.2 border border-emerald-500/30 rounded font-sans font-bold text-[9px] text-emerald-600 dark:text-emerald-400">
                                  {t('admin.table.runningCount', { count: meta.runningCastles })}
                                </span>
                              )}
                              {!meta.isBanned && meta.pendingCastles > 0 && (
                                <span className="bg-amber-100/90 dark:bg-amber-900/40 px-1 py-0.2 border border-amber-200 dark:border-amber-700/40 rounded font-bold text-[9px] text-amber-700 dark:text-amber-300">
                                  +{meta.pendingCastles}
                                </span>
                              )}
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center gap-2">
                          <div className="flex justify-center items-center bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-100 dark:border-emerald-500/20 rounded-lg w-7 h-7 shrink-0">
                            <Calendar size={13} className="text-emerald-600 dark:text-emerald-400" />
                          </div>
                          <div className="min-w-0">
                            <div className="font-semibold text-[10px] text-slate-500 dark:text-slate-400">{t('admin.mobile.subscription')}</div>
                            <div className="font-mono font-bold text-xs" dir="ltr">
                              {meta.expDate ? (
                                <span className={meta.isExpired ? 'text-rose-600 dark:text-rose-400 font-bold' : 'text-emerald-700 dark:text-emerald-300 font-bold'}>
                                  {meta.isLifetime ? t('admin.table.lifetime') : formatDate(meta.expDate)}
                                  <ExpiryLabel meta={meta} t={t} className="ms-1 font-sans text-[10px]" wrap />
                                </span>
                              ) : <span className="text-slate-400">—</span>}
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Quick Approve Button for Pending Users (Mobile) */}
                      {meta.isPending && (
                        <button
                          type="button"
                          onClick={(e) => { e.stopPropagation(); handleQuickApprove(u); }}
                          className="flex justify-center items-center gap-1.5 bg-emerald-600 shadow-xs px-3 py-2.5 rounded-xl w-full font-bold text-white text-xs cursor-pointer"
                        >
                          <UserCheck size={14} />
                          <span>{t('admin.quickApproveBtn')}</span>
                        </button>
                      )}

                      {/* Action buttons (Mobile single row): تمديد سريع + المزيد */}
                      <div className="flex items-center gap-1.5 pt-1" onClick={e => e.stopPropagation()}>
                        {renderQuickExtend(u, meta, true)}
                        <button
                          onClick={() => setMenuUser(u)}
                          className="relative flex flex-1 justify-center items-center gap-1.5 bg-slate-100 dark:bg-white/5 shadow-xs px-3 py-2 border border-slate-200/80 dark:border-white/10 rounded-xl font-bold text-slate-800 dark:text-slate-200 text-xs active:scale-95 cursor-pointer"
                        >
                          <MoreHorizontal size={15} />
                          <span>{t('admin.expiry.more')}</span>
                          {!meta.isBanned && meta.pendingCastles > 0 && (
                            <span className="bg-amber-500 px-1.5 rounded-full font-black text-[9px] text-white">{meta.pendingCastles}</span>
                          )}
                        </button>
                      </div>
                    </div>
                ))}
              </div>

              {filteredEntries.length === 0 && (
                <div className="flex flex-col items-center gap-2.5 py-16 text-slate-400 text-center">
                  <span>{t('admin.table.noSearchResults')}</span>
                  {(searchClean || statusFilter !== 'all') && (
                    <button
                      type="button"
                      onClick={() => {
                        setSearch('')
                        setStatusFilter('all')
                      }}
                      className="bg-emerald-500/10 px-3 py-1.5 border border-emerald-500/25 rounded-lg font-semibold text-emerald-600 dark:text-emerald-400 text-xs cursor-pointer"
                    >
                      {searchClean ? t('accounts.clearSearch') : t('admin.filters.all')}
                    </button>
                  )}
                </div>
              )}
            </>
          )}
        </div>
      </div>
      </div>

      {/* ── Live Processes Tab View (تركيب المكون فقط عند فتح التبويب فعلياً) ── */}
      {isSuperAdmin && isLiveTab && (
        <AdminLiveProcessesView isActive={true} />
      )}

      <AnimatePresence>
        {editUser && <EditUserModal user={users.find(u => u.uid === editUser.uid) ?? editUser} onClose={()=>setEditUser(null)} />}
        {menuUser && (() => {
          const liveMenuUser = users.find(u => u.uid === menuUser.uid) ?? menuUser
          return (
            <UserActionsMenu
              user={liveMenuUser}
              isBanned={Boolean(liveMenuUser.is_banned)}
              pendingCastles={Number(liveMenuUser.subscription?.pending_castles_count ?? 0)}
              onClose={() => setMenuUser(null)}
              onEdit={() => { const u = liveMenuUser; setMenuUser(null); setEditUser(u) }}
              onCastles={() => { const u = liveMenuUser; setMenuUser(null); setManageCastlesUser(u) }}
              onBan={() => { const u = liveMenuUser; setMenuUser(null); handleBan(u) }}
              onDelete={() => { const u = liveMenuUser; setMenuUser(null); handleDelete(u) }}
            />
          )
        })()}
        {manageCastlesUser && (
          <UserCastlesModal
            user={users.find(u => u.uid === manageCastlesUser.uid) ?? manageCastlesUser}
            onClose={()=>setManageCastlesUser(null)}
          />
        )}
        {confirmDeleteUser && (
          <ConfirmDialog
            title={t('admin.modals.confirmDeleteTitle')}
            message={t('admin.modals.confirmDeleteMsg')}
            email={confirmDeleteUser.email}
            loading={deleting}
            onConfirm={doDelete}
            onCancel={() => setConfirmDeleteUser(null)}
          />
        )}
      </AnimatePresence>
    </AdminLayout>
  )
}



// ─── Expiry label (نص قرب الانتهاء الملوّن حسب الأولوية) ──────────────────
function getExpiryInfo(meta: UserMeta, t: (k: string, opts?: any) => string): { text: string; cls: string } | null {
  if (meta.isLifetime) {
    return { text: t('admin.table.unlimited'), cls: 'text-emerald-600 dark:text-emerald-400' }
  }
  const d = meta.dayDiff
  if (d === null) return null
  if (d < 0) return { text: t('admin.expiry.expiredAgo', { count: -d }), cls: 'text-slate-500 dark:text-slate-400' }
  if (meta.isExpired) return { text: t('admin.expiry.expiredToday'), cls: 'text-rose-600 dark:text-rose-400 font-bold' }
  if (d === 0) return { text: t('admin.expiry.inToday'), cls: 'text-rose-600 dark:text-rose-400 font-bold' }
  if (d === 1) return { text: t('admin.expiry.inTomorrow'), cls: 'text-orange-600 dark:text-orange-400 font-bold' }
  if (d <= 3) return { text: `${d} ${t('common.days')}`, cls: 'text-amber-600 dark:text-amber-400 font-semibold' }
  if (d <= 7) return { text: `${d} ${t('common.days')}`, cls: 'text-yellow-600 dark:text-yellow-400 font-semibold' }
  if (d > 60) return { text: `~${Math.round(d / 30)} ${t('admin.table.months')}`, cls: 'text-slate-500 dark:text-slate-400' }
  return { text: `${d} ${t('common.days')}`, cls: 'text-slate-500 dark:text-slate-400' }
}

function ExpiryLabel({
  meta,
  t,
  className = '',
  wrap = false,
}: {
  meta: UserMeta
  t: (k: string, opts?: any) => string
  className?: string
  wrap?: boolean
}) {
  const info = getExpiryInfo(meta, t)
  if (!info) return null
  return <span className={`${className} ${info.cls}`}>{wrap ? `(${info.text})` : info.text}</span>
}

// ─── Row actions menu: تعديل الاشتراك / القلاع / حظر / حذف ──────────────────
function UserActionsMenu({
  user,
  isBanned,
  pendingCastles,
  onClose,
  onEdit,
  onCastles,
  onBan,
  onDelete,
}: {
  user: User
  isBanned: boolean
  pendingCastles: number
  onClose: () => void
  onEdit: () => void
  onCastles: () => void
  onBan: () => void
  onDelete: () => void
}) {
  const { t } = useTranslation()
  const itemCls =
    'flex items-center gap-2.5 px-3 py-2.5 rounded-xl w-full font-semibold text-sm text-start cursor-pointer active:scale-[0.99]'

  return createPortal(
    <div className="z-[100] fixed inset-0 flex justify-center items-end sm:items-center p-3 sm:p-4" onClick={onClose}>
      <div className="fixed inset-0 bg-black/65 dark:bg-black/75" />
      <div
        className="z-10 relative bg-white dark:bg-[#0c1410] shadow-2xl p-2 border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-xs text-gray-900 dark:text-gray-100"
        onClick={e => e.stopPropagation()}
      >
        <div className="px-3 py-2 border-gray-200 dark:border-white/8 border-b">
          <div className="font-bold text-sm truncate">{user.username || '—'}</div>
          <div className="font-mono text-slate-500 dark:text-slate-400 text-xs truncate">{user.email}</div>
        </div>
        <div className="space-y-0.5 pt-1.5">
          <button type="button" onClick={onEdit} className={`${itemCls} text-slate-800 dark:text-slate-200`}>
            <Edit size={15} />
            <span>{t('admin.editSubscription')}</span>
          </button>
          <button type="button" onClick={onCastles} className={`${itemCls} text-primary-600 dark:text-primary-400`}>
            <Layers size={15} />
            <span className="flex-1">{t('admin.castles')}</span>
            {!isBanned && pendingCastles > 0 && (
              <span className="bg-amber-500 px-1.5 rounded-full font-black text-[10px] text-white">{pendingCastles}</span>
            )}
          </button>
          <button
            type="button"
            onClick={onBan}
            className={`${itemCls} ${isBanned ? 'text-emerald-700 dark:text-emerald-400' : 'text-amber-700 dark:text-yellow-400'}`}
          >
            {isBanned ? <CheckCircle size={15} /> : <Ban size={15} />}
            <span>{isBanned ? t('admin.unbanUser') : t('admin.banUser')}</span>
          </button>
          <button type="button" onClick={onDelete} className={`${itemCls} text-rose-600 dark:text-rose-400`}>
            <Trash2 size={15} />
            <span>{t('admin.deleteUser')}</span>
          </button>
        </div>
      </div>
    </div>,
    document.body
  )
}

import React, { useState, useEffect } from 'react'
import { createPortal } from 'react-dom'
import { useTranslation } from 'react-i18next'
import { User, Lock, Eye, EyeOff, Check, Sparkles, Clock, Plus, Minus, Trash2, Dices, X, Search } from 'lucide-react'
import { updatePassword, EmailAuthProvider, reauthenticateWithCredential, updateProfile } from 'firebase/auth'
import { useQueryClient } from '@tanstack/react-query'
import { Layout } from '../components/layout/Layout'
import { useAuth } from '../hooks/useAuth'
import { useCastles } from '../hooks/useCastles'
import { updateCastlesLoopIntervals } from '../lib/botApi'
import type { Castle } from '../types'
import toast from 'react-hot-toast'
import clsx from 'clsx'

export function SettingsPage() {
  const { t } = useTranslation()
  const { user, firebaseUser, updateUserProfile, isAdmin } = useAuth()

  const [username, setUsername] = useState(user?.username ?? '')
  const [savingProfile, setSavingProfile] = useState(false)
  const [savedSuccess, setSavedSuccess] = useState(false)

  const [currentPw, setCurrentPw]   = useState('')
  const [newPw, setNewPw]           = useState('')
  const [confirmPw, setConfirmPw]   = useState('')
  const [showCurrent, setShowCurrent] = useState(false)
  const [showNew, setShowNew]         = useState(false)
  const [savingPw, setSavingPw]       = useState(false)

  // مزامنة الاسم تلقائياً عند تحديث كائن المستخدم
  useEffect(() => {
    if (user?.username) {
      setUsername(user.username)
    }
  }, [user?.username])

  const handleSaveProfile = async () => {
    if (!user) return
    const trimmed = username.trim()
    if (!trimmed) {
      toast.error(t('settings.usernameRequired'))
      return
    }

    setSavingProfile(true)

    // 1. تحديث محلي وفوري في الذاكرة ليظهر في السايدبار والواجهة فوراً بـ 0 تأخير
    updateUserProfile({ username: trimmed })
    setSavedSuccess(true)

    try {
      // 2. تحديث الاسم التعريفي في Firebase Auth
      if (firebaseUser) {
        try {
          await updateProfile(firebaseUser, { displayName: trimmed })
        } catch {
          // non-critical
        }
      }

      toast.success(t('settings.profileSaved', { name: trimmed }), {
        icon: '✨',
        duration: 2500,
      })
    } catch {
      toast.error(t('common.error'))
      // إعادة الاسم السابق في حال فشل الاتصال
      if (user?.username) {
        updateUserProfile({ username: user.username })
      }
    } finally {
      setSavingProfile(false)
      setTimeout(() => setSavedSuccess(false), 2500)
    }
  }

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault()
    if (newPw !== confirmPw) { toast.error(t('settings.passwordsNotMatching')); return }
    if (newPw.length < 6)    { toast.error(t('settings.passwordMinLength')); return }
    if (!firebaseUser?.email) return
    setSavingPw(true)
    try {
      const cred = EmailAuthProvider.credential(firebaseUser.email, currentPw)
      await reauthenticateWithCredential(firebaseUser, cred)
      await updatePassword(firebaseUser, newPw)
      toast.success(t('common.success'))
      setCurrentPw(''); setNewPw(''); setConfirmPw('')
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : ''
      toast.error(msg.includes('wrong-password') ? t('settings.wrongCurrentPassword') : t('common.error'))
    } finally {
      setSavingPw(false)
    }
  }

  return (
    <Layout title={t('settings.title')}>
      <div className="space-y-4 sm:space-y-6 mx-auto max-w-2xl">
        {/* Header */}
        <div className="p-3.5 sm:p-4 royal-header-card">
          <h1 className="font-bold text-white text-xl sm:text-2xl settings-page-title">{t('settings.title')}</h1>
          <p className="mt-1 text-gray-500 text-xs sm:text-sm settings-page-desc">{t('settings.profileDesc')}</p>
        </div>

        {/* Profile section */}
        <div className="space-y-4 sm:space-y-6 p-4 sm:p-6 settings-profile-card glass-card">
          {/* Live Profile Header Banner */}
          <div className="flex flex-wrap justify-between items-center gap-3 sm:gap-4 bg-primary-950/30 p-3.5 sm:p-4 border border-primary-500/25 rounded-2xl settings-profile-banner">
            <div className="flex items-center gap-3 sm:gap-3.5 min-w-0">
              {/* Avatar Circle with Ring */}
              <div className="relative shrink-0">
                <div className="flex justify-center items-center bg-primary-700 border border-primary-400/35 rounded-2xl w-11 sm:w-13 h-11 sm:h-13 font-black text-white text-xl sm:text-2xl settings-avatar">
                  {(user?.username || username || user?.email || '?')[0].toUpperCase()}
                </div>
              </div>

              {/* Dynamic Live Name Display */}
              <div className="space-y-0.5 min-w-0">
                <div className="flex items-center gap-2">
                  <h3 className="font-bold text-white text-base sm:text-xl truncate settings-username-display">
                    {user?.username || username || t('settings.newUser')}
                  </h3>
                </div>
                <p className="font-mono text-gray-400 text-xs truncate select-all settings-email-display">{user?.email}</p>
              </div>
            </div>

            {savedSuccess && (
              <div className="flex items-center gap-1.5 bg-primary-500/20 px-3 py-1.5 border border-primary-500/35 rounded-xl font-bold text-primary-300 text-xs settings-success-badge">
                <Check size={14} />
                <span>{t('settings.saved')}</span>
              </div>
            )}
          </div>

          <div className="space-y-4">
            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.email')}</label>
              <input
                id="settings-email"
                type="email"
                value={user?.email ?? ''}
                readOnly
                className="opacity-60 cursor-not-allowed settings-readonly-input input-field"
                dir="ltr"
              />
            </div>

            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.username')}</label>
              <div className="relative flex items-center">
                <input
                  id="settings-username"
                  type="text"
                  value={username}
                  onChange={e => setUsername(e.target.value)}
                  onKeyDown={e => { if (e.key === 'Enter') { e.preventDefault(); handleSaveProfile(); } }}
                  className="pe-10 input-field"
                  placeholder={t('settings.username')}
                />
                <div className="absolute text-gray-500 pointer-events-none end-3">
                  <User size={16} />
                </div>
              </div>
            </div>

            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.castleCount')}</label>
              <div className="flex items-center gap-2 opacity-60 cursor-not-allowed settings-stat-input input-field">
                <span className="text-primary-400">🏰</span>
                <span className="flex items-center gap-1.5 font-mono font-bold" dir="ltr">
                  <span>{user?.subscription?.current_castles_count ?? 0}</span>
                  <span className="font-sans font-normal text-gray-400">{t('common.of', 'من')}</span>
                  <span>{isAdmin || user?.role === 'admin' ? '∞' : (user?.subscription?.max_castles_allowed ?? 0)}</span>
                </span>
              </div>
            </div>

            <button
              id="save-profile-btn"
              onClick={handleSaveProfile}
              disabled={savingProfile}
              className={clsx(
                'flex items-center gap-2 cursor-pointer btn-primary',
                savedSuccess && 'bg-primary-600 border-primary-400'
              )}
            >
              {savingProfile ? (
                <>
                  <span className="border-2 border-white/30 border-t-white rounded-full w-4 h-4 animate-spin" />
                  <span>{t('settings.savingProfile')}</span>
                </>
              ) : savedSuccess ? (
                <>
                  <Check size={16} className="text-white" />
                  <span>{t('settings.profileUpdated')}</span>
                </>
              ) : (
                <>
                  <Sparkles size={16} />
                  <span>{t('settings.saveProfile')}</span>
                </>
              )}
            </button>
          </div>
        </div>

        {/* Bot Cycle Intervals */}
        <BotCycleIntervalsSection userId={user?.uid} />

        {/* Change password */}
        <div className="space-y-4 sm:space-y-5 p-4 sm:p-6 settings-password-card glass-card">
          <div className="flex items-center gap-2">
            <div className="flex justify-center items-center bg-primary-700 rounded-lg w-7 h-7 settings-lock-icon">
              <Lock size={15} className="text-white" />
            </div>
            <h2 className="font-semibold text-white settings-section-title">{t('settings.changePassword')}</h2>
          </div>

          <form onSubmit={handleChangePassword} className="space-y-4">
            {/* Current password */}
            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.currentPassword')}</label>
              <div className="relative">
                <input
                  id="current-password"
                  type={showCurrent ? 'text' : 'password'}
                  required
                  value={currentPw}
                  onChange={e => setCurrentPw(e.target.value)}
                  className="pe-10 input-field"
                  placeholder="••••••••"
                />
                <button type="button" onClick={() => setShowCurrent(v => !v)}
                  className="absolute inset-y-0 flex items-center text-gray-500 settings-eye-btn end-3">
                  {showCurrent ? <EyeOff size={15} /> : <Eye size={15} />}
                </button>
              </div>
            </div>

            {/* New password */}
            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.newPassword')}</label>
              <div className="relative">
                <input
                  id="new-password"
                  type={showNew ? 'text' : 'password'}
                  required
                  minLength={6}
                  value={newPw}
                  onChange={e => setNewPw(e.target.value)}
                  className="pe-10 input-field"
                  placeholder="••••••••"
                />
                <button type="button" onClick={() => setShowNew(v => !v)}
                  className="absolute inset-y-0 flex items-center text-gray-500 settings-eye-btn end-3">
                  {showNew ? <EyeOff size={15} /> : <Eye size={15} />}
                </button>
              </div>
              <p className="mt-1 text-gray-600 text-xs settings-hint-text">{t('settings.minChars')}</p>
            </div>

            {/* Confirm password */}
            <div>
              <label className="block mb-1.5 text-gray-400 text-sm settings-label">{t('settings.confirmPassword')}</label>
              <input
                id="confirm-password"
                type="password"
                required
                minLength={6}
                value={confirmPw}
                onChange={e => setConfirmPw(e.target.value)}
                className="input-field"
                placeholder="••••••••"
              />
            </div>

            <button
              id="update-password-btn"
              type="submit"
              disabled={savingPw}
              className="btn-primary"
            >
              {savingPw ? t('common.loading') : t('settings.updatePassword')}
            </button>
          </form>
        </div>
      </div>
    </Layout>
  )
}

const MIN_INTERVAL_MINS = 30
const MAX_INTERVAL_MINS = 180
const DEFAULT_INTERVAL_MINS = 40
const JITTER_MINUTES = 10

function clampInterval(val: number): number {
  if (Number.isNaN(val)) return DEFAULT_INTERVAL_MINS
  return Math.max(MIN_INTERVAL_MINS, Math.min(MAX_INTERVAL_MINS, Math.round(val)))
}

interface IntervalGroup {
  id: string
  minutes: number
  draftMinutes: string
  castleIds: string[]
}

interface CastleSelectorModalProps {
  isOpen: boolean
  onClose: () => void
  durationMinutes: number
  allCastles: Castle[]
  currentGroupId: string
  allGroups: IntervalGroup[]
  onConfirm: (selectedIds: string[]) => void
}

function CastleSelectorModal({
  isOpen,
  onClose,
  durationMinutes,
  allCastles,
  currentGroupId,
  allGroups,
  onConfirm,
}: CastleSelectorModalProps) {
  const { t } = useTranslation()
  const [selectedIds, setSelectedIds] = useState<string[]>([])
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    if (isOpen) {
      const currentGroup = allGroups.find(g => g.id === currentGroupId)
      setSelectedIds(currentGroup ? [...currentGroup.castleIds] : [])
      setSearchQuery('')
    }
  }, [isOpen, currentGroupId, allGroups])

  if (!isOpen) return null

  // خريطة لمعرفة القلاع المعينة في مدد أخرى
  const otherAssignments = new Map<string, number>()
  allGroups.forEach(g => {
    if (g.id !== currentGroupId) {
      g.castleIds.forEach(cid => otherAssignments.set(cid, g.minutes))
    }
  })

  const filteredCastles = allCastles.filter(c => {
    const q = searchQuery.trim().toLowerCase()
    if (!q) return true
    const lord = (c.castle_info?.lord_name || '').toLowerCase()
    const name = (c.castle_info?.castle_name || '').toLowerCase()
    const email = (c.email || '').toLowerCase()
    const sId = String(c.castle_info?.server_id || '')
    return lord.includes(q) || name.includes(q) || email.includes(q) || sId.includes(q)
  })

  const handleToggle = (id: string) => {
    setSelectedIds(prev =>
      prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]
    )
  }

  const handleSelectAll = () => {
    const allFilteredIds = filteredCastles.map(c => c.id)
    setSelectedIds(prev => Array.from(new Set([...prev, ...allFilteredIds])))
  }

  const handleDeselectAll = () => {
    const filteredSet = new Set(filteredCastles.map(c => c.id))
    setSelectedIds(prev => prev.filter(id => !filteredSet.has(id)))
  }

  const handleSaveAndClose = () => {
    onConfirm(selectedIds)
    onClose()
  }

  return createPortal(
    <div
      className="z-[9999] fixed inset-0 flex justify-center items-end sm:items-center p-0 sm:p-4 overflow-y-auto"
      onClick={onClose}
    >
      <div className="fixed inset-0 bg-black/75 backdrop-blur-sm pointer-events-auto modal-backdrop" />
      <div
        className="z-10 relative flex flex-col bg-[#0c1310] shadow-2xl my-auto sm:border border-white/10 border-t sm:rounded-2xl rounded-t-3xl w-full sm:max-w-2xl max-h-[88vh] sm:max-h-[82vh] overflow-hidden text-gray-100 pointer-events-auto interval-modal-panel"
        onClick={e => e.stopPropagation()}
      >
        <div className="sm:hidden bg-gray-700 mx-auto my-2.5 rounded-full w-12 h-1.5 shrink-0 interval-modal-handle" />
        <div className="bg-gradient-to-r from-primary-500 via-primary-400 to-primary-600 w-full h-1 shrink-0" />

        {/* Header */}
        <div className="flex justify-between items-center bg-black/20 px-5 py-3.5 border-white/10 border-b shrink-0 interval-modal-header">
          <div className="flex items-center gap-2.5 min-w-0">
            <div className="flex justify-center items-center bg-primary-500/15 border border-primary-500/30 rounded-xl w-9 h-9 text-primary-400 shrink-0 interval-modal-icon">
              <Clock size={18} />
            </div>
            <div className="min-w-0">
              <h3 className="font-bold text-white text-base truncate">
                {t('settings.selectCastlesTitle', { mins: durationMinutes })}
              </h3>
              <p className="text-gray-400 text-xs">
                {t('settings.assignedCount', { count: selectedIds.length })}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="flex justify-center items-center bg-white/10 hover:bg-white/15 rounded-xl w-8 h-8 text-gray-300 transition-colors cursor-pointer shrink-0 interval-modal-close"
          >
            <X size={16} />
          </button>
        </div>

        {/* Search & Actions Bar */}
        <div className="space-y-2.5 bg-black/15 p-3.5 border-white/5 border-b shrink-0 interval-modal-toolbar">
          <div className="relative flex items-center">
            <Search size={15} className="absolute text-gray-400 pointer-events-none start-3" />
            <input
              type="text"
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              placeholder={t('settings.searchCastlesPlaceholder')}
              className="bg-black/40 py-2 ps-9 pe-8 border border-white/10 rounded-xl focus:outline-none focus:ring-1 focus:ring-primary-500 w-full text-white placeholder:text-gray-400 text-xs interval-modal-search"
            />
            {searchQuery && (
              <button
                type="button"
                onClick={() => setSearchQuery('')}
                className="absolute text-gray-400 hover:text-white cursor-pointer end-2.5"
              >
                <X size={14} />
              </button>
            )}
          </div>

          <div className="flex justify-between items-center pt-0.5 text-xs">
            <span className="font-mono text-[11px] text-gray-400">
              {filteredCastles.length} / {allCastles.length}
            </span>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={handleSelectAll}
                className="bg-primary-500/15 px-2.5 py-1 border border-primary-500/30 rounded-lg font-semibold text-primary-300 text-xs active:scale-95 transition-all cursor-pointer interval-modal-select-all"
              >
                {t('settings.selectAll')}
              </button>
              <button
                type="button"
                onClick={handleDeselectAll}
                className="bg-white/5 px-2.5 py-1 border border-white/10 rounded-lg font-medium text-gray-400 text-xs active:scale-95 transition-all cursor-pointer interval-modal-deselect-all"
              >
                {t('settings.deselectAll')}
              </button>
            </div>
          </div>
        </div>

        {/* Castles Checklist */}
        <div className="flex-1 p-3 sm:p-4 overflow-y-auto overscroll-contain">
          {filteredCastles.length === 0 ? (
            <div className="py-12 text-gray-400 text-xs text-center">
              {t('settings.noMatchingCastles')}
            </div>
          ) : (
            <div className="gap-2.5 grid grid-cols-1 sm:grid-cols-2">
              {filteredCastles.map(c => {
                const isChecked = selectedIds.includes(c.id)
                const otherMins = otherAssignments.get(c.id)
                const cName = c.castle_info?.lord_name || c.castle_info?.castle_name || c.email?.split('@')[0] || c.id.slice(0, 8)

                return (
                  <div
                    key={c.id}
                    onClick={() => handleToggle(c.id)}
                    className={clsx(
                      'flex justify-between items-center p-3 rounded-2xl min-h-[56px] transition-all cursor-pointer select-none interval-modal-item',
                      isChecked
                        ? 'is-checked bg-primary-500/15 border-2 border-primary-500/60 shadow-sm'
                        : 'bg-white/5 hover:bg-white/10 border border-white/10'
                    )}
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <div
                        className={clsx(
                          'flex justify-center items-center rounded-md w-5 h-5 transition-all shrink-0 interval-modal-checkbox',
                          isChecked
                            ? 'is-checked bg-primary-600 text-white shadow-sm'
                            : 'border-2 border-gray-600 bg-transparent'
                        )}
                      >
                        {isChecked && <Check size={13} strokeWidth={3} />}
                      </div>

                      <div className="flex justify-center items-center bg-primary-700 shadow-sm rounded-xl w-8 h-8 font-bold text-white text-xs shrink-0 interval-modal-avatar">
                        {cName[0].toUpperCase()}
                      </div>

                      <div className="min-w-0">
                        <div className="flex items-center gap-1.5">
                          <span className="font-bold text-white text-xs truncate">
                            {cName}
                          </span>
                          {c.castle_info?.server_id ? (
                            <span className="bg-primary-500/20 px-1.5 py-0.5 rounded font-mono font-semibold text-[10px] text-primary-300 interval-modal-server-badge">
                              s{c.castle_info.server_id}
                            </span>
                          ) : null}
                        </div>
                        <p className="font-mono text-[11px] text-gray-400 truncate">
                          {c.email}
                        </p>
                      </div>
                    </div>

                    {otherMins && !isChecked && (
                      <span className="bg-amber-500/15 px-2 py-0.5 border border-amber-500/30 rounded-full font-medium text-[10px] text-amber-400 shrink-0 interval-modal-other-badge">
                        {t('settings.assignedToOther', { mins: otherMins })}
                      </span>
                    )}
                  </div>
                )
              })}
            </div>
          )}
        </div>

        {/* Sticky Bottom Actions */}
        <div className="bg-[#0c1310]/95 backdrop-blur-md p-3.5 sm:p-4 border-white/10 border-t shrink-0 interval-modal-footer">
          <button
            type="button"
            onClick={handleSaveAndClose}
            className="flex justify-center items-center gap-2 py-3 rounded-xl w-full font-bold text-sm cursor-pointer btn-primary"
          >
            <Check size={18} />
            <span>{t('settings.confirm')} ({selectedIds.length})</span>
          </button>
        </div>
      </div>
    </div>,
    document.body
  )
}

function BotCycleIntervalsSection({ userId }: { userId?: string }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { data: castlesData, isLoading: castlesLoading } = useCastles(userId || '')
  const castles: Castle[] = castlesData?.pages ? castlesData.pages.flatMap((p: { items?: Castle[] }) => p.items || []) : []

  const [groups, setGroups] = useState<IntervalGroup[]>([])
  const [initialized, setInitialized] = useState(false)
  const [saving, setSaving] = useState(false)
  const [savedSuccess, setSavedSuccess] = useState(false)
  const [activeModalGroupId, setActiveModalGroupId] = useState<string | null>(null)
  const [pendingDeleteGroup, setPendingDeleteGroup] = useState<IntervalGroup | null>(null)

  useEffect(() => {
    setInitialized(false)
    setGroups([])
  }, [userId])

  useEffect(() => {
    if (!castles.length || initialized) return
    const map = new Map<number, string[]>()
    castles.forEach(c => {
      const interval = clampInterval(c.loop_interval ? Number(c.loop_interval) : DEFAULT_INTERVAL_MINS)
      if (!map.has(interval)) map.set(interval, [])
      map.get(interval)!.push(c.id)
    })

    const initialGroups: IntervalGroup[] = []
    map.forEach((cIds, mins) => {
      initialGroups.push({
        id: `group_${mins}_${Math.random().toString(36).substring(2, 6)}`,
        minutes: mins,
        draftMinutes: String(mins),
        castleIds: cIds,
      })
    })

    if (initialGroups.length === 0) {
      initialGroups.push({
        id: 'group_default',
        minutes: DEFAULT_INTERVAL_MINS,
        draftMinutes: String(DEFAULT_INTERVAL_MINS),
        castleIds: castles.map(c => c.id),
      })
    }
    initialGroups.sort((a, b) => a.minutes - b.minutes)
    setGroups(initialGroups)
    setInitialized(true)
  }, [castles, initialized])

  const handleUpdateMinutes = (groupId: string, delta: number) => {
    setGroups(prev => prev.map(g => {
      if (g.id !== groupId) return g
      const next = clampInterval(g.minutes + delta)
      return { ...g, minutes: next, draftMinutes: String(next) }
    }))
  }

  const handleDraftMinutesChange = (groupId: string, raw: string) => {
    setGroups(prev => prev.map(g => {
      if (g.id !== groupId) return g
      const parsed = parseInt(raw, 10)
      const nextMinutes = !Number.isNaN(parsed) && parsed >= MIN_INTERVAL_MINS && parsed <= MAX_INTERVAL_MINS
        ? parsed
        : g.minutes
      return { ...g, draftMinutes: raw, minutes: nextMinutes }
    }))
  }

  const handleCommitMinutes = (groupId: string) => {
    setGroups(prev => prev.map(g => {
      if (g.id !== groupId) return g
      const parsed = parseInt(g.draftMinutes, 10)
      const clamped = clampInterval(Number.isNaN(parsed) ? g.minutes : parsed)
      return { ...g, minutes: clamped, draftMinutes: String(clamped) }
    }))
  }

  const handleModalConfirm = (groupId: string, newCastleIds: string[]) => {
    const newIdsSet = new Set(newCastleIds)
    setGroups(prev => prev.map(g => {
      if (g.id === groupId) {
        return { ...g, castleIds: newCastleIds }
      }
      return {
        ...g,
        castleIds: g.castleIds.filter(id => !newIdsSet.has(id)),
      }
    }))
  }

  const handleRemoveCastleFromGroup = (groupId: string, castleId: string) => {
    setGroups(prev => prev.map(g => {
      if (g.id !== groupId) return g
      return {
        ...g,
        castleIds: g.castleIds.filter(id => id !== castleId),
      }
    }))
  }

  const handleAddGroup = () => {
    const existingMins = groups.map(g => g.minutes)
    let candidate = 60
    if (existingMins.includes(60)) candidate = 45
    if (existingMins.includes(45)) candidate = 90
    if (existingMins.includes(candidate)) candidate = Math.min(MAX_INTERVAL_MINS, Math.max(...existingMins, MIN_INTERVAL_MINS) + 15)

    setGroups(prev => [
      ...prev,
      {
        id: `group_${Date.now()}`,
        minutes: candidate,
        draftMinutes: String(candidate),
        castleIds: [],
      },
    ])
  }

  const handleRemoveGroup = (groupId: string) => {
    setGroups(prev => prev.filter(g => g.id !== groupId))
  }

  const handleSave = async () => {
    if (!castles.length) return
    setSaving(true)
    try {
      const normalizedGroups = groups.map(g => {
        const parsed = parseInt(g.draftMinutes, 10)
        const clamped = clampInterval(Number.isNaN(parsed) ? g.minutes : parsed)
        return { ...g, minutes: clamped, draftMinutes: String(clamped) }
      })
      setGroups(normalizedGroups)

      const payload: Record<string, number> = {}
      normalizedGroups.forEach(g => {
        g.castleIds.forEach(cid => {
          payload[cid] = g.minutes
        })
      })
      castles.forEach(c => {
        if (!payload[c.id]) {
          payload[c.id] = DEFAULT_INTERVAL_MINS
        }
      })

      await updateCastlesLoopIntervals(payload)
      await queryClient.invalidateQueries({ queryKey: ['castles', userId] })
      setSavedSuccess(true)
      toast.success(t('settings.intervalsSaved'))
      setTimeout(() => setSavedSuccess(false), 2500)
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : ''
      toast.error(msg || t('common.error'))
    } finally {
      setSaving(false)
    }
  }

  const castlesById = new Map<string, Castle>(castles.map(c => [c.id, c]))
  const activeModalGroup = groups.find(g => g.id === activeModalGroupId)

  return (
    <div className="space-y-4 sm:space-y-5 p-4 sm:p-6 settings-intervals-card glass-card">
      {/* Header */}
      <div className="flex flex-wrap justify-between items-center gap-2">
        <div className="flex items-center gap-2.5">
          <div className="flex justify-center items-center bg-primary-700 border border-primary-500/40 rounded-lg w-7 h-7 text-white shrink-0 settings-lock-icon">
            <Clock size={15} />
          </div>
          <div>
            <h2 className="font-semibold text-white settings-section-title">
              {t('settings.botCycleIntervals')}
            </h2>
            <p className="text-gray-400 text-xs settings-hint-text">
              {t('settings.botCycleIntervalsDesc')}
            </p>
          </div>
        </div>

        {savedSuccess && (
          <div className="flex items-center gap-1.5 bg-primary-500/20 px-3 py-1 border border-primary-500/35 rounded-xl font-bold text-primary-300 text-xs settings-success-badge">
            <Check size={14} />
            <span>{t('settings.saved')}</span>
          </div>
        )}
      </div>

      {castlesLoading ? (
        <div className="flex justify-center items-center py-8 text-gray-400 text-xs">
          <span className="me-2 border-2 border-primary-500 border-t-transparent rounded-full w-4 h-4 animate-spin" />
          <span>{t('common.loading')}</span>
        </div>
      ) : castles.length === 0 ? (
        <div className="py-6 text-gray-500 text-sm text-center">
          {t('settings.noCastlesFound')}
        </div>
      ) : (
        <div className="space-y-4">
          {groups.map((group, idx) => {
            const minRand = group.minutes
            const maxRand = group.minutes + JITTER_MINUTES
            const assignedCastles = group.castleIds
              .map(id => castlesById.get(id))
              .filter(Boolean) as Castle[]

            return (
              <div
                key={group.id}
                className="settings-interval-group space-y-3 bg-black/30 p-3.5 sm:p-4 border border-white/10 rounded-2xl transition-colors"
              >
                {/* Duration Row */}
                <div className="flex flex-wrap justify-between items-center gap-3">
                  <div className="flex flex-wrap items-center gap-2.5 sm:gap-3">
                    <span className="bg-white/5 px-2 py-1 border border-white/10 rounded-lg font-mono font-bold text-gray-400 text-xs settings-interval-index">
                      #{idx + 1}
                    </span>

                    {/* Stepper Input */}
                    <div className="flex items-center bg-black/50 border border-white/15 rounded-xl overflow-hidden settings-interval-stepper">
                      <button
                        type="button"
                        onClick={() => handleUpdateMinutes(group.id, -5)}
                        disabled={group.minutes <= MIN_INTERVAL_MINS}
                        className="hover:bg-white/10 disabled:opacity-30 p-2 text-gray-300 transition-colors cursor-pointer disabled:cursor-not-allowed settings-interval-stepper-btn"
                        title={t('settings.minusFiveMin')}
                      >
                        <Minus size={13} />
                      </button>

                      <div className="flex items-center px-2 min-w-[74px] text-center">
                        <input
                          type="number"
                          min={MIN_INTERVAL_MINS}
                          max={MAX_INTERVAL_MINS}
                          value={group.draftMinutes}
                          onChange={e => handleDraftMinutesChange(group.id, e.target.value)}
                          onBlur={() => handleCommitMinutes(group.id)}
                          className="bg-transparent focus:outline-none w-full font-mono font-bold text-white text-sm text-center [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none [appearance:textfield] settings-interval-input"
                        />
                        <span className="ms-1 font-normal text-gray-400 text-xs shrink-0 settings-interval-unit">
                          {t('settings.minutesUnit')}
                        </span>
                      </div>

                      <button
                        type="button"
                        onClick={() => handleUpdateMinutes(group.id, 5)}
                        disabled={group.minutes >= MAX_INTERVAL_MINS}
                        className="hover:bg-white/10 disabled:opacity-30 p-2 text-gray-300 transition-colors cursor-pointer disabled:cursor-not-allowed settings-interval-stepper-btn"
                        title={t('settings.plusFiveMin')}
                      >
                        <Plus size={13} />
                      </button>
                    </div>

                    {/* Smart Jitter Badge */}
                    <div className="flex items-center gap-1.5 bg-emerald-500/10 px-2.5 py-1.5 border border-emerald-500/25 rounded-xl font-mono font-medium text-emerald-300 text-xs settings-interval-jitter">
                      <Dices size={13} className="text-emerald-400 shrink-0" />
                      <span>
                        {minRand} ~ {maxRand} {t('settings.minutesUnit')}
                      </span>
                    </div>

                    {/* Selection Modal Trigger */}
                    <button
                      type="button"
                      onClick={() => setActiveModalGroupId(group.id)}
                      className="flex items-center gap-1.5 bg-primary-500/15 hover:bg-primary-500/25 px-3 py-1.5 border border-primary-500/40 rounded-xl font-bold text-primary-300 text-xs transition-colors cursor-pointer settings-interval-select-btn"
                    >
                      <span>🏰</span>
                      <span>{t('settings.selectCastlesBtn')}</span>
                      <span className="bg-primary-400 px-1.5 py-0.5 rounded-full font-mono text-[10px] text-gray-900 leading-none settings-interval-count-pill">
                        {group.castleIds.length}
                      </span>
                    </button>
                  </div>

                  {groups.length > 1 && (
                    <button
                      type="button"
                      onClick={() => setPendingDeleteGroup(group)}
                      className="settings-interval-remove-group hover:bg-rose-500/10 p-1.5 rounded-lg text-rose-400/80 hover:text-rose-400 transition-colors cursor-pointer"
                      title={t('settings.removeGroup')}
                    >
                      <Trash2 size={15} />
                    </button>
                  )}
                </div>

                {/* Assigned Castles Display */}
                <div>
                  {assignedCastles.length === 0 ? (
                    <div
                      onClick={() => setActiveModalGroupId(group.id)}
                      className="flex justify-center items-center gap-2 hover:bg-primary-500/5 p-3 border border-white/15 hover:border-primary-400 border-dashed rounded-xl text-gray-400 text-xs text-center transition-colors cursor-pointer settings-interval-empty-drop"
                    >
                      <span>🏰</span>
                      <span>{t('settings.noCastlesInGroup')} — {t('settings.clickToAssign')}</span>
                    </div>
                  ) : (
                    <div className="flex flex-wrap gap-2 pt-0.5">
                      {assignedCastles.map(c => {
                        const cName = c.castle_info?.lord_name || c.castle_info?.castle_name || c.email?.split('@')[0] || c.id.slice(0, 8)
                        return (
                          <div
                            key={c.id}
                            className="flex items-center gap-2 bg-white/5 px-2.5 py-1 border border-white/10 rounded-xl text-xs settings-interval-chip"
                          >
                            <span className="bg-emerald-500 rounded-full w-2 h-2 shrink-0" />
                            <span className="max-w-[130px] font-semibold text-gray-100 truncate">
                              {cName}
                            </span>
                            {c.castle_info?.server_id ? (
                              <span className="font-mono text-[10px] text-gray-400">
                                s{c.castle_info.server_id}
                              </span>
                            ) : null}
                            <button
                              type="button"
                              onClick={() => handleRemoveCastleFromGroup(group.id, c.id)}
                              className="p-0.5 rounded text-gray-400 hover:text-rose-400 transition-colors cursor-pointer settings-interval-chip-remove"
                              title={t('settings.removeCastleFromGroup')}
                            >
                              <X size={12} />
                            </button>
                          </div>
                        )
                      })}
                    </div>
                  )}
                </div>
              </div>
            )
          })}

          {/* Action buttons */}
          <div className="flex flex-wrap justify-between items-center gap-3 pt-2">
            <button
              type="button"
              onClick={handleAddGroup}
              className="flex items-center gap-1.5 bg-white/5 hover:bg-white/10 px-3.5 py-2 border border-white/10 rounded-xl font-semibold text-gray-200 text-xs transition-colors cursor-pointer settings-interval-add-btn"
            >
              <Plus size={14} />
              <span>{t('settings.addGroup')}</span>
            </button>

            <button
              type="button"
              onClick={handleSave}
              disabled={saving}
              className={clsx(
                'flex items-center gap-2 px-5 py-2 text-xs cursor-pointer btn-primary',
                savedSuccess && 'bg-primary-600 border-primary-400'
              )}
            >
              {saving ? (
                <>
                  <span className="border-2 border-white/30 border-t-white rounded-full w-3.5 h-3.5 animate-spin" />
                  <span>{t('settings.savingIntervals')}</span>
                </>
              ) : savedSuccess ? (
                <>
                  <Check size={14} className="text-white" />
                  <span>{t('settings.saved')}</span>
                </>
              ) : (
                <>
                  <Clock size={14} />
                  <span>{t('settings.saveIntervals')}</span>
                </>
              )}
            </button>
          </div>
        </div>
      )}

      {/* Castle Selector Modal */}
      {activeModalGroup && (
        <CastleSelectorModal
          isOpen={Boolean(activeModalGroupId)}
          onClose={() => setActiveModalGroupId(null)}
          durationMinutes={activeModalGroup.minutes}
          allCastles={castles}
          currentGroupId={activeModalGroup.id}
          allGroups={groups}
          onConfirm={(selectedIds) => handleModalConfirm(activeModalGroup.id, selectedIds)}
        />
      )}

      {/* Delete Interval Confirmation Modal */}
      <ConfirmDeleteIntervalModal
        group={pendingDeleteGroup}
        onClose={() => setPendingDeleteGroup(null)}
        onConfirm={() => {
          if (pendingDeleteGroup) {
            handleRemoveGroup(pendingDeleteGroup.id)
            setPendingDeleteGroup(null)
          }
        }}
      />
    </div>
  )
}

function ConfirmDeleteIntervalModal({
  group,
  onClose,
  onConfirm,
}: {
  group: IntervalGroup | null
  onClose: () => void
  onConfirm: () => void
}) {
  const { t } = useTranslation()

  useEffect(() => {
    if (!group) return
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [group, onClose])

  if (!group || typeof document === 'undefined') return null

  const castleCount = group.castleIds.length

  return createPortal(
    <>
      <div
        onClick={onClose}
        className="z-[9998] fixed inset-0 bg-black/70 backdrop-blur-sm modal-backdrop"
      />
      <div className="z-[9999] fixed inset-0 flex justify-center items-center p-4 pointer-events-none">
        <div
          onClick={e => e.stopPropagation()}
          className="relative rounded-2xl w-full max-w-[380px] overflow-hidden pointer-events-auto confirm-logout-modal-box"
        >
          <div className="bg-gradient-to-r from-rose-500 via-red-500 to-rose-500 w-full h-1" />
          <div className="relative p-5 sm:p-6 text-center">
            <button
              type="button"
              onClick={onClose}
              className="top-4 absolute p-1.5 rounded-lg text-gray-400 cursor-pointer modal-close-btn start-4"
              title={t('modals.close')}
            >
              <X size={17} />
            </button>

            <div className="flex justify-center items-center bg-rose-500/15 mx-auto mb-3.5 border border-rose-500/30 rounded-2xl w-12 h-12 text-rose-400">
              <Trash2 size={22} className="text-rose-400" />
            </div>

            <h3 className="mb-1.5 font-bold text-white text-base sm:text-lg modal-title">
              {t('settings.confirmDeleteGroupTitle')}
            </h3>

            <p className="mb-6 text-gray-400 text-xs sm:text-sm leading-relaxed modal-desc">
              {castleCount > 0
                ? t('settings.confirmDeleteGroupDescWithCastles', { mins: group.minutes, count: castleCount })
                : t('settings.confirmDeleteGroupDescEmpty', { mins: group.minutes })}
            </p>

            <div className="flex items-center gap-2.5">
              <button
                type="button"
                onClick={onClose}
                className="flex-1 bg-white/5 px-4 py-2.5 border border-white/10 rounded-xl font-semibold text-gray-300 text-xs sm:text-sm cursor-pointer modal-btn-cancel"
              >
                {t('modals.cancel')}
              </button>
              <button
                type="button"
                onClick={onConfirm}
                className="flex flex-1 justify-center items-center gap-1.5 px-4 py-2.5 rounded-xl font-bold text-xs sm:text-sm cursor-pointer btn-danger"
              >
                <Trash2 size={14} />
                <span>{t('settings.removeGroup')}</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </>,
    document.body
  )
}

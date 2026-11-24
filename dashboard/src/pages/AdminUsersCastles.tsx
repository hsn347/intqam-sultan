import React, { useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import {
  Search, Users, ChevronDown, ChevronUp, AlertTriangle,
  X, RefreshCw, Zap, Shield, Trash2, Landmark, CheckCircle2, Lock
} from 'lucide-react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import toast from 'react-hot-toast'
import { AdminLayout } from '../components/layout/AdminLayout'
import { CastleCard } from '../components/accounts/CastleCard'
import { fetchAdminUsersCastles, deleteCastle, AdminUserWithCastles } from '../lib/botApi'
import { Castle } from '../types'

export function AdminUsersCastlesPage() {
  const { t } = useTranslation()
  const qc = useQueryClient()

  // ─── Search & Filter State ─────────────────────────────────
  const [searchQuery, setSearchQuery] = useState('')
  const [filterType, setFilterType] = useState<'all' | 'with_castles' | 'no_castles' | 'running'>('all')

  // ─── Collapsed State: All user cards closed by default ─────
  const [expandedUsers, setExpandedUsers] = useState<Record<string, boolean>>({})

  // ─── Castle Delete Modal State ─────────────────────────────
  const [deletingCastle, setDeletingCastle] = useState<{
    castleId: string
    castleEmail?: string
    userUid: string
    userEmail: string
  } | null>(null)

  // ─── Query: Fetch All Users with Castles ───────────────────
  const {
    data: users = [],
    isLoading,
    isRefetching,
    refetch
  } = useQuery({
    queryKey: ['admin_users_castles'],
    queryFn: fetchAdminUsersCastles,
    staleTime: 45_000,
    refetchOnWindowFocus: false,
  })

  // ─── Toggle User Expand ────────────────────────────────────
  const toggleUser = (uid: string) => {
    setExpandedUsers(prev => ({
      ...prev,
      [uid]: !prev[uid]
    }))
  }

  // ─── Collapse / Expand All ─────────────────────────────────
  const collapseAll = () => setExpandedUsers({})

  // ─── Delete Castle Mutation ────────────────────────────────
  const deleteMutation = useMutation({
    mutationFn: async (castleId: string) => {
      await deleteCastle(castleId)
    },
    onSuccess: (_, castleId) => {
      toast.success(t('accounts.deletedSuccess', 'تم حذف القلعة بنجاح'))
      // Update local cache directly without waiting for full refetch
      qc.setQueryData<AdminUserWithCastles[]>(['admin_users_castles'], old => {
        if (!old) return []
        return old.map(u => ({
          ...u,
          castles: (u.castles || []).filter(c => c.id !== castleId),
          castles_count: (u.castles || []).filter(c => c.id !== castleId).length,
        }))
      })
      qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
      qc.invalidateQueries({ queryKey: ['admin_stats'] })
      qc.invalidateQueries({ queryKey: ['admin_users'] })
      setDeletingCastle(null)
    },
    onError: (err: any) => {
      toast.error(err.message || t('accounts.deleteFailed', 'تعذر حذف القلعة'))
    }
  })

  const confirmDeleteCastle = () => {
    if (!deletingCastle) return
    deleteMutation.mutate(deletingCastle.castleId)
  }

  // ─── Overall Counts ────────────────────────────────────────
  const stats = useMemo(() => {
    let totalCastles = 0
    let runningCastles = 0
    users.forEach(u => {
      totalCastles += u.castles_count || 0
      runningCastles += u.running_count || 0
    })
    return {
      totalUsers: users.length,
      totalCastles,
      runningCastles,
    }
  }, [users])

  // ─── Filtered Users List (Search by user or by castle) ─────
  const filteredUsers = useMemo(() => {
    const q = searchQuery.trim().toLowerCase()

    return users.filter(u => {
      // Type filter
      if (filterType === 'with_castles' && u.castles_count === 0) return false
      if (filterType === 'no_castles' && u.castles_count > 0) return false
      if (filterType === 'running' && u.running_count === 0) return false

      if (!q) return true

      // 1. Match User
      const userMatch =
        (u.email || '').toLowerCase().includes(q) ||
        (u.display_name || '').toLowerCase().includes(q) ||
        (u.uid || '').toLowerCase().includes(q)

      if (userMatch) return true

      // 2. Match Any Castle belonging to this User
      const castleMatch = (u.castles || []).some(c =>
        (c.email || '').toLowerCase().includes(q) ||
        (c.castle_info?.lord_name || '').toLowerCase().includes(q) ||
        (c.id || '').toLowerCase().includes(q)
      )

      return castleMatch
    })
  }, [users, searchQuery, filterType])

  return (
    <AdminLayout title="قلاع المستخدمين">
      <div className="space-y-4 mx-auto px-3 sm:px-6 lg:px-8 py-4 sm:py-6 max-w-7xl">

        {/* ── Header & KPI Badges ── */}
        <div className="flex sm:flex-row flex-col justify-between sm:items-center gap-3 bg-white dark:bg-[#0c1410] shadow-xs p-4 sm:p-5 border border-slate-200/80 dark:border-white/10 rounded-2xl">
          <div className="flex items-center gap-3">
            <div className="flex justify-center items-center bg-emerald-500/10 border border-emerald-500/20 rounded-xl w-10 h-10 shrink-0">
              <Landmark size={20} className="text-emerald-600 dark:text-emerald-400" />
            </div>
            <div>
              <h1 className="font-black text-slate-900 dark:text-white text-base sm:text-lg leading-tight">
                قلاع المستخدمين
              </h1>
              <p className="mt-0.5 text-slate-500 dark:text-slate-400 text-xs">
                إدارة مركزية لجميع مستخدمي المنصة وقلاعهم مع التحكم الكامل
              </p>
            </div>
          </div>

          {/* Quick Metrics & Actions */}
          <div className="flex flex-wrap items-center gap-2 pt-2 sm:pt-0 border-slate-100 dark:border-white/5 border-t sm:border-t-0">
            <span className="flex items-center gap-1.5 bg-slate-100 dark:bg-white/5 px-2.5 py-1 border border-slate-200/80 dark:border-white/10 rounded-lg font-semibold text-slate-700 dark:text-slate-300 text-xs">
              <Users size={12} className="text-emerald-500" />
              <span>{stats.totalUsers} مستخدم</span>
            </span>

            <span className="flex items-center gap-1.5 bg-emerald-50 dark:bg-emerald-500/10 px-2.5 py-1 border border-emerald-200/80 dark:border-emerald-500/25 rounded-lg font-semibold text-emerald-700 dark:text-emerald-300 text-xs">
              <Landmark size={12} />
              <span>{stats.totalCastles} قلعة</span>
            </span>

            {stats.runningCastles > 0 && (
              <span className="flex items-center gap-1.5 bg-teal-50 dark:bg-teal-500/15 px-2.5 py-1 border border-teal-200/80 dark:border-teal-500/30 rounded-lg font-bold text-teal-700 dark:text-teal-300 text-xs animate-pulse">
                <span className="bg-teal-400 rounded-full w-1.5 h-1.5" />
                <span>{stats.runningCastles} يعمل الآن</span>
              </span>
            )}

            <button
              type="button"
              onClick={() => refetch()}
              disabled={isRefetching}
              className="bg-slate-100 dark:bg-white/5 p-1.5 rounded-lg text-slate-500 dark:text-slate-400 cursor-pointer"
              title="تحديث البيانات"
            >
              <RefreshCw size={13} className={isRefetching ? 'animate-spin text-emerald-500' : ''} />
            </button>
          </div>
        </div>

        {/* ── Search & Filter Controls ── */}
        <div className="flex sm:flex-row flex-col items-stretch sm:items-center gap-2.5">
          {/* Search Input */}
          <div className="relative flex-1 min-w-0">
            <Search size={15} className="top-1/2 absolute text-slate-400 -translate-y-1/2 pointer-events-none start-3.5" />
            <input
              type="text"
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              placeholder="بحث بالاسم، بريد المستخدم، بريد القلعة، أو اسم اللورد..."
              className="bg-white dark:bg-[#0c1410] shadow-xs py-2 ps-9.5 pe-8 border border-slate-200/80 focus:border-emerald-500 dark:border-white/10 rounded-xl focus:outline-hidden focus:ring-1 focus:ring-emerald-500/25 w-full text-slate-900 dark:text-gray-100 text-xs placeholder-slate-400"
            />
            {searchQuery && (
              <button
                type="button"
                onClick={() => setSearchQuery('')}
                className="top-1/2 absolute p-0.5 rounded text-slate-400 -translate-y-1/2 cursor-pointer end-2.5"
              >
                <X size={14} />
              </button>
            )}
          </div>

          {/* Quick Filter Badges */}
          <div className="flex items-center gap-1 pb-1 sm:pb-0 overflow-x-auto select-none shrink-0">
            {(
              [
                { id: 'all', label: 'الكل' },
                { id: 'with_castles', label: 'لديهم قلاع' },
                { id: 'running', label: 'قيد التشغيل' },
                { id: 'no_castles', label: 'بدون قلاع' },
              ] as const
            ).map(f => (
              <button
                key={f.id}
                type="button"
                onClick={() => setFilterType(f.id)}
                className={`px-3 py-1.5 rounded-lg text-xs font-semibold cursor-pointer border ${
                  filterType === f.id
                    ? 'bg-emerald-600 text-white border-emerald-600 shadow-xs'
                    : 'bg-white dark:bg-[#0c1410] text-slate-600 dark:text-slate-300 border-slate-200/80 dark:border-white/10'
                }`}
              >
                {f.label}
              </button>
            ))}

            {Object.values(expandedUsers).some(Boolean) && (
              <button
                type="button"
                onClick={collapseAll}
                className="bg-white dark:bg-white/5 px-2.5 py-1.5 border border-slate-200/80 dark:border-white/10 rounded-lg font-medium text-slate-500 dark:text-slate-400 text-xs cursor-pointer"
                title="إغلاق كافة الكاردات"
              >
                طي الكل
              </button>
            )}
          </div>
        </div>

        {/* ── Users List ── */}
        {isLoading ? (
          <div className="flex flex-col justify-center items-center gap-3 bg-white dark:bg-[#0c1410] py-16 border border-slate-200/80 dark:border-white/10 rounded-2xl">
            <div className="border-2 border-emerald-500/30 border-t-emerald-500 rounded-full w-8 h-8 animate-spin" />
            <span className="text-slate-500 dark:text-slate-400 text-xs">جاري تحميل المستخدمين وقلاعهم...</span>
          </div>
        ) : filteredUsers.length === 0 ? (
          <div className="flex flex-col justify-center items-center bg-white dark:bg-[#0c1410] p-6 py-16 border border-slate-200/80 dark:border-white/10 rounded-2xl text-center">
            <Users size={36} className="mb-2 text-slate-300 dark:text-slate-600" />
            <h3 className="font-bold text-slate-800 dark:text-slate-200 text-sm">لا توجد نتائج مطابقة</h3>
            <p className="mt-1 max-w-sm text-slate-500 dark:text-slate-400 text-xs">
              لم نعثر على أي مستخدم أو قلعة تطابق شروط البحث الحالية
            </p>
            {searchQuery && (
              <button
                type="button"
                onClick={() => setSearchQuery('')}
                className="bg-emerald-500/10 mt-3 px-3 py-1.5 border border-emerald-500/25 rounded-lg font-semibold text-emerald-600 dark:text-emerald-400 text-xs cursor-pointer"
              >
                مسح البحث
              </button>
            )}
          </div>
        ) : (
          <div className="space-y-3">
            {filteredUsers.map(user => {
              const isExpanded = Boolean(expandedUsers[user.uid])
              const castles = user.castles || []

              return (
                <div
                  key={user.uid}
                  className="bg-white dark:bg-[#0c1410] shadow-xs border border-slate-200/80 dark:border-white/10 rounded-2xl overflow-hidden"
                >
                  {/* ── User Row / Header Card (Click to expand/collapse) ── */}
                  <div
                    onClick={() => toggleUser(user.uid)}
                    className="flex sm:flex-row flex-col justify-between sm:items-center gap-3 p-3.5 sm:p-4 border-transparent border-b cursor-pointer select-none"
                  >
                    {/* Left: User Identity */}
                    <div className="flex items-center gap-3 min-w-0">
                      <div className="flex justify-center items-center bg-emerald-500/15 border border-emerald-500/30 rounded-xl w-10 h-10 font-bold text-emerald-600 dark:text-emerald-400 text-sm shrink-0">
                        {user.display_name?.[0]?.toUpperCase() || user.email?.[0]?.toUpperCase() || 'U'}
                      </div>

                      <div className="min-w-0">
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-slate-900 dark:text-white text-sm truncate">
                            {user.display_name || user.email.split('@')[0]}
                          </span>

                          {user.is_banned ? (
                            <span className="bg-rose-500/15 px-1.5 py-0.2 border border-rose-500/30 rounded-md font-bold text-[10px] text-rose-500 dark:text-rose-400">
                              محظور
                            </span>
                          ) : (
                            <span className="bg-emerald-500/10 px-1.5 py-0.2 border border-emerald-500/20 rounded-md font-bold text-[10px] text-emerald-600 dark:text-emerald-400">
                              {user.subscription?.plan_name || 'نشط'}
                            </span>
                          )}
                        </div>

                        <div className="flex items-center gap-2 mt-0.5 font-mono text-slate-500 dark:text-slate-400 text-xs truncate">
                          <span>{user.email}</span>
                          {user.tenant_domain && (
                            <span className="bg-slate-100 dark:bg-white/5 px-1 py-0.2 border border-slate-200/60 dark:border-white/10 rounded text-[10px]">
                              {user.tenant_domain}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Right: Badges & Chevron */}
                    <div className="flex justify-between sm:justify-end items-center gap-2 pt-2 sm:pt-0 border-slate-100 dark:border-white/5 border-t sm:border-t-0">
                      {/* Castles Count */}
                      <span className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold border ${
                        user.castles_count > 0
                          ? 'bg-emerald-50 dark:bg-emerald-500/10 border-emerald-200/80 dark:border-emerald-500/25 text-emerald-700 dark:text-emerald-300'
                          : 'bg-slate-100 dark:bg-white/5 border-slate-200/80 dark:border-white/10 text-slate-500 dark:text-slate-400'
                      }`}>
                        <Landmark size={12} />
                        <span>{user.castles_count} {user.castles_count === 1 ? 'قلعة' : 'قلاع'}</span>
                      </span>

                      {/* Running Count if any */}
                      {user.running_count > 0 && (
                        <span className="flex items-center gap-1 bg-teal-50 dark:bg-teal-500/15 px-2 py-1 border border-teal-200/80 dark:border-teal-500/30 rounded-lg font-bold text-[11px] text-teal-700 dark:text-teal-300">
                          <span className="bg-teal-400 rounded-full w-1.5 h-1.5 animate-pulse" />
                          <span>{user.running_count} يعمل</span>
                        </span>
                      )}

                      {/* Expand/Collapse Chevron Indicator */}
                      <div className="flex justify-center items-center bg-slate-100 dark:bg-white/5 border border-slate-200/60 dark:border-white/10 rounded-lg w-7 h-7 text-slate-500 dark:text-slate-400 shrink-0">
                        {isExpanded ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
                      </div>
                    </div>
                  </div>

                  {/* ── Dropdown / Collapsed Content: Lazy mounted on expand ── */}
                  {isExpanded && (
                    <div className="space-y-3 bg-slate-50/70 dark:bg-[#070d0a]/60 p-3 sm:p-4 border-slate-200/80 dark:border-white/10 border-t">
                      {castles.length === 0 ? (
                        <div className="py-6 font-medium text-slate-500 dark:text-slate-400 text-xs text-center">
                          لا توجد أي قلاع مسجلة لهذا المستخدم حتى الآن.
                        </div>
                      ) : (
                        <div className="space-y-3">
                          {castles.map((castle, cIdx) => (
                            <CastleCard
                              key={castle.id}
                              castle={castle}
                              userId={user.uid}
                              index={cIdx}
                              onDelete={(cId) => {
                                setDeletingCastle({
                                  castleId: cId,
                                  castleEmail: castle.email,
                                  userUid: user.uid,
                                  userEmail: user.email,
                                })
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        )}

        {/* ── Delete Castle Confirmation Dialog ── */}
        {deletingCastle && (
          <div className="z-50 fixed inset-0 flex justify-center items-center bg-black/65 p-4">
            <div className="space-y-4 bg-white dark:bg-[#0c1410] shadow-2xl p-5 border border-slate-200 dark:border-white/10 rounded-2xl w-full max-w-sm">
              <div className="flex items-center gap-3">
                <div className="flex justify-center items-center bg-rose-500/10 border border-rose-500/25 rounded-xl w-10 h-10 text-rose-500 shrink-0">
                  <AlertTriangle size={20} />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 dark:text-white text-sm">
                    تأكيد حذف القلعة
                  </h3>
                  <p className="mt-0.5 text-slate-500 dark:text-slate-400 text-xs">
                    حذف القلعة من حساب المستخدم نهائياً
                  </p>
                </div>
              </div>

              <div className="space-y-1 bg-slate-50 dark:bg-white/5 p-3 border border-slate-200/60 dark:border-white/10 rounded-xl text-xs">
                <div className="flex justify-between items-center">
                  <span className="text-slate-500">المستخدم:</span>
                  <span className="font-mono text-slate-800 dark:text-slate-200">{deletingCastle.userEmail}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-slate-500">بريد القلعة:</span>
                  <span className="font-mono text-slate-800 dark:text-slate-200">{deletingCastle.castleEmail || deletingCastle.castleId}</span>
                </div>
              </div>

              <div className="flex items-center gap-2 pt-1">
                <button
                  type="button"
                  onClick={confirmDeleteCastle}
                  disabled={deleteMutation.isPending}
                  className="flex flex-1 justify-center items-center gap-1.5 bg-rose-600 px-3 py-2 rounded-xl font-bold text-white text-xs cursor-pointer"
                >
                  {deleteMutation.isPending ? 'جاري الحذف...' : 'نعم، احذف القلعة'}
                </button>
                <button
                  type="button"
                  onClick={() => setDeletingCastle(null)}
                  disabled={deleteMutation.isPending}
                  className="bg-slate-100 dark:bg-white/5 px-4 py-2 rounded-xl font-semibold text-slate-700 dark:text-slate-300 text-xs cursor-pointer"
                >
                  إلغاء
                </button>
              </div>
            </div>
          </div>
        )}

      </div>
    </AdminLayout>
  )
}

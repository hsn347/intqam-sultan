import React, { useState, useEffect, useMemo, useRef } from 'react'
import { Link, Navigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import {
  Activity, RefreshCw, Search, Shield, AlertTriangle,
  Play, Pause, Clock, Cpu, User, CheckCircle2,
  StopCircle, ArrowRight, Radio, Eye
} from 'lucide-react'
import { clsx } from 'clsx'
import { AdminLayout } from '../components/layout/AdminLayout'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { getAdminLiveProcesses, stopBot, type LiveProcessInfo, type LiveProcessesResponse } from '../lib/botApi'
import { useAuth } from '../hooks/useAuth'
import toast from 'react-hot-toast'

export function AdminLiveProcessesView({ isActive = true }: { isActive?: boolean }) {
  const { t } = useTranslation()
  const { firebaseUser, isSuperAdmin } = useAuth()
  const qc = useQueryClient()
  const [autoRefresh, setAutoRefresh] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [activeFilter, setActiveFilter] = useState<'all' | 'running' | 'waiting' | 'other_login' | 'reconnecting'>('all')
  const [stoppingIds, setStoppingIds] = useState<Set<string>>(new Set())

  const {
    data,
    isLoading: loading,
    isFetching: isRefreshing,
    refetch,
  } = useQuery<LiveProcessesResponse>({
    queryKey: ['admin', 'live-processes'],
    queryFn: getAdminLiveProcesses,
    staleTime: 5000,
    gcTime: 1000 * 60 * 10,
    refetchInterval: isActive && autoRefresh ? 5000 : false,
    refetchIntervalInBackground: false,
    refetchOnWindowFocus: true,
  })

  const handleStopProcess = async (castleId: string, email: string) => {
    const targetName = email || castleId
    if (!confirm(t('admin.live.confirmStop', { target: targetName }))) {
      return
    }

    setStoppingIds(prev => new Set(prev).add(castleId))
    try {
      await stopBot(castleId)
      toast.success(t('admin.live.stopSuccess', { target: targetName }))
      await refetch()
    } catch (err: any) {
      toast.error(t('admin.live.stopError', { error: err?.message || t('common.error') }))
    } finally {
      setStoppingIds(prev => {
        const next = new Set(prev)
        next.delete(castleId)
        return next
      })
    }
  }

  // Format uptime in friendly localized string
  const formatUptime = (sec: number) => {
    if (!sec || sec < 0) return `0 ${t('common.seconds')}`
    const h = Math.floor(sec / 3600)
    const m = Math.floor((sec % 3600) / 60)
    const s = sec % 60
    if (h > 0) return `${h} ${t('common.hours')} ${m} ${t('common.minutes')}`
    if (m > 0) return `${m} ${t('common.minutes')} ${s} ${t('common.seconds')}`
    return `${s} ${t('common.seconds')}`
  }

  // Filtered list
  const filteredProcesses = useMemo(() => {
    if (!data?.processes) return []
    return data.processes.filter(p => {
      // 1. Search Query
      const q = searchQuery.toLowerCase().trim()
      if (q) {
        const matchEmail = (p.email || '').toLowerCase().includes(q)
        const matchCid = (p.castle_id || '').toLowerCase().includes(q)
        const matchUser = (p.user_email || '').toLowerCase().includes(q) || (p.user_id || '').toLowerCase().includes(q)
        if (!matchEmail && !matchCid && !matchUser) return false
      }

      // 2. Filter Category
      if (activeFilter === 'running') return p.live_category === 'running'
      if (activeFilter === 'waiting') return p.live_category === 'waiting'
      if (activeFilter === 'other_login') return p.live_category === 'other_login'
      if (activeFilter === 'reconnecting') return p.live_category === 'reconnecting'

      return true
    })
  }, [data, searchQuery, activeFilter])

  const summary = data?.summary || {
    total_active: 0,
    running: 0,
    waiting: 0,
    other_login: 0,
    reconnecting: 0,
    starting: 0,
  }

  if (!firebaseUser || !isSuperAdmin) {
    return null
  }

  return (

    <div className="space-y-6">
        {/* ── Top Bar: Title + Controls ── */}
        <div className="flex sm:flex-row flex-col justify-between sm:items-center gap-3 pb-2 border-slate-200 dark:border-white/10 border-b">
          <div className="flex items-center gap-2.5">
            <div className="bg-emerald-500/10 dark:bg-emerald-500/20 p-2 border border-emerald-500/30 rounded-xl text-emerald-600 dark:text-emerald-400">
              <Activity size={20} className="animate-pulse" />
            </div>
            <div className="flex items-center gap-2">
              <h1 className="font-bold text-slate-900 dark:text-white text-lg sm:text-xl">
                العمليات الحية
              </h1>
              <span className="bg-emerald-500/10 px-2 py-0.5 border border-emerald-500/20 rounded-md font-mono text-emerald-600 dark:text-emerald-400 text-xs">
                {summary.total_active} نشط
              </span>
            </div>
          </div>

          <div className="flex items-center gap-2 shrink-0">
            {/* Auto Refresh Toggle */}
            <button
              onClick={() => setAutoRefresh(!autoRefresh)}
              className={clsx(
                'flex items-center gap-1.5 px-3 py-1.5 border rounded-xl font-bold text-xs transition-colors cursor-pointer',
                autoRefresh
                  ? 'bg-emerald-500/10 text-emerald-700 dark:text-emerald-400 border-emerald-500/30'
                  : 'bg-slate-100 dark:bg-white/5 text-slate-600 dark:text-gray-400 border-slate-200 dark:border-white/10'
              )}
              title="تحديث تلقائي"
            >
              <Radio size={13} className={autoRefresh ? 'animate-pulse text-emerald-500' : ''} />
              <span>تلقائي</span>
            </button>

            {/* Manual Refresh Button */}
            <button
              onClick={() => refetch()}
              disabled={isRefreshing}
              className="flex items-center gap-1.5 bg-slate-100 dark:bg-white/5 disabled:opacity-50 px-3 py-1.5 border border-slate-200 dark:border-white/10 rounded-xl font-bold text-slate-700 dark:text-gray-200 text-xs cursor-pointer"
            >
              <RefreshCw size={13} className={isRefreshing ? 'animate-spin text-emerald-500' : ''} />
              <span>تحديث</span>
            </button>
          </div>
        </div>

        {/* ── Summary Counters (Fast Cards) ── */}
        <div className="gap-2.5 grid grid-cols-2 sm:grid-cols-5">
          {/* Total Active */}
          <div
            onClick={() => setActiveFilter('all')}
            className={clsx(
              'p-3.5 border rounded-xl cursor-pointer select-none',
              activeFilter === 'all'
                ? 'bg-slate-100 text-slate-900 dark:bg-white/10 dark:text-white border-slate-300 dark:border-white/30 shadow-xs'
                : 'bg-white dark:bg-[#0c1410] border-slate-200 dark:border-white/10'
            )}
          >
            <div className="flex justify-between items-center text-slate-500 dark:text-slate-400">
              <span className="font-semibold text-xs">الكل</span>
              <Cpu size={15} />
            </div>
            <div className="mt-1 font-mono font-bold text-xl">{summary.total_active}</div>
          </div>

          {/* Running Now */}
          <div
            onClick={() => setActiveFilter('running')}
            className={clsx(
              'p-3.5 border rounded-xl cursor-pointer select-none',
              activeFilter === 'running'
                ? 'bg-emerald-500/20 text-emerald-700 dark:text-emerald-300 border-emerald-500/40 shadow-xs font-bold'
                : 'bg-white dark:bg-[#0c1410] border-emerald-500/20 text-emerald-600 dark:text-emerald-400'
            )}
          >
            <div className="flex justify-between items-center">
              <span className="font-semibold text-xs">شغال</span>
              <Play size={14} />
            </div>
            <div className="mt-1 font-mono font-bold text-xl">{summary.running}</div>
          </div>

          {/* Waiting for Next Loop */}
          <div
            onClick={() => setActiveFilter('waiting')}
            className={clsx(
              'p-3.5 border rounded-xl cursor-pointer select-none',
              activeFilter === 'waiting'
                ? 'bg-amber-500/20 text-amber-700 dark:text-amber-300 border-amber-500/40 shadow-xs font-bold'
                : 'bg-white dark:bg-[#0c1410] border-amber-500/20 text-amber-600 dark:text-amber-400'
            )}
          >
            <div className="flex justify-between items-center">
              <span className="font-semibold text-xs">انتظار</span>
              <Clock size={14} />
            </div>
            <div className="mt-1 font-mono font-bold text-xl">{summary.waiting}</div>
          </div>

          {/* Other Device Login */}
          <div
            onClick={() => setActiveFilter('other_login')}
            className={clsx(
              'p-3.5 border rounded-xl cursor-pointer select-none',
              activeFilter === 'other_login'
                ? 'bg-rose-500/20 text-rose-700 dark:text-rose-300 border-rose-500/40 shadow-xs font-bold'
                : 'bg-white dark:bg-[#0c1410] border-rose-500/20 text-rose-600 dark:text-rose-400'
            )}
          >
            <div className="flex justify-between items-center">
              <span className="font-semibold text-xs">دخول آخر</span>
              <AlertTriangle size={14} />
            </div>
            <div className="mt-1 font-mono font-bold text-xl">{summary.other_login}</div>
          </div>

          {/* Reconnecting */}
          <div
            onClick={() => setActiveFilter('reconnecting')}
            className={clsx(
              'col-span-2 sm:col-span-1 p-3.5 border rounded-xl cursor-pointer select-none',
              activeFilter === 'reconnecting'
                ? 'bg-blue-500/20 text-blue-700 dark:text-blue-300 border-blue-500/40 shadow-xs font-bold'
                : 'bg-white dark:bg-[#0c1410] border-blue-500/20 text-blue-600 dark:text-blue-400'
            )}
          >
            <div className="flex justify-between items-center">
              <span className="font-semibold text-xs">إعادة اتصال</span>
              <RefreshCw size={14} />
            </div>
            <div className="mt-1 font-mono font-bold text-xl">{summary.reconnecting}</div>
          </div>
        </div>

        {/* ── Search Bar & Filter Tabs ── */}
        <div className="flex sm:flex-row flex-col items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search size={16} className="top-1/2 absolute text-slate-400 -translate-y-1/2 start-3.5" />
            <input
              type="text"
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              placeholder="بحث بالبريد أو المعرف..."
              className="bg-white dark:bg-[#0c1410] py-2.5 ps-10 pe-4 border border-slate-200 focus:border-emerald-500/50 dark:border-white/10 rounded-xl focus:outline-none w-full text-slate-900 dark:text-white placeholder:text-slate-400 text-xs"
            />
          </div>

          {/* Filter Pills */}
          <div className="flex items-center gap-1 pb-1 sm:pb-0 w-full sm:w-auto overflow-x-auto">
            {[
              { id: 'all', label: 'الكل' },
              { id: 'running', label: 'شغال' },
              { id: 'waiting', label: 'انتظار' },
              { id: 'other_login', label: 'دخول آخر' },
              { id: 'reconnecting', label: 'إعادة اتصال' },
            ].map(f => (
              <button
                key={f.id}
                onClick={() => setActiveFilter(f.id as any)}
                className={clsx(
                  'px-3 py-1.5 rounded-lg font-bold text-xs whitespace-nowrap cursor-pointer',
                  activeFilter === f.id
                    ? 'bg-emerald-600 text-white'
                    : 'bg-slate-100 dark:bg-white/5 text-slate-600 dark:text-gray-400'
                )}
              >
                {f.label}
              </button>
            ))}
          </div>
        </div>

        {/* ── Process List ── */}
        {loading && !data ? (
          <div className="flex flex-col justify-center items-center gap-3 py-20 text-emerald-600 dark:text-emerald-400">
            <div className="border-2 border-emerald-500/30 border-t-emerald-500 rounded-full w-8 h-8 animate-spin" />
            <span className="font-mono text-xs">{t('admin.live.loadingThreads')}</span>
          </div>
        ) : filteredProcesses.length === 0 ? (
          <div className="bg-white dark:bg-[#0c1410] p-8 py-16 border border-slate-200 dark:border-white/10 rounded-2xl text-center">
            <Activity size={36} className="mx-auto mb-3 text-slate-300 dark:text-white/20" />
            <h3 className="font-bold text-slate-800 dark:text-white text-sm">{t('admin.live.noMatchTitle')}</h3>
            <p className="mt-1 text-slate-500 dark:text-gray-400 text-xs">
              {data?.processes?.length === 0
                ? t('admin.live.emptyProcesses')
                : t('admin.live.tryChangeFilter')}
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            <div className="flex justify-between items-center px-1 text-slate-500 dark:text-gray-400 text-xs">
              <span>{filteredProcesses.length} من {data?.processes?.length || 0}</span>
            </div>

            <div className="gap-3 grid grid-cols-1">
              {filteredProcesses.map((proc, idx) => {
                const isStopping = stoppingIds.has(proc.castle_id)
                const isOtherLogin = proc.live_category === 'other_login'
                const isWaiting = proc.live_category === 'waiting'
                const isRunning = proc.live_category === 'running'
                const isReconnecting = proc.live_category === 'reconnecting'

                return (
                  <div
                    key={proc.castle_id || idx}
                    className={clsx(
                      'bg-white dark:bg-[#0c1410] shadow-xs p-4 border rounded-xl transition-all',
                      isOtherLogin
                        ? 'border-rose-400/40 dark:border-rose-500/30'
                        : isWaiting
                        ? 'border-amber-400/30 dark:border-amber-500/20'
                        : isReconnecting
                        ? 'border-blue-400/30 dark:border-blue-500/20'
                        : 'border-emerald-500/25 dark:border-emerald-500/20'
                    )}
                  >
                    <div className="flex sm:flex-row flex-col justify-between sm:items-center gap-3">
                      {/* Left: Email, User, Status Badge */}
                      <div className="flex-1 min-w-0">
                        <div className="flex flex-wrap items-center gap-2">
                          {/* Status Indicator Dot */}
                          <span className="relative flex w-2.5 h-2.5">
                            {isRunning && (
                              <span className="inline-flex absolute bg-emerald-400 opacity-75 rounded-full w-full h-full animate-ping" />
                            )}
                            <span
                              className={clsx(
                                'inline-flex relative rounded-full w-2.5 h-2.5',
                                isRunning
                                  ? 'bg-emerald-500'
                                  : isWaiting
                                  ? 'bg-amber-500'
                                  : isOtherLogin
                                  ? 'bg-rose-500'
                                  : isReconnecting
                                  ? 'bg-blue-500'
                                  : 'bg-slate-400'
                              )}
                            />
                          </span>

                          <span className="font-bold text-slate-900 dark:text-white text-sm select-all">
                            {proc.email || proc.castle_id}
                          </span>

                          {/* Runtime Verified IP Badge (المقبس الفعلي الحي) */}
                          {(proc.real_ip || proc.proxy_ip) && (
                            <span
                              title={
                                proc.real_ip_type === 'socks5'
                                  ? t('admin.live.socksBadgeTooltip', { target: proc.socket_peer || proc.real_ip || proc.proxy_ip })
                                  : t('admin.live.directBadgeTooltip', { target: proc.real_ip && proc.real_ip !== 'direct' ? proc.real_ip : t('admin.live.directLabel') })
                              }
                              className={clsx(
                                "inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-md text-[11px] font-mono border font-bold shadow-2xs select-none",
                                (proc.real_ip_type === "direct" || proc.real_ip === "direct" || proc.proxy_ip === "direct")
                                  ? "bg-amber-500/10 text-amber-600 dark:text-amber-400 border-amber-500/25"
                                  : "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-emerald-500/25"
                              )}
                            >
                              {(proc.real_ip_type === "direct" || proc.real_ip === "direct" || proc.proxy_ip === "direct") ? (
                                <>
                                  <span className="text-[10px]">🌐</span>
                                  <span>{proc.real_ip && proc.real_ip !== 'direct' ? proc.real_ip : t('admin.live.directLabel')}</span>
                                  {proc.is_live_socket && (
                                    <span className="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse" title={t('admin.live.liveDirectSocketTitle')} />
                                  )}
                                </>
                              ) : (
                                <>
                                  <span className="text-[10px]">🛡️</span>
                                  <span>{proc.real_ip || proc.proxy_ip}</span>
                                  {proc.is_live_socket && (
                                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" title={t('admin.live.liveSocksSocketTitle')} />
                                  )}
                                </>
                              )}
                            </span>
                          )}



                          {/* Live Category Badge */}
                          <span
                            className={clsx(
                              'px-2 py-0.5 border rounded-md font-bold text-[11px]',
                              isRunning
                                ? 'bg-emerald-500/10 text-emerald-700 dark:text-emerald-400 border-emerald-500/30'
                                : isWaiting
                                ? 'bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/30'
                                : isOtherLogin
                                ? 'bg-rose-500/10 text-rose-700 dark:text-rose-400 border-rose-500/30 animate-pulse'
                                : isReconnecting
                                ? 'bg-blue-500/10 text-blue-700 dark:text-blue-400 border-blue-500/30'
                                : 'bg-slate-100 dark:bg-white/5 text-slate-600 dark:text-gray-400 border-slate-200 dark:border-white/10'
                            )}
                          >
                            {proc.category_label || proc.state}
                          </span>

                          {/* Iteration Badge */}
                          {proc.iteration > 0 && (
                            <span className="bg-slate-100 dark:bg-white/5 px-2 py-0.5 border border-slate-200 dark:border-white/10 rounded-md font-mono text-[11px] text-slate-700 dark:text-gray-300">
                              {t('admin.live.iteration', { num: proc.iteration })}
                            </span>
                          )}

                          {/* Thread ID */}
                          {proc.thread_id && (
                            <span className="font-mono text-[10px] text-slate-400 dark:text-gray-500">
                              Thread #{proc.thread_id}
                            </span>
                          )}
                        </div>

                        {/* Owner / Account info */}
                        {(proc.user_email || proc.user_id) && (
                          <div className="flex items-center gap-1.5 mt-1.5 text-[11px] text-slate-500 dark:text-gray-400">
                            <User size={12} className="shrink-0" />
                            <span className="font-mono text-slate-700 dark:text-gray-300 select-all">
                              {proc.user_email || proc.user_id}
                            </span>
                            <span className="text-slate-300 dark:text-white/10">•</span>
                            <span className="font-mono text-[10px] text-slate-400 dark:text-gray-500 select-all">
                              ID: {proc.castle_id?.slice(0, 12)}
                            </span>
                          </div>
                        )}
                      </div>

                      {/* Right: Runtime Counters + Stop Action */}
                      <div className="flex sm:flex-col justify-between items-center sm:items-end gap-2 pt-2 sm:pt-0 border-slate-100 dark:border-white/5 border-t sm:border-t-0 shrink-0">
                        <div className="text-start sm:text-end">
                          <div className="text-[10px] text-slate-400">المدة</div>
                          <div className="font-mono font-bold text-slate-800 dark:text-gray-200 text-xs">
                            {formatUptime(proc.uptime_seconds)}
                          </div>
                        </div>

                        {/* Stop Action Button */}
                        <button
                          onClick={() => handleStopProcess(proc.castle_id, proc.email)}
                          disabled={isStopping}
                          className="flex items-center gap-1 bg-rose-50 dark:bg-rose-500/15 disabled:opacity-50 shadow-xs px-3 py-1.5 border border-rose-200 dark:border-rose-500/30 rounded-lg font-bold text-rose-600 dark:text-rose-400 text-xs active:scale-95 cursor-pointer"
                        >
                          <StopCircle size={14} className={isStopping ? 'animate-spin' : ''} />
                          <span>{isStopping ? 'جاري...' : 'إيقاف'}</span>
                        </button>
                      </div>
                    </div>

                    {/* Prominent Alert Box for other device login */}
                    {isOtherLogin && (
                      <div className="flex justify-between items-center gap-2 bg-rose-50 dark:bg-rose-500/10 mt-3 p-2.5 border border-rose-200 dark:border-rose-500/30 rounded-lg text-rose-800 dark:text-rose-300 text-xs">
                        <div className="flex items-center gap-2">
                          <AlertTriangle size={15} className="text-rose-600 dark:text-rose-400 shrink-0" />
                          <span>
                            <strong>تنبيه:</strong> {proc.last_kick_reason ? `فصل (${proc.last_kick_reason})` : 'دخول من جهاز آخر، بانتظار إعادة المحاولة'}
                          </span>
                        </div>
                        {proc.reconnect_attempt > 0 && (
                          <span className="bg-rose-200/60 dark:bg-rose-500/20 px-2 py-0.5 rounded font-mono font-bold text-[11px] text-rose-900 dark:text-rose-200 shrink-0">
                            {proc.reconnect_attempt} / {proc.max_reconnect_attempts}
                          </span>
                        )}
                      </div>
                    )}
                  </div>
                )
              })}
            </div>
          </div>
        )}
      </div>
  )
}

export function AdminLiveProcessesPage() {
  const { t } = useTranslation()
  return (
    <AdminLayout title={t('admin.live.title')}>
      <AdminLiveProcessesView isActive={true} />
    </AdminLayout>
  )
}

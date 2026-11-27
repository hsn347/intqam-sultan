import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { createPortal } from 'react-dom'
import { useTranslation } from 'react-i18next'
import {
  Activity, RefreshCw, Search, AlertTriangle,
  Play, Clock, Cpu, User, StopCircle, X, Loader2
} from 'lucide-react'
import { clsx } from 'clsx'
import { AdminLayout } from '../components/layout/AdminLayout'
import { useQueryClient } from '@tanstack/react-query'
import {
  getAdminLiveProcesses,
  getWsBaseUrl,
  getWsAuthQuery,
  stopBot,
  stopAllBotsAdmin,
  startEligibleBotsGradualAdmin,
  cancelGradualStartAdmin,
  type LiveProcessesResponse,
} from '../lib/botApi'
import { useAuth } from '../hooks/useAuth'
import toast from 'react-hot-toast'

type LiveFilterCategory = 'all' | 'running' | 'waiting' | 'starting' | 'other_login' | 'reconnecting'

type ConfirmActionState =
  | { mode: 'single'; castleId: string; targetLabel: string }
  | { mode: 'all'; count: number }
  | { mode: 'start_eligible'; count: number }

function formatNextRunShort(iso: string | null | undefined): string {
  if (!iso) return ''
  const dt = new Date(iso)
  if (isNaN(dt.getTime())) return ''
  return `${String(dt.getHours()).padStart(2, '0')}:${String(dt.getMinutes()).padStart(2, '0')}`
}

function LiveActionConfirmModal({
  state,
  isPending,
  onClose,
  onConfirm,
}: {
  state: ConfirmActionState | null
  isPending: boolean
  onClose: () => void
  onConfirm: () => void
}) {
  const { t } = useTranslation()

  useEffect(() => {
    if (!state) return
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && !isPending) onClose()
    }
    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [state, isPending, onClose])

  if (!state || typeof document === 'undefined') return null

  const isAll = state.mode === 'all'
  const isStartEligible = state.mode === 'start_eligible'

  return createPortal(
    <div
      className="z-[100] fixed inset-0 flex justify-center items-center p-3 sm:p-4 overflow-y-auto"
      onClick={() => !isPending && onClose()}
    >
      <div className="fixed inset-0 bg-black/70" />
      <div
        onClick={e => e.stopPropagation()}
        className="z-10 relative bg-white dark:bg-[#0c1410] shadow-2xl border border-gray-200 dark:border-white/10 rounded-2xl w-full max-w-xs sm:max-w-sm overflow-hidden text-gray-900 dark:text-gray-100 admin-modal"
      >
        <div className={clsx('w-full h-1', isStartEligible ? 'bg-emerald-500' : 'bg-rose-500')} />
        <div className="space-y-4 p-4 sm:p-5">
          <div className="flex flex-col items-center gap-2 text-center">
            <div
              className={clsx(
                'flex justify-center items-center border rounded-2xl w-11 h-11',
                isStartEligible
                  ? 'bg-emerald-500/10 border-emerald-500/25 text-emerald-500'
                  : 'bg-rose-500/10 border-rose-500/25 text-rose-500'
              )}
            >
              {isStartEligible ? <Play size={22} /> : <StopCircle size={22} />}
            </div>
            <h3 className="font-bold text-gray-900 dark:text-white text-base">
              {isStartEligible
                ? t('admin.live.startEligibleTitle')
                : isAll
                ? t('admin.live.stopAllTitle')
                : t('admin.live.stopTitle')}
            </h3>
            <p className="text-gray-500 dark:text-gray-400 text-xs leading-relaxed">
              {isStartEligible
                ? t('admin.live.startEligibleDesc', { count: state.count })
                : isAll
                ? t('admin.live.stopAllDesc', { count: state.count })
                : t('admin.live.stopProcessDesc')}
            </p>
          </div>

          {state.mode === 'single' && (
            <div className="bg-gray-50 dark:bg-white/[0.03] px-3 py-2 border border-gray-200 dark:border-white/8 rounded-xl text-center">
              <span className="block font-mono text-gray-800 dark:text-gray-200 text-xs truncate select-all">
                {state.targetLabel}
              </span>
            </div>
          )}

          <div className="flex gap-2 pt-1">
            <button
              type="button"
              onClick={onClose}
              disabled={isPending}
              className="flex-1 py-2.5 border border-gray-200 dark:border-white/10 rounded-xl font-semibold text-gray-700 dark:text-gray-300 text-xs sm:text-sm cursor-pointer disabled:opacity-50"
            >
              {t('common.cancel')}
            </button>
            <button
              type="button"
              onClick={onConfirm}
              disabled={isPending}
              className={clsx(
                'flex flex-1 justify-center items-center gap-1.5 disabled:opacity-50 shadow-sm py-2.5 rounded-xl font-bold text-white text-xs sm:text-sm active:scale-[0.98] cursor-pointer',
                isStartEligible ? 'bg-emerald-600' : 'bg-rose-600'
              )}
            >
              {isPending ? (
                <>
                  <Loader2 size={14} className="animate-spin" />
                  <span>{isStartEligible ? t('admin.live.startingEligible') : t('admin.live.stopping')}</span>
                </>
              ) : isStartEligible ? (
                <>
                  <Play size={14} />
                  <span>{t('admin.live.startEligibleConfirm')}</span>
                </>
              ) : (
                <>
                  <StopCircle size={14} />
                  <span>{isAll ? t('admin.live.stopAllBtn') : t('admin.live.stopProcess')}</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>,
    document.body
  )
}

export function AdminLiveProcessesView({ isActive = true }: { isActive?: boolean }) {
  const { t } = useTranslation()
  const { firebaseUser, isSuperAdmin } = useAuth()
  const qc = useQueryClient()
  const [data, setData] = useState<LiveProcessesResponse | null>(null)
  const [loading, setLoading] = useState(true)
  const [isError, setIsError] = useState(false)
  const [wsConnected, setWsConnected] = useState(false)
  const [isTabVisible, setIsTabVisible] = useState<boolean>(
    () => (typeof document === 'undefined' ? true : document.visibilityState === 'visible')
  )
  const [nowSec, setNowSec] = useState<number>(() => Math.floor(Date.now() / 1000))
  const [searchQuery, setSearchQuery] = useState('')
  const [activeFilter, setActiveFilter] = useState<LiveFilterCategory>('all')
  const [stoppingIds, setStoppingIds] = useState<Set<string>>(new Set())
  const [stoppingAll, setStoppingAll] = useState(false)
  const [startingEligible, setStartingEligible] = useState(false)
  const [cancellingGradual, setCancellingGradual] = useState(false)
  const [confirmState, setConfirmState] = useState<ConfirmActionState | null>(null)
  const wsRef = useRef<WebSocket | null>(null)
  const hasDataRef = useRef(false)

  useEffect(() => {
    if (typeof document === 'undefined') return
    const onVis = () => setIsTabVisible(document.visibilityState === 'visible')
    document.addEventListener('visibilitychange', onVis)
    return () => document.removeEventListener('visibilitychange', onVis)
  }, [])

  const fetchSnapshotFallback = useCallback(async () => {
    try {
      const snap = await getAdminLiveProcesses()
      hasDataRef.current = true
      setData(snap)
      setIsError(false)
      setLoading(false)
    } catch {
      setIsError(true)
      setLoading(false)
    }
  }, [])

  const triggerInstantRefresh = useCallback(async () => {
    const ws = wsRef.current
    if (ws && ws.readyState === WebSocket.OPEN) {
      try {
        ws.send('refresh')
        return
      } catch {
        // fallback below
      }
    }
    await fetchSnapshotFallback()
  }, [fetchSnapshotFallback])

  // اتصال WebSocket لحظي خفيف يعمل فقط عند فتح التبويب ورؤيته؛ يُغلق تلقائياً في الخلفية
  useEffect(() => {
    if (!isActive || !isTabVisible || !firebaseUser || !isSuperAdmin) {
      wsRef.current?.close()
      wsRef.current = null
      setWsConnected(false)
      return
    }

    const WS_BASE = getWsBaseUrl()
    let destroyed = false
    let reconnectTimer: ReturnType<typeof setTimeout> | null = null

    function connect() {
      if (destroyed) return
      void (async () => {
        try {
          const authQuery = await getWsAuthQuery()
          if (destroyed) return
          const ws = new WebSocket(`${WS_BASE}/ws/admin/live-processes${authQuery}`)
          wsRef.current = ws

          ws.onopen = () => {
            if (!destroyed) {
              setWsConnected(true)
              setIsError(false)
            }
          }

          ws.onmessage = (e) => {
            if (destroyed || !e.data) return
            try {
              const parsed = JSON.parse(e.data)
              if (parsed?.type === 'ping') return
              if (parsed && Array.isArray(parsed.processes)) {
                hasDataRef.current = true
                setData(parsed as LiveProcessesResponse)
                setLoading(false)
                setIsError(false)
              }
            } catch {
              // ignore malformed frames
            }
          }

          ws.onclose = (ev) => {
            if (wsRef.current === ws) wsRef.current = null
            if (!destroyed) {
              setWsConnected(false)
              if (!hasDataRef.current) {
                void fetchSnapshotFallback()
              }
              reconnectTimer = setTimeout(connect, ev.code === 1008 ? 15000 : 2500)
            }
          }

          ws.onerror = () => {
            ws.close()
          }
        } catch {
          if (!destroyed) {
            setWsConnected(false)
            void fetchSnapshotFallback()
            reconnectTimer = setTimeout(connect, 3000)
          }
        }
      })()
    }

    connect()

    return () => {
      destroyed = true
      if (reconnectTimer) clearTimeout(reconnectTimer)
      wsRef.current?.close()
      wsRef.current = null
      setWsConnected(false)
    }
  }, [isActive, isTabVisible, firebaseUser, isSuperAdmin, fetchSnapshotFallback])

  // تحديث محلي خفيف لمدة التشغيل (uptime) كل 5 ثوانٍ دون أي اتصال بالسيرفر
  useEffect(() => {
    if (!isActive || !isTabVisible || !data?.processes?.length) return
    setNowSec(Math.floor(Date.now() / 1000))
    const timer = window.setInterval(() => {
      setNowSec(Math.floor(Date.now() / 1000))
    }, 5000)
    return () => window.clearInterval(timer)
  }, [isActive, isTabVisible, data?.processes?.length])

  const invalidateLiveCaches = () => {
    qc.invalidateQueries({ queryKey: ['admin_stats'] })
    qc.invalidateQueries({ queryKey: ['admin_users'] })
    qc.invalidateQueries({ queryKey: ['admin_users_castles'] })
    qc.invalidateQueries({ queryKey: ['castles'] })
  }

  const handleCancelGradual = async () => {
    setCancellingGradual(true)
    try {
      await cancelGradualStartAdmin()
      toast.success(t('admin.live.cancelGradualSuccess'))
      invalidateLiveCaches()
      await triggerInstantRefresh()
    } catch (err: any) {
      toast.error(t('admin.live.startEligibleError', { error: err?.message || t('common.error') }))
    } finally {
      setCancellingGradual(false)
    }
  }

  const handleConfirmAction = async () => {
    if (!confirmState) return

    if (confirmState.mode === 'start_eligible') {
      setStartingEligible(true)
      try {
        const res = await startEligibleBotsGradualAdmin()
        if (res.status === 'started') {
          toast.success(t('admin.live.startEligibleStarted', { count: res.total ?? confirmState.count }))
        } else if (res.status === 'already_running') {
          toast(t('admin.live.startEligibleAlreadyRunning'))
        } else {
          toast(t('admin.live.startEligibleEmpty'))
        }
        setConfirmState(null)
        invalidateLiveCaches()
        await triggerInstantRefresh()
      } catch (err: any) {
        toast.error(t('admin.live.startEligibleError', { error: err?.message || t('common.error') }))
      } finally {
        setStartingEligible(false)
      }
      return
    }

    if (confirmState.mode === 'all') {
      setStoppingAll(true)
      try {
        await stopAllBotsAdmin()
        toast.success(t('admin.live.stopAllSuccess'))
        setConfirmState(null)
        invalidateLiveCaches()
        await triggerInstantRefresh()
      } catch (err: any) {
        toast.error(t('admin.live.stopError', { error: err?.message || t('common.error') }))
      } finally {
        setStoppingAll(false)
      }
      return
    }

    const { castleId, targetLabel } = confirmState
    setStoppingIds(prev => new Set(prev).add(castleId))
    try {
      await stopBot(castleId)
      toast.success(t('admin.live.stopSuccess', { target: targetLabel }))
      setConfirmState(null)
      invalidateLiveCaches()
      await triggerInstantRefresh()
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

  const formatUptime = (sec: number) => {
    if (!sec || sec < 0) return `0 ${t('common.seconds')}`
    const h = Math.floor(sec / 3600)
    const m = Math.floor((sec % 3600) / 60)
    const s = sec % 60
    if (h > 0) return `${h} ${t('common.hours')} ${m} ${t('common.minutes')}`
    if (m > 0) return `${m} ${t('common.minutes')}`
    return `${s} ${t('common.seconds')}`
  }

  const getCategoryLabel = (category: string, fallbackState: string) => {
    if (category === 'running') return t('admin.live.filterRunning')
    if (category === 'waiting') return t('admin.live.filterWaiting')
    if (category === 'starting') return t('admin.live.filterStarting')
    if (category === 'other_login') return t('admin.live.filterOtherLogin')
    if (category === 'reconnecting') return t('admin.live.filterReconnecting')
    return fallbackState
  }

  const filteredProcesses = useMemo(() => {
    if (!data?.processes) return []
    const q = searchQuery.toLowerCase().trim()
    return data.processes.filter(p => {
      if (activeFilter !== 'all' && p.live_category !== activeFilter) {
        return false
      }
      if (!q) return true
      return (
        (p.email || '').toLowerCase().includes(q) ||
        (p.castle_id || '').toLowerCase().includes(q) ||
        (p.castle_name || '').toLowerCase().includes(q) ||
        (p.lord_name || '').toLowerCase().includes(q) ||
        (p.user_email || '').toLowerCase().includes(q) ||
        (p.owner_name || '').toLowerCase().includes(q) ||
        (p.user_id || '').toLowerCase().includes(q) ||
        (p.real_ip || '').toLowerCase().includes(q) ||
        (p.proxy_ip || '').toLowerCase().includes(q) ||
        (p.status_message || '').toLowerCase().includes(q)
      )
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

  const eligibleIdleCount = Number(data?.eligible_idle_count ?? 0)
  const gradualStartup = data?.gradual_startup || {
    running: false,
    total: 0,
    started: 0,
    skipped: 0,
    remaining: 0,
  }

  if (!firebaseUser || !isSuperAdmin) {
    return null
  }

  const summaryCards: Array<{
    id: LiveFilterCategory
    label: string
    count: number
    icon: React.ReactNode
    valueClass: string
    activeBoxClass: string
  }> = [
    {
      id: 'all',
      label: t('admin.live.allFilter'),
      count: summary.total_active,
      icon: <Cpu size={14} />,
      valueClass: 'text-slate-900 dark:text-white',
      activeBoxClass: 'border-slate-400/70 dark:border-white/30 bg-slate-100/80 dark:bg-white/10',
    },
    {
      id: 'running',
      label: t('admin.live.filterRunning'),
      count: summary.running,
      icon: <Play size={14} />,
      valueClass: 'text-emerald-600 dark:text-emerald-400',
      activeBoxClass: 'border-emerald-500/50 bg-emerald-500/10',
    },
    {
      id: 'waiting',
      label: t('admin.live.filterWaiting'),
      count: summary.waiting,
      icon: <Clock size={14} />,
      valueClass: 'text-amber-600 dark:text-amber-400',
      activeBoxClass: 'border-amber-500/50 bg-amber-500/10',
    },
    {
      id: 'starting',
      label: t('admin.live.filterStarting'),
      count: summary.starting,
      icon: <Loader2 size={14} />,
      valueClass: 'text-slate-700 dark:text-slate-300',
      activeBoxClass: 'border-emerald-500/40 bg-emerald-500/10',
    },
    {
      id: 'other_login',
      label: t('admin.live.filterOtherLogin'),
      count: summary.other_login,
      icon: <AlertTriangle size={14} />,
      valueClass: 'text-rose-600 dark:text-rose-400',
      activeBoxClass: 'border-rose-500/50 bg-rose-500/10',
    },
    {
      id: 'reconnecting',
      label: t('admin.live.filterReconnecting'),
      count: summary.reconnecting,
      icon: <RefreshCw size={14} />,
      valueClass: 'text-blue-600 dark:text-blue-400',
      activeBoxClass: 'border-blue-500/50 bg-blue-500/10',
    },
  ]

  return (
    <div className="space-y-4">
      {/* ── Top Bar: Title + Controls ── */}
      <div className="flex flex-wrap justify-between items-center gap-3 pb-3 border-slate-200 dark:border-white/10 border-b">
        <div className="flex items-center gap-2.5">
          <div className="bg-emerald-500/10 dark:bg-emerald-500/15 p-2 border border-emerald-500/25 rounded-xl text-emerald-600 dark:text-emerald-400">
            <Activity size={19} />
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <h1 className="font-bold text-slate-900 dark:text-white text-lg sm:text-xl">
              {t('admin.live.title')}
            </h1>
            <span className="bg-emerald-500/10 px-2 py-0.5 border border-emerald-500/25 rounded-md font-mono font-semibold text-emerald-600 dark:text-emerald-400 text-xs">
              {t('admin.live.activeCount', { count: summary.total_active })}
            </span>
            <span
              className={clsx(
                'inline-flex items-center gap-1.5 px-2 py-0.5 border rounded-md font-semibold text-[11px]',
                wsConnected
                  ? 'bg-emerald-500/10 text-emerald-700 dark:text-emerald-400 border-emerald-500/25'
                  : 'bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/25'
              )}
            >
              <span
                className={clsx(
                  'rounded-full w-1.5 h-1.5',
                  wsConnected ? 'bg-emerald-500' : 'bg-amber-500'
                )}
              />
              <span>{wsConnected ? t('admin.live.liveBadge') : t('admin.live.connectingBadge')}</span>
            </span>
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-2 shrink-0">
          {gradualStartup.running ? (
            <button
              type="button"
              onClick={handleCancelGradual}
              disabled={cancellingGradual}
              className="flex items-center gap-1.5 bg-amber-500/15 disabled:opacity-50 px-3 py-1.5 border border-amber-500/35 rounded-xl font-bold text-amber-700 dark:text-amber-300 text-xs active:scale-95 cursor-pointer"
              title={t('admin.live.cancelGradualBtn')}
            >
              <Loader2 size={13} className="animate-spin" />
              <span>
                {t('admin.live.gradualProgress', {
                  started: gradualStartup.started,
                  total: gradualStartup.total,
                })}
              </span>
              <span className="ms-0.5 text-amber-800 dark:text-amber-200 underline">
                {t('admin.live.cancelGradualBtn')}
              </span>
            </button>
          ) : (
            <button
              type="button"
              onClick={() => setConfirmState({ mode: 'start_eligible', count: eligibleIdleCount })}
              disabled={startingEligible || eligibleIdleCount === 0}
              className="flex items-center gap-1.5 bg-emerald-600 disabled:opacity-45 shadow-xs px-3 py-1.5 rounded-xl font-bold text-white text-xs active:scale-95 cursor-pointer disabled:cursor-not-allowed"
            >
              <Play size={13} />
              <span>{t('admin.live.startEligibleBtn', { count: eligibleIdleCount })}</span>
            </button>
          )}

          {summary.total_active > 0 && (
            <button
              type="button"
              onClick={() => setConfirmState({ mode: 'all', count: summary.total_active })}
              disabled={stoppingAll}
              className="flex items-center gap-1.5 bg-rose-600 disabled:opacity-50 shadow-xs px-3 py-1.5 rounded-xl font-bold text-white text-xs active:scale-95 cursor-pointer"
            >
              <StopCircle size={13} />
              <span>{stoppingAll ? t('admin.live.stoppingAll') : t('admin.live.stopAllBtn')}</span>
            </button>
          )}
        </div>
      </div>

      {/* ── Single Clean Summary Filter Grid ── */}
      <div className="gap-2.5 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6">
        {summaryCards.map(card => {
          const isSelected = activeFilter === card.id
          return (
            <button
              key={card.id}
              type="button"
              onClick={() => setActiveFilter(prev => (card.id === 'all' ? 'all' : (prev === card.id ? 'all' : card.id)))}
              className={clsx(
                'admin-stat-card flex flex-col justify-between p-3 border rounded-xl text-start cursor-pointer active:scale-[0.99] select-none',
                isSelected
                  ? `is-active ${card.activeBoxClass}`
                  : 'bg-white dark:bg-[#0c1410] border-slate-200 dark:border-white/10'
              )}
            >
              <div className={clsx('flex justify-between items-center gap-1.5 text-xs font-semibold', card.valueClass)}>
                <span className="truncate">{card.label}</span>
                {card.icon}
              </div>
              <div className={clsx('mt-1 font-mono font-black text-xl', card.valueClass)}>
                {card.count}
              </div>
            </button>
          )
        })}
      </div>

      {/* ── Clean Search Bar ── */}
      <div className="relative w-full">
        <Search size={15} className="top-1/2 z-10 absolute text-slate-400 -translate-y-1/2 pointer-events-none start-3.5" />
        <input
          id="live-processes-search"
          name="live_processes_filter"
          type="text"
          dir="auto"
          autoComplete="off"
          autoCorrect="off"
          autoCapitalize="none"
          spellCheck={false}
          value={searchQuery}
          onChange={e => setSearchQuery(e.target.value)}
          placeholder={t('admin.live.searchPlaceholder')}
          className="admin-search-input shadow-xs py-2 rounded-xl outline-none w-full min-h-[42px] sm:min-h-[38px] text-base sm:text-sm"
          style={{ paddingInlineStart: '2.5rem', paddingInlineEnd: '2.5rem' }}
        />
        {searchQuery && (
          <button
            type="button"
            onClick={() => setSearchQuery('')}
            className="top-1/2 z-10 absolute flex justify-center items-center w-7 h-7 text-slate-400 -translate-y-1/2 cursor-pointer end-2.5"
            aria-label={t('accounts.clearSearch')}
            title={t('accounts.clearSearch')}
          >
            <X size={14} />
          </button>
        )}
      </div>

      {/* ── Process List ── */}
      {isError && !data ? (
        <div className="flex flex-col items-center gap-2.5 bg-white dark:bg-[#0c1410] p-6 border border-rose-200 dark:border-rose-500/30 rounded-2xl text-center">
          <AlertTriangle size={28} className="text-rose-500" />
          <p className="font-semibold text-slate-800 dark:text-slate-200 text-sm">
            {t('admin.live.fetchError')}
          </p>
          <button
            type="button"
            onClick={() => void fetchSnapshotFallback()}
            className="bg-emerald-600 px-3.5 py-1.5 rounded-xl font-bold text-white text-xs cursor-pointer"
          >
            {t('admin.live.retryBtn')}
          </button>
        </div>
      ) : loading && !data ? (
        <div className="flex flex-col justify-center items-center gap-3 py-16 text-emerald-600 dark:text-emerald-400">
          <div className="border-2 border-emerald-500/30 border-t-emerald-500 rounded-full w-7 h-7 animate-spin" />
          <span className="font-mono text-xs">{t('admin.live.loadingThreads')}</span>
        </div>
      ) : filteredProcesses.length === 0 ? (
        <div className="flex flex-col items-center gap-2 bg-white dark:bg-[#0c1410] p-8 py-14 border border-slate-200 dark:border-white/10 rounded-2xl text-center admin-card">
          <Activity size={32} className="text-slate-300 dark:text-white/20" />
          <h3 className="font-bold text-slate-800 dark:text-white text-sm">{t('admin.live.noMatchTitle')}</h3>
          <p className="text-slate-500 dark:text-gray-400 text-xs">
            {data?.processes?.length === 0
              ? t('admin.live.emptyProcesses')
              : t('admin.live.tryChangeFilter')}
          </p>
          {(searchQuery || activeFilter !== 'all') && (data?.processes?.length ?? 0) > 0 && (
            <button
              type="button"
              onClick={() => {
                setSearchQuery('')
                setActiveFilter('all')
              }}
              className="bg-emerald-500/10 mt-1 px-3 py-1.5 border border-emerald-500/25 rounded-lg font-semibold text-emerald-600 dark:text-emerald-400 text-xs cursor-pointer"
            >
              {t('admin.live.clearAndShowAll')}
            </button>
          )}
        </div>
      ) : (
        <div className="space-y-2.5">
          <div className="flex justify-between items-center px-1 text-slate-500 dark:text-gray-400 text-xs">
            <span>{t('admin.live.showingCount', { count: filteredProcesses.length, total: data?.processes?.length || 0 })}</span>
          </div>

          <div className="space-y-2.5">
            {filteredProcesses.map((proc, idx) => {
              const isStopping = stoppingIds.has(proc.castle_id)
              const isOtherLogin = proc.live_category === 'other_login'
              const isWaiting = proc.live_category === 'waiting'
              const isRunning = proc.live_category === 'running'
              const isReconnecting = proc.live_category === 'reconnecting'
              const isDirect = proc.real_ip_type === 'direct' || proc.real_ip === 'direct' || proc.proxy_ip === 'direct'
              const displayTitle = proc.lord_name || proc.castle_name || proc.email || proc.castle_id
              const showSecondaryEmail = Boolean((proc.lord_name || proc.castle_name) && proc.email)
              const ownerDisplay = proc.owner_name && proc.user_email
                ? `${proc.owner_name} (${proc.user_email})`
                : (proc.user_email || proc.owner_name || proc.user_id)
              const nextTime = isWaiting ? formatNextRunShort(proc.next_run_time) : ''

              return (
                <div
                  key={proc.castle_id || idx}
                  className={clsx(
                    'bg-white dark:bg-[#0c1410] shadow-xs px-3.5 py-3 border rounded-xl admin-card',
                    isOtherLogin
                      ? 'border-rose-400/50 dark:border-rose-500/35'
                      : isWaiting
                      ? 'border-amber-400/35 dark:border-amber-500/25'
                      : isReconnecting
                      ? 'border-blue-400/35 dark:border-blue-500/25'
                      : 'border-slate-200 dark:border-white/10'
                  )}
                >
                  <div className="flex sm:flex-row flex-col justify-between sm:items-center gap-2.5">
                    {/* Left: Main identity + status + owner */}
                    <div className="flex-1 min-w-0">
                      <div className="flex flex-wrap items-center gap-2">
                        <span
                          className={clsx(
                            'rounded-full w-2 h-2 shrink-0',
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

                        <span className="font-bold text-slate-900 dark:text-white text-sm truncate">
                          {displayTitle}
                        </span>

                        {showSecondaryEmail && (
                          <span className="font-mono text-slate-500 dark:text-slate-400 text-xs truncate select-all">
                            {proc.email}
                          </span>
                        )}

                        <span
                          className={clsx(
                            'px-2 py-0.5 border rounded-md font-bold text-[11px]',
                            isRunning
                              ? 'bg-emerald-500/10 text-emerald-700 dark:text-emerald-400 border-emerald-500/30'
                              : isWaiting
                              ? 'bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/30'
                              : isOtherLogin
                              ? 'bg-rose-500/10 text-rose-700 dark:text-rose-400 border-rose-500/30'
                              : isReconnecting
                              ? 'bg-blue-500/10 text-blue-700 dark:text-blue-400 border-blue-500/30'
                              : 'bg-slate-100 dark:bg-white/5 text-slate-600 dark:text-gray-300 border-slate-200 dark:border-white/10'
                          )}
                        >
                          {getCategoryLabel(proc.live_category, proc.state)}
                        </span>

                        {(proc.real_ip || proc.proxy_ip) && (
                          <span
                            title={
                              isDirect
                                ? t('admin.live.directBadgeTooltip', { target: proc.real_ip && proc.real_ip !== 'direct' ? proc.real_ip : t('admin.live.directLabel') })
                                : t('admin.live.socksBadgeTooltip', { target: proc.socket_peer || proc.real_ip || proc.proxy_ip })
                            }
                            className={clsx(
                              'inline-flex items-center gap-1 px-2 py-0.5 rounded-md font-mono font-semibold text-[11px] border',
                              isDirect
                                ? 'bg-amber-500/10 text-amber-700 dark:text-amber-400 border-amber-500/25'
                                : 'bg-emerald-500/10 text-emerald-700 dark:text-emerald-400 border-emerald-500/25'
                            )}
                          >
                            <span>{isDirect ? '🌐' : '🛡️'}</span>
                            <span>{isDirect ? (proc.real_ip && proc.real_ip !== 'direct' ? proc.real_ip : t('admin.live.directLabel')) : (proc.real_ip || proc.proxy_ip)}</span>
                          </span>
                        )}
                      </div>

                      {/* Concise second line: owner + current status message */}
                      <div className="flex flex-wrap items-center gap-x-2.5 gap-y-1 mt-1.5 text-xs text-slate-500 dark:text-slate-400">
                        {ownerDisplay && (
                          <span className="inline-flex items-center gap-1 max-w-full truncate">
                            <User size={12} className="shrink-0" />
                            <span className="font-mono text-slate-700 dark:text-slate-300 truncate">{ownerDisplay}</span>
                          </span>
                        )}
                        {isOtherLogin ? (
                          <span className="font-medium text-rose-600 dark:text-rose-400 truncate">
                            {proc.last_kick_reason
                              ? t('admin.live.disconnectedReason', { reason: proc.last_kick_reason })
                              : t('admin.live.otherLoginMsg')}
                            {proc.reconnect_attempt > 0 && (
                              <span className="ms-1.5 font-mono font-bold">
                                ({t('admin.live.attemptCount', { attempt: proc.reconnect_attempt, max: proc.max_reconnect_attempts || 2 })})
                              </span>
                            )}
                          </span>
                        ) : proc.status_message ? (
                          <span className="text-slate-600 dark:text-slate-300 truncate">
                            {proc.status_message}
                          </span>
                        ) : null}
                      </div>
                    </div>

                    {/* Right: Duration + Next Cycle + Stop */}
                    <div className="flex justify-between sm:justify-end items-center gap-3 pt-2 sm:pt-0 border-slate-100 dark:border-white/5 border-t sm:border-t-0 shrink-0">
                      <div className="text-start sm:text-end">
                        <div className="font-mono font-bold text-slate-800 dark:text-gray-200 text-xs">
                          {formatUptime(
                            proc.start_time && proc.start_time > 0
                              ? Math.max(proc.uptime_seconds || 0, Math.floor(nowSec - proc.start_time))
                              : proc.uptime_seconds
                          )}
                          {proc.iteration > 0 && (
                            <span className="ms-1.5 font-normal text-[11px] text-slate-500 dark:text-slate-400">
                              · {t('admin.live.iteration', { num: proc.iteration })}
                            </span>
                          )}
                        </div>
                        {nextTime && (
                          <div className="font-mono text-[11px] text-amber-600 dark:text-amber-400" dir="ltr">
                            {t('admin.live.nextCycleAt', { time: nextTime })}
                          </div>
                        )}
                      </div>

                      <button
                        type="button"
                        onClick={() =>
                          setConfirmState({
                            mode: 'single',
                            castleId: proc.castle_id,
                            targetLabel: proc.email || displayTitle,
                          })
                        }
                        disabled={isStopping}
                        className="flex items-center gap-1.5 bg-rose-50 dark:bg-rose-500/15 disabled:opacity-50 px-3 py-1.5 border border-rose-200 dark:border-rose-500/30 rounded-lg font-bold text-rose-600 dark:text-rose-400 text-xs active:scale-95 cursor-pointer shrink-0"
                      >
                        <StopCircle size={14} className={isStopping ? 'animate-spin' : ''} />
                        <span>{isStopping ? t('admin.live.stopping') : t('admin.live.stopProcess')}</span>
                      </button>
                    </div>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      )}

      <LiveActionConfirmModal
        state={confirmState}
        isPending={
          confirmState?.mode === 'start_eligible'
            ? startingEligible
            : confirmState?.mode === 'all'
            ? stoppingAll
            : Boolean(confirmState && stoppingIds.has(confirmState.castleId))
        }
        onClose={() => setConfirmState(null)}
        onConfirm={handleConfirmAction}
      />
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

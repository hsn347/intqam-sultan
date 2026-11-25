import React, { useState, useEffect } from 'react'
import { AdminLayout } from '../components/layout/AdminLayout'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import {
  ShieldCheck, Globe, RefreshCw, Zap, CheckCircle2,
  XCircle, Server, ChevronDown, ChevronUp,
  ArrowRightLeft, Check, Sparkles
} from 'lucide-react'
import { clsx } from 'clsx'
import {
  getAdminProxies,
  testAdminProxy,
  toggleAdminNetworkMode,
  type NetworkMode,
} from '../lib/botApi'
import toast from 'react-hot-toast'
import { ProxyLookupPanel, ProxyMoveModal, type MoveTarget } from '../components/admin/ProxyManualTools'

// حفظ نتائج الفحص وحالة البطاقات الموسعة في الذاكرة لمنع فقدانها عند التنقل بين صفحات لوحة التحكم
const _persistedTestResults: Record<string, { ok: boolean; ping?: number; msg: string }> = {}
const _persistedExpandedIps: Set<string> = new Set()

export function AdminProxiesPage() {
  const { t, i18n } = useTranslation()
  const [testingIp, setTestingIp] = useState<string | null>(null)
  const [testResults, setTestResults] = useState<Record<string, { ok: boolean; ping?: number; msg: string }>>(() => ({ ..._persistedTestResults }))
  const [expandedIps, setExpandedIps] = useState<Set<string>>(() => new Set(_persistedExpandedIps))
  const [moveTarget, setMoveTarget] = useState<MoveTarget | null>(null)
  const qc = useQueryClient()

  // Toggle Modal State
  const [showConfirmModal, setShowConfirmModal] = useState(false)
  const [targetMode, setTargetMode] = useState<NetworkMode | null>(null)
  const [isToggling, setIsToggling] = useState(false)
  const [localModeOverride, setLocalModeOverride] = useState<NetworkMode | null>(null)

  const {
    data,
    isLoading: loading,
    isFetching: refreshing,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['admin', 'proxies'],
    queryFn: getAdminProxies,
    retry: 1,
    staleTime: 60_000,
    gcTime: 1000 * 60 * 60,
  })

  useEffect(() => {
    if (isError) {
      toast.error(t('admin.proxies.fetchError'))
    }
  }, [isError, t])

  const proxies = data?.proxies_list || []
  const totalCastles = data?.total_bound_castles || 0
  const totalUsers = data?.total_bound_users || 0
  const residentialCount = data?.residential_count || 0
  const freeCount = data?.free_count || 0
  const serverIp = data?.server_ip || ''

  const rawFetchedMode = (data?.network_mode || (data?.enabled ? 'residential' : 'direct')) as NetworkMode
  const fetchedMode: NetworkMode = rawFetchedMode === 'socks5' ? 'residential' : rawFetchedMode
  const networkMode: NetworkMode = localModeOverride ?? fetchedMode

  const isResidentialMode = networkMode === 'residential' || networkMode === 'socks5'
  const isFreeMode = networkMode === 'free'

  const getModeLabel = (mode: NetworkMode) => {
    if (mode === 'residential' || mode === 'socks5') return t('admin.proxies.modes.residential')
    if (mode === 'free') return t('admin.proxies.modes.free')
    return serverIp ? t('admin.proxies.modes.directWithIp', { ip: serverIp }) : t('admin.proxies.modes.direct')
  }

  const handleTestProxy = async (proxyUrl: string, ip: string) => {
    setTestingIp(ip)
    try {
      const result = await testAdminProxy(proxyUrl)
      _persistedTestResults[ip] = result
      setTestResults(prev => ({ ...prev, [ip]: result }))
      if (result.ok) {
        toast.success(t('admin.proxies.card.testSuccessToast', { ip, ping: result.ping ?? 0 }))
      } else {
        toast.error(t('admin.proxies.card.testFailToast', { msg: result.msg }))
      }
    } catch {
      const failRes = { ok: false, msg: t('admin.proxies.card.testFailMsg') }
      _persistedTestResults[ip] = failRes
      setTestResults(prev => ({ ...prev, [ip]: failRes }))
      toast.error(t('admin.proxies.card.testErrorToast'))
    } finally {
      setTestingIp(null)
    }
  }

  const handleConfirmToggle = async () => {
    if (!targetMode) return
    setIsToggling(true)
    try {
      const res = await toggleAdminNetworkMode(targetMode)
      setLocalModeOverride(targetMode)
      setShowConfirmModal(false)
      toast.success(res.message || t('admin.proxies.modal.toggleSuccess'))
      await refetch()
      setLocalModeOverride(null)
    } catch (err: any) {
      toast.error(err?.message || t('admin.proxies.modal.toggleError'))
    } finally {
      setIsToggling(false)
    }
  }

  const toggleExpand = (ip: string) => {
    setExpandedIps(prev => {
      const next = new Set(prev)
      if (next.has(ip)) {
        next.delete(ip)
        _persistedExpandedIps.delete(ip)
      } else {
        next.add(ip)
        _persistedExpandedIps.add(ip)
      }
      return next
    })
  }

  return (
    <AdminLayout title={t('admin.proxies.pageTitle')}>
      <div className="space-y-4 max-w-7xl mx-auto px-2 sm:px-4 py-4" dir={i18n.dir()}>
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white dark:bg-[#0c140f] p-4 sm:p-5 rounded-2xl border border-slate-200/80 dark:border-emerald-500/20 shadow-xs">
          <div className="flex items-center gap-3">
            <div className={clsx(
              "p-2.5 rounded-xl border shrink-0 transition-colors",
              isResidentialMode
                ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-600 dark:text-emerald-400"
                : isFreeMode
                ? "bg-sky-500/10 border-sky-500/20 text-sky-600 dark:text-sky-400"
                : "bg-amber-500/10 border-amber-500/20 text-amber-600 dark:text-amber-400"
            )}>
              {isResidentialMode ? (
                <Sparkles size={22} />
              ) : isFreeMode ? (
                <ShieldCheck size={22} />
              ) : (
                <Server size={22} />
              )}
            </div>
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <h1 className="text-lg sm:text-xl font-bold text-slate-900 dark:text-white">
                  {t('admin.proxies.headerTitle')}
                </h1>
                <span className={clsx(
                  "text-[11px] px-2 py-0.5 rounded-md font-mono font-bold border",
                  isResidentialMode
                    ? "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-emerald-500/20"
                    : isFreeMode
                    ? "bg-sky-500/10 text-sky-600 dark:text-sky-400 border-sky-500/20"
                    : "bg-amber-500/10 text-amber-600 dark:text-amber-400 border-amber-500/20"
                )}>
                  {getModeLabel(networkMode)}
                </span>
              </div>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2 self-end sm:self-auto">
            {/* 3-way Mode Switcher */}
            <div className="flex items-center p-1 rounded-xl bg-slate-100 dark:bg-white/5 border border-slate-200/80 dark:border-white/10 text-xs gap-1">
              {/* Option 1: Static Residential (Paid) */}
              <button
                onClick={() => {
                  if (!isResidentialMode) {
                    setTargetMode('residential')
                    setShowConfirmModal(true)
                  }
                }}
                className={clsx(
                  "flex items-center gap-1.5 px-3 py-1.5 rounded-lg font-bold cursor-pointer",
                  isResidentialMode
                    ? "bg-white dark:bg-emerald-500/20 text-emerald-700 dark:text-emerald-300 shadow-xs border border-slate-200/60 dark:border-emerald-500/30"
                    : "text-slate-600 dark:text-slate-400"
                )}
                title={t('admin.proxies.tooltips.residentialBtn')}
              >
                <Sparkles size={13} className="text-emerald-500" />
                <span>{t('admin.proxies.modes.residentialBtn')}</span>
              </button>

              {/* Option 2: Free Tier (Backup) */}
              <button
                onClick={() => {
                  if (!isFreeMode) {
                    setTargetMode('free')
                    setShowConfirmModal(true)
                  }
                }}
                className={clsx(
                  "flex items-center gap-1.5 px-3 py-1.5 rounded-lg font-bold cursor-pointer",
                  isFreeMode
                    ? "bg-white dark:bg-sky-500/20 text-sky-700 dark:text-sky-300 shadow-xs border border-slate-200/60 dark:border-sky-500/30"
                    : "text-slate-600 dark:text-slate-400"
                )}
                title={t('admin.proxies.tooltips.freeBtn')}
              >
                <ShieldCheck size={13} className="text-sky-500" />
                <span>{t('admin.proxies.modes.freeBtn')}</span>
              </button>

              {/* Option 3: Direct Server IP */}
              <button
                onClick={() => {
                  if (networkMode !== 'direct') {
                    setTargetMode('direct')
                    setShowConfirmModal(true)
                  }
                }}
                className={clsx(
                  "flex items-center gap-1.5 px-3 py-1.5 rounded-lg font-bold cursor-pointer",
                  networkMode === 'direct'
                    ? "bg-white dark:bg-amber-500/20 text-amber-700 dark:text-amber-300 shadow-xs border border-slate-200/60 dark:border-amber-500/30"
                    : "text-slate-600 dark:text-slate-400"
                )}
                title={t('admin.proxies.tooltips.directBtn')}
              >
                <Globe size={13} className="text-amber-500" />
                <span>{t('admin.proxies.modes.directBtn')}</span>
              </button>
            </div>

            <button
              onClick={() => refetch()}
              disabled={refreshing}
              className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold rounded-xl bg-slate-100 dark:bg-white/5 text-slate-700 dark:text-slate-200 border border-slate-200 dark:border-white/10 cursor-pointer shadow-xs"
            >
              <RefreshCw size={13} className={refreshing ? 'animate-spin text-emerald-500' : ''} />
              <span>{t('admin.proxies.refresh')}</span>
            </button>
          </div>
        </div>

        {/* Top Summary Cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <div className="p-4 rounded-xl bg-white dark:bg-[#0c140f] border border-slate-200/80 dark:border-white/10 shadow-xs">
            <div className="text-xs text-slate-500 dark:text-slate-400 font-medium">{t('admin.proxies.stats.activeIps')}</div>
            <div className="mt-1 flex items-baseline gap-2 flex-wrap">
              <span className="text-xl font-bold text-slate-900 dark:text-white font-mono">{proxies.length}</span>
              <span className="text-[11px] text-slate-400">
                {t('admin.proxies.stats.ipsBreakdown', { residential: residentialCount, free: freeCount })}
              </span>
            </div>
          </div>

          <div className="p-4 rounded-xl bg-white dark:bg-[#0c140f] border border-slate-200/80 dark:border-white/10 shadow-xs">
            <div className="text-xs text-slate-500 dark:text-slate-400 font-medium">{t('admin.proxies.stats.boundCastles')}</div>
            <div className="mt-1 text-xl font-bold text-slate-900 dark:text-white font-mono">{totalCastles}</div>
          </div>

          <div className="p-4 rounded-xl bg-white dark:bg-[#0c140f] border border-slate-200/80 dark:border-white/10 shadow-xs">
            <div className="text-xs text-slate-500 dark:text-slate-400 font-medium">{t('admin.proxies.stats.users')}</div>
            <div className="mt-1 text-xl font-bold text-slate-900 dark:text-white font-mono">{totalUsers}</div>
          </div>

          <div className="p-4 rounded-xl bg-white dark:bg-[#0c140f] border border-slate-200/80 dark:border-white/10 shadow-xs">
            <div className="text-xs text-slate-500 dark:text-slate-400 font-medium">{t('admin.proxies.stats.currentMode')}</div>
            <div className={clsx(
              "mt-1 text-sm font-bold truncate",
              isResidentialMode
                ? "text-emerald-600 dark:text-emerald-400"
                : isFreeMode
                ? "text-sky-600 dark:text-sky-400"
                : "text-amber-600 dark:text-amber-400"
            )}>
              {isResidentialMode
                ? t('admin.proxies.modes.residentialShort')
                : isFreeMode
                ? t('admin.proxies.modes.freeShort')
                : t('admin.proxies.modes.directShort')}
            </div>
          </div>
        </div>

        {/* Notices */}
        {isResidentialMode && (
          <div className="p-3.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-700 dark:text-emerald-300 flex items-center gap-2 text-xs font-medium">
            <Sparkles size={16} className="shrink-0 text-emerald-500" />
            <span>{t('admin.proxies.notices.residential')}</span>
          </div>
        )}

        {isFreeMode && (
          <div className="p-3.5 rounded-xl bg-sky-500/10 border border-sky-500/20 text-sky-700 dark:text-sky-300 flex items-center gap-2 text-xs font-medium">
            <ShieldCheck size={16} className="shrink-0 text-sky-500" />
            <span>{t('admin.proxies.notices.free')}</span>
          </div>
        )}

        {networkMode === 'direct' && (
          <div className="p-3.5 rounded-xl bg-amber-500/10 border border-amber-500/20 text-amber-700 dark:text-amber-300 flex items-center gap-2 text-xs font-medium">
            <Globe size={16} className="shrink-0 text-amber-500" />
            <span>{t('admin.proxies.notices.direct')}</span>
          </div>
        )}

        {/* Manual tools: بحث + نقل قلعة/مستخدم + إزالة ارتباط */}
        <ProxyLookupPanel
          onMove={setMoveTarget}
          onChanged={() => qc.invalidateQueries({ queryKey: ['admin'] })}
        />

        {moveTarget && (
          <ProxyMoveModal
            target={moveTarget}
            proxies={proxies}
            testResults={testResults}
            onClose={() => setMoveTarget(null)}
            onDone={() => qc.invalidateQueries({ queryKey: ['admin'] })}
          />
        )}

        {/* Confirmation Modal */}
        {showConfirmModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/65">
            <div className="bg-white dark:bg-[#0c140f] border border-slate-200 dark:border-emerald-500/30 rounded-2xl w-full max-w-md p-5 shadow-2xl space-y-4" dir={i18n.dir()}>
              <div className="flex items-center gap-3">
                <div className={clsx(
                  "p-2.5 rounded-xl border shrink-0",
                  (targetMode === 'residential' || targetMode === 'socks5')
                    ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-600"
                    : targetMode === 'free'
                    ? "bg-sky-500/10 border-sky-500/20 text-sky-600"
                    : "bg-amber-500/10 border-amber-500/20 text-amber-600"
                )}>
                  <ArrowRightLeft size={20} />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 dark:text-white text-base">
                    {t('admin.proxies.modal.title')}
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                    {t('admin.proxies.modal.switchingTo')}{' '}
                    <span className="font-bold text-slate-800 dark:text-white">
                      {targetMode ? getModeLabel(targetMode) : ''}
                    </span>
                  </p>
                </div>
              </div>

              <div className="p-3 rounded-xl bg-slate-50 dark:bg-white/5 border border-slate-200/60 dark:border-white/5 text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                {(targetMode === 'residential' || targetMode === 'socks5')
                  ? t('admin.proxies.modal.residentialDesc', { count: residentialCount })
                  : targetMode === 'free'
                  ? t('admin.proxies.modal.freeDesc', { count: freeCount })
                  : t('admin.proxies.modal.directDesc')}
              </div>

              <div className="flex items-center justify-end gap-2 pt-2">
                <button
                  onClick={() => setShowConfirmModal(false)}
                  disabled={isToggling}
                  className="px-4 py-2 rounded-xl text-xs font-bold text-slate-600 dark:text-slate-400 cursor-pointer"
                >
                  {t('admin.proxies.modal.cancel')}
                </button>
                <button
                  onClick={handleConfirmToggle}
                  disabled={isToggling}
                  className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-bold bg-emerald-600 text-white shadow-xs cursor-pointer disabled:opacity-50"
                >
                  {isToggling ? <RefreshCw size={13} className="animate-spin" /> : <Check size={14} />}
                  <span>{t('admin.proxies.modal.confirm')}</span>
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Loading Indicator */}
        {loading && (
          <div className="flex flex-col items-center justify-center py-16 gap-3 text-emerald-500">
            <div className="w-8 h-8 border-2 border-emerald-500/30 border-t-emerald-500 rounded-full animate-spin" />
            <span className="text-xs font-medium">{t('admin.proxies.loading')}</span>
          </div>
        )}

        {/* Proxy Cards Grid */}
        {!loading && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
            {proxies.map((p) => {
              const test = testResults[p.ip]
              const isTesting = testingIp === p.ip
              const isExpanded = expandedIps.has(p.ip)
              const count = p.assigned_castles?.length || 0
              const isResidentialCard = p.type === 'residential' || (!p.type && isResidentialMode)

              return (
                <div
                  key={p.ip}
                  className="rounded-2xl p-4 sm:p-5 bg-white dark:bg-[#0a110d] border border-slate-200/80 dark:border-white/10 shadow-xs flex flex-col justify-between"
                >
                  <div>
                    {/* Top IP Header */}
                    <div className="flex items-center justify-between gap-2 mb-2">
                      <div className="flex items-center gap-1.5 font-mono font-bold text-sm text-slate-900 dark:text-white truncate">
                        <span>🌐 {p.ip}</span>
                        <span className="text-xs text-slate-400 font-normal">:{p.port}</span>
                      </div>
                      <div className="flex items-center gap-1.5 shrink-0">
                        <span className={clsx(
                          "text-[10px] px-1.5 py-0.5 rounded font-bold border",
                          isResidentialCard
                            ? "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-emerald-500/20"
                            : "bg-sky-500/10 text-sky-600 dark:text-sky-400 border-sky-500/20"
                        )}>
                          {isResidentialCard ? t('admin.proxies.card.residentialBadge') : t('admin.proxies.card.freeBadge')}
                        </span>
                        <span className="text-xs px-2 py-0.5 rounded-md bg-slate-100 dark:bg-white/5 border border-slate-200/60 dark:border-white/10 text-slate-600 dark:text-slate-300">
                          {p.country}
                        </span>
                      </div>
                    </div>

                    {/* ASN / Provider Details */}
                    {p.asn && (
                      <div className="mb-3 text-[11px] text-slate-500 dark:text-slate-400 flex items-center justify-between gap-1 truncate">
                        <span className="truncate font-medium">{p.asn}</span>
                        {p.city && <span className="text-slate-400 shrink-0">({p.city})</span>}
                      </div>
                    )}

                    {/* Castles count badge & progress bar */}
                    <div className="p-3 rounded-xl bg-slate-50 dark:bg-white/5 border border-slate-200/60 dark:border-white/5 mb-3">
                      <div className="flex items-center justify-between mb-1.5 text-xs">
                        <span className="text-slate-500 dark:text-slate-400 font-medium">{t('admin.proxies.card.castlesLabel')}</span>
                        <span className="font-bold text-emerald-600 dark:text-emerald-400 font-mono">
                          {count}
                        </span>
                      </div>
                      <div className="w-full h-1.5 rounded-full bg-slate-200 dark:bg-white/10 overflow-hidden">
                        <div
                          className="h-full bg-emerald-500 transition-all rounded-full"
                          style={{ width: `${Math.min(100, (count / 50) * 100)}%` }}
                        />
                      </div>
                    </div>

                    {/* Test Result Indicator */}
                    {test && (
                      <div
                        className={`p-2.5 rounded-xl text-xs mb-3 flex items-center gap-2 ${
                          test.ok
                            ? 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border border-emerald-500/20'
                            : 'bg-rose-500/10 text-rose-600 dark:text-rose-400 border border-rose-500/20'
                        }`}
                      >
                        {test.ok ? <CheckCircle2 size={15} className="shrink-0" /> : <XCircle size={15} className="shrink-0" />}
                        <span className="truncate">
                          {test.ok ? t('admin.proxies.card.testOkMsg') : test.msg} {test.ping ? `(${test.ping}ms)` : ''}
                        </span>
                      </div>
                    )}

                    {/* Expandable Castles List */}
                    {count > 0 && (
                      <div className="mb-3">
                        <button
                          onClick={() => toggleExpand(p.ip)}
                          className="w-full flex items-center justify-between text-xs text-slate-500 dark:text-slate-400 py-1 cursor-pointer"
                        >
                          <span>{t('admin.proxies.card.castlesCount', { count })}</span>
                          {isExpanded ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
                        </button>
                        {isExpanded && (
                          <div className="mt-1.5 max-h-36 overflow-y-auto space-y-1 p-2 rounded-xl bg-slate-50 dark:bg-black/20 border border-slate-200/50 dark:border-white/5 text-[11px] font-mono text-slate-600 dark:text-slate-300">
                            {p.assigned_castles.map((em, i) => (
                              <div key={i} className="flex justify-between items-center gap-2 py-0.5 border-b border-slate-200/30 dark:border-white/5 last:border-none">
                                <span className="truncate">• {em}</span>
                                {p.index !== undefined && (
                                  <button
                                    type="button"
                                    onClick={() => setMoveTarget({ kind: 'castle', email: em, label: em, currentIndex: p.index ?? null })}
                                    className="p-1 rounded-md text-slate-400 shrink-0 cursor-pointer"
                                    title={t('admin.proxies.manage.moveCastle')}
                                    aria-label={t('admin.proxies.manage.moveCastle')}
                                  >
                                    <ArrowRightLeft size={12} />
                                  </button>
                                )}
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    )}
                  </div>

                  {/* Card Action Button: Test IP */}
                  <button
                    onClick={() => handleTestProxy(p.full_url, p.ip)}
                    disabled={isTesting}
                    className="w-full flex items-center justify-center gap-1.5 py-2 text-xs font-bold rounded-xl bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border border-emerald-500/30 cursor-pointer shadow-xs active:scale-98 disabled:opacity-50"
                  >
                    {isTesting ? (
                      <>
                        <RefreshCw size={13} className="animate-spin text-emerald-500" />
                        <span>{t('admin.proxies.card.testing')}</span>
                      </>
                    ) : (
                      <>
                        <Zap size={13} />
                        <span>{t('admin.proxies.card.testBtn')}</span>
                      </>
                    )}
                  </button>

                  {count > 0 && p.index !== undefined && proxies.length > 1 && (
                    <button
                      onClick={() => setMoveTarget({ kind: 'drain', fromIndex: p.index as number, fromIp: p.ip, count })}
                      className="w-full flex items-center justify-center gap-1.5 py-2 mt-2 text-xs font-bold rounded-xl bg-amber-500/10 text-amber-700 dark:text-amber-400 border border-amber-500/30 cursor-pointer shadow-xs"
                    >
                      <ArrowRightLeft size={13} />
                      <span>{t('admin.proxies.manage.drainBtn')}</span>
                    </button>
                  )}
                </div>
              )
            })}
          </div>
        )}
      </div>
    </AdminLayout>
  )
}
export default AdminProxiesPage

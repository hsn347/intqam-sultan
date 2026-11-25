import { useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { Search, X, RefreshCw, Ban, Copy, ShieldAlert, Clock } from 'lucide-react'
import { useQuery } from '@tanstack/react-query'
import toast from 'react-hot-toast'
import { AdminLayout } from '../components/layout/AdminLayout'
import { fetchAdminBannedCastles, AdminBannedCastle } from '../lib/botApi'

const RECENT_MS = 3 * 24 * 60 * 60 * 1000 // الافتراضي: القلاع المحظورة خلال آخر 3 أيام

type Period = 'recent' | 'older'

function parseTs(s?: string | null): number | null {
  if (!s) return null
  const ts = new Date(s).getTime()
  return Number.isNaN(ts) ? null : ts
}

function formatDateTime(ts: number): string {
  const d = new Date(ts)
  const p = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}/${p(d.getMonth() + 1)}/${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`
}

function formatNumber(n: number | null | undefined): string {
  return typeof n === 'number' && Number.isFinite(n) ? n.toLocaleString('en-US') : '—'
}

export function AdminBannedCastlesPage() {
  const { t } = useTranslation()
  const [search, setSearch] = useState('')
  const [period, setPeriod] = useState<Period>('recent')

  const {
    data: castles = [],
    isLoading,
    isRefetching,
    refetch,
  } = useQuery({
    queryKey: ['admin_banned_castles'],
    queryFn: fetchAdminBannedCastles,
    staleTime: 45_000,
    refetchOnWindowFocus: false,
  })

  const { visible, recentCount, olderCount } = useMemo(() => {
    const q = search.trim().toLowerCase()
    const now = Date.now()
    const matched = castles.filter(c => {
      if (!q) return true
      return [
        c.game_email, c.lord_name, c.castle_name, c.seal_reason, c.alliance_name,
        c.owner.email, c.owner.username, c.owner.phone, c.owner.tenant_domain,
      ].some(v => (v || '').toLowerCase().includes(q))
    })
    const isRecent = (c: AdminBannedCastle) => {
      const ts = parseTs(c.banned_at)
      return ts !== null && now - ts <= RECENT_MS
    }
    const recent = matched.filter(isRecent)
    const older = matched.filter(c => !isRecent(c))
    return {
      visible: period === 'recent' ? recent : older,
      recentCount: recent.length,
      olderCount: older.length,
    }
  }, [castles, search, period])

  const formatAgo = (ts: number): string => {
    const minutes = Math.max(0, Math.floor((Date.now() - ts) / 60000))
    if (minutes < 1) return t('admin.bannedCastles.justNow')
    if (minutes < 60) return t('admin.bannedCastles.minutesAgo', { count: minutes })
    const hours = Math.floor(minutes / 60)
    if (hours < 24) return t('admin.bannedCastles.hoursAgo', { count: hours })
    return t('admin.bannedCastles.daysAgo', { count: Math.floor(hours / 24) })
  }

  const copyEmail = async (email: string) => {
    try {
      await navigator.clipboard.writeText(email)
      toast.success(t('admin.bannedCastles.copied'))
    } catch {
      toast.error(t('common.error'))
    }
  }

  const chipCls = (active: boolean) =>
    `flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold border shrink-0 cursor-pointer ${
      active
        ? 'bg-rose-600 text-white border-rose-600 shadow-xs'
        : 'bg-white dark:bg-white/5 text-slate-600 dark:text-slate-300 border-slate-200/80 dark:border-white/10'
    }`
  const countCls = (active: boolean) =>
    `font-mono text-[10px] px-1.5 rounded-full ${
      active ? 'bg-white/20 text-white' : 'bg-slate-100 dark:bg-white/10 text-slate-600 dark:text-slate-400'
    }`

  return (
    <AdminLayout title={t('admin.bannedCastles.title')}>
      <div className="space-y-4 mx-auto px-3 sm:px-6 lg:px-8 py-4 sm:py-6 max-w-7xl">
        {/* Header */}
        <div className="flex justify-between items-center gap-3 bg-white dark:bg-[#0c1410] shadow-xs p-4 sm:p-5 border border-slate-200/80 dark:border-white/10 rounded-2xl">
          <div className="flex items-center gap-3 min-w-0">
            <div className="flex justify-center items-center bg-rose-50 dark:bg-rose-500/10 border border-rose-200 dark:border-rose-500/25 rounded-xl w-10 h-10 text-rose-600 dark:text-rose-400 shrink-0">
              <ShieldAlert size={20} />
            </div>
            <div className="min-w-0">
              <h1 className="font-black text-slate-900 dark:text-white text-lg sm:text-xl">{t('admin.bannedCastles.title')}</h1>
              <p className="text-slate-500 dark:text-slate-400 text-xs">{t('admin.bannedCastles.subtitle')}</p>
            </div>
          </div>
          <button
            type="button"
            onClick={() => void refetch()}
            disabled={isRefetching}
            title={t('admin.refreshData')}
            className="flex items-center gap-1.5 bg-white dark:bg-white/5 disabled:opacity-60 shadow-xs px-3 py-2 border border-slate-200/80 dark:border-white/10 rounded-xl font-semibold text-slate-700 dark:text-slate-200 text-xs active:scale-95 cursor-pointer shrink-0"
          >
            <RefreshCw size={14} className={isRefetching ? 'animate-spin text-rose-500' : 'text-slate-500 dark:text-slate-400'} />
            <span className="hidden sm:inline">{t('admin.refreshData')}</span>
          </button>
        </div>

        {/* Search + period */}
        <div className="flex sm:flex-row flex-col sm:items-center gap-3">
          <div className="relative w-full sm:w-80">
            <Search size={15} className="top-1/2 absolute text-slate-400 -translate-y-1/2 pointer-events-none start-3" />
            <input
              type="text"
              dir="auto"
              autoComplete="off"
              spellCheck={false}
              value={search}
              onChange={e => setSearch(e.target.value)}
              placeholder={t('admin.bannedCastles.search')}
              className="admin-search-input shadow-xs py-2 rounded-xl outline-none w-full min-h-[42px] sm:min-h-[38px] text-base sm:text-sm"
              style={{ paddingInlineStart: '2.35rem', paddingInlineEnd: '2.35rem' }}
            />
            {search && (
              <button
                type="button"
                onClick={() => setSearch('')}
                className="top-1/2 absolute flex justify-center items-center w-7 h-7 text-slate-400 -translate-y-1/2 cursor-pointer end-2"
                aria-label={t('accounts.clearSearch')}
              >
                <X size={14} />
              </button>
            )}
          </div>
          <div className="flex items-center gap-1.5 select-none">
            <button type="button" onClick={() => setPeriod('recent')} className={chipCls(period === 'recent')}>
              <span>{t('admin.bannedCastles.recent')}</span>
              <span className={countCls(period === 'recent')}>{recentCount}</span>
            </button>
            <button type="button" onClick={() => setPeriod('older')} className={chipCls(period === 'older')}>
              <span>{t('admin.bannedCastles.older')}</span>
              <span className={countCls(period === 'older')}>{olderCount}</span>
            </button>
          </div>
        </div>

        {/* List */}
        {isLoading ? (
          <div className="py-16 text-slate-400 text-center">{t('common.loading')}</div>
        ) : visible.length === 0 ? (
          <div className="flex flex-col items-center gap-2.5 bg-white dark:bg-[#0c1410] py-16 border border-slate-200/80 dark:border-white/10 rounded-2xl text-slate-400 text-center">
            <span>{period === 'recent' ? t('admin.bannedCastles.emptyRecent') : t('admin.bannedCastles.empty')}</span>
            {period === 'recent' && olderCount > 0 && (
              <button
                type="button"
                onClick={() => setPeriod('older')}
                className="bg-rose-500/10 px-3 py-1.5 border border-rose-500/25 rounded-lg font-semibold text-rose-600 dark:text-rose-400 text-xs cursor-pointer"
              >
                {t('admin.bannedCastles.showOlder', { count: olderCount })}
              </button>
            )}
          </div>
        ) : (
          <div className="gap-3 grid grid-cols-1 lg:grid-cols-2">
            {visible.map(c => {
              const ts = parseTs(c.banned_at)
              const name = c.lord_name || c.castle_name || c.game_email.split('@')[0]
              const createdTs = parseTs(c.created_at)
              return (
                <div
                  key={c.castle_id}
                  className="space-y-3 bg-white dark:bg-[#0c1410] shadow-xs p-4 border border-slate-200/80 dark:border-white/8 rounded-2xl"
                >
                  {/* Castle identity */}
                  <div className="flex justify-between items-start gap-2">
                    <div className="flex items-center gap-2.5 min-w-0">
                      <div className="flex justify-center items-center bg-rose-50 dark:bg-rose-500/10 border border-rose-200 dark:border-rose-500/25 rounded-xl w-10 h-10 font-black text-rose-700 dark:text-rose-400 text-xs shrink-0">
                        {name[0]?.toUpperCase()}
                      </div>
                      <div className="min-w-0">
                        <div className="font-bold text-slate-900 dark:text-white text-sm truncate">{name}</div>
                        <div className="flex items-center gap-1 min-w-0">
                          <span className="font-mono text-slate-500 dark:text-slate-400 text-xs truncate select-all" dir="ltr">{c.game_email}</span>
                          <button
                            type="button"
                            onClick={() => void copyEmail(c.game_email)}
                            className="p-1 rounded-md text-slate-400 shrink-0 cursor-pointer"
                            title={t('admin.bannedCastles.copyEmail')}
                            aria-label={t('admin.bannedCastles.copyEmail')}
                          >
                            <Copy size={12} />
                          </button>
                        </div>
                      </div>
                    </div>
                    <span className="flex items-center gap-1 badge badge-red shrink-0">
                      <Ban size={11} />
                      {t('dashboard.bannedBadge')}
                    </span>
                  </div>

                  {/* Ban reason */}
                  <div className="flex items-start gap-2 bg-rose-50 dark:bg-rose-500/10 p-2.5 border border-rose-200 dark:border-rose-500/25 rounded-xl text-rose-700 dark:text-rose-300 text-xs">
                    <ShieldAlert size={14} className="mt-0.5 shrink-0" />
                    <div className="min-w-0">
                      <div className="font-semibold text-[10px] text-rose-500 dark:text-rose-400">{t('admin.bannedCastles.reason')}</div>
                      <div className="font-bold break-words">
                        {c.seal_reason || t('admin.bannedCastles.unknownReason')}
                        {c.seal_type !== null && c.seal_type !== undefined && (
                          <span className="ms-1 font-mono font-normal text-[10px] opacity-70">#{c.seal_type}</span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Details */}
                  <div className="gap-2 grid grid-cols-2 bg-slate-50 dark:bg-black/30 p-2.5 border border-slate-100 dark:border-white/5 rounded-xl text-xs">
                    <div className="min-w-0">
                      <div className="flex items-center gap-1 font-semibold text-[10px] text-slate-500 dark:text-slate-400">
                        <Clock size={10} />
                        {t('admin.bannedCastles.bannedAt')}
                      </div>
                      {ts !== null ? (
                        <>
                          <div className="font-bold text-slate-900 dark:text-white">{formatAgo(ts)}</div>
                          <div className="font-mono text-[10px] text-slate-500 dark:text-slate-400" dir="ltr">{formatDateTime(ts)}</div>
                        </>
                      ) : (
                        <div className="text-slate-400">—</div>
                      )}
                    </div>

                    <div className="min-w-0">
                      <div className="font-semibold text-[10px] text-slate-500 dark:text-slate-400">{t('admin.bannedCastles.owner')}</div>
                      <div className="font-bold text-slate-900 dark:text-white truncate">{c.owner.username || '—'}</div>
                      <div className="font-mono text-[10px] text-slate-500 dark:text-slate-400 truncate select-all" dir="ltr">{c.owner.email}</div>
                    </div>

                    <div className="min-w-0">
                      <div className="font-semibold text-[10px] text-slate-500 dark:text-slate-400">{t('admin.bannedCastles.level')}</div>
                      <div className="font-mono font-bold text-slate-900 dark:text-white">
                        {formatNumber(c.castle_level)}
                        <span className="ms-2 font-sans font-normal text-[10px] text-slate-500 dark:text-slate-400">
                          {t('admin.bannedCastles.power')}: {formatNumber(c.power)}
                        </span>
                      </div>
                    </div>

                    <div className="min-w-0">
                      <div className="font-semibold text-[10px] text-slate-500 dark:text-slate-400">{t('admin.bannedCastles.added')}</div>
                      <div className="font-mono font-bold text-slate-900 dark:text-white" dir="ltr">
                        {createdTs !== null ? formatDateTime(createdTs).split(' ')[0] : '—'}
                      </div>
                    </div>
                  </div>

                  {/* Footer chips */}
                  <div className="flex flex-wrap items-center gap-1.5 text-[10px]">
                    {c.alliance_name && (
                      <span className="badge badge-gray">{c.alliance_name}</span>
                    )}
                    {c.server_id && (
                      <span className="badge badge-gray">{c.server_id}</span>
                    )}
                    {c.owner.tenant_domain && (
                      <span className="badge badge-gray" dir="ltr">{c.owner.tenant_domain}</span>
                    )}
                    {c.proxy_index !== null && c.proxy_index !== undefined && c.proxy_index >= 0 && (
                      <span className="badge badge-gray">{t('admin.bannedCastles.proxy')} #{c.proxy_index}</span>
                    )}
                    {c.owner.is_banned && (
                      <span className="badge badge-red">{t('admin.bannedCastles.ownerBanned')}</span>
                    )}
                  </div>
                </div>
              )
            })}
          </div>
        )}

        <p className="text-[11px] text-slate-400 dark:text-slate-500 text-center">{t('admin.bannedCastles.note')}</p>
      </div>
    </AdminLayout>
  )
}

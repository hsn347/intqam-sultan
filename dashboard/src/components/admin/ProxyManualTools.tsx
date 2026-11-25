import { useEffect, useState } from 'react'
import { createPortal } from 'react-dom'
import { useTranslation } from 'react-i18next'
import { useQuery } from '@tanstack/react-query'
import { Search, X, ArrowRightLeft, Check, RefreshCw, Unlink, Users, AlertTriangle } from 'lucide-react'
import toast from 'react-hot-toast'
import {
  lookupAdminProxyCastles,
  assignCastleProxy,
  assignUserProxy,
  drainAdminProxy,
  unbindAdminProxy,
  type ProxyCardInfo,
  type ProxyLookupItem,
  type ProxyOpResult,
} from '../../lib/botApi'

export type MoveTarget =
  | { kind: 'castle'; email: string; label: string; currentIndex: number | null }
  | { kind: 'user'; uid: string; label: string; currentIndex: number | null }
  | { kind: 'drain'; fromIndex: number; fromIp: string; count: number }

// ─── Move / Drain modal ────────────────────────────────────────
export function ProxyMoveModal({
  target,
  proxies,
  testResults,
  onClose,
  onDone,
}: {
  target: MoveTarget
  proxies: ProxyCardInfo[]
  testResults: Record<string, { ok: boolean; ping?: number; msg: string }>
  onClose: () => void
  onDone: () => void
}) {
  const { t } = useTranslation()
  const [selected, setSelected] = useState<number | null>(null)
  const [busy, setBusy] = useState(false)

  const isDrain = target.kind === 'drain'
  const currentIndex = target.kind === 'drain' ? target.fromIndex : target.currentIndex

  const title =
    target.kind === 'castle'
      ? t('admin.proxies.manage.moveCastleTitle')
      : target.kind === 'user'
      ? t('admin.proxies.manage.moveUserTitle')
      : t('admin.proxies.manage.drainTitle')

  const handleConfirm = async () => {
    if (!isDrain && selected === null) return
    setBusy(true)
    try {
      let res: ProxyOpResult
      if (target.kind === 'castle') res = await assignCastleProxy(target.email, selected as number)
      else if (target.kind === 'user') res = await assignUserProxy(target.uid, selected as number)
      else res = await drainAdminProxy(target.fromIndex)

      if (isDrain) {
        toast.success(t('admin.proxies.manage.drained', { count: res.moved, ips: Object.keys(res.targets || {}).length }))
      } else {
        toast.success(t('admin.proxies.manage.moved', { count: res.moved, ip: res.ip || '' }))
      }
      if (res.running_count > 0) {
        toast(t('admin.proxies.manage.runningNotice', { count: res.running_count }), { icon: '⚠️', duration: 6000 })
      }
      onDone()
      onClose()
    } catch (err: any) {
      toast.error(err?.message || t('common.error'))
    } finally {
      setBusy(false)
    }
  }

  return createPortal(
    <div className="z-[100] fixed inset-0 flex justify-center items-center bg-black/65 p-4" onClick={busy ? undefined : onClose}>
      <div
        className="space-y-3 bg-white dark:bg-[#0c140f] shadow-2xl p-5 border border-slate-200 dark:border-emerald-500/30 rounded-2xl w-full max-w-md max-h-[90vh] overflow-y-auto"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex justify-between items-start gap-3">
          <div className="flex items-center gap-3 min-w-0">
            <div className="bg-emerald-500/10 p-2.5 border border-emerald-500/20 rounded-xl text-emerald-600 shrink-0">
              <ArrowRightLeft size={20} />
            </div>
            <div className="min-w-0">
              <h3 className="font-bold text-slate-900 dark:text-white text-base">{title}</h3>
              <p className="text-slate-500 dark:text-slate-400 text-xs truncate" dir="auto">
                {target.kind === 'drain'
                  ? t('admin.proxies.manage.drainDesc', { count: target.count, ip: target.fromIp })
                  : target.label}
              </p>
            </div>
          </div>
          <button type="button" onClick={onClose} disabled={busy} className="p-1.5 rounded-lg text-slate-400 cursor-pointer">
            <X size={16} />
          </button>
        </div>

        {!isDrain && (
          <div className="space-y-1.5 max-h-64 overflow-y-auto pe-1">
            <div className="font-semibold text-[11px] text-slate-500 dark:text-slate-400">{t('admin.proxies.manage.chooseProxy')}</div>
            {proxies.map(p => {
              const idx = p.index ?? -1
              const isCurrent = idx === currentIndex
              const test = testResults[p.ip]
              const isSel = selected === idx
              return (
                <button
                  key={p.ip}
                  type="button"
                  disabled={isCurrent || idx < 0}
                  onClick={() => setSelected(idx)}
                  className={`flex items-center justify-between gap-2 px-3 py-2 border rounded-xl w-full text-start text-xs cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 ${
                    isSel
                      ? 'bg-emerald-500/10 border-emerald-500/50 ring-1 ring-emerald-500/30'
                      : 'bg-slate-50 dark:bg-white/5 border-slate-200/70 dark:border-white/10'
                  }`}
                >
                  <span className="font-mono font-bold text-slate-900 dark:text-white truncate" dir="ltr">
                    {p.ip}
                    <span className="font-normal text-slate-400">:{p.port}</span>
                  </span>
                  <span className="flex items-center gap-1.5 text-[10px] text-slate-500 dark:text-slate-400 shrink-0">
                    {test && (
                      <span className={test.ok ? 'text-emerald-600 dark:text-emerald-400' : 'text-rose-600 dark:text-rose-400'}>
                        {test.ok ? `✓${test.ping ? ` ${test.ping}ms` : ''}` : '✗'}
                      </span>
                    )}
                    <span>{p.country}</span>
                    <span className="font-mono">{p.assigned_castles?.length || 0}</span>
                    {isCurrent && <span className="font-bold text-emerald-600">{t('admin.proxies.manage.current')}</span>}
                  </span>
                </button>
              )
            })}
          </div>
        )}

        <div className="flex items-start gap-2 bg-amber-500/10 p-2.5 border border-amber-500/25 rounded-xl text-amber-700 dark:text-amber-300 text-[11px] leading-relaxed">
          <AlertTriangle size={14} className="mt-0.5 shrink-0" />
          <span>{t('admin.proxies.manage.warning')}</span>
        </div>

        <div className="flex justify-end items-center gap-2 pt-1">
          <button type="button" onClick={onClose} disabled={busy} className="px-4 py-2 rounded-xl font-bold text-slate-600 dark:text-slate-400 text-xs cursor-pointer">
            {t('admin.proxies.modal.cancel')}
          </button>
          <button
            type="button"
            onClick={handleConfirm}
            disabled={busy || (!isDrain && selected === null)}
            className="flex items-center gap-1.5 bg-emerald-600 disabled:opacity-50 shadow-xs px-4 py-2 rounded-xl font-bold text-white text-xs cursor-pointer"
          >
            {busy ? <RefreshCw size={13} className="animate-spin" /> : <Check size={14} />}
            <span>{t('admin.proxies.modal.confirm')}</span>
          </button>
        </div>
      </div>
    </div>,
    document.body
  )
}

// ─── Quick lookup + per-castle / per-user actions ──────────────
export function ProxyLookupPanel({
  onMove,
  onChanged,
}: {
  onMove: (target: MoveTarget) => void
  onChanged: () => void
}) {
  const { t } = useTranslation()
  const [input, setInput] = useState('')
  const [q, setQ] = useState('')
  const [busyKey, setBusyKey] = useState<string | null>(null)

  useEffect(() => {
    const id = setTimeout(() => setQ(input.trim()), 350)
    return () => clearTimeout(id)
  }, [input])

  const { data: items = [], isFetching } = useQuery({
    queryKey: ['admin', 'proxy_lookup', q],
    queryFn: () => lookupAdminProxyCastles(q),
    enabled: q.length >= 2,
    staleTime: 15_000,
  })

  const handleUnbind = async (key: string, label: string, body: { castle_email: string } | { user_id: string }, isUser: boolean) => {
    if (!confirm(t(isUser ? 'admin.proxies.manage.unbindUserConfirm' : 'admin.proxies.manage.unbindCastleConfirm', { name: label }))) return
    setBusyKey(key)
    try {
      const res = await unbindAdminProxy(body)
      toast.success(t('admin.proxies.manage.unbound', { count: res.moved }))
      if (res.running_count > 0) {
        toast(t('admin.proxies.manage.runningNotice', { count: res.running_count }), { icon: '⚠️', duration: 6000 })
      }
      onChanged()
    } catch (err: any) {
      toast.error(err?.message || t('common.error'))
    } finally {
      setBusyKey(null)
    }
  }

  const btn =
    'flex items-center gap-1 px-2 py-1 rounded-lg border text-[11px] font-semibold cursor-pointer disabled:opacity-50 bg-slate-50 dark:bg-white/5 border-slate-200/80 dark:border-white/10 text-slate-700 dark:text-slate-200'

  return (
    <div className="space-y-3 bg-white dark:bg-[#0c140f] shadow-xs p-4 border border-slate-200/80 dark:border-white/10 rounded-2xl">
      <div className="flex sm:flex-row flex-col sm:items-center gap-2">
        <div className="font-bold text-slate-900 dark:text-white text-sm shrink-0">{t('admin.proxies.manage.title')}</div>
        <div className="relative flex-1">
          <Search size={14} className="top-1/2 absolute text-slate-400 -translate-y-1/2 pointer-events-none start-3" />
          <input
            type="text"
            dir="auto"
            autoComplete="off"
            spellCheck={false}
            value={input}
            onChange={e => setInput(e.target.value)}
            placeholder={t('admin.proxies.manage.searchPlaceholder')}
            className="admin-search-input py-2 rounded-xl outline-none w-full min-h-[38px] text-base sm:text-sm"
            style={{ paddingInlineStart: '2.25rem', paddingInlineEnd: '2.25rem' }}
          />
          {input && (
            <button type="button" onClick={() => setInput('')} className="top-1/2 absolute flex justify-center items-center w-7 h-7 text-slate-400 -translate-y-1/2 cursor-pointer end-2">
              <X size={14} />
            </button>
          )}
        </div>
      </div>

      {q.length >= 2 && (
        <div className="space-y-2">
          {isFetching && items.length === 0 ? (
            <div className="py-3 text-slate-400 text-xs text-center">{t('common.loading')}</div>
          ) : items.length === 0 ? (
            <div className="py-3 text-slate-400 text-xs text-center">{t('admin.proxies.manage.noResults')}</div>
          ) : (
            items.map((it: ProxyLookupItem) => {
              const name = it.lord_name || it.castle_name || it.email
              const owner = it.owner.username || it.owner.email
              return (
                <div key={it.castle_id} className="space-y-2 bg-slate-50 dark:bg-white/5 p-3 border border-slate-200/60 dark:border-white/5 rounded-xl">
                  <div className="flex justify-between items-start gap-2">
                    <div className="min-w-0">
                      <div className="flex items-center gap-1.5 font-bold text-slate-900 dark:text-white text-sm truncate">
                        {it.is_running && <span className="bg-emerald-500 rounded-full w-1.5 h-1.5 shrink-0" />}
                        <span className="truncate">{name}</span>
                      </div>
                      <div className="font-mono text-[11px] text-slate-500 dark:text-slate-400 truncate" dir="ltr">{it.email}</div>
                      {owner && <div className="text-[11px] text-slate-500 dark:text-slate-400 truncate">{t('admin.bannedCastles.owner')}: {owner}</div>}
                    </div>
                    <div className="text-end shrink-0">
                      <div className="text-[10px] text-slate-500 dark:text-slate-400">{t('admin.bannedCastles.proxy')}</div>
                      <div className={`font-mono font-bold text-xs ${it.proxy_ip ? 'text-emerald-600 dark:text-emerald-400' : 'text-amber-600 dark:text-amber-400'}`} dir="ltr">
                        {it.proxy_ip || t('admin.proxies.manage.unassigned')}
                      </div>
                    </div>
                  </div>
                  <div className="flex flex-wrap items-center gap-1.5">
                    <button type="button" className={btn} onClick={() => onMove({ kind: 'castle', email: it.email, label: name, currentIndex: it.proxy_index })}>
                      <ArrowRightLeft size={11} />
                      {t('admin.proxies.manage.moveCastle')}
                    </button>
                    {it.owner.uid && (
                      <button type="button" className={btn} onClick={() => onMove({ kind: 'user', uid: it.owner.uid, label: owner, currentIndex: it.proxy_index })}>
                        <Users size={11} />
                        {t('admin.proxies.manage.moveUser')}
                      </button>
                    )}
                    {it.proxy_ip && (
                      <button
                        type="button"
                        className={btn}
                        disabled={busyKey === `c:${it.email}`}
                        onClick={() => handleUnbind(`c:${it.email}`, name, { castle_email: it.email }, false)}
                      >
                        <Unlink size={11} />
                        {t('admin.proxies.manage.unbindCastle')}
                      </button>
                    )}
                    {it.owner.uid && it.proxy_ip && (
                      <button
                        type="button"
                        className={btn}
                        disabled={busyKey === `u:${it.owner.uid}`}
                        onClick={() => handleUnbind(`u:${it.owner.uid}`, owner, { user_id: it.owner.uid }, true)}
                      >
                        <Unlink size={11} />
                        {t('admin.proxies.manage.unbindUser')}
                      </button>
                    )}
                  </div>
                </div>
              )
            })
          )}
        </div>
      )}
    </div>
  )
}

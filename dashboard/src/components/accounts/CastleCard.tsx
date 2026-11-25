import React, { useState, useEffect, useMemo, useRef } from 'react'
import { useTranslation } from 'react-i18next'
import {
  ChevronDown, ChevronUp, Play, Square, Trash2, Edit2, Clock,
  Zap, Globe, MapPin, Crown, Activity, Lock, ShieldAlert, AlertTriangle, KeyRound,
  Loader2, Shield, Ban
} from 'lucide-react'
import { motion } from 'framer-motion'
import { clsx } from 'clsx'
import toast from 'react-hot-toast'
import { ResourceBar } from './ResourceBar'
import { TaskTabContent } from './TaskTabContent'
import { ConfirmStopModal } from './ConfirmStopModal'
import { Castle, BotState } from '../../types'
import { useBotControl, useRealBotStatus } from '../../hooks/useCastles'
import { useAuth } from '../../hooks/useAuth'
import { localizeApiError, localizeCastleSealReason } from '../../lib/localize'

export interface CastleCardProps {
  castle: Castle
  userId: string
  index?: number
  onDelete?: (id: string, wasActive?: boolean) => void
  onEdit?: (castle: Castle) => void
  onSetBatchTemplate?: (castleId: string) => void
  isPending?: boolean
  isExpanded?: boolean
  onToggleExpand?: (id?: string) => void
  isStopAllPending?: boolean
}

function CastleCardInner({
  castle,
  userId,
  index,
  onDelete,
  onEdit,
  onSetBatchTemplate,
  isPending,
  isExpanded,
  onToggleExpand,
  isStopAllPending,
}: CastleCardProps) {
  const { t } = useTranslation()
  const isControlled = typeof isExpanded === 'boolean'
  const [internalExpanded, setInternalExpanded] = useState(false)
  const expanded = isControlled ? isExpanded : internalExpanded
  const [hasBeenExpanded, setHasBeenExpanded] = useState(false)

  useEffect(() => {
    if (expanded) setHasBeenExpanded(true)
  }, [expanded])

  const handleToggleExpand = (e?: React.MouseEvent) => {
    if (e) e.stopPropagation()
    if (isControlled) {
      onToggleExpand?.(castle.id)
    } else {
      setInternalExpanded(prev => {
        const next = !prev
        if (next) setHasBeenExpanded(true)
        return next
      })
    }
  }
  const [liveCastle, setLiveCastle] = useState<Castle>(castle)
  const [liveState, setLiveState] = useState<string>(castle.bot_status.state)
  const [connState, setConnState] = useState<string>(castle.bot_status?.conn_state ?? '')
  const [isStopping, setIsStopping] = useState(false)
  const [isStarting, setIsStarting] = useState(false)
  const isJustStoppedRef = useRef(false)
  const stopGraceTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    return () => {
      if (stopGraceTimerRef.current) clearTimeout(stopGraceTimerRef.current)
    }
  }, [])

  const [showStopModal, setShowStopModal] = useState(false)
  const botControl = useBotControl(userId)
  const { user } = useAuth()

  const isSuperAdmin = user?.role === 'admin' || user?.email?.trim().toLowerCase() === 'ibraboths@gmail.com'
  const isBanned = !isSuperAdmin && Boolean(user?.is_banned)
  const isPendingApproval = !isSuperAdmin && (user?.subscription?.status === 'pending_approval' || (user as any)?.status === 'pending')
  const isExpired = !isSuperAdmin && !isPendingApproval && (
    user?.subscription?.status === 'expired' ||
    (user?.subscription?.expires_at ? new Date(user.subscription.expires_at).getTime() < Date.now() : false)
  )

  const currentBotState = (castle.bot_status?.state as string) || ''
  const currentConnState = (castle.bot_status?.conn_state as string) || ''

  const shouldConnectWs = Boolean(
    expanded ||
    isStarting ||
    isStopping ||
    currentBotState === 'running' ||
    currentBotState === 'starting' ||
    currentConnState === 'connected' ||
    currentConnState === 'waiting' ||
    currentConnState === 'reconnecting'
  )
  const {
    status: realStatus,
    next_run_time: realNextRun,
    status_message: realStatusMsg,
    is_sealed: realIsSealed,
    seal_type: realSealType,
    seal_reason: realSealReason,
  } = useRealBotStatus(castle.id, shouldConnectWs)

  const isMutationStarting = botControl.isPending && (botControl.variables as any)?.state === 'running'
  const isMutationStopping = botControl.isPending && (botControl.variables as any)?.state === 'idle'

  const isStoppingActive = isStopping || isMutationStopping || (Boolean(isStopAllPending) && (liveState === 'running' || castle.bot_status?.state === 'running'))

  const isActuallyRunning = Boolean(
    !isStoppingActive && !isJustStoppedRef.current && (
      realStatus === 'running' ||
      realStatus === 'waiting' ||
      connState === 'connected' ||
      connState === 'waiting' ||
      (liveState === 'running' && connState !== 'starting' && connState !== 'idle')
    )
  )

  const isStartingActive = !isActuallyRunning && (
    isStarting ||
    isMutationStarting ||
    (!isStopping && !isJustStoppedRef.current && (connState === 'starting' || liveState === 'starting' || (realStatus as string) === 'starting'))
  )

  useEffect(() => {
    if (isStarting && isActuallyRunning) {
      setIsStarting(false)
      setLiveState('running')
      setConnState(realStatus && realStatus !== 'offline' ? realStatus : 'connected')
    }
  }, [isStarting, isActuallyRunning, realStatus])

  useEffect(() => {
    if (isStarting && (realStatus === 'error' || realStatus === 'sealed' || connState === 'error' || connState === 'sealed' || liveState === 'error' || liveState === 'sealed')) {
      setIsStarting(false)
    }
  }, [isStarting, realStatus, connState, liveState])

  useEffect(() => {
    if (!isStarting) return
    const timer = setTimeout(() => {
      setIsStarting(false)
    }, 15000)
    return () => clearTimeout(timer)
  }, [isStarting])

  useEffect(() => {
    setLiveCastle(castle)
    if (!isStopping && !isStarting && !isJustStoppedRef.current) {
      setLiveState(castle.bot_status.state)
      setConnState(castle.bot_status?.conn_state ?? '')
    }
  }, [castle, isStopping, isStarting])

  useEffect(() => {
    if (isStopping || isStarting || isJustStoppedRef.current) return

    if (realStatus && realStatus !== 'offline') {
      const bs = realStatus === 'starting'
        ? 'starting'
        : realStatus === 'idle'
        ? 'idle'
        : realStatus === 'sealed'
        ? 'sealed'
        : realStatus === 'error'
        ? 'error'
        : 'running'
      setLiveState(bs)
      setConnState(realStatus)
    }
  }, [realStatus, isStopping, isStarting])

  const info      = liveCastle.castle_info || castle.castle_info
  const bot       = liveCastle.bot_status  || castle.bot_status
  const resources = liveCastle.resources   || castle.resources

  const emailPrefix = (castle.email || '').split('@')[0] || t('common.castle', 'قلعة')
  const isGenericName = !info?.lord_name || ['لورد الإمبراطورية', 'القلعة الملكية', 'قلعة جديدة', 'غير معروف', 'قلعة'].includes(info.lord_name)
  const displayLordName = isGenericName ? emailPrefix : info.lord_name

  const avatarPath = info?.avatar || ''
  const isCustomAvatar = Boolean(avatarPath && (avatarPath.startsWith('/') || avatarPath.includes('customAvatar') || avatarPath.startsWith('http')))
  const avatarUrl = isCustomAvatar ? (avatarPath.startsWith('http') ? avatarPath : `/api/castles/${castle.id}/avatar`) : ''
  const [imgError, setImgError] = useState(false)

  const isDeploying    = connState === 'deploying' || liveState === 'deploying' || realStatus === 'deploying'
  const isSealed       = !isDeploying && !isStoppingActive && (
    liveState === 'sealed' ||
    connState === 'sealed' ||
    bot?.state === 'sealed' ||
    bot?.conn_state === 'sealed' ||
    realStatus === 'sealed' ||
    Boolean(bot?.is_sealed) ||
    Boolean(realIsSealed)
  )
  const isError        = !isDeploying && !isStoppingActive && !isSealed && (liveState === 'error' || connState === 'error' || bot?.conn_state === 'error' || bot?.state === 'error' || realStatus === 'error' || Boolean((castle as any)?.is_password_error) || Boolean((bot as any)?.is_password_error))
  const statusMsgStr   = (realStatusMsg || bot?.conn_message || (castle as any)?.status_message || bot?.last_error || '').toLowerCase()
  const isPasswordError = isError && (statusMsgStr.includes('كلمة') || statusMsgStr.includes('password') || Boolean((bot as any)?.is_password_error) || Boolean((castle as any)?.is_password_error))
  const isDisconnected = !isDeploying && !isStoppingActive && !isError && !isSealed && (connState === 'disconnected' || liveState === 'disconnected')
  const isReconnecting = !isDeploying && !isStoppingActive && !isError && !isSealed && (connState === 'reconnecting' || liveState === 'reconnecting')
  const isWaitingCycle = !isDeploying && !isStoppingActive && !isJustStoppedRef.current && !isError && !isSealed && (connState === 'waiting' || liveState === 'waiting') && !isDisconnected && !isReconnecting
  const isRunningNow   = !isDeploying && !isStoppingActive && !isJustStoppedRef.current && !isError && !isSealed && (connState === 'connected' || liveState === 'running') && !isDisconnected && !isReconnecting && !isWaitingCycle && connState !== 'idle'
  const isBotActive    = !isError && !isSealed && !isStoppingActive && !isStartingActive && !isJustStoppedRef.current && (isRunningNow || isWaitingCycle || isActuallyRunning || (!isDeploying && liveState === 'running' && connState !== 'idle'))

  const sealReasonText = useMemo(() => {
    if (!isSealed) return ''
    const rawReason = realSealReason || bot?.seal_reason || realStatusMsg || bot?.conn_message || (castle as any)?.status_message || bot?.last_error || ''
    const sealType = realSealType ?? bot?.seal_type ?? null
    return localizeCastleSealReason(sealType, rawReason, t)
  }, [isSealed, realSealType, realSealReason, realStatusMsg, bot?.seal_type, bot?.seal_reason, bot?.conn_message, bot?.last_error, castle, t])

  const [nowTick, setNowTick] = useState(() => Date.now())
  const nextRunValue = realNextRun || bot?.next_run_time || castle?.bot_status?.next_run_time || (castle as any)?.next_run_time || null
  const msgBaselineRef = useRef<{ msg: string; seenAt: number }>({ msg: '', seenAt: 0 })

  useEffect(() => {
    if (!isWaitingCycle) return
    setNowTick(Date.now())
    const timer = setInterval(() => setNowTick(Date.now()), 5000)
    return () => clearInterval(timer)
  }, [isWaitingCycle, nextRunValue])

  const waitingMinutes = useMemo(() => {
    if (!isWaitingCycle) return null
    const nextRun = nextRunValue
    if (nextRun) {
      let nextMs = new Date(nextRun).getTime()
      if (isNaN(nextMs) && typeof nextRun === 'string') {
        const timeParts = nextRun.match(/(\d{1,2}):(\d{2})(?::(\d{2}))?/)
        if (timeParts) {
          const h = parseInt(timeParts[1], 10)
          const m = parseInt(timeParts[2], 10)
          const s = timeParts[3] ? parseInt(timeParts[3], 10) : 0
          const d = new Date(nowTick)
          d.setHours(h, m, s, 0)
          if (d.getTime() < nowTick - 60000) {
            d.setDate(d.getDate() + 1)
          }
          nextMs = d.getTime()
        }
      }
      if (!isNaN(nextMs)) {
        const diffMs = nextMs - nowTick
        if (diffMs > 0) {
          return Math.max(1, Math.ceil(diffMs / 60000))
        }
        // إذا اقترب الموعد أو تجاوزه بثوانٍ بسبب فرق ساعة الخادم والمتصفح، لا نرجع للنص الثابت
        if (diffMs > -120000) {
          return 1
        }
      }
    }

    const msg = realStatusMsg || bot?.conn_message || castle?.bot_status?.conn_message || (castle as any)?.status_message || ''
    if (msg && msgBaselineRef.current.msg !== msg) {
      msgBaselineRef.current = { msg, seenAt: nowTick }
    }

    const timeMatch = msg.match(/(?:الساعة\s*)?(\d{1,2}):(\d{2})(?::\d{2})?/)
    if (timeMatch && !nextRun) {
      const targetHour = parseInt(timeMatch[1], 10)
      const targetMin = parseInt(timeMatch[2], 10)
      const target = new Date(nowTick)
      target.setHours(targetHour, targetMin, 0, 0)
      if (target.getTime() < nowTick - 60000) {
        target.setDate(target.getDate() + 1)
      }
      const diffMins = Math.ceil((target.getTime() - nowTick) / 60000)
      if (diffMins > 0 && diffMins <= 240) return diffMins
    }

    const explicitMins = msg.match(/(?:متبقي|انتظار)\s*(\d+(?:\.\d+)?)\s*دقيقة/i)
    if (explicitMins) {
      const initialMins = Math.ceil(parseFloat(explicitMins[1]))
      if (initialMins > 0) {
        const elapsedMins = Math.floor(Math.max(0, nowTick - msgBaselineRef.current.seenAt) / 60000)
        return Math.max(1, initialMins - elapsedMins)
      }
    }

    return null
  }, [isWaitingCycle, nextRunValue, realStatusMsg, bot?.conn_message, castle, nowTick])

  const handleToggleClick = (e: React.MouseEvent) => {
    e.stopPropagation()
    if (isStartingActive || isStoppingActive) return
    if (isDeploying) {
      toast.error(t('accounts.deployingToast', 'جاري رفع التغييرات إلى السيرفر... يرجى الانتظار حتى اكتمال التحديث واستئناف البوت تلقائياً'))
      return
    }
    if (isBanned) {
      toast.error(t('accounts.bannedToast'))
      return
    }
    if (isPendingApproval) {
      toast.error(t('accounts.pendingApprovalAlert', 'لا يمكن تشغيل البوت: حسابك بانتظار موافقة الإدارة لتفعيل الباقة التجريبية'))
      return
    }
    if (isExpired) {
      toast.error(t('accounts.expiredToast'))
      return
    }
    if (isPasswordError) {
      if (onEdit) onEdit(castle)
      else toast.error(t('accounts.passwordErrorToast', 'كلمة المرور غير صحيحة — يرجى تعديلها أولاً'))
      return
    }
    if (isBotActive) {
      setShowStopModal(true)
    } else {
      setIsStarting(true)
      setLiveState('starting')
      setConnState('starting')
      botControl.mutate({ castle, state: 'running' }, {
        onError: (err: any) => {
          setIsStarting(false)
          setLiveState('idle')
          setConnState('idle')
          const msg = err?.message || ''
          toast.error(localizeApiError(msg, t))
        }
      })
    }
  }

  const handleConfirmStop = () => {
    setIsStopping(true)
    isJustStoppedRef.current = true
    if (stopGraceTimerRef.current) clearTimeout(stopGraceTimerRef.current)
    stopGraceTimerRef.current = setTimeout(() => {
      isJustStoppedRef.current = false
    }, 2500)
    setLiveState('idle')
    setConnState('idle')
    botControl.mutate({ castle, state: 'idle' }, {
      onSuccess: () => {
        toast.success(t('accounts.botStoppedSuccess'))
        setShowStopModal(false)
        isJustStoppedRef.current = true
        setLiveState('idle')
        setConnState('idle')
        setIsStopping(false)
        if (stopGraceTimerRef.current) clearTimeout(stopGraceTimerRef.current)
        stopGraceTimerRef.current = setTimeout(() => {
          isJustStoppedRef.current = false
        }, 2500)
      },
      onError: () => {
        toast.error(t('accounts.botStopError'))
        setShowStopModal(false)
        isJustStoppedRef.current = false
        if (stopGraceTimerRef.current) clearTimeout(stopGraceTimerRef.current)
        setIsStopping(false)
      }
    })
  }

  return (
    <div
      className={clsx(
        'relative border rounded-2xl overflow-hidden castle-card',
        (isBanned || isExpired) && !isRunningNow
          ? 'castle-card-locked bg-gray-50 dark:bg-gray-900 border-rose-500/40'
          : isDeploying
          ? 'castle-card-deploying dark:bg-gray-900 border-amber-500/50'
          : isError || isSealed
          ? 'castle-card-error bg-rose-50/50 dark:bg-gray-900 border-rose-500/50'
          : isRunningNow
          ? 'castle-card-running dark:bg-gray-900 border-emerald-500/50'
          : isWaitingCycle
          ? 'castle-card-waiting dark:bg-gray-900 border-sky-500/40'
          : isDisconnected
          ? 'castle-card-disconnected dark:bg-gray-900 border-amber-500/40'
          : isReconnecting
          ? 'castle-card-reconnecting dark:bg-gray-900 border-orange-500/40'
          : isPending || liveState === 'pending'
          ? 'castle-card-pending dark:bg-gray-900 border-amber-500/30'
          : 'castle-card-idle dark:bg-gray-900/90 border-gray-200 dark:border-gray-800'
      )}
    >

      {/* ── Header Row ─────────────────────────────────────── */}
      <div
        onClick={handleToggleExpand}
        className="flex sm:flex-row flex-col justify-between sm:items-center gap-2.5 sm:gap-3.5 p-3 sm:p-4 cursor-pointer select-none castle-card-header"
      >
        <div className="flex items-center gap-2.5 sm:gap-3 min-w-0">
          {typeof index === 'number' && (
            <span className="hidden sm:inline-block w-5 font-mono font-bold text-gray-400 dark:text-gray-500 text-xs select-none castle-index">
              {String(index + 1).padStart(2, '0')}
            </span>
          )}

          <div className="relative flex-shrink-0">
            <div
              className={clsx(
                'flex justify-center items-center rounded-xl sm:rounded-2xl w-10 sm:w-12 h-10 sm:h-12 overflow-hidden font-black text-base castle-avatar',
                isDeploying
                  ? 'avatar-deploying bg-amber-500/20 border border-amber-400/60 text-amber-700 dark:text-amber-300'
                  : isError || isSealed
                  ? 'avatar-error bg-rose-100 dark:bg-rose-500/20 border border-rose-400/60 text-rose-700 dark:text-rose-300'
                  : isRunningNow
                  ? 'avatar-running bg-emerald-500/20 border border-emerald-400/60 text-emerald-700 dark:text-emerald-300'
                  : isWaitingCycle
                  ? 'avatar-waiting bg-sky-500/20 border border-sky-400/60 text-sky-700 dark:text-sky-300'
                  : isDisconnected
                  ? 'avatar-disconnected bg-amber-500/20 border border-amber-400/60 text-amber-700 dark:text-amber-300'
                  : 'avatar-idle bg-gray-100 dark:bg-white/[0.05] border border-gray-200 dark:border-white/15 text-gray-500 dark:text-white/80'
              )}
            >
              {isCustomAvatar && !imgError ? (
                <img
                  src={avatarUrl}
                  alt={displayLordName}
                  className="rounded-xl sm:rounded-2xl w-full h-full object-cover select-none"
                  onError={() => setImgError(true)}
                  loading="lazy"
                />
              ) : (
                <img
                  src="/images/castles/main_castle_square.png"
                  alt={displayLordName}
                  className="p-1 w-full h-full object-contain select-none"
                  loading="lazy"
                />
              )}
            </div>
            {info.castle_level > 0 && (
              <span
                className="-bottom-1 absolute bg-amber-600 px-1.5 py-0.5 border border-amber-200/50 rounded-full font-black text-[9px] text-white leading-none select-none -end-1"
                title={t('accounts.castleLevelTitle', 'القلعة الرئيسية - المستوى: {{level}}', { level: info.castle_level })}
              >
                {info.castle_level}
              </span>
            )}
          </div>

          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-1.5 sm:gap-2">
              <span className="font-bold text-gray-900 dark:text-white text-sm sm:text-base truncate tracking-wide castle-lord-name">
                {displayLordName}
              </span>

              <span
                className="hidden sm:inline-flex items-center gap-1 bg-amber-500/12 px-2 py-0.5 border border-amber-500/30 rounded-md font-bold text-amber-800 dark:text-amber-300 text-xs select-none castle-badge"
                title={t('accounts.castleLevelTitle', 'القلعة الرئيسية - المستوى: {{level}}', { level: info.castle_level || 1 })}
              >
                <img
                  src="/images/castles/main_castle_square.png"
                  alt={t('accounts.mainCastle', 'القلعة الرئيسية')}
                  className="w-4 h-4 object-contain select-none shrink-0"
                  loading="lazy"
                />
                <span>
                  {info.castle_level > 0 ? `${t('accounts.castleLevelPrefix', 'قلعة')} ${info.castle_level}` : t('accounts.mainCastle', 'القلعة الرئيسية')}
                </span>
              </span>

              {info.alliance_name && (
                <span className="hidden sm:inline-block bg-primary-500/15 px-2 py-0.5 border border-primary-500/30 rounded-md font-semibold text-primary-700 dark:text-primary-300 text-xs castle-alliance-badge">
                  [{info.alliance_name.split(' ')[0]}]
                </span>
              )}

              {info.vip_level > 0 && (
                <span className="flex items-center gap-1 bg-amber-500/15 px-1.5 py-0.5 border border-amber-500/35 rounded-md font-bold text-[10px] text-amber-700 dark:text-amber-300 castle-vip-badge">
                  <Crown size={10} className="text-amber-600 dark:text-amber-400" />
                  VIP {info.vip_level}
                </span>
              )}

              {isDeploying ? (
                <span className="flex items-center gap-1.5 bg-amber-500/20 px-2 sm:px-2.5 py-0.5 border border-amber-500/50 rounded-full font-bold text-[10px] text-amber-800 dark:text-amber-300 sm:text-xs castle-status-badge status-badge-deploying">
                  <Loader2 size={12} className="text-amber-600 dark:text-amber-400 animate-spin" />
                  <span>{t('accounts.deployingBadge', 'جاري رفع التحديثات...')}</span>
                </span>
              ) : isBanned ? (
                <span className="flex items-center gap-1.5 bg-rose-500/20 px-2 sm:px-2.5 py-0.5 border border-rose-500/50 rounded-full font-bold text-[10px] text-rose-700 dark:text-rose-300 sm:text-xs castle-status-badge status-badge-banned">
                  <ShieldAlert size={12} className="text-rose-600 dark:text-rose-400" />
                  <span>{t('status.banned')}</span>
                </span>
              ) : isExpired ? (
                <span className="flex items-center gap-1.5 bg-rose-500/15 px-2 sm:px-2.5 py-0.5 border border-rose-500/40 rounded-full font-bold text-[10px] text-rose-700 dark:text-rose-300 sm:text-xs castle-status-badge status-badge-expired">
                  <AlertTriangle size={12} className="text-rose-600 dark:text-rose-400" />
                  <span>{t('status.stoppedExpired')}</span>
                </span>
              ) : isSealed ? (
                <span
                  className="flex items-center gap-1.5 bg-rose-500/20 px-2 sm:px-2.5 py-0.5 border border-rose-500/50 rounded-full font-bold text-[10px] text-rose-700 dark:text-rose-300 sm:text-xs castle-status-badge status-badge-sealed"
                  title={sealReasonText}
                >
                  <ShieldAlert size={12} className="text-rose-600 dark:text-rose-400 shrink-0" />
                  <span>{t('status.castleSealed', 'محظور من اللعبة')}</span>
                </span>
              ) : isError ? (
                <span className="flex items-center gap-1.5 bg-rose-500/20 px-2 sm:px-2.5 py-0.5 border border-rose-500/50 rounded-full font-bold text-[10px] text-rose-700 dark:text-rose-300 sm:text-xs castle-status-badge status-badge-error">
                  {isPasswordError ? (
                    <>
                      <KeyRound size={12} className="text-rose-600 dark:text-rose-400" />
                      <span>{t('status.passwordError', 'كلمة المرور خاطئة')}</span>
                    </>
                  ) : (
                    <>
                      <span className="bg-rose-600 dark:bg-rose-400 rounded-full w-1.5 h-1.5" />
                      <span>{bot?.conn_message ? t('status.authError', 'خطأ في المصادقة') : t('status.error', 'خطأ')}</span>
                    </>
                  )}
                </span>
              ) : isPending || liveState === 'pending' ? (
                <span className="flex items-center gap-1 bg-amber-500/15 px-2 py-0.5 border border-amber-500/30 rounded-full font-semibold text-[10px] text-amber-700 dark:text-amber-400 sm:text-xs castle-status-badge status-badge-pending">
                  <Clock size={11} />
                  <span>{t('status.pending')}</span>
                </span>
              ) : isDisconnected ? (
                <span className="flex items-center gap-1 bg-amber-500/20 px-2 py-0.5 border border-amber-500/50 rounded-full font-bold text-[10px] text-amber-700 dark:text-amber-300 sm:text-xs castle-status-badge status-badge-disconnected">
                  <span className="bg-amber-600 dark:bg-amber-400 rounded-full w-1.5 h-1.5" />
                  <span>{t('status.otherDevice')}</span>
                </span>
              ) : isReconnecting ? (
                <span className="flex items-center gap-1 bg-orange-500/15 px-2 py-0.5 border border-orange-500/35 rounded-full font-semibold text-[10px] text-orange-700 dark:text-orange-300 sm:text-xs castle-status-badge status-badge-reconnecting">
                  <span className="bg-orange-600 dark:bg-orange-400 rounded-full w-1.5 h-1.5 animate-spin" style={{borderRadius:'50%', border:'2px solid transparent', borderTopColor:'currentColor'}} />
                  <span>{t('status.reconnecting')}</span>
                </span>
              ) : isWaitingCycle ? (
                <span
                  className="flex items-center gap-1.5 bg-sky-500/15 px-2 py-0.5 border border-sky-500/35 rounded-full font-semibold text-[10px] text-sky-700 dark:text-sky-300 sm:text-xs castle-status-badge status-badge-waiting"
                  title={realStatusMsg || bot?.conn_message || (castle as any)?.status_message || t('status.waitingCycle')}
                >
                  <span className="bg-sky-600 dark:bg-sky-400 rounded-full w-1.5 h-1.5" />
                  <span>
                    {waitingMinutes != null
                      ? t('status.waitingCountdown', { count: waitingMinutes })
                      : t('status.waitingCycle')}
                  </span>
                </span>
              ) : isRunningNow ? (
                <span
                  className="flex items-center gap-1.5 bg-emerald-500/20 px-2 sm:px-2.5 py-0.5 border border-emerald-500/50 rounded-full font-bold text-[10px] text-emerald-700 dark:text-emerald-300 sm:text-xs castle-status-badge status-badge-running"
                  title={bot?.conn_message || t('status.runningNow')}
                >
                  <span className="bg-emerald-600 dark:bg-emerald-400 rounded-full w-1.5 h-1.5" />
                  <span>{t('status.runningNow')}</span>
                </span>
              ) : (
                <span className="flex items-center gap-1 bg-gray-100 dark:bg-white/5 px-2 py-0.5 border border-gray-200 dark:border-white/10 rounded-full font-medium text-[10px] text-gray-500 dark:text-gray-400 sm:text-xs castle-status-badge status-badge-idle">
                  <span className="bg-gray-400 dark:bg-gray-500 rounded-full w-1.5 h-1.5" />
                  <span>{t('status.idle')}</span>
                </span>
              )}
            </div>

            <div className="hidden sm:block mt-0.5 font-mono text-gray-500 dark:text-gray-400 text-xs truncate select-none castle-email">
              {castle.email}
            </div>


            <div className="flex flex-wrap items-center gap-1 sm:gap-1.5 mt-1 sm:mt-1.5">
              {typeof resources.stamina === 'number' && (
                <span className="flex items-center gap-1 bg-amber-50 dark:bg-amber-500/10 px-1.5 sm:px-2 py-0.5 border border-amber-300 dark:border-amber-500/25 rounded-md font-bold text-[10px] text-amber-800 sm:text-[11px] dark:text-amber-300 castle-stat-stamina" title={t('resources.stamina', 'طاقة الأمير')}>
                  <Zap size={10} className="text-amber-600 dark:text-amber-400" />
                  {resources.stamina}
                </span>
              )}

              <span className="flex items-center gap-1 bg-purple-500/10 px-1.5 sm:px-2 py-0.5 border border-purple-500/25 rounded-md font-semibold text-[10px] text-purple-700 sm:text-[11px] dark:text-purple-300 castle-stat-power" title={t('dashboard.stats.lordPower', 'القوة')}>
                <Shield size={10} className="text-purple-600 dark:text-purple-400" />
                {(info.lord_power / 1_000_000).toFixed(1)}M
              </span>

              <span className="flex items-center gap-1 bg-blue-500/10 px-1.5 sm:px-2 py-0.5 border border-blue-500/25 rounded-md font-semibold text-[10px] text-blue-700 sm:text-[11px] dark:text-blue-300 castle-stat-server">
                <Globe size={10} className="text-blue-600 dark:text-blue-400" />
                #{info.server_id}
              </span>

              <span className="hidden sm:flex items-center gap-1 bg-cyan-500/10 px-2 py-0.5 border border-cyan-500/25 rounded-md font-semibold text-[11px] text-cyan-700 dark:text-cyan-300 castle-stat-coords">
                <MapPin size={10} className="text-cyan-600 dark:text-cyan-400" />
                {info.coordinates.x},{info.coordinates.y}
              </span>
            </div>

            {isSealed && sealReasonText && (
              <div
                className="inline-flex items-center gap-1.5 bg-rose-500/10 mt-1.5 sm:mt-2 px-2.5 py-1 border border-rose-500/30 rounded-lg max-w-full font-semibold text-[11px] text-rose-700 dark:text-rose-300 sm:text-xs castle-seal-reason"
                title={sealReasonText}
              >
                <Ban size={12} className="text-rose-600 dark:text-rose-400 shrink-0" />
                <span className="truncate">{sealReasonText}</span>
              </div>
            )}
          </div>
        </div>

        <div className="flex justify-between sm:justify-end items-center gap-2 sm:ms-auto pt-2 sm:pt-0 border-gray-100 dark:border-white/6 border-t sm:border-t-0 w-full sm:w-auto">
          {isDeploying ? (
            <button
              type="button"
              disabled
              onClick={e => e.stopPropagation()}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1.5 bg-amber-50 dark:bg-amber-500/10 px-3.5 py-2 sm:py-1.5 border border-amber-300 dark:border-amber-500/30 rounded-xl sm:rounded-lg font-bold text-amber-800 dark:text-amber-300 text-xs cursor-not-allowed select-none btn-deploying"
            >
              <Loader2 size={13} className="text-amber-600 dark:text-amber-400 animate-spin" />
              <span>{t('accounts.updating', 'جاري التحديث...')}</span>
            </button>
          ) : isBanned ? (
            <button
              type="button"
              onClick={handleToggleClick}
              title={t('accounts.bannedTooltip')}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1.5 bg-rose-500/15 px-3.5 py-2 sm:py-1.5 border border-rose-500/40 rounded-xl sm:rounded-lg font-bold text-rose-700 dark:text-rose-300 text-xs cursor-pointer select-none castle-btn-toggle btn-locked"
            >
              <Lock size={13} className="text-rose-600 dark:text-rose-400" />
              <span>{t('accounts.lockedBanned')}</span>
            </button>
          ) : isPendingApproval ? (
            <button
              type="button"
              onClick={handleToggleClick}
              title={t('accounts.pendingApprovalAlert', 'لا يمكن تشغيل البوت: حسابك بانتظار موافقة الإدارة لتفعيل الباقة التجريبية')}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1.5 bg-amber-500/15 px-3.5 py-2 sm:py-1.5 border border-amber-500/40 rounded-xl sm:rounded-lg font-bold text-amber-700 dark:text-amber-500 text-xs cursor-pointer select-none castle-btn-toggle btn-locked"
            >
              <Clock size={13} className="text-amber-600 dark:text-amber-500" />
              <span>{t('admin.pendingApproval', 'بانتظار موافقة الإدارة')}</span>
            </button>
          ) : isExpired ? (
            <button
              type="button"
              onClick={handleToggleClick}
              title={t('accounts.expiredTooltip')}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1.5 bg-rose-500/15 px-3.5 py-2 sm:py-1.5 border border-rose-500/40 rounded-xl sm:rounded-lg font-bold text-rose-700 dark:text-rose-300 text-xs cursor-pointer select-none castle-btn-toggle btn-locked"
            >
              <Lock size={13} className="text-rose-600 dark:text-rose-400" />
              <span>{t('accounts.lockedExpired')}</span>
            </button>
          ) : isPending || liveState === 'pending' ? (
            <span
              onClick={e => e.stopPropagation()}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1 bg-amber-50 dark:bg-yellow-500/10 px-3 py-2 sm:py-1.5 border border-amber-300 dark:border-yellow-500/30 rounded-xl sm:rounded-lg font-semibold text-amber-800 dark:text-yellow-400 text-xs cursor-not-allowed"
            >
              <Clock size={13} />
              {t('status.pending')}
            </span>
          ) : isPasswordError ? (
            <button
              type="button"
              onClick={handleToggleClick}
              title={t('accounts.passwordErrorTooltip', 'كلمة المرور غير صحيحة — اضغط للتعديل')}
              className="flex sm:flex-initial flex-1 justify-center items-center gap-1.5 bg-rose-500/15 px-3.5 py-2 sm:py-1.5 border border-rose-500/40 rounded-xl sm:rounded-lg font-bold text-rose-700 dark:text-rose-300 text-xs cursor-pointer select-none castle-btn-toggle"
            >
              <KeyRound size={13} className="text-rose-600 dark:text-rose-400" />
              <span>{t('accounts.editPasswordBtn', 'تعديل كلمة السر')}</span>
            </button>
          ) : (
            <button
              onClick={handleToggleClick}
              disabled={isStoppingActive || isStartingActive}
              style={!isBotActive && !isStoppingActive && !isStartingActive ? { backgroundColor: 'var(--theme-primary)', color: '#ffffff' } : {}}
              className={clsx(
                'flex sm:flex-initial flex-1 justify-center items-center gap-1.5 px-3.5 py-2 sm:py-1.5 rounded-xl sm:rounded-lg font-bold text-xs select-none castle-btn-toggle',
                (isStoppingActive || isStartingActive)
                  ? 'cursor-not-allowed opacity-80'
                  : 'cursor-pointer',
                isStoppingActive
                  ? 'btn-stopping bg-slate-100 dark:bg-gray-800 border border-slate-300 dark:border-gray-700 text-slate-700 dark:text-gray-400'
                  : isStartingActive
                  ? 'btn-starting bg-emerald-50 dark:bg-gray-800 border border-emerald-300 dark:border-gray-700 text-emerald-800 dark:text-emerald-400'
                  : isBotActive
                  ? 'btn-stop-bot bg-rose-600 text-white'
                  : 'btn-start-bot text-white'
              )}
            >
              {isStoppingActive ? (
                <>
                  <Loader2 size={13} className="text-slate-500 dark:text-gray-300 animate-spin stopping-spinner" />
                  <span className="stopping-text">{t('status.stopping', 'جاري الإيقاف...')}</span>
                </>
              ) : isStartingActive ? (
                <>
                  <Loader2 size={13} className="text-emerald-600 dark:text-emerald-400 animate-spin starting-spinner" />
                  <span className="starting-text">{t('status.starting', 'جاري التشغيل...')}</span>
                </>
              ) : isBotActive ? (
                <>
                  <Square size={13} className="fill-white text-white" />
                  <span>{t('accounts.stopBot')}</span>
                </>
              ) : (
                <>
                  <Play size={13} className="fill-white text-white" />
                  <span>{t('accounts.startBot')}</span>
                </>
              )}
            </button>
          )}

          <div
            onClick={e => e.stopPropagation()}
            className="castle-icon-group flex items-center gap-0.5 bg-gray-100 dark:bg-white/[0.04] p-0.5 border border-gray-200 dark:border-white/8 rounded-xl sm:rounded-lg shrink-0"
          >
            {onEdit && (
              <button
                onClick={(e) => { e.stopPropagation(); onEdit(castle) }}
                className="p-1.5 rounded-lg sm:rounded-md text-gray-500 dark:text-gray-400 cursor-pointer castle-action-btn"
                title={t('accounts.editCredentials')}
              >
                <Edit2 size={15} />
              </button>
            )}

            {onDelete && (
              <button
                onClick={(e) => { e.stopPropagation(); onDelete(castle.id, castle.is_active) }}
                className="p-1.5 rounded-lg sm:rounded-md text-gray-500 cursor-pointer castle-action-btn castle-action-btn-delete"
                title={t('accounts.confirmDelete')}
              >
                <Trash2 size={15} />
              </button>
            )}

            <button
              type="button"
              onClick={handleToggleExpand}
              className={clsx(
                'p-1.5 rounded-lg sm:rounded-md cursor-pointer castle-action-btn castle-action-btn-expand',
                expanded
                  ? 'text-primary-700 dark:text-primary-400 bg-primary-500/15'
                  : 'text-gray-500 dark:text-gray-400'
              )}
              title={expanded ? t('accounts.hideSettings') : t('accounts.showSettings')}
            >
              {expanded ? <ChevronUp size={17} /> : <ChevronDown size={17} />}
            </button>
          </div>
        </div>
      </div>

      {/* ── Resources Row ─────────────────────────────────── */}
      <div
        onClick={handleToggleExpand}
        className="bg-gray-50 dark:bg-white/[0.01] px-3 sm:px-5 py-2 sm:py-3 border-gray-100 dark:border-white/8 border-t cursor-pointer select-none castle-resources-row"
      >
        <ResourceBar resources={resources} />
      </div>

      {/* ── Expanded Task Settings Accordion (Instant & Fast) ── */}
      {hasBeenExpanded && (
        <div
          className={clsx(
            'border-gray-100 dark:border-white/8 border-t w-full castle-expanded-section',
            expanded ? 'block' : 'hidden'
          )}
          onClick={e => e.stopPropagation()}
        >
          <div className="space-y-3 sm:space-y-5 bg-white dark:bg-transparent p-2 sm:p-4 md:p-6 w-full">
            <div className="w-full">
              <TaskTabContent
                castle={castle}
                userId={userId}
              />
            </div>
          </div>
        </div>
      )}

      <ConfirmStopModal
        isOpen={showStopModal}
        onClose={() => !isStoppingActive && setShowStopModal(false)}
        onConfirm={handleConfirmStop}
        lordName={displayLordName}
        email={castle.email}
        isPending={isStoppingActive}
      />
    </div>
  )
}

export const CastleCard = React.memo(CastleCardInner)
export default CastleCard
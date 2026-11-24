import React from 'react'
import { clsx } from 'clsx'
import type { BotState } from '../../types'

interface StatusBadgeProps {
  state: BotState
  label: string
  showDot?: boolean
}

const stateStyles: Record<BotState, string> = {
  running:      'badge-green',
  idle:         'badge-gray',
  error:        'badge-red',
  sealed:       'badge-red',
  paused:       'badge-yellow',
  pending:      'badge-yellow',
  disconnected: 'badge-yellow',
  reconnecting: 'badge-yellow',
  waiting:      'badge-blue',
  deploying:    'badge-yellow',
}

const dotStyles: Record<BotState, string> = {
  running:      'bg-emerald-400 ring-2 ring-emerald-400/30',
  idle:         'bg-gray-500',
  error:        'bg-red-500 ring-2 ring-red-500/30',
  sealed:       'bg-rose-500',
  paused:       'bg-yellow-500',
  pending:      'bg-yellow-500',
  disconnected: 'bg-amber-400',
  reconnecting: 'bg-orange-400',
  waiting:      'bg-sky-400 ring-2 ring-sky-400/25',
  deploying:    'bg-amber-400',
}

export function StatusBadge({ state, label, showDot = true }: StatusBadgeProps) {
  return (
    <span className={clsx('badge', stateStyles[state])}>
      {showDot && <span className={clsx('w-1.5 h-1.5 rounded-full', dotStyles[state])} />}
      {label}
    </span>
  )
}

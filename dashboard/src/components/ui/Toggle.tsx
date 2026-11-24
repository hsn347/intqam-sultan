import React from 'react'
import { clsx } from 'clsx'

interface ToggleProps {
  value: boolean
  onChange: (v: boolean) => void
  disabled?: boolean
  size?: 'sm' | 'md'
}

export function Toggle({ value, onChange, disabled, size = 'md' }: ToggleProps) {
  const isSmall = size === 'sm'
  const width = isSmall ? 36 : 44
  const height = isSmall ? 20 : 24
  const knobSize = isSmall ? 16 : 20
  const travel = width - knobSize - 4

  return (
    <button
      type="button"
      role="switch"
      aria-checked={value}
      disabled={disabled}
      onClick={(e) => {
        e.stopPropagation()
        if (!disabled) onChange(!value)
      }}
      style={{
        direction: 'ltr',
        width: `${width}px`,
        height: `${height}px`,
        minWidth: `${width}px`,
        ...(value ? {
          backgroundColor: 'var(--theme-primary)',
        } : {}),
      }}
      className={clsx(
        'inline-flex relative flex-shrink-0 items-center p-0.5 rounded-full focus:outline-none active:scale-95 transition-colors duration-150 cursor-pointer select-none',
        value
          ? 'border border-transparent'
          : 'bg-gray-700 border border-white/10',
        disabled && 'opacity-40 cursor-not-allowed active:scale-100'
      )}
    >
      <span
        style={{
          width: `${knobSize}px`,
          height: `${knobSize}px`,
          transform: value ? `translateX(${travel}px)` : 'translateX(0px)',
        }}
        className="block bg-white shadow-md rounded-full transition-transform duration-200 ease-out pointer-events-none"
      />
    </button>
  )
}

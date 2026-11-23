import React, { useState, useEffect, useMemo, useRef } from 'react'
import { Plus, Minus, Trash2, Check, RotateCcw, Loader2, SlidersHorizontal, Edit3 } from 'lucide-react'
import { clsx } from 'clsx'
import { Toggle } from '../ui/Toggle'
import { TaskTabs, TABS } from './TaskTabs'
import { useUpdateCastleConfig } from '../../hooks/useCastles'
import { updateCastle } from '../../lib/botApi'
import type { Castle, TaskTab, CastleConfig, StaminaConfig } from '../../types'
import { useTranslation } from 'react-i18next'
import toast from 'react-hot-toast'
import { localizeApiError } from '../../lib/localize'

/** مقارنة عميقة سريعة وخفيفة على الذاكرة دون تحويل الكائنات إلى سلاسل JSON */
export function fastDeepEqual(a: any, b: any): boolean {
  if (a === b) return true
  if (a == null || b == null) return false
  if (typeof a !== 'object' || typeof b !== 'object') return a === b

  const aIsArr = Array.isArray(a)
  const bIsArr = Array.isArray(b)
  if (aIsArr !== bIsArr) return false

  if (aIsArr) {
    if (a.length !== b.length) return false
    for (let i = 0; i < a.length; i++) {
      if (!fastDeepEqual(a[i], b[i])) return false
    }
    return true
  }

  const keysA = Object.keys(a)
  const keysB = Object.keys(b)
  if (keysA.length !== keysB.length) return false

  for (let i = 0; i < keysA.length; i++) {
    const key = keysA[i]
    if (!Object.prototype.hasOwnProperty.call(b, key)) return false
    if (!fastDeepEqual(a[key], b[key])) return false
  }
  return true
}

/** يحسب عدد الإعدادات الفردية المختلفة بين الإعداد الأصلي والمسودة بسرعة فائقة ودون استهلاك للذاكرة */
export function countConfigChanges(original: unknown, draft: unknown): number {
  if (original === draft) return 0
  if (original == null || draft == null) return 1
  if (typeof original !== 'object' || typeof draft !== 'object') {
    return original !== draft ? 1 : 0
  }
  if (Array.isArray(original) || Array.isArray(draft)) {
    return fastDeepEqual(original, draft) ? 0 : 1
  }
  let count = 0
  const origObj = original as Record<string, unknown>
  const draftObj = draft as Record<string, unknown>
  const allKeys = new Set([...Object.keys(origObj), ...Object.keys(draftObj)])
  for (const key of allKeys) {
    const oVal = origObj[key]
    const dVal = draftObj[key]
    if (oVal === dVal) continue
    if (
      typeof oVal === 'object' &&
      typeof dVal === 'object' &&
      oVal !== null &&
      dVal !== null &&
      !Array.isArray(oVal) &&
      !Array.isArray(dVal)
    ) {
      count += countConfigChanges(oVal, dVal)
    } else {
      if (!fastDeepEqual(oVal, dVal)) {
        count += 1
      }
    }
  }
  return count
}

// ─── Shared Helper Components ───────────────────────────────────────────────

/** محدد وزر رقمي مدمج وأنيق يدعم الكتابة المباشرة والأزرار */
function Stepper({
  value,
  min = 1,
  max = 99,
  step = 1,
  onChange,
  formatLabel,
}: {
  value: number
  min?: number
  max?: number
  step?: number
  onChange: (v: number) => void
  formatLabel?: (v: number) => string | React.ReactNode
}) {
  const [isFocused, setIsFocused] = useState(false)
  const [textValue, setTextValue] = useState(String(value))
  const [hasError, setHasError] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!isFocused) {
      setTextValue(String(value))
      setHasError(false)
    }
  }, [value, isFocused])

  const handleStep = (delta: number) => {
    const next = Math.min(max, Math.max(min, (Number(value) || 0) + delta * step))
    onChange(next)
    setTextValue(String(next))
    setHasError(false)
  }

  const commitValue = (valStr: string) => {
    const trimmed = valStr.trim()
    if (trimmed === '') {
      setTextValue(String(value))
      setHasError(false)
      return
    }
    const parsed = parseInt(trimmed, 10)
    if (isNaN(parsed)) {
      setTextValue(String(value))
      setHasError(false)
      return
    }
    const clamped = Math.min(max, Math.max(min, parsed))
    onChange(clamped)
    setTextValue(String(clamped))
    setHasError(false)
  }

  return (
    <div
      className={clsx(
        'inline-flex items-center bg-black/60 shadow-sm border border-white/10 rounded-md h-6 overflow-hidden transition-all duration-150 select-none task-stepper shrink-0',
        isFocused
          ? hasError
            ? 'border-rose-500 ring-1 ring-rose-500/40'
            : 'border-primary-400 ring-1 ring-primary-500/40'
          : 'hover:border-primary-500/40'
      )}
      style={{ direction: 'ltr' }}
    >
      {/* Minus button */}
      <button
        type="button"
        disabled={value <= min}
        onClick={() => handleStep(-1)}
        className="flex justify-center items-center bg-white/[0.03] hover:bg-primary-500/20 active:bg-primary-500/30 disabled:hover:bg-transparent disabled:opacity-20 border-white/5 border-r w-5 h-6 text-gray-300 hover:text-primary-300 transition-colors cursor-pointer disabled:cursor-not-allowed task-stepper-btn shrink-0"
        title={`- (${min})`}
      >
        <Minus size={10} strokeWidth={2.5} />
      </button>

      {/* Center Numeric Pod */}
      <div
        onClick={() => inputRef.current?.focus()}
        className={clsx(
          'relative flex justify-center items-center px-0.5 h-6 transition-colors cursor-text task-stepper-pod shrink-0',
          formatLabel ? 'w-auto min-w-[50px] px-1.5' : 'w-7 min-w-[28px] max-w-[28px]',
          isFocused ? 'bg-black/90' : 'bg-black/30 hover:bg-black/50'
        )}
        title={`(${min} - ${max})`}
      >
        <input
          ref={inputRef}
          type="text"
          inputMode="numeric"
          pattern="[0-9]*"
          value={isFocused ? textValue : (formatLabel ? '' : value)}
          placeholder={formatLabel ? '' : String(value)}
          onFocus={(e) => {
            setIsFocused(true)
            setTextValue(String(value))
            setHasError(false)
            setTimeout(() => e.target.select(), 10)
          }}
          onChange={(e) => {
            const clean = e.target.value.replace(/[^0-9]/g, '')
            setTextValue(clean)
            if (clean === '') {
              setHasError(false)
              return
            }
            const num = parseInt(clean, 10)
            if (!isNaN(num)) {
              if (num > max || num < min) {
                setHasError(true)
              } else {
                setHasError(false)
                onChange(num)
              }
            }
          }}
          onBlur={() => {
            setIsFocused(false)
            commitValue(textValue)
          }}
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              e.currentTarget.blur()
            } else if (e.key === 'Escape') {
              setTextValue(String(value))
              setIsFocused(false)
              setHasError(false)
              e.currentTarget.blur()
            } else if (e.key === 'ArrowUp') {
              e.preventDefault()
              handleStep(e.shiftKey ? 5 : 1)
            } else if (e.key === 'ArrowDown') {
              e.preventDefault()
              handleStep(e.shiftKey ? -5 : -1)
            }
          }}
          style={{ width: '100%', minWidth: 0 }}
          className="bg-transparent selection:bg-primary-500/40 px-0 outline-none font-mono font-bold text-primary-400 text-xs text-center cursor-text task-stepper-input"
        />

        {/* Formatted label overlay when blurred */}
        {!isFocused && formatLabel && (
          <span className="absolute inset-0 flex justify-center items-center px-1 font-bold text-[11px] text-primary-400 whitespace-nowrap pointer-events-none task-stepper-label">
            {formatLabel(value)}
          </span>
        )}
      </div>

      {/* Plus button */}
      <button
        type="button"
        disabled={value >= max}
        onClick={() => handleStep(1)}
        className="flex justify-center items-center bg-white/[0.03] hover:bg-primary-500/20 active:bg-primary-500/30 disabled:hover:bg-transparent disabled:opacity-20 border-white/5 border-l w-5 h-6 text-gray-300 hover:text-primary-300 transition-colors cursor-pointer disabled:cursor-not-allowed task-stepper-btn shrink-0"
        title={`+ (${max})`}
      >
        <Plus size={10} strokeWidth={2.5} />
      </button>
    </div>
  )
}

/** بطاقة مورد قابلة للتحديد */
function ResCard({ img, label, selected, onClick }: { img: string; label: string; selected: boolean; onClick: () => void }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={clsx('task-res-card', selected ? 'selected' : 'unselected')}
      style={{
        flex: '1 1 0',
        minWidth: '58px',
        padding: '5px 4px',
        borderRadius: '8px',
        border: selected ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)' : '1px solid rgba(255,255,255,0.10)',
        background: selected ? 'rgba(var(--theme-primary-rgb),0.12)' : 'rgba(255,255,255,0.04)',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '3px',
        cursor: 'pointer',
        transition: 'all 0.15s',
        color: selected ? 'var(--theme-primary-light)' : '#9ca3af',
        fontSize: '11px', fontWeight: selected ? 600 : 400,
        fontFamily: 'inherit',
      }}
    >
      <img src={img} alt={label} style={{ width: '22px', height: '22px', objectFit: 'contain' }}
        onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
      />
      {label}
    </button>
  )
}

// ─── Task Accordion Context (قائمة منسدلة أحادية: واحدة فقط تفتح في نفس الوقت) ──
interface TaskAccordionContextValue {
  expandedTaskId: string | null
  toggleTask: (id: string) => void
}

const TaskAccordionContext = React.createContext<TaskAccordionContextValue>({
  expandedTaskId: null,
  toggleTask: () => {},
})

/** صف مهمة مع toggle وقائمة منسدلة للخيارات الفرعية بسهم مميز */
function TaskRow({
  id, img, emoji, label, description, enabled, onToggle, children, comingSoon = true, badge,
}: {
  id?: string; img?: string; emoji?: string; label: string; description?: string;
  enabled: boolean; onToggle: (v: boolean) => void;
  children?: React.ReactNode; comingSoon?: boolean; badge?: React.ReactNode;
}) {
  const { t } = useTranslation()
  const { expandedTaskId, toggleTask } = React.useContext(TaskAccordionContext)
  const taskId = id || label
  const hasOptions = Boolean(children)
  const isOpen = hasOptions && expandedTaskId === taskId
  const rowRef = useRef<HTMLDivElement>(null)

  // انتقال سلس وسريع: توسيط المكون في الشاشة، أو إظهار أعلاه إذا كان أطول من الشاشة
  useEffect(() => {
    if (isOpen && rowRef.current) {
      const timer = setTimeout(() => {
        if (!rowRef.current) return
        const rect = rowRef.current.getBoundingClientRect()
        const isMobile = window.innerWidth < 768
        const headerOffset = isMobile ? 65 : 24
        const bottomOffset = isMobile ? 65 : 0
        const usableHeight = window.innerHeight - headerOffset - bottomOffset
        const elementHeight = rect.height

        let targetY: number
        if (elementHeight >= usableHeight) {
          // إذا كان المكون أطول من الشاشة: يظهر أعلى المكون مباشرة أسفل الهيدر
          targetY = window.scrollY + rect.top - headerOffset - 8
        } else {
          // إذا كان المكون يتسع في الشاشة: يتم توسيطه عمودياً في المنتصف تماماً
          const verticalPadding = (usableHeight - elementHeight) / 2
          targetY = window.scrollY + rect.top - headerOffset - verticalPadding
        }

        window.scrollTo({
          top: Math.max(0, Math.round(targetY)),
          behavior: 'smooth',
        })
      }, 75)
      return () => clearTimeout(timer)
    }
  }, [isOpen])

  return (
    <div
      ref={rowRef}
      className={clsx(
        'transition-all duration-200 task-row-card',
        enabled && !comingSoon ? 'enabled' : 'disabled',
        comingSoon && 'coming-soon',
        isOpen && 'task-row-expanded shadow-md'
      )}
      style={{
        background: enabled && !comingSoon
          ? (isOpen ? 'rgba(var(--theme-primary-rgb),0.08)' : 'rgba(var(--theme-primary-rgb),0.05)')
          : (isOpen ? 'rgba(255,255,255,0.05)' : 'rgba(255,255,255,0.03)'),
        border: enabled && !comingSoon
          ? (isOpen ? '1.5px solid rgba(var(--theme-primary-rgb),0.35)' : '1px solid rgba(var(--theme-primary-rgb),0.18)')
          : (isOpen ? '1.5px solid rgba(255,255,255,0.14)' : '1px solid rgba(255,255,255,0.08)'),
        borderRadius: '12px',
        overflow: 'hidden',
      }}
    >
      <div
        onClick={() => {
          if (comingSoon) return
          if (hasOptions) {
            toggleTask(taskId)
          } else {
            onToggle(!enabled)
          }
        }}
        style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '6px 10px', gap: '8px',
          cursor: comingSoon ? 'default' : 'pointer',
          userSelect: 'none',
        }}
        className="hover:bg-white/[0.04] active:bg-white/[0.06] transition-colors task-row-header"
      >
        {/* الطرف الأيمن: أيقونة المهمة واسمها */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '7px', minWidth: 0, flex: 1 }} title={description}>
          {img ? (
            <img src={img} alt={label} style={{ width: '22px', height: '22px', objectFit: 'contain', flexShrink: 0 }}
              onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
            />
          ) : emoji ? (
            <span style={{ fontSize: '15px', flexShrink: 0 }}>{emoji}</span>
          ) : null}
          <div style={{ minWidth: 0, display: 'flex', flexDirection: 'column', gap: '1px' }}>
            <div style={{ minWidth: 0, display: 'flex', alignItems: 'center', gap: '6px', flexWrap: 'wrap' }}>
              <div className="task-row-label" style={{ color: comingSoon ? '#9ca3af' : '#f0fdf4', fontWeight: 600, fontSize: '12px' }}>
                {label}
              </div>
              {badge}
              {comingSoon && (
                <span
                  className="task-coming-soon-badge"
                  style={{
                    fontSize: '10px',
                    padding: '1.5px 6px',
                    borderRadius: '6px',
                    background: 'rgba(234, 179, 8, 0.14)',
                    border: '1px solid rgba(234, 179, 8, 0.25)',
                    color: '#fef08a',
                    fontWeight: 600,
                    userSelect: 'none',
                  }}
                >
                  {t('tasks.comingSoon', 'قريباً')}
                </span>
              )}
            </div>
            {description && (
              <div style={{ color: '#94a3b8', fontSize: '10px', lineHeight: '1.2' }}>
                {description}
              </div>
            )}
          </div>
        </div>

        {/* الطرف الأيسر: السهم المميز (فقط للمهام ذات الخيارات) + زر التفعيل Toggle */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flexShrink: 0 }}>
          {hasOptions && (
            <button
              type="button"
              aria-label="Toggle options"
              onClick={(e) => {
                e.stopPropagation()
                toggleTask(taskId)
              }}
              className={clsx(
                'flex justify-center items-center rounded-lg transition-all duration-200 cursor-pointer task-accordion-arrow',
                isOpen
                  ? 'is-open bg-primary-500/25 text-primary-300 border border-primary-500/50 shadow-xs ring-1 ring-primary-500/30'
                  : 'bg-white/[0.07] text-gray-300 hover:text-white hover:bg-white/12 border border-white/10'
              )}
              style={{
                width: '24px',
                height: '24px',
              }}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                style={{
                  width: '13px',
                  height: '13px',
                  transform: isOpen ? 'rotate(180deg)' : 'rotate(0deg)',
                  transition: 'transform 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
                }}
              >
                <path
                  fillRule="evenodd"
                  d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z"
                  clipRule="evenodd"
                />
              </svg>
            </button>
          )}

          <div onClick={(e) => e.stopPropagation()} style={{ display: 'flex', alignItems: 'center' }}>
            <Toggle value={enabled} onChange={onToggle} disabled={comingSoon} size="sm" />
          </div>
        </div>
      </div>

      {/* محتوى الخيارات: يظهر فقط عند فتح القائمة */}
      {hasOptions && !comingSoon && isOpen && (
        <div
          className="animate-in duration-200 task-row-children fade-in-50"
          style={{
            padding: '0 10px 8px',
            borderTop: '1px solid rgba(255,255,255,0.06)',
          }}
        >
          <div style={{ paddingTop: '6px' }}>{children}</div>
        </div>
      )}
    </div>
  )
}

/** عنوان قسم */
function SectionLabel({ text }: { text: string }) {
  return <div className="task-section-label" style={{ color: '#9ca3af', fontSize: '11px', fontWeight: 500, marginBottom: '4px' }}>{text}</div>
}

// ─── Resource definitions ────────────────────────────────────────────────────

const MARCH_RESOURCES = [
  { v: 2, img: '/images/gather/mtahil.png',  resKey: 'resources.food' },
  { v: 3, img: '/images/gather/modun.png',   resKey: 'resources.wood' },
  { v: 4, img: '/images/gather/mdemir.png',  resKey: 'resources.iron' },
  { v: 5, img: '/images/daily/metal.png',    resKey: 'resources.silver' },
  { v: 6, img: '/images/gather/mkuvars.png', resKey: 'resources.crystal' },
  { v: 1, img: '/images/gather/altin.png',   resKey: 'resources.gold' },
]

const TRANSPORT_RESOURCES = [
  { id: 1002, key: 'food',    img: '/images/resources/mtahil.png',  resKey: 'resources.food' },
  { id: 1003, key: 'wood',    img: '/images/resources/modun.png',   resKey: 'resources.wood' },
  { id: 1004, key: 'iron',    img: '/images/resources/mdemir.png',  resKey: 'resources.iron' },
  { id: 1005, key: 'silver',  img: '/images/daily/metal.png',       resKey: 'resources.silver' },
  { id: 1006, key: 'crystal', img: '/images/resources/mkuvars.png', resKey: 'resources.crystal' },
]

const WATERMILL_RESOURCES = [
  { key: 'food',    img: '/images/watermill/uretimtahil.png',  resKey: 'resources.food'    },
  { key: 'wood',    img: '/images/watermill/uretimodun.png',   resKey: 'resources.wood'    },
  { key: 'iron',    img: '/images/watermill/uretimdemir.png',  resKey: 'resources.iron'    },
  { key: 'diamond', img: '/images/watermill/uretimkuvars.png', resKey: 'resources.diamond' },
]

const FOUNTAIN_RESOURCES = [
  { key: 'food',    resKey: 'resources.food',    img: '/images/fountain/food.png' },
  { key: 'wood',    resKey: 'resources.wood',    img: '/images/fountain/wood.png' },
  { key: 'iron',    resKey: 'resources.iron',    img: '/images/fountain/iron.png' },
  { key: 'coal',    resKey: 'resources.coal',     img: '/images/fountain/coal.png' },
  { key: 'diamond', resKey: 'resources.diamond', img: '/images/fountain/diamond.png' },
  { key: 'crystal', resKey: 'resources.crystal', img: '/images/resources/mkuvars.png' },
] as const

const WATERMILL_BOOST_RESOURCES = [
  { key: 'food',   resKey: 'resources.food',   img: '/images/boosts/icon_building_up_food.png' },
  { key: 'wood',   resKey: 'resources.wood',   img: '/images/boosts/icon_building_up_wood.png' },
  { key: 'iron',   resKey: 'resources.iron',   img: '/images/boosts/icon_building_up_iron.png' },
  { key: 'silver', resKey: 'resources.silver', img: '/images/boosts/icon_building_up_silver.png' },
  { key: 'crystal', resKey: 'resources.crystal', img: '/images/boosts/icon_building_up_crystal.png' },
] as const

// أنواع القوات والتدريب العسكري
const BARRACKS_TYPES = [
  { key: 'infantry', labelKey: 'tasks.infantry', emoji: '🛡️', img: '/images/soldiers/armyicon_s_401.png' },
  { key: 'cavalry',  labelKey: 'tasks.cavalry',  emoji: '🐎', img: '/images/soldiers/armyicon_s_501.png' },
  { key: 'archers',  labelKey: 'tasks.archers',  emoji: '🏹', img: '/images/soldiers/armyicon_s_601.png' },
  { key: 'chariots', labelKey: 'tasks.chariots', emoji: '🚜', img: '/images/soldiers/armyicon_s_701.png' },
]

export const PET_TARGETS = [
  { id: 1251, name: 'الحصان',              labelKey: 'tasks.pet_1251', emoji: '🐎', img: '/images/pets/1251.png' },
  { id: 1252, name: 'الفهد',               labelKey: 'tasks.pet_1252', emoji: '🐆', img: '/images/pets/1252.png' },
  { id: 1253, name: 'الصقر',               labelKey: 'tasks.pet_1253', emoji: '🦅', img: '/images/pets/1253.png' },
  { id: 1254, name: 'جمل عربي',            labelKey: 'tasks.pet_1254', emoji: '🐪', img: '/images/pets/1254.png' },
  { id: 1255, name: 'ذئب عربي',            labelKey: 'tasks.pet_1255', emoji: '🐺', img: '/images/pets/1255.png' },
  { id: 1256, name: 'أسد عربي',            labelKey: 'tasks.pet_1256', emoji: '🦁', img: '/images/pets/1256.png' },
  { id: 1257, name: 'الوشق',               labelKey: 'tasks.pet_1257', emoji: '🐱', img: '/images/pets/1257.png' },
  { id: 1258, name: 'أيّل',                labelKey: 'tasks.pet_1258', emoji: '🦌', img: '/images/pets/1258.png' },
  { id: 1259, name: 'فيل',                 labelKey: 'tasks.pet_1259', emoji: '🐘', img: '/images/pets/1259.png' },
  { id: 1260, name: 'دب',                  labelKey: 'tasks.pet_1260', emoji: '🐻', img: '/images/pets/1260.png' },
  { id: 1261, name: 'المها',               labelKey: 'tasks.pet_1261', emoji: '🦌', img: '/images/pets/1261.png' },
  { id: 1262, name: 'ثعبان',               labelKey: 'tasks.pet_1262', emoji: '🐍', img: '/images/pets/1262.png' },
  { id: 1263, name: 'اللآما',              labelKey: 'tasks.pet_1263', emoji: '🦙', img: '/images/pets/1263.png' },
  { id: 1264, name: 'الضب',                labelKey: 'tasks.pet_1264', emoji: '🦎', img: '/images/pets/1264.png' },
  { id: 1265, name: 'النمر الأبيض',         labelKey: 'tasks.pet_1265', emoji: '🐅', img: '/images/pets/1265.png' },
  { id: 1266, name: 'طائر حورس',           labelKey: 'tasks.pet_1266', emoji: '🦅', img: '/images/pets/1266.png' },
  { id: 1267, name: 'تنين المجد التليد',    labelKey: 'tasks.pet_1267', emoji: '🐉', img: '/images/pets/1267.png' },
  { id: 1268, name: 'الغوريلا',            labelKey: 'tasks.pet_1268', emoji: '🦍', img: '/images/pets/1268.png' },
] as const

const WORKSHOP_MATERIALS = [
  { id: 200101, labelKey: 'tasks.herb',       img: '/images/materials/2001.png' },
  { id: 200201, labelKey: 'tasks.purpleWood', img: '/images/materials/2002.png' },
  { id: 200301, labelKey: 'tasks.bronze',     img: '/images/materials/2003.png' },
  { id: 200401, labelKey: 'tasks.ruby',       img: '/images/materials/2004.png' },
  { id: 200501, labelKey: 'tasks.fur',        img: '/images/materials/2005.png' },
  { id: 200601, labelKey: 'tasks.horn',       img: '/images/materials/2006.png' },
] as const

const DEFAULT_WORKSHOP_MATERIAL_IDS = WORKSHOP_MATERIALS.map(m => m.id)

export const EQUIPMENT_CATEGORIES = [
  { key: 'weapon',   labelKey: 'tasks.equipWeapon',   img: '/images/daily/equip/weapon.png' },
  { key: 'clothes',  labelKey: 'tasks.equipClothes',  img: '/images/daily/equip/clothes.png' },
  { key: 'helmet',   labelKey: 'tasks.equipHelmet',   img: '/images/daily/equip/helmet.png' },
  { key: 'trousers', labelKey: 'tasks.equipTrousers', img: '/images/daily/equip/trousers.png' },
  { key: 'shoes',    labelKey: 'tasks.equipShoes',    img: '/images/daily/equip/shoes.png' },
  { key: 'ring',     labelKey: 'tasks.equipRing',     img: '/images/daily/equip/ring.png' },
] as const

export interface LordSkillDef {
  id: string
  img: string
  labelKey: string
  category: 'battle' | 'develop' | 'auxiliary'
}

export const LORD_SKILLS: LordSkillDef[] = [
  // ⚔️ قتال (Battle - 6)
  { id: '11011', img: '/images/skills/lord/Battle_11.png', labelKey: 'tasks.skill11011', category: 'battle' },
  { id: '11028', img: '/images/skills/lord/Battle_28.png', labelKey: 'tasks.skill11028', category: 'battle' },
  { id: '11029', img: '/images/skills/lord/Battle_29.png', labelKey: 'tasks.skill11029', category: 'battle' },
  { id: '11042', img: '/images/skills/lord/Battle_42.png', labelKey: 'tasks.skill11042', category: 'battle' },
  { id: '11056', img: '/images/skills/lord/Battle_44.png', labelKey: 'tasks.skill11056', category: 'battle' },
  { id: '11057', img: '/images/skills/lord/Battle_45.png', labelKey: 'tasks.skill11057', category: 'battle' },

  // 🌾 تطوير (Develop - 5)
  { id: '12008', img: '/images/skills/lord/Develop_8.png', labelKey: 'tasks.skill12008', category: 'develop' },
  { id: '12022', img: '/images/skills/lord/Develop_22.png', labelKey: 'tasks.skill12022', category: 'develop' },
  { id: '12023', img: '/images/skills/lord/Develop_23.png', labelKey: 'tasks.skill12023', category: 'develop' },
  { id: '12031', img: '/images/skills/lord/Develop_31.png', labelKey: 'tasks.skill12031', category: 'develop' },
  { id: '12042', img: '/images/skills/lord/Develop_42.png', labelKey: 'tasks.skill12042', category: 'develop' },

  // 🛡️ دعم (Auxiliary - 5)
  { id: '13020', img: '/images/skills/lord/Assist_20.png', labelKey: 'tasks.skill13020', category: 'auxiliary' },
  { id: '13021', img: '/images/skills/lord/Assist_21.png', labelKey: 'tasks.skill13021', category: 'auxiliary' },
  { id: '13022', img: '/images/skills/lord/Assist_22.png', labelKey: 'tasks.skill13022', category: 'auxiliary' },
  { id: '13032', img: '/images/skills/lord/Assist_32.png', labelKey: 'tasks.skill13032', category: 'auxiliary' },
  { id: '13040', img: '/images/skills/lord/Assist_33.png', labelKey: 'tasks.skill13040', category: 'auxiliary' },
]

// ─── Style constants ─────────────────────────────────────────────────────────

const stepBtn: React.CSSProperties = {
  width: '24px', height: '24px', borderRadius: '6px',
  border: '1px solid rgba(var(--theme-primary-rgb),0.3)', background: 'rgba(var(--theme-primary-rgb),0.08)',
  color: 'var(--theme-primary-light)', cursor: 'pointer', fontSize: '14px',
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  fontFamily: 'inherit',
}

const inputStyle: React.CSSProperties = {
  width: '100%', background: 'rgba(255,255,255,0.06)',
  border: '1px solid rgba(255,255,255,0.12)', borderRadius: '8px',
  padding: '6px 10px', fontSize: '12px', color: '#f0fdf4',
  outline: 'none', boxSizing: 'border-box', fontFamily: 'inherit',
}

// ─── Main Component ──────────────────────────────────────────────────────────

interface Props {
  tab?: TaskTab
  initialTab?: TaskTab
  castle: Castle
  userId: string
  onTabChange?: (tab: TaskTab) => void
  isBatchMode?: boolean
  batchTargetCount?: number
  onBatchSave?: (changedSections: Partial<CastleConfig>) => Promise<void>
}

function TaskTabContentInner({
  tab: externalTab,
  initialTab = 'gather',
  castle,
  userId,
  onTabChange,
  isBatchMode = false,
  batchTargetCount = 1,
  onBatchSave,
}: Props) {
  const { t, i18n } = useTranslation()
  const [internalTab, setInternalTab] = useState<TaskTab>(externalTab || initialTab)
  const [coordsError, setCoordsError] = useState(false)
  const [isSavingBatch, setIsSavingBatch] = useState(false)
  const [activeSkillCategory, setActiveSkillCategory] = useState<'all' | 'battle' | 'develop' | 'auxiliary'>('all')

  // حالة القائمة المنسدلة: مهمة واحدة فقط يمكن فتح خياراتها في الوقت نفسه
  const [expandedTaskId, setExpandedTaskId] = useState<string | null>('fountain')

  const toggleTaskAccordion = (id: string) => {
    setExpandedTaskId(prev => prev === id ? null : id)
  }

  type AutoSaveStatus = 'idle' | 'saving' | 'saved' | 'error'
  const [saveStatus, setSaveStatus] = useState<AutoSaveStatus>('idle')
  const [saveErrorMsg, setSaveErrorMsg] = useState<string | null>(null)

  // Local draft of castle.config — allows instant optimistic UI updates
  const [draftConfig, setDraftConfig] = useState<CastleConfig>(() =>
    JSON.parse(JSON.stringify(castle.config))
  )
  const [savedConfig, setSavedConfig] = useState<CastleConfig>(() =>
    JSON.parse(JSON.stringify(castle.config))
  )

  const draftConfigRef = useRef<CastleConfig>(draftConfig)
  const lastSavedConfigRef = useRef<CastleConfig>(castle.config)
  const currentCastleIdRef = useRef<string>(castle.id)
  const saveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const idleTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const isSavingRef = useRef<boolean>(false)
  const hasPendingSaveRef = useRef<boolean>(false)

  // Always keep draftConfigRef in sync with draftConfig state
  draftConfigRef.current = draftConfig

  // Sync internalTab when externalTab changes
  useEffect(() => {
    if (externalTab && externalTab !== internalTab) {
      setInternalTab(externalTab)
    }
  }, [externalTab])

  const currentTab = externalTab ?? internalTab

  // إغلاق كافة القوائم المنسدلة عند تغيير التبويب (تكون كلها مقفلة افتراضياً)
  useEffect(() => {
    setExpandedTaskId(null)
  }, [currentTab])

  const updateConfig = useUpdateCastleConfig(userId, castle.id)

  const performSave = async () => {
    if (isBatchMode) return
    if (isSavingRef.current) {
      hasPendingSaveRef.current = true
      return
    }

    const currentDraft = draftConfigRef.current
    if (fastDeepEqual(currentDraft, lastSavedConfigRef.current)) {
      return
    }

    const fountainDraft = (currentDraft as any)?.fountain
    const trainDraft = (currentDraft as any)?.train
    const shieldDraft = (currentDraft as any)?.shield
    const researchDraft = (currentDraft as any)?.research
    const flowerDraft = (currentDraft as any)?.flower
    const wonderMerchantDraft = (currentDraft as any)?.wonder_merchant
    const materialSynthesisDraft = (currentDraft as any)?.material_synthesis
    const cureWoundedDraft = (currentDraft as any)?.cure_wounded
    const allianceDraft = (currentDraft as any)?.alliance
    const petDraft = (currentDraft as any)?.pet
    const forgeEquipmentDraft = (currentDraft as any)?.forge_equipment
    const dailyTrainDraft = (currentDraft as any)?.daily_train
    const dailyQuestDraft = (currentDraft as any)?.daily_quest
    const buildingDraft = (currentDraft as any)?.building
    const arenaDraft = (currentDraft as any)?.arena
    const heroTrialDraft = (currentDraft as any)?.hero_trial
    const commandHallDraft = (currentDraft as any)?.command_hall
    const watermillDraft = (currentDraft as any)?.watermill
    const skillsDraft = (currentDraft as any)?.skills
    const materialWorkshopDraft = (currentDraft as any)?.material_workshop
    const staminaDraft = (currentDraft as any)?.stamina
    const caravanDraft = (currentDraft as any)?.caravan
    const marchManagerDraft = (currentDraft as any)?.march_manager
    isSavingRef.current = true
    setSaveStatus('saving')
    try {
      await updateConfig.mutateAsync({
        fountain: fountainDraft,
        train: trainDraft,
        shield: shieldDraft,
        research: researchDraft,
        flower: flowerDraft,
        wonder_merchant: wonderMerchantDraft,
        material_synthesis: materialSynthesisDraft,
        cure_wounded: cureWoundedDraft,
        alliance: allianceDraft,
        pet: petDraft,
        forge_equipment: forgeEquipmentDraft,
        daily_train: dailyTrainDraft,
        daily_quest: dailyQuestDraft || { enabled: true },
        building: buildingDraft,
        arena: arenaDraft,
        hero_trial: heroTrialDraft,
        command_hall: commandHallDraft,
        watermill: watermillDraft,
        skills: skillsDraft,
        material_workshop: materialWorkshopDraft,
        stamina: staminaDraft,
        caravan: caravanDraft,
        march_manager: marchManagerDraft,
      } as any)
      lastSavedConfigRef.current = JSON.parse(JSON.stringify(currentDraft))
      setSavedConfig(JSON.parse(JSON.stringify(currentDraft)))
      setSaveStatus('saved')
    } catch (e: any) {
      setSaveStatus('error')
      setSaveErrorMsg(e?.message || 'فشل الحفظ')
    } finally {
      isSavingRef.current = false
      if (hasPendingSaveRef.current) {
        hasPendingSaveRef.current = false
        performSave()
      }
    }
    return
  }

  const scheduleSave = (delayMs: number = 400) => {
    if (saveTimerRef.current) clearTimeout(saveTimerRef.current)
    setSaveStatus('idle')
    saveTimerRef.current = setTimeout(() => {
      performSave()
    }, delayMs)
  }

  const flushSave = () => {
    if (saveTimerRef.current) {
      clearTimeout(saveTimerRef.current)
      performSave()
    }
  }

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      if (saveTimerRef.current) clearTimeout(saveTimerRef.current)
      if (idleTimerRef.current) clearTimeout(idleTimerRef.current)
    }
  }, [castle.id, isBatchMode])

  // Sync with API/props when castle changes
  useEffect(() => {
    if (currentCastleIdRef.current !== castle.id) {
      currentCastleIdRef.current = castle.id
      if (saveTimerRef.current) clearTimeout(saveTimerRef.current)
      if (idleTimerRef.current) clearTimeout(idleTimerRef.current)
      lastSavedConfigRef.current = castle.config
      const fresh = JSON.parse(JSON.stringify(castle.config))
      draftConfigRef.current = fresh
      setSavedConfig(fresh)
      setDraftConfig(fresh)
      setSaveStatus('idle')
      setSaveErrorMsg(null)
      setCoordsError(false)
      return
    }

    // Only update from server if not currently saving and draft has no local pending edits
    if (
      !isSavingRef.current &&
      !fastDeepEqual(lastSavedConfigRef.current, castle.config)
    ) {
      if (fastDeepEqual(draftConfigRef.current, lastSavedConfigRef.current)) {
        lastSavedConfigRef.current = castle.config
        const fresh = JSON.parse(JSON.stringify(castle.config))
        draftConfigRef.current = fresh
        setSavedConfig(fresh)
        setDraftConfig(fresh)
      }
    }
  }, [castle.id, castle.config])

  const changesCount = useMemo(() => {
    if (!isBatchMode) return 0
    return countConfigChanges(savedConfig, draftConfig)
  }, [isBatchMode, savedConfig, draftConfig])

  const applyConfigChange = (
    updater: (prev: CastleConfig) => CastleConfig,
    delayMs: number = 250
  ) => {
    setDraftConfig(prev => {
      const next = updater(prev)
      draftConfigRef.current = next
      return next
    })
    if (!isBatchMode) {
      scheduleSave(delayMs)
    }
  }

  function update<K extends keyof CastleConfig>(
    key: K,
    patch: Partial<CastleConfig[K]>,
    delayMs: number = 250
  ) {
    applyConfigChange(prev => {
      const current = (prev[key] || {}) as Record<string, unknown>
      return {
        ...prev,
        [key]: {
          ...current,
          ...(patch as Record<string, unknown>),
        } as CastleConfig[K],
      }
    }, delayMs)
  }

  const toggle = (key: keyof CastleConfig) => (v: boolean) =>
    update(key, { enabled: v } as Partial<CastleConfig[typeof key]>, 150)

  const handleTabChange = (newTab: TaskTab) => {
    if (newTab === currentTab) return

    // Flush any pending debounced change immediately before switching tab
    flushSave()

    // التحقق من إحداثيات مساعدة الموارد إذا كانت مفعّلة
    const tr = draftConfig.march_manager?.resource_help
    if (tr?.enabled) {
      const hasX = tr.target_x != null && tr.target_x > 0
      const hasY = tr.target_y != null && tr.target_y > 0
      if (!hasX || !hasY) {
        toast.error(t('tasks.coordsRequiredToNavigate'), {
          id: 'transport-missing-coords',
          duration: 4500,
        })
        setCoordsError(true)
        if (currentTab !== 'transport') {
          setInternalTab('transport')
          onTabChange?.('transport')
        }
        return
      }
    }

    setCoordsError(false)
    setInternalTab(newTab)
    onTabChange?.(newTab)
  }

  const isPending = updateConfig.isPending || isSavingBatch

  const handleSave = async () => {
    if (changesCount === 0 || isPending) return

    // التحقق من إحداثيات مساعدة الموارد عند الحفظ
    const tr = draftConfig.march_manager?.resource_help
    if (tr?.enabled) {
      const hasX = tr.target_x != null && tr.target_x > 0
      const hasY = tr.target_y != null && tr.target_y > 0
      if (!hasX || !hasY) {
        toast.error(t('tasks.coordsRequiredToSave'), {
          id: 'transport-missing-coords',
          duration: 4500,
        })
        setCoordsError(true)
        setInternalTab('transport')
        onTabChange?.('transport')
        return
      }
    }

    const changedSections: Partial<CastleConfig> = {}
    for (const key of Object.keys(draftConfig) as (keyof CastleConfig)[]) {
      if (!fastDeepEqual(draftConfig[key], savedConfig[key])) {
        ;(changedSections as Record<string, unknown>)[key] = draftConfig[key]
      }
    }

    const fountainConfig = (draftConfig as any)?.fountain
    const trainConfig = (draftConfig as any)?.train
    const shieldConfig = (draftConfig as any)?.shield
    const researchConfig = (draftConfig as any)?.research
    const flowerConfig = (draftConfig as any)?.flower
    const wonderMerchantConfig = (draftConfig as any)?.wonder_merchant
    const materialSynthesisConfig = (draftConfig as any)?.material_synthesis
    const cureWoundedConfig = (draftConfig as any)?.cure_wounded
    const allianceConfig = (draftConfig as any)?.alliance
    const petConfig = (draftConfig as any)?.pet
    const forgeEquipmentConfig = (draftConfig as any)?.forge_equipment
    const dailyTrainConfig = (draftConfig as any)?.daily_train
    const dailyQuestConfig = (draftConfig as any)?.daily_quest
    const buildingConfig = (draftConfig as any)?.building
    const arenaConfig = (draftConfig as any)?.arena
    const heroTrialConfig = (draftConfig as any)?.hero_trial
    const commandHallConfig = (draftConfig as any)?.command_hall
    const watermillConfig = (draftConfig as any)?.watermill
    const skillsConfig = (draftConfig as any)?.skills
    const materialWorkshopConfig = (draftConfig as any)?.material_workshop
    const staminaConfig = (draftConfig as any)?.stamina
    const caravanConfig = (draftConfig as any)?.caravan
    const marchManagerConfig = (draftConfig as any)?.march_manager
    const payloadToSave = {
      ...(fountainConfig !== undefined ? { fountain: fountainConfig } : {}),
      ...(trainConfig !== undefined ? { train: trainConfig } : {}),
      ...(shieldConfig !== undefined ? { shield: shieldConfig } : {}),
      ...(researchConfig !== undefined ? { research: researchConfig } : {}),
      ...(flowerConfig !== undefined ? { flower: flowerConfig } : {}),
      ...(wonderMerchantConfig !== undefined ? { wonder_merchant: wonderMerchantConfig } : {}),
      ...(materialSynthesisConfig !== undefined ? { material_synthesis: materialSynthesisConfig } : {}),
      ...(cureWoundedConfig !== undefined ? { cure_wounded: cureWoundedConfig } : {}),
      ...(allianceConfig !== undefined ? { alliance: allianceConfig } : {}),
      ...(petConfig !== undefined ? { pet: petConfig } : {}),
      ...(forgeEquipmentConfig !== undefined ? { forge_equipment: forgeEquipmentConfig } : {}),
      ...(dailyTrainConfig !== undefined ? { daily_train: dailyTrainConfig } : {}),
      ...(dailyQuestConfig !== undefined ? { daily_quest: dailyQuestConfig } : { daily_quest: { enabled: true } }),
      ...(buildingConfig !== undefined ? { building: buildingConfig } : {}),
      ...(arenaConfig !== undefined ? { arena: arenaConfig } : {}),
      ...(heroTrialConfig !== undefined ? { hero_trial: heroTrialConfig } : {}),
      ...(commandHallConfig !== undefined ? { command_hall: commandHallConfig } : {}),
      ...(watermillConfig !== undefined ? { watermill: watermillConfig } : {}),
      ...(skillsConfig !== undefined ? { skills: skillsConfig } : {}),
      ...(materialWorkshopConfig !== undefined ? { material_workshop: materialWorkshopConfig } : {}),
      ...(staminaConfig !== undefined ? { stamina: staminaConfig } : {}),
      ...(caravanConfig !== undefined ? { caravan: caravanConfig } : {}),
      ...(marchManagerConfig !== undefined ? { march_manager: marchManagerConfig } : {}),
    }
    try {
      if (isBatchMode) {
        if (onBatchSave) {
          await onBatchSave(payloadToSave as any)
          toast.success(t('tasks.savedSuccess', 'تم حفظ الإعدادات بنجاح'))
        }
        return
      }

      await updateConfig.mutateAsync(payloadToSave as any)
      setSavedConfig(JSON.parse(JSON.stringify(draftConfig)))
      lastSavedConfigRef.current = JSON.parse(JSON.stringify(draftConfig))
      setSaveStatus('saved')
      toast.success(t('tasks.savedSuccess', 'تم حفظ الإعدادات بنجاح'))
    } catch (err: any) {
      toast.error(localizeApiError(err?.message, t) || t('tasks.saveError', 'فشل حفظ الإعدادات'))
    }
    return
  }

  const handleCancel = () => {
    if (changesCount === 0) return
    const restored = JSON.parse(JSON.stringify(savedConfig))
    draftConfigRef.current = restored
    setDraftConfig(restored)
    setCoordsError(false)
    toast.success(t('common.success'))
  }

  const cfg = draftConfig

  function renderTabContent() {
    const tab = currentTab

    // ─────────────────────────────────────────────────────────────────────────
    // 1. جمع الموارد (Gather)
    // ─────────────────────────────────────────────────────────────────────────
    if (tab === 'gather') {
      const mm: any = cfg.march_manager || {}
      const gr: any = mm.gather_resources || {
        enabled: false,
        resource: 'wood',
        res_type: 3,
        level: 0,
        max_distance: 120,
      }
      const gsb: any = mm.gather_speed_buff || { enabled: false }

      const RES_KEY_BY_V: Record<number, string> = {
        2: 'food',
        3: 'wood',
        4: 'iron',
        5: 'silver',
        6: 'crystal',
        1: 'gold',
      }
      const V_BY_RES_KEY: Record<string, number> = {
        food: 2,
        wood: 3,
        iron: 4,
        silver: 5,
        crystal: 6,
        diamond: 6,
        gold: 1,
      }

      const selectedResKey = String(gr.resource || RES_KEY_BY_V[Number(gr.res_type)] || 'wood').toLowerCase()
      const selectedResV = V_BY_RES_KEY[selectedResKey] ?? 3
      const gatherLevel = Number(gr.level ?? 0)

      const updateGatherResources = (patch: Record<string, unknown>, delayMs = 200) => {
        const nextGr = { ...gr, ...patch }
        const nextKey = String(nextGr.resource || 'wood').toLowerCase()
        const nextLv = Number(nextGr.level ?? 0)
        const nextEnabled = Boolean(nextGr.enabled)
        update(
          'march_manager',
          {
            ...(nextEnabled ? { enabled: true } : {}),
            gather_resources: {
              enabled: nextEnabled,
              resource: nextKey,
              level: nextLv,
            },
          } as any,
          delayMs
        )
      }

      const updateGatherBuff = (enabled: boolean) => {
        update(
          'march_manager',
          {
            ...(enabled ? { enabled: true } : {}),
            gather_speed_buff: { ...gsb, enabled },
          } as any,
          150
        )
      }

      return (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          <TaskRow
            id="gather_resources"
            img="/images/gather/icon_map_mineral_collect.png"
            label={t('tasks.gatherResources')}
            enabled={Boolean(gr.enabled)}
            onToggle={v => updateGatherResources({ enabled: v }, 150)}
            comingSoon={false}
          />

          {Boolean(gr.enabled) && (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                gap: '10px',
                padding: '12px',
                background: 'rgba(255,255,255,0.03)',
                border: '1px solid rgba(255,255,255,0.08)',
                borderRadius: '12px',
              }}
            >
              <div>
                <SectionLabel text={t('tasks.resourceType', 'نوع المورد')} />
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
                  {MARCH_RESOURCES.map(r => (
                    <ResCard
                      key={r.v}
                      img={r.img}
                      label={t(r.resKey)}
                      selected={selectedResV === r.v}
                      onClick={() =>
                        updateGatherResources({
                          resource: RES_KEY_BY_V[r.v] || 'wood',
                          res_type: r.v,
                        })
                      }
                    />
                  ))}
                </div>
              </div>

              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <SectionLabel text={t('common.level', 'المستوى')} />
                <Stepper
                  value={gatherLevel}
                  min={0}
                  max={10}
                  formatLabel={v => (v === 0 ? t('common.auto', 'تلقائي') : `Lv.${v}`)}
                  onChange={v => updateGatherResources({ level: v })}
                />
              </div>
            </div>
          )}

          <TaskRow
            id="gather_speed_buff"
            img="/images/gather/gather_boost.png"
            label={t('tasks.gatherBoost')}
            description={t('tasks.gatherBoostDesc', 'تفعيل تلقائي (الصغيرة ← الكبيرة ← السوبر) قبل الجمع')}
            enabled={Boolean(gsb.enabled)}
            onToggle={updateGatherBuff}
            comingSoon={false}
          />
        </div>
      )
    }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. التدريب العسكري (Train) — نظام بطاقات الثكنات المستقلة مطابق لبوت العثمانية
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'train') {
    const tr = cfg.train || { enabled: false, levels: { infantry: 0, cavalry: 0, archers: 0, chariots: 0 } }
    const trLevels = (tr as any).levels || { infantry: 0, cavalry: 0, archers: 0, chariots: 0 }

    type BarracksKey = 'infantry' | 'cavalry' | 'archers' | 'chariots'
    const activeList = (Object.keys(trLevels) as BarracksKey[]).filter(k => (Number(trLevels[k]) || 0) > 0)
    const unusedTypes = BARRACKS_TYPES.filter(b => !activeList.includes(b.key as BarracksKey))

    const setLevel = (key: BarracksKey, lv: number) => {
      update('train', { levels: { ...trLevels, [key]: lv } } as any)
    }

    const removeBarracks = (key: BarracksKey) => {
      update('train', { levels: { ...trLevels, [key]: 0 } } as any)
    }

    const addBarracks = () => {
      if (unusedTypes.length === 0) return
      const next = unusedTypes[0]
      update('train', { levels: { ...trLevels, [next.key]: 1 } } as any)
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        {/* Header — تفعيل/تعطيل التدريب العسكري */}
        <div
          onClick={() => toggle('train')(!tr.enabled)}
          style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            background: tr.enabled ? 'rgba(var(--theme-primary-rgb),0.06)' : 'rgba(255,255,255,0.03)',
            border: tr.enabled ? '1px solid rgba(var(--theme-primary-rgb),0.18)' : '1px solid rgba(255,255,255,0.08)',
            borderRadius: '10px', padding: '8px 10px',
            cursor: 'pointer', userSelect: 'none',
          }}
          className={clsx('transition-colors task-header-card', tr.enabled ? 'enabled' : 'disabled')}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <img
              src="/images/soldiers/icon_building_training_finish.png"
              alt="train"
              style={{ width: '22px', height: '22px', objectFit: 'contain' }}
            />
            <div>
              <div className="task-header-title" style={{ color: '#f0fdf4', fontWeight: 600, fontSize: '13px' }}>
                {t('tasks.militaryTraining')}
              </div>
            </div>
          </div>
          <Toggle value={tr.enabled} onChange={toggle('train')} size="sm" />
        </div>

        {/* الخيارات الفرعية وبطاقات الثكنات المستقلة تظهر فقط عند تفعيل المهمة */}
        {tr.enabled && (
          <>
            {/* بطاقات الثكنات النشطة */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              {activeList.map((key, idx) => {
                return (
                  <div key={key} className="task-barracks-card" style={{
                    background: 'rgba(255,255,255,0.04)',
                    border: '1px solid rgba(255,255,255,0.10)',
                    borderRadius: '10px', padding: '9px 11px',
                  }}>
                    {/* ترويسة البطاقة */}
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                        <span style={{ width: '7px', height: '7px', borderRadius: '50%', background: '#22c55e', display: 'inline-block' }} />
                        <span style={{ color: '#9ca3af', fontSize: '12px', fontWeight: 600 }}>{t('tasks.troops')} #{idx + 1}</span>
                      </div>
                      <button
                        type="button"
                        onClick={() => removeBarracks(key)}
                        style={{ background: 'none', border: 'none', color: '#6b7280', cursor: 'pointer', padding: '2px', display: 'flex' }}
                      >
                        <Trash2 size={13} />
                      </button>
                    </div>

                    {/* محدد النوع العسكري — 4 أزرار متجاورة مع تعطيل الأنواع المختارة في بطاقات أخرى */}
                    <SectionLabel text={t('tasks.troopType')} />
                    <div className="gap-1.5 grid grid-cols-2 sm:grid-cols-4 mb-2">
                      {BARRACKS_TYPES.map(b => {
                        const isSelected = b.key === key
                        const isUsedElsewhere = !isSelected && activeList.includes(b.key as BarracksKey)
                        return (
                          <button
                            key={b.key}
                            type="button"
                            disabled={isUsedElsewhere}
                            className={clsx('task-troop-btn', isSelected ? 'selected' : 'unselected', isUsedElsewhere && 'used-elsewhere')}
                            onClick={() => {
                              if (isUsedElsewhere) return
                              const newLevels = { ...trLevels, [key]: 0, [b.key]: trLevels[key] || 1 }
                              update('train', { levels: newLevels } as any)
                            }}
                            style={{
                              width: '100%',
                              padding: '5px 4px', borderRadius: '6px',
                              border: isSelected ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)' : '1px solid rgba(255,255,255,0.10)',
                              background: isSelected ? 'rgba(var(--theme-primary-rgb),0.12)' : 'rgba(255,255,255,0.04)',
                              color: isSelected ? 'var(--theme-primary-light)' : isUsedElsewhere ? '#374151' : '#9ca3af',
                              fontSize: '11px', fontWeight: isSelected ? 600 : 500,
                              cursor: isUsedElsewhere ? 'not-allowed' : 'pointer',
                              fontFamily: 'inherit', transition: 'all 0.15s',
                              opacity: isUsedElsewhere ? 0.38 : 1,
                              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '5px',
                            }}
                          >
                            {(b as any).img ? (
                              <img
                                src={(b as any).img}
                                alt=""
                                style={{
                                  width: '20px',
                                  height: '20px',
                                  objectFit: 'contain',
                                  flexShrink: 0,
                                }}
                                onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                              />
                            ) : (
                              <span>{b.emoji}</span>
                            )}
                            <span>{t(b.labelKey)}</span>
                          </button>
                        )
                      })}
                    </div>

                    {/* عداد الرتبة المستقل لهذه الثكنة فقط */}
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                      <SectionLabel text={t('common.level')} />
                      <Stepper value={Number(trLevels[key]) || 1} min={1} max={10} onChange={v => setLevel(key, v)} />
                    </div>
                  </div>
                )
              })}
            </div>

            {/* زر إضافة نوع قوات متبقٍ */}
            {unusedTypes.length > 0 && (
              <button
                type="button"
                onClick={addBarracks}
                style={{
                  display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px',
                  width: '100%', padding: '7px 10px',
                  borderRadius: '8px', border: '1px dashed rgba(var(--theme-primary-rgb),0.3)',
                  background: 'rgba(var(--theme-primary-rgb),0.05)',
                  color: 'var(--theme-primary-light)', fontSize: '11px', fontWeight: 500,
                  cursor: 'pointer', fontFamily: 'inherit',
                  transition: 'all 0.15s',
                }}
              >
                <Plus size={12} />
                {t('tasks.addTroopType')}
              </button>
            )}
          </>
        )}
      </div>
    )
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. الهجوم (Combat / march_manager)
  // ─────────────────────────────────────────────────────────────────────────

  // ─────────────────────────────────────────────────────────────────────────
  // 3. الهجوم (Combat / march_manager)
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'combat') {
    const mm: any = cfg.march_manager || {}
    const hm: any = mm.hunt_monsters || {
      enabled: false,
      monster_type: 'normal',
      monster_level: 0,
      formation_id: 1,
      auto_downgrade: true,
      min_energy: 10,
    }
    const inv: any = mm.invaders || { enabled: false, level: 0, formation_id: 1 }
    const reb: any = mm.rebels || { enabled: false, level: 0, formation_id: 1 }
    const ruinsCfg: any = mm.ruins || { enabled: false, explore_time: 14400, formation_id: 1 }
    const expRuins: any = mm.explore_ruins || { enabled: false, explore_time: 14400, formation: 1, max_distance: 120 }

    const RUINS_DURATIONS = [
      { sec: 900,   labelKey: 'tasks.ruins15m', fallback: '15 دقيقة' },
      { sec: 3600,  labelKey: 'tasks.ruins1h',  fallback: '1 ساعة' },
      { sec: 14400, labelKey: 'tasks.ruins4h',  fallback: '4 ساعات' },
      { sec: 28800, labelKey: 'tasks.ruins8h',  fallback: '8 ساعات' },
    ]

    const normalizeRuinsSec = (raw: unknown): number => {
      const n = Number(raw)
      if ([900, 3600, 14400, 28800].includes(n)) return n
      if (n === 15) return 900
      if (n === 1) return 3600
      if (n === 4) return 14400
      if (n === 8) return 28800
      return 14400
    }

    const ruinsEnabled = Boolean(expRuins.enabled ?? ruinsCfg.enabled ?? false)
    const ruinsExploreSec = normalizeRuinsSec(expRuins.explore_time ?? ruinsCfg.explore_time ?? 14400)

    const updateRuins = (patch: { enabled?: boolean; explore_time?: number }) => {
      const nextEnabled = patch.enabled !== undefined ? patch.enabled : ruinsEnabled
      const nextSec = patch.explore_time !== undefined ? normalizeRuinsSec(patch.explore_time) : ruinsExploreSec
      update(
        'march_manager',
        {
          ...(nextEnabled ? { enabled: true } : {}),
          explore_ruins: {
            enabled: nextEnabled,
            explore_time: nextSec,
            formation: activeFormationId,
          },
        } as any,
        150
      )
    }

    const te: any = mm.treasure_escort || { enabled: false, free_refresh: true }

    // تحديث حراسة الكنز بدون حفظ formation_id إطلاقاً في قاعدة البيانات
    const updateTreasureEscort = (patch: { enabled?: boolean }) => {
      const nextEnabled = patch.enabled !== undefined ? patch.enabled : Boolean(te.enabled)
      update(
        'march_manager',
        {
          ...(nextEnabled ? { enabled: true } : {}),
          treasure_escort: { enabled: nextEnabled },
        } as any,
        150
      )
    }

    const activeFormationId = Number(mm.formation_id ?? expRuins.formation ?? 1)
    const normalEnabled = Boolean(hm.enabled && hm.monster_type !== 'nebula')
    const nebulaEnabled = Boolean(hm.enabled && hm.monster_type === 'nebula')

    const normalLevel = normalEnabled
      ? Number(hm.monster_level ?? 0)
      : Number(inv.level ?? 0)
    const nebulaLevel = nebulaEnabled
      ? Number(hm.monster_level ?? 0)
      : Number(reb.level ?? 0)

    const FORMATION_SLOTS = [
      { id: 1, img: '/images/combat/slot1.png' },
      { id: 2, img: '/images/combat/slot2.png' },
      { id: 3, img: '/images/combat/slot3.png' },
      { id: 4, img: '/images/combat/slot4.png' },
    ]

    // تحديث التشكيلة الموحدة في رأس قسم الهجوم (تنطبق على الوحوش + وحوش السحاب + الأطلال فقط)
    const setCombatFormation = (slotId: number) => {
      update(
        'march_manager',
        {
          formation_id: slotId,
          explore_ruins: {
            enabled: ruinsEnabled,
            explore_time: ruinsExploreSec,
            formation: slotId,
          },
        } as any,
        150
      )
    }

    const setMonsterOption = (type: 'normal' | 'nebula', enabled: boolean, level?: number) => {
      const targetLv = level !== undefined ? level : (type === 'nebula' ? nebulaLevel : normalLevel)
      update(
        'march_manager',
        {
          ...(enabled ? { enabled: true } : {}),
          hunt_monsters: {
            enabled,
            monster_type: type,
            monster_level: targetLv,
          },
        } as any,
        150
      )
    }

    const handleNebulaLevelChange = (v: number) => {
      let clean = v
      if (v > 0 && v < 41) {
        clean = nebulaLevel === 0 ? 41 : 0
      }
      setMonsterOption('nebula', true, clean)
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
        {/* رأس قسم الهجوم: اختيار التشكيلة الموحدة لجميع مهام القسم ما عدا قافلة الغنيمة */}
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '6px',
            padding: '10px 12px',
            background: 'rgba(255,255,255,0.03)',
            border: '1px solid rgba(255,255,255,0.08)',
            borderRadius: '12px',
          }}
        >
          <SectionLabel text={t('tasks.formation', 'تشكيلة')} />
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', gap: '6px' }}>
            {FORMATION_SLOTS.map(slot => {
              const isSelected = activeFormationId === slot.id
              return (
                <button
                  key={slot.id}
                  type="button"
                  onClick={() => setCombatFormation(slot.id)}
                  className={clsx('task-res-card', isSelected ? 'selected' : 'unselected')}
                  style={{
                    padding: '6px 4px',
                    borderRadius: '8px',
                    border: isSelected
                      ? '1.5px solid rgba(var(--theme-primary-rgb),0.65)'
                      : '1px solid rgba(255,255,255,0.10)',
                    background: isSelected
                      ? 'rgba(var(--theme-primary-rgb),0.14)'
                      : 'rgba(255,255,255,0.04)',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '3px',
                    cursor: 'pointer',
                    transition: 'all 0.15s',
                  }}
                >
                  <img
                    src={slot.img}
                    alt={`${t('tasks.formation', 'تشكيلة')} ${slot.id}`}
                    style={{ width: '28px', height: '28px', objectFit: 'contain' }}
                  />
                  <span
                    style={{
                      fontSize: '11px',
                      fontWeight: isSelected ? 700 : 500,
                      color: isSelected ? 'var(--theme-primary-light)' : '#9ca3af',
                    }}
                  >
                    {t('tasks.formation', 'تشكيلة')} {slot.id}
                  </span>
                </button>
              )
            })}
          </div>
        </div>

        {/* 1) الوحوش (العادية: 1–40 أو 0 تلقائي) */}
        <TaskRow
          id="combat_monsters"
          img="/images/combat/yagmaci.png"
          label={t('tasks.invaders', 'الوحوش')}
          enabled={normalEnabled}
          onToggle={v => setMonsterOption('normal', v)}
          comingSoon={false}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <SectionLabel text={t('common.level', 'المستوى')} />
            <Stepper
              value={normalLevel}
              min={0}
              max={40}
              formatLabel={v => (v === 0 ? t('common.auto', 'تلقائي') : `Lv.${v}`)}
              onChange={v => setMonsterOption('normal', true, v)}
            />
          </div>
        </TaskRow>

        {/* 2) وحوش السحاب (41–50 أو 0 تلقائي) */}
        <TaskRow
          id="combat_nebula"
          img="/images/combat/elitifrit.png"
          label={t('tasks.eliteRebels', 'وحوش السحاب')}
          enabled={nebulaEnabled}
          onToggle={v => setMonsterOption('nebula', v)}
          comingSoon={false}
        >
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <SectionLabel text={t('common.level', 'المستوى')} />
            <Stepper
              value={nebulaLevel}
              min={0}
              max={50}
              formatLabel={v => (v === 0 ? t('common.auto', 'تلقائي') : `Lv.${v}`)}
              onChange={handleNebulaLevelChange}
            />
          </div>
        </TaskRow>

        {/* 3) الأطلال */}
        <TaskRow
          id="combat_ruins"
          img="/images/combat/kesif.png"
          label={t('tasks.ruins', 'الأطلال')}
          enabled={ruinsEnabled}
          onToggle={v => updateRuins({ enabled: v })}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
            <SectionLabel text={t('tasks.marchDuration', 'مدة المسيرة')} />
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', gap: '6px' }}>
              {RUINS_DURATIONS.map(d => {
                const isSelected = ruinsExploreSec === d.sec
                return (
                  <button
                    key={d.sec}
                    type="button"
                    onClick={() => updateRuins({ explore_time: d.sec })}
                    className={clsx('task-troop-btn', isSelected ? 'selected' : 'unselected')}
                    style={{
                      padding: '6px 4px',
                      borderRadius: '7px',
                      border: isSelected
                        ? '1.5px solid rgba(var(--theme-primary-rgb),0.65)'
                        : '1px solid rgba(255,255,255,0.10)',
                      background: isSelected
                        ? 'rgba(var(--theme-primary-rgb),0.14)'
                        : 'rgba(255,255,255,0.04)',
                      color: isSelected ? 'var(--theme-primary-light)' : '#9ca3af',
                      fontSize: '11px',
                      fontWeight: isSelected ? 700 : 500,
                      cursor: 'pointer',
                      fontFamily: 'inherit',
                      transition: 'all 0.15s',
                    }}
                  >
                    {t(d.labelKey, d.fallback)}
                  </button>
                )
              })}
            </div>
          </div>
        </TaskRow>

        {/* 4) حراسة الكنز (بدون حفظ رقم التشكيلة في قاعدة البيانات) */}
        <TaskRow
          id="combat_treasure_escort"
          img="/images/daily/ganimetkaravani.png"
          label={t('tasks.treasureEscort', 'حراسة الكنز')}
          description={t('tasks.treasureEscortDesc')}
          enabled={Boolean(te.enabled)}
          onToggle={v => updateTreasureEscort({ enabled: v })}
          comingSoon={false}
        />
      </div>
    )
  }


  // ─────────────────────────────────────────────────────────────────────────
  // 4. دعم الموارد (Watermill / Resource Support)
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'watermill') {
    const wm = (cfg as any).watermill || { enabled: false, resources: ['food', 'wood', 'iron', 'silver', 'crystal'] }
    const selectedRes: string[] = Array.isArray(wm.resources)
      ? wm.resources
      : (typeof wm.types === 'string' && wm.types === 'all'
          ? ['food', 'wood', 'iron', 'silver', 'crystal']
          : (typeof wm.types === 'string' && wm.types ? [wm.types] : ['food', 'wood', 'iron', 'silver', 'crystal']))

    const activeCount = WATERMILL_BOOST_RESOURCES.filter(r => selectedRes.includes(r.key)).length

    const toggleRes = (key: string) => {
      const next = selectedRes.includes(key)
        ? selectedRes.filter(k => k !== key)
        : [...selectedRes, key]
      update('watermill' as any, { resources: next, types: next })
    }

    const selectAll = () => {
      update('watermill' as any, { resources: WATERMILL_BOOST_RESOURCES.map(r => r.key), types: 'all' })
    }

    const deselectAll = () => {
      update('watermill' as any, { resources: [], types: [] })
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
        <TaskRow
          id="watermill"
          img="/images/watermill/uretimbonusust.png"
          label={t('tasks.watermillBonus')}
          enabled={Boolean(wm.enabled)}
          onToggle={v => update('watermill' as any, { enabled: v })}
          comingSoon={false}
        />

        {/* خيارات مكافآت الموارد تظل مفتوحة ومباشرة دائماً طالما أن المهمة مفعلة دون زر قائمة منسدلة */}
        {wm.enabled && (
          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '8px',
              padding: '12px',
              background: 'rgba(255,255,255,0.03)',
              border: '1px solid rgba(255,255,255,0.08)',
              borderRadius: '12px',
            }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginBottom: '2px',
                flexWrap: 'wrap',
                gap: '6px',
              }}
            >
              <span style={{ fontSize: '12px', fontWeight: 600, color: '#e2e8f0' }}>
                {t('tasks.bonusTypes', 'أنواع المكافآت')} ({activeCount}/{WATERMILL_BOOST_RESOURCES.length})
              </span>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <button
                  type="button"
                  onClick={selectAll}
                  className="task-fountain-btn-select-all"
                >
                  {t('common.selectAll', 'تحديد الكل')}
                </button>
                <button
                  type="button"
                  onClick={deselectAll}
                  className="task-fountain-btn-deselect-all"
                >
                  {t('common.cancelAll', 'إلغاء الكل')}
                </button>
              </div>
            </div>

            {/* شبكة بطاقات الموارد الخمسة */}
            <div className="gap-2 grid grid-cols-2 sm:grid-cols-5">
              {WATERMILL_BOOST_RESOURCES.map(r => {
                const isSelected = selectedRes.includes(r.key)
                return (
                  <button
                    key={r.key}
                    type="button"
                    onClick={() => toggleRes(r.key)}
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      padding: '10px 8px',
                      borderRadius: '8px',
                      border: isSelected
                        ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)'
                        : '1px solid rgba(255,255,255,0.08)',
                      background: isSelected
                        ? 'rgba(var(--theme-primary-rgb),0.12)'
                        : 'rgba(255,255,255,0.03)',
                      color: isSelected ? 'var(--theme-primary-light)' : '#9ca3af',
                      cursor: 'pointer',
                      fontFamily: 'inherit',
                      transition: 'all 0.15s ease',
                    }}
                  >
                    <img
                      src={r.img}
                      alt={t(r.resKey)}
                      style={{
                        width: '32px',
                        height: '32px',
                        objectFit: 'contain',
                        opacity: isSelected ? 1 : 0.45,
                        transition: 'opacity 0.15s ease',
                      }}
                      onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                    />
                    <span style={{ fontSize: '11.5px', fontWeight: isSelected ? 600 : 500 }}>
                      {t(r.resKey)}
                    </span>
                  </button>
                )
              })}
            </div>
          </div>
        )}
      </div>
    )
  }


  // ─────────────────────────────────────────────────────────────────────────
  // 5. مساعدة الموارد (Transport)
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'transport') {
    const mm: any = cfg.march_manager || {}
    const tr: any = mm.transport || { enabled: false, target_x: null, target_y: null, resource_ids: [1002, 1003, 1004] }
    const rh: any = mm.resource_help || {
      enabled: Boolean(tr.enabled),
      target_x: tr.target_x ?? null,
      target_y: tr.target_y ?? null,
      resources: 'food,wood,iron',
      keep_reserve: 0,
      respect_target_limit: true,
    }

    const KEY_BY_ID: Record<number, string> = {
      1002: 'food',
      1003: 'wood',
      1004: 'iron',
      1005: 'silver',
      1006: 'crystal',
    }
    const ID_BY_KEY: Record<string, number> = {
      food: 1002,
      wood: 1003,
      iron: 1004,
      silver: 1005,
      mithril: 1005,
      crystal: 1006,
    }

    const parseSelectedIds = (): number[] => {
      if (typeof rh.resources === 'string' && rh.resources.trim()) {
        const ids = rh.resources
          .split(',')
          .map((s: string) => ID_BY_KEY[s.trim().toLowerCase()])
          .filter((n: number | undefined): n is number => typeof n === 'number')
        if (ids.length > 0) return Array.from(new Set(ids))
      }
      if (Array.isArray(tr.resource_ids) && tr.resource_ids.length > 0) {
        return tr.resource_ids.map((n: any) => Number(n)).filter((n: number) => Boolean(KEY_BY_ID[n]))
      }
      return [1002]
    }

    const helpEnabled = Boolean(rh.enabled ?? tr.enabled ?? false)
    const targetX = rh.target_x ?? tr.target_x ?? null
    const targetY = rh.target_y ?? tr.target_y ?? null
    const selectedIds = parseSelectedIds()

    const isXValid = targetX != null && Number(targetX) > 0
    const isYValid = targetY != null && Number(targetY) > 0
    const hasInvalidCoords = helpEnabled && (!isXValid || !isYValid)

    const updateResourceHelp = (
      patch: { enabled?: boolean; target_x?: number | null; target_y?: number | null; resource_ids?: number[] },
      delayMs = 200
    ) => {
      const nextEnabled = patch.enabled !== undefined ? patch.enabled : helpEnabled
      const nextX = patch.target_x !== undefined ? patch.target_x : targetX
      const nextY = patch.target_y !== undefined ? patch.target_y : targetY
      const nextIds = patch.resource_ids !== undefined ? patch.resource_ids : selectedIds
      const cleanIds = nextIds.length > 0 ? nextIds : [1002]
      const resCsv = cleanIds.map(id => KEY_BY_ID[id]).filter(Boolean).join(',')

      const nextValid = nextX != null && Number(nextX) > 0 && nextY != null && Number(nextY) > 0
      if (nextEnabled && nextValid) {
        setCoordsError(false)
      }

      const mmPatch = {
        ...(nextEnabled ? { enabled: true } : {}),
        resource_help: {
          enabled: nextEnabled,
          target_x: nextX,
          target_y: nextY,
          resources: resCsv,
        },
      } as any

      // لا نحفظ تلقائياً إذا كانت الميزة مفعّلة وإحدى الإحداثيات فارغة أو 0
      if (nextEnabled && !nextValid) {
        setDraftConfig(prev => {
          const next = {
            ...prev,
            march_manager: { ...(prev.march_manager || {}), ...mmPatch },
          } as CastleConfig
          draftConfigRef.current = next
          return next
        })
        return
      }

      update('march_manager', mmPatch, delayMs)
    }

    const handleCoordChange = (axis: 'target_x' | 'target_y', raw: string) => {
      // إزالة أي أحرف غير رقمية ومنع الرقم 0 (إزالة الأصفار البادئة)
      const digits = raw.replace(/[^0-9]/g, '').replace(/^0+/, '')
      if (!digits) {
        updateResourceHelp({ [axis]: null }, 250)
        return
      }
      const num = Math.min(1199, Math.max(1, parseInt(digits, 10)))
      updateResourceHelp({ [axis]: num }, 250)
    }

    const toggleHelpResource = (resId: number) => {
      const exists = selectedIds.includes(resId)
      if (exists && selectedIds.length <= 1) return // الإبقاء على مورد واحد على الأقل
      const nextIds = exists
        ? selectedIds.filter(id => id !== resId)
        : [...selectedIds, resId]
      updateResourceHelp({ resource_ids: nextIds }, 150)
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
        <TaskRow
          id="resource_help"
          img="/images/transport/transport.png"
          label={t('tasks.transportResources', 'مساعدة الموارد')}
          enabled={helpEnabled}
          onToggle={v => updateResourceHelp({ enabled: v }, 150)}
          comingSoon={false}
        />

        {helpEnabled && (
          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '12px',
              padding: '12px',
              background: 'rgba(255,255,255,0.03)',
              border: hasInvalidCoords || coordsError
                ? '1px solid rgba(239,68,68,0.55)'
                : '1px solid rgba(255,255,255,0.08)',
              borderRadius: '12px',
            }}
          >
            {/* إدخال الإحداثيات X و Y (أكبر من 0 فقط) */}
            <div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: '8px' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <span style={{ color: '#9ca3af', fontSize: '12px', fontWeight: 700, minWidth: '14px' }}>X</span>
                  <input
                    type="text"
                    inputMode="numeric"
                    pattern="[1-9][0-9]*"
                    placeholder="1 - 1199"
                    value={targetX != null && Number(targetX) > 0 ? String(targetX) : ''}
                    onChange={e => handleCoordChange('target_x', e.target.value)}
                    style={{
                      width: '100%',
                      padding: '6px 8px',
                      borderRadius: '8px',
                      background: 'rgba(0,0,0,0.35)',
                      border: !isXValid
                        ? '1px solid rgba(239,68,68,0.65)'
                        : '1px solid rgba(255,255,255,0.12)',
                      color: '#f0fdf4',
                      fontSize: '12px',
                      fontFamily: 'monospace',
                      textAlign: 'center',
                      outline: 'none',
                    }}
                  />
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <span style={{ color: '#9ca3af', fontSize: '12px', fontWeight: 700, minWidth: '14px' }}>Y</span>
                  <input
                    type="text"
                    inputMode="numeric"
                    pattern="[1-9][0-9]*"
                    placeholder="1 - 1199"
                    value={targetY != null && Number(targetY) > 0 ? String(targetY) : ''}
                    onChange={e => handleCoordChange('target_y', e.target.value)}
                    style={{
                      width: '100%',
                      padding: '6px 8px',
                      borderRadius: '8px',
                      background: 'rgba(0,0,0,0.35)',
                      border: !isYValid
                        ? '1px solid rgba(239,68,68,0.65)'
                        : '1px solid rgba(255,255,255,0.12)',
                      color: '#f0fdf4',
                      fontSize: '12px',
                      fontFamily: 'monospace',
                      textAlign: 'center',
                      outline: 'none',
                    }}
                  />
                </div>
              </div>

              {(hasInvalidCoords || coordsError) && (
                <div style={{ color: '#f87171', fontSize: '11px', marginTop: '6px' }}>
                  {t('tasks.invalidCoordsWarning')}
                </div>
              )}
            </div>

            {/* اختيار الموارد المراد المساعدة بها */}
            <div>
              <SectionLabel text={t('tasks.resourceType', 'نوع المورد')} />
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
                {TRANSPORT_RESOURCES.map(r => (
                  <ResCard
                    key={r.id}
                    img={r.img}
                    label={t(r.resKey)}
                    selected={selectedIds.includes(r.id)}
                    onClick={() => toggleHelpResource(r.id)}
                  />
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    )
  }


  // ─────────────────────────────────────────────────────────────────────────
  // 7. النشاط اليومي (Daily Activity)
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'daily') {
    const fl = cfg.flower || { enabled: false, allow_gold: false }
    const wm = cfg.wonder_merchant || { enabled: false }
    const ms = cfg.material_synthesis || { enabled: false }
    const cw = (cfg as any).cure_wounded || { enabled: false, mode: 'daily' }
    const fe = (cfg as any).forge_equipment || { enabled: false, category: 'weapon' }
    const dt = (cfg as any).daily_train || { enabled: false }
    const ar = (cfg as any).arena || { enabled: false, arena_type: 'kingdom', auto_claim_rewards: true }
    const ht = (cfg as any).hero_trial || { enabled: false }
    const ch = (cfg as any).command_hall || { enabled: false, mode: 'daily', allow_marches: false, auto_claim_rewards: true, auto_upgrade_hall: true }
    const mmDaily: any = cfg.march_manager || {}
    const dailyHuntEnabled = Boolean(mmDaily.daily_hunt?.enabled)
    const dailyGatherEnabled = Boolean(mmDaily.daily_gather?.enabled)

    const toggleDailyMarch = (key: 'daily_hunt' | 'daily_gather') => (enabled: boolean) => {
      update(
        'march_manager',
        {
          ...(enabled ? { enabled: true } : {}),
          [key]: { enabled },
        } as any,
        150
      )
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        {/* الهجوم على الوحوش (النشاط اليومي - مستوى تلقائي بدون تشكيلة) */}
        <TaskRow
          id="daily_hunt"
          img="/images/combat/yagmaci.png"
          label={t('tasks.dailyHunt', 'الهجوم على الوحوش (النشاط اليومي)')}
          description={t('tasks.dailyHuntDesc', 'إنجاز مهمة الوحوش اليومية تلقائياً حسب مستوى قدرة القلعة')}
          enabled={dailyHuntEnabled}
          onToggle={toggleDailyMarch('daily_hunt')}
          comingSoon={false}
        />

        {/* جمع الموارد (النشاط اليومي - مستوى تلقائي) */}
        <TaskRow
          id="daily_gather"
          img="/images/gather/icon_map_mineral_collect.png"
          label={t('tasks.dailyGather', 'جمع الموارد (النشاط اليومي)')}
          description={t('tasks.dailyGatherDesc', 'إرسال فيالق لإنجاز مهام الجمع اليومية المتاحة للقلعة بمستوى تلقائي')}
          enabled={dailyGatherEnabled}
          onToggle={toggleDailyMarch('daily_gather')}
          comingSoon={false}
        />
        {/* مهام التحالف (التبرع لعلوم التحالف) */}
        <TaskRow
          id="alliance"
          img="/images/daily/lonca.png"
          label={t('tasks.allianceTasks', 'مهام التحالف')}
          enabled={Boolean(cfg.alliance?.enabled)}
          onToggle={toggle('alliance')}
          comingSoon={false}
        />


        {/* مهمة الحيوان (استلام الجوائز والإطعام المجاني) */}
        <TaskRow
          id="pet"
          emoji="🦁"
          img="/images/daily/pet.png"
          label={t('tasks.pet', 'رعاية وجوائز الحيوانات')}
          enabled={cfg.pet?.enabled ?? false} onToggle={toggle('pet')}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {/* تفاصيل آلية المهمة وصمام الأمان */}


            {/* الحيوان المستهدف للإطعام المجاني */}
            <div>
              <div className="gap-2 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 pt-1">
                {PET_TARGETS.map(p => {
                  const isSelected = (cfg.pet?.target_pet === p.id) ||
                                     (!cfg.pet?.target_pet && (p.id as number) === 1256)
                  return (
                    <button
                      key={p.id}
                      type="button"
                      className={clsx(
                        'flex items-center gap-2 px-2.5 py-2 rounded-xl text-start transition-all select-none task-pet-btn',
                        isSelected
                          ? 'border-[1.5px] border-primary-500/80 bg-primary-500/15 text-primary-600 dark:text-primary-300 ring-1 ring-primary-500/40 shadow-xs font-semibold'
                          : 'border border-gray-200 dark:border-white/10 bg-gray-50/70 dark:bg-white/[0.03] hover:bg-gray-100 dark:hover:bg-white/[0.07] text-gray-700 dark:text-gray-300 font-normal'
                      )}
                      onClick={() => update('pet', { target_pet: p.id })}
                      title={t(p.labelKey, p.name)}
                    >
                      <div className="flex justify-center items-center bg-black/5 dark:bg-black/25 p-0.5 rounded-lg w-7 sm:w-8 h-7 sm:h-8 shrink-0">
                        <img
                          src={p.img}
                          alt={p.name}
                          loading="lazy"
                          className="drop-shadow-xs w-full h-full object-contain select-none filter"
                        />
                      </div>
                      <span className="flex-1 text-xs truncate leading-tight">
                        {t(p.labelKey, p.name)}
                      </span>
                    </button>
                  )
                })}
              </div>
            </div>
          </div>
        </TaskRow>

        {/* نافورة الأمنيات الملكية وبئر الحظ (Trevi Fountain) */}
        {(() => {
          const ft = cfg.fountain || {
            enabled: false,
            resources: ['food', 'wood', 'iron', 'coal', 'diamond', 'crystal'],
            gold_times: 0,
          }
          const selectedRes: string[] = Array.isArray(ft.resources) ? ft.resources : []
          const activeResCount = FOUNTAIN_RESOURCES.filter(r => selectedRes.includes(r.key)).length

          const toggleRes = (key: string) => {
            const next = selectedRes.includes(key)
              ? selectedRes.filter(k => k !== key)
              : [...selectedRes, key]
            update('fountain', { resources: next })
          }

          const selectAll = () => {
            update('fountain', { resources: FOUNTAIN_RESOURCES.map(r => r.key) })
          }

          const deselectAll = () => {
            update('fountain', { resources: [] })
          }

          const currentGoldTimes = Math.max(0, Number(ft.gold_times) || 0)
          const isGoldAllowed = currentGoldTimes > 0

          return (
            <TaskRow
              id="fountain"
              img="/images/fountain/fountain.png"
              label={t('tasks.fountainOfWishes')}
              enabled={ft.enabled}
              onToggle={toggle('fountain')}
              comingSoon={false}

            >
              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '2px' }}>
                {/* ── قسم اختيار الموارد الستة للتمني ── */}
                <div>
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: '6px',
                    flexWrap: 'wrap',
                    gap: '6px',
                  }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span className={clsx('task-fountain-counter-badge', activeResCount > 0 ? 'active' : 'empty')}>
                        {t('tasks.countOfTotalResources', { active: activeResCount, total: FOUNTAIN_RESOURCES.length })}
                      </span>
                    </div>

                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <button
                        type="button"
                        onClick={selectAll}
                        className="task-fountain-btn-select-all"
                      >
                        {t('common.selectAll')}
                      </button>
                      <button
                        type="button"
                        onClick={deselectAll}
                        className="task-fountain-btn-deselect-all"
                      >
                        {t('common.cancelAll')}
                      </button>
                    </div>
                  </div>

                  {/* شبكة بطاقات الموارد الستة */}
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: '6px' }}>
                    {FOUNTAIN_RESOURCES.map(r => {
                      const isSelected = selectedRes.includes(r.key)
                      return (
                        <button
                          key={r.key}
                          type="button"
                          className={clsx('task-fountain-card', isSelected ? 'selected' : 'unselected')}
                          onClick={() => toggleRes(r.key)}
                        >
                          <div className={clsx('task-fountain-icon-box', isSelected ? 'selected' : 'unselected')}>
                            <img
                              src={r.img}
                              alt={t(r.resKey)}
                              style={{
                                width: '20px',
                                height: '20px',
                                objectFit: 'contain',
                                filter: isSelected ? 'drop-shadow(0 0 6px rgba(var(--theme-primary-rgb),0.6))' : 'grayscale(25%) opacity(0.8)',
                                transition: 'filter 0.15s ease',
                              }}
                              onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                            />
                          </div>
                          <span className={clsx('task-fountain-name', isSelected ? 'selected' : 'unselected')}>
                            {t(r.resKey)}
                          </span>
                        </button>
                      )
                    })}
                  </div>
                </div>

                {/* ── قسم الشراء بالذهب ── */}
                {(() => {
                  const handleToggleGold = (enabled: boolean) => {
                    if (enabled) {
                      update('fountain', {
                        gold_times: Math.max(1, Number(ft.gold_times) || 1),
                      })
                    } else {
                      update('fountain', {
                        gold_times: 0,
                      })
                    }
                  }

                  const setGoldCount = (val: number) => {
                    const count = Math.max(0, val)
                    update('fountain', {
                      gold_times: count,
                    })
                  }

                  return (
                    <div className={clsx('task-fountain-gold-box', isGoldAllowed ? 'enabled' : 'disabled')}>
                      <div style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        gap: '10px',
                        flexWrap: 'wrap',
                      }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <img
                            src="/images/fountain/gold.png"
                            alt="Gold"
                            style={{
                              width: '22px',
                              height: '22px',
                              objectFit: 'contain',
                              filter: isGoldAllowed ? 'drop-shadow(0 0 6px rgba(var(--theme-primary-rgb),0.6))' : 'grayscale(60%) opacity(0.6)',
                            }}
                            onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                          />
                          <div>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                              <span className={clsx('task-fountain-gold-title', isGoldAllowed ? 'enabled' : 'disabled')}>
                                {t('tasks.allowGoldPurchase')}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* مفتاح التفعيل الصريح (Toggle) وأداة التحكم بالأرقام (+ / -) */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                          {isGoldAllowed && (
                            <Stepper
                              value={currentGoldTimes}
                              min={1}
                              max={50}
                              onChange={setGoldCount}
                            />
                          )}
                          <Toggle
                            value={isGoldAllowed}
                            onChange={handleToggleGold}
                            size="sm"
                          />
                        </div>
                      </div>

                      {/* رسالة توضيحية للأمان */}
                      
                    </div>
                  )
                })()}
              </div>
            </TaskRow>
          )
        })()}

        {/* إهداء الزهور (النشاط اليومي) */}
        <TaskRow
          id="flower"
          emoji="🌸"
          img="/images/daily/flower.png"
          label={t('tasks.giveFlowers', 'إهداء الزهور (النشاط اليومي)')}
          enabled={Boolean(fl.enabled)}
          onToggle={toggle('flower')}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '2px' }}>
            {/* خيار السماح بالشراء بالذهب (allow_gold) */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '6px 10px',
              background: fl.allow_gold ? 'rgba(245,158,11,0.08)' : 'rgba(255,255,255,0.03)',
              border: fl.allow_gold ? '1px solid rgba(245,158,11,0.25)' : '1px solid rgba(255,255,255,0.06)',
              borderRadius: '8px',
              transition: 'all 0.15s ease',
            }}>
              <div>
                <div style={{
                  fontSize: '12px',
                  fontWeight: 600,
                  color: fl.allow_gold ? '#fbbf24' : '#e2e8f0',
                }}>
                  {t('tasks.allowGoldFlower', 'السماح بالشراء بالذهب (10 ذهب) إذا نفدت زهور الحقيبة')}
                </div>
              </div>
              <Toggle
                value={Boolean(fl.allow_gold)}
                onChange={v => update('flower', { allow_gold: v })}
                size="sm"
              />
            </div>
          </div>
        </TaskRow>

        {/* التاجر العجيب (النشاط اليومي) */}
        <TaskRow
          id="wonder_merchant"
          emoji="🏪"
          img="/images/prestige/kacakci.png"
          label={t('tasks.wonderMerchant', 'التاجر العجيب (النشاط اليومي)')}
          enabled={Boolean(wm.enabled)}
          onToggle={toggle('wonder_merchant')}
          comingSoon={false}
        />

        {/* تجميع المواد (النشاط اليومي) */}
        <TaskRow
          id="material_synthesis"
          emoji="⚒️"
          img="/images/daily/material_synthesis.png"
          label={t('tasks.materialSynthesis', 'تجميع المواد (النشاط اليومي)')}
          enabled={Boolean(ms.enabled)}
          onToggle={toggle('material_synthesis')}
          comingSoon={false}
        />

        {/* تصنيع العتاد (النشاط اليومي - Forge Equipment) */}
        <TaskRow
          id="forge_equipment"
          img="/images/daily/forge_equipment.png"
          label={t('tasks.forgeEquipment')}
          enabled={Boolean(fe.enabled)}
          onToggle={toggle('forge_equipment' as any)}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '4px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
              <span style={{ fontSize: '12px', color: '#94a3b8', fontWeight: 500 }}>
                {t('tasks.forgeCategory',"صنف العتاد المطلوب:")}
              </span>
            </div>

            {/* شبكة اختيار الأصناف الستة بأيقوناتها المستخرجة */}
            <div className="gap-1.5 grid grid-cols-3 sm:grid-cols-6 pt-2">
              {EQUIPMENT_CATEGORIES.map(cat => {
                const isSelected = (fe.category || 'weapon') === cat.key
                return (
                  <button
                    key={cat.key}
                    type="button"
                    onClick={() => update('forge_equipment' as any, { category: cat.key }, 150)}
                    style={{
                      padding: '6px 4px',
                      borderRadius: '8px',
                      border: isSelected ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)' : '1px solid rgba(255,255,255,0.08)',
                      background: isSelected ? 'rgba(var(--theme-primary-rgb),0.12)' : 'rgba(255,255,255,0.03)',
                      color: isSelected ? 'var(--theme-primary-light)' : '#9ca3af',
                      fontSize: '11px',
                      fontWeight: isSelected ? 600 : 400,
                      cursor: 'pointer',
                      fontFamily: 'inherit',
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '4px',
                      transition: 'all 0.15s ease',
                    }}
                  >
                    <img
                      src={cat.img}
                      alt={t(cat.labelKey)}
                      style={{
                        width: '24px',
                        height: '24px',
                        objectFit: 'contain',
                        filter: isSelected ? 'drop-shadow(0 0 6px rgba(var(--theme-primary-rgb),0.5))' : 'grayscale(20%) opacity(0.8)',
                        transition: 'all 0.15s',
                      }}
                      onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                    />
                    <span style={{ fontSize: '11px', whiteSpace: 'nowrap' }}>
                      {t(cat.labelKey)}
                    </span>
                  </button>
                )
              })}
            </div>
          </div>
        </TaskRow>

        {/* علاج المصابين (النشاط اليومي) */}
        <TaskRow
          id="cure_wounded"
          emoji="⛺"
          img="/images/daily/cure_wounded.png"
          label={t('tasks.cureWounded', 'علاج المصابين (النشاط اليومي)')}
          enabled={Boolean(cw.enabled)}
          onToggle={toggle('cure_wounded')}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '4px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px', flexWrap: 'wrap' }}>
              <span style={{ fontSize: '12px', color: '#94a3b8' }}>
                {t('tasks.cureWoundedModeLabel', 'نمط علاج المصابين:')}
              </span>
              <div style={{ display: 'inline-flex', background: 'rgba(255,255,255,0.05)', borderRadius: '8px', padding: '2px', border: '1px solid rgba(255,255,255,0.08)' }}>
                <button
                  type="button"
                  onClick={() => update('cure_wounded' as any, { mode: 'daily' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: cw.mode !== 'all' ? 600 : 400,
                    background: cw.mode !== 'all' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: cw.mode !== 'all' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: cw.mode !== 'all' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.cureWoundedModeDaily', '🩺 النشاط اليومي (المتبقي حتى 500)')}
                </button>
                <button
                  type="button"
                  onClick={() => update('cure_wounded' as any, { mode: 'all' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: cw.mode === 'all' ? 600 : 400,
                    background: cw.mode === 'all' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: cw.mode === 'all' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: cw.mode === 'all' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.cureWoundedModeAll', '🏥 علاج جميع المصابين')}
                </button>
              </div>
            </div>
          </div>
        </TaskRow>

        {/* تدريب جنود النشاط اليومي (Daily Activity Troop Training) */}
        <TaskRow
          id="daily_train"
          img="/images/daily/egitim_stratejisi.png"
          label={t('tasks.dailyTrain', 'تدريب جنود النشاط اليومي (250 وحدة Lv.1)')}
          enabled={Boolean(dt.enabled)}
          onToggle={toggle('daily_train' as any)}
          comingSoon={false}
        />


        {/* تحدي الحلبة (Arena Challenge) */}
        <TaskRow
          id="arena"
          emoji="🏟️"
          img="/images/daily/icon_build_121.png"
          label={t('tasks.arena.title', 'تحدي الحلبة')}
          description={t('tasks.arena.desc', 'خوض 3 تحديات يومية ضد أضعف الخصوم واستلام جوائز الترتيب التراكمية')}
          enabled={Boolean(ar.enabled)}
          onToggle={toggle('arena' as any)}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '4px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px', flexWrap: 'wrap' }}>
              <span style={{ fontSize: '12px', color: '#94a3b8' }}>
                {t('tasks.arena.typeLabel', 'نوع الحلبة:')}
              </span>
              <div style={{ display: 'inline-flex', background: 'rgba(255,255,255,0.05)', borderRadius: '8px', padding: '2px', border: '1px solid rgba(255,255,255,0.08)' }}>
                <button
                  type="button"
                  onClick={() => update('arena' as any, { arena_type: 'kingdom' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: ar.arena_type !== 'global' ? 600 : 400,
                    background: ar.arena_type !== 'global' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: ar.arena_type !== 'global' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: ar.arena_type !== 'global' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.arena.kingdom', 'حلبة المملكة (يومياً)')}
                </button>
                <button
                  type="button"
                  onClick={() => update('arena' as any, { arena_type: 'global' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: ar.arena_type === 'global' ? 600 : 400,
                    background: ar.arena_type === 'global' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: ar.arena_type === 'global' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: ar.arena_type === 'global' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.arena.global', 'حلبة العالم (الأحد تلقائياً)')}
                </button>
              </div>
            </div>
          </div>
        </TaskRow>

        {/* كفاءة الجندي (Hero Trial - مهمة النشاط اليومي رقم 25) */}
        <TaskRow
          id="hero_trial"
          emoji="⚔️"
          img="/images/daily/hero_trial.png"
          label={t('tasks.hero_trial.title', 'كفاءة الجندي')}
          description={t('tasks.hero_trial.desc', 'المشاركة في تحدي كفاءة الجندي لمرة واحدة بالحد الأدنى لكسب 20 نقطة نشاط')}
          enabled={Boolean(ht.enabled)}
          onToggle={toggle('hero_trial' as any)}
          comingSoon={false}
        />

        {/* مهام قاعة القيادة (Command Hall Tasks - مهمة النشاط اليومي رقم 33) */}
        <TaskRow
          id="command_hall"
          emoji="🏛️"
          img="/images/daily/command_hall.png"
          label={t('tasks.command_hall.title', 'مهام قاعة القيادة')}
          description={t('tasks.command_hall.desc', 'إنجاز مهام قاعة القيادة واستلام الجوائز لإتمام مهمة النشاط اليومي وترقية القاعة')}
          enabled={Boolean(ch.enabled)}
          onToggle={toggle('command_hall' as any)}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '2px' }}>
            {/* نمط التنفيذ: النشاط اليومي (دورة واحدة يومياً) أو دورة كاملة مستمرة */}
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '10px' }}>
              <span style={{ fontSize: '12px', color: '#e2e8f0', fontWeight: 500 }}>
                {t('tasks.command_hall.modeLabel', 'نمط التنفيذ')}
              </span>
              <div style={{ display: 'inline-flex', background: 'rgba(255,255,255,0.05)', borderRadius: '8px', padding: '2px', border: '1px solid rgba(255,255,255,0.08)' }}>
                <button
                  type="button"
                  onClick={() => update('command_hall' as any, { mode: 'daily' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: ch.mode !== 'full' ? 600 : 400,
                    background: ch.mode !== 'full' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: ch.mode !== 'full' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: ch.mode !== 'full' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.command_hall.modeDaily', 'النشاط اليومي (دورة واحدة يومياً)')}
                </button>
                <button
                  type="button"
                  onClick={() => update('command_hall' as any, { mode: 'full' }, 150)}
                  style={{
                    padding: '4px 10px',
                    borderRadius: '6px',
                    fontSize: '11px',
                    fontWeight: ch.mode === 'full' ? 600 : 400,
                    background: ch.mode === 'full' ? 'rgba(59, 130, 246, 0.25)' : 'transparent',
                    border: ch.mode === 'full' ? '1px solid rgba(59, 130, 246, 0.4)' : '1px solid transparent',
                    color: ch.mode === 'full' ? '#60a5fa' : '#94a3b8',
                    cursor: 'pointer',
                    transition: 'all 0.15s ease',
                  }}
                >
                  {t('tasks.command_hall.modeFull', 'دورة كاملة مستمرة')}
                </button>
              </div>
            </div>

            {/* خيار السماح بالمسير القتالي للمعارك */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '6px 10px',
              background: ch.allow_marches ? 'rgba(239,68,68,0.08)' : 'rgba(255,255,255,0.03)',
              border: ch.allow_marches ? '1px solid rgba(239,68,68,0.25)' : '1px solid rgba(255,255,255,0.06)',
              borderRadius: '8px',
              transition: 'all 0.15s ease',
            }}>
              <div>
                <div style={{
                  fontSize: '12px',
                  fontWeight: 600,
                  color: ch.allow_marches ? '#f87171' : '#e2e8f0',
                }}>
                  {t('tasks.command_hall.allowMarches', 'السماح بإرسال فيالق للمهام القتالية عند توفر جنود وطوابير')}
                </div>
              </div>
              <Toggle
                value={Boolean(ch.allow_marches)}
                onChange={v => update('command_hall' as any, { allow_marches: v })}
                size="sm"
              />
            </div>

            {/* خيار الترقية التلقائية لمستوى قاعة القيادة */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '6px 10px',
              background: ch.auto_upgrade_hall !== false ? 'rgba(59,130,246,0.08)' : 'rgba(255,255,255,0.03)',
              border: ch.auto_upgrade_hall !== false ? '1px solid rgba(59,130,246,0.25)' : '1px solid rgba(255,255,255,0.06)',
              borderRadius: '8px',
              transition: 'all 0.15s ease',
            }}>
              <div>
                <div style={{
                  fontSize: '12px',
                  fontWeight: 600,
                  color: ch.auto_upgrade_hall !== false ? '#60a5fa' : '#e2e8f0',
                }}>
                  {t('tasks.command_hall.autoUpgradeHall', 'ترقية مستوى قاعة القيادة تلقائياً عند اكتمال النقاط المطلوبة')}
                </div>
              </div>
              <Toggle
                value={Boolean(ch.auto_upgrade_hall !== false)}
                onChange={v => update('command_hall' as any, { auto_upgrade_hall: v })}
                size="sm"
              />
            </div>
          </div>
        </TaskRow>
      </div>
    )
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 8. التطوير والمكافآت (Building)
  // ─────────────────────────────────────────────────────────────────────────
  if (tab === 'building') {
    const bld = cfg.building
    const sk = cfg.skills || { enabled: false, target_skills: [] }
    const sh = cfg.shield || { enabled: false, duration: '8h', allow_gold: false }
    const targetSkills = Array.isArray(sk.target_skills) ? sk.target_skills : []

    const mw = (cfg as any).material_workshop || { enabled: false, selected_materials: DEFAULT_WORKSHOP_MATERIAL_IDS }
    const selectedMaterials: number[] = Array.isArray(mw.selected_materials) && mw.selected_materials.length > 0
      ? mw.selected_materials
      : DEFAULT_WORKSHOP_MATERIAL_IDS

    const toggleMaterial = (id: number) => {
      let next: number[]
      if (selectedMaterials.includes(id)) {
        if (selectedMaterials.length <= 1) {
          return
        }
        next = selectedMaterials.filter((x: number) => x !== id)
      } else {
        next = [...selectedMaterials, id]
      }
      update('material_workshop' as any, { selected_materials: next })
    }

    const selectAllMaterials = () => {
      update('material_workshop' as any, { selected_materials: [...DEFAULT_WORKSHOP_MATERIAL_IDS] })
    }

    const isSkillSelected = (id: string) => {
      if (targetSkills.includes(id)) return true
      if (id === '12008' && (targetSkills.includes('harvest') || targetSkills.includes('warehouse'))) return true
      if (id === '12022' && (targetSkills.includes('gather') || targetSkills.includes('fast_dig'))) return true
      if (id === '13021' && targetSkills.includes('stamina')) return true
      return false
    }

    const toggleLordSkill = (id: string) => {
      const selected = isSkillSelected(id)
      let next: string[]
      if (selected) {
        next = targetSkills.filter(x => x !== id && x !== 'harvest' && x !== 'gather' && x !== 'warehouse' && x !== 'stamina' && x !== 'fast_dig')
      } else {
        next = [...targetSkills, id]
      }
      update('skills', { target_skills: next })
    }

    const filteredSkills = activeSkillCategory === 'all'
      ? LORD_SKILLS
      : LORD_SKILLS.filter(s => s.category === activeSkillCategory)

    const selectAllFilteredSkills = () => {
      const idsToAdd = filteredSkills.map(s => s.id)
      const merged = Array.from(new Set([...targetSkills, ...idsToAdd]))
      update('skills', { target_skills: merged })
    }

    const deselectAllFilteredSkills = () => {
      const idsToRemove = new Set(filteredSkills.map(s => s.id))
      if (activeSkillCategory === 'all' || activeSkillCategory === 'develop') {
        idsToRemove.add('harvest')
        idsToRemove.add('gather')
        idsToRemove.add('warehouse')
        idsToRemove.add('fast_dig')
      }
      if (activeSkillCategory === 'all' || activeSkillCategory === 'auxiliary') {
        idsToRemove.add('stamina')
      }
      const next = targetSkills.filter(x => !idsToRemove.has(x))
      update('skills', { target_skills: next })
    }

    const selectedSkillsCount = LORD_SKILLS.filter(s => isSkillSelected(s.id)).length

    const targetBuildings = bld.target_buildings ?? {
      farm: true,
      sawmill: true,
      iron_mine: true,
      quartz_mine: true,
      hospital: true,
      military_tent: true,
    }

    const toggleTargetBuilding = (key: string) => {
      const current = targetBuildings[key as keyof typeof targetBuildings] ?? true
      const updated = {
        ...targetBuildings,
        [key]: !current,
      }
      update('building', { target_buildings: updated })
    }

    const selectAllBuildings = () => {
      update('building', {
        target_buildings: {
          farm: true,
          sawmill: true,
          iron_mine: true,
          quartz_mine: true,
          hospital: true,
          military_tent: true,
        },
      })
    }

    const deselectAllBuildings = () => {
      update('building', {
        target_buildings: {
          farm: false,
          sawmill: false,
          iron_mine: false,
          quartz_mine: false,
          hospital: false,
          military_tent: false,
        },
      })
    }

    const supportBuildingOptions = [
      { key: 'farm',          nameKey: 'tasks.bldFarm',         bid: '201', img: '/images/development/camps/tahilmaden.png' },
      { key: 'sawmill',       nameKey: 'tasks.bldSawmill',      bid: '202', img: '/images/development/camps/odunmaden.png' },
      { key: 'iron_mine',     nameKey: 'tasks.bldIronMine',     bid: '203', img: '/images/development/camps/demirmaden.png' },
      { key: 'quartz_mine',   nameKey: 'tasks.bldQuartzMine',   bid: '204', img: '/images/development/camps/kuvarsmaden.png' },
      { key: 'hospital',      nameKey: 'tasks.bldHospital',     bid: '206', img: '/images/development/camps/aramayi_tamamla.png' },
      { key: 'military_tent', nameKey: 'tasks.bldMilitaryTent', bid: '205', img: '/images/development/camps/egitimcadiri.png' },
    ]

    const activeBuildingsCount = Object.values(targetBuildings).filter(Boolean).length

    const toggleBuilding = (v: boolean) => {
      if (!v) {
        // إغلاق القائمة المنسدلة فوراً
        setExpandedTaskId(prev => (prev === 'building' || prev === t('tasks.executeBuilding')) ? null : prev)
        // إلغاء تفعيل البناء العام وكافة المهام والخيارات التابعة له
        update('building', {
          enabled: false,
          upgrade_castle: false,
          speedup_castle: false,
          upgrade_support_buildings: false,
        }, 150)
      } else {
        // تفعيل البناء العام مع القلعة والمباني الموصى بها افتراضياً
        update('building', {
          enabled: true,
          upgrade_castle: true,
          upgrade_support_buildings: true,
        }, 150)
      }
    }

    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        {/* تنفيذ البناء */}
        <TaskRow
          id="building"
          img="/images/development/insaat.png"
          label={t('tasks.executeBuilding')}
          enabled={bld.enabled}
          onToggle={toggleBuilding}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {/* تنبيه توضيحي بأن إغلاق الرئيسي يغلق الفرعي */}
            <div style={{
              display: 'flex', alignItems: 'center', gap: '6px',
              padding: '6px 10px', borderRadius: '8px',
              background: 'rgba(255,255,255,0.02)',
              border: '1px solid rgba(255,255,255,0.06)',
              fontSize: '11px', color: '#9ca3af',
            }}>
              <span>💡</span>
              <span>{t('tasks.buildingMasterNotice')}</span>
            </div>

            {/* القلعة فقط */}
            <div style={{
              display: 'flex', alignItems: 'center', justifyContent: 'space-between',
              padding: '6px 10px',
              background: bld.upgrade_castle ? 'rgba(var(--theme-primary-rgb),0.06)' : 'rgba(255,255,255,0.02)',
              border: bld.upgrade_castle ? '1px solid rgba(var(--theme-primary-rgb),0.2)' : '1px solid rgba(255,255,255,0.05)',
              borderRadius: '9px',
              transition: 'all 0.15s ease',
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <div style={{
                  width: '26px', height: '26px', borderRadius: '7px',
                  background: 'rgba(255,255,255,0.04)', display: 'flex', alignItems: 'center', justifyContent: 'center',
                  border: '1px solid rgba(255,255,255,0.08)', flexShrink: 0,
                }}>
                  <img src="/images/development/insaat.png" alt="" style={{ width: '18px', height: '18px', objectFit: 'contain' }} />
                </div>
                <div>
                  <div style={{ color: '#f0fdf4', fontWeight: 600, fontSize: '12px' }}>{t('tasks.castleOnly')}</div>
                </div>
              </div>
              <Toggle
                value={Boolean(bld.upgrade_castle)}
                onChange={v => {
                  const willHaveActive = v || Boolean(bld.upgrade_support_buildings)
                  update('building', {
                    upgrade_castle: v,
                    speedup_castle: v ? bld.speedup_castle : false,
                    enabled: willHaveActive,
                  })
                  if (!willHaveActive) {
                    setExpandedTaskId(prev => (prev === 'building' || prev === t('tasks.executeBuilding')) ? null : prev)
                  }
                }}
                size="sm"
              />
            </div>

            {/* استخدام التسريع */}
            <div style={{
              display: 'flex', alignItems: 'center', justifyContent: 'space-between',
              padding: '6px 10px',
              background: bld.speedup_castle ? 'rgba(var(--theme-primary-rgb),0.06)' : 'rgba(255,255,255,0.02)',
              border: bld.speedup_castle ? '1px solid rgba(var(--theme-primary-rgb),0.2)' : '1px solid rgba(255,255,255,0.05)',
              borderRadius: '9px',
              transition: 'all 0.15s ease',
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <div style={{
                  width: '26px', height: '26px', borderRadius: '7px',
                  background: 'rgba(255,255,255,0.04)', display: 'flex', alignItems: 'center', justifyContent: 'center',
                  border: '1px solid rgba(255,255,255,0.08)', flexShrink: 0,
                }}>
                  <img src="/images/development/speedup.png" alt="" style={{ width: '18px', height: '18px', objectFit: 'contain' }} />
                </div>
                <div>
                  <div style={{ color: '#f0fdf4', fontWeight: 600, fontSize: '12px' }}>{t('tasks.useSpeedup')}</div>
                  <div style={{ color: '#6b7280', fontSize: '10px', marginTop: '1px' }}>{t('tasks.speedupCastleDesc')}</div>
                </div>
              </div>
              <Toggle
                value={Boolean(bld.speedup_castle)}
                onChange={v => {
                  update('building', {
                    speedup_castle: v,
                    ...(v ? { upgrade_castle: true, enabled: true } : {}),
                  })
                }}
                size="sm"
              />
            </div>

            {/* ترقية المعسكرات والمباني الداعمة */}
            <div style={{
              display: 'flex', flexDirection: 'column', gap: '6px',
              padding: '6px 10px',
              background: bld.upgrade_support_buildings ? 'rgba(var(--theme-primary-rgb),0.06)' : 'rgba(255,255,255,0.02)',
              border: bld.upgrade_support_buildings ? '1px solid rgba(var(--theme-primary-rgb),0.2)' : '1px solid rgba(255,255,255,0.05)',
              borderRadius: '9px',
              transition: 'all 0.15s ease',
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <div style={{
                    width: '26px', height: '26px', borderRadius: '7px',
                    background: 'rgba(255,255,255,0.04)', display: 'flex', alignItems: 'center', justifyContent: 'center',
                    border: '1px solid rgba(255,255,255,0.08)', flexShrink: 0,
                  }}>
                    <img src="/images/development/camps/egitimcadiri.png" alt="" style={{ width: '20px', height: '16px', objectFit: 'contain' }} />
                  </div>
                  <div>
                    <div style={{ color: '#f0fdf4', fontWeight: 600, fontSize: '12px' }}>{t('tasks.upgradeSupportBuildings')}</div>
                  </div>
                </div>
                <Toggle
                  value={Boolean(bld.upgrade_support_buildings)}
                  onChange={v => {
                    const willHaveActive = v || Boolean(bld.upgrade_castle)
                    update('building', {
                      upgrade_support_buildings: v,
                      enabled: willHaveActive,
                    })
                    if (!willHaveActive) {
                      setExpandedTaskId(prev => (prev === 'building' || prev === t('tasks.executeBuilding')) ? null : prev)
                    }
                  }}
                  size="sm"
                />
              </div>

              {/* شبكة المباني الـ 6 التفاعلية */}
              {bld.upgrade_support_buildings && (
                <div className="task-support-bld-box" style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '6px',
                  marginTop: '4px',
                  padding: '8px',
                  background: 'rgba(0,0,0,0.3)',
                  borderRadius: '9px',
                  border: '1px solid rgba(255,255,255,0.06)',
                }}>
                  {/* شريط التحكم السريع ومعلومات التفعيل */}
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    flexWrap: 'wrap',
                    gap: '6px',
                    paddingBottom: '4px',
                    borderBottom: '1px solid rgba(255,255,255,0.06)',
                  }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <span style={{
                        padding: '1px 7px',
                        borderRadius: '8px',
                        background: activeBuildingsCount > 0 ? 'rgba(var(--theme-primary-rgb),0.15)' : 'rgba(239,68,68,0.15)',
                        border: activeBuildingsCount > 0 ? '1px solid rgba(var(--theme-primary-rgb),0.3)' : '1px solid rgba(239,68,68,0.3)',
                        color: activeBuildingsCount > 0 ? '#4ade80' : '#f87171',
                        fontSize: '11px',
                        fontWeight: 600,
                      }}>
                        {t('tasks.activeBuildingsRatio', { active: activeBuildingsCount, total: 6 })}
                      </span>
                    </div>

                    <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
                      <button
                        type="button"
                        onClick={selectAllBuildings}
                        style={{
                          background: 'rgba(var(--theme-primary-rgb),0.12)',
                          border: '1px solid rgba(var(--theme-primary-rgb),0.25)',
                          borderRadius: '6px',
                          padding: '2px 8px',
                          color: '#86efac',
                          fontSize: '11px',
                          fontWeight: 500,
                          cursor: 'pointer',
                          fontFamily: 'inherit',
                          transition: 'all 0.15s ease',
                        }}
                      >
                        {t('common.selectAll')}
                      </button>
                      <button
                        type="button"
                        onClick={deselectAllBuildings}
                        style={{
                          background: 'rgba(255,255,255,0.04)',
                          border: '1px solid rgba(255,255,255,0.08)',
                          borderRadius: '6px',
                          padding: '2px 8px',
                          color: '#9ca3af',
                          fontSize: '11px',
                          fontWeight: 500,
                          cursor: 'pointer',
                          fontFamily: 'inherit',
                          transition: 'all 0.15s ease',
                        }}
                      >
                        {t('common.cancelAll')}
                      </button>
                    </div>
                  </div>

                  {/* الشبكة التفاعلية للمباني الـ 6 */}
                  <div className="gap-2 sm:gap-2 grid grid-cols-2 sm:grid-cols-3">
                    {supportBuildingOptions.map(b => {
                      const isSelected = Boolean(targetBuildings[b.key as keyof typeof targetBuildings] ?? true)
                      return (
                        <button
                          key={b.key}
                          type="button"
                          className={clsx('relative flex flex-col justify-between items-center p-2 rounded-xl transition-all duration-150 cursor-pointer task-support-bld-card', isSelected ? 'selected' : 'unselected')}
                          onClick={() => toggleTargetBuilding(b.key)}
                          style={{
                            background: isSelected
                              ? 'linear-gradient(135deg, rgba(var(--theme-primary-rgb),0.14) 0%, rgba(var(--theme-primary-rgb),0.08) 100%)'
                              : 'rgba(255,255,255,0.02)',
                            border: isSelected
                              ? '1.5px solid rgba(var(--theme-primary-rgb),0.45)'
                              : '1px solid rgba(255,255,255,0.06)',
                            borderRadius: '9px',
                            boxShadow: isSelected ? '0 0 10px rgba(var(--theme-primary-rgb),0.12)' : 'none',
                            opacity: isSelected ? 1 : 0.45,
                            fontFamily: 'inherit',
                            minHeight: '68px',
                          }}
                        >

                          <div style={{
                            width: '44px',
                            height: '30px',
                            background: isSelected ? 'rgba(var(--theme-primary-rgb),0.15)' : 'rgba(255,255,255,0.04)',
                            borderRadius: '6px',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            border: isSelected ? '1px solid rgba(var(--theme-primary-rgb),0.3)' : '1px solid rgba(255,255,255,0.06)',
                            filter: isSelected ? 'drop-shadow(0 0 6px rgba(var(--theme-primary-rgb),0.35))' : 'grayscale(25%)',
                            transition: 'all 0.15s',
                          }}>
                            <img src={b.img} alt={t(b.nameKey)} style={{ width: '34px', height: '24px', objectFit: 'contain' }} />
                          </div>

                          <span
                            className="task-support-bld-name"
                            style={{
                              color: isSelected ? '#f0fdf4' : '#9ca3af',
                              fontSize: '11px',
                              fontWeight: isSelected ? 600 : 500,
                              textAlign: 'center',
                              lineHeight: 1.2,
                              marginTop: '4px',
                            }}
                          >
                            {t(b.nameKey)}
                          </span>
                        </button>
                      )
                    })}
                  </div>
                </div>
              )}
            </div>
          </div>
        </TaskRow>

        {/* أبحاث المعهد (البحث الموصى به) */}
        <TaskRow
          id="research"
          img="/images/development/arastir.png"
          label={t('tasks.conductResearch')}
          enabled={Boolean(cfg.research?.enabled)}
          onToggle={toggle('research')}
          comingSoon={false}
        />

        {/* مهارات الأمير (Lord Skills) */}
        <TaskRow
          id="skills"
          img="/images/skills/lord/Develop_8.png"
          label={t('tasks.lordSkills', 'مهارات الأمير')}
          description={t('tasks.lordSkillsDesc', 'تفعيل المهارات النشطة تلقائياً مع التبديل الذكي للأطقم')}
          enabled={Boolean(sk.enabled)}
          onToggle={v => update('skills', { enabled: v })}
          comingSoon={false}
        >
          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '10px',
              paddingTop: '4px',
            }}
          >
            {/* بار التصنيفات وأزرار تحديد الكل */}
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                flexWrap: 'wrap',
                gap: '8px',
                borderBottom: '1px solid rgba(255,255,255,0.06)',
                paddingBottom: '8px',
              }}
            >
              {/* تصنيفات المهارات: الكل، قتال، تطوير، دعم */}
              <div style={{ display: 'flex', alignItems: 'center', gap: '4px', flexWrap: 'wrap' }}>
                {[
                  { key: 'all', label: t('common.all', 'الكل'), emoji: '🌟', count: 16 },
                  { key: 'battle', label: t('tasks.skillCategoryBattle', 'قتال'), emoji: '⚔️', count: 6 },
                  { key: 'develop', label: t('tasks.skillCategoryDevelop', 'تطوير'), emoji: '🌾', count: 5 },
                  { key: 'auxiliary', label: t('tasks.skillCategoryAuxiliary', 'دعم'), emoji: '🛡️', count: 5 },
                ].map(cat => {
                  const isActive = activeSkillCategory === cat.key
                  return (
                    <button
                      key={cat.key}
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation()
                        setActiveSkillCategory(cat.key as any)
                      }}
                      style={{
                        padding: '4px 10px',
                        fontSize: '11px',
                        fontWeight: isActive ? 600 : 400,
                        borderRadius: '6px',
                        border: isActive ? '1px solid rgba(var(--theme-primary-rgb),0.5)' : '1px solid rgba(255,255,255,0.08)',
                        background: isActive ? 'rgba(var(--theme-primary-rgb),0.15)' : 'rgba(255,255,255,0.03)',
                        color: isActive ? 'var(--theme-primary-light)' : '#9ca3af',
                        cursor: 'pointer',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '4px',
                        transition: 'all 0.15s ease',
                      }}
                    >
                      <span>{cat.emoji}</span>
                      <span>{cat.label}</span>
                      <span style={{ opacity: 0.7, fontSize: '10px' }}>({cat.count})</span>
                    </button>
                  )
                })}
              </div>

              {/* عداد المهارات المختارة وأزرار التحديد السريع */}
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ fontSize: '11px', color: '#9ca3af' }}>
                  ({selectedSkillsCount}/16)
                </span>
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation()
                    if (!sk.enabled) update('skills', { enabled: true })
                    selectAllFilteredSkills()
                  }}
                  style={{
                    padding: '3px 8px',
                    fontSize: '11px',
                    borderRadius: '6px',
                    border: '1px solid rgba(var(--theme-primary-rgb),0.3)',
                    background: 'rgba(var(--theme-primary-rgb),0.08)',
                    color: 'var(--theme-primary-light)',
                    cursor: 'pointer',
                  }}
                >
                  {t('common.selectAll', 'تحديد الكل')}
                </button>
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation()
                    deselectAllFilteredSkills()
                  }}
                  style={{
                    padding: '3px 8px',
                    fontSize: '11px',
                    borderRadius: '6px',
                    border: '1px solid rgba(255,255,255,0.1)',
                    background: 'rgba(255,255,255,0.04)',
                    color: '#9ca3af',
                    cursor: 'pointer',
                  }}
                >
                  {t('common.deselectAll', 'إلغاء الكل')}
                </button>
              </div>
            </div>

            {/* شبكة كروت المهارات */}
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(130px, 1fr))',
                gap: '8px',
              }}
            >
              {filteredSkills.map(skill => {
                const selected = isSkillSelected(skill.id)
                return (
                  <button
                    key={skill.id}
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation()
                      if (!sk.enabled) update('skills', { enabled: true })
                      toggleLordSkill(skill.id)
                    }}
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      padding: '10px 8px',
                      borderRadius: '10px',
                      border: selected
                        ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)'
                        : '1px solid rgba(255,255,255,0.08)',
                      background: selected
                        ? 'rgba(var(--theme-primary-rgb),0.12)'
                        : 'rgba(255,255,255,0.03)',
                      cursor: 'pointer',
                      transition: 'all 0.15s ease',
                      position: 'relative',
                    }}
                  >
                    {/* أيقونة المهارة */}
                    <img
                      src={skill.img}
                      alt={t(skill.labelKey)}
                      style={{
                        width: '36px',
                        height: '36px',
                        objectFit: 'contain',
                        filter: selected ? 'none' : 'grayscale(30%) opacity(0.85)',
                      }}
                      onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                    />

                    {/* اسم المهارة */}
                    <span
                      style={{
                        fontSize: '11px',
                        fontWeight: selected ? 600 : 400,
                        color: selected ? 'var(--theme-primary-light)' : '#9ca3af',
                        textAlign: 'center',
                        lineHeight: '1.2',
                      }}
                    >
                      {t(skill.labelKey)}
                    </span>

                    {/* علامة التحديد الصغيرة */}
                    {selected && (
                      <div
                        style={{
                          position: 'absolute',
                          top: '4px',
                          right: '4px',
                          width: '14px',
                          height: '14px',
                          borderRadius: '50%',
                          background: 'var(--theme-primary)',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          color: '#fff',
                          fontSize: '9px',
                          fontWeight: 'bold',
                        }}
                      >
                        ✓
                      </div>
                    )}
                  </button>
                )
              })}
            </div>
          </div>
        </TaskRow>

        {/* معمل المواد (Material Workshop) — قائمة قابلة للطي والفتح (مغلقة افتراضياً) */}
        <TaskRow
          id="material_workshop"
          img="/images/materials/2003.png"
          label={t('tasks.materialWorkshop', 'معمل المواد')}
          description={t('tasks.materialWorkshopDesc', 'تكرير وإنتاج المواد وتعبئة الخانات الشاغرة تلقائياً')}
          enabled={Boolean(mw.enabled)}
          onToggle={v => update('material_workshop' as any, { enabled: v })}
          comingSoon={false}
          badge={
            <span
              style={{
                fontSize: '11px',
                padding: '2px 8px',
                borderRadius: '12px',
                background: selectedMaterials.length > 0 ? 'rgba(var(--theme-primary-rgb),0.15)' : 'rgba(255,255,255,0.06)',
                color: selectedMaterials.length > 0 ? 'var(--theme-primary-light)' : '#9ca3af',
                border: '1px solid rgba(var(--theme-primary-rgb),0.2)',
                fontWeight: 600,
              }}
            >
              {selectedMaterials.length} / {WORKSHOP_MATERIALS.length}
            </span>
          }
        >
          {/* محتوى القائمة القابلة للفتح والغلق (المواد المراد إنتاجها) */}
          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '10px',
              paddingTop: '4px',
            }}
          >
            {/* بار الرأس وزر تحديد الكل */}
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                flexWrap: 'wrap',
                gap: '8px',
                borderBottom: '1px solid rgba(255,255,255,0.06)',
                paddingBottom: '8px',
              }}
            >
              <span style={{ fontSize: '12px', color: '#9ca3af' }}>
                {t('tasks.selectedMaterials', 'المواد المراد إنتاجها وتكريرها')}
              </span>
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation()
                  selectAllMaterials()
                }}
                style={{
                  padding: '3px 8px',
                  fontSize: '11px',
                  borderRadius: '6px',
                  border: '1px solid rgba(var(--theme-primary-rgb),0.3)',
                  background: 'rgba(var(--theme-primary-rgb),0.08)',
                  color: 'var(--theme-primary-light)',
                  cursor: 'pointer',
                }}
              >
                {t('common.selectAll', 'تحديد الكل')}
              </button>
            </div>

            {/* شبكة كروت المواد */}
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(130px, 1fr))',
                gap: '8px',
              }}
            >
              {WORKSHOP_MATERIALS.map(mat => {
                const selected = selectedMaterials.includes(mat.id)
                return (
                  <button
                    key={mat.id}
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation()
                      if (!mw.enabled) update('material_workshop' as any, { enabled: true })
                      toggleMaterial(mat.id)
                    }}
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      padding: '10px 8px',
                      borderRadius: '10px',
                      border: selected
                        ? '1.5px solid rgba(var(--theme-primary-rgb),0.6)'
                        : '1px solid rgba(255,255,255,0.08)',
                      background: selected
                        ? 'rgba(var(--theme-primary-rgb),0.12)'
                        : 'rgba(255,255,255,0.03)',
                      cursor: 'pointer',
                      transition: 'all 0.15s ease',
                      position: 'relative',
                    }}
                  >
                    {/* أيقونة المادة */}
                    <img
                      src={mat.img}
                      alt={t(mat.labelKey)}
                      style={{
                        width: '36px',
                        height: '36px',
                        objectFit: 'contain',
                        filter: selected ? 'none' : 'grayscale(30%) opacity(0.85)',
                      }}
                      onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                    />

                    {/* اسم المادة */}
                    <span
                      style={{
                        fontSize: '11px',
                        fontWeight: selected ? 600 : 400,
                        color: selected ? 'var(--theme-primary-light)' : '#9ca3af',
                        textAlign: 'center',
                        lineHeight: '1.2',
                      }}
                    >
                      {t(mat.labelKey)}
                    </span>

                    {/* شارة التحديد */}
                    {selected && (
                      <div
                        style={{
                          position: 'absolute',
                          top: '4px',
                          right: '4px',
                          width: '14px',
                          height: '14px',
                          borderRadius: '50%',
                          background: 'var(--theme-primary)',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          color: '#fff',
                          fontSize: '9px',
                          fontWeight: 'bold',
                        }}
                      >
                        ✓
                      </div>
                    )}
                  </button>
                )
              })}
            </div>
          </div>
        </TaskRow>

        {/* طاقة القلعة (Stamina Management) */}
        {(() => {
          const rawStamina = (cfg.stamina || {}) as Partial<StaminaConfig>
          const staminaCfg = {
            enabled: Boolean(rawStamina.enabled),
            gold_buy_enabled: Boolean(rawStamina.gold_buy_enabled),
            gold_trigger_stamina: typeof rawStamina.gold_trigger_stamina === 'number' ? rawStamina.gold_trigger_stamina : 50,
            gold_buy_stamina_amount: typeof rawStamina.gold_buy_stamina_amount === 'number' ? rawStamina.gold_buy_stamina_amount : 50,
          }

          return (
            <TaskRow
              id="stamina"
              img="/images/daily/dayaniklilik_2.png"
              label={t('tasks.stamina.title', 'طاقة القلعة')}
              description={t('tasks.stamina.desc', 'استخدام كافة حزم الطاقة المجانية المتوفرة بالحقيبة')}
              enabled={staminaCfg.enabled}
              onToggle={toggle('stamina')}
              comingSoon={false}
            >
              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '4px' }}>
                {/* خيار الشراء بالذهب عند نفاذ الحزم المجانية */}
                <div style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '8px',
                  padding: '6px 10px',
                  background: staminaCfg.gold_buy_enabled ? 'rgba(234, 179, 8, 0.08)' : 'rgba(255,255,255,0.03)',
                  border: staminaCfg.gold_buy_enabled ? '1px solid rgba(234, 179, 8, 0.25)' : '1px solid rgba(255,255,255,0.06)',
                  borderRadius: '8px',
                  transition: 'all 0.15s ease',
                }}>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '10px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <img
                        src="/images/fountain/gold.png"
                        alt=""
                        style={{
                          width: '18px',
                          height: '18px',
                          objectFit: 'contain',
                          filter: staminaCfg.gold_buy_enabled ? 'drop-shadow(0 0 4px rgba(234, 179, 8, 0.6))' : 'grayscale(70%) opacity(0.6)',
                        }}
                        onError={e => { (e.target as HTMLImageElement).style.display = 'none' }}
                      />
                      <span style={{
                        fontSize: '12px',
                        fontWeight: 600,
                        color: staminaCfg.gold_buy_enabled ? '#fbbf24' : '#e2e8f0',
                      }}>
                        {t('tasks.stamina.goldBuyEnabledLabel', 'السماح بالشراء بالذهب عند نفاذ الحزم المجانية')}
                      </span>
                    </div>
                    <Toggle
                      value={staminaCfg.gold_buy_enabled}
                      onChange={v => update('stamina', { gold_buy_enabled: v })}
                      size="sm"
                    />
                  </div>

                  {staminaCfg.gold_buy_enabled && (
                    <div style={{
                      display: 'flex',
                      flexDirection: 'column',
                      gap: '8px',
                      paddingTop: '6px',
                      borderTop: '1px solid rgba(234, 179, 8, 0.12)',
                    }}>
                      {/* سقف الطاقة لتفعيل الشراء بالذهب */}
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
                        <span style={{ fontSize: '11px', color: '#fde68a', fontWeight: 500 }}>
                          {t('tasks.stamina.goldTriggerStaminaLabel', 'سقف الطاقة لتفعيل الشراء بالذهب')}
                        </span>
                        <Stepper
                          value={staminaCfg.gold_trigger_stamina}
                          min={10}
                          max={200}
                          step={10}
                          onChange={v => update('stamina', { gold_trigger_stamina: v })}
                        />
                      </div>

                      {/* كمية الطاقة للشراء في المرة الواحدة */}
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
                        <span style={{ fontSize: '11px', color: '#fde68a', fontWeight: 500 }}>
                          {t('tasks.stamina.goldBuyStaminaAmountLabel', 'كمية الطاقة للشراء في المرة الواحدة')}
                        </span>
                        <Stepper
                          value={staminaCfg.gold_buy_stamina_amount}
                          min={50}
                          max={500}
                          step={50}
                          onChange={v => update('stamina', { gold_buy_stamina_amount: v })}
                        />
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </TaskRow>
          )
        })()}

        {/* الدرع التلقائي (Peace Shield) */}
        <TaskRow
          id="shield"
          img="/images/daily/kalkan.png"
          label={t('tasks.peaceShield')}
          enabled={Boolean(sh.enabled)}
          onToggle={toggle('shield')}
          comingSoon={false}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '2px' }}>
            {/* مدة الدرع - القائمة المنسدلة */}
            <div>
              <select
                value={sh.duration || '8h'}
                className="task-shield-select"
                onChange={e => update('shield', { duration: e.target.value as typeof sh.duration })}
                style={{
                  width: '100%',
                  background: 'rgba(255,255,255,0.06)',
                  border: '1px solid rgba(255,255,255,0.15)',
                  borderRadius: '8px',
                  padding: '6px 10px',
                  fontSize: '12px',
                  color: '#f0fdf4',
                  outline: 'none',
                  cursor: 'pointer',
                  fontFamily: 'inherit',
                }}
              >
                <option value="8h" style={{ background: '#111a11', color: '#f0fdf4' }}>
                  {t('tasks.hours8')}
                </option>
                <option value="24h" style={{ background: '#111a11', color: '#f0fdf4' }}>
                  {t('tasks.hours24')}
                </option>
                <option value="3d" style={{ background: '#111a11', color: '#f0fdf4' }}>
                  {t('tasks.days3')}
                </option>
              </select>
            </div>

            {/* خيار السماح بالشراء بالذهب (allow_gold) */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '6px 10px',
              background: sh.allow_gold ? 'rgba(245,158,11,0.08)' : 'rgba(255,255,255,0.03)',
              border: sh.allow_gold ? '1px solid rgba(245,158,11,0.25)' : '1px solid rgba(255,255,255,0.06)',
              borderRadius: '8px',
              transition: 'all 0.15s ease',
            }}>
              <div>
                <div style={{
                  fontSize: '12px',
                  fontWeight: 600,
                  color: sh.allow_gold ? '#fbbf24' : '#e2e8f0',
                }}>
                  {t('tasks.buyWithGold')}
                </div>
              </div>
              <Toggle
                value={Boolean(sh.allow_gold)}
                onChange={v => update('shield', { allow_gold: v })}
                size="sm"
              />
            </div>
          </div>
        </TaskRow>
      </div>
    )
  }

  return null
  }

  const transportHasMissingCoords = Boolean(
  coordsError &&
  cfg.march_manager?.resource_help?.enabled &&
  (!cfg.march_manager.resource_help.target_x || cfg.march_manager.resource_help.target_x <= 0 ||
   !cfg.march_manager.resource_help.target_y || cfg.march_manager.resource_help.target_y <= 0)
)

  return (
    <div className="relative space-y-4 w-full task-tab-content-root">
      <div className="space-y-2.5 w-full">
        <TaskTabs
          active={currentTab}
          onChange={handleTabChange}
          errorTab={transportHasMissingCoords ? 'transport' : null}
        />

        {/* AutoSave Status Row — يظهر حصراً واستثنائياً فقط إذا حدث خطأ في الحفظ */}
        {!isBatchMode && saveStatus === 'error' && (
          <div className="flex justify-end items-center px-1 min-h-[20px] text-xs select-none">
            <span className="inline-flex items-center gap-2 font-medium text-[11px] text-rose-400">
              <span>{t('common.saveFailed', 'فشل الحفظ')}{saveErrorMsg ? `: ${saveErrorMsg}` : ''}</span>
              <button
                type="button"
                onClick={() => performSave()}
                className="font-semibold text-rose-300 hover:text-white underline cursor-pointer"
              >
                {t('common.retry', 'إعادة المحاولة')}
              </button>
            </span>
          </div>
        )}

        {/* Compact Luxury Glowing Single-Row Action Bar for Batch Mode */}
        {isBatchMode && changesCount > 0 && (
          <div className="flex flex-nowrap justify-between items-center gap-2.5 backdrop-blur-md px-3 py-1.5 border rounded-xl w-full text-xs animate-in duration-150 select-none batch-action-bar fade-in">
            {/* Target Accounts Count */}
            <div className="flex items-center gap-2 min-w-0 truncate shrink">
              <span className="bg-primary-500 dark:bg-primary-400 shadow-[0_0_6px_rgba(var(--theme-primary-rgb),0.6)] rounded-full w-2 h-2 shrink-0" />
              <span className="font-medium text-[11px] sm:text-xs whitespace-nowrap batch-count-text">
                <span className="ml-1 font-bold batch-count-num">   {batchTargetCount}   </span>

                {t('accounts.accountUnit', 'حساب')}
              </span>
            </div>

            {/* Actions: Cancel & Elegant Glowing Save Button */}
            <div className="flex items-center gap-1 sm:gap-1.5 shrink-0">
              <button
                type="button"
                disabled={isPending}
                onClick={handleCancel}
                className="px-2.5 py-1 rounded-lg font-medium text-[11px] sm:text-xs whitespace-nowrap active:scale-95 transition-colors cursor-pointer batch-cancel-btn"
              >
                {t('common.cancel', 'إلغاء')}
              </button>

              <button
                type="button"
                disabled={isPending || batchTargetCount === 0}
                onClick={handleSave}
                className={clsx(
                  'flex items-center gap-1.5 px-3 py-1 rounded-lg font-semibold text-[11px] sm:text-xs whitespace-nowrap active:scale-95 transition-all duration-150 batch-lux-btn',
                  !isPending && batchTargetCount > 0
                    ? 'bg-primary-600 hover:bg-primary-500 text-white cursor-pointer shadow-sm border border-primary-500 dark:border-primary-400/30'
                    : 'bg-gray-100 dark:bg-white/10 text-gray-400 dark:text-gray-500 cursor-not-allowed opacity-60'
                )}
              >
                {isPending ? (
                  <Loader2 size={12} className="text-white animate-spin shrink-0" />
                ) : (
                  <Check size={12} className="stroke-[2.5] text-white shrink-0" />
                )}
                <span>
                  {t('common.save', 'حفظ')} ({changesCount})
                </span>
              </button>
            </div>
          </div>
        )}
      </div>



      <TaskAccordionContext.Provider value={{ expandedTaskId, toggleTask: toggleTaskAccordion }}>
        {renderTabContent()}
      </TaskAccordionContext.Provider>
    </div>
  )
}

export const TaskTabContent = React.memo(TaskTabContentInner)

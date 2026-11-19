import React, { useState, useRef, useEffect } from 'react'
import { clsx } from 'clsx'
import { useTranslation } from 'react-i18next'
import { Globe, ChevronDown, Check } from 'lucide-react'
import { useAppStore } from '../../store/appStore'
import type { Language } from '../../types'

export interface LanguageOption {
  code: Language
  label: string
  short: string
  flag: string
}

export const LANGUAGES: LanguageOption[] = [
  { code: 'ar', label: 'العربية', short: 'AR', flag: '🇸🇦' },
  { code: 'en', label: 'English', short: 'EN', flag: '🇬🇧' },
  { code: 'tr', label: 'Türkçe',  short: 'TR', flag: '🇹🇷' },
]

interface LanguageDropdownProps {
  placement?: 'top' | 'bottom'
  variant?: 'compact' | 'full'
  className?: string
}

export function LanguageDropdown({
  placement = 'bottom',
  variant = 'compact',
  className,
}: LanguageDropdownProps) {
  const { i18n } = useTranslation()
  const { language, setLanguage } = useAppStore()
  const [isOpen, setIsOpen] = useState(false)
  const dropdownRef = useRef<HTMLDivElement>(null)

  // اللغة المحددة حالياً
  const currentLang = LANGUAGES.find((l) => l.code === language) || LANGUAGES[0]

  const handleSelect = (langCode: Language) => {
    setLanguage(langCode)
    i18n.changeLanguage(langCode)
    document.documentElement.dir = 'ltr'
    document.documentElement.lang = langCode
    setIsOpen(false)
  }

  // إغلاق القائمة عند النقر خارجها أو الضغط على Escape
  useEffect(() => {
    if (!isOpen) return
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        setIsOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    document.addEventListener('keydown', handleKeyDown)
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
      document.removeEventListener('keydown', handleKeyDown)
    }
  }, [isOpen])

  return (
    <div ref={dropdownRef} className={clsx('relative inline-block text-start', className)}>
      {/* زر القائمة المنسدلة الرئيسي */}
      <button
        type="button"
        onClick={() => setIsOpen((prev) => !prev)}
        aria-haspopup="listbox"
        aria-expanded={isOpen}
        className={clsx(
          'flex items-center gap-1.5 rounded-lg border transition-all duration-150 cursor-pointer select-none',
          variant === 'compact'
            ? 'px-2 py-1 text-xs font-medium'
            : 'w-full px-2.5 py-1.5 text-xs font-medium justify-between',
          isOpen
            ? 'bg-gray-200 dark:bg-white/12 border-primary-500/50 text-gray-900 dark:text-white shadow-xs'
            : 'bg-gray-100 hover:bg-gray-200/80 dark:bg-white/6 dark:hover:bg-white/10 border-gray-200 dark:border-white/10 text-gray-700 dark:text-gray-300'
        )}
      >
        <div className="flex items-center gap-1.5 min-w-0">
          <Globe size={13} className="shrink-0 text-primary-600 dark:text-primary-400 opacity-90" />
          <span className="shrink-0 text-xs leading-none">{currentLang.flag}</span>
          <span className="font-semibold text-[11px] sm:text-xs">
            {variant === 'compact' ? currentLang.short : currentLang.label}
          </span>
        </div>
        <ChevronDown
          size={12}
          className={clsx(
            'shrink-0 text-gray-400 transition-transform duration-200',
            isOpen && 'rotate-180 text-primary-500'
          )}
        />
      </button>

      {/* خيارات القائمة المنسدلة */}
      {isOpen && (
        <div
          role="listbox"
          className={clsx(
            'absolute z-50 min-w-[135px] py-1 bg-white dark:bg-[#121915] border border-gray-200 dark:border-white/12 rounded-xl shadow-xl backdrop-blur-xl animate-in fade-in-50 zoom-in-95 duration-100 select-none',
            placement === 'top'
              ? 'bottom-full mb-1.5 end-0'
              : 'top-full mt-1.5 end-0'
          )}
        >
          {LANGUAGES.map((lang) => {
            const isSelected = lang.code === currentLang.code
            return (
              <button
                key={lang.code}
                type="button"
                role="option"
                aria-selected={isSelected}
                onClick={() => handleSelect(lang.code)}
                className={clsx(
                  'w-full flex items-center justify-between gap-2.5 px-3 py-1.5 text-xs transition-colors cursor-pointer text-start',
                  isSelected
                    ? 'bg-primary-500/12 text-primary-600 dark:text-primary-400 font-semibold'
                    : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-white/8 hover:text-gray-900 dark:hover:text-white'
                )}
              >
                <div className="flex items-center gap-2 min-w-0">
                  <span className="text-xs shrink-0 leading-none">{lang.flag}</span>
                  <span className="truncate">{lang.label}</span>
                </div>
                {isSelected && (
                  <Check size={13} className="shrink-0 text-primary-600 dark:text-primary-400" />
                )}
              </button>
            )
          })}
        </div>
      )}
    </div>
  )
}

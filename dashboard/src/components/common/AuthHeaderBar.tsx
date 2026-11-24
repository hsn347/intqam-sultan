import React from 'react'
import { useTranslation } from 'react-i18next'
import { Sun, Moon } from 'lucide-react'
import { useAppStore } from '../../store/appStore'
import { LanguageDropdown } from './LanguageDropdown'

export function AuthHeaderBar() {
  const { t } = useTranslation()
  const { theme, setTheme } = useAppStore()

  const toggleTheme = () => {
    setTheme(theme === 'dark' ? 'light' : 'dark')
  }

  return (
    <div className="top-4 z-20 absolute flex justify-between items-center pointer-events-auto start-4 end-4">
      <div />
      {/* Language & Theme Controls */}
      <div className="flex items-center gap-1.5 bg-white dark:bg-[#0c120f] shadow-xs p-1 border border-gray-200/80 dark:border-white/10 rounded-xl">
        {/* Language selector */}
        <LanguageDropdown placement="bottom" variant="compact" />

        {/* Theme toggle button */}
        <button
          type="button"
          onClick={toggleTheme}
          className="bg-gray-100 dark:bg-white/6 p-1.5 border border-gray-200/60 dark:border-white/5 rounded-lg text-gray-500 dark:text-gray-400 cursor-pointer"
          title={theme === 'dark' ? t('common.lightMode', 'الوضع النهاري') : t('common.darkMode', 'الوضع الليلي')}
        >
          {theme === 'dark' ? (
            <Sun size={15} className="text-amber-400" />
          ) : (
            <Moon size={15} className="text-emerald-600" />
          )}
        </button>
      </div>
    </div>
  )
}

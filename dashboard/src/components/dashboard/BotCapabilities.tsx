import React from 'react'
import { useTranslation } from 'react-i18next'

// قائمة تعريفية ثابتة بكل المهام التي يستطيع البوت تنفيذها (لا تعتمد على أي استعلام شبكي)
const CATEGORIES: { id: string; icon: string; items: { key: string; icon: string }[] }[] = [
  {
    id: 'eco',
    icon: '💰',
    items: [
      { key: 'city_harvest', icon: '🌾' },
      { key: 'watermill', icon: '🌱' },
      { key: 'port', icon: '⚓' },
      { key: 'merchant_ship', icon: '🚢' },
      { key: 'treasure', icon: '🎰' },
      { key: 'wonder_merchant', icon: '👳' },
      { key: 'war_medal', icon: '🎖️' },
      { key: 'stamina', icon: '⚡' },
    ],
  },
  {
    id: 'build',
    icon: '🏗️',
    items: [
      { key: 'building', icon: '🏰' },
      { key: 'research', icon: '🔬' },
      { key: 'material_synthesis', icon: '💎' },
      { key: 'material_workshop', icon: '🧵' },
      { key: 'forge_equipment', icon: '🔨' },
    ],
  },
  {
    id: 'military',
    icon: '🛡️',
    items: [
      { key: 'train', icon: '⚔️' },
      { key: 'daily_train', icon: '🪖' },
      { key: 'cure_wounded', icon: '🏥' },
      { key: 'shield', icon: '🛡️' },
      { key: 'skills', icon: '✨' },
      { key: 'pet', icon: '🦅' },
    ],
  },
  {
    id: 'marches',
    icon: '🗺️',
    items: [
      { key: 'march_manager', icon: '🧭' },
      { key: 'hunt_monsters', icon: '👹' },
      { key: 'gather_resources', icon: '🧺' },
      { key: 'explore_ruins', icon: '🏺' },
      { key: 'escort_treasure', icon: '📦' },
      { key: 'resource_help', icon: '🚚' },
      { key: 'gather_speed_buff', icon: '⏫' },
    ],
  },
  {
    id: 'compete',
    icon: '🏆',
    items: [
      { key: 'arena', icon: '🏟️' },
      { key: 'hero_trial', icon: '🗡️' },
      { key: 'command_hall', icon: '🏛️' },
      { key: 'imperial_mausoleum', icon: '🔺' },
      { key: 'alliance', icon: '🤝' },
    ],
  },
  {
    id: 'daily',
    icon: '📋',
    items: [
      { key: 'daily_quest', icon: '📋' },
      { key: 'flower', icon: '🌸' },
    ],
  },
]

const TOTAL_TASKS = CATEGORIES.reduce((n, c) => n + c.items.length, 0)

export function BotCapabilities() {
  const { t } = useTranslation()

  return (
    <details open className="group glass-card overflow-hidden">
      <summary className="flex justify-between items-center gap-2 px-3.5 sm:px-5 py-3 sm:py-3.5 cursor-pointer list-none select-none">
        <div className="min-w-0">
          <div className="flex items-center gap-2">
            <h2 className="font-semibold text-sm sm:text-base brand-title">{t('dashboard.capabilities.title')}</h2>
            <span className="bg-primary-500/15 px-2 py-0.5 border border-primary-500/30 rounded-full font-bold text-[10px] text-primary-700 dark:text-primary-300">
              {TOTAL_TASKS}
            </span>
          </div>
          <p className="mt-0.5 text-[11px] text-gray-500 sm:text-xs">{t('dashboard.capabilities.subtitle')}</p>
        </div>
        <span className="text-gray-400 text-xs transition-transform group-open:rotate-180">▼</span>
      </summary>

      <div className="space-y-4 px-3.5 sm:px-5 pt-3 pb-4 border-gray-100 dark:border-white/8 border-t">
        {CATEGORIES.map(cat => (
          <section key={cat.id}>
            <h3 className="flex items-center gap-1.5 mb-2 font-bold text-gray-700 dark:text-gray-200 text-xs sm:text-sm">
              <span>{cat.icon}</span>
              {t(`dashboard.capabilities.categories.${cat.id}`)}
              <span className="font-medium text-[10px] text-gray-400">({cat.items.length})</span>
            </h3>
            <div className="gap-2 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
              {cat.items.map(item => (
                <div
                  key={item.key}
                  className="flex items-start gap-2.5 bg-gray-50 dark:bg-white/4 px-2.5 py-2 border border-gray-100 dark:border-white/8 rounded-xl"
                >
                  <span className="text-lg leading-none shrink-0">{item.icon}</span>
                  <div className="min-w-0">
                    <div className="font-semibold text-gray-900 dark:text-white text-xs sm:text-[13px] truncate">
                      {t(`dashboard.capabilities.items.${item.key}.n`)}
                    </div>
                    <div className="mt-0.5 text-[11px] text-gray-500 dark:text-gray-400 leading-snug">
                      {t(`dashboard.capabilities.items.${item.key}.d`)}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>
    </details>
  )
}

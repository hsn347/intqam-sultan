import React from 'react'
import { useTranslation } from 'react-i18next'

// قائمة تعريفية ثابتة بكل المهام التي يستطيع البوت تنفيذها بأيقونات ومسميات اللعبة الرسمية
const CATEGORIES: { id: string; img: string; items: { key: string; img: string }[] }[] = [
  {
    id: 'eco',
    img: '/images/resources/altin.png',
    items: [
      { key: 'city_harvest', img: '/images/development/hasatet.png' },
      { key: 'watermill', img: '/images/watermill/uretimbonusust.png' },
      { key: 'port', img: '/images/daily/port.png' },
      { key: 'merchant_ship', img: '/images/daily/merchant_ship.png' },
      { key: 'treasure', img: '/images/fountain/fountain.png' },
      { key: 'wonder_merchant', img: '/images/prestige/kacakci.png' },
      { key: 'war_medal', img: '/images/daily/war_medal.png' },
      { key: 'stamina', img: '/images/daily/dayaniklilik_2.png' },
    ],
  },
  {
    id: 'build',
    img: '/images/development/icon_building_levelup.png',
    items: [
      { key: 'building', img: '/images/development/insaat.png' },
      { key: 'research', img: '/images/development/icon_building_research.png' },
      { key: 'material_synthesis', img: '/images/daily/material_synthesis.png' },
      { key: 'material_workshop', img: '/images/daily/malzeme_atolyesi.png' },
      { key: 'forge_equipment', img: '/images/daily/forge_equipment.png' },
    ],
  },
  {
    id: 'military',
    img: '/images/soldiers/icon_building_training_finish.png',
    items: [
      { key: 'train', img: '/images/soldiers/icon_building_training_finish.png' },
      { key: 'daily_train', img: '/images/soldiers/icon_train_army.png' },
      { key: 'cure_wounded', img: '/images/daily/cure_wounded.png' },
      { key: 'shield', img: '/images/development/peace_shield.png' },
      { key: 'skills', img: '/images/skills/lord/Develop_8.png' },
      { key: 'pet', img: '/images/daily/pet.png' },
    ],
  },
  {
    id: 'marches',
    img: '/images/combat/icon_map_attack.png',
    items: [
      { key: 'march_manager', img: '/images/combat/icon_fight_expedition.png' },
      { key: 'hunt_monsters', img: '/images/combat/monster_all.png' },
      { key: 'gather_resources', img: '/images/gather/icon_map_mineral_collect.png' },
      { key: 'explore_ruins', img: '/images/combat/kesif.png' },
      { key: 'escort_treasure', img: '/images/daily/ganimetkaravani.png' },
      { key: 'resource_help', img: '/images/transport/transport.png' },
      { key: 'gather_speed_buff', img: '/images/gather/gather_speed_buff.png' },
    ],
  },
  {
    id: 'compete',
    img: '/images/daily/icon_build_121.png',
    items: [
      { key: 'arena', img: '/images/daily/icon_build_121.png' },
      { key: 'hero_trial', img: '/images/daily/hero_trial.png' },
      { key: 'command_hall', img: '/images/daily/command_hall.png' },
      { key: 'imperial_mausoleum', img: '/images/daily/pyramid.png' },
      { key: 'alliance', img: '/images/daily/lonca.png' },
    ],
  },
  {
    id: 'daily',
    img: '/images/daily/quest_button.png',
    items: [
      { key: 'daily_quest', img: '/images/daily/quest_button.png' },
      { key: 'flower', img: '/images/daily/flower.png' },
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
            <h3 className="flex items-center gap-2 mb-2 font-bold text-gray-700 dark:text-gray-200 text-xs sm:text-sm">
              <img
                src={cat.img}
                alt={t(`dashboard.capabilities.categories.${cat.id}`)}
                loading="lazy"
                className="w-5 h-5 object-contain shrink-0 select-none"
              />
              {t(`dashboard.capabilities.categories.${cat.id}`)}
              <span className="font-medium text-[10px] text-gray-400">({cat.items.length})</span>
            </h3>
            <div className="gap-2 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
              {cat.items.map(item => {
                const title = t(`dashboard.capabilities.items.${item.key}.n`)
                return (
                  <div
                    key={item.key}
                    className="flex items-center gap-2.5 bg-gray-50 dark:bg-white/4 px-2.5 py-2 border border-gray-100 dark:border-white/8 rounded-xl"
                  >
                    <img
                      src={item.img}
                      alt={title}
                      loading="lazy"
                      className="w-7 h-7 object-contain shrink-0 select-none"
                    />
                    <div className="min-w-0">
                      <div className="font-semibold text-gray-900 dark:text-white text-xs sm:text-[13px] truncate">
                        {title}
                      </div>
                      <div className="mt-0.5 text-[11px] text-gray-500 dark:text-gray-400 leading-snug">
                        {t(`dashboard.capabilities.items.${item.key}.d`)}
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          </section>
        ))}
      </div>
    </details>
  )
}

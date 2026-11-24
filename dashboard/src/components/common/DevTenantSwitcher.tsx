import React from 'react'
import { useTranslation } from 'react-i18next'
import { MERCHANTS_CONFIG, DEFAULT_TENANT } from '../../config/tenants'
import { useTenant } from '../../context/TenantContext'

/**
 * شريط تجربة النطاقات والتجار محلياً (يظهر فقط أثناء التطوير على localhost)
 * يتيح لك التبديل بضغطة زر وتجربة هوية أي تاجر في ثانية واحدة
 */
export function DevTenantSwitcher() {
  const { t } = useTranslation()
  if (typeof window === 'undefined') return null
  const isLocal =
    window.location.hostname === 'localhost' ||
    window.location.hostname === '127.0.0.1' ||
    window.location.hostname.includes('192.168.')

  if (!isLocal) return null

  const { tenant } = useTenant()

  const handleSelectTenant = (tenantId: string) => {
    localStorage.setItem('dev_selected_tenant', tenantId)
    const url = new URL(window.location.href)
    if (tenantId === 'main') {
      url.searchParams.delete('tenant')
      url.searchParams.delete('domain')
    } else {
      url.searchParams.set('tenant', tenantId)
    }
    window.location.href = url.toString()
  }

  return (
    <div className="hidden bottom-3 z-50 fixed sm:flex items-center gap-1.5 bg-black/90 shadow-lg px-2.5 py-1.5 border border-white/15 rounded-xl font-sans text-white text-xs end-3">
      <span className="hidden sm:inline font-semibold text-[10px] text-gray-400">
        {t('dev.domainIdentityTest', 'تجربة هوية النطاق:')}
      </span>
      <button
        type="button"
        onClick={() => handleSelectTenant('main')}
        className={`px-2 py-0.5 rounded-lg text-xs font-bold cursor-pointer ${
          tenant.id === 'main'
            ? 'bg-emerald-600 text-white shadow-xs'
            : 'text-gray-300'
        }`}
        title={t('dev.mainDomain', 'الدومين الرئيسي (IBRA BOT)')}
      >
        IBRA BOT
      </button>

      {MERCHANTS_CONFIG.map((m) => (
        <button
          key={m.id}
          type="button"
          onClick={() => handleSelectTenant(m.id)}
          className={`px-2 py-0.5 rounded-lg text-xs font-bold cursor-pointer ${
            tenant.id === m.id
              ? 'text-white shadow-xs'
              : 'text-gray-300'
          }`}
          style={tenant.id === m.id ? { backgroundColor: m.primaryColor } : {}}
          title={t('dev.merchantDomainTest', { domains: m.domains.join(', '), defaultValue: `تجربة دومين التاجر: ${m.domains.join(', ')}` })}
        >
          {m.brandName}
        </button>
      ))}
    </div>
  )
}

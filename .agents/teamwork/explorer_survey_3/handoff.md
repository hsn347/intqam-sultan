# تقرير تسليم الاستكشاف: الواجهة الأمامية، الأنواع، الحفظ المزدوج، والترجمة الثلاثية
# Explorer 3 Handoff Report: Frontend UI, Types, Dual-Save & Localization

**تاريخ الإعداد**: 2026-10-31T11:35:30Z  
**المستكشف**: Explorer 3 (Frontend UI, Types, Dual-Save & Localization Explorer)  
**المجلد**: `e:\intqam-sultan\.agents\teamwork\explorer_survey_3\`  
**المرجع الأساسي**: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md`  
**الخطة المعتمدة**: `C:\Users\Computer Home\.gemini\antigravity\brain\c9dda83e-09db-4998-9bd3-36c6eb6ad6d0\forge_equipment_plan.md`  

---

## 1. Observation (الملاحظات المباشرة المدعومة بالأدلة)

### أ. ملف الأنواع وقيم التهيئة (`dashboard/src/types/index.ts`)
- **تعريف واجهة `CastleConfig` (الأسطر 120-165)**:
  المهام اليومية تُعرَّف كحقول مشتقة من `BaseTaskConfig`:
  - السطر 84-86:
    ```typescript
    export interface BaseTaskConfig {
      enabled: boolean
    }
    ```
  - الأسطر 134-144:
    ```typescript
    material_synthesis?: BaseTaskConfig
    cure_wounded?: BaseTaskConfig & { mode: 'daily' | 'all' }
    stamina: BaseTaskConfig & { gold_buys: number }
    hero_draw: BaseTaskConfig
    treasure_pavilion: BaseTaskConfig
    blacksmith_forge: BaseTaskConfig
    imperial_mausoleum: BaseTaskConfig
    ```
- **الإعداد الافتراضي للقلاع `DEFAULT_CASTLE_CONFIG` (الأسطر 188-255)**:
  - السطر 203: `material_synthesis: { enabled: false },`
  - السطر 204: `cure_wounded: { enabled: false, mode: 'daily' },`
  - السطر 209: `blacksmith_forge: { enabled: false },`
- **الإعداد الثابت المسبق `FIXED_PRESET_CONFIG` (الأسطر 257-336)**:
  - السطر 306: `material_synthesis: { enabled: false },`
  - السطر 307: `cure_wounded: { enabled: false, mode: 'daily' },`
  - السطر 311: `blacksmith_forge: { enabled: true },`

### ب. دمج الإعدادات بالهوك (`dashboard/src/hooks/useCastles.ts`)
- **دالة `mergeCastleConfig(fcConfig)` (الأسطر 12-106)**:
  تقوم بعمل Deep merge للإعدادات الواردة من السيرفر (`fc`) مع القيم الافتراضية (`def`).
  - السطور 80-87:
    ```typescript
    material_synthesis: { ...(def.material_synthesis || { enabled: false }), ...((fc.material_synthesis as Record<string, unknown>) || {}) },
    cure_wounded:       { ...(def.cure_wounded || { enabled: false, mode: 'daily' }), ...((fc.cure_wounded as Record<string, unknown>) || {}) },
    blacksmith_forge:   { ...def.blacksmith_forge,   ...((fc.blacksmith_forge   as Record<string, unknown>) || {}) },
    ```

### ج. مكون التحكم بالمهام ومسار الحفظ الثنائي (`dashboard/src/components/accounts/TaskTabContent.tsx`)
- **مكون `TaskRow` (الأسطر 248-420)**:
  - السطر 249: خاصية `comingSoon = true` افتراضياً! **ملاحظة حرجة**: أي مهمة نشطة يجب تمرير `comingSoon={false}` لها صراحة وإلا ستظهر معطلة كـ "قريباً".
  - السطر 258-259: `hasOptions = Boolean(children)`. إذا تم تمرير عناصر فرعية (`children`)، يظهر سهم الأكورديون ويتحول السطر لقائمة منسدلة قابلة للفتح والغلق.
- **دالة الحفظ التلقائي `performSave()` (الأسطر 672-723)**:
  - الأسطر 684-708:
    ```typescript
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
      } as any)
    ```
- **دالة الحفظ اليدوي `handleSave()` (الأسطر 885-965)**:
  - الأسطر 924-945:
    ```typescript
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
    }
    ```
- **قسم المهام اليومية (الأسطر 1506-2274: `if (tab === 'daily')`)**:
  - يحتوي على المهام اليومية: `caravan`, `hero_draw`, `alliance`, `pet`, `stamina`, `savings_bank`, `warrior_exchange`, `tactics_hall`, `fountain`, `material_workshop`, `shield`, `flower`, `wonder_merchant`, `material_synthesis`, `cure_wounded`.
  - الأسطر 2208-2216 تُعرّف `material_synthesis` (تجميع المواد)، وهو الموضع المثالي لإدراج مهمة `forge_equipment` (تصنيع العتاد) بعده مباشرة.

### د. أصول الصور والأيقونات (Assets)
تم فحص الملفات برمجياً بالكامل:
- `dashboard/public/images/daily/forge_equipment.png` (الحجم: 9736 بايت - موجود وسليم).
- أيقونات الأصناف الستة في `dashboard/public/images/daily/equip/`:
  - `weapon.png` (5221 بايت)
  - `clothes.png` (9576 بايت)
  - `helmet.png` (9539 بايت)
  - `trousers.png` (8492 بايت)
  - `shoes.png` (8160 بايت)
  - `ring.png` (6358 بايت)
- مجلد الإنتاج `dashboard/dist/images/daily/` ومجلده الفرعي `equip/` يحتويان على نسخ مطابقة 100% بنفس الأحجام.

### هـ. الترجمة الثلاثية (Localization Files)
- الملفات:
  - `dashboard/src/locales/ar.json` (يحتوي حالياً على 224 مفتاح مهام تحت `tasks`).
  - `dashboard/src/locales/en.json` (يحتوي حالياً على 224 مفتاح مهام تحت `tasks`).
  - `dashboard/src/locales/tr.json` (يحتوي حالياً على 211 مفتاح مهام تحت `tasks`).
- تم التأكد من أن مفاتيح `forge_equipment` و `forgeEquipment` غير موجودة بعد في أي من الملفات الثلاثة.
- لوحظ أن المهام المضافة حديثاً في المشروع تعتمد النمط المزدوج للمفتاح (snake_case و camelCase مثل `material_synthesis` و `materialSynthesis`).

### و. أمر البناء وفحص الأنواع (Build Verification)
- في `dashboard/package.json`:
  ```json
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  }
  ```
- تم تشغيل `npm run build` في مجلد `dashboard`:
  - النتيجة: انتهى بكود الخروج `0` خلال 1.49 ثانية.
  - لا توجد أي أخطاء فحص أنواع (TypeScript) أو أخطاء بناء.

---

## 2. Logic Chain (سلسلة الاستدلال المنطقي)

1. **الأنواع وقاعدة البيانات والـ API**:
   - بناءً على الملاحظة (أ)، واجهة `CastleConfig` تمثل العقد الموحد بين الباك إند والواجهة.
   - إضافة `forge_equipment?: BaseTaskConfig & { category: EquipmentCategory }` تضمن تطابق الأنواع في TypeScript، وتمنع أخطاء `tsc` أثناء البناء.
   - تعريف `type EquipmentCategory = 'weapon' | 'clothes' | 'helmet' | 'trousers' | 'shoes' | 'ring'` يمنع إدخال قيم عشوائية خارج الأصناف الستة المدعومة في اللعبة.
   - تهيئة الحقل في `DEFAULT_CASTLE_CONFIG` و `FIXED_PRESET_CONFIG` بالقيمة `{"enabled": false, "category": "weapon"}` يضمن أن أي قلعة جديدة أو عملية ضبط تلقائي تحتوي على الكائن كاملاً دون حدوث أخطاء `undefined`.

2. **هوك الدمج `useCastles.ts`**:
   - بناءً على الملاحظة (ب)، عند استرجاع القلاع من السيرفر، يتم استدعاء `mergeCastleConfig`.
   - إضافة دمج `forge_equipment` يحمي الواجهة من الانهيار إذا ورد سجل قلعة قديمة لم يتم ترحيلها بعد أو بدون حقل `category`.

3. **بروتوكول الحفظ الثنائي (Dual-Save Audit)**:
   - بناءً على الملاحظة (ج) وقواعد الدستور في `GEMINI.md` (البندين 3 و 5):
     - الحفظ التلقائي يتم عبر `performSave()`.
     - الحفظ اليدوي يتم عبر `handleSave()`.
   - كود الواجهة في `TaskTabContent.tsx` يعتمد على قائمة بيضاء صريحة (Explicit Whitelist payload) في كلتا الدالتين (وليس تمرير `draftConfig` بالكامل لحماية الشبكة من الطلبات الضخمة غير الضرورية).
   - وبالتالي: **عدم إضافة `forge_equipment` إلى كلتا الدالتين سيتسبب مباشرة في فشل حفظ التعديلات وإلغائها فور تحديث الصفحة**.
   - إضافة `forgeEquipmentDraft` في `performSave()` و `forgeEquipmentConfig` في `handleSave()` تحقق الامتثال الصارم لبروتوكول الحفظ الثنائي.

4. **عنصر التحكم وتجربة المستخدم (UI/UX - Rule 11)**:
   - بناءً على الملاحظة (ج)، `TaskRow` هو المكون المعتمد في كامل الصفحة.
   - تمرير `comingSoon={false}` إلزامي لضمان تفعيل الزر.
   - تصميم محدد الأصناف الستة كشبكة أيقونات أفقية متجاوبة (`grid grid-cols-3 sm:grid-cols-6 gap-1.5`) يتيح اختيار الصنف بنقرة واحدة سريعة دون أي قوائم منسدلة معقدة، متوافقاً تماماً مع فلسفة البساطة (KISS) والسرعة الفائقة.
   - اختيار السلاح `weapon` كصنف افتراضي يحقق أعلى فائدة للمستخدم.

5. **الترجمة الثلاثية الإلزامية (Rule 10)**:
   - بناءً على الملاحظة (هـ)، منع النصوص الثابتة وتوفير الترجمات باللغات الثلاث (العربية، الإنجليزية، التركية) بالتزامن يمنع أي عيوب بصرية للمستخدمين متعددي اللغات.
   - إضافة المفتاحين `forgeEquipment` و `forge_equipment` يمنع أي خلل عند الوصول للمفتاح عبر المعرف البرمجي المباشر.

---

## 3. Caveats (الافتراضات والحدود)

- **لا تعديل استباقي للأكواد**: التزاماً بالبند 8 في `GEMINI.md` وبصفتنا مستكشفين (Explorer - Read-only)، لم يتم تعديل أي ملف في كود المشروع الفعلي.
- **تزامن Vite للأصول**: عند تشغيل `npm run build`، يقوم Vite بنسخ محتويات مجلد `dashboard/public/` تلقائياً إلى `dashboard/dist/`. وبما أن الأصول موجودة في المجلدين بالفعل، فلن يطرأ أي فقدان للأيقونات أثناء البناء أو النشر.
- **الخيار الافتراضي للصنف**: تم اعتماد `weapon` (السلاح) كخيار افتراضي متوافقاً مع الخطة المعتمدة في `forge_equipment_plan.md` و `DEFAULT_BOT_CONFIG`.

---

## 4. Conclusion & Proposed Code Implementation (الخلاصة والحل البرمجي المقترح)

الواجهة الأمامية جاهزة تماماً للربط والتنفيذ السلس عبر التعديلات المحددة التالية:

### الخطوة 1: تحديث `dashboard/src/types/index.ts`
```typescript
// أ. إضافة نوع الأصناف الستة ونوع المهمة:
export type EquipmentCategory = 'weapon' | 'clothes' | 'helmet' | 'trousers' | 'shoes' | 'ring'

export interface ForgeEquipmentConfig extends BaseTaskConfig {
  category: EquipmentCategory
}

// ب. إضافة الحقل في واجهة CastleConfig (نحو السطر 144):
forge_equipment?: BaseTaskConfig & { category: EquipmentCategory }

// ج. إضافة القيمة الافتراضية في DEFAULT_CASTLE_CONFIG (نحو السطر 212):
forge_equipment: { enabled: false, category: 'weapon' },

// د. إضافة القيمة في FIXED_PRESET_CONFIG (نحو السطر 313):
forge_equipment: { enabled: false, category: 'weapon' },
```

### الخطوة 2: تحديث `dashboard/src/hooks/useCastles.ts`
داخل دالة `mergeCastleConfig` (نحو السطر 90):
```typescript
forge_equipment: {
  ...(def.forge_equipment || { enabled: false, category: 'weapon' }),
  ...((fc.forge_equipment as Record<string, unknown>) || {}),
  category: ['weapon', 'clothes', 'helmet', 'trousers', 'shoes', 'ring'].includes((fc.forge_equipment as { category?: string })?.category as string)
    ? ((fc.forge_equipment as { category?: string }).category as 'weapon' | 'clothes' | 'helmet' | 'trousers' | 'shoes' | 'ring')
    : 'weapon',
},
```

### الخطوة 3: تحديث `dashboard/src/components/accounts/TaskTabContent.tsx`

1. **إضافة مصفوفة الأصناف الستة** في أعلى الملف مع الثوابت الأخرى (نحو السطر 550):
```typescript
export const EQUIPMENT_CATEGORIES = [
  { key: 'weapon',   labelKey: 'tasks.equipWeapon',   img: '/images/daily/equip/weapon.png' },
  { key: 'clothes',  labelKey: 'tasks.equipClothes',  img: '/images/daily/equip/clothes.png' },
  { key: 'helmet',   labelKey: 'tasks.equipHelmet',   img: '/images/daily/equip/helmet.png' },
  { key: 'trousers', labelKey: 'tasks.equipTrousers', img: '/images/daily/equip/trousers.png' },
  { key: 'shoes',    labelKey: 'tasks.equipShoes',    img: '/images/daily/equip/shoes.png' },
  { key: 'ring',     labelKey: 'tasks.equipRing',     img: '/images/daily/equip/ring.png' },
] as const
```

2. **تحديث دالة `performSave()`** (نحو السطر 694):
```typescript
const forgeEquipmentDraft = (currentDraft as any)?.forge_equipment
// ثم تمريره داخل updateConfig.mutateAsync:
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
} as any)
```

3. **تحديث دالة `handleSave()`** (نحو السطر 934):
```typescript
const forgeEquipmentConfig = (draftConfig as any)?.forge_equipment
const payloadToSave = {
  ...
  ...(forgeEquipmentConfig !== undefined ? { forge_equipment: forgeEquipmentConfig } : {}),
}
```

4. **إدراج عنصر التحكم داخل قسم `tab === 'daily'`** بعد مهمة `material_synthesis` (نحو السطر 2217):
```tsx
{/* تصنيع العتاد (النشاط اليومي - Forge Equipment) */}
{(() => {
  const fe = (cfg as any).forge_equipment || { enabled: false, category: 'weapon' }
  const selectedCategory = fe.category || 'weapon'

  return (
    <TaskRow
      id="forge_equipment"
      img="/images/daily/forge_equipment.png"
      label={t('tasks.forgeEquipment', 'تصنيع العتاد')}
      enabled={Boolean(fe.enabled)}
      onToggle={toggle('forge_equipment' as any)}
      comingSoon={false}
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', paddingTop: '4px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
          <span style={{ fontSize: '12px', color: '#94a3b8', fontWeight: 500 }}>
            {t('tasks.forgeEquipCategory', 'صنف العتاد المطلوب:')}
          </span>
        </div>

        {/* شبكة اختيار الأصناف الستة بأيقوناتها المستخرجة */}
        <div className="gap-1.5 grid grid-cols-3 sm:grid-cols-6">
          {EQUIPMENT_CATEGORIES.map(cat => {
            const isSelected = selectedCategory === cat.key
            return (
              <button
                key={cat.key}
                type="button"
                className={clsx('task-equip-btn', isSelected ? 'selected' : 'unselected')}
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
  )
})()}
```

### الخطوة 4: تحديث ملفات الترجمة الثلاثة بالتزامن

#### `dashboard/src/locales/ar.json` (داخل كائن `"tasks"`):
```json
"forge_equipment": "تصنيع العتاد",
"forgeEquipment": "تصنيع العتاد",
"forgeEquipCategory": "صنف العتاد المطلوب:",
"equipWeapon": "السلاح",
"equipClothes": "الثوب / الدرع",
"equipHelmet": "الخوذة",
"equipTrousers": "البنطلون",
"equipShoes": "الحذاء",
"equipRing": "الخاتم / الملحقات",
"forgeEquipmentDesc": "تصنيع أعلى مستوى ممكن من صنف العتاد المختار لإنجاز النشاط اليومي"
```

#### `dashboard/src/locales/en.json` (داخل كائن `"tasks"`):
```json
"forge_equipment": "Forge Equipment",
"forgeEquipment": "Forge Equipment",
"forgeEquipCategory": "Equipment Category:",
"equipWeapon": "Weapon",
"equipClothes": "Armor",
"equipHelmet": "Helmet",
"equipTrousers": "Trousers",
"equipShoes": "Shoes",
"equipRing": "Ring / Accessory",
"forgeEquipmentDesc": "Forge the highest possible tier of chosen equipment category for daily quest"
```

#### `dashboard/src/locales/tr.json` (داخل كائن `"tasks"`):
```json
"forge_equipment": "Ekipman Üret",
"forgeEquipment": "Ekipman Üret",
"forgeEquipCategory": "Ekipman Kategorisi:",
"equipWeapon": "Silah",
"equipClothes": "Zırh",
"equipHelmet": "Miğfer",
"equipTrousers": "Pantolon",
"equipShoes": "Ayakkabı",
"equipRing": "Yüzük",
"forgeEquipmentDesc": "Günlük aktivite için seçilen kategoride üretilebilecek en yüksek ekipmanı üretir"
```

---

## 5. Verification Method (طريقة التحقق المستقلة)

للتحقق المستقل بعد تطبيق التعديلات:
1. **فحص بناء الواجهة وسلامة الأنواع (TypeScript & Vite)**:
   تشغيل الأمر:
   ```powershell
   cd dashboard; npm run build
   ```
   **شرط النجاح**: انتهاء الأمر بنجاح بكود الخروج `0` دون أي أخطاء فحص أنواع أو تحذيرات مفقودة.

2. **التحقق من ملفات الترجمة الثلاثة (JSON Syntax & Key Parity)**:
   تشغيل سكربت بايثون سريع للتحقق من تطابق المفاتيح وصحة ترميز JSON في اللغات الثلاث:
   ```powershell
   python -c "
   import json
   keys = ['forge_equipment', 'forgeEquipment', 'forgeEquipCategory', 'equipWeapon', 'equipClothes', 'equipHelmet', 'equipTrousers', 'equipShoes', 'equipRing']
   for lang in ['ar', 'en', 'tr']:
       with open(f'dashboard/src/locales/{lang}.json', 'r', encoding='utf-8') as f:
           d = json.load(f)
       missing = [k for k in keys if k not in d.get('tasks', {})]
       print(lang, 'missing:', missing)
       assert not missing, f'{lang} missing keys!'
   print('Localization verified 100%!')
   "
   ```

3. **التحقق من سلامة الحفظ الثنائي (Dual-Save Static Audit)**:
   فحص تواجد `forge_equipment` في كود `TaskTabContent.tsx` داخل كلتا الدالتين `performSave()` و `handleSave()` عبر فحص نمط الكود.

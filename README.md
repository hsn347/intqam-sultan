# انتقام السلاطين (Revenge of Sultans) - Bot Project

## معلومات اللعبة
- **Package**: `and.onemt.war.ar`
- **Company**: OneM Technology (نفس شركة Empire)
- **Lua Engine**: xLua (Lua 5.3 معدّل، instruction size = 8 bytes)
- **Game Version**: 2.86

## هيكل المجلد

```
e:\intqam-sultan\
├── base.apk           # APK الأصلية (35MB)
├── apk_decoded\       # APK مفككة بـ apktool
├── delta_raw\         # ملفات Delta الخام من الجهاز
├── lua_src\           # ملفات Lua منظمة (الأصلية + _dec)
├── lua_dumped\        # ملفات Lua مستخرجة بـ Frida (عند تشغيل frida_lua_dump.py)
├── extract_lua.py     # سكريبت سحب وتفكيك ملفات Lua (أعد تشغيله بعد تحميل اللعبة)
├── frida_lua_dump.py  # سكريبت Frida لاستخراج Lua من الذاكرة أثناء التشغيل
└── README.md          # هذا الملف
```

## خطوات التفكيك

### المرحلة 1: سحب الملفات المتاحة
```powershell
python extract_lua.py
```
يسحب الملفات من `Delta/` على الجهاز.

### المرحلة 2: تشغيل اللعبة
شغّل اللعبة في المحاكي وانتظر حتى تكتمل التحميلات.
ستنزل المزيد من ملفات Lua في مجلد Delta.

### المرحلة 3: استخراج Lua بـ Frida
```powershell
python frida_lua_dump.py
```
- الغة تحتاج تكون شغّالة أولاً
- يستخرج كل ملف Lua عند تحميله في الذاكرة
- الملفات تُحفظ في `lua_dumped/`

### لماذا Frida وليس unluac مباشرة؟
اللعبة تستخدم **xLua** مع instruction size = 8 bytes (غير معياري).
`unluac.jar` لا يدعم هذا الـ format. الحل هو استخراج الكود من الذاكرة.

## مقارنة مع لعبة Empire
| الخاصية | Empire (عثمانلي) | انتقام السلاطين |
|---------|-----------------|-----------------|
| Package | `and.onemt.boe.tr` | `and.onemt.war.ar` |
| Lua | LuaJIT 2.0 | xLua (Lua 5.3) |
| Instruction | 4 bytes | 8 bytes |
| Decompiler | unluac.jar ✓ | Frida dump |
| Header | `1B 4C 75 61 51 00` | `1B 4C 75 61 53 01` |

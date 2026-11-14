# المرجع التقني الشامل لمحرك الأتمتة وحقن الحزم (Automation Engine Reference)

يوفر هذا المرجع الكود البرمجي الكامل والموثق الجاهز للحقن المباشر في مشروعنا للعبة **انتقام السلاطين (`and.onemt.war.ar`)**، دون الحاجة لأي محاكي أو نقرات على الشاشة (Zero-Click Protocol).

---

## 1. نموذج بناء وتشفير حزم التحكم في اللعبة (DES-ECB Socket Encryptor)

تعتمد لعبة انتقام السلاطين في اتصالها مع خوادم البوابة على تغليف JSON المشفر بخوارزمية `DES-ECB` مع حشوة `ISO 7816-4`:

```python
import json
import base64
from Crypto.Cipher import DES

def pack_game_command(cmd_id: str, subcmd_id: str, data: dict, session_id: int, des_key: bytes) -> bytes:
    """
    يقوم بتغليف وتشفير طلب تحكم وإعداده للإرسال عبر مقبس البوابة (Gate TCP Socket).
    """
    payload_dict = {
        "cmd": cmd_id,
        "subcmd": subcmd_id,
        "data": data
    }
    payload_json = json.dumps(payload_dict, separators=(',', ':')).encode('utf-8')
    
    # حشوة ISO 7816-4 وتشفير DES-ECB
    pad_len = 8 - (len(payload_json) % 8)
    if pad_len == 0:
        pad_len = 8
    padded = payload_json + b'\x80' + (b'\x00' * (pad_len - 1))
    
    cipher = DES.new(des_key, DES.MODE_ECB)
    enc_data = cipher.encrypt(padded)
    b64_enc = base64.b64encode(enc_data)
    
    # تغليف الحزمة النهائي: 2 بايت طول + Base64 + 4 بايت SessionID
    pkt_len = len(b64_enc) + 4
    header = pkt_len.to_bytes(2, byteorder='big')
    sess_bytes = session_id.to_bytes(4, byteorder='big')
    return header + b64_enc + sess_bytes
```

---

## 2. جدول الوحدات والأوامر الشبكية الرسمية (Master Command Matrix)

تم استخراج هذه الأكواد ومطابقتها مباشرة من ملف تعريف البروتوكول المصدري `cmdDef.lua`:

| الوحدة البرمجية | كود الوحدة (CMD) | الأمر الفرعي (Sub-CMD) | الوظيفة الميدانية | نموذج البيانات (Payload) |
| :--- | :---: | :---: | :--- | :--- |
| **`CMD_CITY_MODULE`** | `1001` | `2` | بناء مبنى جديد في القلعة | `{"bid": "201", "groundIndex": 1}` |
| **`CMD_CITY_MODULE`** | `1001` | `3` | ترقية مبنى قائم | `{"bid": "101", "isgold": 0}` |
| **`CMD_CITY_MODULE`** | `1001` | `8` | حصاد الموارد من المباني الداخلية | `{"bid": "201"}` |
| **`CMD_LORD_MODULE`** | `1002` | `13` | استلام هدية الـ VIP اليومية المجانية | `{}` |
| **`CMD_QUEUE_MODULE`** | `1003` | `2` | تسريع طابور البناء أو التدريب | `{"qid": 1, "itemId": 500602}` |
| **`CMD_BACKPACK_MODULE`** | `1004` | `2` | استخدام أداة من الحقيبة | `{"itemId": 100004, "count": 1}` |
| **`CMD_ARMY_MODULE`** | `1005` | `2` | تدريب دفعة جنود بالثكنة/المعسكر | `{"bid": "118", "armyid": "601", "armycount": 100}` |
| **`CMD_ARMY_MODULE`** | `1005` | `4` | علاج الجنود المصابين بالخيمة الطبية | `{"cureList": [{"armyid": 601, "count": 50}]}` |
| **`CMD_WORLD_MODULE`** | `1006` | `2` | إرسال فيلق لجمع منجم في الخريطة | `{"pointId": 154201, "troops": [...]}` |
| **`CMD_ALLIANCE_MODULE`** | `1010` | `1` | نقر زر مساعدة جميع أعضاء التحالف | `{}` |
| **`CMD_ALLIANCE_MODULE`** | `1010` | `12` | التبرع لتقنيات وعلوم التحالف | `{"scienceId": 101, "isGold": 0}` |
| **`CMD_QUEST_MODULE`** | `1028` | `1` | استعلام بيانات المهام الرئيسية المنجزة | `{}` |
| **`CMD_QUEST_MODULE`** | `1028` | `2` | استلام مكافأة مهمة رئيسية | `{"questID": 5000301}` |
| **`CMD_ACTIVITY_MODULE`** | `1030` | `1` | استعلام بيانات فعاليات الخادم | `{"activityId": 9002}` |
| **`CMD_EVERYDAY_TASK_MODULE`** | `2027` | `1` | استعلام رصيد المهام اليومية | `{}` |
| **`CMD_EVERYDAY_TASK_MODULE`** | `2027` | `2` | استلام نقاط مهمة يومية منجزة | `{"everydayTaskID": 4100001}` |
| **`CMD_EVERYDAY_TASK_MODULE`** | `2027` | `4` | فتح صندوق النقاط اليومي (1 إلى 8) | `{"index": 1}` |
| **`CMD_MOBILIZATION_MODULE`** | `2044` | `1` | استعلام لوحة مهام حشد التحالف | `{}` |
| **`CMD_MOBILIZATION_MODULE`** | `2044` | `5` | إكمال مهمة حشد تحالف واستلام نقاطها | `{"tasktypeid": 4101001}` |
| **`CMD_NEW_PLAYRE_TASK_MODULE`** | `2045` | `2` | استلام مهمة فصل المبتدئين | `{"taskID": 4103012}` |
| **`CMD_NEW_PLAYRE_TASK_MODULE`** | `2045` | `3` | استلام المكافأة الكبرى لإتمام الفصل | `{"chapterID": 4103000}` |

---

## 3. كلاس دورة تنفيذ المهام الذاتية للبوت (TaskExecutionEngine)

```python
class TaskExecutionEngine:
    """
    ينفذ دورة المسح والمطالبة التلقائية بجميع مهام القلعة والمهام اليومية.
    """
    def __init__(self, game_conn):
        self.conn = game_conn

    async def claim_all_finished_quests(self):
        """استلام جميع المهام الرئيسية المكتملة دفعة واحدة"""
        rsp = await self.conn.request("1028", "1", {})
        finished_list = rsp.get("retdata", {}).get("canCommitList", [])
        for qid in finished_list:
            print(f"[Automation] جاري استلام مكافأة المهمة الرئيسية: {qid}")
            await self.conn.request("1028", "2", {"questID": qid})

    async def claim_daily_chests(self):
        """فتح صناديق المهام اليومية المتاحة حتى 500 نقطة"""
        for chest_idx in range(1, 9):
            await self.conn.request("2027", "4", {"index": chest_idx})

    async def claim_mobilization_tasks(self, completed_task_type):
        """إكمال واستلام مهمة حشد التحالف فور انتهائها"""
        await self.conn.request("2044", "5", {"tasktypeid": completed_task_type})
```


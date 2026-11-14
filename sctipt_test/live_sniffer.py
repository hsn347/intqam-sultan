"""
live_sniffer.py — مراقب الحزم المباشر (انتقام السلاطين)
============================================================
يعرض كل الطلبات الصادرة [SEND] والردود الواردة [RECV] بشكل فوري ومقروء كـ JSON صريح
شاملاً حقول cmd و subcmd و data تماماً مثل مشروع العثمانية.

الاستخدام:
  python live_sniffer.py
  python live_sniffer.py --all         # إظهار نبض الاتصال الدوري (cmd 1037)
  python live_sniffer.py --notify      # إظهار إشعارات السيرفر التلقائية RECV NOTIFY
  python live_sniffer.py --filter 1005 # تصفية أوامر محددة  
"""

import socket
import subprocess
import struct
import json
import zlib
import base64
import sys
import os
import re
import time
import argparse
import threading
from Crypto.Cipher import DES

try:
    import frida
    HAS_FRIDA = True
except ImportError:
    HAS_FRIDA = False

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass

# ── إعدادات ──
GATE_PORT      = 4060
BRIDGE_PORT    = 19876
HIDDEN_DEFAULT = {'1037'}
SCRIPT_DIR     = os.path.dirname(os.path.abspath(__file__))
LOG_FILE       = os.path.join(SCRIPT_DIR, "sniffer_log.txt")
KEY_FILE       = os.path.join(SCRIPT_DIR, "des_key.bin")

KEY_SEARCH_PATHS = [
    KEY_FILE,
    os.path.join(os.path.dirname(SCRIPT_DIR), "core", "des_key.bin"),
    os.path.join(SCRIPT_DIR, "core", "des_key.bin"),
    r"E:\intqam-sultan\core\des_key.bin",
    r"E:\osmanli\des_key.bin",
    r"D:\osmanli\des_key.bin",
    r"C:\Users\Computer Home\Desktop\des_key.bin"
]

FALLBACK_KEY = bytes.fromhex("156ebeae9f679e0c")

# ── المتغيرات العامة ──
log_f            = None
count            = 0
pending_sends    = {}
recent_reqs      = []
ACTIVE_DES_KEY   = None
DETECTED_PORTS   = {4060, 4012}
filter_cmds      = set()
show_all         = False
show_notify      = False
ADB_DEVICE       = "emulator-5554"


def _load_des_key():
    global ACTIVE_DES_KEY
    for kp in KEY_SEARCH_PATHS:
        if os.path.exists(kp):
            try:
                with open(kp, "rb") as f:
                    k = f.read()
                    if len(k) == 8 and len(set(k)) >= 4:
                        ACTIVE_DES_KEY = k
                        return k
            except Exception:
                pass
    if not ACTIVE_DES_KEY:
        ACTIVE_DES_KEY = FALLBACK_KEY
        try:
            with open(KEY_FILE, "wb") as f:
                f.write(FALLBACK_KEY)
        except Exception:
            pass
    return ACTIVE_DES_KEY


ACTIVE_DES_KEY = _load_des_key()


def out(text: str):
    print(text, flush=True)
    if log_f:
        try:
            log_f.write(text + '\n')
            log_f.flush()
        except Exception:
            pass


def get_adb_device() -> str:
    try:
        res = subprocess.run("adb devices", shell=True, capture_output=True, text=True)
        lines = [line.split()[0] for line in res.stdout.splitlines()[1:] if '\tdevice' in line]
        for dev in lines:
            if '5554' in dev:
                return dev
        if lines:
            return lines[0]
    except Exception:
        pass
    return "emulator-5554"


def get_game_pid(serial: str):
    try:
        cmd = f"adb -s {serial} shell pidof and.onemt.war.ar"
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        out_str = res.stdout.strip()
        if out_str:
            return int(out_str.split()[0])
    except Exception:
        pass
    return None


def detect_game_connection(serial: str, pid: int) -> list:
    ports = []
    try:
        cmd = f"adb -s {serial} shell su -c 'cat /proc/{pid}/net/tcp'"
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=3.0)
        for line in res.stdout.splitlines()[1:]:
            parts = line.strip().split()
            if len(parts) >= 4:
                st = parts[3]
                if st == '01':
                    rem_addr = parts[2]
                    if ':' in rem_addr:
                        port_hex = rem_addr.split(':')[1]
                        p = int(port_hex, 16)
                        if p not in (53, 80, 443, 853, BRIDGE_PORT):
                            ports.append(p)
    except Exception:
        pass
    return ports


def show_box(direction: str, num: int, session: int, cmd: str, sub: str, err: str, tag: str, payload_dict: dict):
    arrow = '>>>' if direction == 'SEND' else '<<<'
    err_s = f" err={err}" if err and err != '0' else ''
    sess_s = f" session={session}" if session else ''
    cmd_s = f" cmd={cmd}" if cmd else ''
    sub_s = f" subcmd={sub}" if sub else ''
    out(f"\n{'='*56}")
    out(f"  {arrow} #{num}{sess_s}{cmd_s}{sub_s}{err_s} [{tag}]")
    out(f"{'='*56}")
    out(json.dumps(payload_dict, ensure_ascii=False, indent=2))


def try_decompress(raw: bytes) -> bytes:
    for w in (-15, 15, 31, 47, 32):
        try:
            return zlib.decompress(raw, w)
        except Exception:
            pass
    return raw


def _extract_json_from_bytes(data: bytes) -> dict:
    """استخراج أي JSON صالح من bytes"""
    if not data:
        return None
    for candidate in (data, try_decompress(data)):
        s_idx = candidate.find(b'{')
        e_idx = candidate.rfind(b'}')
        if s_idx != -1 and e_idx != -1 and e_idx > s_idx:
            try:
                parsed = json.loads(candidate[s_idx:e_idx+1].decode('utf-8', errors='replace'))
                if isinstance(parsed, dict):
                    return parsed
            except Exception:
                pass
    return None


def decode_json(raw: bytes):
    for candidate in (raw, try_decompress(raw)):
        try:
            s_idx = candidate.find(b'{')
            e_idx = candidate.rfind(b'}')
            if s_idx != -1 and e_idx != -1:
                slice_str = candidate[s_idx:e_idx+1].decode('utf-8', errors='replace')
                parsed = json.loads(slice_str)
                if isinstance(parsed, dict) and ('cmd' in parsed or 'subcmd' in parsed or 'data' in parsed):
                    return parsed
        except Exception:
            pass
    return None


def _des_decrypt_bytes(data: bytes) -> bytes:
    """فك تشفير DES-ECB مع ISO 7816-4 و PKCS7 unpadding"""
    global ACTIVE_DES_KEY
    key = ACTIVE_DES_KEY or _load_des_key()
    if not key or len(key) != 8:
        return None
    try:
        if len(data) % 8 != 0:
            return None
        cipher = DES.new(key, DES.MODE_ECB)
        pt = cipher.decrypt(data)
        # ISO 7816-4
        idx = pt.rfind(b'\x80')
        if idx != -1 and all(b == 0 for b in pt[idx+1:]):
            return pt[:idx]
        # PKCS7
        if pt and 1 <= pt[-1] <= 8:
            pad_len = pt[-1]
            if all(b == pad_len for b in pt[-pad_len:]):
                return pt[:-pad_len]
        return pt
    except Exception:
        return None


def _try_decrypt_des_str(ct_str: str) -> dict:
    """فك تشفير Base64+DES واستخراج JSON"""
    if not ct_str or not isinstance(ct_str, str):
        return None
    try:
        padded = ct_str + '=' * (-len(ct_str) % 4)
        raw_ct = base64.b64decode(padded)
    except Exception:
        return None
    pt = _des_decrypt_bytes(raw_ct)
    if pt is None:
        return None
    return _extract_json_from_bytes(pt)


def _parse_send_body(body: bytes) -> dict:
    """
    فك تشفير body طلب SEND بـ 6 استراتيجيات متتالية.
    الهدف: الحصول على dict فيه cmd و subcmd و data.
    """
    if not body:
        return None

    # 1: JSON صريح
    result = _extract_json_from_bytes(body)
    if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
        inner_d = result.get('data')
        if isinstance(inner_d, str) and inner_d:
            dec = _try_decrypt_des_str(inner_d)
            if isinstance(dec, dict):
                result['data'] = dec
        return result

    # 2: DES على كامل الـ body
    if len(body) >= 8 and len(body) % 8 == 0:
        pt = _des_decrypt_bytes(body)
        if pt:
            result = _extract_json_from_bytes(pt)
            if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
                inner_d = result.get('data')
                if isinstance(inner_d, str) and inner_d:
                    dec = _try_decrypt_des_str(inner_d)
                    if isinstance(dec, dict):
                        result['data'] = dec
                return result

    # 3: Base64 ثم DES
    try:
        b64_str = body.decode('ascii', errors='strict').strip()
        if re.match(r'^[A-Za-z0-9+/=\n]+$', b64_str):
            raw_ct = base64.b64decode(b64_str + '=' * (-len(b64_str) % 4))
            if len(raw_ct) % 8 == 0:
                pt = _des_decrypt_bytes(raw_ct)
                if pt:
                    result = _extract_json_from_bytes(pt)
                    if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
                        inner_d = result.get('data')
                        if isinstance(inner_d, str) and inner_d:
                            dec = _try_decrypt_des_str(inner_d)
                            if isinstance(dec, dict):
                                result['data'] = dec
                        return result
    except Exception:
        pass

    # 4: Header ثنائي [cmd:4B][subcmd:4B][data:NB]
    if len(body) >= 9:
        for endian in ('>', '<'):
            try:
                cmd_i = struct.unpack(f'{endian}I', body[0:4])[0]
                sub_i = struct.unpack(f'{endian}I', body[4:8])[0]
                if 1000 <= cmd_i <= 9999 and 0 <= sub_i <= 999:
                    data_raw = body[8:]
                    result_data = {}
                    if len(data_raw) >= 8 and len(data_raw) % 8 == 0:
                        pt = _des_decrypt_bytes(data_raw)
                        if pt:
                            d = _extract_json_from_bytes(pt)
                            if isinstance(d, dict):
                                result_data = d
                    if not result_data:
                        d = _extract_json_from_bytes(data_raw)
                        if isinstance(d, dict):
                            result_data = d
                    if not result_data:
                        try:
                            b64s = data_raw.decode('ascii', errors='strict').strip()
                            if re.match(r'^[A-Za-z0-9+/=]+$', b64s):
                                raw_ct = base64.b64decode(b64s + '=' * (-len(b64s) % 4))
                                if len(raw_ct) % 8 == 0:
                                    pt = _des_decrypt_bytes(raw_ct)
                                    if pt:
                                        d = _extract_json_from_bytes(pt)
                                        if isinstance(d, dict):
                                            result_data = d
                        except Exception:
                            pass
                    if result_data or (1000 <= cmd_i <= 3000 and 1 <= sub_i <= 50):
                        return {
                            'cmd': str(cmd_i),
                            'subcmd': str(sub_i),
                            'data': result_data
                        }
            except Exception:
                pass

    # 5: XOR ثابت
    try:
        XOR_KEY = bytes([79, 83, 120, 72, 80, 46, 33, 45, 119, 100, 63, 39, 108, 97, 111, 53])
        de_xor = bytes(b ^ XOR_KEY[i % len(XOR_KEY)] for i, b in enumerate(body))
        result = _extract_json_from_bytes(de_xor)
        if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
            return result
    except Exception:
        pass

    # 6: شرائح مختلفة من الـ body
    for skip in (1, 2, 3, 4, 6, 8, 10, 12, 16):
        if len(body) > skip + 8:
            slc = body[skip:]
            if len(slc) % 8 == 0:
                pt = _des_decrypt_bytes(slc)
                if pt:
                    result = _extract_json_from_bytes(pt)
                    if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
                        return result
            result = _extract_json_from_bytes(slc)
            if result and isinstance(result, dict) and ('cmd' in result or 'subcmd' in result):
                return result

    return None


def _enrich_data_from_frida(cmd: str, sub: str) -> dict:
    """استرجاع data من recent_reqs المجمعة بواسطة Frida"""
    for r in reversed(recent_reqs):
        if str(r.get('cmd', '')) == str(cmd) and str(r.get('subcmd', '')) == str(sub):
            d = r.get('data')
            if isinstance(d, dict) and d:
                return d
            elif isinstance(d, str) and d:
                dec = _try_decrypt_des_str(d)
                if isinstance(dec, dict):
                    return dec
    return None


def _build_final_send_payload(parsed_send: dict, raw_body: bytes) -> dict:
    """
    بناء payload الطلب النهائي بأولوية صارمة.
    يضمن أن حقل data لن يكون فارغاً إلا إذا فشلت كل المحاولات.
    """
    cmd = ''
    sub = ''
    data = {}

    if isinstance(parsed_send, dict):
        cmd = str(parsed_send.get('cmd', ''))
        sub = str(parsed_send.get('subcmd', ''))
        raw_data = parsed_send.get('data')
        if isinstance(raw_data, dict) and raw_data:
            data = raw_data
        elif isinstance(raw_data, str) and raw_data:
            dec = _try_decrypt_des_str(raw_data)
            if isinstance(dec, dict) and dec:
                data = dec

    # من Frida
    if not data and cmd:
        frida_data = _enrich_data_from_frida(cmd, sub)
        if frida_data:
            data = frida_data

    # شرائح مختلفة من raw_body
    if not data and raw_body and len(raw_body) > 8:
        for slc in (raw_body[8:], raw_body[4:], raw_body[12:], raw_body[16:], raw_body[6:]):
            if len(slc) >= 8 and len(slc) % 8 == 0:
                pt = _des_decrypt_bytes(slc)
                if pt:
                    d = _extract_json_from_bytes(pt)
                    if isinstance(d, dict) and d:
                        data = d
                        break
            if not data:
                d = _extract_json_from_bytes(slc)
                if isinstance(d, dict) and d:
                    data = d
                    break

    # إعادة محاولة _parse_send_body
    if not data and raw_body:
        re_parsed = _parse_send_body(raw_body)
        if isinstance(re_parsed, dict):
            if not cmd:
                cmd = str(re_parsed.get('cmd', ''))
            if not sub:
                sub = str(re_parsed.get('subcmd', ''))
            re_data = re_parsed.get('data')
            if isinstance(re_data, dict) and re_data:
                data = re_data

    # hex للتشخيص إن فشل كل شيء
    if not data and raw_body:
        data = {"_raw_hex": raw_body[:64].hex(), "_raw_len": len(raw_body)}

    return {"cmd": cmd, "subcmd": sub, "data": data}


def read_exact(conn: socket.socket, n: int) -> bytes:
    buf = bytearray()
    while len(buf) < n:
        chunk = conn.recv(n - len(buf))
        if not chunk:
            raise ConnectionResetError("Stream closed by bridge")
        buf.extend(chunk)
    return bytes(buf)


def start_frida_worker(serial: str):
    """هوك Frida لالتقاط المفتاح والطلبات في الخلفية"""
    global ACTIVE_DES_KEY
    if not HAS_FRIDA:
        return

    def on_frida_msg(msg, data):
        global ACTIVE_DES_KEY
        if msg.get('type') == 'send':
            p = msg.get('payload', {})
            t = p.get('type')
            if t == 'DES_KEY':
                raw_hex = p.get('hex', '')
                if len(raw_hex) == 16:
                    k_raw = bytes.fromhex(raw_hex)
                    if k_raw != ACTIVE_DES_KEY:
                        ACTIVE_DES_KEY = k_raw
                        try:
                            with open(KEY_FILE, "wb") as f:
                                f.write(k_raw)
                        except Exception:
                            pass
                        print(f"\n[+] مفتاح DES جديد: {raw_hex}", flush=True)
            elif t == 'REQ_JSON':
                try:
                    parsed = json.loads(p.get('str', ''))
                    if isinstance(parsed, dict):
                        recent_reqs.append(parsed)
                        if len(recent_reqs) > 50:
                            recent_reqs.pop(0)
                except Exception:
                    pass

    def _worker():
        while True:
            try:
                pid = get_game_pid(serial)
                if not pid:
                    time.sleep(2)
                    continue

                frida_code = """
                (function() {
                    var libcMod = Process.getModuleByName('libc.so');
                    var recvfromAddr = libcMod.findExportByName('recvfrom');
                    var sendtoAddr   = libcMod.findExportByName('sendto');
                    var gameSocketFD = -1;
                    var keyFound = false;
                    var lastScan = 0;

                    if (recvfromAddr) {
                        Interceptor.attach(recvfromAddr, {
                            onEnter: function(args) {
                                this._fd  = args[0].toInt32();
                                this._buf = args[1];
                            },
                            onLeave: function(retval) {
                                var ret = retval.toInt32();
                                if (ret <= 0) return;
                                if (ret > 20 && gameSocketFD < 0) {
                                    try {
                                        var first = this._buf.readU8();
                                        if (first === 0x7b || first === 0xFF || first === 0xFE) {
                                            gameSocketFD = this._fd;
                                        }
                                    } catch(e) {}
                                }
                                if (this._fd === gameSocketFD && ret > 10) {
                                    if (!keyFound) {
                                        var now = Date.now();
                                        if (now - lastScan > 4000) {
                                            lastScan = now;
                                            _scanForKey();
                                        }
                                    }
                                }
                            }
                        });
                    }

                    if (sendtoAddr) {
                        Interceptor.attach(sendtoAddr, {
                            onEnter: function(args) {
                                var fd  = args[0].toInt32();
                                var buf = args[1];
                                var len = args[2].toInt32();
                                if (fd === gameSocketFD && len > 8 && len < 4096) {
                                    try {
                                        var bytes = buf.readByteArray(len);
                                        send({type: 'SEND_RAW'}, bytes);
                                    } catch(e) {}
                                }
                            }
                        });
                    }

                    function _scanForKey() {
                        var pattern = '08 00 00 00 ?? ?? ?? ?? ?? ?? ?? ?? 00';
                        var heapRanges = Process.enumerateRanges('rw-');
                        heapRanges.forEach(function(region) {
                            if (keyFound) return;
                            if (region.size < 4096 || region.size > 8*1024*1024) return;
                            if (region.base.compare(ptr('0x10000000')) < 0) return;
                            try {
                                Memory.scan(region.base, region.size, pattern, {
                                    onMatch: function(addr, sz) {
                                        if (keyFound) return;
                                        try {
                                            var kb = addr.add(4).readByteArray(8);
                                            var arr = new Uint8Array(kb);
                                            var uniq = new Set(Array.from(arr)).size;
                                            if (uniq >= 4) {
                                                send({type:'KEY_CAND'}, kb);
                                            }
                                        } catch(e) {}
                                    },
                                    onError: function() {},
                                    onComplete: function() {}
                                });
                            } catch(e) {}
                        });
                    }
                })();
                """

                dev = frida.get_device_manager().get_device(serial)
                session = dev.attach(pid)
                scr = session.create_script(frida_code)

                def _on_frida(msg, data):
                    p = msg.get('payload', {})
                    t = p.get('type', '')
                    if t == 'KEY_CAND' and data:
                        raw8 = bytes(data)
                        global ACTIVE_DES_KEY
                        if len(raw8) == 8 and len(set(raw8)) >= 4:
                            ACTIVE_DES_KEY = raw8
                            try:
                                with open(KEY_FILE, "wb") as f:
                                    f.write(raw8)
                            except Exception:
                                pass
                            print(f"\n[KEY] مفتاح DES من الذاكرة: {raw8.hex()}", flush=True)
                    elif t == 'SEND_RAW' and data:
                        raw_bytes = bytes(data)
                        parsed = _parse_send_body(raw_bytes)
                        if parsed and isinstance(parsed, dict):
                            recent_reqs.append(parsed)
                            if len(recent_reqs) > 50:
                                recent_reqs.pop(0)
                    else:
                        on_frida_msg(msg, data)

                scr.on('message', _on_frida)
                scr.load()

                while True:
                    time.sleep(3)
                    curr_pid = get_game_pid(serial)
                    if curr_pid != pid:
                        break
            except Exception:
                time.sleep(3)

    t = threading.Thread(target=_worker, daemon=True)
    t.start()


def start_stream_bridge(serial: str, detected_ports: list = None):
    """تأسيس جسر TCP مباشر مع الأندرويد"""
    subprocess.run(f"adb -s {serial} reverse tcp:{BRIDGE_PORT} tcp:{BRIDGE_PORT}", shell=True, check=True, stdout=subprocess.DEVNULL)

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(('127.0.0.1', BRIDGE_PORT))
    server.listen(1)

    ports = set(detected_ports or [])
    ports.add(GATE_PORT)
    ports.add(4012)
    ports.add(4060)
    ports.discard(853)
    ports.discard(53)

    port_filter = " or ".join(f"port {p}" for p in sorted(ports))
    cmd = f"adb -s {serial} shell \"su -c 'tcpdump -i any -l -U -s 0 -w - {port_filter} 2>/dev/null | toybox nc 127.0.0.1 {BRIDGE_PORT}'\""
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    server.settimeout(12.0)
    try:
        conn, addr = server.accept()
    except socket.timeout:
        proc.kill()
        server.close()
        raise TimeoutError("فشل الاتصال بالمحاكي! تأكد من تشغيل المحاكي وصلاحيات Root.")

    conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    server.close()
    return conn, proc


def is_gate_port(p: int) -> bool:
    return p in DETECTED_PORTS or p in (GATE_PORT, 4012, 4060) or (4000 <= p <= 4350)


def main():
    global log_f, count, filter_cmds, show_all, show_notify, ADB_DEVICE, GATE_PORT, ACTIVE_DES_KEY, DETECTED_PORTS

    parser = argparse.ArgumentParser(description="مراقب الحزم المباشر (انتقام السلاطين)")
    parser.add_argument('--all', action='store_true')
    parser.add_argument('--notify', action='store_true')
    parser.add_argument('--filter', type=str, default="")
    parser.add_argument('--device', type=str, default="")
    parser.add_argument('--port', type=int, default=GATE_PORT)
    parser.add_argument('--key', type=str, default="")
    args = parser.parse_args()
    GATE_PORT = args.port
    show_all = args.all
    show_notify = args.notify
    if args.filter:
        filter_cmds = set(args.filter.split(','))
    if args.key:
        try:
            raw_k = bytes.fromhex(args.key.strip())
            if len(raw_k) == 8:
                ACTIVE_DES_KEY = raw_k
                try:
                    with open(KEY_FILE, "wb") as f:
                        f.write(raw_k)
                except Exception:
                    pass
                print(f"  [مفتاح التشفير]: تم التعيين يدوياً ({raw_k.hex()})", flush=True)
        except Exception as e:
            print(f"  [تحذير]: مفتاح غير صالح ({e})", flush=True)

    ADB_DEVICE = args.device if args.device else get_adb_device()
    log_f = open(LOG_FILE, 'w', encoding='utf-8')

    print("=" * 56, flush=True)
    print("  live_sniffer.py — مراقب حزم انتقام السلاطين المباشر", flush=True)
    print(f"  المحاكي: {ADB_DEVICE}  |  السجل: {LOG_FILE}", flush=True)

    game_pid = get_game_pid(ADB_DEVICE)
    active_ports = []
    if game_pid:
        print(f"  [PID={game_pid}]", flush=True)
        active_ports = detect_game_connection(ADB_DEVICE, game_pid)
        for p in active_ports:
            if p not in (53, 853):
                DETECTED_PORTS.add(p)
        if active_ports:
            print(f"  [منافذ نشطة]: {list(DETECTED_PORTS)}", flush=True)
    else:
        print("  [تنبيه]: اللعبة غير مشغلة على المحاكي!", flush=True)

    if ACTIVE_DES_KEY:
        print(f"  [مفتاح DES]: {ACTIVE_DES_KEY.hex()}", flush=True)
    if not show_all:
        print("  [تصفية]: نبض 1037 مخفي (--all لإظهاره)", flush=True)
    if filter_cmds:
        print(f"  [فلتر]: {', '.join(filter_cmds)}", flush=True)
    print("=" * 56, flush=True)

    start_frida_worker(ADB_DEVICE)
    print("[*] جارٍ تأسيس جسر التدفق...", flush=True)

    try:
        conn, proc = start_stream_bridge(ADB_DEVICE, active_ports)
    except Exception as e:
        print(f"[!] خطأ: {e}", flush=True)
        return

    print("[+] تم الاتصال! يراقب الطلبات الآن...")
    print("[*] اضغط Ctrl+C للإيقاف.\n", flush=True)

    try:
        pcap_hdr = read_exact(conn, 24)
    except Exception as e:
        print(f"[!] خطأ في قراءة ترويسة الحزم: {e}", flush=True)
        proc.kill()
        conn.close()
        return

    magic = pcap_hdr[:4]
    little_endian = (magic in (b'\xd4\xc3\xb2\xa1', b'\x4d\x3c\xb2\xa1'))
    order = '<' if little_endian else '>'

    recv_buf = bytearray()
    send_buf = bytearray()

    try:
        while True:
            hdr_raw = read_exact(conn, 16)
            ts_sec, ts_usec, incl_len, orig_len = struct.unpack(f'{order}IIII', hdr_raw)
            pkt_data = read_exact(conn, incl_len)

            if len(pkt_data) < 56:
                continue

            ip_hdr = pkt_data[16:36]
            ihl = (ip_hdr[0] & 0x0F) * 4
            proto = ip_hdr[9]
            if proto != 6:
                continue

            tcp_offset = 16 + ihl
            if len(pkt_data) < tcp_offset + 20:
                continue

            tcp_hdr = pkt_data[tcp_offset:tcp_offset+20]
            src_port, dst_port = struct.unpack('>HH', tcp_hdr[:4])
            data_offset = ((tcp_hdr[12] >> 4) & 0x0F) * 4
            payload = pkt_data[tcp_offset + data_offset:]

            if not payload:
                continue

            # ── RECV من السيرفر ──
            if is_gate_port(src_port):
                GATE_PORT = src_port
                recv_buf.extend(payload)
                while len(recv_buf) >= 2:
                    sz = recv_buf[0] * 256 + recv_buf[1]
                    if sz == 0xFFFF:
                        if len(recv_buf) < 5: break
                        sz = recv_buf[2]*65536 + recv_buf[3]*256 + recv_buf[4]
                        head_len = 5
                    else:
                        head_len = 2

                    total_len = head_len + sz
                    if len(recv_buf) < total_len:
                        break

                    frame = bytes(recv_buf[head_len:total_len])
                    del recv_buf[:total_len]

                    session = 0
                    parsed = None
                    raw_body = frame

                    if len(frame) >= 5:
                        cand_session = struct.unpack('>I', frame[-4:])[0]
                        parsed = decode_json(frame[:-5])
                        if parsed:
                            session = cand_session
                            raw_body = frame[:-5]

                    if not parsed and len(frame) >= 4:
                        cand_session = struct.unpack('>I', frame[-4:])[0]
                        parsed = decode_json(frame[:-4])
                        if parsed:
                            session = cand_session
                            raw_body = frame[:-4]

                    if not parsed:
                        parsed = decode_json(frame)

                    cmd = str(parsed.get('cmd', '')) if parsed else ''
                    sub = str(parsed.get('subcmd', '')) if parsed else ''
                    err = str(parsed.get('err', '')) if parsed else ''

                    if not show_all and (cmd in HIDDEN_DEFAULT or (not cmd and len(frame) <= 12)):
                        pending_sends.pop(session, None)
                        continue

                    if filter_cmds and cmd not in filter_cmds:
                        pending_sends.pop(session, None)
                        continue

                    req_info = pending_sends.pop(session, None)

                    if not req_info:
                        if show_notify:
                            count += 1
                            show_box('RECV', count, session, cmd, sub, err, 'RECV NOTIFY',
                                     parsed if parsed else {"raw": repr(raw_body[:200])})
                        continue

                    count += 1

                    send_box_data = _build_final_send_payload(
                        parsed_send=req_info.get('parsed'),
                        raw_body=req_info.get('raw_body', b'')
                    )

                    if not send_box_data.get('cmd'):
                        send_box_data['cmd'] = cmd
                    if not send_box_data.get('subcmd'):
                        send_box_data['subcmd'] = sub

                    show_box('SEND', count, session,
                             str(send_box_data.get('cmd', cmd)),
                             str(send_box_data.get('subcmd', sub)),
                             '', 'SEND', send_box_data)

                    if parsed:
                        show_box('RECV', count, session, cmd, sub, err, 'RECV', parsed)
                    else:
                        out(f"\n{'='*56}")
                        out(f"  <<< #{count} session={session} len={len(raw_body)} [RECV RAW]")
                        out(f"{'='*56}")
                        out(repr(raw_body[:200]))

            # ── SEND من اللعبة ──
            elif is_gate_port(dst_port):
                GATE_PORT = dst_port
                send_buf.extend(payload)
                while len(send_buf) >= 2:
                    sz = send_buf[0] * 256 + send_buf[1]
                    if sz == 0xFFFF:
                        if len(send_buf) < 5: break
                        sz = send_buf[2]*65536 + send_buf[3]*256 + send_buf[4]
                        head_len = 5
                    else:
                        head_len = 2

                    total_len = head_len + sz
                    if len(send_buf) < total_len:
                        break

                    frame = bytes(send_buf[head_len:total_len])
                    del send_buf[:total_len]

                    if len(frame) < 4:
                        continue

                    session = struct.unpack('>I', frame[-4:])[0]
                    body = frame[:-4]
                    if not body:
                        continue

                    parsed_send = _parse_send_body(body)

                    cmd_val = str(parsed_send.get('cmd', '')) if parsed_send else ''
                    sub_val = str(parsed_send.get('subcmd', '')) if parsed_send else ''

                    if not show_all and cmd_val in HIDDEN_DEFAULT:
                        continue

                    pending_sends[session] = {
                        'session': session,
                        'raw_body': body,
                        'parsed': parsed_send,
                        'cmd': cmd_val,
                        'subcmd': sub_val,
                        'time': time.time()
                    }

                    if len(pending_sends) > 100:
                        now = time.time()
                        stale = [s for s, v in pending_sends.items() if now - v.get('time', now) > 60]
                        for s in stale:
                            pending_sends.pop(s, None)

    except KeyboardInterrupt:
        print(f"\n[*] تم الإيقاف. السجل: {LOG_FILE}", flush=True)
    except Exception as e:
        print(f"\n[!] انقطع الاتصال: {e}", flush=True)
    finally:
        try: proc.kill()
        except Exception: pass
        try: conn.close()
        except Exception: pass
        if log_f:
            try: log_f.close()
            except Exception: pass


if __name__ == '__main__':
    main()

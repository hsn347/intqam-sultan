// ============================================================
//  📡 أداة استعلام + تنفيذ الأوامر وعرض الرد (انتقام السلاطين)
// ============================================================
//  عدّل CMD, SUBCMD, DATA → شغّل → المس اللعبة → يظهر الرد فوراً
// ============================================================

// طريقة التشغيل في التيرمنال:
// frida -D emulator-5554 -n and.onemt.war.ar -l simple_cmd.js
// أو ببساطة:
// python send_cmd.py

// ╔══════════════════════════════════╗
// ║   عدّل هنا فقط ↓↓↓                ║
// ╚══════════════════════════════════╝

var CMD = '1005';
var SUBCMD = '2';
var DATA = {
  "isget": false,
  "armycount": "100",
  "bid": "117",
  "mode": "0",
  "armyid": "609"
};

// ╔══════════════════════════════════╗
// ║   لا تعدّل تحت هذا السطر          ║
// ╚══════════════════════════════════╝

var sent = false;
var foundFd = -1;
var waiting = true;
var activeDesKey = null;

var libc = Process.getModuleByName("libc.so");
var libz = Process.findModuleByName("libz.so");

var fn_write = new NativeFunction(libc.findExportByName("write"), 'int', ['int', 'pointer', 'int']);
var fn_send  = new NativeFunction(libc.findExportByName("send"), 'int', ['int', 'pointer', 'int', 'int']);

var fn_uncompress = null;
if (libz) {
    var p_uncompress = libz.findExportByName("uncompress");
    if (p_uncompress) {
        fn_uncompress = new NativeFunction(p_uncompress, 'int', ['pointer', 'pointer', 'pointer', 'ulong']);
    }
}

// ─────────────────────────────────────────────────────────────
// خوارزمية DES-ECB النقية القياسية مع حشوة ISO 7816-4
// ─────────────────────────────────────────────────────────────
var DES_TABLES = (function() {
    var IP = [58,50,42,34,26,18,10,2,60,52,44,36,28,20,12,4,62,54,46,38,30,22,14,6,64,56,48,40,32,24,16,8,
              57,49,41,33,25,17,9,1,59,51,43,35,27,19,11,3,61,53,45,37,29,21,13,5,63,55,47,39,31,23,15,7];
    var FP = [40,8,48,16,56,24,64,32,39,7,47,15,55,23,63,31,38,6,46,14,54,22,62,30,37,5,45,13,53,21,61,29,
              36,4,44,12,52,20,60,28,35,3,43,11,51,19,59,27,34,2,42,10,50,18,58,26,33,1,41,9,49,17,57,25];
    var PC1 = [57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,
               63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4];
    var PC2 = [14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,
               51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32];
    var SHIFTS = [1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1];
    var E = [32,1,2,3,4,5,4,5,6,7,8,9,8,9,10,11,12,13,12,13,14,15,16,17,16,17,18,19,20,21,20,21,22,23,24,25,
             24,25,26,27,28,29,28,29,30,31,32,1];
    var P = [16,7,20,21,29,12,28,17,1,15,23,26,5,18,31,10,2,8,24,14,32,27,3,9,19,13,30,6,22,11,4,25];
    var S = [
        [14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7, 0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8, 4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0, 15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13],
        [15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10, 3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5, 0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15, 13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9],
        [10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8, 13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1, 13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7, 1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12],
        [7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15, 13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9, 10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4, 3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14],
        [2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9, 14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6, 4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14, 11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3],
        [12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11, 10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8, 9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6, 4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13],
        [4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1, 13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6, 1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2, 6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12],
        [13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7, 1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2, 7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8, 2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11]
    ];
    return {IP:IP, FP:FP, PC1:PC1, PC2:PC2, SHIFTS:SHIFTS, E:E, P:P, S:S};
})();

function desKeySchedule(keyBytes) {
    var T = DES_TABLES;
    var bits = [];
    for (var i = 0; i < 8; i++) {
        for (var b = 7; b >= 0; b--) bits.push((keyBytes[i] >> b) & 1);
    }
    var pc1 = [];
    for (var i = 0; i < 56; i++) pc1.push(bits[T.PC1[i] - 1]);
    var C = pc1.slice(0, 28);
    var D = pc1.slice(28, 56);
    var subkeys = [];
    for (var r = 0; r < 16; r++) {
        var sh = T.SHIFTS[r];
        C = C.slice(sh).concat(C.slice(0, sh));
        D = D.slice(sh).concat(D.slice(0, sh));
        var CD = C.concat(D);
        var k = [];
        for (var i = 0; i < 48; i++) k.push(CD[T.PC2[i] - 1]);
        subkeys.push(k);
    }
    return subkeys;
}

function desEncryptBlock(block8, subkeys) {
    var T = DES_TABLES;
    var bits = [];
    for (var i = 0; i < 8; i++) {
        for (var b = 7; b >= 0; b--) bits.push((block8[i] >> b) & 1);
    }
    var ip = [];
    for (var i = 0; i < 64; i++) ip.push(bits[T.IP[i] - 1]);
    var L = ip.slice(0, 32);
    var R = ip.slice(32, 64);
    for (var r = 0; r < 16; r++) {
        var K = subkeys[r];
        var e = [];
        for (var i = 0; i < 48; i++) e.push(R[T.E[i] - 1]);
        var x = [];
        for (var i = 0; i < 48; i++) x.push(e[i] ^ K[i]);
        var sOut = [];
        for (var s = 0; s < 8; s++) {
            var chunk = x.slice(s * 6, s * 6 + 6);
            var row = (chunk[0] << 1) | chunk[5];
            var col = (chunk[1] << 3) | (chunk[2] << 2) | (chunk[3] << 1) | chunk[4];
            var val = T.S[s][row * 16 + col];
            for (var b = 3; b >= 0; b--) sOut.push((val >> b) & 1);
        }
        var pOut = [];
        for (var i = 0; i < 32; i++) pOut.push(sOut[T.P[i] - 1]);
        var nextR = [];
        for (var i = 0; i < 32; i++) nextR.push(L[i] ^ pOut[i]);
        L = R;
        R = nextR;
    }
    var preOutput = R.concat(L);
    var fp = [];
    for (var i = 0; i < 64; i++) fp.push(preOutput[T.FP[i] - 1]);
    var outBytes = [];
    for (var i = 0; i < 8; i++) {
        var byteVal = 0;
        for (var b = 0; b < 8; b++) byteVal = (byteVal << 1) | fp[i * 8 + b];
        outBytes.push(byteVal);
    }
    return outBytes;
}

function desEcbEncrypt(plainBytes, keyBytes) {
    var subkeys = desKeySchedule(keyBytes);
    var out = [];
    for (var i = 0; i < plainBytes.length; i += 8) {
        var block = plainBytes.slice(i, i + 8);
        var encBlock = desEncryptBlock(block, subkeys);
        out = out.concat(encBlock);
    }
    return out;
}

function bytesToBase64(bytes) {
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    var res = '';
    for (var i = 0; i < bytes.length; i += 3) {
        var b0 = bytes[i], b1 = (i+1 < bytes.length)?bytes[i+1]:0, b2 = (i+2 < bytes.length)?bytes[i+2]:0;
        res += chars.charAt(b0 >> 2);
        res += chars.charAt(((b0 & 3) << 4) | (b1 >> 4));
        res += (i+1 < bytes.length) ? chars.charAt(((b1 & 15) << 2) | (b2 >> 6)) : '=';
        res += (i+2 < bytes.length) ? chars.charAt(b2 & 63) : '=';
    }
    return res;
}

function utf8Encode(str) {
    var bytes = [];
    for (var i = 0; i < str.length; i++) {
        var c = str.charCodeAt(i);
        if (c < 128) bytes.push(c);
        else if (c < 2048) bytes.push((c >> 6) | 192, (c & 63) | 128);
        else bytes.push((c >> 12) | 224, ((c >> 6) & 63) | 128, (c & 63) | 128);
    }
    return bytes;
}

// ─────────────────────────────────────────────────────────────
// بناء حزمة الطلب المشفرة بالكامل
// ─────────────────────────────────────────────────────────────
function buildCmd(cmd, subcmd, data, session, keyBytes) {
    var msg = JSON.stringify({cmd: String(cmd), subcmd: String(subcmd), data: data || {}});
    var plain = utf8Encode(msg);
    
    // ISO 7816-4 padding: chunksz = (len + 8) & ~7
    var textsz = plain.length;
    var chunksz = (textsz + 8) & ~7;
    plain.push(0x80);
    while (plain.length < chunksz) plain.push(0x00);
    
    var encBytes = desEcbEncrypt(plain, keyBytes);
    var b64Str = bytesToBase64(encBytes);
    var b64Bytes = utf8Encode(b64Str);
    
    var sz = b64Bytes.length + 4;
    var pkt = [];
    if (sz >= 0xFFFF) {
        pkt.push(0xFF, 0xFF, (sz >> 16) & 0xFF, (sz >> 8) & 0xFF, sz & 0xFF);
    } else {
        pkt.push((sz >> 8) & 0xFF, sz & 0xFF);
    }
    for (var i = 0; i < b64Bytes.length; i++) pkt.push(b64Bytes[i]);
    pkt.push((session >> 24) & 0xFF, (session >> 16) & 0xFF, (session >> 8) & 0xFF, session & 0xFF);
    return pkt;
}

function sendPacket(fd, packet) {
    var buf = Memory.alloc(packet.length);
    for (var i = 0; i < packet.length; i++) buf.add(i).writeU8(packet[i]);
    var r = fn_send(fd, buf, packet.length, 0);
    if (r <= 0) r = fn_write(fd, buf, packet.length);
    return r;
}

function tryShowResponse(ptr, len) {
    if (!waiting || len < 10) return;
    try {
        var u = new Uint8Array(ptr.readByteArray(Math.min(len, 65536)));
        var si = -1, ei = -1;
        for (var i = 0; i < u.length; i++) {
            if (u[i] === 0x7b && si === -1) si = i;
            if (u[i] === 0x7d) ei = i;
        }
        if (si !== -1 && ei > si) {
            var t = '';
            for (var i = si; i <= ei; i++) t += String.fromCharCode(u[i]);
            try {
                var p = JSON.parse(t);
                if (p && (p.cmd === CMD || p.subcmd === SUBCMD || p.err !== undefined)) {
                    waiting = false;
                    printResult(p);
                    return;
                }
            } catch(e) {}
        }
        if (fn_uncompress && len > 6) {
            for (var off = 0; off <= 5; off++) {
                var dL = Memory.alloc(8); dL.writeU64(131072);
                var dB = Memory.alloc(131072);
                if (fn_uncompress(dB, dL, ptr.add(off), len - off) === 0) {
                    var ds = dB.readUtf8String(dL.readU32());
                    var ps = ds.indexOf('{'), pe = ds.lastIndexOf('}');
                    if (ps !== -1 && pe > ps) {
                        var j = JSON.parse(ds.substring(ps, pe + 1));
                        waiting = false;
                        printResult(j);
                        return;
                    }
                }
            }
        }
    } catch(e) {}
}

function printResult(jsonObj) {
    console.log("\n╔══════════════════════════════════════════════════════╗");
    console.log("║  📥 رد السيرفر (Server Response)                     ║");
    console.log("╚══════════════════════════════════════════════════════╝");
    console.log(JSON.stringify(jsonObj, null, 2));
    console.log("════════════════════════════════════════════════════════\n");
}

// ─────────────────────────────────────────────────────────────
// بدء المراقبة والحقن (مطابق للعثمانية)
// ─────────────────────────────────────────────────────────────
console.log("\n📡 أداة تنفيذ الأوامر المباشرة (انتقام السلاطين)");
console.log("→ cmd=" + CMD + " | subcmd=" + SUBCMD);
console.log("→ data=" + JSON.stringify(DATA));
console.log("→ المس أي زر في اللعبة لإرسال الأمر فوراً...\n");

// 1. هوك التقاط مفتاح DES من libxlua.so
try {
    var libxlua = Process.findModuleByName('libxlua.so');
    if (libxlua) {
        var base = libxlua.base;
        var lua_tolstring = new NativeFunction(base.add(0x30c74), 'pointer', ['pointer', 'int', 'pointer']);
        var p_getkey = base.add(0xb5bf4);

        Interceptor.attach(p_getkey, {
            onEnter: function(args) {
                if (activeDesKey) return;
                try {
                    var L = args[0];
                    var keyPtr = lua_tolstring(L, 1, ptr(0));
                    if (!keyPtr.isNull()) {
                        var kb = [];
                        for (var i = 0; i < 8; i++) kb.push(keyPtr.add(i).readU8());
                        if (new Set(kb).size >= 3) {
                            activeDesKey = kb;
                            console.log("[+] تم التقاط مفتاح التشفير DES بنجاح ✓");
                        }
                    }
                } catch(e) {}
            }
        });
    }
} catch(e) {}

// 2. هوك الإرسال (لاكتشاف المقبس وجلسة الاتصال ثم حقن الأمر فوراً)
['send', 'sendto', 'write'].forEach(function(fn) {
    var ep = libc.findExportByName(fn);
    if (!ep) return;
    Interceptor.attach(ep, {
        onEnter: function(args) {
            if (sent) return;
            var fd = args[0].toInt32();
            var len = args[2].toInt32();
            if (len < 10 || len > 10000 || fd <= 3) return;

            try {
                var buf = args[1];
                var s0 = buf.add(len - 4).readU8();
                var s1 = buf.add(len - 3).readU8();
                var s2 = buf.add(len - 2).readU8();
                var s3 = buf.add(len - 1).readU8();
                var session = (((s0 << 24) | (s1 << 16) | (s2 << 8) | s3) >>> 0);

                if (session > 0 && session < 2000000000 && activeDesKey) {
                    sent = true;
                    foundFd = fd;
                    var nextSession = session + 1;

                    var packet = buildCmd(CMD, SUBCMD, DATA, nextSession, activeDesKey);
                    var r = sendPacket(fd, packet);

                    console.log("📤 أُرسل بنجاح! FD=" + fd + " | حجم=" + r + " بايت | session=" + nextSession + " | مشفر بـ DES ✓");
                    console.log("⏳ بانتظار رد السيرفر...\n");
                }
            } catch(e) {}
        }
    });
});

// 3. هوك استقبال الرد
['recv', 'recvfrom', 'read'].forEach(function(fn) {
    var ep = libc.findExportByName(fn);
    if (!ep) return;
    Interceptor.attach(ep, {
        onEnter: function(args) {
            this.buf = args[1];
            this.fd = args[0].toInt32();
        },
        onLeave: function(retval) {
            var len = retval.toInt32();
            if (len > 10 && waiting && sent) {
                tryShowResponse(this.buf, len);
            }
        }
    });
});

setTimeout(function() {
    if (waiting && sent) {
        console.log("⚠️ تم إرسال الطلب لكن لم يصل الرد خلال 20 ثانية. تحقق من live_sniffer.py");
    }
}, 20000);

console.log("[+] جاهز ✓\n");

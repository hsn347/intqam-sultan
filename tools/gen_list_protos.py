import sys
import os

with open('tools/disasm_init_heros.py', 'r', encoding='utf-8') as f:
    code = f.read()

# Replace the loop at the bottom
code = code.replace("for idx in [5, 8]:\n    p = main_proto['protos'][idx]\n    print(f\"=== PROTO {idx} (params={p['numparams']}, lines={p['line1']}-{p['line2']}) ===\")\n    print(\"Consts:\", p['consts'])\n    print(\"Locs:\", [x[0] for x in p['locs']])\n    print(disassemble(p))\n    print()", """
for idx, p in enumerate(main_proto['protos']):
    c_str = [str(c) for c in p['consts'] if isinstance(c, str)]
    print(f"Proto {idx}: lines {p['line1']}-{p['line2']}, params={p['numparams']}, consts={c_str}")
""")

with open('tools/list_protos.py', 'w', encoding='utf-8') as f:
    f.write(code)

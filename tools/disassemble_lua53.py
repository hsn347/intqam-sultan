import struct
import sys

class Lua53Bytecode:
    OPNAMES = [
        "MOVE", "LOADK", "LOADKX", "LOADBOOL", "LOADNIL",
        "GETUPVAL", "GETTABUP", "GETTABLE", "SETTABUP", "SETUPVAL",
        "SETTABLE", "NEWTABLE", "SELF", "ADD", "SUB",
        "MUL", "MOD", "POW", "DIV", "IDIV",
        "BAND", "BOR", "BXOR", "SHL", "SHR",
        "UNM", "BNOT", "NOT", "LEN", "CONCAT",
        "JMP", "EQ", "LT", "LE", "TEST",
        "TESTSET", "CALL", "TAILCALL", "RETURN", "FORLOOP",
        "FORPREP", "TFORCALL", "TFORLOOP", "SETLIST", "CLOSURE",
        "VARARG", "EXTRAARG"
    ]

    def __init__(self, data):
        self.data = data
        self.pos = 0

    def read_byte(self):
        b = self.data[self.pos]
        self.pos += 1
        return b

    def read_int(self):
        val = struct.unpack('<I', self.data[self.pos:self.pos+4])[0]
        self.pos += 4
        return val

    def read_integer(self):
        val = struct.unpack('<q', self.data[self.pos:self.pos+8])[0]
        self.pos += 8
        return val

    def read_number(self):
        val = struct.unpack('<d', self.data[self.pos:self.pos+8])[0]
        self.pos += 8
        return val

    def read_string(self):
        b = self.read_byte()
        if b == 0:
            return ""
        elif b <= 253:
            length = b - 1
        else: # 254
            length = struct.unpack('<Q', self.data[self.pos:self.pos+8])[0] - 1
            self.pos += 8
        s = self.data[self.pos:self.pos+length]
        self.pos += length
        return s.decode('utf-8', errors='replace')

    def parse_header(self):
        # 34 bytes header
        header = self.data[:34]
        self.pos = 34
        self.top_upval = self.read_byte()

    def parse_function(self, name="root"):
        fn = {'name': name}
        fn['source'] = self.read_string()
        fn['line_defined'] = self.read_int()
        fn['last_line_defined'] = self.read_int()
        fn['num_params'] = self.read_byte()
        fn['is_vararg'] = self.read_byte()
        fn['max_stack'] = self.read_byte()

        # Instructions
        num_code = self.read_int()
        fn['code'] = [self.read_int() for _ in range(num_code)]

        # Constants
        num_k = self.read_int()
        constants = []
        for _ in range(num_k):
            k_type = self.read_byte()
            if k_type == 0: # NIL
                constants.append(None)
            elif k_type == 1: # BOOL
                constants.append(bool(self.read_byte()))
            elif k_type == 3: # FLOAT
                constants.append(self.read_number())
            elif k_type == 0x13: # INTEGER
                constants.append(self.read_integer())
            elif k_type in (4, 0x14): # STRING
                constants.append(self.read_string())
            else:
                constants.append(f"UNK_{k_type}")
        fn['constants'] = constants

        # Upvalues
        num_upvals = self.read_int()
        upvals = []
        for _ in range(num_upvals):
            in_stack = self.read_byte()
            idx = self.read_byte()
            upvals.append((in_stack, idx))
        fn['upvals'] = upvals

        # Prototypes
        num_p = self.read_int()
        prototypes = []
        for i in range(num_p):
            prototypes.append(self.parse_function(f"{name}_p{i}"))
        fn['prototypes'] = prototypes

        # Debug lines
        num_lines = self.read_int()
        fn['lines'] = [self.read_int() for _ in range(num_lines)]

        # Debug locvars
        num_locvars = self.read_int()
        locvars = []
        for _ in range(num_locvars):
            varname = self.read_string()
            startpc = self.read_int()
            endpc = self.read_int()
            locvars.append((varname, startpc, endpc))
        fn['locvars'] = locvars

        # Debug upval names
        num_upval_names = self.read_int()
        fn['upval_names'] = [self.read_string() for _ in range(num_upval_names)]

        return fn

def find_functions_by_keyword(fn, kw):
    matches = []
    # check constants
    for k in fn['constants']:
        if isinstance(k, str) and kw.lower() in k.lower():
            matches.append((fn, k))
            break
    for p in fn['prototypes']:
        matches.extend(find_functions_by_keyword(p, kw))
    return matches

def disassemble_func(fn):
    lines = []
    lines.append(f"Function {fn['name']} (params={fn['num_params']}, stack={fn['max_stack']}, lines={fn['line_defined']}-{fn['last_line_defined']})")
    lines.append(f"  Constants: {fn['constants']}")
    loc_names = [f"{lv[0]}({lv[1]}-{lv[2]})" for lv in fn['locvars']]
    lines.append(f"  Locals: {loc_names}")
    lines.append(f"  Upvalues: {fn['upval_names']}")
    
    for pc, inst in enumerate(fn['code']):
        op = inst & 0x3F
        opname = Lua53Bytecode.OPNAMES[op] if op < len(Lua53Bytecode.OPNAMES) else f"OP_{op}"
        a = (inst >> 6) & 0xFF
        c = (inst >> 14) & 0x1FF
        b = (inst >> 23) & 0x1FF
        bx = (inst >> 14) & 0x3FFFF
        sbx = bx - 131071

        def k(idx):
            if idx & 0x100:
                cidx = idx & 0xFF
                if cidx < len(fn['constants']):
                    return f"K({repr(fn['constants'][cidx])})"
            return f"R({idx})"

        line_str = f"[{pc:03d}] {opname:<10}"
        if opname in ("GETTABUP", "SETTABUP"):
            line_str += f" A={a} Upval={b} Key={k(c)}"
        elif opname in ("GETTABLE", "SETTABLE", "ADD", "SUB", "MUL", "DIV", "EQ", "LT", "LE"):
            line_str += f" R({a}) R({b}) {k(c)}"
        elif opname == "SELF":
            line_str += f" R({a}) R({b}) {k(c)}"
        elif opname == "LOADK":
            kval = fn['constants'][bx] if bx < len(fn['constants']) else bx
            line_str += f" R({a}) {repr(kval)}"
        elif opname in ("CALL", "TAILCALL"):
            line_str += f" R({a}) args={b-1} rets={c-1}"
        elif opname in ("JMP", "FORLOOP", "FORPREP"):
            line_str += f" R({a}) pc={pc + 1 + sbx}"
        elif opname == "CLOSURE":
            line_str += f" R({a}) proto={bx}"
        else:
            line_str += f" A={a} B={b} C={c} Bx={bx} sBx={sbx}"
        lines.append(f"  {line_str}")
    return "\n".join(lines)

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f:
        data = f.read()
    bc = Lua53Bytecode(data)
    bc.parse_header()
    root = bc.parse_function()
    print("Parsed root function successfully! Prototypes:", len(root['prototypes']))
    
    # search for autoFillHeros
    matches = find_functions_by_keyword(root, "autoFillHeros")
    print(f"Found {len(matches)} matches for 'autoFillHeros':")
    for fn, k in matches:
        print(f"--- Matched: {k} in {fn['name']} ---")
        print(disassemble_func(fn))
        print()

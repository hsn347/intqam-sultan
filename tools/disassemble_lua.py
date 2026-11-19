import struct
import sys

class Lua51Disassembler:
    OPCODES = [
        "MOVE", "LOADK", "LOADBOOL", "LOADNIL", "GETUPVAL",
        "GETGLOBAL", "GETTABLE", "SETGLOBAL", "SETUPVAL", "SETTABLE",
        "NEWTABLE", "SELF", "ADD", "SUB", "MUL",
        "DIV", "MOD", "POW", "UNM", "NOT",
        "LEN", "CONCAT", "JMP", "EQ", "LT",
        "LE", "TEST", "TESTSET", "CALL", "TAILCALL",
        "RETURN", "FORLOOP", "FORPREP", "TFORLOOP", "SETLIST",
        "CLOSE", "CLOSURE", "VARARG"
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

    def read_size_t(self):
        # usually 4 or 8
        if self.size_size_t == 4:
            return self.read_int()
        elif self.size_size_t == 8:
            val = struct.unpack('<Q', self.data[self.pos:self.pos+8])[0]
            self.pos += 8
            return val

    def read_number(self):
        val = struct.unpack('<d', self.data[self.pos:self.pos+8])[0]
        self.pos += 8
        return val

    def read_string(self):
        length = self.read_size_t()
        if length == 0:
            return ""
        s = self.data[self.pos:self.pos+length-1] # strip null
        self.pos += length
        return s.decode('utf-8', errors='replace')

    def parse_header(self):
        magic = self.data[self.pos:self.pos+4]
        assert magic == b'\x1bLua', f"Invalid magic: {magic}"
        self.pos += 4
        version = self.read_byte()
        assert version == 0x51, f"Not Lua 5.1: {hex(version)}"
        format_version = self.read_byte()
        endianness = self.read_byte()
        self.size_int = self.read_byte()
        self.size_size_t = self.read_byte()
        self.size_instruction = self.read_byte()
        self.size_lua_number = self.read_byte()
        integral = self.read_byte()

    def parse_function(self, parent_name=""):
        fn = {}
        fn['source'] = self.read_string()
        fn['line_defined'] = self.read_int()
        fn['last_line_defined'] = self.read_int()
        fn['num_upvalues'] = self.read_byte()
        fn['num_params'] = self.read_byte()
        fn['is_vararg'] = self.read_byte()
        fn['max_stack'] = self.read_byte()

        # Instructions
        num_code = self.read_int()
        code = []
        for _ in range(num_code):
            code.append(self.read_int())
        fn['code'] = code

        # Constants
        num_k = self.read_int()
        constants = []
        for _ in range(num_k):
            k_type = self.read_byte()
            if k_type == 0: # NIL
                constants.append(None)
            elif k_type == 1: # BOOLEAN
                constants.append(bool(self.read_byte()))
            elif k_type == 3: # NUMBER
                constants.append(self.read_number())
            elif k_type == 4: # STRING
                constants.append(self.read_string())
            else:
                constants.append(f"UNKNOWN_{k_type}")
        fn['constants'] = constants

        # Inner prototypes
        num_p = self.read_int()
        prototypes = []
        for i in range(num_p):
            prototypes.append(self.parse_function(f"{parent_name}_{i}"))
        fn['prototypes'] = prototypes

        # Debug lines
        num_lines = self.read_int()
        lines = [self.read_int() for _ in range(num_lines)]
        fn['lines'] = lines

        # Debug locals
        num_locals = self.read_int()
        locals_list = []
        for _ in range(num_locals):
            name = self.read_string()
            s_pc = self.read_int()
            e_pc = self.read_int()
            locals_list.append((name, s_pc, e_pc))
        fn['locals'] = locals_list

        # Debug upvalues
        num_upval_names = self.read_int()
        upvals = [self.read_string() for _ in range(num_upval_names)]
        fn['upvalues'] = upvals

        return fn

def format_func(fn, name="root", depth=0):
    indent = "  " * depth
    lines_out = []
    lines_out.append(f"{indent}FUNCTION {name} (lines {fn['line_defined']}-{fn['last_line_defined']}, params={fn['num_params']}, stack={fn['max_stack']})")
    lines_out.append(f"{indent}  Constants: {fn['constants']}")
    
    # decode instructions
    for pc, inst in enumerate(fn['code']):
        opcode = inst & 0x3F
        opname = Lua51Disassembler.OPCODES[opcode] if opcode < len(Lua51Disassembler.OPCODES) else f"OP_{opcode}"
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

        line_info = f"line {fn['lines'][pc]}" if pc < len(fn['lines']) else ""
        if opname in ("LOADK",):
            k_val = repr(fn['constants'][bx]) if bx < len(fn['constants']) else bx
            inst_str = f"{opname:<10} R({a}) {k_val}"
        elif opname in ("GETGLOBAL", "SETGLOBAL"):
            k_val = repr(fn['constants'][bx]) if bx < len(fn['constants']) else bx
            inst_str = f"{opname:<10} R({a}) {k_val}"
        elif opname in ("GETTABLE", "SELF"):
            inst_str = f"{opname:<10} R({a}) R({b}) {k(c)}"
        elif opname in ("SETTABLE", "ADD", "SUB", "MUL", "DIV", "EQ", "LT", "LE"):
            inst_str = f"{opname:<10} R({a}) {k(b)} {k(c)}"
        elif opname in ("JMP", "FORLOOP", "FORPREP"):
            inst_str = f"{opname:<10} R({a}) pc={pc + 1 + sbx}"
        elif opname in ("CALL", "TAILCALL"):
            inst_str = f"{opname:<10} R({a}) args={b-1} rets={c-1}"
        else:
            inst_str = f"{opname:<10} A={a} B={b} C={c} Bx={bx} sBx={sbx}"

        lines_out.append(f"{indent}  [{pc:03d} {line_info}] {inst_str}")

    for i, proto in enumerate(fn['prototypes']):
        lines_out.append(format_func(proto, f"{name}_proto{i}", depth + 1))

    return "\n".join(lines_out)

if __name__ == '__main__':
    filepath = sys.argv[1]
    with open(filepath, 'rb') as f:
        data = f.read()
    dis = Lua51Disassembler(data)
    dis.parse_header()
    root = dis.parse_function()
    out = format_func(root)
    if len(sys.argv) > 2:
        with open(sys.argv[2], 'w', encoding='utf-8') as f:
            f.write(out)
        print(f"Disassembly written to {sys.argv[2]}")
    else:
        print(out[:2000])

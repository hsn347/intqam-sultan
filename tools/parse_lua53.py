import struct
import sys

class Lua53Reader:
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
        magic = self.data[self.pos:self.pos+4]
        assert magic == b'\x1bLua'
        self.pos += 4
        self.version = self.read_byte()
        self.format_ver = self.read_byte()
        self.data_conv = self.data[self.pos:self.pos+6]
        self.pos += 6
        self.int_size = self.read_byte()
        self.sizet_size = self.read_byte()
        self.inst_size = self.read_byte()
        self.integer_size = self.read_byte()
        self.number_size = self.read_byte()
        test_int = self.read_integer()
        test_num = self.read_number()
        self.top_upvalues = self.read_byte()

    def parse_function(self):
        fn = {}
        fn['source'] = self.read_string()
        fn['line_defined'] = self.read_int()
        fn['last_line_defined'] = self.read_int()
        fn['num_params'] = self.read_byte()
        fn['is_vararg'] = self.read_byte()
        fn['max_stack'] = self.read_byte()

        # Instructions
        num_code = self.read_int()
        code = [self.read_int() for _ in range(num_code)]
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
            elif k_type == 3: # FLOAT
                constants.append(self.read_number())
            elif k_type == 0x13: # INTEGER (19)
                constants.append(self.read_integer())
            elif k_type in (4, 0x14): # SHORT/LONG STRING
                constants.append(self.read_string())
            else:
                constants.append(f"UNKNOWN_{k_type}")
        fn['constants'] = constants

        # Upvalues
        num_upvalues = self.read_int()
        upvals = []
        for _ in range(num_upvalues):
            in_stack = self.read_byte()
            idx = self.read_byte()
            upvals.append((in_stack, idx))
        fn['upvals'] = upvals

        # Prototypes
        num_p = self.read_int()
        prototypes = [self.parse_function() for _ in range(num_p)]
        fn['prototypes'] = prototypes

        # Debug lineinfo
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

        # Debug upvalue names
        num_upval_names = self.read_int()
        fn['upval_names'] = [self.read_string() for _ in range(num_upval_names)]

        return fn

def dump_functions(fn, path="root"):
    str_k = [k for k in fn['constants'] if isinstance(k, str)]
    loc_names = [lv[0] for lv in fn['locvars']]
    print(f"=== Function {path} (params={fn['num_params']}, stack={fn['max_stack']}, lines={fn['line_defined']}-{fn['last_line_defined']}) ===")
    print(f"  Constants: {fn['constants'][:20]}")
    if loc_names:
        print(f"  Locals: {loc_names}")
    for i, p in enumerate(fn['prototypes']):
        dump_functions(p, f"{path}_{i}")

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f:
        data = f.read()
    r = Lua53Reader(data)
    r.parse_header()
    root = r.parse_function()
    dump_functions(root)

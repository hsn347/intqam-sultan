import struct

with open(r'game_file\src_bytecode\app\module\hero\heroCtrl.lua', 'rb') as f:
    buf = f.read()

class LuaParser:
    def __init__(self, data):
        self.data = data
        self.pos = 0

    def read_byte(self):
        b = self.data[self.pos]
        self.pos += 1
        return b

    def read_int(self):
        v = struct.unpack_from('<I', self.data, self.pos)[0]
        self.pos += 4
        return v

    def read_size_t(self):
        return self.read_int()

    def read_number(self):
        v = struct.unpack_from('<d', self.data, self.pos)[0]
        self.pos += 8
        return v

    def read_string(self):
        size = self.read_size_t()
        if size == 0:
            return None
        s = self.data[self.pos:self.pos+size-1]
        self.pos += size
        return s.decode('latin1', errors='ignore')

    def parse_function(self):
        fn = {}
        fn['source'] = self.read_string()
        fn['lineDefined'] = self.read_int()
        fn['lastLineDefined'] = self.read_int()
        fn['numUpvalues'] = self.read_byte()
        fn['numParams'] = self.read_byte()
        fn['isVararg'] = self.read_byte()
        fn['maxStackSize'] = self.read_byte()
        
        sizecode = self.read_int()
        fn['code'] = [self.read_int() for _ in range(sizecode)]
        
        sizek = self.read_int()
        constants = []
        for _ in range(sizek):
            t = self.read_byte()
            if t == 0:
                constants.append(None)
            elif t == 1:
                constants.append(self.read_byte() != 0)
            elif t == 3:
                constants.append(self.read_number())
            elif t == 4:
                constants.append(self.read_string())
            else:
                constants.append(f'type_{t}')
        fn['constants'] = constants
        
        sizep = self.read_int()
        fn['prototypes'] = [self.parse_function() for _ in range(sizep)]
        
        sizelineinfo = self.read_int()
        fn['lineinfo'] = [self.read_int() for _ in range(sizelineinfo)]
        
        sizelocvars = self.read_int()
        locvars = []
        for _ in range(sizelocvars):
            varname = self.read_string()
            startpc = self.read_int()
            endpc = self.read_int()
            locvars.append((varname, startpc, endpc))
        fn['locvars'] = locvars
        
        sizeup = self.read_int()
        fn['upvalues'] = [self.read_string() for _ in range(sizeup)]
        return fn

p = LuaParser(buf[12:])
top = p.parse_function()
print(f"Top level prototypes: {len(top['prototypes'])}")

for i, proto in enumerate(top['prototypes']):
    consts = [str(c) for c in proto['constants']]
    if any('palace' in c.lower() for c in consts):
        ld = proto['lineDefined']
        lld = proto['lastLineDefined']
        np = proto['numParams']
        print(f"Proto {i}: lines {ld}-{lld}, params={np}")
        print("  Constants:", proto['constants'])
        print("  Locvars:", [lv[0] for lv in proto['locvars']])

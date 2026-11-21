import struct

def parse_lua_string(f):
    size_bytes = f.read(4)
    if not size_bytes:
        return None
    size = struct.unpack('<I', size_bytes)[0]
    if size == 0:
        return ""
    s = f.read(size)
    return s[:-1].decode('utf-8', errors='ignore')

def parse_function(f, depth=0):
    source_name = parse_lua_string(f)
    line_defined = struct.unpack('<I', f.read(4))[0]
    last_line_defined = struct.unpack('<I', f.read(4))[0]
    num_upvalues = ord(f.read(1))
    num_params = ord(f.read(1))
    is_vararg = ord(f.read(1))
    max_stack_size = ord(f.read(1))
    
    # instructions
    num_instructions = struct.unpack('<I', f.read(4))[0]
    instructions = [struct.unpack('<I', f.read(4))[0] for _ in range(num_instructions)]
    
    # constants
    num_constants = struct.unpack('<I', f.read(4))[0]
    constants = []
    for _ in range(num_constants):
        const_type = ord(f.read(1))
        if const_type == 0: # LUA_TNIL
            constants.append(None)
        elif const_type == 1: # LUA_TBOOLEAN
            val = ord(f.read(1)) != 0
            constants.append(val)
        elif const_type == 3: # LUA_TNUMBER
            val = struct.unpack('<d', f.read(8))[0]
            constants.append(val)
        elif const_type == 4: # LUA_TSTRING
            val = parse_lua_string(f)
            constants.append(val)
        else:
            constants.append(f"UNKNOWN_{const_type}")
            
    # prototypes (inner functions)
    num_prototypes = struct.unpack('<I', f.read(4))[0]
    prototypes = []
    for _ in range(num_prototypes):
        prototypes.append(parse_function(f, depth + 1))
        
    # debug info
    line_info_size = struct.unpack('<I', f.read(4))[0]
    f.read(line_info_size * 4)
    
    loc_vars_size = struct.unpack('<I', f.read(4))[0]
    for _ in range(loc_vars_size):
        parse_lua_string(f)
        f.read(8) # start_pc, end_pc
        
    upvalues_size = struct.unpack('<I', f.read(4))[0]
    for _ in range(upvalues_size):
        parse_lua_string(f)
        
    return {
        "source": source_name,
        "line_defined": line_defined,
        "last_line_defined": last_line_defined,
        "num_params": num_params,
        "constants": constants,
        "instructions": instructions,
        "prototypes": prototypes
    }

def print_fn(fn, name="root", depth=0):
    indent = "  " * depth
    consts_str = ", ".join([repr(c) for c in fn["constants"] if isinstance(c, str)])
    print(f"{indent}[FN {name}] lines {fn['line_defined']}-{fn['last_line_defined']}, params={fn['num_params']}, consts=[{consts_str[:120]}]")
    for i, proto in enumerate(fn["prototypes"]):
        print_fn(proto, f"{name}.proto_{i}", depth + 1)

with open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
    header = f.read(12)
    root = parse_function(f)
    print_fn(root)

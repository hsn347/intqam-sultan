import ast
import json

with open("tasks/building.py", "r", encoding="utf-8") as f:
    source = f.read()

tree = ast.parse(source, filename="tasks/building.py")

calls = []
for node in ast.walk(tree):
    if isinstance(node, ast.Call):
        func = node.func
        if (isinstance(func, ast.Attribute) and func.attr == "safe_query") or (isinstance(func, ast.Name) and func.id == "safe_query"):
            calls.append(node)

# Sort by line number
calls.sort(key=lambda x: x.lineno)

print(f"Total safe_query calls found via AST: {len(calls)}")
for idx, c in enumerate(calls, 1):
    args = [ast.unparse(a) for a in c.args]
    kwargs = {k.arg: ast.unparse(k.value) for k in c.keywords}
    cmd = args[0] if len(args) > 0 else kwargs.get("cmd")
    subcmd = args[1] if len(args) > 1 else kwargs.get("subcmd")
    payload = args[2] if len(args) > 2 else kwargs.get("data")
    print(f"Call #{idx} (Line {c.lineno}):")
    print(f"  CMD: {cmd}")
    print(f"  SubCMD: {subcmd}")
    print(f"  Payload: {payload}")
    print(f"  min_delay: {kwargs.get('min_delay')}")
    print(f"  max_delay: {kwargs.get('max_delay')}")
    print("-" * 50)

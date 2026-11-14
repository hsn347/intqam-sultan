import re

line1 = "_ENV, (nil)[1], (nil).costWEs, _ENV, (nil).costTools, (nil)[1] = nil, nil, nil, nil, nil, 300501"
line2 = "_ENV, (nil)[1], (nil).costWEs, _ENV, (nil).costTools, (nil)[2] = nil, nil, nil, nil, nil, 1"

pattern = r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)'

m1 = re.search(pattern, line1)
m2 = re.search(pattern, line2)

print("m1:", m1.groups() if m1 else None)
print("m2:", m2.groups() if m2 else None)

import sys
import os
import json

sys.path.insert(0, 'E:/osmanli/tasks')
import march_capacity

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

# Run osmanli function on beetoo2
cap2_base = march_capacity.get_castle_base_march_capacity(d2)
print("Osmanli beetoo2 base:", cap2_base)

# With beetoo2 top heroes (1712, 1717, 1700, 1711, 1707)
cap2_all = march_capacity.get_castle_march_capacity(d2, [1712, 1717, 1700, 1711, 1707])
print("Osmanli beetoo2 with heroes:", cap2_all)

# Run osmanli function on beetoo1
cap1_base = march_capacity.get_castle_base_march_capacity(d1)
print("Osmanli beetoo1 base:", cap1_base)

# With beetoo1 top heroes (1717, 1711, 1710, 1704, 1718)
cap1_all = march_capacity.get_castle_march_capacity(d1, [1717, 1711, 1710, 1704, 1718])
print("Osmanli beetoo1 with heroes:", cap1_all)

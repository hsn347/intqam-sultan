# -*- coding: utf-8 -*-
"""
tools/test_wonder_merchant_balance.py — اختبار قراءة أرصدة الموارد الحرة والآمنة في التاجر العجيب
"""

import sys
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from tasks.wonder_merchant import WonderMerchantTask

class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        self.is_connected = True

def main():
    mock_init = {
        "cityCtrl": {
            "resList": {"1002": "62221", "1003": "100000"},
            "saferes": {"1002": 450000, "1003": 50000},
        },
        "lordInfoCtrl": {
            "base": {"gold": 1000}
        }
    }

    task = WonderMerchantTask(MockConn(mock_init), log_func=print)

    # 1. Test wheat balance (should be 62,221 + 450,000 = 512,221)
    wheat_bal = task._get_resource_balance(1002)
    print(f"Wheat balance: {wheat_bal:,.0f}")
    assert wheat_bal == 512221.0, f"Expected 512,221, got {wheat_bal}"

    # 2. Test gold balance
    gold_bal = task._get_resource_balance(1001)
    print(f"Gold balance: {gold_bal}")
    assert gold_bal == 1000.0, f"Expected 1000, got {gold_bal}"

    print("\n✓ SUCCESS: Wonder merchant resource balance correctly includes both free and safe resources without zeroing out!")

if __name__ == "__main__":
    main()

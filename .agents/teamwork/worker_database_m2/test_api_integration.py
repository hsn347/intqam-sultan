# -*- coding: utf-8 -*-
"""
End-to-End API Integration & Validation Test
Verifies ForgeEquipmentConfig and CastleConfigModel behavior within api_server
"""

import sys
import os

sys.path.insert(0, r"e:\intqam-sultan")

if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

from api_server import ForgeEquipmentConfig, CastleConfigModel, CastleUpdateRequest

def run_tests():
    print("=== Running API Whitelist & Schema Tests ===")

    # Test 1: Defaults
    m1 = ForgeEquipmentConfig()
    assert m1.enabled is False, "Default enabled should be False"
    assert m1.category == "weapon", "Default category should be 'weapon'"
    print("[PASS] Test 1: Default ForgeEquipmentConfig values")

    # Test 2: All 6 valid categories
    valid_categories = ["weapon", "clothes", "helmet", "trousers", "shoes", "ring"]
    for cat in valid_categories:
        m = ForgeEquipmentConfig(enabled=True, category=cat)
        assert m.enabled is True
        assert m.category == cat
    print(f"[PASS] Test 2: Valid categories verified: {valid_categories}")

    # Test 3: Category normalization
    assert ForgeEquipmentConfig(category="  RING  ").category == "ring"
    assert ForgeEquipmentConfig(category="CLOTHES").category == "clothes"
    assert ForgeEquipmentConfig(category="HELMET ").category == "helmet"
    assert ForgeEquipmentConfig(category="trousers").category == "trousers"
    assert ForgeEquipmentConfig(category="SHOES").category == "shoes"
    print("[PASS] Test 3: Normalization for casing and whitespace")

    # Test 4: Invalid and None fallbacks
    assert ForgeEquipmentConfig(category="unknown_category").category == "weapon"
    assert ForgeEquipmentConfig(category=None).category == "weapon"
    assert ForgeEquipmentConfig(category="").category == "weapon"
    print("[PASS] Test 4: Fallbacks to 'weapon' on invalid/None inputs")

    # Test 5: CastleConfigModel integration
    cfg_data = {
        "forge_equipment": {
            "enabled": True,
            "category": "helmet"
        }
    }
    ccm = CastleConfigModel(**cfg_data)
    assert ccm.forge_equipment is not None
    assert ccm.forge_equipment.enabled is True
    assert ccm.forge_equipment.category == "helmet"

    dumped = ccm.model_dump(exclude_none=True)
    assert "forge_equipment" in dumped
    assert dumped["forge_equipment"] == {"enabled": True, "category": "helmet"}
    print("[PASS] Test 5: CastleConfigModel model_dump includes forge_equipment")

    # Test 6: CastleUpdateRequest integration
    req = CastleUpdateRequest(
        castle_name="Updated Castle",
        config=CastleConfigModel(forge_equipment={"enabled": True, "category": "ring"})
    )
    req_dumped = req.config.model_dump(exclude_none=True)
    assert "forge_equipment" in req_dumped
    assert req_dumped["forge_equipment"] == {"enabled": True, "category": "ring"}
    print("[PASS] Test 6: CastleUpdateRequest passes through forge_equipment")

    # Test 7: update_castle clean_config simulation
    existing_db_config = {
        "fountain": {"enabled": True},
        "train": {"enabled": False},
        "forge_equipment": {"enabled": False, "category": "weapon"}
    }
    clean_config = dict(existing_db_config)
    clean_config.pop("pet_patrol", None)
    clean_config.update(req_dumped)

    assert clean_config["forge_equipment"] == {"enabled": True, "category": "ring"}
    assert clean_config["fountain"] == {"enabled": True}
    assert clean_config["train"] == {"enabled": False}
    print("[PASS] Test 7: clean_config update simulation preserved other keys and updated forge_equipment")

    print("\nALL 7 TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    run_tests()

import json

accounts = ['beetoo1', 'beetoo3', 'lucifer']
controllers_to_check = [
    'equipmentCtrl',
    'militaryRankCtrl',
    'parliamentCtrl',
    'allianceCtrl',
    'atlantisPrivilegeCtrl',
    'exoticPavilionCtrl',
    'magicLampCtrl',
    'guardianCtrl',
    'dressCtrl',
    'heroSysCtrl',
    'godArmsCtrl',
    'godArmsRuneCtrl',
    'petCtrl',
    'warGemCtrl',
    'playerKingdomLevelCtrl',
    'nebulaTowerCtrl',
    'heroBiographyCtrl',
    'miraculousWeaponCtrl'
]

for acc in accounts:
    path = f'docs/{acc}_live_memory.json'
    with open(path, 'r', encoding='utf-8') as f:
        d = json.load(f)
    print(f"\n==================== {acc} ====================")
    for c in controllers_to_check:
        val = d.get(c)
        if val:
            print(f"[{c}]: present, type={type(val).__name__}, keys={list(val.keys()) if isinstance(val, dict) else len(val)}")
            # If military rank
            if c == 'militaryRankCtrl':
                print("   militaryRankCtrl:", val)
            if c == 'parliamentCtrl':
                print("   parliamentCtrl:", val)
            if c == 'atlantisPrivilegeCtrl':
                print("   atlantisPrivilegeCtrl:", val)
            if c == 'exoticPavilionCtrl':
                print("   exoticPavilionCtrl:", val)
            if c == 'magicLampCtrl':
                print("   magicLampCtrl:", val)

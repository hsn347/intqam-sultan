local constantRead = include("constantRead")
local _ENV, windTowerDef = "constantRead", "constantRead"
windTowerDef.NEED_NUM = constantRead.getConstValue("LOST_RUINS_SUMMON_ITEM_NUM", 5)
windTowerDef.MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
windTowerDef.MAX_SURVEYNUM = constantRead.getConstValue("LOST_RUINS_MAX_SURVEYED_NUM", 20)
windTowerDef.HP_MIN_SURVEY_NEED = constantRead.getConstValue("LOST_RUINS_MIN_SURVEYED_HP", 1)
windTowerDef.CD_TIME = 1800
return windTowerDef

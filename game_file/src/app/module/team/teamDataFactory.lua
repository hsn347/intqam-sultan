local _ENV, teamDataFactory
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
_ENV = nil
;(nil)[teamAreaEnum.RUINS] = "teamDataRemains"
;(nil)[teamAreaEnum.LEGEND_LORD] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_LORD_FOR_SEP] = "teamDataKingStar"
;(nil)[teamAreaEnum.LEGEND_LORD_9001646] = "teamDataKingStar"
;(nil)[teamAreaEnum.LEGEND_LORD_9001647] = "teamDataKingStar"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_1] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_2] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_3] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_4] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_5] = "teamDataLegend"
;(nil)[teamAreaEnum.LEGEND_HEGEMON_6] = "teamDataLegend"
;(nil)[teamAreaEnum.NEBULA_WAR] = "teamDataNebula"
;(nil)[teamAreaEnum.NEBULA_EMPEROR] = "teamDataNebulaEmperor"
local (nil)[teamAreaEnum.NEBULA_ALL_STAR], teamFactoryData = "teamDataNebulaAllStar", nil
function teamDataFactory:createTeamData(teamType)
	local factory = teamFactoryData[teamType]
	factory = factory or "teamDataBase"
	return include(factory).new(teamType)
end
return teamDataFactory

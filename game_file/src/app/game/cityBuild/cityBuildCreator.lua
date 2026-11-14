local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBase = include("cityBuildBase")
local cityBuildCastle = include("cityBuildCastle")
local cityBuildDepot = include("cityBuildDepot")
local cityBuildEmbassy = include("cityBuildEmbassy")
local cityBuildMarket = include("cityBuildMarket")
local cityBuildCollege = include("cityBuildCollege")
local cityBuildWishingWell = include("cityBuildWishingWell")
local cityBuildBlackSmith = include("cityBuildBlackSmith")
local cityBuildStables = include("cityBuildStables")
local cityBuildRange = include("cityBuildRange")
local cityBuildChariotPlant = include("cityBuildChariotPlant")
local cityBuildBarracks = include("cityBuildBarracks")
local cityBuildFortress = include("cityBuildFortress")
local cityBuildDrillGround = include("cityBuildDrillGround")
local cityBuildHallOfWar = include("cityBuildHallOfWar")
local cityBuildFarm = include("cityBuildFarm")
local cityBuildSawMill = include("cityBuildSawMill")
local cityBuildIronMine = include("cityBuildIronMine")
local cityBuildSteel = include("cityBuildSteel")
local cityBuildMilitaryTent = include("cityBuildMilitaryTent")
local cityBuildHosptial = include("cityBuildHosptial")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildWall = include("cityBuildWall")
local cityBuildTurret = include("cityBuildTurret")
local cityBuildWatchTower = include("cityBuildWatchTower")
local cityBuildLeisureCenter = include("cityBuildLeisureCenter")
local cityBuildMaterialWorkShop = include("cityBuildMaterialWorkShop")
local cityBuildHuoChuang = include("cityBuildHuoChuang")
local cityBuildPetCenter = include("cityBuildPetCenter")
local cityBuildElitePalace = include("cityBuildElitePalace")
local cityBuildMiracle = include("cityBuildMiracle")
local cityBuildResurrectionHall = include("cityBuildResurrectionHall")
local cityBuildCrystalMine = include("cityBuildCrystalMine")
local cityBuildServiceCenter = include("cityBuildServiceCenter")
local cityBuildEpicBattle = include("cityBuildEpicBattle")
local cityBuildTrainHall = include("cityBuildTrainHall")
local cityBuildPrison = include("cityBuildPrison")
local cityBuildStarBraveStatue = include("cityBuildStarBraveStatue")
local CBD = require_data("city_build_config")
local cityBuildMonument = include("cityBuildMonument")
local cityBuildNebulaHall = include("cityBuildNebulaHall")
local cityBuildMagicLamp = include("cityBuildMagicLamp")
local cityBuildGarden = include("cityBuildGarden")
local _ENV, cityBuildCreator = "cityBuildGarden", "cityBuildGarden"
function cityBuildCreator:createBuild(bid, viewNode, basePos)
	local uiType = self:getBuildCreateType(bid)
	return self:createBuildByType(bid, uiType, viewNode, basePos)
end
function cityBuildCreator:createBuildByType(bid, uiType, viewNodes, basePos)
	if uiType == cityBuildConstDef.uiType.UI_TYPE_ALONE then
		return self:createBuild_Alone(bid)
	elseif uiType == cityBuildConstDef.uiType.UI_TYPE_RELYON then
		return self:createBuild_Relyon(bid, viewNodes, basePos)
	else
		print("cityBuildCreator:createBuildByType: Not defined: uiType = ", uiType)
	end
end
function cityBuildCreator:createBuild_Alone(bid)
	local cityBuildClass = self:getBuildClass(bid)
	local cityBuildNode = cityBuildClass.new()
	cityBuildNode:initWithUIType(bid, cityBuildConstDef.uiType.UI_TYPE_ALONE)
	cityBuildNode:setBuildBid(bid)
	cityBuildNode:loadView()
	return cityBuildNode
end
function cityBuildCreator:createBuild_Relyon(bid, viewNodes, basePos)
	print("create bid = ", bid)
	local cityBuildClass = self:getBuildClass(bid)
	local cityBuildNode = cityBuildClass.new()
	cityBuildNode:initWithUIType(bid, cityBuildConstDef.uiType.UI_TYPE_RELYON, viewNodes, basePos)
	cityBuildNode:setBuildBid(bid)
	cityBuildNode:loadView()
	return cityBuildNode
end
_ENV, cityBuildCreator.createBuildTop = function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end, function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.CASTLE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.DEPOT)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.EMBASSY)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.COLLEGE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.WISHING_WELL)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.BLACK_SMITH)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.STABLES)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.RANGE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.CHARIOT_PLANT)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.BARRACKS)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.FORTRESS)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.DRILL_GROUDS)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.HALL_OF_WAR)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.WALLS)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.TURRET)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.WATCH_TOWER)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.MARKET)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.FARM)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.SAWMILL)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.IRON_MINE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.CRYSTAL_MINE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.STEEL)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.MILITARY_TENT)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.HOSTPITAL)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.MATERIAL_WORKSHOP)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(cityBuildConstDef.fixedBuildDef.LeisureCenter)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(cityBuildConstDef.fixedBuildDef.HuoChuang)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(cityBuildConstDef.fixedBuildDef.ResurrectionHall)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(cityBuildConstDef.fixedBuildDef.ServiceCenter)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(cityBuildConstDef.fixedBuildDef.EpicBattle)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.MIRACLE)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.HERO_TRAIN_GROUND)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.HERO_PRISON)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
;(function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.MONUMENT)] = cityBuildConstDef.uiType.UI_TYPE_ALONE
local (function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end)[tostring(BUILDID.NEBULA_PALACE)], tblCityBuildCreateType = cityBuildConstDef.uiType.UI_TYPE_ALONE, function(self, topType, viewNodes, basePos)
	local cityBuildTop = include("cityBuildTop")
	local cityBuildTopNode = cityBuildTop.new()
	cityBuildTopNode:initWithTopType(topType, viewNodes, basePos)
	return cityBuildTopNode
end
function cityBuildCreator:getBuildClass(bid)
	local baseData = CBD.data[bid]
	if baseData and baseData.aliasName then
		local cityBuildClass = include("cityBuild" .. baseData.aliasName)
		if nil ~= cityBuildClass then
			return cityBuildClass
		end
	end
	return cityBuildBaseEntity
end
function cityBuildCreator:getBuildCreateType(bid)
	local uiType = tblCityBuildCreateType[tostring(bid)]
	uiType = uiType or cityBuildConstDef.uiType.UI_TYPE_ALONE
	return uiType
end
return cityBuildCreator

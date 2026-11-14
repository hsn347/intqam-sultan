local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local mainCityDefine = include("mainCityDefine")
local mainCityFunctions = include("mainCityFunctions")
local cityBuildViewDef = include("cityBuildViewDef")
local mainCityNightCommonSkinBzt = class("mainCityNightCommonSkinBzt", function()
	if RAMADAN_SWITCH then
		return cc.CSLoader:createNode(getCCSPath("mainCityNightSixthBzt"))
	else
		return cc.CSLoader:createNode(getCCSPath("mainCityNightCommonBzt"))
	end
end)
function mainCityNightCommonSkinBzt:ctor()
	self.Node_night_common = SoraDGetChildByName(self, "Node_night_common")
	self:showLightAction()
end
function mainCityNightCommonSkinBzt:showLightAction()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	local fadeIn = math.random(100, 150) / 100
	local fadeOut = math.random(80, 160) / 100
	local delay = math.random(50, 100) / 100
	for k, v in ipairs(self.Node_night_common:getChildren()) do
		v:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_COMMON)
		v:setLocalZOrder(k)
		_ENV = k
		k.fadeIn = fadeIn
		k.fadeOut = fadeOut
		k.delay = delay
		k.beginOpacity = 0.6
		k.endOpacity = 1
		SoraDFadeINOUT(v, k)
	end
end
function mainCityNightCommonSkinBzt:checkSpecial()
end
return mainCityNightCommonSkinBzt

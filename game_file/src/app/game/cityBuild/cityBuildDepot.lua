local cityBuildDepot = class("cityBuildDepot", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildDepot:ctor()
end
function cityBuildDepot:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_105"), i18n("buildDes_name_105")
	i18n("buildDes_name_105").x = 0
	;(nil).pos, i18n("buildDes_name_105").y = i18n("buildDes_name_105"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildDepot:isCustomIdle()
	local isIdle = true
	local gametop = gModuleMgr.getObject("gametop")
	local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
	local freeTime = allianceTreasureCtrl:getNextFreeTime()
	if freeTime <= 0 then
		isIdle = false
	end
	return isIdle
end
return cityBuildDepot

local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildHuoChuang = class("cityBuildHuoChuang", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildHuoChuang:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.HuoChuang)
	self.bid = cityBuildConstDef.fixedBuildDef.HuoChuang
end
function cityBuildHuoChuang:onMessageListener()
	self:updateView()
end
function cityBuildHuoChuang:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("common_text_2478"), i18n("common_text_2478")
	i18n("common_text_2478").x = 20
	;(nil).pos, i18n("common_text_2478").y = i18n("common_text_2478"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildHuoChuang:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildHuoChuang:updateView()
	print("TODO: 货船建筑更新--------")
end
return cityBuildHuoChuang

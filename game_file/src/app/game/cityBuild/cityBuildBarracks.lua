local buildLogic = include("buildLogic")
local armyLogic = include("armyLogic")
local armyDes = include("armyDesRead")
local cityBuildBarracks = class("cityBuildBarracks", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildBarracks:ctor()
end
function cityBuildBarracks:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_119"), i18n("buildDes_name_119")
	i18n("buildDes_name_119").x = 0
	;(nil).pos, i18n("buildDes_name_119").y = i18n("buildDes_name_119"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildBarracks

local buildLogic = include("buildLogic")
local cityBuildChariotPlant = class("cityBuildChariotPlant", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildChariotPlant:ctor()
end
function cityBuildChariotPlant:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_118"), i18n("buildDes_name_118")
	i18n("buildDes_name_118").x = 0
	;(nil).pos, i18n("buildDes_name_118").y = i18n("buildDes_name_118"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildChariotPlant

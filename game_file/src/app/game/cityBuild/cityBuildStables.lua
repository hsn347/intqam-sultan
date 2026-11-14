local buildLogic = include("buildLogic")
local cityBuildStables = class("cityBuildStables", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildStables:ctor()
end
function cityBuildStables:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_116"), i18n("buildDes_name_116")
	i18n("buildDes_name_116").x = 0
	;(nil).pos, i18n("buildDes_name_116").y = i18n("buildDes_name_116"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildStables

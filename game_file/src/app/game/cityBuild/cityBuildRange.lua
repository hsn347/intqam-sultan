local buildLogic = include("buildLogic")
local cityBuildRange = class("cityBuildRange", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildRange:ctor()
end
function cityBuildRange:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_117"), i18n("buildDes_name_117")
	i18n("buildDes_name_117").x = 0
	;(nil).pos, i18n("buildDes_name_117").y = i18n("buildDes_name_117"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildRange

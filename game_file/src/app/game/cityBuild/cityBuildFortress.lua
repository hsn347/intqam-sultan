local buildLogic = include("buildLogic")
local cityBuildFortress = class("cityBuildFortress", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildFortress:ctor()
end
function cityBuildFortress:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_120"), i18n("buildDes_name_120")
	i18n("buildDes_name_120").x = 0
	;(nil).pos, i18n("buildDes_name_120").y = i18n("buildDes_name_120"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildFortress:updateViewModel()
end
return cityBuildFortress

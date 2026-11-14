local cityBuildCollege = class("cityBuildCollege", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildCollege:ctor()
end
function cityBuildCollege:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_113"), i18n("buildDes_name_113")
	i18n("buildDes_name_113").x = 0
	;(nil).pos, i18n("buildDes_name_113").y = i18n("buildDes_name_113"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildCollege

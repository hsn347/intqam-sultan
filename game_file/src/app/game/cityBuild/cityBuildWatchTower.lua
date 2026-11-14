local cityBuildWatchTower = class("cityBuildWatchTower", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildWatchTower:ctor()
	self.posEtUpgradeOffset = cc.p(8, -82)
end
function cityBuildWatchTower:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_104"), i18n("buildDes_name_104")
	i18n("buildDes_name_104").x = -10
	;(nil).pos, i18n("buildDes_name_104").y = i18n("buildDes_name_104"), -115
	SoraDShowNameOnTouchEvent(self, nil)
end
return cityBuildWatchTower

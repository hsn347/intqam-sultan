local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleReportProxy = class("kingdomBattleReportProxy", baseProxy)
function kingdomBattleReportProxy:onRegisterEvent()
	print("=======kingdomBattleReportProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTLIST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTBACK", handler(self, self.refreshLeftTime))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTTIMEOUT", handler(self, self.closeMe))
end
function kingdomBattleReportProxy:judgeCastleLv(showTips)
	if SoraDGetCastleLv() >= CASTLE_LV16_LIMITED then
		return true
	else
		if showTips then
			_ENV = nil
			;(nil).level = CASTLE_LV16_LIMITED
			SoraDShowMsgTip(i18n("common_text_2417", nil))
		end
		return false
	end
end
function kingdomBattleReportProxy:initData(...)
	self.view:initData(...)
end
function kingdomBattleReportProxy:refreshLeftTime(target, redata)
	SoraDShowMsgTip(i18n("common_text_1452"))
	self.view:refreshLeftTime()
end
function kingdomBattleReportProxy:closeMe(...)
	self.view:removeFromParent()
end
return kingdomBattleReportProxy

local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local batteryStateViewLogIntegralWar = class("batteryStateViewLogIntegralWar", include("batteryStateViewLogIntegral"))
function batteryStateViewLogIntegralWar:ctor()
	batteryStateViewLogIntegralWar.super.ctor(self)
	self.ccs_bg:setTitleName(i18n("worldwar_text_07"))
	SoraDGetChildByName(self, "Text_intIntegral"):setString(i18n("common_text_289"))
end
function batteryStateViewLogIntegralWar:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_OCCUPYTIME", handler(self, self.updateIngegral))
end
function batteryStateViewLogIntegralWar:req4Info()
	SoraDShowLoading(self)
	KWKingdomCtrl:getServiceWarOccupyRank()
end
return batteryStateViewLogIntegralWar

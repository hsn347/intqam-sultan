local allianceWarltCtrl = include("allianceWarltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local pyramidBattleScorePopViewPanel = class("pyramidBattleScorePopViewPanel", baseFguiPanel)
function pyramidBattleScorePopViewPanel:ctor(...)
	pyramidBattleScorePopViewPanel.super.ctor(self, ...)
	print("pyramidBattleScorePopViewPanel:ctor", self.viewName)
end
function pyramidBattleScorePopViewPanel:onInit()
	print("=======pyramidBattleScorePopViewPanel:onInit")
	self.listData, _ENV = print, print
	self.fields.Text_event:setString(i18n("legendaryking_text_50"))
	self.fields.Text_score:setString(i18n("common_text_3156"))
	self.fields.List:setItemRenderer(handler(self, self.onSingleRenderer))
	self.fields.Text_event:fixPos()
	self.fields.Text_score:fixPos()
end
function pyramidBattleScorePopViewPanel:onSingleRenderer(index, obj)
	obj:initData(self.listData[index + 1], index + 1)
end
function pyramidBattleScorePopViewPanel:onShow()
	print("=======pyramidBattleScorePopViewPanel:onShow")
	self.matchType = self.param.matchType
	self.fields.Panel_bg:setString(self.matchType == gSeasonType.REGULAR_SEASON and i18n("allianceWar_regularSeason_getPoint_title") or i18n("allianceWar_shopPoint_getPoint_title"))
	local scoreLimit = allianceWarltCtrl.getShopScoreLimit(self.matchType, SoraDGetCastleLv())
	if self.matchType == gSeasonType.REGULAR_SEASON then
		_ENV = SoraDGetCastleLv()
		SoraDGetCastleLv().var1 = scoreLimit
		if i18n("allianceWar_shopPoint_limit_desc02", SoraDGetCastleLv()) then
			goto lbl_49
		end
	end
	_ENV = SoraDGetCastleLv()
	SoraDGetCastleLv().var1 = scoreLimit
	::lbl_49::
	self.fields.Text_ins:setString((i18n("allianceWar_shopPoint_limit_desc", SoraDGetCastleLv())))
	self.listData = allianceWarltCtrl.getShopTaskInfo(self.matchType)
	self.fields.List:setNumItems(#self.listData)
	self.fields.List:setScrollEnable(#self.listData * 42 > self.fields.List:getHeight())
end
return pyramidBattleScorePopViewPanel

local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local allianceMobResetView = class("allianceMobResetView", function()
	return SoraDCreateTouchPanel("allianceMobResetView")
end)
function allianceMobResetView:ctor()
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Text_msg:setString(i18n("alliance_mobilize_text_08"))
	self.Text_notice = SoraDGetChildByName(self, "Text_notice")
	self.Text_notice:setString(i18n("alliance_mobilize_text_09"))
	self.Button_reset = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_yes")
	_ENV = "CCS_commonGoldNormalBtn_yes"
	;("CCS_commonGoldNormalBtn_yes").title = i18n("alliance_mobilize_text_10")
	self.Button_reset:initData("CCS_commonGoldNormalBtn_yes", 1)
	self.Button_reset:setHandle(handler(self, self.btnResetCallBack))
end
function allianceMobResetView:initData(gold, view)
	self.gold = gold
	self.view = view
	self.Button_reset:setGoldText(self.gold)
end
function allianceMobResetView:btnResetCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(self.gold) then
			SoraDShowLoading(self.view)
			playerMobilizationCtrl:reqRefresh()
			self:removeFromParent()
		end
	end
end
return allianceMobResetView

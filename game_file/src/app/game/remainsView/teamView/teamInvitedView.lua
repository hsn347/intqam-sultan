local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local teamInvitedView = class("teamInvitedView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("teamInvitedView")
	end
	return target
end)
function teamInvitedView:ctor()
	self.enableTouchCloseSelf = true
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.btnNo = SoraDGetChildByName(self, "Button_no")
	self.btnNo:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnYes:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnNo:setTitleText(i18n("common_text_091"))
	self.btnYes:setTitleText(i18n("common_text_068"))
	self.txtTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.txtPlayerName = SoraDGetChildByName(self, "Text_player_name")
	self.txtTeamName:addTouchEventListener(handler(self, self.onTeamName))
	self:initView()
end
function teamInvitedView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
end
function teamInvitedView:updateTeamInfo(target, data)
	if remainsTeamCtrl:isHasTeam() then
		local panel = SoraDCreatePanel("myTeamView")
		panel:show()
		self:removeFromParent()
	end
end
function teamInvitedView:initView()

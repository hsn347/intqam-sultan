local ancientReelActivity = class("ancientReelActivity", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientReelActivity")
	end
	return target
end)
function ancientReelActivity:ctor()
	self:setBackGround(204.0)
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitleActivity = SoraDGetChildByName(self, "Text_title_activity")
	self.spIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.txtContinue = SoraDGetChildByName(self, "Text_continue")
	local gametop = gModuleMgr.getObject("gametop")
	local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
	local round = ancientReelCtrl:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	self.txtTitle:setString(i18n("Ancient_reel_text_12", nil))
	self.txtTitleActivity:setString(i18n("activity_name_9001271"))
	self.txtContinue:setString(i18n("summoned_text_03"))
	do
		local node = SoraDGetChildByName(self, "Node_Particle_bottom")
		_G.SoraDSetParticleAutoCull(node:getChildren(), false)
	end
	do
		local node = SoraDGetChildByName(self, "Node_Particle_top")
		_G.SoraDSetParticleAutoCull(node:getChildren(), false)
	end
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.centerEffect = SoraDGetChildByName(self, "Node_icon")
	_G.SoraDCreatAnimationEx(self.__cname, self, true)
end
function ancientReelActivity:onEnterOther()
	SoraDPlaySound("uicontrol", 39)
end
function ancientReelActivity:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:closePanel()
		if not SoraDSearchPanelFromManagerByName("ancientReelMainView") then
			local panel = SoraDCreatePanel("ancientReelMainView")
			panel:show()
		end
	end
end
function ancientReelActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ancientReelActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY) then
		self:removeFromParent()
	end
end
return ancientReelActivity

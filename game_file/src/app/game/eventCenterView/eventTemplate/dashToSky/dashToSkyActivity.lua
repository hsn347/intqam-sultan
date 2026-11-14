local dashToSkyActivity = class("dashToSkyActivity", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dashToSkyActivity")
	end
	return target
end)
function dashToSkyActivity:ctor()
	self:setBackGround(204.0)
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitleActivity = SoraDGetChildByName(self, "Text_title_activity")
	self.spIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.txtContinue = SoraDGetChildByName(self, "Text_continue")
	local gametop = gModuleMgr.getObject("gametop")
	local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
	local round = royalSummonsCtrl:getActivitySeasonRound()
	self.txtTitle:setString(i18n("summoned_text_52"))
	self.txtTitleActivity:setString(i18n("summoned_text_53"))
	self.txtContinue:setString(i18n("summoned_text_03"))
	do
		local node = SoraDGetChildByName(self, "Node_Particle_top")
		local array = SoraDGetChildsArrayByName(node, "Particle_", 3, 1)
		_G.SoraDSetParticleAutoCull(array)
	end
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.centerEffect = SoraDGetChildByName(self, "Node_icon")
	self:initEffect()
end
function dashToSkyActivity:initEffect()
	self.centerEffect:setVisible(false)
	SoraDGetChildByName(self.centerEffect, "Particle_15"):setVisible(false)
	SoraDGetChildByName(self, "ft_2"):setColor(cc.c3b(120, 120, 120))
	SoraDGetChildByName(self.centerEffect, "Node_EffectGold"):setVisible(false)
	local cssFileName = "dashToSkyActivity"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
	self.etPetCardNode = SoraDCreatAnimationEx("dashToSkyLockEffect", self.etPetCardNode, false, nil)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(true)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(false)
	self.etPetCardNode.action:gotoFrameAndPause(0)
	local action = self.etPetCardNode.action
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "UNLOCKEND" then
				SoraDGetChildByName(self.centerEffect, "Particle_15"):setVisible(true)
				SoraDGetChildByName(self, "ft_2"):runAction(cca.tintTo(0.25, 1, 1, 1))
				SoraDGetChildByName(self.centerEffect, "Node_EffectGold"):setVisible(true)
			end
		end)
	end
	local filePath = "3d/junwang/junwangzhaojiling.c3b"
	if SoraDIsFileExistByFileName(filePath) then
	end
	_UPVALUE1_ = filePath
	filePath[1] = cca.delay(0.4166666666666667)
	filePath[2] = cca.callFunc(function()
		self.centerEffect:setVisible(true)
		self.etPetCardNode:setVisible(true)
		self.etPetCardNode.action:gotoFrameAndPlay(1, 122, false)
	end)
	filePath[3] = cca.callFunc(function()
		self.centerEffect:setVisible(true)
		self.etPetCardNode:setVisible(true)
		self.etPetCardNode.action:gotoFrameAndPlay(1, 122, false)
	end)
	local seq = cca.seq(filePath)
	self.centerEffect:runAction(seq)
end
function dashToSkyActivity:onEnterOther()
	SoraDPlaySound("uicontrol", 39)
end
function dashToSkyActivity:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:closePanel()
		if not SoraDSearchPanelFromManagerByName("royalSummonsMainView") then
			local panel = SoraDCreatePanel("royalSummonsMainView")
			panel:show()
		end
	end
end
function dashToSkyActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function dashToSkyActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROYAL_SUMMONS) then
		self:removeFromParent()
	end
end
return dashToSkyActivity

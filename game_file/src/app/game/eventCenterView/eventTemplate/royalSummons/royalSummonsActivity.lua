local royalSummonsActivity = class("royalSummonsActivity", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("royalSummonsActivity")
	end
	return target
end)
function royalSummonsActivity:ctor()
	self:setBackGround(204.0)
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitleActivity = SoraDGetChildByName(self, "Text_title_activity")
	self.spIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.txtContinue = SoraDGetChildByName(self, "Text_continue")
	local gametop = gModuleMgr.getObject("gametop")
	local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
	local round = royalSummonsCtrl:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	self.txtTitle:setString(i18n("summoned_text_01", nil))
	self.txtTitleActivity:setString(i18n("summoned_text_42"))
	self.txtContinue:setString(i18n("summoned_text_03"))
	do
		local node = SoraDGetChildByName(self, "Node_Particle_bottom")
		local array = SoraDGetChildsArrayByName(node, "Particle_", 5, 1)
		_G.SoraDSetParticleAutoCull(array)
	end
	do
		local node = SoraDGetChildByName(self, "Node_Particle_top")
		local array = SoraDGetChildsArrayByName(node, "Particle_", 3, 1)
		_G.SoraDSetParticleAutoCull(array)
	end
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.centerEffect = SoraDGetChildByName(self, "Node_icon")
	self:initEffect()
end
function royalSummonsActivity:initEffect()
	self.centerIcon = sp.SkeletonAnimation:create("spine/junwangzhaojiling.skel", "spine/junwangzhaojiling.atlas", 1.2)
	self.centerIcon:setVisible(false)
	self.centerIcon:setPosition(0, -160)
	self.centerEffect:addChild(self.centerIcon, -1)
	self.centerIcon:setColor(cc.c3b(120, 120, 120))
	self.etPetCardNode = SoraDCreatAnimationEx("royalSummonLockEffect", self.etPetCardNode, false, nil, 1, 89)
	SoraDMixtureGLONEByParent(self.etPetCardNode)
	self.etPetCardNode:setVisible(false)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(true)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(false)
	self.etPetCardNode.action:gotoFrameAndPause(0)
	local action = self.etPetCardNode.action
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "UNLOCKEND" then
				self.centerIcon:setAnimation(0, "animation", true)
				self.centerIcon:setColor(cc.c3b(255, 255, 255))
			end
		end)
	end
	local filePath = "3d/junwang/junwangzhaojiling.c3b"
	if SoraDIsFileExistByFileName(filePath) then
	end
	_UPVALUE1_ = filePath
	filePath[1] = cca.delay(0.5)
	filePath[2] = cca.callFunc(function()
		self.centerIcon:setVisible(true)
		self.etPetCardNode.action:gotoFrameAndPlay(1, 89, false)
		self.etPetCardNode:setVisible(true)
	end)
	filePath[3] = cca.callFunc(function()
		self.centerIcon:setVisible(true)
		self.etPetCardNode.action:gotoFrameAndPlay(1, 89, false)
		self.etPetCardNode:setVisible(true)
	end)
	local seq = cca.seq(filePath)
	self:runAction(seq)
end
function royalSummonsActivity:onEnterOther()
	SoraDPlaySound("uicontrol", 39)
end
function royalSummonsActivity:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:closePanel()
		if not SoraDSearchPanelFromManagerByName("royalSummonsMainView") then
			local panel = SoraDCreatePanel("royalSummonsMainView")
			panel:show()
		end
	end
end
function royalSummonsActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function royalSummonsActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROYAL_SUMMONS) then
		self:removeFromParent()
	end
end
return royalSummonsActivity

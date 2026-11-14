local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisSkillView = class("atlantisSkillView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisSkillView")
	end
	return target
end)
function atlantisSkillView:ctor()
	self.isHideCurrentSceneView = true
	self:initWidget()
	self:fitView()
	self:initData()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.ATLANTIS_WAR_SKILL)
end
function atlantisSkillView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_get" then
		return self.skillList[1].Button_get
	elseif itemName == "Button_detail" then
		return self.skillList[1].Button_detail
	end
	return nil
end
function atlantisSkillView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUYGIFT_SUCCESS", handler(self, self.onMessageBuyGiftSuccess))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgDataReqBack))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
end
function atlantisSkillView:initWidget()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_1")
	self.ccs_title:setTitle(i18n("common_title_03"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	_UPVALUE1_ = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick)[1] = "Top_Image_bg"
	self.Top_Image_bg = SoraDGetChildByFullPath(self._ccsView, handler(self, self.btnHelpClick))
	_UPVALUE1_ = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick)[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(self._ccsView, handler(self, self.btnHelpClick))
	_UPVALUE2_ = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick)[1] = "Node_tip"
	handler(self, self.btnHelpClick)[2] = "Text_tip"
	self.Text_tip = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnHelpClick))
	_UPVALUE1_ = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick)[1] = "Node_book"
	self.Node_book = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnHelpClick))
	_UPVALUE1_ = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick)[1] = "Button_book"
	self.Button_book = SoraDGetChildByFullPath(self.Node_book, handler(self, self.btnHelpClick))
	self.Button_book:addTouchEventListener(handler(self, self.btnBookClick))
	_UPVALUE1_ = handler(self, self.btnBookClick)
	handler(self, self.btnBookClick)[1] = "Text_book"
	self.Text_book = SoraDGetChildByFullPath(self.Button_book, handler(self, self.btnBookClick))
	self.Text_tip:setString(i18n("atlantiswar_skill_text_004"))
	self.Text_book:setString(i18n("atlantiswar_skill_text_003"))
	_UPVALUE1_ = i18n("atlantiswar_skill_text_003")
	i18n("atlantiswar_skill_text_003")[1] = "Node_skill"
	self.Node_skill = SoraDGetChildByFullPath(self.Top_Node, i18n("atlantiswar_skill_text_003"))
	self.skillList = SoraDGetChildsArrayByName(self.Node_skill, "CCS_atlantisSkillSingle_", 5, 1, nil, true)
	if SoraDFIsRA() then
		local posx = self.skillList[1]:getPositionX()
		self.skillList[1]:setPositionX(self.skillList[3]:getPositionX())
		self.skillList[3]:setPositionX(posx)
		local posx = self.skillList[4]:getPositionX()
		self.skillList[4]:setPositionX(self.skillList[5]:getPositionX())
		self.skillList[5]:setPositionX(posx)
	end
end
function atlantisSkillView:fitView(...)
	if display.height < 900 then
		self.Node_skill:setScale(0.9)
		self.Node_skill:setPositionY(self.Node_skill:getPositionY() + 45)
	elseif display.height > 1200 then
		self.Node_book:setPositionY(self.Node_book:getPositionY() - 22)
		self.Node_skill:setPositionY(self.Node_skill:getPositionY() - (display.height - 1136) / 2)
		if display.height > 1386 then
			self.Top_Image_bg:setContentSize(display.size)
		end
	end
end
function atlantisSkillView:initData(...)
	self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	self.isPrivilegeLock = atlantisActivityCtrl:getSkillData("isPrivilegeLock")
	for i, item in ipairs(self.skillList) do
		atlantisActivityCtrl = nil
		;(nil).index = i
		;(nil).skillSlot = self.skillSlot[tostring(i)]
		;(nil).isPrivilegeLock = self.isPrivilegeLock
		item:initData(nil)
	end
end
function atlantisSkillView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "atlantiswar_skill_text_002"
		;("atlantiswar_skill_text_002").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("atlantiswar_skill_text_002"), "atlantiswar_skill_text_002")
	end
end
function atlantisSkillView:btnBookClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisSkillBook"):show()
	end
end
function atlantisSkillView:onMessageSkillLottery(target, event)
	local index = event.index
	self.candidateSkill = atlantisActivityCtrl:getSkillData("candidateSkill")
	if self.candidateSkill[tostring(index)] then
		return
	end
	self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	self.skillList[index]:showChangeSkillEffect()
end
function atlantisSkillView:onMessageSkillReplace(target, event)
	local index = event.index
	self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	atlantisActivityCtrl = "skillSlot"
	;("skillSlot").index = index
	;("skillSlot").skillSlot = self.skillSlot[tostring(index)]
	self.skillList[index]:initData("skillSlot")
end
function atlantisSkillView:onMessageSkillSelect(target, event)
	self:onMessageSkillReplace(target, event)
end
function atlantisSkillView:initShowSkillEffect(skillSingle)
	local criSprite = cc.criSprite.createCriSprite("G_JNBH.usm", true, false, nil)
	criSprite:addTo(skillSingle, 1)
	criSprite:setPosition(4, 6)
	criSprite:setBlendFunc(gl.ONE, gl.ONE)
end
function atlantisSkillView:onMessageBuyGiftSuccess(...)
	self.isPrivilegeLock = atlantisActivityCtrl:getSkillData("isPrivilegeLock")
	self.isPrivilegeLock = true
	for i = 4, 5 do
		self.skillList[i]:showUnLockEffect()
	end
end
function atlantisSkillView:msgDataReqBack(target, content)
	if content.key == "reqStateDataRsp" then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return atlantisSkillView

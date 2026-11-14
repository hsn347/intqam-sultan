local gametop = gModuleMgr.getObject("gametop")
local allianceSetting = gametop.playertop_:getModule("allianceSetting")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local ChangeOpenRecruitmentNode = class("changeOpenRecruitmentNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeOpenRecruitmentNode")
	end
	return target
end)
function ChangeOpenRecruitmentNode:ctor()
	self.newInput = nil
	self.newPowerInput = nil
	self.curLv = nil
	self.recruitmentType = gARecruit.public
	_ENV, self.isChanged = gARecruit.public, false
	gARecruit.public.power = 0
	self.tableNeed, gARecruit.public.lv = gARecruit.public, 0
	self.nodeSize = SoraDGetChildByName(self, "Panel_size")
	self.nodeSize:setSwallowTouches(false)
	self.btnType = SoraDGetChildByName(self, "Button_type")
	self.btnType:setPressedActionEnabled(false)
	self.btnOpen = SoraDGetChildByName(self, "Button_open")
	self.btnClosed = SoraDGetChildByName(self, "Button_closed")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_245"))
	self.labelNeed = SoraDGetChildByName(self, "Text_need")
	self.labelNeed:setString(i18n("common_text_1154"))
	self.tfdLv = SoraDGetChildByName(self, "TextField_lv")
	self.tfdLv:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdPower = SoraDGetChildByName(self, "TextField_power")
	_ENV = "TextField_power"
	;("TextField_power").func = handler(self, self.OnInputPowerNotice)
	self.tfdPower = SoraDChangeToEditBox(self.tfdPower, "TextField_power")
	self.tfdPower:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdPower:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.Panel_lv = SoraDGetChildByName(self, "Panel_lv")
	self.Panel_lv:addTouchEventListener(handler(self, self.txtFieldActive))
	self.labelLv = SoraDGetChildByName(self, "Text_lv")
	_ENV = handler(self, self.txtFieldActive)
	handler(self, self.txtFieldActive).value = ""
	self.labelLv:setString(i18n("common_text_1155", handler(self, self.txtFieldActive)))
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	_ENV = i18n("common_text_1155", handler(self, self.txtFieldActive))
	i18n("common_text_1155", handler(self, self.txtFieldActive)).value = ""
	self.labelPower:setString(i18n("common_text_1156", i18n("common_text_1155", handler(self, self.txtFieldActive))))
	self.labelNeedNotice = SoraDGetChildByName(self, "Text_needNotice")
	self.labelNeedNotice:setString(i18n("common_text_1157"))
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange:setTitleText(i18n("common_text_243"))
	self.btnChange:setTouchEnabled(false)
	self.btnChange:setBright(false)
	self.btnType:addTouchEventListener(handler(self, self.btnTypeChangeCallBack))
	self.btnOpen:addTouchEventListener(handler(self, self.btnOpenClickCallBack))
	self.btnClosed:addTouchEventListener(handler(self, self.btnClosedClickCallBack))
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	self:initData()
	SoradCreateTimer(self, handler(self, self.update), true)
end
function ChangeOpenRecruitmentNode:update()
	if self.newLvInput then
		self.tfdLv:setString(self.newLvInput)
		self.newLvInput = nil
	end
	if self.newPowerInput then
		self.tfdPower:setString(self.newPowerInput)
		self.newPowerInput = nil
	end
	self:updateBtnState()
end
function ChangeOpenRecruitmentNode:txtFieldActive(textField, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).isCastleLv = true
		;(nil).curNum = self.tableNeed.lv
		;(nil).handl = handler(self, self.returnFromInput)
		uiManager:show("gameMessageTimeInput", nil)
	end
end
function ChangeOpenRecruitmentNode:returnFromInput(num)
	self.tfdLv:setString(num)
	self.curLv = num
end
function ChangeOpenRecruitmentNode:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if tonumber(target:getString()) == 0 then
			target:setString("")
		end
		target:touchDownAction(target, type)
	end
end
function ChangeOpenRecruitmentNode:OnInputLvNotice(eventType, textField)
	if eventType == "return" then
		local input = textField:getString()
		print("ChangeOpenRecruitmentNode-return: ", input)
		input = tonumber(input) or 0
		local maxVlaue = 130
		if input > maxVlaue then
			input = maxVlaue
		end
		self.newLvInput = input
		self:updateBtnState()
	end
end
function ChangeOpenRecruitmentNode:OnInputPowerNotice(eventType, textField)
	if eventType == "return" then
		local input = textField:getString()
		print("ChangeOpenRecruitmentNode-return: ", input)
		input = tonumber(input) or 0
		local maxVlaue = 100000000
		if input > maxVlaue then
			input = maxVlaue
		end
		self.newPowerInput = input
		self:updateBtnState()
	end
end
function ChangeOpenRecruitmentNode:updateBtnState()
	local lv = tonumber(self.tfdLv:getString())
	local power = tonumber(self.tfdPower:getString())
	local canChange = lv ~= self.tableNeed.lv or power ~= self.tableNeed.power
	self.btnChange:setTouchEnabled(canChange)
	self.btnChange:setBright(canChange)
	return canChange
end
function ChangeOpenRecruitmentNode:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local lv = tonumber(self.tfdLv:getString())
		local power = tonumber(self.tfdPower:getString())
		allianceSetting:reqModifyRecruitCondition(lv, power)
		self.tableNeed.lv = lv
		self.tableNeed.power = power
		self:updateBtnState()
	elseif type == ccui.TouchEventType.began then
		self:updateBtnState()
	end
end
function ChangeOpenRecruitmentNode:initData()
	self.recruitmentType = allianceMgr:getAllianceProperty("recruitType")
	if self.recruitmentType == gARecruit.public then
		self.btnType:setPositionX(375)
	else
		self.btnType:setPositionX(225)
	end
	self:changeTitle()
	self:updateCondition()
end
function ChangeOpenRecruitmentNode:updateCondition()
	self.tableNeed.power = allianceMgr:getAllianceProperty("joinPower")
	self.tableNeed.lv = allianceMgr:getAllianceProperty("joinLevel")
	self.tfdLv:setString(tostring(self.tableNeed.lv))
	self.tfdPower:setString(string.formatnumberthousands(self.tableNeed.power))
end
function ChangeOpenRecruitmentNode:getSingleH()
	return self.nodeSize:getContentSize().height
end
function ChangeOpenRecruitmentNode:changeState(type)
	if type == self.recruitmentType then
		return
	end
	self.recruitmentType = type
	self.btnType:stopAllActions()
	if self.recruitmentType == gARecruit.public then
		self.btnType:runAction(cca.moveTo(0.1, cc.p(375, self.btnType:getPositionY())))
	else
		self.btnType:runAction(cca.moveTo(0.1, cc.p(225, self.btnType:getPositionY())))
	end
	self.isChanged = not self.isChanged
end
function ChangeOpenRecruitmentNode:changeTitle()
	if self.recruitmentType == gARecruit.public then
		self.btnType:setTitleText(i18n("common_text_246"))
		self.btnType:loadTextures("btn_alliance_green.png", "btn_alliance_green.png", "btn_alliance_green.png", ccui.TextureResType.plistType)
	else
		self.btnType:setTitleText(i18n("common_text_247"))
		self.btnType:loadTextures("btn_alliance_black.png", "btn_alliance_black.png", "btn_alliance_black.png", ccui.TextureResType.plistType)
	end
	self.btnType:setContentSize(cc.size(150, 57))
	if self.isChanged then
		allianceSetting:reqModifyRecruitType(self.recruitmentType)
		self.isChanged = false
	end
end
function ChangeOpenRecruitmentNode:btnOpenClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeState(gARecruit.public)
		self:changeTitle()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = touchBeganPoint.x - touchmovePoint.x
		if tonumber(distance) <= -50 then
			self:changeState(gARecruit.public)
			self:changeTitle()
		end
	end
end
function ChangeOpenRecruitmentNode:btnClosedClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeState(gARecruit.private)
		self:changeTitle()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = touchBeganPoint.x - touchmovePoint.x
		if tonumber(distance) >= 50 then
			self:changeState(gARecruit.private)
			self:changeTitle()
		end
	end
end
function ChangeOpenRecruitmentNode:btnTypeChangeCallBack(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:changeTitle()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = touchBeganPoint.x - touchmovePoint.x
		if tonumber(distance) >= 50 then
			self:changeState(gARecruit.private)
		elseif tonumber(distance) <= -50 then
			self:changeState(gARecruit.public)
		end
	end
end
return ChangeOpenRecruitmentNode

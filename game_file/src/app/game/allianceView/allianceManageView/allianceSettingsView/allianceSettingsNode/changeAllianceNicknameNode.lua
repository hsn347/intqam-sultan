local ChangeAllianceNicknameNode = class("changeAllianceNicknameNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeAllianceNicknameNode")
	end
	return target
end)
function ChangeAllianceNicknameNode:ctor()
	self.nodeTag = gaSettings.NAME
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelErr = SoraDGetChildByName(self, "Text_err")
	self.labelErr:setColor(cc.c3b(120, 120, 120))
	self.tfdName = SoraDGetChildByName(self, "TextField_name")
	_ENV = "TextField_name"
	;("TextField_name").func = handler(self, self.OnInputName)
	self.tfdName = SoraDChangeToEditBox(self.tfdName, "TextField_name")
	self.btnGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_change")
	_ENV = "CCS_commonGoldNormalBtn_change"
	;("CCS_commonGoldNormalBtn_change").title = i18n("common_text_243")
	self.btnGold:initData("CCS_commonGoldNormalBtn_change", 1)
	self.spriteErr = SoraDGetChildByName(self, "Sprite_err")
	self.spriteErr:setVisible(false)
	self.nodeSize = SoraDGetChildByName(self, "Panel_size")
	self.nodeSize:setSwallowTouches(false)
	self.tfdName:setSwallowTouches(false)
	self.tfdName:setTextHorizontalAlignment(SoraDFLabelR())
	if self.btnGold then
		self.btnGold:setHandle(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CREATE_ERR_BACK", handler(self, self.allianceInputErr))
end
function ChangeAllianceNicknameNode:allianceInputErr(target, data)
	self:updateErr(data.err)
	self.btnGold:setTouchEnabled(false)
	self.btnGold:setBright(false)
end
function ChangeAllianceNicknameNode:initData(nodeTag)
	self.nodeTag = nodeTag
	self.btnGold:setTouchEnabled(false)
	self.btnGold:setBright(false)
	if self.nodeTag == gaSettings.NAME then
		self:initChangeName()
	else
		self:initChangeNickName()
	end
end
function ChangeAllianceNicknameNode:initChangeName()
	self.labelTitle:setString(i18n("common_text_248"))
	self.labelNotice:setString(i18n("common_text_174"))
	self.btnGold:setGoldText(tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD))
	self.tfdName:setMaxLength(ALLIANCE_NAME_MAX)
	_ENV = tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD)
	tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD).count = ALLIANCE_NAME_MAX
	self.labelErr:setString(i18n("common_text_364", tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD)))
end
function ChangeAllianceNicknameNode:initChangeNickName()
	self.labelTitle:setString(i18n("common_text_249"))
	self.labelNotice:setString(i18n("common_text_176"))
	self.btnGold:setGoldText(tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_ABBT_GOLD))
	self.tfdName:setMaxLength(ALLIANCE_NAME_MIN)
	_ENV = tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_ABBT_GOLD)
	tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_ABBT_GOLD).count = ALLIANCE_NAME_MIN
	self.labelErr:setString(i18n("common_text_364", tostring(gConstValue.ALLIANCE_MODIFY_ALLIANCE_ABBT_GOLD)))
end
function ChangeAllianceNicknameNode:getSingleH()
	return self.nodeSize:getContentSize().height
end
function ChangeAllianceNicknameNode:OnInputName(eventType, textField)
	if eventType == "changed" then
		local input = textField:getCharCount()
		local maxCount = self.nodeTag == gaSettings.NAME and 20 or 3
		self.spriteErr:setVisible(false)
		self.labelErr:setColor(cc.c3b(120, 120, 120))
		_ENV = cc.c3b(120, 120, 120)
		cc.c3b(120, 120, 120).count = maxCount - input
		self.labelErr:setString(i18n("common_text_364", cc.c3b(120, 120, 120)))
	elseif eventType == "return" then
		if self.nodeTag == gaSettings.NAME then
			self:updateChangeBtnTouchEnable()
		else
			self:updateChangeBtnTouchEnable()
		end
	end
end
function ChangeAllianceNicknameNode:updateErr(err)
	if self.nodeTag == gaSettings.NAME then
		if err == gErrDef.Err_None then
			self.spriteErr:setSpriteFrame("icon_g.png")
			self.labelErr:setColor(cc.c3b(120, 120, 120))
		else
			self.spriteErr:setSpriteFrame("icon_no.png")
			self.labelErr:setColor(display.COLOR_RED)
			if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
				self.labelErr:setString(i18n("notice_0070"))
			elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL then
				self.labelErr:setString(i18n("notice_0153"))
			elseif err == gErrDef.Err_ALLIANCE_NAME_HAVE then
				self.labelErr:setString(i18n("notice_0072"))
			end
		end
	elseif err == gErrDef.Err_None then
		self.spriteErr:setSpriteFrame("icon_g.png")
		self.labelErr:setColor(cc.c3b(120, 120, 120))
	else
		self.spriteErr:setSpriteFrame("icon_no.png")
		self.labelErr:setColor(display.COLOR_RED)
		if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
			self.labelErr:setString(i18n("notice_0074"))
		elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_ABBR_ILLEGAL then
			self.labelErr:setString(i18n("notice_0154"))
		elseif err == gErrDef.Err_ALLIANE_ABBR_HAVE then
			self.labelErr:setString(i18n("notice_0155"))
		end
	end
end
function ChangeAllianceNicknameNode:updateChangeBtnTouchEnable()
	local isEnable = true
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	local nameErr = gErrDef.Err_None
	if self.nodeTag == gaSettings.NAME then
		nameErr = allianceQuery:reqCheckAllianceName(self.tfdName:getString())
	else
		nameErr = allianceQuery:reqCheckAllianceAbbr(self.tfdName:getString())
	end
	self.spriteErr:setVisible(true)
	self:updateErr(nameErr)
	isEnable = nameErr == gErrDef.Err_None
	self.btnGold:setTouchEnabled(isEnable)
	self.btnGold:setBright(isEnable)
end
function ChangeAllianceNicknameNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended and SoraDEnoughGold(self.btnGold:getGoldValue()) then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceSetting = gametop.playertop_:getModule("allianceSetting")
		if self.nodeTag == gaSettings.NAME then
			allianceSetting:reqModifyName(self.tfdName:getString())
		else
			allianceSetting:reqModifyAbbr(self.tfdName:getString())
		end
		self.spriteErr:setVisible(false)
		self.tfdName:setString("")
	elseif type == ccui.TouchEventType.began then
		self:updateChangeBtnTouchEnable()
	end
end
return ChangeAllianceNicknameNode

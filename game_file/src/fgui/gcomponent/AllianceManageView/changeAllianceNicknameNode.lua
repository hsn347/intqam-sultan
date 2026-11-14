local allianceSetting = SoraDGetCtrl("allianceSetting")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local baseComponent = require("fgui.base.baseComponent")
local changeAllianceNicknameNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeAllianceNicknameNode", changeAllianceNicknameNode)
function changeAllianceNicknameNode:onInit()
	self.nodeTag = gaSettings.NAME
	self.needGold = gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputName))
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnChangeName))
	self.fields.TextField_name:setAlign(SoraDFLabelR())
	self.fields.Sprite_err:setVisible(false)
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_change:setEnabled(false)
	self:fixChildrenPos()
end
function changeAllianceNicknameNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CREATE_ERR_BACK", handler(self, self.allianceInputErr))
end
function changeAllianceNicknameNode:allianceInputErr(target, data)
	self:updateErr(data.err)
	self.fields.Button_change:setEnabled(false)
end
function changeAllianceNicknameNode:updateErr(err)
	if self.nodeTag == gaSettings.NAME then
		if err == gErrDef.Err_None then
			self.fields.Sprite_err:setSpriteFrame("bg_main_task05.png")
			self.fields.Text_err:setColor(cc.c3b(120, 120, 120))
		else
			self.fields.Sprite_err:setSpriteFrame("bg_main_task06.png")
			self.fields.Text_err:setColor(cc.c3b(224, 43, 43))
			if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
				self.fields.Text_err:setString(i18n("notice_0070"))
			elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL then
				self.fields.Text_err:setString(i18n("notice_0153"))
			elseif err == gErrDef.Err_ALLIANCE_NAME_HAVE then
				self.fields.Text_err:setString(i18n("notice_0072"))
			end
		end
	elseif err == gErrDef.Err_None then
		self.fields.Sprite_err:setSpriteFrame("bg_main_task05.png")
		self.fields.Text_err:setColor(cc.c3b(120, 120, 120))
	else
		self.fields.Sprite_err:setSpriteFrame("bg_main_task06.png")
		self.fields.Text_err:setColor(cc.c3b(224, 43, 43))
		if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
			self.fields.Text_err:setString(i18n("notice_0074"))
		elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_ABBR_ILLEGAL then
			self.fields.Text_err:setString(i18n("notice_0154"))
		elseif err == gErrDef.Err_ALLIANE_ABBR_HAVE then
			self.fields.Text_err:setString(i18n("notice_0155"))
		end
	end
end
function changeAllianceNicknameNode:onShow()
end
function changeAllianceNicknameNode:OnInputName()
	local inputText = self.fields.TextField_name:getText()
	local maxCount = self.nodeTag == gaSettings.NAME and ALLIANCE_NAME_MAX or ALLIANCE_NAME_MIN
	local inputCount = string.utf8len(inputText)
	self.fields.Sprite_err:setVisible(false)
	self.fields.Text_err:setColor(cc.c3b(120, 120, 120))
	_ENV = cc.c3b(120, 120, 120)
	cc.c3b(120, 120, 120).count = maxCount - inputCount
	self.fields.Text_err:setString(i18n("common_text_364", cc.c3b(120, 120, 120)))
end
function changeAllianceNicknameNode:OnChangeName()
	local isEnable = true
	local nameErr = gErrDef.Err_None
	if self.nodeTag == gaSettings.NAME then
		nameErr = allianceQuery:reqCheckAllianceName(self.fields.TextField_name:getText())
	else
		nameErr = allianceQuery:reqCheckAllianceAbbr(self.fields.TextField_name:getText())
	end
	self.fields.Sprite_err:setVisible(true)
	self:updateErr(nameErr)
	isEnable = nameErr == gErrDef.Err_None
	self.fields.Button_change:setEnabled(isEnable)
end
function changeAllianceNicknameNode:initData(tag)
	self.nodeTag = tag
	if self.nodeTag == gaSettings.NAME then
		self:initChangeName()
	else
		self:initChangeNickName()
	end
end
function changeAllianceNicknameNode:initChangeName()
	self.needGold = gConstValue.ALLIANCE_MODIFY_ALLIANCE_NAME_GOLD
	self.fields.Text_title:setString(i18n("common_text_248"))
	self.fields.Text_notice:setString(i18n("common_text_174"))
	self.fields.Button_change:setCostTitle(tostring(self.needGold))
	self.fields.TextField_name:setMaxLength(ALLIANCE_NAME_MAX)
	_ENV = tostring(self.needGold)
	tostring(self.needGold).count = ALLIANCE_NAME_MAX
	self.fields.Text_err:setString(i18n("common_text_364", tostring(self.needGold)))
end
function changeAllianceNicknameNode:initChangeNickName()
	self.needGold = gConstValue.ALLIANCE_MODIFY_ALLIANCE_ABBT_GOLD
	self.fields.Text_title:setString(i18n("common_text_249"))
	self.fields.Text_notice:setString(i18n("common_text_176"))
	self.fields.Button_change:setCostTitle(tostring(self.needGold))
	self.fields.TextField_name:setMaxLength(ALLIANCE_NAME_MIN)
	_ENV = tostring(self.needGold)
	tostring(self.needGold).count = ALLIANCE_NAME_MIN
	self.fields.Text_err:setString(i18n("common_text_364", tostring(self.needGold)))
end
function changeAllianceNicknameNode:btnClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.needGold) then
		if self.nodeTag == gaSettings.NAME then
			allianceSetting:reqModifyName(self.fields.TextField_name:getText())
		else
			allianceSetting:reqModifyAbbr(self.fields.TextField_name:getText())
		end
		self.fields.Sprite_err:setVisible(false)
		self.fields.TextField_name:setText("")
		self.fields.Button_change:setEnabled(false)
	end
end
return changeAllianceNicknameNode

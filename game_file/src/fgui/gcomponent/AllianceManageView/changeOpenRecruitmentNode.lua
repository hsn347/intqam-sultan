local allianceSetting = SoraDGetCtrl("allianceSetting")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local MAX_POWER_SET = 100000000
local baseComponent = require("fgui.base.baseComponent")
local changeOpenRecruitmentNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeOpenRecruitmentNode", changeOpenRecruitmentNode)
function changeOpenRecruitmentNode:onInit()
	self.isPowerChanged = false
	_ENV, self.isLvChanged = nil, false
	;(nil).power = 0
	self.tableNeed, (nil).lv = nil, 0
	self.recruitmentType = gARecruit.public
	self.fields.Text_notice:setString(i18n("common_text_245"))
	self.fields.Text_need:setString(i18n("common_text_1154"))
	_ENV = i18n("common_text_1154")
	i18n("common_text_1154").value = ""
	self.fields.Text_lv:setString(i18n("common_text_1155", i18n("common_text_1154")))
	_ENV = i18n("common_text_1155", i18n("common_text_1154"))
	i18n("common_text_1155", i18n("common_text_1154")).value = ""
	self.fields.Text_power:setString(i18n("common_text_1156", i18n("common_text_1155", i18n("common_text_1154"))))
	self.fields.Text_needNotice:setString(i18n("common_text_1157"))
	self.fields.TextField_power:setMaxLength(9)
	self.fields.TextField_power:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.TextField_power:setAlign(SoraDFLabelR())
	self.fields.Button_closed:addClickListener(handler(self, self.btnClosedClickCallBack))
	self.fields.Button_open:addClickListener(handler(self, self.btnOpenClickCallBack))
	self.fields.Button_type:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		self.beginPos = context:getInput():getPosition()
	end)
	self.fields.Button_type:addEventListener(fgui.UIEventType.TouchEnd, function(context)
		self.endPos = context:getInput():getPosition()
		if self.beginPos then
			if self.endPos.x - self.beginPos.x > 50 then
				self.recruitmentType = SoraDFIsRA() and gARecruit.public or gARecruit.private
				self:setBtnType(true)
			elseif self.endPos.x - self.beginPos.x < -50 then
				self.recruitmentType = SoraDFIsRA() and gARecruit.private or gARecruit.public
				self:setBtnType(true)
			end
		end
	end)
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:setEnabled(false)
	self.fields.Button_change:addClickListener(handler(self, self.btnChangeClickCallBack))
	self.fields.Button_lv:addClickListener(handler(self, self.btnLvClickCallBack))
	self:fixChildrenPos()
end
function changeOpenRecruitmentNode:onShow()
	self.tableNeed.power = allianceMgr:getAllianceProperty("joinPower")
	self.tableNeed.lv = allianceMgr:getAllianceProperty("joinLevel")
	self.fields.TextField_power:setText(self.tableNeed.power)
	self.fields.TextField_lv:setString(self.tableNeed.lv)
end
function changeOpenRecruitmentNode:onChanged()
	local inputPower = self.fields.TextField_power:getText()
	inputPower = tonumber(inputPower) or 0
	local newInputPower = math.min(inputPower, MAX_POWER_SET)
	if newInputPower ~= inputPower then
		self.fields.TextField_power:setText(newInputPower)
	end
	self.isPowerChanged = self.tableNeed.power ~= newInputPower
	self:updateBtnChange()
end
function changeOpenRecruitmentNode:updateBtnChange()
	if self.isPowerChanged or self.isLvChanged then
		self.fields.Button_change:setEnabled(true)
	else
		self.fields.Button_change:setEnabled(false)
	end
end
function changeOpenRecruitmentNode:initData(tag)
	self.recruitmentType = allianceMgr:getAllianceProperty("recruitType")
	self:setBtnType()
end
function changeOpenRecruitmentNode:setBtnType(isAni)
	if isAni then
		local toPosX = self.recruitmentType == gARecruit.public and SoraDFPosX(390, 640) or SoraDFPosX(250, 640)
		self.fields.Button_type:runAction(ffa.moveTo(0.1, toPosX, self.fields.Button_type:getPositionY()))
	else
		self.fields.Button_type:setPositionX(self.recruitmentType == gARecruit.public and SoraDFPosX(390, 640) or SoraDFPosX(250, 640))
	end
	self.fields.Button_type:setString(self.recruitmentType == gARecruit.public and i18n("common_text_246") or i18n("common_text_247"))
	self.fields.Button_type:setBright(self.recruitmentType == gARecruit.public)
	if isAni then
		allianceSetting:reqModifyRecruitType(self.recruitmentType)
	end
end
function changeOpenRecruitmentNode:btnOpenClickCallBack()
	SoraDPlaySound()
	self.recruitmentType = gARecruit.public
	self:setBtnType(true)
end
function changeOpenRecruitmentNode:btnClosedClickCallBack()
	SoraDPlaySound()
	self.recruitmentType = gARecruit.private
	self:setBtnType(true)
end
function changeOpenRecruitmentNode:btnLvClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isCastleLv = true
	;(nil).curNum = self.tableNeed.lv
	;(nil).handl = handler(self, self.returnFromInput)
	uiManager:show("gameMessageTimeInput", nil)
end
function changeOpenRecruitmentNode:returnFromInput(num)
	if tolua.isnull(self) then
		return
	end
	self.fields.TextField_lv:setString(num)
	self.isLvChanged = self.tableNeed.lv ~= num
	self:updateBtnChange()
end
function changeOpenRecruitmentNode:btnChangeClickCallBack()
	SoraDPlaySound()
	local lv = tonumber(self.fields.TextField_lv:getText())
	local power = tonumber(self.fields.TextField_power:getText())
	allianceSetting:reqModifyRecruitCondition(lv, power)
	self.tableNeed.lv = lv
	self.tableNeed.power = power
	self.fields.Button_change:setEnabled(false)
end
return changeOpenRecruitmentNode

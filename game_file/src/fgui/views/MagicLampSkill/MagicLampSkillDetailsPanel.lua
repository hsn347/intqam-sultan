local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillDetailsPanel = class("MagicLampSkillDetailsPanel", baseFguiPanel)
function MagicLampSkillDetailsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillDetailsPanel:ctor", self.viewName)
	self.addMode = UI_ADD_MODE.Multi
end
function MagicLampSkillDetailsPanel:onInit()
	print("=======MagicLampSkillDetailsPanel:onInit")
	if SoraDFIsRA() then
		self.fields.Button_left:addClickListener(handler(self, self.onClickBtnRight))
		self.fields.Button_right:addClickListener(handler(self, self.onClickBtnLeft))
	else
		self.fields.Button_left:addClickListener(handler(self, self.onClickBtnLeft))
		self.fields.Button_right:addClickListener(handler(self, self.onClickBtnRight))
	end
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
end
function MagicLampSkillDetailsPanel:onShow()
	print("=======MagicLampSkillDetailsPanel:onShow")
	if self.param.skillType then
		_ENV, self.skillType = self.param.skillType, self.param.skillType
		self.data, self.param.skillType.skillType = self.param.skillType, self.skillType
		self.fields.Com_skillBig:setViewType(1)
	else
		self.curIndex = self.param.index
		self.skillList = self.param.skillList
		self.data = self.skillList[self.curIndex]
	end
	self:initData(self.data)
	self:updateButtonArrow()
end
function MagicLampSkillDetailsPanel:updateButtonArrow(...)
	if self.skillType then
		self.fields.Button_left:setVisible(false)
		self.fields.Button_right:setVisible(false)
	elseif SoraDFIsRA() then
		self.fields.Button_left:setVisible(self.curIndex < #self.skillList)
		self.fields.Button_right:setVisible(self.curIndex > 1)
	else
		self.fields.Button_left:setVisible(self.curIndex > 1)
		self.fields.Button_right:setVisible(self.curIndex < #self.skillList)
	end
end
function MagicLampSkillDetailsPanel:onClickBtnLeft(...)
	SoraDPlaySound()
	if self.curIndex > 1 then
		self.curIndex = self.curIndex - 1
		local data = self.skillList[self.curIndex]
		self.data = magicLampSkillCtrl:getSkillData(data.id)
		self:initData(self.data)
		self:updateButtonArrow()
	end
end
function MagicLampSkillDetailsPanel:onClickBtnRight(...)
	SoraDPlaySound()
	if self.curIndex < #self.skillList then
		self.curIndex = self.curIndex + 1
		local data = self.skillList[self.curIndex]
		self.data = magicLampSkillCtrl:getSkillData(data.id)
		self:initData(self.data)
		self:updateButtonArrow()
	end
end
function MagicLampSkillDetailsPanel:initData(data)
	dump(data, "==MagicLampSkillDetailsPanel:initData==")
	self.fields.Com_skillBig:initData(data)
end
function MagicLampSkillDetailsPanel:onMsgUpgradeLvBack(...)
	self.fields.Com_skillBig:updateSkillLv()
end
function MagicLampSkillDetailsPanel:onMsgUpgradeClassBack(...)
	self.fields.Com_skillBig:updateSkillClassLv()
	for i = #self.skillList, 1, -1 do
		local data = self.skillList[i]
		if not magicLampSkillCtrl:getSkillData(data.id) then
			table.remove(self.skillList, i)
		end
	end
	for i, v in ipairs(self.skillList) do
		if self.data.id == v.id then
			self.curIndex = i
			break
		end
	end
	self:updateButtonArrow()
end
function MagicLampSkillDetailsPanel:onMsgUpdateLock(...)
	SoraDCloseLoading(self.view:displayObject())
	self.fields.Com_skillBig:updateSkillLock()
end
function MagicLampSkillDetailsPanel:onMsgAfterMerge(target, event)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	local skillType = event.skillType
	if skillType == self.skillType then
		self.fields.Com_skillBig:updateGetState(true)
		self.fields.Com_skillBig:updateItemCount()
	end
end
function MagicLampSkillDetailsPanel:onMsgAfterRebirth(...)
	self.fields.Com_skillBig:updateSkillLv()
	self.fields.Com_skillBig:updateSkillClassLv()
end
return MagicLampSkillDetailsPanel

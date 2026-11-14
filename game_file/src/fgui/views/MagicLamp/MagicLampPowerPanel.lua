local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampRead = include("magicLampRead")
local MagicLampPowerPanel = class("MagicLampPowerPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
function MagicLampPowerPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampPowerPanel:ctor", self.viewName)
end
function MagicLampPowerPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampPowerPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampPowerPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_10"))
	self.fields.List_skill:setVirtual()
	self.fields.List_skill:setItemRenderer(handler(self, self.onItemsRenderer))
	self.fields.List_skill:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Button_getMore:setTitle(i18n("magic_lamp_text_102"))
	self.fields.Button_getMore:addClickEventListener(handler(self, self.onGetMore))
	self.fields.Button_inlay:setTitle(i18n("common_btn_05"))
	self.fields.Button_inlay:addClickEventListener(handler(self, self.onInlay))
	self.fields.Button_replace:setTitle(i18n("common_text_1371"))
	self.fields.Button_replace:addClickEventListener(handler(self, self.onInlay))
	self.fields.Button_remove:setTitle(i18n("common_text_3889"))
	self.fields.Button_remove:addClickEventListener(handler(self, self.onRemove))
end
function MagicLampPowerPanel:onShow()
	print("=======MagicLampPowerPanel:onShow")
	self.jinnType = self.param.jinnType
	self.blessID = self.param.blessID
	self.selectedIdx = nil
	self:updateSkills()
	self:updateView()
end
function MagicLampPowerPanel:updateView()
	print("======== MagicLampPowerPanel:updateView")
	self.usingSkillID = magicLampCtrl:getBlessSkillId(self.jinnType, self.blessID)
	self.oldSkillData = self.usingSkillID and magicLampSkillCtrl:getSkillData(self.usingSkillID) or nil
	self.oldSkillType = self.oldSkillData and self.oldSkillData.skillType or nil
	self.newSkillData = self.selectedIdx and self.skillList[self.selectedIdx] or nil
	self.newSkillType = self.newSkillData and self.newSkillData.skillType or nil
	local curStatus = 3
	if self.oldSkillData and self.newSkillData then
		curStatus = 0
	elseif self.oldSkillData then
		curStatus = 1
	elseif self.newSkillData then
		curStatus = 2
	end
	self.fields.Hole_old:initData(self.oldSkillData)
	self.fields.Hole_new:initData(self.newSkillData)
	self.controllers.Ctrl_status:setSelectedIndex(curStatus)
	self.fields.Button_inlay:setEnabled(curStatus ~= 3)
end
function MagicLampPowerPanel:updateSkills()
	self.usingSkillID = magicLampCtrl:getBlessSkillId(self.jinnType, self.blessID)
	local skillList = magicLampSkillCtrl:getSkillList()
	self.usingMap, magicLampCtrl, self.skillList, magicLampCtrl = magicLampSkillCtrl, magicLampSkillCtrl, magicLampSkillCtrl, magicLampSkillCtrl
	for i, v in ipairs(skillList) do
		if v.id ~= self.usingSkillID then
			table.insert(self.skillList, v)
			self.usingMap[v.id] = magicLampCtrl:getIsUsing(v.id)
		end
	end
	table.sort(self.skillList, function(a, b)
		local isUsingA = self.usingMap[a.id]
		local isUsingB = self.usingMap[b.id]
		if isUsingA ~= isUsingB then
			return isUsingA
		end
		local qualityA = magicLampSkillRead.getSkillQuality(a.skillType)
		local qualityB = magicLampSkillRead.getSkillQuality(b.skillType)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		if a.classLv ~= b.classLv then
			return a.classLv > b.classLv
		end
		if a.lv ~= b.lv then
			return a.lv > b.lv
		end
		if a.skillType ~= b.skillType then
			return a.skillType < b.skillType
		end
		return a.id < b.id
	end)
	self.fields.List_skill:setNumItems(#self.skillList)
	self.fields.Text_empty:setVisible(#self.skillList == 0)
	self.controllers.c1:setSelectedIndex(#self.skillList == 0 and 1 or 0)
	if #self.skillList == 0 then
		self.fields.Text_empty:setString(i18n("magic_lamp_text_098"))
	end
end
function MagicLampPowerPanel:onGetMore()
	SoraDPlaySound()
	local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
	if magicLampSkillLotteryCtrl:getIsUnlock() then
		SoraDRemoveAllPanelFromManager()
		uiManager:show("MagicLampMaigcPowerMain")
	else
		SoraDShowMsgTip(i18n("allitreas_text_03"))
	end
end
function MagicLampPowerPanel:onInlay()
	SoraDPlaySound()
	if not self.newSkillData then
		return
	end
	if self.oldSkillData ~= nil and magicLampCtrl:getIsUsing(self.newSkillData.id) then
		local blessSkillData = magicLampCtrl:getUsingSkillIdList()
		for k, v in pairs(blessSkillData) do
			if k ~= self.jinnType then
				for k2, v2 in pairs(v) do
					local skillData = magicLampSkillCtrl:getSkillData(v2)
					if skillData.skillType == self.oldSkillData.skillType then
						_ENV = nil
						;(nil).name = magicLampRead.getJinnName(k)
						;(nil).skillname = magicLampSkillRead.getSkillName(skillData.skillType)
						SoraDShowMsgTip(i18n("magic_lamp_tips_011", nil))
						return
					end
				end
			end
		end
	else
		local skillList1 = magicLampCtrl:getUsingSkillIdList()
		for k, v2 in pairs(skillList1) do
			for i, v in ipairs(v2) do
				local skillData = magicLampSkillCtrl:getSkillData(v)
				if v ~= self.usingSkillID and skillData.skillType == self.newSkillData.skillType and skillData.id ~= self.newSkillData.id then
					_ENV = i18n("magic_lamp_tips_011", nil)
					i18n("magic_lamp_tips_011", nil).name = magicLampRead.getJinnName(k)
					SoraDShowMsgTip(i18n("magic_lamp_tips_012", i18n("magic_lamp_tips_011", nil)))
					return
				end
			end
		end
	end
	magicLampCtrl:reqMagicLampWearSkill(self.jinnType, self.blessID, self.newSkillData.id)
	self:setSelectedIdx(nil)
end
function MagicLampPowerPanel:onRemove()
	SoraDPlaySound()
	if not self.oldSkillData then
		return
	end
	magicLampCtrl:reqMagicLampTakeOffSkill(self.jinnType, self.oldSkillData.id)
	self:setSelectedIdx(nil)
end
function MagicLampPowerPanel:onItemsRenderer(index, obj)
	local data = self.skillList[index + 1]
	obj:initData(data, index + 1 == self.selectedIdx, self.usingMap[data.id])
end
function MagicLampPowerPanel:onClickItem(context)
	SoraDPlaySound()
	local obj = context:getGObjectData()
	self:setSelectedIdx(nil, obj)
end
function MagicLampPowerPanel:setSelectedIdx(itemIndex, obj)
	if obj then
		local childIndex = self.fields.List_skill:getChildIndex(obj)
		itemIndex = self.fields.List_skill:childIndexToItemIndex(childIndex) + 1
	end
	if itemIndex == self.selectedIdx then
		self.selectedIdx = nil
	else
		self.selectedIdx = itemIndex
	end
	self.fields.List_skill:setNumItems(#self.skillList)
	self:updateView()
end
return MagicLampPowerPanel

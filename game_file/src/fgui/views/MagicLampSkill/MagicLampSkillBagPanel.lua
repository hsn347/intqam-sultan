local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillBagPanel = class("MagicLampSkillBagPanel", baseFguiPanel)
function MagicLampSkillBagPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillBagPanel:ctor", self.viewName)
	local constantRead = include("constantRead")
	self.is3SSwitchOpen = constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	local backpack = backpackCtrl:getBackpack(gBackpackDef.MAGIC_LAMP_SKILL)
	local itemList = backpack:getItemList()
	table.sort(itemList, function(a, b)
		local qualityA = backpackltCtrl:getItemQuality(a.id)
		local qualityB = backpackltCtrl:getItemQuality(b.id)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		return a.id < b.id
	end)
	local _ENV, ret = table.sort, table.sort
	for i, data in ipairs(itemList) do
		local quality = backpackltCtrl:getItemQuality(data.id)
		if not ret[quality] then
			_ENV = ret[quality]
		end
		ret[quality] = ret[quality]
		table.insert(ret[quality], data)
	end
	ret[0] = itemList
	self.itemList = ret
end
function MagicLampSkillBagPanel:onInit()
	print("=======MagicLampSkillBagPanel:onInit")
	self.fields.Com_title:initData(i18n("jinn_skill_58"), handler(self, self.onClickClose))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.noteSize = self.fields.Com_note:getContentSize()
	self.fieldsNote = fguiHelper.get_fields(self.fields.Com_note)
	self.fieldsNote.Button_use:setString(i18n("common_text_1352"))
	self.fieldsNote.Button_use:addClickListener(handler(self, self.onClickBtnUse))
end
function MagicLampSkillBagPanel:onShow()
	print("=======MagicLampSkillBagPanel:onShow")
	self.curSelectIndex = 1
	_ENV = nil
	;(nil).defaultSelect = self.curSelectIndex
	;(nil).callback = handler(self, self.onClickQualityTab)
	;(nil).autoColumnGap = true
	self.fields.Com_qualityMenu:initMenuData(nil)
	self:onClickQualityTab(self.curSelectIndex)
end
function MagicLampSkillBagPanel:onClickQualityTab(selectIndex)
	self.view:addChild(self.fields.Com_note)
	self.curSelectIndex = selectIndex
	if self.is3SSwitchOpen then
		_UPVALUE6_ = self.is3SSwitchOpen
		self.is3SSwitchOpen[1] = 0
		self.is3SSwitchOpen[2] = 5
		self.is3SSwitchOpen[3] = 4
		self.is3SSwitchOpen[4] = 3
		self.is3SSwitchOpen[5] = 2
		self.is3SSwitchOpen[6] = 1
		if self.is3SSwitchOpen then
			goto lbl_27
		end
	end
	_UPVALUE5_ = self.is3SSwitchOpen
	self.is3SSwitchOpen[1] = 0
	self.is3SSwitchOpen[2] = 4
	self.is3SSwitchOpen[3] = 3
	self.is3SSwitchOpen[4] = 2
	local self.is3SSwitchOpen[5], config = 1, self.is3SSwitchOpen
	::lbl_27::
	if not self.itemList[config[self.curSelectIndex]] then
		_UPVALUE0_ = self.itemList[config[self.curSelectIndex]]
	end
	self.showList = self.itemList[config[self.curSelectIndex]]
	self.fields.List_item:setNumItems(#self.showList)
	self:hideItemEffect()
	self:setComNoteVisible(false)
end
function MagicLampSkillBagPanel:onItemRenderer(index, obj)
	local _index = index + 1
	local data = self.showList[_index]
	obj.Com_item = obj:getChild("Com_item")
	obj.Com_item:initData(data.id, data.count)
	obj.Com_item:setClickCallback(handlerEx(self, self.onClickItem, _index))
end
function MagicLampSkillBagPanel:onClickBtnUse(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.curItemID
	uiManager:show("MagicLampSkillMerge", nil)
end
function MagicLampSkillBagPanel:onClickItem(_index)
	local data = self.showList[_index]
	self.curItemID = data.id
	local itemName = itemDesRead.getName(self.curItemID)
	local itemDes = itemDesRead.getDes(self.curItemID)
	local nameStr = string.format([[
%s
%s]], itemName, itemDes)
	self.fieldsNote.Text_name:setString(nameStr)
	local addIndex = math.ceil(_index / 5) * 5
	self.fields.List_item:addChildAt(self.fields.Com_note, addIndex)
	local obj = self.fields.List_item:getChildAt(_index - 1)
	if self.curObj and self.curObj == obj then
		self:hideItemEffect()
		self:setComNoteVisible(false)
	else
		self:hideItemEffect()
		self.curObj = obj
		self.curObj.Com_item:setEffectShow(true)
		self:setComNoteVisible(true)
		local posx = obj:getPositionX()
		self.fieldsNote.Image_arr:setPositionX(posx)
	end
end
function MagicLampSkillBagPanel:hideItemEffect(...)
	if self.curObj then
		self.curObj.Com_item:setEffectShow(false)
		self.curObj = nil
	end
end
function MagicLampSkillBagPanel:setComNoteVisible(visible)
	if visible then
		self.fields.Com_note:setContentSize(self.noteSize)
		self.fields.Com_note:setVisible(true)
	else
		self.fields.Com_note:setVisible(false)
		self.fields.Com_note:setContentSize(cc.size(640, 0))
		self.fields.List_item:addChildAt(self.fields.Com_note, #self.showList)
	end
end
function MagicLampSkillBagPanel:onMsgAfterMerge(target, event)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	local skillType = event.skillType
	local needItems = magicLampSkillRead.getSkillCompound(skillType)
	for i, v in ipairs(needItems) do
		self:updateShowItem(v.id)
	end
end
function MagicLampSkillBagPanel:updateShowItem(itemID)
	local findIndex
	for i, v in ipairs(self.showList) do
		if v.id == itemID then
			findIndex = i
			break
		end
	end
	if not findIndex then
		return
	end
	local obj = self.fields.List_item:getChildAt(findIndex - 1)
	if obj then
		local data = self.showList[findIndex]
		local itemCount = backpackCtrl:getItemCount(data.id)
		if 0 < itemCount then
			data.count = itemCount
			obj.Com_item:initData(data.id, data.count)
		else
			table.remove(self.showList, findIndex)
			self:hideItemEffect()
			self.fields.List_item:removeChildAt(findIndex - 1, true)
			self:setComNoteVisible(false)
		end
	end
end
return MagicLampSkillBagPanel

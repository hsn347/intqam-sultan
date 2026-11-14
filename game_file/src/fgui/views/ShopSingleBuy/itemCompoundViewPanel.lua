local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemDesRead = include("itemDesRead")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local itemCompoundViewPanel = class("itemCompoundViewPanel", baseFguiPanel)
function itemCompoundViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("itemCompoundViewPanel:ctor", self.viewName)
end
function itemCompoundViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function itemCompoundViewPanel:onInit()
	print("=======itemCompoundViewPanel:onInit")
	self.tableMaterial, _ENV, self.canMerge = print, print, nil
	self:hideEffect()
	self.fields.Panel_bg:setString(i18n("common_text_1753"))
	self.fields.Text_title:setString(i18n("common_text_1755"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.Button_compound:setString(i18n("common_text_1352"))
	self.fields.Button_compound:addClickListener(handler(self, self.btnCompoundClick))
	self.fields.Button_all:setString(i18n("common_text_1754"))
	self.fields.Button_all:addClickListener(handler(self, self.btnCompoundAllClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_compound:fixPos()
	self.fields.Button_all:fixPos()
end
function itemCompoundViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableMaterial[index + 1])
end
function itemCompoundViewPanel:onShow()
	print("=======itemCompoundViewPanel:onShow")
	self.itemID = self.param.itemID
	self:initData()
end
function itemCompoundViewPanel:initData()
	self.curItemID = backpackltCtrl:getItemIDByMaterial(self.itemID)
	self.tableMaterial = backpackltCtrl:getMaterialOfMergeItem(self.curItemID)
	self.itemType = backpackltCtrl:getItemType(self.itemID)
	self:updateView()
end
function itemCompoundViewPanel:updateView()
	self.fields.item:initData(self.curItemID)
	if self.itemType == gItemType.WAR_PARTERN_FRAGMENT then
		self.fields.Text_name:setString(artifactRuneRead.getRuneName(self.curItemID))
		self.fields.Text_des:setString(artifactRuneRead.getRuneDes(self.curItemID))
	else
		self.fields.Text_name:setString(itemDesRead.getName(self.curItemID))
		self.fields.Text_des:setString(itemDesRead.getDes(self.curItemID))
	end
	self.fields.List:setNumItems(#self.tableMaterial)
	for i = 1, self.fields.List:getNumItems() do
		local item = self.fields.List:getChildAt(i - 1)
		self.canMerge = self.canMerge and math.min(self.canMerge, item:getMergeCount()) or item:getMergeCount()
	end
end
function itemCompoundViewPanel:hideEffect()
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_2:setVisible(false)
	self.fields.Particle_3:setVisible(false)
end
function itemCompoundViewPanel:playEffect()
	self.fields.Particle_1:setVisible(true)
	self.fields.Particle_1:resetSystem()
	self.fields.Particle_2:setVisible(true)
	self.fields.Particle_2:resetSystem()
	self.fields.Particle_3:setVisible(true)
	self.fields.Particle_3:resetSystem()
end
function itemCompoundViewPanel:addItemUseEffect()
	self:playEffect()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		self:updateView()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:updateView()
	end)
	self:runAction(ffa.seq(nil))
end
function itemCompoundViewPanel:checkCanMerge()
	if self.canMerge <= 0 then
		local data = itemDesRead.getOutput(self.curItemID)
		if 0 < #data then
			itemDesRead = nil
			;(nil).itemID = self.curItemID
			uiManager:show("CommonSourceGuide", nil)
		elseif self.itemType == gItemType.WAR_PARTERN_FRAGMENT then
			SoraDShowMsgTip(i18n("notice_0184"), artifactRuneRead.getRuneIcon(self.itemID))
		else
			SoraDShowMsgTip(i18n("notice_0184"), itemDesRead.getIcon(self.curItemID, true))
		end
		return false
	else
		return true
	end
end
function itemCompoundViewPanel:btnCompoundClick()
	SoraDPlaySound()
	if self:checkCanMerge() then
		backpackCtrl:mergeItem(self.curItemID)
	end
end
function itemCompoundViewPanel:btnCompoundAllClick()
	SoraDPlaySound()
	if self:checkCanMerge() then
		backpackCtrl:mergeItemAsPossible(self.curItemID)
	end
end
return itemCompoundViewPanel

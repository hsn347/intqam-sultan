local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemHoleDetailPanel = class("WarGemHoleDetailPanel", baseFguiPanel)
function WarGemHoleDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WarGemHoleDetailPanel:ctor", self.viewName)
end
function WarGemHoleDetailPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WarGem"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function WarGemHoleDetailPanel:onInit()
	print("=======WarGemHoleDetailPanel:onInit")
	self.controllers.c1:fix()
	self.fields.Button_enchant:fixPos()
	self.fields.Button_enchant2:fixPos()
	self.fields.Button_compose:fixPos()
	self.fields.Button_compose2:fixPos()
	self.fields.Button_replace2:fixPos()
	self.fields.LittleResView:fixPos()
	self.fields.Label_enchant:setString(i18n("gemEnchant_text_16"))
	_ENV = i18n("gemEnchant_text_16")
	i18n("gemEnchant_text_16").lv = 1
	self.fields.Text_unlock:setString((i18n("gemEnchant_text_13", i18n("gemEnchant_text_16"))))
	self.fields.Button_enchant:setString(i18n("gemEnchant_text_16"))
	self.fields.Button_enchant2:setString(i18n("gemEnchant_text_16"))
	self.fields.Button_replace:setString(i18n("common_text_1371"))
	self.fields.Button_replace2:setString(i18n("common_text_1371"))
	self.fields.Button_inlay:setString(i18n("common_text_3879"))
	self.fields.Button_color:setString(i18n("gemEnchant_text_54"))
	self.fields.Button_enchant:addClickListener(handler(self, self.onClickEnchant))
	self.fields.Button_enchant2:addClickListener(handler(self, self.onClickEnchant))
	self.fields.Button_replace:addClickListener(handler(self, self.onClickReplace))
	self.fields.Button_replace2:addClickListener(handler(self, self.onClickReplace))
	self.fields.Button_inlay:addClickListener(handler(self, self.onClickInlay))
	self.fields.Button_compose:addClickListener(handler(self, self.onClickCompose))
	self.fields.Button_compose2:addClickListener(handler(self, self.onClickCompose))
	self.fields.Button_color:addClickListener(handler(self, self.onClickColor))
	self.fields.List_enchant:setItemRenderer(handler(self, self.onItemRenderer))
end
function WarGemHoleDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.lv, self.idx, index + 1)
end
function WarGemHoleDetailPanel:onClickEnchant()
	local lv = self.lv
	local idx = self.idx
	SoraDPlaySound()
	_ENV = nil
	;(nil).lv = lv
	;(nil).idx = idx
	uiManager:show("WarGemHoleEnchant", nil)
end
function WarGemHoleDetailPanel:onClickReplace()
	SoraDPlaySound()
	_ENV = nil
	;(nil).lv = self.lv
	;(nil).idx = self.idx
	uiManager:show("WarGemHoleInlay", nil)
	self:closePanel()
end
function WarGemHoleDetailPanel:onClickInlay()
	SoraDPlaySound()
	local lv = self.lv
	local idx = self.idx
	self:closePanel()
	_ENV = nil
	;(nil).lv = lv
	;(nil).idx = idx
	uiManager:show("WarGemHoleInlay", nil)
end
function WarGemHoleDetailPanel:onClickCompose()
	SoraDPlaySound()
	if self:isGemMaxLv() then
		SoraDShowMsgTip(i18n("common_text_3900"))
		return
	end
	_ENV = i18n("common_text_3900")
	i18n("common_text_3900").lv = self.lv
	i18n("common_text_3900").idx = self.idx
	i18n("common_text_3900").inlay = true
	uiManager:show("WarGemCompose", i18n("common_text_3900"))
	self:closePanel()
end
function WarGemHoleDetailPanel:isGemMaxLv()
	if self.gemID and self.gemID > 0 then
		local newGemID = warGemltCtrl:getGemMaterialIDAfterMerge(self.gemID)
		return newGemID == 0
	end
	return false
end
function WarGemHoleDetailPanel:onClickColor()
	SoraDPlaySound()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	local lv = SoraDGetBuildLv(BUILDID.MIRACLE)
	local constantRead = include("constantRead")
	local needLv = constantRead.getConstValue("WAR_STONE_CHANGE_LEVLE")
	if lv < needLv then
		local buildDescribeRead = include("buildDescribeRead")
		_ENV = nil
		;(nil).var = needLv
		SoraDShowMsgTip(i18n("gemEnchant_text_57", nil))
		return
	end
	_ENV = i18n("gemEnchant_text_57", nil)
	i18n("gemEnchant_text_57", nil).lv = self.lv
	i18n("gemEnchant_text_57", nil).idx = self.idx
	uiManager:show("WarGemHoleColor", i18n("gemEnchant_text_57", nil))
end
function WarGemHoleDetailPanel:onIntoPanel()
	self.fields.LittleResView:setVisible(true)
end
function WarGemHoleDetailPanel:onLeavePanel()
	self.fields.LittleResView:setVisible(false)
end
function WarGemHoleDetailPanel:onShow()
	print("=======WarGemHoleDetailPanel:onShow")
	self.lv = self.param.lv
	self.idx = self.param.idx
	self.fields.LittleResView:setVisible(true)
	self.fields.LittleResView:initData(warGemCtrl:getResParam(self.lv, self.idx))
	local changes = warGemltCtrl:getGemHoleChange(self.lv, self.idx)
	self.fields.Button_color:setVisible(0 < #changes)
	self:updateView()
end
function WarGemHoleDetailPanel:updateView()
	self:updateHole()
	self:updateEnchant()
end
function WarGemHoleDetailPanel:updateHole()
	local color = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	local title = wargemResRead.getColorTitle(color)
	self.fields.Panel_bg:setString(i18n(title))
	self.fields.Hole:initData(self.lv, self.idx)
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
	local bidLv = SoraDGetBuildStarLv(BUILDID.MIRACLE)
	self.unlock = 0 < bidLv
	self.gemID = gemID or 0
	if self.unlock then
		self.controllers.c1:setSelectedIndex(0 < self.gemID and 0 or 1)
	else
		self.controllers.c1:setSelectedIndex(0 < self.gemID and 2 or 3)
	end
	local isPanelActive = warGemCtrl:isCurPanelActive()
	self.fields.Button_compose:setGrayed(not isPanelActive)
	self.fields.Button_compose:setTouchable(isPanelActive)
	self.fields.Button_compose2:setGrayed(not isPanelActive)
	self.fields.Button_compose2:setTouchable(isPanelActive)
	self.dismountCost = 0
	if 0 < self.gemID then
		if isPanelActive then
			self.dismountCost = warGemltCtrl:getGemDismantle(gemID)
		end
		self.fields.Button_replace:setCost(gIDDef.MITHRIL, self.dismountCost)
		self.fields.Button_replace2:setCost(gIDDef.MITHRIL, self.dismountCost)
		self.fields.Text_attr:setString(wargemResRead.getAttrHtmlByID(gemID))
		if self:isGemMaxLv() then
			self.fields.Button_compose:setString(i18n("common_text_283"))
			self.fields.Button_compose2:setString(i18n("common_text_283"))
		else
			self.fields.Button_compose:setString(i18n("common_text_1352"))
			self.fields.Button_compose2:setString(i18n("common_text_1352"))
		end
	else
		self.fields.Text_attr:setString(i18n("gemEnchant_text_12"))
	end
end
function WarGemHoleDetailPanel:updateEnchant()
	if self.unlock then
		self.fields.List_enchant:setNumItems(3)
	else
		self.fields.List_enchant:setNumItems(0)
	end
end
function WarGemHoleDetailPanel:onHide()
	print("=======WarGemHoleDetailPanel:onHide")
end
function WarGemHoleDetailPanel:onDispose()
	print("=======WarGemHoleDetailPanel:onDispose")
end
function WarGemHoleDetailPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "gemSingle" then
		return self.fields.Button_inlay
	end
	return SoraDGetChildByName(self, itemName)
end
return WarGemHoleDetailPanel

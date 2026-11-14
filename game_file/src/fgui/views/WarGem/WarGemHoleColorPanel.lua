local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemHoleColorPanel = class("WarGemHoleColorPanel", baseFguiPanel)
function WarGemHoleColorPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WarGemHoleColorPanel:ctor", self.viewName)
end
function WarGemHoleColorPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WarGem"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function WarGemHoleColorPanel:onInit()
	print("=======WarGemHoleColorPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("gemEnchant_text_54"))
	self.fields.Button_change:setString(i18n("gemEnchant_text_53"))
	self.fields.Text_cur:setString(i18n("common_text_4345"))
	self.fields.Text_select:setString(i18n("gemEnchant_text_55"))
	self.fields.List_change:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_change:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Button_change:addClickListener(handler(self, self.onClickChange))
end
function WarGemHoleColorPanel:onItemRenderer(index, obj)
	obj:initData(self.changes[index + 1], index + 1)
end
function WarGemHoleColorPanel:onClickItem()
	print("onClickItem!!!!!!!")
	SoraDPlaySound()
	self:updateBtn()
end
function WarGemHoleColorPanel:onClickChange()
	SoraDPlaySound()
	local data = self.data
	local curNum = backpackCtrl:getItemCount(data.itemID)
	if curNum < data.itemCount then
		_ENV = nil
		;(nil).content = i18n("gemEnchant_text_50")
		;(nil).confirmString = i18n("common_text_477")
		;(nil).confirmFunc = function()
			local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(data.itemID)
			if itemInfo then
				_ENV = nil
				;(nil).itemData = itemInfo
				uiManager:show("newShopSingleBuy", nil)
			else
				SoraDShowMsgTip(i18n("notice_0170"))
			end
		end
		uiManager:show("MessageBox", nil)
		return
	end
	local srcColor = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	local srcColorValue = warGemltCtrl:getColorValue(srcColor)
	local srcColorName = warGemltCtrl:getColorName(srcColor)
	local srcColorString = fguiHelper.getColorString(srcColorValue, i18n(srcColorName))
	local targetColor = data.color
	local targetColorValue = warGemltCtrl:getColorValue(targetColor)
	local targetColorName = warGemltCtrl:getColorName(targetColor)
	local targetColorString = fguiHelper.getColorString(targetColorValue, i18n(targetColorName))
	print(data.color, colorValue, colorName)
	_ENV = colorName
	_ENV = i18n(targetColorName)
	i18n(targetColorName).var = srcColorString
	i18n(targetColorName).var1 = targetColorString
	colorName.content = i18n("gemEnchant_text_46", i18n(targetColorName))
	colorName.cancel = true
	function colorName.confirmFunc()
		SoraDShowLoading(self:displayObject())
		warGemCtrl:reqChangeHoleColor(warGemCtrl:getEditPanelId(), self.lv, self.idx, targetColor)
	end
	uiManager:show("MessageBox", colorName)
end
function WarGemHoleColorPanel:onShow()
	print("=======WarGemHoleColorPanel:onShow")
	self.lv = self.param.lv
	self.idx = self.param.idx
	self:updateView()
end
function WarGemHoleColorPanel:updateView()
	local color = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	self.fields.Com_curHole:setColor(color)
	local title = wargemResRead.getColorTitle(color)
	self.fields.Text_name:setString(i18n(title))
	local colorValue = warGemltCtrl:getColorValue(color)
	self.fields.Text_name:setColor(SoraDHtmlColor2RGB(colorValue))
	local colorDes = warGemltCtrl:getColorDescribe(color)
	self.fields.Text_desc:setString(i18n(colorDes))
	local changes = warGemltCtrl:getGemHoleChange(self.lv, self.idx)
	self.changes, warGemCtrl = warGemltCtrl, warGemltCtrl
	for i, v in ipairs(changes) do
		if v.color ~= color then
			table.insert(self.changes, v)
		end
	end
	dump(self.changes, "self.changes======", 10)
	self.fields.List_change:setNumItems(#self.changes)
	self.fields.List_change:setSelectedIndex(0)
	print("getSelectedIndex", self.fields.List_change:getSelectedIndex())
	self:updateBtn()
end
function WarGemHoleColorPanel:updateBtn()
	print("WarGemHoleColorPanel:updateBtn")
	local index = self.fields.List_change:getSelectedIndex() + 1
	print("index===", index)
	local data = self.changes[index]
	self.data = data
	dump(data, "data==" .. index, 10)
	self.fields.Button_change:setCost(data.itemID, data.itemCount)
end
function WarGemHoleColorPanel:onHide()
	print("=======WarGemHoleColorPanel:onHide")
end
function WarGemHoleColorPanel:onDispose()
	print("=======WarGemHoleColorPanel:onDispose")
end
return WarGemHoleColorPanel

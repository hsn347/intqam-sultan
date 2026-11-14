local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
_ENV = "resDesRead"
;("resDesRead").SELECT = 0
local ("resDesRead").UNSELECT, CTRL_INDEX = 1, "resDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemHoleInlayPanel = class("WarGemHoleInlayPanel", baseFguiPanel)
function WarGemHoleInlayPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHidePrePanel = true
	self.debug = true
	print("WarGemHoleInlayPanel:ctor", self.viewName)
end
function WarGemHoleInlayPanel:getPackageList()
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
function WarGemHoleInlayPanel:onInit()
	print("=======WarGemHoleInlayPanel:onInit")
	self.fields.LittleResView:fixPos()
	self.controllers.Ctrl_status:fix()
	self.view:fixChildrenPos()
	self.fields.Effect_arrow:fix()
	self.fields.Bg_l:fix()
	self.fields.Bg_r:fix()
	self.fields.Text_empty:setString(i18n("gemEnchant_text_65"))
	self.fields.Button_getMore:addClickListener(handler(self, self.onClickGetMore))
	self.fields.Button_inlay:addClickListener(handler(self, self.onClickInlay))
	self.fields.Button_replace:addClickListener(handler(self, self.onClickReplace))
	self.fields.Button_remove:addClickListener(handler(self, self.onClickRemove))
	self.fields.Button_getMore:setString(i18n("common_text_3882"))
	self.fields.Button_inlay:setString(i18n("common_text_3879"))
	self.fields.Button_replace:setString(i18n("common_text_1371"))
	self.fields.Button_remove:setString(i18n("common_text_1329"))
	self.fields.List_gem:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.List_gem:setItemRenderer(handler(self, self.onItemRenderer))
end
function WarGemHoleInlayPanel:onClickInlay()
	SoraDPlaySound()
	local curIndex = warGemCtrl:getEditPanelId()
	if not warGemCtrl:checkVip(curIndex, true) then
		return
	end
	local name = wargemResRead.getName(self.newGem)
	local level = wargemResRead.getLevel(self.newGem)
	_ENV = nil
	;(nil).level = level
	;(nil).name = name
	local strTip = i18n("common_text_3884", nil)
	SoraDShowMsgBox(strTip, i18n("common_text_204"), nil, function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			SoraDPlaySound("warGem", 3)
			SoraDShowLoading(self:displayObject())
			warGemCtrl:reqMountInPanel(curIndex, self.newGem, self.lv, self.idx)
			_ENV = warGemCtrl
			warGemCtrl.msg = "MESSAGE_UI_WARGEM_MOUNT_REQ"
			SoraDSendMessage(warGemCtrl)
		end
	end, nil, nil, true)
end
function WarGemHoleInlayPanel:onClickReplace()
	SoraDPlaySound()
	local curIndex = warGemCtrl:getEditPanelId()
	if not warGemCtrl:checkVip(curIndex, true) then
		return
	end
	if not SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost) then
		_ENV, warGemCtrl = gIDDef.MITHRIL, SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)
		gIDDef.MITHRIL.resid = gIDDef.MITHRIL
		gIDDef.MITHRIL.rescount = self.dismountCost
		local SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)[1], needResList = gIDDef.MITHRIL, SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)
		_ENV = nil
		;(nil).rid = gIDDef.MITHRIL
		;(nil).needResData = needResList
		uiManager:show("resourceBuyView", nil)
		return
	end
	SoraDShowMsgBox(i18n("common_text_3899"), i18n("common_text_204"), nil, function(msgType)
		if MSGBOX_CALLBACK_YES == msgType then
			SoraDShowLoading(self:displayObject())
			warGemCtrl:ReqReplaceToPanel(curIndex, self.lv, self.idx, self.newGem)
		end
	end)
end
function WarGemHoleInlayPanel:onClickRemove()
	SoraDPlaySound()
	local curIndex = warGemCtrl:getEditPanelId()
	if not warGemCtrl:checkVip(curIndex, true) then
		return
	end
	if not SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost) then
		_ENV, warGemCtrl = gIDDef.MITHRIL, SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)
		gIDDef.MITHRIL.resid = gIDDef.MITHRIL
		gIDDef.MITHRIL.rescount = self.dismountCost
		local SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)[1], needResList = gIDDef.MITHRIL, SoraDEnoughRes(gIDDef.MITHRIL, self.dismountCost)
		_ENV = nil
		;(nil).rid = gIDDef.MITHRIL
		;(nil).needResData = needResList
		uiManager:show("resourceBuyView", nil)
		return
	end
	SoraDShowMsgBox(i18n("common_text_3890"), i18n("common_text_204"), nil, function(msgType)
		if MSGBOX_CALLBACK_YES == msgType then
			SoraDPlaySound("warGem", 4)
			SoraDShowLoading(self:displayObject())
			warGemCtrl:reqDismountFromPanel(curIndex, self.lv, self.idx)
		end
	end, nil, nil, true)
end
function WarGemHoleInlayPanel:onClickGetMore()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.WAR_GEM
	;(nil).itemType2 = gItemType.POWERFUL_ESSENCE
	uiManager:show("vipBuyView", nil)
end
function WarGemHoleInlayPanel:onClickItem()
	SoraDPlaySound()
	self:updateSelect()
end
function WarGemHoleInlayPanel:onItemRenderer(index, obj)
	index = index + 1
	local gemData = self.gems[index]
	obj:setCanSelected(true)
	if self.oldGem > 0 and index == 1 then
		obj:initData(gemData.id)
		if self.oldGem == gemData.id then
			obj:setNumText(i18n("common_text_4092"))
		end
		obj:setNumColor(cc.c3b(0, 255, 0))
	else
		obj:initData(gemData.id, gemData.count)
	end
end
function WarGemHoleInlayPanel:onIntoPanel()
	self.fields.LittleResView:setVisible(true)
end
function WarGemHoleInlayPanel:onLeavePanel()
	self.fields.LittleResView:setVisible(false)
end
function WarGemHoleInlayPanel:onShow()
	print("=======WarGemHoleInlayPanel:onShow")
	self.lv = self.param.lv
	self.idx = self.param.idx
	self.dismountCost = 0
	local lv = self.lv
	local idx = self.idx
	self.fields.LittleResView:initData(warGemCtrl:getResParam(self.lv, self.idx))
	local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), lv, idx)
	self.oldGem = gemID or 0
	if gemID and 0 < gemID then
		self.fields.Panel_bg:setTitle(i18n("common_text_1371"))
		CTRL_INDEX.SELECT = 0
		CTRL_INDEX.UNSELECT = 1
		self.fields.Hole_old:initData(lv, idx)
		self.fields.Text_oldName:setString(wargemResRead.getName(gemID))
		self.fields.Text_oldAttr:setString(wargemResRead.getAttrHtmlByID(gemID))
		if warGemCtrl:isCurPanelActive() then
			self.dismountCost = warGemltCtrl:getGemDismantle(gemID)
		end
	else
		self.fields.Panel_bg:setTitle(i18n("common_text_3879"))
		CTRL_INDEX.SELECT = 2
		CTRL_INDEX.UNSELECT = 3
	end
	self:updateList()
	self:updateCost()
end
function WarGemHoleInlayPanel:updateList()
	local gemBagList = warGemCtrl:getGemBagList(warGemCtrl:getEditPanelId())
	self.gems, warGemCtrl = warGemCtrl, warGemCtrl
	local color = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	print(self.lv, self.idx, color, #gemBagList)
	for i, v in ipairs(gemBagList) do
		if not warGemltCtrl:isEnchantedItem(v.id) and (color == 0 or color == wargemResRead.getQuality(v.id)) then
			table.insert(self.gems, v)
		end
	end
	if 0 < self.oldGem then
		warGemCtrl = color
		color.id = self.oldGem
		color.count = 0
		table.insert(self.gems, 1, color)
	end
	print("宝石列表", self.oldGem, #self.gems)
	local count = #self.gems
	self.controllers.c1:setSelectedIndex(0 < count and 0 or 1)
	self.fields.List_gem:setNumItems(count)
	if 0 < count and self.fields.List_gem:getSelectedIndex() == -1 then
		self.fields.List_gem:setSelectedIndex(0)
	end
	self:updateSelect()
end
function WarGemHoleInlayPanel:updateSelect()
	local index = self.fields.List_gem:getSelectedIndex() + 1
	print("index", index, #self.gems)
	local newGem = 0
	if 0 < index and index <= #self.gems then
		newGem = self.gems[index].id
	end
	print("newGem", newGem)
	self.newGem = newGem
	if (self.oldGem == 0 or index ~= 1) and 0 < self.newGem then
		self.controllers.Ctrl_status:setSelectedIndex(CTRL_INDEX.SELECT)
		self.fields.Hole_new:setGem(newGem)
		self.fields.Text_newName:setString(wargemResRead.getName(self.newGem))
		self.fields.Text_newAttr:setString(wargemResRead.getAttrHtmlByID(self.newGem))
	else
		self.controllers.Ctrl_status:setSelectedIndex(CTRL_INDEX.UNSELECT)
		self.fields.Hole_new:setGem(0)
		self.fields.Text_newName:setString("")
		self.fields.Text_newAttr:setString("")
	end
	local color = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	self.fields.Hole_new:setColor(color)
end
function WarGemHoleInlayPanel:updateCost()
	print("WarGemHoleInlayPanel:updateCost", self.oldGem)
	if self.oldGem > 0 then
		self.fields.Button_remove:setCost(gIDDef.MITHRIL, self.dismountCost)
		self.fields.Button_replace:setCost(gIDDef.MITHRIL, self.dismountCost)
	end
end
function WarGemHoleInlayPanel:onHide()
	print("=======WarGemHoleInlayPanel:onHide")
end
function WarGemHoleInlayPanel:onDispose()
	print("=======WarGemHoleInlayPanel:onDispose")
end
function WarGemHoleInlayPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "gemSingle" then
		return self.fields.Button_inlay
	end
	return SoraDGetChildByName(self, itemName)
end
return WarGemHoleInlayPanel

local dailyRemindManager = include("dailyRemindManager")
local warGemltCtrl = include("warGemltCtrl")
local wargemltCtrl = warGemltCtrl
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemComposePanel = class("WarGemComposePanel", baseFguiPanel)
function WarGemComposePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WarGemComposePanel:ctor", self.viewName)
end
function WarGemComposePanel:getPackageList()
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
function WarGemComposePanel:onInit()
	if display.height < 1000 then
		local scale = display.height / 1000
		self.fields.Content:setScale(scale, scale)
		self.fields.Content:setDaijiScale(1 / scale, 1 / scale)
	end
	print("=======WarGemComposePanel:onInit")
	self.fields.Buttom_composeAll:fixPos()
	self.fields.Button_compose:fixPos()
	self.controllers.c1:fix()
	self.fields.Text_enough:setString(i18n("common_text_4090"))
	self.fields.Text_notEnough:setString(i18n("common_text_4091"))
	self.fields.Button_getMore:setString(i18n("common_text_3882"))
	self.fields.Button_compose:setString(i18n("common_text_1352"))
	self.fields.Buttom_composeAll:setString(i18n("common_text_1754"))
	self.fields.Com_title:initData(i18n("common_text_3892"), handler(self, self.onClickClose))
	self.fields.Button_getMore:addClickListener(handler(self, self.onClickGetMore))
	self.fields.List_gem:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.List_gem:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Buttom_composeAll:addClickListener(handler(self, self.onClickComposeAll))
	self.fields.Button_compose:addClickListener(handler(self, self.onClickCompose))
end
function WarGemComposePanel:onClickCompose()
	SoraDPlaySound()
	local reqFunc = function()
		if self.inlay then
			print("reqMergeInPanel", self.toMid, self.lv)
			warGemCtrl:reqMergeInPanel(self.lv, self.idx)
			SoraDShowLoading()
		else
			print("reqMergeInBag", self.toMid, self.lv)
			warGemCtrl:reqMergeInBag(self.toMid)
			SoraDShowLoading()
		end
	end
	if wargemResRead.getLevel(self.toMid) == 10 and dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.tenwargemcompose) then
		_ENV = nil
		;(nil).content = i18n("common_text_4669")
		;(nil).confirmFunc = reqFunc
		;(nil).cancel = true
		;(nil).remindString = i18n("coffeeCraftsman_text_27")
		;(nil).remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.tenwargemcompose)
			end
		end
		uiManager:show("MessageBox", nil)
	else
		reqFunc()
	end
end
function WarGemComposePanel:onClickComposeAll()
	SoraDPlaySound()
	local reqFunc = function()
		print("reqMergeAllInBag", self.toMid, self.lv)
		warGemCtrl:reqMergeAllInBag(self.toMid)
		SoraDShowLoading()
	end
	if wargemResRead.getLevel(self.toMid) == 10 and dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.tenwargemcompose) then
		_ENV = nil
		;(nil).content = i18n("common_text_4669")
		;(nil).confirmFunc = reqFunc
		;(nil).remindString = i18n("coffeeCraftsman_text_27")
		;(nil).remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.tenwargemcompose)
			end
		end
		uiManager:show("MessageBox", nil)
	else
		reqFunc()
	end
end
function WarGemComposePanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List_gem:getSelectedIndex() + 1
	if index == #self.gems then
		SoraDShowMsgTip(i18n("common_text_3900"))
		self.fields.List_gem:setSelectedIndex(self.lastIndex - 1)
	else
		self.gemID = self.gems[index]
		self:updateGem()
	end
end
function WarGemComposePanel:onItemRenderer(index, obj)
	index = index + 1
	local id = self.gems[index]
	local curCount = warGemCtrl:getItemCount(id)
	if index == #self.gems then
		obj:initData(id, curCount)
	else
		local needCount = wargemltCtrl:getGemNeedCount(id)
		obj:initData(id, curCount, needCount)
	end
end
function WarGemComposePanel:onClickGetMore()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.WAR_GEM
	;(nil).itemType2 = gItemType.POWERFUL_ESSENCE
	uiManager:show("vipBuyView", nil)
end
function WarGemComposePanel:onShow()
	print("=======WarGemComposePanel:onShow")
	self.lv = self.param.lv
	self.idx = self.param.idx
	self.gemID = self.param.gemID
	self.inlay = self.param.inlay
	self.lastIndex = 0
	self.controllers.c1:setSelectedIndex(self.inlay and 1 or 0)
	if not self.inlay then
		self:updateGemList()
	else
		local gemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
		if 0 < gemID then
			self.gemID = gemID
		else
			error("no gem in this place", self.lv, self.idx)
		end
	end
	self:updateView()
end
function WarGemComposePanel:updateView()
	if not self.inlay then
		self:updateGemList()
		self:updateList()
	end
	self:updateGem()
end
function WarGemComposePanel:showNextGem()
	local newGemID = warGemltCtrl:getGemMaterialIDAfterMerge(self.gemID)
	if warGemltCtrl:getGemMaterialIDAfterMerge(newGemID) > 0 then
		self.gemID = newGemID
	else
		self:removeFromParent()
		return
	end
	print("showNextGem", self.gemID, newGemID)
	if not self.inlay then
		self:updateList()
		self:updateGem()
	else
		self:updateGem()
	end
end
function WarGemComposePanel:updateGemList()
	local baseID = math.floor(self.gemID / 100) * 100
	self.gems, _ENV = self.gemID / 100, self.gemID / 100
	for i = 1, warGemCtrl:getGemListMax() do
		table.insert(self.gems, baseID + i)
	end
end
function WarGemComposePanel:updateList()
	print("updateList!!!!!!")
	self.fields.List_gem:setNumItems(#self.gems)
	local selectIndex = self.fields.List_gem:getSelectedIndex()
	if #self.gems > 0 and selectIndex == -1 or self.gems[selectIndex + 1] ~= self.gemID then
		local selectedIndex = 0
		for i, v in ipairs(self.gems) do
			if v == self.gemID then
				selectedIndex = i - 1
				break
			end
		end
		self.fields.List_gem:scrollToView(selectedIndex)
		self.fields.List_gem:setSelectedIndex(selectedIndex)
	end
end
function WarGemComposePanel:onGemMerge()
	self.fields.Button_compose:setTouchable(false)
	self.fields.Buttom_composeAll:setTouchable(false)
	self.fields.List_gem:setTouchable(false)
	self.fields.Content:showEffect()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Button_compose:setTouchable(true)
		self.fields.Buttom_composeAll:setTouchable(true)
		self.fields.List_gem:setTouchable(true)
		if self.inlay then
			self:showNextGem()
		else
			self:updateView()
		end
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Button_compose:setTouchable(true)
		self.fields.Buttom_composeAll:setTouchable(true)
		self.fields.List_gem:setTouchable(true)
		if self.inlay then
			self:showNextGem()
		else
			self:updateView()
		end
	end)
	self:runAction(ffa.seq(nil))
end
function WarGemComposePanel:updateGem()
	print("updateList!!!!!!")
	if not self.inlay then
		self.lastIndex = self.fields.List_gem:getSelectedIndex() + 1
		for i = 1, self.fields.List_gem:getNumItems() do
			local item = self.fields.List_gem:getChildAt(i - 1)
			item:setArrow(i == self.lastIndex + 1)
		end
	end
	local midGemID = warGemltCtrl:getGemMaterialIDAfterMerge(self.gemID)
	self.toMid = midGemID
	self.fields.Content:updateGem(self.gemID, self.toMid, self.lv, self.idx)
	local curCount = self.fields.Content:getGemCount()
	local costCount = warGemltCtrl:getGemMaterialCount(self.toMid, self.gemID)
	self.controllers.c2:setSelectedIndex(curCount >= costCount and 0 or 1)
end
function WarGemComposePanel:onHide()
	print("=======WarGemComposePanel:onHide")
end
function WarGemComposePanel:onDispose()
	print("=======WarGemComposePanel:onDispose")
end
return WarGemComposePanel

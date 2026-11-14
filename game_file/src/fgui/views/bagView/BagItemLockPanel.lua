local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BagItemLockPanel = class("BagItemLockPanel", baseFguiPanel)
function BagItemLockPanel:ctor(...)
	self.isLRU = true
	BagItemLockPanel.super.ctor(self, ...)
	print("BagItemLockPanel:ctor", self.viewName)
end
function BagItemLockPanel:onInit()
	self.fields.text_none:setString(i18n("common_text_4672"))
	print("=======BagItemLockPanel:onInit")
	self.fields.Com_title:initData(i18n("Safety_lock_text_32"), handler(self, self.onClickClose))
	self.fields.Button_lock:setTitle(i18n("Safety_lock_text_33"))
	self.fields.Button_lock:addClickEventListener(handler(self, self.onLockItem))
	self.fields.Button_unlock:setTitle(i18n("Safety_lock_text_34"))
	self.fields.Button_unlock:addClickEventListener(handler(self, self.onUnlockItem))
	self.fields.btn_search:setTitle(i18n("common_text_166"))
	self.fields.btn_search:addClickEventListener(handler(self, self.onSearch))
	self.fields.btn_close:getParent():setChildIndex(self.fields.btn_close, 6)
	self.fields.btn_close:addClickEventListener(handler(self, self.onCleanSearch))
	self.fields.btn_close:setVisible(false)
	self.fields.loader:fixPos()
	self.fields.btn_search:fixPos()
	self.fields.btn_close:fixPos()
	self.fields.n27:fixPos()
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self:initTextField()
	self.fields.tab:setTabClickCallback(handler(self, self.onTabClick))
	self.fields.maskArea:addEventListener(fgui.UIEventType.Click, handler(self, self.hideKeyboardMask))
end
function BagItemLockPanel:onTabClick(tag)
	if self.curTagIndex ~= tag then
		self:updateCurBtn(tag)
	end
end
function BagItemLockPanel:initTextField()
	self.textField = ccui.EditBox:create(cc.size(374, 60), "bg_transparent.png", ccui.TextureResType.plistType)
	self.textField:setName("textField")
	if self.textField.setControlType then
		self.textField:setControlType(1)
	end
	self.textField:setAnchorPoint(cc.p(0, 0))
	self.textField:setFontColor(cc.c3b(0, 0, 0))
	self.textField:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textField:setTextHorizontalAlignment(SoraDFLabelR())
	self.textField:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.textField:setMaxLength(30)
	self.textField:setFontSize(20)
	self.textField:setPlaceholderFontSize(20)
	function self.textField:getCharCount()
		return string.utf8len(self:getText())
	end
	function self.textField:getString()
		return RemoveStringSpecial(self:getText())
	end
	self.textField:setPlaceholderFontColor(cc.c3b(115, 99, 68))
	self.textField:setFontColor(cc.c3b(65, 35, 15))
	self.textField:setPlaceHolder(i18n("common_text_4670"))
	self.textField:setText("")
	self.textField:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	self.fields.loader:setContent(self.textField)
	self.textField:setPosition(cc.p(-187, 0))
	self.fields.tab:setFixTabWith(false)
end
function BagItemLockPanel:endShow()
	print("=======BagItemLockPanel:endShow")
	self.editItemIDList, _ENV = print, print
	self.fields.tab:updateTabList()
	self.curTagIndex = 0
	self.textField:setText("")
	self.fields.btn_close:setVisible(false)
	self.searchStr = nil
	self.fields.tab:updateTab(0)
	self:updateData()
end
function BagItemLockPanel:updateCurBtn(tag, noAction)
	self.curTagIndex = tag
	print("updateCurBtn", self.curTagIndex)
	self.fields.tab:updateTab(self.curTagIndex)
	self:updateData()
	self.fields.list:scrollToView(0)
end
function BagItemLockPanel:updateData()
	local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
	local tag = self.fields.tab:getTagByIndex(self.curTagIndex)
	self.fields.text_none:setVisible(false)
	self.itemList, backpackCtrl = self.fields.text_none.setVisible, self.fields.text_none.setVisible
	if self.searchStr == nil or self.searchStr == "" then
		self.tableItemsData = backpack:getClassifyList(tag)
	else
		local tableItemsData = backpack:getClassifyList(tag)
		local searchStr = string.lower(self.searchStr)
		self.tableItemsData, backpackCtrl = self.searchStr, self.searchStr
		for i, v in ipairs(tableItemsData) do
			local itemName = publicRead.getName(v.id)
			if string.find(string.lower(itemName), searchStr, 1, true) ~= nil then
				table.insert(self.tableItemsData, v)
			end
		end
		self.fields.text_none:setVisible(#self.tableItemsData == 0)
	end
	local backpackCtrl, markItem = tableItemsData, backpack:getClassifyList(tag)
	for i, v in ipairs(self.tableItemsData) do
		if not markItem[v.id] then
			markItem[v.id] = true
			table.insert(self.itemList, v)
		end
	end
	dump(self.itemList, "self.itemList")
	self.fields.list:setNumItems(#self.itemList)
end
function BagItemLockPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item)
	obj:setItemClickCallback(handler(self, self.onItemClick))
	obj:setIsSelected(self.editItemIDList[item.id])
end
function BagItemLockPanel:onItemClick(sender, data)
	self.editItemIDList[data.id] = not self.editItemIDList[data.id]
	if not self.editItemIDList[data.id] then
		self.editItemIDList[data.id] = nil
	end
	sender:setIsSelected(self.editItemIDList[data.id])
end
function BagItemLockPanel:onLockItem()
	SoraDPlaySound()
	if table.nums(self.editItemIDList) > 0 then
		local _ENV, list = table.nums(self.editItemIDList), table.nums(self.editItemIDList)
		for k, v in pairs(self.editItemIDList) do
			if v then
				table.insert(list, k)
			end
		end
		SoraDIsNeedOpenVerifySecondaryLock(function()
			backpackCtrl:lockItem(list)
			self.editItemIDList, backpackCtrl = backpackCtrl.lockItem, backpackCtrl.lockItem
		end)
	end
end
function BagItemLockPanel:onUnlockItem()
	SoraDPlaySound()
	if table.nums(self.editItemIDList) > 0 then
		local _ENV, list = table.nums(self.editItemIDList), table.nums(self.editItemIDList)
		for k, v in pairs(self.editItemIDList) do
			if v then
				table.insert(list, k)
			end
		end
		_ENV = nil
		_ENV, (nil).verHolder = i18n("Safety_lock_text_35"), i18n("Safety_lock_text_35")
		;(nil).logParam, i18n("Safety_lock_text_35").items = i18n("Safety_lock_text_35"), list
		SoraDCheckSecondaryLock(function()
			backpackCtrl:unlockItem(list)
			self.editItemIDList, backpackCtrl = backpackCtrl.unlockItem, backpackCtrl.unlockItem
		end, gSecondaryLockType.BagItemLock, "BagItemLock", nil)
	else
		_ENV = "BagItemLock"
		;("BagItemLock").verHolder = i18n("Safety_lock_text_35")
		SoraDCheckSecondaryLock(function()
		end, gSecondaryLockType.BagItemLock, "BagItemLock", "BagItemLock")
	end
end
function BagItemLockPanel:onSearch()
	self.textField:closeKeyboard()
	self:hideKeyboardMask()
	local newSeachStr = self.textField:getText()
	if newSeachStr == self.searchStr then
		if newSeachStr == "" then
			SoraDShowMsgTip(i18n("common_text_4670"))
			return
		end
		SoraDShowMsgTip(i18n("common_text_4671"))
		return
	end
	self.searchStr = newSeachStr
	self:updateCurBtn(0)
	self.fields.btn_close:setVisible(self.searchStr ~= "")
end
function BagItemLockPanel:onCleanSearch()
	self.textField:setString("")
	if self.searchStr ~= "" then
		self.searchStr = ""
		self:updateCurBtn(0)
	end
	self.fields.btn_close:setVisible(self.searchStr ~= "")
end
function BagItemLockPanel:onChanged()
	local text = self.textField:getText()
	if text == "" and self.searchStr ~= "" then
		self.searchStr = ""
		self:updateCurBtn(0)
	end
	self.fields.btn_close:setVisible(text ~= "")
end
function BagItemLockPanel:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	if strEventName == "began" then
		self:showKeyboardMask()
	elseif strEventName == "ended" then
	elseif strEventName == "return" then
		self:hideKeyboardMask()
	elseif strEventName == "changed" then
		self:onChanged()
	end
end
function BagItemLockPanel:showKeyboardMask()
	self.fields.maskArea:setVisible(true)
end
function BagItemLockPanel:hideKeyboardMask()
	self.fields.maskArea:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.fields.maskArea:setVisible(false)
		self.textField:closeKeyboard()
	end)))
end
return BagItemLockPanel

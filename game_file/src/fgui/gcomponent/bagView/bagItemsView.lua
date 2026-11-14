local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local MIN_BAG_CAPACITY = 40
local LINE_NUM = 5
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local bagItemsView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/bagItemsView", bagItemsView)
function bagItemsView:onInit()
	timeLimitedItemCtrl:resetIndex()
	self.clickTab, timeLimitedItemCtrl, self.tableItemsSingle, timeLimitedItemCtrl, self.tableItemsData, timeLimitedItemCtrl = timeLimitedItemCtrl.resetIndex, timeLimitedItemCtrl.resetIndex, timeLimitedItemCtrl.resetIndex, timeLimitedItemCtrl.resetIndex, timeLimitedItemCtrl.resetIndex, timeLimitedItemCtrl.resetIndex
	self.curItem = nil
	self.curItemID = nil
	self.curTagIndex = 0
	self.searchStr = ""
	self.fields.text_none:setString(i18n("common_text_4672"))
	self.fields.btn_search:setTitle(i18n("common_text_166"))
	self.fields.btn_search:addClickEventListener(handler(self, self.onSearch))
	self.fields.btn_close:getParent():setChildIndex(self.fields.btn_close, 6)
	self.fields.btn_close:addClickEventListener(handler(self, self.onCleanSearch))
	self.fields.btn_close:setVisible(false)
	self.fields.btn_lockEdit:setTitle(i18n("Safety_lock_text_32"))
	self.fields.btn_lockEdit:addClickEventListener(handler(self, self.onLockEdit))
	if userSDKManager.isNeedVerify() then
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.loader:fixPos()
	self.fields.btn_search:fixPos()
	self.fields.btn_close:fixPos()
	self.fields.n3:fixPos()
	self.fields.btn_lockEdit:fixPos()
	self.fields.lock_bg:fixPos()
	self:initTextField()
end
function bagItemsView:initTextField()
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
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_IME", handler(self, self.hideKeyPad))
	self.fields.tab:setTabClickCallback(handler(self, self.onTabClick))
end
function bagItemsView:onTabClick(tag)
	print("onTabClick", tag, self.curTagIndex)
	if self.curTagIndex == tag then
		return
	end
	self:updateCurBtn(tag)
end
function bagItemsView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, data)
		dump(self.fields.scroll:isEffect(), "self.fields.scroll:isEffect()")
		if not self.fields.scroll:isEffect() then
			self:updateData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_UI_BAG_TAB_UPDATE", function(target, data)
		self:initTabNew()
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.addItemUseEffect))
end
function bagItemsView:onShow()
	self.fields.tab:updateTab(self.curTagIndex)
end
function bagItemsView:initTabNew()
	self.fields.tab:updateTabList()
	self.fields.tab:updateNew()
end
function bagItemsView:jumpToTab(btnName)
	_UPVALUE0_ = nil
	;(nil).btnAll = 0
	;(nil).btnRes = 1
	;(nil).btnWar = 2
	;(nil).btnBuf = 3
	local (nil).btnOther, tbl = 4, nil
	if tbl[btnName] then
		self:updateCurBtn(tbl[btnName])
	end
end
function bagItemsView:addItemUseEffect(target, data)
	if self.fields.scroll:getCurItem() then
		self.fields.scroll:addItemUseEffect()
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(1.0)
		;(nil)[2] = ffa.callFunc(function()
			self:updateData()
		end)
		;(nil)[3] = ffa.callFunc(function()
			self:updateData()
		end)
		self:runAction(ffa.seq(nil))
	else
		self:updateData()
	end
end
function bagItemsView:updateData(isInit)
	local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
	local tag = self.fields.tab:getTagByIndex(self.curTagIndex)
	self.clickTab[tag] = true
	self.fields.text_none:setVisible(false)
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
	self.tableItemsSingle, backpackCtrl = backpack:getClassifyList(tag), tableItemsData
	for i, v in ipairs(self.tableItemsData) do
		backpackCtrl = nil
		;(nil).point = nil
		;(nil).data = v
		self.tableItemsSingle[i], (nil).pos = nil, nil
	end
	if not self.fields.text_none:isVisible() then
		if #self.tableItemsData < MIN_BAG_CAPACITY then
			for i = #self.tableItemsData + 1, MIN_BAG_CAPACITY do
				backpackCtrl = self.tableItemsSingle
				self.tableItemsSingle.point = nil
				self.tableItemsSingle.data = nil
				self.tableItemsSingle[i], self.tableItemsSingle.pos = self.tableItemsSingle, nil
			end
		elseif #self.tableItemsData % LINE_NUM ~= 0 then
			for i = #self.tableItemsData + 1, math.ceil(#self.tableItemsData / LINE_NUM) * LINE_NUM do
				backpackCtrl = self.tableItemsSingle
				self.tableItemsSingle.point = nil
				self.tableItemsSingle.data = nil
				self.tableItemsSingle[i], self.tableItemsSingle.pos = self.tableItemsSingle, nil
			end
		end
	end
	self.fields.scroll:initData(self.tableItemsSingle, tag)
	self:initTabNew()
	if isInit and not SoraDIsGameGuide() then
		self.fields.scroll:runJumpTop()
	end
end
function bagItemsView:jumpToItem(itemID)
	self:updateCurBtn(0, true)
	for i, v in ipairs(self.tableItemsSingle) do
		if v.data.id == itemID then
			local index = i % 5 == 0 and 5 or i % 5
			local line = math.ceil(i / 5) - 1
			self.fields.scroll:showSingleInfo(v.data, line, index, true)
			return
		end
	end
end
function bagItemsView:updateCurBtn(tag, noAction)
	self.curTagIndex = tag
	self.fields.tab:updateTab(self.curTagIndex)
	self:updateData()
	if SoraDIsGameGuide() then
		self.fields.scroll:jumpTop()
	elseif not noAction then
		self.fields.scroll:runJumpTop()
	end
end
function bagItemsView:onHide()
	for k, v in pairs(self.clickTab) do
		backpackCtrl:resetNewItemInfoByType(k)
	end
	_ENV = pairs(self.clickTab)
	pairs(self.clickTab).msg = "MESSAGE_GREEN_POINT_UPDATE"
	pairs(self.clickTab).type = GREEN_POINT_NOTICE_TYPE.ITEMS
	pairs(self.clickTab).count = backpackCtrl:getNewItemTotal()
	SoraDSendMessage(pairs(self.clickTab))
end
function bagItemsView:gameGuide_getTarget(itemName, parameters)
	if itemName == "noviceGift" then
		self:updateCurBtn(4)
		for i, v in ipairs(self.tableItemsSingle) do
			if v.data and parameters.itemID == v.data.id then
				return self.fields.scroll:getItemPointByID(parameters.itemID)
			end
		end
		_ENV = ipairs(self.tableItemsSingle)
		ipairs(self.tableItemsSingle).msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		ipairs(self.tableItemsSingle).step = parameters.endStep
		SoraDSendMessage(ipairs(self.tableItemsSingle))
		return nil
	elseif itemName == "Button_use" then
		return self.fields.scroll:getItemInfoBtnUse()
	end
	return nil
end
function bagItemsView:onSearch()
	self.textField:closeKeyboard()
	if self.chatDelegate then
		_ENV = nil
		self.chatDelegate:hideKeyboardMask(nil, nil)
	end
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
function bagItemsView:onCleanSearch()
	self.textField:setString("")
	if self.searchStr ~= "" then
		self.searchStr = ""
		self:updateCurBtn(0)
	end
	self.fields.btn_close:setVisible(self.searchStr ~= "")
end
function bagItemsView:onChanged()
	local text = self.textField:getText()
	if text == "" and self.searchStr ~= "" then
		self.searchStr = ""
		self:updateCurBtn(0)
	end
	self.fields.btn_close:setVisible(text ~= "")
end
function bagItemsView:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	if strEventName == "began" then
		if self.chatDelegate then
			self.chatDelegate:showKeyboardMask()
		end
	elseif strEventName == "ended" then
	elseif strEventName == "return" then
		if self.chatDelegate then
			self.chatDelegate:hideKeyboardMask()
		end
	elseif strEventName == "changed" then
		self:onChanged()
	end
end
function bagItemsView:hideKeyPad(...)
	self.textField:closeKeyboard()
end
function bagItemsView:onLockEdit()
	SoraDPlaySound()
	uiManager:show("BagItemLock")
end
return bagItemsView

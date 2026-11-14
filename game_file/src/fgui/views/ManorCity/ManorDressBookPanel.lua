local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local buffDesRead = include("buffDesRead")
local manorCityUtil = include("manorCityUtil")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressBookPanel = class("ManorDressBookPanel", baseFguiPanel)
function ManorDressBookPanel:ctor(...)
	self.isLRU = true
	ManorDressBookPanel.super.ctor(self, ...)
	print("ManorDressBookPanel:ctor", self.viewName)
end
function ManorDressBookPanel:onInit()
	print("=======ManorDressBookPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initData(i18n("garden_btn_07"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemLineRenderer))
	self.fields.Button_active:setString(i18n("common_btn_05"))
	self.fields.Button_active:addClickListener(handler(self, self.onClickBtnActive))
	self.fields.Button_cancel:setString(i18n("garden_text_41"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickBtnCancel))
	self.fields.Button_upgrade:setString(i18n("common_text_055"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_merge:setString(i18n("common_text_1352"))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_get:setString(i18n("common_text_4347"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_detail:setString(i18n("common_text_059"))
	self.fields.Button_detail:addClickListener(handler(self, self.onClickBtnDetail))
	self.fields.Button_activeNum:addClickListener(handler(self, self.onClickBtnActiveNum))
end
function ManorDressBookPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("decoration_text_20")
	uiManager:show("RuleView", nil)
end
function ManorDressBookPanel:endShow()
	print("=======ManorDressBookPanel:endShow")
	self.curDressID = nil
	self.activeMap = manorCityCtrl:getDressActiveMap()
	self.dressIDMap = manorCityRead.getDressIDMap()
	self:sortDressIDMap()
	local _ENV, tabsetArray = self.sortDressIDMap, self.sortDressIDMap
	local dressQualityList = manorCityRead.getDressQualityList()
	for _, quality in ipairs(dressQualityList) do
		local name = manorCityRead.getDressQualityName(quality)
		_ENV = nil
		;(nil).title = name
		;(nil).tag = quality
		table.insert(tabsetArray, nil)
	end
	_ENV, self.tabsetArray = ipairs(dressQualityList)
	ipairs(dressQualityList).defaultClick = tabsetArray[1].tag
	ipairs(dressQualityList).tabsetArray = tabsetArray
	local ipairs(dressQualityList).callback, param = handler(self, self.onClickTab), ipairs(dressQualityList)
	self.fields.Com_title:initTab(param)
	self:updateRedPoint()
	manorCityCtrl:reqDressInit()
end
function ManorDressBookPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c1:setSelectedIndex(1)
	self:resetCurSelectIndex()
	self.objList, _ENV = self.resetCurSelectIndex, self.resetCurSelectIndex
	if not self.dressIDMap[self.curTag] then
		_ENV = self.dressIDMap[self.curTag]
	end
	self.dressIDList = self.dressIDMap[self.curTag]
	local numItems = math.ceil(#self.dressIDList / 3)
	self.fields.List:setNumItems(numItems)
	self:updateActiveCount()
end
function ManorDressBookPanel:onItemLineRenderer(index, obj)
	for i = 1, 3 do
		local widget = obj:getChild("n" .. i)
		local _index = index * 3 + i
		local dressID = self.dressIDList[_index]
		if dressID then
			widget:setVisible(true)
			self:onItemSingleRenderer(_index - 1, widget)
		else
			widget:setVisible(false)
		end
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function ManorDressBookPanel:onItemSingleRenderer(index, obj)
	local dressID = self.dressIDList[index + 1]
	obj:initData(dressID)
	obj:setClickCallback(handler(self, self.clickCallback))
	table.insert(self.objList, obj)
	if dressID == self.mergeDressID then
		self.mergeDressID = nil
		obj:showMergeEffect()
	end
end
function ManorDressBookPanel:clickCallback(dressID)
	print("==ManorDressBookPanel:clickCallback==", dressID)
	local selectIndex = table.indexof(self.dressIDList, dressID)
	if selectIndex == self.curSelectIndex then
		self.controllers.c1:setSelectedIndex(1)
		self:resetCurSelectIndex()
	else
		self.controllers.c1:setSelectedIndex(0)
		self:resetCurSelectIndex()
		self.curSelectIndex = selectIndex
		self:showDressInfo()
	end
end
function ManorDressBookPanel:onClickBtnActive(context)
	SoraDPlaySound()
	local activeMax = manorCityRead.getDressActiveMax(self.curTag)
	local activeCount = self.activeMap[self.curTag] or 0
	if activeMax <= activeCount then
		SoraDShowMsgTip(i18n("decoration_text_23"))
		return
	end
	manorCityCtrl:reqDressActive(self.curDressID)
end
function ManorDressBookPanel:onClickBtnCancel(context)
	SoraDPlaySound()
	manorCityCtrl:reqDressCancel(self.curDressID)
end
function ManorDressBookPanel:onClickBtnUpgrade(context)
	SoraDPlaySound()
	if manorCityCtrl:getDressIsGet(self.curDressID) then
		_ENV = nil
		;(nil).dressID = self.curDressID
		uiManager:show("ManorDressUpgrade", nil)
	else
		local canUnlock, itemID = self:checkDressCostRes(self.curDressID)
		if not canUnlock then
			_ENV = nil
			;(nil).itemID = itemID
			uiManager:show("CommonSourceGuide", nil)
		else
			manorCityCtrl:reqDressUpLv(self.curDressID)
		end
	end
end
function ManorDressBookPanel:onClickBtnDetail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).dressID = self.curDressID
	uiManager:show("ManorDressDetail", nil)
end
function ManorDressBookPanel:showDressInfo()
	local dressID = self.dressIDList[self.curSelectIndex]
	self.curDressID = dressID
	local dressName = manorCityRead.getDressName(dressID)
	self.fields.Text_name:setString(dressName)
	local isActive = manorCityCtrl:getDressIsActive(dressID)
	local isGet = manorCityCtrl:getDressIsGet(dressID)
	local buffLvMap = manorCityUtil.getDressBuffLvMap(dressID)
	local maxLv = manorCityRead.getDressMaxLv(dressID)
	local maxBuff = manorCityRead.getDressBuff(dressID, maxLv)
	local dressLv = manorCityCtrl:getDressLv(dressID, 1)
	local buff = manorCityRead.getDressBuff(dressID, dressLv)
	local buffStr = ""
	for i, v in ipairs(maxBuff) do
		local id = v.id
		local value = 0
		if buff[i] then
			value = buff[i].value
		else
			value = buffLvMap[id].value
		end
		local _buffStr = ""
		local unlockLv = buffLvMap[id].lv
		if not isGet or dressLv < unlockLv then
			_buffStr = buffDesRead.getTitleWithValue(id, value)
			manorCityRead = nil
			;(nil).num = unlockLv
			local unlockStr = "(" .. i18n("artifact_text_01", nil) .. ")"
			if isGet then
				manorCityRead = nil
				;(nil).color = "#746E65"
				_buffStr = SoraDWrapHtmlTagByStyle(_buffStr, nil)
				manorCityRead = nil
				;(nil).color = "#E02B2B"
				unlockStr = SoraDWrapHtmlTagByStyle(unlockStr, nil)
			end
			_buffStr = _buffStr .. unlockStr
		else
			local buffTitle = buffDesRead.getTitleBase(id, false, true)
			local buffValue = buffDesRead.getTitleValueWithValue(id, value)
			manorCityRead = nil
			;(nil).title = buffTitle
			manorCityRead, manorCityRead, (nil).value = nil, buffValue or "", buffValue or ""
			;(buffValue or "").value, (nil).color = nil, "#4CE61A"
			_buffStr = i18n_html("common_text_3904", nil, buffValue or "")
		end
		if i ~= 1 then
			_buffStr = "\n" .. _buffStr
		end
		buffStr = buffStr .. _buffStr
	end
	self.fields.Text_buff:setString(buffStr)
	if not isGet then
		self.fields.Text_buff:setColor("#746E65")
	else
		self.fields.Text_buff:setColor("#FFFBD5")
	end
	local manorCityRead, showBtnList = self.fields.Text_buff.setColor, self.fields.Text_buff.setColor
	local manorCityRead, hideBtnList = self.fields.Text_buff, self.fields.Text_buff
	table.insert(showBtnList, self.fields.Button_detail)
	local canUnlock, itemID = self:checkDressCostRes(dressID)
	if isGet then
		if manorCityCtrl:getDressIsMaxLv(dressID) then
			table.insert(hideBtnList, self.fields.Button_upgrade)
		else
			table.insert(showBtnList, self.fields.Button_upgrade)
		end
		table.insert(hideBtnList, self.fields.Button_merge)
		table.insert(hideBtnList, self.fields.Button_get)
	elseif canUnlock then
		table.insert(hideBtnList, self.fields.Button_upgrade)
		table.insert(showBtnList, self.fields.Button_merge)
		table.insert(hideBtnList, self.fields.Button_get)
	else
		table.insert(hideBtnList, self.fields.Button_upgrade)
		table.insert(hideBtnList, self.fields.Button_merge)
		local sources = itemDesRead.getOutput(itemID)
		if 0 < #sources then
			table.insert(showBtnList, self.fields.Button_get)
		else
			table.insert(hideBtnList, self.fields.Button_get)
		end
	end
	if not isActive and isGet then
		table.insert(showBtnList, self.fields.Button_active)
	else
		table.insert(hideBtnList, self.fields.Button_active)
	end
	if isActive then
		table.insert(showBtnList, self.fields.Button_cancel)
	else
		table.insert(hideBtnList, self.fields.Button_cancel)
	end
	local totalW = self.view:getWidth()
	local stepW = math.floor(totalW / #showBtnList)
	for index, btn in ipairs(showBtnList) do
		btn:setVisible(true)
		btn:setPositionX(stepW * (index - 0.5))
	end
	for _, btn in ipairs(hideBtnList) do
		btn:setVisible(false)
	end
	local showGetWay = not isGet and not canUnlock
	self.fields.Text_getWay:setVisible(showGetWay)
	if showGetWay then
		local getWayStr = manorCityRead.getDressGetWay(dressID)
		self.fields.Text_getWay:setString(getWayStr)
		local posX = 0
		if self.fields.Button_get:isVisible() then
			posX = self.fields.Button_get:getPositionX()
		else
			posX = self.fields.Button_detail:getPositionX()
		end
		self.fields.Text_getWay:setPositionX(posX)
	end
end
function ManorDressBookPanel:onMsgDressExchange(...)
	local numItems = math.ceil(#self.dressIDList / 3)
	self.fields.List:setNumItems(numItems)
	self:updateRedPoint()
end
function ManorDressBookPanel:onMsgDressUpdate(target, event)
	local mergeDressID = event.mergeDressID
	self.mergeDressID = mergeDressID
	self:sortDressIDList(self.dressIDList)
	local numItems = math.ceil(#self.dressIDList / 3)
	self.fields.List:setNumItems(numItems)
	self:resetCurSelectIndex()
	local idx = table.indexof(self.dressIDList, self.curDressID)
	if idx then
		self.curSelectIndex = idx
		self.objList[self.curSelectIndex]:setSelected(true)
		self:showDressInfo()
	end
	self.activeMap = manorCityCtrl:getDressActiveMap()
	self:updateActiveCount()
	self:updateRedPoint()
end
function ManorDressBookPanel:updateActiveCount()
	local activeMax = manorCityRead.getDressActiveMax(self.curTag)
	local activeCount = self.activeMap[self.curTag] or 0
	local qualityName = manorCityRead.getDressQualityName(self.curTag)
	manorCityRead = nil
	;(nil).name = qualityName
	local activeStr = i18n("garden_text_40", nil)
	activeStr = activeStr .. activeCount .. "/" .. activeMax
	self.fields.Text_active:setString(activeStr)
	local textWidth = self.fields.Text_active:getTextAreaWidth()
	local posX = self:getWidth() / 2 - textWidth / 2 - self.fields.Button_activeNum:getWidth() - 5
	self.fields.Button_activeNum:setPositionX(posX)
end
function ManorDressBookPanel:updateRedPoint()
	for idx, cfg in ipairs(self.tabsetArray) do
		local quality = cfg.tag
		local isRed = manorCityCtrl:getDressBookRedPointByQuality(quality, self.dressIDMap, self.activeMap)
		self.fields.Com_title:setBtnRedDot(idx, isRed)
	end
end
function ManorDressBookPanel:sortDressIDMap()
	for quality, dressIDList in pairs(self.dressIDMap) do
		self:sortDressIDList(dressIDList)
	end
end
function ManorDressBookPanel:sortDressIDList(dressIDList)
	local _ENV, temp
	for _, dressID in ipairs(dressIDList) do
		_ENV = nil
		local (nil).dressID, data = dressID, nil
		local isGet = manorCityCtrl:getDressIsGet(dressID)
		data.canUnlock = not isGet and self:checkDressCostRes(dressID)
		data.isPlace = manorCityCtrl:getDressIsPlace(dressID)
		temp[dressID] = data
	end
	table.sort(dressIDList, function(a, b)
		local dataA = temp[a]
		local dataB = temp[b]
		if dataA.canUnlock ~= dataB.canUnlock then
			return dataA.canUnlock
		end
		if dataA.isPlace ~= dataB.isPlace then
			return not dataA.isPlace
		end
		return dataA.dressID > dataB.dressID
	end)
end
function ManorDressBookPanel:checkDressCostRes(dressID)
	local costRes = manorCityRead.getDressCostRes(dressID, 1)
	local itemID, itemCount = costRes[1], costRes[2]
	local itemHave = manorCityCtrl:getItemCount(itemID)
	return itemCount <= itemHave, itemID
end
function ManorDressBookPanel:resetCurSelectIndex()
	if self.curSelectIndex then
		self.objList[self.curSelectIndex]:setSelected(false)
		self.curSelectIndex = nil
	end
end
function ManorDressBookPanel:onClickBtnActiveNum(context)
	SoraDPlaySound()
	uiManager:show("ManorDressActiveNum")
end
return ManorDressBookPanel

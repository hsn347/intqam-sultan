local rechargeRead = include("rechargeRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeViewLimitGiftNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeViewLimitGiftNode", rechargeViewLimitGiftNode)
function rechargeViewLimitGiftNode:onInit()
	self.giftList, _ENV, self.limitGiftData, _ENV, self.tblBtns, _ENV, self.curTab = nil, nil, nil, nil, nil, nil, 1
	self._turnPage = false
	self.packageIndex = 1
	self.giftCount = 0
	self.isJumpInit = true
	self.menuSwitch = false
	self.fields.List_category:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_gift:setVirtualAndLoop()
	self.fields.List_gift:setItemRenderer(handler(self, self.onPageItemRenderer))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightPageClick))
	self.fields.Btn_setting:setString(i18n("recharge_setting_text_01"))
	self.fields.Btn_setting:addClickListener(handler(self, self.onSettingClick))
	self.fields.panel_menu:addClickListener(handler(self, self.menuClose))
	self.fields.List_category:fixPos()
	self.fields.Btn_setting:fixPos()
end
function rechargeViewLimitGiftNode:turnPage(actionFoward)
	self.packageIndex = actionFoward and self.packageIndex - 1 or self.packageIndex + 1
	local isAni = true
	if self.packageIndex < 1 then
		self.packageIndex = self.giftCount
		isAni = false
	elseif self.packageIndex > self.giftCount then
		self.packageIndex = 1
		isAni = false
	end
	self:setPageView(isAni)
end
function rechargeViewLimitGiftNode:btnLeftPageClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
	SoraDSendMessage(nil)
	self._turnPage = true
	self:turnPage(true)
end
function rechargeViewLimitGiftNode:btnRightPageClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
	SoraDSendMessage(nil)
	self._turnPage = true
	self:turnPage(false)
end
function rechargeViewLimitGiftNode:menuClose()
	self.menuSwitch = false
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_MENU_SHOW"
	;(nil).menuSwitch = self.menuSwitch
	SoraDSendMessage(nil)
end
function rechargeViewLimitGiftNode:onSettingClick()
	SoraDPlaySound()
	uiManager:show("rechargeSetting")
end
function rechargeViewLimitGiftNode:onShow()
end
function rechargeViewLimitGiftNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_RECHARGECENTER_MENU_SELECT", handler(self, self.menuSelect))
	SoraDAddMessage(self, "MESSAGE_UI_RECHARGECENTER_MENU_SHOW", handler(self, self.menuShow))
	SoraDAddMessage(self, "MESSAGE_UI_RECHARGECENTER_MENU_GIFT_INDEX", handler(self, self.menuIndex))
	SoraDAddMessage(self, "MESSAGE_UI_RECHARGECENTER_GROUP_NOTIFY", handler(self, self.groupSelect))
	SoraDAddMessage(self, "MESSAGE_UI_RECHARGECENTER_HIDE_GIFT", handler(self, self.sortGiftList))
end
function rechargeViewLimitGiftNode:sortGiftList()
	self:initData(self.tabType, self.menuEnum, self.rechargeID, self.rechargeIDList, self.isJumpInit)
end
function rechargeViewLimitGiftNode:groupSelect(target, data)
	self.rechargeGroup = data and data.group
	print("========self.rechargeGroup========", self.rechargeGroup)
end
function rechargeViewLimitGiftNode:menuIndex(target, data)
	self.packageIndex = data.index
	local isAni = true
	if self.packageIndex < 1 then
		self.packageIndex = self.giftCount
		isAni = false
	elseif self.packageIndex > self.giftCount then
		self.packageIndex = 1
		isAni = false
	end
	self:setPageView(isAni)
	self.menuSwitch = false
	_ENV = self
	self.msg = "MESSAGE_UI_RECHARGECENTER_MENU_SHOW"
	self.menuSwitch = self.menuSwitch
	SoraDSendMessage(self)
end
function rechargeViewLimitGiftNode:menuShow(target, data)
	if data.menuSwitch ~= nil then
		self.menuSwitch = data.menuSwitch
	else
		self.menuSwitch = not self.menuSwitch
	end
	self:updateMenuShow()
end
function rechargeViewLimitGiftNode:menuSelect(target, data)
	self.curTab = data.index
	self.packageIndex = 1
	self.fields.List_category:setNumItems(#self.tblBtns)
	self:initView()
end
function rechargeViewLimitGiftNode:onMenuRenderer(index, obj)
	obj:initData(self.tblBtns[index + 1], self.curTab)
end
function rechargeViewLimitGiftNode:onPageItemRenderer(index, obj)
	obj:initGroup(self.giftList[index + 1], self.tblBtns[self.curTab].tag, self._turnPage, self.tabType, self.rechargeID, true)
end
function rechargeViewLimitGiftNode:makeDiffData()
	local _ENV, packageDiffData
	if self.giftList[1].rType and self.giftList[1].rType == gRechargeActiveModelType.CLIENTLADDER then
		for i, v in ipairs(self.giftList[1].nextLadderList) do
			v.rType = gRechargeActiveModelType.CLIENTLADDER
		end
		packageDiffData = self.giftList
	else
		packageDiffData = self.giftList
	end
	return packageDiffData
end
function rechargeViewLimitGiftNode:updateMenuShow()
	self.fields.panel_menu:setVisible(self.menuSwitch)
	self.fields.panel_menu:setTouchEnabled(self.menuSwitch)
	self.fields.Com_menuList:setVisible(self.menuSwitch)
	if self.menuSwitch then
		self.fields.Com_menuList:initData(self:makeDiffData(), self.packageIndex, handler(self, self.getOriData), self:getCurEnum())
	end
end
function rechargeViewLimitGiftNode:getOriData()
	if self.tabType == gRechargeCenterCategory.LIMITGIFT then
		return self:getLimitData(true)
	else
		return self:getLimitDataEX(true)
	end
end
function rechargeViewLimitGiftNode:jumpToID()
	if self.rechargeIDList and self.isJumpInit then
		local tag, targetID
		local _ENV, showList
		for k, v in pairs(self.categoryData) do
			for ki, vi in ipairs(v) do
				if vi.group then
					for km, vn in ipairs(vi.data) do
						if SoraDisInList(tonumber(vn.rid), self.rechargeIDList) or self.rechargeGroup and tonumber(self.rechargeGroup) == tonumber(vi.group) then
							self.curTab = self:getIdxByEnum(k)
							tag = k
							_ENV = k
							k.rid = tonumber(vn.rid)
							k.price = vn.data.price
							table.insert(showList, k)
						end
					end
				elseif vi.rid and SoraDisInList(tonumber(vi.rid), self.rechargeIDList) then
					self.curTab = self:getIdxByEnum(k)
					tag = k
					_ENV = k
					k.rid = tonumber(vi.rid)
					k.price = vi.data.price
					table.insert(showList, k)
				end
			end
		end
		table.sort(showList, function(a, b)
			return a.price > b.price
		end)
		if 0 < #showList then
			targetID = showList[1].rid
			if self.rechargeID then
				for k, v in ipairs(showList) do
					if v.rid == self.rechargeID then
						targetID = v.rid
						break
					end
				end
			end
		end
		self.fields.List_category:setNumItems(#self.tblBtns)
		if not tag or not self.categoryData[tag] then
			local _ENV, giftList = self.categoryData[tag], self.categoryData[tag]
		end
		for k, v in ipairs(giftList) do
			if v.group then
				for ki, vi in ipairs(v.data) do
					if targetID and tonumber(targetID) == tonumber(vi.rid) then
						self.packageIndex = k
					end
				end
			elseif targetID and tonumber(targetID) == tonumber(v.rid) then
				self.packageIndex = k
			end
		end
		self.isJumpInit = false
		self.rechargeGroup = nil
		local obj = self.fields.List_category:getChildAt(self.curTab - 1)
		self.fields.List_category:scrollToCenter(obj)
	end
end
function rechargeViewLimitGiftNode:initView()
	self:jumpToID()
	if self.rechargeID and self.isJumpInit then
		_UPVALUE1_ = self.isJumpInit
		self.rechargeIDList, self.isJumpInit[1] = self.isJumpInit, self.rechargeID
		self:jumpToID()
	end
	if self.menuEnum and not self.rechargeID and self.isJumpInit then
		self.curTab = self:getIdxByEnum(self.menuEnum)
		self.isJumpInit = false
		self.fields.List_category:setNumItems(#self.tblBtns)
		local obj = self.fields.List_category:getChildAt(self.curTab - 1)
		self.fields.List_category:scrollToCenter(obj)
	end
	local tag = self.tblBtns[self.curTab].tag
	self.giftList = self.categoryData[tag]
	if self.giftList[1].rType == gRechargeActiveModelType.CLIENTLADDER then
		local _ENV, ladderList = self.giftList[1].rType, self.giftList[1].rType
		for k, v in ipairs(self.giftList[1].data) do
			v.rType = gRechargeActiveModelType.CLIENTLADDER
			v.rid = v.ID
			table.insert(ladderList, v)
		end
		self.giftList = ladderList
	end
	self:updateView()
end
function rechargeViewLimitGiftNode:updateView()
	self.giftCount = #self.giftList
	self.fields.List_gift:setNumItems(self.giftCount)
	self.fields.List_gift:scrollToView(self.packageIndex - 1)
	self.fields.List_gift:setScrollEnable(self.giftCount > 1)
	self.fields.Button_left:setVisible(self.giftCount > 1)
	self.fields.Button_right:setVisible(self.giftCount > 1)
	self.fields.Com_indicator:setVisible(self.giftCount > 1)
	self.fields.Com_indicator:reserLastIndex()
	_ENV = self.giftCount > 1
	;(self.giftCount > 1).count = self.giftCount
	;(self.giftCount > 1).intervalWidth = 8
	;(self.giftCount > 1).begin = self.packageIndex
	self.fields.Com_indicator:initData(self.giftCount > 1)
	self.fields.List_gift:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.List_gift:childIndexToItemIndex(0)
		self.packageIndex = itemIndex % self.giftCount + 1
		self._turnPage = false
		self:setCurLight()
	end)
end
function rechargeViewLimitGiftNode:getIdxByEnum(enum)
	local curTab = 1
	for k, v in ipairs(self.tblBtns) do
		if tonumber(v.tag) == tonumber(enum) then
			curTab = v.index
			break
		end
	end
	return curTab
end
function rechargeViewLimitGiftNode:getCurTab()
	return self.curTab
end
function rechargeViewLimitGiftNode:getCurEnum()
	return self.tblBtns[self.curTab].tag
end
function rechargeViewLimitGiftNode:getJumpDataByID(rid)
	local jumpTab = 1
	local jumpIndex = 1
	local jumpID
	local category = self.tblBtns[1].tag
	local clientInfo = rechargeRead.getPageViewData(rid)
	local group = clientInfo and clientInfo.rechargeGroup or 0
	local _category = self:getCurEnum()
	local categoryList = self.categoryData[_category]
	print("rid,category,_category,group===", rid, category, _category, group)
	dump(categoryList, "categoryList====" .. _category, 10)
	if categoryList then
		category = tonumber(_category)
		if tonumber(_category) == 20 then
			jumpIndex = 1
			for k, v in ipairs(categoryList[1].data) do
				if v.extraData then
					local tmpList = SoraDStringSplit(v.extraData, ",")
					if SoraDisInList(tostring(rid), tmpList) then
						jumpIndex = k
						jumpID = tonumber(v.ID)
						print("找到所属阶梯礼包组======111===", jumpIndex, jumpID)
						return self:getIdxByEnum(category), jumpIndex, jumpID, category
					end
				elseif math.abs(tonumber(v.ID) - tonumber(rid)) <= 5 and tonumber(v.ID) > tonumber(rid) then
					jumpIndex = k
					jumpID = tonumber(v.ID)
					print("找到所属阶梯礼包组======222===", jumpIndex, jumpID)
					return self:getIdxByEnum(category), jumpIndex, jumpID, category
				end
			end
			jumpTab = self:getIdxByEnum(category)
		else
			if 0 < tonumber(group) then
				for k, v in ipairs(categoryList) do
					if v.group and tonumber(v.group) == tonumber(group) then
						jumpIndex = k
						jumpID = tonumber(v.data[1].rid)
						for ki, vi in ipairs(v.data) do
							if vi.rid and tonumber(vi.rid) == tonumber(rid) then
								jumpID = rid
								return self:getIdxByEnum(category), jumpIndex, jumpID, category
							end
						end
					end
				end
			else
				for k, v in ipairs(categoryList) do
					jumpIndex = 1
					jumpID = tonumber(categoryList[jumpIndex].rid)
					if v.rid and tonumber(v.rid) == tonumber(rid) then
						jumpIndex = k
						jumpID = rid
						return self:getIdxByEnum(category), jumpIndex, jumpID, category
					end
				end
			end
			jumpTab = self:getIdxByEnum(category)
		end
	else
		jumpIndex = 1
		category = self.tblBtns[1].tag
		jumpTab = 1
	end
	print("jumpTab,jumpIndex,jumpID,category=====", jumpTab, jumpIndex, jumpID, category)
	return jumpTab, jumpIndex, jumpID, category
end
function rechargeViewLimitGiftNode:setPageView(isAni)
	self.fields.List_gift:scrollToView(self.packageIndex - 1, isAni)
	self:setCurLight()
end
function rechargeViewLimitGiftNode:setCurLight()
	self.fields.Com_indicator:setCurLight(self.packageIndex)
end
function rechargeViewLimitGiftNode:initBtnScroll()
	self.tblBtns, activityShowCtrl = nil, nil
	local sortTbl = activityShowCtrl:getLabelSort()
	local keys = table.keys(self.categoryData)
	table.sort(keys, function(l, r)
		local ls = sortTbl[l] or 999
		local rs = sortTbl[r] or 999
		return ls < rs
	end)
	for idx, val in ipairs(keys) do
		local info = rechargeRead.getCategoryConfig(val)
		activityShowCtrl = nil
		;(nil).tag = val
		;(nil).index = idx
		;(nil).icon = info.icon
		;(nil).name = info.name
		table.insert(self.tblBtns, nil)
	end
	dump(keys, "keys====")
	dump(self.tblBtns, "self.tblBtns====")
	if self.curTab > #self.tblBtns then
		self.curTab = 1
	end
	self.fields.List_category:setNumItems(#self.tblBtns)
	local obj = self.fields.List_category:getChildAt(self.curTab - 1)
	self.fields.List_category:scrollToCenter(obj)
end
function rechargeViewLimitGiftNode:initLimitGiftData()
	self.groupData, _ENV, self.categoryData, _ENV, self.limitGiftData = self:getLimitData(), self:getLimitData(), self:getLimitData(), self:getLimitData(), self:getLimitData()
	for i, v in ipairs(self.limitGiftData) do
		if v.rType == gRechargeActiveModelType.CLIENTLADDER then
			table.sort(v.data, function(a, b)
				return a.ID < b.ID
			end)
			_ENV = v.data
			self.categoryData[20], v.data[1] = v.data, v
		elseif v.data.category then
			if not self.categoryData[v.data.category] then
				self.categoryData[v.data.category], _ENV = function(a, b)
					return a.ID < b.ID
				end, function(a, b)
					return a.ID < b.ID
				end
			end
			local _ENV, clientInfo = self.categoryData, self.categoryData
			if v.rid then
				clientInfo = rechargeRead.getPageViewData(v.rid)
			end
			if clientInfo.rechargeGroup and clientInfo.rechargeGroup ~= 0 then
				local key = string.format("%s_%s", v.data.category, clientInfo.rechargeGroup)
				if not self.groupData[key] then
					self.groupData[key], _ENV = v.data.category, v.data.category
				end
				table.insert(self.groupData[key], v)
			else
				table.insert(self.categoryData[v.data.category], v)
			end
			if type(v.data.extraCategory) == "string" and 0 < string.len(v.data.extraCategory) then
				local tmpList = SoraDStringSplit(v.data.extraCategory, ",")
				for _, category in ipairs(tmpList) do
					if clientInfo.rechargeGroup and clientInfo.rechargeGroup ~= 0 then
						local key = string.format("%s_%s", category, clientInfo.rechargeGroup)
						if not self.groupData[key] then
							self.groupData[key], _ENV = category, category
						end
						table.insert(self.groupData[key], v)
					else
						if not self.categoryData[tonumber(category)] then
							self.categoryData[tonumber(category)], _ENV = category, category
						end
						table.insert(self.categoryData[tonumber(category)], v)
					end
				end
			end
		else
			if not self.categoryData[0] then
				self.categoryData[0], _ENV = SoraDStringSplit(v.data.extraCategory, ","), SoraDStringSplit(v.data.extraCategory, ",")
			end
			table.insert(self.categoryData[0], v)
		end
	end
	for key, v in pairs(self.groupData) do
		table.sort(v, function(l, r)
			if l.data.price ~= r.data.price then
				return l.data.price > r.data.price
			else
				return l.rid < r.rid
			end
		end)
		local keys = string.split(key, "_")
		if not self.categoryData[tonumber(keys[1])] then
			self.categoryData[tonumber(keys[1])], _ENV = keys[1], keys[1]
		end
		_ENV = tonumber(keys[1])
		tonumber(keys[1]).data = v
		tonumber(keys[1]).group = keys[2]
		table.insert(self.categoryData[tonumber(keys[1])], (tonumber(keys[1])))
	end
	if next(self.limitGiftData) then
		self:initBtnScroll()
		self:initView(self.curTab)
	end
end
function rechargeViewLimitGiftNode:initPresentGiftData()
	self.categoryData, _ENV, self.limitGiftData = self:getLimitDataEX(), self:getLimitDataEX(), self:getLimitDataEX()
	for _, v in ipairs(self.limitGiftData) do
		if v.data.category then
			if not self.categoryData[v.data.category] then
				self.categoryData[v.data.category], _ENV = nil, nil
			end
			table.insert(self.categoryData[v.data.category], v)
			if type(v.data.extraCategory) == "string" and string.len(v.data.extraCategory) > 0 then
				local tmpList = SoraDStringSplit(v.data.extraCategory, ",")
				for _, category in ipairs(tmpList) do
					if not self.categoryData[tonumber(category)] then
						self.categoryData[tonumber(category)], _ENV = category, category
					end
					table.insert(self.categoryData[tonumber(category)], v)
				end
			end
		else
			if not self.categoryData[0] then
				self.categoryData[0], _ENV = ipairs(tmpList)
			end
			table.insert(self.categoryData[0], v)
		end
	end
	if next(self.limitGiftData) then
		self:initBtnScroll()
		self:initView(self.curTab)
	elseif self.handleRefreshHead then
		self.handleRefreshHead()
	end
	self:setPackageTabNums()
	self:updateMenu()
	if self.tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
		_ENV = self.curTab
		self.curTab.byUID = true
		local isFirst = SoraDConfigGet("Game:rechargePresentActivity:first~bool", self.curTab)
		if isFirst then
			local gameGuideView = include("gameGuideView").new()
			gameGuideView:startGuideWithStep(71001)
			gameGuideView:show()
			_ENV = table.insert
			table.insert.byUID = true
			SoraDConfigSet("Game:rechargePresentActivity:first~bool", false, table.insert)
		end
	end
end
function rechargeViewLimitGiftNode:setPackageTabNums()
end
function rechargeViewLimitGiftNode:updateMenu()
end
function rechargeViewLimitGiftNode:getPanelGuide()
	return self.fields.Panel_guide
end
function rechargeViewLimitGiftNode:initData(tabType, menuEnum, rechargeID, rechargeIDList, isJumpInit)
	self.tabType = tabType
	self.menuEnum = menuEnum
	self.rechargeID = rechargeID
	self.rechargeIDList = rechargeIDList
	self.curTab = isJumpInit and self.curTab or 1
	self.isJumpInit = isJumpInit or self.isJumpInit
	if self.tabType == gRechargeCenterCategory.LIMITGIFT then
		self:initLimitGiftData()
	else
		self:initPresentGiftData()
	end
	self.menuSwitch = false
	self:updateMenuShow()
end
function rechargeViewLimitGiftNode:checkHide(rid, category, isOri)
	if isOri then
		return false
	end
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideCategory~table", nil) then
		local _ENV, hideCategoryList = SoraDConfigGet("Game:Recharge:hideCategory~table", nil), SoraDConfigGet("Game:Recharge:hideCategory~table", nil)
	end
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideGift~table", nil) then
		local _ENV, hideList = SoraDConfigGet("Game:Recharge:hideGift~table", nil), SoraDConfigGet("Game:Recharge:hideGift~table", nil)
	end
	if not self.rechargeIDList then
		local _ENV, ridList = self.rechargeIDList, self.rechargeIDList
	end
	local isHide = false
	if SoraDisInList(tonumber(rid), ridList) then
		for _, v in ipairs(ridList) do
			if hideList[tostring(v)] then
				hideList[tostring(v)] = nil
			end
		end
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:Recharge:hideGift~table", hideList, nil)
		return false
	end
	if hideCategoryList[tostring(category)] or hideList[tostring(rid)] then
		isHide = true
	end
	return isHide
end
function rechargeViewLimitGiftNode:sortLadderHide(data, isOri)
	if isOri then
		return data
	end
	local _ENV, sortData
	for _, v in ipairs(data) do
		local isHideNext = false
		for _, data in ipairs(v.nextLadderList) do
			if self:checkHide(data.ID, 20) then
				isHideNext = true
			end
		end
		if self:checkHide(v.ID, 20) or isHideNext then
		else
			table.insert(sortData, v)
		end
	end
	return sortData
end
function rechargeViewLimitGiftNode:getLimitData(isOri)
	local princeGiftNewCtrl, normalGiftData
	local newPrinceClientData, newPrinceGiftData = princeGiftNewCtrl:getNewPrinceData()
	if newPrinceClientData then
		local rid = tonumber(newPrinceClientData.ID)
		if not self:checkHide(rid, newPrinceClientData.category, isOri) then
			princeGiftNewCtrl = rid
			rid.rid = rid
			rid.rType = gRechargeActiveModelType.NEW_PRINCE_GIFT
			rid.data = newPrinceGiftData
			rid.clientData = newPrinceClientData
			table.insert(normalGiftData, rid)
		end
	end
	local luckyGiftList = luckyGiftCtrl:getLuckyGiftData(true)
	local lblData = luckyGiftCtrl:getBirthdayLadderGiftData()
	if next(lblData) then
		local sortData = self:sortLadderHide(lblData, isOri)
		if next(sortData) then
			princeGiftNewCtrl = isOri
			isOri.rType = gRechargeActiveModelType.BIRTHDAY_LADDER
			isOri.data = sortData
			table.insert(normalGiftData, isOri)
		end
	end
	for i, v in ipairs(luckyGiftList) do
		local judgeData = rechargeRead.hasRechargeItem(v.luckyGiftID)
		if not judgeData or v.type == gLuckyPackageType.LUCKY_PACKAGE_BIRTHDAY and #v.extraData > 0 then
		elseif not self:checkHide(v.luckyGiftID, v.category, isOri) then
			princeGiftNewCtrl = v.luckyGiftID
			v.luckyGiftID.rid = v.luckyGiftID
			v.luckyGiftID.rType = gRechargeActiveModelType.LUCKYGIFT
			v.luckyGiftID.data = v
			table.insert(normalGiftData, v.luckyGiftID)
		end
	end
	local activeDataList = clone(rechargeActivityCtrl:getHotActivityList())
	local princeGiftNewCtrl, normalSortList = rechargeActivityCtrl:getHotActivityList()
	for k, v in pairs(activeDataList) do
		if paymentManager.judgeGiftExclusive(k) and rechargeRead.hasRechargeItem(k) and rechargeRead.getRankHideListByID(v.label) and not self:checkHide(tonumber(k), v.category, isOri) then
			princeGiftNewCtrl = tonumber(k)
			tonumber(k).rid = tonumber(k)
			tonumber(k).rType = gRechargeActiveModelType.NORMAL
			tonumber(k).data = v
			table.insert(normalSortList, (tonumber(k)))
		end
	end
	if next(normalSortList) then
		table.sort(normalSortList, function(l, r)
			local lWeight = l.data.weight or 0
			local rWeight = r.data.weight or 0
			local lRid = l.rid or tonumber(not l.data or l.data.ID or l.data.rechargeID or l.data.luckyGiftID) or 0
			local rRid = r.rid or tonumber(not r.data or r.data.ID or r.data.rechargeID or r.data.luckyGiftID) or 0
			if lWeight ~= rWeight then
				return lWeight > rWeight
			else
				return lRid < rRid
			end
		end)
	end
	for _, v in ipairs(normalSortList) do
		table.insert(normalGiftData, v)
	end
	local ladderData = rechargeActivityCtrl:getLadderActivityList()
	if ladderData and next(ladderData) then
		local sortData = self:sortLadderHide(ladderData, isOri)
		if next(sortData) then
			princeGiftNewCtrl = isOri
			isOri.rType = gRechargeActiveModelType.CLIENTLADDER
			isOri.data = sortData
			table.insert(normalGiftData, isOri)
		end
	end
	return normalGiftData
end
function rechargeViewLimitGiftNode:getLimitDataEX(isOri)
	local rechargePresentUtil = include("rechargePresentUtil")
	local _ENV, activeDataList = "rechargePresentUtil", "rechargePresentUtil"
	local rType = gRechargeActiveModelType.RECHARGE_PRESENT
	local activityID = rechargePresentUtil.getActivityIDByCategory(self.tabType)
	local group = rechargePresentUtil.getActivityClassType(activityID)
	activeDataList = rechargeRead.getRechargePresentCfgByGroup(group)
	rType = gRechargeActiveModelType.RECHARGE_PRESENT
	local _ENV, normalSortList = gRechargeActiveModelType, gRechargeActiveModelType
	for i, v in ipairs(activeDataList) do
		local extraData = rechargePresentUtil.getRechargePresentExchangeNum(v, activityID)
		v.payType = v.limitType
		v.extraData = extraData
		if not self:checkHide(v.rechargeID, v.category, isOri) then
			_ENV = v.rechargeID
			v.rechargeID.rid = v.rechargeID
			v.rechargeID.rType = rType
			v.rechargeID.data = v
			table.insert(normalSortList, v.rechargeID)
		end
	end
	if next(normalSortList) then
		table.sort(normalSortList, function(l, r)
			local lWeight = l.data.weight or 0
			local rWeight = r.data.weight or 0
			if lWeight ~= rWeight then
				return lWeight > rWeight
			else
				return l.rid < r.rid
			end
		end)
	end
	return normalSortList
end
return rechargeViewLimitGiftNode

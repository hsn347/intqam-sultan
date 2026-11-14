local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LordSelectViewPanel = class("LordSelectViewPanel", baseFguiPanel)
function LordSelectViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LordSelectViewPanel:ctor", self.viewName)
end
function LordSelectViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LordSelectViewPanel:onInit()
	print("=======LordSelectViewPanel:onInit")
	self.memberListSingle, _ENV, self.memberListData, _ENV, self.selectIndex, _ENV, self.selectData, _ENV = print, print, print, print, print, print, print, print
	self.tableSpare, _ENV, self.shieldUidMap = print, print, nil
	self.maxCount = 0
	self.canSelectOwn = false
	self.keyName = nil
	self.fromLoadText = false
	self.nextIndex = nil
	self.isLock = false
	self.isShowOnline = false
	self.isSortPower = false
	self.isCheckKingdom = false
	self.canCloseSelf = true
	self.handle = nil
	self.searchType = lordSearchType.PIGEON
	self.curSortType = 1
	self.isFlower = false
	local ownmember = memberMgr:getOwnMember()
	self.aid = ownmember:getProperty("aid")
	self.isHaveTextField = true
	self.btnAnnounce = self.fields.Button_announce
	self.btnAnnounce:setVisible(false)
	self.scroll = self.fields.scroll
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.labelNone = self.fields.Text_none
	self.labelNone:setString(i18n("common_text_961"))
	self.fields.Com_title:initData(i18n("common_text_2234"), handler(self, self.onClickClose))
	self.btnSearch = self.fields.Button_search
	self.btnSearch:setTitle(i18n("common_text_166"))
	self.tfdSearch = self.fields.TextField_search
	self.Node_chooseList = self.fields.ComboBox_sort
	self.btnSend = self.fields.btnSend
	self.btnSend:setTitle(i18n("common_text_073"))
	self.labelNone:setVisible(false)
	self.btnSearch:addClickEventListener(handler(self, self.btnSearchClickCallBack))
	self.btnSend:addClickEventListener(handler(self, self.btnSendClickCallBack))
	self.scroll:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	self:setShieldMap()
	self:applyData()
	self:setSwitcher()
end
function LordSelectViewPanel:onShow()
	print("=======LordSelectViewPanel:onShow")
end
function LordSelectViewPanel:applyData()
	self:recoverAllSingle()
	self.allMemberListData, allianceQuery, self.memberListData, allianceQuery, self.selectIndex, allianceQuery, self.selectData, allianceQuery = self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle
	self.fromLoadText = false
	if self.aid and self.aid ~= 0 then
		allianceQuery:reqMemberList(self.aid)
		SoraDShowLoading(self:displayObject()):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	else
		self.labelNone:setVisible(true)
		self.labelNone:setString(i18n("common_text_961"))
	end
	self:updateBtn()
end
function LordSelectViewPanel:setTitleText(title)
	if self.fields.Com_title then
		self.fields.Com_title:updateTitle(title)
	end
end
function LordSelectViewPanel:setMaxCount(maxCount)
	self.maxCount = maxCount
end
function LordSelectViewPanel:setSearchType(searchType)
	self.searchType = searchType
end
function LordSelectViewPanel:setOwnSelect(enable)
	self.canSelectOwn = enable
end
function LordSelectViewPanel:setLimitCasteLV(lv)
	self.limitLV = lv
end
function LordSelectViewPanel:setLimitTips(strKey)
	self.limitTips = i18n(strKey)
end
function LordSelectViewPanel:showOnline(isOpen)
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	if (self.searchType == lordSearchType.ALLIANCE or self.searchType == lordSearchType.ALLIANCE_MEMBER) and self.aid and self.aid ~= 0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO) then
		self.isShowOnline = true
	else
		self.isShowOnline = false
	end
	self:initSearchList()
end
function LordSelectViewPanel:showOwnKingdom(isCheck)
	self.isCheckKingdom = isCheck
	self:initSearchList()
end
function LordSelectViewPanel:initData(type, selectCount, title)
	if title then
		self.btnSend:setTitle(title)
	end
	self.searchType = type
	self.controllers.c1:setSelectedIndex(self.searchType == lordSearchType.PIGEON and 1 or 0)
	self.Node_chooseList:setVisible(self.searchType == lordSearchType.PIGEON)
	self.maxCount = selectCount
end
function LordSelectViewPanel:setHandle(handle)
	self.handle = handle
end
function LordSelectViewPanel:setShieldMap(shieldUidMap)
	if self.shieldUidMap then
		for k, v in pairs(shieldUidMap) do
			self.shieldUidMap[k] = v
		end
	else
		self.shieldUidMap = shieldUidMap
	end
end
function LordSelectViewPanel:setCloseSelfType(type)
	self.canCloseSelf = type
end
function LordSelectViewPanel:isSendFlower(ret)
	self.isFlower = ret
end
function LordSelectViewPanel:setIsSortPower(isSort)
	self.isSortPower = isSort
end
function LordSelectViewPanel:btnSendClickCallBack(button, type)
	SoraDPlaySound()
	local _ENV, tableUID = SoraDPlaySound, SoraDPlaySound
	local _ENV, tableData
	for k, v in pairs(self.selectData) do
		table.insert(tableUID, tonumber(k))
		table.insert(tableData, v)
	end
	if self.handle then
		self.handle(tableUID, #tableUID, self, tableData)
	end
	if self.canCloseSelf then
		self:removeFromParent()
	end
end
function LordSelectViewPanel:btnSearchClickCallBack(button, type)
	SoraDPlaySound()
	local key = string.match(self.tfdSearch:getText(), "%s*(.-)%s*$")
	local keyLen = string.utf8len(key)
	print("self.searchType====", self.searchType, self.curSortType, self.isFlower)
	if keyLen >= SEARCH_MIN_LEN then
		self.keyname = key
		if self.searchType == lordSearchType.PIGEON then
			local kid = gametop.playertop_:getMapID()
			if self.warType == gKingdomClassType.roaringFlame then
				kid = gametop.playertop_:getKingdomID()
			end
			if self.curSortType == 1 then
				if self.isFlower then
					lordInfoCtrl:searchLordAllWorld(self.keyname)
				else
					lordInfoCtrl:searchLordInThisKingdomReq(self.keyname, 1, kid, nil, lordSearchType.PIGEON)
				end
			elseif self.isFlower then
				if tonumber(self.keyname) then
					_ENV = self.keyname
					self.keyname.targetName = self.__cname
					lordInfoCtrl:searchLordInThisKingdomsReq(nil, nil, tonumber(self.keyname), self.keyname)
				end
			else
				lordInfoCtrl:searchLordInThisKingdomReq("", 1, kid, tonumber(self.keyname) or 0, lordSearchType.PIGEON)
			end
			SoraDShowLoading(self:displayObject()):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
		elseif self.searchType == lordSearchType.ALLIANCE then
			self:searchInAlliance()
		elseif self.searchType == gSearchStyle.LORD_ALL_WORLD then
			lordInfoCtrl:searchLordAllWorld(self.keyname, self.needLv)
			SoraDShowLoading(self:displayObject()):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
		end
	else
		SoraDShowMsgBox(i18n("common_text_961"), i18n("common_text_054"))
	end
end
function LordSelectViewPanel:setSearchNeedLv(lv)
	self.needLv = lv
end
function LordSelectViewPanel:updateBtn()
	local haveData = table.nums(self.selectData) > 0
	self.btnSend:setTouchEnabled(haveData)
	self.btnSend:setBright(haveData)
end
function LordSelectViewPanel:recoverAllSingle()
	self.memberListSingle, _UPVALUE0_ = nil, nil
end
function LordSelectViewPanel:searchInAlliance()
	local tmpData = self.allMemberListData
	self:recoverAllSingle()
	self.memberListData, _ENV, self.selectIndex, _ENV = self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle
	self.scroll:jumpToTop()
	self.fromLoadText = false
	for i, v in ipairs(tmpData) do
		local name = v.nickName or v:getProperty("nickName")
		local uid = v.uid or v:getProperty("uid")
		if self.selectData[tostring(uid)] == nil and string.find(name, self.keyname, 1, true) then
			table.insert(self.memberListData, v)
		end
	end
	if table.nums(self.selectIndex) <= 0 and table.nums(self.selectData) > 0 then
		for k, v in pairs(self.selectData) do
			table.insert(self.memberListData, 1, v)
			self.selectIndex[tostring(table.nums(self.selectIndex) + 1)] = true
		end
	end
	self:updateNotice()
	self:updateScrollWithData()
	self:initSearchList()
	SoraDCloseLoading(self:displayObject())
end
function LordSelectViewPanel:updateData(target, data)
	if data.msg == "MESSAGE_ITEM_LORD_SEARCH_BACK" then
		local retdata = data.data
		self.nextIndex = retdata.nextindex
		if not self.fromLoadText then
			self:recoverAllSingle()
			self.scroll:jumpToTop()
			self.memberListData, _ENV, self.selectIndex, _ENV = self.scroll.jumpToTop, self.scroll.jumpToTop, self.scroll.jumpToTop, self.scroll.jumpToTop
		end
		self.fromLoadText = false
		for _, v in ipairs(retdata.uinfolist) do
			local uid = v.uid or v:getProperty("uid")
			if self.selectData[tostring(uid)] == nil then
				table.insert(self.memberListData, v)
			end
		end
		if table.nums(self.selectIndex) <= 0 and table.nums(self.selectData) > 0 then
			for k, v in pairs(self.selectData) do
				table.insert(self.memberListData, 1, v)
				self.selectIndex[tostring(table.nums(self.selectIndex) + 1)] = true
			end
		end
		self:updateNotice()
	elseif data.msg == "MESSAGE_SERVER_OPTION_SEARCH_LORD" then
		if self.selectedTarget then
			self.selectedTarget:btnClickCallBack(self.selectedTarget.nodeTouch, ccui.TouchEventType.ended)
		end
		if not data.data then
			local _ENV, retdata = data.data, data.data
		end
		self:recoverAllSingle()
		self.selectIndex, _ENV, self.memberListData, _ENV = self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle
		self.scroll:jumpToTop()
		for i, v in ipairs(retdata) do
			if self.selectData[tostring(v.uid)] == nil then
				table.insert(self.memberListData, v)
			end
		end
	elseif data.msg == "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS" then
		local allianceData = allianceMgr:getMemberList(self.aid)
		_UPVALUE6_ = allianceMgr
		allianceMgr[1] = "5"
		allianceMgr[2] = "6"
		allianceMgr[3] = "4"
		allianceMgr[4] = "3"
		allianceMgr[5] = "2"
		local allianceMgr[6], tableMemberListKey = "1", allianceMgr
		for i, v in ipairs(tableMemberListKey) do
			local rankData = allianceData[v]
			if rankData then
				for i, v in ipairs(rankData) do
					print("(not self.needlv)", not self.needLv, self.needLv)
					if not self.needLv or self.needLv and self.needLv <= v.uinfo.cityLevel then
						table.insert(self.memberListData, v)
					end
				end
			end
		end
	end
	self:updateNotice()
	if not self.canSelectOwn then
		local ownuid = lordInfoCtrl:getLordInfo().base.uid
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if uid == ownuid then
				table.remove(self.memberListData, i)
				if data.msg == "MESSAGE_ITEM_LORD_SEARCH_BACK" then
					self:updateNotice()
					break
				end
				self.labelNone:setString(i18n("common_text_1060"))
				break
			end
		end
	end
	if self.shieldUidMap then
		for i = #self.memberListData, 1, -1 do
			local v = self.memberListData[i]
			local uid = v.uid or v:getProperty("uid")
			if self.shieldUidMap[uid] then
				table.remove(self.memberListData, i)
				if data.msg == "MESSAGE_ITEM_LORD_SEARCH_BACK" then
					self:updateNotice()
				else
					self.labelNone:setString(i18n("common_text_1060"))
				end
			end
		end
	end
	self.labelNone:setVisible(#self.memberListData <= 0)
	self.allMemberListData = self.memberListData
	self:initSearchList()
	SoraDCloseLoading(self:displayObject())
end
function LordSelectViewPanel:setFilterCityLv(cityLevel)
	self.filterCityLv = cityLevel
end
function LordSelectViewPanel:setStickOnline(isStickOnLine)
	self.isStickOnLine = isStickOnLine
end
function LordSelectViewPanel:updateScrollWithData()
	if self.filterCityLv then
		for i = #self.memberListData, 1, -1 do
			if self.memberListData[i]:getProperty("cityLevel") < self.filterCityLv then
				table.remove(self.memberListData, i)
			end
		end
	end
	if self.isShowOnline and self.isStickOnLine then
		table.sort(self.memberListData, function(a, b)
			local power_a = a.getProperty and a:getProperty("totalFc") or a.totalFc or 0
			local power_b = b.getProperty and b:getProperty("totalFc") or b.totalFc or 0
			if power_a ~= power_b then
				return power_a > power_b
			end
			local uid_a = a.getProperty and a:getProperty("uid") or a.uid
			local uid_b = b.getProperty and b:getProperty("uid") or b.uid
			return uid_a < uid_b
		end)
		local _ENV, newList = table.sort, table.sort
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if self.selectData[tostring(uid)] and v:getProperty("online") == 0 then
				table.insert(newList, v)
			end
		end
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if self.selectData[tostring(uid)] and v:getProperty("online") ~= 0 then
				table.insert(newList, v)
			end
		end
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if not self.selectData[tostring(uid)] and v:getProperty("online") == 0 then
				table.insert(newList, v)
			end
		end
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if not self.selectData[tostring(uid)] and v:getProperty("online") ~= 0 then
				table.insert(newList, v)
			end
		end
		self.memberListData = newList
	elseif self.isSortPower then
		local abbr = allianceMgr:getAllianceProperty("abbr")
		table.sort(self.memberListData, function(a, b)
			local uid_a = a.getProperty and a:getProperty("uid") or a.uid
			local uid_b = b.getProperty and b:getProperty("uid") or b.uid
			local select_a = self.selectData[tostring(uid_a)]
			local select_b = self.selectData[tostring(uid_b)]
			if select_a ~= select_b then
				return select_a
			end
			if abbr then
				local abbr_a = a.getProperty and a:getProperty("allianceAbbr") or a.allianceAbbr
				local abbr_b = b.getProperty and b:getProperty("allianceAbbr") or b.allianceAbbr
				if abbr_a ~= abbr_b then
					local selfAbbr_a = abbr_a == abbr
					local selfAbbr_b = abbr_b == abbr
					if selfAbbr_a ~= selfAbbr_b then
						return selfAbbr_a
					end
				end
			end
			local power_a = a.getProperty and a:getProperty("totalFc") or a.totalFc or 0
			local power_b = b.getProperty and b:getProperty("totalFc") or b.totalFc or 0
			if power_a ~= power_b then
				return power_a > power_b
			end
			return uid_a < uid_b
		end)
	end
	dump(self.memberListData, "self.memberListData")
	self.scroll:setNumItems(#self.memberListData)
end
function LordSelectViewPanel:onItemRenderer(index, single)
	local data = self.memberListData[index + 1]
	single:setHandle(handler(self, self.clickMemberBack))
	single:setOwnKingdom(self.isCheckKingdom)
	single:setOnline(self.isShowOnline)
	single:setLimitCasteLV(self.limitLV)
	single:showAbbr(self.isShowAbbr)
	single:initData(data)
	single:setTag(index + 1)
	single:setCheck(self.selectIndex[tostring(index + 1)] == true)
	_ENV = tostring(index + 1)
	tostring(index + 1).isLock = self.isLock
	single:lockSingle(nil, (tostring(index + 1)))
	single:initSearchData(data)
	single:setLimitTips(self.limitTips)
end
function LordSelectViewPanel:updateNotice()
	self.labelNone:setVisible(#self.memberListData <= 0)
	self.labelNone:setString(i18n("common_text_963"))
end
function LordSelectViewPanel:initSearchList()
	self:updateScrollWithData()
	self.scroll:setNumItems(#self.memberListData)
end
function LordSelectViewPanel:scrollEventCallBack(target, event)
	self.fromLoadText = true
	if self.keyname and self.nextIndex then
		lordInfoCtrl:searchLordInKingdomReq(self.keyname, self.nextIndex, lordSearchType.PIGEON)
		SoraDShowLoading(self:displayObject()):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	end
end
function LordSelectViewPanel:clickMemberBack(target, lordData)
	local uid = lordData.data.uid or lordData.data:getProperty("uid")
	local tag = target:getTag()
	if lordData.isSelect then
		self.selectData[tostring(uid)] = lordData.data
		self.selectIndex[tostring(tag)] = true
		self.selectedTarget = target
	else
		self.selectData[tostring(uid)] = nil
		self.selectIndex[tostring(tag)] = nil
		self.selectedTarget = nil
	end
	self.isLock = table.nums(self.selectData) >= self.maxCount
	_ENV = self.maxCount
	self.maxCount.msg = "MESSAGE_LORD_SELECT_BACK"
	self.maxCount.isLock = self.isLock
	SoraDSendMessage(self.maxCount)
	self:updateBtn()
end
function LordSelectViewPanel:onChooseClick(button, event)
	SoraDPlaySound()
	self.switcher = not self.switcher
	self.curSortType = tonumber(self.fields.ComboBox_sort:getValue())
	self:setSwitcher()
end
function LordSelectViewPanel:onNameClick(button, event)
	SoraDPlaySound()
	print("按名字排序")
	self.switcher = false
	self.curSortType = 1
	self:setSwitcher()
end
function LordSelectViewPanel:onUIDClick(button, event)
	SoraDPlaySound()
	print("按uid排序")
	self.switcher = false
	self.curSortType = 2
	self:setSwitcher()
end
function LordSelectViewPanel:setSwitcher()
	_ENV, _ENV = nil, nil
	;(nil).name = "common_text_3155"
	_ENV, (nil)[1], (nil).eventType = nil, nil, 1
	;(nil).name = "UID"
	;(nil)[2], (nil).eventType = nil, 2
	local sortTypeList
	_UPVALUE2_, _ENV = nil, nil
	_UPVALUE2_, (nil).items, (nil)[1] = nil, nil, i18n("common_text_3155")
	_UPVALUE2_, (nil).items, (nil)[2] = nil, nil, "UID"
	;(nil).values, (nil)[1] = nil, 1
	;(nil).values, (nil)[2] = nil, 2
	;(nil).changedCallback = handler(self, self.onChooseClick)
	;(nil).selectedValue = self.curSortType
	self:setComboBox(self.fields.ComboBox_sort, nil)
end
function LordSelectViewPanel:showAbbr(isShow)
	self.isShowAbbr = isShow
end
function LordSelectViewPanel:setStyleAtlantisSettingZero(params)
	self.warType = params.warType
	self:showAbbr(true)
	self:setOwnSelect(true)
	self:setTitleText(params.title)
	self:initData(gSearchStyle.LORD_KINGDOM, 1, i18n("shopping_text_10"))
	self:setShieldMap(params.shieldUidMap)
	self:setHandle(params.handle)
end
function LordSelectViewPanel:setStyleAtlantisManager(params)
	self.warType = params.warType
	self:showAbbr(true)
	self:setOwnSelect(true)
	self:setTitleText(params.title)
	self:setLimitCasteLV(params.castleLvLimit)
	self:setIsSortPower(true)
	self:setLimitTips(params.limitTips)
	self:initData(gSearchStyle.LORD_KINGDOM, 1, i18n("common_text_1417"))
	self:setSearchType(lordSearchType.PIGEON)
	self:setShieldMap(params.shieldUidMap)
	self:setHandle(params.handle)
end
return LordSelectViewPanel

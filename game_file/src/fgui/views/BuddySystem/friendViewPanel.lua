local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local friendViewPanel = class("friendViewPanel", baseFguiPanel)
function friendViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("friendViewPanel:ctor", self.viewName)
end
function friendViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function friendViewPanel:onInit()
	print("=======friendViewPanel:onInit")
	self.viewType = 1
	self.isHaveTextField = true
	self.deleteType = false
	self.rankIndex = 1
	self.searchList, _ENV, self.friendList, _ENV, self.searchType = print, print, print, print, 1
	self.fields.Com_title:initData(i18n("friend_name_01"), handler(self, self.onClickClose))
	self.fields.Button_delete:addClickListener(handler(self, self.onDeleteClick))
	self.fields.Text_notice:setString(i18n("friend_text_04"))
	self.fields.Button_add:setString(i18n("common_text_477"))
	self.fields.Button_add:addClickListener(handler(self, self.onAddClick))
	_UPVALUE1_ = self.fields.Button_add.addClickListener
	_UPVALUE2_, self.fields.Button_add.addClickListener[1] = i18n("friend_text_02"), i18n("friend_text_02")
	_UPVALUE2_, self.fields.Button_add.addClickListener[2] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[3] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[4] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[5] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[6] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[7] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[8] = i18n("friend_text_02"), i18n("friend_text_03")
	_UPVALUE2_, self.fields.Button_add.addClickListener[9] = i18n("friend_text_02"), i18n("friend_text_03")
	local _UPVALUE2_, self.fields.Button_add.addClickListener[10], items = i18n("friend_text_02"), i18n("friend_text_03")
	i18n("friend_text_02")[1] = 1
	local i18n("friend_text_02")[2], values = 2, i18n("friend_text_02")
	_ENV = i18n("friend_text_03")
	i18n("friend_text_03").items = items
	i18n("friend_text_03").values = values
	i18n("friend_text_03").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("friend_text_03"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.rankIndex - 1)
	end)
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.Button_applyList:setString(i18n("friend_btn_03"))
	self.fields.Button_applyList:addClickListener(handler(self, self.onApplyListView))
	self.fields.List_myFriend:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Text_kingdom:setString(i18n("common_text_479"))
	self.fields.Text_inputTip:setString(i18n("friend_text_12"))
	self.fields.Text_inputTip:setVisible(false)
	_UPVALUE1_, _ENV = i18n("friend_text_12")
	_UPVALUE2_, i18n("friend_text_12").items, i18n("friend_text_12")[1] = i18n("friend_text_12")
	_UPVALUE2_, i18n("friend_text_12").items, i18n("friend_text_12")[2] = i18n("friend_text_12")
	_UPVALUE2_, i18n("friend_text_12").items, i18n("friend_text_12")[3] = i18n("friend_text_12")
	i18n("friend_text_12").values, i18n("friend_text_12")[1] = i18n("friend_text_12")
	i18n("friend_text_12").values, i18n("friend_text_12")[2] = i18n("friend_text_12")
	i18n("friend_text_12").changedCallback = handler(self, self.onComboBoxTypeClick)
	self:setComboBox(self.fields.ComboBox_type, i18n("friend_text_12"))
	local dropTypedown = self.fields.ComboBox_type:getDropdown()
	self.comboBoxTypeList = dropTypedown:getChildByName("list")
	self.fields.ComboBox_type:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxTypeList:setSelectedIndex(self.searchType - 1)
	end)
	self.fields.ComboBox_type:fixChildrenPos()
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onSearchClick))
	self.fields.Button_addList:setString(i18n("friend_btn_08"))
	self.fields.Button_addList:addClickListener(handler(self, self.onAddListView))
	self.fields.TextField_kingdom:setMaxLength(4)
	self.fields.TextField_name:setMaxLength(15)
	self.fields.List_addFriend:setItemRenderer(handler(self, self.onAddListRenderer))
	self.fields.ComboBox_sort:fixPos()
	self.fields.Button_delete:fixPos()
	self.fields.Text_friendNum:fixPos()
	self.fields.Text_kingdom:fixPos()
	self.fields.n34:fixPos()
	self.fields.TextField_kingdom:fixPos()
	self.fields.ComboBox_type:fixPos()
	self.fields.n36:fixPos()
	self.fields.TextField_name:fixPos()
	self.fields.Button_search:fixPos()
end
function friendViewPanel:onListRenderer(index, obj)
	obj:initData(self.friendList[index + 1], self.viewType, self.rankIndex, self.deleteType)
end
function friendViewPanel:onAddListRenderer(index, obj)
	obj:initData(self.searchList[index + 1])
end
function friendViewPanel:onShow()
	print("=======friendViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.viewType = self.param and self.param.viewType or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.viewType, self.viewType
	;(nil).title = i18n("friend_btn_01")
	_ENV, self.viewType[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("friend_btn_02")
	;(nil).tabsetArray, self.viewType[2], (nil).tag = self.viewType, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function friendViewPanel:onClickTab(tag)
	self.viewType = tag
	self.controllers.c1:setSelectedIndex(self.viewType - 1)
	if self.viewType == 1 then
		SoraDShowLoading(self)
		contactCtrl:reqGetData(true, false, true)
	else
		contactCtrl:reqGetData(false, true, false)
		if allianceMgr:hasJoinAlliance() then
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			allianceQuery:reqMemberList(allianceMgr.ownaid)
		else
			self.fields.Text_inputTip:setVisible(true)
		end
	end
end
function friendViewPanel:onComboBoxClick()
	SoraDPlaySound()
	self.rankIndex = tonumber(self.fields.ComboBox_sort:getValue())
	self:updateFriendList()
end
function friendViewPanel:onComboBoxTypeClick()
	SoraDPlaySound()
	self.searchType = tonumber(self.fields.ComboBox_type:getValue())
end
function friendViewPanel:updateFriendList(target, data)
	SoraDCloseLoading(self)
	if self.viewType == 1 then
		self.friendList, _ENV = self.viewType, self.viewType
		local mapList = contactCtrl:getContactList()
		for k, v in pairs(mapList) do
			v.uid = tonumber(k)
			table.insert(self.friendList, v)
		end
		table.sort(self.friendList, function(a, b)
			if self.rankIndex == 1 then
				return a.totalFc > b.totalFc
			else
				return a.cityLevel > b.cityLevel
			end
		end)
		local contactMax = contactCtrl:getContactFriendMax()
		self.fields.Text_friendNum:setString(string.format(i18n("friend_text_01") .. " %d/%d", #self.friendList, contactMax))
		self.fields.Text_notice:setVisible(#self.friendList == 0)
		self.fields.Button_add:setVisible(#self.friendList == 0)
		self.fields.Button_delete:setVisible(#self.friendList > 0)
		self.fields.List_myFriend:setNumItems(#self.friendList)
	end
end
function friendViewPanel:updateRedPoint(target, data)
	if not contactCtrl:getRecvInviteMap() then
		local contactCtrl, inviteList = contactCtrl:getRecvInviteMap(), contactCtrl:getRecvInviteMap()
	end
	local num = table.nums(inviteList)
	contactCtrl = nil
	;(nil).visible = 0 < num
	;(nil).num = num
	self.fields.Button_applyList:setRedDot(nil)
	self.fields.Com_tab:setBtnRedDot(1, 0 < num, num)
end
function friendViewPanel:updateSearchList(target, data)
	SoraDCloseLoading()
	if self.viewType == 2 then
		if data and data.msg == "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS" then
			local defaultList = contactCtrl:getAllianceContactList()
			self.fields.Text_inputTip:setVisible(#defaultList < 1)
			self.searchList = defaultList
			_ENV = nil
			;(nil).data = defaultList
			;(nil).isAlliance = true
			self:updateSearchList(self, nil)
			return
		end
		if data and data.msg == "MESSAGE_SERVER_FRIEND_ADD" then
			for k, v in ipairs(self.searchList) do
				if tonumber(v.uid) == tonumber(data.uid) then
					table.remove(self.searchList, k)
					break
				end
			end
			self.fields.Text_inputTip:setVisible(#self.searchList == 0)
			self.fields.List_addFriend:setNumItems(#self.searchList)
			return
		end
		if data and data.data and data.data.uinfolist then
			self.searchList, _ENV = data.data.uinfolist, data.data.uinfolist
			local kid = self.fields.TextField_kingdom:getText()
			if kid == "" or kid ~= "" and not kingdomCtrl:isFoundKingdomID(tonumber(kid)) then
				kid = gametop.playertop_:getMapID()
			else
				kid = tonumber(kid)
			end
			for k, v in ipairs(data.data.uinfolist) do
				if v.uid ~= gametop.playertop_:getPlayerID() and not contactCtrl:isFriend(v.uid) and v.sourceKid == 0 then
					if self.searchType == 1 and v.partition == kid then
						v.kid = v.partition
						table.insert(self.searchList, v)
					elseif self.searchType == 2 then
						v.kid = v.partition
						table.insert(self.searchList, v)
					end
				end
			end
			self.fields.List_addFriend:setNumItems(#self.searchList)
			self.fields.Text_inputTip:setVisible(#self.searchList == 0)
			if 0 < #data.data.uinfolist then
				if #self.searchList == 0 and not data.isAlliance then
					SoraDShowMsgTip(i18n("friend_text_13"))
				end
			elseif not data.isAlliance then
				SoraDShowMsgTip(i18n("friend_text_19"))
			end
		elseif data.msg == "MESSAGE_SERVER_OPTION_SEARCH_LORD" and not data.data then
			if not self.searchList then
				_ENV = self.searchList
			end
			self.searchList = self.searchList
			self.fields.Text_inputTip:setVisible(#self.searchList == 0)
			self.fields.List_addFriend:setNumItems(#self.searchList)
		else
			self.fields.List_addFriend:setNumItems(#self.searchList)
		end
	end
end
function friendViewPanel:onAddClick()
	SoraDPlaySound()
	self.fields.Com_tab:setToTag(2)
	self.fields.Com_tab:clickTab(2)
end
function friendViewPanel:setBtnDeleteModel()
	local img = self.deleteType and "icon_haoyou_back.png" or "icon_haoyou_shanchu.png"
	self.fields.Button_delete:setIcon(img)
end
function friendViewPanel:onDeleteClick()
	self.deleteType = not self.deleteType
	self:setBtnDeleteModel()
	self.fields.List_myFriend:setNumItems(#self.friendList)
end
function friendViewPanel:onApplyListView()
	SoraDPlaySound()
	uiManager:show("friendApplyListView")
end
function friendViewPanel:onAddListView()
	SoraDPlaySound()
	uiManager:show("friendAddListView")
end
function friendViewPanel:onSearchClick()
	SoraDPlaySound()
	local kid = self.fields.TextField_kingdom:getText()
	local name = self.fields.TextField_name:getText()
	local pid = self.fields.TextField_name:getText()
	if tonumber(kid) then
		kid = math.floor(tonumber(kid) or 0)
		if kid < 1 then
			kid = 1
		end
		if kid > kingdomCtrl:getKingdomNum() then
			kid = kingdomCtrl:getKingdomNum()
		end
	end
	self.fields.TextField_kingdom:setText(kid)
	if kid == "" or kid ~= "" and not kingdomCtrl:isFoundKingdomID(tonumber(kid)) then
		kid = gametop.playertop_:getMapID()
	else
		kid = tonumber(kid)
	end
	if kid >= GAME_KINGDOM_ID_ASSIGN.GAME.START and kid <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		self.fields.TextField_kingdom:setText(kid)
	else
		self.fields.TextField_kingdom:setText("")
	end
	if tonumber(kid) and (kid > GAME_KINGDOM_ID_ASSIGN.GAME.END or kid < GAME_KINGDOM_ID_ASSIGN.GAME.START) then
		SoraDShowMsgTip(i18n("friend_text_33"))
		return
	end
	if name == "" then
		SoraDShowMsgTip(i18n("friend_text_20"))
		return
	end
	if string.utf8len(name) < 3 then
		SoraDShowMsgTip(i18n("friend_text_12"))
		return
	end
	if self.searchType == 1 then
		pid = nil
	else
		name = nil
	end
	lordInfoCtrl:searchLordInThisKingdomReq(name, 1, kid, pid, lordSearchType.PIGEON)
end
function friendViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "addFriend" then
		return self.fields.Com_tab:getBtn(1)
	else
		return self.fields[itemName]
	end
end
return friendViewPanel

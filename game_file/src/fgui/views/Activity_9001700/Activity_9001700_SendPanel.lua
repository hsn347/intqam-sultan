local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_SendPanel = class("Activity_9001700_SendPanel", baseFguiPanel)
function Activity_9001700_SendPanel:ctor(...)
	self.isLRU = true
	Activity_9001700_SendPanel.super.ctor(self, ...)
	print("Activity_9001700_SendPanel:ctor", self.viewName)
	self.searchType = 1
	self.selfUid = gametop.playertop_:getPlayerID()
end
function Activity_9001700_SendPanel:onInit()
	print("=======Activity_9001700_SendPanel:onInit")
	self.fields.Panel_bg:setString(i18n("eid_fireworks_014"))
	self.fields.Text_kid:setString(i18n("common_text_479"))
	self.fields.input_kid = self.fields.input_kid:getChild("input")
	self.fields.input_name = self.fields.input_name:getChild("input")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local ComboBox = self.fields.ComboBox_type
	_UPVALUE1_, _ENV = handler(self, self.onItemRenderer)
	_UPVALUE2_, handler(self, self.onItemRenderer).items, handler(self, self.onItemRenderer)[1] = handler(self, self.onItemRenderer)
	_UPVALUE2_, handler(self, self.onItemRenderer).items, handler(self, self.onItemRenderer)[2] = handler(self, self.onItemRenderer)
	_UPVALUE2_, handler(self, self.onItemRenderer).items, handler(self, self.onItemRenderer)[3] = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).values, handler(self, self.onItemRenderer)[1] = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).values, handler(self, self.onItemRenderer)[2] = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).changedCallback = handler(self, self.onComboBoxTypeClick)
	self:setComboBox(ComboBox, handler(self, self.onItemRenderer))
	local dropTypedown = ComboBox:getDropdown()
	self.comboBoxTypeList = dropTypedown:getChildByName("list")
	ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxTypeList:setSelectedIndex(self.searchType - 1)
	end)
	ComboBox:fixChildrenPos()
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function Activity_9001700_SendPanel:endShow()
	print("=======Activity_9001700_SendPanel:endShow")
	SoraDCloseLoading(self)
	self.searchList, _ENV, self.idx = self.param and self.param.idx, self.param and self.param.idx, self.param and self.param.idx
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_noData:setVisible(true)
	self.fields.Text_noData:setString(i18n("eid_fireworks_033"))
	self.fields.input_kid:setText("")
	self.fields.input_name:setText("")
	self.isFrindListBack = false
	self.isMemberListBack = false
	contactCtrl:reqGetData(true, false, false)
	self.ownaid = allianceMgr:getOwnAid()
	if self.ownaid then
		allianceQuery:reqMemberList(self.ownaid)
	else
		self.isMemberListBack = true
	end
end
function Activity_9001700_SendPanel:onComboBoxTypeClick()
	SoraDPlaySound()
	self.searchType = tonumber(self.fields.ComboBox_type:getValue())
end
function Activity_9001700_SendPanel:onClickBtnSearch()
	SoraDPlaySound()
	local kid = self.fields.input_kid:getText()
	local name = self.fields.input_name:getText()
	local pid = self.fields.input_name:getText()
	kid = tonumber(kid)
	if not kingdomCtrl:isFoundKingdomID(kid) then
		kid = gametop.playertop_:getMapID()
	end
	if kid >= GAME_KINGDOM_ID_ASSIGN.GAME.START and kid <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		self.fields.input_kid:setText(kid)
	else
		self.fields.input_kid:setText("")
		SoraDShowMsgTip(i18n("friend_text_33"))
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
function Activity_9001700_SendPanel:onMsgUpdateSearchList(target, event)
	local _ENV, showList
	local _ENV, filter
	filter[self.selfUid] = true
	local uinfolist = event.data.uinfolist
	for __, v in ipairs(uinfolist) do
		if not filter[v.uid] then
			table.insert(showList, v)
		end
	end
	self.searchList = showList
	self:updateSearchList()
end
function Activity_9001700_SendPanel:updateSearchList(...)
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_noData:setString(i18n("friend_text_19"))
	self.fields.Text_noData:setVisible(#self.searchList <= 0)
end
function Activity_9001700_SendPanel:onItemRenderer(index, obj)
	local data = self.searchList[index + 1]
	obj:initData(self.idx, data)
	obj:setParentPanel(self)
end
function Activity_9001700_SendPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "give" then
		self:closePanel()
	elseif subMsg == "giveErr" then
		SoraDCloseLoading(self)
	end
end
function Activity_9001700_SendPanel:onMsgUpdateMemberList(...)
	self.isMemberListBack = true
	self:updatePlayerList()
end
function Activity_9001700_SendPanel:onMsgUpdateFriendList(...)
	self.isFrindListBack = true
	self:updatePlayerList()
end
function Activity_9001700_SendPanel:updatePlayerList(...)
	if not self.isMemberListBack or not self.isFrindListBack then
		return
	end
	local allianceMgr, showList = self.isFrindListBack, self.isFrindListBack
	local allianceMgr, filter
	filter[self.selfUid] = true
	if self.ownaid then
		local allianceMgr, tempList = self.ownaid, self.ownaid
		local memberList = allianceMgr:getAllianceProperty("memberlist")
		for __, uid in ipairs(memberList) do
			if not filter[uid] then
				table.insert(tempList, uid)
			end
		end
		local randomList = self:getRandomList(tempList)
		for __, uid in ipairs(randomList) do
			local member = memberMgr:getMember(uid)
			local uinfo = member:getProperty("uinfo")
			local data = clone(uinfo)
			data.uid = uid
			data.kid = data.partition
			table.insert(showList, data)
		end
	end
	dump(showList, "==Activity_9001700_SendPanel:updatePlayerList=111=")
	local friendList = contactCtrl:getContactList()
	for i, v in ipairs(showList) do
		filter[v.uid] = true
	end
	local allianceMgr, tempList = (for generator), ipairs(showList)
	for k, __ in pairs(friendList) do
		local uid = tonumber(k)
		if not filter[uid] then
			table.insert(tempList, uid)
		end
	end
	local randomList = self:getRandomList(tempList)
	for __, uid in ipairs(randomList) do
		local friend = friendList[tostring(uid)]
		local data = clone(friend)
		data.uid = uid
		data.iconID = data.headid
		data.nickName = data.name
		data.kid = data.sourceKid
		table.insert(showList, data)
	end
	dump(showList, "==Activity_9001700_SendPanel:updatePlayerList=222=")
	self.searchList = showList
	self:updateSearchList()
end
function Activity_9001700_SendPanel:getRandomList(tempList)
	local _ENV, ret
	local maxNum = math.min(3, #tempList)
	for i = 1, maxNum do
		local idx = math.random(1, #tempList)
		local uid = table.remove(tempList, idx)
		table.insert(ret, uid)
	end
	return ret
end
return Activity_9001700_SendPanel

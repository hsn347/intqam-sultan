local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseComponent = require("fgui.base.baseComponent")
local Data_searchList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Data_searchList", Data_searchList)
function Data_searchList:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.onMsgUpdateMemberList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.onMsgUpdateFriendList))
end
function Data_searchList:onInit()
	self.selfUid = gametop.playertop_:getPlayerID()
	self.memberCount = 5
	self.searchList, gametop, self.friendCount = gametop.playertop_:getPlayerID(), gametop.playertop_:getPlayerID(), 5
end
function Data_searchList:onShow()
end
function Data_searchList:onMsgUpdateMemberList(...)
	self.isMemberListBack = true
	self:updatePlayerList()
end
function Data_searchList:onMsgUpdateFriendList(...)
	self.isFrindListBack = true
	self:updatePlayerList()
end
function Data_searchList:updatePlayerList(...)
	if not self.isMemberListBack or not self.isFrindListBack then
		return
	end
	local allianceMgr, showList = self.isFrindListBack, self.isFrindListBack
	local allianceMgr, filter
	filter[self.selfUid] = true
	if self.needMember and self.ownaid then
		local allianceMgr, tempList = self.ownaid, self.ownaid
		local memberList = allianceMgr:getAllianceProperty("memberlist")
		local alliance = allianceMgr:getAllianceProperty("property")
		dump(memberList, "==Data_searchList:updatePlayerList=memberList=")
		for __, uid in ipairs(memberList) do
			if not filter[uid] then
				table.insert(tempList, uid)
			end
		end
		tempList = self:filterMemberList(tempList)
		local randomList = self:getRandomList(tempList, self.memberCount)
		for __, uid in ipairs(randomList) do
			local member = memberMgr:getMember(uid)
			local uinfo = member:getProperty("uinfo")
			local data = clone(uinfo)
			data.uid = uid
			data.kid = data.partition
			data.alliance = alliance.aid
			data.allianceName = alliance.name
			data.allianceAbbr = alliance.abbr
			table.insert(showList, data)
		end
	end
	dump(showList, "==Data_searchList:updatePlayerList=111=")
	for i, v in ipairs(showList) do
		filter[v.uid] = true
	end
	if self.needFriend then
		local friendList = contactCtrl:getContactList()
		dump(friendList, "==Data_searchList:updatePlayerList=friendList=")
		local allianceMgr, tempList = dump, dump
		for k, __ in pairs(friendList) do
			local uid = tonumber(k)
			if not filter[uid] then
				table.insert(tempList, uid)
			end
		end
		local randomList = self:getRandomList(tempList, self.friendCount)
		for __, uid in ipairs(randomList) do
			local friend = friendList[tostring(uid)]
			local data = clone(friend)
			data.uid = uid
			data.iconID = data.headid
			data.nickName = data.name
			data.kid = data.sourceKid
			table.insert(showList, data)
		end
	end
	dump(showList, "==Data_searchList:updatePlayerList=222=")
	self.searchList = showList
	if self.needRandom then
		self.searchList = self:getRandomList(self.searchList, #self.searchList)
	end
	if self.updateHandler then
		self.updateHandler(self.searchList)
	end
end
function Data_searchList:filterMemberList(memberList)
	local _ENV, ret
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001702 then
		for __, uid in ipairs(memberList) do
			local member = memberMgr:getMember(uid)
			local uinfo = member:getProperty("uinfo")
			local cityLevel = uinfo.cityLevel
			if uinfo.cityLevel >= 6 then
				local online = uinfo.online
				if online and online < 1209600 then
					table.insert(ret, uid)
				end
			end
		end
	else
		ret = memberList
	end
	return ret
end
function Data_searchList:getRandomList(tempList, randomCount)
	local _ENV, ret
	local maxNum = math.min(randomCount or 0, #tempList)
	for i = 1, maxNum do
		local idx = math.random(1, #tempList)
		local uid = table.remove(tempList, idx)
		table.insert(ret, uid)
	end
	return ret
end
function Data_searchList:getSearchList()
	return self.searchList
end
function Data_searchList:setMemberCount(count)
	self.memberCount = count
end
function Data_searchList:setFriendCount(count)
	self.friendCount = count
end
function Data_searchList:setUpdateHandler(handler)
	self.updateHandler = handler
end
function Data_searchList:initData(data)
	self.activityID = data.activityID
	self:setUpdateHandler(data.updateHandler)
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001702 then
		self.needRandom = true
		self.memberCount = 10
		self.needMember = true
	end
	self.isFrindListBack = true
	self.isMemberListBack = true
	if self.needMember then
		self.ownaid = allianceMgr:getOwnAid()
		if self.ownaid then
			self.isMemberListBack = false
			allianceQuery:reqMemberList(self.ownaid)
		end
	end
	if self.needFriend then
		self.isFrindListBack = false
		contactCtrl:reqGetData(true, false, false)
	end
	self:updatePlayerList()
end
return Data_searchList

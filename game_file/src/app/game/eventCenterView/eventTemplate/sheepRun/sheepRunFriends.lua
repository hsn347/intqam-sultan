local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local sheepRunCtrl = gametop.playertop_:getModule("sheepRunCtrl")
local sheepRunFriends = class("sheepRunFriends", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sheepRunFriends")
end)
function sheepRunFriends:ctor()
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.title:setTitleName(i18n("friend_name_01"))
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("sheepRunFriendSingle")
	SoraDShowLoading(self)
	contactCtrl:reqGetData(true, false, false)
end
function sheepRunFriends:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CHOOSE_FRIEND", handler(self, self.onFriendChooseM))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_STATUS_UPDATE", handler(self, self.updateFriendList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.updateFriendList))
end
function sheepRunFriends:updateFriendList()
	SoraDCloseLoading(self)
	local curUid = sheepRunCtrl:getCurContactUid()
	self.friendList, _ENV = sheepRunCtrl, sheepRunCtrl
	local mapList = contactCtrl:getContactList()
	for k, v in pairs(mapList) do
		v.uid = tonumber(k)
		table.insert(self.friendList, v)
	end
	table.sort(self.friendList, function(a, b)
		return a.totalFc > b.totalFc
	end)
	_ENV = table.insert
	table.insert.view = self
	table.insert.curUid = curUid
	table.insert.friend = true
	self.scroll:updateScrollView(cc.size(541, 120), self.friendList, 1, table.insert)
end
function sheepRunFriends:onFriendChooseM()
	_UPVALUE2_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.removeFromParent
	dump(nil, "eepRunFriends:onFriendChoose")
	self:removeFromParent()
end
return sheepRunFriends

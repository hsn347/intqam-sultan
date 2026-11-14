local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local callFriendsBackPopView = class("callFriendsBackPopView", function(target)
	return SoraDCreateTouchPanel("callFriendsBackPopView")
end)
function callFriendsBackPopView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("friend_back_text04"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("callFriendsBackSingle")
	self.text_noFriend = SoraDGetChildByName(self, "text_noFriend")
	self.text_noFriend:setString(i18n("friend_back_text05"))
	self:initData()
end
function callFriendsBackPopView:initData()
	local callFriendData = sultansBackCtrl:getCallFriendData()
	if next(callFriendData.friendsData) then
		self.text_noFriend:setVisible(false)
	else
		self.text_noFriend:setVisible(true)
	end
	local sultansBackCtrl, friendList = self.text_noFriend.setVisible, self.text_noFriend.setVisible
	for k, v in pairs(callFriendData.friendsData) do
		table.insert(friendList, v)
	end
	for i, v in ipairs(friendList) do
		v.index = i
	end
	sultansBackCtrl = table.insert
	table.insert.scroll = self.scroll
	table.insert.view = self
	self.scroll:updateScrollView(cc.size(538, 122), friendList, 1, table.insert)
end
return callFriendsBackPopView

local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local publicRead = include("publicRead")
local friendsCallbackRead = include("friendsCallbackRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local callbackFriendsShare = class("callbackFriendsShare", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("callbackFriendsShare")
	end
	return target
end)
function callbackFriendsShare:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("return_title_03"))
	self.node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_friends")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV, self.text_alter = SoraDGetChildByName(self, "Text_alter"), SoraDGetChildByName(self, "Text_alter"), SoraDGetChildByName(self, "Text_alter"), SoraDGetChildByName(self, "Text_alter"), SoraDGetChildByName(self, "Text_alter")
	self.itemSize = cc.size(540, 80)
	self:initView()
end
function callbackFriendsShare:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK", function(target, data)
		self:clearOld()
		self:initView()
	end)
end
function callbackFriendsShare:initView()
	self.backFriendsList = friendsCallbackCtrl:getInviteList()
	if next(self.backFriendsList) == nil then
		self.text_alter:setString(i18n("return_text_22"))
	else
		self.text_alter:setVisible(false)
		self:updateScrollData()
	end
end
function callbackFriendsShare:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function callbackFriendsShare:updateScrollData()
	for k, v in pairs(self.backFriendsList) do
		_ENV = nil
		;(nil).data = v
		_ENV, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initScroll()
	self:initFriendsList()
end
function callbackFriendsShare:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local accumulateHeight = self.itemSize.height * #self.tableItemsSel + 30
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = accumulateHeight - i * self.itemSize.height
		v.pos.x = 10
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function callbackFriendsShare:initFriendsList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = self.node_single:clone()
				single:addTo(self.scroll)
			end
			self:initSingleView(v.data, single)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function callbackFriendsShare:initSingleView(data, _node)
	local single = _node
	local img_head = SoraDGetChildByName(single, "Image_friendsHead")
	SoraDGetChildByName(single, "Text_friendskindom"):setString(data.kid)
	SoraDGetChildByName(single, "Text_friendsName"):setString(data.nickName)
	SoraDGetChildByName(single, "Text_gold"):setString(data.gold)
	SoraDGetChildByName(single, "Text_gift"):setString(data.giftNum)
	SoraDGetHeadFromManager(img_head, data.iconID, data.avatar)
end
function callbackFriendsShare:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initFriendsList()
	end
end
return callbackFriendsShare

local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local honorBackLoginNode = class("honorBackLoginNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackLoginNode")
	end
	return target
end)
function honorBackLoginNode:ctor()
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCCS("honorBackLoginItem")
	local item = SoraDCreatePanel("honorBackLoginItem")
	self.itemSize = item:getItemSize()
	self.oldSize = self.Panel_cut:getContentSize()
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_HONORBACK)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, 10, SoraDFIsRA())
	end
	self:initLoginDes()
end
function honorBackLoginNode:setSize(size)
	self.Panel_cut:setContentSize(size)
	self.Top_Node:setPositionY(size.height)
	local sSize = self.scroll:getContentSize()
	self.scroll:setContentSize(cc.size(sSize.width, sSize.height + size.height - self.oldSize.height))
end
function honorBackLoginNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK", function(target, data)
		self:updateScrollData()
	end)
end
function honorBackLoginNode:initData()
	self.eventDatas = friendsCallbackRead.honorBackTaskLoginConfig
	self.loginDays = honorBackCtrl:getLoginDays()
	self:updateScrollData(true)
end
function honorBackLoginNode:updateScrollData(needJump)
	_UPVALUE0_ = nil
	;(nil).view = self.Panel_cut
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(self.itemSize, self.eventDatas, 1, nil)
	if needJump and self.loginDays > 0 and self.loginDays <= #self.eventDatas then
		self.scroll:jumpIndexToCenter(self.loginDays)
	end
end
function honorBackLoginNode:initLoginDes(...)
	self.Node_des_ar = SoraDGetChildByName(self, "Node_des_ar")
	self.Node_des_en = SoraDGetChildByName(self, "Node_des_en")
	self.Image_activity = SoraDGetChildByName(self, "Image_activity")
	self.Image_activity:ignoreContentAdaptWithSize(true)
	self.Image_activity:setAnchorPoint(cc.p(0.5, 0.5))
	self.Image_activity:setPosition(320, 100)
	SoraChangeSpriteImage(self.Image_activity, "bg_activity_9001114_2.png")
	local node_des, node_hide
	if SoraDFIsRA() then
		node_hide = self.Node_des_en
		node_des = self.Node_des_ar
		self.Image_activity:setFlippedX(false)
	else
		node_hide = self.Node_des_ar
		node_des = self.Node_des_en
		self.Image_activity:setFlippedX(true)
	end
	node_hide:setVisible(false)
	node_des:setVisible(true)
	self.Text_des = SoraDGetChildByName(node_des, "Text_des")
	self.Text_des:setString(i18n("returnnew_text_016"))
end
return honorBackLoginNode

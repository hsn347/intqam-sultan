local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = gametop.playertop_:getModule("honorBackCtrl")
local publicRead = include("publicRead")
local honorBackLoginItem = class("honorBackLoginItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackLoginItem")
	end
	return target
end)
function honorBackLoginItem:getItemSize(...)
	return self.panel_content:getContentSize()
end
function honorBackLoginItem:ctor(...)
	self.tbInUse, _ENV = nil, nil
	SoraDGetAllChildFromWidget(self, self)
	self.Text_day:setString(i18n("Day"))
	self.btn_operate:addTouchEventListener(handler(self, self.btnOperateClick))
	self.Image_received:setVisible(false)
	if not SoraDFIsRA() then
		for k, v in pairs(self.Node_content:getChildren()) do
			v:setPositionX(-v:getPositionX())
		end
		self.Image_bg:setFlippedX(true)
	end
	self.Image_1:setFillType(1)
end
function honorBackLoginItem:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK", function(target, data)
		SoraDCloseLoading(self.btn_operate)
	end)
end
function honorBackLoginItem:initData(data, otherData)
	SoraDCloseLoading(self.btn_operate)
	self.taskData = data
	self.view = otherData.view
	self.scroll = otherData.scroll
	self:setNumIcon(data)
	for i, v in ipairs(self.tbInUse) do
		v:setVisible(false)
	end
	local itemWidth = 97
	for i, v in ipairs(data.Reward) do
		if 3 < i then
			break
		end
		local item = self.tbInUse[i]
		if not item then
			item = SoraDCreatePanel("commonItemAward")
			item:setScale(0.83)
			item:setPosition(SoraDFSign(-itemWidth * (i - 1)), 0)
			item:setOwnView(self.view)
			item:addTo(self.Node_items)
			self.tbInUse[i] = item
		end
		item:setVisible(true)
		item:initData(v.id, v.count)
	end
	local taskstatus = honorBackCtrl:getLoginDaysState(data.day)
	if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
		self.btn_operate:setBright(true)
		self.btn_operate:setTouchEnabled(true)
		self.btn_operate:setTitleText(i18n("common_text_1146"))
		self.btn_operate:setVisible(true)
		self.Image_received:setVisible(false)
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE then
		self.btn_operate:setVisible(false)
		self.Image_received:setVisible(true)
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_DOING then
		self.Image_received:setVisible(false)
		self.btn_operate:setBright(false)
		self.btn_operate:setTouchEnabled(false)
		self.btn_operate:setTitleText(i18n("common_text_2139"))
		self.btn_operate:setVisible(true)
	end
	local loginDays = honorBackCtrl:getLoginDays()
	if loginDays == data.day then
		self.Node_bg:setVisible(false)
		self.Image_bg:setVisible(true)
	else
		self.Node_bg:setVisible(true)
		self.Image_bg:setVisible(false)
	end
end
function honorBackLoginItem:setNumIcon(data)
	local getNumIcon = function(num)
		if num == 0 then
			num = 10
		end
		return string.format("frame_hzlh_num_%.2d.png", num)
	end
	local one = data.day % 10
	local ten = math.floor(data.day / 10)
	self.Sprite_day_one:setSpriteFrame(getNumIcon(one))
	if 0 < ten then
		self.Sprite_day_ten:setSpriteFrame(getNumIcon(ten))
		self.Sprite_day_ten:setVisible(true)
	else
		self.Sprite_day_ten:setVisible(false)
	end
	SoraDToCenter(self.Node_day, 0)
end
function honorBackLoginItem:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		local taskstatus = honorBackCtrl:getLoginDaysState(self.taskData.day)
		if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
			SoraDShowLoading(sender)
			honorBackCtrl:reqHonorLoginGift(self.taskData.day)
		end
	end
end
return honorBackLoginItem

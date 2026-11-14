local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_event = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_event", Com_event)
function Com_event:onInit()
	self.reqInit = false
	self:addClickListener(handler(self, self.onClickBtn))
end
function Com_event:registerEvent()
	SoraDAddMessage(self, "MESSAGE_NEW_START_INITNEW", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_NEWS_ERVER_BACK_RED_POINT", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_NEW_START_GETREWARD_BACK", handler(self, self.updateRedPointReward))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateRedPointByItem))
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_REFRESH", handler(self, self.updateRedPointByItem))
end
function Com_event:updateRedPoint(target, data)
	if data.activityID == self.activityID then
		print("红点刷新")
		local showRed = newStartMainCtrl:getReceiveStatusAndNumByActID(data.activityID)
		self.fields.Label_reddot:initData(showRed)
	end
end
function Com_event:updateRedPointReward(target, data)
	if gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY == self.activityID then
		local showRed = newStartMainCtrl:getReceiveStatusAndNumByActID(gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY)
		self.fields.Label_reddot:initData(showRed)
	end
end
function Com_event:updateRedPointByItem(target, data)
	if gActivityTimeActivityID.VICIOUS_PET_ACTIVITY == self.activityID then
		local showRed = newStartMainCtrl:getReceiveStatusAndNumByActID(gActivityTimeActivityID.VICIOUS_PET_ACTIVITY)
		self.fields.Label_reddot:initData(showRed)
	end
end
function Com_event:initData(index, data, btnHandle)
	self.activityID = data.activityID
	self:setTag(data.tag or index)
	self.fields.title:setString(data.title or "event day")
	self.fields.icon:setURL(data.iconURL or "8840.png")
	self.btnHandle = btnHandle
	local showRed = newStartMainCtrl:getReceiveStatusAndNumByActID(data.activityID)
	self.fields.Label_reddot:initData(showRed)
end
function Com_event:onClickBtn()
	SoraDPlaySound()
	if self.btnHandle and self:getTag() then
		self.btnHandle(self:getTag())
	end
end
function Com_event:onShow()
end
return Com_event

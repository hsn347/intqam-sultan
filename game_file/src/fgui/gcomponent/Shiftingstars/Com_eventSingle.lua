local activityTimeRead = include("activityTimeRead")
local shiftingstarsRead = include("shiftingstarsRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_eventSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Shiftingstars/Com_eventSingle", Com_eventSingle)
function Com_eventSingle:onInit()
	self.rewards, _ENV = nil, nil
	self.fields.Text_end:setString(i18n("Community_text_0011"))
	self.fields.touch:addClickListener(handler(self, self.onClickEvent))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.fields.n25:fix(false)
end
function Com_eventSingle:onShow()
end
function Com_eventSingle:onItemRenderer(index, object)
	object:getChildByName("Com_item"):initData(self.rewards[index + 1])
end
function Com_eventSingle:initData(index, data)
	self.data = data
	self.activityID = self.data.activityID
	self.fields.Text_name:setString(i18n(activityTimeRead.getActivityNameByID(self.data.activityID, self.data.classtype)))
	self.fields.Label_banner:setIcon(shiftingstarsRead.getActBgByIDEX(self.data.activityID))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(self.data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(self.data.endTime), "-", "/"))
	self:setNewFlag()
	self.rewards = self.data.awardShow or shiftingstarsRead.getActRewardByIDClasstypeEX(self.data.activityID, self.data.classtype)
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(#self.rewards)
		self.fields.n2:setVisible(true)
	else
		self.fields.List_reward:setNumItems(0)
		self.fields.n2:setVisible(false)
	end
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Com_eventSingle:setNewFlag()
	if self:getNewInfo(self.activityID) then
		self.fields.Label_new:setVisible(true)
	else
		self.fields.Label_new:setVisible(false)
	end
end
function Com_eventSingle:getNewInfo()
	if clientEventMgr.judgeIsOpen(self.activityID) and clientEventMgr.getNewInfo(self.activityID).isNew then
		return true
	end
	return false
end
function Com_eventSingle:onClickEvent()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("IceShimmerDetail", nil)
end
return Com_eventSingle

local activityTimeRead = include("activityTimeRead")
local anniversaryRead = include("anniversaryRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_event = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://EighthAnniversary/Com_event", Com_event)
function Com_event:onInit()
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.fields.n25:fix(false)
	self.fields.Text_end:setString(i18n("Community_text_0011"))
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Label_new:setPositionX(self.fields.Label_banner:getPositionX() - 28)
	else
		self.fields.Label_new:setPositionX(self.fields.Label_banner:getPositionX() - 27)
	end
	self.fields.Label_new:setString("new")
	self.fields.touch:addClickListener(handler(self, self.onClickEvent))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_event:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.setNewByActID))
end
function Com_event:setNewByActID(target, data)
	if data == nil or data.eid == nil then
		return
	end
	if self.activityID == data.eid then
		self:setNewFlag()
	end
end
function Com_event:initData(index, data)
	self.data = data
	self.activityID = data.activityID
	self.fields.Text_name:setString(i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype)))
	self.fields.Label_banner:setIcon(anniversaryRead.getActBgByID(data.activityID))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(data.endTime), "-", "/"))
	self:setNewFlag()
	self.rewards = data.awardShow or anniversaryRead.getActRewardByIDClasstype(data.activityID, data.classtype)
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
	else
		self.fields.n2:setVisible(false)
	end
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Com_event:getEventActID()
	return self.activityID
end
function Com_event:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
function Com_event:setNewFlag()
	if self:getNewInfo(self.activityID) then
		self.fields.Label_new:setVisible(true)
	else
		self.fields.Label_new:setVisible(false)
	end
end
function Com_event:getNewInfo()
	if clientEventMgr.judgeIsOpen(self.activityID) and clientEventMgr.getNewInfo(self.activityID).isNew then
		return true
	end
	return false
end
function Com_event:onClickEvent()
	SoraDPlaySound()
	uiManager:show("EightAnniversaryDetail", self.data):setOwnerKey(self)
end
return Com_event

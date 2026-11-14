local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventTargetView = class("eventTargetView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventTargetView")
	end
	return target
end)
function eventTargetView:ctor()
	self.activityID = nil
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventTargetSingle")
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
end
function eventTargetView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventTargetView:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventTargetView:setActivityID(activityID)
	self.activityID = activityID
end
function eventTargetView:setTitle(title)
	self.ccs_title:setTitle(title)
end
function eventTargetView:setEventBg(img)
	self.Image_event:loadTexture(img, ccui.TextureResType.plistType)
end
function eventTargetView:setTime(lang, time)
	self.Text_time:setTimeLast(function(ticket)
		return i18n(lang) .. ticket
	end)
	self.Text_time:beginTime(time)
	self.Node_time:setVisible(true)
	SoraDToCenter(self.Node_time)
end
function eventTargetView:initData(data)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 170), data, 1, nil)
end
return eventTargetView

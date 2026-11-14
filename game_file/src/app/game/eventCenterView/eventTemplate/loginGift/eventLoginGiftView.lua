local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local loginGiftCtrl = gametop.playertop_:getModule("loginGiftCtrl")
local eventLoginGiftView = class("eventLoginGiftView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventLoginGiftView")
	end
	return target
end)
function eventLoginGiftView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.ccs_title:setTitle(i18n("login_name_01"))
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	if SoraDFIsRA() then
		self.Image_event:loadTexture("bg_activity_show_9001130_ar.png", ccui.TextureResType.plistType)
	else
		self.Image_event:loadTexture("bg_activity_show_9001130_en.png", ccui.TextureResType.plistType)
	end
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventLoginGiftSingle")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self:setTime()
	self:initData()
end
function eventLoginGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LOGINGIFT_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventLoginGiftView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOGIN_GIFT) then
		self:removeFromParent()
	end
end
function eventLoginGiftView:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LOGIN_GIFT)
	if eventTime then
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_421", nil)
		end)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time)
	end
end
function eventLoginGiftView:initData(target, data)
	SoraDCloseLoading(self)
	self.taskList, _ENV, self.loginDays = loginGiftCtrl:getLoginDays(), loginGiftCtrl:getLoginDays(), loginGiftCtrl:getLoginDays()
	local giftList = activityShowCtrl:getParamByID(gActivityTimeActivityID.LOGIN_GIFT)
	local index = 1
	for k, v in pairs(giftList) do
		_ENV = nil
		;(nil).taskIndex = tonumber(k)
		;(nil).loginDays = self.loginDays
		;(nil).aimDays = v.loginDays
		self.taskList[index], (nil).reward = nil, v.rewardItems
		index = index + 1
	end
	self:sortData()
	_ENV = self.taskList
	self.taskList.scroll = self.scroll
	self.taskList.view = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, self.taskList)
end
function eventLoginGiftView:sortData()
	local getStatus = function(isR, data)
		local status = gBtnTargetStatusDef.GO
		if isR then
			status = gBtnTargetStatusDef.GOT
		elseif data.loginDays >= data.aimDays then
			status = gBtnTargetStatusDef.GET
		end
		return status
	end
	table.sort(self.taskList, function(a, b)
		local aIsR = loginGiftCtrl:isReceived(a.taskIndex)
		local bIsR = loginGiftCtrl:isReceived(b.taskIndex)
		a.status = getStatus(aIsR, a)
		b.status = getStatus(bIsR, b)
		if a.status == b.status then
			return a.aimDays < b.aimDays
		else
			return a.status < b.status
		end
	end)
end
return eventLoginGiftView

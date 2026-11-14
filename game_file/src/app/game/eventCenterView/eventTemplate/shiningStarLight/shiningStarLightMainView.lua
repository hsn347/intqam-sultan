local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local shiningStarLightMainView = class("shiningStarLightMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("radianceWarIntegralView")
end)
_ENV = "shiningStarLightMainView"
;("shiningStarLightMainView").TASK_VIEW = 2
local ("shiningStarLightMainView").START_LIGHT, VIEW_TYPE = 1, "shiningStarLightMainView"
function shiningStarLightMainView:ctor(properties)
	self.activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("Glorious_text_01"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeCommonFramTitle:setLocalZOrder(99)
	_ENV, _ENV, self.nodeCommonTabBtn = self, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.title = i18n("Glorious_text_03")
	self.handle = handler(self, self.btnTabClick)
	self.tag = VIEW_TYPE.START_LIGHT
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[1], self.fontSize = self, self, 20
	self.title = i18n("common_text_675")
	self.handle = handler(self, self.btnTabClick)
	self.tag = VIEW_TYPE.TASK_VIEW
	_ENV, self.tableData, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[2], self.fontSize = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), self, 20
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 2
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = 1
	local SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, param = self.tableData, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(param)
	shiningStarLightCtrl:reqGloriousStarLampInit()
	self:updataRedPoint()
end
function shiningStarLightMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataRedPoint))
	SoraDAddMessage(self, "MESSAGE_SHINING_STAR_LIGHT", handler(self, self.activityMsgCallBack))
end
function shiningStarLightMainView:initData(target, data)
end
function shiningStarLightMainView:createPanel(showViewType)
	local panel
	if showViewType == VIEW_TYPE.START_LIGHT then
		panel = SoraDCreatePanelByFixName("shiningStarLightNode")
	elseif showViewType == VIEW_TYPE.TASK_VIEW then
		panel = SoraDCreatePanelByFixName("shiningStarLightTaskNode")
	end
	panel:setPosition(cc.p(0, 0))
	panel:addTo(self.nodeCommonTabBtn:getParent(), 1)
	self.nodeCommonTabBtn:setLocalZOrder(99)
	return panel
end
function shiningStarLightMainView:updataRedPoint()
	local ret, num = shiningStarLightCtrl:getTaskReceiveStatusAndNum(self.activityID)
	SoraDPrint(shiningStarLightCtrl:getLightStatusAndNum())
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.TASK_VIEW, ret)
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.START_LIGHT, shiningStarLightCtrl:getLightStatusAndNum())
end
function shiningStarLightMainView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("Glorious_text_02"))
	end
end
function shiningStarLightMainView:btnTabClick(tag, name)
	for i, v in ipairs(self.tableData) do
		local show = i == tonumber(tag)
		if show then
			if not v.panel then
				v.panel = self:createPanel(tag)
			end
			if v.panel then
				v.panel:initData(self)
				v.panel:setVisible(true)
			end
		elseif v.panel then
			v.panel:setVisible(false)
		end
	end
end
function shiningStarLightMainView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function shiningStarLightMainView:activityMsgCallBack(target, data)
	if data.subMsg == "Jump_Task" then
		self.nodeCommonTabBtn:clickByTag(VIEW_TYPE.TASK_VIEW)
	elseif data.subMsg == "Star_Reward" then
		local panel = SoraDCreatePanel("shiningStarLightGainReward")
		panel:initData(data)
		panel:panelScaleAct()
		panel:show()
	end
end
return shiningStarLightMainView

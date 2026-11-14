local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local endlessTrialsView = class("endlessTrialsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("endlessTrialsView")
	end
	return target
end)
function endlessTrialsView:ctor()
	self.isHideCurrentSceneView = true
	_ENV, _ENV, self.nodeTable, _ENV, self.activityID = nil, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
	;(nil).title = i18n("Endless_trial_text_02")
	;(nil).handle = handler(self, self.btn_onClick_btns)
	_ENV, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY[1], (nil).ccsName = nil, nil, "endlessTrialsChallenge"
	;(nil).title = i18n("Endless_trial_text_03")
	;(nil).handle = handler(self, self.btn_onClick_btns)
	_ENV, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY[2], (nil).ccsName = nil, nil, "endlessTrialsRank"
	;(nil).title = i18n("Endless_trial_text_04")
	;(nil).handle = handler(self, self.btn_onClick_btns)
	self.btnConfig, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY[3], (nil).ccsName = gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY, nil, "endlessTrialsRank"
	self:initWidget()
	self:initData()
end
function endlessTrialsView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(self.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALSVIEW_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function endlessTrialsView:initWidget(...)
	local root = self._ccsView
	_UPVALUE1_ = nil
	;(nil)[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Bottom_Size_panel"
	self.panel = SoraDGetChildByFullPath(root, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, nil)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_bg")
	ccs_title:setTitle(i18n("activity_name_9001197"))
	_UPVALUE1_ = i18n("activity_name_9001197")
	i18n("activity_name_9001197")[1] = "Button_help"
	local Button_help = SoraDGetChildByFullPath(ccs_title, i18n("activity_name_9001197"))
	Button_help:addTouchEventListener(handler(self, self.btn_onClick_help))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	self.ccs_tab:setChoosePng("btn_wjtz_fengyeanniu01.png")
	self.ccs_tab:setUnChoosePng("btn_wjtz_fengyeanniu02.png")
	_ENV = "btn_wjtz_fengyeanniu02.png"
	;("btn_wjtz_fengyeanniu02.png").tabNum = 3
	;("btn_wjtz_fengyeanniu02.png").defaultClick = 1
	;("btn_wjtz_fengyeanniu02.png").tabsetArray = self.btnConfig
	;("btn_wjtz_fengyeanniu02.png").textSize = cc.size(160, 40)
	self.ccs_tab:initView("btn_wjtz_fengyeanniu02.png")
end
function endlessTrialsView:updateRedPoint(target, data)
	if data and data.eventID == self.activityID then
		self:initData()
	end
end
function endlessTrialsView:initData(...)
	self.ccs_tab:setBigRedPointCount(1, endlessTrialsCtrl:getRewardCount())
end
function endlessTrialsView:btn_onClick_help(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Endless_trial_text_05"
		;("Endless_trial_text_05").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Endless_trial_text_05"), "Endless_trial_text_05")
	end
end
function endlessTrialsView:btn_onClick_btns(tag, name)
	for k, v in pairs(self.nodeTable) do
		v:setVisible(false)
	end
	local node = self.nodeTable[tag]
	if not node then
		node = SoraDCreatePanel(self.btnConfig[tag].ccsName)
		node:addTo(self.panel)
		self.nodeTable[tag] = node
		node:setPositionY(node:getPositionY() - display.iPhoneXBottom)
	end
	node:setVisible(true)
	node:initData(tag)
end
return endlessTrialsView

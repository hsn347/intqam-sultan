local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
local eventQuestRead = include("eventQuestRead")
local windTowerUtil = include("windTowerUtil")
local windTowerHistoryView = class("windTowerHistoryView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("windTowerHistoryView")
	end
	return target
end)
local notBeginTaskColor = cc.c3b(255, 255, 0)
local doingTaskColor = cc.c3b(0, 190, 30)
local finishTaskColor = cc.c3b(229, 167, 65)
local minHeight = 540
local maxHeight = 810
if display.height < 900 then
	minHeight = 360
	maxHeight = 630
end
local gWindTowerStatus = _G.gWindTowerStatus
function windTowerHistoryView:ctor(properties)
	self.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("lost_ruins_text_23"))
	self.scrollRecord = SoraDGetChildByName(self, "ScrollView_list")
	self.scrollRecord = include("commonAutoScrollList").new(self.scrollRecord)
	self.scrollRecord:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollRecord:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.textNoRecord = SoraDGetChildByName(self, "Text_NoRecord")
	self.textNoRecord:setString(i18n("windActive_text_07"))
	self.nodeTaskSingle = SoraDGetChildByName(self, "Node_TaskSingle")
	self:initData()
end
function windTowerHistoryView:initData(target, data)
	if not windTowerCtrl:getRecordList() then
		local windTowerCtrl, records = windTowerCtrl:getRecordList(), windTowerCtrl:getRecordList()
	end
	local nums = #records
	self.textNoRecord:setVisible(nums == 0)
	local newHeight = math.min(maxHeight, math.max(nums * 180, minHeight))
	self.scrollRecord:setContentSize(cc.size(520, newHeight))
	self.nodeCommonPopBox:setSize(cc.size(574.0, newHeight + 68))
	self.nodeCommonPopBox:setPositionY(-newHeight / 2 - 34)
	self.scrollRecord:setPositionY(newHeight / 2 - 16)
	windTowerCtrl = cc.size(574.0, newHeight + 68)
	cc.size(574.0, newHeight + 68).scroll = self.scrollRecord
	cc.size(574.0, newHeight + 68).view = self
	self.scrollRecord:updateScrollView(cc.size(520, 180), records, 1, cc.size(574.0, newHeight + 68))
end
function windTowerHistoryView:createScrollSingle()
	local single = self.nodeTaskSingle:clone()
	local textStatus = SoraDGetChildByName(single, "Text_status_time")
	SoraDCreateTimerLabel(single, textStatus)
	return single
end
function windTowerHistoryView:refreshScrollSingle(parent, data)
	local btnGo = SoraDGetChildByName(parent, "Button_go")
	btnGo:setTitleText(i18n("common_text_1720"))
	local point
	if data.x then
		_ENV = data.x
		data.x.x = data.x - 1
		point, data.x.y = data.x, data.y - 1
	else
		local idArray = SoraDStringsSplit(data.key, "_")
		_ENV = data.key
		data.key.x = idArray[1] - 1
		point, data.key.y = data.key, idArray[2] - 1
	end
	btnGo:addTouchEventListener(_G.handlerEx(self, self.btnGoClick, point))
	btnGo:setVisible(data.status == gWindTowerStatus.NOT_RECIEVE or data.status == gWindTowerStatus.RECIEVED)
	local textStatus = SoraDGetChildByName(parent, "Text_Status")
	local color = finishTaskColor
	local taskDes = i18n(eventQuestRead.getDes(data.questId))
	if data.status == gWindTowerStatus.NOT_RECIEVE then
		color = notBeginTaskColor
	elseif data.status == gWindTowerStatus.RECIEVED then
		color = doingTaskColor
		local progress = windTowerCtrl:getQuestProgress(data.questId)
		local aim = eventQuestRead.getAim(data.questId)
		_ENV = eventQuestRead.getDes(data.questId)
		eventQuestRead.getDes(data.questId).member = progress
		_ENV, _ENV, eventQuestRead.getDes(data.questId).total = eventQuestRead.getDes(data.questId)
		eventQuestRead.getDes(data.questId).member, eventQuestRead.getDes(data.questId).color = eventQuestRead.getDes(data.questId)
		local task_progress = _G.i18n_html("common_text_155", eventQuestRead.getDes(data.questId))
		taskDes = string.format("%s(%s)", taskDes, task_progress)
	end
	textStatus:setColor(color)
	textStatus:setString(windTowerUtil.getStateStr(data.status))
	SoraDGetChildByName(parent, "Text_Time"):setString(_G.SoraDConverTimeStr(data.createtime))
	SoraDGetChildByName(parent, "Text_Title"):setString(i18n("windActive_text_06"))
	local textPos = SoraDGetChildByName(parent, "Text_Pos")
	textPos = _G.SoraDChangeTextToHtml(textPos)
	_ENV = i18n("windActive_text_06")
	_ENV, _ENV, i18n("windActive_text_06").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", point.x, point.y), string.format("X:%d Y:%d", point.x, point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", point.x, point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	textPos:setString(_G.i18n_html("common_text_034", i18n("windActive_text_06")))
	textPos:setTouchEnabled(true)
	textPos:setSwallowTouches(false)
	textPos:addTouchEventListener(_G.handlerEx(self, self.btnClickText, point))
	local nodePos = SoraDGetChildByName(parent, "Node_pos")
	SoraDToCenter(nodePos, 1, SoraDFIsRA())
	local textDes = SoraDGetChildByName(parent, "Text_Des")
	textDes = _G.SoraDChangeTextToHtml(textDes)
	textDes:setString(taskDes)
	local textStatusTime = SoraDGetChildByName(parent, "Text_status_time")
	if data.status == gWindTowerStatus.RECIEVED then
		if not data.finish then
			textStatusTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_607", nil)
			end)
			local leftTime = math.max(0, data.endtime - serviceFunctions.systemTime())
			textStatusTime:beginTime(leftTime)
			textStatusTime:setVisible(true)
		else
			textStatusTime:endTime()
			textStatusTime:setVisible(false)
		end
	else
		local windTowerRead = include("windTowerRead")
		local totalTime = windTowerRead.getTaskTimeByQuestId(data.questId)
		textStatusTime:endTime()
		textStatusTime:setVisible(true)
		_ENV = SoraDFIsRA()
		SoraDFIsRA().time = SoraDConvertSecondToString(totalTime)
		textStatusTime:setString(i18n("lost_ruins_text_15", SoraDFIsRA()))
	end
	local nodeTime = SoraDGetChildByName(parent, "Node_Status_Info")
	gWindTowerStatus = i18n("lost_ruins_text_15", SoraDFIsRA())
	i18n("lost_ruins_text_15", SoraDFIsRA())[1] = 10
	SoraDAlignNodeArray(nodeTime:getChildren(), not SoraDFIsRA(), i18n("lost_ruins_text_15", SoraDFIsRA()))
end
function windTowerHistoryView:btnGoClick(point, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(point, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function windTowerHistoryView:btnClickText(pos, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local metaInfo = button:getTouchMetaInfo(button:getTouchEndPosition())
		if metaInfo and metaInfo.name == "posXY" then
			SoraDGotoWorldMapPoint(pos, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function windTowerHistoryView:onEnterOther()
	if windTowerCtrl:hasNewSurvey() then
		windTowerCtrl:reqWindTowerClearNewNum()
	end
end
return windTowerHistoryView

local eventQuestRead = include("eventQuestRead")
local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
local lostRuinsRecordView = class("lostRuinsRecordView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lostRuinsRecordView")
end)
local notBeginTaskColor = cc.c3b(255, 165, 85)
local doingTaskColor = cc.c3b(64, 232, 36)
local finishTaskColor = cc.c3b(255, 1, 1)
_UPVALUE7_ = 255
;(255)[1] = "lost_ruins_text_06"
;(255)[2] = "lost_ruins_text_08"
;(255)[3] = "lost_ruins_text_07"
;(255)[4] = "lost_ruins_text_10"
;(255)[5] = "common_text_1892"
;(255)[6] = "lost_ruins_text_09"
local (255)[7], taskStateStr = "togetherTeam_text_68", 255
local minHeight = 420
local maxHeight = 630
function lostRuinsRecordView:ctor(properties)
	self.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("lost_ruins_text_23"))
	self.scrollRecord = SoraDGetChildByName(self.node, "ScrollView_Record")
	self.scrollRecord = include("commonAutoScrollList").new(self.scrollRecord)
	self.scrollRecord:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollRecord:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.textNoRecord = SoraDGetChildByName(self, "Text_NoRecord")
	self.textNoRecord:setString(i18n("lost_ruins_text_37"))
	self.nodeTaskSingle = SoraDGetChildByName(self, "Node_TaskSingle")
	self:initData()
end
function lostRuinsRecordView:initData(target, data)
	local records = lostRuinsCtrl:getRecordList()
	local nums = table.nums(records)
	self.textNoRecord:setVisible(nums == 0)
	local newHeight = math.min(maxHeight, math.max(nums * 140, minHeight))
	self.scrollRecord:setContentSize(cc.size(550, newHeight))
	self.nodeCommonPopBox:setSize(cc.size(574.0, newHeight + 68))
	self.nodeCommonPopBox:setPositionY(-newHeight / 2 - 34)
	lostRuinsCtrl = cc.size(574.0, newHeight + 68)
	cc.size(574.0, newHeight + 68).scroll = self.scrollRecord
	cc.size(574.0, newHeight + 68).view = self
	self.scrollRecord:updateScrollView(cc.size(550, 140), records, 1, cc.size(574.0, newHeight + 68))
end
function lostRuinsRecordView:createScrollSingle()
	return self.nodeTaskSingle:clone()
end
function lostRuinsRecordView:refreshScrollSingle(parent, data)
	local btnGo = SoraDGetChildByName(parent, "Button_go")
	btnGo:setTitleText(i18n("common_text_477"))
	_ENV = btnGo.setTitleText
	btnGo.setTitleText.x = data.x - 1
	local btnGo.setTitleText.y, point = data.y - 1, btnGo.setTitleText
	btnGo:addTouchEventListener(handlerEx(self, self.btnGoClick, point))
	local textStatus = SoraDGetChildByName(parent, "Text_Status")
	local color = finishTaskColor
	btnGo:setVisible(data.state == gLosRuinsStatus.NOT_RECIEVE or data.state == gLosRuinsStatus.RECIEVED)
	if data.state == gLosRuinsStatus.NOT_RECIEVE then
		color = notBeginTaskColor
	elseif data.state == gLosRuinsStatus.RECIEVED then
		color = doingTaskColor
	end
	textStatus:setColor(color)
	textStatus:setString(i18n(taskStateStr[data.state]))
	SoraDGetChildByName(parent, "Text_Time"):setString(SoraDConverTimeStr(data.time))
	SoraDGetChildByName(parent, "Text_Title"):setString(i18n("activity_name_9001301"))
	local textPos = SoraDGetChildByName(parent, "Text_Pos")
	textPos = SoraDChangeTextToHtml(textPos)
	_ENV = i18n("activity_name_9001301")
	_ENV, _ENV, i18n("activity_name_9001301").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", point.x, point.y), string.format("X:%d Y:%d", point.x, point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", point.x, point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	textPos:setString(i18n_html("common_text_034", i18n("activity_name_9001301")))
	textPos:setTouchEnabled(true)
	textPos:setSwallowTouches(false)
	textPos:addTouchEventListener(handlerEx(self, self.btnClickText, point))
	SoraDGetChildByName(parent, "Text_Des"):setString(i18n(eventQuestRead.getDes(data.questId)))
end
function lostRuinsRecordView:btnGoClick(point, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDGotoWorldMapPoint(point, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function lostRuinsRecordView:btnClickText(pos, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local metaInfo = button:getTouchMetaInfo(button:getTouchEndPosition())
		if metaInfo and metaInfo.name == "posXY" then
			SoraDGotoWorldMapPoint(pos, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function lostRuinsRecordView:onEnterOther()
	local haveNew, _ = lostRuinsCtrl:getReceiveStatusAndNum()
	if haveNew then
		lostRuinsCtrl:reqLostRuinsClearNewNum()
	end
end
return lostRuinsRecordView

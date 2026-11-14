local baseComponent = require("fgui.base.baseComponent")
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local Com_InvestigationRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_InvestigationRecord", Com_InvestigationRecord)
local eventQuestRead = include("eventQuestRead")
local notBeginTaskColor = cc.c3b(166, 175, 183)
local doingTaskColor = cc.c3b(243, 182, 20)
local finishTaskColor = cc.c3b(255, 1, 1)
local completeTaskColor = cc.c3b(64, 232, 36)
_UPVALUE7_ = 64
;(64)[1] = "lost_ruins_text_06"
;(64)[2] = "lost_ruins_text_08"
;(64)[3] = "lost_ruins_text_07"
;(64)[4] = "lost_ruins_text_10"
;(64)[5] = "common_text_1892"
;(64)[6] = "lost_ruins_text_09"
local (64)[7], taskStateStr = "togetherTeam_text_68", 64
local minHeight = 420
local maxHeight = 630
function Com_InvestigationRecord:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	local btnGo = self.fields.btnGo
	btnGo:addClickEventListener(handler(self, self.btnGoClick))
	local textPos = self.fields.Text_Pos
	textPos:addClickListener(handler(self, self.btnClickText))
end
function Com_InvestigationRecord:onShow()
end
function Com_InvestigationRecord:initData(data)
	local btnGo = self.fields.btnGo
	btnGo:setTitle(i18n("common_text_477"))
	_ENV = btnGo.setTitle
	btnGo.setTitle.x = data.x - 1
	local btnGo.setTitle.y, point = data.y - 1, btnGo.setTitle
	self.point = point
	local textStatus = self.fields.Text_Status
	local color = finishTaskColor
	btnGo:setVisible(data.state == gLosRuinsStatus.NOT_RECIEVE or data.state == gLosRuinsStatus.RECIEVED)
	if data.state == gLosRuinsStatus.NOT_RECIEVE then
		color = notBeginTaskColor
	elseif data.state == gLosRuinsStatus.RECIEVED then
		color = doingTaskColor
	elseif data.state == gLosRuinsStatus.COMPLETE or data.state == gLosRuinsStatus.RECIEVED_REWARD then
		color = completeTaskColor
	end
	textStatus:setColor(color)
	textStatus:setString(i18n(taskStateStr[data.state]))
	self.state = data.state
	self.questInfo = data
	self.fields.Text_Time:setString(SoraDConverTimeStr(data.time))
	self.fields.Text_Title:setString(i18n("npc_name_042"))
	local textPos = self.fields.Text_Pos
	_ENV = i18n("npc_name_042")
	_ENV, _ENV, i18n("npc_name_042").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", point.x, point.y), string.format("X:%d Y:%d", point.x, point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", point.x, point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	textPos:setString(i18n_html("common_text_034", i18n("npc_name_042")))
	textPos:setTouchEnabled(true)
	textPos:setSwallowTouches(false)
	self.fields.Text_Des:setString(i18n(eventQuestRead.getDes(data.questId)))
end
function Com_InvestigationRecord:btnGoClick(sender)
	SoraDPlaySound()
	if self.state == gLosRuinsStatus.RECIEVED then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
		local tbParam = mildGuideManager:splitGuideParam(guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(eventQuestRead.getDes(self.questInfo.questId)))
			return
		end
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	else
		SoraDGotoWorldMapPoint(self.point, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function Com_InvestigationRecord:btnClickText(sender)
	SoraDPlaySound()
	dump(self.point, "self.point2")
	SoraDGotoWorldMapPoint(self.point, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_InvestigationRecord

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
local baseComponent = require("fgui.base.baseComponent")
local Com_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://IceDragonLost/Com_recordSingle", Com_recordSingle)
function Com_recordSingle:onInit()
	self.fields.btnGo:setString(i18n("common_text_477"))
	self.fields.btnGo:addClickListener(handler(self, self.btnGoClick))
	self.fields.Text_Pos:setTouchEnabled(true)
	self.fields.Text_Pos:setSwallowTouches(false)
	self.fields.Text_Pos:addClickListener(handler(self, self.btnClickText))
	self:fixChildrenPos()
end
function Com_recordSingle:onShow()
end
function Com_recordSingle:initData(data)
	self.state = data.state
	finishTaskColor, self.questInfo = data.state, data
	data.state.x = data.x - 1
	self.point, data.state.y = data.state, data.y - 1
	local color = finishTaskColor
	self.fields.btnGo:setVisible(data.state == gLosRuinsStatus.NOT_RECIEVE or data.state == gLosRuinsStatus.RECIEVED)
	if data.state == gLosRuinsStatus.NOT_RECIEVE then
		color = notBeginTaskColor
	elseif data.state == gLosRuinsStatus.RECIEVED then
		color = doingTaskColor
	elseif data.state == gLosRuinsStatus.COMPLETE or data.state == gLosRuinsStatus.RECIEVED_REWARD then
		color = completeTaskColor
	end
	self.fields.Text_Status:setColor(color)
	self.fields.Text_Status:setString(i18n(taskStateStr[data.state]))
	self.fields.Text_Time:setString(SoraDConverTimeStr(data.time))
	self.fields.Text_Title:setString(i18n("icedragon_lost_22"))
	finishTaskColor = i18n("icedragon_lost_22")
	finishTaskColor, finishTaskColor, i18n("icedragon_lost_22").commonStr = "X:%d Y:%d", string.format("X:%d Y:%d", self.point.x, self.point.y), string.format("X:%d Y:%d", self.point.x, self.point.y)
	;("X:%d Y:%d").u = "true"
	;("X:%d Y:%d").c = "true"
	string.format("X:%d Y:%d", self.point.x, self.point.y).commonStr, ("X:%d Y:%d").name = "X:%d Y:%d", "posXY"
	self.fields.Text_Pos:setString(i18n_html("common_text_034", i18n("icedragon_lost_22")))
	self.fields.Text_Des:setString(i18n(eventQuestRead.getDes(data.questId)))
end
function Com_recordSingle:btnGoClick()
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
function Com_recordSingle:btnClickText()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(self.point, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_recordSingle

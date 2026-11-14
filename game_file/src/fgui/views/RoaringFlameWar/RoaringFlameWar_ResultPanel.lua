local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_ResultPanel = class("RoaringFlameWar_ResultPanel", baseFguiPanel)
function RoaringFlameWar_ResultPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_ResultPanel.super.ctor(self, ...)
	print("RoaringFlameWar_ResultPanel:ctor", self.viewName)
end
function RoaringFlameWar_ResultPanel:onInit()
	print("=======RoaringFlameWar_ResultPanel:onInit")
	self.fields.Text_title:setString(i18n("flames_dunes_text234"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_tip:setString(i18n("common_text_3701"))
	self.fields.Text_noData:setString(i18n("flames_dunes_text328"))
end
function RoaringFlameWar_ResultPanel:endShow()
	print("=======RoaringFlameWar_ResultPanel:endShow")
	self.selfCamp = roaringFlameWarCtrl:getSelfCamp()
	if not self.param or not self.param.resultData then
		local _ENV, data = self.param.resultData, self.param.resultData
	end
	if not data.occupyLogList then
		_ENV = data.occupyLogList
	end
	self.logList = data.occupyLogList
	local logCount = #self.logList
	self.fields.List:setNumItems(logCount)
	self.fields.List:setVisible(0 < logCount)
	self.fields.Text_noData:setVisible(logCount <= 0)
	if not data.warTimes then
		local _ENV, warTimes = data.warTimes, data.warTimes
	end
	if next(warTimes) then
		local time1 = os.date("!%m/%d %H:%M", warTimes[1])
		local time2 = os.date("!%m/%d %H:%M", warTimes[2])
		self.fields.Text_time:setString(time1 .. " - " .. time2)
	end
end
function RoaringFlameWar_ResultPanel:initCheatData(...)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).bId = 1
	;(nil).cId = 1
	;(nil).oId = 2
	;(nil).t = 1729308797
	_ENV, (nil)[1], (nil).type = nil, nil, 1
	;(nil).bId = 2
	;(nil).cId = 2
	;(nil).oId = 1
	;(nil).t = 1729308797
	_ENV, (nil).occupyLogList, (nil)[2], (nil).type = nil, nil, nil, 1
	;(nil)[1] = serviceFunctions.systemTime()
	;(nil).warTimes, (nil)[2] = nil, serviceFunctions.systemTime() + 3600
	_ENV, (nil).campScore = nil, 10
	;(nil).attackCount = 100
	;(nil).avatar = ""
	;(nil).fromKid = 1
	;(nil).iconID = 1405
	;(nil).killScore = 1000
	;(nil).name = "mly"
	_ENV, (nil).maxPlayerInfo, (nil).uid = nil, nil, 1
	;(nil).attackCount = 100
	;(nil).attackCountWin = 0
	;(nil).avatar = ""
	;(nil).fromKid = 1
	;(nil).iconID = 1405
	;(nil).killScore = 1000
	;(nil).name = "mly"
	_ENV, (nil).selfPlayerInfo, (nil).uid = nil, nil, 1
	local resultData
	self.param, (nil).resultData = nil, resultData
end
function RoaringFlameWar_ResultPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_fields.Text_pos:addClickListener(handler(self, self.onClickBtnPos))
	end
	local data = self.logList[index + 1]
	local objId = data.bId
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local buildLv = roaringFlameWarRead.getBuildLevel(objId)
	local buildName = roaringFlameWarRead.getBuildName(subType)
	_ENV = handler(self, self.onClickBtnPos)
	handler(self, self.onClickBtnPos).lv = buildLv
	handler(self, self.onClickBtnPos).name = buildName
	local titleStr = i18n("common_text_134", handler(self, self.onClickBtnPos))
	_fields.Text_title:setString(titleStr)
	_fields.Text_time:setString(os.date("!%m/%d %H:%M", data.t))
	local buildImage = roaringFlameWarRead.getBuildBattleIcon(objId)
	_fields.Load_build:setURL(buildImage)
	local pos = roaringFlameWarRead.getBuildCoord(objId)
	_ENV = os.date("!%m/%d %H:%M", data.t)
	os.date("!%m/%d %H:%M", data.t).x = pos.x
	os.date("!%m/%d %H:%M", data.t).y = pos.y
	local posStr = i18n("common_text_2155", os.date("!%m/%d %H:%M", data.t))
	_fields.Text_pos:setString(posStr)
	_fields.Text_pos.pos = pos
	if self.selfCamp == data.cId then
		_fields.Load_bg:setURL("frame_9001674_settlement_teblue.png")
		self:initCampInfo(_fields.Com_camp1, data.cId, true)
		self:initCampInfo(_fields.Com_camp2, data.oId)
	else
		_fields.Load_bg:setURL("frame_9001674_settlement_tered.png")
		self:initCampInfo(_fields.Com_camp1, data.oId)
		self:initCampInfo(_fields.Com_camp2, data.cId, true)
	end
end
function RoaringFlameWar_ResultPanel:initCampInfo(obj, camp, isWin)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if SoraDFIsRA() then
			_fields.Load_win:setURL("title_yjyh_win.png")
		else
			_fields.Load_win:setURL("title_yjyh_win_en.png")
		end
		local c2 = obj:getController("c2")
		if c2:getSelectedIndex() == 1 then
			_fields.Load_win.align = cc.TEXT_ALIGNMENT_RIGHT
		else
			_fields.Load_win.align = cc.TEXT_ALIGNMENT_LEFT
		end
	end
	local resultImage = roaringFlameWarRead.getCampResultImage(camp)
	_fields.Load_bg:setURL(resultImage)
	local campName = roaringFlameWarRead.getCampName(camp)
	_fields.Text_camp:setString(campName)
	local c1 = obj:getController("c1")
	c1:setSelectedIndex(isWin and 0 or 1)
end
function RoaringFlameWar_ResultPanel:onClickBtnPos(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	SoraDGotoWorldMapPoint(button.pos, true)
	self:closePanel()
end
function RoaringFlameWar_ResultPanel:close(...)
	local resultData = self.param and self.param.resultData
	self:closePanel()
	_ENV = nil
	;(nil).resultData = resultData
	uiManager:show("RoaringFlameWar_MVP", nil)
end
return RoaringFlameWar_ResultPanel

local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortrecordPanel = class("EscortrecordPanel", baseFguiPanel)
function EscortrecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortrecordPanel:ctor", self.viewName)
end
function EscortrecordPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortrecordPanel:onInit()
	print("=======EscortrecordPanel:onInit")
end
function EscortrecordPanel:onShow()
	print("=======EscortrecordPanel:onShow")
	self.viewType = self.param.viewType
	if self.viewType == 1 then
		self.fields.Panel_bg:setString(i18n("treasureEscort_text12"))
		self:initRecord()
	else
		self.fields.Panel_bg:setString(i18n("treasureEscort_text17"))
		self:initBattleRecord()
	end
	if self.recordData and next(self.recordData) then
		self.fields.List_record:setItemRenderer(handler(self, self.onRecordItemRenderer))
		self.fields.List_record:setNumItems(#self.recordData)
		if self.viewType ~= 1 then
			self.fields.List_record:scrollToView(#self.recordData - 1)
		end
		self.controllers.c_state:setSelectedIndex(1)
	else
		self.fields.Text_noRecord:setString(i18n("treasureEscort_text13"))
		self.controllers.c_state:setSelectedIndex(0)
	end
end
function EscortrecordPanel:initRecord(...)
	if not allianceEscortCtrl:getEscortData().escortRecord then
		local allianceEscortCtrl, escortRecord = allianceEscortCtrl:getEscortData().escortRecord, allianceEscortCtrl:getEscortData().escortRecord
	end
	allianceEscortCtrl = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:allianceEscortRecord:count~integer", #escortRecord, nil)
	self.recordData, allianceEscortCtrl = SoraDConfigSet, SoraDConfigSet
	for i, data in ipairs(escortRecord) do
		local timeStr = string.format("%s", os.date("%m-%d", data.startTime))
		local difficultyName = allianceEscortCtrl:getDifficultyName(data.difficulty)
		allianceEscortCtrl = allianceEscortCtrl
		allianceEscortCtrl.time = timeStr
		allianceEscortCtrl.name = data.nickName
		local allianceEscortCtrl, allianceEscortCtrl, allianceEscortCtrl.num, params = os.date("%m-%d", data.startTime)
		allianceEscortCtrl, data.nickName.name, os.date("%m-%d", data.startTime).color = os.date("%m-%d", data.startTime)
		data.nickName.num, os.date("%m-%d", data.startTime).color = os.date("%m-%d", data.startTime)
		local styles = data.nickName
		local record = ""
		if data.result == 3 then
			record = i18n_html("treasureEscort_text46", params, styles)
		else
			local resultStr, resultColor = self:getResultNameAndColor(data.result)
			allianceEscortCtrl, params.result = data.result, resultStr
			styles.result, data.result.color = data.result, resultColor
			record = i18n_html("treasureEscort_text14", params, styles)
		end
		table.insert(self.recordData, record)
	end
end
function EscortrecordPanel:initBattleRecord(...)
	if not allianceEscortCtrl:getEscortData().escortBattleRecord then
		local allianceEscortCtrl, escortBattleRecord = allianceEscortCtrl:getEscortData().escortBattleRecord, allianceEscortCtrl:getEscortData().escortBattleRecord
	end
	local curStage = 0
	local maxWarPlace = 6
	local state = allianceEscortCtrl:getEscortData().state or gAllianceEscortState.NONE
	if state == gAllianceEscortState.NONE then
		return
	elseif state == gAllianceEscortState.FINISH or state == gAllianceEscortState.PREPARE then
		curStage = maxWarPlace * 2
	else
		local stateStartTime = allianceEscortCtrl:getEscortData().stateStartTime
		local curTime = serviceFunctions.systemTime()
		local lastTime = math.max(0, curTime - stateStartTime)
		local constantRead = include("constantRead")
		local mobileTime = constantRead.getConstValue("TreasureEscort_Mobile_Time")
		local battleTime = constantRead.getConstValue("TreasureEscort_Battle_Time")
		local curWarPlace = math.floor(lastTime / (mobileTime + battleTime))
		local time = (mobileTime + battleTime) * (curWarPlace + 1) - lastTime
		curStage = math.min(maxWarPlace, curWarPlace) * 2
		if battleTime >= time then
			curStage = curStage + 1
		end
	end
	self.recordData, allianceEscortCtrl = allianceEscortCtrl:getEscortData().stateStartTime, stateStartTime
	if #escortBattleRecord == 0 then
		return
	end
	table.insert(self.recordData, i18n("treasureEscort_text18"))
	local allianceEscortCtrl, warPlaceTag = table.insert, table.insert
	local curWarPlace = math.ceil(curStage / 2)
	for i, data in ipairs(escortBattleRecord) do
		local warPlace = data.warPlace
		if curWarPlace < warPlace then
			break
		end
		if not warPlaceTag[warPlace] then
			warPlaceTag[warPlace] = true
			allianceEscortCtrl = i18n("treasureEscort_text18")
			allianceEscortCtrl, allianceEscortCtrl, i18n("treasureEscort_text18").buildname = allianceEscortCtrl, allianceEscortCtrl:getWarPlaceName(warPlace), allianceEscortCtrl:getWarPlaceName(warPlace)
			allianceEscortCtrl:getWarPlaceName(warPlace).buildname, allianceEscortCtrl.color = allianceEscortCtrl, "#70C723"
			local record = i18n_html("treasureEscort_text19", i18n("treasureEscort_text18"))
			table.insert(self.recordData, record)
		end
		if curWarPlace > warPlace or curStage % 2 == 0 then
			local npcName = worldMapDefine.getMonsterName(data.npcId)
			local resultStr, resultColor = self:getResultNameAndColor(data.result)
			allianceEscortCtrl = data.result
			data.result.name1 = npcName
			data.result.name2 = data.nickName
			local allianceEscortCtrl, allianceEscortCtrl, data.result.result, params = warPlace, data.nickName, resultStr, data.result
			allianceEscortCtrl, data.nickName.name1, warPlace.color = warPlace, warPlace, "#FF2E00"
			allianceEscortCtrl, data.nickName.name2, warPlace.color = warPlace, warPlace, "#70C723"
			data.nickName.result, warPlace.color = warPlace, resultColor
			local styles = data.nickName
			local record = i18n_html("treasureEscort_text20", params, styles)
			table.insert(self.recordData, record)
		end
	end
end
function EscortrecordPanel:getResultNameAndColor(result)
	if result == 1 then
		return i18n("treasureEscort_text47"), "#70C723"
	else
		return i18n("common_text_291"), "#FF2E00"
	end
end
function EscortrecordPanel:onRecordItemRenderer(index, obj)
	local selectIndex = index % 2 == 0 and 0 or 1
	obj:getController("c_state"):setSelectedIndex(selectIndex)
	obj:getChild("title"):setString(self.recordData[index + 1])
end
return EscortrecordPanel

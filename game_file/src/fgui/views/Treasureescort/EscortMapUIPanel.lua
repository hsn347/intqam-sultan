local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortMapUIPanel = class("EscortMapUIPanel", baseFguiPanel)
function EscortMapUIPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortMapUIPanel:ctor", self.viewName)
	self.curStage = 0
	self.escortData = allianceEscortCtrl:getEscortData()
	self.curState = self.escortData.state
	local constantRead = include("constantRead")
	self.mobileTime = constantRead.getConstValue("TreasureEscort_Mobile_Time")
	self.battleTime = constantRead.getConstValue("TreasureEscort_Battle_Time")
end
function EscortMapUIPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortMapUIPanel:onInit()
	print("=======EscortMapUIPanel:onInit")
	self.fields.Com_title:initData(i18n("treasureEscort_text15"), handler(self, self.onClickClose))
	self.fields.Button_record:setString(i18n("treasureEscort_text12"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.Progress_des = self.fields.Progress_army:getChild("Text_des")
	self.fields.Progress_army:setVisible(false)
	self.mapFields = fguiHelper.get_fields(self.fields.EscortMap)
	for i = 0, 7 do
		self.mapFields["Com_build" .. i]:setString(allianceEscortCtrl:getWarPlaceName(i))
	end
	self.mapFields.Com_fighting:setVisible(false)
end
function EscortMapUIPanel:onShow()
	print("=======EscortMapUIPanel:onShow")
	self:initStage()
end
function EscortMapUIPanel:onClickBtnRecord()
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = 2
	uiManager:show("Escortrecord", nil)
end
function EscortMapUIPanel:initMap(...)
	if self.posList then
		return
	end
	self.posList, _ENV = self.posList, self.posList
	for i = 0, 7 do
		local widget = self.mapFields["Com_build" .. i]
		local pos = widget:getPosition()
		local size = widget:getSize()
		self.posList[i] = cc.p(pos.x + size.width / 2, pos.y + size.height / 2)
	end
end
function EscortMapUIPanel:showMove(warPlace)
	local beginIdx = warPlace
	local endIdx = beginIdx + 1
	local beginPos = self.posList[beginIdx]
	local endPos = self.posList[endIdx]
	local armyList = self.armyList
	local warMatrix = SoraDCreatePanel("troopsMatrixHeroTrial")
	_ENV, _UPVALUE1_ = nil, 0
	;(nil).armyList = armyList
	;(0)[1] = nil
	_ENV = nil
	;(nil).effectId = self.escortData.effectId
	warMatrix:initData(cc.p(beginPos.x, -beginPos.y), cc.p(endPos.x, -endPos.y), cc.p(0, 0), cc.p(0, 0), gMapObjTypeDef.mapObjTypePlayer, 0, nil, nil, nil)
	warMatrix:setVisible(true)
	warMatrix:setTouchEnabled(false)
	warMatrix:setSoliderVisible(true)
	self.mapFields.Loader3DMatrix:setPosition(cc.p(0, 0))
	self.mapFields.Loader3DMatrix:setContent(warMatrix)
	local endPos2 = cc.p(self.posList[endIdx].x, self.posList[beginIdx].y * 2 - self.posList[endIdx].y)
	local moveLine = include("worldMapMoveLine").new(beginPos, endPos2)
	moveLine:showMoveline(0)
	moveLine:setMoveLineColor(gMapMoveLineColor.moveLineColorGreen)
	self.mapFields.Loader3DLine:setPosition(beginPos)
	self.mapFields.Loader3DLine:setContent(moveLine)
	warMatrix:setMoveLine(moveLine)
	_ENV = moveLine
	_ENV, _ENV, moveLine.currentMoveTime = self.time, self.mobileTime - self.time, self.mobileTime - self.time
	self.time.distancePrecent = 1
	moveLine.moveTimeSpan, (self.mobileTime - self.time)[1], self.time.time = self.mobileTime - self.time, self.time, self.mobileTime
	warMatrix:setMoveTimeData(moveLine)
	warMatrix:beginMove()
end
function EscortMapUIPanel:showBattle(warPlace)
	if not self.stateNode then
		local stateNode = SoraDGetFightingEffect()
		self.mapFields.Com_fighting:getChild("Loader3D"):setContent(stateNode)
		self.stateNode = stateNode
	end
	self.mapFields.Com_fighting:getChild("Label_time"):beginTime(self.time)
	local endPos = self.posList[warPlace]
	self.mapFields.Com_fighting:setPosition(endPos.x, endPos.y - 100)
	self.mapFields.Com_fighting:setVisible(true)
	local isFlipX = false
	local endPos3 = cc.p(endPos.x + 150, endPos.y)
	if endPos3.x > self.view:getWidth() * 0.5 then
		isFlipX = true
		endPos3.x = endPos.x - 150
	end
	local npcId = allianceEscortCtrl:getNpcId(warPlace)
	local imgName = worldMapDefine.getMonsterImageName(npcId)
	local worldMapMonster = display.newSprite(string.format("#%s_dj_ws_01.png", imgName))
	local fightingFrames = display.newFrames(imgName .. "_gj_ws_%02d.png", 1, 8)
	local animation = display.newAnimation(fightingFrames, 0.15)
	worldMapMonster:playAnimationForever(animation)
	worldMapMonster:setFlippedX(isFlipX)
	self.mapFields.Loader3DNpc:setPosition(endPos3)
	self.mapFields.Loader3DNpc:setContent(worldMapMonster)
end
function EscortMapUIPanel:clearLoader3D(...)
	self.mapFields.Loader3DMatrix:clearContent()
	self.mapFields.Loader3DLine:clearContent()
	self.mapFields.Loader3DNpc:clearContent()
	self.mapFields.Com_fighting:setVisible(false)
end
function EscortMapUIPanel:initStage(...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return
	end
	allianceEscortCtrl:reqBattleRecord()
	if self.escortData.state ~= gAllianceEscortState.ESCORT then
		return
	end
	self.fields.Progress_army:setVisible(true)
	_ENV, _ENV = self.fields.Progress_army, self.fields.Progress_army.setVisible
	self.fields.Progress_army.id = 7010009412
	_ENV, self.fields.Progress_army.setVisible[1], self.fields.Progress_army.num = self.fields.Progress_army, self.fields.Progress_army, 1
	self.fields.Progress_army.id = 7010009512
	_ENV, self.fields.Progress_army.setVisible[2], self.fields.Progress_army.num = self.fields.Progress_army, self.fields.Progress_army, 1
	self.fields.Progress_army.id = 7010009413
	self.armyList, self.fields.Progress_army.setVisible[3], self.fields.Progress_army.num = self.fields.Progress_army.setVisible, self.fields.Progress_army, 1
	self:initMap()
	self:refreshStage()
end
function EscortMapUIPanel:refreshStage(...)
	self:clearLoader3D()
	local stateStartTime = self.escortData.stateStartTime
	local curTime = serviceFunctions.systemTime()
	local lastTime = math.max(0, curTime - stateStartTime)
	local curWarPlace = math.floor(lastTime / (self.mobileTime + self.battleTime))
	if curWarPlace > self.escortData.finishWarPlace then
		self.fields.Progress_army:setVisible(false)
		return
	end
	local maxWarPlace = 6
	self.curStage = math.min(maxWarPlace, curWarPlace) * 2
	self.time = (self.mobileTime + self.battleTime) * (curWarPlace + 1) - lastTime
	if self.time > self.battleTime then
		self.time = self.time - self.battleTime
	else
		self.curStage = self.curStage + 1
	end
	if curWarPlace == self.escortData.finishWarPlace and (self.curStage % 2 == 1 or self.escortData.result == 2) then
		self.fields.Progress_army:setVisible(false)
		return
	end
	if self.curStage % 2 == 0 then
		self:showMove(math.floor(self.curStage / 2))
	else
		self:showBattle(math.ceil(self.curStage / 2))
	end
	self:refreshProgressArmy(curWarPlace)
	_UPVALUE1_ = math.ceil(self.curStage / 2)
	math.ceil(self.curStage / 2)[1] = ffa.delay(self.time)
	math.ceil(self.curStage / 2)[2] = ffa.callFunc(function()
		self:refreshStage()
	end)
	math.ceil(self.curStage / 2)[3] = ffa.callFunc(function()
		self:refreshStage()
	end)
	self.view:runAction(ffa.seq(math.ceil(self.curStage / 2)))
end
function EscortMapUIPanel:refreshProgressArmy(curWarPlace)
	local warPlaceSurvivePer = self.escortData.warPlaceSurvivePer
	local value = (warPlaceSurvivePer[tostring(curWarPlace)] or 1) * 100
	self.fields.Progress_army:setValue(value)
	local signUpCount = table.nums(self.escortData.signUpUserList)
	local count = math.round(value / 100 * signUpCount)
	self.Progress_des:setString(i18n("treasureEscort_text16") .. count)
end
function EscortMapUIPanel:refreshView(...)
	self.escortData = allianceEscortCtrl:getEscortData()
	if self.curState == self.escortData.state then
		return
	end
	self.curState = self.escortData.state
	if self.curState == gAllianceEscortState.FINISH then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	if SoraDGetCtrl("allianceMgr"):hasJoinAlliance() and self.curState ~= gAllianceEscortState.ESCORT and self.curState ~= gAllianceEscortState.FINISH then
		return
	end
	self.view:stopAllActions()
	self.fields.Progress_army:setVisible(false)
	self:clearLoader3D()
	self:initStage()
end
return EscortMapUIPanel

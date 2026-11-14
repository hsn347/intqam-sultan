local gametop = gModuleMgr.getObject("gametop")
local activity_9001658_Ctrl = SoraDGetCtrl("activity_9001658_Ctrl")
local activity_9001658_Read = include("activity_9001658_Read")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001658/Com_map", Com_map)
local ZOOM_SCALE_MIN = 0.5
local ZOOM_SCALE_MAX = 1.2
local ZOOM_SCALE_NORMAL = 0.8
function Com_map:onInit()
	self.frameName = "3sgb_%s_%s_%%02d.png"
	self.stageMax = activity_9001658_Read.getStageMax()
	self.scrollPane = self:getScrollPane()
	self.zoomScale = ZOOM_SCALE_NORMAL
	self.scrollPane:setZoomScale(self.zoomScale)
	if G_IS_UNITY then
		self:setZoomEnable(true)
		self:setMinScale(ZOOM_SCALE_MIN)
		self:setMaxScale(ZOOM_SCALE_MAX)
	end
	self.chatTime = 0
	self.fields.Com_chat1:setVisible(false)
	self.fields.Com_chat2:setVisible(false)
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
	self.fields.mv_line:setAllFrameName("G_dh_9001658_line_%02d.png", 1)
	for stage = 1, self.stageMax do
		local Com_stage = self.fields["Com_stage" .. stage]
		if Com_stage then
			Com_stage:addClickListener(handlerEx(self, self.onClickBtnStage, stage))
		end
	end
	for stage = 1, self.stageMax do
		local Com_name = self.fields["Com_name" .. stage]
		if Com_name then
			local signName = activity_9001658_Read.getStageSignName(stage)
			Com_name:setString(signName)
			Com_name:addClickListener(handlerEx(self, self.onClickBtnStage, stage))
		end
	end
	self:createBuild1()
	self:createBuild8()
	self:checkBossHdRes()
	self.fields.mv_npc:setAllFrameName("9001658_npc_dj_%02d.png", 1)
	self.fields.Usm_npc:setPrepareCallback(function(...)
		self.fields.mv_npc:setVisible(false)
		self.fields.Usm_npc:getCriSprite():start()
	end)
	self.fields.Usm_npc:play()
	self.fields.mv_pp1:setAllFrameName("9001658_pp_%02d.png", 1)
	fguiHelper.registMouseEvent(self)
end
function Com_map:onShow()
	self:initMap()
end
function Com_map:initMap(...)
	local curStage = activity_9001658_Ctrl:getCurStage()
	self.curStage = curStage
	local nextStage = curStage + 1
	local pos1 = self:getComStagePos(curStage)
	local pos2 = self:getComStagePos(nextStage)
	local angle, isFlipX = self:getStageImgAngel(pos1, pos2)
	self.fields.mv_zhujue:setFlip(isFlipX and 1 or 0)
	local frameKey = "yd"
	if curStage >= self.stageMax then
		frameKey = "gj"
	end
	local frameName = string.format(self.frameName, frameKey, angle)
	self.fields.mv_zhujue:setAllFrameName(frameName, 1)
	self.fields.mv_zhujue:stopAllActions()
	if curStage >= self.stageMax then
		self.fields.mv_zhujue:setPosition(pos1)
		self.fields.mv_line:setVisible(false)
	else
		local curTime = activity_9001658_Ctrl:getCurTime()
		local curStageTime = activity_9001658_Read.getStageTime(curStage)
		local nextStageTime = activity_9001658_Read.getStageTime(nextStage)
		local scale = (curTime - curStageTime) / (nextStageTime - curStageTime)
		scale = math.max(0, math.min(1, scale))
		local offset = cc.p(pos2.x - pos1.x, pos2.y - pos1.y)
		local curPos = cc.p(pos1.x + offset.x * scale, pos1.y + offset.y * scale)
		self.fields.mv_zhujue:setPosition(curPos)
		local moveTime = nextStageTime - curTime
		self.fields.mv_zhujue:runAction(ffa.moveTo(moveTime, pos2.x, pos2.y))
		self.fields.mv_line:setVisible(true)
		local linePos = cc.p((pos2.x + pos1.x) / 2, (pos2.y + pos1.y) / 2)
		self.fields.mv_line:setPosition(linePos)
		local angle = SoraDGetAngleByPos(pos1, pos2)
		self.fields.mv_line:setRotation(angle)
		local distance = cc.pGetDistance(pos1, pos2)
		local scale = self.fields.mv_line:getScale()
		self.fields.mv_line:setWidth(distance / scale)
	end
	self:updateScrollPane()
end
function Com_map:getComStagePos(stage)
	local Com_stage = self.fields["Com_stage" .. stage]
	if stage > self.stageMax then
		Com_stage = self.fields.Com_stageEnd
	end
	return Com_stage:getPosition()
end
function Com_map:getStageImgAngel(pos1, pos2)
	local __, angle, isFlipX = worldMapFunction.getSoliderImgAngel(cc.p(pos1.x, -pos1.y), cc.p(pos2.x, -pos2.y))
	return angle, isFlipX
end
function Com_map:updateScrollPane(...)
	local pos = self.fields.mv_zhujue:getPosition()
	local size = self.scrollPane:getContentSize()
	local percX = pos.x / size.width
	self.scrollPane:setPercX(percX)
	local percY = pos.y / size.height
	self.scrollPane:setPercY(percY)
end
function Com_map:updateTime(time)
	self.chatTime = self.chatTime + 1
	if self.chatTime >= 15 then
		self.chatTime = 0
		self:showRandomChat()
	end
end
function Com_map:showRandomChat(...)
	local curStage = self.curStage
	local chatType = serviceFunctions.random(1, 2)
	if chatType == 1 then
		local chatIndex = activity_9001658_Read.getRandomHeroChat(curStage)
		local chatWord = activity_9001658_Read.getChatWord(chatIndex)
		self.fields.Com_chat1:setString(chatWord)
		local curPos = self.fields.mv_zhujue:getPosition()
		self.fields.Com_chat1:setPosition(cc.p(curPos.x - 90, curPos.y - 80))
		self.fields.Com_chat1:setVisible(true)
		activity_9001658_Read = cc.p(curPos.x - 90, curPos.y - 80)
		cc.p(curPos.x - 90, curPos.y - 80)[1] = ffa.delay(3.0)
		cc.p(curPos.x - 90, curPos.y - 80)[2] = ffa.hide()
		self.fields.Com_chat1:runAction(ffa.seq(cc.p(curPos.x - 90, curPos.y - 80)))
	elseif chatType == 2 then
		local chatIndex = activity_9001658_Read.getRandomMonsterChat(curStage)
		local chatWord = activity_9001658_Read.getChatWord(chatIndex)
		self.fields.Com_chat2:setString(chatWord)
		self.fields.Com_chat2:setVisible(true)
		activity_9001658_Read = ffa.seq(cc.p(curPos.x - 90, curPos.y - 80))
		ffa.seq(cc.p(curPos.x - 90, curPos.y - 80))[1] = ffa.delay(3.0)
		ffa.seq(cc.p(curPos.x - 90, curPos.y - 80))[2] = ffa.hide()
		ffa.seq(cc.p(curPos.x - 90, curPos.y - 80))[3] = ffa.hide()
		self.fields.Com_chat2:runAction(ffa.seq(ffa.seq(cc.p(curPos.x - 90, curPos.y - 80))))
	end
end
function Com_map:onClickBtnStage(stage, ...)
	SoraDPlaySound()
	if stage > self.curStage then
		SoraDShowMsgTip(i18n("BUBBLE_LEGEND_TEXT_27"))
		return
	end
	local activityID = activity_9001658_Read.getStageActivityID(stage)
	clientEventMgr.singleClickEvent(activityID)
end
function Com_map:createBuild1(...)
	local itemID = 462401
	local dressID = backpackltCtrl:getResult(itemID)
	backpackltCtrl = backpackltCtrl
	backpackltCtrl.isSafe = false
	backpackltCtrl.playerID = gametop.playertop_:getPlayerID()
	local backpackltCtrl.castleSkin, ownCityData = dressID, backpackltCtrl
	local castle = include("worldMapBuildingPreview").new()
	castle:setScale(1.0)
	castle:setPosition(0, -140)
	castle:addTo(self.fields.Com_build1:displayObject())
	castle:initCityData(ownCityData)
end
function Com_map:createBuild8(...)
	if not self.bossImg then
		local bossImg = display.newSprite("#bhmt_dj_ws.png")
		bossImg:addTo(self.fields.Com_build8:displayObject())
		bossImg:setPosition(0, -40)
		bossImg:setScale(1.2)
		self.bossImg = bossImg
	end
	local bossType = gBossType.endlessTrialBoss1
	local bossData = worldMapDefine.getWorldBossShow(bossType)
	local imgName = bossData.effects
	local framesNumber = bossData.frams
	local framesTimes = 0.08333333333333333
	local hasHD = worldMapDefine.hasBossHdRes(bossType)
	if hasHD then
		local frames = display.newFrames(imgName .. "_dj_ws_%02d.png", 1, framesNumber)
		local animation = display.newAnimation(frames, framesTimes)
		self.bossImg:playAnimationForever(animation)
	else
		self.bossImg:setSpriteFrame(imgName .. "_dj_ws.png")
	end
end
function Com_map:checkBossHdRes(...)
	local bossType = gBossType.endlessTrialBoss1
	local hasHD = worldMapDefine.hasBossHdRes(bossType)
	if hasHD then
		return
	end
	local ret = _G.SoraDIsFileExistByKey("worldMapEndlessBoss")
	if not ret then
		return
	end
	display.addSpriteFrames("worldMap/worldMapEndlessBoss.plist", "worldMap/worldMapEndlessBoss.png", function(plist)
		self:createBuild8()
	end)
end
return Com_map

local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
local worldMapLegendOfPegasus = class("worldMapLegendOfPegasus", function(target)
	local target = include("worldMapInstance").new("worldMapLegendOfPegasus")
	return target
end)
local CD_TIME = 1800
function worldMapLegendOfPegasus:ctor()
	self.createUid = 0
	self.leagueID = 0
	self.status = gLosRuinsStatus.SURVEY
	self.lostRuins = display.newSprite("#Map_build_pegasus.png")
	self.lostRuins:setPosition(cc.p(-50, 0))
	self:addChild(self.lostRuins)
	self.effectSp = display.newSprite("#dh_tmxkjudian_01.png")
	self.effectSp:setPosition(cc.p(123, 112))
	self.effectSp:addTo(self.lostRuins, 0)
	self.effectSp:setBlendFunc(gl.ONE, gl.ONE)
	local frames = display.newFrames("dh_tmxkjudian_%02d.png", 1, 15)
	local animation = display.newAnimation(frames, 0.13333333333333333)
	self.effectSp:playAnimationForever(animation)
	self.cdTipNode = SoraDCreatePanel("lostRuinsMapTip")
	self.cdTipNode:addTo(self.lostRuins)
	self.cdTipNode:setPosition(120, 0)
	_ENV = self.cdTipNode
	self.cdTipNode.text = ""
	self.cdTipNode.size = 20
	self.campNameLabel = SoraDCreateLabel(self.cdTipNode)
	self.campNameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.campNameLabel:setPosition(cc.p(0, -55))
	self.campNameLabel:setGroupID(worldMapDefine.GROU_ID.group_text)
	self:addChild(self.campNameLabel)
	self.spriteBg = display.newSprite("#frame_main_receive.png")
	self.spriteBg:setAnchorPoint(cc.p(0.5, 0))
	self.spriteBg:setPosition(cc.p(127, 115))
	self.spriteBg:addTo(self.lostRuins)
	self.spriteBg:setScale(0.5)
	self.spriteBg:setOpacity(180)
	self.statusImg = display.newSprite("#icon_set_search.png")
	self.statusImg:setAnchorPoint(cc.p(0.5, 0.5))
	self.statusImg:setPosition(cc.p(40, 42))
	self.statusImg:addTo(self.spriteBg)
end
function worldMapLegendOfPegasus:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LEGEND_OF_PEGASUS_REFRESH", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
end
function worldMapLegendOfPegasus:setBatchNodeGroupID(groupID)
	self.lostRuins:setGroupID(groupID)
end
function worldMapLegendOfPegasus:initInstanceData(resourceClassID, treasureData)
	self:updateData(treasureData)
end
function worldMapLegendOfPegasus:updateData(treasureData)
	legendOfPegasusCtrl = nil
	;(nil).x = self.tilePoint.x + 1
	;(nil).y = self.tilePoint.y + 1
	local questInfo = legendOfPegasusCtrl:getQuestInfo(nil)
	self.status = questInfo.state or gLosRuinsStatus.SURVEY
	print("updateData self.status", self.status, self:isSurveying())
	self.spriteBg:setVisible(true)
	self.cdTipNode:setVisible(false)
	if self.status == gLosRuinsStatus.SURVEY then
		local isSurveying, leftTime, totalTime = self:isSurveying()
		if isSurveying then
			self.cdTipNode:initActivityTime(leftTime, totalTime, self.status, isSurveying)
			self.cdTipNode:setVisible(true)
			self.spriteBg:setVisible(false)
		else
			self.statusImg:setSpriteFrame("icon_lostRuins_quest.png")
		end
	elseif self.status == gLosRuinsStatus.NOT_RECIEVE then
		self.statusImg:setSpriteFrame("icon_lostRuins_gth.png")
	elseif self.status == gLosRuinsStatus.RECIEVED then
		local totalTime = snowWolfLostRead.getLegendOfPegasusTaskTimeByQuestId(questInfo.questId)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - legendOfPegasusCtrl:getRunningQuestInfo().startTime))
		self.cdTipNode:initActivityTime(leftTime, totalTime, self.status)
		self.spriteBg:setVisible(false)
		self.cdTipNode:setVisible(true)
	elseif self.status == gLosRuinsStatus.COMPLETE then
		self.statusImg:setSpriteFrame("icon_equip_box.png")
	elseif self.status == gLosRuinsStatus.GIVE_UP or self.status == gLosRuinsStatus.RECIEVED_REWARD or self.status == gLosRuinsStatus.OVERDUE or self.status == gLosRuinsStatus.CANCEL then
		legendOfPegasusCtrl = "icon_equip_box.png"
		;("icon_equip_box.png").x = self.tilePoint.x + 1
		;("icon_equip_box.png").y = self.tilePoint.y + 1
		local cdBeginTime = legendOfPegasusCtrl:getQuestInfo("icon_equip_box.png").cdBeginTime or 0
		local leftTime = math.max(0, CD_TIME - (serviceFunctions.systemTime() - cdBeginTime))
		print("cdBeginTime", cdBeginTime, leftTime)
		if 0 < leftTime then
			self.cdTipNode:initActivityTime(leftTime, CD_TIME, self.status)
			self.cdTipNode:setTimeEndCallBack(handler(self, self.updateData))
			self.cdTipNode:setVisible(true)
			self.spriteBg:setVisible(false)
		else
			local isSurveying, leftTime, totalTime = self:isSurveying()
			if isSurveying then
				self.cdTipNode:initActivityTime(leftTime, totalTime, self.status, isSurveying)
				self.cdTipNode:setVisible(true)
				self.spriteBg:setVisible(false)
			else
				self.statusImg:setSpriteFrame("icon_lostRuins_quest.png")
			end
		end
	end
end
function worldMapLegendOfPegasus:playClickSound()
	SoraDPlaySound()
end
function worldMapLegendOfPegasus:isSurveying()
	if not kingdomMapCtrl:getMapEventList() then
		local kingdomMapCtrl, queues = kingdomMapCtrl:getMapEventList(), kingdomMapCtrl:getMapEventList()
	end
	for _, v in pairs(queues) do
		if v.to.x == self.tilePoint.x and v.to.y == self.tilePoint.y then
			local leftTime = v:getStatusRemainTime()
			local totalTime = v.endTime - v.createTime
			return true, leftTime, totalTime
		end
	end
	return false
end
function worldMapLegendOfPegasus:onClickInstance(onShowView)
	print("worldMapLegendOfPegasus:onClickInstance")
	if lordInfoCtrl:getSourceKid() > 0 or lordInfoCtrl:getMapSourceKid() ~= self.kingdomID then
		SoraDShowMsgTip(i18n("snowWolfLost_022"))
		return
	end
	self:playClickSound()
	local panelName = "LegendOfPegasusTask"
	if self.status == gLosRuinsStatus.SURVEY then
		panelName = "LegendOfPegasusInvestigation"
	elseif self.status == gLosRuinsStatus.GIVE_UP or self.status == gLosRuinsStatus.RECIEVED_REWARD or self.status == gLosRuinsStatus.CANCEL or self.status == gLosRuinsStatus.OVERDUE then
		_ENV = i18n("snowWolfLost_022")
		i18n("snowWolfLost_022").x = self.tilePoint.x + 1
		i18n("snowWolfLost_022").y = self.tilePoint.y + 1
		local cdBeginTime = legendOfPegasusCtrl:getQuestInfo(i18n("snowWolfLost_022")).cdBeginTime or 0
		local leftTime = math.max(0, CD_TIME - (serviceFunctions.systemTime() - cdBeginTime))
		print("cdBeginTime", cdBeginTime, leftTime)
		if 0 < leftTime then
			_ENV = leftTime
			leftTime.time = SoraDConvertSecondToString(leftTime)
			SoraDShowMsgTip(i18n("lost_ruins_text_27", leftTime))
			return nil, false
		else
			panelName = "LegendOfPegasusInvestigation"
		end
	end
	_ENV = false
	;(false).titlePoint = cc.p(self.tilePoint.x, self.tilePoint.y)
	;(false).instanceID = self:getInstanceID()
	local selectShowPanel = uiManager:show(panelName, false).view
	return selectShowPanel, true
end
return worldMapLegendOfPegasus

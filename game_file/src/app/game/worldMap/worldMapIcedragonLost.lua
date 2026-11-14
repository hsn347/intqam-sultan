local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local iceDragonLostCtrl = SoraDGetCtrl("iceDragonLostCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
local worldMapIcedragonLost = class("worldMapIcedragonLost", function(target)
	local target = include("worldMapInstance").new("worldMapIcedragonLost")
	return target
end)
local CD_TIME = 1800
function worldMapIcedragonLost:ctor()
	self.createUid = 0
	self.leagueID = 0
	self.status = gLosRuinsStatus.SURVEY
	self.lostRuins = display.newSprite("#Map_build_iceDragonLost.png")
	self.lostRuins:setPosition(cc.p(-50, 0))
	self:addChild(self.lostRuins)
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
function worldMapIcedragonLost:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ICEDRAGON_LOST_REFRESH", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
end
function worldMapIcedragonLost:setBatchNodeGroupID(groupID)
	self.lostRuins:setGroupID(groupID)
end
function worldMapIcedragonLost:initInstanceData(resourceClassID, treasureData)
	self:updateData(treasureData)
end
function worldMapIcedragonLost:updateData(treasureData)
	iceDragonLostCtrl = nil
	;(nil).x = self.tilePoint.x + 1
	;(nil).y = self.tilePoint.y + 1
	local questInfo = iceDragonLostCtrl:getQuestInfo(nil)
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
		local totalTime = snowWolfLostRead.getIceDragonTaskTimeByQuestId(questInfo.questId)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - iceDragonLostCtrl:getRunningQuestInfo().startTime))
		self.cdTipNode:initActivityTime(leftTime, totalTime, self.status)
		self.spriteBg:setVisible(false)
		self.cdTipNode:setVisible(true)
	elseif self.status == gLosRuinsStatus.COMPLETE then
		self.statusImg:setSpriteFrame("icon_equip_box.png")
	elseif self.status == gLosRuinsStatus.GIVE_UP or self.status == gLosRuinsStatus.RECIEVED_REWARD or self.status == gLosRuinsStatus.OVERDUE or self.status == gLosRuinsStatus.CANCEL then
		iceDragonLostCtrl = "icon_equip_box.png"
		;("icon_equip_box.png").x = self.tilePoint.x + 1
		;("icon_equip_box.png").y = self.tilePoint.y + 1
		local cdBeginTime = iceDragonLostCtrl:getQuestInfo("icon_equip_box.png").cdBeginTime or 0
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
function worldMapIcedragonLost:playClickSound()
	SoraDPlaySound()
end
function worldMapIcedragonLost:isSurveying()
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
function worldMapIcedragonLost:onClickInstance(onShowView)
	if lordInfoCtrl:getSourceKid() > 0 or lordInfoCtrl:getMapSourceKid() ~= self.kingdomID then
		SoraDShowMsgTip(i18n("snowWolfLost_022"))
		return
	end
	self:playClickSound()
	local panelName = "IceDragonLostTask"
	if self.status == gLosRuinsStatus.SURVEY then
		panelName = "IceDragonLostInvestigation"
	elseif self.status == gLosRuinsStatus.GIVE_UP or self.status == gLosRuinsStatus.RECIEVED_REWARD or self.status == gLosRuinsStatus.CANCEL or self.status == gLosRuinsStatus.OVERDUE then
		lordInfoCtrl = i18n("snowWolfLost_022")
		i18n("snowWolfLost_022").x = self.tilePoint.x + 1
		i18n("snowWolfLost_022").y = self.tilePoint.y + 1
		local cdBeginTime = iceDragonLostCtrl:getQuestInfo(i18n("snowWolfLost_022")).cdBeginTime or 0
		local leftTime = math.max(0, CD_TIME - (serviceFunctions.systemTime() - cdBeginTime))
		print("cdBeginTime", cdBeginTime, leftTime)
		if 0 < leftTime then
			lordInfoCtrl = leftTime
			leftTime.time = SoraDConvertSecondToString(leftTime)
			SoraDShowMsgTip(i18n("lost_ruins_text_27", leftTime))
			return nil, false
		else
			panelName = "IceDragonLostInvestigation"
		end
	end
	lordInfoCtrl = false
	;(false).titlePoint = cc.p(self.tilePoint.x, self.tilePoint.y)
	;(false).instanceID = self:getInstanceID()
	local selectShowPanel = uiManager:show(panelName, false).view
	return selectShowPanel, true
end
return worldMapIcedragonLost

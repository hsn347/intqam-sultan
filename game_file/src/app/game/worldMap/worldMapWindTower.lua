local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
local worldMapWindTower = class("worldMapWindTower", function()
	local target = include("worldMapInstance").new("worldMapWindTower")
	return target
end)
local windTowerDef = include("windTowerDef")
local windTowerUtil = include("windTowerUtil")
local CD_TIME = windTowerDef.CD_TIME
local gWindTowerStatus = _G.gWindTowerStatus
function worldMapWindTower:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapWindTower:_initData()
	self.createUid = 0
	self.leagueID = 0
	self.status = gWindTowerStatus.SURVEY
end
function worldMapWindTower:_initUI()
	self.lostRuins = display.newSprite("#Map_build_windTower.png")
	self.lostRuins:setPosition(cc.p(self.centerPoint.x + 10, self.centerPoint.y + 10))
	self:addChild(self.lostRuins)
	self.cdTipNode = SoraDCreatePanel("windTowerMapTip")
	self.cdTipNode:addTo(self)
	self.cdTipNode:setPosition(cc.p(self.centerPoint.x + 20, self.centerPoint.y - 60))
	self.spriteBg = display.newSprite("#frame_main_receive.png")
	self.spriteBg:setAnchorPoint(cc.p(0.5, 0))
	self.spriteBg:setPosition(cc.p(self.centerPoint.x + 55, self.centerPoint.y + 15))
	self.spriteBg:addTo(self)
	self.spriteBg:setScale(0.5)
	self.statusImg = display.newSprite("#icon_set_search.png")
	self.statusImg:setAnchorPoint(cc.p(0.5, 0.5))
	self.statusImg:setPosition(cc.p(40, 42))
	self.statusImg:addTo(self.spriteBg)
end
function worldMapWindTower:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WIND_TOWER_REFRESH", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
end
function worldMapWindTower:setBatchNodeGroupID(groupID)
	self.lostRuins:setGroupID(groupID)
end
function worldMapWindTower:initInstanceData(resourceClassID, treasureData)
	self:updateData(treasureData)
end
function worldMapWindTower:updateData(treasureData)
	windTowerCtrl = nil
	;(nil).x = self.tilePoint.x + 1
	;(nil).y = self.tilePoint.y + 1
	local questInfo = windTowerCtrl:getQuestInfo(nil)
	self.status = questInfo.status or gWindTowerStatus.SURVEY
	print("self.status", self.status, self:isSurveying())
	self.spriteBg:setVisible(true)
	self.cdTipNode:setVisible(false)
	local cdTime = windTowerUtil.getBuildCD(self.tilePoint)
	if 0 < cdTime then
		self.status = gWindTowerStatus.OVERDUE
		self.cdTipNode:initActivityTime(cdTime, CD_TIME, self.status)
		self.cdTipNode:setVisible(true)
		self.spriteBg:setVisible(false)
	elseif self.status == gWindTowerStatus.NOT_RECIEVE then
		self.statusImg:setSpriteFrame("icon_lostRuins_gth.png")
	elseif self.status == gWindTowerStatus.RECIEVED then
		if questInfo.finish then
			self.statusImg:setSpriteFrame("icon_equip_box.png")
		else
			local windTowerRead = include("windTowerRead")
			local totalTime = windTowerRead.getTaskTimeByQuestId(questInfo.questId)
			local leftTime = math.max(0, questInfo.endtime - serviceFunctions.systemTime())
			self.cdTipNode:initActivityTime(leftTime, totalTime, self.status)
			self.spriteBg:setVisible(false)
			self.cdTipNode:setVisible(true)
		end
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
function worldMapWindTower:playClickSound()
	SoraDPlaySound()
end
function worldMapWindTower:isSurveying()
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
function worldMapWindTower:onClickInstance(onShowView)
	if lordInfoCtrl:getSourceKid() > 0 or lordInfoCtrl:getMapSourceKid() ~= self.kingdomID then
		return
	end
	self:playClickSound()
	local cdTime = windTowerUtil.getBuildCD(self.tilePoint)
	if 0 < cdTime then
		lordInfoCtrl = nil
		;(nil).time = SoraDConvertSecondToString(cdTime)
		SoraDShowMsgTip(i18n("lost_ruins_text_27", nil))
		return nil, false
	end
	local selectShowPanel = SoraDCreatePanel("windTowerBuildView")
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self:getInstanceID(), self.status)
	selectShowPanel:show()
	return selectShowPanel, true
end
return worldMapWindTower

local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local pyramidClientModule = include("pyramidClientModule")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local allianceDesRead = include("allianceDesRead")
_ENV = "allianceDesRead"
;("allianceDesRead").READ_APPLY = 1
;("allianceDesRead").START_APPLY = 2
;("allianceDesRead").WAIT_APPLY_END = 3
;("allianceDesRead").WAIT_MATCH = 4
;("allianceDesRead").WAIT_DRAW = 5
;("allianceDesRead").START_DRAW = 6
;("allianceDesRead").EMPTY = 7
;("allianceDesRead").PREPARE = 8
local ("allianceDesRead").ENTER, PBLState = 9, "allianceDesRead"
local alliancePBLMainNode = class("alliancePBLMainNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLMainNode")
	end
	return target
end)
function alliancePBLMainNode:ctor()
	self.isRegular = false
	self.nodePBL = SoraDGetChildByName(self, "Node_PBL")
	self.nodeBg = SoraDGetChildByName(self, "Node_bg")
	self.imgBlackBg = SoraDGetChildByName(self, "Image_blackBg")
	self.imgBlackBottom = SoraDGetChildByName(self, "Iamge_blackBottom")
	self.imgBlackBottom2 = SoraDGetChildByName(self, "frame_king_road_line_04_25")
	self.nodePBLIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_alliancePBLBigIconNode_pbl")
	self.spriteBg = SoraDGetChildByName(self, "Sprite_bg")
	self.nodeCreateGroup = SoraDGetChildByName(self, "Node_createGroup")
	self.btnCreateGroup = SoraDGetChildByName(self, "Button_createGroup")
	self.labelCreate1 = SoraDGetChildByName(self, "Text_create_1")
	self.labelCreate2 = SoraDGetChildByName(self, "Text_create_2")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTimeCooling = SoraDGetChildByName(self, "Node_timeCooling")
	self.frameLegendaryKingCountdown12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.frameLegendaryKingCountdown13 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_13")
	self.frameLegendaryKingCountdown14 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_14")
	self.frameLegendaryKingCountdown15 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_15")
	self.frameLegendaryKingCountdown16 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_16")
	self.frameLegendaryKingCountdown17 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_17")
	self.frameLegendaryKingCountdown18 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_18")
	self.labelTime1 = SoraDGetChildByName(self, "Text_time_1")
	self.labelTime2 = SoraDGetChildByName(self, "Text_time_2")
	self.labelApply = SoraDGetChildByName(self, "Text_apply")
	self.btnApply = SoraDGetChildByName(self, "Button_apply")
	self.nodeEnter = SoraDGetChildByName(self, "Node_enter")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.labelOther = SoraDGetChildByName(self, "Text_other")
	self.labelOtherName = SoraDGetChildByName(self, "Text_otherName")
	self.labelOtherMember = SoraDGetChildByName(self, "Text_otherMember")
	self.labelGroupInfo = SoraDGetChildByName(self, "Text_groupInfo")
	self.nodeAllianceFlag = SoraDGetChildByName(self, "Node_otherFlag")
	self.nodePowerRank = SoraDGetChildByName(self, "Node_powerRank")
	self.labelPowerRank = SoraDGetChildByName(self, "Text_powerRank")
	self.btnPoint = SoraDGetChildByName(self, "Button_point")
	self.labelTime3 = SoraDGetChildByName(self, "Text_time_3")
	self.labelTime4 = SoraDGetChildByName(self, "Text_time_4")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelEmpty = SoraDGetChildByName(self, "Text_empty")
	self.labelGameInfo = SoraDGetChildByName(self, "Text_gameInfo")
	self.btnCreateGroup:setTitleText(i18n("pyramid_btn_02"))
	self.labelCreate1:setString(i18n("pyramid_text_09"))
	self.labelCreate2:setString(i18n("pyramid_text_10"))
	self.btnApply:setTitleText(i18n("pyramid_btn_06"))
	self.labelOther:setString(i18n("common_text_3319"))
	self.btnEnter:setTitleText(i18n("common_text_3318"))
	SoraDChangeTextToHtml(self.labelGameInfo)
	SoraDChangeTextToHtml(self.labelGroupInfo)
	_ENV, _ENV, _ENV = i18n("common_text_3318")
	i18n("common_text_3318").__default, i18n("common_text_3318").u = i18n("common_text_3318")
	self.labelGroupInfo:setString(i18n_html("pyramid_btn_04", i18n("common_text_3318")))
	self.labelGroupInfo:setTouchEnabled(true)
	self.labelGroupInfo:addTouchEventListener(handler(self, self.btnClickText))
	_ENV, _ENV, _ENV = handler(self, self.btnClickText)
	handler(self, self.btnClickText).__default, handler(self, self.btnClickText).u = handler(self, self.btnClickText)
	self.labelGameInfo:setString(i18n_html("pyramid_btn_05", handler(self, self.btnClickText)))
	self.labelGameInfo:setTouchEnabled(true)
	self.labelGameInfo:addTouchEventListener(handler(self, self.btnGameInfoClickText))
	_UPVALUE6_ = self.labelGameInfo.addTouchEventListener
	self.timePadding, self.labelGameInfo.addTouchEventListener[1] = self.labelGameInfo.addTouchEventListener, 56
	self.timePadding, self.labelGameInfo.addTouchEventListener[2] = self.labelGameInfo.addTouchEventListener, 56
	self.timePadding, self.labelGameInfo.addTouchEventListener[3] = self.labelGameInfo.addTouchEventListener, 90
	self.timePadding, self.labelGameInfo.addTouchEventListener[4] = self.labelGameInfo.addTouchEventListener, 45
	self.timePadding, self.labelGameInfo.addTouchEventListener[5] = self.labelGameInfo.addTouchEventListener, 86
	self.timePadding, self.labelGameInfo.addTouchEventListener[6] = self.labelGameInfo.addTouchEventListener, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.activity_time:addTo(self.nodeTimeCooling)
	self.activity_time:setPosition(cc.p(-345, 0))
	self.activity_time:setLocalZOrder(10)
	self.btnApply:addTouchEventListener(handler(self, self.btnApplyClick))
	self.btnCreateGroup:addTouchEventListener(handler(self, self.btnCreateGroupClick))
	self.btnEnter:addTouchEventListener(handler(self, self.btnEnterClick))
	self.btnPoint:addTouchEventListener(handler(self, self.btnPointClick))
	self:initData()
end
function alliancePBLMainNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ENTERBATTLEFAIL", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.initGroupCreate))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.initGroupCreate))
end
function alliancePBLMainNode:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
function alliancePBLMainNode:updatePoint()
	self.nodePowerRank:setVisible(true)
	self.labelPowerRank:setString(i18n("pyramid_text_115") .. ":" .. string.formatnumberthousands(pyramidWarCtrl.pblPoint))
	SoraDToCenter(self.nodePowerRank, 50)
end
function alliancePBLMainNode:initData(...)
	self:initView()
end
function alliancePBLMainNode:initView(...)
	self:hiddleAll()
	self.groupType = gPinnacleSeasonAllianceState.NOT_APPLY
	self.seasonState = pyramidWarCtrl.pinnacleSeasonState
	self.curMatchType = pyramidWarCtrl.curMatchType
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.ownlegion = pyramidWarCtrl:getOwnLegion()
	if self.ownlegion then
		self.groupType = self.ownlegion.pinnacleSeasonAllianceState
	end
	self:testDump()
	print("hasJoinAlliance", allianceMgr:hasJoinAlliance(), self.legionList, self.ownlegion)
	dump(self.legionList, "self.legionList")
	if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 or not self.ownlegion then
		if self.rtimer then
			SoraDManagerRemoveTimer(self, self.rtimer)
			self.rtimer = nil
		end
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		self:initGroupCreate()
	elseif self.ownlegion and (self.ownlegion.battleSeasonType == gSeasonType.REGULAR_SEASON or self.ownlegion.battleSeasonType == gSeasonType.NONE and self.seasonState ~= gPinnacleSeasonState.APPLY_ING_A and self.seasonState ~= gPinnacleSeasonState.WAIT_OPEN or self.seasonState == gPinnacleSeasonState.FINISH and self.groupType == gPinnacleSeasonAllianceState.FINISH) then
		self.isRegular = true
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		self:initRegularView()
	else
		self.isRegular = false
		if self.rtimer then
			SoraDManagerRemoveTimer(self, self.rtimer)
			self.rtimer = nil
		end
		local curState = self:change2state()
		print("curState", curState)
		if curState == PBLState.READ_APPLY then
			print("准备开始")
			self:initWaitApply()
		elseif curState == PBLState.START_APPLY then
			print("开始报名")
			self:initStarApply()
		elseif curState == PBLState.WAIT_APPLY_END then
			print("等待报名结果公布")
			self:initStarApply()
		elseif curState == PBLState.WAIT_MATCH then
			print("匹配对手中")
			self:initWaitMatch()
		elseif curState == PBLState.WAIT_DRAW then
			print("等待抽签")
			self:initStarDraw()
		elseif curState == PBLState.START_DRAW then
			print("开始抽签")
			self:initStarDraw()
		elseif curState == PBLState.EMPTY then
			print("轮空")
			self:initWaitApply()
		elseif curState == PBLState.PREPARE then
			print("有对手")
			self:initInWar()
		elseif curState == PBLState.ENTER then
			print("进入战场")
			self:initInWar()
		end
	end
end
function alliancePBLMainNode:initRegularView()
	self.seasonState = pyramidWarCtrl.regularSeasonState
	self.groupType = self.ownlegion.regularSeasonAllianceState
	if self.groupType == gRegularSeasonAllianceState.NOT_APPLY or self.groupType == gRegularSeasonAllianceState.FINISH then
		print("未报名")
		if self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
			print("等待下一轮报名")
			self:initRWaitApply()
		elseif self.seasonState == gRegularSeasonState.APPLY_ING then
			print("开始报名")
			self:initRStarApply()
		end
	elseif self.groupType == gRegularSeasonAllianceState.APPLY_ED then
		print("已报名")
		self:initRStarApply()
	elseif self.groupType == gRegularSeasonAllianceState.NOT_MATCH then
		self:initRWaitApply()
	elseif self.groupType == gRegularSeasonAllianceState.PREPARE then
		print("准备，等待本联盟战场开始")
		self:initRInWar()
	elseif self.groupType == gRegularSeasonAllianceState.RUNNING then
		print("进行中，等待本联盟战场结束")
		self:initRInWar()
	end
end
function alliancePBLMainNode:openRTimeUp()
	if self.nodeTime:isVisible() then
		local nowTimeLeft = pyramidWarCtrl:getLeftTime(self.seasonState)
		self.activity_time:setTime(nowTimeLeft)
	end
	if self.labelTime4:isVisible() and self.ownlegion then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
		end
		if self.groupType == gRegularSeasonAllianceState.PREPARE then
			pyramidWarCtrl = nil
			;(nil).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3308", nil))
		elseif self.groupType == gRegularSeasonAllianceState.RUNNING then
			pyramidWarCtrl = i18n("common_text_3308", nil)
			i18n("common_text_3308", nil).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3309", i18n("common_text_3308", nil)))
		end
	elseif self.ownlegion and self.groupType == gRegularSeasonAllianceState.APPLY_ED and self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
			self.activity_time:setTime(leftTime)
		end
	end
end
function alliancePBLMainNode:initRInWar(target, data)
	self:changeBg(true)
	if data and data.info then
		self.groupType = gRegularSeasonAllianceState.NOT_APPLY
		self.seasonState = pyramidWarCtrl.regularSeasonState
		self.legionList = pyramidWarCtrl:getLegionInfoList()
		self.ownlegion = pyramidWarCtrl:getOwnLegion()
		if self.ownlegion then
			self.groupType = self.ownlegion.regularSeasonAllianceState
		end
		if self.groupType ~= gRegularSeasonAllianceState.RUNNING and self.groupType ~= gRegularSeasonAllianceState.PREPARE then
			self:initData()
			return
		end
		if self.ownlegion == nil then
			self:initData()
			return
		end
		local otherData = data.info[tostring(self.ownlegion.legionId)]
		if otherData == nil then
			self:initData()
			return
		end
		self.nodeBg:setVisible(true)
		self.nodeEnter:setVisible(true)
		self.labelTime4:setVisible(true)
		self.labelMember:setVisible(true)
		if self.groupType == gRegularSeasonAllianceState.PREPARE then
			self.btnEnter:setVisible(false)
		else
			self.btnEnter:setVisible(true)
		end
		_ENV = true
		;(true).abbr = _q(otherData.abbr)
		;(true).name = otherData.legionName
		local name = i18n("common_text_186", true)
		self.nodeAllianceFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(otherData.flag, self.nodeAllianceFlag)
		self.labelOtherName:setString(name .. " " .. "#" .. otherData.kid)
		_ENV = "#"
		;("#").cur = otherData.curmem
		;("#").max = otherData.totalmem
		self.labelOtherMember:setString(i18n("common_text_3408", "#"))
		_ENV = i18n("common_text_3408", "#")
		i18n("common_text_3408", "#").cur = table.nums(self.ownlegion.memberList)
		i18n("common_text_3408", "#").max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", i18n("common_text_3408", "#")))
	else
		SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK")
		SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK", handler(self, self.initRInWar))
		pyramidWarCtrl:regularSeasonGetMatchAllianceInfoReq()
	end
	if self.rtimer == nil then
		self.rtimer = SoradCreateTimer(self, handler(self, self.openRTimeUp))
	end
	self:openRTimeUp()
end
function alliancePBLMainNode:initRStarApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	self.labelTime3:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(false)
	self.btnApply:setVisible(true)
	self.labelTime1:setString(i18n("pyramid_text_106"))
	self.labelTime3:setString(i18n("pyramid_text_14"))
	if self.groupType == gRegularSeasonAllianceState.APPLY_ED then
		self.labelApply:setVisible(true)
		local showTime = pyramidWarltCtrl.getWeedTimeStr(self.ownlegion.number, self.seasonState ~= gRegularSeasonState.WAIT_APPLY_NEXT)
		self.labelApply:setString(i18n("pyramid_text_15") .. " " .. showTime)
		if self.seasonState == gRegularSeasonState.WAIT_APPLY_NEXT then
			self.labelTime1:setString(i18n("pyramid_text_105"))
			self.btnApply:setVisible(false)
		elseif pyramidWarCtrl:getGroupManagerRank() <= 0 then
			self.btnApply:setVisible(false)
		end
	end
	if self.rtimer == nil then
		self.rtimer = SoradCreateTimer(self, handler(self, self.openRTimeUp))
	end
	self:openRTimeUp()
	self:updatePoint()
end
function alliancePBLMainNode:initRWaitApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	self.nodePowerRank:setVisible(true)
	self.labelTime2:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(false)
	self.btnApply:setVisible(false)
	self.labelTime1:setString(i18n("pyramid_text_103"))
	self.labelTime2:setString(i18n("pyramid_text_11"))
	if self.groupType == gRegularSeasonAllianceState.NOT_MATCH then
		self.labelEmpty:setVisible(true)
		self.labelEmpty:setString(i18n("common_text_3320"))
	end
	rankingsCtrl:getRankings(lordRankingsDef.allianceLegionPower)
	if self.rtimer == nil then
		self.rtimer = SoradCreateTimer(self, handler(self, self.openRTimeUp))
	end
	self:openRTimeUp()
	self:updatePoint()
	if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.WAIT_OPEN then
		_ENV = handler(self, self.openRTimeUp)
		handler(self, self.openRTimeUp).num = pyramidWarCtrl.peakSeasonNo
		self.labelTime2:setString(i18n("pyramid_text_16", handler(self, self.openRTimeUp)))
		self.labelPBLInfo:setVisible(true)
	end
end
function alliancePBLMainNode:change2state()
	local ret = PBLState.READ_APPLY
	if self.groupType == gPinnacleSeasonAllianceState.FINISH and (self.seasonState == gPinnacleSeasonState.CHAMPION_LOT or self.seasonState == gPinnacleSeasonState.WAIT_LOT or self.seasonState == gPinnacleSeasonState.SYSTEM_LOT) and (self.curMatchType == gPinnacleMatchType.BREAKOUT_MATCH or self.curMatchType == gPinnacleMatchType.CHAMPION_MATCH) then
		if self.ownlegion and (self.ownlegion.pinnacleCompetitionGroup == 3 or self.ownlegion.pinnacleBreakoutGroup == 3) then
			ret = PBLState.WAIT_MATCH
		else
			ret = PBLState.WAIT_DRAW
		end
	elseif self.seasonState == gPinnacleSeasonState.APPLY_ING_A then
		ret = PBLState.START_APPLY
	elseif self.seasonState == gPinnacleSeasonState.GROUP_LIST_WILL_SHOW or self.seasonState == gPinnacleSeasonAllianceState.GROUP_LIST_WAITING or self.seasonState == gPinnacleSeasonAllianceState.WAIT_AREA_SELECT or self.groupType == gPinnacleSeasonAllianceState.PINNACLE_SIGN_UP then
		ret = PBLState.WAIT_APPLY_END
	elseif self.groupType == gPinnacleSeasonAllianceState.APPLY_ED or self.groupType == gPinnacleSeasonAllianceState.COMPETITION_LOTED then
		ret = PBLState.WAIT_MATCH
	elseif self.groupType == gPinnacleSeasonAllianceState.PINNACLE_WAIT_GROUP_AREA or self.groupType == gPinnacleSeasonAllianceState.PINNACLE_GROUP_AREA_OK or self.groupType == gPinnacleSeasonAllianceState.COMPETITION_LOTED or self.seasonState == gPinnacleSeasonState.CHAMPION_LOT then
		ret = PBLState.START_DRAW
		if self.groupType == gPinnacleSeasonAllianceState.PINNACLE_GROUP_AREA_OK and self.seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT then
			ret = PBLState.WAIT_MATCH
		end
	elseif self.groupType == gPinnacleSeasonAllianceState.NOT_MATCH then
		ret = PBLState.EMPTY
	elseif self.groupType == gPinnacleSeasonAllianceState.PREPARE then
		ret = PBLState.PREPARE
	elseif self.groupType == gPinnacleSeasonAllianceState.RUNNING then
		ret = PBLState.ENTER
	elseif self.groupType == gPinnacleSeasonAllianceState.FINISH then
		if self.seasonState == gPinnacleSeasonState.WAIT_LOT or self.seasonState == gPinnacleSeasonState.SYSTEM_LOT then
			ret = PBLState.WAIT_DRAW
		else
			ret = PBLState.WAIT_MATCH
		end
	else
		print("没有可匹配的状态")
	end
	return ret
end
function alliancePBLMainNode:testDump()
	dump(self.ownlegion, "self.ownlegion", 10)
	for k, v in pairs(gPinnacleSeasonAllianceState) do
		if v == self.groupType then
			print("groupType", k, self.groupType)
			break
		end
	end
	for k, v in pairs(gPinnacleSeasonState) do
		if v == self.seasonState then
			print("seasonState", k, self.seasonState)
			break
		end
	end
	for k, v in pairs(gPinnacleMatchType) do
		if v == self.curMatchType then
			print("curMatchType", k, self.curMatchType)
			break
		end
	end
end
function alliancePBLMainNode:openTimeUp()
	if self.nodeTime:isVisible() then
		local nowTimeLeft = pyramidWarCtrl:getLeftTime(self.seasonState)
		self.activity_time:setTime(nowTimeLeft)
	end
	if self.labelTime4:isVisible() and self.ownlegion then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
		end
		if self.groupType == gPinnacleSeasonAllianceState.PREPARE then
			pyramidWarCtrl = nil
			;(nil).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3308", nil))
		elseif self.groupType == gPinnacleSeasonAllianceState.RUNNING then
			pyramidWarCtrl = i18n("common_text_3308", nil)
			i18n("common_text_3308", nil).time = SoraDConvertSecondToString(leftTime)
			self.labelTime4:setString(i18n("common_text_3309", i18n("common_text_3308", nil)))
		elseif self.groupType == gPinnacleSeasonAllianceState.APPLY_ED then
			self.activity_time:setTime(leftTime)
		end
	elseif self.ownlegion and self.groupType == gPinnacleSeasonAllianceState.APPLY_ED and self.seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT then
		local data = self.ownlegion.queue[tostring(self.groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
			self.activity_time:setTime(leftTime)
		end
	end
end
function alliancePBLMainNode:initGroupCreate()
	if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 or not self.ownlegion then
		self.nodeCreateGroup:setVisible(true)
		local canTouch = allianceMgr:hasJoinAlliance() and pyramidWarCtrl:getGroupManagerRank() >= 2 and pyramidWarCtrl:checkLeftLegionNum()
		self.btnCreateGroup:setTouchEnabled(canTouch)
		self.btnCreateGroup:setBright(canTouch)
		self.nodeBg:setVisible(true)
	end
end
function alliancePBLMainNode:initWaitApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	self.nodePowerRank:setVisible(true)
	self.labelTime2:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(false)
	self.btnApply:setVisible(false)
	self.labelTime1:setString(i18n("pyramid_text_103"))
	self.labelTime2:setString(i18n("pyramid_text_11"))
	if self.groupType == gPinnacleSeasonAllianceState.NOT_MATCH then
		self.labelEmpty:setVisible(true)
		self.labelEmpty:setString(i18n("common_text_3320"))
		self.labelTime2:setVisible(false)
	else
		self.labelTime2:setVisible(true)
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	self:updatePoint()
end
function alliancePBLMainNode:initStarDraw()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelTime3:setVisible(true)
	if self.groupType == gPinnacleSeasonAllianceState.FINISH then
		self.labelTime1:setString(i18n("pyramid_text_116"))
	else
		self.labelTime1:setString(i18n("pyramid_text_118"))
	end
	self.labelTime3:setString(i18n("pyramid_text_20"))
	self.btnApply:setVisible(true)
	self.labelApply:setVisible(false)
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	self:updatePoint()
end
function alliancePBLMainNode:initWaitMatch()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	self.labelApply:setVisible(true)
	self.labelTime4:setVisible(true)
	if self.ownlegion.number > 0 then
		local showTime = pyramidWarltCtrl.getWeedTimeStrByData(self.ownlegion)
		if showTime ~= "" then
			self.labelApply:setString(i18n("pyramid_text_15") .. " " .. showTime)
		else
			self.labelApply:setString(showTime)
		end
	end
	self.labelTime1:setString(i18n("pyramid_text_105"))
	self.btnApply:setVisible(false)
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	self:updatePoint()
end
function alliancePBLMainNode:initStarApply()
	self.nodeBg:setVisible(true)
	self.nodeTime:setVisible(true)
	if self.ownlegion then
		self.labelMember:setVisible(true)
		_ENV = nil
		;(nil).cur = table.nums(self.ownlegion.memberList)
		;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", nil))
	end
	if self.seasonState == gPinnacleSeasonState.GROUP_LIST_WILL_SHOW or self.seasonState == gPinnacleSeasonState.GROUP_LIST_WAITING or self.seasonState == gPinnacleSeasonState.WAIT_AREA_SELECT or self.seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT then
		self.labelTime1:setString(i18n("pyramid_text_50"))
		self.btnApply:setVisible(false)
	else
		self.labelTime3:setVisible(true)
		self.labelTime1:setString(i18n("pyramid_text_106"))
		self.labelTime3:setString(i18n("pyramid_text_14"))
		self.btnApply:setVisible(true)
	end
	self.labelApply:setVisible(false)
	if self.groupType == gPinnacleSeasonAllianceState.APPLY_ED then
		self.labelApply:setVisible(true)
		self.labelTime4:setVisible(true)
		local showTime = pyramidWarltCtrl.getWeedTimeStrByData(self.ownlegion)
		if showTime ~= "" then
			self.labelApply:setString(i18n("pyramid_text_15") .. " " .. showTime)
		else
			self.labelApply:setString(showTime)
		end
		if self.seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT then
			self.labelTime1:setString(i18n("pyramid_text_105"))
			self.btnApply:setVisible(false)
		elseif pyramidWarCtrl:getGroupManagerRank() <= 0 then
			self.btnApply:setVisible(false)
		end
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	self:updatePoint()
end
function alliancePBLMainNode:changeBg(isEnter)
	local offsetY = 0
	if isEnter then
		offsetY = 190
	end
	self.nodeBg:setPositionY(0 + offsetY)
	self.nodePowerRank:setPositionY(170 + offsetY)
	self.labelGameInfo:setPositionY(215 + offsetY)
	self.imgBlackBottom:setPositionY(-160 - offsetY)
	self.imgBlackBottom2:setPositionY(-160 - offsetY)
	self.imgBlackBg:setContentSize(cc.size(800, 280 + offsetY))
end
function alliancePBLMainNode:initInWar(target, data)
	self:changeBg(true)
	dump(data, "alliancePBLMainNode:initInWar", 10)
	if data and data.info then
		self.groupType = gPinnacleSeasonAllianceState.NOT_APPLY
		self.seasonState = pyramidWarCtrl.pinnacleSeasonState
		self.legionList = pyramidWarCtrl:getLegionInfoList()
		self.ownlegion = pyramidWarCtrl:getOwnLegion()
		if self.ownlegion then
			self.groupType = self.ownlegion.pinnacleSeasonAllianceState
		end
		if self.groupType ~= gPinnacleSeasonAllianceState.RUNNING and self.groupType ~= gPinnacleSeasonAllianceState.PREPARE then
			self:initData()
			return
		end
		if self.ownlegion == nil then
			self:initData()
			return
		end
		local otherData = data.info[tostring(self.ownlegion.legionId)]
		if otherData == nil or otherData.style ~= gSeasonType.PINNACLE_SEASON then
			self:initData()
			return
		end
		self.nodeBg:setVisible(true)
		self.nodeEnter:setVisible(true)
		self.labelTime4:setVisible(true)
		self.labelMember:setVisible(true)
		if self.groupType == gPinnacleSeasonAllianceState.PREPARE then
			self.btnEnter:setVisible(false)
		else
			self.btnEnter:setVisible(true)
		end
		_ENV = true
		;(true).abbr = _q(otherData.abbr)
		;(true).name = otherData.legionName
		local name = i18n("common_text_186", true)
		self.nodeAllianceFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(otherData.flag, self.nodeAllianceFlag)
		self.labelOtherName:setString(name .. " " .. "#" .. otherData.kid)
		_ENV = "#"
		;("#").cur = otherData.curmem
		;("#").max = otherData.totalmem
		self.labelOtherMember:setString(i18n("common_text_3408", "#"))
		_ENV = i18n("common_text_3408", "#")
		i18n("common_text_3408", "#").cur = table.nums(self.ownlegion.memberList)
		i18n("common_text_3408", "#").max = ALLIANCE_GROUP_MEMBER_MAX
		self.labelMember:setString(i18n("common_text_3408", i18n("common_text_3408", "#")))
	else
		SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK")
		SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK", handler(self, self.initInWar))
		pyramidWarCtrl:regularSeasonGetMatchAllianceInfoReq()
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function alliancePBLMainNode:hiddleAll()
	self.nodeCreateGroup:setVisible(false)
	self.nodeBg:setVisible(false)
	self.nodeTime:setVisible(false)
	self.nodeEnter:setVisible(false)
	self.nodePowerRank:setVisible(false)
	self.labelTime2:setVisible(false)
	self.labelTime3:setVisible(false)
	self.labelTime4:setVisible(false)
	self.labelMember:setVisible(false)
	self.labelEmpty:setVisible(false)
end
function alliancePBLMainNode:createTimeNode(numOfChar, initTime, paddingArray)
	local nodeParent = display.newNode()
	local getCharNode = function()
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0.5, 0.5))
		numChar:setPosition(0, 0)
		return numChar
	end
	local _ENV, numArray
	for i = 1, numOfChar do
		local numChar = getCharNode()
		numChar:addTo(nodeParent)
		numChar:setContentSize(cc.size(35, 46))
		numChar:setFontSize(46)
		numArray[i] = numChar
	end
	SoraDAlignNodeArray(numArray, false, paddingArray)
	local nodeTimeCooling = self.nodeTimeCooling
	local frame_LegendaryKing_countdown_12 = self.frameLegendaryKingCountdown12
	function nodeParent:setTime(secTime)
		local timeStr = SoraDConvertSecondToStringNoDay(secTime)
		local splitTime = string.split(timeStr, ":")
		if string.len(splitTime[1]) >= 3 then
			if tonumber(splitTime[1]) > 999 then
				splitTime[1] = tostring(999)
			end
			frame_LegendaryKing_countdown_12:setVisible(true)
			numArray[1]:setVisible(true)
			nodeTimeCooling:setPositionX(344)
			_UPVALUE6_ = nodeTimeCooling.setPositionX
			nodeTimeCooling.setPositionX[1] = string.sub(timeStr, 1, 1)
			nodeTimeCooling.setPositionX[2] = string.sub(timeStr, 2, 2)
			nodeTimeCooling.setPositionX[3] = string.sub(timeStr, 3, 3)
			nodeTimeCooling.setPositionX[4] = string.sub(timeStr, 5, 5)
			nodeTimeCooling.setPositionX[5] = string.sub(timeStr, 6, 6)
			nodeTimeCooling.setPositionX[6] = string.sub(timeStr, 8, 8)
			nodeTimeCooling.setPositionX[7] = string.sub(timeStr, 9, 9)
			nodeTimeCooling.setPositionX[8] = string.sub(timeStr, 9, 9)
			nodeTimeCooling.setPositionX[9] = string.sub(timeStr, 9, 9)
			local nodeTimeCooling.setPositionX[10], strArray = string.sub(timeStr, 9, 9)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			nodeTimeCooling:setPositionX(320)
			frame_LegendaryKing_countdown_12:setVisible(false)
			numArray[1]:setVisible(false)
			_UPVALUE5_ = numArray[1].setVisible
			numArray[1].setVisible[1] = string.sub(timeStr, 1, 1)
			numArray[1].setVisible[2] = string.sub(timeStr, 2, 2)
			numArray[1].setVisible[3] = string.sub(timeStr, 4, 4)
			numArray[1].setVisible[4] = string.sub(timeStr, 5, 5)
			numArray[1].setVisible[5] = string.sub(timeStr, 7, 7)
			numArray[1].setVisible[6] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[7] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[8] = string.sub(timeStr, 8, 8)
			numArray[1].setVisible[9] = string.sub(timeStr, 8, 8)
			local numArray[1].setVisible[10], strArray = string.sub(timeStr, 8, 8)
			for i = 1, #strArray do
				if numArray[i + 1] then
					numArray[i + 1]:setString(strArray[i])
				end
			end
		end
	end
	if initTime then
		nodeParent:setTime(initTime)
	end
	return nodeParent
end
function alliancePBLMainNode:btnCreateGroupClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupCreateView")
		panel:initCreate()
		panel:show()
	end
end
function alliancePBLMainNode:btnClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupMatchView")
		panel:show()
	end
end
function alliancePBLMainNode:btnGameInfoClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		pyramidClientModule.popPBLView()
	end
end
function alliancePBLMainNode:btnApplyClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isRegular then
			if pyramidWarCtrl:getGroupManagerRank() <= 0 then
				SoraDShowMsgTip(i18n("pyramid_tips_11"))
				return
			end
			local canSelect = false
			for i, v in ipairs(self.legionList) do
				if pyramidWarCtrl:isCanApplyByAid(v.legionId) then
					canSelect = true
					break
				end
			end
			if canSelect then
				SoraDCreatePanel("allianceGroupSelectTimeView"):show()
			else
				SoraDShowMsgTip(i18n("common_text_3254"))
			end
		else
			pyramidClientModule.popPBLView()
		end
	end
end
function alliancePBLMainNode:btnPointClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("alliancePBLPointInfoView"):show()
	end
end
function alliancePBLMainNode:btnEnterClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local enterWarCondition = function(...)
			local gametop = gModuleMgr.getObject("gametop")
			local armyCtrl = gametop.playertop_:getModule("armyCtrl")
			if armyCtrl:getTotalWoundedArmyCount() > 0 then
				SoraDShowMsgBox(i18n("common_text_3261"), i18n("common_text_402"), nil, function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						local worldMapWarDef = include("worldMapWarDef")
						worldMapWarDef.openHospitalView()
					end
				end)
				return false
			end
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			if kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
				SoraDShowMsgTip(i18n("common_text_3498"))
				return false
			end
			if kingdomMapCtrl:isHasMassQueue() then
				SoraDShowMsgTip(i18n("common_text_3262"))
				return false
			end
			return true
		end
		local enterBattle = function()
			if enterWarCondition() then
				SoraDShowLoading(self)
				pyramidWarCtrl:pyramidwarEnterReq()
			end
		end
		pyramidClientModule.popSelectMenu(enterBattle)
	end
end
return alliancePBLMainNode

local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local mailFunctions = include("mailFunctions")
local allianceTaskResult = class("allianceTaskResult", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskResult")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskResult:ctor()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Size_Image_bg = SoraDGetChildByName(self, "Top_Size_Image_bg")
	self.Top_Size_Tile_BgL = SoraDGetChildByName(self, "Top_Size_Tile_BgL")
	self.Top_Size_Tile_BgR = SoraDGetChildByName(self, "Top_Size_Tile_BgR")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.frame_Daily_reward_lace_red_02_2 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_02_2")
	self.frame_Daily_reward_lace_red_01_4 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_01_4")
	self.frame_Daily_reward_lace_red_02_2_0 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_02_2_0")
	self.frame_Daily_reward_lace_red_01_4_0 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_01_4_0")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.img_battle_current = SoraDGetChildByName(self, "img_battle_current")
	self.img_upgrade = SoraDGetChildByName(self, "img_upgrade")
	self.img_battle_next = SoraDGetChildByName(self, "img_battle_next")
	self.title_battle_next = SoraDGetChildByName(self, "title_battle_next")
	self.img_rank_bg = SoraDGetChildByName(self, "img_rank_bg")
	self.lace_rank_bg = SoraDGetChildByName(self, "lace_rank_bg")
	self.text_group_rank = SoraDGetChildByName(self, "text_group_rank")
	self.text_score = SoraDGetChildByName(self, "text_score")
	self.text_stage = SoraDGetChildByName(self, "text_stage")
	self.btn_rank = SoraDGetChildByName(self, "btn_rank")
	self.Top_lacel = SoraDGetChildByName(self, "Top_lacel")
	self.btn_award = SoraDGetChildByName(self, "btn_award")
	self.text_remain_time = SoraDGetChildByName(self, "text_remain_time")
	self.icon_hourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.nodeScore = SoraDGetChildByName(self, "Node_score")
	self.nodeStage = SoraDGetChildByName(self, "Node_stage")
	self.nodeRank = SoraDGetChildByName(self, "Node_rank")
	self.nodeReceive = SoraDGetChildByName(self, "Node_receive")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(120)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(120)
	nodeFireR:addTo(self.Node_fire_R)
	self.btn_rank:addTouchEventListener(handler(self, self.onClick_btn_rank))
	self.btn_award:addTouchEventListener(handler(self, self.onClick_btn_award))
	self.commonFramTitle_node:setTitle(i18n("mail_text_417"))
	self:fitDevice()
	self:init()
end
function allianceTaskResult:fitDevice()
	local dis = display.height - 960
	local contentSize = self.scroll:getContentSize()
	self.scroll:setContentSize(contentSize.width, contentSize.height + dis)
	if 80 < dis then
		self.nodeInfo:setPositionY(self.nodeInfo:getPositionY() + dis)
		self.Text_tip:setPositionY(self.Text_tip:getPositionY() + dis)
		self.nodeRank:setPositionY(self.nodeRank:getPositionY() + dis)
		self.nodeScore:setPositionY(self.nodeScore:getPositionY() + dis)
		self.nodeStage:setPositionY(self.nodeStage:getPositionY() + dis)
		self.nodeReceive:setPositionY(self.nodeReceive:getPositionY() + dis)
	elseif dis < 0 then
	end
end
function allianceTaskResult:init(data)
	local allianceMissionData = playerMobilizationCtrl:getAllianceMobiInfo()
	local matchlev = allianceMissionData.matchlev
	local newmatchlev = allianceMissionData.newmatchlev
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	self.title_battle_next:setString(i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))
	local icon = mobilizationltCtrl:getMobilizationIconByLv(matchlev)
	print("current icon = ", icon)
	local iconNext = mobilizationltCtrl:getMobilizationIconByLv(newmatchlev)
	print("iconnext = ", iconNext)
	self.img_battle_next:loadTexture(iconNext, ccui.TextureResType.plistType)
	local alliancemissionInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	local grouprank = alliancemissionInfo.grouprank
	playerMobilizationCtrl = i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))
	i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)).rank = grouprank
	self.text_group_rank:setString(i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))
	local score = alliancemissionInfo.score
	playerMobilizationCtrl = i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))
	i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))).score = score
	self.text_score:setString(i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))))
	local stageRank = mobilizationltCtrl:getActivitStage(score, matchlev)
	playerMobilizationCtrl = i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))
	i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))).rank = stageRank
	self.text_stage:setString(i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))))
	playerMobilizationCtrl = i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))))
	i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))).num = stageRank
	local strTip = i18n("common_text_3600", i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))))
	local mobiAliStatus = playerMobilizationCtrl:getUserMobiAliStatus()
	if mobiAliStatus == gMobilizationAliStatus.STATUS_NOT_CASTLE_NOTENOUGH then
		playerMobilizationCtrl = i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))))
		i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))).lv = 15
		strTip = i18n("legendaryking_text_22", i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))))
	elseif newmatchlev == matchlev then
		playerMobilizationCtrl = i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)))))
		i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))).rank = i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))
		strTip = strTip .. i18n("common_text_3602", i18n("common_text_3599", i18n("common_text_3597", i18n("common_text_3598", i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))))
	elseif matchlev > newmatchlev then
		playerMobilizationCtrl = "common_text_3602"
		;("common_text_3602").num = stageRank
		;("common_text_3602").rank = i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))
		strTip = i18n("common_text_3603", "common_text_3602")
	elseif matchlev < newmatchlev then
		playerMobilizationCtrl = i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))
		i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev)).rank = i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))
		strTip = strTip .. i18n("common_text_3601", (i18n(mobilizationltCtrl:getMobilizationNameByLv(newmatchlev))))
	end
	self.Text_tip:setString(strTip)
	local closetime = playerMobilizationCtrl:getActivityStatus().closetime
	local remainTime = closetime.timer:getRemainTime()
	self.text_remain_time:setString(SoraDConvertSecondToString(remainTime))
	self.timer = closetime.timer
	self:beginTime()
	self.btn_award:setTitleText(i18n("common_text_1669"))
	SoraDAutoSizeButtonText(self.btn_award, cc.size(174, 55))
end
function allianceTaskResult:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ACTIVITY_CLOSE", handler(self, self.sMsgActivityClose))
end
function allianceTaskResult:sMsgActivityClose(target, data)
	SoraDRemoveAllPanelFromManager()
end
function allianceTaskResult:onClick_btn_rank(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceTaskRankingsView"):show()
	end
end
function allianceTaskResult:onClick_btn_award(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mobiAliStatus = playerMobilizationCtrl:getUserMobiAliStatus()
		if mobiAliStatus == gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE then
			local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
			local allianceInfo = personalMissionData.allianceinfo
			local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
			_ENV = nil
			;(nil).abbr = allianceName
			SoraDShowMsgTip(i18n("common_text_3559", nil))
			return
		end
		SoraDCreatePanel("allianceTaskReward"):show()
	end
end
function allianceTaskResult:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function allianceTaskResult:updateTime()
	local timeStr = SoraDConvertSecondToString(self.timer:getRemainTime())
	self.text_remain_time:setString(timeStr)
end
function allianceTaskResult:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
return allianceTaskResult

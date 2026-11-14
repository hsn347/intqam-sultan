local gametop = gModuleMgr.getObject("gametop")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendStageReward = class("legendStageReward", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendStageReward")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendStageReward:ctor()
	self:createUI()
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.node = SoraDGetChildByName(self, "Bottom_Node")
	self.imgBgBottom = SoraDGetChildByName(self, "img_bg_bottom")
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.scrollView = SoraDGetChildByName(self, "Size_ScrollView_Reward")
	self.legendaryStageContent_Node_Personal = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageContent_Node_Personal")
	self.legendaryStageContent_Node_Alliance = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageContent_Node_Alliance")
	self.nodeFrameSep = SoraDGetChildByName(self, "node_frame_sep")
	self.frameQueueDouble1 = SoraDGetChildByName(self, "frame_queue_double_1")
	self.frameQueueDouble2 = SoraDGetChildByName(self, "frame_queue_double_2")
	self.btnGo:addTouchEventListener(handler(self, self.onClick_btnGo))
	self.btnGo:setTitleText(i18n("common_text_3318"))
	self.commonFramTitle_node:setTitle(i18n("common_text_3141"))
	self.scrollView:setInnerContainerSize(self.scrollView:getContentSize())
	self:fitDevice()
	self.legendaryStageContent_Node_Personal:setVisible(false)
	self.legendaryStageContent_Node_Alliance:setVisible(false)
	if self.nodeFrameSep then
		self.nodeFrameSep:setVisible(false)
	end
	self:init()
	self:updateBtnGo()
end
function legendStageReward:initData(mapid)
	self.mapid = mapid
	self:updateBtnGo()
end
function legendStageReward:updateBtnGo()
	local stageType = legendStageRewardCtrl:getStageType(self.mapid)
	local isPrepare = legendStageRewardCtrl:isActivityPrepare(stageType, self.mapid)
	if isPrepare then
		self.btnGo:setBright(false)
	else
		local isInWar = self:isInWar()
		if not isInWar then
			self.btnGo:setTitleText(i18n("common_text_3318"))
		else
			self.btnGo:setTitleText(i18n("common_text_4256"))
			self.btnGo:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
			SoraDAutoSizeButtonText(self.btnGo)
		end
	end
end
function legendStageReward:isInWar()
	local curKindomID = gametop.playertop_:getKingdomID()
	if worldMapDefine.isInKingStarBattle(curKindomID) and curKindomID == self.mapid then
		return true
	elseif not worldMapDefine.isInKingStarBattle(curKindomID) then
		return worldMapDefine.isInLegendLord()
	end
	return false
end
function legendStageReward:fitDevice()
	local sepH = 20
	local singleH = (display.height - 160 - sepH) / 2
	singleH = math.max(490, singleH)
	local innerH = 2 * singleH + sepH
	self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getContentSize().width, innerH))
	local bottomH = 80
	print("singleH = ", singleH)
	self.legendaryStageContent_Node_Personal:setFitH(singleH)
	self.legendaryStageContent_Node_Alliance:setFitH(singleH)
	self.legendaryStageContent_Node_Alliance:setPositionY(singleH)
	self.legendaryStageContent_Node_Personal:setPositionY(sepH + 2 * singleH)
	if self.nodeFrameSep then
		self.nodeFrameSep:setPositionY(singleH + sepH / 2)
	end
end
function legendStageReward:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendStageReward:init()
	SoraDShowLoading(self)
	legendStageRewardCtrl:reqReward()
end
function legendStageReward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_STAGE_REWARD_INFO_BACK", handler(self, self.sMsgRewardInfoBack))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.sMsgTeamUPdate))
end
function legendStageReward:sMsgRewardInfoBack(target, data)
	dump(data, "legendStageReward:sMsgRewardInfoBack")
	SoraDCloseLoading(self)
	self.legendaryStageContent_Node_Personal:setVisible(true)
	self.legendaryStageContent_Node_Alliance:setVisible(true)
	if self.nodeFrameSep then
		self.nodeFrameSep:setVisible(true)
	end
	local stageType = legendStageRewardCtrl:getStageType(self.mapid)
	_ENV = nil
	;(nil).stageType = stageType
	;(nil).rewardType = gLegendStageRewardType.PERSONAL
	;(nil).mapid = self.mapid
	self.legendaryStageContent_Node_Personal:init(nil)
	_ENV = nil
	;(nil).stageType = stageType
	;(nil).rewardType = gLegendStageRewardType.ALLIANCE
	;(nil).mapid = self.mapid
	self.legendaryStageContent_Node_Alliance:init(nil)
end
function legendStageReward:onClick_btnGo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local stageType = legendStageRewardCtrl:getStageType(self.mapid)
		if legendStageRewardCtrl:isActivityPrepare(stageType, self.mapid) then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		local isInWar = self:isInWar()
		if not isInWar then
			local stageType = legendStageRewardCtrl:getStageType(self.mapid)
			if stageType == gLegendStageType.KING then
				SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
			elseif stageType == gLegendStageType.KING_STAR then
				SoraDGotoWorldMapPoint(cc.p(150, 150), false, self.mapid)
			elseif stageType == gLegendStageType.HEGEMON then
				local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
				local hegemonRead = include("hegemonRead")
				local bid = hegemonCtrl:getJoinBid()
				local coordinate = hegemonRead.getBuildCoordinate(bid)
				SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
			end
		else
			local sourceKid = gametop.playertop_:getKingdomID()
			if 0 < sourceKid then
				SoraDGotoWorldMapPoint(cc.p(600, 600), false, sourceKid)
			end
		end
		self:closePanel()
		SoraDRemoveAllPanelFromManager()
	end
end
function legendStageReward:sMsgTeamUPdate(target, data)
	local stageType = legendStageRewardCtrl:getStageInfo()
	legendStageRewardCtrl = nil
	;(nil).stageType = stageType
	;(nil).rewardType = gLegendStageRewardType.ALLIANCE
	self.legendaryStageContent_Node_Alliance:init(nil)
end
return legendStageReward

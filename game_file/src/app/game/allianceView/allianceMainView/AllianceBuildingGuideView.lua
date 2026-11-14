local gametop = gModuleMgr.getObject("gametop")
local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local AllianceBuildingGuideView = class("AllianceBuildingGuideView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("AllianceBuildingGuideView")
end)
_ENV = "AllianceBuildingGuideView"
;("AllianceBuildingGuideView").none = 0
;("AllianceBuildingGuideView").build = 1
;("AllianceBuildingGuideView").move = 2
local ("AllianceBuildingGuideView").get, gGuideType = 3, "AllianceBuildingGuideView"
function AllianceBuildingGuideView:ctor(properties)
	self.award, gGuideType = nil, nil
	self.guideType = gGuideType.none
	self.FileNode_ani = SoraDGetChildByName(self, "FileNode_ani")
	self.FileNode_ani:setVisible(false)
	self.nodeReward = SoraDGetChildByName(self, "Node_award")
	self.singleReward = SoraDGetChildByName(self.nodeReward, "CCS_commonItemAward_1")
	self.singleReward:setVisible(false)
	self.sprBg = SoraDGetChildByName(self, "Sprite_bg")
	self.btnGo = SoraDGetChildByName(self, "btnGo")
	self.txtGo = SoraDGetChildByName(self, "Text_go")
	self.Text_dear = SoraDGetChildByName(self, "Text_dear")
	self.Text_dear:setString(i18n("common_text_4550"))
	self.txtPs = SoraDGetChildByName(self, "txtPs")
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self:initAni()
	SoraDCreatAnimation(self.__cname, self, false)
	SoraDCreatAnimation("Node_GuideDone_Get_Ani", self.FileNode_ani, true)
end
function AllianceBuildingGuideView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD", handler(self, self.getAction))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GUIDE_UPDATE", handler(self, self.onSetBtn))
end
function AllianceBuildingGuideView:initData(type)
	self.guideType = type
	self:onSetBtn()
	self:upDataReward()
end
function AllianceBuildingGuideView:getAction(target, data)
	local reward = data.reward
	local _ENV, itemData
	for i, v in ipairs(reward) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(itemData, nil)
	end
	dump(itemData, "AllianceBuildingGuideView:getAction")
	SoraDRemoveAllAfterPanelFromManager(self)
	SoraDMailGainItems(itemData, true)
end
function AllianceBuildingGuideView:initAni()
	self.aniCaidai = SoraDGetChildByName(self, "aniCaidai")
	local spine_caidai = sp.SkeletonAnimation:create("spine/caidai.skel", "spine/caidai.atlas", 1)
	spine_caidai:setAnimation(0, "animation", true)
	spine_caidai:addTo(self.aniCaidai)
end
function AllianceBuildingGuideView:onSetBtn()
	self.FileNode_ani:setVisible(false)
	if self.guideType == gGuideType.build then
		self.txtGo:setString(i18n("common_text_042"))
		gGuideType = i18n("common_text_042")
		i18n("common_text_042").num = 15
		self.txtPs:setString(i18n("common_text_4547", i18n("common_text_042")))
	elseif self.guideType == gGuideType.move then
		self.txtGo:setString(i18n("common_text_003"))
		gGuideType = i18n("common_text_003")
		i18n("common_text_003").num = 15
		self.txtPs:setString(i18n("common_text_4548", i18n("common_text_003")))
	elseif self.guideType == gGuideType.get then
		self.txtGo:setString(i18n("common_text_003"))
		gGuideType = i18n("common_text_003")
		i18n("common_text_003").num = 15
		self.txtPs:setString(i18n("common_text_4548", i18n("common_text_003")))
	end
	if allianceGuideCtrl:getGuideStauts() == 1 then
		self.FileNode_ani:setVisible(true)
		self.txtGo:setString(i18n("common_text_1146"))
		self.sprBg:setSpriteFrame("frame_kzhlhd_gz01.png")
	elseif allianceGuideCtrl:getGuideStauts() == 2 then
		self.txtGo:setString(i18n("common_text_1892"))
	end
	self:playGetRewardsEffect(allianceGuideCtrl:getGuideStauts() == 1)
end
function AllianceBuildingGuideView:playGetRewardsEffect(isPlay)
	if isPlay then
		if self.effectGetReward then
			self.effectGetReward:setVisible(true)
			SoraDResetEffectNode(self.effectGetReward)
			self.effectGetReward.action:gotoFrameAndPlay(0, 90, true)
		else
			self.effectGetReward = SoraDCreatAnimationEx("lingdi", nil, true)
			self.effectGetReward:setPosition(cc.p(45, 60))
			self.effectGetReward:addTo(self.txtGo, 1)
		end
	elseif self.effectGetReward then
		self.effectGetReward:setVisible(false)
	end
end
function AllianceBuildingGuideView:upDataReward()
	local data = allianceGuideCtrl.getReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "itemid"
	;(nil)[2] = "count"
	local rewardData = serviceFunctions.tableFormat(data[1].reward, nil)
	for index = 1, table.nums(rewardData) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].itemid, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.8)
			itemAward:setPresentgiftModel()
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.nodeReward)
			itemAward:initData(rewardData[index].itemid, rewardData[index].count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.nodeReward, 100, SoraDFIsRA())
end
function AllianceBuildingGuideView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if allianceGuideCtrl:getGuideStauts() == 1 then
			allianceGuideCtrl:reqGuideReward()
		elseif allianceGuideCtrl:getGuideStauts() == 0 then
			if self.guideType == gGuideType.build then
				local memberMgr = gametop.playertop_:getModule("memberMgr")
				local ownmember = memberMgr:getOwnMember()
				local ownRank = ownmember:getProperty("rank")
				local iscan = allianceBuildingltCtrl:canRankMemberCreate(1, ownRank, 1)
				local canBuild = iscan or ownmember.minfo.official == gAllianceOfficial.LEADER
				if canBuild then
					mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_ALLIANCE_BUILDING)
				else
					SoraDShowMsgTip(i18n("common_text_4549"))
				end
				SoraDRemoveAllAfterPanelFromManager(self)
			elseif self.guideType == gGuideType.move then
				allianceGuideCtrl:reqRandomPoint()
				SoraDRemoveAllAfterPanelFromManager(self)
			end
		end
	end
end
return AllianceBuildingGuideView

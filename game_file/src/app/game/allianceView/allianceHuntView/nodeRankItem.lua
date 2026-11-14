local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local chatFunctions = include("chatFunctions")
local allianceHuntDesRead = include("allianceHuntDesRead")
local nodeRankItem = class("nodeRankItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeRankItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeRankItem:ctor()
	self:createUI()
	self.nodeRank = SoraDGetChildByName(self, "Node_rank")
	self.frameRankBg = SoraDGetChildByName(self, "frame_rank_bg")
	self.frameRank = SoraDGetChildByName(self, "frame_rank")
	self.nodeHead = SoraDGetChildByName(self, "Node_head")
	self.frameLegendaryKingHeadBase2 = SoraDGetChildByName(self, "frame_LegendaryKing_head_base_2")
	self.iconHead = SoraDGetChildByName(self, "icon_head")
	self.frameHead = SoraDGetChildByName(self, "frame_head")
	self.nodeInfo1 = SoraDGetChildByName(self, "Node_info1")
	self.txtDate = SoraDGetChildByName(self, "Text_date")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spRank = SoraDGetChildByName(self, "Sprite_Rank")
	self.textMyRank = SoraDGetChildByName(self, "text_my_rank")
	self.btnChallenge = SoraDGetChildByName(self, "btn_challenge")
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	self.iconReward = SoraDGetChildByName(self, "icon_reward")
	self.btnChallenge:addTouchEventListener(handler(self, self.onClick_btnChallenge))
	self.btnChallenge:setSwallowTouches(true)
	self.btnChallenge:setTitleText(i18n("arena_btn_04"))
	if self.frameRank then
		self.frameRank:setSwallowTouches(false)
		self.frameRank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function nodeRankItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeRankItem:initData(data)
	self.data = data
	if self.data.nodeType == HUNTING_RANK_NODE_TYPE.CHALLENGE then
		local selfId = chatFunctions:getSelfId()
		print("selfId = ", selfId, ", self.data.rankData.uid = ", self.data.rankData.uid)
		if self.data.rankData.uid ~= selfId then
			self.btnChallenge:setVisible(true)
		else
			self.btnChallenge:setVisible(false)
		end
		self.iconReward:setVisible(false)
	elseif self.data.nodeType == HUNTING_RANK_NODE_TYPE.RANK then
		self.btnChallenge:setVisible(false)
	end
	if self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
	else
	end
	self:updateBaseInfo()
end
function nodeRankItem:setTimes(times)
	print("times==333=====", times)
	self.times = times
end
function nodeRankItem:updateBaseInfo()
	local rank = self.data.rankData.rank
	self.spRank:setVisible(true)
	self.textMyRank:setVisible(true)
	self.textMyRank:setVisible(rank > RANK_TOP_SPECIAL)
	self.spRank:setVisible(rank <= RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		self.spRank:setSpriteFrame("icon_ranking_" .. rank .. ".png")
	end
	if self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		local uinfo = self.data.rankData.uinfo
		self.txtName:setString(uinfo.nickName)
		SoraDGetHeadFromManager(self.iconHead, uinfo.iconID, uinfo.avatar)
	else
		self.txtName:setString(i18n(allianceHuntDesRead.robotConfig[1].Name))
		self.iconHead:setSpriteFrame(allianceHuntDesRead.robotConfig[1].Head)
		self.spRank:setVisible(false)
		self.textMyRank:setVisible(false)
	end
	self.txtDate:setString(self.data.rankData.score)
	if self.data.nodeType == HUNTING_RANK_NODE_TYPE.CHALLENGE then
		self.textRewardNum:setVisible(false)
		self.iconReward:setVisible(false)
	else
		local iconRewardNum = allianceHuntDesRead.getChanllengePointByRank(rank)
		self.textRewardNum:setString(string.formatnumberthousands(iconRewardNum))
		self.textRewardNum:setVisible(true)
		self.iconReward:setVisible(true)
	end
	self:updateBg()
end
function nodeRankItem:onMessageListener()
end
function nodeRankItem:onClick_btnChallenge(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroSelectOneView")
		_ENV = nil
		;(nil)[gHeroState.HERO_STATE_NORMAL] = true
		;(nil)[gHeroState.HERO_STATE_DEAD] = false
		;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
		;(nil)[gHeroState.HERO_STATE_BATTLE] = true
		;(nil)[gHeroState.HERO_STATE_DEFEND] = true
		;(nil)[gHeroState.HERO_STATE_ESCAPE] = true
		panel:setFilteHeroState(nil)
		panel:setBannerTitle(i18n("hero_title_07"))
		panel:setBottomTip(i18n("alliance_hunt_text_25"))
		local other = self.data
		local parentView = self.data.parentView
		local funcCallBack = function(selectHeroID, times)
			print("selectHeroID=", selectHeroID)
			local rankData = self.data.rankData
			local canSelectHeros = panel:getCanReallySelectHeros()
			dump(canSelectHeros, "canSelectHeros -----")
			print("#canSelectHeros", #canSelectHeros)
			if 0 < #canSelectHeros and not selectHeroID then
				SoraDShowMsgTip(i18n("alliance_hunt_text_22"))
			else
				panel:closePanel()
				parentView:closePanel()
				local battleView = SoraDCreatePanel("allianceHuntBattleView")
				_ENV = i18n("alliance_hunt_text_22")
				i18n("alliance_hunt_text_22").rankData = rankData
				i18n("alliance_hunt_text_22").selectHeroID = selectHeroID or 0
				i18n("alliance_hunt_text_22").times = times or self.times
				battleView:init(i18n("alliance_hunt_text_22"))
				battleView:show()
			end
		end
		local filterList = allianceHuntCtrl:getGuideHistory()
		panel:initData(funcCallBack, filterList, self.times)
		panel:show()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function nodeRankItem:updateBg()
	self.frameRankBg:setVisible(true)
	local selfID = chatFunctions:getSelfId()
	local rank = self.data.rankData.rank
	if rank > RANK_TOP_SPECIAL and selfID == self.data.rankData.uid then
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_05.png")
	elseif rank <= RANK_TOP_SPECIAL and self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_0" .. rank .. ".png")
	else
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_04.png")
	end
end
function nodeRankItem:setHandle(handle)
	self.handle = handle
end
function nodeRankItem:setScroll(scroll)
	self.scroll = scroll
end
function nodeRankItem:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.data)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
return nodeRankItem

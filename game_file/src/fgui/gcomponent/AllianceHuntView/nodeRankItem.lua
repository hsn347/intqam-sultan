local baseComponent = require("fgui.base.baseComponent")
local nodeRankItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceHuntView/nodeRankItem", nodeRankItem)
local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local chatFunctions = include("chatFunctions")
local allianceHuntDesRead = include("allianceHuntDesRead")
function nodeRankItem:onInit()
	self:fixChildrenPos()
	self.frameRankBg = SoraDGetChildByName(self, "frame_rank_bg")
	self.frameRank = SoraDGetChildByName(self, "frame_rank")
	self.nodeHead = SoraDGetChildByName(self, "Node_head")
	self.frameLegendaryKingHeadBase2 = SoraDGetChildByName(self, "frame_LegendaryKing_head_base_2")
	self.iconHead = SoraDGetChildByName(self, "Node_head")
	self.frameHead = SoraDGetChildByName(self, "frame_head")
	self.nodeInfo1 = SoraDGetChildByName(self, "Node_info1")
	self.txtDate = SoraDGetChildByName(self, "Text_date")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spRank = SoraDGetChildByName(self, "Sprite_Rank")
	self.textMyRank = SoraDGetChildByName(self, "text_my_rank")
	self.btnChallenge = SoraDGetChildByName(self, "btn_challenge")
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	self.iconReward = SoraDGetChildByName(self, "icon_reward")
	self.rankBg = SoraDGetChildByName(self, "rank_bg")
	self.frameRankBg:fix()
	self.btnChallenge:addClickEventListener(handler(self, self.onClick_btnChallenge))
	self.btnChallenge:setTitleText(i18n("arena_btn_04"))
	if self.frameRank then
		self.frameRank:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
	end
end
function nodeRankItem:onShow()
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
	self.rankBg:setVisible(rank > RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		dump("icon_ranking_" .. rank .. ".png", "nodeRankItem:updateBaseInfo")
		self.spRank:setURL("icon_ranking_" .. rank .. ".png")
	end
	if self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		local uinfo = self.data.rankData.uinfo
		self.txtName:setString(uinfo.nickName)
		self.nodeHead:setHeadSprite(uinfo.iconID, uinfo.avatar)
	else
		self.txtName:setString(i18n(allianceHuntDesRead.robotConfig[1].Name))
		self.iconHead:setImage(allianceHuntDesRead.robotConfig[1].Head, false)
		self.spRank:setVisible(false)
		self.textMyRank:setVisible(false)
	end
	self.txtDate:setString(self.data.rankData.score)
	if self.data.nodeType == HUNTING_RANK_NODE_TYPE.CHALLENGE then
		self.textRewardNum:setVisible(false)
		self.iconReward:setVisible(false)
	else
		local iconRewardNum = allianceHuntDesRead.getChanllengePointByRank(rank)
		_UPVALUE2_ = false
		;(false)[1] = rank
		;(false)[2] = iconRewardNum
		dump(false, "iconRewardNum")
		self.textRewardNum:setString(string.formatnumberthousands(iconRewardNum))
		self.textRewardNum:setVisible(true)
		self.iconReward:setVisible(true)
	end
	self:updateBg()
end
function nodeRankItem:onMessageListener()
end
function nodeRankItem:onClick_btnChallenge(sender, event)
	SoraDPlaySound()
	local panel = uiManager:show("heroSelectOneView").view
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
end
function nodeRankItem:updateBg()
	self.frameRankBg:setVisible(true)
	local selfID = chatFunctions:getSelfId()
	local rank = self.data.rankData.rank
	if rank <= RANK_TOP_SPECIAL and self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		self.frameRankBg:setURL("frame_lord_mingci0" .. rank .. ".png")
	else
		self.frameRankBg:setVisible(false)
	end
end
function nodeRankItem:setHandle(handle)
	self.handle = handle
end
function nodeRankItem:setScroll(scroll)
	self.scroll = scroll
end
function nodeRankItem:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.handle then
		self.handle(self.data)
	end
end
return nodeRankItem

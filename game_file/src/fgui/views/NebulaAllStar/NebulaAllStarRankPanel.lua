local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarRankPanel = class("NebulaAllStarRankPanel", baseFguiPanel)
function NebulaAllStarRankPanel:ctor(...)
	NebulaAllStarRankPanel.super.ctor(self, ...)
	print("NebulaAllStarRankPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.curSelect = 1
	self.rankType = 1
	self.nCount = 10
	self:retsetRankData()
	self.selfPlayerID = gametop.playertop_:getPlayerID() or 0
	self.selfCamp = nebulaAllStarCtrl:getSelfCamp()
	self:initShowSelfConfig()
end
function NebulaAllStarRankPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "NebulaEmperor"
	return nil
end
function NebulaAllStarRankPanel:onInit()
	print("=======NebulaAllStarRankPanel:onInit")
	self.fields.Com_title:initData(i18n("pyramid_btn_29"), handler(self, self.onClickClose))
	self.fields.Button_score:setString(i18n("NebulaAllstar_115"))
	self.fields.Button_score:addClickListener(handler(self, self.onClickBtnScore))
	self.fields.Button_reward:setString(i18n("NebulaAllstar_116"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setVirtual()
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("NebulaAllstar_376"))
	self.config = nebulaAllStarRead.getRankConfig()
	local _ENV, tabsetArray = nebulaAllStarRead.getRankConfig(), nebulaAllStarRead.getRankConfig()
	for i, v in ipairs(self.config) do
		_ENV = i18n("NebulaAllstar_376")
		i18n("NebulaAllstar_376").title = i18n(v.rankTitle)
		table.insert(tabsetArray, i18n("NebulaAllstar_376"))
	end
	_ENV = (for generator)
	ipairs(self.config).defaultClick = 1
	ipairs(self.config).tabsetArray = tabsetArray
	local ipairs(self.config).callback, param = handler(self, self.onClickTab), ipairs(self.config)
	self.fields.com_Tab:initView(param, 4.5)
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function NebulaAllStarRankPanel:onShow()
	print("=======NebulaAllStarRankPanel:onShow")
end
function NebulaAllStarRankPanel:onClickTab(tag)
	print("==NebulaEmperorRankPanel:onClickTab==", tag)
	self.curSelect = tag
	local cfg = self.config[self.curSelect]
	self.rankType = cfg.rankType
	self.isRegion = cfg.isRegion
	self.fields.List:setNumItems(0)
	self:retsetRankData()
	self:req4Data()
	self:updateRankTitle()
	self:updateBtnReward()
	if self.isRegion or self.showSelfConfig[self.rankType] then
		self.controllers.c_showSelf:setSelectedIndex(0)
	else
		self.controllers.c_showSelf:setSelectedIndex(1)
	end
end
function NebulaAllStarRankPanel:retsetRankData(...)
	self.rankList, _UPVALUE0_, self.myInfo, _UPVALUE0_, self.iBegin = nil, nil, nil, nil, 1
	self.hasMore = true
end
function NebulaAllStarRankPanel:req4Data()
	nebulaAllStarCtrl:reqRankData(self.rankType, self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarRankPanel:updateRankTitle(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	if self.rankType == RANK_TYPE.CAMP_OCCUPY then
		_fields.Text_title1:setString(i18n("common_text_3154"))
		_fields.Text_title2:setString(i18n("nebula_war_text_0001"))
		_fields.Text_title3:setString(i18n("legendaryking_title_01"))
	else
		_fields.Text_title1:setString(i18n("common_text_3154"))
		_fields.Text_title2:setString(i18n("common_text_264"))
		_fields.Text_title3:setString(i18n("common_text_3156"))
	end
end
function NebulaAllStarRankPanel:onItemRederer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function NebulaAllStarRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function NebulaAllStarRankPanel:refreshRankSingle(obj, rank, data)
	local isSelf = false
	if self.isRegion then
		isSelf = self.selfCamp == data.camp
	else
		isSelf = self.selfPlayerID == data.uid
	end
	local isOwnRank = obj == self.fields.Com_ownRank
	local valueKey = self.config[self.curSelect].key or "value"
	_UPVALUE0_ = nil
	;(nil).rank = rank
	;(nil).isSelf = isSelf
	;(nil).isOwnRank = isOwnRank
	;(nil).rankType = self.rankType
	;(nil).valueKey = valueKey
	obj:initData(data, nil)
end
function NebulaAllStarRankPanel:refreshRankData(rspdata)
	if self.iBegin == 1 then
		if not rspdata.myInfo then
			local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		self:updateOwnRank(myInfo)
	end
	if not rspdata.rankList then
		local _ENV, rankList = rspdata.rankList, rspdata.rankList
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.List:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function NebulaAllStarRankPanel:updateOwnRank(myInfo)
	if not self.isRegion and not self.showSelfConfig[self.rankType] then
		return
	end
	if not self.isRegion then
		myInfo = nebulaAllStarUtil.getRankDataMyInfo(myInfo)
	end
	self.myInfo = myInfo
	self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, self.myInfo)
end
function NebulaAllStarRankPanel:onClickBtnScore(...)
	SoraDPlaySound()
	local scoreDes = nebulaAllStarRead.getRankTypeScoreDes(self.rankType)
	SoraDShowHelpMsgTip(scoreDes)
end
function NebulaAllStarRankPanel:onClickBtnReward(...)
	SoraDPlaySound()
	uiManager:show("NebulaAllStarReward")
end
function NebulaAllStarRankPanel:initShowSelfConfig(...)
	RANK_TYPE, RANK_TYPE = nil, nil
	RANK_TYPE, (nil)[1], (nil)[RANK_TYPE.VIEWER_COLLECT_SPOIL] = nil, nil, true
	;(nil)[RANK_TYPE.CHARM] = true
	;(nil)[RANK_TYPE.STAR_KILL_ARMY_SCORE] = true
	;(nil)[RANK_TYPE.STAR_VALUE] = true
	RANK_TYPE, (nil)[2], (nil)[RANK_TYPE.STAR_ROB_VALUE] = nil, nil, true
	;(nil)[RANK_TYPE.CHARM] = true
	;(nil)[RANK_TYPE.SUPPORT_KILL_ARMY_SCORE] = true
	;(nil)[RANK_TYPE.SUPPORT_VALUE] = true
	;(nil)[3], (nil)[RANK_TYPE.SUPPORT_ROB_VALUE] = nil, true
	local config
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	local teamType = 1
	if myTeamInfo:getIsSuperTeam() then
		teamType = 2
	elseif myTeamInfo:getIsBackupTeam() then
		teamType = 3
	end
	if not config[teamType] then
		RANK_TYPE = config[teamType]
	end
	self.showSelfConfig = config[teamType]
end
function NebulaAllStarRankPanel:updateBtnReward(...)
	RANK_TYPE = nil
	;(nil)[RANK_TYPE.STAR_VALUE] = true
	;(nil)[RANK_TYPE.SUPPORT_VALUE] = true
	local (nil)[RANK_TYPE.VIEWER_COLLECT_SPOIL], config = true, nil
	local visible = not config[self.rankType]
	self.fields.Button_reward:setVisible(visible)
end
return NebulaAllStarRankPanel

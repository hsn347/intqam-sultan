local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRankPanel = class("NebulaEmperorRankPanel", baseFguiPanel)
_ENV = "NebulaEmperorRankPanel"
;("NebulaEmperorRankPanel").TYPE_CAMP = 1
;("NebulaEmperorRankPanel").TYPE_PLAYER = 2
;("NebulaEmperorRankPanel").TYPE_KILL = 3
local ("NebulaEmperorRankPanel").TYPE_CONTRIBUTE, RANK_TYPE = 4, "NebulaEmperorRankPanel"
function NebulaEmperorRankPanel:ctor(...)
	NebulaEmperorRankPanel.super.ctor(self, ...)
	print("NebulaEmperorRankPanel:ctor", self.viewName)
	self.rankType = RANK_TYPE.TYPE_CAMP
	self.nCount = 10
	self:retsetRankData()
	self.selfPlayerID = gametop.playertop_:getPlayerID() or 0
	self.selfCamp = nebulaEmperorCtrl:getSelfCamp()
end
function NebulaEmperorRankPanel:onInit()
	print("=======NebulaEmperorRankPanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(i18n("activity_name_9001535"), handler(self, self.onClickClose), handlerHelp)
	self.fields.Com_rankTitle:fixChildrenPos()
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	_fields.Text_title3:setString(i18n("common_text_2193"))
	self.Text_title1 = _fields.Text_title1
	self.Text_title2 = _fields.Text_title2
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.Com_ownRank:addClickListener(handler(self, self.onClickOwnRank))
	_ENV, _ENV = self.fields.Com_ownRank, self.fields.Com_ownRank.addClickListener
	_ENV, self.fields.Com_ownRank.addClickListener[1], self.fields.Com_ownRank.title = self.fields.Com_ownRank, self.fields.Com_ownRank, i18n("nebulaemperor_text_92")
	_ENV, self.fields.Com_ownRank.addClickListener[2], self.fields.Com_ownRank.title = self.fields.Com_ownRank, self.fields.Com_ownRank, i18n("nebulaemperor_text_93")
	_ENV, self.fields.Com_ownRank.addClickListener[3], self.fields.Com_ownRank.title = self.fields.Com_ownRank, self.fields.Com_ownRank, i18n("nebulaemperor_text_94")
	_ENV, self.fields.Com_ownRank.addClickListener[4], self.fields.Com_ownRank.title = self.fields.Com_ownRank, self.fields.Com_ownRank, i18n("nebulaemperor_text_95")
	local tabsetArray = self.fields.Com_ownRank.addClickListener
	self.fields.Com_ownRank.defaultClick = self.rankType
	self.fields.Com_ownRank.tabsetArray = tabsetArray
	local self.fields.Com_ownRank.callback, param = handler(self, self.onClickTab), self.fields.Com_ownRank
	self.fields.com_Tab:initView(param)
end
function NebulaEmperorRankPanel:onShow()
	print("=======NebulaEmperorRankPanel:onShow")
end
function NebulaEmperorRankPanel:onClickBtnHelp(...)
	SoraDPlaySound()
	if self.rankType == RANK_TYPE.TYPE_CONTRIBUTE then
		uiManager:show("NebulaEmperorRankHelp")
	else
		_ENV = uiManager.show
		uiManager.show[1] = i18n("nebulaemperor_text_97")
		uiManager.show[2] = i18n("nebulaemperor_text_98")
		local uiManager.show[3], config = i18n("nebulaemperor_text_99"), uiManager.show
		local content = config[self.rankType]
		SoraDShowHelpMsgTip(content)
	end
end
function NebulaEmperorRankPanel:onClickTab(tag)
	print("==NebulaEmperorRankPanel:onClickTab==", tag)
	self.rankType = tag
	self.fields.List_rank:setNumItems(0)
	self:retsetRankData()
	self:req4Data()
	self:updateRankTitle()
end
function NebulaEmperorRankPanel:retsetRankData(...)
	self.rankList, _UPVALUE0_, self.myInfo, _UPVALUE0_, self.iBegin = nil, nil, nil, nil, 1
	self.hasMore = true
end
function NebulaEmperorRankPanel:req4Data()
	nebulaEmperorCtrl:reqRankData(self.rankType, self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorRankPanel:updateRankTitle(...)
	_UPVALUE1_, _ENV = nil, nil
	_UPVALUE1_, (nil)[1], (nil)[1] = nil, nil, i18n("nebulaemperor_text_96")
	_UPVALUE1_, (nil)[1], (nil)[2] = nil, nil, i18n("remains_text_86")
	_UPVALUE1_, (nil)[1], (nil)[3] = nil, nil, i18n("remains_text_86")
	_UPVALUE1_, (nil)[2], (nil)[1] = nil, nil, i18n("common_text_264")
	_UPVALUE1_, (nil)[2], (nil)[2] = nil, nil, i18n("remains_text_86")
	_UPVALUE1_, (nil)[2], (nil)[3] = nil, nil, i18n("remains_text_86")
	_UPVALUE1_, (nil)[3], (nil)[1] = nil, nil, i18n("common_text_264")
	_UPVALUE1_, (nil)[3], (nil)[2] = nil, nil, i18n("nebula_war_text_0104")
	_UPVALUE1_, (nil)[3], (nil)[3] = nil, nil, i18n("nebula_war_text_0104")
	;(nil)[4], (nil)[1] = nil, i18n("common_text_264")
	;(nil)[4], (nil)[2] = nil, i18n("common_text_3693")
	;(nil)[4], (nil)[3] = nil, i18n("common_text_3693")
	local titleConfig
	local cfg = titleConfig[self.rankType]
	self.Text_title1:setString(cfg[1])
	self.Text_title2:setString(cfg[2])
end
function NebulaEmperorRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function NebulaEmperorRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function NebulaEmperorRankPanel:refreshRankSingle(obj, rank, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local _fields = obj.fields
	local isSelf = false
	if self.rankType == RANK_TYPE.TYPE_CAMP then
		isSelf = self.selfCamp == data.camp
	else
		isSelf = self.selfPlayerID == data.uid
	end
	_ENV = self.selfPlayerID
	self.selfPlayerID.rank = rank
	self.selfPlayerID.isOwnRank = obj == self.fields.Com_ownRank
	local self.selfPlayerID.isSelf, baseData = isSelf, self.selfPlayerID
	_fields.Com_base:initData2(baseData)
	if self.rankType == RANK_TYPE.TYPE_CAMP then
		local areaName = nebulaEmperorUtil.getAreaName(data.camp)
		local areaIcon = nebulaEmperorUtil.getAreaIcon(data.camp)
		_fields.Text_name:setString(areaName)
		_fields.Load_region:setURL(areaIcon)
		_fields.Load_region:setVisible(true)
		_fields.Com_head:setVisible(false)
	else
		_fields.Load_region:setVisible(false)
		_fields.Com_head:setVisible(true)
		_fields.Com_head:setHeadSprite(data.headid, data.avatar)
		_fields.Com_head:setPlayerID(data.uid)
		local nameStr = data.nickName
		if data.teamAbbr then
			_ENV = data.avatar
			data.avatar.abbr = data.teamAbbr
			data.avatar.name = nameStr
			nameStr = i18n("common_text_186", data.avatar)
		end
		_fields.Text_name:setString(nameStr)
	end
	local scoreStr = ""
	if self.rankType == RANK_TYPE.TYPE_CAMP or self.rankType == RANK_TYPE.TYPE_PLAYER then
		scoreStr = SoraDConvertSecondToString(data.occupyPalaceSecs or 0)
	elseif self.rankType == RANK_TYPE.TYPE_KILL then
		scoreStr = string.formatnumberthousands(data.killArmyFc or 0)
	elseif self.rankType == RANK_TYPE.TYPE_CONTRIBUTE then
		local totalScore = (data.occupyPalaceScore or 0) + (data.occupyTowerScore or 0) + (data.killArmyFcScore or 0)
		scoreStr = string.formatnumberthousands(totalScore)
	end
	_fields.Text_score:setString(scoreStr)
end
function NebulaEmperorRankPanel:onClickOwnRank(...)
	SoraDPlaySound()
	local rank = self.myInfo.rank
	if rank and 0 < rank and rank < self.iBegin then
		self.fields.List_rank:scrollToView(rank - 1, true, true)
	end
end
function NebulaEmperorRankPanel:refreshRankData(rspdata)
	if self.iBegin == 1 then
		if not rspdata.myInfo then
			local nebulaEmperorCtrl, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		local myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
		local lordInfo = lordInfoCtrl:getLordInfo()
		myInfo.teamAbbr = myTeamInfo:getTeamAbbr()
		myInfo.nickName = lordInfo.base.nickName
		myInfo.camp = self.selfCamp
		self.myInfo = myInfo
		self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, self.myInfo)
	end
	if not rspdata.rankList then
		local nebulaEmperorCtrl, rankList = rspdata.rankList, rspdata.rankList
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
return NebulaEmperorRankPanel

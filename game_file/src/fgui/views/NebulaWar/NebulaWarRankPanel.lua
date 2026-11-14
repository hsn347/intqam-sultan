local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarRankPanel = class("NebulaWarRankPanel", baseFguiPanel)
_ENV = "NebulaWarRankPanel"
;("NebulaWarRankPanel").TYPE_PERSON = 1
local _ENV, ("NebulaWarRankPanel").TYPE_CAMP, RANK_TYPE = baseFguiPanel, 2, "NebulaWarRankPanel"
baseFguiPanel.TYPE_SUPER = 1
local baseFguiPanel.TYPE_NORMAL, TEAM_TYPE = 2, baseFguiPanel
function NebulaWarRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarRankPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.rankType = RANK_TYPE.TYPE_PERSON
	self.nCount = 10
	self:retsetRankData()
	self.curRound = nebulaActivityCtrl:getCurRound()
	self.teamType = TEAM_TYPE.TYPE_SUPER
end
function NebulaWarRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarRankPanel:onInit()
	print("=======NebulaWarRankPanel:onInit")
	self.fields.Com_title:setCloseCallback(handler(self, self.onClickClose))
	local obj = self.fields.Com_rankTitle
	obj:fixChildrenPos()
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_title1:setString(i18n("common_text_264"))
	_fields.Text_title2:setString(i18n("common_text_2195"))
	_fields.Text_title3:setString(i18n("common_text_2193"))
	_fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.Com_ownRank:addClickListener(handler(self, self.onClickOwnRank))
	self.inOutWar = self.proxy.param and self.proxy.param.inOutWar
	if self.inOutWar then
		self.curRound = nebulaWarUtil.getLastRound()
	end
	if self.inOutWar then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0342"))
	else
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0135"))
	end
	_ENV, _ENV = self.fields.Com_title, self.fields.Com_title.setTitle
	self.fields.Com_title.title = i18n("nebula_war_text_0596")
	_ENV, self.fields.Com_title.setTitle[1], self.fields.Com_title.tag = self.fields.Com_title, self.fields.Com_title, RANK_TYPE.TYPE_PERSON
	self.fields.Com_title.title = i18n("nebula_war_text_0531")
	_ENV, self.fields.Com_title.setTitle[2], self.fields.Com_title.tag = self.fields.Com_title, self.fields.Com_title, RANK_TYPE.TYPE_CAMP
	local tabsetArray = self.fields.Com_title.setTitle
	self.fields.Com_title.defaultClick = self.rankType
	self.fields.Com_title.tabsetArray = tabsetArray
	local self.fields.Com_title.callback, param = handler(self, self.onClickTab), self.fields.Com_title
	self.fields.com_Tab:initView(param)
	_ENV = self.fields.com_Tab.initView
	_ENV, _ENV, self.fields.com_Tab.initView.defaultClick = param, self.fields.com_Tab, 1
	_ENV, self.fields.com_Tab[1], param.title = param, param, i18n("nebula_war_text_0371")
	self.fields.com_Tab.initView.tabsetArray, self.fields.com_Tab[2], param.title = self.fields.com_Tab, param, i18n("nebula_war_text_0593")
	local self.fields.com_Tab.initView.callback, param = handler(self, self.onClickTab2), self.fields.com_Tab.initView
	self.fields.com_Tab2:initView(param)
end
function NebulaWarRankPanel:onShow()
	print("=======NebulaWarRankPanel:onShow")
	if self.inOutWar then
		SoraDAddMessage(self.proxy, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgNebulaStateNotify))
	end
end
function NebulaWarRankPanel:onMsgNebulaStateNotify(target, event)
	if not nebulaWarUtil.checkShowLastRoundRankBtn() then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function NebulaWarRankPanel:onClickBtnHelp(...)
	local content = ""
	if self.rankType == RANK_TYPE.TYPE_PERSON then
		content = i18n("nebula_war_text_0532")
	elseif self.rankType == RANK_TYPE.TYPE_CAMP then
		content = i18n("nebula_war_text_0533")
	end
	SoraDShowHelpMsgTip(content)
end
function NebulaWarRankPanel:onClickTab(tag)
	self.rankType = tag
	self.fields.List_rank:setNumItems(0)
	self:retsetRankData()
	self:req4Data()
end
function NebulaWarRankPanel:onClickTab2(tag)
	print("==onClickTab2==", tag)
	if self.teamType == tag then
		return
	end
	self.teamType = tag
	self.fields.List_rank:setNumItems(0)
	self:retsetRankData()
	self:req4Data()
end
function NebulaWarRankPanel:retsetRankData(...)
	self.rankList, _UPVALUE0_, self.myInfo, _UPVALUE0_, self.iBegin = nil, nil, nil, nil, 1
	self.hasMore = true
end
function NebulaWarRankPanel:req4Data()
	local isSuperTeam = self.teamType == TEAM_TYPE.TYPE_SUPER
	if self.rankType == RANK_TYPE.TYPE_PERSON then
		nebulaActivityCtrl:reqPlayerRank(nil, self.iBegin, self.nCount, isSuperTeam)
	else
		local camp = nebulaWarUtil.getOutWarSelfCamp(self.curRound)
		nebulaActivityCtrl:reqPlayerRank(camp, self.iBegin, self.nCount, isSuperTeam)
	end
	SoraDShowLoading(self:displayObject())
end
function NebulaWarRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function NebulaWarRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function NebulaWarRankPanel:refreshRankSingle(obj, rank, data)
	if not obj.isInit then
		obj.isInit = true
		obj.fields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
		obj.fields.Load_bg:fix()
	end
	if 0 < rank and rank <= 3 then
		obj.controllers.c_top3:setSelectedIndex(0)
		obj.fields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		obj.fields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		obj.controllers.c_top3:setSelectedIndex(1)
		if 0 < rank and rank <= 150 then
			obj.fields.Text_rank:setString(tostring(rank))
		else
			obj.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
		obj.fields.Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.uid == self.myInfo.uid then
		obj.fields.Load_bg:setURL("frame_alliance_pank_05.png")
	end
	local Com_head = obj.fields.Com_head
	Com_head:setHeadSprite(data.headid, data.avatar)
	Com_head:setPlayerID(data.uid)
	local nameStr = data.nickName
	if data.teamAbbr then
		_ENV = data.avatar
		data.avatar.abbr = data.teamAbbr
		data.avatar.name = data.nickName
		nameStr = i18n("common_text_186", data.avatar)
	end
	obj.fields.Text_name:setString(nameStr)
	local score = data.score or nebulaActivityCtrl:getPlayerScore(data)
	obj.fields.Text_score:setString(string.formatnumberthousands(score or 0))
	if self.rankType == RANK_TYPE.TYPE_PERSON then
		obj.controllers.c_rankType:setSelectedIndex(0)
		local groupId = nebulaWarUtil.getGroupIdByCamp(data.camp)
		local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
		local name = nebulaWarRead.getWarGroupName(groupId)
		_ENV = string.formatnumberthousands(score or 0)
		string.formatnumberthousands(score or 0).abbr = abbr
		string.formatnumberthousands(score or 0).name = name
		local campStr = i18n("common_text_186", string.formatnumberthousands(score or 0))
		obj.fields.Text_camp:setString(campStr)
	else
		obj.controllers.c_rankType:setSelectedIndex(1)
	end
end
function NebulaWarRankPanel:onClickOwnRank(...)
	local rank = self.myInfo.rank
	if rank and 0 < rank and rank < self.iBegin then
		self.fields.List_rank:scrollToView(rank - 1, true, true)
	end
end
function NebulaWarRankPanel:refreshRankData(rspdata)
	if self.iBegin == 1 then
		self:updateOwnRank(rspdata)
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
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function NebulaWarRankPanel:updateOwnRank(rspdata)
	if not rspdata.myInfo then
		local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
	end
	self.myInfo = myInfo
	if self.inOutWar then
		if next(myInfo) then
			self.controllers.c_showSelf:setSelectedIndex(0)
			self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, myInfo)
		else
			self.controllers.c_showSelf:setSelectedIndex(1)
		end
	else
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		local isSuperTeam = self.teamType == TEAM_TYPE.TYPE_SUPER
		if myTeamInfo:getIsSuperTeam() == isSuperTeam then
			self.controllers.c_showSelf:setSelectedIndex(0)
			local _ENV, data = self.controllers.c_showSelf.setSelectedIndex, self.controllers.c_showSelf.setSelectedIndex
			if next(myInfo) then
				data = myInfo
			else
				local lordInfo = lordInfoCtrl:getLordInfo()
				_ENV = lordInfoCtrl
				lordInfoCtrl.teamAbbr = myTeamInfo:getTeamAbbr()
				lordInfoCtrl.teamName = myTeamInfo:getTeamNameRaw()
				lordInfoCtrl.nickName = lordInfo.base.nickName
				data, lordInfoCtrl.camp = lordInfoCtrl, nebulaWarUtil.getOutWarSelfCamp(self.curRound)
			end
			self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, data)
		else
			self.controllers.c_showSelf:setSelectedIndex(1)
		end
	end
end
return NebulaWarRankPanel

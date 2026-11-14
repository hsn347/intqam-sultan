local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaWarRead = include("nebulaWarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local lordLocalData = include("lordLocalData")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarShowPanel = class("NebulaAllStarShowPanel", baseFguiPanel)
function NebulaAllStarShowPanel:ctor(...)
	NebulaAllStarShowPanel.super.ctor(self, ...)
	print("NebulaAllStarShowPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
	self.curSelect = 1
	self.rankList, NebulaAllStarShowPanel, self.indexMax = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY, gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY, 1
end
function NebulaAllStarShowPanel:onInit()
	print("=======NebulaAllStarShowPanel:onInit")
	self.debug = nebulaAllStarUtil.getIsDebug()
	nebulaAllStarUtil.initCheatBtn(self.fields.Button_cheat)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Button_rank:setString(i18n("pyramid_btn_29"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickOperateBtn))
	self.fields.Button_reward:setString(i18n("common_text_2078"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickOperateBtn))
	self.fields.Button_shop:setString(i18n("NebulaAllstar_33"))
	self.fields.Button_shop:addClickListener(handler(self, self.onClickOperateBtn))
	if nebulaAllStarCtrl:getMyTeamInfo():isHasTeam() then
		self.fields.Button_shop:setVisible(false)
	else
		nebulaAllStarCtrl:reqViewerExchangeRecord()
	end
	if SoraDFIsRA() then
		self.fields.Button_left, self.fields.Button_right = self.fields.Button_right, self.fields.Button_left
	end
	self.fields.Button_left:addClickListener(handler(self, self.onClickBtnLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickBtnRight))
	_UPVALUE3_ = self.fields.Button_right.addClickListener
	_UPVALUE3_, self.Com_regionList, self.fields.Button_right.addClickListener[1] = self.fields.Button_right.addClickListener, self.fields.Button_right.addClickListener, self.fields.Com_region1
	_UPVALUE3_, self.Com_regionList, self.fields.Button_right.addClickListener[2] = self.fields.Button_right.addClickListener, self.fields.Button_right.addClickListener, self.fields.Com_region2
	_UPVALUE3_, self.Com_regionList, self.fields.Button_right.addClickListener[3] = self.fields.Button_right.addClickListener, self.fields.Button_right.addClickListener, self.fields.Com_region3
	self.Com_playerList, self.fields.Button_right.addClickListener[1] = self.fields.Button_right.addClickListener, self.fields.Com_player1
	self.Com_playerList, self.fields.Button_right.addClickListener[2] = self.fields.Button_right.addClickListener, self.fields.Com_player2
	self.Com_playerList, self.fields.Button_right.addClickListener[3] = self.fields.Button_right.addClickListener, self.fields.Com_player3
	self.fields.Label_rank:setString(i18n("NebulaAllstar_289"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function NebulaAllStarShowPanel:onShow()
	print("=======NebulaAllStarShowPanel:onShow")
	self.config = nebulaAllStarRead.getShowRankConfig()
	self.indexMax = #self.config
	self.fields.List:setNumItems(self.indexMax)
	self:updateCurSelect2()
	self:updateActivityState()
end
function NebulaAllStarShowPanel:updateShopRed()
	local ret, retNum = nebulaAllStarCtrl:getQuizShopStatusAndNum(true)
	self.fields.Button_shop:setRedVisible(ret, retNum)
end
function NebulaAllStarShowPanel:updateActivityState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if self.debug then
		local cheatStr = "切换状态" .. curState
		self.fields.Button_cheat:setString(cheatStr)
	end
end
function NebulaAllStarShowPanel:updateCurSelect2()
	self:updateCurSelect(self.curSelect)
	local itemIndex = self.curSelect - 1
	self.fields.List:scrollToView(itemIndex)
	self.fields.List:setSelectedIndex(itemIndex)
end
function NebulaAllStarShowPanel:updateCurSelect(curSelect)
	self.curSelect = curSelect
	local cfg = self.config[self.curSelect]
	self.rankType = cfg.rankType
	if cfg.isRegion then
		self.fields.Group_region:setVisible(true)
		self.fields.Group_player:setVisible(false)
	else
		self.fields.Group_region:setVisible(false)
		self.fields.Group_player:setVisible(true)
	end
	local rankList = self.rankList[self.curSelect]
	if rankList then
		self:refreshRankData(rankList)
	else
		nebulaAllStarCtrl:reqRankData(self.rankType, 1, 3, "NebulaAllStarShow")
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaAllStarShowPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_rank then
		uiManager:show("NebulaAllStarRank")
	elseif sender == self.fields.Button_reward then
		uiManager:show("NebulaAllStarReward")
	elseif sender == self.fields.Button_shop then
		nebulaAllStarUtil.openGuessView()
	end
end
function NebulaAllStarShowPanel:onClickBtnLeft(...)
	SoraDPlaySound()
	self.curSelect = self.curSelect - 1
	if self.curSelect < 1 then
		self.curSelect = self.indexMax
	end
	self:updateCurSelect2(self.curSelect)
end
function NebulaAllStarShowPanel:onClickBtnRight(...)
	SoraDPlaySound()
	self.curSelect = self.curSelect + 1
	if self.curSelect > self.indexMax then
		self.curSelect = 1
	end
	self:updateCurSelect2(self.curSelect)
end
function NebulaAllStarShowPanel:onItemRederer(index, obj)
	local cfg = self.config[index + 1]
	if cfg.showTitle then
		obj:setString(i18n(cfg.showTitle))
	end
	if cfg.showImg then
		obj:setIcon(cfg.showImg)
	end
end
function NebulaAllStarShowPanel:onClickItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local curSelect = childIndex + 1
	print("==curSelect==", curSelect)
	if self.curSelect == curSelect then
		return
	end
	self:updateCurSelect(curSelect)
end
function NebulaAllStarShowPanel:refreshRankData(rankList)
	dump(rankList, "==NebulaAllStarShowPanel:refreshRankData==")
	self.rankList[self.curSelect] = rankList
	local cfg = self.config[self.curSelect]
	if cfg.isRegion then
		for i, obj in ipairs(self.Com_regionList) do
			self:updateRegionSingle(obj, rankList[i])
		end
	else
		for i, obj in ipairs(self.Com_playerList) do
			self:updatePlayerSingle(obj, rankList[i])
		end
	end
end
function NebulaAllStarShowPanel:updateRegionSingle(obj, data)
	local _fields = fguiHelper.get_fields(obj)
	local _controllers = fguiHelper.get_controllers(obj)
	if not data then
		obj:setVisible(false)
		return
	end
	obj:setVisible(true)
	local regionIcon = nebulaWarRead.getAreaBigIcon(data.camp)
	_fields.Load_region:setURL(regionIcon)
	local cfg = self.config[self.curSelect]
	local value = data[cfg.key or "value"] or 0
	if cfg.rankType == RANK_TYPE.CAMP_OCCUPY then
		value = SoraDConvertSecondToString(value)
	else
		value = string.formatnumberthousands(value)
	end
	_ENV = nil
	;(nil).num = value
	_fields.Text_value:setString(i18n(cfg.showTitle2, nil))
	local leaderName = data.leaderName or i18n("hero_text_84")
	_ENV = i18n(cfg.showTitle2, nil)
	i18n(cfg.showTitle2, nil).name = leaderName
	_fields.Text_name:setString(i18n("NebulaAllstar_53", i18n(cfg.showTitle2, nil)))
end
function NebulaAllStarShowPanel:updatePlayerSingle(obj, data)
	local _fields = fguiHelper.get_fields(obj)
	local _controllers = fguiHelper.get_controllers(obj)
	_fields.Text_noData:setString(i18n("hero_text_84"))
	if not data then
		_controllers.c1:setSelectedIndex(1)
		return
	end
	_controllers.c1:setSelectedIndex(0)
	_fields.Load_player:setURL(lordLocalData.getPortrait(data.headid))
	local cfg = self.config[self.curSelect]
	local value = data[cfg.key or "value"] or 0
	_ENV = lordLocalData.getPortrait(data.headid)
	lordLocalData.getPortrait(data.headid).num = string.formatnumberthousands(value)
	_fields.Text_value:setString(i18n(cfg.showTitle2, lordLocalData.getPortrait(data.headid)))
	local areaAbbr = nebulaWarRead.getAreaAbbr(data.camp)
	_ENV = i18n(cfg.showTitle2, lordLocalData.getPortrait(data.headid))
	i18n(cfg.showTitle2, lordLocalData.getPortrait(data.headid)).abbr = areaAbbr
	i18n(cfg.showTitle2, lordLocalData.getPortrait(data.headid)).name = data.nickName
	_fields.Text_name:setString(i18n("common_text_186", i18n(cfg.showTitle2, lordLocalData.getPortrait(data.headid))))
end
return NebulaAllStarShowPanel

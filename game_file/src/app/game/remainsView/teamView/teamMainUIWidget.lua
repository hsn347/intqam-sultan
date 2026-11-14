local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsWarUtil = include("remainsWarUtil")
local RUINS_WAR_TEAM_STATE = _G.RUINS_WAR_TEAM_STATE
local teamMainUIWidget = class("teamMainUIWidget", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamMainUIWidget")
	end
	return target
end)
function teamMainUIWidget:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil
	self.single = SoraDGetChildByName(self, "Node_head")
	self.single:setVisible(false)
	table.insert(self.listNode, self.single)
	self.nodeInwar = SoraDGetChildByName(self, "Node_inwar")
	self.txtInwarTime = SoraDGetChildByName(self, "Text_inwar_time")
	SoraDSetTextWidthHeight(self.txtInwarTime, cc.size(300, 60))
	self.txtInwarTime = SoraDCreateTimerLabel(self, self.txtInwarTime)
	self.btnInwar = SoraDGetChildByName(self, "Button_inwar")
	self.btnInwar:setTitleText(i18n("common_text_3318"))
	self.btnInwar:addTouchEventListener(handler(self, self.btnInwarClickCallBack))
	self.nodeTeam = SoraDGetChildByName(self, "Node_team")
	self.txtStatus = SoraDGetChildByName(self, "Text_status")
	self.txtStatus = SoraDCreateScrollLabel(self.txtStatus, 300)
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll:setSwallowTouches(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.nodeMember = SoraDGetChildByName(self, "Node_member")
	self.imagBg = SoraDGetChildByName(self, "Image_bg")
	self.imagBg:addTouchEventListener(handler(self, self.btnClickHeadCallBack))
	self.frameBg = SoraDGetChildByName(self, "frame_bg")
	self.nodeLeader = SoraDGetChildByName(self, "Node_team_leader")
	self.nodeMatching = SoraDGetChildByName(self, "Node_matching")
	self.btnMatch = SoraDGetChildByName(self, "Button_match")
	self.btnMatch:addTouchEventListener(handler(self, self.btnMatchClickCallBack))
	self.txtMatchTimeNum = SoraDGetChildByName(self, "Text_match_time")
	self.txtMatchTimeNum = SoraDCreateTimerLabel(self, self.txtMatchTimeNum)
	self.txtMatchTitle = SoraDGetChildByName(self, "Text_match_status")
	self.memberList, _ENV, self.tableSingleData, _ENV, self.heightWidget = SoraDGetChildByName(self, "Text_match_status"), SoraDGetChildByName(self, "Text_match_status"), SoraDGetChildByName(self, "Text_match_status"), SoraDGetChildByName(self, "Text_match_status"), false
	self.handle = nil
	self.txtInwarTime:setTimeEndListener(function()
		self:initData()
	end)
	self.currentViewType = VIEW_TYPE_CITY
	self:initScrollPos()
end
function teamMainUIWidget:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.changeMainScene))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_BACK", handler(self, self.rspMatchTeam))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_CANCEL_BACK", handler(self, self.rspCancelMatchTeam))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_REQ", function()
		local loading = SoraDShowLoading(self, cc.size(150, 150), nil, nil, 5)
		loading:setPosition(cc.p(0, -137))
	end)
end
function teamMainUIWidget:initData()
	if remainsTeamCtrl:isHasTeam() then
		local status = remainsTeamCtrl:getTeamStatus()
		if status == RUINS_WAR_TEAM_STATE.NONE then
			self:setUIVisible(true)
			self:updateTeaming()
		elseif status == RUINS_WAR_TEAM_STATE.MATCHING then
			self:setUIVisible(true)
			self:updateMatching()
		elseif status == RUINS_WAR_TEAM_STATE.BATTLE then
			self:setUIVisible(true)
			self:updateWaring()
		elseif status == RUINS_WAR_TEAM_STATE.REST then
			self:setUIVisible(true)
			self:updateReset()
		else
			self:resetView()
			self:setUIVisible(false)
		end
	else
		self:resetView()
		self:setUIVisible(false)
	end
end
function teamMainUIWidget:resetView()
	self:removeTime()
	self:setWidgetHeight(false)
	self.nodeLeader:setVisible(false)
end
function teamMainUIWidget:setWidgetHeight(heightWidget)
	if self.heightWidget == heightWidget then
		return
	end
	self.heightWidget = heightWidget
	local cSize = self.imagBg:getContentSize()
	if self.heightWidget then
		self.imagBg:setContentSize(cc.size(cSize.width, 172))
		self.frameBg:setPositionY(-165)
	else
		self.imagBg:setContentSize(cc.size(cSize.width, 127))
		self.frameBg:setPositionY(-120)
	end
end
function teamMainUIWidget:updateMemberList()
	local myTeamInfo = remainsTeamCtrl:getMyTeamInfo()
	dump(myTeamInfo, "myTeamInfo", 10)
	self.memberList = myTeamInfo:getTeamMemberList()
end
function teamMainUIWidget:updateTeaming()
	self:resetView()
	self.nodeTeam:setVisible(true)
	self.nodeInwar:setVisible(false)
	self:updateMemberList()
	_ENV = nil
	;(nil).num = #self.memberList
	self.txtStatus:setString(i18n("remains_text_60", nil))
	self:updateNodeList()
	if remainsTeamCtrl:isTeamLeader() then
		self:setWidgetHeight(true)
		self.nodeLeader:setVisible(true)
		self.txtMatchTitle:setString(i18n("remains_btn_06"))
		local err = remainsWarUtil.checkMatch()
		local isCanMatch = gErrDef.Err_None == err
		self.btnMatch:setTouchEnabled(isCanMatch)
		self.btnMatch:setBright(isCanMatch)
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.txtMatchTimeNum:beginTime(warTime)
		end
	end
end
function teamMainUIWidget:updateMatching()
	self:resetView()
	self.txtStatus:setString(i18n("remains_text_131"))
	self.nodeTeam:setVisible(true)
	self.nodeInwar:setVisible(false)
	self:updateMemberList()
	self:updateNodeList()
	if remainsTeamCtrl:isTeamLeader() then
		self:setWidgetHeight(true)
		self.nodeLeader:setVisible(true)
		self.txtMatchTitle:setString(i18n("remains_text_134"))
		local err = remainsWarUtil.checkCaneclMatch()
		local isCanMatch = gErrDef.Err_None == err
		self.btnMatch:setTouchEnabled(isCanMatch)
		self.btnMatch:setBright(isCanMatch)
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.txtMatchTimeNum:beginTime(warTime)
		end
	end
end
function teamMainUIWidget:updateWaring()
	self:resetView()
	self.txtStatus:setString(i18n("remains_text_66"))
	self.nodeTeam:setVisible(false)
	self.nodeInwar:setVisible(true)
	self.btnInwar:setTouchEnabled(true)
	self.btnInwar:setBright(true)
	local mapId = remainsTeamCtrl:getWarMapId()
	if mapId and 0 < mapId then
		remainsWarCtrl:reqRemainsWarData(mapId)
	end
end
function teamMainUIWidget:updateReset()
	self:resetView()
	self.txtStatus:setString(i18n("remains_text_66"))
	self.nodeTeam:setVisible(false)
	self.nodeInwar:setVisible(true)
	self.btnInwar:setTouchEnabled(false)
	self.btnInwar:setBright(false)
	self:updateStatus()
end
function teamMainUIWidget:removeTime()
	self.txtInwarTime:removeTime()
	self.txtMatchTimeNum:removeTime()
end
function teamMainUIWidget:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self.single:clone()
		single:addTo(self.nodeMember)
	end
	single:setVisible(true)
	return single
end
function teamMainUIWidget:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
local INTER_WIDTH = 65
function teamMainUIWidget:initScrollPos()
	local sSize = self.scroll:getContentSize()
	local scrollW = math.max(_G.TEAM_MEMBER_MAX * INTER_WIDTH, sSize.width)
	self.scroll:setInnerContainerSize(cc.size(scrollW, sSize.height))
	local scrollPercent
	if SoraDFIsRA() then
		scrollPercent = 100
	else
		scrollPercent = 0
	end
	self.scroll:scrollToPercentHorizontal(scrollPercent, 0.0, false)
end
function teamMainUIWidget:updateNodePos()
	local sSize = self.scroll:getInnerContainerSize()
	local scrollW = sSize.width
	for i, v in ipairs(self.scrollItems) do
		local posX = SoraDFPosX(scrollW - (i - 1) * INTER_WIDTH, scrollW)
		v:setPositionX(posX)
	end
end
function teamMainUIWidget:updateNodeData()
	for i = 1, _G.TEAM_MEMBER_MAX do
		local single = self:getSingle()
		local data = self.memberList[i]
		self:setSingleView(single, data)
		table.insert(self.scrollItems, single)
	end
end
function teamMainUIWidget:setSingleView(single, headData)
	local iconHead = SoraDGetChildByName(single, "icon_head")
	if headData then
		iconHead:setScale(0.8)
		SoraDGetHeadFromManager(iconHead, headData.headid, headData.avatar)
	else
		iconHead:setSpriteFrame("frame_LegendaryKing_green_add.png")
		iconHead:setScale(0.9)
	end
end
function teamMainUIWidget:updateNodeList()
	self:recycleSingle()
	self:updateNodeData()
	self:updateNodePos()
end
function teamMainUIWidget:btnInwarClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local err = remainsWarUtil.checkEnterBattleField()
		if gErrDef.Err_None == err then
			remainsTeamCtrl:reqEnterBattlefield()
			local loading = SoraDShowLoading(self, cc.size(150, 150), nil, nil, 5)
			loading:setPosition(cc.p(0, -85))
		else
			self:errHandle(err)
		end
	end
end
function teamMainUIWidget:btnMatchClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local status = remainsTeamCtrl:getTeamStatus()
		if status == RUINS_WAR_TEAM_STATE.MATCHING then
			local err = remainsWarUtil.checkCaneclMatch()
			if gErrDef.Err_None == err then
				remainsTeamCtrl:reqCancelMatch()
				local loading = SoraDShowLoading(self, cc.size(150, 150), nil, nil, 5)
				loading:setPosition(cc.p(0, -137))
			else
				self:errHandle(err)
			end
		elseif status == RUINS_WAR_TEAM_STATE.NONE then
			local err = remainsWarUtil.checkMatch()
			if gErrDef.Err_None == err then
				remainsWarUtil.reqMatch()
			else
				self:errHandle(err)
			end
		end
	end
end
function teamMainUIWidget:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RUINS_WAR) then
		self:setUIVisible(false)
	end
end
function teamMainUIWidget:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = remainsWarUtil.getErrType(err)
	if errType == remainsWarUtil.errType.TIPS then
		remainsWarUtil.errShowTips(err)
	elseif errType == remainsWarUtil.errType.CLOSE then
		remainsWarUtil.errShowTips(err)
		self:setUIVisible(false)
	elseif errType == remainsWarUtil.errType.REFRESH then
		self:initData()
	end
end
function teamMainUIWidget:updateStatus()
	local status = remainsTeamCtrl:getTeamStatus()
	if status == RUINS_WAR_TEAM_STATE.BATTLE then
		local warStatus = remainsWarCtrl:getWarStatus()
		if gKingdomWarStatusType.inWar == warStatus then
			self.inWar = true
			local getTimeNodeTicket = function()
				local time = remainsWarCtrl:getWarBeginTime()
				return time
			end
			self.txtInwarTime:beginTimeNode(getTimeNodeTicket)
		elseif gKingdomWarStatusType.close == warStatus then
			self.inWar = false
			local time = remainsWarCtrl:getStatusTime()
			self.txtInwarTime:beginTime(time)
		end
		self.txtInwarTime:setTimeLast(function(str, tick)
			if self.inWar then
				self = nil
				;(nil).time = str
				local reText = i18n("remains_text_66", nil)
				return reText
			end
			self = nil
			;(nil).time = str
			local reText = i18n("remains_text_65", nil)
			return reText
		end)
	elseif status == RUINS_WAR_TEAM_STATE.REST then
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.txtInwarTime:beginTime(warTime)
			local stri18n = i18n("remains_text_203")
			self.txtInwarTime:setTimeLast(function(str, tick)
				local reText = stri18n .. str
				return reText
			end)
		end
	end
end
function teamMainUIWidget:setUIVisible(visable)
	self._uiVisible = visable
	self:updateUIVisible()
end
function teamMainUIWidget:updateUIVisible(visable)
	if self.currentViewType == VIEW_TYPE_CITY then
		self:setVisible(self._uiVisible)
	else
		self:setVisible(false)
	end
end
function teamMainUIWidget:setViewType(viewType)
	if viewType == VIEW_TYPE_NONE or self.currentViewType == viewType then
		return
	end
	self.currentViewType = viewType
	self:updateUIVisible()
end
function teamMainUIWidget:changeMainScene(target, data)
	self:setViewType(data.viewType)
end
function teamMainUIWidget:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self.beginMove = false
	end
end
function teamMainUIWidget:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not self.beginMove then
			return
		end
		SoraDPlaySound()
		local status = remainsTeamCtrl:getTeamStatus()
		if status == RUINS_WAR_TEAM_STATE.MATCHING or status == RUINS_WAR_TEAM_STATE.NONE then
			local panel = SoraDCreatePanel("myTeamView")
			panel:show()
		end
	elseif type == ccui.TouchEventType.began then
		self.beginMove = true
	end
end
function teamMainUIWidget:rspMatchTeam(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	end
end
function teamMainUIWidget:rspCancelMatchTeam(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("alliance_text_09"))
	end
end
return teamMainUIWidget

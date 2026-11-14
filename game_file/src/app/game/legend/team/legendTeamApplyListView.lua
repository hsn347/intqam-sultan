local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamDef = include("legendTeamDef")
local legendTeamApplyListView = class("legendTeamApplyListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApplyListView")
	end
	return target
end)
_ENV = "legendTeamApplyListView"
;("legendTeamApplyListView").TEAM_VIEW_TYPE_VIEW = 1
local _ENV, ("legendTeamApplyListView").TEAM_VIEW_TYPE_SEARCH, TEAM_VIEW_TYPE = function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApplyListView")
	end
	return target
end, 2, "legendTeamApplyListView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApplyListView")
	end
	return target
end).TEAM_VIEW_SUB_TYPE_ALLIANCE = 1
local _ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApplyListView")
	end
	return target
end).TEAM_VIEW_SUB_TYPE_KINGDOM, TEAM_VIEW_SUB_TYPE = nil, 2, function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamApplyListView")
	end
	return target
end
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE], (nil).name = nil, "common_text_069"
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_KINGDOM], (nil).name = nil, "common_text_479"
local TEAM_VIEW_SUB_TYPE_CONFIG
function legendTeamApplyListView:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("free_team_text_21"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.btnRefreshChoose = SoraDGetChildByName(self, "Button_refresh")
	self.btnRefreshChoose:setTitleText(i18n("common_text_911"))
	self.btnRefreshChoose:addTouchEventListener(handler(self, self.btnRefreshClickCallBack))
	SoraDAutoSizeButtonTextByContent(self.btnRefreshChoose)
	self.nodeView = SoraDGetChildByName(self, "Top_Node_view")
	self.txtViewType = SoraDGetChildByName(self, "Text_view_type")
	self.spArrow = SoraDGetChildByName(self, "Sprite_arrow_l")
	self.spArrow:setRotation(90)
	self.Image_touch = SoraDGetChildByName(self, "Image_touch")
	self.Image_touch:setTouchEnabled(true)
	self.Image_touch:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Image_choose = SoraDGetChildByName(self, "Image_choose")
	self.Image_choose:setScaleY(0)
	self.nodeSearch = SoraDGetChildByName(self, "Top_Node_search")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.nodeNotice = SoraDGetChildByName(self, "Center_Text_notice")
	self.nodeNotice:setVisible(false)
	self.btnTeamCreate = SoraDGetChildByName(self, "Button_team_cteate")
	self.btnTeamCreate:setTitleText(i18n("free_team_text_40"))
	self.btnTeamCreate:addTouchEventListener(handler(self, self.btnTeamCteateClickCallBack))
	_ENV, self.labelNotice = SoraDGetChildByName(self, "Text_notice"), SoraDGetChildByName(self, "Text_notice")
	_ENV = "Text_notice"
	;("Text_notice").title = "Button_View"
	SoraDGetChildByName(self, "Text_notice")[TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW], ("Text_notice").titleText = "Text_notice", "common_text_829"
	_ENV = "Text_notice"
	;("Text_notice").title = "Button_Search"
	SoraDGetChildByName(self, "Text_notice")[TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH], ("Text_notice").titleText = "Text_notice", "common_text_166"
	local tableData = SoraDGetChildByName(self, "Text_notice")
	for i, v in ipairs(tableData) do
		local btnScore = SoraDGetChildByName(self, v.title)
		btnScore:setTag(i)
		btnScore:setPressedActionEnabled(false)
		btnScore:setTitleText(i18n(v.titleText))
		btnScore:addTouchEventListener(handler(self, self.OnBtnChangeClick))
		v.button = btnScore
	end
	self.Node_choose = SoraDGetChildByName(self, "Node_choose")
	self.Node_choose:setVisible(false)
	self:initChoosePanel()
	self.txtSearchName = SoraDGetChildByName(self, "Text_search_name")
	self.txtSearchName:setString(i18n("common_text_4447"))
	self.txtSearchKid = SoraDGetChildByName(self, "Text_search_kid")
	self.txtSearchKid:setString(i18n("common_text_4446"))
	self.fieldText_name = SoraDGetChildByName(self, "TextField_search_name")
	self.fieldText_name = _G.SoraDChangeToEditBox(self.fieldText_name)
	self.fieldText_kid = SoraDGetChildByName(self, "TextField_search_kid")
	self.btnSearch = SoraDGetChildByName(self, "Button_Search_begin")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	SoraDAutoSizeButtonTextByContent(self.btnSearch)
	self.tableData = tableData
	self.showViewType = nil
	self.showViewSubType = nil
	self:changeToEditBox()
	self:initShowBtn(TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW)
end
function legendTeamApplyListView:changeToEditBox(...)
	local editBox = ccui.EditBox:create(self.fieldText_kid:getContentSize(), "bg_transparent.png", ccui.TextureResType.plistType)
	editBox:setPosition(cc.p(self.fieldText_kid:getPositionX(), self.fieldText_kid:getPositionY()))
	editBox:setAnchorPoint(self.fieldText_kid:getAnchorPoint())
	editBox:setFontColor(display.COLOR_BLACK)
	editBox:setMaxLength(4)
	editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
	editBox:addTo(self.fieldText_kid:getParent())
	editBox:setSwallowTouches(false)
	self.fieldText_kid:removeFromParent()
	self.fieldText_kid = editBox
end
function legendTeamApplyListView:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		local btn = v.button
		btn:setTouchEnabled(not show)
		if show then
			btn:setTitleColor(cc.c3b(255, 245, 176))
			btn:loadTextureNormal("btn_alliance_special.png", ccui.TextureResType.plistType)
			self:selectPanel(self.showViewType)
		else
			btn:setTitleColor(cc.c3b(144, 132, 97))
			btn:loadTextureNormal("btn_alliance_click.png", ccui.TextureResType.plistType)
		end
	end
end
function legendTeamApplyListView:selectPanel(showViewType)
	if showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
		self.nodeSearch:setVisible(false)
		self.nodeView:setVisible(true)
		self.showViewSubType = nil
		if allianceMgr:hasJoinAlliance() then
			self:initViewType(TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE)
		else
			self:initViewType(TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_KINGDOM)
		end
	elseif showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH then
		self.nodeSearch:setVisible(true)
		self.nodeView:setVisible(false)
		self:initView()
	end
end
function legendTeamApplyListView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
function legendTeamApplyListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_LIST_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_JOIN_BACK", handler(self, self.rspDispatchBack))
end
function legendTeamApplyListView:initView()
	self:req4Data()
end
function legendTeamApplyListView:updateTeamInfo(target, data)
	if legendTeamCtrl:isHasTeam() then
		legendTeamUtil.openTeamView()
		self:removeFromParent()
	else
		self:refreshViewByData()
	end
end
function legendTeamApplyListView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS or errType == legendTeamUtil.errType.CLOSE or errType == legendTeamUtil.errType.REFRESH then
		legendTeamUtil.errShowTips(err)
		self:initView()
	end
end
function legendTeamApplyListView:req4Data()
	self:resetUI()
	if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
		if self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE then
			if allianceMgr:hasJoinAlliance() then
				local aid = allianceMgr:getOwnAid()
				legendTeamCtrl:reqGetTeamList(nil, aid, "")
				SoraDShowLoading(self)
			else
				self.nodeNotice:setVisible(true)
				self.labelNotice:setString(i18n("common_text_583"))
			end
		elseif self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_KINGDOM then
			local currentKid = gametop.playertop_:getKingdomID()
			legendTeamCtrl:reqGetTeamList(currentKid, nil, "")
			SoraDShowLoading(self)
		end
	elseif self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH then
		self.nodeNotice:setVisible(true)
		self.labelNotice:setString(i18n("remains_text_301"))
	end
end
function legendTeamApplyListView:initData(target, data)
	SoraDCloseLoading(self)
	local teamList
	if data.teamList and next(data.teamList) ~= nil then
		teamList = data.teamList
	else
		teamList, _ENV = next(data.teamList), next(data.teamList)
	end
	if not teamList or not next(teamList) then
		self.teamList, _ENV = next(teamList), next(teamList)
		self.nodeNotice:setVisible(true)
		self.scroll:setVisible(false)
		if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
			self.labelNotice:setString(i18n("free_team_text_20"))
			SoraDSetTextWidthHeight(self.labelNotice, cc.size(620, 64))
		else
			self.labelNotice:setString(i18n("remains_text_302"))
		end
	else
		table.sort(teamList, function(team1, team2)
			local teamMember1 = team1.memberList and table.nums(team1.memberList) or 0
			local teamFull1 = teamMember1 >= legendTeamDef.TEAM_MEMBER_MAX
			local teamMember2 = team2.memberList and table.nums(team2.memberList) or 0
			local teamFull2 = teamMember2 >= legendTeamDef.TEAM_MEMBER_MAX
			if teamFull1 ~= teamFull2 then
				return teamFull2
			end
			if teamMember1 ~= teamMember2 then
				return teamMember1 > teamMember2
			end
			return team2.tid < team1.tid
		end)
		self.teamList = teamList
		self.nodeNotice:setVisible(false)
		self.scroll:setVisible(true)
		self:updateScrollList()
	end
end
function legendTeamApplyListView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = 0
	for _, v in ipairs(self.scrollItems) do
		listHeight = listHeight + v:getSingleH()
	end
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local totalPosY = sH
	for _, v in ipairs(self.scrollItems) do
		v:setPosition(sSize.width / 2, totalPosY)
		totalPosY = totalPosY - v:getSingleH()
	end
end
function legendTeamApplyListView:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = SoraDCreatePanel("legendTeamApplyListSingle")
		single:addTo(self.scroll)
	end
	single:setVisible(true)
	return single
end
function legendTeamApplyListView:updateScrollData()
	local isLegend = legendLordWarCtrl:isLegendLordTeamOpen()
	for _, v in ipairs(self.teamList) do
		local single = self:getSingle()
		single:setScroll(self.scroll)
		single:initData(v, isLegend)
		single:setHandle(handler(self, self.touchClickCallBack))
		single:setJoinHandle(handler(self, self.joinClickCallBack))
		single:setPlayerInfo(handler(self, self.queryPlayerInfo))
		table.insert(self.scrollItems, single)
	end
end
function legendTeamApplyListView:joinClickCallBack(data)
	local err = legendTeamUtil.checkJoinTeam(data)
	if gErrDef.Err_None == err then
		local teamId = data.tid or data.teamId
		legendTeamCtrl:reqApplyJoin(teamId)
		SoraDShowLoading(self)
	else
		self:errHandle(err)
	end
end
function legendTeamApplyListView:touchClickCallBack(single)
	for _, v in ipairs(self.scrollItems) do
		if v == single then
			v:setLaunched(not v:isLaunched())
		else
			v:setLaunched(false)
		end
	end
	self:updateScrollPos()
end
function legendTeamApplyListView:resetUI()
	self.scroll:setVisible(false)
	self.scroll:jumpToTop()
	self.nodeNotice:setVisible(false)
	self:closeShow2()
end
function legendTeamApplyListView:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function legendTeamApplyListView:refreshViewByData()
	for _, v in ipairs(self.scrollItems) do
		if v then
			v:refreshViewByData()
		end
	end
	self:updateScrollPos()
end
function legendTeamApplyListView:updateScrollList()
	self:recycleSingle()
	self:updateScrollData()
	self:updateScrollPos()
end
function legendTeamApplyListView:btnRefreshClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:initView()
	end
end
local namkVailidCheck = function(nickName)
	local __err
	if nickName then
		if string.utf8len(nickName) > 15 then
			__err = gErrDef.Err_NICKNAME
		elseif string.utf8len(nickName) < 1 then
			__err = gErrDef.Err_NICKNAME_MIN_SIZE
		elseif string.sub(nickName, 1, 1) == "(" then
			__err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(nickName, "$SoarDragon&") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\n") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\r") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, " ") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		else
			__err = gErrDef.Err_None
		end
	else
		__err = gErrDef.Err_NICKNAME
	end
	return __err
end
function legendTeamApplyListView:btnSearchClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local name = self.fieldText_name:getText()
		if string.utf8len(name) < 3 then
			if string.utf8len(name) <= 0 then
				SoraDShowMsgTip(i18n("remains_text_301"))
			else
				SoraDShowMsgTip(i18n("common_text_365"))
			end
			self:resetUI()
			self.nodeNotice:setVisible(true)
			self.labelNotice:setString(i18n("remains_text_301"))
			return
		elseif namkVailidCheck(name) ~= gErrDef.Err_None then
			SoraDShowMsgTip(i18n("notice_0071"))
			self:resetUI()
			self.nodeNotice:setVisible(true)
			self.labelNotice:setString(i18n("remains_text_301"))
			return
		end
		local kidStr = self.fieldText_kid:getText()
		local kid
		if 0 < string.len(kidStr) then
			kid = tonumber(kidStr)
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			if not kid or kid <= 0 or not kingdomCtrl:isFoundKingdomID(kid) then
				kid = gametop.playertop_:getKingdomID()
			end
		end
		legendTeamCtrl:reqGetTeamList(kid, nil, name)
		SoraDShowLoading(self)
	end
end
function legendTeamApplyListView:btnTeamCteateClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendTeamCreateView")
		panel:show()
	end
end
function legendTeamApplyListView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		legendTeamUtil.openHelp()
	end
end
function legendTeamApplyListView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function legendTeamApplyListView:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.kid
		self._queryInfo = true
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function legendTeamApplyListView:initChoosePanel()
	local showCount = #TEAM_VIEW_SUB_TYPE_CONFIG
	local sH = showCount * 50 + 25
	self.Image_choose:setContentSize(cc.size(self.Image_choose:getContentSize().width, sH))
	for i = 1, showCount do
		local item = self:createChooseItem(self.Node_choose, i, false, function(showViewSubType, type)
			self:closeShow2()
			self:initViewType(showViewSubType)
		end)
		item:addTo(self.Image_choose)
		item:setPosition(cc.p(self.Image_choose:getContentSize().width / 2, (showCount - i + 1) * 50 - 13))
	end
end
function legendTeamApplyListView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self.isShow2 then
		self.isShow2 = true
		self.spArrow:runAction(cc.RotateTo:create(0.3, 0))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, 1.0, 1.0))
	else
		self:closeShow2()
	end
end
function legendTeamApplyListView:closeShow2(...)
	if self.isShow2 then
		self.isShow2 = false
		self.spArrow:runAction(cc.RotateTo:create(0.3, 90))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, 1.0, 0.0))
	end
end
function legendTeamApplyListView:initViewType(showViewType)
	if self.showViewSubType == showViewType then
		return
	end
	self.showViewSubType = showViewType
	local info = TEAM_VIEW_SUB_TYPE_CONFIG[showViewType]
	self.txtViewType:setString(i18n(info.name))
	self:initView()
end
function legendTeamApplyListView:createChooseItem(widget, showViewSubType, showLock, handle)
	local item = widget:clone()
	item:setVisible(true)
	item.img_touch = SoraDGetChildByName(item, "img_touch")
	item.Text_name = SoraDGetChildByName(item, "Text_name")
	item.Image_line = SoraDGetChildByName(item, "Image_line")
	local info = TEAM_VIEW_SUB_TYPE_CONFIG[showViewSubType]
	item.Text_name:setString(i18n(info.name))
	item.img_touch:setTouchEnabled(true)
	item.img_touch:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		if handle then
			handle(showViewSubType, type)
		end
	end)
	if showViewSubType == #TEAM_VIEW_SUB_TYPE_CONFIG then
		item.Image_line:setVisible(false)
	end
	return item
end
function legendTeamApplyListView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function legendTeamApplyListView:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "ended" or event == "return" then
		local oriString = editBox:getText()
		if string.len(oriString) > 0 then
			local kid = tonumber(oriString)
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			if not kid or kid <= 0 or not kingdomCtrl:isFoundKingdomID(kid) then
				do
					local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
					kid = lordInfoCtrl:getMapSourceKid()
					local act = cca.callFunc(function()
						editBox:setText(kid)
					end)
					editBox:runAction(act)
				end
			end
		end
	end
end
function legendTeamApplyListView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		if self.fieldText_name.closeKeyBoard then
			self.fieldText_name:closeKeyBoard()
		end
		if self.fieldText_kid.closeIME then
			self.fieldText_kid:closeIME()
		end
		self:closePanel()
	end
end
function legendTeamApplyListView:rspDispatchBack(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("remains_text_25"))
	end
end
return legendTeamApplyListView

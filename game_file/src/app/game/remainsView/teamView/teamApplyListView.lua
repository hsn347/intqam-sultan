local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local remainsWarUtil = include("remainsWarUtil")
local teamApplyListView = class("teamApplyListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListView")
	end
	return target
end)
_ENV = "teamApplyListView"
;("teamApplyListView").TEAM_VIEW_TYPE_VIEW = 1
local _ENV, ("teamApplyListView").TEAM_VIEW_TYPE_SEARCH, TEAM_VIEW_TYPE = function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListView")
	end
	return target
end, 2, "teamApplyListView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListView")
	end
	return target
end).TEAM_VIEW_SUB_TYPE_ALLIANCE = 1
local _ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListView")
	end
	return target
end).TEAM_VIEW_SUB_TYPE_KINGDOM, TEAM_VIEW_SUB_TYPE = nil, 2, function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListView")
	end
	return target
end
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE], (nil).name = nil, "common_text_069"
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_KINGDOM], (nil).name = nil, "common_text_479"
local TEAM_VIEW_SUB_TYPE_CONFIG
function teamApplyListView:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_btn_01"))
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
	self.btnHelp:setVisible(IsArClient)
	self.nodeNotice = SoraDGetChildByName(self, "Center_Text_notice")
	self.nodeNotice:setVisible(false)
	self.btnTeamCreate = SoraDGetChildByName(self, "Button_team_cteate")
	self.btnTeamCreate:setTitleText(i18n("remains_btn_02"))
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
	self.fieldText_name = SoraDChangeToEditBox(self.fieldText_name)
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
function teamApplyListView:changeToEditBox(...)
	local editBox = ccui.EditBox:create(self.fieldText_kid:getContentSize(), "bg_transparent.png", ccui.TextureResType.plistType)
	editBox:setPosition(cc.p(self.fieldText_kid:getPositionX(), self.fieldText_kid:getPositionY()))
	editBox:setAnchorPoint(self.fieldText_kid:getAnchorPoint())
	editBox:setFontColor(display.COLOR_BLACK)
	editBox:setMaxLength(4)
	editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	editBox:addTo(self.fieldText_kid:getParent())
	editBox:setSwallowTouches(false)
	self.fieldText_kid:removeFromParent()
	self.fieldText_kid = editBox
end
function teamApplyListView:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		local btn = v.button
		btn:setTouchEnabled(not show)
		if show then
			btn:setTitleColor(cc.c3b(255, 200, 100))
			btn:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
			self:selectPanel(self.showViewType)
		else
			btn:setTitleColor(cc.c3b(100, 80, 40))
			btn:loadTextureNormal("btn_alliance_unchoose.png", ccui.TextureResType.plistType)
		end
	end
end
function teamApplyListView:selectPanel(showViewType)
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
function teamApplyListView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
function teamApplyListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_LIST_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_APPLY_TEAM", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_CAN_JOIN_BACK", handler(self, self.rspCanJoinTeam))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS", function(target, data)
		if not remainsTeamCtrl:isWarMatchBegin() then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK", function(target, data)
		if data.err ~= gErrDef.Err_None then
			self:req4Data()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
end
function teamApplyListView:initView()
	self.joinTeamData = nil
	self:req4Data()
end
function teamApplyListView:updateTeamInfo(target, data)
	if remainsTeamCtrl:isHasTeam() then
		local panel = SoraDCreatePanel("myTeamView")
		panel:show()
		self:removeFromParent()
	else
		self:refreshViewByData()
	end
end
function teamApplyListView:rspCanJoinTeam(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		if self.joinTeamData then
			local panel = SoraDCreatePanel("teamDispatchArmyView")
			panel:show()
			panel:initAddView(self.joinTeamData)
		end
	else
		self:errHandle(data.err)
	end
end
function teamApplyListView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = remainsWarUtil.getErrType(err)
	if errType == remainsWarUtil.errType.TIPS or errType == remainsWarUtil.errType.CLOSE or errType == remainsWarUtil.errType.REFRESH then
		remainsWarUtil.errShowTips(err)
		self:initView()
	end
end
function teamApplyListView:req4Data()
	self:resetUI()
	if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
		if self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE then
			if allianceMgr:hasJoinAlliance() then
				local aid = allianceMgr:getOwnAid()
				remainsTeamCtrl:reqGetTeamList(nil, aid, "")
				SoraDShowLoading(self)
			else
				self.nodeNotice:setVisible(true)
				self.labelNotice:setString(i18n("common_text_583"))
			end
		elseif self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_KINGDOM then
			local currentKid = gametop.playertop_:getKingdomID()
			remainsTeamCtrl:reqGetTeamList(currentKid, nil, "")
			SoraDShowLoading(self)
		end
	elseif self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH then
		self.nodeNotice:setVisible(true)
		self.labelNotice:setString(i18n("remains_text_301"))
		self.btnTeamCreate:setVisible(false)
	end
end
function teamApplyListView:initData(target, data)
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
			self.labelNotice:setString(i18n("remains_text_136"))
			SoraDSetTextWidthHeight(self.labelNotice, cc.size(620, 64))
			self.btnTeamCreate:setVisible(true)
			if remainsWarUtil.checkIsInRemainsXianXia() then
				self.btnTeamCreate:setTouchEnabled(false)
				self.btnTeamCreate:setBright(false)
			end
		else
			self.labelNotice:setString(i18n("remains_text_302"))
			self.btnTeamCreate:setVisible(false)
		end
	else
		table.sort(teamList, function(team1, team2)
			local teamMember1 = team1.memberList and #team1.memberList or 0
			local teamFull1 = teamMember1 >= _G.TEAM_MEMBER_MAX
			local teamMember2 = team2.memberList and #team2.memberList or 0
			local teamFull2 = teamMember2 >= _G.TEAM_MEMBER_MAX
			if teamFull1 ~= teamFull2 then
				return teamFull2
			end
			if teamMember1 ~= teamMember2 then
				return teamMember1 > teamMember2
			end
			return team1.tid < team2.tid
		end)
		self.teamList = teamList
		self.nodeNotice:setVisible(false)
		self.scroll:setVisible(true)
		self:updateScrollList()
	end
end
function teamApplyListView:updateScrollPos()
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
function teamApplyListView:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = SoraDCreatePanel("teamApplyListSingle")
		single:addTo(self.scroll)
	end
	single:setVisible(true)
	return single
end
function teamApplyListView:updateScrollData()
	for _, v in ipairs(self.teamList) do
		local single = self:getSingle()
		single:setScroll(self.scroll)
		single:initData(v)
		single:setHandle(handler(self, self.touchClickCallBack))
		single:setJoinHandle(handler(self, self.joinClickCallBack))
		single:setPlayerInfo(handler(self, self.queryPlayerInfo))
		table.insert(self.scrollItems, single)
	end
end
function teamApplyListView:joinClickCallBack(data)
	self.joinTeamData = data
	local panel = SoraDCreatePanel("teamDispatchArmyView")
	panel:show()
	panel:initAddView(self.joinTeamData)
end
function teamApplyListView:touchClickCallBack(single)
	for _, v in ipairs(self.scrollItems) do
		if v == single then
			v:setLaunched(not v:isLaunched())
		else
			v:setLaunched(false)
		end
	end
	self:updateScrollPos()
end
function teamApplyListView:resetUI()
	self.scroll:setVisible(false)
	self.scroll:jumpToTop()
	self.nodeNotice:setVisible(false)
	self:closeShow2()
end
function teamApplyListView:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function teamApplyListView:refreshViewByData()
	for _, v in ipairs(self.scrollItems) do
		if v then
			v:refreshViewByData()
		end
	end
	self:updateScrollPos()
end
function teamApplyListView:updateScrollList()
	self:recycleSingle()
	self:updateScrollData()
	self:updateScrollPos()
end
function teamApplyListView:btnRefreshClickCallBack(button, type)
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
function teamApplyListView:btnSearchClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local name = self.fieldText_name:getText()
		if string.utf8len(name) < 3 then
			SoraDShowMsgTip(i18n("common_text_365"))
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
		if string.len(kidStr) > 0 then
			kid = tonumber(kidStr)
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			if not kid or kid <= 0 or not kingdomCtrl:isFoundKingdomID(kid) then
				kid = gametop.playertop_:getKingdomID()
			end
		end
		remainsTeamCtrl:reqGetTeamList(kid, nil, name)
		SoraDShowLoading(self)
	end
end
function teamApplyListView:btnTeamCteateClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("teamDispatchArmyView")
		panel:show()
		_ENV = nil
		panel:initCreateView(nil)
		self:removeFromParent()
	end
end
function teamApplyListView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function teamApplyListView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function teamApplyListView:queryPlayerInfo(data)
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
function teamApplyListView:initChoosePanel()
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
function teamApplyListView:btnClickCallback(button, type)
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
function teamApplyListView:closeShow2(...)
	if self.isShow2 then
		self.isShow2 = false
		self.spArrow:runAction(cc.RotateTo:create(0.3, 90))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, 1.0, 0.0))
	end
end
function teamApplyListView:initViewType(showViewType)
	if self.showViewSubType == showViewType then
		return
	end
	self.showViewSubType = showViewType
	local info = TEAM_VIEW_SUB_TYPE_CONFIG[showViewType]
	self.txtViewType:setString(i18n(info.name))
	self:initView()
end
function teamApplyListView:createChooseItem(widget, showViewSubType, showLock, handle)
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
function teamApplyListView:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		local oldInput = editBox:getText()
		if oldInput == "" then
			self.newInput = ""
		else
			local newInput = math.floor(tonumber(string.match(oldInput, "([%d]+)")) or 0)
			if newInput <= 0 then
				newInput = ""
			end
			self.newInput = newInput
		end
	end
end
function teamApplyListView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function teamApplyListView:close(ref, type)
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
return teamApplyListView

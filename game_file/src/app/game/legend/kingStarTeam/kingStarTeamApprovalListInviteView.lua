local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local legendTeamUtil = include("legendTeamUtil")
local kingStarTeamApprovalListInviteView = class("kingStarTeamApprovalListInviteView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApprovalListInviteView")
	end
	local base = include("kingStarTeamApprovalListBase")
	target = base.new(target)
	return target
end)
local TEAM_APPROVAL_TYPE_INVITED = _G.TEAM_APPROVAL_TYPE_INVITED
function _ENV(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApprovalListInviteView")
	end
	local base = include("kingStarTeamApprovalListBase")
	target = base.new(target)
	return target
end
;(function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApprovalListInviteView")
	end
	local base = include("kingStarTeamApprovalListBase")
	target = base.new(target)
	return target
end).TEAM_VIEW_TYPE_VIEW = 1
local _ENV, (function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApprovalListInviteView")
	end
	local base = include("kingStarTeamApprovalListBase")
	target = base.new(target)
	return target
end).TEAM_VIEW_TYPE_SEARCH, TEAM_VIEW_TYPE = nil, 2, function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApprovalListInviteView")
	end
	local base = include("kingStarTeamApprovalListBase")
	target = base.new(target)
	return target
end
;(nil).TEAM_VIEW_SUB_TYPE_ALLIANCE = 1
local _ENV, (nil).TEAM_VIEW_SUB_TYPE_FRIEND, TEAM_VIEW_SUB_TYPE = nil, 2, nil
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE], (nil).name = nil, "common_text_069"
_ENV = nil
;(nil)[TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_FRIEND], (nil).name = nil, "friend_name_01"
local TEAM_VIEW_SUB_TYPE_CONFIG
function kingStarTeamApprovalListInviteView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_189"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHelp:setVisible(IsArClient)
	self.btnRefreshChoose = SoraDGetChildByName(self, "Button_refresh")
	self.btnRefreshChoose:setTitleText(i18n("common_text_911"))
	self.btnRefreshChoose:addTouchEventListener(handler(self, self.btnRefreshClickCallBack))
	SoraDAutoSizeButtonTextByContent(self.btnRefreshChoose)
	self.nodeView = SoraDGetChildByName(self, "Top_Node_view")
	self.txtViewType = SoraDGetChildByName(self, "Text_view_type")
	self.spArrow = SoraDGetChildByName(self, "Sprite_arrow_l")
	self.spArrow:setRotation(180)
	self.Image_touch = SoraDGetChildByName(self, "Image_touch")
	self.Image_touch:setTouchEnabled(true)
	self.Image_touch:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Image_choose = SoraDGetChildByName(self, "Image_choose")
	self.Image_choose:setScaleY(0)
	self.nodeSearch = SoraDGetChildByName(self, "Top_Node_search")
	self.nodeTips = SoraDGetChildByName(self, "Center_node_tips")
	self.nodeTips:setVisible(false)
	_ENV, self.labelNotice = SoraDGetChildByName(self, "Text_notice"), SoraDGetChildByName(self, "Text_notice")
	_ENV = "Text_notice"
	;("Text_notice").title = "Button_View"
	SoraDGetChildByName(self, "Text_notice")[TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW], ("Text_notice").titleText = "Text_notice", "common_text_969"
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
	self.txtSearchName:setString(i18n("common_text_264"))
	self.txtSearchKid = SoraDGetChildByName(self, "Text_search_kid")
	self.txtSearchKid:setString(i18n("common_text_4446"))
	self.fieldText_name = SoraDGetChildByName(self, "TextField_search_name")
	self.fieldText_name = SoraDChangeToEditBox(self.fieldText_name)
	self.fieldText_kid = SoraDGetChildByName(self, "TextField_search_kid")
	self.btnSearch = SoraDGetChildByName(self, "Button_Search_begin")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	SoraDAutoSizeButtonTextByContent(self.btnSearch)
	self.nodeSetting = SoraDGetChildByName(self, "Node_setting")
	self.nodeTeamInfo = SoraDGetChildByName(self, "Node_team_info")
	self.checkSettting = SoraDGetChildByName(self, "CheckBox_setting")
	self.checkSettting:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.txtSetting = SoraDGetChildByName(self, "Text_setting")
	self.txtSetting:setString(i18n("remains_text_308"))
	self.tableData = tableData
	self.showViewType = nil
	self.showViewSubType = nil
	self.viewType = TEAM_APPROVAL_TYPE_INVITED
	self:changeToEditBox()
	self:initShowBtn(TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW)
end
function kingStarTeamApprovalListInviteView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_INVITED_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INVITED_BACK", handler(self, self.rspInvited))
	self:onMessageListener_common()
end
function kingStarTeamApprovalListInviteView:rspInvited(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("notice_0092"))
		self:addIgnoreUID(data.uid)
	end
end
function kingStarTeamApprovalListInviteView:initInvitedView()
	self:req4Data()
end
function kingStarTeamApprovalListInviteView:req4Data()
	self:resetUI()
	if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
		if self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE then
			if allianceMgr:hasJoinAlliance() then
				local isFilter = self.checkSettting:isSelected()
				kingStarTeamCtrl:reqGetAllianceList(isFilter)
				SoraDShowLoading(self)
			else
				self.nodeTips:setVisible(true)
				self.labelNotice:setString(i18n("common_text_583"))
			end
		elseif self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_FRIEND then
			local isFilter = self.checkSettting:isSelected()
			kingStarTeamCtrl:reqGetFriendList(isFilter)
			SoraDShowLoading(self)
		end
		self.nodeSetting:setVisible(true)
		self.nodeTeamInfo:setPositionX(SoraDFPosX(-160, 0))
	elseif self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH then
		self.nodeTips:setVisible(true)
		self.labelNotice:setString(i18n("remains_text_303"))
		self.nodeSetting:setVisible(false)
		self.nodeTeamInfo:setPositionX(0)
	end
end
function kingStarTeamApprovalListInviteView:initShowBtn(showViewType)
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
function kingStarTeamApprovalListInviteView:selectPanel(showViewType)
	if showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW then
		self.nodeSearch:setVisible(false)
		self.nodeView:setVisible(true)
		self.showViewSubType = nil
		if allianceMgr:hasJoinAlliance() then
			self:initViewType(TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE)
		else
			self:initViewType(TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_FRIEND)
		end
	elseif showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEARCH then
		self.nodeSearch:setVisible(true)
		self.nodeView:setVisible(false)
		self:initInvitedView()
	end
end
function kingStarTeamApprovalListInviteView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
function kingStarTeamApprovalListInviteView:joinClickCallBack(data)
	kingStarTeamCtrl:reqInviteJoinTeam(data.uid, data.kid)
	SoraDShowLoading(self)
end
function kingStarTeamApprovalListInviteView:btnRefreshClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:req4Data()
	end
end
function kingStarTeamApprovalListInviteView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function kingStarTeamApprovalListInviteView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS then
		legendTeamUtil.errShowTips(err)
	elseif errType == legendTeamUtil.errType.CLOSE then
		legendTeamUtil.errShowTips(err)
		self:removeFromParent()
	elseif errType == legendTeamUtil.errType.REFRESH then
		self:req4Data()
	end
end
function kingStarTeamApprovalListInviteView:resetUI()
	self.scroll:setVisible(false)
	self.scroll:jumpToTop()
	self.nodeTips:setVisible(false)
	self:closeShow2()
end
function kingStarTeamApprovalListInviteView:initChoosePanel()
	local showCount = #TEAM_VIEW_SUB_TYPE_CONFIG
	local sH = showCount * 60 + 5
	self.Image_choose:setContentSize(cc.size(self.Image_choose:getContentSize().width, sH))
	self.items, TEAM_VIEW_SUB_TYPE_CONFIG = self.Image_choose.setContentSize, self.Image_choose.setContentSize
	for i = 1, showCount do
		local item = self:createChooseItem(self.Node_choose, i, false, function(showViewSubType, type)
			self:closeShow2()
			self:initViewType(showViewSubType)
		end)
		item:addTo(self.Image_choose)
		item:setPosition(cc.p(self.Image_choose:getContentSize().width / 2, (showCount - i + 1) * 60 - 30))
		table.insert(self.items, item)
	end
end
function kingStarTeamApprovalListInviteView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self.isShow2 then
		self.isShow2 = true
		self.spArrow:runAction(cc.RotateTo:create(0.3, 0))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, 1.0, 1.0))
		for i, v in ipairs(self.items) do
			v.Text_name:setColor(self.showViewSubType == i and cc.c3b(255, 239, 167) or cc.c3b(182, 173, 151))
			v.Image_line:setVisible(self.showViewSubType == i)
		end
	else
		self:closeShow2()
	end
end
function kingStarTeamApprovalListInviteView:closeShow2()
	if self.isShow2 then
		self.isShow2 = false
		self.spArrow:runAction(cc.RotateTo:create(0.3, 180))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, 1.0, 0.0))
		for i, v in ipairs(self.items) do
			v.Text_name:setColor(self.showViewSubType == i and cc.c3b(255, 239, 167) or cc.c3b(182, 173, 151))
			v.Image_line:setVisible(self.showViewSubType == i)
		end
	end
end
function kingStarTeamApprovalListInviteView:initViewType(showViewType)
	if self.showViewSubType == showViewType then
		return
	end
	self.showViewSubType = showViewType
	local info = TEAM_VIEW_SUB_TYPE_CONFIG[showViewType]
	self.txtViewType:setString(i18n(info.name))
	self:initInvitedView()
end
function kingStarTeamApprovalListInviteView:createChooseItem(widget, showViewSubType, showLock, handle)
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
	return item
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
function kingStarTeamApprovalListInviteView:btnSearchClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local name = self.fieldText_name:getString()
		if string.utf8len(name) < 3 then
			SoraDShowMsgTip(i18n("common_text_365"))
			self:resetUI()
			self.nodeTips:setVisible(true)
			self.labelNotice:setString(i18n("remains_text_303"))
			return
		elseif namkVailidCheck(name) ~= gErrDef.Err_None then
			SoraDShowMsgTip(i18n("notice_0071"))
			self:resetUI()
			self.nodeTips:setVisible(true)
			self.labelNotice:setString(i18n("remains_text_303"))
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
		kingStarTeamCtrl:reqGetUserList(kid, name)
		SoraDShowLoading(self)
	end
end
function kingStarTeamApprovalListInviteView:updateShowList()
	for _, v in pairs(self.teamList) do
		if not v.hasInvite and self.ignoreUID[v.uid] then
			v.hasInvite = true
		end
	end
	self:updateListMember(self.teamList)
end
function kingStarTeamApprovalListInviteView:updateListMember(showList)
	self.showList = showList
	if not self.showList or not next(self.showList) then
		self.nodeTips:setVisible(true)
		if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_VIEW and self.showViewSubType == TEAM_VIEW_SUB_TYPE.TEAM_VIEW_SUB_TYPE_ALLIANCE then
			self.labelNotice:setString(i18n("remains_text_138"))
		else
			self.labelNotice:setString(i18n("common_text_4452"))
		end
		self.scroll:setVisible(false)
	else
		self.nodeTips:setVisible(false)
		self.scroll:setVisible(true)
		self:updateScrollList()
		self:updateViewByData()
	end
	self:updateRemain()
end
function kingStarTeamApprovalListInviteView:changeToEditBox(...)
	local editBox = ccui.EditBox:create(self.fieldText_kid:getContentSize(), "bg_transparent.png", ccui.TextureResType.plistType)
	editBox:setPosition(cc.p(self.fieldText_kid:getPositionX(), self.fieldText_kid:getPositionY()))
	editBox:setAnchorPoint(self.fieldText_kid:getAnchorPoint())
	editBox:setFontColor(display.COLOR_BLACK)
	editBox:setMaxLength(4)
	editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	editBox:addTo(self.fieldText_kid:getParent())
	editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
	editBox:setSwallowTouches(false)
	self.fieldText_kid:removeFromParent()
	self.fieldText_kid = editBox
end
function kingStarTeamApprovalListInviteView:OnInputChangeByEditBoxEnd(event, editBox)
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
function kingStarTeamApprovalListInviteView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function kingStarTeamApprovalListInviteView:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected or type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self:req4Data()
	end
end
function kingStarTeamApprovalListInviteView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		if self.fieldText_name.closeIME then
			self.fieldText_name:closeIME()
		end
		if self.fieldText_kid.closeIME then
			self.fieldText_kid:closeIME()
		end
		self:closePanel()
	end
end
return kingStarTeamApprovalListInviteView

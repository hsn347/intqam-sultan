local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local buildLogic = include("buildLogic")
local kohMigrateRead = include("kohMigrateRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateViewPanel = class("kohMigrateViewPanel", baseFguiPanel)
_ENV = "kohMigrateViewPanel"
;("kohMigrateViewPanel").KINGDOMINFO = 1
;("kohMigrateViewPanel").KINGDOMLIST = 2
local ("kohMigrateViewPanel").APPLYLIST, pageType = 3, "kohMigrateViewPanel"
function kohMigrateViewPanel:ctor(...)
	kohMigrateViewPanel.super.ctor(self, ...)
	print("kohMigrateViewPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE
	self.playerType = kohMigrateCtrl:getMyPlayerType()
end
function kohMigrateViewPanel:onInit()
	print("=======kohMigrateViewPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	local kingdomID = gametop.playertop_:getKingdomID()
	_ENV = handler(self, self.onClickClose)
	_ENV, _ENV, handler(self, self.onClickClose).var1 = "#%d", string.format("#%d", kingdomID), string.format("#%d", kingdomID)
	_ENV, string.format("#%d", kingdomID).var1, ("#%d").color = "#%d", "#%d", "#FFD719"
	string.format("#%d", kingdomID).__default, ("#%d").color = "#%d", "#FEF9EC"
	local kingStr = i18n_html("across_move_myKingdom_name", handler(self, self.onClickClose), (string.format("#%d", kingdomID)))
	self.fields.Text_king:setString(kingStr)
	self.fields.Button_king:addClickListener(handler(self, self.btnKingdomDetailClick))
	self.isNewKingdom = kohMigrateRead.checkIsNewkingdom(kingdomID)
	self.fields.Button_king:setVisible(not self.isNewKingdom)
	local lvLimit = kohMigrateCtrl:getLvLimit()
	local buildLvStr = buildLogic.getBuildLvStr(lvLimit)
	_ENV = handler(self, self.btnKingdomDetailClick)
	handler(self, self.btnKingdomDetailClick).var1 = buildLvStr
	self.fields.Text_lv:setString(i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick)))
	if self.playerType == gKohMigratePlayerType.T1 then
		local legend = kohMigrateCtrl:getMyLegend()
		_ENV = i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick))
		i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick)).legend = string.formatnumberthousands(legend)
		self.fields.Text_power:setString(i18n("migrant_move_text21", i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick))))
	else
		local beginStrength = kohMigrateCtrl:getBeginStrength()
		_ENV = i18n("migrant_move_text21", i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick)))
		i18n("migrant_move_text21", i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick))).power = string.formatnumberthousands(beginStrength)
		self.fields.Text_power:setString(i18n("migrant_move_text20", i18n("migrant_move_text21", i18n("arossDesc_text_012", handler(self, self.btnKingdomDetailClick)))))
	end
	self.ccs_tab = self.fields.com_Tab
	self.fields.List_kingdom:setItemRenderer(handler(self, self.onKingdomItemRenderer))
	self.fields.List_apply:setItemRenderer(handler(self, self.onApplyItemRenderer))
	self.fields.Button_privilege:setString(i18n("across_move_kingPower_title"))
	self.fields.Button_privilege:addClickListener(handler(self, self.btnPrivilegeClick))
	self.fields.Button_mobility:setString(i18n("across_outAndIn_title"))
	self.fields.Button_mobility:addClickListener(handler(self, self.btnMobilityClick))
	self.fields.Button_chat:setString(i18n("common_text_4673"))
	self.fields.Button_chat:addClickListener(handler(self, self.btnChatRoomClick))
	self.fields.Button_rank:setString(i18n("migrant_move_text2"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnLegendRankClick))
	self.fields.Button_group:setString(i18n("arossDesc_text_015"))
	self.fields.Button_group:addClickListener(handler(self, self.btnGroupClick))
	self.fields.Group_btns:setPivot(1, 0)
	if not SoraDFIsRA() then
		_UPVALUE6_ = self.fields.Group_btns
		self.fields.Group_btns[1] = self.fields.Text_king
		self.fields.Group_btns[2] = self.fields.Button_king
		self.fields.Group_btns[3] = self.fields.Text_lv
		self.fields.Group_btns[4] = self.fields.Text_power
		self.fields.Group_btns[5] = self.fields.Com_itemNeed
		self.fields.Group_btns[6] = self.fields.Group_btns
		for __, v in pairs(self.fields.Group_btns) do
			v:fixPos()
		end
		self.fields.Imgae_top:fix()
		self.fields.Com_itemNeed:fixChildrenPos()
	end
end
function kohMigrateViewPanel:onShow()
	print("=======kohMigrateViewPanel:onShow")
	self:refreshTabBtns()
	self:refreshPrivilegeBtn()
end
function kohMigrateViewPanel:onKingdomItemRenderer(index, obj)
	local data = self.groupList_kingdom[index + 1]
	obj:initData(data, index + 1)
end
function kohMigrateViewPanel:onApplyItemRenderer(index, obj)
	local data = self.groupList_apply[index + 1]
	obj:initData(data, -index - 1)
end
function kohMigrateViewPanel:refreshPrivilegeBtn(...)
	if not self.isNewKingdom and kohMigrateCtrl:isShowPrivilegeBtn() then
		self.fields.Button_privilege:setVisible(true)
		self.fields.Button_privilege:setReddot(kohMigrateCtrl:getRecvApplyUnRead() or kohMigrateCtrl:isKingPrivilegeRead())
	else
		self.fields.Button_privilege:setVisible(false)
	end
	self.fields.Group_btns:ensureBoundsCorrect()
end
function kohMigrateViewPanel:refreshTabBtns(...)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("migrant_move_text5")
	_ENV, (nil)[1], (nil).tag = nil, nil, pageType.KINGDOMINFO
	;(nil).title = i18n("across_kingdom_list_title")
	_ENV, (nil)[2], (nil).tag = nil, nil, pageType.KINGDOMLIST
	;(nil).title = i18n("friend_btn_03")
	_ENV, (nil)[3], (nil).tag = nil, nil, pageType.APPLYLIST
	local tabsetArray
	;(nil).defaultClick = pageType.KINGDOMINFO
	;(nil).tabsetArray = tabsetArray
	local (nil).callback, param = handler(self, self.btnTabClick), nil
	self.ccs_tab:initView(param)
	if param.defaultClick ~= pageType.APPLYLIST and (kohMigrateCtrl:getSendApplyUnRead() or kohMigrateCtrl:getRecvSpecInviteUnRead()) then
		self.ccs_tab:setBtnRedDot(pageType.APPLYLIST, true)
	end
	if param.defaultClick ~= pageType.APPLYLIST then
		kohMigrateCtrl:reqPlayerExtraApplyList()
	end
end
function kohMigrateViewPanel:refreshCooling(...)
	self.fields.Node_cooling:setVisible(false)
	local lefttime = kohMigrateCtrl:getMigrateCDLeftTime()
	if 0 < lefttime then
		self.fields.Node_cooling:setVisible(true)
		self.fields.Node_cooling = SoraDCreateTimerLabel(self, self.fields.Node_cooling)
		self.fields.Node_cooling:setTimeLast(function(timeStr)
			return i18n("across_moveCD_name")
		end)
		self.fields.Node_cooling:setTimeEndListener(function()
			self.fields.Node_cooling:setVisible(false)
		end)
		self.fields.Node_cooling:beginTime(lefttime)
	end
end
function kohMigrateViewPanel:btnHelpClick()
	SoraDPlaySound()
	uiManager:show("kohMigrateHelpView")
end
function kohMigrateViewPanel:btnKingdomDetailClick()
	SoraDPlaySound()
	uiManager:show("kohMigrateKingdomDetail")
end
function kohMigrateViewPanel:btnPrivilegeClick()
	SoraDPlaySound()
	if not kohMigrateCtrl:isShowPrivilegeBtn() then
		SoraDShowMsgTip(i18n("tips_across_kingPowerLimit"))
		return
	end
	uiManager:show("kohMigratePrivilegeView")
end
function kohMigrateViewPanel:btnMobilityClick()
	SoraDPlaySound()
	uiManager:show("kohMigrateMobilityView")
end
function kohMigrateViewPanel:btnTabClick(tag, name)
	self.curTabIndex = tag
	local showKingdomList = tag == pageType.KINGDOMLIST
	self.fields.List_kingdom:setVisible(showKingdomList)
	local showApply = tag == pageType.APPLYLIST
	self.fields.List_apply:setVisible(showApply)
	local showInfo = tag == pageType.KINGDOMINFO
	self.fields.Com_kingdomInfo:setVisible(showInfo)
	if tag == pageType.KINGDOMINFO then
		SoraDShowLoading(self)
		kohMigrateCtrl:reqKingdomData()
	elseif tag == pageType.KINGDOMLIST then
		SoraDShowLoading(self)
		kohMigrateCtrl:reqKingdomList()
	elseif tag == pageType.APPLYLIST then
		SoraDShowLoading(self)
		self.waitKingdomListBack = false
		kohMigrateCtrl:reqKingdomList(true)
		self.waitApplyListBack = false
		kohMigrateCtrl:reqPlayerExtraApplyList()
		if kohMigrateCtrl:getSendApplyUnRead() or kohMigrateCtrl:getRecvSpecInviteUnRead() then
			self.ccs_tab:setBtnRedDot(pageType.APPLYLIST, false)
		end
	end
	if tag == pageType.KINGDOMLIST or tag == pageType.APPLYLIST then
		self:refreshCooling()
	else
		self.fields.Node_cooling:setVisible(false)
	end
end
function kohMigrateViewPanel:refreshRedPoint(target, event)
	self:refreshPrivilegeBtn()
	if event.notifyType == gKohMigrateMsgType.isSendApplyUnRead then
		if self.curTabIndex == pageType.APPLYLIST then
			self.waitApplyListBack = false
			kohMigrateCtrl:reqPlayerExtraApplyList()
			SoraDShowLoading(self)
			if kohMigrateCtrl:getSendApplyUnRead() then
				kohMigrateCtrl:setSendApplyUnRead(false)
			end
		elseif kohMigrateCtrl:getSendApplyUnRead() then
			self.ccs_tab:setBtnRedDot(pageType.APPLYLIST, true)
		end
		return
	end
	if event.notifyType == gKohMigrateMsgType.isRecvSpecInviteUnRead or event.notifyType == gKohMigrateMsgType.removeRecvSpecInvite then
		if self.curTabIndex == pageType.APPLYLIST then
			self.waitKingdomListBack = false
			kohMigrateCtrl:reqKingdomList(true)
			SoraDShowLoading(self)
			if kohMigrateCtrl:getRecvSpecInviteUnRead() then
				kohMigrateCtrl:setRecvSpecInviteUnRead(false)
			end
		elseif kohMigrateCtrl:getRecvSpecInviteUnRead() then
			self.ccs_tab:setBtnRedDot(pageType.APPLYLIST, true)
		end
		return
	end
	if event.notifyType == gKohMigrateMsgType.isRecvApplyUnRead then
		self.fields.Button_privilege:setReddot(kohMigrateCtrl:getRecvApplyUnRead() or kohMigrateCtrl:isKingPrivilegeRead())
		return
	end
end
function kohMigrateViewPanel:refreshKingdomList(...)
	if self.curTabIndex == pageType.APPLYLIST then
		self.waitKingdomListBack = true
		if self.waitKingdomListBack and self.waitApplyListBack then
			SoraDCloseLoading(self)
			self:updateAllpyList()
		end
		return
	end
	if self.curTabIndex ~= pageType.KINGDOMLIST then
		return
	end
	SoraDCloseLoading(self)
	local kingdomList = kohMigrateCtrl:getKingdomList()
	local pageType, invitedList = kohMigrateCtrl, kohMigrateCtrl
	local pageType, otherList
	local _group = 1
	for i, v in ipairs(kingdomList) do
		if not v.isSpecInvited and not kohMigrateRead.checkIsNewkingdom(v.kid) then
			if not otherList[_group] then
				pageType = otherList[_group]
			end
			otherList[_group] = otherList[_group]
			table.insert(otherList[_group], v.kid)
			if 10 <= #otherList[_group] then
				_group = _group + 1
			end
		end
	end
	local pageType, groupList = (for generator), ipairs(kingdomList)
	for i, v in ipairs(otherList) do
		pageType = nil
		;(nil).type = 2
		;(nil).kingdomList = v
		table.insert(groupList, nil)
	end
	self.groupList_kingdom = groupList
	self.fields.List_kingdom:setNumItems(#self.groupList_kingdom)
end
function kohMigrateViewPanel:refreshApplyList(...)
	if self.curTabIndex ~= pageType.APPLYLIST then
		return
	end
	self.waitApplyListBack = true
	if self.waitKingdomListBack and self.waitApplyListBack then
		SoraDCloseLoading(self)
		self:updateAllpyList()
	end
end
function kohMigrateViewPanel:updateAllpyList(...)
	local kingdomList = kohMigrateCtrl:getKingdomList()
	local kohMigrateCtrl, privilegeList = kohMigrateCtrl, kohMigrateCtrl
	for i, v in ipairs(kingdomList) do
		if v.isSpecInvited then
			table.insert(privilegeList, v.kid)
		end
	end
	table.sort(privilegeList, function(akid, bkid)
		local aInviteTime = kohMigrateCtrl:getKingdomDataByID(akid).inviteTime or 0
		local bInviteTime = kohMigrateCtrl:getKingdomDataByID(bkid).inviteTime or 0
		if aInviteTime ~= bInviteTime then
			return aInviteTime > bInviteTime
		end
		return akid < bkid
	end)
	local kohMigrateCtrl, groupList = table.sort, table.sort
	local showRedPoint = kohMigrateCtrl:getRecvSpecInviteUnRead()
	kohMigrateCtrl = nil
	;(nil).type = 0
	;(nil).kingdomList = privilegeList
	;(nil).showRedPoint = showRedPoint
	table.insert(groupList, nil)
	local selfApplyList = kohMigrateCtrl:getSelfApplyList()
	local showRedPoint = kohMigrateCtrl:getSendApplyUnRead()
	kohMigrateCtrl = privilegeList
	privilegeList.type = 3
	privilegeList.kingdomList = selfApplyList
	privilegeList.showRedPoint = showRedPoint
	table.insert(groupList, privilegeList)
	self.groupList_apply = groupList
	self.fields.List_apply:setNumItems(#self.groupList_apply)
	kohMigrateCtrl:setRecvSpecInviteUnRead(false)
	kohMigrateCtrl:setSendApplyUnRead(false)
end
function kohMigrateViewPanel:btnChatRoomClick()
	SoraDPlaySound()
	local enterChatRoom = function()
		if kohMigrateCtrl:getChannelID() ~= 0 then
			self:onMsgEnterChatRoom()
		else
			kohMigrateCtrl:reqEnterChatRoom()
			SoraDShowLoading(self)
		end
	end
	if kohMigrateCtrl:getIsEnterChatRoom() then
		enterChatRoom()
	else
		local constantRead = include("constantRead")
		local cost = constantRead.getConstValue("KOH_MIGRATE_ENTER_CHAT_ROOM_NEED_GOLD", 0)
		_ENV = nil
		;(nil).num = cost
		local showMsg = i18n("common_text_4674", nil)
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if exitType == MSGBOX_CALLBACK_YES and SoraDEnoughGold(cost) then
				enterChatRoom()
			end
		end)
	end
end
function kohMigrateViewPanel:onMsgEnterChatRoom(...)
	SoraDCloseLoading(self)
	local panel = SoraDCreatePanel("teamChatView")
	panel:initKohMigrateChatRoom()
	panel:show()
end
function kohMigrateViewPanel:btnLegendRankClick(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateRank")
end
function kohMigrateViewPanel:btnGroupClick(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateKidGroup")
end
function kohMigrateViewPanel:onMsgUpdateKingdomData(...)
	if self.curTabIndex ~= pageType.KINGDOMINFO then
		return
	end
	SoraDCloseLoading(self)
	self.fields.Com_kingdomInfo:initKingdomData()
end
return kohMigrateViewPanel

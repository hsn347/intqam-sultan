local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamApprovalListView = class("legendTeamApprovalListView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("legendTeamApprovalListView")
	end
	local base = include("legendTeamApprovalListBase")
	target = base.new(target)
	return target
end)
local TEAM_APPROVAL_TYPE_ADD = _G.TEAM_APPROVAL_TYPE_ADD
function legendTeamApprovalListView:ctor()
	self.isHideCurrentSceneView = true
	self.isBatch = false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_title_02"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnRefresh = SoraDGetChildByName(self, "Button_refresh")
	self.btnRefresh:setTitleText(i18n("common_text_911"))
	self.btnRefresh:addTouchEventListener(handler(self, self.btnRefreshClickCallBack))
	self.btnBatch = SoraDGetChildByName(self, "Button_batch")
	self.btnBatch:setTitleText(i18n("legendaryking_text_84"))
	self.btnBatch:addTouchEventListener(handler(self, self.btnBatchClickCallBack))
	self.btnReject = SoraDGetChildByName(self, "Button_reject")
	self.btnReject:setTitleText(i18n("legendaryking_text_85"))
	self.btnReject:addTouchEventListener(handler(self, self.btnRejectClickCallBack))
	self.btnReject:setVisible(false)
	self.btnAgree = SoraDGetChildByName(self, "Button_agree")
	self.btnAgree:setTitleText(i18n("legendaryking_text_86"))
	self.btnAgree:addTouchEventListener(handler(self, self.btnAgreeClickCallBack))
	self.btnAgree:setVisible(false)
	self.btnInvite = SoraDGetChildByName(self, "Button_invite")
	self.btnInvite:setTitleText(i18n("remains_btn_10"))
	self.btnInvite:addTouchEventListener(handler(self, self.btnInviteClickCallBack))
	self.nodeTips = SoraDGetChildByName(self, "Center_node_tips")
	self.nodeTips:setVisible(false)
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	SoraDSetTextWidthHeight(self.labelNotice, cc.size(550, 40))
	self.btnHelp:setVisible(IsArClient)
	self.viewType = TEAM_APPROVAL_TYPE_ADD
	self:req4Data()
end
function legendTeamApprovalListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_ADD_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_AGREE_BACK", handler(self, self.rspAgree))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INFO", handler(self, self.onMsgUpdateApprovalInfo))
	self:onMessageListener_common()
end
function legendTeamApprovalListView:rspAgree(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("remains_text_49"))
		self:addIgnoreUID(data.uid)
	end
end
function legendTeamApprovalListView:req4Data()
	legendTeamCtrl:reqGetApplyList()
	SoraDShowLoading(self)
end
function legendTeamApprovalListView:joinClickCallBack(data, isReject)
	if isReject then
		legendTeamCtrl:getMyTeamInfo():reqTeamRejectApply(data.uid)
	else
		legendTeamCtrl:reqAgreeApplyJoin(data.uid)
	end
	SoraDShowLoading(self)
end
function legendTeamApprovalListView:btnRefreshClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:req4Data()
	end
end
function legendTeamApprovalListView:btnBatchClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendTeamApprovalListView")
		panel:setIsBatch(true)
		panel:show()
	end
end
function legendTeamApprovalListView:btnRejectClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uidList = self:getSelectUidList()
		if #uidList <= 0 then
			SoraDShowMsgTip(i18n("legendaryking_text_90"))
			return
		end
		SoraDShowMsgBox(i18n("legendaryking_text_89"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				legendTeamCtrl:getMyTeamInfo():reqTeamRejectApplyBatch(uidList)
				SoraDShowLoading(self)
			end
		end)
	end
end
function legendTeamApprovalListView:btnAgreeClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uidList = self:getSelectUidList()
		if #uidList <= 0 then
			SoraDShowMsgTip(i18n("legendaryking_text_90"))
			return
		end
		local remainNum = legendTeamCtrl:getTeamRemainNum()
		if remainNum < #uidList then
			SoraDShowMsgTip(i18n("legendaryking_text_88"))
			return
		end
		SoraDShowMsgBox(i18n("legendaryking_text_87"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				legendTeamCtrl:getMyTeamInfo():reqTeamAgreeApplyBatch(uidList)
				SoraDShowLoading(self)
			end
		end)
	end
end
function legendTeamApprovalListView:btnInviteClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendTeamApprovalListInviteView")
		panel:show()
		self:removeFromParent()
	end
end
function legendTeamApprovalListView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function legendTeamApprovalListView:errHandle(err)
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
function legendTeamApprovalListView:updateShowList()
	local _ENV, showList
	for _, v in ipairs(self.teamList) do
		if not self.ignoreUID[v.uid] then
			table.insert(showList, v)
		end
	end
	self:updateListMember(showList)
end
function legendTeamApprovalListView:updateListMember(showList)
	self.showList = showList
	if not self.showList or not next(self.showList) then
		self.nodeTips:setVisible(true)
		if self.isBatch then
			self.btnInvite:setVisible(false)
			self.labelNotice:setString(i18n("legendaryking_text_82"))
		else
			self.btnInvite:setVisible(true)
			self.labelNotice:setString(i18n("remains_text_50"))
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
function legendTeamApprovalListView:onMsgUpdateApprovalInfo(target, event)
	SoraDCloseLoading(self)
	local subMsg = event.subMsg
	if subMsg == "rejectApply" then
		self:addIgnoreUID(event.uid)
	elseif subMsg == "rejectApplyBatch" then
		self:addIgnoreUidList(event.uidList)
		self:setIsSelected(false)
	elseif subMsg == "agreeApplyBatch" then
		self:addIgnoreUidList(event.uidList)
		self:setIsSelected(false)
	end
end
function legendTeamApprovalListView:setIsBatch(isBatch)
	self.isBatch = isBatch
	if self.isBatch then
		self.nodeTitle:setTitle(i18n("legendaryking_text_84"))
		self.btnRefresh:setVisible(false)
		self.btnBatch:setVisible(false)
		self.btnReject:setVisible(true)
		self.btnAgree:setVisible(true)
	end
end
return legendTeamApprovalListView

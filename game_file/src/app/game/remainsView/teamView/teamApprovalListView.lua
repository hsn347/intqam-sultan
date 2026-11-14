local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarUtil = include("remainsWarUtil")
local teamApprovalListView = class("teamApprovalListView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("teamApprovalListView")
	end
	local base = include("teamApprovalListBase")
	target = base.new(target)
	return target
end)
local TEAM_APPROVAL_TYPE_ADD = _G.TEAM_APPROVAL_TYPE_ADD
function teamApprovalListView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_title_02"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHelp:setVisible(IsArClient)
	self.btnRefreshChoose = SoraDGetChildByName(self, "Button_refresh")
	self.btnRefreshChoose:setTitleText(i18n("common_text_911"))
	self.btnRefreshChoose:addTouchEventListener(handler(self, self.btnRefreshClickCallBack))
	self.btnInvite = SoraDGetChildByName(self, "Button_invite")
	self.btnInvite:setTitleText(i18n("remains_btn_10"))
	self.btnInvite:addTouchEventListener(handler(self, self.btnInviteClickCallBack))
	self.nodeTips = SoraDGetChildByName(self, "Center_node_tips")
	self.nodeTips:setVisible(false)
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.viewType = TEAM_APPROVAL_TYPE_ADD
	self:req4Data()
end
function teamApprovalListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_LIST_ADD_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_AGREE_BACK", handler(self, self.rspAgree))
	self:onMessageListener_common()
end
function teamApprovalListView:rspAgree(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("remains_text_49"))
		self:addIgnoreUID(data.uid)
	end
end
function teamApprovalListView:req4Data()
	remainsTeamCtrl:reqGetApplyList()
	SoraDShowLoading(self)
end
function teamApprovalListView:joinClickCallBack(data)
	remainsTeamCtrl:reqAgreeApplyJoin(data.uid)
	SoraDShowLoading(self)
end
function teamApprovalListView:btnRefreshClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:req4Data()
	end
end
function teamApprovalListView:btnInviteClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("teamApprovalListInviteView")
		panel:show()
		self:removeFromParent()
	end
end
function teamApprovalListView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function teamApprovalListView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = remainsWarUtil.getErrType(err)
	if errType == remainsWarUtil.errType.TIPS then
		remainsWarUtil.errShowTips(err)
	elseif errType == remainsWarUtil.errType.CLOSE then
		remainsWarUtil.errShowTips(err)
		self:removeFromParent()
	elseif errType == remainsWarUtil.errType.REFRESH then
		self:req4Data()
	end
end
function teamApprovalListView:updateShowList()
	local _ENV, showList
	for _, v in ipairs(self.teamList) do
		if not self.ignoreUID[v.uid] then
			table.insert(showList, v)
		end
	end
	self:updateListMember(showList)
end
function teamApprovalListView:updateListMember(showList)
	self.showList = showList
	if not self.showList or not next(self.showList) then
		self.nodeTips:setVisible(true)
		self.labelNotice:setString(i18n("remains_text_50"))
		self.btnInvite:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.nodeTips:setVisible(false)
		self.scroll:setVisible(true)
		self:updateScrollList()
		self:updateViewByData()
	end
	self:updateRemain()
end
return teamApprovalListView

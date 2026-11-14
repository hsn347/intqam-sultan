local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildNoticePanel = class("AllianceBuildNoticePanel", baseFguiPanel)
function AllianceBuildNoticePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildNoticePanel:ctor", self.viewName)
end
function AllianceBuildNoticePanel:onInit()
	print("=======AllianceBuildNoticePanel:onInit")
	self.aid = nil
	self.buildID = 3721
	self.kid = nil
	self.ccs_bg = self.fields.Panel_bg
	self.labelDes = self.fields.Text_des
	self.btnInfo = self.fields.Button_info
	self.btnInfo:setTitleText(i18n("common_text_082"))
	if self.btnInfo then
		self.btnInfo:addClickListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceBuildNoticePanel:onShow()
	print("=======AllianceBuildNoticePanel:onShow")
end
function AllianceBuildNoticePanel:initData(buidID, aid, kid)
	self.aid = aid
	self.buildID = buidID
	self.kid = kid
	self.ccs_bg:setString(allianceDesRead.getBuildName(self.buildID))
	if gMapAllianceBuildType.subTypeAllianceAltar == self.buildID then
		self.labelDes:setString(i18n("alliance_beast_text_21"))
	else
		self.labelDes:setString(allianceDesRead.getBuildDes(self.buildID))
	end
end
function AllianceBuildNoticePanel:btnClickCallBack()
	SoraDPlaySound()
	if self.kid then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
		_ENV = handler(self, self.sMsgReqInfoBack)
		handler(self, self.sMsgReqInfoBack).from = "AllianceBuildNoticePanel"
		allianceQuery:reqAllianceInfo(self.kid, self.aid, handler(self, self.sMsgReqInfoBack))
	end
end
function AllianceBuildNoticePanel:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	local kid = alliance:getProperty("sourceKid")
	SoraDOpenAllianceInfoView(alliance, kid)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
	self:removeFromParent()
end
return AllianceBuildNoticePanel

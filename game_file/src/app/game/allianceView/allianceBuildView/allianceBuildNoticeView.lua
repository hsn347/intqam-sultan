local allianceDesRead = include("allianceDesRead")
local AllianceBuildNoticeView = class("allianceBuildNoticeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceBuildNoticeView")
	end
	return target
end)
function AllianceBuildNoticeView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch")
	self.aid = nil
	self.buildID = 3721
	self.kid = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnInfo:setTitleText(i18n("common_text_082"))
	if self.btnInfo then
		self.btnInfo:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceBuildNoticeView:initData(buidID, aid, kid)
	self.aid = aid
	self.buildID = buidID
	self.kid = kid
	self.ccs_bg:setTitleName(allianceDesRead.getBuildName(self.buildID))
	if gMapAllianceBuildType.subTypeAllianceAltar == self.buildID then
		self.labelDes:setString(i18n("alliance_beast_text_21"))
	else
		self.labelDes:setString(allianceDesRead.getBuildDes(self.buildID))
	end
end
function AllianceBuildNoticeView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.kid then
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
			_ENV = handler(self, self.sMsgReqInfoBack)
			handler(self, self.sMsgReqInfoBack).from = "allianceBuildNoticeView"
			allianceQuery:reqAllianceInfo(self.kid, self.aid, handler(self, self.sMsgReqInfoBack))
		end
	end
end
function AllianceBuildNoticeView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceBuildNoticeView" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
			self:removeFromParent()
		end
	end
end
return AllianceBuildNoticeView

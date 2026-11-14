local AllianceChangeNoticeView = class("allianceChangeNoticeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceChangeNoticeView")
	end
	return target
end)
function AllianceChangeNoticeView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.isHaveTextField = true
	self.nowShowNotice = ""
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_213"))
	self.btnSave = SoraDGetChildByName(self, "Button_save")
	self.btnSave:setTitleText(i18n("common_text_195"))
	self.tfdNotice = SoraDGetChildByName(self, "TextField_notice")
	_ENV = "TextField_notice"
	;("TextField_notice").func = handler(self, self.OnInputNotice)
	self.tfdNotice = SoraDChangeToEditBox(self.tfdNotice, "TextField_notice")
	self.tfdNotice:setTouchEnabled(true)
	self.tfdNotice:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.tfdNotice:setFontSize(20)
	if self.btnSave then
		self.btnSave:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.tfdNotice:setTextHorizontalAlignment(SoraDFLabelR())
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_NOTICE_CHANGE_SUCCESS", handler(self, self.changeBack))
end
function AllianceChangeNoticeView:OnInputNotice(eventType, textField)
	if eventType == "began" then
	elseif eventType == "changed" then
	elseif eventType == "ended" then
	elseif eventType == "return" then
		self.nowShowNotice = textField:getString()
	end
end
function AllianceChangeNoticeView:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliacnePoint = allianceMgr:getAlliance()
	self.nowShowNotice = alliacnePoint:getProperty("notice")
	local notice = self.nowShowNotice
	if notice == "" then
		notice = i18n("common_text_194")
	end
	self.tfdNotice:setString(notice)
end
function AllianceChangeNoticeView:changeBack()
	self:removeFromParent()
end
function AllianceChangeNoticeView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local allianceSetting = gametop.playertop_:getModule("allianceSetting")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank >= gAllianceRank.R4 then
			allianceSetting:reqModifyNotice(self.tfdNotice:getString())
			self.btnSave:setTouchEnabled(false)
			self.btnSave:setBright(false)
		else
			SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_203"))
			self:changeBack()
		end
	end
end
function AllianceChangeNoticeView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.tfdNotice:setString(self.nowShowNotice)
		target:touchDownAction(target, type)
	end
end
return AllianceChangeNoticeView

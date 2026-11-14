local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local AllianceCounterMsgBox = class("allianceCounterMsgBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceCounterMsgBox")
	end
	return target
end)
function AllianceCounterMsgBox:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeBg:setTitleName(i18n("CounterSystem_text_31"))
	self.btnAlliance:setTitleText(i18n("treasuremap_text_11"))
	self.btnHelp:setTitleText(i18n("CounterSystem_btn_09"))
	self.labelDes:setString(i18n("CounterSystem_text_32"))
	self.btnAlliance:addTouchEventListener(handler(self, self.btnAllianceClickCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	SoraDAutoSizeButtonText(self.btnHelp)
	SoraDAutoSizeButtonText(self.btnAlliance)
end
function AllianceCounterMsgBox:initData(data)
	self.data = data
end
function AllianceCounterMsgBox:btnAllianceClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if allianceMgr:hasJoinAlliance() then
			allianceCounterSysCtrl:getSendAllianceHelp(self.data.uid)
			button:setBright(false)
			button:setTouchEnabled(false)
			SoraDShowMsgTip(i18n("common_text_2293"))
		else
			SoraDShowMsgTip(i18n("notice_0066"))
		end
	end
end
function AllianceCounterMsgBox:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("commonFriendListView")
		panel:selectBtn(i18n("CounterSystem_btn_10"))
		panel:setHand(function(uid)
			local mailCtrl = gametop.playertop_:getModule("mailCtrl")
			local myKindomID = gametop.playertop_:getMapID()
			local name = self.data.nickName
			if self.data.abbr and self.data.abbr ~= "" then
				gametop = nil
				;(nil).abbr = self.data.abbr
				;(nil).name = self.data.nickName
				name = i18n("common_text_186", nil)
			end
			local isKing = SoraDIsSelfKing()
			gametop = self.data.nickName
			self.data.nickName.name = name
			self.data.nickName.k = myKindomID
			self.data.nickName.x = self.data.coordinate.x
			self.data.nickName.y = self.data.coordinate.y
			local strContent = i18n("CounterSystem_text_04", self.data.nickName)
			gametop = "CounterSystem_text_04"
			;("CounterSystem_text_04").contentType = gChatMailContentType.content_text
			;("CounterSystem_text_04").content = strContent
			local ("CounterSystem_text_04").isKing, mailContent = isKing, "CounterSystem_text_04"
			self = nil
			;(nil)[1] = uid
			mailCtrl:sendMultipleChatMail(nil, mailContent)
			SoraDShowMsgTip(i18n("common_text_2293"))
		end)
		panel:updateData()
		panel:show()
	end
end
return AllianceCounterMsgBox

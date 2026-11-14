local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorPersonalInfoView = class("alliancePBLHonorPersonalInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLHonorPersonalInfoView")
	end
	return target
end)
function alliancePBLHonorPersonalInfoView:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeBg:setTitleName(i18n("pyramid_title_12"))
	self.nodeBase = SoraDGetChildByName(self, "Node_base")
	self.labelDes1 = SoraDGetChildByName(self, "Text_des")
	self.labelGood = SoraDGetChildByName(self, "Text_good")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelGroup = SoraDGetChildByName(self, "Text_group")
	self.spriteGood = SoraDGetChildByName(self, "Sprite_good")
	self.labelHaveGood = SoraDGetChildByName(self, "Text_haveGood")
	self.btnGood = SoraDGetChildByName(self, "Button_good")
	self.nodeHead = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.labelDes = SoraDGetChildByName(self, "Text_slogan")
	self.btnEdit = SoraDGetChildByName(self, "Button_edit")
	self.tfdSlogan = SoraDGetChildByName(self, "TextField_edit")
	_ENV = "TextField_edit"
	;("TextField_edit").func = handler(self, self.OnInputNotice)
	self.tfdSlogan = SoraDChangeToEditBox(self.tfdSlogan, "TextField_edit")
	self.tfdSlogan:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdSlogan:setFontSize(20)
	self.tfdSlogan:setPlaceHolder("")
	self.tfdSlogan:setFontColor(self.labelDes:getColor())
	self.tfdSlogan:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.btnGood:addTouchEventListener(handler(self, self.btnGoodClickCallBack))
	self.btnEdit:addTouchEventListener(handler(self, self.btnEditClickCallBack))
	self.labelTitle:setString(i18n("pyramid_text_86"))
	self.labelHaveGood:setString(i18n("common_text_2699"))
	self.btnGood:setTitleText(i18n("pyramid_text_120"))
	self.btnEdit:setTitleText(i18n("common_text_244"))
	self.labelDes1:setString(i18n("pyramid_text_90"))
end
function alliancePBLHonorPersonalInfoView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_BACK", function(...)
		local data = pyramidWarCtrl:getPBLHistoryRank(gGloryRankTypeDef.ALSTAR_PLAYER, self.curData.seasonNum)
		for i, v in ipairs(data) do
			if v.uid == self.curData.uid then
				self:initData(v)
				break
			end
		end
	end)
end
function alliancePBLHonorPersonalInfoView:initData(data)
	self.curData = data
	dump(self.curData, "self.curData")
	_ENV = nil
	;(nil).abbr = self.curData.abbr
	;(nil).name = self.curData.nickName
	self.labelGroup:setString(i18n("common_text_186", nil) .. "#" .. self.curData.kid)
	_ENV = self.curData.kid
	self.curData.kid.name = self.curData.legionName
	self.labelName:setString(i18n("pyramid_text_119", self.curData.kid))
	_ENV = i18n("pyramid_text_119", self.curData.kid)
	i18n("pyramid_text_119", self.curData.kid).count = string.formatnumberthousands(self.curData.totalFc)
	self.labelPower:setString(i18n("common_text_555", i18n("pyramid_text_119", self.curData.kid)))
	self.nodeHead:setHeadSprite(self.curData.iconID, self.curData.avatar)
	self.nodeHead:setPlayerID(self.curData.uid)
	self.labelGood:setString(string.formatnumberthousands(self.curData.praiseNum))
	local canPadised = pyramidWarCtrl:checkPadise(self.curData) == nil
	self.btnGood:setTouchEnabled(canPadised)
	self.btnGood:setBright(canPadised)
	local selfContent = pyramidWarCtrl:checkContent(self.curData, self.curData.seasonNum, true)
	if selfContent then
		print("有内容1")
		self.labelDes:setString(selfContent)
		self.tfdSlogan:setVisible(false)
		self.labelDes:setVisible(true)
		self.btnEdit:setVisible(false)
	else
		print("无法编辑1")
		self.labelDes:setString(i18n("pyramid_text_87"))
		self:checkRank()
	end
	SoraDCloseLoading(self)
end
function alliancePBLHonorPersonalInfoView:changeBtn(canEdit)
	self.btnEdit:setTouchEnabled(canEdit)
	self.btnEdit:setBright(canEdit)
	self.tfdSlogan:setVisible(not canEdit)
	self.labelDes:setVisible(canEdit)
	if canEdit then
		self.btnEdit:setTag(1)
		self.btnEdit:setTitleText(i18n("common_text_244"))
	else
		self.btnEdit:setTag(2)
		self.btnEdit:setTitleText(i18n("common_text_3628"))
	end
end
function alliancePBLHonorPersonalInfoView:checkRank()
	if include("chatFunctions"):getSelfId() == self.curData.uid and (self.curData.editNum == nil or self.curData.editNum <= 0) then
		self.btnEdit:setVisible(true)
		self:changeBtn(true)
	else
		print("无法编辑2")
		self.btnEdit:setVisible(false)
		self.tfdSlogan:setVisible(false)
		self.labelDes:setVisible(true)
	end
end
function alliancePBLHonorPersonalInfoView:btnGoodClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		pyramidWarCtrl:pinnaclePraisePraisedReq(self.curData.uid, self.curData.seasonNum)
		self.btnGood:setTouchEnabled(false)
		self.btnGood:setBright(false)
	end
end
function alliancePBLHonorPersonalInfoView:btnEditClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == 1 then
			self:changeBtn(false)
			self.tfdSlogan:setString("")
			self.tfdSlogan:closeIME()
			self:OnEditBoxTouch(self.tfdSlogan, ccui.TouchEventType.ended)
		else
			SoraDShowMsgBox(i18n("pyramid_text_88"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					self:changeBtn(true)
					self.labelDes:setString(self.tfdSlogan:getString())
					button:setVisible(false)
					pyramidWarCtrl:setPlayerContentReq(self.curData.seasonNum, self.tfdSlogan:getString(), self.curData.legionId)
					SoraDShowLoading(self)
				end
			end)
		end
	end
end
function alliancePBLHonorPersonalInfoView:OnInputNotice(eventType, textField)
	if eventType == "began" then
	elseif eventType == "changed" then
	elseif eventType == "ended" then
	elseif eventType == "return" then
	end
	local str = textField:getString()
	self.btnEdit:setTouchEnabled(str ~= "")
	self.btnEdit:setBright(str ~= "")
end
function alliancePBLHonorPersonalInfoView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		target:touchDownAction(target, type)
	end
end
return alliancePBLHonorPersonalInfoView

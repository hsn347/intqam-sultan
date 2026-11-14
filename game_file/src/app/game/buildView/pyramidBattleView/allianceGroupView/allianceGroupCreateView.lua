local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local AllianceGroupCreateView = class("allianceGroupCreateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceGroupCreateView")
	end
	return target
end)
function AllianceGroupCreateView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.isHaveTextField = true
	self.maxLen = MAX_NICKNAME_LEN
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.labelWarn = SoraDGetChildByName(self, "Text_warn")
	self.labelTip = SoraDGetChildByName(self, "Text_tip")
	self.btnCreate = SoraDGetChildByName(self, "Button_create")
	self.tfdRename = SoraDGetChildByName(self, "TextField_rename")
	_ENV = "TextField_rename"
	;("TextField_rename").func = handler(self, self.onEditBoxChange)
	self.tfdRename = SoraDChangeToEditBox(self.tfdRename, "TextField_rename")
	self.tfdRename:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdRename:setPlaceHolder(i18n("pyramid_text_22"))
	self.tfdRename:setTextColor(cc.c4b(0, 0, 0, 255))
	self.imgYesNo = SoraDGetChildByName(self, "Image_yesno")
	self.imgYesNo:setVisible(false)
	self.labelTip:setString(i18n("pyramid_text_21"))
	self.btnCreate:setTitleText(i18n("common_text_204"))
	if self.btnCreate then
		self.btnCreate:addTouchEventListener(handler(self, self.btnCreateClickCallBack))
	end
	self.labelWarn:setString(i18n("pyramid_text_23"))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.createSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CREATE_ERR_BACK", handler(self, self.inputErr))
end
function AllianceGroupCreateView:createSuccess(target, data)
	SoraDCloseLoading(self)
	self:removeFromParent()
end
function AllianceGroupCreateView:inputErr(target, data)
	self:updateErr(data.err)
	self.btnCreate:setTouchEnabled(false)
	self.btnCreate:setBright(false)
	SoraDCloseLoading(self)
end
function AllianceGroupCreateView:initCreate()
	self.ccs_bg:setTitleName(i18n("pyramid_btn_02"))
	self.btnCreate:setTouchEnabled(false)
	self.btnCreate:setBright(false)
end
function AllianceGroupCreateView:initChangeName(legionId)
	self.legionId = legionId
	self.ccs_bg:setTitleName(i18n("pyramid_title_03"))
	self.btnCreate:setTouchEnabled(false)
	self.btnCreate:setBright(false)
end
function AllianceGroupCreateView:nickNameErr(target, data)
	if data.content.err == gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER and data.content.data.nickName == self.tfdRename:getText() then
		self.labelWarn:setString(i18n("common_text_366"))
		self.labelWarn:setColor(display.COLOR_RED)
		self.imgYesNo:loadTexture("icon_no.png", ccui.TextureResType.plistType)
		self:setBtnState(false)
	end
end
function AllianceGroupCreateView:btnCreateClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.legionId then
			pyramidWarCtrl:newSetLegionNameReq(self.legionId, self.tfdRename:getString(), true)
		else
			allianceMgr:reqCreateLegion(self.tfdRename:getText())
		end
		SoraDShowLoading(self)
	elseif type == ccui.TouchEventType.began then
		self:updateCreateBtnTouchEnable()
	end
end
function AllianceGroupCreateView:onEditBoxChange(eventType, textField)
	local input = textField:getCharCount()
	self.imgYesNo:setVisible(false)
	self.labelWarn:setColor(cc.c3b(114, 114, 114))
	_ENV = cc.c3b(114, 114, 114)
	cc.c3b(114, 114, 114).count = 4 - input
	self.labelWarn:setString(i18n("common_text_364", cc.c3b(114, 114, 114)))
	if eventType == "return" then
		self:updateCreateBtnTouchEnable()
	end
end
function AllianceGroupCreateView:updateCreateBtnTouchEnable()
	local isEnable = true
	local nameErr = pyramidWarCtrl:newSetLegionNameReq(self.legionId, self.tfdRename:getString(), false)
	self.imgYesNo:setVisible(true)
	self:updateErr(gErrDef.Err_None)
	self.btnCreate:setTouchEnabled(isEnable)
	self.btnCreate:setBright(isEnable)
end
function AllianceGroupCreateView:updateErr(err)
	if err == gErrDef.Err_None then
		self.imgYesNo:loadTexture("icon_yes.png", ccui.TextureResType.plistType)
		self.labelWarn:setColor(cc.c3b(114, 114, 114))
	else
		self.imgYesNo:loadTexture("icon_no.png", ccui.TextureResType.plistType)
		self.labelWarn:setColor(display.COLOR_RED)
		if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
			self.labelWarn:setString(i18n("pyramid_text_24"))
		elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL then
			self.labelWarn:setString(i18n("privilege_text_93"))
		elseif err == gErrDef.Err_ALLIANCE_NAME_HAVE then
			self.labelWarn:setString(i18n("pyramid_tips_15"))
		end
	end
end
return AllianceGroupCreateView

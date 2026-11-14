local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local kingStarTeamCreateView = class("kingStarTeamCreateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kingStarTeamCreateView")
	end
	return target
end)
function kingStarTeamCreateView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:bindBtnClose()
	self:setBackGround(204.0)
	self.isHidePrePanel = false
	self.isHaveTextField = true
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("free_team_text_33"))
	self.btnCreate = SoraDGetChildByName(self, "Button_create")
	self.btnCreate:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnCreate:setTitleText(i18n("free_team_text_40"))
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelErrName = SoraDGetChildByName(self, "Text_errName")
	self.labelNameNotice = SoraDGetChildByName(self, "Text_nameNotice")
	self.spriteNameErr = SoraDGetChildByName(self, "Sprite_nameErr")
	self.spriteNameErr:setVisible(false)
	self.labelName:setString(i18n("free_team_text_34"))
	_ENV = i18n("free_team_text_34")
	i18n("free_team_text_34").count = ALLIANCE_NAME_MAX
	self.labelErrName:setString(i18n("common_text_364", i18n("free_team_text_34")))
	self.labelNameNotice:setString(i18n("common_text_174"))
	self.labelNickName = SoraDGetChildByName(self, "Text_nickName")
	self.labelErrNickName = SoraDGetChildByName(self, "Text_errNickName")
	self.labelNickNameNotice = SoraDGetChildByName(self, "Text_nickNameNotice")
	self.spriteNickNameErr = SoraDGetChildByName(self, "Sprite_nickNameErr")
	self.spriteNickNameErr:setVisible(false)
	self.labelNickName:setString(i18n("free_team_text_37"))
	_ENV = i18n("free_team_text_37")
	i18n("free_team_text_37").count = ALLIANCE_NAME_MIN
	self.labelErrNickName:setString(i18n("common_text_364", i18n("free_team_text_37")))
	self.labelNickNameNotice:setString(i18n("free_team_text_38"))
	self.tfdName = SoraDGetChildByName(self, "TextField_name")
	_ENV = "TextField_name"
	;("TextField_name").func = handler(self, self.OnInputName)
	self.tfdName = SoraDChangeToEditBox(self.tfdName, "TextField_name")
	self.tfdName:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdName:setPlaceHolder(i18n("free_team_text_35"))
	self.tfdName:setTextColor(cc.c4b(0, 0, 0, 255))
	self.tfdNickName = SoraDGetChildByName(self, "TextField_nickName")
	_ENV = "TextField_nickName"
	;("TextField_nickName").func = handler(self, self.OnInputNickName)
	self.tfdNickName = SoraDChangeToEditBox(self.tfdNickName, "TextField_nickName")
	self.tfdNickName:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdNickName:setPlaceHolder(i18n("free_team_text_39"))
	self.tfdNickName:setTextColor(cc.c4b(0, 0, 0, 255))
	self:initData()
end
function kingStarTeamCreateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_CREATE_BACK", handler(self, self.createSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_INFO", handler(self, self.changeInfo))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
end
function kingStarTeamCreateView:updateTeamInfo(target, data)
	if kingStarTeamCtrl:isHasTeam() then
		legendTeamUtil.openTeamView(self.mapID)
		self:removeFromParent()
	end
end
function kingStarTeamCreateView:initActivityID(activityID)
	self.activityID = activityID or gActivityTimeActivityID.KING_STAR_BATTLE
	self.mapID = worldMapDefine.getKingStarMapid(self.activityID) or worldMapDefine.KINGSTAR_KINGDOM_ID
	print("self.activityID,self.mapID=======", self.activityID, self.mapID)
end
function kingStarTeamCreateView:initData()
	self.btnCreate:setTouchEnabled(false)
	self.btnCreate:setBright(false)
end
function kingStarTeamCreateView:initChangeView(name, abbr)
	self.isChange = true
	self.oldName = name
	self.oldNickName = abbr
	self.tfdName:setString(self.oldName)
	self.tfdName:touchDownAction(self.tfdName, 2)
	self.tfdName:closeKeyboard()
	self.tfdNickName:setString(self.oldNickName)
	self.tfdNickName:touchDownAction(self.tfdNickName, 2)
	self.tfdNickName:closeKeyboard()
	self.ccs_bg:setTitleName(i18n("free_team_text_57"))
	self.btnCreate:setTitleText(i18n("common_text_243"))
end
function kingStarTeamCreateView:createSuccess(target, data)
	SoraDCloseLoading(self)
	local err = data.err
	if err == gErrDef.Err_None then
		SoraDRemoveAllAfterPanelFromManager(self)
		legendTeamUtil.openTeamView(self.mapID)
	else
		self:updateTeamErr(err)
	end
end
function kingStarTeamCreateView:updateTeamErr(err)
	local isName = err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL or err == gErrDef.Err_ALLIANCE_NAME_LENGTH or err == gErrDef.Err_TEAM_NAME_REPEAT
	if err == gErrDef.Err_TEAM_NAME_REPEAT then
		SoraDShowMsgTip(i18n("free_team_text_52"))
	elseif err == gErrDef.Err_TEAM_ABBR_REPEAT then
		SoraDShowMsgTip(i18n("free_team_text_56"))
	end
	self:updateErr(err, isName)
	self.btnCreate:setTouchEnabled(false)
	self.btnCreate:setBright(false)
end
function kingStarTeamCreateView:changeInfo(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		self:removeFromParent()
	else
		self:updateTeamErr(data.err)
	end
end
function kingStarTeamCreateView:OnInputName(eventType, textField)
	local input = textField:getCharCount()
	self.spriteNameErr:setVisible(false)
	self.labelErrName:setColor(cc.c3b(114, 114, 114))
	_ENV = cc.c3b(114, 114, 114)
	cc.c3b(114, 114, 114).count = ALLIANCE_NAME_MAX - input
	self.labelErrName:setString(i18n("common_text_364", cc.c3b(114, 114, 114)))
	if eventType == "return" then
		self:updateCreateBtnTouchEnable()
	end
end
function kingStarTeamCreateView:OnInputNickName(eventType, textField)
	local input = textField:getCharCount()
	self.spriteNickNameErr:setVisible(false)
	self.labelErrNickName:setColor(cc.c3b(114, 114, 114))
	_ENV = cc.c3b(114, 114, 114)
	cc.c3b(114, 114, 114).count = ALLIANCE_NAME_MIN - input
	self.labelErrNickName:setString(i18n("common_text_364", cc.c3b(114, 114, 114)))
	if eventType == "return" then
		self:updateCreateBtnTouchEnable()
	end
end
function kingStarTeamCreateView:updateErr(err, isName)
	if isName then
		if err == gErrDef.Err_None then
			self.spriteNameErr:setSpriteFrame("icon_yes.png")
			self.labelErrName:setColor(cc.c3b(114, 114, 114))
		else
			self.spriteNameErr:setSpriteFrame("icon_no.png")
			self.labelErrName:setColor(display.COLOR_RED)
			if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
				self.labelErrName:setString(i18n("free_team_text_51"))
			elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL then
				self.labelErrName:setString(i18n("free_team_text_54"))
			elseif err == gErrDef.Err_TEAM_NAME_REPEAT then
				self.labelErrName:setString(i18n("free_team_text_52"))
			end
		end
	elseif err == gErrDef.Err_None then
		self.spriteNickNameErr:setSpriteFrame("icon_yes.png")
		self.labelErrNickName:setColor(cc.c3b(114, 114, 114))
	else
		self.spriteNickNameErr:setSpriteFrame("icon_no.png")
		self.labelErrNickName:setColor(display.COLOR_RED)
		if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
			self.labelErrNickName:setString(i18n("free_team_text_53"))
		elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_ABBR_ILLEGAL then
			self.labelErrNickName:setString(i18n("free_team_text_55"))
		elseif err == gErrDef.Err_TEAM_ABBR_REPEAT then
			self.labelErrNickName:setString(i18n("free_team_text_56"))
		end
	end
end
function kingStarTeamCreateView:updateCreateBtnTouchEnable()
	local strName = self.tfdName:getString()
	local strNickName = self.tfdNickName:getString()
	local nameErr = legendTeamUtil.checkName(strName)
	local abbrErr = legendTeamUtil.checkAbbr(strNickName)
	self.spriteNameErr:setVisible(true)
	self.spriteNickNameErr:setVisible(true)
	self:updateErr(nameErr, true)
	self:updateErr(abbrErr, false)
	local isEnable = nameErr == gErrDef.Err_None and abbrErr == gErrDef.Err_None
	if self.isChange then
		isEnable = isEnable and false
	end
	self.btnCreate:setTouchEnabled(isEnable)
	self.btnCreate:setBright(isEnable)
end
function kingStarTeamCreateView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isChange then
			local strName = self.tfdName:getString()
			local strNickName = self.tfdNickName:getString()
			local bChange = false
			if strName ~= self.oldName then
				kingStarTeamCtrl:reqTeamSetName(strName)
				bChange = true
			end
			if strNickName ~= self.oldNickName then
				kingStarTeamCtrl:reqTeamSetAbbr(strNickName)
				bChange = true
			end
			if bChange then
				SoraDShowLoading(self)
			end
		else
			local err = legendTeamUtil.checkCreateTeam(self.mapID)
			if gErrDef.Err_None == err then
				kingStarTeamCtrl:reqCreateTeam(self.tfdName:getString(), self.tfdNickName:getString())
				SoraDShowLoading(self)
			else
				self:errHandle(err)
			end
		end
	elseif type == ccui.TouchEventType.began then
		self:updateCreateBtnTouchEnable()
	end
end
function kingStarTeamCreateView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS or errType == legendTeamUtil.errType.CLOSE or errType == legendTeamUtil.errType.REFRESH then
		legendTeamUtil.errShowTips(err)
	end
end
return kingStarTeamCreateView

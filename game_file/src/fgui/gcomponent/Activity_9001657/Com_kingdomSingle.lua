local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local constantRead = include("constantRead")
local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_kingdomSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001657/Com_kingdomSingle", Com_kingdomSingle)
function Com_kingdomSingle:onInit()
	self.fields.Button_chat:setString(i18n("kingdom_merger_text15"))
	self.fields.Button_chat:addClickListener(handler(self, self.onClickBtnChat))
	self.fields.Button_apply:addClickListener(handler(self, self.onClickBtnApply))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_kingdomSingle:onShow()
end
function Com_kingdomSingle:initData(data)
	self.data = data
	_ENV = nil
	;(nil).kid = data.kid
	self.fields.Text_kingdom:setString(i18n("kingdom_merger_text10", nil))
	self.fields.Image_kingdom:setURL(kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	local powerStr = string.formatnumberthousands(data.power or 0)
	_ENV = kingdomCtrl:getKindomPalaceModelIcon(data.kid)
	kingdomCtrl:getKindomPalaceModelIcon(data.kid).color = "#FFFBD5"
	powerStr = SoraDWrapHtmlTagByStyle(powerStr, kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	_ENV = kingdomCtrl:getKindomPalaceModelIcon(data.kid)
	kingdomCtrl:getKindomPalaceModelIcon(data.kid).power = powerStr
	self.fields.Text_power:setString(i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)))
	local numMax = constantRead.getConstValue("KINGDOM_MERGER_PEOPLE_NUMBER", 0)
	local userNum = data.agreedUserNum or 0
	local isNumEnough = numMax > userNum
	local userNumStr = tostring(userNum)
	if isNumEnough then
		_ENV = i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid))
		i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)).color = "#00ff00"
		userNumStr = SoraDWrapHtmlTagByStyle(userNumStr, i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)))
	else
		_ENV = i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid))
		i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)).color = "#ff0000"
		userNumStr = SoraDWrapHtmlTagByStyle(userNumStr, i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)))
	end
	_ENV = i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)).num = userNumStr
	i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid)).max = numMax
	self.fields.Text_num:setString(i18n("kingdom_merger_text12", i18n("kingdom_merger_text11", kingdomCtrl:getKindomPalaceModelIcon(data.kid))))
	self.fields.Icon_yes:setVisible(isNumEnough)
	self.fields.Icon_no:setVisible(not isNumEnough)
	local isEnough = isNumEnough
	if not isEnough then
		local totalFc = lordInfoCtrl:getBaseInfo().totalFc
		local KINGDOM_MERGER_POWER = constantRead.getConstValue("KINGDOM_MERGER_POWER", 0)
		if totalFc < KINGDOM_MERGER_POWER then
			isEnough = true
		end
	end
	self.isNumEnough = isNumEnough
	self.isEnough = isEnough
	local c_type = self.fields.Node_condition:getController("c_type")
	if isEnough then
		c_type:setSelectedIndex(0)
		self.fields.Node_condition:setString(i18n("kingdom_merger_text13"))
	else
		c_type:setSelectedIndex(1)
		self.fields.Node_condition:setString(i18n("kingdom_merger_text14"))
	end
	self.applyState = activity_9001657_Ctrl:getApplyState(data.kid)
	if not self.applyState then
		self.fields.Button_apply:setEnabled(true)
		self.fields.Button_apply:setBtnColorIndex(2)
		self.fields.Button_apply:setString(i18n("kingdom_merger_text3"))
		if not isEnough then
			self.fields.Button_apply:setBright(false)
		end
	elseif self.applyState == gMergeServerApplyState.APPLIED then
		self.fields.Button_apply:setEnabled(false)
		self.fields.Button_apply:setString(i18n("across_move_applied_name"))
	elseif self.applyState == gMergeServerApplyState.AGREED or self.applyState == gMergeServerApplyState.AUTO_AGREED then
		self.fields.Button_apply:setEnabled(true)
		self.fields.Button_apply:setBtnColorIndex(1)
		self.fields.Button_apply:setString(i18n("kingdom_merger_text19"))
		c_type:setSelectedIndex(0)
		self.fields.Node_condition:setString(i18n("kingdom_merger_text18"))
	end
end
function Com_kingdomSingle:onClickBtnChat(...)
	SoraDPlaySound()
	if not self.data.kingInfo then
		local _ENV, kingInfo = self.data.kingInfo, self.data.kingInfo
	end
	if not next(kingInfo) then
		SoraDShowMsgTip(i18n("kingdom_merger_text32"))
		return
	end
	if kingInfo.shiledStranger and not SoraDGetCtrl("contactCtrl"):isFriend(kingInfo.uid) then
		SoraDShowMsgTip(i18n("chat_text_66"))
		return
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.targetType = gMailType.CHAT
	SoraDShowMsgTip.target = kingInfo.uid
	SoraDShowMsgTip.nickName = kingInfo.nickName
	local SoraDShowMsgTip.allianceAbbr, data = kingInfo.abbr, SoraDShowMsgTip
	SoraDCreateChatView(data)
end
function Com_kingdomSingle:onClickBtnApply(...)
	SoraDPlaySound()
	if not self.applyState then
		self:doApply()
	elseif self.applyState == gMergeServerApplyState.APPLIED then
	elseif self.applyState == gMergeServerApplyState.AGREED or self.applyState == gMergeServerApplyState.AUTO_AGREED then
		self:doUnbind()
	end
end
function Com_kingdomSingle:doApply(...)
	if not self.isEnough and not self.isNumEnough then
		SoraDShowMsgTip(i18n("kingdom_merger_text16"))
		return
	end
	if activity_9001657_Ctrl:checkOtherBind() then
		SoraDShowMsgTip(i18n("kingdom_merger_text17"))
		return
	end
	local timeMax = constantRead.getConstValue("KINGDOM_MERGER_CANCELLATIONS", 2)
	local unbindTimes = activity_9001657_Ctrl:getUnbindTimes()
	local remain = math.max(0, timeMax - unbindTimes)
	if remain <= 0 then
		local showMsg = i18n("kingdom_merger_text33")
		_ENV = i18n("kingdom_merger_text17")
		i18n("kingdom_merger_text17").content = showMsg
		i18n("kingdom_merger_text17").cancel = true
		i18n("kingdom_merger_text17").confirmFunc = function()
			activity_9001657_Ctrl:reqApplyMoveIn(self.data.kid)
		end
		uiManager:show("MessageBox", i18n("kingdom_merger_text17"))
	else
		activity_9001657_Ctrl:reqApplyMoveIn(self.data.kid)
	end
end
function Com_kingdomSingle:doUnbind(...)
	local timeMax = constantRead.getConstValue("KINGDOM_MERGER_CANCELLATIONS", 2)
	local unbindTimes = activity_9001657_Ctrl:getUnbindTimes()
	local remain = math.max(0, timeMax - unbindTimes)
	if remain <= 0 then
		SoraDShowMsgTip(i18n("kingdom_merger_text22"))
		return
	end
	constantRead = i18n("kingdom_merger_text22")
	i18n("kingdom_merger_text22").kid = self.data.kid
	i18n("kingdom_merger_text22").times = timeMax
	i18n("kingdom_merger_text22").times2 = remain
	local showMsg = i18n("kingdom_merger_text20", i18n("kingdom_merger_text22"))
	constantRead = i18n("kingdom_merger_text22")
	i18n("kingdom_merger_text22").content = showMsg
	i18n("kingdom_merger_text22").cancel = true
	i18n("kingdom_merger_text22").confirmFunc = function()
		activity_9001657_Ctrl:reqUnbind(self.data.kid)
	end
	i18n("kingdom_merger_text22").countDownTime = 5
	uiManager:show("MessageBox", i18n("kingdom_merger_text22"))
end
return Com_kingdomSingle

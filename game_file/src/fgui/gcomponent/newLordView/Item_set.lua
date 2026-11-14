local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Item_set = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Item_set", Item_set)
function Item_set:onInit()
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
end
function Item_set:onShow()
end
function Item_set:getBtnTouch()
	return self.fields.touch
end
function Item_set:initData(data)
	self.data = data
	self:setTitle(self.data.str)
	self:setIcon(self.data.icon)
end
function Item_set:onBtnClick()
	SoraDPlaySound()
	local tag = self.data.tag
	if tag == GameSettingKey.account then
		SoraDShowLoading(nil, nil, nil, true, 0.016666666666666666)
		self:runAction(ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(function()
			if include("pyramidWarltCtrl").checkPwXianXiaSai() then
				userSDKManager.showUserCenter()
			end
		end)))
	elseif tag == GameSettingKey.language then
		uiManager:show("gameLanguage")
	elseif tag == GameSettingKey.explain then
		userSDKManager.showFAQs()
	elseif tag == GameSettingKey.message then
		uiManager:show("gameMessage")
	elseif tag == GameSettingKey.seting then
		uiManager:show("gameOptions")
	elseif tag == GameSettingKey.invite then
		uiManager:show("gameInvite")
	elseif tag == GameSettingKey.search then
		uiManager:show("gameSearch")
	elseif tag == GameSettingKey.fans then
		uiManager:show("gameFanActivities")
	elseif tag == GameSettingKey.shield then
		uiManager:show("gameBlockedUsers")
	elseif tag == GameSettingKey.key then
		uiManager:show("gameActivationCode")
	elseif tag == GameSettingKey.feedback then
		local feedType = "gameSettings"
		userSDKManager.openFeedback(feedType)
	elseif tag == GameSettingKey.policy then
		uiManager:show("gamePolicyAndTerms")
	elseif tag == GameSettingKey.replay then
		if userSDKManager.isSupportReplay() then
			SoraDShowLoading(nil, nil, nil, true, 0.016666666666666666)
			self:runAction(ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(function()
				SoraDRemoveAllPanelFromManager()
				userSDKManager.startRecording()
			end)))
		else
			SoraDShowMsgBox(i18n("common_text_2300"), i18n("common_text_204"))
		end
	elseif tag == GameSettingKey.pyramidWar_desert or tag == GameSettingKey.pyramidWar_remains then
		local strTips
		if pyramidWarCtrl:getIsInPwXianXiaSai() then
			strTips = i18n("worldwar_text_13")
		else
			strTips = i18n("offline_text_01")
		end
		SoraDShowMsgBox(strTips, i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				SoraDShowLoading()
				pyramidWarCtrl:sendPwXianXiaSaiEnterReq()
			end
		end)
	elseif tag == GameSettingKey.back then
		local strTips
		if pyramidWarCtrl:getIsInPwXianXiaSai() then
			strTips = i18n("worldwar_text_14")
		else
			strTips = i18n("offline_text_02")
		end
		SoraDShowMsgBox(strTips, i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				SoraDShowLoading()
				pyramidWarCtrl:sendPwXianXiaSaiExitReq()
			end
		end)
	elseif tag == GameSettingKey.friend then
		uiManager:show("friendView")
	elseif tag == GameSettingKey.remains_mode_anchor then
		local anchorUtil = include("anchorUtil")
		local err = anchorUtil.checkCanSwitchToAnchor()
		local errType = anchorUtil.errType
		if err == errType.ANCHOR_STATUS then
			SoraDShowMsgTip(i18n("Anchor_text_01"))
		elseif err == errType.ACTIVITY then
			SoraDShowMsgTip(i18n("Anchor_text_02"))
		elseif err == errType.NONE then
			SoraDShowMsgBox(i18n("Anchor_text_10"), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					anchorUtil.reqSwitchToAnchor()
				end
			end)
		end
	elseif tag == GameSettingKey.dj_mode then
		if SoraDGetCtrl("djCtrl").isDJ then
			VoiceChatSDKManager:getInstance():req4Permission()
			uiManager:show("DjSettingView")
		else
			SoraDShowMsgTip(i18n("Anchor_text_18"))
		end
	elseif tag == GameSettingKey.remains_mode_player then
		SoraDShowMsgBox(i18n("Anchor_text_03"), i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				local anchorUtil = include("anchorUtil")
				anchorUtil.reqSwitchToNormal()
			end
		end)
	elseif tag == GameSettingKey.remains_field then
		SoraDCreatePanel("anchorSearchView"):show()
	elseif tag == GameSettingKey.secondary_lock then
		uiManager:show("gameSecondaryLock")
	elseif tag == GameSettingKey.verification_code then
		uiManager:show("gameVerificationCode")
	else
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
return Item_set

local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local djHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/djHead", djHead)
function djHead:onInit()
	print("djHead onInit")
	self.canSpeak = true
	self.djInfo, _ENV, self.djuid = print, print, 0
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelTips = SoraDGetChildByName(self, "Text_tips")
	self.btnTip = SoraDGetChildByName(self, "btn_tip")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.labelPeople = SoraDGetChildByName(self, "Text_people")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.btnSwitch = SoraDGetChildByName(self.fields.Button_listen, "Switch")
	self.nodeDj = SoraDGetChildByName(self, "Node_dj")
	self.btnVoice = SoraDGetChildByName(self.fields.Button_voice, "Switch")
	self.btnList = SoraDGetChildByName(self, "Button_list")
	self.spriteRank = SoraDGetChildByName(self, "Sprite_rank")
	self.textServer = SoraDGetChildByName(self, "Text_server")
	self.text_tips_bg = SoraDGetChildByName(self, "text_tips_bg")
	self.btnVoice:addClickEventListener(handler(self, self.btnVoiceClickCallBack))
	self.btnList:addClickEventListener(handler(self, self.btnListClickCallBack))
	self.btnRank:addClickEventListener(handler(self, self.btnRankClickCallBack))
	self.btnSwitch:addClickEventListener(handler(self, self.btnSwitchClickCallBack))
	self.btnTip:addLongPressListener(handler(self, self.onTipPress))
	self.btnTip:addClickEventListener(handler(self, self.onTipClick))
	self.labelTips:setString(i18n("common_text_4761"))
	self.labelTips:setVisible(false)
	self.text_tips_bg:setVisible(false)
	self.fields.Button_listen:setVisible(false)
	self.textServer:setString(i18n("across_kingdom_list_title"))
	self.fields.Button_setting:setString(i18n("Anchor_text_143"))
	self.fields.Button_setting:addClickListener(handler(self, self.onSettingClick))
	self.fields.Button_historyGift:setString(i18n("Anchor_text_144"))
	self.fields.Button_historyGift:addClickListener(handler(self, self.onHistoryGiftClick))
end
function djHead:onShow()
	self.btnSwitch:setSelected(false)
end
function djHead:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_LISTEN_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_APPLY_LIST_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_EXIT_SPEAK", handler(self, self.closeVoiceBtn))
end
function djHead:initData(uid)
	self.speakList, _ENV, self.djuid = nil, nil, uid
	print("当前主播", self.djuid)
	self.isTheDj = djCtrl:isDJAnchor()
	self.isShowVoice = self.isTheDj
	self.controllers.isDJ:setSelectedIndex(self.isTheDj and 1 or 0)
	self:resetVoiceBtn()
	self:fixChildrenPos(true)
	self:updateData()
end
function djHead:updateData()
	self.djInfo = djCtrl:getDJInfo(self.djuid)
	self.isBroadcast = djCtrl.isBroadcast
	self:updatePublic()
	self.btnTip:setVisible(not djCtrl.isBroadcastDJ)
	self.fields.Button_listen:setVisible(not self.isTheDj)
	self:updateSpeakList()
	if self.isBroadcast then
		self.btnSwitch:setSelected(djCtrl.isListen)
		self.fields.Button_voice:setVisible(self.isShowVoice)
		self.btnList:setVisible(self.isTheDj)
		self.textServer:setVisible(self.isTheDj)
		self.labelPoint:setString(string.formatnumberthousands(self.djInfo.contributeCount))
		self.labelPeople:setString(string.formatnumberthousands(self.djInfo.listenNum))
	end
	SoraDCloseLoading()
end
function djHead:updatePublic()
	if self.isBroadcast then
		SoraDGetHeadFromManager(self.imgHead, self.djInfo.iconID, self.djInfo.avatar)
		self.labelName:setString(self.djInfo.nick_name)
		self.labelDes:setString(self.djInfo.anchor_sign)
	else
		self.labelName:setString(i18n("Anchor_text_21"))
		self.labelDes:setString(i18n("Anchor_text_22"))
		self.imgHead:setURL("frame_zblt_tx.png")
	end
end
function djHead:updateSpeakList()
	if not djCtrl:getRoomSetData() then
		local djCtrl, roomSetData = djCtrl:getRoomSetData(), djCtrl:getRoomSetData()
	end
	dump(roomSetData, "roomSetData====")
	local mode = roomSetData.msgModeIndex or 1
	local isShowSpeak = (djCtrl.isListen == true or self.isTheDj) and mode == 2 or false
	self.fields.yuyin:setVisible(isShowSpeak)
	if not djCtrl:getSpeakList() then
		djCtrl = djCtrl:getSpeakList()
	end
	self.speakList = djCtrl:getSpeakList()
	self.isShowVoice = self.isTheDj or mode == 2 and djCtrl:isInSpeak()
	for i = 1, 2 do
		self.fields["join_" .. i]:initData(self.speakList[i])
		self.fields["join_" .. i]:setVisible(isShowSpeak)
	end
	if self.isShowVoice and not self.isTheDj then
		self.fields.Button_voice:setPositionY(50)
	else
		self.fields.Button_voice:setPositionY(-4)
	end
end
function djHead:getSingleHeight()
	return self.layerCut:getContentSize().height
end
function djHead:btnListClickCallBack(button, type)
	SoraDPlaySound()
	_ENV = djCtrl
	djCtrl.title = i18n("Anchor_text_28")
	SoraDShowHelpMsgTip(djCtrl:getKidListStr(self.djuid), djCtrl)
end
function djHead:btnRankClickCallBack(button, type)
	SoraDPlaySound()
	_ENV = nil
	;(nil).uid = self.djuid
	uiManager:show("DjRankView", nil)
end
function djHead:btnSwitchClickCallBack(isListen)
	SoraDShowLoading()
	djCtrl:sendDJListen(djCtrl.isListen and 2 or 1)
end
function djHead:onTipPress()
	self.labelTips:setVisible(true)
	self.text_tips_bg:setVisible(true)
end
function djHead:onTipClick()
	self.labelTips:setVisible(false)
	self.text_tips_bg:setVisible(false)
end
function djHead:resetVoiceBtn()
	self.canSpeak = self.isTheDj
	self.btnVoice:setSelected(self.canSpeak)
end
function djHead:closeVoiceBtn()
	self.isShowVoice = false
	self.btnVoice:setSelected(false)
end
function djHead:btnVoiceClickCallBack(button, type)
	SoraDPlaySound()
	print("音量设置", djCtrl.isDJ, djCtrl.isBroadcastDJ, self.canSpeak)
	if self.isShowVoice then
		if self.canSpeak then
			self.canSpeak = false
			VoiceChatSDKManager:getInstance():end2Speak()
			if self.isTheDj then
				VoiceChatSDKManager:getInstance():mute(tostring(self.djuid))
			end
		else
			self.canSpeak = true
			VoiceChatSDKManager:getInstance():start2Speak()
		end
		self.btnVoice:setSelected(self.canSpeak)
	end
end
function djHead:onSettingClick()
	SoraDPlaySound()
	uiManager:show("DjSettingView")
end
function djHead:onHistoryGiftClick()
	SoraDPlaySound()
	uiManager:show("DjHistoryGift")
end
return djHead

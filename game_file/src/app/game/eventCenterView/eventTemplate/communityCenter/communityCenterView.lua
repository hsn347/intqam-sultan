local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
local communityCenterView = class("communityCenterView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end)
function communityCenterView:ctor()
	self.btnList, _ENV = nil, nil
	SoraDGetChildByName(self, "Text_name"):setString(i18n("activity_name_9001200"))
	self.infoData = activityShowCtrl:getCommunityInfo(gActivityTimeActivityID.COMMUNITY_CENTER)
	dump(self.infoData, "infoData", 10)
	dump(activityShowCtrl:getCommunityInfo(gActivityTimeActivityID.COMMUNITY_CENTER_MAIN_UI), "infoData", 10)
	self.nodeButton = SoraDGetChildByName(self, "Node_Button_Center")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("Community_text_02"))
	self.textTips:setString(i18n("Community_text_01"))
	self:initButtonInfo()
end
_ENV, _UPVALUE4_, communityCenterView.onMessageListener = function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end, function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end, function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end
;(function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end).id = gActivityCenterUIEnum.COMMUNITY_CENTER_1
;(function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end).icon = "btn_scommunity_center_facebook.png"
_ENV, (function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end).url = gActivityCenterUIEnum.COMMUNITY_CENTER_1, "https://www.facebook.com/slateen/"
gActivityCenterUIEnum.COMMUNITY_CENTER_1.id = gActivityCenterUIEnum.COMMUNITY_CENTER_2
gActivityCenterUIEnum.COMMUNITY_CENTER_1.icon = "btn_scommunity_center_instagram.png"
_ENV, gActivityCenterUIEnum.COMMUNITY_CENTER_1.url = gActivityCenterUIEnum.COMMUNITY_CENTER_2, "https://www.instagram.com/revengeofsultans/"
gActivityCenterUIEnum.COMMUNITY_CENTER_2.id = gActivityCenterUIEnum.COMMUNITY_CENTER_3
gActivityCenterUIEnum.COMMUNITY_CENTER_2.icon = "btn_scommunity_center_twitter.png"
_ENV, gActivityCenterUIEnum.COMMUNITY_CENTER_2.url = gActivityCenterUIEnum.COMMUNITY_CENTER_3, "https://twitter.com/EntkamElSlaten"
gActivityCenterUIEnum.COMMUNITY_CENTER_3.id = gActivityCenterUIEnum.COMMUNITY_CENTER_4
gActivityCenterUIEnum.COMMUNITY_CENTER_3.icon = "btn_scommunity_center_community.png"
gActivityCenterUIEnum.COMMUNITY_CENTER_3.url = ""
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end)[1] = function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("communityCenterView")
end
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end)[2] = gActivityCenterUIEnum.COMMUNITY_CENTER_1
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end)[3] = gActivityCenterUIEnum.COMMUNITY_CENTER_2
local (function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end)[4], uiEnum = gActivityCenterUIEnum.COMMUNITY_CENTER_3, function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initButtonInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", function(target, data)
		SoraDShowMsgTip(i18n("accompany_peer_text_07"))
	end)
end
function communityCenterView:initButtonInfo()
	for i, v in ipairs(uiEnum) do
		print(i, v)
		local single
		if not self.btnList[i] then
			local _ENV, info = self.btnList[i], self.btnList[i]
		end
		if not info.button then
			if i == 1 then
				single = SoraDGetChildByName(self.nodeButton, "Button_1")
			else
				single = self.btnList[1].button:clone()
				single:addTo(self.nodeButton)
			end
			info.button = single
			info.activityId = v.id
		else
			single = info.button
		end
		info.url = self.infoData.param["url_" .. v.id] or v.url
		info.new = activityCenterUICtrl:isHaveNewFlag(v.id)
		local isRed = not lordInfoCtrl:isReceiveCommunityReward(v.id)
		SoraDGetChildByName(single, "Sprite_Icon"):setSpriteFrame(v.icon)
		SoraDGetChildByName(single, "Sprite_Red"):setVisible(isRed)
		SoraDGetChildByName(single, "Sprite_New"):setVisible(info.new and not isRed)
		single:addTouchEventListener(handlerEx(self, self.btnClickJump, info))
		self.btnList[i] = info
	end
	SoraDToCenter(self.nodeButton, 100, SoraDFIsRA())
end
function communityCenterView:btnClickJump(info, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("communityCenterView-url", info.url)
		if info.activityId == gActivityCenterUIEnum.COMMUNITY_CENTER_4 and info.url == "" then
			print("···打开社区")
			userSDKManager.showSocial()
		else
			userSDKManager.openSDKLink(info.url)
		end
		activityCenterUICtrl:sendClearNewMsg(info.activityId)
		if not lordInfoCtrl:isReceiveCommunityReward(info.activityId) then
			_ENV = info.activityId
			info.activityId.id = info.activityId
			lordInfoCtrl:sendGetCommunityReward(info.activityId)
		end
	end
end
function communityCenterView:judgeClose(id)
	if id == gActivityTimeActivityID.COMMUNITY_CENTER then
		if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.COMMUNITY_CENTER) then
			self:layerClickCallBack(self, ccui.TouchEventType.ended)
		else
			print("communityCenterView-refresh")
			self.infoData = activityShowCtrl:getCommunityInfo(gActivityTimeActivityID.COMMUNITY_CENTER)
			self:initButtonInfo()
		end
	end
end
return communityCenterView

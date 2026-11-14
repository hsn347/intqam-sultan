local lordLocalData = include("lordLocalData")
local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local atlantisPrivilegeView = class("atlantisPrivilegeView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisPrivilegeView")
end)
function atlantisPrivilegeView:onEnterPanel()
	atlantisPrivilegeCtrl:reqAtlantisPrivilegeInit()
end
function atlantisPrivilegeView:ctor(properties)
	self.activityID = gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY
	self.nodeAtlantisPrivilegeGiftNode = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisPrivilegeGiftNode")
	self.nodeAtlantisPrivilegeOrderNode = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisPrivilegeOrderNode")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.spKingNormal = SoraDGetChildByName(self.nodeTop, "Top_Sprite_king_nor")
	self.btnKing = SoraDGetChildByName(self.nodeTop, "Button_King")
	self.btnKing:addTouchEventListener(handler(self, self.btnOrderClick))
	self.textRemainTime = SoraDGetChildByName(self.nodeTop, "Text_remainTime")
	self.textRemainTime = SoraDCreateTimerLabel(self, self.textRemainTime)
	_ENV, self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX"), SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX")
	SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX").defaultClick = "CCS_commonTabBtnEX", self.nodeTop, 1
	;("CCS_commonTabBtnEX").title = i18n("common_text_687")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 1
	_ENV, self.nodeTop[1], ("CCS_commonTabBtnEX").fontSize = "CCS_commonTabBtnEX", "CCS_commonTabBtnEX", 22
	;("CCS_commonTabBtnEX").title = i18n("common_text_1441")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 2
	SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX").tabsetArray, self.nodeTop[2], ("CCS_commonTabBtnEX").fontSize = self.nodeTop, "CCS_commonTabBtnEX", 22
	local param = SoraDGetExtendChildFromCCSByName(self.nodeTop, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtnEX:setContentSize(cc.size(640, 60))
	self.nodeCommonTabBtnEX:setNewStyle()
	self.nodeCommonTabBtnEX:initView(param)
	self.nodeCommonTabBtnEX:setRedPointOffset(cc.p(-10, -16))
	self.textKindomInfo = SoraDGetChildByName(self.nodeTop, "Text_KindomInfo")
	self.textKingInfo = SoraDGetChildByName(self.nodeTop, "Text_KingInfo")
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001350"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self:initActivityTime()
	self:initEffect()
end
function atlantisPrivilegeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH", handler(self, self.initData))
end
function atlantisPrivilegeView:initEffect()
	include("atlantisWarUtil").playFireAnimation(self)
end
function atlantisPrivilegeView:initActivityTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textRemainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	if eventTime then
		self.textRemainTime:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(SoraDGetChildByName(self, "Node_timer"), 10, SoraDFIsRA())
end
function atlantisPrivilegeView:initData(target, data)
	local ret = atlantisPrivilegeCtrl:getReceiveStatusAndNum() or false
	self.nodeCommonTabBtnEX:setRedPointState(2, ret)
	local kingdomInfo = atlantisPrivilegeCtrl:getInfoByOfficialType(1)
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		self.textKingInfo:setString(i18n("atlantiswar_privilege_text_0002") .. i18n("common_text_480"))
		self.textKindomInfo:setString(i18n("atlantiswar_privilege_text_0004") .. atlantisPrivilegeView:getKindomStr())
		self.spKingNormal:setVisible(false)
		return
	end
	self.textKindomInfo:setString(i18n("atlantiswar_privilege_text_0004") .. atlantisPrivilegeView:getKindomStr())
	self.textKingInfo:setString(i18n("atlantiswar_privilege_text_0002") .. textParser.formatPlayerName(kingdomInfo.allianceAbbr, kingdomInfo.nickName, kingdomInfo.kid))
	local portrait = lordLocalData.getPortrait(kingdomInfo.iconID)
	self.spKingNormal:setSpriteFrame(portrait)
end
function atlantisPrivilegeView:btnTabClick(tag, name)
	self.nodeAtlantisPrivilegeGiftNode:setVisible(tag == 2)
	self.nodeAtlantisPrivilegeOrderNode:setVisible(tag == 1)
end
function atlantisPrivilegeView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local atlantisWarUtil = include("atlantisWarUtil")
		if atlantisWarUtil.isNewMap() then
			SoraDShowHelpMsgTip(i18n("atlantiswar_privilege_text_0001_KOH"))
		else
			SoraDShowHelpMsgTip(i18n("atlantiswar_privilege_text_0001"))
		end
	end
end
function atlantisPrivilegeView:btnOrderClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("atlantisPrivilegeDetailPop")
		panel:init(1)
		panel:show()
	end
end
function atlantisPrivilegeView:getKindomStr()
	local str = ""
	local kindomList = atlantisPrivilegeCtrl:getKindomList()
	for i, v in ipairs(kindomList) do
		str = str .. "#" .. v
		if i ~= #kindomList then
			str = str .. ","
		end
	end
	return str
end
function atlantisPrivilegeView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return atlantisPrivilegeView

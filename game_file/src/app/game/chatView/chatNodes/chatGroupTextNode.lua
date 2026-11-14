local chatGroupBaseNode = include("chatGroupBaseNode")
local chatNodeFactory = include("chatNodeFactory")
local chatGroupTextNode = class("chatGroupTextNode", function(target)
	local target = chatGroupBaseNode.new("chatGroupTextNode")
	return target
end)
chatGroupTextNode._childConfig = clone(chatGroupBaseNode._childConfig)
_ENV = chatGroupBaseNode._childConfig
chatGroupBaseNode._childConfig.nodeType = gChatNodeType.text
chatGroupBaseNode._childConfig.zorder = 1
chatGroupTextNode._childConfig.contentNode, chatGroupBaseNode._childConfig.alignFunc = chatGroupBaseNode._childConfig, "alignNode_content"
function chatGroupTextNode:ctor()
	self.isDebug = gChatDebug
	self.isRichTextClick = true
	self._childConfig = chatGroupTextNode._childConfig
end
function chatGroupTextNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupTextNode._childConfig, data, target)
end
function chatGroupTextNode:onBeforeInitCustom()
	if self.data.dataType == gChatDataType.dataType_text then
		if self.data.isShowTranslate then
			self.data.bottomTextTip = self.data.translation.translateInfo
		else
			self.data.bottomTextTip = nil
			self.data.bottomTipSize = nil
		end
	elseif self.data.dataType == gChatDataType.dataType_collect_torch_require then
		self.isClickOnRichText = false
	end
end
function chatGroupTextNode:onAfterInitCustom()
end
function chatGroupTextNode:onClickHandler(target)
	if self.data.dataType == gChatDataType.dataType_collect_torch_require then
		local uid = self.data.customData.values.reqUid
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		print(uid, lordInfoCtrl:getLordInfo().base.uid)
		if uid ~= lordInfoCtrl:getLordInfo().base.uid then
			local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
			_ENV = lordInfoCtrl
			lordInfoCtrl.recUid = self.data.customData.values.reqUid
			lordInfoCtrl.fragmentID = self.data.customData.values.fragmentID
			lordInfoCtrl.indexID = self.data.customData.values.indexID
			collectSalaryCtrl:reqGetSendCheckData(lordInfoCtrl)
		end
		return
	end
	if self.isClickOnRichText then
		print("chatGroupTextNode:onClickHandler()检测到点击了富文本的信息, 直接返回")
		self.isClickOnRichText = false
		return
	end
	SoraDPlaySound()
	self:showMenu()
end
function chatGroupTextNode:onRichEventHandler(target, event)
	if type(event) == "table" and event.metatype ~= nil then
		self:onRichClickHandler(target, event)
		return
	end
	if G_IS_UNITY then
		self:onRichClickHandler(target, event)
	elseif event == ccui.TouchEventType.began then
		self.isClickOnRichText = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local metaInfo = target:getTouchMetaInfo(target:getTouchEndPosition())
		if metaInfo then
			self:onRichClickHandler(target, metaInfo)
		else
			self.isClickOnRichText = false
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
			self.isClickOnRichText = false
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.isClickOnRichText = false
	end
end
function chatGroupTextNode:onRichClickHandler(richText, metaInfo)
	local isHandle = false
	if metaInfo.metatype == ccui.RichTextMetaType.REPLACE then
		isHandle = self:onRichReplace(richText, metaInfo)
	elseif metaInfo.metatype == ccui.RichTextMetaType.LINK then
		print("点击了超链接")
		isHandle = self:onRichLink(richText, metaInfo)
	end
	if isHandle then
		SoraDPlaySound()
		self.isClickOnRichText = true
	end
end
function chatGroupTextNode:onRichReplace(richText, metaInfo)
	local funcName = "onRichReplace_" .. metaInfo.name
	local func = chatGroupTextNode[funcName]
	if func then
		return func(self, richText, metaInfo)
	else
		return self:onRichClickCommonView(richText, metaInfo)
	end
end
function chatGroupTextNode:onRichReplace_iconSys(richText, metaInfo)
	return false
end
function chatGroupTextNode:onRichLink(richText, metaInfo)
	local funcName = "onRichLink_" .. metaInfo.name
	local func = chatGroupTextNode[funcName]
	print("chatGroupTextNode:onRichLink", funcName, func)
	if func then
		return func(self, richText, metaInfo)
	else
		return self:onRichClickCommonView(richText, metaInfo)
	end
end
function chatGroupTextNode:onRichLink_dataType_bubble_post(richText, metaInfo)
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
		return true
	end
	local activityID = metaInfo.values.activityId or gActivityTimeActivityID.BUBBLE_CARNIVAL
	if not clientEventMgr.judgeIsOpen(activityID) then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return true
	end
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001692 then
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").tag = 2
		uiManager:show("Activity_9001692_Main", i18n("common_text_2486"))
	else
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").tag = 2
		uiManager:show("Activity_9001663_main", i18n("common_text_2486"))
	end
	return true
end
function chatGroupTextNode:onRichLink_frosty_market_share(richText, metaInfo)
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FROSTY_MARKET) then
		local isSameDay = serviceFunctions.isSameDay(metaInfo.values.t)
		if isSameDay then
			local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
			local skin = activity_9001678_Ctrl:getSkin()
			if skin == 1 then
				_ENV = i18n("common_text_1151", nil)
				i18n("common_text_1151", nil).values = metaInfo.values
				uiManager:show("Activity_9001678_HelpReward", i18n("common_text_1151", nil))
			elseif skin == 2 then
				_ENV = i18n("common_text_1151", nil)
				i18n("common_text_1151", nil).values = metaInfo.values
				uiManager:show("Activity_9001714_HelpReward", i18n("common_text_1151", nil))
			end
		else
			SoraDShowMsgTip(i18n("Frosty_Market_text_9"))
		end
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	return true
end
function chatGroupTextNode:onRichLink_reply_msg(richText, metaInfo)
	local msgID = tonumber(metaInfo.custom)
	if msgID and self.data then
		include("chatFunctions").navigateToReplyMsg(self.data.chatChannel, self.data.chatSet, self.data.key, msgID)
	end
	return true
end
function chatGroupTextNode:onRichLink_coordinate(richText, metaInfo)
	local chatDataParser = include("chatDataParser")
	local coordinate = chatDataParser.parseCoordinate(metaInfo.custom)
	if coordinate then
		SoraDPlaySound()
		if self.data.checkSelfMap and (worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle()) then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return false
		end
		SoraDGotoWorldMapPoint(coordinate, true, coordinate.k)
		SoraDRemoveAllPanelFromManager()
		return false
	end
	return true
end
_ENV, chatGroupTextNode.onRichClickCommonView = function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end, function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end
;(function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end)[gChatLinkName.coordinate] = chatGroupTextNode.onRichLink_Coordinate
_ENV, chatGroupTextNode.richLinkFuncs, (function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end)[gChatLinkName.reply_msg] = function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end, function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end, chatGroupTextNode.onRichLink_reply_msg
chatGroupTextNode.richReplaceFuncs, (function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end)[gChatReplaceName.iconSys] = function(self, richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end, chatGroupTextNode.onRichReplace_iconSys
return chatGroupTextNode

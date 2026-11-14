local chatGroupBaseNode = include("chatGroupBaseNode")
local chatGroupRedPacketNode = class("chatGroupRedPacketNode", function(target)
	local target = chatGroupBaseNode.new("chatGroupRedPacketNode")
	return target
end)
chatGroupRedPacketNode._childConfig = clone(chatGroupBaseNode._childConfig)
_ENV = chatGroupBaseNode._childConfig
chatGroupBaseNode._childConfig.nodeType = gChatNodeType.redpacket
chatGroupBaseNode._childConfig.zorder = 1
chatGroupRedPacketNode._childConfig.contentNode, chatGroupBaseNode._childConfig.alignFunc = chatGroupBaseNode._childConfig, "alignNode_content"
function chatGroupRedPacketNode:ctor()
	self.isDebug = gChatDebug
	self._childConfig = chatGroupRedPacketNode._childConfig
end
function chatGroupRedPacketNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupRedPacketNode._childConfig, data, target)
end
function chatGroupRedPacketNode:onClickHandler(target)
	SoraDPlaySound()
	if not worldMapDefine.inInCrossWar() then
		local content = self.data.customData
		dump(content, "红包数据-------222", 5)
		local isShowDetail = false
		if content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
				SoraDShowMsgTip(i18n("treasureChest_text_20"))
				return
			end
			local dropBoxCtrl = SoraDGetCtrl("dropBoxCtrl")
			local constantRead = include("constantRead")
			local useMax = constantRead.getConstValue("TREASURECHEAT_DAILY_USE_MAX")
			local usedCount = dropBoxCtrl:getToDayReceiveCount()
			if useMax - usedCount <= 0 then
				SoraDShowMsgTip(i18n("treasureChest_text_25"))
				return
			else
				print("可以领啦，进入领奖界面")
			end
		end
		local chatFunctions = include("chatFunctions")
		local uid = chatFunctions:getSelfId()
		local rid = content.redPacketInfo.RID
		print("请求查看红包-------------222, uid = ", uid, " , rid = ", rid)
		SoraDShowLoading()
		local gametop = gModuleMgr.getObject("gametop")
		local redenvelopesCtrl = gametop.playertop_:getModule("redenvelopesCtrl")
		local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
		if content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			chatRedPacketMgr:setIsReqViewDropBox(isShowDetail)
		else
			chatRedPacketMgr:setReqChatMessage(self.data)
		end
		redenvelopesCtrl:sendCheck(uid, rid)
	else
		SoraDShowMsgTip(i18n("common_text_4479"))
	end
end
function chatGroupRedPacketNode:onBeforeInitCustom()
	local isSelfClaimed = self:getIsClaimed()
	if self.data.isRPClaimed == nil or self.data.isRPClaimed ~= isSelfClaimed then
		self.data.bottomTipSize = nil
		if isSelfClaimed then
			self.data.bottomTextTip = i18n("common_text_1892")
		else
			self.data.bottomTextTip = i18n("common_text_1776")
		end
	end
end
function chatGroupRedPacketNode:onAfterInitCustom()
	self:initRedPacketStatus()
end
function chatGroupRedPacketNode:initRedPacketStatus()
	local isSelfClaimed = self:getIsClaimed()
	if self.data.isRPClaimed == nil or self.data.isRPClaimed ~= isSelfClaimed then
		self.data.isRPClaimed = isSelfClaimed
	end
	local contentNode = self.contentNode
	if isSelfClaimed then
		contentNode:setIsClaimed(true)
	else
		contentNode:setIsClaimed(false)
	end
end
function chatGroupRedPacketNode:getIsClaimed()
	local isSelfClaimed = false
	local customData = self.data.customData
	if customData and customData.redPacketInfo then
		local getStatus = customData.redPacketInfo.getStatus
		if getStatus == gUserRedEnvelopesStatus.ALREADY_GET then
			isSelfClaimed = true
		end
	end
	return isSelfClaimed
end
return chatGroupRedPacketNode

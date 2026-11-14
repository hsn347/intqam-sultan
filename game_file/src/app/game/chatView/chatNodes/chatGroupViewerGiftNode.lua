local nebulaAllStarRead = include("nebulaAllStarRead")
local chatBaseNode = include("chatBaseNode")
local chatGroupViewerGiftNode = class("chatGroupViewerGiftNode", function(target)
	local target = chatBaseNode.new("chatGroupViewerGiftNode")
	return target
end)
local nodeSize = cc.size(640, 314)
function chatGroupViewerGiftNode:ctor()
	self.width = nodeSize.width
	self.height = nodeSize.height
	local node = SoraDCreateCSBNode("chatGroupViewerGiftNode")
	node:addTo(self)
	node:setPosition(self.width / 2, self.height - 10)
	SoraDGetAllChildFromWidget(node, self)
	self.Image_box:addTouchEventListener(handler(self, self.onClickBox))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(timeStr)
		return timeStr .. i18n("NebulaAllstar_193")
	end)
	self.Text_time:setTimeEndListener(function()
		self.Text_time:setVisible(false)
	end)
end
function chatGroupViewerGiftNode:init(data)
	dump(data, "==chatGroupViewerGiftNode:init==")
	self.data = data
	if not self.data.customData.values then
		local _ENV, values = self.data.customData.values, self.data.customData.values
	end
	local giftName = nebulaAllStarRead.getViewerGiftName(values.giftType)
	self.Text_title:setString(giftName)
	if not self.data.serverMsg then
		local _ENV, serverMsg = self.data.serverMsg, self.data.serverMsg
	end
	local name = textParser.formatPlayerName(nil, self.data.nickName, serverMsg.kid)
	_ENV = serverMsg.kid
	serverMsg.kid.name1 = name
	serverMsg.kid.name2 = giftName
	self.content = i18n("NebulaAllstar_191", serverMsg.kid)
	self.Text_name:setString(self.content)
	local giftCD = nebulaAllStarRead.getConstValue("GiftPlunderCD", 10)
	local remainTime = values.time + giftCD - serviceFunctions.systemTime() + 1
	if 0 < remainTime then
		self.Text_time:setVisible(true)
		self.Text_time:beginTime(remainTime)
	else
		self.Text_time:setVisible(false)
	end
end
function chatGroupViewerGiftNode.measureSize(data, target)
	return nodeSize
end
function chatGroupViewerGiftNode:onClickBox(target, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self.data.customData.values then
		local _ENV, values = self.data.customData.values, self.data.customData.values
	end
	_ENV = nil
	;(nil).giftType = values.giftType
	;(nil).id = values.id
	;(nil).time = values.time
	;(nil).content = self.content
	uiManager:show("NebulaAllStarViewerGift", nil)
end
function chatGroupViewerGiftNode:onBeforeInitCustom()
end
function chatGroupViewerGiftNode:onAfterInitCustom()
end
return chatGroupViewerGiftNode

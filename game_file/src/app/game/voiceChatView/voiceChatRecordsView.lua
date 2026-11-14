local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local voiceChatRecordsView = class("voiceChatRecordsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatRecordsView")
	end
	return target
end)
function voiceChatRecordsView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_voice")
	self.nodeTitle:setTitle(i18n("common_text_836"))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg", true)
	self.ccsNightBg:setContentHeight(self:getPanelOffsetHeight() - 70)
	self.ccsNightBg:updateTheme()
	self.canUseOCXs, _ENV, self.listData, _ENV = self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.txtNotice = SoraDGetChildByName(self, "Top_Text_notice")
	self.txtNotice:setString(i18n("common_text_1464"))
	self:initData()
end
function voiceChatRecordsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONLEAVECHANNEL", handler(self, self.onExitRoom))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_EVENTRECORD", handler(self, self.initData))
end
function voiceChatRecordsView:initData(target, redata)
	self.roomRecords = voiceRoomCtrl:getRoomRecordsInfo()
	self:initView()
end
function voiceChatRecordsView:initView(...)
	self:listMembers()
	self.txtNotice:setVisible(not next(self.roomRecords))
end
function voiceChatRecordsView:cleanList(...)
	for _, v in pairs(self.listData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.canUseOCXs, v.point)
		end
	end
end
function voiceChatRecordsView:listMembers(...)
	self:cleanList()
	self.listData, _ENV = self.cleanList, self.cleanList
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.roomRecords * 112)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	table.sort(self.roomRecords, function(r, l)
		return r.time > l.time
	end)
	for i, v in ipairs(self.roomRecords) do
		_ENV = cc.size(sSize.width, sH)
		cc.size(sSize.width, sH).posX = sSize.width / 2
		cc.size(sSize.width, sH).posY = sH - (i - 1) * 112
		cc.size(sSize.width, sH).data = v
		table.insert(self.listData, cc.size(sSize.width, sH))
	end
	if not self.isInitScroll then
		self.scroll:addEventListener(handler(self, self.updateScroll))
		self.isInitScroll = true
	end
	self:updateScroll()
end
function voiceChatRecordsView:createItem(info, ocx)
	ocx = ocx or self.nodeSingle:clone()
	local img = SoraDGetChildByName(ocx, "Image_single")
	local msg = SoraDGetChildByName(ocx, "Text_msg")
	if false then
		img:setFlippedX(false)
		img:setPositionX(310)
		msg:setPositionX(70)
	else
		img:setFlippedX(true)
		img:setPositionX(-310)
		msg:setPositionX(-70)
	end
	msg:setString(voiceRoomCtrl.doRecordsMsg(info) .. "\n" .. os.date("!%Y-%m-%d %H:%M:%S", info.time))
	return ocx
end
function voiceChatRecordsView:updateScroll(...)
	local scrollInner = self.scroll:getInnerContainer()
	local sSize = self.scroll:getContentSize()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for k, v in pairs(self.listData) do
		if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
			if v.point then
				table.insert(self.canUseOCXs, v.point)
				v.point:setVisible(false)
				v.point = nil
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		elseif 0 < #self.canUseOCXs then
			v.point = table.remove(self.canUseOCXs)
			self:createItem(v.data, v.point)
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		else
			local single = self:createItem(v.data)
			single:setPosition(v.posX, v.posY)
			single:addTo(self.scroll)
			v.point = single
		end
	end
end
function voiceChatRecordsView:onExitRoom(target, redata)
	self:removeFromParent()
end
return voiceChatRecordsView

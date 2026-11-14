local djCtrl = SoraDGetCtrl("djCtrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local djScrollView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/djScrollView", djScrollView)
function djScrollView:onInit()
	self.giftQueueData, constantRead, self.giftItemData, constantRead, self.itemsData, constantRead = nil, nil, nil, nil, nil, nil
	self.maxGiftNum = 3
	self.fadeTime = constantRead.getConstValue("ANCHOR_GIFT_LIMIT_TIME", 10)
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.giftScroll = SoraDGetChildByName(self, "Gift_scrollView")
	self.scrollView:setVirtual()
	self.scrollView:setItemRenderer(handler(self, self.onItemRender))
	self.giftScroll:setItemRenderer(handler(self, self.onGiftRender))
	self.fields.Label_time:setTimeUpdateListener(handler(self, self.updateGiftShow))
end
function djScrollView:updateGiftShow(time)
	if time % self.fadeTime == 0 then
		self:updateGiftData()
	end
end
function djScrollView:onShow()
	self.fields.Label_time:beginTime(0, true)
end
function djScrollView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ROOM_MSG", handler(self, self.initData))
end
function djScrollView:initData(target, data)
	if data and data.info then
		if data.info.uid and data.info.itemID then
			local isMerge = false
			for k, v in ipairs(self.itemsData) do
				if data.info.uid == v.uid and data.info.itemID == v.itemID then
					self.itemsData[k].count = self.itemsData[k].count + data.info.count
					isMerge = true
					break
				end
			end
			if not isMerge then
				table.insert(self.itemsData, data.info)
			end
		else
			table.insert(self.itemsData, data.info)
		end
		self:updateGiftScroll(data.info)
	end
	self:updateMsgScroll()
end
function djScrollView:updateMsgScroll()
	self.scrollView:setNumItems(#self.itemsData)
	self.scrollView:jumpToBottom()
end
function djScrollView:refreshMsgScroll()
	self.scrollView:setNumItems(0)
	self.scrollView:setNumItems(#self.itemsData)
end
function djScrollView:updateGiftData(target, data)
	self.isMerge = false
	table.remove(self.giftItemData, 1)
	if #self.giftQueueData > 0 then
		local queueData = table.remove(self.giftQueueData, 1)
		if queueData then
			table.insert(self.giftItemData, queueData)
		end
	end
	self.giftScroll:setNumItems(#self.giftItemData)
end
function djScrollView:updateGiftScroll(info)
	self.isMerge = false
	if info.itemID and info.count then
		if #self.giftItemData < self.maxGiftNum and #self.giftQueueData == 0 then
			for index, data in ipairs(self.giftItemData) do
				if info.uid == data.uid and info.itemID == data.itemID then
					self.giftItemData[index].count = self.giftItemData[index].count + info.count
					self.isMerge = true
				end
			end
			if not self.isMerge then
				table.insert(self.giftItemData, clone(info))
			end
		else
			for index, data in ipairs(self.giftItemData) do
				if info.uid == data.uid and info.itemID == data.itemID then
					self.giftItemData[index].count = self.giftItemData[index].count + info.count
					self.isMerge = true
				end
			end
			if not self.isMerge then
				table.insert(self.giftQueueData, clone(info))
			end
		end
	end
	self.giftScroll:setNumItems(#self.giftItemData)
end
function djScrollView:onGiftRender(index, obj)
	obj:initData(self.giftItemData[index + 1])
end
function djScrollView:onItemRender(index, obj)
	local data = self.itemsData[index + 1]
	obj:initData(data)
end
return DjScrollView

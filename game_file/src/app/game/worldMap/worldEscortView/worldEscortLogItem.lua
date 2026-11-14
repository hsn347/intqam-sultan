local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local worldEscortLogItem = class("worldEscortLogItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldEscortLogItem")
	end
	return target
end)
function worldEscortLogItem:ctor()
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.onLayoutItem))
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_timeInfo = SoraDGetChildByName(self, "Text_timeInfo")
	self.imgIcon = SoraDGetChildByName(self, "imgIcon")
	self.itemIsMoved = false
	self:setAnchorPoint(cc.p(0, 0))
end
function worldEscortLogItem:initWithData(data)
	self.itemData = data
	local serverMsg = self.itemData.serverMsg
	local intelType = serverMsg.data.intelType
	local totalHeight = 0
	local autoHeight = 0
	local widthLayout = 600
	self.Text_des:setString(data.content)
	local timeStr = os.date("%m-%d %H:%M", serverMsg.t)
	self.Text_timeInfo:setString(timeStr)
	autoHeight = SoraDGetAutoHeightLabel(self.Text_des, self.Text_des:getContentSize().width)
	totalHeight = autoHeight + 68
	self.Image_itemBg:setContentSize(500, totalHeight)
	self.Panel_touch:setContentSize(cc.size(widthLayout, totalHeight))
	self.Text_des:setPosition(SoraDFPosX(-130, 0), totalHeight - 20)
	self.Text_timeInfo:setPosition(SoraDFPosX(-580, 0), 34)
	self.imgIcon:setPosition(SoraDFPosX(-50, 0), totalHeight / 2)
	if intelType == gEscortIntelType.ESCORT_WITH_MAX_LEVEL_CART then
		self.imgIcon:setSpriteFrame("icon_escort_convey.png")
		self.Text_des:setColor(cc.c3b(170, 50, 190))
	elseif intelType == gEscortIntelType.OPEN_ALLIANCE_GAIN_PLUS then
		self.imgIcon:setSpriteFrame("icon_escort_open.png")
		self.Text_des:setColor(cc.c3b(160, 80, 20))
	elseif intelType == gEscortIntelType.ESCORT_ROB then
		if data.isRobbed == true then
			self.imgIcon:setSpriteFrame("icon_escort_defend.png")
			self.Text_des:setColor(cc.c3b(40, 120, 150))
		else
			self.imgIcon:setSpriteFrame("icon_escort_plunder.png")
			self.Text_des:setColor(cc.c3b(30, 150, 10))
		end
		local selfPlayerID = gametop.playertop_:getPlayerID()
		local opPlayerID = serverMsg.data.opPlayer.uid
		if selfPlayerID == opPlayerID then
			self.Text_des:setColor(cc.c3b(0, 0, 0))
		else
			local targetPlayerIDs = serverMsg.data.targetPlayers
			for k, v in pairs(targetPlayerIDs) do
				if selfPlayerID == v.uid then
					self.Text_des:setColor(cc.c3b(190, 40, 40))
					break
				end
			end
		end
	end
	self.itemWidth = widthLayout
	self.itemHeight = totalHeight
end
function worldEscortLogItem:getItemWidth()
	return self.itemWidth
end
function worldEscortLogItem:getItemHeight()
	return self.itemHeight
end
function worldEscortLogItem:getLabelSize()
	return self.Text_des:getTextAreaSize()
end
function worldEscortLogItem:onLayoutItem(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_SHOW_CHAT_MENU"
		;(nil).itemData = self.itemData
		;(nil).sender = sender
		SoraDSendMessage(nil)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
	end
end
return worldEscortLogItem

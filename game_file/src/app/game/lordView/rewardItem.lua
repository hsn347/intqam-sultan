local publicRead = include("publicRead")
_UPVALUE3_ = "publicRead"
;("publicRead")[1] = 1
;("publicRead")[2] = 2
local ("publicRead")[3], itemStyleDef = 3, "publicRead"
local rewardItem = class("rewardItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rewardItem")
	end
	return target
end)
function rewardItem:ctor()
	self.itemStyle = 1
	self.labName = SoraDGetChildByName(self, "Text_name")
	self.labCount = SoraDGetChildByName(self, "Text_count")
	self.imgSquare = SoraDGetChildByName(self, "frame_square")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.itemBG = SoraDGetChildByName(self, "item_base_bg")
	self.btnItem:addTouchEventListener(handler(self, self.showDetail))
	self.btnItem:setSwallowTouches(false)
	self:initView()
end
function rewardItem:initView()
	if self.itemStyle == 1 then
		self.imgSquare:setSpriteFrame("frame_square_39.png")
		self.imgSquare:setScale(1.2)
	elseif self.itemStyle == 2 then
		self.imgSquare:setSpriteFrame("frame_square_15.png")
		self.imgSquare:setScale(0.6)
	elseif self.itemStyle == 3 then
		self.imgSquare:setSpriteFrame("frame_mailinfo_18.png")
		self.imgSquare:setScale(0.95)
	end
end
function rewardItem:initData(param)
	self.itemID = param.itemID
	self.itemNum = param.num or 1
	self.labName:setString(param.name or publicRead.getName(self.itemID))
	self.imgItem:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.itemBG:setSpriteFrame(publicRead.getBg(self.itemID))
	self.labCount:setString(self.itemNum)
end
function rewardItem:setItemStyle(style)
	if SoraDisInList(style, itemStyleDef) then
		self.itemStyle = style
		self:initView()
	end
end
function rewardItem:setItemCallBack(handle)
	self.handle = handle
end
function rewardItem:setItemTouchBeginHandle(handle)
	self.beginHandle = handle
end
function rewardItem:setForceBgColor(quality)
	if quality == gQualityDef.WHITE then
		self.itemBG:setSpriteFrame("frame_item_base_01.png")
	elseif quality == gQualityDef.GREEN then
		self.itemBG:setSpriteFrame("frame_item_base_02.png")
	elseif quality == gQualityDef.BLUE then
		self.itemBG:setSpriteFrame("frame_item_base_03.png")
	elseif quality == gQualityDef.PURPLE then
		self.itemBG:setSpriteFrame("frame_item_base_04.png")
	elseif quality == gQualityDef.ORANGE then
		self.itemBG:setSpriteFrame("frame_item_base_05.png")
	elseif quality == gQualityDef.GOLD then
		self.itemBG:setSpriteFrame("frame_item_base_06.png")
	end
end
function rewardItem:setLabNameColor(color)
	self.labName:setColor(color)
end
function rewardItem:hideLabName()
	self.labName:setVisible(false)
end
function rewardItem:setTipOffset(offset)
	self.tipOffset = offset
end
function rewardItem:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.handle then
			self.handle(self)
			return
		end
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		if self.beginHandle then
			print("rewardItem:showDetail")
			self.beginHandle(self)
			return
		end
		self.tips = SoraDCreatePanel("commonItemTips")
		self.tips:initData(self.itemID)
		local dt = 140
		if not SoraDFIsRA() then
			dt = -140
			if self.tipOffset then
				self.tipOffset.x = -math.abs(self.tipOffset.x)
			end
		end
		self.tips:setPosition(cc.p(dt + self:getPositionX(), self:getPositionY()))
		if self.tipOffset then
			self.tips:setPositionX(self.tips:getPositionX() + self.tipOffset.x)
			self.tips:setPositionY(self.tips:getPositionY() + self.tipOffset.y)
		end
		self.tips:addTo(self:getParent(), 99)
	end
end
return rewardItem

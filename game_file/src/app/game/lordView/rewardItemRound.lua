local publicRead = include("publicRead")
_UPVALUE3_ = "publicRead"
;("publicRead")[1] = 1
;("publicRead")[2] = 2
local ("publicRead")[3], itemStyleDef = 3, "publicRead"
local rewardItemRound = class("rewardItemRound", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rewardItemRound")
	end
	return target
end)
function rewardItemRound:ctor()
	self.itemStyle = 1
	self.labCount = SoraDGetChildByName(self, "Text_count")
	self.labCountShadow = SoraDGetChildByName(self, "Text_count_shadow")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.itemBG = SoraDGetChildByName(self, "item_base_bg")
	self.btnItem:addTouchEventListener(handler(self, self.showDetail))
	self.btnItem:setSwallowTouches(false)
	self:initView()
end
function rewardItemRound:initView()
end
function rewardItemRound:initData(param)
	self.itemID = param.itemID
	self.itemNum = param.num or 1
	self.imgItem:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self:setForceBgColor(publicRead.getQuality(self.itemID))
	self.labCount:setString(self.itemNum)
	self.labCountShadow:setString(self.itemNum)
	self.labCount:setPositionX(self.btnItem:getContentSize().width / 2)
	self.labCountShadow:setPositionX(self.labCount:getPositionX() + 1.5)
	self.labCountShadow:setPositionY(self.labCount:getPositionY() - 1.5)
end
function rewardItemRound:setItemStyle(style)
	if SoraDisInList(style, itemStyleDef) then
		self.itemStyle = style
		self:initView()
	end
end
function rewardItemRound:setItemCallBack(handle)
	self.handle = handle
end
function rewardItemRound:setItemTouchBeginHandle(handle)
	self.beginHandle = handle
end
function rewardItemRound:setForceBgColor(quality)
	if quality == gQualityDef.WHITE then
		self.itemBG:setColor(cc.c3b(89, 107, 102))
	elseif quality == gQualityDef.GREEN then
		self.itemBG:setColor(cc.c3b(19, 139, 108))
	elseif quality == gQualityDef.BLUE then
		self.itemBG:setColor(cc.c3b(35, 104, 181))
	elseif quality == gQualityDef.PURPLE then
		self.itemBG:setColor(cc.c3b(107, 48, 149))
	elseif quality == gQualityDef.ORANGE then
		self.itemBG:setColor(cc.c3b(224, 129, 6))
	elseif quality == gQualityDef.GOLD then
		self.itemBG:setColor(cc.c3b(229, 178, 0))
	end
end
function rewardItemRound:setLabNameColor(color)
end
function rewardItemRound:hideLabName()
end
function rewardItemRound:setTipOffset(offset)
	self.tipOffset = offset
end
function rewardItemRound:showDetail(button, type)
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
			print("rewardItemRound:showDetail")
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
return rewardItemRound

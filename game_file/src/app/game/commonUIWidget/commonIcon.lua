local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local longEventTime = 0.4
local commonIcon = class("commonIcon", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("commonIcon")
	end
end)
function commonIcon:ctor()
	self.scroll = nil
	self.touch = true
	self.id = nil
	self.num = 0
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Image_sheer = SoraDGetChildByName(self, "Image_sheer")
	self.Text_labNum = SoraDGetChildByName(self, "Text_labNum")
	self.Image_frm = SoraDGetChildByName(self, "Image_frm")
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	if self.Button_item then
		self.Button_item:setSwallowTouches(false)
		self.Button_item:setTouchEnabled(self.touch)
		self.Button_item:addTouchEventListener(handler(self, self.showTip))
	end
end
function commonIcon:initData(id, num)
	self.id = id
	self.num = num or 0
	if self.Image_quality then
		self.Image_quality:loadTexture(publicRead.getBg(self.id), ccui.TextureResType.plistType)
	end
	if self.Image_icon then
		self.Image_icon:loadTexture(publicRead.getIcon(self.id), ccui.TextureResType.plistType)
	end
	if self.Text_num and self.num > 0 then
		self.Text_num:setString(string.formatnumberthousands(self.num))
	end
	local specialNum = itemDesRead.getNumByID(self.id)
	if self.Image_sheer then
		self.Image_sheer:setVisible(specialNum ~= nil)
	end
	if self.Text_labNum then
		self.Text_labNum:setVisible(specialNum ~= nil)
		self.Text_labNum:setString(specialNum and specialNum or "")
	end
end
function commonIcon:setScroll(scroll)
	self.scroll = scroll
end
function commonIcon:setTouch(enable)
	self.touch = enable
	if self.Button_item then
		self.Button_item:setTouchEnabled(self.touch)
	end
end
function commonIcon:getIconInfo()
	return self.id, self.num
end
function commonIcon:showTip(target, event)
	if event == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		_ENV = "node is not on view"
		;("node is not on view").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		SoraDSendMessage("node is not on view")
		longEventTime = "node is not on view"
		;("node is not on view")[1] = cca.delay(longEventTime)
		;("node is not on view")[2] = cca.callFunc(function()
			SoraDPlaySound()
			print("显示tip")
			local worldPos = self:convertToWorldSpace(cc.p(0, 0))
			local defaultPos = cc.p(worldPos.x, worldPos.y + 150 * self:getScaleY() / 2)
			_ENV = worldPos.y + 150 * self:getScaleY() / 2
			;(worldPos.y + 150 * self:getScaleY() / 2).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			;(worldPos.y + 150 * self:getScaleY() / 2).id = self.id
			;(worldPos.y + 150 * self:getScaleY() / 2).pos = defaultPos
			SoraDSendMessage(worldPos.y + 150 * self:getScaleY() / 2)
		end)
		;("node is not on view")[3] = cca.callFunc(function()
			SoraDPlaySound()
			print("显示tip")
			local worldPos = self:convertToWorldSpace(cc.p(0, 0))
			local defaultPos = cc.p(worldPos.x, worldPos.y + 150 * self:getScaleY() / 2)
			_ENV = worldPos.y + 150 * self:getScaleY() / 2
			;(worldPos.y + 150 * self:getScaleY() / 2).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			;(worldPos.y + 150 * self:getScaleY() / 2).id = self.id
			;(worldPos.y + 150 * self:getScaleY() / 2).pos = defaultPos
			SoraDSendMessage(worldPos.y + 150 * self:getScaleY() / 2)
		end)
		local seqLong = cca.seq("node is not on view")
		self:runAction(seqLong)
	elseif event == ccui.TouchEventType.ended then
		print("掩藏tip")
		_ENV = "掩藏tip"
		;("掩藏tip").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		SoraDSendMessage("掩藏tip")
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			print("掩藏tip")
			_ENV = "掩藏tip"
			;("掩藏tip").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			SoraDSendMessage("掩藏tip")
		end
	elseif event == ccui.TouchEventType.canceled then
		print("掩藏tip")
		_ENV = "掩藏tip"
		;("掩藏tip").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		SoraDSendMessage("掩藏tip")
	end
end
return commonIcon

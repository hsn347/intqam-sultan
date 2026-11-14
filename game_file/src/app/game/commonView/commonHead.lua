local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local commonHead = class("commonHead", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonHead")
	end
	return target
end)
function commonHead:ctor()
	self.scroll = nil
	self.handle = nil
	self.playerID = nil
	self.scale = self:getScale()
	self.Image_light = SoraDGetChildByName(self, "Image_light")
	self.Image_light:setVisible(false)
	self.Image_headBg = SoraDGetChildByName(self, "Image_headBg")
	self.Sprite_head = SoraDGetChildByName(self, "Sprite_head")
	if G_IS_UNITY then
		self.Sprite_head:ignoreContentAdaptWithSize(false)
		self.Sprite_head:setFill(fgui.LoaderFillType.SCALE_FREE)
	end
	self.Image_frame = SoraDGetChildByName(self, "Image_frame")
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:setSwallowTouches(false)
	self.Button_touch:setTouchEnabled(true)
	self.Button_touch:addTouchEventListener(handler(self, self.onTouchHeadBack))
	self:setContentSize()
end
function commonHead:setHeadSprite(imageId, avatar)
	local info = lordInfoCtrl:getBaseInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	if type(imageId) == "number" then
		SoraDGetHeadFromManager(self.Sprite_head, imageId, avatar)
	elseif type(imageId) == "string" then
		self.Sprite_head:setSpriteFrame(imageId)
	end
end
function commonHead:setPlayerID(id)
	local id = id or gametop.playertop_:getPlayerID()
	self.playerID = id
end
function commonHead:setKid(kid)
	self.kid = kid
end
function commonHead:getPlayerID()
	return self.playerID
end
function commonHead:getKid()
	return self.kid
end
function commonHead:setBgLightVisible(isVisible)
	local ret = isVisible and true or false
	self.Image_light:setVisible(ret)
end
function commonHead:setTouchEnabled(enable)
	self.Button_touch:setTouchEnabled(enable)
end
function commonHead:setSwallowTouches(enable)
	self.Button_touch:setSwallowTouches(enable)
end
function commonHead:setScroll(scroll)
	self.scroll = scroll
end
function commonHead:setHandle(handle)
	self.handle = handle
end
function commonHead:setScale(scale)
	self.scale = scale
	self:setContentSize()
end
function commonHead:setContentSize()
	local baseW = 100
	local baseLightW = 124
	self.Image_light:setContentSize(cc.size(baseLightW * self.scale, baseLightW * self.scale))
	self.Image_headBg:setContentSize(cc.size(baseW * self.scale, baseW * self.scale))
	self.Sprite_head:setScale(self.scale)
	self.Image_frame:setContentSize(cc.size(baseW * self.scale, baseW * self.scale))
	self.Button_touch:setContentSize(cc.size(baseW * self.scale, baseW * self.scale))
end
function commonHead:onTouchHeadBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle()
		elseif self.playerID then
			_ENV = "node is not on view"
			;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;("node is not on view").playerID = self.playerID
			;("node is not on view").kid = self.kid
			SoraDSendMessage("node is not on view")
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function commonHead:setGray(isGray)
	SoraDSetNodeGray(self.Sprite_head, isGray)
	SoraDSetNodeGray(self.Image_frame, isGray)
end
return commonHead

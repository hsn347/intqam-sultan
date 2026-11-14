local itemDesRead = include("itemDesRead")
local mailFunctions = include("mailFunctions")
local publicRead = include("publicRead")
local mailItemBox = class("mailItemBox", function(target)
	return ccui.Layout:create()
end)
function mailItemBox:createUI()
	self:setCascadeOpacityEnabled(true)
	local layout_content = ccui.Layout:create()
	layout_content:setName("content")
	layout_content:setAnchorPoint(cc.p(0, 0))
	layout_content:setPosition(cc.p(0, 0))
	layout_content:setContentSize(cc.size(106, 106))
	self:addChild(layout_content)
	self.contentPanel = layout_content
	self.contentPanel:setCascadeOpacityEnabled(true)
	local imgBg = ccui.ImageView:create()
	imgBg:setName("img_frame_Bg")
	imgBg:setPosition(cc.p(-2, -3))
	imgBg:setAnchorPoint(cc.p(0, 0))
	imgBg:loadTexture("frame_mailinfo_18.png", ccui.TextureResType.plistType)
	imgBg:setContentSize(cc.size(115, 115))
	imgBg:ignoreContentAdaptWithSize(false)
	self.contentPanel:addChild(imgBg, 3)
	self.imgBg = imgBg
	local imgColor = ccui.ImageView:create()
	imgColor:setName("Image_bg")
	imgColor:loadTexture("frame_item_base_02.png", ccui.TextureResType.plistType)
	imgColor:setContentSize(cc.size(86, 86))
	imgColor:setAnchorPoint(cc.p(0.5, 0.5))
	imgColor:setPosition(cc.p(55, 55))
	imgColor:ignoreContentAdaptWithSize(false)
	self.contentPanel:addChild(imgColor, 1)
	self.imgColor = imgColor
	local img_item = ccui.ImageView:create()
	img_item:setName("Image_item")
	img_item:loadTexture("1001.png", ccui.TextureResType.plistType)
	img_item:setContentSize(cc.size(86, 86))
	img_item:setAnchorPoint(cc.p(0.5, 0.5))
	img_item:setPosition(cc.p(55, 55))
	img_item:ignoreContentAdaptWithSize(false)
	self.contentPanel:addChild(img_item, 2)
	self.img_item = img_item
end
function mailItemBox:ctor()
	self:createUI()
	if not self.imgBg then
		self.imgBg = SoraDGetChildByName(self, "img_frame_Bg")
	end
	if not self.imgColor then
		self.imgColor = SoraDGetChildByName(self, "Image_bg")
	end
	if not self.img_item then
		self.img_item = SoraDGetChildByName(self, "Image_item")
	end
end
function mailItemBox:initWithData(data)
	self.itemData = data
	local itemId = data.id
	self.imgBg:setVisible(true)
	self.imgColor:setVisible(true)
	if false == SoraDJudgeResOrItem(itemId) then
		local imgIconName = publicRead.getIcon(itemId)
		self.img_item:loadTexture(imgIconName, ccui.TextureResType.plistType)
		if itemId == gIDDef.GOLD or itemId == gIDDef.BORE then
			self.imgColor:loadTexture("frame_item_base_05.png", ccui.TextureResType.plistType)
		else
			self.imgBg:setVisible(false)
			self.imgColor:setVisible(false)
			self.imgColor:loadTexture("frame_square_black_06.png", ccui.TextureResType.plistType)
		end
		return
	end
	local iconName = publicRead.getIcon(itemId, false)
	local colorBgName = publicRead.getBg(itemId, false)
	self.img_item:loadTexture(iconName, ccui.TextureResType.plistType)
	self.imgColor:loadTexture(colorBgName, ccui.TextureResType.plistType)
	if data.hideColor then
		self.imgColor:setVisible(false)
		self.imgBg:setVisible(false)
	else
		self.imgColor:setVisible(true)
		self.imgBg:setVisible(true)
	end
	if data.showItemInfo then
		self.contentPanel:setTouchEnabled(true)
		self.contentPanel:addTouchEventListener(handler(self, self.OnBtnItemClick))
	else
		self.contentPanel:setTouchEnabled(false)
	end
end
function mailItemBox:gray()
	self.img_item:setColor(cc.c3b(120, 120, 120))
end
function mailItemBox:getItemWidth()
	return self.contentPanel:getContentSize().width
end
function mailItemBox:getItemHeight()
	return self.contentPanel:getContentSize().height
end
function mailItemBox:runAnimFadeIn(dt)
	self.imgBg:runAction(cca.fadeIn(dt))
	self.imgColor:runAction(cca.fadeIn(dt))
	self.img_item:runAction(cca.fadeIn(dt))
end
function mailItemBox:runAnimFadeOut(dt)
	self.imgBg:runAction(cca.fadeOut(dt))
	self.imgColor:runAction(cca.fadeOut(dt))
	self.img_item:runAction(cca.fadeOut(dt))
end
function mailItemBox:setNodeOpacity(o)
	self.imgBg:setOpacity(o)
	self.imgColor:setOpacity(o)
	self.img_item:setOpacity(o)
end
function mailItemBox:openItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SHOW_ITEMINFO"
	;(nil).id = self.itemData.id
	;(nil).item = self
	SoraDSendMessage(nil)
end
function mailItemBox:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_CLOSE_ITEMINFO"
	SoraDSendMessage(nil)
end
function mailItemBox:OnBtnItemClick(target, event)
	if event == ccui.TouchEventType.began then
		SoraDPlaySound()
		self:openItemInfo()
	elseif event == ccui.TouchEventType.ended then
		self:stopAllActions()
		self:closeItemInfo()
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self:stopAllActions()
		self:closeItemInfo()
		self.singleIsMoved = false
	end
end
return mailItemBox

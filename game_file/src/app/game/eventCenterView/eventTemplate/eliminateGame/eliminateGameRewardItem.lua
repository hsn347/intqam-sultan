local gametop = gModuleMgr.getObject("gametop")
local eliminateGameRewardItem = class("eliminateGameRewardItem", function(target)
	if target == nil then
		return ccui.Layout:create()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function eliminateGameRewardItem:ctor()
	self:setCascadeOpacityEnabled(true)
	self:createUI()
	self.singleIsMoved = false
	self.itemWidth = 170
	self.itemHeight = 170
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:setAnchorPoint(cc.p(0, 0))
end
function eliminateGameRewardItem:createUI()
	self.btnItem = ccui.Button:create("frame_square_36.png", "frame_square_36.png", "frame_square_36.png", ccui.TextureResType.plistType)
	self.btnItem:setPosition(cc.p(76.5, 76.5))
	self.btnItem:setPressedActionEnabled(false)
	self.btnItem:addTo(self, 1)
	self.btnItem:setCascadeOpacityEnabled(true)
	local imgFrame = display.newSprite("#frame_square_39.png")
	imgFrame:setPosition(cc.p(self.btnItem:getContentSize().height / 2, self.btnItem:getContentSize().height / 2))
	imgFrame:addTo(self.btnItem, 2)
	imgFrame:setScale(2.1)
	imgFrame:setCascadeOpacityEnabled(true)
	self.btnItem:setSwallowTouches(false)
end
function eliminateGameRewardItem:initWithData(data)
	self.itemData = data
	if self.itemData then
		local itmeType = JudgeItemType(self.itemData.itemid)
		if itmeType ~= gIDType.PACKAGE and self.btnItem then
			self.btnItem:addTouchEventListener(handler(self, self.OnBtnItemClick))
		end
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			imgBg:setCascadeOpacityEnabled(true)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView:setCascadeOpacityEnabled(true)
			imgView = ccui.ImageView:create("frame_sheer_items.png", ccui.TextureResType.plistType)
			imgView:setAnchorPoint(cc.p(0.5, 0))
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, 0))
			imgView:addTo(imgBg)
			imgView:setCascadeOpacityEnabled(true)
			imgView:setFlippedX(not SoraDFIsRA())
			imgView:setScaleY(1.8)
			imgView:setScaleX(1.27)
			_ENV = imgView
			imgView.text = ""
			imgView.font = "res/Default/defaultBMFont.fnt"
			imgView.align = SoraDFLabelR()
			imgView.x = 10
			imgView.y = 16
			local labelNum = display.newBMFontLabel(imgView)
			labelNum:setScale(2)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(SoraDFAP(0, 0.5))
			labelNum:addTo(imgBg)
			labelNum:setPosition(SoraDFPoint(10, 24, imgBg:getContentSize().width))
			self.item = include("commonItems").new(self.item)
			self.item:setCascadeOpacityEnabled(true)
		end
		_ENV = display.newBMFontLabel(imgView)
		display.newBMFontLabel(imgView).itemID = self.itemData.itemid
		display.newBMFontLabel(imgView).itemCount = self.itemData.itemnum
		self.item:initData((display.newBMFontLabel(imgView)))
		if itmeType == gIDType.PACKAGE then
			self.item.num:setVisible(false)
			self.item.item:setSpriteFrame("icon_item_more.png")
		end
		self.item:setVisible(true)
	elseif self.item then
		self.item:setVisible(false)
	end
end
function eliminateGameRewardItem:OnBtnItemClick(target, event)
	if event == ccui.TouchEventType.began then
		self:openItemInfo()
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
		self.singleIsMoved = false
	end
end
function eliminateGameRewardItem:openItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_ELIMINATEGAME_SHOW_ITEMINFO"
	;(nil).id = self.itemData.itemid
	;(nil).item = self
	SoraDSendMessage(nil)
end
function eliminateGameRewardItem:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_ELIMINATEGAME_CLOSE_ITEMINFO"
	SoraDSendMessage(nil)
end
function eliminateGameRewardItem:getItemWidth()
	return self.itemWidth
end
function eliminateGameRewardItem:getItemHeight()
	return self.itemHeight
end
return eliminateGameRewardItem

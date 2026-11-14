local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mailFunctions = include("mailFunctions")
local lordLocalData = include("lordLocalData")
local mailDesRead = include("mailDesRead")
local worldMapDefine = include("worldMapDefine")
local itemDesRead = include("itemDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local chatDesRead = include("chatDesRead")
local chatFunctions = include("chatFunctions")
local chatRoomGroupBar = class("chatRoomGroupBar", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatRoomGroupBar:ctor()
	local itemSize = cc.size(640, 50)
	local widthLayout = 640
	self:setAnchorPoint(cc.p(0, 0))
	self:setContentSize(itemSize)
	local img_bg = ccui.ImageView:create()
	img_bg:loadTexture("frame_mailinfo_05.png", ccui.TextureResType.plistType)
	img_bg:setScale9Enabled(true)
	img_bg:setCapInsets(cc.rect(10, 10, 2, 18))
	img_bg:setContentSize(cc.size(itemSize.width, itemSize.height - 4))
	self.img_bg = img_bg
	self.img_bg:setPosition(cc.p(0, 4))
	self.img_bg:setAnchorPoint(cc.p(0, 0))
	self.img_bg:addTo(self)
	_ENV = self.img_bg
	self.img_bg.text = "R0"
	self.img_bg.size = 24
	self.img_bg.color = cc.c3b(189, 164, 145)
	self.img_bg.align = SoraDFLabelR()
	self.img_bg.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.img_bg.x = 630
	self.img_bg.y = 25
	self.label_title = display.newTTFLabel(self.img_bg)
	self.label_title:setAnchorPoint(SoraDFAP(1, 0.5))
	self.label_title:addTo(self)
	self.label_title:setPosition(SoraDFPoint(630, itemSize.height / 2, widthLayout))
	self.img_arrow = display.newSprite("#frame_mail_arrow.png", SoraDFPoint(43.0, 41.5, widthLayout))
	self.img_arrow:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.img_arrow:setPosition(SoraDFPoint(570.0, 26, widthLayout))
	self.img_arrow:addTo(self)
	self.img_arrow:setRotation(-90)
	self.img_arrow:setScale(0.5)
	if not SoraDFIsRA() then
		self.img_arrow:setFlippedX(true)
	end
	self.layout_item = ccui.Layout:create()
	self.layout_item:setAnchorPoint(cc.p(1, 0))
	self.layout_item:setPosition(cc.p(640, 0))
	self.layout_item:addTo(self)
	self.layout_item:setTouchEnabled(true)
	self.layout_item:setSwallowTouches(false)
	self.layout_item:setContentSize(itemSize)
	self.layout_item:addTouchEventListener(handler(self, self.onLayoutItem))
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
end
function chatRoomGroupBar:initWithData(data)
	self.itemData = data
	self.isKingdom = data.isKingdom
	self.rankLv = data.rankLv
	if self.isKingdom then
		self.label_title:setString(i18n("atlantiswar_text_0109"))
	else
		local title = "R0"
		if self.rankLv == gAllianceRank.OFFICIAL then
			title = i18n("common_text_686")
		else
			title = "R" .. (data.rankLv or 0)
		end
		self.label_title:setString(title)
	end
	if not SoraDFIsRA() then
		self.img_arrow:setPositionX(self.label_title:getPositionX() + self.label_title:getContentSize().width + 20)
	else
		self.img_arrow:setPositionX(self.label_title:getPositionX() - self.label_title:getContentSize().width - 20)
	end
	if self.itemData.isCollapse then
		self.img_arrow:setRotation(90)
	else
		self.img_arrow:setRotation(-90)
	end
end
function chatRoomGroupBar:getItemWidth()
	return self.itemWidth
end
function chatRoomGroupBar:getItemHeight()
	return self.itemHeight + 2
end
function chatRoomGroupBar:setScrollView(scrollView)
	self.scrollView = scrollView
end
function chatRoomGroupBar:reset(ignoreAnim)
end
function chatRoomGroupBar:onLayoutItem(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("TODO:折叠该选项----------------------, rankLv = ", self.rankLv)
		self.itemData.isCollapse = not self.itemData.isCollapse
		_ENV = not self.itemData.isCollapse
		;(not self.itemData.isCollapse).msg = "MESSAGE_CHAT_ROOM_TOGGLE_GROUP_BAR"
		;(not self.itemData.isCollapse).rankLv = self.rankLv
		;(not self.itemData.isCollapse).isKingdom = self.isKingdom
		SoraDSendMessage(not self.itemData.isCollapse)
		if self.itemData.isCollapse then
			self.img_arrow:setRotation(90)
		else
			self.img_arrow:setRotation(-90)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatRoomGroupBar:setIsCollapse(isCollapse)
	self.itemData.isCollapse = isSelected
	if self.itemData.isCollapse then
		self.img_arrow:setRotation(90)
	else
		self.img_arrow:setRotation(-90)
	end
end
return chatRoomGroupBar

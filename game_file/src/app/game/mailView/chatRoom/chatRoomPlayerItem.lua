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
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local chatRoomPlayerItem = class("chatRoomPlayerItem", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatRoomPlayerItem:ctor()
	local itemSize = cc.size(640, 110)
	local widthLayout = 640
	self.deltaX = 0
	self.offsetX = 0
	self.layout_item = ccui.Layout:create()
	self.layout_item:setAnchorPoint(cc.p(1, 0))
	self.layout_item:setPosition(cc.p(640, 0))
	self.layout_item:addTo(self)
	self.layout_item:setTouchEnabled(true)
	self.layout_item:setSwallowTouches(false)
	self.layout_item:setContentSize(itemSize)
	self.layout_item:addTouchEventListener(handler(self, self.onLayoutItem))
	local spriteBg = ccui.ImageView:create()
	spriteBg:loadTexture("frame_mail_sheer_01.png", ccui.TextureResType.plistType)
	spriteBg:setScale9Enabled(true)
	spriteBg:setCapInsets(cc.rect(10, 10, 34, 34))
	spriteBg:setContentSize(itemSize)
	self.spriteBg = spriteBg
	self.spriteBg:setPosition(cc.p(0, itemSize.height / 2))
	self.spriteBg:setAnchorPoint(cc.p(0, 0.5))
	self.spriteBg:addTo(self.layout_item)
	local iconBg = ccui.ImageView:create()
	iconBg:loadTexture("frame_mailinfo_18.png", ccui.TextureResType.plistType)
	iconBg:setContentSize(cc.size(100, 100))
	iconBg:ignoreContentAdaptWithSize(false)
	iconBg:setAnchorPoint(SoraDFAP(0.5, 0.5))
	iconBg:setPosition(SoraDFPoint(585, itemSize.height / 2, widthLayout))
	iconBg:addTo(self.layout_item, 2)
	self.iconBg = iconBg
	self.img_icon = ccui.ImageView:create("head_m_001.png", ccui.TextureResType.plistType)
	self.img_icon:setPosition(SoraDFPoint(585, itemSize.height / 2, widthLayout))
	self.img_icon:ignoreContentAdaptWithSize(false)
	self.img_icon:setContentSize(cc.size(80, 80))
	self.img_icon:addTo(self.layout_item)
	_ENV = self.img_icon
	self.img_icon.text = ""
	self.img_icon.size = 24
	self.img_icon.color = cc.c3b(41, 21, 6)
	self.img_icon.align = SoraDFLabelR()
	self.img_icon.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.img_icon.x = 524
	self.img_icon.y = itemSize.height / 2
	self.label_title = display.newTTFLabel(self.img_icon)
	self.label_title:setAnchorPoint(SoraDFAP(1, 0.5))
	self.label_title:addTo(self.layout_item)
	self.label_title:setPosition(SoraDFPoint(524.0, itemSize.height / 2, widthLayout))
	self.btn_check = ccui.CheckBox:create("frame_mail_03.png", "icon_yes3.png")
	self.btn_check:setAnchorPoint(cc.p(0.5, 0.5))
	self.btn_check:setContentSize(cc.size(70, 70))
	self.btn_check:setPosition(SoraDFPoint(48, 55, widthLayout))
	self.btn_check:addTo(self.layout_item)
	self.btn_check:addEventListener(handler(self, self.checkEvent))
	self.imgSelect = ccui.ImageView:create()
	self.imgSelect:loadTexture("icon_yes.png", ccui.TextureResType.plistType)
	self.imgSelect:setContentSize(cc.size(39, 41))
	self.imgSelect:ignoreContentAdaptWithSize(false)
	self.imgSelect:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.imgSelect:setPosition(SoraDFPoint(48, 55, widthLayout))
	self.imgSelect:addTo(self.layout_item)
	self.imgSelect:setVisible(false)
	_ENV = self.imgSelect
	self.imgSelect.text = ""
	self.imgSelect.size = 24
	self.imgSelect.color = cc.c3b(41, 21, 6)
	self.imgSelect.align = SoraDFLabelL()
	self.imgSelect.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.imgSelect.x = 524
	self.imgSelect.y = itemSize.height / 2
	self.label_online = display.newTTFLabel(self.imgSelect)
	self.label_online:setAnchorPoint(SoraDFAP(0, 0.5))
	self.label_online:addTo(self.layout_item)
	self.label_online:setPosition(SoraDFPoint(34.0, itemSize.height / 2, widthLayout))
	self.label_online:setVisible(false)
	local lineTop = display.newSprite("#frame_mail_line_02.png", 320, 111)
	lineTop:addTo(self, 1)
	lineTop:setScaleX(640 / lineTop:getContentSize().width)
	local lineBottom = display.newSprite("#frame_mail_line_02.png", 320, -1)
	lineBottom:addTo(self, 1)
	lineBottom:setScaleX(640 / lineTop:getContentSize().width)
	local itemSize = self.layout_item:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
end
function chatRoomPlayerItem:initWithData(data)
	self.imgSelect:setVisible(false)
	self:hideMask()
	self.itemData = data
	self:updateIcon()
	self:updateTitle()
	self:updateCheck()
	self:updateOnline()
	self:updateInWar()
end
function chatRoomPlayerItem:updateOnline()
	self.label_online:setString(i18n("common_text_3976"))
	self.label_online:setVisible(false)
	if self.itemData.isOnline ~= nil then
		if self.itemData.isOnline == false then
			self.label_online:setVisible(true)
			self.btn_check:setVisible(false)
			self.imgSelect:setVisible(false)
			_UPVALUE2_ = self.imgSelect
			self.imgSelect[1] = self.iconBg
			self.imgSelect[2] = self.img_icon
			SoraDSetArrayGray(self.imgSelect, true)
		else
			_UPVALUE2_ = self.imgSelect
			self.imgSelect[1] = self.iconBg
			self.imgSelect[2] = self.img_icon
			SoraDSetArrayGray(self.imgSelect, false)
		end
	end
end
function chatRoomPlayerItem:updateInWar()
	if self.itemData.sourceKid ~= nil and self.itemData.sourceKid ~= 0 then
		self.label_online:setString(i18n("common_text_4591"))
		self.label_online:setVisible(true)
		self.btn_check:setVisible(false)
		self.imgSelect:setVisible(false)
	end
end
function chatRoomPlayerItem:updateIcon()
	local iconID = self.itemData.iconID
	local avatar = self.itemData.avatar
	SoraDGetHeadFromManager(self.img_icon, iconID, avatar)
end
function chatRoomPlayerItem:updateTitle()
	local nickName = self.itemData.nickName
	if self.itemData.isOwner == true then
		nickName = nickName .. "(" .. i18n("common_text_2038") .. ")"
	end
	self.label_title:setString(nickName)
end
function chatRoomPlayerItem:updateCheck()
	self.btn_check:setSelected(self.itemData.isChecked)
	local selfId = chatFunctions:getSelfId()
	if self.itemData.isInRoom == true and self.itemData.isOwner == true then
		self.btn_check:setSelected(false)
		self.btn_check:setVisible(false)
		self.imgSelect:setVisible(true)
	elseif self.itemData.isInRoom == true then
		self.btn_check:setSelected(false)
		self.btn_check:setVisible(false)
		self.imgSelect:setVisible(true)
	else
		self.btn_check:setEnabled(true)
		self.btn_check:setVisible(true)
	end
end
function chatRoomPlayerItem:getItemWidth()
	return self.itemWidth
end
function chatRoomPlayerItem:getItemHeight()
	return self.itemHeight
end
function chatRoomPlayerItem:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.began then
	end
end
function chatRoomPlayerItem:setScrollView(scrollView)
	self.scrollView = scrollView
end
function chatRoomPlayerItem:reset(ignoreAnim)
end
function chatRoomPlayerItem:showMask()
	self.spriteBg:setColor(cc.c3b(125, 125, 125))
end
function chatRoomPlayerItem:hideMask()
	self.spriteBg:setColor(display.COLOR_WHITE)
end
function chatRoomPlayerItem:getTarget()
end
function chatRoomPlayerItem:onBtnNumberBg(sender, event)
end
function chatRoomPlayerItem:checkEvent(sender, event)
	SoraDPlaySound()
	if event == ccui.CheckBoxEventType.selected then
		self.itemData.isChecked = true
	elseif event == ccui.CheckBoxEventType.unselected then
		self.itemData.isChecked = false
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_ROOM_UPDATE_SELMEMBERS"
	;(nil).curItem = self
	SoraDSendMessage(nil)
end
function chatRoomPlayerItem:setSelected(isSelected)
	self.btn_check:setSelected(isSelected)
	self.itemData.isChecked = isSelected
end
return chatRoomPlayerItem

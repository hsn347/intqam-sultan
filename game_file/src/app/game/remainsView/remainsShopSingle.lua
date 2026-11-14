local colorRed = cc.c3b(255, 0, 0)
local colorYellow = cc.c3b(254, 255, 1)
local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local RemainsShopSingle = class("remainsShopSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsShopSingle")
	end
	return target
end)
function RemainsShopSingle:ctor()
	self.text_num = SoraDGetChildByName(self, "text_num")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_alter = SoraDGetChildByName(self, "text_alter")
	self.text_alter:setVisible(false)
	self.icon_buy = SoraDGetChildByName(self, "icon_buy")
	self.text_buy = SoraDGetChildByName(self, "text_buy")
	self.item_color = SoraDGetChildByName(self, "item_color")
	self.item_icon = SoraDGetChildByName(self, "item_icon")
	self.panelMask = SoraDGetChildByName(self, "Panel_mask")
	self.panelMask:setVisible(false)
	self.panelBtnMask = SoraDGetChildByName(self, "Panel_btnMask")
	self.panelBtnMask:setVisible(false)
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.item_color:setTouchEnabled(true)
	self.item_color:setSwallowTouches(false)
	self.item_color:addTouchEventListener(handler(self, self.onClick_Button_show))
	self.text_alter:setString(i18n("shop_text_06"))
	self.btn_operate:setSwallowTouches(false)
	self.panelMask:setSwallowTouches(false)
	self.panelBtnMask:setSwallowTouches(false)
end
function RemainsShopSingle:initData(data)
	self.itemData = data
	self.canBuyNum = math.max(0, self.itemData.limitNumber - (self.itemData.buyNum or 0))
	self:initView()
end
function RemainsShopSingle:initView()
	local itemId = self.itemData.itemId
	self.text_name:setString(publicRead.getName(itemId))
	self.item_color:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
	self.item_icon:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
	publicRead = publicRead.getName(itemId)
	publicRead.getName(itemId).member = math.min(self.itemData.buyNum or 0, self.itemData.limitNumber)
	publicRead.getName(itemId).total = self.itemData.limitNumber
	self.text_num:setString(i18n("common_text_155", publicRead.getName(itemId)))
	self.text_buy:setString(string.formatnumberthousands(self.itemData.integral))
	local score = remainsTeamCtrl:getPlayerShopScore()
	local curSegment = remainsTeamCtrl:getPlayerSegment()
	local curIndex = remainsTeamCtrl:getSegmentRealIndex(curSegment)
	local needSegment = self.itemData.segment
	local needIndex = remainsTeamCtrl:getSegmentRealIndex(needSegment)
	self.text_buy:setColor(colorYellow)
	self.text_num:setColor(colorYellow)
	if score < self.itemData.integral and curIndex >= needIndex then
		self.text_buy:setColor(colorRed)
	end
	if self.canBuyNum == 0 then
		self.text_num:setColor(colorRed)
	end
	self.text_alter:setVisible(curIndex < needIndex)
	self:setMode(curIndex >= needIndex and self.canBuyNum ~= 0)
end
function RemainsShopSingle:setMode(canBuy)
	self.panelMask:setVisible(not canBuy)
	self.btn_operate:setBright(canBuy)
	self.btn_operate:setTouchEnabled(canBuy)
end
function RemainsShopSingle:openItemInfoMsg(data)
	if data.isShow then
		local itemID = data.id
		local item = data.item
		if self.itemTips == nil then
			self.itemTips = SoraDCreatePanel("commonItemTips")
			self.itemTips:setPositionY(50)
			self.itemTips:addTo(self.parentPannel)
			self.itemTips:setLocalZOrder(10)
			self.itemTips:setVisible(false)
		end
		local worldPos = item:convertToWorldSpace(cc.p(0, 0))
		local nodePos = self.parentPannel:convertToNodeSpace(worldPos)
		local deltaTipX = 0
		if SoraDFIsRA() then
			deltaTipX = 0
		else
			deltaTipX = -280
		end
		if nodePos.x > 300 then
			self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
		else
			self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
		end
		self.itemTips:setPositionY(nodePos.y + 200)
		self.itemTips:setVisible(true)
		self.itemTips:initData(itemID)
	elseif self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function RemainsShopSingle:onClick_btn_operate(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("点击到了")
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("不在范围内")
			return
		end
		if self.itemData and remainsTeamCtrl:getPlayerShopScore() < self.itemData.integral then
			SoraDShowMsgTip(i18n("shop_text_07"))
		elseif self.canBuyNum == 0 then
			SoraDShowMsgTip(i18n("shop_text_05"))
		else
			local panel = SoraDCreatePanel("remainsItemBuyBox")
			panel:initData(self.itemData)
			panel:setHandle(handler(self, self.itemBuyBack))
			panel:show()
		end
	end
end
function RemainsShopSingle:itemBuyBack(data)
	local selfIndex = remainsTeamCtrl:getSegmentRealIndex(remainsTeamCtrl:getPlayerSegment())
	local needIndex = remainsTeamCtrl:getSegmentRealIndex(self.itemData.segment)
	if selfIndex < needIndex then
		SoraDShowMsgTip(i18n("arena_text_10"))
	else
		remainsTeamCtrl:reqBuyItem(data.id, data.num)
	end
end
function RemainsShopSingle:onClick_Button_show(sender, event)
	if event == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll, event) then
			return
		end
		SoraDPlaySound()
		_ENV = self.scroll
		self.scroll.id = self.itemData.itemId
		self.scroll.item = sender
		self.scroll.isShow = true
		self:openItemInfoMsg(self.scroll)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		_ENV = self.scroll
		self.scroll.isShow = false
		self:openItemInfoMsg(self.scroll)
	elseif event == ccui.TouchEventType.ended then
		_ENV = self.scroll
		self.scroll.isShow = false
		self:openItemInfoMsg(self.scroll)
	end
end
function RemainsShopSingle:changeBtnIcon(img)
	self.icon_buy:loadTexture(img, ccui.TextureResType.plistType)
end
function RemainsShopSingle:setFather(_father)
	self.parentPannel = _father
end
function RemainsShopSingle:setBuyHandle(handle)
	self.buyHandle = handle
end
function RemainsShopSingle:setScroll(scroll)
	self.scroll = scroll
end
return RemainsShopSingle

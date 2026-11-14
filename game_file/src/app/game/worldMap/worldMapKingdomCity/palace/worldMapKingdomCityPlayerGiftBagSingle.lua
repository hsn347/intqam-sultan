local kingPacksRead = include("kingPacksRead")
local WorldMapKingdomCityPlayerGiftBagSingle = class("worldMapKingdomCityPlayerGiftBagSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityPlayerGiftBagSingle")
	end
	return target
end)
function WorldMapKingdomCityPlayerGiftBagSingle:ctor()
	self.scroll = nil
	self.giftInfo, _ENV, self.limitUsrList, _ENV, self.itemTable, _ENV, self.singleIsMoved = nil, nil, nil, nil, nil, nil, false
	self.Node_player = SoraDGetChildByName(self, "Node_player")
	self.Node_player:setVisible(false)
	self.Node_gift = SoraDGetChildByName(self, "Node_gift")
	self.imgFrm = SoraDGetChildByName(self, "Image_frm")
	self.imgItem = SoraDGetChildByName(self, "Node_item")
	self.btnSend = SoraDGetChildByName(self, "Button_send")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtCount = SoraDGetChildByName(self, "Text_count")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.btnSend:setSwallowTouches(false)
	self.btnSend:setTitleText(i18n("common_text_1441"))
	self.btnSend:addTouchEventListener(handler(self, self.btnSendClick))
end
function WorldMapKingdomCityPlayerGiftBagSingle:initData(type, usrData, myRank, kingdomLv)
	self.isOffer = myRank
	self.giftInfo = kingPacksRead.getItem(type)
	self.giftInfo.itemsArray = SoraDIntArr2Table(self.giftInfo.items)
	if not usrData[tostring(type)] then
		kingPacksRead = usrData[tostring(type)]
	end
	self.giftUsrInfo = usrData[tostring(type)]
	local kingPacksRead, tmpList = usrData[tostring(type)], usrData[tostring(type)]
	for k, v in pairs(usrData) do
		for key, val in pairs(v) do
			table.insert(tmpList, key)
		end
	end
	self.limitUsrList = tmpList
	self.kingdomLv = kingdomLv
	self:initView()
end
function WorldMapKingdomCityPlayerGiftBagSingle:initView(...)
	self.Node_gift:setPositionY(-72)
	self.txtName:setString(i18n(self.giftInfo.name))
	_ENV = i18n(self.giftInfo.name)
	i18n(self.giftInfo.name).send = self.giftInfo.num - table.nums(self.giftUsrInfo)
	i18n(self.giftInfo.name).total = self.giftInfo.num
	self.txtCount:setString(i18n("common_text_1289", i18n(self.giftInfo.name)))
	local publicRead = include("publicRead")
	table.insert(self.itemTable, self.imgItem)
	for i = 2, table.nums(self.giftInfo.itemsArray) do
		local newItem = self.imgItem:clone()
		newItem:addTo(self, 9)
		table.insert(self.itemTable, newItem)
	end
	local keysTbl = table.keys(self.giftInfo.itemsArray)
	local sortNum = 4
	for i, v in ipairs(self.itemTable) do
		local _line = i % sortNum == 0 and sortNum or i % sortNum
		local _row = math.ceil(i / sortNum)
		local fX = -180 + (_line - 1) * 120
		local fY = -160 - (_row - 1) * 120
		local Button_item = v:getChildByName("Button_item")
		v:getChildByName("Image_quality"):loadTexture(publicRead.getBg(keysTbl[i]), ccui.TextureResType.plistType)
		v:getChildByName("Image_icon"):loadTexture(publicRead.getIcon(keysTbl[i]), ccui.TextureResType.plistType)
		local text = v:getChildByName("Text_num")
		text:setString(self.giftInfo.itemsArray[keysTbl[i]])
		SoraDSetTextWidthHeight(text, cc.size(80, 23))
		v:setPosition(SoraDFPosX(-fX, 0), fY)
		Button_item:setTag(keysTbl[i])
		Button_item:setSwallowTouches(false)
		Button_item:addTouchEventListener(function(button, type)
			if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
				button:stopAllActions()
				if self.pFloor then
					self.pFloor:setVisible(false)
				end
			elseif type == ccui.TouchEventType.began then
				if not self.pFloor then
					self.pFloor = SoraDCreatePanel("commonItemTips")
					self.pFloor:addTo(self, 99)
				else
					self.pFloor:setVisible(true)
				end
				self.pFloor:initData(button:getTag())
				self.pFloor:setPosition(self:convertPos(button:getTouchBeganPosition()))
			end
		end)
	end
	if self.isOffer then
		if table.nums(self.giftUsrInfo) >= self.giftInfo.num then
			self.btnSend:setBright(false)
			self.btnSend:setTouchEnabled(false)
			self.btnSend:setTitleColor(cc.c3b(85, 65, 55))
		end
	else
		self.btnSend:setVisible(false)
	end
end
function WorldMapKingdomCityPlayerGiftBagSingle:convertPos(fromPos)
	if SoraDFIsRA() then
		if fromPos.x < 280 then
			fromPos.x = fromPos.x + 280
		end
	elseif fromPos.x > 360 then
		fromPos.x = fromPos.x - 280
	end
	local localPos = self:convertToNodeSpace(fromPos)
	return localPos
end
function WorldMapKingdomCityPlayerGiftBagSingle:setScroll(scroll)
	self.scroll = scroll
end
function WorldMapKingdomCityPlayerGiftBagSingle:returnHeigh()
	local btnHeight = 0
	if not self.btnSend:isVisible() then
		btnHeight = 70
	end
	return 560 - btnHeight
end
function WorldMapKingdomCityPlayerGiftBagSingle:btnSendClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
		panel:setKingdomGift(self.giftInfo.type, self.limitUsrList, self.kingdomLv)
		panel:show()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return WorldMapKingdomCityPlayerGiftBagSingle

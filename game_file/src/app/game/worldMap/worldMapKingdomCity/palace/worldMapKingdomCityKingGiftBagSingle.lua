_ENV = nil
;(nil).KING_GIFT = 1
;(nil).LEGEND_GIFT = 2
;(nil).PLAYER_GIFT = 3
;(nil).HEGEMON_GIFT = 4
local (nil).KINGSTAR_GIFT, ViewType = 5, nil
local kingPacksRead = include("kingPacksRead")
local legendKingRead = include("legendKingRead")
local hegemonRead = include("hegemonRead")
local publicRead = include("publicRead")
local WorldMapKingdomCityKingGiftBagSingle = class("worldMapKingdomCityKingGiftBagSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityKingGiftBagSingle")
	end
	return target
end)
function WorldMapKingdomCityKingGiftBagSingle:ctor()
	self.offsetY = 0
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
function WorldMapKingdomCityKingGiftBagSingle:initData(giftInfo, usrData, viewType, kingdomLv, mapID)
	self.viewType = viewType or ViewType.KING_GIFT
	self.giftInfo = giftInfo
	self.giftInfo.itemsArray = SoraDIntArr2Table(self.giftInfo.items)
	if not usrData[tostring(giftInfo.type)] then
		ViewType = usrData[tostring(giftInfo.type)]
	end
	self.giftUsrInfo = usrData[tostring(giftInfo.type)]
	self.mapid = mapID
	local ViewType, tmpList = usrData[tostring(giftInfo.type)], usrData[tostring(giftInfo.type)]
	for _, v in pairs(usrData) do
		for key in pairs(v) do
			table.insert(tmpList, key)
		end
	end
	if self.viewType == ViewType.PLAYER_GIFT and self.giftInfo.rank and self.giftInfo.rank > 0 then
		self.Node_player:setVisible(true)
		ViewType = nil
		;(nil).num = self.giftInfo.rank
		self.txtTitle:setString(i18n("kindofwar_title_02", nil))
		self.offsetY = 28
	else
		self.Node_player:setVisible(false)
		self.Node_gift:setPositionY(-72)
		self.offsetY = 0
	end
	self.Node_gift:setPositionY(-72 - self.offsetY)
	self.imgFrm:setPositionY(-90 - self.offsetY)
	self.btnSend:setPositionY(-520 - self.offsetY)
	self.limitUsrList = tmpList
	self.kingdomLv = kingdomLv
	self:initView()
end
function WorldMapKingdomCityKingGiftBagSingle:initView(...)
	self.txtName:setString(i18n(self.giftInfo.name))
	_ENV = i18n(self.giftInfo.name)
	i18n(self.giftInfo.name).send = self.giftInfo.num - table.nums(self.giftUsrInfo)
	i18n(self.giftInfo.name).total = self.giftInfo.num
	self.txtCount:setString(i18n("common_text_1289", i18n(self.giftInfo.name)))
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
		local fY = -160 - (_row - 1) * 120 - self.offsetY
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
	local bShowSend = false
	if self.viewType == ViewType.KING_GIFT then
		if SoraDClickFromKingManager() or SoraDIsSelfKing() and SoraDIsLookMyKingdom() then
			bShowSend = true
		end
	elseif self.viewType == ViewType.PLAYER_GIFT then
		if SoraDClickFromKingManager() or SoraDIsLookMyKingdom() then
			local rank = self.giftInfo.rank or 0
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			local myRank = kingdomMapCtrl:getKingWarRank()
			if myRank and myRank == rank then
				bShowSend = true
			end
		end
	else
		self.btnSend:setVisible(false)
	end
	if bShowSend then
		self.btnSend:setVisible(true)
		if table.nums(self.giftUsrInfo) >= self.giftInfo.num then
			self.btnSend:setTouchEnabled(false)
			self.btnSend:setTitleColor(cc.c3b(210, 195, 155))
			self.btnSend:setBright(false)
		end
	else
		self.btnSend:setVisible(false)
	end
end
function WorldMapKingdomCityKingGiftBagSingle:initLegendLordGiftData(viewType, data, limitUsrList, mapid)
	self.viewType = viewType
	self.giftInfo = data
	self.giftID = self.giftInfo.giftID
	local mapid = mapid or worldMapDefine.KINGSTAR_KINGDOM_ID
	self.mapid = viewType == ViewType.KINGSTAR_GIFT and mapid or nil
	self.giftRewards = legendKingRead.getPackageReward(self.giftID, self.mapid)
	self.limitUsrList = limitUsrList
	self:initLegendLordView()
end
function WorldMapKingdomCityKingGiftBagSingle:initHegemonLordGiftData(data, limitUsrList, bid, mapid)
	self.viewType = ViewType.HEGEMON_GIFT
	self.giftInfo = data
	self.bid = bid
	self.giftID = self.giftInfo.giftID
	self.giftRewards = hegemonRead.getPackageReward(self.giftID)
	self.limitUsrList = limitUsrList
	self.mapid = mapid
	self:initHegemonLordView()
end
function WorldMapKingdomCityKingGiftBagSingle:initLegendLordView(...)
	self.Node_gift:setPositionY(-72)
	self.txtName:setString(i18n(legendKingRead.getPackageName(self.giftInfo.giftID, self.mapid)))
	_ENV = i18n(legendKingRead.getPackageName(self.giftInfo.giftID, self.mapid))
	i18n(legendKingRead.getPackageName(self.giftInfo.giftID, self.mapid)).send = self.giftInfo.remainCount
	i18n(legendKingRead.getPackageName(self.giftInfo.giftID, self.mapid)).total = self.giftInfo.total
	self.txtCount:setString(i18n("common_text_1289", i18n(legendKingRead.getPackageName(self.giftInfo.giftID, self.mapid))))
	table.insert(self.itemTable, self.imgItem)
	for i = 2, table.nums(self.giftRewards) do
		local newItem = self.imgItem:clone()
		newItem:addTo(self, 9)
		table.insert(self.itemTable, newItem)
	end
	local legendHeight = self:returnLegendHeight()
	local rows = math.ceil(#self.giftRewards / 4)
	local itemsH = rows * 120
	local bgH = itemsH + 20
	self.imgFrm:setContentSize(cc.size(self.imgFrm:getContentSize().width, bgH))
	self.btnSend:setPositionY(-legendHeight + 43 - self.offsetY)
	local numx = 4
	for i, v in ipairs(self.itemTable) do
		local _line = i % numx == 0 and numx or i % numx
		local _row = math.ceil(i / numx)
		local fX = -180 + (_line - 1) * 120
		local fY = -160 - (_row - 1) * 120 - self.offsetY
		local Button_item = v:getChildByName("Button_item")
		v:getChildByName("Image_quality"):loadTexture(publicRead.getBg(self.giftRewards[i].id), ccui.TextureResType.plistType)
		v:getChildByName("Image_icon"):loadTexture(publicRead.getIcon(self.giftRewards[i].id), ccui.TextureResType.plistType)
		v:getChildByName("Text_num"):setString(self.giftRewards[i].count)
		v:setPosition(SoraDFPosX(-fX, 0), fY)
		Button_item:setTag(self.giftRewards[i].id)
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
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	local rank = self.viewType == ViewType.KINGSTAR_GIFT and kingStarCtrl:getLordRank() or legendLordCtrl:getLordRank()
	local needRank = legendKingRead.getPackageRewardRank(self.giftID, self.mapid)
	if self.giftInfo.remainCount <= 0 then
		self.btnSend:setTouchEnabled(true)
		self.btnSend:setTitleColor(cc.c3b(210, 195, 155))
		self.btnSend:setBright(false)
	elseif rank and rank == needRank then
		self.btnSend:setVisible(true)
		self.btnSend:setTouchEnabled(true)
	else
		self.btnSend:setVisible(true)
		self.btnSend:setTouchEnabled(true)
		self.btnSend:setTitleColor(cc.c3b(210, 195, 155))
		self.btnSend:setBright(false)
	end
end
function WorldMapKingdomCityKingGiftBagSingle:initHegemonLordView(...)
	self.Node_gift:setPositionY(-72)
	self.txtName:setString(i18n(hegemonRead.getPackageName(self.giftInfo.giftID)))
	_ENV = i18n(hegemonRead.getPackageName(self.giftInfo.giftID))
	i18n(hegemonRead.getPackageName(self.giftInfo.giftID)).send = self.giftInfo.remainCount
	i18n(hegemonRead.getPackageName(self.giftInfo.giftID)).total = self.giftInfo.total
	self.txtCount:setString(i18n("common_text_1289", i18n(hegemonRead.getPackageName(self.giftInfo.giftID))))
	table.insert(self.itemTable, self.imgItem)
	for i = 2, table.nums(self.giftRewards) do
		local newItem = self.imgItem:clone()
		newItem:addTo(self, 9)
		table.insert(self.itemTable, newItem)
	end
	local legendHeight = self:returnLegendHeight()
	local rows = math.ceil(#self.giftRewards / 4)
	local itemsH = rows * 120
	local bgH = itemsH + 20
	self.imgFrm:setContentSize(cc.size(self.imgFrm:getContentSize().width, bgH))
	self.btnSend:setPositionY(-legendHeight + 43 - self.offsetY)
	local numx = 4
	for i, v in ipairs(self.itemTable) do
		local _line = i % numx == 0 and numx or i % numx
		local _row = math.ceil(i / numx)
		local fX = -180 + (_line - 1) * 120
		local fY = -160 - (_row - 1) * 120 - self.offsetY
		local Button_item = v:getChildByName("Button_item")
		v:getChildByName("Image_quality"):loadTexture(publicRead.getBg(self.giftRewards[i].id), ccui.TextureResType.plistType)
		v:getChildByName("Image_icon"):loadTexture(publicRead.getIcon(self.giftRewards[i].id), ccui.TextureResType.plistType)
		v:getChildByName("Text_num"):setString(self.giftRewards[i].count)
		v:setPosition(SoraDFPosX(-fX, 0), fY)
		Button_item:setTag(self.giftRewards[i].id)
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
	local gametop = gModuleMgr.getObject("gametop")
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	local rank = hegemonCtrl:getLordRank()
	local needRank = hegemonRead.getPackageRewardRank(self.giftID)
	if self.giftInfo.remainCount <= 0 then
		self.btnSend:setTouchEnabled(true)
		self.btnSend:setTitleColor(cc.c3b(210, 195, 155))
		self.btnSend:setBright(false)
	elseif rank and rank == needRank and self.bid == hegemonCtrl:getJoinBid() then
		self.btnSend:setVisible(true)
		self.btnSend:setTouchEnabled(true)
	else
		self.btnSend:setVisible(true)
		self.btnSend:setTouchEnabled(true)
		self.btnSend:setTitleColor(cc.c3b(210, 195, 155))
		self.btnSend:setBright(false)
	end
end
function WorldMapKingdomCityKingGiftBagSingle:convertPos(fromPos)
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
function WorldMapKingdomCityKingGiftBagSingle:setScroll(scroll)
	self.scroll = scroll
end
function WorldMapKingdomCityKingGiftBagSingle:returnHeigh()
	local btnHeight = 0
	if not self.btnSend:isVisible() then
		btnHeight = 70
	end
	return 560 - btnHeight + self.offsetY
end
function WorldMapKingdomCityKingGiftBagSingle:returnLegendHeight()
	local btnHeight = 0
	if not self.btnSend:isVisible() then
		btnHeight = 70
	end
	local rows = math.ceil(#self.giftRewards / 4)
	local itemsH = rows * 120
	local totalH = itemsH + 200
	return totalH - btnHeight + self.offsetY
end
function WorldMapKingdomCityKingGiftBagSingle:btnSendClick(button, type)
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
		if self.viewType == ViewType.KING_GIFT or self.viewType == ViewType.PLAYER_GIFT then
			local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
			panel:setKingdomGift(self.giftInfo.type, self.limitUsrList, self.kingdomLv)
			panel:show()
		elseif self.viewType == ViewType.LEGEND_GIFT then
			local gametop = gModuleMgr.getObject("gametop")
			local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
			local rank = legendLordCtrl:getLordRank()
			local needRank = legendKingRead.getPackageRewardRank(self.giftID)
			if rank ~= needRank then
				_ENV = nil
				;(nil).rank = needRank
				local name = i18n("mail_text_458", nil)
				_ENV = nil
				;(nil).name = name
				local strTip = i18n("legendaryking_text_29", nil)
				SoraDShowMsgTip(strTip)
				return
			else
				if self.giftInfo.remainCount <= 0 then
					SoraDShowMsgTip(i18n("common_text_4268"))
					return
				end
				local panel = SoraDCreatePanelByFixName("worldMapKingdomCityAppointSelect")
				panel:setLegendGift(self.giftID, self.limitUsrList)
				panel:show()
			end
		elseif self.viewType == ViewType.KINGSTAR_GIFT then
			local gametop = gModuleMgr.getObject("gametop")
			local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
			local rank = kingStarCtrl:getLordRank()
			local mapID = self.mapid or worldMapDefine.KINGSTAR_KINGDOM_ID
			print("self.mapid=======", self.mapid, mapID)
			local needRank = legendKingRead.getPackageRewardRank(self.giftID, mapID)
			if rank ~= needRank then
				_ENV = mapID
				mapID.rank = needRank
				local name = i18n("kingstarbattle_text_59", mapID)
				_ENV = self.limitUsrList
				self.limitUsrList.name = name
				local strTip = i18n("legendaryking_text_29", self.limitUsrList)
				SoraDShowMsgTip(strTip)
				return
			else
				if self.giftInfo.remainCount <= 0 then
					SoraDShowMsgTip(i18n("common_text_4268"))
					return
				end
				local panel = SoraDCreatePanelByFixName("worldMapKingdomCityAppointSelect")
				panel:setKingStarGift(self.giftID, self.limitUsrList, mapID)
				panel:show()
			end
		elseif self.viewType == ViewType.HEGEMON_GIFT then
			local gametop = gModuleMgr.getObject("gametop")
			local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
			local rank = hegemonCtrl:getLordRank()
			local needRank = hegemonRead.getPackageRewardRank(self.giftID)
			if self.bid ~= hegemonCtrl:getJoinBid() then
				local buildName = hegemonRead.getName(self.bid)
				_ENV = panel
				panel.build = buildName
				panel.rank = needRank
				local name = i18n("hegemon_text_50", panel)
				_ENV = self.giftID
				self.giftID.name = name
				local strTip = i18n("legendaryking_text_29", self.giftID)
				SoraDShowMsgTip(strTip)
				return
			end
			if rank ~= needRank then
				local buildName = hegemonRead.getName(self.bid)
				_ENV = SoraDShowMsgTip
				SoraDShowMsgTip.build = buildName
				SoraDShowMsgTip.rank = needRank
				local name = i18n("hegemon_text_50", SoraDShowMsgTip)
				_ENV = strTip
				strTip.name = name
				local strTip = i18n("legendaryking_text_29", strTip)
				SoraDShowMsgTip(strTip)
				return
			else
				if self.giftInfo.remainCount <= 0 then
					SoraDShowMsgTip(i18n("common_text_4268"))
					return
				end
				local panel = SoraDCreatePanelByFixName("worldMapKingdomCityAppointSelect")
				panel:setHegemonGift(self.bid, self.giftID, self.limitUsrList)
				panel:show()
			end
		end
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
return WorldMapKingdomCityKingGiftBagSingle

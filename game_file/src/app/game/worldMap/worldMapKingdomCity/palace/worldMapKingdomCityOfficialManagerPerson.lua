local WorldMapKingdomCityOfficialManagerPerson = class("worldMapKingdomCityOfficialManagerPerson", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityOfficialManagerPerson")
	end
	return target
end)
function WorldMapKingdomCityOfficialManagerPerson:ctor()
	self.scroll = nil
	self.msgGetList, _ENV, self.itemTable, _ENV, self.singleIsMoved = nil, nil, nil, nil, false
	self.item = nil
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.goodItem = SoraDGetChildByName(self, "Node_official")
	self.badItem = SoraDGetChildByName(self, "Node_slave")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST", handler(self, self.update))
end
function WorldMapKingdomCityOfficialManagerPerson:update(target, data)
	dump(data, "WorldMapKingdomCityOfficialManagerPerson:update", 4)
	self:updateHead()
	self.isInit = true
	self.msgGetList = data.retdate
	local officialInfoRead = include("officialInfoRead")
	local lordLocalData = include("lordLocalData")
	local aimTable = self.isBad and officialInfoRead.getBadPerson() or officialInfoRead.getGoodPerson()
	local tblKeys = table.keys(aimTable)
	table.sort(tblKeys, function(a, b)
		return a < b
	end)
	for i, v in ipairs(tblKeys) do
		local btnTouch = SoraDGetChildByName(self.itemTable[i], "Button_touch")
		btnTouch:setSwallowTouches(false)
		btnTouch:setTag(v)
		btnTouch:addTouchEventListener(handler(self, self.btnHeadClick))
		self.itemTable[i]:getChildByName("Text_position"):setString(i18n(aimTable[v].name))
		self.itemTable[i]:getChildByName("Image_official"):setVisible(true)
		local usrData = self.msgGetList[tostring(v)]
		if next(usrData) ~= nil then
			local allianceAbbr = usrData.allianceAbbr and "(" .. usrData.allianceAbbr .. ")" or ""
			self.itemTable[i]:getChildByName("Text_name"):setString(usrData.nickName)
			self.itemTable[i]:getChildByName("Image_head"):setVisible(true)
			self.itemTable[i]:getChildByName("Image_official"):setVisible(false)
			SoraDGetHeadFromManager(self.itemTable[i]:getChildByName("Image_head"), usrData.iconID, usrData.avatar)
		end
	end
end
function WorldMapKingdomCityOfficialManagerPerson:initData(isBad)
	self.isBad = isBad
	if self.isBad then
		self.item = self.badItem
		self.goodItem:setVisible(false)
	else
		self.item = self.goodItem
		self.badItem:setVisible(false)
	end
	self:initView()
end
function WorldMapKingdomCityOfficialManagerPerson:initView()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	local lordLocalData = include("lordLocalData")
	if self.isBad then
		self.txtTitle:setString(i18n("common_text_1197"))
	else
		self.txtTitle:setString(i18n("common_text_1196"))
	end
	local sortNum = 4
	for i = 1, 8 do
		local _line = i % sortNum == 0 and sortNum or i % sortNum
		local _row = math.ceil(i / sortNum)
		local fX = 545 - (_line - 1) * 150
		local fY = -140 - (_row - 1) * 190
		local newItem
		if i == 1 then
			newItem = self.item
		else
			newItem = self.item:clone()
			newItem:addTo(self, 1)
		end
		newItem:setPosition(SoraDFPosX(fX), fY)
		table.insert(self.itemTable, newItem)
	end
	self:updateHead()
end
function WorldMapKingdomCityOfficialManagerPerson:updateHead()
	local officialInfoRead = include("officialInfoRead")
	local aimTable = self.isBad and officialInfoRead.getBadPerson() or officialInfoRead.getGoodPerson()
	local tblKeys = table.keys(aimTable)
	table.sort(tblKeys, function(a, b)
		return a < b
	end)
	for i, v in ipairs(tblKeys) do
		local btnTouch = SoraDGetChildByName(self.itemTable[i], "Button_touch")
		btnTouch:setSwallowTouches(false)
		btnTouch:setTag(v)
		btnTouch:addTouchEventListener(handler(self, self.btnHeadClick))
		self.itemTable[i]:getChildByName("Text_position"):setString(i18n(aimTable[v].name))
		self.itemTable[i]:getChildByName("Image_official"):loadTexture(aimTable[v].img, ccui.TextureResType.plistType)
		self.itemTable[i]:getChildByName("Text_name"):setString(i18n("common_text_480"))
		self.itemTable[i]:getChildByName("Image_official"):setVisible(true)
		self.itemTable[i]:getChildByName("Image_head"):setVisible(false)
	end
end
function WorldMapKingdomCityOfficialManagerPerson:btnHeadClick(button, type)
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
		if self.msgGetList[tostring(button:getTag())] then
			local panel = SoraDCreatePanel("worldMapKingdomCityOfficialPop")
			panel:initData(button:getTag(), self.msgGetList[tostring(button:getTag())])
			panel:show()
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 5 then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function WorldMapKingdomCityOfficialManagerPerson:setScroll(scroll)
	self.scroll = scroll
end
function WorldMapKingdomCityOfficialManagerPerson:getHeigh()
	local line = math.ceil(#self.itemTable / 4)
	return line * 180 + (line - 1) + 10 + 60
end
return WorldMapKingdomCityOfficialManagerPerson

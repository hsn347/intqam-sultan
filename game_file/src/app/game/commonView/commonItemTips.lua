local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local buffDesRead = include("buffDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local CommonItemTips = class("commonItemTips", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonItemTips")
	end
	return target
end)
function CommonItemTips:ctor()
	self.desColor = cc.c3b(215, 195, 155)
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgLine = SoraDGetChildByName(self, "Image_2")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.txtLordLv = SoraDGetChildByName(self, "Text_lordLv")
	self.txtCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.txtSuit1 = SoraDGetChildByName(self, "Text_suit1")
	self.txtSuit2 = SoraDGetChildByName(self, "Text_suit2")
	self.txtSuit3 = SoraDGetChildByName(self, "Text_suit3")
	self.tableItemID = 0
	self.needHeigh = 0
	self.width = self.imgBg:getContentSize().width
	self.height = self.imgBg:getContentSize().height
	self.txtLordLv:setVisible(false)
	self.txtCastleLv:setVisible(false)
	self.nowWidth = self.imgBg:getContentSize().width
	self.nowHeight = self.imgBg:getContentSize().height
	self.txtSuit1:setVisible(false)
	self.txtSuit2:setVisible(false)
	self.txtSuit3:setVisible(false)
	SoraDChangeTextToHtml(self.txtSuit1)
	SoraDChangeTextToHtml(self.txtSuit2)
	SoraDChangeTextToHtml(self.txtSuit3)
	SoraDChangeTextToHtml(self.labelDes)
	self.labelCount = self.txtSuit1:clone()
	self.labelCount:setAnchorPoint(cc.p(0.5, 0.5))
	self.labelCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.labelCount:addTo(self, 9)
	self.labelCount:setVisible(false)
end
function CommonItemTips:initDiscountShopPackageData(itemID, ContainGoods)
	local str = self:getContainGoodsNamesAndNums(ContainGoods)
	self.txtLordLv:setVisible(false)
	self.txtCastleLv:setVisible(false)
	local publicRead = include("publicRead")
	self.labelName:setString(publicRead.getName(itemID))
	self.labelDes:setString(str)
	self.labelDes:setColor(self.desColor)
	self.needHeigh = 25
	self:setBgHeight(self.height)
end
function CommonItemTips:getContainGoodsNamesAndNums(ContainGoods)
	local publicRead = include("publicRead")
	local combineString = ""
	for k, v in pairs(ContainGoods) do
		local name = publicRead.getName(v.id)
		local count = v.count
		if SoraDFIsRA() then
			combineString = combineString .. count .. "x" .. " " .. name .. "\n"
		else
			combineString = combineString .. name .. " " .. "x" .. count .. "\n"
		end
	end
	return combineString
end
local convertLvInfo = function(judgeLv)
	local des = ""
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(judgeLv)
	if 0 < warLv then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = warLv
			;(nil).title = i18n("common_text_4267", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = warLv
			des = i18n("common_text_4267", nil)
		end
	elseif judgeLv >= CASTLE_MAXLV_NOWAR then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			;(nil).title = i18n("common_text_3452", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			des = i18n("common_text_3452", nil)
		end
	else
		_ENV = nil
		;(nil).lv = judgeLv
		des = i18n("common_text_3452", nil)
	end
	return des
end
function CommonItemTips:initSuitPopView(itemID, value)
	self.txtSuit1:setVisible(true)
	self.txtSuit2:setVisible(true)
	self.txtSuit3:setVisible(true)
	self.labelName:setString(publicRead.getName(itemID))
	local index = math.floor(itemID % 1000000 / 100000)
	local partList = equipmentltCtrl.getSuitPartList(index, itemID)
	local propertyType = partList[value + 1].propertyType
	local propertyValue = partList[value + 1].propertyValue
	local propertyType2 = partList[value + 1].propertyType2
	local propertyValue2 = partList[value + 1].propertyValue2
	local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(partList[value + 1].suitequipID)
	publicRead = publicRead.getName(itemID)
	publicRead.getName(itemID).level = partList[value + 1].level
	local comStr = string.format([[
%s
%s
%s]], equipDesRead.getAttrName(propertyType, propertyValue), equipDesRead.getAttrName(propertyType2, propertyValue2), i18n("common_text_600", publicRead.getName(itemID)))
	if 0 < value then
		for i = 1, value do
			comStr = comStr .. string.format([[

%s]], i18n("common_text_1344"))
		end
	end
	self.labelDes:setString(comStr)
	self.labelDes:setColor(self.desColor)
	SoraDSetTextWidthHeight(self.labelDes, cc.size(252, self.labelDes:getContentSize().height + 15))
	local line = self.imgLine:clone()
	if SoraDFIsRA() then
		line:setPosition(cc.p(-140, self.labelDes:getPositionY() - self.labelDes:getContentSize().height))
	else
		line:setPosition(cc.p(140, self.labelDes:getPositionY() - self.labelDes:getContentSize().height))
	end
	line:addTo(self, 10)
	local additionStr1 = ""
	local additionStr2 = ""
	local additionStr3 = ""
	local color = "#969696"
	for i = 1, 4 do
		local showStr1 = equipDesRead.getSuitpropertyDes(suitResultInfo.SuitpropertyType1, suitResultInfo.SuitpropertyValue1[i])
		local showStr2 = equipDesRead.getSuitpropertyDes(suitResultInfo.SuitpropertyType2, suitResultInfo.SuitpropertyValue2[i])
		local showStr3 = equipDesRead.getSuitpropertyDes(suitResultInfo.SuitpropertyType3, suitResultInfo.SuitpropertyValue3[i])
		if i == 1 then
			color = "#969696"
			publicRead = string.format("+%s/", showStr1)
			string.format("+%s/", showStr1).color = color
			additionStr1 = SoraDWrapHtmlTagByStyle(additionStr1 .. string.format("+%s/", showStr1), (string.format("+%s/", showStr1)))
			publicRead = string.format("+%s/", showStr2)
			string.format("+%s/", showStr2).color = color
			additionStr2 = SoraDWrapHtmlTagByStyle(additionStr2 .. string.format("+%s/", showStr2), (string.format("+%s/", showStr2)))
			publicRead = string.format("+%s/", showStr3)
			string.format("+%s/", showStr3).color = color
			additionStr3 = SoraDWrapHtmlTagByStyle(additionStr3 .. string.format("+%s/", showStr3), (string.format("+%s/", showStr3)))
		elseif i == 4 then
			color = "#FF00FF"
			publicRead = string.format("%s", showStr1)
			string.format("%s", showStr1).color = color
			additionStr1 = SoraDWrapHtmlTagByStyle(additionStr1 .. string.format("%s", showStr1), (string.format("%s", showStr1)))
			publicRead = string.format("%s", showStr2)
			string.format("%s", showStr2).color = color
			additionStr2 = SoraDWrapHtmlTagByStyle(additionStr2 .. string.format("%s", showStr2), (string.format("%s", showStr2)))
			publicRead = string.format("%s", showStr3)
			string.format("%s", showStr3).color = color
			additionStr3 = SoraDWrapHtmlTagByStyle(additionStr3 .. string.format("%s", showStr3), (string.format("%s", showStr3)))
		else
			if i == 2 then
				color = "#00BE1E"
			else
				color = "#00B9FF"
			end
			publicRead = string.format("%s/", showStr1)
			string.format("%s/", showStr1).color = color
			additionStr1 = SoraDWrapHtmlTagByStyle(additionStr1 .. string.format("%s/", showStr1), (string.format("%s/", showStr1)))
			publicRead = string.format("%s/", showStr2)
			string.format("%s/", showStr2).color = color
			additionStr2 = SoraDWrapHtmlTagByStyle(additionStr2 .. string.format("%s/", showStr2), (string.format("%s/", showStr2)))
			publicRead = string.format("%s/", showStr3)
			string.format("%s/", showStr3).color = color
			additionStr3 = SoraDWrapHtmlTagByStyle(additionStr3 .. string.format("%s/", showStr3), (string.format("%s/", showStr3)))
		end
	end
	local suitComStr1 = string.format("%s %s  %s", i18n("suit_text_02"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType1), additionStr1)
	local suitComStr2 = string.format("%s %s  %s", i18n("suit_text_03"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType2), additionStr2)
	local suitComStr3 = string.format("%s %s  %s", i18n("suit_text_04"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType3), additionStr3)
	self.txtSuit1:setString(suitComStr1)
	self.txtSuit2:setString(suitComStr2)
	self.txtSuit3:setString(suitComStr3)
	SoraDSetTextWidthHeight(self.txtSuit1, cc.size(260, self.txtSuit1:getContentSize().height + 40))
	SoraDSetTextWidthHeight(self.txtSuit2, cc.size(260, self.txtSuit2:getContentSize().height + 40))
	SoraDSetTextWidthHeight(self.txtSuit3, cc.size(260, self.txtSuit3:getContentSize().height + 40))
	self.txtSuit1:setPositionY(line:getPositionY() - 10)
	self.txtSuit2:setPositionY(self.txtSuit1:getPositionY() - self.txtSuit1:getContentSize().height)
	self.txtSuit3:setPositionY(self.txtSuit2:getPositionY() - self.txtSuit2:getContentSize().height)
	self:setBgHeight(self.labelDes:getContentSize().height + self.txtSuit1:getContentSize().height + self.txtSuit2:getContentSize().height + self.txtSuit3:getContentSize().height + 50)
end
function CommonItemTips:initData(itemID, value)
	print(itemID)
	local sType = serviceFunctions.getIDType(itemID)
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(itemID)
	if sType == gIDType.PACKAGE then
		self.labelName:setString(i18n("privilege_text_123"))
		self.labelDes:setString(i18n("privilege_text_123"))
		self.labelDes:setColor(self.desColor)
		return
	end
	if sType == gIDType.EQUIPMENT and isSuitEquip then
		self:initSuitPopView(itemID, value)
		return
	end
	if value and sType ~= gIDType.ITEM and sType ~= gIDType.TROOP and buffDesRead.isBuff(itemID) then
		self:setBuffInfo(itemID, value)
		return
	end
	local resultType = backpackltCtrl:getResultType(itemID)
	local goodType = backpackltCtrl:getItemType(itemID)
	if IsArClient and (resultType == gItemEffectDef.KEY_OPEN or resultType == gItemEffectDef.SOLOMON_KEY) then
		local panel = SoraDCreatePanel("solomonKeyView")
		panel:initData(itemID)
		panel:show()
		return
	end
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	if ret and next(ret) and isShow then
		_ENV = i18n("privilege_text_123")
		i18n("privilege_text_123").itemID = itemID
		uiManager:show("CommonItemShowBox", i18n("privilege_text_123"))
		self:setVisible(false)
		return false
	end
	local isDressShow = backpackltCtrl:isSkinShow(itemID)
	if isDressShow then
		_ENV = i18n("privilege_text_123")
		i18n("privilege_text_123").itemID = itemID
		uiManager:show("commonDressPreview", i18n("privilege_text_123"))
		self:setVisible(false)
		return false
	end
	if resultType == gItemEffectDef.HERO_DRESS then
		_ENV = i18n("privilege_text_123")
		i18n("privilege_text_123").itemID = itemID
		uiManager:show("HeroDressPreview", i18n("privilege_text_123"))
		self:setVisible(false)
		return false
	end
	self.txtLordLv:setVisible(false)
	self.txtCastleLv:setVisible(false)
	self.tableItemID = equipDesRead.getEquipQualityCfgID(itemID) or itemID
	print("self.tableItemID,itemID=====", self.tableItemID, itemID)
	sType = serviceFunctions.getIDType(self.tableItemID)
	if sType == gIDType.EQUIPMENT then
		local ret, qlv = include("militaryRankRead").isInMilitaryShop(self.tableItemID)
		if ret then
			local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(self.tableItemID, qlv, 0)
			local propertyCount = equipmentltCtrl.getExtraPropertyNum(qlv)
			local limitLv = equipmentltCtrl.getEquipmentLv(self.tableItemID)
			_ENV = i18n("privilege_text_123")
			i18n("privilege_text_123").lv = limitLv
			local baseString = equipDesRead.getAttrName(baseProperty, mayVal) .. "\n" .. i18n("common_text_277", i18n("privilege_text_123"))
			for i = 1, propertyCount do
				baseString = baseString .. "\n" .. i18n("common_text_1344")
			end
			local name = equipDesRead.getName(self.tableItemID)
			self:customData(name, baseString)
		else
			local equipmentCell = include("equipmentCell")
			_ENV = equipmentltCtrl.getExtraPropertyNum(qlv)
			equipmentltCtrl.getExtraPropertyNum(qlv).eid = self.tableItemID
			equipmentltCtrl.getExtraPropertyNum(qlv).epid = nil
			equipmentltCtrl.getExtraPropertyNum(qlv).slv = 0
			equipmentltCtrl.getExtraPropertyNum(qlv).qly = equipDesRead.getEquipQuality(itemID)
			equipmentltCtrl.getExtraPropertyNum(qlv).wear = gStatus.NO
			local data = equipmentCell.new((equipmentltCtrl.getExtraPropertyNum(qlv)))
			_ENV = equipDesRead.getName(self.tableItemID)
			equipDesRead.getName(self.tableItemID).data = data
			equipDesRead.getName(self.tableItemID).onlyShow = true
			uiManager:show("ringNeckInfoView", (equipDesRead.getName(self.tableItemID)))
			self:setVisible(false)
		end
		return false
	end
	if sType == gIDType.WAR_STONE then
		local level = include("wargemResRead").getLevel(self.tableItemID)
		self.labelName:setString("LV." .. level .. " " .. publicRead.getName(self.tableItemID))
	else
		self.labelName:setString(publicRead.getName(self.tableItemID))
	end
	self.labelDes:setString(publicRead.getDes(self.tableItemID))
	if not itemDesRead.isRichDes(self.tableItemID) then
		self.labelDes:setColor(self.desColor)
	else
		self.labelDes:setColor(cc.c3b(255, 255, 255))
	end
	self:showCond(itemID)
	self.labelCount:setVisible(false)
	if not backpackltCtrl:getResult(itemID) then
		local _ENV, result = backpackltCtrl:getResult(itemID), backpackltCtrl:getResult(itemID)
	end
	local mergeID = type(result) == "number" and result or result[1]
	if resultType == gItemEffectDef.MERGE_FRAGMENG and mergeID then
		local _resultType = backpackltCtrl:getResultType(mergeID)
		if _resultType == gItemEffectDef.HERO_DRESS or _resultType == gItemEffectDef.DRESS then
			self.labelCount:setVisible(true)
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255).num = backpackCtrl:getItemCount(itemID)
			self.labelCount:setString(i18n("common_text_4832", cc.c3b(255, 255, 255)))
			self:setBgHeight(self.height + 20)
			self.labelCount:setPosition(cc.p(SoraDFPosX(-self.nowWidth / 2, 0), 20 - self.nowHeight))
		end
	end
	return true
end
function CommonItemTips:showCond(itemID)
	local publicRead = include("publicRead")
	local cond = publicRead.checkLevelCondition(itemID)
	if cond then
		if cond.needCastleLevel then
			self.needHeigh = 25
			self.txtCastleLv:setVisible(true)
			local buildLogic = include("buildLogic")
			local warLv = buildLogic.transformBuildLvToWarLv(cond.needCastleLevel)
			if 0 < warLv then
				_ENV = nil
				;(nil).lv = warLv
				self.txtCastleLv:setString(i18n("common_text_4267", nil))
			elseif cond.needCastleLevel > CASTLE_MAXLV_NOWAR then
				_ENV = i18n("common_text_4267", nil)
				i18n("common_text_4267", nil).lv = CASTLE_MAXLV_NOWAR
				self.txtCastleLv:setString(i18n("common_text_3452", i18n("common_text_4267", nil)))
			else
				_ENV = i18n("common_text_3452", i18n("common_text_4267", nil))
				i18n("common_text_3452", i18n("common_text_4267", nil)).lv = cond.needCastleLevel
				self.txtCastleLv:setString(i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil))))
			end
		end
		if cond.needLordLevel then
			self.needHeigh = 45
			self.txtLordLv:setVisible(true)
			_ENV = i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil)))
			i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil))).lv = cond.needLordLevel
			self.txtLordLv:setString(i18n("common_text_3453", i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil)))))
		end
		if cond.needVIPLevel then
			self.needHeigh = 25
			self.txtCastleLv:setVisible(true)
			_ENV = i18n("common_text_3453", i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil))))
			i18n("common_text_3453", i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil)))).lv = cond.needVIPLevel
			self.txtCastleLv:setString(i18n("common_text_3972", i18n("common_text_3453", i18n("common_text_3452", i18n("common_text_3452", i18n("common_text_4267", nil))))))
		end
		if cond.needVIPActive then
			self.needHeigh = 45
			self.txtLordLv:setVisible(true)
			self.txtLordLv:setString(i18n("common_text_2824"))
		end
		self:setBgHeight(self.height)
	end
end
function CommonItemTips:setBuffInfo(itemID, value)
	self.labelName:setString(buffDesRead.getTitleBase(itemID))
	self.labelDes:setString(buffDesRead.getTitleWithValue(itemID, value))
	self.labelDes:setColor(self.desColor)
	local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	local buffID = lightShiningCtrl:getBuffID(itemID)
	local remainTime = buffCtrl:getRemainTimeByBuffID(buffID)
	_ENV = buffDesRead.getTitleWithValue(itemID, value)
	buffDesRead.getTitleWithValue(itemID, value)[1] = buffID
	local isIn = lightShiningCtrl:isInBuffList(buffDesRead.getTitleWithValue(itemID, value))
	if isIn and remainTime and 0 < remainTime then
		self.txtCastleLv = SoraDCreateTimerLabel(self, self.txtCastleLv)
		self.txtCastleLv:setTimeLast(function(ticket)
			_ENV = nil
			_ENV = nil
			;(nil).time = ticket
			;(nil).abbr = i18n("common_text_766", nil)
			;(nil).name = ""
			return i18n("common_text_186", nil)
		end)
		self.txtCastleLv:beginTime(remainTime)
		self.txtCastleLv:setVisible(true)
		self.txtCastleLv:setColor(cc.c3b(0, 190, 30))
		self.needHeigh = 25
		self:setBgHeight(self.height)
		self.txtCastleLv:setTimeEndListener(function()
			if self.timeEndHandle then
				self.txtCastleLv:setVisible(false)
				self.needHeigh = 0
				self:setBgHeight(self.height)
			end
		end)
	end
end
function CommonItemTips:setTouchClose(bool)
	if bool then
		self.imgBg:setTouchEnabled(true)
		self.imgBg:setSwallowTouches(false)
		self.imgBg:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				self:removeFromParent()
			end
		end)
	end
end
function CommonItemTips:setBgHeight(height)
	self.imgBg:setContentSize(cc.size(self.imgBg:getContentSize().width, height + self.needHeigh))
	self.nowWidth = self.imgBg:getContentSize().width
	self.nowHeight = self.imgBg:getContentSize().height
end
function CommonItemTips:getBgSize()
	return self.imgBg:getContentSize()
end
function CommonItemTips:setDesAlign(align)
	self.labelDes:setTextHorizontalAlignment(align)
end
function CommonItemTips:customDes(_des)
	self.labelDes:setString(_des)
	self.labelDes:setColor(self.desColor)
end
function CommonItemTips:customName(_name)
	self.labelName:setString(_name)
end
function CommonItemTips:setNoTitleStyle(...)
	SoraDGetChildByName(self, "Image_2"):setVisible(false)
	self.labelDes:setPositionY(-12)
	self.labelDes:setContentSize(cc.size(252, 115))
	self.labelDes:setTextAreaSize(cc.size(252, 115))
end
function CommonItemTips:customData(_name, _des, _itemID)
	self.txtLordLv:setVisible(false)
	self.txtCastleLv:setVisible(false)
	self:customName(_name)
	self:customDes(_des)
	if _itemID then
		local cond = publicRead.checkLevelCondition(_itemID)
		if cond then
			if cond.needCastleLevel then
				self.needHeigh = 25
				self.txtCastleLv:setVisible(true)
				self.txtCastleLv:setString(convertLvInfo(cond.needCastleLevel))
			end
			if cond.needLordLevel then
				self.needHeigh = 45
				self.txtLordLv:setVisible(true)
				publicRead = convertLvInfo(cond.needCastleLevel)
				convertLvInfo(cond.needCastleLevel).lv = cond.needLordLevel
				self.txtLordLv:setString(i18n("common_text_3453", convertLvInfo(cond.needCastleLevel)))
			end
			if cond.needVIPLevel then
				self.needHeigh = 25
				self.txtCastleLv:setVisible(true)
				publicRead = i18n("common_text_3453", convertLvInfo(cond.needCastleLevel))
				i18n("common_text_3453", convertLvInfo(cond.needCastleLevel)).lv = cond.needVIPLevel
				self.txtCastleLv:setString(i18n("common_text_3972", i18n("common_text_3453", convertLvInfo(cond.needCastleLevel))))
			end
			if cond.needVIPActive then
				self.needHeigh = 45
				self.txtLordLv:setVisible(true)
				self.txtLordLv:setString(i18n("common_text_2824"))
			end
			self:setBgHeight(self.height)
		end
	end
end
function CommonItemTips:getRootShowPos(pos, tipsOffset)
	tipsOffset = tipsOffset or 30
	if pos then
		if pos.y + self.nowHeight + tipsOffset < display.height then
			pos.y = pos.y + self.nowHeight + tipsOffset
		else
			pos.y = display.height
		end
		pos.x = math.max(0, pos.x - self.nowWidth / 2)
		if pos.x + self.nowWidth > display.width then
			pos.x = display.width - self.nowWidth
		end
		if SoraDFIsRA() then
			pos.x = pos.x + self.nowWidth
		end
		return pos
	end
	return cc.p(display.cx, display.cy)
end
return CommonItemTips

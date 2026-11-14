local PyramidPlayoffsPriceView = class("pyramidPlayoffsPriceView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidPlayoffsPriceView")
	end
	return target
end)
function PyramidPlayoffsPriceView:ctor()
	gPersonalRewardType.WIN.single, _ENV, _ENV, self.singleTbl, gPersonalRewardType.WIN.final, _ENV, gPersonalRewardType.WIN.normal, _ENV, _ENV, self.tabType = nil, nil, gPersonalRewardType.WIN, gPersonalRewardType.WIN, nil, nil, nil, nil, gPersonalRewardType.WIN, gPersonalRewardType.WIN
	self.curSingle, gPersonalRewardType.WIN.isNormal = gPersonalRewardType.WIN, true
	self.singleClass = nil
	self.singleNormalClass = nil
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_playoffsPrice")
	self.title:setTitle(i18n("common_text_3301"))
	self.labelSectionTitle = SoraDGetChildByName(self, "Text_sectionTitle")
	_ENV = i18n("common_text_3301")
	i18n("common_text_3301").count = 32
	self.labelSectionTitle:setString(i18n("common_text_4013", i18n("common_text_3301")))
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	_ENV = i18n("common_text_4013", i18n("common_text_3301"))
	i18n("common_text_4013", i18n("common_text_3301")).count = 3
	self.labelDes:setString(i18n("common_text_4011", i18n("common_text_4013", i18n("common_text_3301"))))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnFailure = SoraDGetChildByName(self, "Button_failure")
	self.btnSuccess = SoraDGetChildByName(self, "Button_success")
	self.btnSuccess:setTitleText(i18n("common_text_3343"))
	self.btnFailure:setTitleText(i18n("common_text_3344"))
	self.btnAlliance:setTitleText(i18n("common_text_4012"))
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnPrice:setTitleText(i18n("common_text_4017"))
	self.panelCopy = SoraDGetChildByName(self, "Panel_copy")
	self.panelCopyNormal = SoraDGetChildByName(self, "Panel_copy_normal")
	self.itemTips = SoraDCreatePanel("commonItemTips")
	self.itemTips:addTo(self.scroll, 2)
	self.itemTips:setScale(0.8)
	self.itemTips:setVisible(false)
	self.itemTips:setPositionX(0.5 * self.scroll:getContentSize().width + SoraDFSign(110))
	_UPVALUE3_, self.nodeTitle = SoraDGetChildByName(self, "Node_title"), SoraDGetChildByName(self, "Node_title")
	self.btnsTbl, SoraDGetChildByName(self, "Node_title")[1] = SoraDGetChildByName(self, "Node_title"), self.btnAlliance
	self.btnsTbl, SoraDGetChildByName(self, "Node_title")[2] = SoraDGetChildByName(self, "Node_title"), self.btnFailure
	self.btnsTbl, SoraDGetChildByName(self, "Node_title")[3] = SoraDGetChildByName(self, "Node_title"), self.btnSuccess
	self.btnAlliance:addTouchEventListener(handler(self, self.headBtnClick))
	self.btnFailure:addTouchEventListener(handler(self, self.headBtnClick))
	self.btnSuccess:addTouchEventListener(handler(self, self.headBtnClick))
	self.btnPrice:addTouchEventListener(handler(self, self.priceBtnClick))
	SoraDAutoSizeButtonText(self.btnAlliance)
	SoraDAutoSizeButtonText(self.btnFailure)
	SoraDAutoSizeButtonText(self.btnSuccess)
	SoraDAutoSizeButtonText(self.btnPrice)
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self:createSingleClass()
	self:createNormalSingleClass()
	self:switchTab("success")
end
function PyramidPlayoffsPriceView:singleItemPress(itemPos, itemID)
	if itemPos == nil then
		self:closeItemInfo()
	elseif itemPos and itemID then
		self:openItemInfo(itemPos, itemID)
	end
end
function PyramidPlayoffsPriceView:openItemInfo(itemPos, itemID)
	print("显示")
	local offsetY = self.btnAlliance:isTouchEnabled() and 60 or 160
	local curPos = self.itemTips:getParent():convertToNodeSpace(itemPos)
	self.itemTips:setPositionY(curPos.y + offsetY)
	self.itemTips:initData(itemID)
	self.itemTips:setVisible(true)
end
function PyramidPlayoffsPriceView:closeItemInfo()
	print("隐藏")
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function PyramidPlayoffsPriceView:cleanAllSingle()
	for i, v in ipairs(self.curSingle.single) do
		v:setVisible(false)
		if self.curSingle.isNormal then
			table.insert(self.singleTbl.normal, v)
		else
			table.insert(self.singleTbl.final, v)
		end
	end
	self.curSingle.single, _ENV = ipairs(self.curSingle.single)
end
function PyramidPlayoffsPriceView:getSingle(isNormal)
	if isNormal then
		if #self.singleTbl.normal > 0 then
			return table.remove(self.singleTbl.normal)
		else
			local createItem = self.singleNormalClass.new()
			createItem:addTo(self.scroll)
			return createItem
		end
	elseif 0 < #self.singleTbl.final then
		return table.remove(self.singleTbl.final)
	else
		local createItem = self.singleClass.new()
		createItem:addTo(self.scroll)
		return createItem
	end
end
function PyramidPlayoffsPriceView:initDataWithNormal(...)
	self.itemData, _ENV = nil, nil
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local tmpTbl = allianceWarltCtrl.getAlliancewarPersonalReward(self.tabType, gSeasonType.PINNACLE_SEASON)
	for i, v in ipairs(tmpTbl) do
		_ENV = nil
		;(nil).min = v.point[1]
		;(nil).max = v.point[2]
		;(nil).itemList = SoraDIntArr2FormatTable(v.reward)
		table.insert(self.itemData, nil)
	end
	table.sort(self.itemData, function(a, b)
		return a.max > b.max
	end)
	self:initNormalView()
end
function PyramidPlayoffsPriceView:initData(...)
	self.itemData, _ENV = nil, nil
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local tmpTbl = allianceWarltCtrl.getAlliancewarAllianceReward(self.tabType)
	for i, v in ipairs(tmpTbl) do
		_ENV = nil
		;(nil).min = v.point[1]
		;(nil).max = v.point[2]
		;(nil).itemList = SoraDIntArr2FormatTable(v.reward)
		table.insert(self.itemData, nil)
	end
	self:initView()
end
function PyramidPlayoffsPriceView:switchTab(typeStr)
	local offset = typeStr == "final" and 120 or 0
	self.nodeBottom:setVisible(typeStr == "final")
	self.scroll:setContentSize(cc.size(640, display.height - offset - 186))
	if typeStr == "success" then
		self.btnSuccess:setTouchEnabled(false)
		self.btnSuccess:setBright(true)
		self.btnFailure:setTouchEnabled(true)
		self.btnFailure:setBright(false)
		self.btnAlliance:setTouchEnabled(true)
		self.btnAlliance:setBright(false)
		self.btnSuccess:setTitleColor(cc.c3b(255, 200, 100))
		self.btnFailure:setTitleColor(cc.c3b(100, 80, 40))
		self.btnAlliance:setTitleColor(cc.c3b(100, 80, 40))
		self.labelSectionTitle:setVisible(false)
		self.tabType = gPersonalRewardType.WIN
		self:initDataWithNormal()
	elseif typeStr == "fail" then
		self.btnSuccess:setTouchEnabled(true)
		self.btnSuccess:setBright(false)
		self.btnFailure:setTouchEnabled(false)
		self.btnFailure:setBright(true)
		self.btnAlliance:setTouchEnabled(true)
		self.btnAlliance:setBright(false)
		self.btnFailure:setTitleColor(cc.c3b(255, 200, 100))
		self.btnSuccess:setTitleColor(cc.c3b(100, 80, 40))
		self.btnAlliance:setTitleColor(cc.c3b(100, 80, 40))
		self.labelSectionTitle:setVisible(false)
		self.tabType = gPersonalRewardType.LOSE
		self:initDataWithNormal()
	elseif typeStr == "final" then
		self.btnAlliance:setTouchEnabled(false)
		self.btnAlliance:setBright(true)
		self.btnSuccess:setTouchEnabled(true)
		self.btnSuccess:setBright(false)
		self.btnFailure:setTouchEnabled(true)
		self.btnFailure:setBright(false)
		self.btnAlliance:setTitleColor(cc.c3b(255, 200, 100))
		self.btnSuccess:setTitleColor(cc.c3b(100, 80, 40))
		self.btnFailure:setTitleColor(cc.c3b(100, 80, 40))
		self.labelSectionTitle:setVisible(true)
		self.tabType = gPostSeasonAllianceReward.ALLIANCE_RANK
		self:initData()
	end
end
function PyramidPlayoffsPriceView:priceBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidAllianceGiftView"):show()
	end
end
function PyramidPlayoffsPriceView:headBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnSuccess == button then
			self:switchTab("success")
		elseif self.btnFailure == button then
			self:switchTab("fail")
		elseif self.btnAlliance == button then
			self:switchTab("final")
		end
	end
end
function PyramidPlayoffsPriceView:initNormalView(...)
	self:cleanAllSingle()
	local divDis = 10
	local needHeigh = 0
	for i, v in ipairs(self.itemData) do
		local createItem = self:getSingle(true)
		createItem:initData(v)
		createItem:setVisible(true)
		createItem.itemsPressHandle = handler(self, self.singleItemPress)
		needHeigh = needHeigh + createItem:returnHeigh() + divDis
		table.insert(self.curSingle.single, createItem)
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, needHeigh)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.curSingle.single) do
		v:setPosition(sSize.width / 2, sH)
		sH = sH - v:returnHeigh() - divDis
	end
	self.scroll:jumpToTop()
	self.curSingle.isNormal = true
end
function PyramidPlayoffsPriceView:initView(...)
	self:cleanAllSingle()
	local nodeHeight = 80
	local count = #self.itemData
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, self.singleClass.returnHeigh() * count + nodeHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i = 1, count do
		local panel = self:getSingle(false)
		panel:setPosition(sSize.width / 2, sH - (i - 1) * panel.returnHeigh() - 0.5 * panel.returnHeigh() - nodeHeight)
		panel:setRankStyle(i)
		panel:initData(self.itemData[i])
		panel.itemsPressHandle = handler(self, self.singleItemPress)
		panel:setVisible(true)
		table.insert(self.curSingle.single, panel)
	end
	self.nodeTitle:setPosition(sSize.width / 2, sH)
	self.scroll:jumpToTop()
	self.curSingle.isNormal = false
end
function PyramidPlayoffsPriceView:createNormalSingleClass()
	self.singleNormalClass = class("PyramidBattlePriceSingle", function()
		local target = self.panelCopyNormal:clone()
		return target
	end)
	function self.singleNormalClass:ctor()
		self.single, _UPVALUE0_, self.myData, _UPVALUE0_, self.singleItemPress = nil, nil, nil, nil, nil
		self.imgItem = self:getChildByName("Image_item")
	end
	function self.singleNormalClass:initData(_data)
		self.myData = _data
		self:initView()
	end
	function self.singleNormalClass:initView(...)
		local publicRead = include("publicRead")
		for i, v in ipairs(self.myData.itemList) do
			local item = self.single[i]
			if item == nil then
				item = self.imgItem:clone()
				item:addTo(self)
			end
			item:setVisible(true)
			item:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			item:getChildByName("Text_itemNum"):setString(string.formatnumberthousands(v.num))
			item:getChildByName("Image_itemHead"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			item:loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			item:getChildByName("Button_item"):addTouchEventListener(function(button, type)
				if type == ccui.TouchEventType.ended then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.canceled then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.began then
					self.itemsPressHandle(item:getParent():convertToWorldSpace(cc.p(item:getPositionX(), item:getPositionY())), v.id)
				end
			end)
			item:setPosition(self.imgItem:getPositionX(), -86 * (i - 1) - 50)
			self.single[i] = item
		end
		if #self.single > #self.myData.itemList then
			for i = #self.myData.itemList + 1, #self.single do
				self.single[i]:setVisible(false)
			end
		end
		if self.myData.max == 999999999 then
			_ENV = self.single[i].setVisible
			self.single[i].setVisible.min = self.myData.min
			self:getChildByName("Text_copyTitle"):setString(i18n("common_text_3411", self.single[i].setVisible))
		else
			_ENV = i18n("common_text_3411", self.single[i].setVisible)
			i18n("common_text_3411", self.single[i].setVisible).min = self.myData.min
			i18n("common_text_3411", self.single[i].setVisible).max = self.myData.max
			self:getChildByName("Text_copyTitle"):setString(i18n("common_text_3410", i18n("common_text_3411", self.single[i].setVisible)))
		end
		self.imgItem:setVisible(false)
	end
	function self.singleNormalClass:setScroll(scroll)
		self.pScroll = scroll
	end
	function self.singleNormalClass:setCallBack(handl)
		self.singleCb = handl
	end
	function self.singleNormalClass:returnHeigh(...)
		return table.nums(self.myData.itemList) * 86 + 75
	end
end
function PyramidPlayoffsPriceView:createSingleClass()
	self.singleClass = class("PyramidPlayoffsPriceSingle", function()
		return self.panelCopy:clone()
	end)
	function self.singleClass:ctor()
		self.single, _UPVALUE0_, self.myData, _UPVALUE0_, self.singleItemPress = nil, nil, nil, nil, nil
		self.imgItem = self:getChildByName("Image_itemBg")
	end
	function self.singleClass:initData(_data)
		self.myData = _data
		self:initView()
	end
	function self.singleClass:initView(...)
		local pSize = self:getContentSize()
		local iSize = cc.size(140, 125)
		local publicRead = include("publicRead")
		for i, v in ipairs(self.myData.itemList) do
			local item = self.single[i]
			if item == nil then
				item = self.imgItem:clone()
				item:addTo(self)
			end
			item:setVisible(true)
			item:getChildByName("Text_itemNum"):setString(string.formatnumberthousands(v.num))
			item:getChildByName("Image_item"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			item:getChildByName("Button_item"):addTouchEventListener(function(button, type)
				if type == ccui.TouchEventType.ended then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.canceled then
					self.itemsPressHandle()
				elseif type == ccui.TouchEventType.began then
					self.itemsPressHandle(item:getParent():convertToWorldSpace(cc.p(item:getPositionX(), item:getPositionY())), v.id)
				end
			end)
			item:loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			item:setPosition(pSize.width / 2 - 3 * (iSize.width / 2) + (i - 1) % 4 * iSize.width, 330 - (math.ceil(i / 4) - 1) * iSize.height)
			self.single[i] = item
		end
		if #self.single > #self.myData.itemList then
			for i = #self.myData.itemList + 1, #self.single do
				self.single[i]:setVisible(false)
			end
		end
		if self.myData.max == self.myData.min then
			_ENV = self.single[i].setVisible
			self.single[i].setVisible.num = self.myData.max
			self:getChildByName("Text_singleTitle"):setString(i18n("common_text_617", self.single[i].setVisible))
		else
			_ENV = i18n("common_text_617", self.single[i].setVisible)
			i18n("common_text_617", self.single[i].setVisible).min = self.myData.min
			i18n("common_text_617", self.single[i].setVisible).max = self.myData.max
			self:getChildByName("Text_singleTitle"):setString(i18n("common_text_1770", i18n("common_text_617", self.single[i].setVisible)))
		end
		self.imgItem:setVisible(false)
	end
	function self.singleClass:setRankStyle(rank)
	end
	function self.singleClass.returnHeigh(...)
		return 450
	end
end
return PyramidPlayoffsPriceView

local PyramidBattlePriceView = class("pyramidBattlePriceView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattlePriceView")
	end
	return target
end)
function PyramidBattlePriceView:ctor()
	self.tabType = gPersonalRewardType.WIN
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_price"):setTitle(i18n("common_text_2078"))
	self.btnSuccess = SoraDGetChildByName(self, "Button_success")
	self.btnFail = SoraDGetChildByName(self, "Button_failure")
	self.imgCopy = SoraDGetChildByName(self, "Panel_copy_normal")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_price")
	self.btnSuccess:setTitleText(i18n("common_text_3343"))
	self.btnFail:setTitleText(i18n("common_text_3344"))
	self.btnSuccess:addTouchEventListener(handler(self, self.tabClick))
	self.btnFail:addTouchEventListener(handler(self, self.tabClick))
	SoraDAutoSizeButtonText(self.btnSuccess, cc.size(300, 70))
	SoraDAutoSizeButtonText(self.btnFail, cc.size(300, 70))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self:createSingleClass()
	self:switchTab("success")
end
function PyramidBattlePriceView:createSingleClass()
	self.singleClass = class("PyramidBattlePriceSingle", function()
		local target = self.imgCopy:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.myData, _UPVALUE0_ = nil, nil
		self.imgItem = self:getChildByName("Image_item")
	end
	function self.singleClass:initData(_data)
		self.myData = _data
		self:initView()
	end
	function self.singleClass:initView(...)
		local publicRead = include("publicRead")
		for i, v in ipairs(self.myData.itemList) do
			local item = self.imgItem:clone()
			item:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			item:getChildByName("Text_itemNum"):setString(string.formatnumberthousands(v.num))
			item:getChildByName("Image_itemHead"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			item:loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			item:setPosition(self.imgItem:getPositionX(), -86 * (i - 1) - 50)
			item:addTo(self)
		end
		if self.myData.max == 999999999 then
			_ENV = nil
			;(nil).min = self.myData.min
			self:getChildByName("Text_copyTitle"):setString(i18n("common_text_3411", nil))
		else
			_ENV = i18n("common_text_3411", nil)
			i18n("common_text_3411", nil).min = self.myData.min
			i18n("common_text_3411", nil).max = self.myData.max
			self:getChildByName("Text_copyTitle"):setString(i18n("common_text_3410", i18n("common_text_3411", nil)))
		end
		self.imgItem:setVisible(false)
	end
	function self.singleClass:setScroll(scroll)
		self.pScroll = scroll
	end
	function self.singleClass:setCallBack(handl)
		self.singleCb = handl
	end
	function self.singleClass:returnHeigh(...)
		return table.nums(self.myData.itemList) * 86 + 75
	end
end
function PyramidBattlePriceView:tabClick(btn, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnSuccess == btn then
			self:switchTab("success")
		elseif self.btnFail == btn then
			self:switchTab("fail")
		end
	end
end
function PyramidBattlePriceView:switchTab(typeStr)
	if typeStr == "success" then
		self.btnSuccess:setTouchEnabled(false)
		self.btnSuccess:setBright(true)
		self.btnSuccess:setTitleColor(cc.c3b(255, 200, 100))
		self.btnFail:setTouchEnabled(true)
		self.btnFail:setBright(false)
		self.btnFail:setTitleColor(cc.c3b(100, 80, 40))
		self.tabType = gPersonalRewardType.WIN
		self:initData()
	elseif typeStr == "fail" then
		self.btnSuccess:setTouchEnabled(true)
		self.btnSuccess:setBright(false)
		self.btnSuccess:setTitleColor(cc.c3b(100, 80, 40))
		self.btnFail:setTouchEnabled(false)
		self.btnFail:setBright(true)
		self.btnFail:setTitleColor(cc.c3b(255, 200, 100))
		self.tabType = gPersonalRewardType.LOSE
		self:initData()
	end
end
function PyramidBattlePriceView:initData(...)
	self.itemData, _ENV = nil, nil
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local tmpTbl = allianceWarltCtrl.getAlliancewarPersonalReward(self.tabType, gSeasonType.REGULAR_SEASON)
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
	self:initView()
end
function PyramidBattlePriceView:initView(...)
	self.scroll:removeAllChildren()
	local divDis = 10
	local needHeigh = 0
	for i, v in ipairs(self.itemData) do
		local createItem = self.singleClass.new()
		createItem:initData(v)
		createItem:addTo(self.scroll)
		needHeigh = needHeigh + createItem:returnHeigh() + divDis
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, needHeigh)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.scroll:getChildren()) do
		v:setPosition(sSize.width / 2, sH)
		sH = sH - v:returnHeigh() - divDis
	end
	self.scroll:jumpToTop()
end
return PyramidBattlePriceView

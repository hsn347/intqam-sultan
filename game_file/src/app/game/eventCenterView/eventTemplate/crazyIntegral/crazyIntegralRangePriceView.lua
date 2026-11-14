local CrazyIntegralRangePriceView = class("crazyIntegralRangePriceView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("crazyIntegralRangePriceView")
	end
	return target
end)
function CrazyIntegralRangePriceView:ctor()
	self:bindBtnClose()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTotalGold = SoraDGetChildByName(self, "Text_totalPrice")
	self.itemCopy = SoraDFIsRA() and SoraDGetChildByName(self, "Image_item") or SoraDGetChildByName(self, "Image_item_en")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.txtPointTip = SoraDGetChildByName(self, "Text_tip")
	SoraDGetChildByName(self, "Text_num"):setString(i18n("common_text_2709"))
	SoraDGetChildByName(self, "Text_item"):setString(i18n("common_text_2708"))
	SoraDGetChildByName(self, "Image_centerBg"):setFillType(1)
end
function CrazyIntegralRangePriceView:initData(index)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	local readyData = newActivityCtrl:getCrazyScoreStageReward()
	local _ENV, priceList = newActivityCtrl, newActivityCtrl
	local totalGold = 0
	local needscore = 0
	local _stage = 0
	for i, v in ipairs(readyData) do
		if v.stage == index then
			priceList = v.reward
			totalGold = v.price
			needscore = v.needscore
			_stage = v.stage
		end
	end
	_ENV = (for generator)
	ipairs(readyData).priceList = priceList
	ipairs(readyData).upInt = needscore
	ipairs(readyData).totalGold = totalGold
	self.dataTbl, ipairs(readyData).stage = ipairs(readyData)
	self:initView()
end
function CrazyIntegralRangePriceView:initView(...)
	local fillItem = function(ocx, info, enableMask)
		local publicRead = include("publicRead")
		local mask = ocx:getChildByName("Panel_witheBg")
		local txtNum = ocx:getChildByName("Text_itemNum")
		local txtName = ocx:getChildByName("Text_itemName")
		local imgItemBg = ocx:getChildByName("Image_itemBg")
		local imgItemHead = ocx:getChildByName("Image_itemHead")
		if not enableMask then
			mask:setVisible(false)
		end
		txtNum:setString("x" .. info.num)
		txtName:setString(publicRead.getName(info.id))
		imgItemBg:loadTexture(publicRead.getBg(info.id), ccui.TextureResType.plistType)
		imgItemHead:loadTexture(publicRead.getIcon(info.id), ccui.TextureResType.plistType)
		imgItemHead:setTouchEnabled(true)
		imgItemHead:setSwallowTouches(false)
		imgItemHead:setTag(info.id)
		imgItemHead:addTouchEventListener(handler(self, self.itemClick))
	end
	local itemList = SoraDIntArr2FormatTable(self.dataTbl.priceList)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, table.nums(itemList) * 80)
	local index = 0
	for i, v in ipairs(itemList) do
		local item = self.itemCopy:clone()
		fillItem(item, v, index % 2 ~= 0)
		item:addTo(self.scroll)
		item:setPosition(sSize.width / 2, sH - index * 80)
		index = index + 1
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	_ENV = cc.size(sSize.width, sH)
	cc.size(sSize.width, sH).price = self.dataTbl.totalGold
	self.txtTotalGold:setString(i18n("common_text_3044", cc.size(sSize.width, sH)))
	_ENV = i18n("common_text_3044", cc.size(sSize.width, sH))
	i18n("common_text_3044", cc.size(sSize.width, sH)).num = self.dataTbl.stage
	self.txtTitle:setString(i18n("common_text_3045", i18n("common_text_3044", cc.size(sSize.width, sH))))
	_ENV = i18n("common_text_3045", i18n("common_text_3044", cc.size(sSize.width, sH)))
	i18n("common_text_3045", i18n("common_text_3044", cc.size(sSize.width, sH))).point = string.formatnumberthousands(self.dataTbl.upInt)
	self.txtPointTip:setString(i18n("common_text_3046", i18n("common_text_3045", i18n("common_text_3044", cc.size(sSize.width, sH)))))
end
function CrazyIntegralRangePriceView:itemClick(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function CrazyIntegralRangePriceView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y)
		else
			self.pFloor:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y)
	else
		self.pFloor:setPosition(pos.x, pos.y)
	end
	self.pFloor:addTo(self, 100)
end
return CrazyIntegralRangePriceView

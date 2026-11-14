local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local commonSelectResourceBox = class("commonSelectResourceBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonSelectResourceBox")
	end
	return target
end)
function commonSelectResourceBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("box_title_01"))
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.heroTips = SoraDGetChildByName(self, "hero_tips")
	self.heroTips:setVisible(false)
	self.labelTitle:setString(i18n("common_text_4362"))
	self.labelAlter = SoraDGetChildByName(self, "Text_alter")
	self.labelAlter:setString(i18n("box_text_01"))
	self.labelTotalNum = SoraDGetChildByName(self, "Text_totalNum")
	self.Text_mayGet = SoraDGetChildByName(self, "Text_mayGet")
	self.Text_mayGet:setVisible(false)
	self.btnConfirm = SoraDGetChildByName(self, "Button_confirm")
	self.btnConfirm:setTitleText(i18n("common_text_054"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.btnConfirm:getVirtualRenderer():setState(1)
	self.maxNum = 0
	self.itemID = 0
	self.itemsEntity, _ENV, self.itemList, _ENV, self.curSelectedID = self.btnConfirm:getVirtualRenderer().setState, self.btnConfirm:getVirtualRenderer().setState, self.btnConfirm:getVirtualRenderer().setState, self.btnConfirm:getVirtualRenderer().setState, 0
	self.showName = ""
	self.showCount = 0
	self.btnConfirm:addTouchEventListener(handler(self, self.onConfirmBtnClick))
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
	self:suitScroll()
end
function commonSelectResourceBox:suitScroll()
	self.scroll:setContentSize(cc.size(500, self.heroTips:isVisible() and 337 or 377))
end
function commonSelectResourceBox:initData(itemID, selectedItemID)
	local itemType = backpackltCtrl:getResultType(itemID)
	print("itemType-commonSelectResourceBox", itemType, gItemEffectDef.OPTIONAL_HERO, itemID)
	self.checkHero = itemType == gItemEffectDef.OPTIONAL_HERO
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	self.itemList = ret
	self:sortHeroResource()
	self.itemID = itemID
	self.maxNum = backpackCtrl:getItemCount(self.itemID)
	local solomonKeyRead = include("solomonKeyRead")
	local useMax = backpackltCtrl:getUseMax(self.itemID)
	if self.maxNum >= 999 then
		if useMax == 9999 then
			self.maxNum = self.maxNum >= 9999 and 9999 or self.maxNum
		else
			self.maxNum = 999
		end
	end
	self.maxNum = math.min(self.maxNum, useMax)
	self:initScroll()
	self:initSingleList()
	backpackltCtrl = useMax
	useMax.maxValue = self.maxNum
	useMax.minValue = 0
	useMax.curValue = 0
	self.itemUseSlider:initData(useMax)
	self.curCount = 0
	backpackltCtrl = nil
	;(nil).total = string.formatnumberthousands(self.maxNum)
	;(nil).member = ""
	self.labelTotalNum:setString(i18n("common_text_155", nil))
	self.btnConfirm:setTouchEnabled(false)
	self.btnConfirm:setBright(false)
	if selectedItemID then
		local index = self:getItemFromScroll(selectedItemID)
		if index then
			self.itemsEntity[index]:enterAutoSelected()
			self.scroll:scrollToPercentVertical(index ~= 1 and index / table.nums(self.itemList) * 100 or 0, 0, false)
		end
	end
end
function commonSelectResourceBox:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(100 * table.nums(self.itemList), self.scroll:getContentSize().height)
	local scrollW = self.scroll:getContentSize().width
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.scroll:jumpToTop()
end
function commonSelectResourceBox:sortHeroResource()
	if not self.checkHero then
		return
	end
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	for i, v in ipairs(self.itemList) do
		local heroInfo = heroltCtrl.getChipInfo(v.id)
		v.rare = heroltCtrl:getRarity(tonumber(heroInfo.heroID))
		heroInfo = heroCtrl:getHeroInfoByID(heroInfo.heroID)
		v.noHero = false
		if not heroInfo then
			v.noHero = true
		end
	end
	table.sort(self.itemList, function(a, b)
		if not a.noHero and b.noHero then
			return true
		end
		if not b.noHero and a.noHero then
			return false
		end
		if a.rare ~= b.rare then
			return a.rare > b.rare
		else
			return a.id < b.id
		end
	end)
	dump(self.itemList, "self.itemList", 10)
end
function commonSelectResourceBox:initSingleList()
	local scrollInner = self.scroll:getInnerContainer()
	local scrollW = scrollInner:getContentSize().width
	local scrollH = scrollInner:getContentSize().height
	for i, v in ipairs(self.itemList) do
		local item = self:createSingleItem()
		item:addTo(self.scroll)
		_ENV = item.addTo
		item.addTo.id = v.id
		item.addTo.count = v.count
		local item.addTo.noHero, temp = v.noHero, item.addTo
		item:initData(temp, self.scroll)
		item:setPosition(0.5 * scrollW, scrollH - 100 * i + 25)
		item:setHandle(handler(self, self.doCallBack))
		table.insert(self.itemsEntity, item)
	end
end
function commonSelectResourceBox:createSingleItem()
	return SoraDCreatePanel("commonSelectSingleResource")
end
function commonSelectResourceBox:doCallBack(singleEntity)
	if self.beforeEntity then
		self.beforeEntity:setCheck(false)
	else
		self.heroTips:setVisible(true)
		self:suitScroll()
		local defaultValue = 1
		publicRead = nil
		;(nil).maxValue = self.maxNum
		;(nil).minValue = 1
		;(nil).curValue = defaultValue
		self.itemUseSlider:initData(nil)
		self.curCount = defaultValue
	end
	self.beforeEntity = singleEntity
	if singleEntity.itemID then
		local name = publicRead.getName(singleEntity.itemID)
		local num = self:getOwnItemNum(singleEntity.itemID)
		local result = backpackltCtrl:getResult(singleEntity.itemID)
		publicRead = nil
		;(nil).name = name
		;(nil).num = num
		self.heroTips:setString(i18n("common_text_4474", nil))
		self.btnConfirm:setBright(true)
		self.btnConfirm:setTouchEnabled(true)
		self.showName = name
		self.showCount = singleEntity.count
		self.Text_mayGet:setVisible(true)
		publicRead = i18n("common_text_4474", nil)
		i18n("common_text_4474", nil).num = self.curCount
		i18n("common_text_4474", nil).item = self.showName
		i18n("common_text_4474", nil).count = string.formatnumberthousands(self.showCount * self.curCount)
		self.Text_mayGet:setString(i18n("item_text_01", i18n("common_text_4474", nil)))
	end
end
function commonSelectResourceBox:getOwnItemNum(itemID)
	local itemType = serviceFunctions.getIDType(itemID)
	local num = 0
	if itemType == gIDType.SAFE_RES then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		if cityCtrl:isSafeResID(itemID) then
			local resID = cityCtrl:transformSafeResIDToResID(itemID)
			num = math.floor(cityCtrl:getSafeRes(resID))
			num = SoraDConvertNumberWithUnit(num)
		else
			num = backpackltCtrl:getResult(itemID)
		end
	elseif itemType == gIDType.WAR_STONE or itemType == gIDType.ENCHANTMENT_SCROLL then
		num = SoraDGetCtrl("warGemCtrl"):getItemCount(itemID)
	else
		num = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
	end
	return num
end
function commonSelectResourceBox:sliderCallBack(value)
	if 0 < value and self.beforeEntity then
		self.btnConfirm:setBright(true)
		self.btnConfirm:setTouchEnabled(true)
		self.curCount = value
		_ENV = nil
		;(nil).num = self.curCount
		;(nil).item = self.showName
		;(nil).count = string.formatnumberthousands(self.showCount * self.curCount)
		self.Text_mayGet:setString(i18n("item_text_01", nil))
	end
end
function commonSelectResourceBox:onConfirmBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.beforeEntity and self.beforeEntity.itemID ~= 0 then
			local _ENV, sendList = self.beforeEntity.itemID, self.beforeEntity.itemID
			if backpackltCtrl:getResultType(self.itemID) == gItemEffectDef.RESTRICTED_OPTIONAL then
				sendList.id = self.beforeEntity.itemID
			else
				_ENV = self.itemID
				self.itemID.id = self.beforeEntity.itemID
				self.itemID.count = self.curCount
				table.insert(sendList, self.itemID)
			end
			backpackCtrl:reqUseItem(self.itemID, self.curCount, sendList)
			self:removeFromParent()
		end
	end
end
function commonSelectResourceBox:chooseItemAndNum(itemId, num)
	local itemNode = self:getItemInfoByItemID(itemId)
	if itemNode then
		itemNode:btnClickCallBack(itemNode.checkBox, ccui.CheckBoxEventType.selected)
		self.itemUseSlider:updateSlier(num)
	end
end
function commonSelectResourceBox:getItemInfoByItemID(itemId)
	for i, v in ipairs(self.itemsEntity) do
		if v.itemID == itemId then
			return v
		end
	end
	return nil
end
function commonSelectResourceBox:getItemFromScroll(itemID)
	for i, v in ipairs(self.itemList) do
		if v.id == itemID then
			return i
		end
	end
	return nil
end
return commonSelectResourceBox

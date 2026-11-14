local solomonKeyRead = include("solomonKeyRead")
local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonSelectResourceBoxPanel = class("CommonSelectResourceBoxPanel", baseFguiPanel)
function CommonSelectResourceBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonSelectResourceBoxPanel:ctor", self.viewName)
end
function CommonSelectResourceBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonSelectResourceBoxPanel:onInit()
	print("=======CommonSelectResourceBoxPanel:onInit")
	self.fields.Panel_bg:setString(i18n("box_title_01"))
	self.fields.Title:setString(i18n("common_text_4362"))
	self.fields.Button_confirm:setTitleText(i18n("common_text_054"))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickConfim))
	self.fields.Text_alter:setString(i18n("box_text_01"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.btnExtra = self.fields.Title:getChild("Button_icon")
	self.btnExtra:addClickListener(handler(self, self.onClickExtra))
	local itemID = self.proxy.param.itemID
	local curCount = self.proxy.param.curCount
	local selectedItemID = self.proxy.param.selectedItemID
	if next(backpackltCtrl:getExtraItems(itemID)) then
		self.btnExtra:setVisible(true)
		self.fields.Title:setString(i18n("common_text_4712"))
	end
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	local itemType = backpackltCtrl:getResultType(itemID)
	self.checkHero = itemType == gItemEffectDef.OPTIONAL_HERO
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(itemID)
	self.itemList = ret
	self:sortHeroResource()
	self.itemID = itemID
	self.maxNum = backpackCtrl:getItemCount(self.itemID)
	local useMax = backpackltCtrl:getUseMax(self.itemID)
	if self.maxNum >= 999 then
		if useMax == 9999 then
			self.maxNum = self.maxNum >= 9999 and 9999 or self.maxNum
		else
			self.maxNum = 999
		end
	end
	self.maxNum = math.min(self.maxNum, useMax)
	self.fields.List:setNumItems(#self.itemList)
	_ENV = #self.itemList
	;(#self.itemList).maxValue = self.maxNum
	;(#self.itemList).minValue = 1
	;(#self.itemList).curValue = 1
	self.fields.Com_Slider:initData(#self.itemList)
	self.curCount = math.min(self.maxNum, curCount or 1)
	self.fields.Button_confirm:setEnabled(false)
	if selectedItemID then
		local itemNode, index = self:getItemNodeByItemID(selectedItemID)
		if itemNode then
			itemNode:enterAutoSelected()
			self.fields.List:scrollToView(index - 1)
		end
	end
end
function CommonSelectResourceBoxPanel:getItemNodeByItemID(selectedItemID)
	local index
	for i, v in ipairs(self.itemList) do
		if v.id == selectedItemID then
			index = i
			break
		end
	end
	if index then
		return self.fields.List:getChildAt(index - 1), index
	end
end
function CommonSelectResourceBoxPanel:onShow()
	print("=======CommonSelectResourceBoxPanel:onShow")
end
function CommonSelectResourceBoxPanel:onClickConfim()
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
function CommonSelectResourceBoxPanel:sortHeroResource()
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
function CommonSelectResourceBoxPanel:onItemRederer(index, target)
	target:initData(self.itemList[index + 1], true, true)
	target:setCheckCallBack(handler(self, self.doCallBack))
	target:showbg(index % 2 == 1)
end
function CommonSelectResourceBoxPanel:sliderCallBack(value)
	if 0 < value and self.beforeEntity then
		self.fields.Button_confirm:setEnabled(true)
		self.curCount = value
		_ENV = nil
		;(nil).num = self.curCount
		;(nil).item = self.showName
		;(nil).count = string.formatnumberthousands(self.showCount * self.curCount)
		self.fields.Text_mayGet:setString(i18n("item_text_01", nil))
	end
end
function CommonSelectResourceBoxPanel:doCallBack(singleEntity)
	if self.beforeEntity then
		self.beforeEntity:setCheck(false)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_Slider:setSliderCurValue(self.curCount)
	end
	self.beforeEntity = singleEntity
	if singleEntity.itemID then
		local name = publicRead.getName(singleEntity.itemID)
		local num = self:getOwnItemNum(singleEntity.itemID)
		local result = backpackltCtrl:getResult(singleEntity.itemID)
		if self.proxy.param.needCount then
			publicRead = nil
			;(nil).name = name
			publicRead = nil
			;(nil).cur = num
			;(nil).need = self.proxy.param.needCount
			;(nil).num = i18n("%{cur}/%{need}", nil)
			self.fields.Text_Tips:setString(i18n("common_text_4474", nil))
		else
			publicRead = i18n("common_text_4474", nil)
			i18n("common_text_4474", nil).name = name
			i18n("common_text_4474", nil).num = num
			self.fields.Text_Tips:setString(i18n("common_text_4474", i18n("common_text_4474", nil)))
		end
		self.fields.Button_confirm:setEnabled(true)
		self.showName = name
		self.showCount = singleEntity.count
		publicRead = i18n("common_text_4474", i18n("common_text_4474", nil))
		i18n("common_text_4474", i18n("common_text_4474", nil)).num = self.curCount
		i18n("common_text_4474", i18n("common_text_4474", nil)).item = self.showName
		i18n("common_text_4474", i18n("common_text_4474", nil)).count = string.formatnumberthousands(self.showCount * self.curCount)
		self.fields.Text_mayGet:setString(i18n("item_text_01", i18n("common_text_4474", i18n("common_text_4474", nil))))
	end
end
function CommonSelectResourceBoxPanel:getOwnItemNum(itemID)
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
	elseif serviceFunctions.getIDType(itemID) == gIDType.EQUIPMENT_WITH_QUALITY then
		local eid = include("equipDesRead").getRealEquipIDAndQuality(itemID)
		local equipmentMgr = include("equipmentMgr")
		if not equipmentMgr.getEquipmentArrayWithFiler(eid) then
			_ENV = equipmentMgr.getEquipmentArrayWithFiler(eid)
		end
		num = table.nums((equipmentMgr.getEquipmentArrayWithFiler(eid)))
	elseif itemType == gIDType.GARDEN_DRESS then
		num = SoraDGetCtrl("manorCityCtrl"):getItemCount(itemID)
	elseif itemID == gIDDef.DIVINE_BEAST_MARK_EXP then
		num = SoraDGetCtrl("divineBeastMarkCtrl"):getExpCount()
	else
		num = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
	end
	return num
end
function CommonSelectResourceBoxPanel:onClickExtra()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonItemExtraShowBox", nil)
end
return CommonSelectResourceBoxPanel

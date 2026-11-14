local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmHandbookPanel = class("FarmHandbookPanel", baseFguiPanel)
function FarmHandbookPanel:ctor(...)
	self.isLRU = true
	FarmHandbookPanel.super.ctor(self, ...)
	print("FarmHandbookPanel:ctor", self.viewName)
end
function FarmHandbookPanel:startReddotTimer()
	if self.reddotTimer then
		SoraDManagerRemoveTimer(self, self.reddotTimer)
		self.reddotTimer = nil
	end
	self.reddotTimer = SoradCreateTimer(self, handler(self, self.onReddotTimer), nil, nil, nil)
end
function FarmHandbookPanel:stopReddotTimer()
	if self.reddotTimer then
		SoraDManagerRemoveTimer(self, self.reddotTimer)
		self.reddotTimer = nil
	end
end
function FarmHandbookPanel:onInit()
	print("=======FarmHandbookPanel:onInit")
	self:fixChildrenPos()
	fguiHelper.SoraDSetComFields(self)
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.listBookItem:setItemRenderer(handler(self, self.itemRenderer_listBookItem))
	self.fields.listBookItem:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScroll_listBookItem))
	self.fields.listBookItem:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEndFarmBookItem))
	self.fields.listBookItem:addEventListener(fgui.UIEventType.CocosTouchCancel, handler(self, self.onTouchEndFarmBookItem))
	self.fields.Com_title:initData(i18n("farmland_text_25"), handler(self, self.onClickClose))
	self.fields.btnBuff:addClickListener(handler(self, self.onClick_btnBuff))
	self.fields.btnFruitCultivate:addClickListener(handler(self, self.onClick_btnFruitCultivate))
	self.fields.btnBuff:setTitle(i18n("farmland_text_30"))
	self.fields.btnFruitCultivate:setTitle(i18n("farmland_text_32"))
end
function FarmHandbookPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("xxxx")
	uiManager:show("RuleView", nil)
end
function FarmHandbookPanel:endShow()
	print("=======FarmHandbookPanel:endShow")
	self:initData()
	self:startReddotTimer()
end
function FarmHandbookPanel:onHide()
	self:hideFarmBookTip()
	self:stopReddotTimer()
end
function FarmHandbookPanel:onReddotTimer()
	self:updateReddot()
end
function FarmHandbookPanel:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index)
	if self.selectedType then
		if self.selectedType == index then
			obj.controllers.ctrlSelected:setSelectedIndex(2)
		else
			obj.controllers.ctrlSelected:setSelectedIndex(0)
		end
	else
		obj.controllers.ctrlSelected:setSelectedIndex(0)
	end
	obj:initData(index, icon)
end
function FarmHandbookPanel:itemRenderer_listBookItem(index, obj)
	local data = self.fruits[index + 1]
	obj.farmBookIndex = index + 1
	if data.frame then
		obj:initData(data)
	else
		local fruit = data.fruit
		local seed = data.seed
		obj:initData(fruit, seed)
	end
	self:initFarmBookItemTouch(obj)
end
function FarmHandbookPanel:onClickItem_listType(context)
	SoraDPlaySound()
	local seedType = context.data.type
	self.selectedType = seedType
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self:updateFruits(seedType)
end
function FarmHandbookPanel:initFarmBookItemTouch(obj)
	if obj.farmBookTouchInited then
		return
	end
	obj.farmBookTouchInited = true
	obj:setSwallowTouches(false)
	obj:addEventListener(fgui.UIEventType.TouchBegin, function()
		self:onTouchBeginFarmBookItem(obj)
	end)
	obj:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEndFarmBookItem))
	obj:addEventListener(fgui.UIEventType.CocosTouchCancel, handler(self, self.onTouchEndFarmBookItem))
end
function FarmHandbookPanel:onTouchBeginFarmBookItem(obj)
	local data = self:getFarmBookItemData(obj)
	if data.frame then
		return
	end
	local seed = data.seed
	SoraDPlaySound()
	local seedName = seed.name and i18n(seed.name) or tostring(seed.seedID)
	self:showFarmBookTip(obj, seed.seedID, seedName)
end
function FarmHandbookPanel:onTouchEndFarmBookItem()
	self:hideFarmBookTip()
end
function FarmHandbookPanel:getFarmBookItemData(obj)
	return self.fruits[obj.farmBookIndex]
end
function FarmHandbookPanel:hideFarmBookTip()
	if self.currentFarmBookTip then
		self.currentFarmBookTip.tip:removeFromParent()
		self.currentFarmBookTip = nil
	end
end
function FarmHandbookPanel:onScroll_listBookItem()
	if self.currentFarmBookTip then
		self:updateFarmBookTipPosition(self.currentFarmBookTip.obj, self.currentFarmBookTip.tip)
	end
end
function FarmHandbookPanel:updateFarmBookTipPosition(obj, tip)
	local list = self.fields.listBookItem
	local objPivot = obj:getPivot()
	local objPivotX = objPivot.x
	local objPivotY = objPivot.y
	local pos = obj:TransformPoint(cc.p(obj:getWidth() * objPivotX, obj:getHeight() * objPivotY), list)
	local tipPivot = tip:getPivot()
	local tipPivotX = tipPivot.x
	local tipPivotY = tipPivot.y
	local tipW = tip:getWidth()
	local tipH = tip:getHeight()
	local listW = list:getWidth()
	local tipLeft = pos.x - tipW * tipPivotX
	local tipTop = pos.y - tipH * tipPivotY
	if 0 < tipW and 0 < listW then
		if tipW >= listW then
			tipLeft = (listW - tipW) / 2
		else
			tipLeft = math.max(0, math.min(tipLeft, listW - tipW))
		end
	end
	local tipGlobalPos = list:localToGlobal(cc.p(tipLeft + tipW * tipPivotX, tipTop + tipH * tipPivotY))
	local tipLocalPos = obj:globalToLocal(tipGlobalPos)
	tip:setPosition(tipLocalPos)
end
function FarmHandbookPanel:showFarmBookTip(obj, seedID, seedName)
	self:hideFarmBookTip()
	local tip = fgui.UIPackage:createObject("ManorFarm", "ComFarmBookTip")
	tip:setPivot(0.854, 0.5, true)
	tip:setTouchable(false)
	self.fields.listBookItem:setApexIndex(obj.farmBookIndex - 1)
	obj:addChild(tip)
	_ENV = obj.addChild
	obj.addChild.obj = obj
	self.currentFarmBookTip, obj.addChild.tip = obj.addChild, tip
	self:updateFarmBookTipPosition(obj, tip)
	tip:initData(seedID, seedName)
end
function FarmHandbookPanel:onClick_btnBuff(context)
	SoraDPlaySound()
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	manorCityCtrl:setFarmBookNewBuffReddot(false)
	self:updateReddot()
	uiManager:show("FarmHandbookBuff")
end
function FarmHandbookPanel:onClick_btnFruitCultivate(context)
	SoraDPlaySound()
	if not manorCityUtil.checkSeedCultivationUnlock(true) then
		return
	end
	uiManager:show("FruitCultivate")
end
function FarmHandbookPanel:initData()
	self.selectedType = 0
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self:updateFruits(0)
	self:updateReddot()
	self.fields.btnFruitCultivate:setVisible(manorCityUtil.checkSeedCultivationUnlock())
end
function FarmHandbookPanel:updateFruits(seedType)
	self:hideFarmBookTip()
	seedType = seedType or 0
	local _ENV, fruitList = self.hideFarmBookTip, self.hideFarmBookTip
	for k, v in pairs(manorFarmRead.farmland_fruit_info) do
		local seed = manorFarmRead.getSeedInfoByFruitID(v.fruitID)
		if seed and (seedType == 0 or seed.seedType == seedType) then
			_ENV = nil
			;(nil).fruit = v
			;(nil).seed = seed
			table.insert(fruitList, nil)
		end
	end
	table.sort(fruitList, function(a, b)
		local receivedA = manorCityCtrl:getReceivedFarmBookItem(a.fruit.fruitID) == true
		local receivedB = manorCityCtrl:getReceivedFarmBookItem(b.fruit.fruitID) == true
		if receivedA ~= receivedB then
			return receivedA
		elseif a.seed.seedQuality ~= b.seed.seedQuality then
			return a.seed.seedQuality > b.seed.seedQuality
		else
			return a.seed.seedID > b.seed.seedID
		end
	end)
	self.fruits = fruitList
	self.fields.listBookItem:setNumItems(#self.fruits)
end
function FarmHandbookPanel:updateReddot()
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local fruitCultivateRed = manorCityUtil.checkSeedCultivationUnlock() and manorCityCtrl:getFarmFruitCultivateReddot()
	self.fields.btnFruitCultivate:setReddot(fruitCultivateRed)
	local farmBookNewBuffRed = manorCityCtrl:getFarmBookNewBuffReddot()
	self.fields.btnBuff:setReddot(farmBookNewBuffRed)
end
function FarmHandbookPanel:updateFruitCultivate()
	self.fields.btnFruitCultivate:btnFruitCultivate(manorCityUtil.checkSeedCultivationUnlock())
end
return FarmHandbookPanel

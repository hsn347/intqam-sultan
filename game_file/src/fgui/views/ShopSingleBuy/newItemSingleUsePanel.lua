local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemDesRead = include("itemDesRead")
local lordLocalData = include("lordLocalData")
local resDesRead = include("resDesRead")
local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local vipLocalData = include("vipLocalData")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
local pyramidCtrl = SoraDGetCtrl("pyramidCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newItemSingleUsePanel = class("newItemSingleUsePanel", baseFguiPanel)
function newItemSingleUsePanel:ctor(...)
	self.super.ctor(self, ...)
	print("newItemSingleUsePanel:ctor", self.viewName)
end
function newItemSingleUsePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function newItemSingleUsePanel:onInit()
	print("=======newItemSingleUsePanel:onInit")
	self.tableItemData, _ENV, self.needResCount = print, print, nil
	self.fields.Panel_bg.isIgnoreTextEffect = true
	self.fields.Text_resNotice:setVisible(false)
	self.fields.Text_resTotal:setVisible(false)
	self.fields.Text_resNeed:setVisible(false)
	self.fields.com_preview:setVisible(false)
	self.fields.Text_notice:setVisible(false)
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.slider:setInpuBoxFixPos(45, 130, 190)
end
function newItemSingleUsePanel:onShow()
	print("=======newItemSingleUsePanel:onShow")
	self.tableItemData = self.param.itemData
	self.msg = self.param.msg
	self.needResCount = self.param.needResList
	self.handle = self.param.handle
	self.labelHandle = self.param.labelHandle
	self.btnTitle = self.param.btnTitle
	self.fields.Button_use:setString(self.btnTitle or i18n("common_text_314"))
	self:initData()
	if self.needResCount then
		self:setNeedResCount()
	end
	self.fields.slider:setSliderCallBack(handler(self, self.sliderCallBack))
end
function newItemSingleUsePanel:setNeedResCount()
	if self.needResCount then
		self.fields.Text_resTotal:setVisible(false)
		self:refreshView()
	end
end
function newItemSingleUsePanel:refreshView()
	if self.tableItemData and self.tableItemData.id then
		_ENV = self.tableItemData.id
		self.tableItemData.id[gIDDef.FOOD_SAFE] = gIDDef.FOOD
		self.tableItemData.id[gIDDef.WOOD_SAFE] = gIDDef.WOOD
		self.tableItemData.id[gIDDef.IRON_SAFE] = gIDDef.IRON
		self.tableItemData.id[gIDDef.MITHRIL_SAFE] = gIDDef.MITHRIL
		local self.tableItemData.id[gIDDef.CRYSTAL_SAFE], tabResID = gIDDef.CRYSTAL, self.tableItemData.id
		local itemData = backpackltCtrl:getResult(self.tableItemData.id)
		local realID = tabResID[itemData[1].id] or itemData[1].id
		local curResCount = cityCtrl:getResCount(realID)
		local needData = self.needResCount[realID]
		if needData then
			needData.curcount = curResCount
		end
		local rescount = needData and needData.rescount or 0
		local curcount = needData and needData.curcount or 0
		if needData and rescount > curcount then
			local needValue = math.ceil((rescount - curcount) / itemData[1].count)
			needValue = math.min(self.tableItemData.count, needValue)
			_ENV = needValue
			needValue.maxValue = itemLogic.getItemUseCount(self.tableItemData.id, self.tableItemData.count)
			needValue.minValue = 1
			needValue.curValue = needValue
			self.fields.slider:initData(needValue)
		end
		self:updateResNeed()
		self:updateResNotice()
	end
end
function newItemSingleUsePanel:initData()
	self.fields.Panel_bg:setString(publicRead.getName(self.tableItemData.id))
	self.fields.item:initData(self.tableItemData.id)
	self.fields.Text_des:setString(publicRead.getDes(self.tableItemData.id))
	self.fields.Text_notice:setVisible(false)
	local curValue = 1
	local maxValue = itemLogic.getItemUseCount(self.tableItemData.id, self.tableItemData.count)
	local isFullChoose = backpackltCtrl:isChooseFull(self.tableItemData.id)
	if isFullChoose then
		curValue = maxValue
	end
	if self.tableItemData.bestNum then
		curValue = self.tableItemData.bestNum
	end
	publicRead = publicRead.getDes(self.tableItemData.id)
	publicRead.getDes(self.tableItemData.id).maxValue = maxValue
	publicRead.getDes(self.tableItemData.id).minValue = 1
	publicRead.getDes(self.tableItemData.id).curValue = curValue
	self.fields.slider:initData(publicRead.getDes(self.tableItemData.id))
	self:updateResNotice()
	self:showUseTotal()
	self:showUseNextPercent()
end
function newItemSingleUsePanel:sliderCallBack(value)
	local canUse = 0 < value
	self.fields.Button_use:setEnabled(canUse)
	if canUse then
		if self.msg then
			self.fields.Text_notice:setVisible(true)
			self.fields.Text_notice:setString(self.msg)
		else
			self.fields.Text_notice:setVisible(false)
		end
		if self.labelHandle then
			self.fields.Text_resTotal:setVisible(true)
			self.labelHandle(self.fields.Text_resTotal, value)
		end
	else
		self.fields.Text_notice:setVisible(false)
	end
	self:updateResNotice()
	self:showUseTotal()
	self:showUseNextPercent()
end
function newItemSingleUsePanel:showUseNextPercent()
	local itemType = backpackltCtrl:getItemType(self.tableItemData.id)
	_UPVALUE3_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.VIP_POINT
	backpackltCtrl[2] = gItemType.S_VIP_POINT
	local backpackltCtrl[3], showList = gItemType.LORD_EXP, backpackltCtrl
	if SoraDisInList(itemType, showList) then
		self.fields.com_preview:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItemData.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.fields.slider:getSliderCurValue()
		local curData, nextData = self:getUseResult(itemType, curCount * singleNum)
		self.fields.com_preview:initData(curData, nextData, itemType)
	end
end
function newItemSingleUsePanel:getUseResult(itemType, addPoint)
	local lordLocalData, curData
	local lordLocalData, nextData
	local maxLevel = lordLocalData.getMaxLordLv()
	if itemType == gItemType.LORD_EXP then
		curData.lv, curData.percent = lordInfoCtrl:calcExpShow(0)
		nextData.nextLv, nextData.nextPercent = lordInfoCtrl:calcExpShow(addPoint)
		if maxLevel <= curData.lv and curData.percent >= 1 then
			curData.lv = maxLevel
			curData.percent = "MAX"
		end
		if maxLevel <= nextData.nextLv and nextData.nextPercent >= 1 then
			nextData.nextLv = maxLevel
			nextData.nextPercent = "MAX"
		end
	elseif itemType == gItemType.VIP_POINT or itemType == gItemType.S_VIP_POINT then
		curData.lv, curData.percent = lordInfoCtrl:calcNewVipLev(itemType, 0)
		nextData.nextLv, nextData.nextPercent = lordInfoCtrl:calcNewVipLev(itemType, addPoint)
		local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
		local maxVipLevel = vipLocalData.getMaxVipLev(kingdomLev)
		if maxVipLevel <= curData.lv and curData.percent >= 1 then
			curData.lv = maxVipLevel
			curData.percent = "MAX"
		end
		if maxVipLevel <= nextData.nextLv and nextData.nextPercent >= 1 then
			nextData.nextLv = maxVipLevel
			nextData.nextPercent = "MAX"
		end
	elseif itemType == gItemType.METEOR_MAIGC_EXP then
		local curLv = meteorMagicCtrl:getCurLv()
		local curExp = meteorMagicRead.getCurLvExp(meteorMagicCtrl:getCurExp())
		local lvCfg, isMax1 = meteorMagicRead.getCurLvCfg(curLv)
		local nextLvCfg, nextExp, isMax2 = meteorMagicRead.getLvByExp(meteorMagicCtrl:getCurExp() + addPoint)
		curData.lv = curLv
		curData.percent = isMax1 and "MAX" or curExp / lvCfg.needExp
		nextData.nextLv = isMax2 and nextLvCfg.lv or nextLvCfg.lv - 1
		nextData.nextPercent = isMax2 and "MAX" or nextExp / nextLvCfg.needExp
	end
	return curData, nextData
end
function newItemSingleUsePanel:showUseTotal()
	local itemType = backpackltCtrl:getItemType(self.tableItemData.id)
	_UPVALUE14_ = backpackltCtrl
	backpackltCtrl[1] = gItemType.GOLD
	backpackltCtrl[2] = gItemType.FOOD
	backpackltCtrl[3] = gItemType.WOOD
	backpackltCtrl[4] = gItemType.IRON
	backpackltCtrl[5] = gItemType.STEEL
	backpackltCtrl[6] = gItemType.STAMINA
	backpackltCtrl[7] = gItemType.COPPER
	backpackltCtrl[8] = gItemType.MITHRIL
	backpackltCtrl[9] = gItemType.CRYSTAL
	backpackltCtrl[10] = gItemType.SAFE_WOOD
	backpackltCtrl[11] = gItemType.SAFE_FOOD
	backpackltCtrl[12] = gItemType.SAFE_IRON
	backpackltCtrl[13] = gItemType.SAFE_SECRET
	local backpackltCtrl[14], showList = gItemType.POWERFUL_ESSENCE, backpackltCtrl
	if SoraDisInList(itemType, showList) and not self.needResCount then
		self.fields.Text_resTotal:setVisible(true)
		local result = backpackltCtrl:getResult(self.tableItemData.id)
		local singleNum = result[1].count
		local singleID = result[1].id
		local curCount = self.fields.slider:getSliderCurValue()
		local curNum = self:getCurNum(itemType)
		local resName = resDesRead.getName(singleID)
		if gIDDef.FOOD_SAFE == singleID or gIDDef.WOOD_SAFE == singleID or gIDDef.IRON_SAFE == singleID or gIDDef.MITHRIL_SAFE == singleID or gIDDef.CRYSTAL_SAFE == singleID then
			backpackltCtrl = gIDDef.CRYSTAL_SAFE
			gIDDef.CRYSTAL_SAFE[gIDDef.FOOD_SAFE] = gIDDef.FOOD
			gIDDef.CRYSTAL_SAFE[gIDDef.WOOD_SAFE] = gIDDef.WOOD
			gIDDef.CRYSTAL_SAFE[gIDDef.IRON_SAFE] = gIDDef.IRON
			gIDDef.CRYSTAL_SAFE[gIDDef.MITHRIL_SAFE] = gIDDef.MITHRIL
			local gIDDef.CRYSTAL_SAFE[gIDDef.CRYSTAL_SAFE], realRid = gIDDef.CRYSTAL, gIDDef.CRYSTAL_SAFE
			resName = resDesRead.getName(realRid[singleID])
		end
		backpackltCtrl = gItemType.SAFE_FOOD
		gItemType.SAFE_FOOD.resource = resName
		gItemType.SAFE_FOOD.count = string.formatnumberthousands(singleNum * curCount + curNum)
		self.fields.Text_resTotal:setString(i18n("common_text_4289", gItemType.SAFE_FOOD))
	end
end
function newItemSingleUsePanel:getCurNum(itemType)
	local ownNum = 0
	if itemType == gItemType.GOLD then
		ownNum = lordInfoCtrl:getBaseInfo().gold
	elseif itemType == gItemType.FOOD or itemType == gItemType.SAFE_FOOD or itemType == gItemType.WOOD or itemType == gItemType.SAFE_WOOD or itemType == gItemType.IRON or itemType == gItemType.SAFE_IRON or itemType == gItemType.MITHRIL or itemType == gItemType.SAFE_SECRET or itemType == gItemType.CRYSTAL or itemType == gItemType.STEEL then
		_ENV = gItemType.STEEL
		gItemType.STEEL[gItemType.FOOD] = gIDDef.FOOD
		gItemType.STEEL[gItemType.WOOD] = gIDDef.WOOD
		gItemType.STEEL[gItemType.IRON] = gIDDef.IRON
		gItemType.STEEL[gItemType.MITHRIL] = gIDDef.MITHRIL
		gItemType.STEEL[gItemType.CRYSTAL] = gIDDef.CRYSTAL
		gItemType.STEEL[gItemType.STEEL] = gIDDef.STEEL
		gItemType.STEEL[gItemType.SAFE_FOOD] = gIDDef.FOOD
		gItemType.STEEL[gItemType.SAFE_WOOD] = gIDDef.WOOD
		gItemType.STEEL[gItemType.SAFE_IRON] = gIDDef.IRON
		local gItemType.STEEL[gItemType.SAFE_SECRET], tabResID = gIDDef.MITHRIL, gItemType.STEEL
		ownNum = cityCtrl:getResCount(tabResID[itemType])
	elseif itemType == gItemType.STAMINA then
		ownNum = lordInfoCtrl:getBaseInfo().physical
	elseif itemType == gItemType.COPPER then
		ownNum = pyramidCtrl:getCopperNum()
	elseif itemType == gItemType.POWERFUL_ESSENCE then
		ownNum = warGemCtrl:getEssenceCount()
	end
	return ownNum or 0
end
function newItemSingleUsePanel:updateResNotice()
	local resNotice
	_UPVALUE19_ = nil
	;(nil)[1] = gIDDef.GOLD
	;(nil)[2] = gIDDef.FOOD
	;(nil)[3] = gIDDef.WOOD
	;(nil)[4] = gIDDef.IRON
	;(nil)[5] = gIDDef.MITHRIL
	;(nil)[6] = gIDDef.STEEL
	;(nil)[7] = gIDDef.STAMINA
	;(nil)[8] = gIDDef.EXP
	;(nil)[9] = gIDDef.VIP_POINT
	;(nil)[10] = gIDDef.COPPER
	;(nil)[11] = gIDDef.FOOD_SAFE
	;(nil)[12] = gIDDef.WOOD_SAFE
	;(nil)[13] = gIDDef.IRON_SAFE
	;(nil)[14] = gIDDef.MITHRIL_SAFE
	;(nil)[15] = gIDDef.S_VIP_POINT
	;(nil)[16] = gIDDef.CRYSTAL
	;(nil)[17] = gIDDef.CRYSTAL_SAFE
	;(nil)[18] = gIDDef.STRONG_ESSENCE
	;(nil)[19] = gIDDef.METEOR_EXP
	;(nil)[20] = gIDDef.METEOR_CRYSTAL
	local (nil)[21], tableResId = gIDDef.METEOR_CRYSTAL_SAFE, nil
	local itemData = backpackltCtrl:getResult(self.tableItemData.id)
	if type(itemData) == "table" and #itemData == 1 and type(itemData[1]) == "table" and itemData[1].id and SoraDisInList(itemData[1].id, tableResId) then
		local curCount = self.fields.slider:getSliderCurValue()
		_ENV = gIDDef.MITHRIL
		gIDDef.MITHRIL.count = curCount
		gIDDef.MITHRIL.res = string.formatnumberthousands(curCount * itemData[1].count)
		gIDDef.MITHRIL.resname = resDesRead.getName(itemData[1].id)
		resNotice = i18n("common_text_1956", gIDDef.MITHRIL)
		if itemData[1].id == gIDDef.VIP_POINT then
			local vipLevel, isActive = SoraDGetVipLv()
			if vipLevel > VIP_SVIP_LV then
				_ENV = itemData[1].id
				itemData[1].id.count = curCount
				itemData[1].id.res = string.formatnumberthousands(vipLocalData.transPointVip2Svip(curCount * itemData[1].count))
				itemData[1].id.resname = i18n("common_text_3852")
				resNotice = i18n("common_text_1956", itemData[1].id)
			end
		end
		self.fields.Text_resNotice:setString(resNotice)
		self:updateResNeed()
	end
	self.fields.Text_resNotice:setVisible(resNotice ~= nil)
	if self.tableItemData.id == 802901 or self.tableItemData.id == 803001 or self.tableItemData.id == 803101 then
		_ENV = self.tableItemData.id
		self.tableItemData.id[802901] = 1
		self.tableItemData.id[803001] = 10
		local self.tableItemData.id[803101], flowerConfig = 100, self.tableItemData.id
		local curCount = self.fields.slider:getSliderCurValue()
		_ENV = i18n("common_text_3852")
		i18n("common_text_3852").count = curCount
		i18n("common_text_3852").num = flowerConfig[self.tableItemData.id] * curCount
		self.fields.Text_resNotice:setString(i18n("common_text_4325", (i18n("common_text_3852"))))
		self.fields.Text_resNotice:setVisible(true)
	end
	if self.tableItemData.id == 816101 then
		local count = backpackCtrl:getItemCount(816101)
		self.fields.Text_resNotice:setString(i18n("palace_text_18") .. count)
		self.fields.Text_resNotice:setVisible(true)
	end
end
function newItemSingleUsePanel:updateResNeed()
	if self.needResCount then
		_ENV = self.needResCount
		self.needResCount[gIDDef.FOOD_SAFE] = gIDDef.FOOD
		self.needResCount[gIDDef.WOOD_SAFE] = gIDDef.WOOD
		self.needResCount[gIDDef.IRON_SAFE] = gIDDef.IRON
		self.needResCount[gIDDef.MITHRIL_SAFE] = gIDDef.MITHRIL
		local self.needResCount[gIDDef.CRYSTAL_SAFE], tabResID = gIDDef.CRYSTAL, self.needResCount
		local curCount = self.fields.slider:getSliderCurValue()
		local itemData = backpackltCtrl:getResult(self.tableItemData.id)
		local curResCount = curCount * itemData[1].count
		local realID = tabResID[itemData[1].id] or itemData[1].id
		local isVisible = self.needResCount[realID] ~= nil and self.needResCount[realID].curcount ~= nil and self.needResCount[realID].curcount < self.needResCount[realID].rescount
		self.fields.Text_resNeed:setVisible(isVisible)
		if isVisible then
			self.fields.Text_resNeed:setString(resDesRead.getName(itemData[1].id) .. ":" .. string.formatnumberthousands(curCount * itemData[1].count) .. "/" .. string.formatnumberthousands(self.needResCount[realID].rescount - self.needResCount[realID].curcount))
			if curResCount < self.needResCount[realID].rescount - self.needResCount[realID].curcount then
				self.fields.Text_resNeed:setColor(cc.c3b(190, 40, 40))
			else
				self.fields.Text_resNeed:setColor(cc.c3b(255, 251, 213))
			end
		end
	end
end
function newItemSingleUsePanel:btnClickCallBack()
	SoraDPlaySound()
	local sureUse = function()
		local itemID = self.tableItemData.id
		local count = self.fields.slider:getSliderCurValue()
		local isPass = itemLogic.checkResUseLowCastle(itemID, count)
		if not isPass then
			self = nil
			;(nil).food = "500K"
			;(nil).wood = "500K"
			SoraDShowMsgBox(i18n("common_text_3500", nil), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					backpackCtrl:reqUseItem(itemID, count)
				end
			end)
		else
			backpackCtrl:reqUseItem(itemID, count)
		end
	end
	if self.handle then
		_ENV = nil
		;(nil).id = self.tableItemData.id
		;(nil).num = self.fields.slider:getSliderCurValue()
		self.handle(self, nil)
	elseif not itemLogic.checkItemSpecial(self.tableItemData.id, self.fields.slider:getSliderCurValue()) then
		sureUse()
	end
	self:close()
end
return newItemSingleUsePanel

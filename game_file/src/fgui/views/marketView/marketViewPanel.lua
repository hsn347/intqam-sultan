local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityltCtrl = include("cityltCtrl")
local resDesRead = include("resDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local marketViewPanel = class("marketViewPanel", baseFguiPanel)
function marketViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("marketViewPanel:ctor", self.viewName)
end
function marketViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function marketViewPanel:onInit()
	print("=======marketViewPanel:onInit")
	self.tableResCount, _ENV, self.marketData, _ENV = print, print, print, print
	self.btnDeal = SoraDGetChildByName(self, "Button_deal")
	self.scroll = SoraDGetChildByName(self, "list")
	self.fields.com_top:fixChildrenPos(true)
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.txtOverWeight = SoraDGetChildByName(self, "Text_overWeight")
	self.txtOverWeight:setString(i18n("common_text_324"))
	self.txtOverWeightValue = SoraDGetChildByName(self, "Text_overWeight_value")
	self.txtTax = SoraDGetChildByName(self, "Text_tax")
	self.txtTax:setString(i18n("bulidDyf_title_1122") .. "：")
	self.txtTaxValue = SoraDGetChildByName(self, "Text_tax_value")
	_UPVALUE5_, self.txtCityTo = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo")
	_ENV, self.tableResType, SoraDGetChildByName(self, "Text_cityTo")[1] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), gIDDef.FOOD
	_ENV, self.tableResType, SoraDGetChildByName(self, "Text_cityTo")[2] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), gIDDef.WOOD
	_ENV, self.tableResType, SoraDGetChildByName(self, "Text_cityTo")[3] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), gIDDef.IRON
	_ENV, self.tableResType, SoraDGetChildByName(self, "Text_cityTo")[4] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), gIDDef.MITHRIL
	_ENV, self.tableResType, SoraDGetChildByName(self, "Text_cityTo")[5] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), gIDDef.CRYSTAL
	SoraDGetChildByName(self, "Text_cityTo")[1002] = 1
	SoraDGetChildByName(self, "Text_cityTo")[1003] = 1
	SoraDGetChildByName(self, "Text_cityTo")[1004] = 6
	SoraDGetChildByName(self, "Text_cityTo")[1005] = 24
	_ENV, self.tableResPerWeight, SoraDGetChildByName(self, "Text_cityTo")[gIDDef.CRYSTAL] = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), 96
	SoraDGetChildByName(self, "Text_cityTo")[1002] = 1
	SoraDGetChildByName(self, "Text_cityTo")[1003] = 1
	SoraDGetChildByName(self, "Text_cityTo")[1004] = 10
	SoraDGetChildByName(self, "Text_cityTo")[1005] = 15
	self.tableResLimitLV, SoraDGetChildByName(self, "Text_cityTo")[gIDDef.CRYSTAL] = SoraDGetChildByName(self, "Text_cityTo"), resDesRead.getUnLockLevel(gIDDef.CRYSTAL)
	self.tableResSingle, _ENV, self.toResItem, _ENV, self.selfResBtn, _ENV, self.selfLV = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), 0
	self.leftCanGetRes, _ENV, self.err = SoraDGetChildByName(self, "Text_cityTo"), SoraDGetChildByName(self, "Text_cityTo"), nil
	for i, v in ipairs(self.tableResType) do
		self.selfResBtn[v] = SoraDGetChildByName(self, "Button_res" .. v)
		self.selfResBtn[v]:setTag(v)
		self.selfResBtn[v]:addClickEventListener(function(target, event)
			local resID
			if target:getTag() == gIDDef.MITHRIL then
				SoraDPlaySound("uicontrol", 27)
				if SoraDResIsLock(gIDDef.MITHRIL) then
					resID = gIDDef.MITHRIL
				end
			elseif target:getTag() == gIDDef.IRON then
				SoraDPlaySound("uicontrol", 26)
				if SoraDResIsLock(gIDDef.IRON) then
					resID = gIDDef.IRON
				end
			elseif target:getTag() == gIDDef.FOOD then
				SoraDPlaySound("uicontrol", 24)
				resID = gIDDef.FOOD
			elseif target:getTag() == gIDDef.WOOD then
				SoraDPlaySound("uicontrol", 28)
				resID = gIDDef.WOOD
			elseif target:getTag() == gIDDef.CRYSTAL then
				SoraDPlaySound("uicontrol", 23)
				if SoraDResIsLock(gIDDef.CRYSTAL) then
					resID = gIDDef.CRYSTAL
				end
			end
			_ENV = nil
			;(nil).rid = resID
			uiManager:show("resourceBuyView", nil)
		end)
	end
	for i, v in ipairs(self.tableResType) do
		self.toResItem[v] = SoraDGetChildByName(self, "Node_res" .. v)
	end
	self.fields.Com_title:initData(i18n("common_text_221"), handler(self, self.onClickClose))
	self.btnDeal:setTitle(i18n("common_text_044"))
	self.btnDeal:setTouchEnabled(false)
	self.btnDeal:setBright(false)
	self.btnDeal:addClickEventListener(handler(self, self.btnDealClick))
	SoraDCreateTimerEx(self, handler(self, self.resRefresh), 0.15)
end
function marketViewPanel:onShow()
	print("=======marketViewPanel:onShow")
end
function marketViewPanel:initView(uData)
	self.marketData = uData
	kingdomMapCtrl:reqGetCastleMapInfo(self.marketData.uid)
	lordInfoCtrl:checkBetrayByUidReq(self.marketData.uid)
	cityCtrl:sendLeftCanGetResByUid(self.marketData.uid)
	local buildLogic = include("buildLogic")
	self.marketData.tax = buildLogic.getMarketRate().total
	self.marketData.overWeight = buildLogic.getMarketWeight().total
	for i, v in ipairs(self.tableResType) do
		kingdomMapCtrl = nil
		;(nil).resID = v
		;(nil).resCount = cityCtrl:getNormalRes(v)
		table.insert(self.tableResCount, nil)
	end
	local resTypeVisibleCount = 0
	for k, v in pairs(self.tableResCount) do
		if SoraDResIsLock(v.resID) then
			resTypeVisibleCount = resTypeVisibleCount + 1
		else
			self.selfResBtn[v.resID]:setVisible(false)
			self.toResItem[v.resID]:setVisible(false)
		end
	end
	self.scroll:setNumItems(resTypeVisibleCount)
	self.txtTaxValue:setString(self.marketData.tax * 100 .. "%")
	self.txtOverWeightValue:setString("0/" .. string.formatnumberthousands(self.marketData.overWeight))
	self:resRefresh()
end
function marketViewPanel:onItemRenderer(index, single)
	local data = self.tableResCount[index + 1]
	single:fixChildrenPos()
	local limtResCount = math.min(data.resCount * self.tableResPerWeight[data.resID], self.marketData.overWeight)
	_ENV = data.resID
	data.resID.resid = data.resID
	data.resID.max = limtResCount
	data.resID.canMax = limtResCount
	data.resID.perWeight = self.tableResPerWeight[data.resID]
	single:initData(data.resID, false)
	single:setSliderCallBack(handler(self, self.singleSliderChange))
	self.tableResSingle[data.resID] = single
	local resTypeVisibleCount
	single:setBottomLineVisible(index + 1 == resTypeVisibleCount)
end
function marketViewPanel:bindData(target, redata)
	if redata.data then
		self.txtCityTo:setString(redata.data.nickName)
		kingdomMapCtrl = self.txtCityTo
		self.txtCityTo.x = redata.data.x
		self.marketData.uPos, self.txtCityTo.y = self.txtCityTo, redata.data.y
		self.marketData.instanceID = redata.data.id
		self.marketData.level = redata.data.level
		local time = kingdomMapCtrl:getArmyMoveTime(gMapObjTypeDef.mapObjTypePlayer, worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu, nil, self.marketData.uPos)
		self.btnDeal:setCostTitle(SoraDConvertSecondToString(time))
	end
	self:selfResMask()
	self:toResMask()
end
function marketViewPanel:isBetrayBack(target, redata)
	dump(redata, "marketViewPanel:isBetrayBack")
	if redata then
		self.isBetray = redata.result
	end
end
function marketViewPanel:getOtherInfo(target, data)
	self.err = data.err
	self.leftCanGetRes = data.leftCanGetRes
end
function marketViewPanel:selfResMask()
	for k, v in pairs(self.tableResLimitLV) do
		if v > self.marketData.level then
			if self.tableResSingle[k] then
				self.tableResSingle[k]:meLock(true)
			end
		elseif self.tableResSingle[k] then
			self.tableResSingle[k]:meLock(false)
		end
	end
end
function marketViewPanel:toResMask()
end
function marketViewPanel:singleSliderChange(action)
	local leftWeight = self.marketData.overWeight
	for k, v in pairs(self.tableResSingle) do
		leftWeight = leftWeight - v:getFinalWeight()
		self.toResItem[k]:setTitle(string.formatnumberthousands(math.floor(v:getFinalCount() * (1 - self.marketData.tax))))
	end
	for k, v in pairs(self.tableResSingle) do
		v:setCanMax(v:getFinalWeight() + leftWeight)
	end
	self.txtOverWeightValue:setString(string.formatnumberthousands(math.floor(self.marketData.overWeight - leftWeight)) .. "/" .. string.formatnumberthousands(self.marketData.overWeight))
	self.btnDeal:setTouchEnabled(leftWeight ~= self.marketData.overWeight)
	self.btnDeal:setBright(leftWeight ~= self.marketData.overWeight)
	if action and leftWeight == 0 then
		self:overWeightAction()
	end
end
function marketViewPanel:overWeightAction()
	local action0 = ffa.scaleTo(0.2, 1.2, 1.2)
	local action1 = ffa.scaleTo(0.2, 1, 1)
	local action2 = ffa.tintBy(0.2, 1, 0, 0)
	local action3 = action2:reverse()
	_UPVALUE2_ = nil
	;(nil)[1] = action0
	;(nil)[2] = action1
	self.txtOverWeightValue:runAction(ffa.seq(nil))
	_UPVALUE2_ = ffa.seq(nil)
	ffa.seq(nil)[1] = action2
	ffa.seq(nil)[2] = action3
	self.txtOverWeightValue:runAction(ffa.seq(ffa.seq(nil)))
end
function marketViewPanel:resRefresh()
	for k, v in pairs(self.tableResCount) do
		v.resCount = cityCtrl:getNormalRes(v.resID)
		self.selfResBtn[v.resID]:setTitle(SoraDConvertNumberWithUnit(math.floor(v.resCount)))
		if self.tableResSingle[v.resID] then
			self.tableResSingle[v.resID]:setMax(math.min(v.resCount * self.tableResPerWeight[v.resID], self.tableResSingle[v.resID].sliderControl.max))
			self.tableResSingle[v.resID]:correctSlider()
		end
	end
end
function marketViewPanel:btnDealClick(button, type)
	SoraDPlaySound()
	if SoraDEnoughTroops() then
		local _ENV, postResTable = SoraDEnoughTroops(), SoraDEnoughTroops()
		local _ENV, taxResTable
		for k, v in pairs(self.tableResSingle) do
			if v:getFinalCount() > 0 then
				_ENV = nil
				;(nil).id = k
				;(nil).num = math.floor(v:getFinalCount())
				table.insert(postResTable, nil)
				taxResTable[k] = math.floor(v:getFinalCount())
			end
		end
		local dispatch = function()
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
				SoraDShowMsgTip(i18n("worldwar_text_06"))
				return
			end
			local remainsWarUtil = include("remainsWarUtil")
			if remainsWarUtil.isForbitWarByInBorn() then
				SoraDShowMsgTip(i18n("remains_text_142"))
				return
			end
			if self.isBetray and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
				SoraDShowMsgTip(i18n("worldwar_text_02"))
				return
			end
			gametop = SoraDShowMsgTip
			gametop, SoraDShowMsgTip.dispatchType = worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu, worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu
			SoraDShowMsgTip.otherData, worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu.resourceList = worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu, postResTable
			SoraDShowMsgTip.toPoint = self.marketData.uPos
			local SoraDShowMsgTip.instanceID, armyData = self.marketData.instanceID, SoraDShowMsgTip
			worldMapFunction.gotoDispatch(armyData, true)
			SoraDRemoveAllPanelFromManager()
		end
		if self.err and self.err == gErrDef.Err_None then
			local isWarn = false
			for k, v in pairs(taxResTable) do
				if self.leftCanGetRes[tostring(k)] and v * (1 - self.marketData.tax) > self.leftCanGetRes[tostring(k)] then
					isWarn = true
					break
				end
			end
			if isWarn then
				SoraDShowMsgBox(i18n("common_text_3502"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						dispatch()
					end
				end)
			else
				dispatch()
			end
		else
			dispatch()
		end
	end
end
return marketViewPanel

local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local armyLogic = include("armyLogic")
local armyltCtrl = include("armyltCtrl")
local worldMapWarDef = include("worldMapWarDef")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HospitalViewPanel = class("HospitalViewPanel", baseFguiPanel)
function HospitalViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HospitalViewPanel:ctor", self.viewName)
end
function HospitalViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HospitalViewPanel:onInit()
	self.fields.Com_bg:setGradientColor()
	fguiHelper.SoraDSetComFields(self)
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	print("=======HospitalViewPanel:onInit")
	self.needGold = 0
	self.tableHospitalData, _ENV, self.armyCostTime, _ENV, self.armyCostRes, _ENV, self.woundedCount = print, print, print, print, print, print, 0
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_res:setItemRenderer(handler(self, self.onResRenderer))
	self.fields.noWounded:setString(i18n("common_text_409"))
	self.fields.btnAllSelect:setTitle(i18n("common_text_404"))
	self.fields.btnHeal:setTitle(i18n("common_text_065"))
	self.txtRightTime = SoraDCreateTimerLabel(self, self.fields.btnHealNow.fields.Text_rightTime)
	self.txtHealNow = self.fields.btnHealNow.fields.title
	self.txtHealNow:setString(i18n("common_text_402"))
	self.fields.btnAllSelect:addClickEventListener(handler(self, self.btnAllSelectClickCallBack))
	self.fields.btnHeal:setCostIcon("icon_hourglass.png")
	self.fields.btnHeal:addClickEventListener(handler(self, self.btnHealClickCallBack))
	self.fields.btnHealNow:addClickEventListener(handler(self, self.btnHealNowClickCallBack))
	self.fields.btnOrder:addClickEventListener(handler(self, self.onClick_btnOrder))
	self.btnHelp = fguiHelper.get_fields(self.fields.Com_HV_title).btn_help
	self.btnHelp:fixPos()
	self.btnHelp:addClickEventListener(handler(self, self.btnHelpClickCallBack))
	local constantRead = include("constantRead")
	if worldMapDefine.isInLegendLord() then
		local btnCostHelp = fguiHelper.get_fields(self.fields.Com_HV_title2).btn_help
		btnCostHelp:setVisible(true)
		btnCostHelp:addClickEventListener(handler(self, self.onClickBtnCostHelp))
	end
end
function HospitalViewPanel:onShow()
	print("=======HospitalViewPanel:onShow")
	self.controllers.ctrlOrder:setSelectedIndex(1 - armyCtrl:readHospitalOrder())
end
function HospitalViewPanel:setLV(bLevel, warType)
	if warType then
		self.warType = warType
	elseif worldMapDefine.isInRoaringFlame() then
		self.warType = gKingdomClassType.roaringFlame
	elseif worldMapDefine.isInLegendLord() then
		self.warType = gKingdomClassType.legendLord
	elseif worldMapDefine.isInSimulatedDrill() then
		self.warType = gKingdomClassType.simulatedDrill
	end
	self:updateBuildTitle(bLevel)
	self:initView()
end
function HospitalViewPanel:updateBuildTitle(bLevel)
	local titleName = worldMapWarDef.getHostpitalViewTitle(self.warType)
	if titleName then
		self.fields.Com_title:updateTitle(titleName)
		return
	end
	local buildLogic = include("buildLogic")
	local buildRead = include("buildDescribeRead")
	bLevel = bLevel or cityCtrl:getBuildMaxLv(BUILDID.HOSTPITAL)
	local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
	if 0 < warLv then
		worldMapWarDef = nil
		;(nil).build = buildRead.getName(BUILDID.HOSTPITAL)
		;(nil).lv = warLv
		self.fields.Com_title:updateTitle(i18n("common_text_1957", nil))
	elseif bLevel > CASTLE_MAXLV_NOWAR then
		worldMapWarDef = i18n("common_text_1957", nil)
		i18n("common_text_1957", nil).level = CASTLE_MAXLV_NOWAR
		self.fields.Com_title:updateTitle(i18n("common_text_407", i18n("common_text_1957", nil)))
	else
		worldMapWarDef = i18n("common_text_407", i18n("common_text_1957", nil))
		i18n("common_text_407", i18n("common_text_1957", nil)).level = bLevel
		self.fields.Com_title:updateTitle(i18n("common_text_407", i18n("common_text_407", i18n("common_text_1957", nil))))
	end
end
function HospitalViewPanel:initView()
	self:judgeIsPyramidWar()
	self:updateData()
	self:initButtonTimeGold()
	self:refreshRes()
	self:initResData()
end
function HospitalViewPanel:updateResSingle(...)
	local tableKey = self:getResIdList()
	local _ENV, tableHaveRes = self, self
	for _, v in ipairs(tableKey) do
		tableHaveRes[v] = cityCtrl:getResCount(v)
	end
	local _ENV, tmpResTbl = (for generator), ipairs(tableKey)
	if self.tableHospitalData and next(self.tableHospitalData) ~= nil then
		for _, v in ipairs(self.tableHospitalData) do
			local armyRes = self.armyCostRes[v.id]
			for _, val in pairs(armyRes) do
				if not tmpResTbl[val.resid] then
					tmpResTbl[val.resid] = 0
				end
				tmpResTbl[val.resid] = tmpResTbl[val.resid] + val.rescount * v.cur
			end
		end
	end
	if self:checkUnLockLegendCrystal() then
		tmpResTbl = armyLogic.cureWoundedArmyResTransfer(tmpResTbl, self.warType)
	end
	local _ENV, needResList = armyLogic.cureWoundedArmyResTransfer(tmpResTbl, self.warType), armyLogic.cureWoundedArmyResTransfer(tmpResTbl, self.warType)
	for i, v in ipairs(self.fields.List_res:getChildren()) do
		local resKey = self.resList[i]
		_ENV = self.fields.List_res:getChildren()
		self.fields.List_res:getChildren().resid = resKey
		self.fields.List_res:getChildren().rescount = tmpResTbl[resKey]
		self.fields.List_res:getChildren().curcount = tableHaveRes[resKey]
		table.insert(needResList, self.fields.List_res:getChildren())
	end
	for _, v in ipairs(self.fields.List_res:getChildren()) do
		v:updateResource(needResList)
	end
	self:refreshRes()
end
function HospitalViewPanel:onItemRenderer(index, obj)
	local data = self.tableHospitalData[index + 1]
	obj:initData(data)
	obj:setSliderChangeBack(handler(self, self.countCallBack))
end
function HospitalViewPanel:onResRenderer(index, obj)
	_ENV = nil
	;(nil).resid = self.resList[index + 1]
	;(nil).rescount = 0
	local (nil).curcount, data = math.floor(cityCtrl:getResCount(self.resList[index + 1])), nil
	obj:initData(data)
end
function HospitalViewPanel:updateData(order)
	local tmpArmyData = armyCtrl:getWoundedArmy(self.warType)
	if next(tmpArmyData) then
		self.fields.noWounded:setVisible(false)
	else
		self.fields.noWounded:setVisible(true)
	end
	local transList = function(list)
		if not list and next(list) == nil then
			_ENV = next(list)
			return next(list), 0
		end
		local keys = table.keys(list)
		table.sort(keys, function(a, b)
			local atype = armyltCtrl.getArmyTypeAndLv(a)
			local btype = armyltCtrl.getArmyTypeAndLv(b)
			local alv = armyLogic.getArmyLV(a)
			local blv = armyLogic.getArmyLV(b)
			if order == 1 then
				if alv == blv then
					return atype > btype
				else
					return alv > blv
				end
			elseif alv == blv then
				return atype < btype
			else
				return alv < blv
			end
		end)
		local _ENV, reTbl = table.sort, table.sort
		local totalCount = 0
		for _, v in ipairs(keys) do
			_ENV = nil
			;(nil).id = v
			;(nil).num = tonumber(list[v])
			;(nil).cur = 0
			table.insert(reTbl, nil)
			totalCount = totalCount + tonumber(list[v])
		end
		return reTbl, totalCount
	end
	local woundedCount
	self.tableHospitalData, woundedCount = transList(tmpArmyData)
	self:countArmyCostAndTime()
	if self.isInWar or self.warType and self.warType ~= gKingdomClassType.normal then
		self.fields.Com_HV_title:setTitle(string.formatnumberthousands(woundedCount) .. "/MAX")
	else
		local total = armyLogic.getHostpitalMaxCapacity().total
		self.fields.Com_HV_title:setTitle(string.formatnumberthousands(woundedCount) .. "/" .. string.formatnumberthousands(total))
	end
	self:refreshTable()
	self:updateScroll()
end
function HospitalViewPanel:countArmyCostAndTime(...)
	self.armyForce, _ENV, self.armyCostTime, _ENV, self.armyCostRes, _ENV = nil, nil, nil, nil, nil, nil
	for _, v in ipairs(self.tableHospitalData) do
		local armyRes = armyLogic.getArmyCureCostRes(v.id, nil, self.warType)
		dump(armyRes, "countArmyCostAndTime", 10)
		local curetime = 0
		if worldMapDefine.isInAtlantis() or worldMapDefine.isInNebula() or worldMapDefine.isInSimulatedDrill() then
			curetime = armyLogic.getAtlantisWarArmyCureTime(v.id)
		elseif self.warType == gKingdomClassType.roaringFlame then
			curetime = armyLogic.getRoaringFlameArmyCureTime(v.id)
		else
			curetime = armyLogic.getArmyCureTime(v.id, nil, self.isInRadience, self.warType)
		end
		self.armyCostTime[v.id] = curetime
		self.armyCostRes[v.id] = armyRes
		self.armyForce[v.id] = armyltCtrl.armyAttr(v.id, ARMY_ATTR.POWER)
	end
end
function HospitalViewPanel:refreshTable(...)
	local listLong = table.nums(self.tableHospitalData) * 140
	local sSize = self.fields.scroll:getContentSize()
	local sH = math.max(listLong, sSize.height)
	for i, v in ipairs(self.tableHospitalData) do
		v.posY = sH - (i - 1) * 140
		v.index = i
	end
end
function HospitalViewPanel:updateScroll(...)
	self.fields.scroll:setNumItems(#self.tableHospitalData)
end
function HospitalViewPanel:countCallBack(tbl)
	if self.tableHospitalData[tbl.index] then
		self.tableHospitalData[tbl.index].cur = tbl.cur
	end
	self:refreshRes()
end
function HospitalViewPanel:refreshRes(...)
	local _ENV, tmpResTbl
	local healTime = 0
	local selectForce = 0
	local goldNeed = 0
	local tableKey = self:getResIdList()
	local _ENV, tableHaveRes = self, self
	for _, v in ipairs(tableKey) do
		tableHaveRes[v] = cityCtrl:getResCount(v)
	end
	for _, v in ipairs(self.tableHospitalData) do
		local armyRes = self.armyCostRes[v.id]
		local armyForce = self.armyForce[v.id]
		selectForce = selectForce + armyForce * v.cur
		healTime = healTime + self.armyCostTime[v.id] * v.cur
		for _, val in pairs(armyRes) do
			if not tmpResTbl[val.resid] then
				tmpResTbl[val.resid] = 0
			end
			tmpResTbl[val.resid] = tmpResTbl[val.resid] + val.rescount * v.cur
		end
	end
	local crystalCount = self:getResCrystalCount()
	local isNeedMeteor = false
	for resID, needRes in pairs(tmpResTbl) do
		local haveRes = tableHaveRes[resID] or 0
		local deta = needRes - haveRes
		if 0 < deta then
			if resID ~= gIDDef.METEOR_CRYSTAL and resID ~= gIDDef.GILDED_CURE_ESSENCE then
				goldNeed = goldNeed + serviceFunctions.resConvertToGold(resID, deta)
			else
				if resID == gIDDef.METEOR_CRYSTAL and self:checkUnLockLegendCrystal() then
					if not worldMapWarDef.checkCanUseMeteorCrystal() then
						haveRes = crystalCount
					else
						haveRes = haveRes + crystalCount
					end
				end
				isNeedMeteor = needRes > haveRes
			end
		end
	end
	if self:checkUnLockLegendCrystal() then
		tmpResTbl = armyLogic.cureWoundedArmyResTransfer(tmpResTbl, self.warType)
	end
	self.fields.btnHeal:setCostTitle(SoraDConvertSecondToString(math.ceil(healTime)))
	_ENV = SoraDConvertSecondToString(math.ceil(healTime))
	SoraDConvertSecondToString(math.ceil(healTime)).num = math.ceil(selectForce)
	self.fields.Com_HV_title2:setTitle(i18n("common_text_2534", SoraDConvertSecondToString(math.ceil(healTime))))
	local _ENV, needResList = self.fields.Com_HV_title2.setTitle, self.fields.Com_HV_title2.setTitle
	for i, v in ipairs(self.fields.List_res:getChildren()) do
		local resKey = self.resList[i]
		_ENV = self.fields.List_res:getChildren()
		self.fields.List_res:getChildren().resid = resKey
		self.fields.List_res:getChildren().rescount = tmpResTbl[resKey] or 0
		self.fields.List_res:getChildren().curcount = tableHaveRes[resKey]
		table.insert(needResList, self.fields.List_res:getChildren())
	end
	for i, v in ipairs(self.fields.List_res:getChildren()) do
		local resKey = self.resList[i]
		_ENV = self.fields.List_res:getChildren()
		self.fields.List_res:getChildren().resid = resKey
		self.fields.List_res:getChildren().rescount = tmpResTbl[resKey] or 0
		self.fields.List_res:getChildren().curcount = tableHaveRes[resKey]
		v:initData(self.fields.List_res:getChildren())
	end
	self.warCrystalNeedCount = 0
	if self:checkShowNodeLegendJJ() then
		local crystalID = worldMapWarDef.getWarCrystalID()
		self.warCrystalNeedCount = tmpResTbl[crystalID] or 0
	end
	if self.isInRadience or self.warType == gKingdomClassType.roaringFlame then
		self.needGold = tonumber(math.floor(serviceFunctions.timeConvertToRadianceQuarry(healTime)))
		local hasNum = 0
		if self.warType == gKingdomClassType.roaringFlame then
			local roaringFlameWarRead = include("roaringFlameWarRead")
			local itemID = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CURE_ITEM", 872901)
			hasNum = backpackCtrl:getItemCount(itemID) or 0
		else
			local radianceWarUtil = include("radianceWarUtil")
			hasNum = radianceWarUtil.getRadianceQuarryItemNum()
		end
		local str = SoraDConvertNumberWithUnit(self.needGold) .. "/" .. SoraDConvertNumberWithUnit(hasNum)
		self.fields.btnHealNow:setCostTitle(str)
		if hasNum >= self.needGold then
			self.fields.btnHealNow:setTitleColor(cc.c3b(221, 199, 0))
		else
			self.fields.btnHealNow:setTitleColor(display.COLOR_RED)
		end
	elseif self.isInWar then
		self.needGold = tonumber(math.floor(serviceFunctions.timeConvertToGold(healTime, true)))
		self.fields.btnHealNow:setCostTitle(tostring(self.needGold))
	else
		self.fields.btnHeal:setTitleColor(isNeedMeteor and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
		self.needGold = tonumber(math.floor(serviceFunctions.timeConvertToGold(healTime, true)) + math.floor(goldNeed))
		self.fields.btnHealNow:setCostTitle(tostring(self.needGold))
	end
	self.fields.btnHeal:setTouchEnabled(0 < healTime)
	self.fields.btnHeal:setBtnBgGray(not (0 < healTime))
	if not self.isInWar then
		self.fields.btnHealNow:setTouchEnabled(0 < healTime and not isNeedMeteor)
		self.fields.btnHealNow:setBtnBgGray(not (0 < healTime) or not not isNeedMeteor)
	elseif not self.isPyramidCDOut then
		self.fields.btnHealNow:setTouchEnabled(false)
		self.fields.btnHealNow:setBtnBgGray(true)
	else
		self.fields.btnHealNow:setTouchEnabled(0 < healTime)
		self.fields.btnHealNow:setBtnBgGray(not (0 < healTime))
	end
end
function HospitalViewPanel:initResData()
	local tableKey = self:getResIdList()
	self.resList, _ENV = self, self
	for _, v in ipairs(tableKey) do
		if SoraDResIsLock(v) then
			table.insert(self.resList, v)
		end
	end
	self.fields.List_res:setNumItems(#self.resList)
	local line = math.ceil(#self.resList / 3)
	self.fields.List_res:setHeight(line * 45 + (line - 1) * 5)
	self.fields.scroll:setHeight(self.view:getHeight() - 129 - self.fields.Mod_bottom:getHeight())
end
function HospitalViewPanel:selectedAll()
	if self.tableHospitalData and next(self.tableHospitalData) ~= nil then
		local trigger = false
		for _, v in pairs(self.tableHospitalData) do
			if v.cur ~= 0 then
				trigger = true
			end
		end
		if trigger then
			for _, v in pairs(self.tableHospitalData) do
				v.cur = 0
			end
			self:updateScroll()
			self:refreshRes()
			return
		end
	else
		return
	end
	if self.isInWar then
		for _, v in pairs(self.tableHospitalData) do
			v.cur = v.num
		end
		self:updateScroll()
		self:refreshRes()
		return
	end
	local tableKey = self:getResIdList()
	local _ENV, tableHaveRes = self, self
	for _, v in ipairs(tableKey) do
		tableHaveRes[v] = cityCtrl:getResCount(v)
	end
	local _ENV, tableArmy = (for generator), ipairs(tableKey)
	for _, v in ipairs(self.tableHospitalData) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).num = v.num
		table.insert(tableArmy, nil)
	end
	table.sort(tableArmy, function(army1, army2)
		local armyID1 = army1.id % 1000
		local armyID2 = army2.id % 1000
		local armyLv1 = armyID1 % 100
		local armyLv2 = armyID2 % 100
		if armyLv1 == armyLv2 then
			return armyID1 < armyID2
		else
			return armyLv1 > armyLv2
		end
	end)
	for _, val in ipairs(tableArmy) do
		local _ENV, healCount = table.insert, table.insert
		print("selectedAll-id", val.id)
		local armyNeedRes = self.armyCostRes[val.id]
		for i, _ in ipairs(armyNeedRes) do
			healCount[i] = val.num
		end
		local maxHeal = val.num
		if next(healCount) then
			maxHeal = math.min(unpack(healCount))
		end
		val.cur = maxHeal
	end
	for _, val in pairs(tableArmy) do
		for _, v in pairs(self.tableHospitalData) do
			if v.id == val.id then
				v.cur = val.cur
			end
		end
	end
	self:updateScroll()
	self:refreshRes()
end
function HospitalViewPanel:pyramidCDBack(target, redata)
	self:judgeIsPyramidWar()
	self:refreshRes()
end
function HospitalViewPanel:legendCDBack(target, redata)
	self:judgeIsPyramidWar()
	self:refreshRes()
end
function HospitalViewPanel:judgeIsUnlockBrave()
	if commonCheck.WARFRAME_WEAR and SoraDIsBrave8Level() and armyLogic.isUnlockWarTechnology() then
		return true
	end
	return true
end
function HospitalViewPanel:judgeIsLegendWar()
	local isInWar = false
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			isInWar = true
		end
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_STAR_BATTLE)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			isInWar = true
		end
	end
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
	if hegemonState == gActivityState.OPEN then
		local curState = timeTbInfo.curState
		if curState == ACTIVITY_STATE.ACTIVE then
			isInWar = true
		end
	end
	return isInWar
end
function HospitalViewPanel:judgeIsPyramidWar()
	local worldMapDefine = include("worldMapDefine")
	self.isInRadience = false
	self.isInWar = false
	self.isInLegend = false
	if worldMapDefine.isInPyramid() then
		self.isInWar = true
		local pyramidCD = armyCtrl:getHostpitalPyramidWarCDQueueTime()
		if 0 < pyramidCD then
			self.isPyramidCDOut = false
			self.txtRightTime:setTimeEndListener(function()
				self.txtRightTime:setVisible(false)
				self.fields.btnHealNow:setRightNowVisible(true)
			end)
			self.txtRightTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_3250", nil)
			end)
			self.txtRightTime:beginTime(pyramidCD)
			self.txtRightTime:setVisible(true)
			self.txtHealNow:setVisible(false)
			self.fields.btnHealNow:setRightNowVisible(false)
		else
			self.isPyramidCDOut = true
			self.txtRightTime:setVisible(false)
			self.txtHealNow:setVisible(true)
			self.fields.btnHealNow:setRightNowVisible(true)
		end
		self.fields.txtPyramid:setString(i18n("common_text_3354"))
	elseif worldMapDefine.isInRemains() then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.txtPyramid:setString(i18n("remains_text_88"))
	elseif worldMapDefine.isInRadiance() or self.warType == gKingdomClassType.radiance then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.isInRadience = true
		self.fields.txtPyramid:setString(i18n("brightWar_text_47"))
		self.btnHelp:setVisible(false)
		local radianceWarDef = include("radianceWarDef")
		local publicRead = include("publicRead")
		local itemIcon = publicRead.getIcon(radianceWarDef.RADIANCE_QUARRY)
		self.fields.btnHealNow:setCostIcon(itemIcon)
	elseif worldMapDefine.isInNewTrial() then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.List_res:setVisible(false)
		self.fields.txtPyramid:setString(i18n("devilvalley_text_46"))
		self.fields.txtPyramid:setVisible(true)
		self.txtRightTime:setVisible(false)
		self.fields.btnHealNow:setRightNowVisible(true)
	elseif worldMapDefine.isInAtlantis() or self.warType == gKingdomClassType.atlantis then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.txtPyramid:setString(i18n("atlantiswar_text_0150"))
		self.btnHelp:setVisible(false)
	elseif worldMapDefine.isInNebula() then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.txtPyramid:setString(i18n("nebula_war_text_0116"))
		self.btnHelp:setVisible(false)
	elseif self.warType == gKingdomClassType.roaringFlame then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.txtPyramid:setString(i18n("flames_dunes_text261"))
		self.btnHelp:setVisible(false)
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local itemIcon = publicRead.getIcon(roaringFlameWarRead.getConstValue("FLAMES_DUNES_CURE_ITEM", 872901))
		self.fields.btnHealNow:setCostIcon(itemIcon)
	elseif self.warType == gKingdomClassType.legendLord then
		self.isInLegend = true
	elseif self.warType == gKingdomClassType.simulatedDrill then
		self.isInWar = true
		self.isPyramidCDOut = true
		self.fields.txtPyramid:setString(i18n("simulated_drill_text_36"))
		self.btnHelp:setVisible(false)
	else
		self.txtRightTime:setVisible(false)
		self.txtHealNow:setVisible(true)
		self.fields.btnHealNow:setRightNowVisible(true)
	end
	self.fields.List_res:setVisible(not self.isInWar)
	self.fields.txtPyramid:setVisible(self.isInWar)
end
function HospitalViewPanel:initButtonTimeGold()
	self.fields.btnHeal:setCostTitle(SoraDConvertSecondToString(0))
	self.fields.btnHealNow:setCostTitle("0")
	self.fields.btnHeal:setTouchEnabled(false)
	self.fields.btnHealNow:setTouchEnabled(false)
	self.fields.btnHeal:setBtnBgGray(true)
	self.fields.btnHealNow:setBtnBgGray(true)
end
function HospitalViewPanel:btnAllSelectClickCallBack(button, type)
	SoraDPlaySound()
	self:selectedAll()
end
function HospitalViewPanel:btnHealClickCallBack(button, type)
	SoraDPlaySound()
	if self.isInWar then
		local _ENV, armyInfo = self.isInWar, self.isInWar
		for _, v in pairs(self.tableHospitalData) do
			if v.cur > 0 then
				armyInfo[v.id] = v.cur
			end
		end
		dump(armyInfo, "armyInfo")
		armyCtrl:cureWoundedArmyReq(armyInfo, OPERATE_MODE.NORMAL, self.warType)
		self:close()
	else
		self:resNeedToHeal()
	end
end
function HospitalViewPanel:resNeedToHeal(...)
	local _ENV, resNeed
	local isNeed = false
	local isNeedMeteor = false
	local isNeedGilded = false
	local isNeedCrystal = false
	for i, v in ipairs(self.fields.List_res:getChildren()) do
		local reDeta = v:returnDeta()
		reDeta = math.floor(reDeta)
		local resKey = self.resList[i]
		if reDeta < 0 then
			if resKey == gIDDef.METEOR_CRYSTAL then
				isNeedMeteor = true
			elseif resKey == gIDDef.GILDED_CURE_ESSENCE then
				isNeedGilded = true
			else
				isNeed = true
				_ENV = self.fields.List_res:getChildren()
				self.fields.List_res:getChildren().resid = resKey
				self.fields.List_res:getChildren().rescount = math.floor(-reDeta)
				table.insert(resNeed, self.fields.List_res:getChildren())
			end
		end
	end
	if self.warCrystalNeedCount > self:getResCrystalCount() then
		isNeedCrystal = true
	end
	local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
	if isNeed and proxy:checkNeedRes(resNeed) then
		uiManager:show("CommonQuicklyadd")
		return
	end
	if isNeedMeteor then
		SoraDShowMsgTip(i18n("Soldiers_armor_text_90"))
	elseif isNeedGilded then
		_ENV = i18n("Soldiers_armor_text_90")
		i18n("Soldiers_armor_text_90").item = include("publicRead").getName(gIDDef.GILDED_CURE_ESSENCE)
		SoraDShowMsgTip(i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")))
	elseif isNeedCrystal then
		worldMapWarDef.showMeteorCrystalTip()
	elseif isNeed then
		_ENV, _ENV = i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90"))
		i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")).resToGold = self:resToGold(resNeed)
		i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")).needResData, i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")).retCostRes = i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90"))
		i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")).viewType = RESBUYVIEW_TYPE.HEAL_ARMY
		i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")).handle = handler(self, self.resNeedToBuy)
		uiManager:show("buildCreateResBuy", i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")))
	else
		local _ENV, armyInfo = uiManager.show, uiManager.show
		for _, v in pairs(self.tableHospitalData) do
			if 0 < v.cur then
				armyInfo[v.id] = v.cur
			end
		end
		dump(armyInfo, "armyInfo")
		armyCtrl:cureWoundedArmyReq(armyInfo, OPERATE_MODE.NORMAL, self.warType)
		self:close()
	end
end
function HospitalViewPanel:resNeedToBuy()
	if self.tableHospitalData and next(self.tableHospitalData) ~= nil then
		local _ENV, armyInfo = next(self.tableHospitalData), next(self.tableHospitalData)
		for _, v in pairs(self.tableHospitalData) do
			if v.cur > 0 then
				armyInfo[v.id] = v.cur
			end
		end
		armyCtrl:cureWoundedArmyReq(armyInfo, OPERATE_MODE.GOLD_REPLACE, self.warType)
		self:close()
	end
end
function HospitalViewPanel:resToGold(resNeed)
	local goldNeed = 0
	for _, v in ipairs(resNeed) do
		goldNeed = goldNeed + serviceFunctions.resConvertToGold(v.resid, v.rescount)
	end
	return goldNeed
end
function HospitalViewPanel:btnHealNowClickCallBack(button, type)
	SoraDPlaySound()
	local sendMsg = function()
		local _ENV, armyInfo
		for _, v in pairs(self.tableHospitalData) do
			if v.cur > 0 then
				armyInfo[v.id] = v.cur
			end
		end
		dump(armyInfo, "armyInfo")
		armyCtrl:cureWoundedArmyReq(armyInfo, OPERATE_MODE.IMMEDIATELY, self.warType)
		self:removeFromParent()
	end
	if self.isInRadience then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.checkRadianceQuarryEnough(self.needGold) then
			SoraDShowMsgTip(i18n("brightWar_text_48"))
			return
		end
		if not worldMapDefine.isInRadiance() and not not worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("brightWar_text_156"))
			return
		end
		sendMsg()
	elseif self.warType and self.warType == gKingdomClassType.roaringFlame then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local itemID = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CURE_ITEM", 872901)
		local hasNum = backpackCtrl:getItemCount(itemID) or 0
		if hasNum < self.needGold then
			SoraDShowMsgTip(i18n("flames_dunes_text300"))
			return
		end
		sendMsg()
	else
		SoraDShowBuyBox(i18n("common_text_3398"), self.needGold, i18n("common_text_065"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType and SoraDEnoughGold(self.needGold) then
				sendMsg()
			end
		end)
	end
end
function HospitalViewPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	if self.warType == gKingdomClassType.legendLord then
		SoraDShowHelpMsgTip(i18n("legendaryking_text_96"))
	else
		SoraDShowHelpMsgTip(i18n("common_text_403"))
	end
end
function HospitalViewPanel:onClick_btnOrder()
	SoraDPlaySound()
	local curIndex = self.controllers.ctrlOrder:getSelectedIndex()
	self.controllers.ctrlOrder:setSelectedIndex(1 - curIndex)
	self:updateData(curIndex)
	armyCtrl:saveHospitalOrder(curIndex)
end
function HospitalViewPanel:onClickBtnCostHelp(button, type)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("legendaryking_text_81"))
end
function HospitalViewPanel:getResIdList(...)
	_UPVALUE5_ = nil
	;(nil)[1] = gIDDef.WOOD
	;(nil)[2] = gIDDef.FOOD
	;(nil)[3] = gIDDef.IRON
	;(nil)[4] = gIDDef.MITHRIL
	local (nil)[5], tableKey = gIDDef.CRYSTAL, nil
	if SoraDIsBrave8Level() and worldMapWarDef.checkCanUseMeteorCrystal() then
		table.insert(tableKey, gIDDef.METEOR_CRYSTAL)
	end
	if self:checkShowNodeLegendJJ() then
		local crystalID = worldMapWarDef.getWarCrystalID(self.warType)
		table.insert(tableKey, crystalID)
	end
	if SoraDIsGildedArmorOpen() then
		table.insert(tableKey, gIDDef.GILDED_CURE_ESSENCE)
	end
	return tableKey
end
function HospitalViewPanel:checkUnLockLegendCrystal(...)
	if not self:judgeIsUnlockBrave() then
		return false
	end
	if worldMapDefine.isInLegendLord() or self.warType == gKingdomClassType.legendLord then
		return commonCheck.LEGENDARY_CRYSTAL
	end
	if worldMapDefine.isInNebulaEmperor() then
		return true
	end
	return false
end
function HospitalViewPanel:checkShowNodeLegendJJ(...)
	if not self:checkUnLockLegendCrystal() then
		return false
	end
	if worldMapDefine.isInLegendLord() or self.warType == gKingdomClassType.legendLord then
		local constantRead = include("constantRead")
		if constantRead.checkLegendLordMeteorCrystal() then
			return true
		end
		if self:getResCrystalCount() > 0 then
			return true
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		if not worldMapWarDef.checkCanUseMeteorCrystal() then
			return true
		end
		if self:getResCrystalCount() > 0 then
			return true
		end
	end
	return false
end
function HospitalViewPanel:getResCrystalCount(...)
	local crystalID = worldMapWarDef.getWarCrystalID()
	local crystalCount = cityCtrl:getResCount(crystalID) or 0
	return crystalCount
end
return HospitalViewPanel

local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceDesRead = include("allianceDesRead")
local mapObjUtil = include("mapObjUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildMainPopPanel = class("AllianceBuildMainPopPanel", baseFguiPanel)
function AllianceBuildMainPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildMainPopPanel:ctor", self.viewName)
end
function AllianceBuildMainPopPanel:onInit()
	print("=======AllianceBuildMainPopPanel:onInit")
	self.Text_name = self.fields.Text_name
	self.Text_des = self.fields.Text_des
	self.Text_tip = self.fields.Text_tip
	self.Button_build = self.fields.Button_build
	self.Button_build:setTitleText(i18n("common_text_2132"))
	self.Button_build:addTouchEventListener(handler(self, self.onBtnClick))
end
function AllianceBuildMainPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildViewCommon"
	end
	return self._packageList
end
function AllianceBuildMainPopPanel:onShow()
	print("=======AllianceBuildMainPopPanel:onShow")
	local initData = self.param and self.param.initData
	if initData then
		self:initData(initData.buildClassID, initData.transferPoint)
	end
end
function AllianceBuildMainPopPanel:onHide()
	if self.transferPoint then
		mapObjUtil.removeLocalAllianceBuild(self.transferPoint.x, self.transferPoint.y, self.buildClassID, self.defineKey)
	end
end
function AllianceBuildMainPopPanel:initData(buildClassID, transferPoint)
	self.buildClassID = buildClassID
	self.transferPoint = transferPoint
	self.isEnough = true
	print("self.buildClassID====", self.buildClassID)
	self.Text_name:setString(i18n(allianceDesRead.getBuildName(self.buildClassID)))
	self.Text_des:setString(i18n(allianceDesRead.getBuildNewDes(self.buildClassID)))
	local curFlagNum = allianceTerritoryAPI:getAllianceFlagCount() + 1
	_ENV = allianceTerritoryAPI
	allianceTerritoryAPI.leagueID = allianceMgr:getOwnAid()
	allianceTerritoryAPI.leagueName = allianceMgr:getAllianceProperty("name")
	allianceTerritoryAPI.leagueAbbrName = allianceMgr:getAllianceProperty("abbr")
	allianceTerritoryAPI.leagueFlag = allianceMgr:getAllianceProperty("flag")
	allianceTerritoryAPI.status = gMapObjStateTypeDef.gMapObjStateTypeWorking
	allianceTerritoryAPI.isAct = false
	local allianceTerritoryAPI.sn, objData = gMaxSn, allianceTerritoryAPI
	if self.buildClassID == gAllianceBuilding.FLAG then
		_ENV = i18n(allianceDesRead.getBuildNewDes(self.buildClassID))
		i18n(allianceDesRead.getBuildNewDes(self.buildClassID)).count = curFlagNum
		self.Text_tip:setString(i18n("alliance_stronghold_text_030", i18n(allianceDesRead.getBuildNewDes(self.buildClassID))))
	else
		_ENV = i18n("alliance_stronghold_text_030", i18n(allianceDesRead.getBuildNewDes(self.buildClassID)))
		i18n("alliance_stronghold_text_030", i18n(allianceDesRead.getBuildNewDes(self.buildClassID))).var = i18n(allianceDesRead.getBuildName(self.buildClassID))
		self.Text_tip:setString(i18n("alliance_stronghold_text_108", i18n("alliance_stronghold_text_030", i18n(allianceDesRead.getBuildNewDes(self.buildClassID)))))
	end
	mapObjUtil.createLocalAllianceBuild(self.transferPoint.x, self.transferPoint.y, self.buildClassID, objData, self.defineKey)
	_ENV = self.transferPoint.x
	self.transferPoint.x.x = self.transferPoint.x + 1
	self.transferPoint.x.y = self.transferPoint.y + 1
	SoraDGotoWorldMapPoint(self.transferPoint.x)
	self.tableData = allianceTerritoryAPI:getTaxWarehouseData()
	dump(self.tableData, "self.tableData===")
	_ENV, _ENV = self.tableData, dump
	self.tableData.id = gIDDef.FOOD
	_ENV, dump[1], self.tableData.png = self.tableData, self.tableData, "icon_small_food.png"
	self.tableData.id = gIDDef.WOOD
	_ENV, dump[2], self.tableData.png = self.tableData, self.tableData, "icon_small_wood.png"
	self.tableData.id = gIDDef.IRON
	_ENV, dump[3], self.tableData.png = self.tableData, self.tableData, "icon_small_iron.png"
	self.tableData.id = gIDDef.MITHRIL
	_ENV, dump[4], self.tableData.png = self.tableData, self.tableData, "icon_small_silver.png"
	self.tableData.id = gIDDef.ALLIANCE_SCORE
	self.tableData.png = "icon_alliance_point.png"
	dump[5], self.tableData.scale = self.tableData, 0.6
	local costIDArray = dump
	self.costList = allianceBuildingltCtrl:getBuildingCostConfig()
	if self.buildClassID == gAllianceBuilding.FLAG then
		self.costCfg = self.costList[self.buildClassID][curFlagNum]
	else
		self.costCfg = self.costList[self.buildClassID][1]
	end
	local _ENV, costRes = self.costList[self.buildClassID][1], self.costList[self.buildClassID][1]
	for i = 1, #self.costCfg.costRes, 2 do
		costRes[self.costCfg.costRes[i]] = self.costCfg.costRes[i + 1]
	end
	dump(self.costCfg, "self.costCfg======")
	dump(costRes, "costRes======")
	for i, v in ipairs(costIDArray) do
		local Com_cost = self.fields["Com_cost" .. i]
		if not SoraDFIsRA() then
			Com_cost:fixChildrenPos()
		end
		local _fields = fguiHelper.get_fields(Com_cost)
		local icon_res = _fields.icon_res
		local Text_res = _fields.Text_res
		local icon_enough = _fields.icon_enough
		icon_res:setURL(v.png)
		icon_res:setScale(v.scale and v.scale or 1)
		if v.id == gIDDef.ALLIANCE_SCORE then
			Text_res:setString(SoraDConvertNumberWithUnit(self.costCfg.costBonus))
			local isEnough = allianceMgr:getAllianceProperty("bonus") >= self.costCfg.costBonus
			Text_res:setColor(isEnough and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
			icon_enough:setURL(isEnough and "icon_yes.png" or "icon_no.png")
		else
			local costNum = costRes[v.id] or 0
			Text_res:setString(SoraDConvertNumberWithUnit(costNum))
			Text_res:setColor(costNum <= self.tableData[v.id].count and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
			icon_enough:setURL(costNum <= self.tableData[v.id].count and "icon_yes.png" or "icon_no.png")
		end
		local Com_res = self.fields["Com_res" .. i]
		if not SoraDFIsRA() then
			Com_res:fixChildrenPos()
		end
		local _fields = fguiHelper.get_fields(Com_res)
		local icon_hres = _fields.icon
		local Text_hres = _fields.title
		icon_hres:setURL(v.png)
		icon_hres:setScale(v.scale and v.scale or 1)
		if v.id == gIDDef.ALLIANCE_SCORE then
			Text_hres:setString(SoraDConvertNumberWithUnit(allianceMgr:getAllianceProperty("bonus")))
			if self.isEnough then
				self.isEnough = allianceMgr:getAllianceProperty("bonus") >= self.costCfg.costBonus
			end
		else
			Text_hres:setString(SoraDConvertNumberWithUnit(math.floor(self.tableData[v.id].count)))
			if self.isEnough then
				self.isEnough = self.tableData[v.id].count >= (costRes[v.id] or 0)
			end
		end
	end
	self.Button_build:setBright(self.isEnough)
end
function AllianceBuildMainPopPanel:onBtnClick()
	SoraDPlaySound()
	print("执行建造=========", self.buildClassID)
	if not self.isEnough then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_015"))
		return
	end
	local allianceTerritoryAPI = include("allianceTerritoryAPI")
	local isHasPriPalace = false
	if allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PRIMARY_PALACE) then
		isHasPriPalace = true
	end
	if gAllianceBuilding.ALTAR == self.buildClassID and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not isHasPriPalace then
		SoraDShowMsgTip(i18n("common_text_3065"))
		return
	end
	if gAllianceBuilding.FLAG == self.buildClassID and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not isHasPriPalace then
		SoraDShowMsgTip(i18n("common_text_3065"))
		return
	end
	if gAllianceBuilding.PRIMARY_PALACE == self.buildClassID and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_025"))
		return
	end
	allianceTerritoryAPI:buildAllianceBuilding(self.buildClassID, self.transferPoint, gAllianceCreateBuildingCostType.BONUS)
	self:removeFromParent()
end
return AllianceBuildMainPopPanel

local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceDesRead = include("allianceDesRead")
local mapObjUtil = include("mapObjUtil")
local allianceBuildMainPopView = class("allianceBuildMainPopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildMainPopView")
	end
	return target
end)
function allianceBuildMainPopView:ctor()
	self:bindBtnClose()
	self.defineKey = "constom"
	SoraDGetChildByName(self, "Image_bbg"):setFillType(1)
	self.Node_name = SoraDGetChildByName(self, "Node_name")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name_ty = SoraDGetChildByName(self, "Text_name_ty")
	self.Text_jjxy = SoraDGetChildByName(self, "Text_jjxy")
	self.Text_jjxy:setString(i18n("alliance_text_53"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Button_build = SoraDGetChildByName(self, "Button_build")
	self.Button_build:setTitleText(i18n("common_text_2132"))
	self.Button_build:addTouchEventListener(handler(self, self.onBtnClick))
	self.Node_cost = SoraDGetChildByName(self, "Node_cost")
	self.Node_costRes = SoraDGetChildByName(self.Node_cost, "Node_res")
	self.Node_have = SoraDGetChildByName(self, "Node_have")
	self.Node_haveRes = SoraDGetChildByName(self.Node_have, "Node_res")
	self:suitView()
end
function allianceBuildMainPopView:suitView()
	self.nodeLeft = SoraDGetChildByName(self, "Center_Panel_left")
	self.nodeTop = SoraDGetChildByName(self, "Top_Panel")
	self.nodeTop:setContentSize(cc.size(640, display.height - (self.nodeLeft:getPositionY() + 0.5 * self.nodeLeft:getContentSize().height)))
	self.Bottom_Panel = SoraDGetChildByName(self, "Bottom_Panel")
	self.Bottom_Panel:setContentSize(cc.size(640, self.nodeLeft:getPositionY() - 0.5 * self.nodeLeft:getContentSize().height))
	self.Node_name:setPositionY(display.height < 960 and 720 or 520)
end
function allianceBuildMainPopView:onEnterPanel()
	_ENV = nil
	;(nil).isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI(nil)
end
function allianceBuildMainPopView:onExitPanel()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	mapObjUtil.removeLocalAllianceBuild(self.transferPoint.x, self.transferPoint.y, self.buildClassID, self.defineKey)
end
function allianceBuildMainPopView:initData(buildClassID, transferPoint)
	self.buildClassID = buildClassID
	self.transferPoint = transferPoint
	self.isEnough = true
	print("self.buildClassID====", self.buildClassID)
	self.Text_name:setString(i18n(allianceDesRead.getBuildName(self.buildClassID)))
	self.Text_name_ty:setString(i18n(allianceDesRead.getBuildName(self.buildClassID)))
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
	local offsetX = SoraDFIsRA() and 1 or 2
	local offsetY = SoraDFIsRA() and 2 or 1
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
	self.transferPoint.x.x = self.transferPoint.x + offsetX
	self.transferPoint.x.y = self.transferPoint.y + offsetY
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
	for k, v in ipairs(costIDArray) do
		local res, have
		if k == 1 then
			res = self.Node_costRes
			have = self.Node_haveRes
		else
			res = self.Node_costRes:clone()
			res:addTo(self.Node_cost)
			have = self.Node_haveRes:clone()
			have:setPosition(0, 0)
			have:addTo(self.Node_have)
		end
		res:setPosition(0, -(k - 1) * 50)
		local icon_res = SoraDGetChildByName(res, "icon_res")
		local Text_res = SoraDGetChildByName(res, "Text_res")
		local icon_enough = SoraDGetChildByName(res, "icon_enough")
		icon_res:setSpriteFrame(v.png)
		icon_res:setScale(v.scale and v.scale or 1)
		if v.id == gIDDef.ALLIANCE_SCORE then
			Text_res:setString(SoraDConvertNumberWithUnit(self.costCfg.costBonus))
			local isEnough = allianceMgr:getAllianceProperty("bonus") >= self.costCfg.costBonus
			Text_res:setColor(isEnough and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
			icon_enough:setSpriteFrame(isEnough and "icon_yes.png" or "icon_no.png")
		else
			local costNum = costRes[v.id] or 0
			Text_res:setString(SoraDConvertNumberWithUnit(costNum))
			Text_res:setColor(costNum <= self.tableData[v.id].count and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
			icon_enough:setSpriteFrame(costNum <= self.tableData[v.id].count and "icon_yes.png" or "icon_no.png")
		end
		local icon_hres = SoraDGetChildByName(have, "icon_res")
		local Text_hres = SoraDGetChildByName(have, "Text_res")
		icon_hres:setSpriteFrame(v.png)
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
		SoraDToCenter(have)
	end
	SoraDToCenter(self.Node_have, 100)
	self.Button_build:setBright(self.isEnough)
end
function allianceBuildMainPopView:onBtnClick(button, event)
	if event == ccui.TouchEventType.ended then
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
end
return allianceBuildMainPopView

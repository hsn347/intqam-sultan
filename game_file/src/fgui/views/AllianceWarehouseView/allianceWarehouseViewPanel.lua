local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceWarehouseViewPanel = class("allianceWarehouseViewPanel", baseFguiPanel)
function allianceWarehouseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceWarehouseViewPanel:ctor", self.viewName)
end
function allianceWarehouseViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceWarehouseViewPanel:onInit()
	print("=======allianceWarehouseViewPanel:onInit")
	self.tableUse, _ENV, self.tableSingle, _ENV, self.tableData, _ENV = print, print, print, print, print, print
	self.hasInit = false
	self.fields.Com_title:initData(i18n("common_text_3012"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Top_Size_Scroll")
	self.Node_content = SoraDGetChildByName(self.scroll, "Node_content")
	self.Node_lmzy = SoraDGetChildByName(self.Node_content, "Node_lmzy")
	self.Node_zysy = SoraDGetChildByName(self.Node_content, "Node_zysy")
	self.Node_uSingles = SoraDGetChildByName(self.Node_zysy, "Node_uSingles")
	self.Node_log = SoraDGetChildByName(self.Node_lmzy, "Node_log")
	self.Node_revenue = SoraDGetChildByName(self, "Node_revenue")
	self.Text_revenueVal = SoraDGetChildByName(self, "Text_revenueVal")
	self.labelRevenue = SoraDGetChildByName(self, "Text_revenue")
	self.Node_erritory = SoraDGetChildByName(self, "Node_erritory")
	self.Text_territoryVal = SoraDGetChildByName(self, "Text_territoryVal")
	self.labelTerritory = SoraDGetChildByName(self, "Text_territory")
	self.tableSingle = SoraDGetChildsArrayByName(self.Node_log, "Image_single_", 5, 1, false)
	self.Text_allianceRes = SoraDGetChildByName(self.Node_lmzy, "Text_allianceRes")
	self.Text_allianceUse = SoraDGetChildByName(self.Node_zysy, "Text_allianceUse")
	self.labelNeedTitle = SoraDGetChildByName(self.Node_lmzy, "Text_needTitle")
	self.labelCurTitle = SoraDGetChildByName(self.Node_lmzy, "Text_curTitle")
	self.Text_produce = SoraDGetChildByName(self.Node_lmzy, "Text_produce")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	self.btnLog:addClickEventListener(handler(self, self.btnClickCallBack))
	self.labelCurTitle:setString(i18n("common_text_3016"))
	self.labelNeedTitle:setString(i18n("common_text_3017"))
	self.btnLog:setTitleText(i18n("common_text_3019"))
	self.Text_allianceRes:setString(i18n("alliance_stronghold_text_002"))
	self.Text_allianceUse:setString(i18n("alliance_stronghold_text_004"))
	self.Text_produce:setString(i18n("alliance_stronghold_text_003"))
	_ENV = i18n("alliance_stronghold_text_003")
	i18n("alliance_stronghold_text_003").count = ""
	self.labelRevenue:setString(i18n("common_text_3014", i18n("alliance_stronghold_text_003")))
	self.Text_revenueVal:setString(tostring(allianceTerritoryAPI:getTaxPer() / 10) .. "%")
	SoraDToCenter(self.Node_revenue, 10)
	_ENV = allianceTerritoryAPI
	allianceTerritoryAPI.count = ""
	self.labelTerritory:setString(i18n("common_text_3013", allianceTerritoryAPI))
	self.Text_territoryVal:setString(string.formatnumberthousands(allianceTerritoryAPI:getScore()))
	SoraDToCenter(self.Node_erritory, 10)
	self.Node_allianceScore = SoraDGetChildByName(self.Node_lmzy, "Node_allianceScore")
	self.Text_score = SoraDGetChildByName(self.Node_allianceScore, "Text_score")
	self.Text_score:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	SoraDToCenter(self.Node_allianceScore)
	self.Image_use = SoraDGetChildByName(self, "Image_use")
	self.Text_noRecord = SoraDGetChildByName(self.Node_zysy, "Text_noRecord")
	self.Text_noRecord:setString(i18n("god_beast_text_16"))
	self.Button_shelp = SoraDGetChildByName(self.Node_lmzy, "Button_shelp")
	self.Button_shelp:addClickEventListener(handler(self, self.onBtnShelpClick))
	if worldMapDefine.isInWarForbid(true) then
		self.btnLog:setBright(false)
	end
	self.Node_lmzy:fixChildrenPos()
	self.Node_zysy:fixChildrenPos()
	self.Node_allianceScore:fixChildrenPos()
	self.fields.Top_Node:fixChildrenPos(true)
	allianceBuild:reqAllianceResCostRecord()
end
function allianceWarehouseViewPanel:onShow()
	print("=======allianceWarehouseViewPanel:onShow")
end
function allianceWarehouseViewPanel:initData()
	self.tableData = allianceTerritoryAPI:getTaxWarehouseData()
	allianceTerritoryAPI, allianceTerritoryAPI, self.resMineList = allianceBuild, allianceBuild:getResMineList(), allianceBuild:getResMineList()
	allianceTerritoryAPI, allianceBuild:getResMineList()[1], allianceBuild.resId = allianceBuild, allianceBuild, gIDDef.GOLD
	allianceBuild.resId = gIDDef.FOOD
	allianceTerritoryAPI, allianceBuild:getResMineList()[2], allianceBuild.mineId = allianceBuild, allianceBuild, 6001
	allianceBuild.resId = gIDDef.WOOD
	allianceTerritoryAPI, allianceBuild:getResMineList()[3], allianceBuild.mineId = allianceBuild, allianceBuild, 6002
	allianceBuild.resId = gIDDef.IRON
	allianceTerritoryAPI, allianceBuild:getResMineList()[4], allianceBuild.mineId = allianceBuild, allianceBuild, 6003
	allianceBuild.resId = gIDDef.MITHRIL
	allianceBuild:getResMineList()[5], allianceBuild.mineId = allianceBuild, 6004
	local tableResid = allianceBuild:getResMineList()
	for i, v in ipairs(tableResid) do
		local singleData = self.tableData[v.resId]
		if singleData and self.tableSingle[i] then
			local single = self.tableSingle[i]
			single:fixChildrenPos(true)
			single:setVisible(true)
			if not self.hasInit then
				local btn = SoraDGetChildByName(single, "Button_grant")
				btn:setTitleText(i18n("common_text_3018"))
				btn:setTag(v.resId)
				btn:addClickEventListener(handler(self, self.btnGrantClickCallBack))
				local isEnable = allianceDesRead.getOwnRank() >= gAllianceRank.R5
				btn:setTouchEnabled(isEnable)
				btn:setBright(isEnable)
				if worldMapDefine.isInWarForbid(true) then
					btn:setBright(false)
				end
			end
			local need = SoraDGetChildByName(single, "Text_need")
			local cur = SoraDGetChildByName(single, "Text_cur")
			local curMax = SoraDGetChildByName(single, "Text_curMax")
			local curPro = SoraDGetChildByName(single, "Text_pro")
			need:setString(SoraDConvertNumberWithUnit(singleData.allocateMin.min))
			curMax:setString("/" .. SoraDConvertNumberWithUnit(allianceTerritoryAPI:getTaxResourceLimit(v.resId)))
			cur:setString(SoraDConvertNumberWithUnit(math.floor(singleData.count)))
			cur:setColor(singleData.count >= singleData.allocateMin.min and cc.c3b(0, 90, 0) or cc.c3b(150, 30, 0))
			if v.mineId then
				local mineCfg = allianceBuildingltCtrl:getMineCfg(v.mineId)
				local count = self.resMineList[tostring(v.mineId)] and self.resMineList[tostring(v.mineId)].count or 0
				local outPut = mineCfg.outputNum * count
				allianceTerritoryAPI = SoraDConvertNumberWithUnit(math.floor(singleData.count))
				SoraDConvertNumberWithUnit(math.floor(singleData.count)).var = SoraDConvertNumberWithUnit(math.floor(outPut))
				curPro:setString(i18n("+%{var}/h", SoraDConvertNumberWithUnit(math.floor(singleData.count))))
				curPro:setVisible(true)
			else
				curPro:setVisible(false)
			end
		end
	end
	self.costRecord = allianceBuild:getCostRecord()
	self.Text_noRecord:setVisible(#self.costRecord == 0)
	local allianceTerritoryAPI, dateArray = self.Text_noRecord.setVisible, self.Text_noRecord.setVisible
	for k, v in ipairs(self.costRecord) do
		local dateStr = os.date("%Y-%m-%d", v.time)
		v.date = dateStr
		if k == 1 then
			table.insert(dateArray, v.date)
			v.isShowTime = true
		else
			v.isShowTime = not SoraDisInList(dateStr, dateArray)
			if not SoraDisInList(dateStr, dateArray) then
				table.insert(dateArray, v.date)
			end
		end
	end
	for k, v in ipairs(self.tableUse) do
		v:setVisible(false)
	end
	local totalH = 0
	for k, v in ipairs(self.costRecord) do
		if self.tableUse[k] then
			self.tableUse[k]:setVisible(true)
		else
			self.tableUse[k] = fgui.UIPackage:createObject("AllianceWarehouseView", "allianceWarehouseUseSingle")
			self.tableUse[k]:addTo(self.Node_uSingles)
		end
		self.tableUse[k]:initData(v)
		totalH = totalH + self.tableUse[k]:getSingleH()
	end
	self.Image_use:setSize(cc.size(600, math.max(100, totalH + 20)))
	local newH = math.max(self.scroll:getContentSize().height, 700 + math.max(totalH, 100))
	self.Node_content:setContentSize(cc.size(self.scroll:getContentSize().width, newH))
	self.Node_content:setPosition(self.scroll:getContentSize().width, newH / 2)
	local fH = totalH
	for k, v in ipairs(self.tableUse) do
		if v:isVisible() then
			local sH = v:getSingleH()
			v:setPosition(0, fH + sH - totalH)
			fH = fH + sH
		end
	end
	self.hasInit = true
end
function allianceWarehouseViewPanel:btnGrantClickCallBack(button, type)
	SoraDPlaySound()
	if worldMapDefine.isInWarForbid() then
		return
	end
	local tag = button:getTag()
	local singleData = self.tableData[tag]
	if singleData.allocateMin.min > singleData.count then
		SoraDShowMsgTip(i18n("common_text_3117"))
	else
		local isEnable = allianceDesRead.getOwnRank() >= gAllianceRank.R5
		if not isEnable then
			SoraDShowMsgTip(i18n("common_text_3118"))
		else
			allianceTerritoryAPI:allocateTaxes(tag)
		end
	end
end
function allianceWarehouseViewPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_WAREHOUSE)
end
function allianceWarehouseViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	if worldMapDefine.isInWarForbid() then
		return
	end
	uiManager:show("allianceWarehouseLogView")
end
function allianceWarehouseViewPanel:onBtnShelpClick(button, event)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_3015"))
end
return allianceWarehouseViewPanel

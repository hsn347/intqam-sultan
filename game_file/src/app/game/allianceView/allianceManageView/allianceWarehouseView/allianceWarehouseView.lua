local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local AllianceWarehouseView = class("allianceWarehouseView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarehouseView")
	end
	return target
end)
function AllianceWarehouseView:ctor()
	self.tableUse, _ENV, self.tableSingle, _ENV, self.tableData, _ENV = nil, nil, nil, nil, nil, nil
	self.hasInit = false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.scroll = SoraDGetChildByName(self, "Top_Size_Scroll")
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Node_revenue = SoraDGetChildByName(self, "Node_revenue")
	self.Text_revenueVal = SoraDGetChildByName(self, "Text_revenueVal")
	self.labelRevenue = SoraDGetChildByName(self, "Text_revenue")
	self.Node_erritory = SoraDGetChildByName(self, "Node_erritory")
	self.Text_territoryVal = SoraDGetChildByName(self, "Text_territoryVal")
	self.labelTerritory = SoraDGetChildByName(self, "Text_territory")
	self.tableSingle = SoraDGetChildsArrayByName(self, "Image_single_", 5, 1, false)
	self.Button_shelp = SoraDGetChildByName(self, "Button_shelp")
	self.Text_allianceRes = SoraDGetChildByName(self, "Text_allianceRes")
	self.Text_allianceUse = SoraDGetChildByName(self, "Text_allianceUse")
	self.labelNeedTitle = SoraDGetChildByName(self, "Text_needTitle")
	self.labelCurTitle = SoraDGetChildByName(self, "Text_curTitle")
	self.Text_produce = SoraDGetChildByName(self, "Text_produce")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	SoraDAutoSizeButtonText(self.btnLog)
	self.btnLog:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.Button_shelp:addTouchEventListener(handler(self, self.onBtnShelpClick))
	if worldMapDefine.isInWarForbid(true) then
		self.btnLog:setBright(false)
	end
	self.nodeTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClickCallBack))
	self.nodeTitle:setTitle(i18n("common_text_3012"))
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
	self.Node_allianceScore = SoraDGetChildByName(self, "Node_allianceScore")
	self.Text_score = SoraDGetChildByName(self, "Text_score")
	self.Text_score:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	SoraDToCenter(self.Node_allianceScore)
	self.Image_use = SoraDGetChildByName(self, "Image_use")
	self.Text_noRecord = SoraDGetChildByName(self, "Text_noRecord")
	self.Text_noRecord:setString(i18n("god_beast_text_16"))
	self.Node_zysy = SoraDGetChildByName(self.Node_content, "Node_zysy")
	self.Node_uSingles = SoraDGetChildByName(self.Node_zysy, "Node_uSingles")
	self.Center_Size_Tile_Image = SoraDGetChildByName(self, "Center_Size_Tile_Image")
	self.Center_Size_Tile_Image:setContentSize(cc.size(570, math.max(156, display.height - 800)))
	allianceBuild:reqAllianceResCostRecord()
end
function AllianceWarehouseView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GIVETAX_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COST_RECORD_BACK", handler(self, self.initData))
end
function AllianceWarehouseView:initData()
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
			single:setVisible(true)
			if not self.hasInit then
				local btn = SoraDGetChildByName(single, "Button_grant")
				btn:setTitleText(i18n("common_text_3018"))
				btn:setTag(v.resId)
				btn:addTouchEventListener(handler(self, self.btnGrantClickCallBack))
				btn:setTouchEnabled(allianceDesRead.checkRank(gAllianceRank.R5))
				btn:setBright(allianceDesRead.checkRank(gAllianceRank.R5))
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
			if SoraDFIsRA() then
				cur:setPositionX(curMax:getPositionX() - curMax:getContentSize().width)
			else
				curMax:setPositionX(cur:getPositionX() + cur:getContentSize().width)
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
			self.tableUse[k] = include("allianceWarehouseUseSingle").new()
			self.tableUse[k]:addTo(self.Node_uSingles)
		end
		self.tableUse[k]:initData(v)
		totalH = totalH + self.tableUse[k]:getSingleH()
	end
	self.Image_use:setContentSize(cc.size(600, math.max(100, totalH + 20)))
	local newH = math.max(self.scroll:getContentSize().height, 700 + math.max(totalH, 100))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, newH))
	self.Node_content:setPositionY(newH)
	local fH = totalH
	for k, v in ipairs(self.tableUse) do
		if v:isVisible() then
			local sH = v:getSingleH()
			v:setPosition(-281, fH - sH - totalH)
			fH = fH - sH
		end
	end
	self.hasInit = true
end
function AllianceWarehouseView:btnGrantClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		local tag = button:getTag()
		local singleData = self.tableData[tag]
		if singleData.allocateMin.min > singleData.count then
			SoraDShowMsgTip(i18n("common_text_3117"))
		elseif allianceDesRead.checkRank(gAllianceRank.R5, true, i18n("common_text_3118")) then
			allianceTerritoryAPI:allocateTaxes(tag)
		end
	end
end
function AllianceWarehouseView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_WAREHOUSE)
	end
end
function AllianceWarehouseView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		SoraDCreatePanel("allianceWarehouseLogView"):show()
	end
end
function AllianceWarehouseView:onBtnShelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_3015"))
	end
end
return AllianceWarehouseView

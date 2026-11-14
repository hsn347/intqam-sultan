local allianceBuild = SoraDGetCtrl("allianceBuild")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildViewPanel = class("AllianceBuildViewPanel", baseFguiPanel)
_ENV = "AllianceBuildViewPanel"
;("AllianceBuildViewPanel")[gAllianceBuildUIListType.MAIN_BUILD] = false
;("AllianceBuildViewPanel")[gAllianceBuildUIListType.RESOURCE] = false
;("AllianceBuildViewPanel")[gAllianceBuildUIListType.FLAG] = false
;("AllianceBuildViewPanel")[gAllianceBuildUIListType.STATE] = false
local ("AllianceBuildViewPanel")[gAllianceBuildUIListType.RECYCLE], tableAllianceBuildListState = false, "AllianceBuildViewPanel"
function AllianceBuildViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildViewPanel:ctor", self.viewName)
	self.tableBuildList, _ENV, self.tableSpare, _ENV, self.tableSingle, _ENV, self.isHideCurrentSceneView = print, print, print, print, print, print, true
	self.tableCurShow = nil
end
function AllianceBuildViewPanel:onInit()
	print("=======AllianceBuildViewPanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_stronghold_text_001"), handler(self, self.onClickClose), handler(self, self.btnClickCallBack))
	self.fields.Com_bonus:setString(i18n("alliance_stronghold_text_006"))
	local Button_tip = self.fields.Com_bonus:getChild("Button_help")
	Button_tip:addTouchEventListener(handler(self, self.onBtnTipClick))
	self.fields.Button_claim:setTitleText(i18n("common_text_1146"))
	self.fields.Button_claim:addTouchEventListener(handler(self, self.onBtnClaimClick))
	self.fields.btn_mail:addTouchEventListener(handler(self, self.btnClickMail))
	_ENV, _ENV, self.scroll = self.fields.btn_mail, self.fields.ScrollView_build, self.fields.ScrollView_build
	self.fields.btn_mail.id = gIDDef.FOOD
	_ENV, self.fields.ScrollView_build[1], self.fields.btn_mail.png = self.fields.btn_mail, self.fields.btn_mail, "icon_small_food.png"
	self.fields.btn_mail.id = gIDDef.WOOD
	_ENV, self.fields.ScrollView_build[2], self.fields.btn_mail.png = self.fields.btn_mail, self.fields.btn_mail, "icon_small_wood.png"
	self.fields.btn_mail.id = gIDDef.IRON
	_ENV, self.fields.ScrollView_build[3], self.fields.btn_mail.png = self.fields.btn_mail, self.fields.btn_mail, "icon_small_iron.png"
	self.fields.btn_mail.id = gIDDef.MITHRIL
	self.resComs, _ENV, self.fields.ScrollView_build[4], self.fields.btn_mail.png = self.fields.btn_mail, self.fields.btn_mail, self.fields.btn_mail, "icon_small_silver.png"
	local costIDArray = self.fields.ScrollView_build
	for __, v in ipairs(costIDArray) do
		local obj = self.fields["res_" .. v.id]
		if obj then
			self.resComs[v.id] = obj
		end
	end
	if not SoraDFIsRA() then
		self.fields.Button_claim:fixPos()
		for __, v in pairs(self.resComs) do
			v:fixPos()
			v:fixChildrenPos()
		end
	end
end
function AllianceBuildViewPanel:onShow()
	print("=======AllianceBuildViewPanel:onShow")
	allianceBuild:reqAllianceResMineProfit()
	if allianceTerritoryAPI:checkHasRecycleBuilding() then
		for k, v in pairs(tableAllianceBuildListState) do
			tableAllianceBuildListState[k] = false
		end
		tableAllianceBuildListState[gAllianceBuildUIListType.RECYCLE] = true
	end
	local setBuildPos = self.param and self.param.setBuildPos
	if setBuildPos then
		self:setBuildPos(setBuildPos.tilePoint, setBuildPos.buildClass)
	end
end
function AllianceBuildViewPanel:initClaimBtn()
	local total = allianceBuild:getResTotal()
	self.fields.Button_claim:setEnabled(0 < total)
end
function AllianceBuildViewPanel:initRes()
	local resInfo = allianceBuild:getRes()
	for resID, obj in pairs(self.resComs) do
		local resNum = resInfo[tostring(resID)] or 0
		obj:setString(SoraDConvertNumberWithUnit(resNum))
	end
	self:initClaimBtn()
end
function AllianceBuildViewPanel:initMailBtn()
	local status = allianceGuideCtrl:getGuideStauts()
	print("按钮状态", status)
	if status == 0 or status == 1 then
		self.controllers.c_mail:setSelectedIndex(1)
	else
		self.controllers.c_mail:setSelectedIndex(0)
	end
	local img = status == 2 and "btn_mail_read_new01.png" or "btn_mail_unread_new01.png"
	local red = self.fields.Image_red
	if red then
		red:setVisible(img == "btn_mail_unread_new01.png")
	end
	self.fields.btn_mail:setIcon(img)
	allianceGuideCtrl = img
	img.byUID = true
	local tab = SoraDConfigGet("Game:allianceGuideCtrl:isEnterFirsr~table", img)
	dump(tab, "按钮状态")
	local isHas = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE)
	dump(isHas)
	if next(tab) == nil then
		return
	else
		local memberMgr = SoraDGetCtrl("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		local iscan = allianceBuildingltCtrl:canRankMemberCreate(1, ownRank, 1)
		local canBuild = iscan or ownmember.minfo.official == gAllianceOfficial.LEADER
		local isFirsted = tab.isFirst
		local ishasFirsted = tab.ishasFirst
		local isnotFirsted = tab.isnotFirst
		local isGeted = tab.isGet
		if tab.isFirst == false then
			local list = self.tableSingle[1]
			if list and not list.isLaunched then
				list:btnClickCallBack(list.layerTouch, ccui.TouchEventType.ended)
			end
			allianceGuideCtrl = list.layerTouch
			list.layerTouch.isFirst = true
			list.layerTouch.ishasFirst = ishasFirsted
			list.layerTouch.isnotFirst = isnotFirsted
			allianceGuideCtrl, list.layerTouch.isGet = ccui.TouchEventType.ended, isGeted
			ccui.TouchEventType.ended.byUID = true
			SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", list.layerTouch, ccui.TouchEventType.ended)
			allianceGuideCtrl = "Game:allianceGuideCtrl:isEnterFirsr~table"
			;("Game:allianceGuideCtrl:isEnterFirsr~table").msg = "MESSAGE_GREEN_POINT_UPDATE"
			SoraDSendMessage("Game:allianceGuideCtrl:isEnterFirsr~table")
			isFirsted = true
		end
		if status == 1 and tab.isGet == false then
			print("领取奖励", 2)
			local panel = SoraDCreatePanel("AllianceBuildingGuideView")
			panel:show()
			panel:initData(3)
			allianceGuideCtrl = 3
			;(3).isFirst = isFirsted
			;(3).ishasFirst = ishasFirsted
			;(3).isnotFirst = isnotFirsted
			allianceGuideCtrl, (3).isGet = ccui.TouchEventType.ended, true
			ccui.TouchEventType.ended.byUID = true
			SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", 3, ccui.TouchEventType.ended)
		end
		if isHas then
			if tab.ishasFirst == false and status == 0 then
				print("迁城引导", 2)
				local panel = SoraDCreatePanel("AllianceBuildingGuideView")
				panel:show()
				panel:initData(2)
				allianceGuideCtrl = 2
				;(2).isFirst = isFirsted
				;(2).ishasFirst = true
				;(2).isnotFirst = isnotFirsted
				allianceGuideCtrl, (2).isGet = ccui.TouchEventType.ended, isGeted
				ccui.TouchEventType.ended.byUID = true
				SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", 2, ccui.TouchEventType.ended)
			end
		elseif tab.isnotFirst == false and status == 0 and canBuild then
			print("建造引导", 1)
			local panel = SoraDCreatePanel("AllianceBuildingGuideView")
			panel:show()
			panel:initData(1)
			allianceGuideCtrl = 1
			;(1).isFirst = isFirsted
			;(1).ishasFirst = ishasFirsted
			;(1).isnotFirst = true
			allianceGuideCtrl, (1).isGet = ccui.TouchEventType.ended, isGeted
			ccui.TouchEventType.ended.byUID = true
			SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", 1, ccui.TouchEventType.ended)
		end
	end
end
function AllianceBuildViewPanel:initData()
	self:updateData()
	self:initRes()
end
function AllianceBuildViewPanel:updateData()
	self.tableBuildList[gAllianceBuildUIListType.MAIN_BUILD] = allianceTerritoryAPI:getAllianceMainBuildingInfo()
	self.tableBuildList[gAllianceBuildUIListType.RESOURCE] = allianceBuild:getBuildingList()
	_ENV = allianceBuild:getBuildingList()
	self.tableBuildList[gAllianceBuildUIListType.FLAG], allianceBuild:getBuildingList()[1] = allianceBuild:getBuildingList(), allianceTerritoryAPI:getAllianceFlagInfo()
	_ENV = allianceBuild:getBuildingList()
	self.tableBuildList[gAllianceBuildUIListType.STATE], allianceBuild:getBuildingList()[1] = allianceBuild:getBuildingList(), allianceTerritoryAPI:getBurningBuildingList()
	if allianceTerritoryAPI:checkHasRecycleBuilding() then
		self.tableBuildList[gAllianceBuildUIListType.RECYCLE] = allianceTerritoryAPI:getRecycleBuildings()
	end
	self:initScroll()
	self:updateScrollView()
end
function AllianceBuildViewPanel:initScroll()
	_UPVALUE4_, self.tableCurShow = nil, nil
	;(nil)[1] = gAllianceBuildUIListType.MAIN_BUILD
	;(nil)[2] = gAllianceBuildUIListType.RESOURCE
	;(nil)[3] = gAllianceBuildUIListType.FLAG
	local (nil)[4], tableBuildListKey = gAllianceBuildUIListType.STATE, nil
	if allianceTerritoryAPI:checkHasRecycleBuilding() then
		table.insert(tableBuildListKey, 1, gAllianceBuildUIListType.RECYCLE)
	elseif self.tableBuildList[gAllianceBuildUIListType.RECYCLE] then
		self.tableBuildList[gAllianceBuildUIListType.RECYCLE] = nil
		local single = self.tableSingle[1]
		single:removeBuild()
		single:removeFromParent()
		table.remove(self.tableSingle, 1)
	end
	local curShowTable
	for i, v in ipairs(tableBuildListKey) do
		local buildData = self.tableBuildList[v]
		local single = self.tableSingle[i]
		if buildData then
			local isInit = false
			if single == nil then
				isInit = true
				single = fgui.UIPackage:createObject("AllianceBuildView", "allianceBuildListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
				table.insert(self.tableSingle, single)
			end
			single:initData(tonumber(v), buildData, self.tableSpare)
			if curShowTable == nil and isInit and single.isHaveBuidingInConstruction then
				curShowTable = i
			elseif curShowTable == nil and tableAllianceBuildListState[tonumber(v)] then
				self.tableCurShow = i
			end
		elseif single ~= nil then
			single:removeBuild()
			single:removeFromParent()
			table.remove(self.tableSingle, i)
		end
	end
	self.tableCurShow = curShowTable == nil and self.tableCurShow or curShowTable
	for i, v in ipairs(tableBuildListKey) do
		local buildData = self.tableBuildList[v]
		local single = self.tableSingle[i]
		single:setState(i == self.tableCurShow)
	end
end
function AllianceBuildViewPanel:updateScrollView(buildClass, state)
	print("==AllianceBuildViewPanel:updateScrollView==", buildClass, state)
	gModuleMgr.sharedMgr("mildGuideManager"):clean()
	if buildClass ~= nil and state ~= nil then
		for k, v in pairs(tableAllianceBuildListState) do
			tableAllianceBuildListState[k] = false
		end
		tableAllianceBuildListState[tonumber(buildClass)] = state
		if self.tableCurShow then
			self.tableSingle[self.tableCurShow]:setState(false)
			self.tableCurShow = nil
		end
	end
	local scrollInnerNewH = 0
	for index = 1, #self.tableSingle do
		local single = self.tableSingle[index]
		single:setPosition(cc.p(0, scrollInnerNewH))
		scrollInnerNewH = scrollInnerNewH + single:getSingleH()
		if single:getLaunched() then
			self.tableCurShow = index
		end
	end
	self:updateAllScrollSingle(true)
end
function AllianceBuildViewPanel:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function AllianceBuildViewPanel:btnClickCallBack()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_BUILD)
end
function AllianceBuildViewPanel:onBtnTipClick()
	SoraDPlaySound()
	_ENV = "alliance_stronghold_text_007"
	;("alliance_stronghold_text_007").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("alliance_stronghold_text_007"), "alliance_stronghold_text_007")
end
function AllianceBuildViewPanel:onBtnClaimClick()
	SoraDPlaySound()
	print("领取奖励==========")
	allianceBuild:reqGetAllianceResMineProfit()
end
function AllianceBuildViewPanel:btnClickMail()
	SoraDPlaySound()
	local isHas = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE)
	dump("打开领地迁城引导", isHas)
	if allianceGuideCtrl:getGuideStauts() == 3 then
		return
	end
	local panel = SoraDCreatePanel("AllianceBuildingGuideView")
	panel:show()
	panel:initData(isHas and 2 or 1)
end
function AllianceBuildViewPanel:setBuildPos(pos, buildClass)
	if buildClass then
		for k, v in pairs(tableAllianceBuildListState) do
			tableAllianceBuildListState[k] = false
		end
		tableAllianceBuildListState[tonumber(buildClass)] = true
		self:updateData()
	end
	self.proxy:setBuildPos(pos)
end
function AllianceBuildViewPanel:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
		return
	end
	self:initMailBtn()
end
function AllianceBuildViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "build" then
		local single, btn
		local list = self.tableSingle[1]
		if list and not list.isLaunched then
			list:btnClickCallBack(list.layerTouch, ccui.TouchEventType.ended)
		end
		if not list or not list.tableSingle then
			_ENV = list.tableSingle
		end
		for k, v in ipairs(list.tableSingle) do
			print(v.data.bid)
			if v.data.bid == 1 then
				single = v.point
			end
		end
		if single then
			btn = single.btnBuild
		end
		return btn
	end
	return self.fields[itemName]
end
return AllianceBuildViewPanel

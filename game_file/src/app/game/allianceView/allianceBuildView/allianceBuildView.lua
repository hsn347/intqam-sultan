local gametop = gModuleMgr.getObject("gametop")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
_ENV = "allianceTerritoryAPI"
;("allianceTerritoryAPI")[gAllianceBuildUIListType.MAIN_BUILD] = false
;("allianceTerritoryAPI")[gAllianceBuildUIListType.RESOURCE] = false
;("allianceTerritoryAPI")[gAllianceBuildUIListType.FLAG] = false
;("allianceTerritoryAPI")[gAllianceBuildUIListType.STATE] = false
local gAllianceBuildUIListType.RECYCLE.buildMovePos, _ENV, _ENV, ("allianceTerritoryAPI")[gAllianceBuildUIListType.RECYCLE], tableAllianceBuildListState = nil, nil, gAllianceBuildUIListType.RECYCLE, false, "allianceTerritoryAPI"
local tableParam = gAllianceBuildUIListType.RECYCLE
local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local AllianceBuildView = class("allianceBuildView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildView")
	end
	return target
end)
function AllianceBuildView:ctor()
	self.tableBuildList, _ENV, self.tableSpare, _ENV, self.tableSingle, _ENV = nil, nil, nil, nil, nil, nil
	self.resArray, _ENV, self.tableCurShow = nil, nil, nil
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_build")
	self.btn_mail = SoraDGetChildByName(self, "btn_mail")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("alliance_stronghold_text_001"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.Button_Node = SoraDGetChildByName(self, "Button_Node")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	if self.btnHelp then
		self.btnHelp:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	if self.btn_mail then
		self.btn_mail:addTouchEventListener(handler(self, self.btnClickMail))
	end
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("alliance_stronghold_text_006"))
	self.Button_tip = SoraDGetChildByName(self, "Button_tip")
	self.Button_tip:addTouchEventListener(handler(self, self.onBtnTipClick))
	SoraDToCenter(self.Node_tip)
	self.Button_claim = SoraDGetChildByName(self, "Button_claim")
	self.Button_claim:setTitleText(i18n("common_text_1146"))
	self.Button_claim:addTouchEventListener(handler(self, self.onBtnClaimClick))
	self.Node_cost = SoraDGetChildByName(self, "Node_cost")
	self.Node_res = SoraDGetChildByName(self, "Node_res")
	self.resArray[1] = self.Node_res
	allianceBuild:reqAllianceResMineProfit()
	if allianceTerritoryAPI:checkHasRecycleBuilding() then
		for k, v in pairs(tableAllianceBuildListState) do
			tableAllianceBuildListState[k] = false
		end
		tableAllianceBuildListState[gAllianceBuildUIListType.RECYCLE] = true
	end
end
function AllianceBuildView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GUIDE_UPDATE", handler(self, self.initMailBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RES_MINE_PROFIT_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_RES_MINE_PROFIT_BACK", handler(self, self.initRes))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.initData))
end
function AllianceBuildView:initClaimBtn()
	local total = allianceBuild:getResTotal()
	self.Button_claim:setBright(0 < total)
	self.Button_claim:setEnabled(0 < total)
end
function AllianceBuildView:initRes()
	local resInfo = allianceBuild:getRes()
	allianceBuild, allianceBuild = nil, allianceBuild
	;(nil).id = gIDDef.FOOD
	allianceBuild, allianceBuild[1], (nil).png = nil, nil, "icon_small_food.png"
	;(nil).id = gIDDef.WOOD
	allianceBuild, allianceBuild[2], (nil).png = nil, nil, "icon_small_wood.png"
	;(nil).id = gIDDef.IRON
	allianceBuild, allianceBuild[3], (nil).png = nil, nil, "icon_small_iron.png"
	;(nil).id = gIDDef.MITHRIL
	allianceBuild[4], (nil).png = nil, "icon_small_silver.png"
	local costIDArray = allianceBuild
	for k, v in ipairs(self.resArray) do
		v:setVisible(false)
	end
	for k, v in ipairs(costIDArray) do
		if self.resArray[k] then
			self.resArray[k]:setVisible(true)
		else
			self.resArray[k] = self.Node_res:clone()
			self.resArray[k]:setPosition(0, 0)
			self.resArray[k]:addTo(self.Node_cost)
		end
		local icon_res = SoraDGetChildByName(self.resArray[k], "icon_res")
		local Text_res = SoraDGetChildByName(self.resArray[k], "Text_res")
		icon_res:setSpriteFrame(v.png)
		local resNum = resInfo[tostring(v.id)] or 0
		Text_res:setString(SoraDConvertNumberWithUnit(resNum))
		SoraDToCenter(self.resArray[k])
	end
	SoraDToCenter(self.Node_cost, 120)
	self:initClaimBtn()
end
function AllianceBuildView:initMailBtn()
	local status = allianceGuideCtrl:getGuideStauts()
	print("按钮状态", status)
	self.Button_Node:setVisible(status == 0 or status == 1)
	local img = status == 2 and "btn_mail_read_new01.png" or "btn_mail_unread_new01.png"
	local red = SoraDGetChildByName(self.btn_mail, "red")
	if img == "btn_mail_unread_new01.png" and red == nil then
		local red = display.newSprite("#frame_mail_round_01.png")
		red:setName("red")
		red:setScale(0.3, 0.3)
		red:setPosition(cc.p(50, 30))
		red:addTo(self.btn_mail)
	end
	if red then
		red:setVisible(img == "btn_mail_unread_new01.png")
	end
	self.btn_mail:loadTextures(img, img, img, ccui.TextureResType.plistType)
	self.btn_mail:setContentSize(cc.size(52, 48))
	allianceGuideCtrl = cc.size(52, 48)
	cc.size(52, 48).byUID = true
	local tab = SoraDConfigGet("Game:allianceGuideCtrl:isEnterFirsr~table", cc.size(52, 48))
	dump(tab, "按钮状态")
	local isHas = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE)
	dump(isHas)
	if next(tab) == nil then
		return
	else
		local memberMgr = gametop.playertop_:getModule("memberMgr")
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
function AllianceBuildView:initData()
	self:updateData()
	self:initRes()
end
function AllianceBuildView:updateData()
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
function AllianceBuildView:initScroll()
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
				single = SoraDCreatePanel("allianceBuildListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
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
function AllianceBuildView:updateScrollView(buildClass, state)
	print("==AllianceBuildView:updateScrollView==", buildClass, state)
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
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	local openY
	for i = 1, #self.tableSingle do
		local index = #self.tableSingle - i + 1
		local single = self.tableSingle[index]
		scrollInnerNewH = scrollInnerNewH + single:getSingleH()
		single:setPosition(cc.p(320, scrollInnerNewH))
		if single:getLaunched() then
			self.tableCurShow = index
			openY = single:getPositionY()
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			v:setPositionY(v:getPositionY() + upto)
			if i == self.tableCurShow then
				openY = v:getPositionY()
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	if openY then
		openY = self.scroll:getContentSize().height - openY
		offsetY = math.min(offsetY, openY)
	end
	offsetY = math.max(offsetY, -(scrollInnerNewH - self.scroll:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function AllianceBuildView:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function AllianceBuildView:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
function AllianceBuildView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_BUILD)
	end
end
function AllianceBuildView:onBtnTipClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "alliance_stronghold_text_007"
		;("alliance_stronghold_text_007").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("alliance_stronghold_text_007"), "alliance_stronghold_text_007")
	end
end
function AllianceBuildView:onBtnClaimClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("领取奖励==========")
		allianceBuild:reqGetAllianceResMineProfit()
	end
end
function AllianceBuildView:btnClickMail(button, type)
	if type == ccui.TouchEventType.ended then
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
end
function AllianceBuildView:setBuildPos(pos, buildClass)
	if buildClass then
		for k, v in pairs(tableAllianceBuildListState) do
			tableAllianceBuildListState[k] = false
		end
		tableAllianceBuildListState[tonumber(buildClass)] = true
		self:updateData()
	end
	tableParam.buildMovePos = pos
end
function AllianceBuildView.getParam()
	return tableParam
end
function AllianceBuildView:onExitPanel()
	tableParam.buildMovePos, tableParam = nil, nil
end
function AllianceBuildView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
		return
	end
	self:initMailBtn()
end
function AllianceBuildView:gameGuide_getTarget(itemName, parameters)
	if itemName == "build" then
		local single, btn
		local list = self.tableSingle[1]
		if list and not list.isLaunched then
			list:btnClickCallBack(list.layerTouch, ccui.TouchEventType.ended)
		end
		dump(list.tableSingle, "gameGuide_getTarget")
		for k, v in ipairs(list.tableSingle) do
			print(v.data.bid)
			if v.data.bid == 1 then
				single = v.point
			end
		end
		if single then
			btn = SoraDGetChildByName(single, "Button_build")
		end
		return btn
	end
	return SoraDGetChildByName(self, itemName)
end
return AllianceBuildView

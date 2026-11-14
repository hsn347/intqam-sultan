local publicRead = include("publicRead")
local manorTechRead = include("manorTechRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorTechDetailPanel = class("ManorTechDetailPanel", baseFguiPanel)
function ManorTechDetailPanel:ctor(...)
	self.isLRU = true
	ManorTechDetailPanel.super.ctor(self, ...)
	print("ManorTechDetailPanel:ctor", self.viewName)
end
function ManorTechDetailPanel:onInit()
	print("=======ManorTechDetailPanel:onInit")
	self.techType = "manor"
	self.queueType = gQueueTypeDef.garden_technology
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Label_title:setString(i18n("garden_text_14"))
	self.fields.Button_upLv:setTitle(i18n("common_text_062"))
	self.fields.Button_upLv:setCostIcon("icon_hourglass.png")
	self.fields.Button_upLv:addClickListener(handler(self, self.onClick_Button_upLv))
	self.fields.Button_upGold:setTitle(i18n("common_text_335"))
	self.fields.Button_upGold:addClickListener(handler(self, self.onClick_Button_upGold))
	self.fields.Button_upGolding:setTitle(i18n("common_text_335"))
	self.fields.Button_upGolding:addClickListener(handler(self, self.onClick_Button_upGold))
	self.fields.Button_speedUp:setTitle(i18n("common_text_018"))
	self.fields.Button_speedUp:addClickListener(handler(self, self.onClick_Button_speedUp))
	self.fields.Button_detail:addClickListener(handler(self, self.onClick_Button_detail))
	self.fields.Text_leftT:setString(i18n("journey_text_1001"))
	self.fields.Text_max:setString(i18n("flames_dunes_text82"))
	self.fields.Bar:fixPos()
	self.fields.Text_leftT:fixPos()
	self.fields.Button_speedUp:fixPos()
	self.fields.Button_upLv:fixPos()
	self.fields.Button_upGold:fixPos()
	self.fields.Button_upGolding:fixPos()
end
function ManorTechDetailPanel:endShow()
	print("=======ManorTechDetailPanel:endShow")
	self.techID = self.param.techID
	local cfg = manorTechRead.getTechShowCfg(self.techID)
	self.fields.Panel_bg:setString(i18n(cfg.techName))
	self:updateView()
end
function ManorTechDetailPanel:updateGold(leftTime)
	local cost = serviceFunctions.timeConvertToGold(leftTime, false)
	self.fields.Button_upGolding:setCostNum(string.formatnumberthousands(cost))
	self.fields.Button_upGolding:setIsEnough(cost <= SoraDGetGold())
end
function ManorTechDetailPanel:updateView()
	local index = 0
	self.tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	self.tableSingleDetails = technologyCtrl:getTechnologyDetails(self.techID, self.tableSingleData.currentLevel)
	self.fields.tech:initData(self.techID)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Panel_bg:getController("size"):setSelectedIndex(1)
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Panel_bg:getController("size"):setSelectedIndex(1)
		local queue = queueCtrl:queryQueue(self.queueType)
		local leftTime = queue.timerNode.timer:getRemainTime()
		self.fields.Bar:setTimeUpdateFun(function(time)
			self:updateGold(time)
		end)
		self.fields.Bar:setTime(leftTime, queue.totaltime, true)
		self:updateGold(leftTime)
		local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.TECH)
		self.fields.Button_speedUp:setVisible(0 < #itemList)
		if #itemList <= 0 then
			self.fields.Button_upGolding:setPositionX(self.view:getWidth() / 2)
		else
			self.fields.Button_upGolding:setPositionX(SoraDFIsRA() and self.view:getWidth() / 2 + 120 or self.view:getWidth() / 2 - 120)
			self.fields.Button_speedUp:setPositionX(not SoraDFIsRA() and self.view:getWidth() / 2 + 120 or self.view:getWidth() / 2 - 120)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Panel_bg:getController("size"):setSelectedIndex(4)
		self:initScroll()
		local basetime = self.tableSingleDetails.technologyTime
		local finaltime = technologyCtrl:getResearchTime(basetime, self.queueType)
		self.fields.Button_upLv:setCostNum(SoraDConvertSecondToString(finaltime))
		self.fields.Button_upGold:setCostNum(string.formatnumberthousands(self.tableSingleDetails.cost))
		self.fields.Button_upGold:setIsEnough(SoraDGetGold() >= self.tableSingleDetails.cost)
		self:updateBtnState()
	end
end
function ManorTechDetailPanel:updateBtnState()
	local isOpened = true
	self.cantStudying = TECHNOLOGY_SINGLE_TYPE.NONE
	self.needResID = nil
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	if self.tableSingleDetails.starbuild then
		for i, v in ipairs(self.tableSingleDetails.starbuild) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	if self.tableSingleDetails.tech then
		for i, v in ipairs(self.tableSingleDetails.tech) do
			if not v.isContentmented then
				isOpened = false
				self.cantStudying = TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY
				break
			end
		end
	end
	if self.tableSingleDetails.resources then
		for i, v in ipairs(self.tableSingleDetails.resources) do
			if not v.isContentmented then
				self.cantStudying = TECHNOLOGY_SINGLE_TYPE.RES
				self.needResID = v.rid
				break
			end
		end
	end
	if self.tableSingleDetails.wartool then
		for i, v in ipairs(self.tableSingleDetails.wartool) do
			if not v.isContentmented then
				isOpened = false
				self.cantStudying = TECHNOLOGY_SINGLE_TYPE.WAR
				self.needResID = v.rid
				break
			end
		end
	end
	if queueCtrl:queryQueue(self.queueType) then
		self.cantStudying = TECHNOLOGY_SINGLE_TYPE.QUEUE
	end
	self.fields.Button_upGold:setEnabled(isOpened)
	self.fields.Button_upGolding:setEnabled(true)
	self.fields.Button_upLv:setEnabled(isOpened)
end
function ManorTechDetailPanel:initScroll()
	self.tableNeedList, technologyCtrl = nil, nil
	local tableStuding = technologyCtrl:studyingTechnology(self.queueType)
	if tableStuding then
		technologyCtrl = nil
		;(nil).data = tableStuding
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.QUEUE
		;(nil).queueType = self.queueType
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.build) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.BUILD
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.starbuild) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.STAR
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.tech) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY
		;(nil).queueType = self.queueType
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.wartool) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.WAR
		table.insert(self.tableNeedList, nil)
	end
	local technologyCtrl, resNeedList = (for generator), ipairs(self.tableSingleDetails.wartool)
	for i, v in ipairs(self.tableSingleDetails.resources) do
		technologyCtrl = self.tableNeedList
		self.tableNeedList.curcount = v.currentResource
		self.tableNeedList.rescount = v.consumeResourceOri
		resNeedList[i], self.tableNeedList.resid = self.tableNeedList, v.rid
	end
	for i, v in ipairs(self.tableSingleDetails.resources) do
		technologyCtrl = TECHNOLOGY_SINGLE_TYPE.WAR
		TECHNOLOGY_SINGLE_TYPE.WAR.data = v
		TECHNOLOGY_SINGLE_TYPE.WAR.singleType = TECHNOLOGY_SINGLE_TYPE.RES
		TECHNOLOGY_SINGLE_TYPE.WAR.resNeedList = resNeedList
		table.insert(self.tableNeedList, TECHNOLOGY_SINGLE_TYPE.WAR)
	end
	dump(self.tableNeedList, "self.tableNeedList==")
	self.fields.List:setNumItems(#self.tableNeedList)
end
function ManorTechDetailPanel:itemRenderer_List(index, obj)
	local data = self.tableNeedList[index + 1]
	obj:initData(data)
end
function ManorTechDetailPanel:getNeedResource()
	local _ENV, tableResNeedBuy
	local needGold = 0
	for i, v in ipairs(self.tableSingleDetails.resources) do
		if not v.isContentmented then
			local needRes = v.consumeResourceOri - v.currentResource
			if 0 < needRes then
				needGold = needGold + serviceFunctions.resConvertToGold(v.rid, needRes)
				_ENV = needRes
				needRes.resid = v.rid
				needRes.rescount = needRes
				table.insert(tableResNeedBuy, needRes)
			end
		end
	end
	for i, v in ipairs(self.tableSingleDetails.wartool) do
		if not v.isContentmented then
			local needRes = v.consumeResource - v.currentResource
			needGold = needGold + badgeExchangeCtrl:getCostGoldByCount(needRes, v.rid)
			_ENV = needRes
			needRes.resid = v.rid
			needRes.rescount = needRes
			table.insert(tableResNeedBuy, needRes)
		end
	end
	return needGold, tableResNeedBuy
end
function ManorTechDetailPanel:checkEnoughResource(studyTechnology)
	local needGold, tableResNeedBuy = self:getNeedResource()
	local isLackAmber = false
	for i, v in ipairs(tableResNeedBuy) do
		if (BUILD_STAR_COSTITEM[v.resid] or v.resid == gNebulaPalaceItemID) and v.rescount > 0 then
			isLackAmber = true
		end
	end
	if isLackAmber then
		SoraDShowMsgTip(i18n("common_text_2512"))
		return
	end
	local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
	if proxy:checkNeedRes(tableResNeedBuy) then
		uiManager:show("CommonQuicklyadd")
		return
	end
	_ENV, _ENV = i18n("common_text_2512")
	i18n("common_text_2512").resToGold = needGold
	i18n("common_text_2512").needResData, i18n("common_text_2512").retCostRes = i18n("common_text_2512")
	i18n("common_text_2512").viewType = RESBUYVIEW_TYPE.STUDY_SCIENCE
	i18n("common_text_2512").handle = studyTechnology
	uiManager:show("buildCreateResBuy", i18n("common_text_2512"))
end
function ManorTechDetailPanel:onClick_Button_upLv(context)
	SoraDPlaySound()
	local studyTechnology = function(event)
		event = event or UPGRADE_CONDITION.RESOURCES_NOT_ENOUGH
		technologyCtrl = nil
		;(nil)[1] = self.tableSingleData.technologyID
		technologyCtrl:research(self.tableSingleData.technologyID, event, nil)
		self:close()
	end
	if self.cantStudying == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		SoraDShowMsgTip(i18n("garden_text_17"))
		return
	end
	if self.cantStudying == TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY then
		SoraDShowMsgTip(i18n("garden_text_15"))
		return
	end
	if self.cantStudying == TECHNOLOGY_SINGLE_TYPE.RES or self.cantStudying == TECHNOLOGY_SINGLE_TYPE.WAR then
		self:checkEnoughResource(studyTechnology)
		return
	end
	technologyCtrl = i18n("garden_text_15")
	i18n("garden_text_15")[1] = self.tableSingleData.technologyID
	technologyCtrl:research(self.tableSingleData.technologyID, UPGRADE_CONDITION.RESOURCES_ENOUGH, i18n("garden_text_15"))
	self:close()
end
function ManorTechDetailPanel:onClick_Button_upGold(context)
	SoraDPlaySound()
	if SoraDEnoughGold(self.tableSingleDetails.cost) then
		if self.controllers.c1:getSelectedIndex() == 1 then
			SoraDShowSpeedUpBox(queueCtrl:queryQueue(self.queueType), handler(self, self.speedUpBack), i18n("common_text_765"))
		else
			SoraDShowBuyBox(i18n("common_text_707"), self.tableSingleDetails.cost, i18n("common_text_335"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
					self = nil
					;(nil)[1] = self.tableSingleData.technologyID
					technologyCtrl:instantResearch(self.tableSingleData.technologyID, nil)
					self:close()
				end
			end)
		end
	end
end
function ManorTechDetailPanel:speedUpBack(event)
	if event == MSGBOX_CALLBACK_SPEEDUP then
		self:close()
	end
end
function ManorTechDetailPanel:onClick_Button_speedUp(context)
	SoraDPlaySound()
	SoraDShowSpeedUpByItemBox(self.queueType, handler(self, self.speedUpBack))
end
function ManorTechDetailPanel:onClick_Button_detail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("ManorTechAttr", nil)
end
return ManorTechDetailPanel

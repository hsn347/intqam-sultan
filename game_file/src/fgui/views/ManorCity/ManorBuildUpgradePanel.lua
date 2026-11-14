local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityRead = include("manorCityRead")
local manorCityUtil = include("manorCityUtil")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorBuildUpgradePanel = class("ManorBuildUpgradePanel", baseFguiPanel)
function ManorBuildUpgradePanel:ctor(...)
	self.isLRU = true
	ManorBuildUpgradePanel.super.ctor(self, ...)
	print("ManorBuildUpgradePanel:ctor", self.viewName)
end
function ManorBuildUpgradePanel:onInit()
	print("=======ManorBuildUpgradePanel:onInit")
	self.fields.List_attr:setItemRenderer(handler(self, self.itemRenderer_List_attr))
	self.fields.Label_title:setString(i18n("garden_text_02"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_limit:setString(i18n("garden_text_03"))
	self.fields.Button_upNow:setString(i18n("garden_btn_04"))
	self.fields.Button_upNow:addClickListener(handler(self, self.onClickBtnUpNow))
	self.fields.Button_up:setString(i18n("garden_btn_01"))
	self.fields.Button_up:addClickListener(handler(self, self.onClickBtnUp))
	self.fields.Button_up:setCostIcon("icon_hourglass.png")
	if not SoraDFIsRA() then
		self.fields.Text_curLv:fixPos()
		self.fields.Text_nextLv:fixPos()
		self.fields.Com_arrow:setScaleX(-0.9)
		self.fields.Button_upNow:fixPos()
		self.fields.Button_up:fixPos()
	end
end
function ManorBuildUpgradePanel:endShow()
	print("=======ManorBuildUpgradePanel:endShow")
	self.realId = self.param.realId
	self.buildID = self.param.buildID
	local buildName = manorCityRead.getBuildName(self.buildID)
	self.fields.Panel_bg:setString(buildName)
	local buildImage = manorCityRead.getBuildSmallImage(self.buildID)
	self.fields.Image_build:setURL(buildImage)
	self:updateUpgradeData()
end
function ManorBuildUpgradePanel:updateUpgradeData()
	local curLv = manorCityCtrl:getBuildLv(self.realId)
	manorCityCtrl = nil
	;(nil).lv = curLv
	self.fields.Text_curLv:setString(i18n("common_text_100", nil))
	manorCityCtrl = i18n("common_text_100", nil)
	i18n("common_text_100", nil).lv = curLv + 1
	self.fields.Text_nextLv:setString(i18n("common_text_100", i18n("common_text_100", nil)))
	self.upgradeInfo = manorCityUtil.getBuildUpgradeInfo(self.buildID, curLv)
	self.fields.List_attr:setNumItems(#self.upgradeInfo)
	if self:checkMileStoneLvLimit() then
		self.controllers.c1:setSelectedIndex(0)
		self:updateCondData()
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function ManorBuildUpgradePanel:updateCondData()
	local curLv = manorCityCtrl:getBuildLv(self.realId)
	local _iscanupgrade, retdata = manorCityUtil.isCanUpgrade(self.buildID, curLv)
	self.buildData = retdata
	local immediatelyGold = self.buildData._immediatelyGold
	self.fields.Button_upNow:setCostTitle(string.formatnumberthousands(immediatelyGold))
	local costtime = self.buildData._costtime
	self.fields.Button_up:setCostTitle(SoraDConvertSecondToString(costtime))
	local manorCityCtrl, temp = self.fields.Button_up.setCostTitle, self.fields.Button_up.setCostTitle
	local isEnable = true
	if not self.buildData._buildQueueList then
		local manorCityCtrl, _buildQueueList = self.buildData._buildQueueList, self.buildData._buildQueueList
	end
	for i, v in ipairs(_buildQueueList) do
		manorCityCtrl = SoraDConvertSecondToString(costtime)
		SoraDConvertSecondToString(costtime).singleType = MANOR_COND_TYPE.TIME
		SoraDConvertSecondToString(costtime).singleData = v
		table.insert(temp, SoraDConvertSecondToString(costtime))
	end
	if not self.buildData._retPreCond then
		local manorCityCtrl, _retPreCond = self.buildData._retPreCond, self.buildData._retPreCond
	end
	for i, v in ipairs(_retPreCond) do
		manorCityCtrl = MANOR_COND_TYPE.TIME
		MANOR_COND_TYPE.TIME.singleType = MANOR_COND_TYPE.BUILD
		MANOR_COND_TYPE.TIME.singleData = v
		table.insert(temp, MANOR_COND_TYPE.TIME)
		if not v.isreach then
			isEnable = false
		end
	end
	if not self.buildData._retCostItems then
		local manorCityCtrl, _retCostItems = self.buildData._retCostItems, self.buildData._retCostItems
	end
	for i, v in ipairs(_retCostItems) do
		manorCityCtrl = MANOR_COND_TYPE.BUILD
		MANOR_COND_TYPE.BUILD.singleType = MANOR_COND_TYPE.ITEM
		MANOR_COND_TYPE.BUILD.singleData = v
		table.insert(temp, MANOR_COND_TYPE.BUILD)
		if not v.isreach then
			isEnable = false
		end
	end
	if not self.buildData._retCostRes then
		local manorCityCtrl, _retCostRes = self.buildData._retCostRes, self.buildData._retCostRes
	end
	for i, v in ipairs(_retCostRes) do
		manorCityCtrl = MANOR_COND_TYPE.ITEM
		MANOR_COND_TYPE.ITEM.singleType = MANOR_COND_TYPE.RES
		MANOR_COND_TYPE.ITEM.singleData = v
		table.insert(temp, MANOR_COND_TYPE.ITEM)
	end
	self.tableCondData = temp
	self:updateCondList()
	self:setBuildBtnTouchEnable(isEnable)
end
function ManorBuildUpgradePanel:updateCondList()
	self.fields.List:setNumItems(#self.tableCondData)
end
function ManorBuildUpgradePanel:setBuildBtnTouchEnable(isEnable)
	self.fields.Button_upNow:setEnabled(isEnable)
	self.fields.Button_up:setEnabled(isEnable)
end
function ManorBuildUpgradePanel:itemRenderer_List_attr(index, obj)
	local data = self.upgradeInfo[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_title:setString(data.title)
	_fields.Text_value:setString(data.value)
	_fields.Text_nextValue:setString(data.nextValue)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
		_fields.Com_arrow:setScaleX(-0.8)
	end
end
function ManorBuildUpgradePanel:itemRenderer_List(index, obj)
	local data = self.tableCondData[index + 1]
	obj:initData(data)
	obj:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
end
function ManorBuildUpgradePanel:checkPreCond()
	for i, v in ipairs(self.buildData._retPreCond) do
		if not v.isreach then
			SoraDShowMsgTip(i18n("garden_text_05"))
			return false
		end
	end
	return true
end
function ManorBuildUpgradePanel:checkCostItems()
	for i, v in ipairs(self.buildData._retCostItems) do
		if not v.isreach then
			local itemName = itemDesRead.getName(v.toolid)
			_ENV = nil
			;(nil).name = itemName
			SoraDShowMsgTip(i18n("Frosty_Market_text_19", nil))
			return false
		end
	end
	return true
end
function ManorBuildUpgradePanel:onClickBtnUpNow(context)
	SoraDPlaySound()
	if not self:checkPreCond() then
		return
	end
	if not self:checkCostItems() then
		return
	end
	if IS_FIRST_TIME_COST_GOLD_BUILDING then
		local buildName = manorCityRead.getBuildName(self.buildID)
		_ENV = nil
		_ENV = nil
		;(nil).name = buildName
		;(nil).msg = i18n("common_text_745", nil)
		;(nil).gold = self.buildData._immediatelyGold
		;(nil).title = i18n("garden_btn_04")
		;(nil).handle = handler(self, self.upgradeNow)
		;(nil).checkTip = i18n("build_gold_lvup_tips_name")
		;(nil).isCheck = IS_SELECT_LOGIN_NOTICE
		;(nil).isInmediaGold = true
		SoraDShowBuyBoxNew(nil)
	else
		self:upgradeNow(MSGBOX_CALLBACK_YES)
	end
end
function ManorBuildUpgradePanel:onClickBtnUp(context)
	SoraDPlaySound()
	if not self.buildData._buildQueueList then
		local _ENV, _buildQueueList = self.buildData._buildQueueList, self.buildData._buildQueueList
	end
	if #_buildQueueList ~= 0 then
		SoraDShowMsgTip(i18n("garden_text_42"))
		return
	end
	if not self:checkPreCond() then
		return
	end
	if not self:checkCostItems() then
		return
	end
	local isNeedBuyRes = false
	for i, v in ipairs(self.buildData._retCostRes) do
		if not v.isreach then
			isNeedBuyRes = true
			break
		end
	end
	if isNeedBuyRes then
		self:showResBuy()
		return
	end
	self:upgrade()
end
function ManorBuildUpgradePanel:upgrade(mode)
	local _mode = mode or OPERATE_MODE.NORMAL
	manorCityCtrl:reqGardenMapUpgradeBuild(self.realId, _mode)
end
function ManorBuildUpgradePanel:upgradeNow(type)
	if type ~= MSGBOX_CALLBACK_YES then
		return
	end
	if SoraDEnoughGold(self.buildData._immediatelyGold) then
		self:upgrade(OPERATE_MODE.IMMEDIATELY)
	end
end
function ManorBuildUpgradePanel:showResBuy()
	local resBuyType = RESBUYVIEW_TYPE.UPGRADE
	local _ENV, tableResNeedBuy
	for i, v in ipairs(self.buildData._retCostRes) do
		if not v.isreach then
			local needBuyRes = v.rescount - v.curcount
			if 0 < needBuyRes then
				_ENV = nil
				;(nil).resid = v.resid
				;(nil).rescount = needBuyRes
				table.insert(tableResNeedBuy, nil)
			end
		end
	end
	local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
	if proxy:checkNeedRes(tableResNeedBuy) then
		uiManager:show("CommonQuicklyadd")
	else
		local resToGold = self.buildData._resToGold
		_ENV, _ENV = table.insert, v.rescount - v.curcount
		table.insert.resToGold = resToGold
		;(v.rescount - v.curcount).needResData, table.insert.retCostRes = table.insert, tableResNeedBuy
		;(v.rescount - v.curcount).viewType = resBuyType
		;(v.rescount - v.curcount).handle = handler(self, self.resBuyCallBack)
		uiManager:show("buildCreateResBuy", v.rescount - v.curcount)
	end
end
function ManorBuildUpgradePanel:resBuyCallBack()
	self:upgrade(OPERATE_MODE.GOLD_REPLACE)
end
function ManorBuildUpgradePanel:scrollSingleCallBack(data)
	local singleType = data.singleType
	if singleType == MANOR_COND_TYPE.TIME then
		local queue = data.singleData
		local leftTime = queue.timerNode.timer:getRemainTime()
		if leftTime <= 0 then
			return
		else
			local queueType = queue.qtype
			local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.BUILD_UPGRADE)
			if next(itemList) ~= nil then
				SoraDShowSpeedUpByItemBox(tonumber(queueType), handler(self, self.speedUpBoxCallBack))
			else
				SoraDShowSpeedUpBox(queue, handler(self, self.speedUpBoxCallBack))
			end
		end
	elseif singleType == MANOR_COND_TYPE.BUILD then
		self:closePanel()
		local buildID = data.singleData.bid
		_ENV = queue.qtype
		queue.qtype.msg = "MESSAGE_MANOR_BUILD_JUMP"
		queue.qtype.buildID = buildID
		queue.qtype.showFinger = true
		SoraDSendMessage(queue.qtype)
		local mapObj = manorCityCtrl:getMapObjByBid(buildID)
		if mapObj then
			SoraDShowMsgTip(i18n("garden_text_04"))
		end
	elseif singleType == MANOR_COND_TYPE.RES then
		local needBuyResList = self.buildData._retCostRes
		_ENV = i18n("garden_text_04")
		i18n("garden_text_04").rid = data.singleData.resid
		i18n("garden_text_04").needResData = needBuyResList
		uiManager:show("resourceBuyView", i18n("garden_text_04"))
	elseif singleType == MANOR_COND_TYPE.ITEM then
		_ENV = "resourceBuyView"
		;("resourceBuyView").itemID = data.singleData.toolid
		uiManager:show("CommonSourceGuide", "resourceBuyView")
	else
		SoraDShowMsgTip(singleType)
	end
end
function ManorBuildUpgradePanel:speedUpBoxCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		self:updateCondList()
	end
end
function ManorBuildUpgradePanel:onMsgUpgradeBuildBack(target, event)
	local _mode = tonumber(event.mode)
	local isFullLv = manorCityCtrl:getBuildIsMaxLv(self.realId)
	if _mode == OPERATE_MODE.IMMEDIATELY and not isFullLv then
		SoraDRemoveAllAfterPanelFromManager(self, true)
		self:updateUpgradeData()
	else
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function ManorBuildUpgradePanel:onMsgUpgradeBuildQueue(target, event)
	self:updateCondData()
end
function ManorBuildUpgradePanel:onMsgResourceUpdate(target, event)
	self:updateCondData()
end
function ManorBuildUpgradePanel:checkMileStoneLvLimit()
	if self.buildID ~= MANOR_BUILD_ID.MAIN then
		return true
	end
	local curLv = manorCityCtrl:getBuildLv(self.realId)
	local lvLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UNLOCK_GARDEN_BUILD_LV_3101)
	if curLv >= lvLimit then
		return false
	end
	return true
end
return ManorBuildUpgradePanel

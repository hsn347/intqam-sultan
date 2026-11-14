local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local worldMapWarDef = include("worldMapWarDef")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local speedUpReCallBuyViewPanel = class("speedUpReCallBuyViewPanel", baseFguiPanel)
function speedUpReCallBuyViewPanel:ctor(...)
	speedUpReCallBuyViewPanel.super.ctor(self, ...)
	print("speedUpReCallBuyViewPanel:ctor", self.viewName)
end
function speedUpReCallBuyViewPanel:onInit()
	print("=======speedUpReCallBuyViewPanel:onInit")
	self.troopData, _ENV, self.isHideCurrentSceneView = print, print, true
	self.timerInfoTbl, _ENV, self.itemArray, _ENV, self.itemList, _ENV, self.itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
	self.fields.Com_title:initData(i18n("common_text_018"), handler(self, self.onClickClose))
	self.fields.Text_BarTime:setTimeUpdateListener(handler(self, self.updateTimer))
	self.fields.Text_addTip:setString(i18n("common_text_604"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.LoadingBar_progress:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_addTip:fixPos()
end
function speedUpReCallBuyViewPanel:onShow()
	print("=======speedUpReCallBuyViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.troopData = self.param.troopData
	self.itemType = self.param.itemType or gItemType.MARCH_SPEED_UP
	self:initData(self.itemType, self.troopData)
end
function speedUpReCallBuyViewPanel:initData(itemType, troopData)
	self.troopData = troopData
	self.itemType = itemType
	self:refreshData()
end
function speedUpReCallBuyViewPanel:onItemRederer(index, obj)
	obj:initData(self.itemArray[index + 1], self.itemType, self.troopData)
end
function speedUpReCallBuyViewPanel:update(target, data)
	if self.willToUse then
		local itemIcon = publicRead.getIcon(self.willToUse)
		local itemName = publicRead.getName(self.willToUse)
		publicRead = nil
		;(nil).itemName = itemName
		SoraDShowMsgTip(i18n("common_text_422", nil), "#" .. itemIcon)
	end
	if gItemType.MARCH_BACK == self.itemType then
		SoraDCloseLoading(self)
		self:delTimer()
	else
		self:refreshData()
	end
end
function speedUpReCallBuyViewPanel:refreshData(target, data)
	self.itemArray, backpackltCtrl = nil, nil
	local itemList = backpackltCtrl:getItemArray(self.itemType)
	if gItemType.MARCH_BACK == self.itemType then
		self.itemList = itemList
	else
		self.itemList, backpackltCtrl = gItemType.MARCH_BACK, gItemType.MARCH_BACK
		local freeTool = ATLANTIS_WAR_FREE_MARCH_SPEED
		local atlantisWarUtil = include("atlantisWarUtil")
		if worldMapDefine.isInAtlantis() and not atlantisWarUtil.isNewMap() then
			local count = backpackCtrl:getItemCount(freeTool)
			if 0 < count then
				_ENV = backpackCtrl
				self.itemList, backpackCtrl[1] = backpackCtrl, freeTool
			else
				for k, v in ipairs(itemList) do
					table.insert(self.itemList, v)
				end
			end
		else
			for k, v in ipairs(itemList) do
				if v ~= freeTool then
					table.insert(self.itemList, v)
				end
			end
		end
	end
	self:initView()
end
function speedUpReCallBuyViewPanel:initView()
	if self.removeFlag then
		return
	end
	if gItemType.MARCH_SPEED_UP == self.itemType then
		if self.troopData.speedUpType then
			self.fields.Com_title:updateTitle(i18n("common_text_018"))
			self.controllers.c1:setSelectedIndex(0)
			local queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
			if queue then
				self.timerInfoTbl.timerNode = queue.timerNode
				self.timerInfoTbl.totalTime = queue.totaltime
				self:beginTime()
			end
		else
			self.fields.Com_title:updateTitle(i18n("common_text_018"))
			self.controllers.c1:setSelectedIndex(0)
			local queue = kingdomMapCtrl:getQueueByID(self.troopData.troopsID)
			self.timerInfoTbl.queue = queue
			self:beginTime()
		end
	elseif gItemType.MARCH_BACK == self.itemType then
		self.controllers.c1:setSelectedIndex(1)
		if self.troopData.isMass and self.troopData.isMainQueue then
			queueCtrl = self.troopData.isMainQueue
			self.itemList, self.troopData.isMainQueue[1] = self.troopData.isMainQueue, 300202
		elseif not self.troopData.isRecall then
			queueCtrl = self.troopData.isRecall
			self.itemList, self.troopData.isRecall[1] = self.troopData.isRecall, 300203
		end
		if self.troopData.isJieSan then
			self.fields.Com_title:updateTitle(i18n("common_text_301"))
		else
			self.fields.Com_title:updateTitle(i18n("common_text_017"))
		end
	end
	local battleExclusive = worldMapWarDef.getSpeedUpBattleExclusive()
	for k, v in ipairs(self.itemList) do
		local itemInfo
		if table.keyof(battleExclusive, v) then
			itemInfo = worldMapWarDef.createSpeedUpBattleExcluseive(v)
		else
			itemInfo = self:getItemInfo(v)
		end
		if itemInfo then
			table.insert(self.itemArray, itemInfo)
		end
	end
	self.fields.list:setNumItems(#self.itemArray)
end
function speedUpReCallBuyViewPanel:getItemInfo(itemID)
	local isAllowShow = true
	local backpackCtrl, _initData
	local itemCount = backpackCtrl:getItemCount(itemID)
	local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
	local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
	if 0 < itemCount then
		if itemInfo then
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			shopCtrl.gold = itemInfo.price
			shopCtrl.limitData = limitInfo
			_initData, shopCtrl.count = shopCtrl, itemCount
		else
			backpackCtrl = shopCtrl
			shopCtrl.iid = itemID
			_initData, shopCtrl.count = shopCtrl, itemCount
		end
	elseif itemInfo then
		backpackCtrl = shopCtrl
		shopCtrl.iid = itemID
		shopCtrl.gold = itemInfo.price
		shopCtrl.limitData = limitInfo
		_initData, shopCtrl.shopID = shopCtrl, itemInfo.shopItemID
	else
		isAllowShow = false
	end
	if not include("itemLogic").checkUseCond(itemID) then
		isAllowShow = false
	end
	if _initData and itemInfo and itemInfo.isLadder == 1 then
		local count = 0
		if limitInfo then
			count = limitInfo.buyCount
		end
		_initData.gold = gModuleMgr.sharedMgr("shopltCtrl"):getLadderPrice(itemInfo.shopItemID, count + 1)
	end
	if isAllowShow then
		return _initData
	else
		print("noShow = ", itemID)
		return nil
	end
end
function speedUpReCallBuyViewPanel:beginTime()
	if self.timerInfoTbl.timerNode and self.timerInfoTbl.timerNode.timer then
		local curTime = self.timerInfoTbl.timerNode.timer:getRemainTime()
		if 0 < curTime then
			self.fields.Text_BarTime:beginTime(curTime)
		end
	elseif self.timerInfoTbl.queue then
		local queue = self.timerInfoTbl.queue
		local curTime = queue:getStatusRemainTime()
		if 0 < curTime then
			self.fields.Text_BarTime:beginTime(curTime)
		end
	else
		self:delTimer()
	end
end
function speedUpReCallBuyViewPanel:updateTimer(time)
	local totalTime = self.timerInfoTbl.totalTime
	if self.timerInfoTbl.queue then
		totalTime = self.timerInfoTbl.queue:getOrgStatusTotalTime()
	end
	self.fields.LoadingBar_progress:setMax(totalTime)
	self.fields.LoadingBar_progress:setValue(time)
end
function speedUpReCallBuyViewPanel:delTimer()
	self.fields.Text_BarTime:endTime()
	self.removeFlag = true
	self:close()
end
function speedUpReCallBuyViewPanel:updateTimeRefesh(target, data)
	self:beginTime()
end
function speedUpReCallBuyViewPanel:closeMe(target, redata)
	if self.troopData.troopsID and redata.data.id == self.troopData.troopsID then
		self:delTimer()
	end
end
return speedUpReCallBuyViewPanel

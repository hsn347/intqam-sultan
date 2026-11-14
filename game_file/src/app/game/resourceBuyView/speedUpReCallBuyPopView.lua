local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local worldMapWarDef = include("worldMapWarDef")
local publicRead = include("publicRead")
local SpeedUpReCallBuyPopView = class("speedUpReCallBuyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("normalStyleBuyPopView")
	end
	return target
end)
function SpeedUpReCallBuyPopView:ctor()
	print("SpeedUpReCallBuyPopView:ctor")
	self.handleCloseCallBack = handler(self, self.closeCallBack)
	self.enableTouchCloseSelf = true
	self.isHideCurrentSceneView = false
	self:setBackGroundColorOpacity(0)
	self.singleTbl, _ENV, self.timerInfoTbl, _ENV, self.troopData, _ENV = self.setBackGroundColorOpacity, self.setBackGroundColorOpacity, self.setBackGroundColorOpacity, self.setBackGroundColorOpacity, self.setBackGroundColorOpacity, self.setBackGroundColorOpacity
	self.itemScroll = include("itemBuyScroll").new()
	self.imgBg = SoraDGetChildByName(self, "Tile_Image_bg")
	self.nodeMove = SoraDGetChildByName(self, "Node_move")
	self.scroll = SoraDGetChildByName(self, "ScrollView_normalBuyView")
	self.oriScrollSize = self.scroll:getContentSize()
	self.oriScrollPosY = self.scroll:getPositionY()
	self.nodeLoadingBar = SoraDGetChildByName(self, "Node_loadingBar")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_BarTime")
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 0, 4, 21))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_SPEEDUP", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ARMY_SPEEDUP_TIMEREFRESH", handler(self, self.updateTimeRefesh))
	SoraDAddMessage(self, "MESSAGE_ARMY_WORLDMAPCONTROL_CLOSEWINDOW", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_USESPEEDITEMCOUNT", handler(self, self.onMsgUpdateUseCount))
end
function SpeedUpReCallBuyPopView:closeCallBack(...)
	self:exitView()
end
function SpeedUpReCallBuyPopView:exitView()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_HEROQUEUE_SPEED_IN"
	SoraDSendMessage(nil)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(0.1, cc.p(320, 0))
	;(nil)[2] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[3] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[4] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[5] = cca.callFunc(function()
		self:removeFromParent()
	end)
	self.imgBg:runAction(cca.seq(nil))
end
function SpeedUpReCallBuyPopView:update(...)
	if self.willToUse then
		local publicRead = include("publicRead")
		local itemIcon = publicRead.getIcon(self.willToUse)
		local itemName = publicRead.getName(self.willToUse)
		_ENV = nil
		;(nil).itemName = itemName
		SoraDShowMsgTip(i18n("common_text_422", nil), "#" .. itemIcon)
	end
	self:refreshData()
end
function SpeedUpReCallBuyPopView:initData(itemType, troopData)
	self.troopData = troopData
	self.itemType = itemType
	self:initNebulaAllStarView()
	self:initRoaringFlameView()
	self:refreshData()
end
function SpeedUpReCallBuyPopView:refreshData(...)
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
function SpeedUpReCallBuyPopView:initView(...)
	if self.removeFlag then
		return
	end
	if gItemType.MARCH_BACK == self.itemType and self.troopData.isMass then
		if self.troopData.isMainQueue then
			gametop = self.troopData.isMainQueue
			self.itemList, self.troopData.isMainQueue[1] = self.troopData.isMainQueue, 300202
		elseif not self.troopData.isRecall then
			gametop = self.troopData.isRecall
			self.itemList, self.troopData.isRecall[1] = self.troopData.isRecall, 300203
		end
	end
	if self.troopData.speedUpType then
		self.nodeLoadingBar:setVisible(true)
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
		if queue then
			self.timerInfoTbl.timerNode = queue.timerNode
			self.timerInfoTbl.totalTime = queue.totaltime
			self:beginTime()
		end
	else
		self.nodeLoadingBar:setVisible(true)
		local queue = kingdomMapCtrl:getQueueByID(self.troopData.troopsID)
		self.timerInfoTbl.queue = queue
		self:beginTime()
	end
	_ENV = queue
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemList = self.itemList
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemCallBack = handler(self, self.buyOrUseCallBack)
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemStyle = "commonItemUseBar_04"
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemSize = cc.size(640, 100)
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemInitCallBack = handler(self, self.itemInitCallBack)
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).itemIconClickCallBack = handler(self, self.itemIconClickCallBack)
	kingdomMapCtrl:getQueueByID(self.troopData.troopsID).battleExclusive = worldMapWarDef.getSpeedUpBattleExclusive()
	local kingdomMapCtrl:getQueueByID(self.troopData.troopsID).sortHandl, transTbl = handler(self, self.sortByIndex), kingdomMapCtrl:getQueueByID(self.troopData.troopsID)
	if self.itemScroll and not tolua.isnull(self.scroll) then
		self.itemScroll:setScroll(self.scroll)
		self.itemScroll:init(transTbl)
		self.itemScroll.scroll:setBounceEnabled(false)
		local itemCount = #self.itemScroll:getSingleToShow()
		if not self.itemShowCount or self.itemShowCount ~= itemCount then
			local textH = self.textH or 0
			self.imgBg:runAction(cca.moveTo(0.1, cc.p(320, itemCount * 100 + 85 + display.iPhoneXBottom + textH)))
			self.imgBg:setContentSize(cc.size(660, itemCount * 100 + 130 + textH))
			self.nodeMove:setPositionY(itemCount * 100 + 135 + textH)
			local sSize = self.scroll:getContentSize()
			self.scroll:setContentSize(cc.size(sSize.width, itemCount * 100))
			self.scroll:setInnerContainerSize(cc.size(sSize.width, itemCount * 100))
			self.itemScroll:setPos()
			self.itemShowCount = itemCount
			self.firstInitView = true
		end
	end
end
function SpeedUpReCallBuyPopView:itemIconClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif eventType == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button.itemData, pos)
	end
end
function SpeedUpReCallBuyPopView:openItem(itemData, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(itemData.iid)
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 150)
		else
			self.pFloor:setPosition(pos.x, pos.y + 150)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 150)
	else
		self.pFloor:setPosition(pos.x, pos.y + 150)
	end
	self.pFloor:addTo(self, 100)
end
function SpeedUpReCallBuyPopView:itemInitCallBack(item)
	if item.tableItem and item.tableItem.index and item.tableItem.isLast == true then
		local bottomLine = SoraDGetChildByName(item, "Node_bottom_line")
		if bottomLine then
			bottomLine:setVisible(true)
		end
	end
	if item.tableItem.iid == ATLANTIS_WAR_FREE_MARCH_SPEED then
		SoraDSetTextWidthHeight(item.txtTitle, cc.size(320, 70))
		item.txtTitle = SoraDChangeTextToHtml(item.txtTitle)
		item.txtTitle:setColor(display.COLOR_WHITE)
		local publicRead = include("publicRead")
		local itemName = publicRead.getName(item.tableItem.iid)
		_ENV = cc.size(320, 70)
		cc.size(320, 70).color = "#AA9682"
		_ENV = "atlantiswar_text_0270"
		;("atlantiswar_text_0270").color = "#D7C39B"
		local showStr = SoraDWrapHtmlTagByStyle(itemName, cc.size(320, 70)) .. "\n" .. SoraDWrapHtmlTagByStyle(i18n("atlantiswar_text_0270"), "atlantiswar_text_0270")
		item.txtTitle:setString(showStr)
	end
	if worldMapDefine.isInRoaringFlame() and gItemType.MARCH_SPEED_UP == self.itemType then
		self:updateRoaringFlameItem(item)
	end
end
function SpeedUpReCallBuyPopView:buyOrUseCallBack(tbl)
	dump(tbl, "buyOrUseCallBack")
	local checkUseSpeedItemCount = function(itemID, callback)
		if not self:needCheckRoaringFlameUseSpeedItemCount(itemID) then
			callback()
			return
		end
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local remain = roaringFlameWarCtrl:getUseSpeedItemRemainCount()
		if remain <= 0 then
			SoraDShowMsgTip(i18n("flames_dunes_text282"))
			return
		end
		local dailyRemindManager = include("dailyRemindManager")
		self = i18n("flames_dunes_text282")
		i18n("flames_dunes_text282").rtype = dailyRemindManager.REMIND_TYPE.useSpeedItemCount
		self = i18n("flames_dunes_text282")
		i18n("flames_dunes_text282").val = remain
		i18n("flames_dunes_text282").item = publicRead.getName(itemID)
		i18n("flames_dunes_text282").content = i18n("flames_dunes_text277", i18n("flames_dunes_text282"))
		i18n("flames_dunes_text282").confirmFunc = function()
			callback()
		end
		dailyRemindManager.showMessageBox(i18n("flames_dunes_text282"))
	end
	local buyItem = function(id)
		if gItemType.MARCH_SPEED_UP == self.itemType then
			if self.troopData.speedUpType then
				local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
				heroTrialCtrl:speedUp(tonumber(id), "GOLD")
				print("heroTrialCtrl GOLD")
			elseif worldMapWarDef.buySpeedUpItem(id) then
				return true
			elseif id == 300301 or id == 300302 then
				checkUseSpeedItemCount(id, function(...)
					local dailyRemindManager = include("dailyRemindManager")
					_ENV = nil
					;(nil).rtype = dailyRemindManager.REMIND_TYPE.marchSpeedUp
					_ENV = nil
					;(nil).num = tbl.needGold
					;(nil).name = publicRead.getName(id)
					;(nil).content = i18n("common_text_4854", nil)
					;(nil).confirmFunc = function()
						if tolua.isnull(self) then
							return
						end
						kingdomMapCtrl:reqSpeedQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.GOLD)
					end
					dailyRemindManager.showMessageBox(nil)
				end)
			else
				kingdomMapCtrl:reqSpeedQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.GOLD)
			end
		elseif gItemType.MARCH_BACK == self.itemType then
			kingdomMapCtrl:reqRecallQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.GOLD)
		end
	end
	local useItem = function(id)
		if gItemType.MARCH_SPEED_UP == self.itemType then
			if tbl.itemCount == 0 and id == SIMULATED_DRILL_WAR_SPEEDUP_ITEM_ID then
				SoraDShowMsgTip(i18n("simulated_drill_text_57"))
				return
			end
			if self.troopData.speedUpType then
				local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
				heroTrialCtrl:speedUp(tonumber(id), "ITEM")
				print("heroTrialCtrl ITEM")
			elseif id == 300301 or id == 300302 then
				checkUseSpeedItemCount(id, function(...)
					kingdomMapCtrl:reqSpeedQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.TOOLS)
				end)
			else
				kingdomMapCtrl:reqSpeedQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.TOOLS)
			end
		elseif gItemType.MARCH_BACK == self.itemType then
			kingdomMapCtrl:reqRecallQueue(tonumber(id), self.troopData.troopsID, BUILD_EXCHANGE_MODE.TOOLS)
		end
	end
	if tbl.buy then
		if SoraDEnoughGold(tbl.needGold) then
			self.willToUse = tbl.itemID
			local ignoreUseTip = buyItem(tbl.itemID)
			if ignoreUseTip then
				self.willToUse = nil
			end
		end
	elseif tbl.use then
		self.willToUse = tbl.itemID
		useItem(tbl.itemID)
	end
end
function SpeedUpReCallBuyPopView:updateTimeRefesh(target, data)
	if self.timerInfoTbl.timerNode then
		self:updateTime()
	elseif self.timerInfoTbl.queue then
		local queueId = data and data.data and data.data.id
		if queueId and self.troopData.troopsID and queueId == self.troopData.troopsID then
			self:updateTimeQueue()
		end
	end
end
function SpeedUpReCallBuyPopView:updateTime(dt)
	if self.timerInfoTbl.timerNode and self.timerInfoTbl.timerNode.timer then
		local curTime = self.timerInfoTbl.timerNode.timer:getRemainTime()
		local totalTime = self.timerInfoTbl.totalTime
		if curTime and totalTime then
			self.loadingBar:setPercent((totalTime - curTime) / totalTime * 100)
			self.txtTime:setString(SoraDConvertSecondToString(curTime))
			if curTime <= 0 then
				self:delTimer()
			end
		else
			self:delTimer()
		end
	else
		self:delTimer()
	end
end
function SpeedUpReCallBuyPopView:updateTimeQueue(dt)
	local queue = self.timerInfoTbl.queue
	if queue then
		local curTime = math.ceil(queue:getStatusRemainTime())
		local totalTime = queue:getOrgStatusTotalTime()
		if curTime and totalTime then
			self.loadingBar:setPercent((totalTime - curTime) / totalTime * 100)
			self.txtTime:setString(SoraDConvertSecondToString(curTime))
			if curTime <= 0 then
				self:delTimer()
			end
		else
			self:delTimer()
		end
	else
		self:delTimer()
	end
end
function SpeedUpReCallBuyPopView:delTimer()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self.removeFlag = true
	self:close(self, ccui.TouchEventType.ended)
end
function SpeedUpReCallBuyPopView:beginTime()
	if self.timerInfoTbl.timerNode and self.timerInfoTbl.timerNode.timer then
		if self.updateTime then
			local curTime = self.timerInfoTbl.timerNode.timer:getRemainTime()
			if 0 < curTime then
				self:updateTime()
				if self.timeHandler then
					SoraDManagerRemoveTimer(self, self.timeHandler)
				end
				self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
			end
		end
	elseif self.timerInfoTbl.queue then
		if self.updateTimeQueue then
			local queue = self.timerInfoTbl.queue
			local curTime = queue:getStatusRemainTime()
			if 0 < curTime then
				self:updateTimeQueue()
				if self.timeHandler then
					SoraDManagerRemoveTimer(self, self.timeHandler)
				end
				self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTimeQueue))
			end
		end
	else
		self:delTimer()
	end
end
function SpeedUpReCallBuyPopView:sortByIndex(tbl)

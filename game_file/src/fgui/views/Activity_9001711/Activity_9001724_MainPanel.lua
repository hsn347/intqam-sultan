local baseFguiPanel = require("fgui.base.baseFguiPanel")
local activity_9001711_Read = include("activity_9001711_Read")
local activity_9001711_Ctrl = SoraDGetCtrl("activity_9001711_Ctrl")
local Activity_9001724_MainPanel = class("Activity_9001724_MainPanel", baseFguiPanel)
function Activity_9001724_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001724_MainPanel.super.ctor(self, ...)
	print("Activity_9001724_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001724
end
function Activity_9001724_MainPanel:onInit()
	print("=======Activity_9001724_MainPanel:onInit")
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.page:setItemRenderer(handler(self, self.onPageRenderer))
	self.fields.page:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
	self.fields.text_title:setString(i18n("activity_name_9001711"))
end
function Activity_9001724_MainPanel:endShow()
	print("=======Activity_9001724_MainPanel:endShow")
	self.popGfit = self.param and self.param.popGfit
	self.selectedIndex = self.param.page or 1
	self.tabIndex = 1
	if commonCheck.OUTAPPPURCHASE then
		_ENV = commonCheck.OUTAPPPURCHASE
		_ENV, _ENV, commonCheck.OUTAPPPURCHASE.defaultClick = nil, "=======Activity_9001724_MainPanel:endShow", 1
		_ENV, ("=======Activity_9001724_MainPanel:endShow")[1], (nil).title = nil, nil, i18n("common_text_4617")
		_ENV = nil
		;(nil).item = include("publicRead").getName(TOKEN_ITEM)
		commonCheck.OUTAPPPURCHASE.tabsetArray, ("=======Activity_9001724_MainPanel:endShow")[2], (nil).title = "=======Activity_9001724_MainPanel:endShow", nil, i18n("common_text_4618", nil)
		local commonCheck.OUTAPPPURCHASE.callback, tabData = handler(self, self.onClickTab), commonCheck.OUTAPPPURCHASE
		self.fields.com_TabW:initView(tabData)
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		self:initData()
	end
end
function Activity_9001724_MainPanel:initData(target, data)
	local systemTime = serviceFunctions.systemTime()
	local giftList = activity_9001711_Ctrl:getGiftList()
	local _ENV, showGiftList = activity_9001711_Ctrl, activity_9001711_Ctrl
	local _ENV, minTimeData
	local _ENV, hasRemainByShowType
	local curShowType
	for _, v in pairs(giftList) do
		if systemTime < v.buyEndTime then
			for rid, v2 in pairs(v.giftMap) do
				local _ENV, data
				data.rid = tonumber(rid)
				data.remainNum = v2.remainNum
				data.buyEndTime = v.buyEndTime
				local cfg = activity_9001711_Read.getRechargeCfg(rid)
				data.cfg = cfg
				if not showGiftList[cfg.showType] then
					_ENV = showGiftList[cfg.showType]
				end
				showGiftList[cfg.showType] = showGiftList[cfg.showType]
				table.insert(showGiftList[cfg.showType], data)
				data.sortIndex = data.remainNum == 0 and 999 or 1
				if data.remainNum > 0 then
					hasRemainByShowType[cfg.showType] = true
				end
				minTimeData[cfg.showType] = minTimeData[cfg.showType] or data
				if minTimeData[cfg.showType].buyEndTime > data.buyEndTime then
					minTimeData[cfg.showType] = data
				end
				if self.popGfit and self.popGfit.giftMap[tostring(rid)] then
					curShowType = cfg.showType
					print("curShowType", curShowType)
					break
				end
			end
		end
	end
	if table.nums(showGiftList) == 0 then
		self:close()
		return
	end
	self.popGfit = nil
	dump(showGiftList, "showGiftList1", 10)
	for k, v in pairs(showGiftList) do
		table.sort(v, function(a, b)
			if a.sortIndex ~= b.sortIndex then
				return a.sortIndex < b.sortIndex
			elseif a.cfg.price ~= b.cfg.price then
				return a.cfg.price < b.cfg.price
			else
				return a.buyEndTime < b.buyEndTime
			end
		end)
		showGiftList[k] = v
	end
	dump(showGiftList, "showGiftList2", 10)
	local _ENV, minTimeDataList = dump, dump
	for _, v in pairs(minTimeData) do
		table.insert(minTimeDataList, v)
	end
	table.sort(minTimeDataList, function(a, b)
		return a.buyEndTime < b.buyEndTime
	end)
	dump(minTimeDataList, "minTimeDataList")
	self.pageData, _ENV, self.showGiftList, _ENV = dump, dump, dump, dump
	for _, v in pairs(minTimeDataList) do
		local showType = v.cfg.showType
		if not hasRemainByShowType[showType] then
			print("skip showType all sold out", showType)
		else
			print("showType", showType)
			table.insert(self.showGiftList, showGiftList[showType])
			local pageCfg = activity_9001711_Read.getRechargeViewCfg(showType)
			table.insert(self.pageData, pageCfg)
			if curShowType == showType then
				self.selectedIndex = #self.pageData
			end
		end
	end
	self.pageCount = #self.pageData
	if self.pageCount == 0 then
		self:close()
		return
	end
	dump(self.pageData, "self.pageData")
	if data then
		self.selectedIndex = math.min(self.selectedIndex, self.pageCount)
		self.tabIndex = math.min(self.tabIndex, self.pageCount)
	end
	self.selectedIndex = math.max(1, math.min(self.selectedIndex or 1, self.pageCount))
	self.fields.page:setVisible(1 < self.pageCount)
	self.fields.page:setNumItems(self.pageCount + 2)
	local count = self.showGiftList[self.selectedIndex] and #self.showGiftList[self.selectedIndex] or 0
	self.fields.list:setNumItems(count)
	if 1 < self.pageCount then
		self.fields.page:ScrollToView(SoraDFIsRA() and self.selectedIndex + 1 or self.selectedIndex - 1, true, true)
	end
	self.fields.bg:setURL(self.pageData[self.selectedIndex].rechargeBg)
end
function Activity_9001724_MainPanel:onItemRenderer(index, obj)
	local giftData = self.showGiftList[self.selectedIndex][index + 1]
	obj:initData(giftData, self.tabIndex)
end
function Activity_9001724_MainPanel:onPageRenderer(index, obj)
	local page = self.pageData[index]
	dump(page, "Activity_9001724_MainPanel:onPageRenderer")
	obj:initData(page, index, self.selectedIndex, self.pageCount)
	obj:setOnPageChangeCallback(handler(self, self.onPageChange))
end
function Activity_9001724_MainPanel:onClickTab(index)
	self.tabIndex = index
	print("self.tabIndex", self.tabIndex, index)
	self:initData()
end
function Activity_9001724_MainPanel:onScrollEnd()
	local innerContainer = self.fields.page:getInnerContainer()
	local position = innerContainer:getPosition()
	local centerIndex = math.ceil(position.x / 256)
	_UPVALUE3_ = nil
	;(nil)[1] = centerIndex
	;(nil)[2] = position.x
	;(nil)[3] = 256
	dump(nil, "Activity_9001724_MainPanel:onScrollEnd")
	local curIndex = SoraDFIsRA() and self.pageCount - centerIndex or centerIndex + 1
	if self.selectedIndex ~= curIndex then
		self.selectedIndex = curIndex
		self:initData()
	end
	self.fields.page:ScrollToView(SoraDFIsRA() and curIndex + 1 or curIndex - 1, true, true)
end
function Activity_9001724_MainPanel:onPageChange(index)
	self.fields.page:ScrollToView(SoraDFIsRA() and index + 1 or index - 1, true, true)
end
return Activity_9001724_MainPanel

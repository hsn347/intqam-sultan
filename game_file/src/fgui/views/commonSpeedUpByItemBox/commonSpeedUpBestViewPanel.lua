local buildLogic = include("buildLogic")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonSpeedUpBestViewPanel = class("commonSpeedUpBestViewPanel", baseFguiPanel)
function commonSpeedUpBestViewPanel:ctor(...)
	commonSpeedUpBestViewPanel.super.ctor(self, ...)
	print("commonSpeedUpBestViewPanel:ctor", self.viewName)
end
function commonSpeedUpBestViewPanel:onInit()
	print("=======commonSpeedUpBestViewPanel:onInit")
	self.isFirst = true
	self.retData, _ENV, self.totalVal = print, print, 0
	self.fields.Panel_bg:setString(i18n("accelerate_text_001"))
	self.fields.Text_tip:setString(i18n("accelerate_text_004"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_sure:setString(i18n("common_text_204"))
	self.fields.Button_sure:addClickListener(handler(self, self.onOkClick))
end
function commonSpeedUpBestViewPanel:onItemRenderer(index, obj)
	obj:initData(self.retData[index + 1].id, self.retData[index + 1].count)
end
function commonSpeedUpBestViewPanel:onShow()
	print("=======commonSpeedUpBestViewPanel:onShow")
	self.speedType = self.param.speedType
	self.itemType = self.param.itemType
	self:initData()
end
function commonSpeedUpBestViewPanel:speedUpBack()
	self.isFirst = true
	self:initData()
end
function commonSpeedUpBestViewPanel:initData()
	self.totalVal = 0
	self.queue = queueCtrl:queryQueue(self.speedType)
	self.itemData = backpackCtrl:getSpeedUpItemList(self.itemType)
	for k, v in ipairs(self.itemData) do
		local result = backpackltCtrl:getResult(v.id)
		v.key = result.key
		v.value = result.value
		self.totalVal = self.totalVal + v.value * v.count
	end
	self.freeTime = self:getFreeTime()
	table.sort(self.itemData, function(a, b)
		if a.key == b.key then
			return a.value > b.value
		else
			return a.key > b.key
		end
	end)
	if self.queue then
		self:showQueue()
	else
		self:closeQueue()
	end
end
function commonSpeedUpBestViewPanel:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function commonSpeedUpBestViewPanel:closeQueue()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self:close()
end
function commonSpeedUpBestViewPanel:chooseBest()
	local targetTime = self.needTime
	if targetTime >= self.totalVal then
		return self.itemData
	end
	local _ENV, bestData = self.itemData, self.itemData
	local selVal = 0
	local cloneItemData = clone(self.itemData)
	for k, v in ipairs(cloneItemData) do
		if targetTime >= v.value and 0 < v.count then
			local selCount = math.min(v.count, math.floor(targetTime / v.value))
			if 0 < targetTime - selCount * v.value then
				_ENV = math.floor(targetTime / v.value)
				math.floor(targetTime / v.value).id = v.id
				math.floor(targetTime / v.value).count = selCount
				math.floor(targetTime / v.value).key = v.key
				math.floor(targetTime / v.value).value = v.value
				table.insert(bestData, math.floor(targetTime / v.value))
				cloneItemData[k].count = cloneItemData[k].count - selCount
				targetTime = targetTime - selCount * v.value
				selVal = selVal + selCount * v.value
			else
				break
			end
		end
	end
	if 0 < targetTime then
		table.sort(cloneItemData, function(a, b)
			if a.value == b.value then
				return a.key > b.key
			else
				return a.value < b.value
			end
		end)
		for k, v in ipairs(cloneItemData) do
			if targetTime <= v.value * v.count then
				local selCount = math.min(v.count, math.ceil(targetTime / v.value))
				local isHave = false
				for ki, vi in ipairs(bestData) do
					if vi.id == v.id then
						isHave = true
						bestData[ki].count = bestData[ki].count + selCount
					end
				end
				if not isHave then
					_ENV = ipairs(bestData)
					ipairs(bestData).id = v.id
					ipairs(bestData).count = selCount
					ipairs(bestData).key = v.key
					ipairs(bestData).value = v.value
					table.insert(bestData, ipairs(bestData))
				end
				cloneItemData[k].count = cloneItemData[k].count - selCount
				targetTime = targetTime - selCount * v.value
				selVal = selVal + selCount * v.value
				break
			end
		end
	end
	if selVal > self.needTime then
		table.sort(bestData, function(a, b)
			if a.value == b.value then
				return a.key < b.key
			else
				return a.value > b.value
			end
		end)
		for k, v in ipairs(bestData) do
			if selVal - v.value >= self.needTime then
				local backCount = math.min(v.count, math.floor((selVal - self.needTime) / v.value))
				v.count = v.count - backCount
				selVal = selVal - backCount * v.value
			end
		end
	end
	local _ENV, realData = (for generator), ipairs(bestData)
	for k, v in ipairs(bestData) do
		if 0 < v.count then
			table.insert(realData, v)
		end
	end
	return realData
end
function commonSpeedUpBestViewPanel:openTimeUp(dt)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	local needTime = leftTime - self.freeTime
	self.needTime = needTime
	if needTime <= 0 then
		self:closeQueue()
		return
	end
	if self.isFirst or needTime % 60 == 0 then
		self.isFirst = false
		self.retData = self:chooseBest()
		local realTime = 0
		for k, v in ipairs(self.retData) do
			realTime = realTime + v.value * v.count
		end
		self.realTime = realTime
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#C89B64", SoraDConvertSecondToString(realTime))
		self.fields.Text_speedTime:setString(i18n("common_text_1161", nil))
		self:updateItem()
	end
end
function commonSpeedUpBestViewPanel:updateItem()
	self.fields.List:setNumItems(#self.retData)
end
function commonSpeedUpBestViewPanel:getFreeTime()
	local queueTimeUtil = include("queueTimeUtil")
	return queueTimeUtil.getFreeSpeedUpTime(self.itemType, self.speedType, self.queue)
end
function commonSpeedUpBestViewPanel:onOkClick()
	SoraDPlaySound()
	if self.realTime and self.realTime > self.needTime + self.freeTime then
		local dailyRemindManager = include("dailyRemindManager")
		local rtype = dailyRemindManager.REMIND_TYPE.commonSpeedUpBest
		if dailyRemindManager.checkNeedRemind(rtype) then
			_ENV = nil
			;(nil).content = i18n("common_text_1435")
			;(nil).confirmFunc = function()
				queueCtrl:speedUpQueueReq(self.speedType, SPEEDUP_TYPE.TOOLS, self.retData)
				if self.close then
					self:close()
				end
			end
			;(nil).remindString = i18n("coffeeCraftsman_text_27")
			;(nil).remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(rtype)
				end
			end
			uiManager:show("MessageBox", nil)
		else
			queueCtrl:speedUpQueueReq(self.speedType, SPEEDUP_TYPE.TOOLS, self.retData)
			self:close()
		end
	else
		queueCtrl:speedUpQueueReq(self.speedType, SPEEDUP_TYPE.TOOLS, self.retData)
		self:close()
	end
end
return commonSpeedUpBestViewPanel

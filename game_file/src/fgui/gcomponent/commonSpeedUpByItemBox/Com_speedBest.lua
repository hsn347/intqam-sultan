local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_speedBest = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://commonSpeedUpByItemBox/Com_speedBest", Com_speedBest)
function Com_speedBest:onInit()
	self.retData, _ENV, self.itemData, _ENV, self.totalVal = nil, nil, nil, nil, 0
	self.freeTime = 0
	self.isFirst = true
	self.isFree = false
	self.fields.Btn_use:setString(i18n("quick_use_01"))
	self.fields.Btn_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Text_look:setString(i18n("common_text_829"))
	self.fields.Text_look:setTouchEnabled(true)
	self.fields.Text_look:addClickListener(handler(self, self.btnLookClick))
	self:fixChildrenPos()
	self.fields.n2:fix()
end
function Com_speedBest:onShow()
end
function Com_speedBest:initData(_type, _itemType, _queue, _parent, _isForce)
	self.isFirst = true
	self.type = _type
	self.itemType = _itemType
	self.queue = _queue
	self.parent = _parent
	self._isForce = _isForce
	self.totalVal = 0
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
	self:showQueue()
end
function Com_speedBest:getFreeTime()
	local queueTimeUtil = include("queueTimeUtil")
	return queueTimeUtil.getFreeSpeedUpTime(self.itemType, self.type, self.queue)
end
function Com_speedBest:showQueue()
	if self._isForce then
		self:openTimeUp()
	end
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function Com_speedBest:closeQueue()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function Com_speedBest:chooseBest()
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
function Com_speedBest:openTimeUp(dt)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	local needTime = leftTime - self.freeTime
	self.needTime = needTime
	self.isFree = false
	if needTime <= 0 then
		self.isFree = true
		self.fields.Btn_use:setString(i18n("common_text_049"))
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
		_ENV = i18n("common_text_049")
		i18n("common_text_049").time = SoraDConvertSecondToString(realTime)
		self.fields.Text_name:setString(i18n("accelerate_text_008", i18n("common_text_049")))
	end
end
function Com_speedBest:btnUseClick()
	SoraDPlaySound()
	if self.isFree then
		queueCtrl:speedUpQueueReq(tonumber(self.queue.qtype), SPEEDUP_TYPE.FREE)
	else
		_ENV = SPEEDUP_TYPE.FREE
		SPEEDUP_TYPE.FREE.speedType = self.type
		SPEEDUP_TYPE.FREE.itemType = self.itemType
		uiManager:show("commonSpeedUpBestView", SPEEDUP_TYPE.FREE)
	end
end
function Com_speedBest:btnLookClick()
	SoraDPlaySound()
	if self.isFree then
		queueCtrl:speedUpQueueReq(tonumber(self.queue.qtype), SPEEDUP_TYPE.FREE)
	else
		_ENV = SPEEDUP_TYPE.FREE
		SPEEDUP_TYPE.FREE.speedType = self.type
		SPEEDUP_TYPE.FREE.itemType = self.itemType
		uiManager:show("commonSpeedUpBestView", SPEEDUP_TYPE.FREE)
	end
end
function Com_speedBest:getBtnUse()
	return self.fields.Btn_use
end
return Com_speedBest

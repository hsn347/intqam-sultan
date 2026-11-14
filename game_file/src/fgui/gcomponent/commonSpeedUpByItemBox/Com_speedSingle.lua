local publicRead = include("publicRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local heroTrainGroundCtrl = SoraDGetCtrl("heroTrainGroundCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_speedSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://commonSpeedUpByItemBox/Com_speedSingle", Com_speedSingle)
function Com_speedSingle:onInit()
	self.fields.Btn_use:setString(i18n("common_text_314"))
	self.fields.Btn_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Com_item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_own:fixPos()
	self.fields.Btn_use:fixPos()
end
function Com_speedSingle:onShow()
end
function Com_speedSingle:initData(data, queueType, itemType, parent, position)
	self.data = data
	self.queueType = queueType
	self.itemType = itemType
	self.parent = parent
	self.position = position
	self.fields.Com_item:initData(self.data.id)
	self.fields.Text_name:setString(publicRead.getName(self.data.id))
	publicRead = publicRead.getName(self.data.id)
	publicRead.getName(self.data.id).count = self.data.count
	self.fields.Text_own:setString(i18n("common_text_1377", publicRead.getName(self.data.id)))
end
function Com_speedSingle:getFreeTime(queue)
	local queueTimeUtil = include("queueTimeUtil")
	return queueTimeUtil.getFreeSpeedUpTime(self.itemType, self.queueType, queue)
end
function Com_speedSingle:btnUseClick()
	SoraDPlaySound()
	local leftTime = 0
	local freeTime = 0
	if self.position then
		local _cur, _total = heroTrainGroundCtrl:getPositionTrainTime(self.position)
		leftTime = _cur
	else
		local queue = queueCtrl:queryQueue(self.queueType)
		if queue == nil then
			return
		end
		leftTime = queue.timerNode.timer:getRemainTime()
		freeTime = self:getFreeTime(queue)
	end
	local result = backpackltCtrl:getResult(self.data.id)
	local bestCount = math.min(math.ceil((leftTime - freeTime) / result.value), self.data.count)
	bestCount = math.max(bestCount, 1)
	_ENV, _ENV = nil, nil
	;(nil).id = self.data.id
	;(nil).count = bestCount
	;(nil).itemData, (nil).bestNum = nil, bestCount
	;(nil).handle = handler(self, self.sureUse)
	uiManager:show("newItemSingleUse", nil)
end
function Com_speedSingle:sureUse(target, data)
	SoraDShowLoading(self.parent)
	if self.position then
		heroTrainGroundCtrl:speedUpReq(self.position, data.id, data.num)
	else
		_ENV, _ENV = nil, data.num
		;(nil).id = data.id
		data.num[1], (nil).count = nil, data.num
		queueCtrl:speedUpQueueReq(self.queueType, SPEEDUP_TYPE.TOOLS, data.num)
	end
end
return Com_speedSingle

local baseComponent = require("fgui.base.baseComponent")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local Buttton_speedUp = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLamp/Buttton_speedUp", Buttton_speedUp)
function Buttton_speedUp:onInit()
	self:fixChildrenPos()
	self:addClickEventListener(handler(self, self.onSpeedClick))
end
function Buttton_speedUp:onShow()
end
function Buttton_speedUp:updateTimer(queueType)
	self.queue = queueCtrl:queryQueue(queueType)
	self:setVisible(self.queue ~= nil)
	if self.queue == nil then
		self.fields.label_timer:endTime()
	else
		self.fields.label_timer:beginTime(self.queue.timerNode.timer:getRemainTime())
	end
end
function Buttton_speedUp:onSpeedClick()
	SoraDPlaySound()
	local queue = self.queue
	if queue == nil then
		return
	end
	local speedUpItemList = backpackCtrl:getSpeedUpItemList(queue.qtype)
	if 0 < #speedUpItemList then
		SoraDShowSpeedUpByItemBox(queue.qtype)
	else
		SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
	end
end
return Buttton_speedUp

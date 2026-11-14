local manorTechRead = include("manorTechRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_studying = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorTech/Com_studying", Com_studying)
function Com_studying:onInit()
	self.fields.Button_detail:setTitle(i18n("common_text_059"))
	self.fields.Button_detail:addClickListener(handler(self, self.onClick_Button_detail))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_studying:onShow()
end
function Com_studying:initData(queue)
	self.queue = queue
	self.techID = tonumber(self.queue.technologyID)
	self.fields.com_tech:initShow(self.techID, true)
	local cfg = manorTechRead.getTechShowCfg(self.techID)
	self.fields.Text_techName:setString(i18n(cfg.techName))
	local queueData = queueCtrl:queryQueue(gQueueTypeDef.garden_technology)
	local leftTime = queueData.timerNode.timer:getRemainTime()
	self.fields.bar:setTime(leftTime, queueData.totaltime, true)
end
function Com_studying:onClick_Button_detail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("ManorTechDetail", nil)
end
return Com_studying

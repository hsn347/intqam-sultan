local queueCtrl = SoraDGetCtrl("queueCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ManorCityCoolingTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/ManorCityCoolingTip", ManorCityCoolingTip)
function ManorCityCoolingTip:onInit()
	self.fields.bar:hideTitle()
	self.fields.bar:showLabelTime()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function ManorCityCoolingTip:onShow()
end
function ManorCityCoolingTip:initData(queueType)
	self.queueType = queueType
	if self.queueType == gQueueTypeDef.garden_build_upgrade then
		self.fields.Text_tip:setString(i18n("common_text_056"))
		self.fields.Image_icon:setURL("icon_main_build_03.png")
	elseif self.queueType == gQueueTypeDef.garden_technology then
		self.fields.Text_tip:setString(i18n("common_text_062"))
		self.fields.Image_icon:setURL("icon_main_build_05.png")
		local queue = technologyCtrl:studyingTechnology(self.queueType)
		if queue then
			local technologyID = tonumber(queue.technologyID)
			if technologyID then
				local manorTechRead = include("manorTechRead")
				local cfg = manorTechRead.getTechShowCfg(technologyID)
				self.fields.Text_tip:setString(i18n(cfg.techName))
			end
		end
	end
	self:beginCooling()
end
function ManorCityCoolingTip:getQueue()
	return queueCtrl:queryQueue(self.queueType)
end
function ManorCityCoolingTip:beginCooling()
	local queue = self:getQueue()
	if not queue then
		return
	end
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function ManorCityCoolingTip:updateTime()
	local queue = self:getQueue()
	if not queue then
		return
	end
	local totalTime = queue.ottime or queue.totaltime
	local remainTime = queue.timerNode.timer:getRemainTime()
	self.fields.bar:setLabelTimeStr(SoraDConvertSecondToString(remainTime))
	self.fields.bar:setMax(totalTime)
	self.fields.bar:setValue(totalTime - remainTime)
end
return ManorCityCoolingTip

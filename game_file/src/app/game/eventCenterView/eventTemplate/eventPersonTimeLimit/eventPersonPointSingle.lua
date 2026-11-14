local eventPersonPointSingle = class("eventPersonPointSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventPersonPointSingle")
	end
	return target
end)
function eventPersonPointSingle:ctor()
	self.text_des = SoraDGetChildByName(self, "Text_des")
	self.text_addPoint = SoraDGetChildByName(self, "Text_addPoint")
	self.icon_soldier = SoraDGetChildByName(self, "img_soldier")
end
function eventPersonPointSingle:initData(config)
	local str = ""
	if config.eventType == gPersonLimitedTimeType.TRAIN_SOLDIERS then
		_ENV = nil
		;(nil).count = 1
		;(nil).level = config.condition
		str = i18n("limitactivities_eventtitle_11", nil)
	elseif config.eventType == gPersonLimitedTimeType.TECHNOLOGY_POWER then
		_ENV = nil
		;(nil).count = 1
		str = i18n("limitactivities_eventtitle_09", nil)
	elseif config.eventType == gPersonLimitedTimeType.BUILDDING_POWER then
		_ENV = nil
		;(nil).count = 1
		str = i18n("limitactivities_eventtitle_08", nil)
	end
	self.text_des:setString(config.taskDes or str)
	self.text_addPoint:setString("+" .. config.point)
end
return eventPersonPointSingle

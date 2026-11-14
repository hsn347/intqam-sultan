local worldMapRadianceProtect = class("worldMapRadianceProtect", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapRadianceProtect")
	end
	return target
end)
function worldMapRadianceProtect:ctor()
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
	end)
	self.Text_tips = SoraDGetChildByName(self, "Text_title")
end
function worldMapRadianceProtect:beginTime(time, isProtect)
	self:setVisible(true)
	self.txtTime:beginTime(time)
	self.Text_tips:setString(i18n("common_text_690"))
end
function worldMapRadianceProtect:endTime()
	self.txtTime:endTime()
	self:setVisible(false)
end
return worldMapRadianceProtect

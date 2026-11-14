local baseComponent = require("fgui.base.baseComponent")
local Com_mileageSign = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Com_mileageSign", Com_mileageSign)
function Com_mileageSign:onInit()
	if SoraDGetDefaultLanguage() ~= "ar" then
		local tmp = self.fields.day1:getPositionX()
		self.fields.day1:setPositionX(self.fields.day3:getPositionX())
		self.fields.day3:setPositionX(tmp)
		tmp = self.fields.day7:getPositionX()
		self.fields.day7:setPositionX(self.fields.day4:getPositionX())
		self.fields.day4:setPositionX(tmp)
		tmp = self.fields.day6:getPositionX()
		self.fields.day6:setPositionX(self.fields.day5:getPositionX())
		self.fields.day5:setPositionX(tmp)
	end
	self:initData()
end
function Com_mileageSign:initData()
	for i = 1, 7 do
		self.fields["day" .. i]:initData(i)
	end
end
function Com_mileageSign:onShow()
end
return Com_mileageSign

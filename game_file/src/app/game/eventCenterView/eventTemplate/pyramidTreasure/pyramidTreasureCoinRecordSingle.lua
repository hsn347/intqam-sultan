local publicRead = include("publicRead")
local pyramidTreasureCoinRecordSingle = class("pyramidTreasureCoinRecordSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("tradeBoardRecordsSingle")
	end
	return target
end)
function pyramidTreasureCoinRecordSingle:ctor()
	self.Text_single = SoraDGetChildByName(self, "Text_single")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
end
function pyramidTreasureCoinRecordSingle:initData(data)
	dump(data, "data", 10)
	_ENV = "data"
	;("data").num = data[1] or 1
	local timestr = i18n("Pyramid_treasure_text_11", "data")
	self.Text_time:setString(timestr)
	_ENV = timestr
	timestr.num = data[2] or 0
	local str = i18n("Pyramid_treasure_text_12", timestr)
	self.Text_single:setString(str)
	local color = cc.c3b(0, 190, 30)
	self.Text_single:setColor(color)
end
return pyramidTreasureCoinRecordSingle

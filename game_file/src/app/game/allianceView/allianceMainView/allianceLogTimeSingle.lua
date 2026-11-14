local AllianceLogTimeSingle = class("allianceLogTimeSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceLogTimeSingle")
	end
	return target
end)
function AllianceLogTimeSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.labelTime = SoraDGetChildByName(self, "Text_time")
end
function AllianceLogTimeSingle:initData(singleData)
	self.tableSingleData = singleData.time
	self.labelTime:setString(self.tableSingleData)
end
function AllianceLogTimeSingle:getSingleH()
	return self.labelTime:getContentSize().height + 10
end
function AllianceLogTimeSingle:setScroll(scroll)
end
function AllianceLogTimeSingle:setTouchEventCallBack(handle)
end
return AllianceLogTimeSingle

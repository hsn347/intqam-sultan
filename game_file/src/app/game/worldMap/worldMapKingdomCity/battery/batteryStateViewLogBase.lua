local GridScrollView = include("GridScrollView")
local batteryStateViewLogBase = class("batteryStateViewLogBase", function(target)
	return target
end)
function batteryStateViewLogBase:ctor()
	self.logData, _ENV = nil, nil
	self.nextIndex = 1
	self.hasMore = true
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtWarn:setVisible(false)
	self.scroll = GridScrollView.new(self.scroll)
end
function batteryStateViewLogBase:initData(argList)

local baseComponent = require("fgui.base.baseComponent")
local Com_baseInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_baseInfo", Com_baseInfo)
function Com_baseInfo:onInit()
	self:fixChildrenPos()
	self.fields.Button_info:addClickListener(handler(self, self.onClick))
end
function Com_baseInfo:onShow()
end
function Com_baseInfo:initData(armyID, bid, trainType)
	self.armyID = armyID
	self.bid = bid
	self.trainType = trainType
	for i = 1, 3 do
		self.fields["n" .. i]:initData(self.bid, self.armyID, self.trainType, i)
	end
end
function Com_baseInfo:onClick()
	SoraDPlaySound()
	_ENV, _ENV = nil, nil
	;(nil).bid = self.bid
	_ENV, (nil).type = self.trainType, self.trainType
	;(nil).armyData, (nil).armyData, self.trainType.armyid = nil, self.trainType, self.armyID
	uiManager:show("soldiersDetailView", nil)
end
return Com_baseInfo

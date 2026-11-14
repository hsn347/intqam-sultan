local baseComponent = require("fgui.base.baseComponent")
local Com_baseInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001621/Com_baseInfo", Com_baseInfo)
function Com_baseInfo:onInit()
	self.fields.n1:fixPos()
	self.fields.n2:fixPos()
	self.fields.n3:fixPos()
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
	_ENV = nil
	;(nil).content = i18n("Army_subtidy_text_01")
	uiManager:show("RuleView", nil)
end
return Com_baseInfo

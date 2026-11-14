local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisTreasurePrePanel = class("AtlantisTreasurePrePanel", baseFguiPanel)
function AtlantisTreasurePrePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisTreasurePrePanel:ctor", self.viewName)
end
function AtlantisTreasurePrePanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function AtlantisTreasurePrePanel:onInit()
	print("=======AtlantisTreasurePrePanel:onInit")
	self.fields.Com_title:initData(i18n("atlantiswar_text_0366"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_des:setString(i18n("atlantiswar_text_0368"))
	for treasureType = 1, 3 do
		local Text_treasure = self.fields["Text_treasure" .. treasureType]
		Text_treasure:setString(atlantisActivityCtrl:getTreasureName(treasureType))
		local Load_treasure = self.fields["Load_treasure" .. treasureType]
		Load_treasure:setTag(treasureType)
		Load_treasure:addClickListener(handler(self, self.onClickTreasure))
	end
end
function AtlantisTreasurePrePanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("atlantiswar_text_0367")
	uiManager:show("RuleView", nil)
end
function AtlantisTreasurePrePanel:onShow()
	print("=======AtlantisTreasurePrePanel:onShow")
end
function AtlantisTreasurePrePanel:onClickTreasure(EventContext)
	SoraDPlaySound()
	local treasureType = EventContext:getSender():getTag()
	_ENV = nil
	;(nil).treasureType = treasureType
	uiManager:show("AtlantisTreasureReward", nil)
end
return AtlantisTreasurePrePanel

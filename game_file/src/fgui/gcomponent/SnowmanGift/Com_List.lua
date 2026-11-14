local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_List = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SnowmanGift/Com_List", Com_List)
function Com_List:onInit()
	self:fixChildrenPos()
end
function Com_List:onShow()
	for i = 1, 7 do
		local item = self.fields[string.format("day%d", i)]
		item:initData(i)
		item:addClickEventListener(handlerEx(self, self.onClickDayBox, i))
	end
end
function Com_List:onClickDayBox(day)
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 2
	;(nil).day = day
	uiManager:show("SnowmanGiftBoxReward", nil)
end
function Com_List:updateView()
	for i = 1, 7 do
		local item = self.fields[string.format("day%d", i)]
		item:updateData()
	end
end
return Com_List

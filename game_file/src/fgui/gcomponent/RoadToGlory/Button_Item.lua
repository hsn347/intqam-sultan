local baseComponent = require("fgui.base.baseComponent")
local publicUtil = include("publicUtil")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local Button_Item = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoadToGlory/Button_Item", Button_Item)
function Button_Item:onInit()
	self:addClickListener(handler(self, self.clickBoxBtn))
end
function Button_Item:onShow()
end
function Button_Item:initData(itemID)
	self.itemID = itemID
	self:itemChange()
end
function Button_Item:itemChange()
	local num = publicUtil.getCount(self.itemID)
	publicUtil = nil
	;(nil).num = string.formatnumberthousands(num)
	self.fields.text_Num:setString(i18n("common_text_531", nil))
	self:canExchange()
end
function Button_Item:canExchange()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY) then
		local ret, _ = newExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY)
		self:setReddot(ret)
	end
end
function Button_Item:clickBoxBtn()
	SoraDPlaySound()
	uiManager:show("roadToGloryPopView")
end
return Button_Item

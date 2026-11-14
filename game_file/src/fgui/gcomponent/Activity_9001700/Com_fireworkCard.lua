local activity_9001700_Read = include("activity_9001700_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_fireworkCard = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001700/Com_fireworkCard", Com_fireworkCard)
function Com_fireworkCard:onInit()
	self.fields.Button_make:setString(i18n("common_btn_20"))
	self.fields.Button_make:addClickListener(handler(self, self.onClickBtnMake))
end
function Com_fireworkCard:onShow()
end
function Com_fireworkCard:initData(fireType)
	self.fireType = fireType
	self.itemID = activity_9001700_Read.getDrawingCostItemID(self.fireType)
	if self.fireType == 1 then
		self.fields.title:setString(i18n("eid_fireworks_006"))
	else
		self.fields.title:setString(i18n("eid_fireworks_005"))
	end
	self:updateItemCount()
end
function Com_fireworkCard:onClickBtnMake()
	SoraDPlaySound()
	if self.itemCount <= 0 then
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	_ENV = nil
	;(nil).fireType = self.fireType
	uiManager:show("Activity_9001700_Make", nil)
end
function Com_fireworkCard:updateItemCount(...)
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	self.itemCount = itemCount
	self.fields.Text_num:setString("x" .. string.formatnumberthousands(itemCount))
end
function Com_fireworkCard:updateBtnMake(...)
	local ret = activity_9001700_Ctrl:getFireWorksRedNumByFireType(self.fireType)
	self.fields.Button_make:setReddot(ret)
end
return Com_fireworkCard

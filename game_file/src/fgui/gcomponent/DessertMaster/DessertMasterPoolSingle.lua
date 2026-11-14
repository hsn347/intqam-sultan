local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local baseComponent = require("fgui.base.baseComponent")
local DessertMasterPoolSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DessertMaster/DessertMasterPoolSingle", DessertMasterPoolSingle)
function DessertMasterPoolSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_change:addClickListener(handler(self, self.onclickChange))
	self.fields.Item:setClickCallback(handler(self, self.onClickItem))
end
function DessertMasterPoolSingle:openChoose()
	SoraDPlaySound()
	_ENV = nil
	;(nil).pool = self.index
	uiManager:show("DessertMasterPoolSave", nil)
end
function DessertMasterPoolSingle:onClickItem()
	self:openChoose()
end
function DessertMasterPoolSingle:onClickAdd()
	self:openChoose()
end
function DessertMasterPoolSingle:onclickChange()
	self:openChoose()
end
function DessertMasterPoolSingle:onShow()
end
function DessertMasterPoolSingle:initData(index)
	self.index = index
	self.fields.Line_1:setVisible(index ~= 1)
	self.fields.Line_2:setVisible(index ~= 1)
	self.fields.Com_coffee:initData(index)
	local itemId = coffeeCraftsmanCtrl:getPoolMapItemID(index)
	if 0 < itemId then
		local itemCount = coffeeCraftsmanCtrl:getPoolMapItemCount(index)
		self.fields.Item:initData(itemId, itemCount)
	end
	self.controllers.Ctrl_status:setSelectedIndex(0 < itemId and 0 or 1)
end
return DessertMasterPoolSingle

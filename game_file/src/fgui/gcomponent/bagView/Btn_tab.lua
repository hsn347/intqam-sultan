local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_tab = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://bagView/Btn_tab", Btn_tab)
fgui.register_extension("ui://bagView/Btn_tab2", Btn_tab)
function Btn_tab:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.n2:fixPos()
end
function Btn_tab:onShow()
end
function Btn_tab:setClassType(cType)
	self.cType = cType
end
function Btn_tab:getClassType()
	return self.cType
end
function Btn_tab:setSelected(tag)
	self.controllers.c1:setSelectedIndex(tag == self:getTag() and 1 or 0)
end
function Btn_tab:setNew()
	self.controllers.c2:setSelectedIndex(table.nums(backpackCtrl:getNewItemInfoByType(self:getClassType())) > 0 and 1 or 0)
end
function Btn_tab:setNewVisible(ret)
	self.controllers.c2:setSelectedIndex(ret and 1 or 0)
end
function Btn_tab:setTabClickCallback(callback)
	self.tabClickCallback = callback
end
function Btn_tab:onBtnClick()
	SoraDPlaySound()
	if self.tabClickCallback then
		self.tabClickCallback(self:getTag())
	end
end
return Btn_tab

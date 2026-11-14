local baseComponent = require("fgui.base.baseComponent")
local Com_shelvesSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanMarket/Com_shelvesSingle", Com_shelvesSingle)
function Com_shelvesSingle:onInit()
end
function Com_shelvesSingle:initData(index, btnHandle, data1, data2)
	self.fields.Com_item1:initData(index, data1, btnHandle)
	self.fields.bar_left:setVisible(data1.curActive < data1.activeNum)
	self:setActiveString(data1, self.fields.Text_active_left)
	if data2 then
		self.fields.bar_right:setVisible(data2.curActive < data2.activeNum)
		self:setActiveString(data1, self.fields.Text_active_right)
		self.fields.Com_item2:initData(index, data2, btnHandle)
	else
		self.fields.Com_item2:setVisible(false)
	end
end
function Com_shelvesSingle:setActiveString(data, comp)
	if data.curActive < data.activeNum then
		_ENV = nil
		;(nil).num = data.curActive
		;(nil).neednum = data.activeNum
		comp:setString(i18n("ramddantent_text_02", nil))
		comp:setVisible(true)
	else
		comp:setVisible(false)
	end
end
function Com_shelvesSingle:onShow()
end
return Com_shelvesSingle

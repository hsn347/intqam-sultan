local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_selectSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RamadanSurprise/Com_selectSingle", Com_selectSingle)
function Com_selectSingle:onInit()
	self:fixChildrenPos()
	self:addClickListener(handler(self, self.onClickSelect))
end
function Com_selectSingle:initData(index, data, btnHandle)
	self.fields.Image_bg:setVisible(bit.band(index, 1) == 0 and true or false)
	self.index = index
	self.btnHandle = btnHandle
	self.fields.Com_item:initData(data.id, data.count)
	self.fields.title:setString(publicRead.getName(data.id))
end
function Com_selectSingle:onClickSelect()
	self.btnHandle(self.index)
end
function Com_selectSingle:onShow()
end
return Com_selectSingle

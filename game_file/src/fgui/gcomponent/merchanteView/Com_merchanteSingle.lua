local publicRead = include("publicRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local storesCtrl = SoraDGetCtrl("storesCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_merchanteSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://merchanteView/Com_merchanteSingle", Com_merchanteSingle)
function Com_merchanteSingle:onInit()
end
function Com_merchanteSingle:onShow()
end
function Com_merchanteSingle:initData(data, parent)
	self.parent = parent
	self.fields.single:initData(data, self.parent, self)
end
function Com_merchanteSingle:refreshMyData(newData, useAction)
	if useAction then
		self.fields.single:overTurnAction(newData, self.parent, self)
	else
		self.fields.single:initData(newData, self.parent, self)
	end
end
function Com_merchanteSingle:getData()
	return self.fields.single:getData()
end
return Com_merchanteSingle

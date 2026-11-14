local baseComponent = require("fgui.base.baseComponent")
local Com_equipSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_equipSingle", Com_equipSingle)
function Com_equipSingle:onInit()
end
function Com_equipSingle:onShow()
end
function Com_equipSingle:initData(data, index, selectIndex)
	if data.isEmpty then
		self.isEmpty = true
		self:setVisible(false)
	else
		self.isEmpty = false
		self.fields.single:initData(data, index, selectIndex)
	end
end
function Com_equipSingle:setRatio(ratio)
	self.ratio = ratio
	self.fields.single:setScale(ratio)
	self:setAlpha(ratio < 0.9 and ratio * 0.8 or ratio)
end
function Com_equipSingle:getRatio()
	return self.ratio
end
function Com_equipSingle:isEmptyCom()
	return self.isEmpty
end
return Com_equipSingle

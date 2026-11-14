local baseComponent = require("fgui.base.baseComponent")
local Com_army = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_army", Com_army)
function Com_army:onInit()
	self.ratio = 1
	self.isEmpty = false
end
function Com_army:onShow()
end
function Com_army:initData(data, index, selectIndex)
	if data.isEmpty then
		self.isEmpty = true
		self.fields.single:setVisible(false)
	else
		self.isEmpty = false
		self.fields.single:setVisible(true)
		self.fields.single:initData(data, index, selectIndex)
	end
end
function Com_army:setRatio(ratio)
	self.ratio = ratio
	self.fields.single:setScale(ratio)
	self.fields.single:setAlpha(ratio < 0.9 and ratio * 0.8 or ratio)
end
function Com_army:getRatio()
	return self.ratio
end
function Com_army:isEmptyCom()
	return self.isEmpty
end
return Com_army

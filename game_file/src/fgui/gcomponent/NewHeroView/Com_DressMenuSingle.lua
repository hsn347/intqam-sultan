local baseComponent = require("fgui.base.baseComponent")
local Com_DressMenuSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_DressMenuSingle", Com_DressMenuSingle)
function Com_DressMenuSingle:onInit()
	self.fields.single:addClickListener(handler(self, self.onClickItem))
end
function Com_DressMenuSingle:onShow()
end
function Com_DressMenuSingle:initData(dressID, index)
	self.isEmpty = false
	if tolua.type(dressID) == "table" then
		self:setVisible(false)
		self.isEmpty = true
		self.index = nil
		return
	end
	self.index = index
	self.fields.single:initData(dressID)
end
function Com_DressMenuSingle:setRatio(ratio)
	self.ratio = ratio
	ratio = ratio < 0.75 and 0.75 or ratio
	self.fields.single:setScale(ratio)
	self.fields.single:setPositionY(267.5 - math.sqrt(25760.25 - (1 - ratio) / 0.75 * 214 * (1 - ratio) / 0.75 * 214))
end
function Com_DressMenuSingle:getRatio()
	return self.ratio
end
function Com_DressMenuSingle:isEmptyCom()
	return self.isEmpty
end
function Com_DressMenuSingle:setMyHandle(handle)
	self.handle = handle
end
function Com_DressMenuSingle:onClickItem()
	if self.index and self.handle then
		self.handle(self.index)
	end
end
return Com_DressMenuSingle

local baseComponent = require("fgui.base.baseComponent")
local Com_SkinBuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_SkinBuffSingle", Com_SkinBuffSingle)
function Com_SkinBuffSingle:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRender))
end
function Com_SkinBuffSingle:onShow()
end
function Com_SkinBuffSingle:initData(info)
	self.fields.title:setString(info.title)
	self.buffList = info.buffInfo
	self.isLight = info.isLight
	self.fields.list:setNumItems(#self.buffList)
	self.fields.list:resizeToFit(#self.buffList)
end
function Com_SkinBuffSingle:onItemRender(index, target)
	target:initData(self.buffList[index + 1], self.isLight)
end
return Com_SkinBuffSingle

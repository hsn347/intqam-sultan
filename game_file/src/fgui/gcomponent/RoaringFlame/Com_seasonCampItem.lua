local baseComponent = require("fgui.base.baseComponent")
local Com_seasonCampItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_seasonCampItem", Com_seasonCampItem)
function Com_seasonCampItem:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_seasonCampItem:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function Com_seasonCampItem:onShow()
end
function Com_seasonCampItem:initData(data, index)
	self.rankList = data
	_ENV = nil
	;(nil).num = index
	self.fields.Label_title:setString(i18n("flames_dunes_text311", nil))
	self.fields.List:setNumItems(#self.rankList)
	self.fields.List:setHeight(#self.rankList * 110)
end
return Com_seasonCampItem

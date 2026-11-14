local baseComponent = require("fgui.base.baseComponent")
local Com_weekCampItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_weekCampItem", Com_weekCampItem)
function Com_weekCampItem:onInit()
	_ENV = nil
	;(nil)[1] = i18n("flames_dunes_text28")
	;(nil)[2] = i18n("flames_dunes_text29")
	;(nil)[3] = i18n("flames_dunes_text30")
	self.titleCfg, (nil)[4] = nil, i18n("flames_dunes_text31")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_weekCampItem:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function Com_weekCampItem:onShow()
end
function Com_weekCampItem:initData(data, index)
	self.rankList = data
	self.fields.Label_title:setString(self.titleCfg[index])
	self.fields.List:setNumItems(#self.rankList)
	self.fields.List:setHeight(#self.rankList * 110)
end
return Com_weekCampItem

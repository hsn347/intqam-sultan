local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_DecreeGainPanel = class("RoaringFlame_DecreeGainPanel", baseFguiPanel)
function RoaringFlame_DecreeGainPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_DecreeGainPanel.super.ctor(self, ...)
	print("RoaringFlame_DecreeGainPanel:ctor", self.viewName)
end
function RoaringFlame_DecreeGainPanel:onInit()
	print("=======RoaringFlame_DecreeGainPanel:onInit")
	_ENV, _ENV = "=======RoaringFlame_DecreeGainPanel:onInit", print
	;("=======RoaringFlame_DecreeGainPanel:onInit").title = i18n("brightWar_text_202")
	;("=======RoaringFlame_DecreeGainPanel:onInit").icon = "icon_activity_9001611.png"
	;("=======RoaringFlame_DecreeGainPanel:onInit").tag = 1
	_ENV, print[1], ("=======RoaringFlame_DecreeGainPanel:onInit").jumpTag = "=======RoaringFlame_DecreeGainPanel:onInit", "=======RoaringFlame_DecreeGainPanel:onInit", 2
	;("=======RoaringFlame_DecreeGainPanel:onInit").title = i18n("summoned_text_28")
	;("=======RoaringFlame_DecreeGainPanel:onInit").icon = "icon_activity_9001611.png"
	;("=======RoaringFlame_DecreeGainPanel:onInit").tag = 2
	_ENV, print[2], ("=======RoaringFlame_DecreeGainPanel:onInit").jumpTag = "=======RoaringFlame_DecreeGainPanel:onInit", "=======RoaringFlame_DecreeGainPanel:onInit", 3
	;("=======RoaringFlame_DecreeGainPanel:onInit").title = i18n("flames_dunes_text18")
	;("=======RoaringFlame_DecreeGainPanel:onInit").icon = "icon_activity_exchange_01.png"
	self.getWayList, print[3], ("=======RoaringFlame_DecreeGainPanel:onInit").tag = print, "=======RoaringFlame_DecreeGainPanel:onInit", 3
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlame_DecreeGainPanel:onItemRenderer(index, obj)
	obj:initData(self.getWayList[index + 1], self)
end
function RoaringFlame_DecreeGainPanel:endShow()
	print("=======RoaringFlame_DecreeGainPanel:endShow")
	self.fields.List:setNumItems(#self.getWayList)
end
return RoaringFlame_DecreeGainPanel

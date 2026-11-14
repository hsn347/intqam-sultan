local baseProxy = require("fgui.base.baseProxy")
local MaterialFactoryProxy = class("MaterialFactoryProxy", baseProxy)
function MaterialFactoryProxy:onRegisterEvent()
	print("=======MaterialFactoryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateQuality))
	SoraDAddMessage(self, "MESSAGE_SERVER_MATERIAL_FACTORY_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_MATERIAL_FACTORY_PRESS", handler(self, self.showTouch))
	SoraDAddMessage(self, "MESSAGE_UI_MATERIAL_FACTORY_GUIDE_STAR", handler(self, self.showGuide))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_COLLECTITEMS", function(target, data)
		if data.items and data.items[1] and data.items[1].id and data.items[1].num then
			local panel = SoraDCreatePanel("animationGainItem")
			_ENV = nil
			;(nil).itemID = data.items[1].id
			;(nil).itemCount = data.items[1].num
			panel:initData(nil)
			panel:show()
		end
	end)
end
function MaterialFactoryProxy:updateQuality(target, data)
	self.view:updateQuality(false, true)
end
function MaterialFactoryProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function MaterialFactoryProxy:showTouch(target, data)
	self.view:showTouch(target, data)
end
function MaterialFactoryProxy:showGuide(target, data)
	self.view:showGuide(target, data)
end
return MaterialFactoryProxy

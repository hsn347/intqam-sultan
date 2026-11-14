local baseComponent = require("fgui.base.baseComponent")
local iphoneXBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/iphoneXBottom", iphoneXBottom)
function iphoneXBottom:onInit()
	self.blackCount = 0
	self.swallowCount = 0
	self.touchPanel = self.fields.Panel_bottom
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:setVisible(false)
end
function iphoneXBottom:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAIN_IPHONEX_UPDATE", handler(self, self.updateView))
end
function iphoneXBottom:onShow()
	if device.platform ~= "ios" then
		self:setSize(cc.size(display.width, display.iPhoneXBottom))
		self.controllers.c1:setSelectedIndex(1)
	end
end
function iphoneXBottom:updateView(target, data)
	if device.platform ~= "ios" then
		return
	end
	self.blackCount = 0
	self.swallowCount = 0
	if data.onEnter then
		self.blackCount = 1
		self.swallowCount = 1
		if data.opacity then
			self.touchPanel:setAlpha(data.opacity / 255)
		else
			self.touchPanel:setAlpha(0.3137254901960784)
		end
	else
		local topPanel = SoraDCurrentTopPanelFromManager()
		if topPanel and topPanel.isTranslucentView then
			if topPanel:isVisible() then
				self.blackCount = 1
				self.touchPanel:setAlpha(topPanel:getBackGroundColorOpacity() / 255)
			end
			self.swallowCount = 1
		end
	end
	self.touchPanel:setVisible(self.blackCount > 0)
	self:setSwallowTouches(0 >= self.swallowCount)
end
return iphoneXBottom

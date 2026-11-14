local IphoneXBottom = class("iphoneXBottom", function(target)
	if target == nil then
		return SoraDCreateBasePanel("iphoneXBottom")
	end
	return target
end)
function IphoneXBottom:ctor()
	self.blackCount = 0
	self.swallowCount = 0
	self.touchPanel = SoraDGetChildByName(self, "Panel_bottom")
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_MAIN_IPHONEX_UPDATE", handler(self, self.updateView))
	if device.platform ~= "ios" then
		local ccsView = self:getChildByName("ccsView")
		local controllers = fguiHelper.get_controllers(ccsView)
		ccsView:setSize(cc.size(display.width, display.iPhoneXBottom))
		controllers.c1:setSelectedIndex(1)
	end
end
function IphoneXBottom:updateView(target, data)
	self.blackCount = 0
	self.swallowCount = 0
	if data.onEnter then
		self.blackCount = 1
		self.swallowCount = 1
		if data.opacity then
			self.touchPanel:setBackGroundColorOpacity(data.opacity)
		else
			self.touchPanel:setBackGroundColorOpacity(80)
		end
	else
		local topPanel = SoraDCurrentTopPanelFromManager()
		if topPanel and topPanel.isTranslucentView then
			if topPanel:isVisible() then
				self.blackCount = 1
				self.touchPanel:setBackGroundColorOpacity(topPanel:getBackGroundColorOpacity())
			end
			self.swallowCount = 1
		end
	end
	self.touchPanel:setVisible(self.blackCount > 0)
	self:setSwallowTouches(0 >= self.swallowCount)
end
return IphoneXBottom

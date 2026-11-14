local baseComponent = require("fgui.base.baseComponent")
local Activity_9001619_Lamp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001619/Activity_9001619_Lamp", Activity_9001619_Lamp)
local activity_9001619_Read = include("activity_9001619_Read")
function Activity_9001619_Lamp:onInit()
	self.imgLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	if self.btnTouch then
		self.btnTouch:addTouchEventListener(handler(self, self.onClickTouch))
	end
	self.lampInfo, _ENV, self.index = self.btnTouch.addTouchEventListener, self.btnTouch.addTouchEventListener, 1
end
function Activity_9001619_Lamp:onShow()
end
local LAMP_DEAF_COLOR = 4
function Activity_9001619_Lamp:initView(index, data)

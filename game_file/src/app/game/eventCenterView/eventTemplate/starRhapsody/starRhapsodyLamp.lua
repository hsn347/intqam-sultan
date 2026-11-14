local starRhapsodyLamp = class("starRhapsodyLamp", function(target)
	if target == nil then
		return SoraDCreateBasePanel("starRhapsodyLamp")
	end
	return target
end)
local starRhapsodyUtil = include("starRhapsodyUtil")
function starRhapsodyLamp:ctor()
	self.nodeConter = SoraDGetChildByName(self, "Node_Conter_Ctrl")
	self.imgLamp = SoraDGetChildByName(self, "Image_lamp")
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	if self.btnTouch then
		self.btnTouch:addTouchEventListener(handler(self, self.onClickTouch))
	end
	self.isStar = starRhapsodyUtil.isStar()
	self.lampInfo, _ENV, self.index = starRhapsodyUtil.isStar(), starRhapsodyUtil.isStar(), 1
end
local LAMP_DEAF_COLOR = 4
function starRhapsodyLamp:initView(index, data)

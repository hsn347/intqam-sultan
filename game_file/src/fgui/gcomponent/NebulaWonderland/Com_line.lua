local baseComponent = require("fgui.base.baseComponent")
local Com_line = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWonderland/Com_line", Com_line)
function Com_line:onInit()
	self.fields.Ani_lineBottom:setAllFrameName("dh_xingyunqijingx__%02d.png", 0)
	self.fields.Ani_line:setAllFrameName("dh_xingyunqijingx__%02d.png", 0)
	self.fields.Ani_point:setAllFrameName("dh_xyqjxx_%02d.png", 1)
end
function Com_line:setStaticEffect(percent)
	self.fields.Com_lineSub:setWidth(self.fields.Ani_lineBottom:getWidth() * percent)
end
function Com_line:setDynamicEffect(index, percent)
	self.fields.Ani_line:stopAllActions()
	self.index = index
	local target = math.floor(self.fields.Ani_lineBottom:getWidth() * percent)
	local time = 0.5
	local startValue = self.fields.Com_lineSub:getWidth()
	fgui.GTween:to(startValue, target, time):onUpdate(function(tweener)
		self.fields.Com_lineSub:setWidth(tweener.value.x)
	end):setTarget(self):onComplete(function()
		if self.callBackHandle then
			self.callBackHandle(self.index + 1)
			self.callBackHandle = nil
			if percent == 1 then
				self.fields.Ani_point:setVisible(false)
			end
		end
	end)
end
function Com_line:setCallBack(backHanle)
	self.callBackHandle = backHanle
end
function Com_line:onShow()
end
return Com_line

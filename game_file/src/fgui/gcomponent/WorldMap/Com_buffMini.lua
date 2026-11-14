local baseComponent = require("fgui.base.baseComponent")
local Com_buffMini = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_buffMini", Com_buffMini)
function Com_buffMini:onInit()
	self:fixChildrenPos()
	self.fields.Bar:setScale(SoraDFIsRA() and -1 or 1)
end
function Com_buffMini:onShow()
end
function Com_buffMini:initData(data)
	local leftTime = data.endTime - serviceFunctions.systemTime()
	local totalTime = data.endTime - data.beginTime
	self.fields.Text_time:setTimeUpdateListener(function(tick)
		self.fields.Bar:setValue(tick)
	end)
	self.fields.Bar:setMax(totalTime)
	self.fields.Text_time:beginTime(leftTime)
end
return Com_buffMini

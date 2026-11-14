local baseComponent = require("fgui.base.baseComponent")
local Act_title = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://evilPalace/Act_title", Act_title)
function Act_title:onInit()
end
function Act_title:onShow()
end
function Act_title:setAction(showText, time, handle)
	self.fields.title:stopAllActions()
	self.fields.title:setString(showText)
	local bPosX = -self.fields.title:getWidth()
	local toPosX = self:getWidth()
	if not SoraDFIsRA() then
		bPosX = self:getWidth()
		toPosX = -self.fields.title:getWidth()
	end
	self.fields.title:setPositionX(bPosX)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveTo(time, toPosX, self.fields.title:getPositionY())
	;(nil)[2] = ffa.callFunc(function()
		handle()
	end)
	;(nil)[3] = ffa.callFunc(function()
		handle()
	end)
	;(nil)[4] = ffa.callFunc(function()
		handle()
	end)
	;(nil)[5] = ffa.callFunc(function()
		handle()
	end)
	self.fields.title:runAction(ffa.seq(nil))
end
return Act_title

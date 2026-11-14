local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTech_Progress = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTech_Progress", Com_NebulaTech_Progress)
function Com_NebulaTech_Progress:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_NebulaTech_Progress:onShow()
end
function Com_NebulaTech_Progress:initData(lastTime, percent)
	self:setPercent(percent)
	self.fields.title:setString(lastTime)
	local width = self:getSize().width - 12
	local posX = SoraDFIsRA() and width * (1 - percent) + 7 or width * percent + 6
	self.fields.light1:setPositionX(posX)
	self.fields.light2:setPositionX(posX)
end
return Com_NebulaTech_Progress

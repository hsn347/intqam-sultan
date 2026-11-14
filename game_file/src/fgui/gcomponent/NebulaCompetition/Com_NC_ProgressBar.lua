local baseComponent = require("fgui.base.baseComponent")
local Com_NC_ProgressBar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_NC_ProgressBar", Com_NC_ProgressBar)
function Com_NC_ProgressBar:onInit()
	if not SoraDFIsRA() then
		self.fields.blue_line:fix()
		self.fields.red_line:fix()
	end
	self.fields.bar:fix()
end
function Com_NC_ProgressBar:onShow()
	self.fields.ani_shine:setAllFrameName("dh_xmdk_add_D_%02d.png", 1)
	self.fields.ani_shine:setPlaySettings(0, -1, -1)
end
function Com_NC_ProgressBar:initData(curPercent)
	local realPercent = curPercent * 0.94 + 0.03
	local posX = 0
	if not SoraDFIsRA() then
		posX = self:getWidth() * realPercent
		self.fields.blue_line:setX(posX - 118)
		self.fields.red_line:setX(posX + 118)
	else
		posX = self:getWidth() - self:getWidth() * realPercent - 3
		self.fields.blue_line:setX(posX + 118)
		self.fields.red_line:setX(posX - 118)
	end
	self.fields.blue_line:setVisible(0.5 <= realPercent)
	self.fields.red_line:setVisible(realPercent <= 0.5)
	self.fields.ani_shine:setX(posX)
	self:setPercent(realPercent)
end
return Com_NC_ProgressBar

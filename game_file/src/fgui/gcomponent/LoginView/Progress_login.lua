local baseComponent = require("fgui.base.baseComponent")
local Progress_login = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://LoginView/Progress_login", Progress_login)
function Progress_login:onInit()
	self.proWidth = 517
	self.fields.ani:setAllFrameName("loading_luotuo_%.2d.png", 1)
	self.fields.mv_yw:setAllFrameName("dh_loadingjdt_%.2d.png", 1)
	self.fields.mv_l:setAllFrameName("dh_loadingjdt2_%.2d.png", 1)
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function Progress_login:onShow()
end
function Progress_login:setPercent(progressValue, str)
	if progressValue == 0 or progressValue == 100 then
		self:setValue(progressValue)
	else
		self:setValue(progressValue)
	end
	str = str and str or math.floor(progressValue) .. "%"
	self.fields.title:setString(str)
	local nowPos = self.proWidth * progressValue / 100.0
	if SoraDFIsRA() then
		self.fields.particleSp:setPositionX(5 + self.proWidth - nowPos)
		self.fields.ani:setPositionX(5 + self.proWidth - nowPos)
		self.fields.mv_yw:setPositionX(145 + self.proWidth - nowPos)
		self.fields.mv_l:setPositionX(28 + self.proWidth - nowPos)
		self.fields.com_w:setAnchorPoint(cc.p(1, 1))
		self.fields.com_w:setPosition(self.proWidth, -1)
		self.fields.com_w:setWidth(5 + nowPos)
	else
		self.fields.particleSp:setPositionX(nowPos - 5)
		self.fields.ani:setPositionX(nowPos - 5)
		self.fields.mv_yw:setPositionX(nowPos - 145)
		self.fields.mv_l:setPositionX(nowPos - 5 - 23)
		self.fields.com_w:setAnchorPoint(cc.p(0, 1))
		self.fields.com_w:setPosition(0, -1)
		self.fields.com_w:setWidth(nowPos - 5)
	end
end
return Progress_login

local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeProgressBar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeProgressBar", Com_decreeProgressBar)
function Com_decreeProgressBar:onInit()
	self:fixChildrenPos()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.icon:setURL("framer_xnbxsd_lv_01.png")
		self.controllers.c1:setSelectedIndex(1)
		self.fields.ProgressBar_Level:setPositionX(self.fields.Text_Level:getPositionX() + 10 + self.fields.Text_Level:getWidth())
	end
end
function Com_decreeProgressBar:setValue()
	local maxValue = radiantDecreeRead.getNextExp(radiantDecreeCtrl:getLevel(), radiantDecreeCtrl:getLevelIndex())
	self.fields.ProgressBar_Level:setValue(radiantDecreeCtrl:getExp(), maxValue)
	self.fields.Text_Level:setString(radiantDecreeCtrl:getLevel())
end
function Com_decreeProgressBar:onBtnClick()
end
function Com_decreeProgressBar:onShow()
end
return Com_decreeProgressBar

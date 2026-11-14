local baseComponent = require("fgui.base.baseComponent")
local Com_playerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_playerSingle", Com_playerSingle)
function Com_playerSingle:onInit()
	self.selfUid = SoraDGetPlayerID()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Com_castleLv:fixChildrenPos()
	end
end
function Com_playerSingle:onShow()
end
function Com_playerSingle:initData(data)
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	local lordLocalData = include("lordLocalData")
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.iconID))
	self.fields.Text_name:setString(data.nickName)
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	if self.selfUid == data.uid then
		self.fields.Text_name:setColor("#70C723")
	else
		self.fields.Text_name:setColor("#D7C39B")
	end
end
return Com_playerSingle

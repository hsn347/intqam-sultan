local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Com_memberSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_memberSingle", Com_memberSingle)
function Com_memberSingle:onInit()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
end
function Com_memberSingle:onShow()
end
function Com_memberSingle:initData(data, param)
	self.isKick = param and param.isKick or false
	self.fields.Text_name:setString(data.nickName)
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.headid))
	if self.isKick then
		local inWarMap = data.inWarMap or false
		self.fields.Text_online:setString(inWarMap and i18n("flames_dunes_text361") or i18n("flames_dunes_text362"))
		self.fields.Text_online:setColor(inWarMap and cc.c3b(112, 199, 35) or cc.c3b(134, 127, 111))
	else
		local isOnline = data.online and data.online == 0 or false
		self.fields.Text_online:setString(isOnline and i18n("common_text_224") or i18n("common_text_3976"))
		self.fields.Text_online:setColor(isOnline and cc.c3b(112, 199, 35) or cc.c3b(134, 127, 111))
	end
end
return Com_memberSingle

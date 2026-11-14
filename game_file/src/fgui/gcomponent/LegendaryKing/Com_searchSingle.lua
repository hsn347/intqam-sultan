local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://LegendaryKing/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self:fixChildrenPos()
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data)
	self.data = data
	self.fields.Image_portrait:setSpriteFrame(lordLocalData.getBust(self.data.headid))
	self.fields.Text_power:setString(string.formatnumberthousands(self.data.totalFc))
	self.fields.Text_name:setString(self.data.nickName)
	self.fields.Com_castleLv:setVisible(false)
	self.fields.Text_lastTime:setString(self.data.online == 0 and i18n("common_text_224") or SoraDConverSecondToDate(self.data.online, false, true))
	self.fields.Com_jinnBeastLv:initData(self.data)
end
return Com_searchSingle

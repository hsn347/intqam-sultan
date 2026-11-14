local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Country = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_Country", Com_Country)
function Com_Country:onInit()
	self.isCheck = false
end
function Com_Country:onShow()
end
function Com_Country:initData(data)
	self.optionid = data.optionid
	self.oddsid = data.oddsid
	local config = activity_9001734_Read.getCountryCfg(self.optionid)
	self.fields.icon:setIcon(config.flag)
	self.fields.text_name:setString(i18n(config.country))
	local oddsCfg = activity_9001734_Read.getOddsCfg(self.oddsid)
	local odds = tonumber(oddsCfg.odds)
	local oddsType = 0
	if 2 <= odds and odds <= 4 then
		oddsType = 1
	elseif 4 < odds then
		oddsType = 2
	end
	self.fields.text_odds:setString(odds)
	self.controllers.c1:setSelectedIndex(oddsType)
	self:setCheck(false)
end
function Com_Country:setCheck(isCheck)
	self.isCheck = isCheck
	self.controllers.c2:setSelectedIndex(self.isCheck and 1 or 0)
end
return Com_Country

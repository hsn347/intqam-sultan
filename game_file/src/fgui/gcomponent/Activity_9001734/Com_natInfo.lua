local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_natInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_natInfo", Com_natInfo)
function Com_natInfo:onInit()
	self.fields.Text_VS:setString("VS")
end
function Com_natInfo:onShow()
end
function Com_natInfo:initData(matchId)
	self.matchData = activity_9001734_Ctrl:getMatchData(matchId)
	if not self.matchData then
		return
	end
	local config1 = activity_9001734_Read.getCountryCfg(self.matchData.team1)
	local config2 = activity_9001734_Read.getCountryCfg(self.matchData.team2)
	self.fields.Com_Nat1:setString(i18n(config1.country))
	self.fields.Com_Nat2:setString(i18n(config2.country))
	self.fields.Com_Nat1:setIcon(config1.flag)
	self.fields.Com_Nat2:setIcon(config2.flag)
end
return Com_natInfo

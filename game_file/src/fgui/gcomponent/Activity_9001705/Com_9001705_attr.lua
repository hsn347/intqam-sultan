local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_attr = fgui.extension_class(fgui.GButton, baseComponent)
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
local activity_9001705_Read = include("activity_9001705_Read")
fgui.register_extension("ui://Activity_9001705/Com_9001705_attr", Com_9001705_attr)
_ENV, _ENV = "ui://Activity_9001705/Com_9001705_attr", fgui.register_extension
;("ui://Activity_9001705/Com_9001705_attr").idx = 0
_ENV, fgui.register_extension.power, ("ui://Activity_9001705/Com_9001705_attr").des = "ui://Activity_9001705/Com_9001705_attr", "ui://Activity_9001705/Com_9001705_attr", "snow_competition_text_04"
;("ui://Activity_9001705/Com_9001705_attr").idx = 1
_ENV, fgui.register_extension.speed, ("ui://Activity_9001705/Com_9001705_attr").des = "ui://Activity_9001705/Com_9001705_attr", "ui://Activity_9001705/Com_9001705_attr", "snow_competition_text_05"
;("ui://Activity_9001705/Com_9001705_attr").idx = 2
fgui.register_extension.lucky, ("ui://Activity_9001705/Com_9001705_attr").des = "ui://Activity_9001705/Com_9001705_attr", "snow_competition_text_06"
local attMap = fgui.register_extension
function Com_9001705_attr:onInit()
	self:fixChildrenPos()
end
function Com_9001705_attr:onShow()
end
function Com_9001705_attr:initData(name, isShowUp)
	self.controllers.c3:setSelectedIndex(0)
	local value, level = activity_9001705_Ctrl:getAttValue(name)
	self.attName = name
	self.level = level
	local attCfg = attMap[name]
	_ENV = nil
	;(nil)[1] = value
	;(nil)[2] = level
	dump(nil, "Com_9001705_attr:initData")
	self.controllers.c1:setSelectedIndex(attCfg.idx)
	activity_9001705_Ctrl = nil
	;(nil).lv = level
	self.fields.text_lv:setString(string.format("%s %s", i18n(attCfg.des), i18n("common_text_100", nil)))
	self.fields.text_value:setString(value)
	if isShowUp then
		local nowScore = activity_9001705_Ctrl:getAttScore()
		local nextCfg = activity_9001705_Read.getLevelCfg(level + 1)
		if nextCfg ~= nil and nowScore >= nextCfg.exp then
			return level, true, nextCfg.exp
		end
		return level, false, nextCfg and nextCfg.exp or 0
	end
	return level, false, 0
end
function Com_9001705_attr:showNextLevel()
	local nextCfg = activity_9001705_Read.getLevelCfg(self.level + 1)
	self.controllers.c3:setSelectedIndex(nextCfg == nil and 0 or 1)
	if nextCfg ~= nil then
		local value = 0
		if self.attName == "power" then
			value = nextCfg.power
		elseif self.attName == "speed" then
			value = nextCfg.speed
		elseif self.attName == "lucky" then
			value = nextCfg.luckyValue
		end
		self.fields.text_next_value:setString(value)
	end
end
return Com_9001705_attr

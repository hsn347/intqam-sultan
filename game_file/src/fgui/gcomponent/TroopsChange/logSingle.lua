local publicRead = include("publicRead")
local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local logSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/logSingle", logSingle)
function logSingle:onInit()
	self:fixChildrenPos()
end
function logSingle:initData(data, logType, index)
	self.controllers.c1:setSelectedIndex(index % 2 == 0 and 1 or 0)
	self.controllers.c2:setSelectedIndex(logType)
	if logType == 0 then
		local itemStr = string.format("%sx%s,%sx%s", publicRead.getName(data.cost[1].id), string.formatnumberthousands(data.cost[1].count), publicRead.getName(data.cost[2].id), string.formatnumberthousands(data.cost[2].count))
		local itemStr2 = string.format("%sx%s", publicRead.getName(data.gain[1].id), string.formatnumberthousands(data.gain[1].count))
		_ENV = string.formatnumberthousands(data.gain[1].count)
		string.formatnumberthousands(data.gain[1].count).name1 = itemStr
		string.formatnumberthousands(data.gain[1].count).name2 = itemStr2
		self.fields.Text_detail:setString(i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count)))
	else
		local name1 = armyDesRead.getName(data.origArmyId)
		local name2 = armyDesRead.getName(data.targetArmyId)
		_ENV = i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count))
		i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count)).num1 = string.formatnumberthousands(data.origArmyNum)
		i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count)).name1 = name1
		i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count)).name2 = name2
		i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count)).num2 = string.formatnumberthousands(data.targetArmyNum)
		self.fields.Text_detail:setString(i18n("armyExchange_text_002", i18n("armyExchange_text_019", string.formatnumberthousands(data.gain[1].count))))
	end
	self.fields.Text_Time:setString(SoraDConverTimeStr(data.time))
end
return logSingle

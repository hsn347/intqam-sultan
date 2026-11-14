local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_logItem = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ServerLevel/Com_logItem", Com_logItem)
function Com_logItem:onInit()
	self:fixChildrenPos()
end
function Com_logItem:onShow()
end
function Com_logItem:initData(data)
	self.itemData = data
	local id = 0
	if self.itemData.logType == gKingdomLevelLogType.LOG_EVENTS then
		local logData = self.itemData.logData
		self:setIcon(logData.picture)
		if logData.name and logData.name ~= "" then
			self:setText(i18n(logData.name))
		end
		id = self.itemData.index
	elseif self.itemData.logType == gKingdomLevelLogType.LOG_HISTORY then
		local logData = self.itemData.logData
		id = logData.expSource
		local value = logData.exp
		local logCfg = worldKingdomLvDesRead.getExpItem(id)
		if not logCfg then
			self:setText(i18n("common_text_1464"))
			return
		end
		self:setIcon(logCfg.picture)
		_ENV = i18n("common_text_1464")
		i18n("common_text_1464").num = value
		self:setText(i18n(logCfg.des, i18n("common_text_1464")))
	end
end
return Com_logItem

local arenaltCtrl = include("arenaltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local List_text = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/List_text", List_text)
function List_text:onInit()
	self:fixChildrenPos()
end
function List_text:onShow()
end
function List_text:initData(cfg, index, fcInfo)
	self.fields.bg:setVisible(index % 2 == 0)
	local strName = i18n(cfg.name)
	if cfg.nameType == gLordInfoNameType.notHaveColon then
		_ENV = nil
		;(nil).title = i18n(cfg.name)
		strName = i18n("common_text_1915", nil)
	end
	self.fields.Text_name:setString(strName)
	local strValue = ""
	local value = fcInfo[cfg.key] or 0
	if cfg.valueType == gLordInfoValueType.percentage then
		value = math.floor(value * 10000 + 0.5) / 10000
		if value < 0 then
			strValue = tostring(value * 100) .. "%"
		else
			strValue = "+" .. value * 100 .. "%"
		end
	elseif cfg.valueType == gLordInfoValueType.oppoPercentage then
		if value < 0 then
			strValue = "+" .. -value * 100 .. "%"
		else
			strValue = "-" .. value * 100 .. "%"
		end
	elseif cfg.valueType == gLordInfoValueType.numberThousands then
		strValue = string.formatnumberthousands(value)
	elseif cfg.valueType == gLordInfoValueType.oppoNumberThousands then
		strValue = string.formatnumberthousands(-value)
	elseif cfg.valueType == gLordInfoValueType.symbolNumberThousands then
		if value < 0 then
			strValue = string.formatnumberthousands(value)
		else
			strValue = "+" .. string.formatnumberthousands(value)
		end
	elseif cfg.valueType == gLordInfoValueType.toString then
		strValue = tostring(value)
	elseif cfg.valueType == gLordInfoValueType.arenaType then
		if type(value) == "table" and next(value) then
			if value[1] == 1 then
				value[1] = 2
			elseif value[1] == 3 then
				value[1] = 4
			end
			_ENV = value[1]
			value[1].localArenaMaxRank = gArenaBattleType.ARENA_LOCAL
			local value[1].globalArenaMaxRank, key2battleType = gArenaBattleType.AREAN_GLOBAL, value[1]
			local battleType = key2battleType[cfg.key]
			local index = arenaltCtrl.getSubSectionIndex(battleType, value[1])
			local groupInfo = arenaltCtrl.getSubSectionList(index)
			local name = groupInfo.name or ""
			_ENV = nil
			;(nil).num = value[2]
			strValue = i18n(name) .. " " .. i18n("common_text_617", nil)
		else
			strValue = i18n("herobattle_text_05")
		end
	end
	self.fields.Text_value:setString(strValue)
end
return List_text

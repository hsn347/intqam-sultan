local wargemResRead = include("aAReadClass").new()
local wargemltCtrl = include("warGemltCtrl")
local isInited = false
local init = function()
	if isInited then
		return
	end
	wargemResRead = nil
	;(nil)[1] = "war_stone_describe"
	wargemResRead:defineValue("WSD", nil)
	wargemResRead:defineValue("add", function()
		wargemResRead = nil
		wargemResRead = nil
		;(nil).name = "common_text_1313"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.INFANTRY_ATTACK_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1317"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.INFANTRY_DEFENSE_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1321"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.INFANTRY_HP_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1314"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.CAVALRY_ATTACK_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1318"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.CAVALRY_DEFENSE_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1322"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.CAVALRY_HP_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1315"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ARCHER_ATTACK_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1319"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ARCHER_DEFENSE_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1323"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ARCHER_HP_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1316"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.SIEGE_VEHICLES_ATTACK_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1320"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.SIEGE_VEHICLES_DEFENSE_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_1324"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.SIEGE_VEHICLES_HP_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_3238"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ELITE_SOLDIER_ATTACK_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_3239"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ELITE_SOLDIER_DEFENSE_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_3240"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ELITE_SOLDIER_HP_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_4324"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.MARCH_VALUE_LIMIT_BOOST], (nil).valueType = nil, 5
		wargemResRead = nil
		;(nil).name = "common_text_4320"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.TRAIN_SPEED_BOOST], (nil).valueType = nil, 1
		wargemResRead = nil
		;(nil).name = "common_text_4321"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.CLUMP_NUM_BOOST], (nil).valueType = nil, 5
		wargemResRead = nil
		;(nil).name = "common_text_4322"
		;(nil).nameType = 2
		;(nil)[gBuffEffect.ELITE_SOLDIER_MAX_COUNT], (nil).valueType = nil, 5
		wargemResRead = nil
		;(nil).name = "common_text_4323"
		;(nil).nameType = 2
		wargemResRead.add, (nil)[gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST], (nil).valueType = nil, nil, 1
		return wargemResRead.add
	end)
end
local transferID = function(iid)
	return math.floor(iid / 100)
end
local transferLevel = function(iid)
	return iid % 100
end
_ENV = nil
;(nil)[0] = cc.c3b(255, 255, 255)
;(nil)[1] = cc.c3b(255, 0, 0)
;(nil)[2] = cc.c3b(255, 190, 60)
;(nil)[3] = cc.c3b(0, 185, 255)
;(nil)[4] = cc.c3b(0, 255, 0)
;(nil)[5] = cc.c3b(255, 0, 255)
local (nil)[6], tableColor = cc.c3b(255, 190, 60), nil
function wargemResRead.getBaseCfg(iid)
	local iid = tonumber(iid)
	iid = transferID(iid)
	return wargemResRead.WSD[iid]
end
function wargemResRead.getColor(iid)
	iid = tonumber(iid)
	local colorId = 1
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return tableColor[colorId]
end
function wargemResRead.getName(iid)
	local cfg = wargemResRead.getBaseCfg(iid)
	if cfg == nil or cfg.stoneName == nil or i18n(cfg.stoneName) == nil then
		return "???"
	else
		return i18n(cfg.stoneName)
	end
end
function wargemResRead.getDes(iid)
	local cfg = wargemResRead.getBaseCfg(iid)
	if cfg == nil or cfg.stoneDes == nil or i18n(cfg.stoneDes) == nil then
		wargemResRead = nil
		;(nil).des = "??????"
		return i18n("common_text_1437", nil)
	else
		return i18n(cfg.stoneDes)
	end
end
function wargemResRead.getIcon(iid, fromMemory)
	local cfg = wargemResRead.getBaseCfg(iid)
	local fileName = "icon_item_common.png"
	if cfg then
		fileName = cfg.picture
	end
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function wargemResRead.getBIcon(iid, fromMemory)
	local cfg = wargemResRead.getBaseCfg(iid)
	local fileName = "icon_item_common.png"
	if cfg then
		fileName = cfg.picture
	end
	if fromMemory then
		fileName = "#" .. fileName
	end
	return fileName
end
function wargemResRead.getBgRound(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_round_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBgRound(colorId, fromMemory)
end
_ENV, wargemResRead.getQuality = function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end, function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[0] = "frame_round_stone_whilt.png"
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[1] = "frame_round_stone_red.png"
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[2] = "frame_round_stone_yellow.png"
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[3] = "frame_round_stone_blue.png"
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[4] = "frame_round_stone_green.png"
;(function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[5] = "frame_round_stone_purple.png"
local (function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end)[6], tablebground = "frame_round_stone_orange.png", function(iid)
	local colorId = 0
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end
_ENV, wargemResRead.getColorBgRound = function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end, function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[0] = "gemEnchant_text_11"
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[1] = "gemEnchant_text_05"
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[2] = "gemEnchant_text_06"
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[3] = "gemEnchant_text_07"
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[4] = "gemEnchant_text_08"
;(function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[5] = "gemEnchant_text_09"
local (function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end)[6], colorTitle = "gemEnchant_text_10", function(colorId, fromMemory)
	return string.format("frame_baoshi_yanse0%d.png", colorId)
end
function wargemResRead.getColorTitle(colorId)
	return colorTitle[colorId]
end
_ENV, wargemResRead.getBg = function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end, function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[0] = "frame_square_stone_whilt.png"
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[1] = "frame_square_stone_red.png"
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[2] = "frame_square_stone_yellow.png"
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[3] = "frame_square_stone_blue.png"
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[4] = "frame_square_stone_green.png"
;(function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[5] = "frame_square_stone_purple.png"
local (function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end)[6], tablebg = "frame_square_stone_orange.png", function(iid, fromMemory)
	if iid == nil then
		local resultBg = "frame_square_stone_whilt.png"
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	local colorId = 1
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	else
		print("color id error ", iid)
	end
	return wargemResRead.getColorBg(colorId, fromMemory)
end
function wargemResRead.getColorBg(colorId, fromMemory)
	local resultBg = tablebg[colorId]
	resultBg = resultBg or "frame_square_stone_whilt.png"
	if fromMemory then
		resultBg = "#" .. resultBg
	end
	return resultBg
end
function wargemResRead.getGemID(iid)
	iid = transferID(iid)
	return iid
end
function wargemResRead.getLevel(iid)
	local lv = transferLevel(iid)
	return lv
end
function wargemResRead.getGemType(iid)
	iid = tonumber(iid)
	local colorId = 1
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.color then
		colorId = gemConfig.color
	end
	return colorId
end
function wargemResRead.getAttr(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.buffList then
		local buff = gemConfig.buffList[1]
		if buff then
			return buff.type
		end
	end
	return 0
end
function wargemResRead.getAttrByID(iid, bSpilt)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.buffList then
		local buff = gemConfig.buffList[1]
		if buff then
			return wargemResRead.getAttrName(buff.type, buff.count, bSpilt)
		end
	end
	return "???"
end
function wargemResRead.getAttrHtmlByID(iid)
	local strName, strValue = wargemResRead.getAttrByID(iid, true)
	wargemResRead = nil
	;(nil).title = strName
	wargemResRead, wargemResRead, (nil).value = nil, nil, strValue
	;(nil).value, (nil).color = nil, "#70C723"
	local attrStr = i18n_html("common_text_3904", nil, nil)
	return attrStr
end
function wargemResRead.getAttrValueByID(iid)
	local gemConfig = wargemltCtrl:getGemCfg(iid)
	if gemConfig and gemConfig.buffList then
		local buff = gemConfig.buffList[1]
		if buff then
			return buff.type, buff.count
		end
	end
	return nil, 0
end
function wargemResRead.getAttrName(pid, value, bSpilt)
	pid = tonumber(pid)
	if value then
		local config = wargemResRead.add[pid]
		if config then
			local strName = ""
			local strValue = ""
			if config.nameType == 2 then
				_ENV = nil
				;(nil).title = i18n(config.name)
				strName = i18n("common_text_1915", nil)
			else
				strName = i18n(config.name)
			end
			local valueType = config.valueType
			if valueType == 1 then
				if value < 0 then
					strValue = tostring(value / 10) .. "%"
				else
					strValue = "+" .. value / 10 .. "%"
				end
			elseif valueType == 2 then
				if value < 0 then
					strValue = "+" .. -value / 10 .. "%"
				else
					strValue = "-" .. value / 10 .. "%"
				end
			elseif valueType == 3 then
				strValue = string.formatnumberthousands(value)
			elseif valueType == 4 then
				strValue = string.formatnumberthousands(-value)
			elseif valueType == 5 then
				if value < 0 then
					strValue = string.formatnumberthousands(value)
				else
					strValue = "+" .. string.formatnumberthousands(value)
				end
			elseif valueType == 6 then
				strValue = tostring(value)
			end
			if bSpilt then
				return strName, strValue
			else
				_ENV = value
				value.title = strName
				value.value = strValue
				return i18n("common_text_3904", value)
			end
		elseif bSpilt then
			return "???", value
		else
			_ENV = config.valueType
			config.valueType.title = "???"
			config.valueType.value = value
			return i18n("common_text_3904", config.valueType)
		end
	else
		return i18n(wargemResRead.add[pid])
	end
end
function wargemResRead.getEnchantmentAttr(eid, amount, lv, isSplit)
	local bType, value, flag = wargemResRead.getEnchantmentAttrValue(eid, amount, lv)
	local strValue = ""
	if flag == 1 then
		strValue = "+" .. tostring(value / 10) .. "%"
	elseif flag == 2 then
		strValue = "+" .. string.formatnumberthousands(value)
	end
	local cfg = wargemltCtrl:getEnchantedCfg(eid, amount)
	if isSplit then
		return i18n(cfg.stoneName), strValue
	else
		wargemResRead = amount
		amount.title = i18n(cfg.stoneName)
		local strName = i18n("common_text_1915", amount)
		wargemResRead = i18n(cfg.stoneName)
		i18n(cfg.stoneName).title = strName
		i18n(cfg.stoneName).value = strValue
		return i18n("common_text_3904", (i18n(cfg.stoneName)))
	end
end
function wargemResRead.getEnchantmentAttrHtml(eid, amount, lv)
	local strName, strValue = wargemResRead.getEnchantmentAttr(eid, amount, lv, true)
	wargemResRead = true
	;(true).title = strName
	wargemResRead, wargemResRead, (true).value = nil, nil, strValue
	;(nil).value, (nil).color = nil, "#70C723"
	local attrStr = i18n_html("common_text_3904", true, nil)
	return attrStr
end
function wargemResRead.getEnchantmentAttrValue(eid, amount, lv)
	local cacheKey = eid * 1000 + amount
	if not wargemResRead.enchantmentBuffCache then
		wargemResRead.enchantmentBuffCache, wargemResRead = wargemResRead.enchantmentBuffCache, wargemResRead.enchantmentBuffCache
	end
	local buff = wargemResRead.enchantmentBuffCache[cacheKey]
	if not buff then
		local cfg = wargemltCtrl:getEnchantedCfg(eid, amount)
		_UPVALUE4_ = amount
		amount[1] = "type"
		amount[2] = "flag"
		amount[3] = "count"
		amount[4] = "up"
		buff = serviceFunctions.tableFormat(cfg.attribute, amount)[1]
	end
	local flag = buff.flag
	local value = buff.count + (lv - 1 or 0) * (buff.up or 0)
	flag, value = wargemResRead.transFlagValue(flag, value)
	wargemResRead.enchantmentBuffCache[cacheKey] = buff
	return buff.type, value, flag
end
function wargemResRead.getEnchantmentAttrName(eid, amount, value, flag)
	local cfg = wargemltCtrl:getEnchantedCfg(eid, amount)
	local strValue = "???"
	if flag == 1 then
		strValue = "+" .. tostring(value / 10) .. "%"
	elseif flag == 2 then
		strValue = "+" .. string.formatnumberthousands(value)
	end
	wargemltCtrl = value
	value.title = i18n(cfg.enchantmentname)
	local strName = i18n("common_text_1915", value)
	wargemltCtrl = i18n(cfg.enchantmentname)
	i18n(cfg.enchantmentname).title = strName
	i18n(cfg.enchantmentname).value = strValue
	return i18n("common_text_3904", (i18n(cfg.enchantmentname))), strName, strValue
end
function wargemResRead.transFlagValue(flag, value)
	if flag == 2 then
		return 2, value / 1000
	elseif flag == 3 then
		return 2, value / 1000000
	elseif flag == 4 then
		return 1, value / 10
	end
	return flag, value
end
function wargemResRead.initFiler()
	if not wargemResRead.filerCfg then
		local wargemResRead, indexList = wargemResRead.filerCfg, wargemResRead.filerCfg
		local wargemResRead, filerCfg
		if commonCheck.WAR_ENCHANTED then
			wargemResRead = nil
			;(nil).name = "gemEnchant_text_42"
			;(nil).filerType = gWarGemFilerType.ENCHANTED
			;(nil).index = 1
			table.insert(filerCfg, nil)
		end
		local startIndex = #filerCfg + 1
		for k, v in pairs(wargemResRead.add) do
			wargemResRead = nil
			;(nil).name = v.name
			;(nil).filerType = gWarGemFilerType.WARGEM
			;(nil).attrType = k
			filerCfg[startIndex], (nil).index = nil, startIndex
			indexList[k] = startIndex
			startIndex = startIndex + 1
		end
		wargemResRead.filerCfg = filerCfg
		wargemResRead.gemFilerIndexList = indexList
	end
end
function wargemResRead.getGemBgFiler()
	wargemResRead.initFiler()
	return wargemResRead.filerCfg, wargemResRead.gemFilerIndexList
end
init()
return wargemResRead

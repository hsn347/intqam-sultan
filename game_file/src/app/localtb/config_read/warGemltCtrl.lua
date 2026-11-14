local warGemltCtrl = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass")[0] = "#FFFFFF"
;("aAReadClass")[1] = "#BE2828"
;("aAReadClass")[2] = "#FFFF00"
;("aAReadClass")[3] = "#079FD1"
;("aAReadClass")[4] = "#00BE1E"
;("aAReadClass")[5] = "#A800FF"
local _ENV, ("aAReadClass")[6], war_stone_text_color = nil, "#F58501", "aAReadClass"
;(nil)[0] = "img_baoshi_biaozhi_00.png"
;(nil)[1] = "img_baoshi_biaozhi_01.png"
;(nil)[2] = "img_baoshi_biaozhi_02.png"
;(nil)[3] = "img_baoshi_biaozhi_03.png"
;(nil)[4] = "img_baoshi_biaozhi_04.png"
;(nil)[5] = "img_baoshi_biaozhi_05.png"
local (nil)[6], war_stone_color_icon_smalll = "img_baoshi_biaozhi_06.png", nil
function warGemltCtrl:init()
	local createData = function(name)
		local war_stone_config = require_once("app." .. LocalTblPath .. ".config_server.war_stone_config")
		self.enchantendItem, _ENV, self.gemCfg, _ENV = "app." .. LocalTblPath .. ".config_server.war_stone_config", "app." .. LocalTblPath .. ".config_server.war_stone_config", "app." .. LocalTblPath .. ".config_server.war_stone_config", "app." .. LocalTblPath .. ".config_server.war_stone_config"
		for _, v in pairs(war_stone_config) do
			_UPVALUE3_ = nil
			;(nil)[1] = "type"
			;(nil)[2] = "flag"
			;(nil)[3] = "count"
			local buffList = serviceFunctions.tableFormat(v.attribute, nil)
			_UPVALUE2_ = "type"
			;("type")[1] = "id"
			;("type")[2] = "count"
			local mergeCost = serviceFunctions.tableFormat(v.compoundID, "type")
			_UPVALUE2_ = "id"
			;("id")[1] = "id"
			;("id")[2] = "count"
			local dismountCost = serviceFunctions.tableFormat(v.Dismantle, "id")
			_ENV = v.gemID
			v.gemID.id = v.gemID
			v.gemID.level = v.level
			v.gemID.color = v.Colour
			v.gemID.fc = v.Fighting
			v.gemID.itemType = v.type
			v.gemID.gemPile = v.gemPile
			v.gemID.canFromMerge = v.compound > 0
			v.gemID.mergeCost = mergeCost
			v.gemID.dismountCost = dismountCost
			self.gemCfg[tostring(v.gemID)], v.gemID.buffList = v.gemID, buffList
			if v.type == 2 then
				self.enchantendItem[v.Colour] = v.gemID
			end
		end
		if name == "gemCfg" then
			return self.gemCfg
		elseif name == "enchantendItem" then
			return self.enchantendItem
		end
	end
	warGemltCtrl:defineValue("gemCfg", createData)
	warGemltCtrl:defineValue("enchantendItem", createData)
	local createData2 = function(name)
		self.gemPanelCfg, warGemltCtrl, warGemltCtrl.war_stone_place = require_data("war_stone_place", true, true).data, require_data("war_stone_place", true, true).data, require_data("war_stone_place", true, true).data
		for _, v in ipairs(warGemltCtrl.war_stone_place) do
			_UPVALUE3_ = nil
			;(nil)[1] = "color"
			;(nil)[2] = "itemID"
			;(nil)[3] = "itemCount"
			v.change1 = serviceFunctions.tableFormat(v.change1, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "color"
			;(nil)[2] = "itemID"
			;(nil)[3] = "itemCount"
			v.change2 = serviceFunctions.tableFormat(v.change2, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "color"
			;(nil)[2] = "itemID"
			;(nil)[3] = "itemCount"
			v.change3 = serviceFunctions.tableFormat(v.change3, nil)
			self.gemPanelCfg[tostring(v.castleLv)] = v
		end
		return self[name]
	end
	warGemltCtrl:defineValue("war_stone_place", createData2)
	warGemltCtrl:defineValue("gemPanelCfg", createData2)
	warGemltCtrl:defineValue("gemSwitchCfg", function()
		local war_stone_switch = require_once("app." .. LocalTblPath .. ".config_server.war_stone_switch_config")
		self.gemSwitchCfg, _ENV = "app." .. LocalTblPath .. ".config_server.war_stone_switch_config", "app." .. LocalTblPath .. ".config_server.war_stone_switch_config"
		for _, v in pairs(war_stone_switch) do
			v.setID = tostring(v.setID)
			_ENV, _ENV, self.gemSwitchCfg[v.setID] = v.setID, self.gemSwitchCfg, v
			v.setID.condKey = v.condition[1]
			v.setID.condValue = v.condition[2]
			v.condition, self.gemSwitchCfg[1], v.setID.targetValue = self.gemSwitchCfg, v.setID, v.condition[3]
		end
		return self.gemSwitchCfg
	end)
	warGemltCtrl:defineValue("enchantendCfg", function()
		self.enchantendCfg, self = nil, nil
		local ESD = require_data("enchantment_stone", true, true)
		for k, v in pairs(ESD.data) do
			if not self.enchantendCfg[v.enchantmentID] then
				self.enchantendCfg[v.enchantmentID], self = nil, nil
			end
			self.enchantendCfg[v.enchantmentID][v.amount] = v
		end
		return self.enchantendCfg
	end)
	function warGemltCtrl()
		self.enchantendCfg, self = nil, nil
		local ESD = require_data("enchantment_stone", true, true)
		for k, v in pairs(ESD.data) do
			if not self.enchantendCfg[v.enchantmentID] then
				self.enchantendCfg[v.enchantmentID], self = nil, nil
			end
			self.enchantendCfg[v.enchantmentID][v.amount] = v
		end
		return self.enchantendCfg
	end
	;(function()
		self.enchantendCfg, self = nil, nil
		local ESD = require_data("enchantment_stone", true, true)
		for k, v in pairs(ESD.data) do
			if not self.enchantendCfg[v.enchantmentID] then
				self.enchantendCfg[v.enchantmentID], self = nil, nil
			end
			self.enchantendCfg[v.enchantmentID][v.amount] = v
		end
		return self.enchantendCfg
	end)[1] = "war_stone_hole_config"
	warGemltCtrl:defineValue("war_stone_hole_config", function()
		self.enchantendCfg, self = nil, nil
		local ESD = require_data("enchantment_stone", true, true)
		for k, v in pairs(ESD.data) do
			if not self.enchantendCfg[v.enchantmentID] then
				self.enchantendCfg[v.enchantmentID], self = nil, nil
			end
			self.enchantendCfg[v.enchantmentID][v.amount] = v
		end
		return self.enchantendCfg
	end)
end
function warGemltCtrl:getColorDescribe(color)
	local colorDes = "NA"
	for i, v in ipairs(warGemltCtrl.war_stone_hole_config) do
		if v.placeClour == color then
			colorDes = v.des
			break
		end
	end
	return colorDes
end
function warGemltCtrl:getColorName(color)
	for i, v in ipairs(warGemltCtrl.war_stone_hole_config) do
		if v.placeClour == color then
			return v.name
		end
	end
	return "NA"
end
function warGemltCtrl:getGemCfg(gemId)
	if gemId then
		return self.gemCfg[tostring(gemId)]
	else
		return self.gemCfg
	end
end
function warGemltCtrl:getGemMaterialList(gemId)
	local config = self.gemCfg[tostring(gemId)]
	if config and config.mergeCost then
		return config.mergeCost
	end
end
function warGemltCtrl:getGemDismantle(gemId)
	local config = self.gemCfg[tostring(gemId)]
	if config and config.dismountCost then
		return config.dismountCost[1].count
	end
end
function warGemltCtrl:getGemMaterialCount(gemId, materialId)
	local compound = self:getGemMaterialList(gemId)
	if compound then
		for k, v in pairs(compound) do
			if v.id == materialId then
				return v.count
			end
		end
	end
end
function warGemltCtrl:getGemNeedCount(gemId)
	local toId = self:getGemMaterialIDAfterMerge(gemId)
	if toId == 0 then
		return 0
	end
	return self:getGemMaterialCount(toId, gemId)
end
function warGemltCtrl:getGemMaterialIDAfterMerge(gemId)
	local toId = gemId + 1
	if self.gemCfg[tostring(toId)] then
		return toId
	end
	return 0
end
function warGemltCtrl:isEnchantedItem(gemId)
	local cfg = self.gemCfg[tostring(gemId)]
	if cfg then
		return cfg.itemType == 2
	end
	return false
end
function warGemltCtrl:getGemHoleColor(lv, idx)
	return self.gemPanelCfg[tostring(lv)] and self.gemPanelCfg[tostring(lv)].placeClour and self.gemPanelCfg[tostring(lv)].placeClour[idx]
end
function warGemltCtrl:getGemHoleChange(lv, index)
	return self.gemPanelCfg[tostring(lv)] and self.gemPanelCfg[tostring(lv)]["change" .. index]
end
function warGemltCtrl:getGemPanelCfg()
	return self.gemPanelCfg
end
function warGemltCtrl:getGemSwitchCfg()
	local _ENV, ret
	for setID, _ in pairs(self.gemSwitchCfg) do
		table.insert(ret, setID)
	end
	return ret
end
function warGemltCtrl:getGemSwitchCount()
	return table.nums(self.gemSwitchCfg)
end
function warGemltCtrl:setIDValid(setID)
	return self.gemSwitchCfg[tostring(setID)]
end
function warGemltCtrl:getDefaultSetID()
	return "1"
end
function warGemltCtrl:getGemSwitchCondition(setID)
	return self.gemSwitchCfg[tostring(setID)] and self.gemSwitchCfg[tostring(setID)].condition
end
function warGemltCtrl:getEnchantedItemIDByColor(color)
	return self.enchantendItem[color]
end
function warGemltCtrl:getEnchantedColor(id)
	for k, v in pairs(self.enchantendItem) do
		if v == id then
			return k
		end
	end
end
function warGemltCtrl:getEnchantedCfg(eid, amount)
	return self.enchantendCfg[eid][amount]
end
function warGemltCtrl:getColorValue(color)
	return war_stone_text_color[color]
end
function warGemltCtrl:getStonePlaceNum()
	return #warGemltCtrl.war_stone_place
end
function warGemltCtrl:getStonePlaceLv(id)
	return warGemltCtrl.war_stone_place[id].castleLv
end
function warGemltCtrl:getStoneColorIconSmall(color)
	return war_stone_color_icon_smalll[color]
end
warGemltCtrl:init()
return warGemltCtrl

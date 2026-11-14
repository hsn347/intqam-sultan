local activity_9001619_Read = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	activity_9001619_Read:defineValue("resetCfg", function()
		activity_9001619_Read.resetCfg, activity_9001619_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ramadan_rhapsody_reset")
		for i, v in ipairs(cfg) do
			activity_9001619_Read.resetCfg[i] = v.cost and v.cost[2] or 0
		end
		return activity_9001619_Read.resetCfg
	end)
	activity_9001619_Read:defineValue("combCfg", function()
		activity_9001619_Read.combCfg, activity_9001619_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ramadan_rhapsody_comb")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.reward, nil)
			v.reward = reward
			if not activity_9001619_Read.combCfg[v.classType] then
				activity_9001619_Read = activity_9001619_Read.combCfg[v.classType]
			end
			activity_9001619_Read.combCfg[v.classType] = activity_9001619_Read.combCfg[v.classType]
			table.insert(activity_9001619_Read.combCfg[v.classType], v)
		end
		return activity_9001619_Read.combCfg
	end)
	activity_9001619_Read:defineValue("awardCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "starlight_name_01"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "starlight_name_02"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "starlight_name_03"
		;(nil)[4], (nil).name = nil, "starlight_name_04"
		return nil
	end)
end
init()
function activity_9001619_Read:getResetGold(index)
	if index > #self.resetCfg then
		return self.resetCfg[#self.resetCfg]
	end
	return self.resetCfg[index]
end
function activity_9001619_Read:getCombCfg(index)
	local groupID = SoraDGetCtrl("activity_9001619_Ctrl"):getGroupID()
	if index then
		return self.combCfg[groupID][index]
	else
		return self.combCfg[groupID]
	end
end
_ENV, _ENV, activity_9001619_Read.getAwardNmae = nil, function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end, function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end
;(nil).bg = "frame_9001619_huang_da.png"
;(nil).light = "huang"
_ENV, (function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end)[1], (nil).icon = nil, nil, "frame_9001619_huang_da.png"
;(nil).bg = "frame_9001619_lan_da.png"
;(nil).light = "lan"
_ENV, (function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end)[2], (nil).icon = nil, nil, "frame_9001619_lan_da.png"
;(nil).bg = "frame_9001619_lv_da.png"
;(nil).light = "lv"
_ENV, (function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end)[3], (nil).icon = nil, nil, "frame_9001619_lv_da.png"
;(nil).bg = "frame_9001619_weidianliang.png"
;(nil).light = ""
activity_9001619_Read.lampCfg, (function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end)[4], (nil).icon = function(self, index)
	local cfg = self.awardCfg[index]
	if cfg then
		return i18n(cfg.name)
	end
end, nil, "frame_9001619_weidianliang.png"
function activity_9001619_Read:getLampImgBg(index, icon)
	local cfg = self.lampCfg[index]
	if cfg then
		if icon and cfg.icon then
			return cfg.icon
		end
		return cfg.bg
	end
end
function activity_9001619_Read:getLampImgLight(index)
	local cfg = self.lampCfg[index]
	if cfg then
		return "frame_9001619_" .. cfg.light .. "_%02d.png", 13
	end
end
function activity_9001619_Read:getLampImgLightLoop(index)
	local cfg = self.lampCfg[index]
	if cfg then
		return "frame_9001619_" .. cfg.light .. "dj_%02d.png", 16
	end
end
function activity_9001619_Read:isStar()
	return starRhapsodyDef.isStar
end
function activity_9001619_Read:getDefaultImg()
end
return activity_9001619_Read

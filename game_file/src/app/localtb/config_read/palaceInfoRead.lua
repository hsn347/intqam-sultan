local palaceInfoRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	palaceInfoRead = nil
	;(nil)[1] = "kingdompalace"
	palaceInfoRead:defineValue("data", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "king_build_power"
	;(nil)[2] = true
	palaceInfoRead:defineValue("batteryPower", nil)
	palaceInfoRead = nil
	;(nil)[1] = "kingdomtowers"
	palaceInfoRead:defineValue("batterydata", nil)
end
init()
function palaceInfoRead.getImg(id, fromMemory)
	id = id == 0 and 1 or id
	id = tonumber(id)
	if fromMemory then
		return "#" .. palaceInfoRead.data[id].big
	end
	return palaceInfoRead.data[id].big
end
function palaceInfoRead.getImgOffset(id)
	id = id == 0 and 1 or id
	_ENV, _ENV, id = id, tonumber(id), tonumber(id)
	id.pos = cc.p(-10, 0)
	_ENV, tonumber(id)[1], id.scale = id, id, 1
	id.pos = cc.p(-5, 0)
	_ENV, tonumber(id)[2], id.scale = id, id, 1
	id.pos = cc.p(-5, 0)
	_ENV, tonumber(id)[3], id.scale = id, id, 1
	id.pos = cc.p(-12, 0)
	_ENV, tonumber(id)[4], id.scale = id, id, 0.9
	id.pos = cc.p(-8, 5)
	_ENV, tonumber(id)[5], id.scale = id, id, 0.9
	id.pos = cc.p(-12, 8)
	_ENV, tonumber(id)[6], id.scale = id, id, 0.95
	id.pos = cc.p(-9, -8)
	_ENV, tonumber(id)[7], id.scale = id, id, 1
	id.pos = cc.p(-50, 0)
	_ENV, tonumber(id)[8], id.scale = id, id, 1.1
	id.pos = cc.p(-50, 0)
	_ENV, tonumber(id)[9], id.scale = id, id, 1.1
	id.pos = cc.p(-50, 0)
	_ENV, tonumber(id)[10], id.scale = id, id, 1.1
	id.pos = cc.p(-50, 0)
	_ENV, tonumber(id)[11], id.scale = id, id, 1.1
	id.pos = cc.p(-50, 0)
	tonumber(id)[12], id.scale = id, 1.1
	local data = tonumber(id)
	if not data[id] then
		_ENV = data[id]
		data[id].pos = cc.p(0, 0)
		data[id].scale = 1
	end
	return data[id]
end
function palaceInfoRead.getIcon(id, fromMemory)
	id = id == 0 and 1 or id
	id = tonumber(id)
	if fromMemory then
		return "#" .. palaceInfoRead.data[id].icon
	end
	return palaceInfoRead.data[id].icon
end
function palaceInfoRead.getIconLod(id, fromMemory)
	id = id == 0 and 1 or id
	id = tonumber(id)
	if fromMemory then
		return "#" .. palaceInfoRead.data[id].iconLod
	end
	return palaceInfoRead.data[id].iconLod
end
function palaceInfoRead.getTbl(...)
	local _ENV, reTbl
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local includeTbl = activityShowCtrl:getKingdomPalaceIDAry()
	local judgeIsHave = function(id)
		local isHave = false
		for k, v in pairs(includeTbl) do
			if v == id and true == activityShowCtrl:isActivityOpen(id) then
				isHave = true
				break
			end
		end
		return isHave
	end
	for i, v in ipairs(palaceInfoRead.data) do
		if v.holiday == 0 or v.holiday == gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY or judgeIsHave(v.holiday) then
			reTbl[i] = v
		end
	end
	return reTbl
end
function palaceInfoRead.getHoliday(id)
	id = id == 0 and 1 or id
	id = tonumber(id)
	return palaceInfoRead.data[id].holiday
end
function palaceInfoRead.getBatteryCfg(id)
	return palaceInfoRead.batterydata[id]
end
function palaceInfoRead.getBatteryConfig()
	local _ENV, cfg
	for k, v in pairs(palaceInfoRead.batterydata) do
		table.insert(cfg, v)
	end
	table.sort(cfg, function(a, b)
		return a.index < b.index
	end)
	return cfg
end
function palaceInfoRead.getBatteryImg(id)
	local cfg = palaceInfoRead.getBatteryCfg(id)
	if cfg then
		return cfg.big
	end
end
function palaceInfoRead.getBatteryIcon(id)
	local cfg = palaceInfoRead.getBatteryCfg(id)
	if cfg then
		return cfg.icon
	end
end
function palaceInfoRead.getBatteryIconLod(id)
	local cfg = palaceInfoRead.getBatteryCfg(id)
	if cfg then
		return cfg.iconLod
	end
end
function palaceInfoRead.getBatteryName(id)
	local cfg = palaceInfoRead.getBatteryCfg(id)
	if cfg then
		return i18n(cfg.name)
	end
end
function palaceInfoRead.getBatteryPowerCfg(id, num)
	for _, v in ipairs(palaceInfoRead.batteryPower) do
		if v.type == id and num >= v.armynum[1] and num <= v.armynum[2] then
			return v
		end
	end
end
function palaceInfoRead.getBatteryPowerNum(id, num)
	local cfg = palaceInfoRead.getBatteryPowerCfg(id, num)
	if cfg then
		return cfg.proportion, cfg.damge
	end
	return 0, 1
end
function palaceInfoRead.getBatteryPowerDamage(id, num)
	local cfg = palaceInfoRead.getBatteryPowerCfg(id, num)
	if cfg then
		return cfg.damge
	end
	return 1
end
function palaceInfoRead.getAtlantisKingdomPalace(...)
	return palaceInfoRead.data[13]
end
function palaceInfoRead.checkAtlantisPalaceBuff()
	local cfg = palaceInfoRead.getAtlantisKingdomPalace()
	if cfg then
		if not cfg.buff then
			local palaceInfoRead, buff = cfg.buff, cfg.buff
		end
		return 0 < #buff
	end
	return false
end
return palaceInfoRead

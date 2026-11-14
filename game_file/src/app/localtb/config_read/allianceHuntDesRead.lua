local allianceHuntDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceHuntDesRead = nil
	;(nil)[1] = "robot_config"
	allianceHuntDesRead:defineValue("robotConfig", nil)
	allianceHuntDesRead:defineValue("exchangeConfig", function()
		local exchangeConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_exchange_config")
		for i, v in ipairs(exchangeConfig) do
			v.shopIndex = i
		end
		return exchangeConfig
	end)
	function _ENV()
		local exchangeConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_exchange_config")
		for i, v in ipairs(exchangeConfig) do
			v.shopIndex = i
		end
		return exchangeConfig
	end
	;(function()
		local exchangeConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_exchange_config")
		for i, v in ipairs(exchangeConfig) do
			v.shopIndex = i
		end
		return exchangeConfig
	end)[1] = "hunt_master_config"
	;(function()
		local exchangeConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_exchange_config")
		for i, v in ipairs(exchangeConfig) do
			v.shopIndex = i
		end
		return exchangeConfig
	end)[2] = true
	allianceHuntDesRead:defineValue("huntMasterConfig", function()
		local exchangeConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_exchange_config")
		for i, v in ipairs(exchangeConfig) do
			v.shopIndex = i
		end
		return exchangeConfig
	end)
	allianceHuntDesRead:defineValue("huntAttackConfig", function()
		local huntAttackConfig = require_once("app." .. LocalTblPath .. ".config_server.hunt_attack_config")
		for i, v in ipairs(huntAttackConfig) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.RankRewards = serviceFunctions.tableFormatToMap(v.RankRewards, nil)
		end
		return huntAttackConfig
	end)
	allianceHuntDesRead:defineValue("preyCfg", function()
		_ENV, _ENV = nil, nil
		;(nil).defaultImg = "dl_ly_yd_01.png"
		_UPVALUE4_, _UPVALUE2_, (nil).arrowNum = nil, nil, 5
		_UPVALUE4_, (nil)[1] = 0, 0
		_UPVALUE4_, (nil)[2] = 0, 38
		_UPVALUE4_, (nil)[3] = 0, 70
		_UPVALUE4_, (nil)[4] = 0, 60
		;(0)[1] = 26
		;(0)[2] = 52
		;(0)[3] = 30
		;(0)[4] = 25
		_ENV, (nil).hitBox, (nil)[1] = nil, nil, nil
		_ENV, (nil).hitBox, (nil)[2] = nil, nil, 0
		;(nil).imgformat = "dl_ly_yd_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).walkImgCfg, (nil).aend = nil, nil, 24
		;(nil).imgformat = "dl_ly_sw_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).attackImgCfg, (nil).aend = nil, nil, 22
		;(nil).imgformat = "dl_ly_sw_%02d.png"
		;(nil).astart = 1
		_ENV, (nil)[1600], (nil).deadImgCfg, (nil).aend = nil, nil, nil, 22
		;(nil).defaultImg = "dl_sy_yd_01.png"
		_UPVALUE4_, _UPVALUE2_, (nil).arrowNum = nil, nil, 0
		_UPVALUE4_, (nil)[1] = 5, 5
		_UPVALUE4_, (nil)[2] = 5, 20
		_UPVALUE4_, (nil)[3] = 5, 98
		_UPVALUE4_, (nil)[4] = 5, 78
		;(5)[1] = 45
		;(5)[2] = 50
		;(5)[3] = 44
		;(5)[4] = 42
		_ENV, (nil).hitBox, (nil)[1] = nil, nil, nil
		_ENV, (nil).hitBox, (nil)[2] = nil, nil, 5
		;(nil).imgformat = "dl_sy_yd_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).walkImgCfg, (nil).aend = nil, nil, 24
		;(nil).imgformat = "dl_sy_sj_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).attackImgCfg, (nil).aend = nil, nil, 19
		;(nil).imgformat = "dl_sy_sw_%02d.png"
		;(nil).astart = 1
		_ENV, (nil)[1601], (nil).deadImgCfg, (nil).aend = nil, nil, nil, 22
		;(nil).defaultImg = "dl_sz_yd_01.png"
		_UPVALUE4_, _UPVALUE2_, (nil).arrowNum = nil, nil, 0
		_UPVALUE4_, (nil)[1] = 0, 0
		_UPVALUE4_, (nil)[2] = 0, 10
		_UPVALUE4_, (nil)[3] = 0, 124
		_UPVALUE4_, (nil)[4] = 0, 86
		;(0)[1] = 40
		;(0)[2] = 40
		;(0)[3] = 40
		;(0)[4] = 36
		_ENV, (nil).hitBox, (nil)[1] = nil, nil, nil
		_ENV, (nil).hitBox, (nil)[2] = nil, nil, 0
		;(nil).imgformat = "dl_sz_yd_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).walkImgCfg, (nil).aend = nil, nil, 24
		;(nil).imgformat = "dl_sz_sj_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).attackImgCfg, (nil).aend = nil, nil, 16
		;(nil).imgformat = "dl_sz_sw_%02d.png"
		;(nil).astart = 1
		_ENV, (nil)[1602], (nil).deadImgCfg, (nil).aend = nil, nil, nil, 22
		;(nil).defaultImg = "dl_bz_yd_01.png"
		_UPVALUE4_, _UPVALUE2_, (nil).arrowNum = nil, nil, 0
		_UPVALUE4_, (nil)[1] = -10, -10
		_UPVALUE4_, (nil)[2] = -10, 10
		_UPVALUE4_, (nil)[3] = -10, 130
		_UPVALUE4_, (nil)[4] = -10, 66
		;(-10)[1] = 36
		;(-10)[2] = 36
		;(-10)[3] = 40
		;(-10)[4] = 36
		_ENV, (nil).hitBox, (nil)[1] = nil, nil, nil
		_ENV, (nil).hitBox, (nil)[2] = nil, nil, -10
		;(nil).imgformat = "dl_bz_yd_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).walkImgCfg, (nil).aend = nil, nil, 18
		;(nil).imgformat = "dl_bz_sj_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).attackImgCfg, (nil).aend = nil, nil, 16
		;(nil).imgformat = "dl_bz_sw_%02d.png"
		;(nil).astart = 1
		_ENV, (nil)[1603], (nil).deadImgCfg, (nil).aend = nil, nil, nil, 20
		;(nil).defaultImg = "dl_gx_yd_01.png"
		_UPVALUE4_, _UPVALUE2_, (nil).arrowNum = nil, nil, 0
		_UPVALUE4_, (nil)[1] = 5, 5
		_UPVALUE4_, (nil)[2] = 5, 10
		_UPVALUE4_, (nil)[3] = 5, 150
		_UPVALUE4_, (nil)[4] = 5, 86
		;(5)[1] = 62
		;(5)[2] = 34
		;(5)[3] = 48
		;(5)[4] = 44
		_ENV, (nil).hitBox, (nil)[1] = nil, nil, nil
		_ENV, (nil).hitBox, (nil)[2] = nil, nil, 5
		;(nil).imgformat = "dl_gx_yd_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).walkImgCfg, (nil).aend = nil, nil, 24
		;(nil).imgformat = "dl_gx_sj_%02d.png"
		;(nil).astart = 1
		_ENV, (nil).attackImgCfg, (nil).aend = nil, nil, 16
		;(nil).imgformat = "dl_gx_sw_%02d.png"
		;(nil).astart = 1
		;(nil)[1604], (nil).deadImgCfg, (nil).aend = nil, nil, 21
		local preyCfg
		for _, item in pairs(preyCfg) do
			local hitBox = item.hitBox
			for i, v in ipairs(hitBox) do
				local x, y, w, h = v[1], v[2], v[3], v[4]
				local yBottom = y - h / 2
				local beginX = x - w / 2
				if not item.hitRect then
					item.hitRect, _ENV = item.hitRect, item.hitRect
				end
				_ENV = nil
				;(nil).x = beginX
				;(nil).y = yBottom
				;(nil).width = v[3]
				item.hitRect[i], (nil).height = nil, v[4]
			end
		end
		return preyCfg
	end)
	allianceHuntDesRead:defineValue("zOrder", function()
		_ENV = nil
		;(nil).z_bottomNode = display.height - 100
		;(nil).z_shot_effect = display.height - 10
		;(nil).z_hurt_effect = display.height - 5
		;(nil).z_hurt_text = display.height - 4
		;(nil).z_enerty_anim = display.height - 3
		;(nil).z_bullsEye = display.height - 1
		;(nil).z_arrow = display.height
		;(nil).z_centerNode = display.height - 50
		;(nil).z_topNode = display.height + 1
		;(nil).z_btnClose = display.height + 2
		return nil
	end)
end
init()
function allianceHuntDesRead.getPreyCfg(preyId)
	return allianceHuntDesRead.preyCfg[preyId]
end
function allianceHuntDesRead.getRobotCfg()
	return allianceHuntDesRead.robotConfig
end
function allianceHuntDesRead.getExchangeList()
	local _ENV, ret
	local castleLv = SoraDGetCastleLv()
	for i, v in ipairs(allianceHuntDesRead.exchangeConfig) do
		if castleLv >= v.castleLv then
			table.insert(ret, v)
		end
	end
	return ret
end
function allianceHuntDesRead.getChanllengePointByRank(rank)
	for i, v in ipairs(allianceHuntDesRead.huntAttackConfig) do
		if rank >= v.Rank[1] and rank <= v.Rank[2] then
			return v.RankRewards[gIDDef.ALLIANCE_HUNTING_POINT] or 0
		end
	end
end
function allianceHuntDesRead:getPrySpeed(preyId)
	for _, v in ipairs(allianceHuntDesRead.huntMasterConfig) do
		if v.PreyID == preyId then
			return v.Speed
		end
	end
end
return allianceHuntDesRead

local weaponSprctrumRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "weapon_sprctrum_reward"
	;(nil)[2] = true
	weaponSprctrumRead:defineValue("reward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "weapon_sprctrum_task"
	;(nil)[2] = true
	weaponSprctrumRead:defineValue("task", nil)
	weaponSprctrumRead:defineValue("rongyanCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).name = "rongyan1"
		;(nil).param = "app.game.eventCenterView.eventTemplate.equipActivity.shaderCfg.rongyan1_shaderCfg"
		;(nil).shader = "app.game.eventCenterView.eventTemplate.equipActivity.shader.rongyan4"
		_UPVALUE2_, (nil).meshData = nil, "app.game.eventCenterView.eventTemplate.equipActivity.meshData.rongyan1_meshData"
		_UPVALUE2_, (nil).position, (nil)[1] = nil, nil, 30
		_UPVALUE2_, (nil).position, (nil)[2] = nil, nil, -170
		;(nil).rongyan1, (nil).scale, (nil)[1] = nil, nil, 0.025
		;(nil).rongyan1, (nil).scale, (nil)[2] = nil, nil, 0.015
		return nil
	end)
	weaponSprctrumRead:defineValue("UICfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).name = "UI"
		;(nil).param = "app.game.eventCenterView.eventTemplate.equipActivity.shaderCfg.UI_shaderCfg"
		;(nil).shader = "app.game.eventCenterView.eventTemplate.equipActivity.shader.rongyan4"
		_UPVALUE2_, (nil).meshData = nil, "app.game.eventCenterView.eventTemplate.equipActivity.meshData.UI_meshData"
		_UPVALUE2_, (nil).position, (nil)[1] = nil, nil, 0
		_UPVALUE2_, (nil).position, (nil)[2] = nil, nil, 0
		;(nil).UI, (nil).scale, (nil)[1] = nil, nil, 0.3
		;(nil).UI, (nil).scale, (nil)[2] = nil, nil, 0.3
		return nil
	end)
	weaponSprctrumRead:defineValue("jindut1Cfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).name = "jindut1"
		;(nil).param = "app.game.eventCenterView.eventTemplate.equipActivity.shaderCfg.jindut1_shaderCfg"
		;(nil).shader = "app.game.eventCenterView.eventTemplate.equipActivity.shader.rongyan4"
		_UPVALUE2_, (nil).meshData = nil, "app.game.eventCenterView.eventTemplate.equipActivity.meshData.jindut1_meshData"
		_UPVALUE2_, (nil).position, (nil)[1] = nil, nil, 0
		_UPVALUE2_, (nil).position, (nil)[2] = nil, nil, 0
		;(nil).jindut1, (nil).scale, (nil)[1] = nil, nil, 0.0675
		;(nil).jindut1, (nil).scale, (nil)[2] = nil, nil, 0.0675
		return nil
	end)
	weaponSprctrumRead:defineValue("kuangCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).name = "kuang"
		;(nil).param = "app.game.eventCenterView.eventTemplate.equipActivity.shaderCfg.kuang_shaderCfg"
		;(nil).shader = "app.game.eventCenterView.eventTemplate.equipActivity.shader.rongyan4"
		_UPVALUE2_, (nil).meshData = nil, "app.game.eventCenterView.eventTemplate.equipActivity.meshData.kuang_meshData"
		_UPVALUE2_, (nil).position, (nil)[1] = nil, nil, 2
		_UPVALUE2_, (nil).position, (nil)[2] = nil, nil, 2
		;(nil).kuang, (nil).scale, (nil)[1] = nil, nil, 0.105
		;(nil).kuang, (nil).scale, (nil)[2] = nil, nil, 0.108
		return nil
	end)
end
function weaponSprctrumRead.getTypeReward(eType)
	local _ENV, ret
	for k, v in ipairs(weaponSprctrumRead.reward) do
		if v.rewardType == 1 and v.type == eType then
			ret = v.dailyReward
			break
		end
	end
	return ret
end
function weaponSprctrumRead.getTypeConfig(eType)
	_ENV = nil
	_ENV = nil
	;(nil).icon = "icon_spectrum_weapon.png"
	;(nil)[gWeaponTaskType.arms], (nil).title = nil, "spectrum_title_04"
	_ENV = nil
	;(nil).icon = "icon_spectrum_clothes.png"
	;(nil)[gWeaponTaskType.armor], (nil).title = nil, "spectrum_title_01"
	_ENV = nil
	;(nil).icon = "icon_spectrum_pants.png"
	;(nil)[gWeaponTaskType.trousers], (nil).title = nil, "spectrum_title_03"
	_ENV = nil
	;(nil).icon = "icon_spectrum_helmet.png"
	;(nil)[gWeaponTaskType.helmet], (nil).title = nil, "spectrum_title_05"
	_ENV = nil
	;(nil).icon = "icon_spectrum_shoe.png"
	;(nil)[gWeaponTaskType.shoes], (nil).title = nil, "spectrum_title_06"
	_ENV = nil
	;(nil).icon = "icon_spectrum_arm.png"
	;(nil)[gWeaponTaskType.glove], (nil).title = nil, "spectrum_title_02"
	local config
	return config[eType] or config[gWeaponTaskType.arms]
end
function weaponSprctrumRead.getFinalReward()
	local _ENV, ret
	for k, v in ipairs(weaponSprctrumRead.reward) do
		if v.rewardType == 2 then
			ret = v.dailyReward
			break
		end
	end
	return ret
end
function weaponSprctrumRead.getFinalRewardNum()
	local num = 0
	for k, v in ipairs(weaponSprctrumRead.reward) do
		if v.rewardType == 2 then
			num = v.num
			break
		end
	end
	return num
end
function weaponSprctrumRead.getTypeTask(eType)
	local eventQuestRead = include("eventQuestRead")
	local _ENV, ret = "eventQuestRead", "eventQuestRead"
	for k, v in ipairs(weaponSprctrumRead.task) do
		if v.type == eType then
			_ENV = v.type
			v.type.questID = v.questID
			v.type.name = eventQuestRead.getDes(v.questID)
			v.type.aim = eventQuestRead.getAim(v.questID)
			v.type.reward = eventQuestRead.getReward(v.questID)
			local v.type.guideId, data = eventQuestRead.getGuideId(v.questID), v.type
			table.insert(ret, data)
		end
	end
	return ret
end
init()
return weaponSprctrumRead

local summerPrayRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	summerPrayRead:defineValue("exchangeConfig", function()
		local config = require_data("summer_pray_exchange", true, true).data
		return summerPrayRead.getClassTypeConfig(config)
	end)
	summerPrayRead:defineValue("bannerConfig", function()
		local config = require_data("summer_pray_banner", true, true).data
		return summerPrayRead.getClassTypeConfig(config)
	end)
	summerPrayRead:defineValue("awardConfig", function()
		local _ENV, ret
		local awardConfig = require_once("app." .. LocalTblPath .. ".config_server.summer_pray_reward")
		for i, v in ipairs(awardConfig) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.packreward1 = serviceFunctions.tableFormat(v.packreward1, nil)
			local classType = v.classType or 0
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			table.insert(ret[classType], v.packorder, v)
		end
		return ret
	end)
end
init()
function summerPrayRead.getClassType(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY)
	return classType
end
function summerPrayRead.getAwardConfig()
	local classType = summerPrayRead.getClassType()
	if not summerPrayRead.awardConfig[classType] then
		summerPrayRead = summerPrayRead.awardConfig[classType]
	end
	return summerPrayRead.awardConfig[classType]
end
function summerPrayRead.getBannerConfig()
	local classType = summerPrayRead.getClassType()
	if not summerPrayRead.bannerConfig[classType] then
		summerPrayRead = summerPrayRead.bannerConfig[classType]
	end
	return summerPrayRead.bannerConfig[classType]
end
function summerPrayRead.getBoxConfigByOrder(order)
	local config = summerPrayRead.getAwardConfig()
	if order > table.nums(config) then
		order = #config
	elseif order < 0 then
		order = 1
	end
	if not config[order] then
		summerPrayRead = config[order]
	end
	return config[order]
end
function summerPrayRead.getGiftIcon(index)
	if summerPrayRead.getActivityType() == 1 then
		return string.format("icon_cxqf_ticket%d.png", index)
	elseif index == 1 then
		return "7435.png"
	else
		return string.format("7435%02d.png", index)
	end
end
function summerPrayRead.getFAQKey(...)
	if summerPrayRead.getActivityType() == 1 then
		return i18n("pray_text_01")
	else
		return i18n("Icefestival2024_text04")
	end
end
function summerPrayRead.openActivityView(...)
	if summerPrayRead.getActivityType() == 1 then
		SoraDCreatePanel("summerPrayersMainView"):show()
	else
		uiManager:show("summerPrayersMainView")
	end
end
function summerPrayRead.getItemID(...)
	if summerPrayRead.getActivityType() == 1 then
		return 829301
	else
		return 743501
	end
end
function summerPrayRead.getActivityType(...)
	local classType = summerPrayRead.getClassType()
	if classType == 1 then
		return 1
	else
		return 2
	end
end
return summerPrayRead

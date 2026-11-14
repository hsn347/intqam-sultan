local coffeeCraftsmanRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	coffeeCraftsmanRead:defineValue("coffeeRewardPool", function()
		local coffeecrashman_reward = require_once("app." .. _G.LocalTblPath .. ".config_server.coffeecrashman_reward")
		coffeeCraftsmanRead.coffeeRewardPool, _ENV = "app." .. _G.LocalTblPath .. ".config_server.coffeecrashman_reward", "app." .. _G.LocalTblPath .. ".config_server.coffeecrashman_reward"
		for k, v in pairs(coffeecrashman_reward) do
			if v.type == 1 then
				_UPVALUE3_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				;(nil)[3] = "weight"
				v.reward = serviceFunctions.tableFormat(v.reward, nil)
				if not coffeeCraftsmanRead.coffeeRewardPool[v.group] then
					coffeeCraftsmanRead.coffeeRewardPool[v.group], _ENV = nil, nil
				end
				coffeeCraftsmanRead.coffeeRewardPool[v.group][v.pool] = v
			end
		end
		return coffeeCraftsmanRead.coffeeRewardPool
	end)
	coffeeCraftsmanRead:defineValue("view_config", function()
		local coffeecrashman_view = require_once("app." .. _G.LocalTblPath .. ".config_client.coffeecrashman_view")
		coffeeCraftsmanRead.view_config, _ENV = "app." .. _G.LocalTblPath .. ".config_client.coffeecrashman_view", "app." .. _G.LocalTblPath .. ".config_client.coffeecrashman_view"
		for k, v in pairs(coffeecrashman_view) do
			if not coffeeCraftsmanRead.view_config[v.group] then
				_ENV = coffeeCraftsmanRead.view_config[v.group]
			end
			coffeeCraftsmanRead.view_config[v.group] = coffeeCraftsmanRead.view_config[v.group]
			coffeeCraftsmanRead.view_config[v.group][v.pool] = v
		end
		return coffeeCraftsmanRead.view_config
	end)
end
init()
function coffeeCraftsmanRead:getConfig(pool, group)
	return self.coffeeRewardPool[group][pool]
end
function coffeeCraftsmanRead:getCoffeeIcon(pool)
	local group = self:getGroup()
	local view = self.view_config[group][pool]
	return view.show
end
function coffeeCraftsmanRead:getCoffeeSmallIcon(pool)
	local group = self:getGroup()
	local view = self.view_config[group][pool]
	return view.itemIcon
end
function coffeeCraftsmanRead:getCoffeeTip(pool)
	local group = self:getGroup()
	local view = self.view_config[group][pool]
	return view.itemDes
end
function coffeeCraftsmanRead:getCoffeeName(pool)
	local group = self:getGroup()
	local view = self.view_config[group][pool]
	return view.itemName or "undefined"
end
function coffeeCraftsmanRead:getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return coffeeCraftsmanRead

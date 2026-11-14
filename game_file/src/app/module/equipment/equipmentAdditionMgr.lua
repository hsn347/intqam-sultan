local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local equipmentltCtrl = include("equipmentltCtrl")
_ENV = "equipmentltCtrl"
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_ATTACK] = gBuffEffect.TROOP_ATTACK_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_DEFENSE] = gBuffEffect.TROOP_DEFENSE_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_TRAIN_SPEED] = gBuffEffect.TRAIN_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_HP] = gBuffEffect.TROOP_HP_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.MARCH_SPEED] = gBuffEffect.MARCH_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.BUILD_BUILDING_SPEED] = gBuffEffect.BUILD_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.RESOURCE_OUTPUT] = gBuffEffect.RESOURCE_OUTPUT_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.MARCH_MONSTER_SPEED] = gBuffEffect.MARCH_MONSTER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.TRAP_ATTACK] = gBuffEffect.TRAP_ATTACK
;("equipmentltCtrl")[gEquipmentExtraProperty.MAKE_TRAP_SPEED] = gBuffEffect.MAKE_TRAP_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.WOUNDED_SOLDIER_LIMIT] = gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.CURE_SOLDIER_SPEED] = gBuffEffect.CURE_SOLDIER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.RESEARCH_SPEED] = gBuffEffect.RESEARCH_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.FORGE_EQUIPMENT_SPEED] = gBuffEffect.FORGE_EQUIPMENT_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.KILL_MONSTER_EXP] = gBuffEffect.KILL_MONSTER_EXP_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.INFANTRY_ATTACK] = gBuffEffect.INFANTRY_ATTACK_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.CAVALRY_ATTACK] = gBuffEffect.CAVALRY_ATTACK_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.ARCHER_ATTACK] = gBuffEffect.ARCHER_ATTACK_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.SIEGE_VEHICLES_ATTACK] = gBuffEffect.SIEGE_VEHICLES_ATTACK_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.INFANTRY_DEFENSE] = gBuffEffect.INFANTRY_DEFENSE_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.CAVALRY_DEFENSE] = gBuffEffect.CAVALRY_DEFENSE_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.ARCHER_DEFENSE] = gBuffEffect.ARCHER_DEFENSE_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.SIEGE_VEHICLES_DEFENSE] = gBuffEffect.SIEGE_VEHICLES_DEFENSE_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.INFANTRY_HP] = gBuffEffect.INFANTRY_HP_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.CAVALRY_HP] = gBuffEffect.CAVALRY_HP_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.ARCHER_HP] = gBuffEffect.ARCHER_HP_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.SIEGE_VEHICLES_HP] = gBuffEffect.SIEGE_VEHICLES_HP_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.SOLDIER_LOAD] = gBuffEffect.SOLDIER_LOAD_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.RESOURCE_PROTECT] = gBuffEffect.RESOURCE_PROTECT_BOOST
;("equipmentltCtrl")[gEquipmentExtraProperty.WISH_RESOURCE] = gBuffEffect.WISH_RESOURCE_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.UPGRADE_BUILD_COST_RES_REDUCE] = gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.INSTANT_BUILD_SPEED] = gBuffEffect.INSTANT_BUILD_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.INSTANT_RESEARCH_SPEED] = gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.ALL_WOOD_OUTPUT] = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.ALL_FOOD_OUTPUT] = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.ALL_IRON_OUTPUT] = gBuffEffect.ALL_IRON_OUTPUT_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.ALL_MITHRIL_OUTPUT] = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.IRON_GATHER_SPEED] = gBuffEffect.IRON_GATHER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.WOOD_GATHER_SPEED] = gBuffEffect.WOOD_GATHER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.FOOD_GATHER_SPEED] = gBuffEffect.FOOD_GATHER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.STUDY_RESOURCE_REDUCE] = gBuffEffect.STUDY_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.STAMINA_RECOVER_SPEED] = gBuffEffect.STAMINA_RECOVER_SPEED_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.FOOD_CONSUME_REDUCE] = gBuffEffect.FOOD_CONSUME_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.GOLD_COLLECTION] = gBuffEffect.GATHER_GOLD_SPEED_UP
;("equipmentltCtrl")[gEquipmentBaseProperty.NPCWAR_WOUNDED_RESTORE] = gBuffEffect.NPCWAR_WOUNDED_RESTORE
;("equipmentltCtrl")[gEquipmentBaseProperty.JUNIOR_COLLECT_KO] = gBuffEffect.JUNIOR_COLLECT_KO
;("equipmentltCtrl")[gEquipmentBaseProperty.TREATMENT_WOUNDED_RESOURCE] = gBuffEffect.TREATMENT_WOUNDED_RESOURCE
;("equipmentltCtrl")[gEquipmentBaseProperty.TROOP_ATTACK_DEFENSE_HP_BOOST] = gBuffEffect.TROOP_ATTACK_DEFENSE_HP_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.CONSTRUCTION_SPEED_120] = gBuffEffect.CONSTRUCTION_SPEED_120
;("equipmentltCtrl")[gEquipmentBaseProperty.RADIANCE_WAR_BADGE_YIELD] = gBuffEffect.RADIANCE_WAR_BADGE_YIELD
;("equipmentltCtrl")[gEquipmentBaseProperty.RADIANCE_WAR_SENIOR_BADGE_YIELD] = gBuffEffect.RADIANCE_WAR_SENIOR_BADGE_YIELD
;("equipmentltCtrl")[gEquipmentBaseProperty.RADIANCE_WAR_STAR_SHINE_YIELD] = gBuffEffect.RADIANCE_WAR_STAR_SHINE_YIELD
;("equipmentltCtrl")[gEquipmentBaseProperty.RADIANCE_WAR_AMBER_YIELD] = gBuffEffect.RADIANCE_WAR_AMBER_YIELD
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_BASE_ATTACK] = gBuffEffect.SOLDIER_BASE_ATTACK
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_BASE_DEFENSE] = gBuffEffect.SOLDIER_BASE_DEFENSE
;("equipmentltCtrl")[gEquipmentBaseProperty.SOLDIER_BASE_HP] = gBuffEffect.SOLDIER_BASE_HP
;("equipmentltCtrl")[gEquipmentBaseProperty.MARCH_VALUE_LIMIT_BOOST] = gBuffEffect.MARCH_VALUE_LIMIT_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.CLUMP_NUM_BOOST] = gBuffEffect.CLUMP_NUM_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.SUIT_ARMY_TRAIN_RESOURCE_REDUCE] = gBuffEffect.SUIT_ARMY_TRAIN_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.SUIT_INFANTRY_TRAIN_RESOURCE_REDUCE] = gBuffEffect.SUIT_INFANTRY_TRAIN_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.SUIT_CAVALRY_TRAIN_RESOURCE_REDUCE] = gBuffEffect.SUIT_CAVALRY_TRAIN_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.SUIT_ARCHER_TRAIN_RESOURCE_REDUCE] = gBuffEffect.SUIT_ARCHER_TRAIN_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.SUIT_SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE] = gBuffEffect.SUIT_SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE
;("equipmentltCtrl")[gEquipmentBaseProperty.INFANTRY_TRAIN_BOOST] = gBuffEffect.INFANTRY_TRAIN_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.CAVALRY_TRAIN_BOOST] = gBuffEffect.CAVALRY_TRAIN_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.ARCHER_TRAIN_BOOST] = gBuffEffect.ARCHER_TRAIN_BOOST
;("equipmentltCtrl")[gEquipmentBaseProperty.SIEGE_VEHICLES_TRAIN_BOOST] = gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.CONSTRUCTION_SPEED_30] = gBuffEffect.CONSTRUCTION_SPEED_30
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30] = gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.INFANTRY_TRAIN_BOOST_LESS_10] = gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_10
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.CAVALRY_TRAIN_BOOST_LESS_10] = gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_10
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.ARCHER_TRAIN_BOOST_LESS_10] = gBuffEffect.ARCHER_TRAIN_BOOST_LESS_10
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.SIEGE_VEHICLES_TRAIN_BOOST_LESS_10] = gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_10
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.INFANTRY_TRAIN_BOOST_LESS_11] = gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_11
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.CAVALRY_TRAIN_BOOST_LESS_11] = gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_11
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.ARCHER_TRAIN_BOOST_LESS_11] = gBuffEffect.ARCHER_TRAIN_BOOST_LESS_11
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.SIEGE_VEHICLES_TRAIN_BOOST_LESS_11] = gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_11
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.SINGLE_TRAINING_SOLDIERS_NUMBER] = gBuffEffect.SINGLE_TRAINING_SOLDIERS_NUMBER
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.CONSTRUCTION_SPEED_Z4] = gBuffEffect.CONSTRUCTION_SPEED_Z4
;("equipmentltCtrl")[gEquipmentSuitExtraProperty.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4] = gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4
local ("equipmentltCtrl")[gEquipmentBaseProperty.HALLOFWAR_ARMY_UP_PERCENT], equipmentAdditionID_buffEffectType = gBuffEffect.HALLOFWAR_ARMY_UP_PERCENT, "equipmentltCtrl"
local _ENV, addition_list = gEquipmentBaseProperty.HALLOFWAR_ARMY_UP_PERCENT, gEquipmentBaseProperty.HALLOFWAR_ARMY_UP_PERCENT
local _ENV, equipmentAdditionMgr = gBuffEffect.HALLOFWAR_ARMY_UP_PERCENT, gBuffEffect.HALLOFWAR_ARMY_UP_PERCENT
function equipmentAdditionMgr.add(additionID, equipmentID, value, init)
	print("equipmentAdditionMgr.add:", additionID, equipmentID, value)
	if not addition_list[additionID] then
		_ENV = addition_list[additionID]
		addition_list[additionID].list, _ENV, addition_list[additionID].total = "equipmentAdditionMgr.add:", "equipmentAdditionMgr.add:", 0
	end
	addition_list[additionID] = addition_list[additionID]
	if "number" == type(value) and 0 < value then
		local addition = addition_list[additionID]
		local list = addition.list
		if not list[equipmentID] then
			list[equipmentID] = value
			addition.total = addition.total + value
			if not init then
				local buffEffectType = equipmentAdditionID_buffEffectType[additionID]
				local gametop = gModuleMgr.getObject("gametop")
				local buffCtrl = gametop.playertop_:getModule("buffCtrl")
				buffCtrl:dispatchBuffEvent(buffEffectType, gBuffSource.EQUIPMENT)
			end
		else
			print("equipmentAdditionMgr.add: repeat add equipment property! param:", additionID, equipmentID, value)
		end
	else
		print("equipmentAdditionMgr.add: value is error! param:", additionID, equipmentID, value)
	end
end
function equipmentAdditionMgr.remove(additionID, equipmentID)
	print("equipmentAdditionMgr.remove:", additionID, equipmentID)
	local addition = addition_list[additionID]
	if addition then
		local value = addition.list[equipmentID]
		if value then
			addition.list[equipmentID] = nil
			addition.total = addition.total - value
			if addition.total < 0 then
				print(string.format("equipmentAdditionMgr.remove: total(%s) < 0! param:", tostring(addition.total)), additionID, equipmentID)
			end
			local buffEffectType = equipmentAdditionID_buffEffectType[additionID]
			local gametop = gModuleMgr.getObject("gametop")
			local buffCtrl = gametop.playertop_:getModule("buffCtrl")
			buffCtrl:dispatchBuffEvent(buffEffectType, gBuffSource.EQUIPMENT)
		end
	end
end
_ENV, equipmentAdditionMgr.query = function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end, function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TROOP_ATTACK_BOOST] = gEquipmentBaseProperty.SOLDIER_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TROOP_DEFENSE_BOOST] = gEquipmentBaseProperty.SOLDIER_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TRAIN_SPEED_BOOST] = gEquipmentBaseProperty.SOLDIER_TRAIN_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TROOP_HP_BOOST] = gEquipmentBaseProperty.SOLDIER_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.MARCH_SPEED_BOOST] = gEquipmentBaseProperty.MARCH_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.BUILD_SPEED_BOOST] = gEquipmentBaseProperty.BUILD_BUILDING_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RESOURCE_OUTPUT_BOOST] = gEquipmentExtraProperty.RESOURCE_OUTPUT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.MARCH_MONSTER_SPEED_BOOST] = gEquipmentExtraProperty.MARCH_MONSTER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TRAP_ATTACK] = gEquipmentExtraProperty.TRAP_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.MAKE_TRAP_SPEED_BOOST] = gEquipmentExtraProperty.MAKE_TRAP_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST] = gEquipmentExtraProperty.WOUNDED_SOLDIER_LIMIT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CURE_SOLDIER_SPEED_BOOST] = gEquipmentExtraProperty.CURE_SOLDIER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RESEARCH_SPEED_BOOST] = gEquipmentExtraProperty.RESEARCH_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.FORGE_EQUIPMENT_SPEED_BOOST] = gEquipmentExtraProperty.FORGE_EQUIPMENT_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.KILL_MONSTER_EXP_BOOST] = gEquipmentExtraProperty.KILL_MONSTER_EXP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_ATTACK_BOOST] = gEquipmentExtraProperty.INFANTRY_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_ATTACK_BOOST] = gEquipmentExtraProperty.CAVALRY_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_ATTACK_BOOST] = gEquipmentExtraProperty.ARCHER_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_ATTACK_BOOST] = gEquipmentExtraProperty.SIEGE_VEHICLES_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_DEFENSE_BOOST] = gEquipmentExtraProperty.INFANTRY_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_DEFENSE_BOOST] = gEquipmentExtraProperty.CAVALRY_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_DEFENSE_BOOST] = gEquipmentExtraProperty.ARCHER_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_DEFENSE_BOOST] = gEquipmentExtraProperty.SIEGE_VEHICLES_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_HP_BOOST] = gEquipmentExtraProperty.INFANTRY_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_HP_BOOST] = gEquipmentExtraProperty.CAVALRY_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_HP_BOOST] = gEquipmentExtraProperty.ARCHER_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_HP_BOOST] = gEquipmentExtraProperty.SIEGE_VEHICLES_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SOLDIER_LOAD_BOOST] = gEquipmentExtraProperty.SOLDIER_LOAD
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RESOURCE_PROTECT_BOOST] = gEquipmentExtraProperty.RESOURCE_PROTECT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.WISH_RESOURCE_BOOST] = gEquipmentExtraProperty.WISH_RESOURCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE] = gEquipmentBaseProperty.UPGRADE_BUILD_COST_RES_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INSTANT_BUILD_SPEED_BOOST] = gEquipmentBaseProperty.INSTANT_BUILD_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST] = gEquipmentBaseProperty.INSTANT_RESEARCH_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ALL_WOOD_OUTPUT_BOOST] = gEquipmentBaseProperty.ALL_WOOD_OUTPUT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ALL_FOOD_OUTPUT_BOOST] = gEquipmentBaseProperty.ALL_FOOD_OUTPUT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ALL_IRON_OUTPUT_BOOST] = gEquipmentBaseProperty.ALL_IRON_OUTPUT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST] = gEquipmentBaseProperty.ALL_MITHRIL_OUTPUT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.IRON_GATHER_SPEED_BOOST] = gEquipmentBaseProperty.IRON_GATHER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.WOOD_GATHER_SPEED_BOOST] = gEquipmentBaseProperty.WOOD_GATHER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.FOOD_GATHER_SPEED_BOOST] = gEquipmentBaseProperty.FOOD_GATHER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.STUDY_RESOURCE_REDUCE] = gEquipmentBaseProperty.STUDY_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.STAMINA_RECOVER_SPEED_BOOST] = gEquipmentBaseProperty.STAMINA_RECOVER_SPEED
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.FOOD_CONSUME_REDUCE] = gEquipmentBaseProperty.FOOD_CONSUME_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.GATHER_GOLD_SPEED_UP] = gEquipmentBaseProperty.GOLD_COLLECTION
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.NPCWAR_WOUNDED_RESTORE] = gEquipmentBaseProperty.NPCWAR_WOUNDED_RESTORE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.JUNIOR_COLLECT_KO] = gEquipmentBaseProperty.JUNIOR_COLLECT_KO
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TREATMENT_WOUNDED_RESOURCE] = gEquipmentBaseProperty.TREATMENT_WOUNDED_RESOURCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RADIANCE_WAR_BADGE_YIELD] = gEquipmentBaseProperty.RADIANCE_WAR_BADGE_YIELD
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RADIANCE_WAR_SENIOR_BADGE_YIELD] = gEquipmentBaseProperty.RADIANCE_WAR_SENIOR_BADGE_YIELD
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RADIANCE_WAR_STAR_SHINE_YIELD] = gEquipmentBaseProperty.RADIANCE_WAR_STAR_SHINE_YIELD
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.RADIANCE_WAR_AMBER_YIELD] = gEquipmentBaseProperty.RADIANCE_WAR_AMBER_YIELD
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SOLDIER_BASE_ATTACK] = gEquipmentBaseProperty.SOLDIER_BASE_ATTACK
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SOLDIER_BASE_DEFENSE] = gEquipmentBaseProperty.SOLDIER_BASE_DEFENSE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SOLDIER_BASE_HP] = gEquipmentBaseProperty.SOLDIER_BASE_HP
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CLUMP_NUM_BOOST] = gEquipmentBaseProperty.CLUMP_NUM_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CONSTRUCTION_SPEED_30] = gEquipmentSuitExtraProperty.CONSTRUCTION_SPEED_30
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30] = gEquipmentSuitExtraProperty.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_10] = gEquipmentSuitExtraProperty.INFANTRY_TRAIN_BOOST_LESS_10
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_10] = gEquipmentSuitExtraProperty.CAVALRY_TRAIN_BOOST_LESS_10
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_TRAIN_BOOST_LESS_10] = gEquipmentSuitExtraProperty.ARCHER_TRAIN_BOOST_LESS_10
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_10] = gEquipmentSuitExtraProperty.SIEGE_VEHICLES_TRAIN_BOOST_LESS_10
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_11] = gEquipmentSuitExtraProperty.INFANTRY_TRAIN_BOOST_LESS_11
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_11] = gEquipmentSuitExtraProperty.CAVALRY_TRAIN_BOOST_LESS_11
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_TRAIN_BOOST_LESS_11] = gEquipmentSuitExtraProperty.ARCHER_TRAIN_BOOST_LESS_11
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_11] = gEquipmentSuitExtraProperty.SIEGE_VEHICLES_TRAIN_BOOST_LESS_11
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SINGLE_TRAINING_SOLDIERS_NUMBER] = gEquipmentSuitExtraProperty.SINGLE_TRAINING_SOLDIERS_NUMBER
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SOLDIER_TRAIN_ADD_LIMIT] = gEquipmentSuitExtraProperty.SINGLE_TRAINING_SOLDIERS_NUMBER
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CONSTRUCTION_SPEED_Z4] = gEquipmentSuitExtraProperty.CONSTRUCTION_SPEED_Z4
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4] = gEquipmentSuitExtraProperty.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.MITHRIL_GATHER_SPEED_BOOST] = gEquipmentSuitExtraProperty.MITHRIL_GATHER_SPEED_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.GATHER_SPEED_BOOST] = gEquipmentSuitExtraProperty.GATHER_SPEED_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST] = gEquipmentSuitExtraProperty.ALL_CRYSTAL_OUTPUT_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] = gEquipmentBaseProperty.MARCH_VALUE_LIMIT_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.HALLOFWAR_ARMY_UP_PERCENT] = gEquipmentBaseProperty.HALLOFWAR_ARMY_UP_PERCENT
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SUIT_ARMY_TRAIN_RESOURCE_REDUCE] = gEquipmentBaseProperty.SUIT_ARMY_TRAIN_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SUIT_INFANTRY_TRAIN_RESOURCE_REDUCE] = gEquipmentBaseProperty.SUIT_INFANTRY_TRAIN_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SUIT_CAVALRY_TRAIN_RESOURCE_REDUCE] = gEquipmentBaseProperty.SUIT_CAVALRY_TRAIN_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SUIT_ARCHER_TRAIN_RESOURCE_REDUCE] = gEquipmentBaseProperty.SUIT_ARCHER_TRAIN_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SUIT_SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE] = gEquipmentBaseProperty.SUIT_SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.INFANTRY_TRAIN_BOOST] = gEquipmentBaseProperty.INFANTRY_TRAIN_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CAVALRY_TRAIN_BOOST] = gEquipmentBaseProperty.CAVALRY_TRAIN_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.ARCHER_TRAIN_BOOST] = gEquipmentBaseProperty.ARCHER_TRAIN_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST] = gEquipmentBaseProperty.SIEGE_VEHICLES_TRAIN_BOOST
;(function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.TROOP_ATTACK_DEFENSE_HP_BOOST] = gEquipmentBaseProperty.TROOP_ATTACK_DEFENSE_HP_BOOST
local (function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end)[gBuffEffect.CONSTRUCTION_SPEED_120], buffEffectType_equipmentAdditionID = gEquipmentBaseProperty.CONSTRUCTION_SPEED_120, function(additionID)
	if additionID then
		local addition = addition_list[additionID]
		if addition and addition.total > 0 then
			return addition.total, addition.list
		end
	else
		print("equipmentAdditionMgr.query: additionID error! additionID = ", additionID)
	end
end
function equipmentAdditionMgr.queryByBuffEffectType(effectType)
	local additionID = buffEffectType_equipmentAdditionID[effectType]
	if additionID then
		return equipmentAdditionMgr.query(additionID)
	end
end
function equipmentAdditionMgr.wearSuitCombineProperty(suitKey)
	local suitList = equipDesRead.getSuitInfoList()
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(suitKey)
	local equipDesRead, qualityTable = suitKey, suitKey
	for i = 1, #suitList[suitKey] do
		for j = 1, #tabelBaseList do
			if tabelBaseList[j]:getEID() == suitList[suitKey][i].equipid and tabelBaseList[j]:isWearing() then
				local quality = 0
				if quality < tabelBaseList[j]:getEquipmentQuality() then
					quality = tabelBaseList[j]:getEquipmentQuality()
				end
				table.insert(qualityTable, quality)
			end
		end
	end
	table.sort(qualityTable, function(a, b)
		return b < a
	end)
	if qualityTable and next(qualityTable) then
		local key = suitKey + 100000
		if 2 <= #qualityTable and #qualityTable < 4 then
			if #qualityTable == 3 then
				equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			end
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
		elseif 4 <= #qualityTable and #qualityTable < 6 then
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
			if #qualityTable == 5 then
				equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType2, key)
			end
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType2, key, suitResultInfo.SuitpropertyValue2[qualityTable[4] + 1])
		elseif #qualityTable == 6 then
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType2, key)
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType2, key, suitResultInfo.SuitpropertyValue2[qualityTable[4] + 1])
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType3, key, suitResultInfo.SuitpropertyValue3[qualityTable[6] + 1])
		end
	end
end
function equipmentAdditionMgr.takeOffSuitCombineProperty(suitKey)
	local suitList = equipDesRead.getSuitInfoList()
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(suitKey)
	local equipDesRead, qualityTable = suitKey, suitKey
	for i = 1, #suitList[suitKey] do
		for j = 1, #tabelBaseList do
			if tabelBaseList[j]:getEID() == suitList[suitKey][i].equipid and tabelBaseList[j]:isWearing() then
				local quality = 0
				if quality < tabelBaseList[j]:getEquipmentQuality() then
					quality = tabelBaseList[j]:getEquipmentQuality()
				end
				table.insert(qualityTable, quality)
			end
		end
	end
	table.sort(qualityTable, function(a, b)
		return b < a
	end)
	if qualityTable and next(qualityTable) then
		local key = suitKey + 100000
		if 1 <= #qualityTable and #qualityTable < 3 then
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			if #qualityTable == 2 then
				equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
			end
		elseif 3 <= #qualityTable and #qualityTable < 5 then
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType2, key)
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
			if #qualityTable == 4 then
				equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType2, key, suitResultInfo.SuitpropertyValue2[qualityTable[4] + 1])
			end
		elseif #qualityTable == 5 then
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType1, key)
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType2, key)
			equipmentAdditionMgr.remove(suitResultInfo.SuitpropertyType3, key)
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType1, key, suitResultInfo.SuitpropertyValue1[qualityTable[2] + 1])
			equipmentAdditionMgr.add(suitResultInfo.SuitpropertyType2, key, suitResultInfo.SuitpropertyValue2[qualityTable[4] + 1])
		end
	end
end
function equipmentAdditionMgr.clean()
	addition_list = nil
end
function equipmentAdditionMgr.dump()
	dump(addition_list, "addition_list")
end
return equipmentAdditionMgr

local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local _ENV, _ENV, publicUtil = nil, "divineBeastCtrl", "divineBeastCtrl"
;(nil)[gIDDef.ITEM_RECYCLE_TOKEN] = true
;(nil)[gIDDef.ITEM_RECYCLE_TOKEN_LV1] = true
;(nil)[gIDDef.ITEM_RECYCLE_TOKEN_LV2] = true
local (nil)[gIDDef.ITEM_RECYCLE_TOKEN_LV3], ITEM_RECYCLE_TOKEN_SET = true, nil
function publicUtil.getCount(id)
	if not id then
		print("publicUtil.getCount: id is nil")
		return -1
	end
	id = tonumber(id)
	if id == gIDDef.DIVINE_BEAST_MARK_ENERGY then
		return divineBeastMarkCtrl:getEnergyCount()
	elseif ITEM_RECYCLE_TOKEN_SET[id] then
		return cityCtrl:getItemRecycleToken(id)
	elseif id == gIDDef.MAGIC_LAMP_SKILL_ENERGY or id == gIDDef.MAGIC_LAMP_SKILL_ENERGY_SSS then
		local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
		return magicLampSkillCtrl:getItemCount(id)
	elseif id == gIDDef.PURPLE_AGATE then
		local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
		return activityExchangeMallCtrl:getPurpleAgateNum()
	elseif id == gIDDef.GARDEN_FARMLAND_COIN then
		local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
		return manorCityCtrl:getFarmShopCoin()
	end
	local sType = serviceFunctions.getIDType(id)
	if gIDType.DIVINE_BEAST_RES == sType then
		return divineBeastCtrl:getItemCount(id)
	elseif gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		return backpackCtrl:getItemCount(id)
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		return warGemCtrl:getItemCount(id)
	elseif gIDType.GOLD == sType then
		return SoraDGetGold()
	elseif include("resDesRead").checkResID(id) then
		return cityCtrl:getResCount(id) or -1
	else
		print("undefined type " .. sType .. " id:" .. id)
	end
	return -1
end
return publicUtil

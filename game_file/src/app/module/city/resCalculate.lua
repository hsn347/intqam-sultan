local gametop = gModuleMgr.getObject("gametop")
local gamemodulec = include("GameModule")
local resCalculate = class("resCalculate", gamemodulec)
_ENV = "resCalculate"
;("resCalculate")[BUILDID.FARM] = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
;("resCalculate")[BUILDID.SAWMILL] = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
;("resCalculate")[BUILDID.IRON_MINE] = gBuffEffect.ALL_IRON_OUTPUT_BOOST
;("resCalculate")[BUILDID.STEEL] = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
resCalculate.BUILDID2BUFFEFFECT, ("resCalculate")[BUILDID.CRYSTAL_MINE] = "resCalculate", gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
function resCalculate:ctor(properties)
	resCalculate.super.ctor(self, properties)
	self:resetData()
end
function resCalculate:EnterGame()
	gametop.playertop_:getModule("loginDataInitCtrl"):addEventListener(gEventName.event_client_req_data_complete, handler(self, self.initData))
	local lordSkillCtrl = gametop.playertop_:getModule("lordSkillCtrl")
	lordSkillCtrl:addEventListener(gEventName.event_skill_update, handler(self, self.initSkillAdd))
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local techFoodEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.FOOD_PRODUCTIVITY)
	local techWoodEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.WOOD_PRODUCTIVITY)
	local techIronEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.IRON_PRODUCTIVITY)
	local techMithrilEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.MITHRIL_PRODUCTIVITY)
	local techCrystalEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.CRYSTAL_PRODUCTIVITY_BOOST)
	local armyCostFoodEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.FRCES_CONSUMPTION)
	technologyCtrl:addEventListener(techFoodEventName, handler(self, self.initTechnologyAdd))
	technologyCtrl:addEventListener(techWoodEventName, handler(self, self.initTechnologyAdd))
	technologyCtrl:addEventListener(techIronEventName, handler(self, self.initTechnologyAdd))
	technologyCtrl:addEventListener(techMithrilEventName, handler(self, self.initTechnologyAdd))
	technologyCtrl:addEventListener(techCrystalEventName, handler(self, self.initTechnologyAdd))
	technologyCtrl:addEventListener(armyCostFoodEventName, handler(self, self.initArmyCostFood))
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	hegemonCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initArmyCostFood))
	local warTechEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.RES_PRODUCTIVITY_BOOST)
	technologyCtrl:addEventListener(warTechEventName, handler(self, self.initTechnologyAdd))
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	allianceScience:addEventListener(gEventName.event_alliance_science_success, handler(self, self.initAllianceSciAdd))
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordInfoCtrl:addEventListener(gEventName.event_vip_update, handler(self, self.initVipAdd))
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	cityCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initToolAdd))
	local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
	miraculousWeaponCtrl:addEventListener(gEventName.event_miraculous_weapon_update, handler(self, self.initMiraculousWeaponAdd))
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initToolAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initVipAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initArmyCostFood))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initOfficialAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initOfficialDec))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initAchieveAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initActivityAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initKingdomLevelAdd))
	buffCtrl:addEventListener(gEventName.event_buff_update, handler(self, self.initMiraculousWeaponAdd))
	local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
	equipmentCtrl:addEventListener(gEventName.event_equip_update, handler(self, self.initEquipAdd))
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	conquestWarCtrl:addEventListener(gEventName.event_conquestwar_win_buff_update, handler(self, self.initConquestWarAdd))
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	petCtrl:addEventListener(gEventName.event_pet_update, handler(self, self.initPetAdd))
	local magicLampCtrl = gametop.playertop_:getModule("magicLampCtrl")
	magicLampCtrl:addEventListener(gEventName.event_magic_lamp_update, handler(self, self.initMagicLampAdd))
end
function resCalculate:Logout()
	resCalculate.super.Logout(self)
	self:resetData()
end
function resCalculate:initGuardianAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.add_guardian_farm = buffCtrl:getBuffEffect(gBuffEffect.ALL_FOOD_OUTPUT_BOOST, gBuffSource.GUARD_ACTIVITY)
	self.add_guardian_sawmill = buffCtrl:getBuffEffect(gBuffEffect.ALL_WOOD_OUTPUT_BOOST, gBuffSource.GUARD_ACTIVITY)
	self.add_guardian_ironmine = buffCtrl:getBuffEffect(gBuffEffect.ALL_IRON_OUTPUT_BOOST, gBuffSource.GUARD_ACTIVITY)
	self.add_guardian_steel = buffCtrl:getBuffEffect(gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST, gBuffSource.GUARD_ACTIVITY)
	self.add_guardian_crystal = buffCtrl:getBuffEffect(gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST, gBuffSource.GUARD_ACTIVITY)
	self.add_guardian_farm = self.add_guardian_farm and self.add_guardian_farm / 1000 or 0
	self.add_guardian_sawmill = self.add_guardian_sawmill and self.add_guardian_sawmill / 1000 or 0
	self.add_guardian_ironmine = self.add_guardian_ironmine and self.add_guardian_ironmine / 1000 or 0
	self.add_guardian_steel = self.add_guardian_steel and self.add_guardian_steel / 1000 or 0
	self.add_guardian_crystal = self.add_guardian_crystal and self.add_guardian_crystal / 1000 or 0
end
function resCalculate:initNebulaTowerAdd()
	print("resCalculate:initNebulaTowerAdd")
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	self.add_nebulaTower_farm = nebulaActivityCtrl:getNebulaTowerBuffEffect(gBuffEffect.ALL_FOOD_OUTPUT_BOOST) / 1000
	self.add_nebulaTower_sawmill = nebulaActivityCtrl:getNebulaTowerBuffEffect(gBuffEffect.ALL_WOOD_OUTPUT_BOOST) / 1000
	self.add_nebulaTower_ironmine = nebulaActivityCtrl:getNebulaTowerBuffEffect(gBuffEffect.ALL_IRON_OUTPUT_BOOST) / 1000
	self.add_nebulaTower_steel = nebulaActivityCtrl:getNebulaTowerBuffEffect(gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST) / 1000
	self.add_nebulaTower_crystal = nebulaActivityCtrl:getNebulaTowerBuffEffect(gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST) / 1000
end
function resCalculate:initSkillAdd()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.add_skill_farm = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FOOD_PRODUCTION)
	self.add_skill_sawmill = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.WOOD_PRODUCTION)
	self.add_skill_ironmine = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.IRON_ORE_PRODUCTION)
	self.add_skill_steel = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.MITHRIL_YIELD)
	self.add_skill_crystal = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CRYSTAL_PRODUCTION)
end
function resCalculate:initTechnologyAdd()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local warTechAdd = technologyCtrl:getTechnologyPower(gTechnologyType.RES_PRODUCTIVITY_BOOST) or 0
	self.add_technology_farm = technologyCtrl:getTechnologyPower(gTechnologyType.FOOD_PRODUCTIVITY) + warTechAdd
	self.add_technology_sawmill = technologyCtrl:getTechnologyPower(gTechnologyType.WOOD_PRODUCTIVITY) + warTechAdd
	self.add_technology_ironmine = technologyCtrl:getTechnologyPower(gTechnologyType.IRON_PRODUCTIVITY) + warTechAdd
	self.add_technology_steel = technologyCtrl:getTechnologyPower(gTechnologyType.MITHRIL_PRODUCTIVITY) + warTechAdd
	self.add_technology_crystal = technologyCtrl:getTechnologyPower(gTechnologyType.CRYSTAL_PRODUCTIVITY_BOOST) + warTechAdd
end
function resCalculate:initAllianceSciAdd()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	self.add_allianceSci_farm = allianceScience:getScienceAddValue(gAScienceType.FOOD_OUTPUT)
	self.add_allianceSci_sawmill = allianceScience:getScienceAddValue(gAScienceType.WOOD_OUTPUT)
	self.add_allianceSci_ironmine = allianceScience:getScienceAddValue(gAScienceType.IRON_OUTPUT)
	self.add_allianceSci_steel = allianceScience:getScienceAddValue(gAScienceType.MITHRIL_OUTPUT)
	self.add_allianceSci_crystal = allianceScience:getScienceAddValue(gAScienceType.CRYSTAL_OUTPUT)
end
function resCalculate:initVipAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.add_vip = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.VIP)
	if self.add_vip then
		self.add_vip = self.add_vip / 1000
	else
		self.add_vip = 0
	end
end
function resCalculate:initOfficialAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.add_official = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.OFFICIAL)
	if self.add_official then
		self.add_official = self.add_official / 1000
	else
		self.add_official = 0
	end
end
function resCalculate:initOfficialDec()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.desc_official = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_REDUCE, gBuffSource.OFFICIAL)
	if self.desc_official then
		self.desc_official = self.desc_official / 1000
	else
		self.desc_official = 0
	end
end
function resCalculate:initToolAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildLogic = include("buildLogic")
	local buildlist = cityCtrl:getBuildList()
	for k, bcell in pairs(buildlist) do
		local bid = tonumber(bcell.info.bid)
		local iid = tonumber(bcell.info.iid)
		if buildLogic.judgeIsResBuild(bid) then
			local bufftype = gBuffEffect.FOOD_OUTPUT_BOOST
			if bid == BUILDID.FARM then
				bufftype = gBuffEffect.FOOD_OUTPUT_BOOST
			elseif bid == BUILDID.SAWMILL then
				bufftype = gBuffEffect.WOOD_OUTPUT_BOOST
			elseif bid == BUILDID.IRON_MINE then
				bufftype = gBuffEffect.IRON_OUTPUT_BOOST
			elseif bid == BUILDID.STEEL then
				bufftype = gBuffEffect.MITHRIL_OUTPUT_BOOST
			elseif bid == BUILDID.CRYSTAL_MINE then
				bufftype = gBuffEffect.CRYSTAL_OUTPUT_BOOST
			end
			local add_tool = buffCtrl:getResourceBoostEffect(bufftype, bid, iid)
			if add_tool then
				add_tool = add_tool / 1000
			else
				add_tool = 0
			end
			if not self.add_tool[bid] then
				self.add_tool[bid], gametop = bufftype, bufftype
			end
			self.add_tool[bid][iid] = add_tool
		end
	end
end
function resCalculate:initArmyCostFood()
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	self.armyCostFoodHour = armyCtrl:getTotalArmyCostFood()
end
function resCalculate:initEquipAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local equipadd = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.EQUIPMENT)
	if equipadd then
		self.equipAdd = equipadd / 1000
	else
		self.equipAdd = 0
	end
end
function resCalculate:initAchieveAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.ACHIEVEMENT)
	if achieveadd then
		self.achieveAdd = achieveadd / 1000
	else
		self.achieveAdd = 0
	end
end
function resCalculate:initPetAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local petadd = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.PET)
	if petadd then
		self.petadd = petadd / 1000
	else
		self.petadd = 0
	end
end
function resCalculate:initActivityAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local activityadd = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.ACTIVITY)
	if activityadd then
		self.add_activity = activityadd / 1000
	else
		self.add_activity = 0
	end
end
function resCalculate:initConquestWarAdd()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	self.conquestwar_add = conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.RESOURCE_OUTPUT_BOOST).totalEffect or 0
end
function resCalculate:initMiraculousWeaponAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.miraculous_weapon_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.MIRACULOUS_WEAPON) or 0
end
function resCalculate:initMagicLampAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.magic_lamp_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.MAGIC_LAMP) or 0
end
function resCalculate:initKingdomLevelAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	self.kingdomLevel_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.KINGDOM_LEVEL) or 0
end
function resCalculate:initData()
	if userSDKManager.timeInfo.t_total.tend == 0 then
		userSDKManager.timeInfo.t_res.tbegin = SoraDGetSocketTime()
	end
	self:initGuardianAdd()
	self:initNebulaTowerAdd()
	self:initSkillAdd()
	self:initTechnologyAdd()
	self:initAllianceSciAdd()
	self:initVipAdd()
	self:initOfficialAdd()
	self:initOfficialDec()
	self:initToolAdd()
	self:initArmyCostFood()
	self:initEquipAdd()
	self:initAchieveAdd()
	self:initActivityAdd()
	self:initConquestWarAdd()
	self:initPetAdd()
	self:initKingdomLevelAdd()
	self:initMiraculousWeaponAdd()
	if userSDKManager.timeInfo.t_total.tend == 0 then
		userSDKManager.timeInfo.t_res.tend = SoraDGetSocketTime()
		userSDKManager.timeInfo.t_res.taccu = userSDKManager.timeInfo.t_res.taccu + (userSDKManager.timeInfo.t_res.tend - userSDKManager.timeInfo.t_res.tbegin)
	end
end
function resCalculate:resetData()
	self.add_skill_farm = 0
	self.add_skill_sawmill = 0
	self.add_skill_ironmine = 0
	self.add_skill_steel = 0
	self.add_skill_crystal = 0
	self.add_technology_farm = 0
	self.add_technology_sawmill = 0
	self.add_technology_ironmine = 0
	self.add_technology_steel = 0
	self.add_technology_crystal = 0
	self.add_allianceSci_farm = 0
	self.add_allianceSci_sawmill = 0
	self.add_allianceSci_ironmine = 0
	self.add_allianceSci_steel = 0
	self.add_allianceSci_crystal = 0
	self.add_guardian_farm = 0
	self.add_guardian_sawmill = 0
	self.add_guardian_ironmine = 0
	self.add_guardian_steel = 0
	self.add_guardian_crystal = 0
	self.add_nebulaTower_farm = 0
	self.add_nebulaTower_sawmill = 0
	self.add_nebulaTower_ironmine = 0
	self.add_nebulaTower_steel = 0
	self.add_nebulaTower_crystal = 0
	self.add_vip = 0
	self.add_official = 0
	self.add_tool, _UPVALUE0_, self.desc_official = nil, nil, 0
	self.armyCostFoodHour = 0
	self.equipAdd = 0
	self.achieveAdd = 0
	self.add_activity = 0
	self.conquestwar_add = 0
	self.petadd = 0
	self.kingdomLevel_add = 0
	self.miraculous_weapon_add = 0
	self.magic_lamp_add = 0
end
function resCalculate:getGuardianAdd(bid)
	if bid == BUILDID.FARM then
		return self.add_guardian_farm
	elseif bid == BUILDID.SAWMILL then
		return self.add_guardian_sawmill
	elseif bid == BUILDID.IRON_MINE then
		return self.add_guardian_ironmine
	elseif bid == BUILDID.STEEL then
		return self.add_guardian_steel
	elseif bid == BUILDID.CRYSTAL_MINE then
		return self.add_guardian_crystal
	end
	return 0
end
function resCalculate:getNebulaTowerAdd(bid)
	if bid == BUILDID.FARM then
		return self.add_nebulaTower_farm
	elseif bid == BUILDID.SAWMILL then
		return self.add_nebulaTower_sawmill
	elseif bid == BUILDID.IRON_MINE then
		return self.add_nebulaTower_ironmine
	elseif bid == BUILDID.STEEL then
		return self.add_nebulaTower_steel
	elseif bid == BUILDID.CRYSTAL_MINE then
		return self.add_nebulaTower_crystal
	end
	return 0
end
function resCalculate:getSkillAdd(bid)
	if bid == BUILDID.FARM then
		return self.add_skill_farm
	elseif bid == BUILDID.SAWMILL then
		return self.add_skill_sawmill
	elseif bid == BUILDID.IRON_MINE then
		return self.add_skill_ironmine
	elseif bid == BUILDID.STEEL then
		return self.add_skill_steel
	elseif bid == BUILDID.CRYSTAL_MINE then
		return self.add_skill_crystal
	end
	return 0
end
function resCalculate:getTechnologyAdd(bid)
	if bid == BUILDID.FARM then
		return self.add_technology_farm
	elseif bid == BUILDID.SAWMILL then
		return self.add_technology_sawmill
	elseif bid == BUILDID.IRON_MINE then
		return self.add_technology_ironmine
	elseif bid == BUILDID.STEEL then
		return self.add_technology_steel
	elseif bid == BUILDID.CRYSTAL_MINE then
		return self.add_technology_crystal
	end
	return 0
end
function resCalculate:getAllianceSciAdd(bid)
	if bid == BUILDID.FARM then
		return self.add_allianceSci_farm
	elseif bid == BUILDID.SAWMILL then
		return self.add_allianceSci_sawmill
	elseif bid == BUILDID.IRON_MINE then
		return self.add_allianceSci_ironmine
	elseif bid == BUILDID.STEEL then
		return self.add_allianceSci_steel
	elseif bid == BUILDID.CRYSTAL_MINE then
		return self.add_allianceSci_crystal
	end
	return 0
end
function resCalculate:getHeroAppointAdd(bid)
	if bid == BUILDID.FARM then
		return gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		return gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		return gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		return gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		return gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
end
function resCalculate:getVipAdd(bid)
	if self.add_vip then
		return self.add_vip
	end
	return 0
end
function resCalculate:getOfficialAdd()
	if self.add_official then
		return self.add_official
	end
	return 0
end
function resCalculate:getOfficialDec()
	if self.desc_official then
		return self.desc_official
	end
	return 0
end
function resCalculate:getToolAdd(bid, iid)
	local add_tool = 0
	if self.add_tool[bid] and self.add_tool[bid][iid] then
		add_tool = self.add_tool[bid][iid]
	end
	return add_tool
end
function resCalculate:getActivityAdd()
	if self.add_activity then
		return self.add_activity
	end
	return 0
end
function resCalculate:getConquestWarAdd()
	return self.conquestwar_add or 0
end
function resCalculate:getArmyCostFood()
	return 0
end
function resCalculate:getEquipAdd(bid)
	local bufftype2
	if bid == BUILDID.FARM then
		bufftype2 = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype2 = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype2 = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype2 = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype2 = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local buff_week_equip = 0
	if bufftype2 then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		buff_week_equip = buffCtrl:getBuffEffect(bufftype2, gBuffSource.EQUIPMENT) or 0
		buff_week_equip = buff_week_equip / 1000
	end
	if self.equipAdd then
		return self.equipAdd + buff_week_equip
	else
		return buff_week_equip
	end
end
function resCalculate:getPetAdd()
	if self.petadd then
		return self.petadd
	else
		return 0
	end
end
function resCalculate:getAchieveAdd()
	if self.achieveAdd then
		return self.achieveAdd
	else
		return 0
	end
end
function resCalculate:getBuffWeekAdd(bid)
	local bufftype2
	if bid == BUILDID.FARM then
		bufftype2 = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype2 = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype2 = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype2 = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype2 = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local buff_week_add = 0
	if bufftype2 then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		buff_week_add = buffCtrl:getBuffEffect(bufftype2, gBuffSource.RECHARGE_WEEK_CARD) or 0
		buff_week_add = buff_week_add / 1000
	end
	return buff_week_add
end
function resCalculate:getKingdomLevelAdd()
	if self.kingdomLevel_add then
		return self.kingdomLevel_add
	else
		return 0
	end
end
function resCalculate:getMiraculousWeaponAdd()
	if self.miraculous_weapon_add then
		return self.miraculous_weapon_add
	else
		return 0
	end
end
function resCalculate:getMagicLampAdd()
	if self.magic_lamp_add then
		return self.magic_lamp_add
	else
		return 0
	end
end
function resCalculate:getLegendLordAdd(bid)
	local bufftype
	if bid == BUILDID.FARM then
		bufftype = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local add = 0
	if bufftype then
		add = buffCtrl:getBuffEffect(bufftype, gBuffSource.LEGEND_TITLE) or 0
	end
	add = add + (buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.LEGEND_TITLE) or 0)
	return add
end
function resCalculate:getHegemonLordAdd(bid)
	local bufftype
	if bid == BUILDID.FARM then
		bufftype = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local add = 0
	if bufftype then
		add = buffCtrl:getBuffEffect(bufftype, gBuffSource.HEGEMON_TITLE) or 0
	end
	add = add + (buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.HEGEMON_TITLE) or 0)
	return add
end
function resCalculate:getWarGemAdd(bid)
	local bufftype2
	if bid == BUILDID.FARM then
		bufftype2 = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype2 = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype2 = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype2 = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype2 = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local add = 0
	if bufftype2 then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		add = buffCtrl:getBuffEffect(bufftype2, gBuffSource.WAR_GEM) or 0
		add = add / 1000
	end
	return add
end
function resCalculate:getHeroAdd(bid)
	local bufftype2
	if bid == BUILDID.FARM then
		bufftype2 = gBuffEffect.ALL_FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		bufftype2 = gBuffEffect.ALL_WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		bufftype2 = gBuffEffect.ALL_IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		bufftype2 = gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		bufftype2 = gBuffEffect.ALL_CRYSTAL_OUTPUT_BOOST
	end
	local add = 0
	if bufftype2 then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		add = buffCtrl:getBuffEffect(bufftype2, gBuffSource.HERO_SYSTEM) or 0
		add = add / 1000
	end
	return add
end
function resCalculate:getResCalculateAdd(bid, buffSourse)
	if not buffSourse then
		return 0
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, buffSourse) or 0
	local bufftype = resCalculate.BUILDID2BUFFEFFECT[bid]
	if bufftype then
		add = add + (buffCtrl:getBuffEffect(bufftype, buffSourse) or 0)
	end
	return add
end
return resCalculate

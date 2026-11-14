local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local equipmentltCtrl = include("equipmentltCtrl")
local msgCtrl = include("msgCtrl")
local msgNotice = include("msgNotice")
local equipmentCell = include("equipmentCell")
local equipmentMgr = include("equipmentMgr")
local equipmentAdditionMgr = include("equipmentAdditionMgr")
local cityltCtrl = include("cityltCtrl")
local equipmentSetMgr = include("equipmentSetMgr")
local shieldedWordsltCtrl = include("shieldedWordsltCtrl")
local equipmentCtrl = class("equipmentCtrl", gameModule)
local _ENV, REQ = "equipmentCtrl", "equipmentCtrl"
local _ENV, RSP = gameModule, gameModule
function equipmentCtrl:getNebulaExchangeInfo()
	return self.nebulaExchangeInfo
end
function equipmentCtrl:resetNebulaExchangeInfo()
	self.nebulaExchangeInfo, _UPVALUE0_ = nil, nil
end
function equipmentCtrl:getLimitRingShop()
	if not self.limitRingShop then
		_UPVALUE0_ = self.limitRingShop
	end
	return self.limitRingShop
end
function equipmentCtrl:getAttributeGroupInfoByIndex(quality, index)
	local key = string.format("%d_%d", quality, index)
	return self.attributeGroupInfo[key]
end
function equipmentCtrl:getAttributeGroupInfo(quality)
	local _ENV, array
	for k, v in pairs(self.attributeGroupInfo) do
		if v.quality == quality then
			table.insert(array, v)
		end
	end
	table.sort(array, function(a, b)
		return a.position < b.position
	end)
	return array
end
function equipmentCtrl:getNexPosition(quality)
	local position = 0
	for k, v in pairs(self.attributeGroupInfo) do
		if position < v.position then
			position = v.position
		end
	end
	return position + 1
end
function equipmentCtrl:getSettedAttributeGroupCount()
	return table.nums(self.attributeGroupInfo)
end
function equipmentCtrl:isNoticeAttribute(equipment, rExtra)
	local _ENV, retList
	local equipDesRead = include("equipDesRead")
	local quality = equipment:getEquipmentQuality()
	local attrGroup = self:getAttributeGroupInfo(quality)
	local _ENV, list = self, self
	local index = 1
	for k, v in pairs(attrGroup) do
		list[index], _ENV = nil, nil
		for ki, vi in ipairs(v.info) do
			local pro = equipDesRead.getPropertyType(vi)
			if pro then
				table.insert(list[index], pro)
			end
		end
		index = index + 1
	end
	local _ENV, rExtraList = (for generator), pairs(attrGroup)
	if not rExtra then
		rExtra, _ENV = pairs(attrGroup)
	end
	for k, v in ipairs(rExtra) do
		table.insert(rExtraList, v[1])
	end
	dump(rExtraList, "rExtraList=====")
	dump(list, "list=====")
	for k, v in ipairs(list) do
		local _ENV, isInList = table.insert, table.insert
		for m, n in ipairs(v) do
			isInList[m] = SoraDisInList(n, rExtraList)
		end
		dump(isInList, "isInList=====")
		local ret = true
		for p, q in pairs(isInList) do
			if not q then
				ret = false
			end
		end
		retList[k] = ret
	end
	local result = false
	dump(retList, "retList=====")
	for k, v in pairs(retList) do
		if v then
			result = true
			break
		end
	end
	return result
end
function equipmentCtrl:getForgingTime(eid, sid, quality)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local time = 0
	if sid ~= 0 then
		time = equipmentltCtrl.getForgeSuitTime(eid, quality)
	elseif quality == gQualityDef.ORANGE then
		time = equipmentltCtrl.getForgeOrangeEquipmentTime(eid)
	else
		time = equipmentltCtrl.getForgeEquipmentTime(eid)
	end
	print("配置的锻造时间：", time)
	local buildLogic = include("buildLogic")
	local forgeSpeed = buildLogic.getBuildBaseValue(BUILDID.BLACK_SMITH, "forgeSpeed")
	print("铁匠铺时间减少比例 = ", forgeSpeed)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buff = buffCtrl:getBuffEffect(gBuffEffect.FORGE_EQUIPMENT_SPEED_BOOST) or 0
	print("buff时间减少比例 = ", buff)
	local costTime = math.floor(time / (1 + (forgeSpeed + buff) / 1000))
	print("最终需要的时间：", costTime)
	return costTime
end
local getRealSteelNum = function(needSteel)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildLogic = include("buildLogic")
	local steelReduce = buildLogic.getBuildBaseValue(BUILDID.BLACK_SMITH, "steelReduce")
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	local buff = buffCtrl:getBuffEffect(gBuffEffect.EQUIPMENT_STEEL_COST_REDUCE) or 0
	print("钢材数减少比例：", steelReduce, buff)
	local reducePlus = math.min(steelReduce + buff, 900)
	needSteel = math.floor((1 - reducePlus / 1000) * needSteel)
	print("需要的钢材数：", needSteel)
	return needSteel
end
function equipmentCtrl:getRealSteelNumOfForging(eid, quality)
	local needSteel = equipmentltCtrl.getSteelNumOfForging(eid)
	if quality == gQualityDef.ORANGE then
		needSteel = equipmentltCtrl.getSteelNumOfForgeOrange(eid)
	end
	print("锻造配置的钢材数：", needSteel)
	return getRealSteelNum(needSteel)
end
function equipmentCtrl:getRealSteelNumOfSuitForging(eid, quality)
	local needSteel = equipmentltCtrl.getSteelNumOfSuitForging(eid, quality)
	print("套装锻造配置的钢材数：", eid, needSteel)
	return getRealSteelNum(needSteel)
end
function equipmentCtrl:getRealSteelNumOfStrengthen(elv, slv, equipType)
	local needSteel = equipmentltCtrl.getSteelNumOfStrengthen(elv, slv, equipType)
	print("强化配置的钢材数：", needSteel)
	return getRealSteelNum(needSteel)
end
function equipmentCtrl:getRealSteelNumOfRemake(quality)
	local needSteel = equipmentltCtrl.getRemakeSteelNum(quality)
	print("洗练配置的钢材数：", needSteel)
	return getRealSteelNum(needSteel)
end
function equipmentCtrl:isEquipmentLocked(epid)
	local equipment = equipmentMgr.getEquipment(epid)
	if equipment then
		return equipment:isLock()
	end
	return false
end
function equipmentCtrl:canEquipmentForge(eid, isOrange)
	if isOrange then
		return self:canOrangeEquipmentForge(eid)
	end
	local equipmentlist = equipmentMgr.getEquipmentList()
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local mainEquipmentLvRange1, mainEquipmentLvRange2 = equipmentltCtrl.getMainMaterialLv(eid)
	if mainEquipmentLvRange1 and mainEquipmentLvRange2 then
		local ok = false
		if equipmentlist then
			for epid, equipment in pairs(equipmentlist) do
				local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(equipment:getEID())
				local equipQuality = equipment:getEquipmentQuality()
				if not isSuitEquip then
					local lv = equipment:getEquipmentLV()
					if mainEquipmentLvRange1 <= lv and mainEquipmentLvRange2 >= lv and equipQuality ~= gQualityDef.ORANGE then
						ok = true
						break
					end
				end
			end
		end
		if not ok then
			return false, gErrDef.Err_MAIN_MATERIAL_LV_NOT_ENOUGH
		end
	end
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local materialBackpack = backpackCtrl:getBackpack(gBackpackDef.MATERIAL)
	if materialBackpack then
		local ok = true
		local materialInfo = equipmentltCtrl.getMaterialOfForging(eid)
		local equipmentMgr, temp = eid, eid
		for i, materialGroup in ipairs(materialInfo) do
			for j, materialID in ipairs(materialGroup) do
				local count = temp[materialID] and temp[materialID] + 1 or 1
				equipmentMgr = equipment:getEID()
				equipment:getEID()[materialID] = count
				if materialBackpack:checkItemCountEnough(equipment:getEID()) then
					ok = true
					temp[materialID] = temp[materialID] or 0
					temp[materialID] = temp[materialID] + 1
					break
				else
					ok = false
				end
			end
			if not ok then
				return false, gErrDef.Err_MATERIAL_NOT_ENOUGH
			end
		end
	end
	return true
end
function equipmentCtrl:canOrangeEquipmentForge(eid)
	local equipmentlist = equipmentMgr.getEquipmentList()
	local hasOrangeMainMaterial = false
	local orangeMainMaterialID
	local equipmentMgr, tabelList
	local mainMaterialList = equipmentltCtrl.getOrangeMainMaterial(eid)
	local ok = false
	for k, v in pairs(equipmentlist) do
		if mainMaterialList then
			local _quality = v:getEquipmentQuality()
			if v:getEID() == mainMaterialList[1] and _quality == mainMaterialList[2] or v:getEID() == mainMaterialList[3] and _quality == mainMaterialList[4] then
				table.insert(tabelList, v)
				if _quality == gQualityDef.ORANGE then
					hasOrangeMainMaterial = true
					orangeMainMaterialID = v:getEID()
				end
			end
		end
	end
	if next(tabelList) then
		ok = true
	end
	if not ok then
		return false, gErrDef.Err_MAIN_MATERIAL_LV_NOT_ENOUGH
	end
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local materialBackpack = backpackCtrl:getBackpack(gBackpackDef.MATERIAL)
	if materialBackpack then
		local ok = true
		local materialList = equipmentltCtrl.getMaterialOfForgeOrange(eid)
		local bluePrint = equipmentltCtrl.getBluePrintInfo(eid)
		if hasOrangeMainMaterial then
			local bluePrint2 = equipmentltCtrl.getBluePrintInfo(orangeMainMaterialID)
			bluePrint[2] = bluePrint[2] - bluePrint2[2]
		end
		for i, v in ipairs(bluePrint) do
			table.insert(materialList, v)
		end
		_ENV = ipairs(bluePrint)
		ipairs(bluePrint)[1] = "id"
		ipairs(bluePrint)[2] = "count"
		materialList = serviceFunctions.tableFormat(materialList, ipairs(bluePrint))
		for i, v in ipairs(materialList) do
			local itemCount = backpackCtrl:getItemCount(v.id)
			local needCount = v.count
			if itemCount < needCount then
				ok = false
				break
			end
		end
		if not ok then
			return false, gErrDef.Err_MATERIAL_NOT_ENOUGH
		end
	end
	return true
end
function equipmentCtrl:canSuitForge(eid, quality)
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local materialBackpack = backpackCtrl:getBackpack(gBackpackDef.MATERIAL)
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local quality = quality or 0
	if materialBackpack then
		local materialInfo = equipmentltCtrl.getSuitMaterialOfForging(eid, quality)
		for i = 1, #materialInfo / 2 do
			local materialID = tonumber(materialInfo[2 * i - 1])
			local needCount = tonumber(materialInfo[2 * i])
			local ownCount = backpackCtrl:getItemCount(materialID)
			if needCount > ownCount then
				return false
			end
		end
		if 0 < quality then
			for i, v in ipairs(tabelBaseList) do
				if tonumber(v:getEID()) == eid and v:getEquipmentQuality() == quality - 1 then
					return true
				end
			end
			return false
		end
	end
	return true
end
function equipmentCtrl:canGetEquipment()
	local forgingEquipment = equipmentMgr.getForgingEquipment()
	if forgingEquipment and forgingEquipment:isEquipmentComplete() then
		return true
	end
	return false
end
function equipmentCtrl:forgeEquipment(eid, materialArray, mainMaterialID)
	if eid and materialArray and 0 < #materialArray then
		REQ.reqForgeEquipment(eid, materialArray, mainMaterialID)
	else
		print("equipmentCtrl.forgeEquipment: param error!", eid, materialArray, mainMaterialID)
	end
end
function equipmentCtrl:forgeOrangeEquipment(eid, mainMaterialID)
	if eid then
		REQ.reqForgeOrangeEquipment(eid, mainMaterialID)
	else
		print("equipmentCtrl.forgeOrangeEquipment: param error!", eid, mainMaterialID)
	end
end
function equipmentCtrl:legendEquipLevelUp(mainMaterialID)
	if mainMaterialID then
		if self:isEquipmentLocked(mainMaterialID) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqLegendEquipLevelUp(mainMaterialID)
	else
		print("equipmentCtrl.legendEquipLevelUp: param error!", mainMaterialID)
	end
end
function equipmentCtrl:setAttributeGroupInfo(setType, quality, position, info, name)
	REQ.reqSetAttributeGroupInfo(setType, quality, position, info, name)
end
function equipmentCtrl:oneKeyDisassembleInfo(minLv, maxLv, qualitys, isStrengthen, isSuit)
	REQ.reqOneKeyDisassembleInfo(minLv, maxLv, qualitys, isStrengthen, isSuit)
end
function equipmentCtrl:recastEquipment(epid, isSenior)
	if self:isEquipmentLocked(epid) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	REQ.reqRecastEquipment(epid, isSenior)
end
function equipmentCtrl:equipmentExchange(epid)
	if self:isEquipmentLocked(epid) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	REQ.reqEquipmentExchange(epid)
end
function equipmentCtrl:equipmentOverdueReturn()
	REQ.reqEquipmentOverdueReturn()
end
function equipmentCtrl:equipmentNebulaExchange(epid)
	if self:isEquipmentLocked(epid) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	REQ.reqEquipmentNebulaExchange(epid)
end
function equipmentCtrl:getEquipment()
	local forgingEquipment = equipmentMgr.getForgingEquipment()
	if forgingEquipment and forgingEquipment:isEquipmentComplete() then
		local epid = forgingEquipment:getEPID()
		equipmentMgr.addEquipment(epid, forgingEquipment)
		equipmentMgr.setForgingEquipment(nil)
		forgingEquipment:cleanForgingInfo()
		REQ.reqGetEquipment(epid)
		equipmentMgr = epid
		epid.msg = "MESSAGE_UI_EQUIP_GET_SUCCESS"
		epid.epid = epid
		SoraDSendMessage(epid)
	end
	return forgingEquipment
end
function equipmentCtrl:strengthenEquipment(epid)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqStrengthenEquipment(epid)
	end
end
function equipmentCtrl:remakeEquipment(epid, materialID, lockInfo)
	print("equipmentCtrl:remakeEquipment", epid, materialID)
	if epid and 0 < epid and materialID and 0 < materialID then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		if self:canFreeRemaking() then
			REQ.reqFreeRemakingEquipment(epid, lockInfo)
		else
			REQ.reqRemakeEquipment(epid, materialID, lockInfo)
		end
	end
end
function equipmentCtrl:confirmRemakeProperty(epid)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqConfirmRemakeProperty(epid)
	end
end
function equipmentCtrl:remakeEquipmentTen(epid, lockInfo)
	print("equipmentCtrl:remakeEquipmentTen", epid)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqRemakeEquipmentTen(epid, lockInfo)
	end
end
function equipmentCtrl:confirmRemakeTenProperty(epid, idx)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqConfirmRemakeTenProperty(epid, idx)
	end
end
function equipmentCtrl:deleteRemakeProperty(epid)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqDeleteRemakeProperty(epid)
	end
end
function equipmentCtrl:wearEquipment(epid, part, setID)
	print("equipmentCtrl:wearEquipment", epid, part, setID)
	setID = setID or equipmentSetMgr:getActiveSet()
	local ok, condValue, condKey = self:isEquipmentSetUnlock(setID)
	if not ok then
		_ENV = nil
		;(nil).lv = condValue
		SoraDShowMsgTip(i18n("common_text_3242", nil))
		print("equipmentCtrl:wearEquipment failed! set is unlock!", condValue, condKey)
		return
	end
	local isWear = true
	if equipmentSetMgr:isActive(setID) then
		isWear = self:_wearEquipment(epid, part, setID)
	end
	if isWear then
		equipmentSetMgr:setPart(setID, part, epid)
		REQ.reqWearEquipment(epid, part, setID)
		_ENV = epid
		epid.msg = "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK"
		epid.setID = setID
		epid.epid = epid
		epid.part = part
		epid.isWearing = true
		SoraDSendMessage(epid)
	end
end
function equipmentCtrl:takeOffEquipment(epid, part, setID)
	setID = setID or equipmentSetMgr:getActiveSet()
	print("equipmentCtrl:wearEquipment", epid, part, setID)
	local ok, condValue, condKey = self:isEquipmentSetUnlock(setID)
	if not ok then
		equipmentSetMgr = nil
		;(nil).lv = condValue
		SoraDShowMsgTip(i18n("common_text_3242", nil))
		print("equipmentCtrl:wearEquipment failed! set is unlock!", condValue, condKey)
		return
	end
	local isTakeOff = true
	if equipmentSetMgr:isActive(setID) then
		isTakeOff = self:_takeOffEquipment(epid, part, setID)
	end
	if isTakeOff then
		equipmentSetMgr:resetPart(setID, part, epid)
		REQ.reqTakeOffEquipment(epid, part, setID)
		equipmentSetMgr = part
		part.name = gEventName.event_equip_update
		self:dispatchEvent(part)
		equipmentSetMgr = self
		self.msg = "MESSAGE_SERVER_EQUIP_WEAR_BACK"
		self.epid = epid
		self.part = part
		self.isWearing = false
		SoraDSendMessage(self)
		equipmentSetMgr = self
		self.msg = "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK"
		self.setID = setID
		self.epid = epid
		self.part = part
		self.isWearing = false
		SoraDSendMessage(self)
	end
end
function equipmentCtrl:getActiveSet()
	return equipmentSetMgr:getActiveSet()
end
function equipmentCtrl:getSetTitle(setID)
	return equipmentSetMgr:getTitle(setID)
end
function equipmentCtrl:getOverdueEquipments()
	return self.overdueEquipments
end
function equipmentCtrl:isEquipmentSetUnlock(setID)
	local condition = equipmentltCtrl.getEquipmentSetCondition(setID)
	return serviceFunctions.checkCondtion(condition)
end
function equipmentCtrl:disassembleEquipment(epid)
	if epid and 0 < epid then
		if self:isEquipmentLocked(epid) then
			SoraDShowMsgTip(i18n("Safety_lock_text_37"))
			return
		end
		REQ.reqDisassembleEquipment(epid)
	end
end
function equipmentCtrl:mergeMaterial(mergeMaterialID, mergeCount)
	if mergeMaterialID then
		REQ.reqMergeMaterial(mergeMaterialID, mergeCount)
	end
end
function equipmentCtrl:mergeMaterialAsPossible(mergeMaterialID)
	if mergeMaterialID then
		REQ.reqMergeMaterialAsPossible(mergeMaterialID)
	end
end
function equipmentCtrl:disassembleMaterial(materialID, num)
	if materialID then
		REQ.reqDisassembleMaterial(materialID, num)
	end
end
function equipmentCtrl:isEquipmentShow()
	return self.isShow
end
function equipmentCtrl:setEquipmentShowOrHideRsp(val)
	if true == val or false == val then
		REQ.setEquipmentShowOrHideRsp(val)
	end
end
function equipmentCtrl:canFreeRemaking()
	if self.countOfFreeRemaking and self.countOfFreeRemaking > 0 then
		return true, self.countOfFreeRemaking
	else
		return false, self.countOfFreeRemaking
	end
end
function equipmentCtrl:getCountOfFreeRemaking()
	return self.countOfFreeRemaking
end
function equipmentCtrl:shareEquipmentToAllianceChat(epid)
	if not epid then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local equipment = equipmentMgr.getEquipment(epid)
	if not equipment then
		return gErrDef.Err_NOT_FOUND_EQUIPMENT
	end
	if equipment:getEquipmentQuality() < gQualityDef.BLUE then
		return gErrDef.Err_EQUIPMENT_SHARE_QUALITY_NOT_ENOUGH
	end
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	if not settingCtrl:isShareEquipmentToAllianceChat() then
		return gErrDef.Err_EQUIPMENT_SHARE_SET_OFF
	end
	REQ.reqShareEquipmentToAllianceChat(epid)
	return true
end
function equipmentCtrl:acitveEquipmentSet(setID)
	if not self:isEquipmentSetUnlock(setID) then
		return
	end
	REQ.reqAcitveEquipmentSet(setID)
end
function equipmentCtrl:resetEquipmentSet(setID)
	if not self:isEquipmentSetUnlock(setID) then
		return
	end
	REQ.reqResetEquipmentSet(setID)
end
function equipmentCtrl:setEquipmentSetTitle(setID, title)
	if not self:isEquipmentSetUnlock(setID) then
		return
	end
	REQ.reqSetEquipmentSetTitle(setID, title)
end
function equipmentCtrl:takeOffAllEquipment()
	local list = equipmentMgr.getAllPartEquipment()
	for k, v in pairs(list) do
		self:_takeOffEquipment(v:getEPID(), v:getEquipmentPart())
	end
	equipmentMgr = pairs(list)
	pairs(list).msg = "MESSAGE_SERVER_EQUIP_WEAR_BACK"
	SoraDSendMessage(pairs(list))
	equipmentMgr = pairs(list)
	pairs(list).name = gEventName.event_equip_update
	self:dispatchEvent(pairs(list))
end
function equipmentCtrl:getEquipmentSetList(setID)
	local ret, epList = equipmentSetMgr:getEquipmentSetList(setID)
	if gErrDef.Err_None == ret and epList then
		local equipmentSetMgr, equipmentlist = gErrDef.Err_None, gErrDef.Err_None
		for _, v in pairs(epList) do
			table.insert(equipmentlist, equipmentMgr.getEquipment(v))
		end
		return equipmentlist
	end
end
function equipmentCtrl:wearEquipmentSet(setID)
	local ret, equipmentList = equipmentSetMgr:getEquipmentSetList(setID)
	if gErrDef.Err_None == ret then
		for part, epid in pairs(equipmentList) do
			self:_wearEquipment(epid, part, setID)
		end
	end
end
function equipmentCtrl:getEquipmentSetPart(setID, part)
	local ret, epid = equipmentSetMgr:getEquipmentSetPart(setID, part)
	if gErrDef.Err_None == ret and epid then
		return equipmentMgr.getEquipment(epid)
	end
end
function equipmentCtrl:getEquipmentSetPropertyList(setID)
	local ret, equipmentList = equipmentSetMgr:getEquipmentSetList(setID)
	local equipmentSetMgr, tempList = setID, setID
	for k, v in pairs(equipmentList) do
		local equipment = equipmentMgr.getEquipment(v)
		if equipment then
			tempList[k], equipmentSetMgr = v, v
			tempList[k] = v
		end
	end
	local equipmentSetMgr, temp = (for generator), pairs(equipmentList)
	local equipmentSetMgr, specialTemp = pairs(equipmentList)
	local equipmentSetMgr, qualityTable = pairs(equipmentList)
	if gErrDef.Err_None == ret then
		for part, epid in pairs(tempList) do
			local equipmentSetMgr, base
			local equipment = equipmentMgr.getEquipment(epid)
			local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(equipment:getEID())
			local index = math.floor(equipment:getEID() % 1000000 / 100000)
			local slv = equipment:getEquipmentSLV()
			local equipQuality = equipment:getEquipmentQuality()
			local tabelBaseList = equipmentMgr:getEquipmentArray()
			if not isSuitEquip then
				if part == gEquipmentPart.NECKLACE or part == gEquipmentPart.RING then
					specialAttr = equipmentltCtrl.getEquipmentSpecialProperty(equipment:getEID(), equipment:getEquipmentQuality())
					base = equipmentltCtrl.getEquipmentAllProperty(equipment:getEID(), equipQuality, slv)
					for i, v in ipairs(base) do
						print("项链属性，", i)
						temp[v.propertyType] = (temp[v.propertyType] or 0) + v.propertyValue
					end
					if next(specialAttr) then
						for i, v in ipairs(specialAttr) do
							table.insert(specialTemp, v)
						end
					end
				else
					base = equipment:getEquipmentBaseProperty(slv)
					for i = 1, #base - 1, 2 do
						temp[base[i]] = temp[base[i]] or 0
						temp[base[i]] = temp[base[i]] + base[i + 1]
					end
				end
			else
				local suitKey = equipmentltCtrl.getEquipmentSuitID(equipment:getEID(), equipQuality)
				local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(suitKey)
				local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(index, equipment:getEID(), equipQuality, slv)
				table.insert(base, propertyType)
				table.insert(base, propertyValue)
				table.insert(base, propertyType2)
				table.insert(base, propertyValue2)
				if not qualityTable[suitKey] then
					qualityTable[suitKey], equipmentSetMgr = qualityTable[suitKey], qualityTable[suitKey]
				end
				table.insert(qualityTable[suitKey], equipment:getEquipmentQuality())
				for i = 1, #base - 1, 2 do
					temp[base[i]] = temp[base[i]] or 0
					temp[base[i]] = temp[base[i]] + base[i + 1]
				end
			end
			local exter = equipment:getEquipmentExtraProperty()
			if exter then
				for _, v in ipairs(exter) do
					temp[v[1]] = temp[v[1]] or 0
					temp[v[1]] = temp[v[1]] + v[2]
				end
			end
		end
		for suitKey, v in pairs(qualityTable) do
			table.sort(qualityTable[suitKey], function(a, b)
				return b < a
			end)
			local equipmentSetMgr, base = table.sort, table.sort
			local m = qualityTable[suitKey]
			local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(suitKey)
			if 2 <= #m and #m < 4 then
				table.insert(base, suitResultInfo.SuitpropertyType1)
				table.insert(base, suitResultInfo.SuitpropertyValue1[m[2] + 1])
			elseif 4 <= #m and #m < 6 then
				table.insert(base, suitResultInfo.SuitpropertyType1)
				table.insert(base, suitResultInfo.SuitpropertyValue1[m[2] + 1])
				table.insert(base, suitResultInfo.SuitpropertyType2)
				table.insert(base, suitResultInfo.SuitpropertyValue2[m[4] + 1])
			elseif #m == 6 then
				table.insert(base, suitResultInfo.SuitpropertyType1)
				table.insert(base, suitResultInfo.SuitpropertyValue1[m[2] + 1])
				table.insert(base, suitResultInfo.SuitpropertyType2)
				table.insert(base, suitResultInfo.SuitpropertyValue2[m[4] + 1])
				table.insert(base, suitResultInfo.SuitpropertyType3)
				table.insert(base, suitResultInfo.SuitpropertyValue3[m[6] + 1])
			end
			for i = 1, 3 do
				if base[2 * i - 1] then
					temp[base[2 * i - 1]] = temp[base[2 * i - 1]] or 0
					temp[base[2 * i - 1]] = temp[base[2 * i - 1]] + base[2 * i]
				end
			end
		end
	end
	local equipmentSetMgr, propertyList = (for generator), pairs(qualityTable)
	if next(temp) then
		for k, v in pairs(temp) do
			equipmentMgr = 1
			;(1)[1] = k
			;(1)[2] = v
			table.insert(propertyList, 1)
		end
		table.sort(propertyList, function(l, r)
			local lOrder = equipmentltCtrl.getPropertyOrder(l[1]) or 0
			local rOrder = equipmentltCtrl.getPropertyOrder(r[1]) or 0
			return lOrder < rOrder
		end)
	end
	if next(specialTemp) then
		for i, v in ipairs(specialTemp) do
			equipmentltCtrl = 1
			;(1)[1] = v.attrID
			;(1)[2] = v.attrValue
			;(1)[3] = true
			table.insert(propertyList, 1)
		end
	end
	return propertyList
end
function equipmentCtrl:isTitleLegal(title)
	if "string" ~= type(title) then
		return false
	end
	local len = string.utf8len(title)
	if len < 1 or 15 < len then
		return false
	end
	local ok = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isEquipmentSetTitleLegality(title)
	if not ok then
		return false
	end
	local ok = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(title)
	if ok then
		return false
	end
	return true
end
function equipmentCtrl:clean()
	local equipmentList = equipmentMgr.getEquipmentList()
	if "table" == type(equipmentList) and next(equipmentList) then
		for epid, equipment in pairs(equipmentList) do
			if not equipment:isWearing() then
				local epid = equipment:getEPID()
				equipmentMgr.removeEquipment(epid)
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
			end
		end
	end
end
function equipmentCtrl:findEquipList(minLv, maxLv, isStrengthen, isSuit, qualityList)
	print("minLv,maxLv,isStrengthen,isSuit====", minLv, maxLv, isStrengthen, isSuit)
	dump(qualityList, "qualityList===")
	local _ENV, findList = dump, dump
	local _ENV, equpList = qualityList, qualityList
	local equipmentList = equipmentMgr.getEquipmentList()
	if "table" == type(equipmentList) and next(equipmentList) then
		for epid, equipment in pairs(equipmentList) do
			local lv = equipment:getEquipmentLV()
			local slv = equipment:getEquipmentSLV()
			local suit = equipmentltCtrl.judgeSuitEquipByEid(equipment:getEID())
			local quality = equipment:getEquipmentQuality()
			local part = equipment:getEquipmentPart()
			local isWear = equipment:isWearing()
			if not isWear and part ~= gEquipmentPart.RING and part ~= gEquipmentPart.NECKLACE and quality ~= gQualityDef.LEGEND and minLv <= lv and maxLv >= lv and qualityList[quality] then
				if isStrengthen and isSuit then
					findList[quality] = (findList[quality] or 0) + 1
					table.insert(equpList, equipment)
				elseif isStrengthen and not isSuit and not suit then
					findList[quality] = (findList[quality] or 0) + 1
					table.insert(equpList, equipment)
				elseif not isStrengthen and slv == 0 and isSuit then
					findList[quality] = (findList[quality] or 0) + 1
					table.insert(equpList, equipment)
				elseif not isStrengthen and slv == 0 and not isSuit and not suit then
					findList[quality] = (findList[quality] or 0) + 1
					table.insert(equpList, equipment)
				end
			end
		end
	end
	dump(findList, "findList===")
	return findList, equpList
end
function REQ.reqForgeEquipment(eid, materialArray, mainMaterialID)
	serverproxy = nil
	;(nil).eid = eid
	;(nil).materialArray = materialArray
	local (nil).mainMaterialID, data = mainMaterialID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FORGE_EQUIPMENT, data)
end
function REQ.reqForgeOrangeEquipment(eid, mainMaterialID)
	serverproxy = nil
	;(nil).eid = eid
	local (nil).mainMaterialID, data = mainMaterialID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FORGE_ORANGE_EQUIPMENT, data)
end
function REQ.reqLegendEquipLevelUp(mainMaterialID)
	serverproxy = nil
	local (nil).mainMaterialID, data = mainMaterialID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_LEGEND_EQUIP_LEVEL_UP, data)
end
function REQ.reqSetAttributeGroupInfo(setType, quality, position, info, name)
	serverproxy = nil
	;(nil).setType = setType
	;(nil).quality = quality
	;(nil).position = position
	;(nil).info = info
	local (nil).name, data = name, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_ATTRIBUTE_GROUP_INFO, data)
end
function REQ.reqOneKeyDisassembleInfo(minLv, maxLv, qualitys, isStrengthen, isSuit)
	serverproxy = nil
	;(nil).minLv = minLv
	;(nil).maxLv = maxLv
	;(nil).qualitys = qualitys
	;(nil).isStrengthen = isStrengthen
	local (nil).isSuit, data = isSuit, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_ONE_KEY_DISASSEMBLE_EQUIPMENT, data)
end
function REQ.reqRecastEquipment(epid, isSenior)
	serverproxy = nil
	;(nil).epid = epid
	local (nil).isSenior, data = isSenior or false, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_RECAST_EQUIPMENT, data)
end
function REQ.reqEquipmentExchange(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_EXCHANGE, data)
end
function REQ.reqEquipmentOverdueReturn()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_OVERDUE_RETURN, nil)
end
function REQ.reqEquipmentNebulaExchange(epid)
	serverproxy = nil
	;(nil).epid = epid
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_NEBULA_EXCHANGE, nil)
end
function REQ.reqGetEquipment(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_GET_EQUIPMENT, data)
end
function REQ.reqStrengthenEquipment(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_STRENGTHEN_EQUIPMENT, data)
end
function REQ.reqRemakeEquipment(epid, materialID, lockInfo)
	_ENV = nil
	;(nil).epid = epid
	;(nil).materialID = materialID
	local (nil).lockInfo, data = lockInfo, nil
	dump(data, "reqRemakeEquipment")
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_REMAKE_EQUIPMENT, data)
end
function REQ.reqConfirmRemakeProperty(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_CONFIRM_REMAKE_PROPERTY, data)
end
function REQ.reqRemakeEquipmentTen(epid, lockInfo)
	_ENV = nil
	;(nil).epid = epid
	local (nil).lockInfo, data = lockInfo, nil
	dump(data, "reqRemakeEquipmentTen")
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_REMAKE_EQUIPMENT_TEN, data)
end
function REQ.reqConfirmRemakeTenProperty(epid, idx)
	serverproxy = nil
	;(nil).epid = epid
	local (nil).idx, data = idx, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_CONFIRM_REMAKE_TEN_PROPERTY, data)
end
function REQ.reqDeleteRemakeProperty(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DELETE_REMAKE_PROPERTY, data)
end
function REQ.reqWearEquipment(epid, part, setID)
	serverproxy = nil
	;(nil).epid = epid
	;(nil).part = part
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_WEAR_EQUIPMENT, data)
end
function REQ.reqTakeOffEquipment(epid, part, setID)
	serverproxy = nil
	;(nil).epid = epid
	;(nil).part = part
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_TAKE_OFF_EQUIPMENT, data)
end
function REQ.reqDisassembleEquipment(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DISASSEMBLE_EQUIPMENT, data)
end
function REQ.reqMergeMaterial(mergeMaterialID, mergeCount)
	serverproxy = nil
	;(nil).mergeMaterialID = mergeMaterialID
	local (nil).mergeCount, data = mergeCount, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_MERGE_MATERIAL, data)
end
function REQ.reqMergeMaterialAsPossible(mergeMaterialID)
	serverproxy = nil
	local (nil).mergeMaterialID, data = mergeMaterialID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_MERGE_MATERIAL_AS_POSSIBLE, data)
end
function REQ.setEquipmentShowOrHideRsp(val)
	serverproxy = nil
	local (nil).setValue, data = val, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_EQUIPMENT_SHOW_OR_HIDE, data)
end
function REQ.reqFreeRemakingEquipment(epid, lockInfo)
	_ENV = nil
	;(nil).epid = epid
	local (nil).lockInfo, data = lockInfo, nil
	dump(data, "reqFreeRemakingEquipment")
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FREE_REMAKING, data)
end
function REQ.reqShareEquipmentToAllianceChat(epid)
	serverproxy = nil
	local (nil).epid, data = epid, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SHARE_EQUIPMENT_TO_ALLIANCE_CHAT, data)
end
function REQ.reqAcitveEquipmentSet(setID)
	serverproxy = nil
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_ACTIVE_EQUIPMENTSET, data)
end
function REQ.reqResetEquipmentSet(setID)
	serverproxy = nil
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_RESET_EQUIPMENTSET, data)
end
function REQ.reqSetEquipmentSetTitle(setID, title)
	serverproxy = nil
	;(nil).setID = setID
	local (nil).title, data = title, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_EQUIPMENTSET_TITLE, data)
end
function REQ.reqDisassembleMaterial(materialID, num)
	local serverproxy, count = nil, num or 1
	;(nil).mergeMaterialID = materialID
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DISASSEMBLE_MATERIAL, data)
end
function equipmentCtrl:reqShopRing(data)
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_BUY_RING, data)
end
function equipmentCtrl:reqEquipmentLock(epidList)
	dump(epidList, "equipmentCtrl:reqEquipmentLock")
	_ENV = nil
	;(nil).epidList = epidList
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_LOCK, nil)
end
function equipmentCtrl:reqEquipmentUnlock(epidList)
	dump(epidList, "equipmentCtrl:reqEquipmentUnlock")
	_ENV = nil
	;(nil).epidList = epidList
	serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_UNLOCK, nil)
end
function RSP:forgeEquipmentRsp(content)
	dump(content, "equipmentCtrl.forgeEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local equipmentProperty = data.equipment
		local forgingEquipment = equipmentCell.new(equipmentProperty)
		equipmentMgr.setForgingEquipment(forgingEquipment)
		local mainMaterialInfo = forgingEquipment:getMainMaterialInfo()
		if mainMaterialInfo then
			local epid = mainMaterialInfo.epid
			local equipment = equipmentMgr.removeEquipment(epid)
			if equipment then
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
			end
		end
		local beginForgeTime = data.bTime
		local costTime = data.costTime
		local eid = equipmentProperty.eid
		local epid = equipmentProperty.epid
		local remainTime = costTime
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queueData = clone(equipmentProperty)
		queueData.bTime = beginForgeTime
		queueData.costTime = costTime
		queueData.ishelp = 0
		queueCtrl:addQueue(gQueueTypeDef.forge_equipment, beginForgeTime, costTime, remainTime, queueData)
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_SERVER_EQUIP_FORGE_BACK"
		queueCtrl.eid = eid
		SoraDSendMessage(queueCtrl)
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCell(tonumber(BUILDID.BLACK_SMITH), 0)
		if nil ~= buildCell then
			_ENV = tonumber(BUILDID.BLACK_SMITH)
			tonumber(BUILDID.BLACK_SMITH).msg = "MESSAGE_BUILD_WORKING"
			tonumber(BUILDID.BLACK_SMITH).buildID = tonumber(buildCell.info.index)
			tonumber(BUILDID.BLACK_SMITH).buildCfgID = tonumber(BUILDID.BLACK_SMITH)
			SoraDSendMessage((tonumber(BUILDID.BLACK_SMITH)))
		end
		equipmentMgr.dump()
	end
end
function RSP:legendEquipmentRefineRsp(content)
	dump(content, "equipmentCtrl.legendEquipmentRefineRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local equipmentProperty = data.equipment
		local equipment = equipmentCell.new(equipmentProperty)
		local epid = equipment:getEPID()
		equipmentMgr.addEquipment(epid, equipment)
		local mainMaterialInfo = equipment:getMainMaterialInfo()
		if mainMaterialInfo then
			local epid = mainMaterialInfo.epid
			local equipment = equipmentMgr.removeEquipment(epid)
			if equipment then
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
			end
		end
		_ENV = equipmentMgr.removeEquipment(epid)
		equipmentMgr.removeEquipment(epid).msg = "MESSAGE_SERVER_EQUIP_LEGEND_LEVELUP"
		equipmentMgr.removeEquipment(epid).epid = epid
		SoraDSendMessage((equipmentMgr.removeEquipment(epid)))
		_ENV = equipmentSetMgr
		equipmentSetMgr.singleData = equipment
		equipmentSetMgr.isNewEquip = true
		uiManager:show("equipForgeSuccessView", equipmentSetMgr)
		equipmentMgr.dump()
	end
end
function RSP:setAttributeGroupInfoRsp(content)
	dump(content, "equipmentCtrl.setAttributeGroupInfoRsp", 5)
	if content.err == gErrDef.Err_None then
		self.attributeGroupInfo = content.rspdata.attributeGroupInfo
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EQUIP_ATTRIBUTE_SET"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:oneKeyDisassembleRsp(content)
	dump(content, "equipmentCtrl.oneKeyDisassembleRsp", 5)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.equipmentArr then
			local _ENV, equipmentArr = content.rspdata.equipmentArr, content.rspdata.equipmentArr
		end
		for k, v in ipairs(equipmentArr) do
			local equipment = equipmentMgr.getEquipment(v)
			if equipment then
				equipmentMgr.removeEquipment(v)
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), v)
			end
		end
		local materialArray = content.rspdata.materialArray
		_ENV = nil
		;(nil).materialArray = materialArray
		uiManager:show("ATotal", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_SERVER_ONEKEY_DISASSEMBLE"
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK"
		uiManager.materialArray = materialArray
		uiManager.noPop = true
		uiManager.err = content.err
		SoraDSendMessage(uiManager)
	end
end
function RSP:recastEquipmentRsp(content)
	dump(content, "equipmentCtrl.recastEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local items = content.rspdata.items
		SoraDMailGainItems(items, true)
		local equipment = equipmentMgr.getEquipment(content.data.epid)
		if equipment then
			equipment:recastEquipmentSLV()
		end
		if content.data.isSenior then
			SoraDShowMsgTip(i18n("equipment_recoin_text_0008"))
		else
			SoraDShowMsgTip(i18n("equipment_recoin_text_0009"))
		end
		_ENV = i18n("equipment_recoin_text_0009")
		i18n("equipment_recoin_text_0009").msg = "MESSAGE_SERVER_EQUIP_RECAST_BACK"
		i18n("equipment_recoin_text_0009").equipCell = equipment
		SoraDSendMessage(i18n("equipment_recoin_text_0009"))
	end
end
function RSP:equipmentExchangeRsp(content)
	dump(content, "equipmentCtrl.equipmentExchangeRsp", 5)
	if content.err == gErrDef.Err_None then
		local equipmentProperty = content.rspdata.equipment
		local equipment = equipmentCell.new(equipmentProperty)
		local epid = equipment:getEPID()
		equipmentMgr.addEquipment(epid, equipment)
		equipmentMgr.removeEquipment(content.data.epid)
		_ENV = content.data.epid
		content.data.epid.msg = "MESSAGE_SERVER_EQUIP_EXCHANGE_BACK"
		SoraDSendMessage(content.data.epid)
	end
end
function RSP:equipmentOverdueReturnRsp(content)
	dump(content, "equipmentCtrl.equipmentOverdueReturnRsp", 5)
	if content.err == gErrDef.Err_None then
		self.overdueEquipments = content.rspdata.overdueEquipments
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_SERVER_EQUIP_OVERDUE_BACK"
		SoraDSendMessage(rewards)
	end
end
function RSP:equipmentNebulaExchangeRsp(content)
	dump(content, "equipmentCtrl.equipmentNebulaExchangeRsp", 5)
	if content.err == gErrDef.Err_None then
		local rewards = content.rspdata and content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
	end
end
function RSP:forgeOrangeEquipmentRsp(content)
	dump(content, "equipmentCtrl.forgeOrangeEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local equipmentProperty = data.equipment
		local forgingEquipment = equipmentCell.new(equipmentProperty)
		equipmentMgr.setForgingEquipment(forgingEquipment)
		local mainMaterialInfo = forgingEquipment:getMainMaterialInfo()
		if mainMaterialInfo then
			local epid = mainMaterialInfo.epid
			local equipment = equipmentMgr.removeEquipment(epid)
			if equipment then
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
			end
		end
		local beginForgeTime = data.bTime
		local costTime = data.costTime
		local eid = equipmentProperty.eid
		local epid = equipmentProperty.epid
		local remainTime = costTime
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queueData = clone(equipmentProperty)
		queueData.bTime = beginForgeTime
		queueData.costTime = costTime
		queueData.ishelp = 0
		queueCtrl:addQueue(gQueueTypeDef.forge_equipment, beginForgeTime, costTime, remainTime, queueData)
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_SERVER_EQUIP_FORGE_BACK"
		queueCtrl.eid = eid
		SoraDSendMessage(queueCtrl)
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCell(tonumber(BUILDID.BLACK_SMITH), 0)
		if nil ~= buildCell then
			_ENV = tonumber(BUILDID.BLACK_SMITH)
			tonumber(BUILDID.BLACK_SMITH).msg = "MESSAGE_BUILD_WORKING"
			tonumber(BUILDID.BLACK_SMITH).buildID = tonumber(buildCell.info.index)
			tonumber(BUILDID.BLACK_SMITH).buildCfgID = tonumber(BUILDID.BLACK_SMITH)
			SoraDSendMessage((tonumber(BUILDID.BLACK_SMITH)))
		end
		equipmentMgr.dump()
	end
end
function RSP:getEquipmentRsp(content)
	dump(content, "equipmentCtrl.getEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local bid = BUILDID.BLACK_SMITH
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCell(tonumber(bid), 0)
		local buildIndex = tonumber(buildCell.info.index)
		_ENV = 0
		;(0).msg = "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT"
		;(0).index = buildIndex
		;(0).bid = bid
		SoraDSendMessage(0, content)
	end
end
function RSP:disassembleEquipmentRsp(content)
	dump(content, "equipmentCtrl.disassembleEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local materialArray = data.materialArray
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipmentMgr.removeEquipment(epid)
			equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
			if equipment:isWearing() then
				local part = equipment:getEquipmentPart()
				equipmentMgr.setPartEquipment(part, nil)
			end
			_ENV = equipmentMgr.setPartEquipment
			equipmentMgr.setPartEquipment.msg = "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK"
			equipmentMgr.setPartEquipment.epid = epid
			equipmentMgr.setPartEquipment.materialArray = materialArray
			equipmentMgr.setPartEquipment.err = content.err
			SoraDSendMessage(equipmentMgr.setPartEquipment)
		else
			_ENV = equipmentMgr.setPartEquipment
			equipmentMgr.setPartEquipment.msg = "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK"
			equipmentMgr.setPartEquipment.err = content.err
			SoraDSendMessage(equipmentMgr.setPartEquipment)
			print("RSP.strengthenEquipmentRsp: not found equipment!")
		end
		equipmentMgr.dump()
	else
		_ENV = data.epid
		data.epid.msg = "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK"
		data.epid.err = content.err
		SoraDSendMessage(data.epid)
	end
end
function RSP:strengthenEquipmentRsp(content)
	dump(content, "equipmentCtrl.strengthenEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local slv = data.slv
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:strengthenEquipment(slv)
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			if equipment:isWearing() then
				equipmentMgr.setEnhanceChange(true)
				_ENV = slv
				slv.name = gEventName.event_equip_update
				self:dispatchEvent(slv)
			end
		else
			print("RSP.strengthenEquipmentRsp: not found equipment!")
		end
	end
end
function RSP:remakeEquipmentRsp(content)
	dump(content, "equipmentCtrl.remakeEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local rExtra = data.rExtra
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:remakeEquipment(rExtra)
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_BACK"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			if self:isNoticeAttribute(equipment, rExtra) then
				_ENV = rExtra
				rExtra.singleData = equipment
				rExtra.rExtra = rExtra
				uiManager:show("equipBaptizeSetDoneView", rExtra)
			end
		else
			print("RSP.remakeEquipmentRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:remakeEquipmentTenRsp(content)
	dump(content, "equipmentCtrl.remakeEquipmentTenRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local rExtra10 = data.rExtra10
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:remakeEquipmentTen(rExtra10)
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_BACK"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			for index, rExtra in ipairs(rExtra10) do
				if self:isNoticeAttribute(equipment, rExtra) then
					_ENV = rExtra
					rExtra.singleData = equipment
					rExtra.rExtra = rExtra
					rExtra.idx = index
					uiManager:show("equipBaptizeSetDoneView", rExtra)
					return
				end
			end
		else
			print("RSP.remakeEquipmentRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:freeRemakeEquipmentRsp(content)
	dump(content, "equipmentCtrl.freeRemakeEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local rExtra = data.rExtra
		self.countOfFreeRemaking = self.countOfFreeRemaking - 1
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:remakeEquipment(rExtra)
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_BACK"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			if self:isNoticeAttribute(equipment, rExtra) then
				_ENV = rExtra
				rExtra.singleData = equipment
				rExtra.rExtra = rExtra
				uiManager:show("equipBaptizeSetDoneView", rExtra)
			end
		else
			print("RSP.freeRemakeEquipmentRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:confirmRemakePropertyRsp(content)
	dump(content, "equipmentCtrl.confirmRemakePropertyRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:confirmRemakeProperty()
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			if equipment:isWearing() then
				_ENV = nil
				;(nil).name = gEventName.event_equip_update
				self:dispatchEvent(nil)
			end
		else
			print("RSP.confirmRemakePropertyRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:confirmRemakeTenPropertyRsp(content)
	dump(content, "equipmentCtrl.confirmRemakePropertyRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local idx = data.idx
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:confirmRemakePropertyTen(idx)
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE"
			equipment.epid = epid
			SoraDSendMessage(equipment)
			if equipment:isWearing() then
				_ENV = idx
				idx.name = gEventName.event_equip_update
				self:dispatchEvent(idx)
			end
		else
			print("RSP.confirmRemakePropertyRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:deleteRemakePropertyRsp(content)
	dump(content, "equipmentCtrl.deleteRemakePropertyRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local epid = data.epid
		local equipment = equipmentMgr.getEquipment(epid)
		if equipment then
			equipment:deleteRemakeProperty()
			_ENV = equipment
			equipment.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_RESTORE"
			equipment.epid = epid
			SoraDSendMessage(equipment)
		else
			print("RSP.deleteRemakePropertyRsp: not found equipment!")
		end
		equipmentMgr.dump()
	end
end
function RSP:wearEquipmentRsp(content)
	dump(content, "equipmentCtrl.wearEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		equipmentMgr.setEnhanceChange(true)
	end
end
function RSP:takeOffEquipmentRsp(content)
	dump(content, "equipmentCtrl.takeOffEquipmentRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		equipmentMgr.setEnhanceChange(true)
	end
end
function RSP:mergeMeterialRsp(content)
	dump(content, "equipmentCtrl.mergeMeterialRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		_ENV = "equipmentCtrl.mergeMeterialRsp"
		;("equipmentCtrl.mergeMeterialRsp").msg = "MESSAGE_SERVER_EQUIP_METERIAL_MERGE_BACK"
		SoraDSendMessage("equipmentCtrl.mergeMeterialRsp")
	end
end
function RSP:mergeMeterialAsPossibleRsp(content)
	dump(content, "equipmentCtrl.mergeMeterialAsPossibleRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.data
		_ENV = "equipmentCtrl.mergeMeterialAsPossibleRsp"
		;("equipmentCtrl.mergeMeterialAsPossibleRsp").msg = "MESSAGE_SERVER_EQUIP_METERIAL_MERGE_BACK"
		SoraDSendMessage("equipmentCtrl.mergeMeterialAsPossibleRsp")
	end
end
function RSP:setEquipmentShowOrHideRsp(content)
	dump(content, "equipmentCtrl.setEquipmentShowOrHideRsp", 5)
	if content.err == gErrDef.Err_None then
		self.isShow = content.data.setValue
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EQUIP_ISSHOW_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:shareEquipmentToAllianceChatRsp(content)
	dump(content, "equipmentCtrl.shareEquipmentToAllianceChatRsp", 5)
	if content.err == gErrDef.Err_None then
	end
end
function RSP:activeEquipmentSetRsp(content)
	dump(content, "equipmentCtrl.activeEquipmentSetRsp", 5)
	if content.err == gErrDef.Err_None then
		local gametop = gModuleMgr.getObject("gametop")
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		buffCtrl:openDelayDispatch()
		local setID = content.data.setID
		equipmentSetMgr:active(setID)
		self:takeOffAllEquipment()
		self:wearEquipmentSet(setID)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EQUIP_SET_ACTIVE_BACK"
		SoraDSendMessage(self)
		buffCtrl:closeDelayDispatch()
		equipmentMgr.setEnhanceChange(true)
	end
end
function RSP:resetEquipmentSetRsp(content)
	dump(content, "equipmentCtrl.resetEquipmentSetRsp", 5)
	if content.err == gErrDef.Err_None then
		local setID = content.data.setID
		equipmentSetMgr:reset(setID)
		if equipmentSetMgr:isActive(setID) then
			self:takeOffAllEquipment()
		end
		_ENV = self
		self.msg = "MESSAGE_SERVER_EQUIP_SET_RESET_BACK"
		SoraDSendMessage(self)
	end
end
function RSP:setEquipmentTitleRsp(content)
	dump(content, "equipmentCtrl.setEquipmentTitleRsp", 5)
	if content.err == gErrDef.Err_None then
		local setID = content.data.setID
		local title = content.data.title
		equipmentSetMgr:setTitle(setID, title)
		_ENV = equipmentSetMgr
		equipmentSetMgr.msg = "MESSAGE_SERVER_EQUIP_SET_RENAME_BACK"
		equipmentSetMgr.err = content.err
		SoraDSendMessage(equipmentSetMgr)
	else
		_ENV = content.data.title
		content.data.title.msg = "MESSAGE_SERVER_EQUIP_SET_RENAME_BACK"
		content.data.title.err = content.err
		SoraDSendMessage(content.data.title)
	end
end
function RSP:disassembleMaterialRSp(content)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EQUIP_DISASSEMBLE_MATERIAL_BACK"
		gErrDef.Err_None.err = content.err
		gErrDef.Err_None.info = content.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:shopRingRSp(content)
	dump(content, "shopRingRSp", 5)
	if content.err == gErrDef.Err_None then
		for i, v in pairs(self.limitRingShop) do
			print("shopRingRSp", i, v.shopItemId, v.buyNum)
			if v.shopItemId == content.data.shopItemId then
				v.buyNum = v.buyNum + 1
			end
		end
		dump(self.limitRingShop, "self.limitRingShop", 10)
		_ENV = self.limitRingShop
		self.limitRingShop.msg = "MESSAGE_SERVER_EQUIP_RING_NECKLACE"
		self.limitRingShop.subMsg = "shopSuccess"
		self.limitRingShop.shopItemID = content.data.shopItemId
		SoraDSendMessage(self.limitRingShop)
	elseif content.err == gErrDef.Err_RING_NUM_MAX then
		SoraDShowMsgTip(i18n("equip_text_38"))
	end
end
function RSP:equipmentLockRsp(content)
	dump(content, "equipmentCtrl.equipmentLockRsp", 5)
	if content.err == gErrDef.Err_None then
		for _, epid in ipairs(content.data.epidList) do
			local equipment = equipmentMgr.getEquipment(epid)
			if equipment then
				equipment:setIsLock(true)
			else
				print("equipmentLockRsp: not found equipment!")
			end
		end
		_ENV = ipairs(content.data.epidList)
		ipairs(content.data.epidList).msg = "MESSAGE_SERVER_EQUIPMENT_LOCK_BACK"
		SoraDSendMessage(ipairs(content.data.epidList))
	end
end
function RSP:equipmentUnlockRsp(content)
	dump(content, "equipmentCtrl.equipmentUnlockRsp", 5)
	if content.err == gErrDef.Err_None then
		for _, epid in ipairs(content.data.epidList) do
			local equipment = equipmentMgr.getEquipment(epid)
			if equipment then
				equipment:setIsLock(false)
			else
				print("equipmentUnlockRsp: not found equipment!")
			end
		end
		_ENV = ipairs(content.data.epidList)
		ipairs(content.data.epidList).msg = "MESSAGE_SERVER_EQUIPMENT_LOCK_BACK"
		SoraDSendMessage(ipairs(content.data.epidList))
	end
end
function RSP:noitfyDataRsp(content)
	dump(content, "equipmentCtrl.noitfyDataRsp", 5)
	for i, notifyData in ipairs(content.data) do
		local notifyType = notifyData.notifyType
		if "cle" == notifyType then
			local epid = notifyData.epid
			local forgingEquipment = equipmentMgr.getForgingEquipment()
			if forgingEquipment then
				local forgingEpid = forgingEquipment:getEPID()
				if forgingEpid == epid then
					forgingEquipment:completeForging()
					local queueCtrl = gametop.playertop_:getModule("queueCtrl")
					queueCtrl:removeQueue(gQueueTypeDef.forge_equipment)
					_ENV = queueCtrl
					queueCtrl.msg = "MESSAGE_SERVER_EQUIP_FORGE_FINISH"
					queueCtrl.eid = forgingEquipment:getEID()
					SoraDSendMessage(queueCtrl)
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local buildCell = cityCtrl:getBuildCell(tonumber(BUILDID.BLACK_SMITH), 0)
					if nil ~= buildCell then
						_ENV = tonumber(BUILDID.BLACK_SMITH)
						tonumber(BUILDID.BLACK_SMITH).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
						tonumber(BUILDID.BLACK_SMITH).buildIndex = tonumber(buildCell.info.index)
						SoraDSendMessage((tonumber(BUILDID.BLACK_SMITH)))
					end
					SoraDGetEquip()
				else
					print("queueFinishListener error: forgingEquipment's epid don't match!")
				end
			else
				print("queueFinishListener error: forgingEquipment is nil")
			end
		elseif "rfr" == notifyType then
			local count = notifyData.count
			self.countOfFreeRemaking = count
			_ENV = print
			print.msg = "MESSAGE_SERVER_EQUIP_BAPTIZE_FREE_UPDATE"
			SoraDSendMessage(print)
		elseif "add" == notifyType then
			local property = notifyData.property
			local equipment = equipmentCell.new(property)
			local epid = equipment:getEPID()
			equipmentMgr.addEquipment(epid, equipment)
			_ENV = epid
			epid.msg = "MESSAGE_SERVER_EQUIP_ADD_SUCCESS"
			epid.equip = equipment
			SoraDSendMessage(epid)
		elseif "delete" == notifyType then
			local epid = notifyData.epid
			local part = notifyData.part
			local overdueEquipments = notifyData.overdueEquipments
			if overdueEquipments then
				self.overdueEquipments = overdueEquipments
			end
			print("epid,part", epid, part)
			local equipment = equipmentMgr.getEquipment(epid)
			local eid = equipment:getEID()
			if part and 0 < part then
				equipment:takeOffEquipment()
				equipmentMgr.setPartEquipment(part, nil)
				_ENV = nil
				;(nil).name = gEventName.event_equip_update
				self:dispatchEvent(nil)
				equipmentMgr.removeEquipment(epid)
				equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
				_ENV = equipmentSetMgr
				equipmentSetMgr.msg = "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT"
				equipmentSetMgr.eid = eid
				equipmentSetMgr.epid = epid
				equipmentSetMgr.part = part
				equipmentSetMgr.isWearing = true
				SoraDSendMessage(equipmentSetMgr)
				print("MESSAGE_SERVER_EQUIP_WEAR_BACK = ", epid)
			else
				local equipment = equipmentMgr.removeEquipment(epid)
				if equipment then
					equipmentSetMgr:removeEquipment(equipment:getEquipmentPart(), epid)
				end
				_ENV = equipmentSetMgr
				equipmentSetMgr.msg = "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT"
				equipmentSetMgr.eid = eid
				equipmentSetMgr.epid = epid
				equipmentSetMgr.part = part
				equipmentSetMgr.isWearing = false
				SoraDSendMessage(equipmentSetMgr)
				print("MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT = ", epid)
			end
			if notifyData.nebulaExchangeInfo then
				self.nebulaExchangeInfo = notifyData.nebulaExchangeInfo
				_ENV = print
				print.msg = "MESSAGE_SERVER_EQUIP_NEBULA_EXCHANGE_BACK"
				SoraDSendMessage(print)
			end
		elseif "ringStore" == notifyType then
			dump(notifyData, "noitfyDataRsp.ringStore", 20)
			if notifyData.ringStore then
				self.limitRingShop = notifyData.ringStore.limitItemsInfo
			end
			_ENV = notifyData
			notifyData.msg = "MESSAGE_SERVER_EQUIP_RING_NECKLACE"
			notifyData.subMsg = "refreshShop"
			SoraDSendMessage(notifyData)
		end
	end
end
function equipmentCtrl:_wearEquipment(epid, part, setID)
	if epid and 0 < epid and part then
		local equipment = equipmentMgr.getEquipment(epid)
		if not equipment then
			return false
		end
		local curEquipmentPart = equipment:getEquipmentPart()
		if part ~= curEquipmentPart then
			return false
		end
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if guideCtrl:isGuideOpen(gGuideModule.WEAR_EQUIPMENT) then
			guideCtrl:CompleteGuideStep(15001)
		end
		local wearingEquipment = equipmentMgr.getPartEquipment(part)
		if wearingEquipment then
			wearingEquipment:takeOffEquipment()
			equipmentMgr.setPartEquipment(part, nil)
			equipmentMgr = part
			part.msg = "MESSAGE_SERVER_EQUIP_WEAR_BACK"
			part.epid = wearingEquipment:getEPID()
			part.part = part
			part.isWearing = false
			SoraDSendMessage(part)
		end
		equipment:wearEquipment()
		equipmentMgr.setPartEquipment(part, equipment)
		equipmentMgr = part
		part.msg = "MESSAGE_SERVER_EQUIP_WEAR_BACK"
		part.epid = epid
		part.part = part
		part.isWearing = true
		SoraDSendMessage(part)
		equipmentMgr = equipment
		equipment.name = gEventName.event_equip_update
		self:dispatchEvent(equipment)
		return true
	end
end
function equipmentCtrl:_takeOffEquipment(epid, part, setID)
	if epid and 0 < epid and part then
		local equipment = equipmentMgr.getEquipment(epid)
		if not equipment then
			return false
		end
		equipment:takeOffEquipment()
		equipmentMgr.setPartEquipment(part, nil)
		return true
	end
end
function equipmentCtrl:ctor(properties)
	equipmentCtrl.super.ctor(self, properties)
end
function equipmentCtrl:EnterGame()
	equipmentCtrl.super.EnterGame(self)
	IS_LEVEL_4_WASH_FACE_USED_CONFIRM = false
	IS_TEN_WASH_FACE_USED_CONFIRM = false
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FORGE_EQUIPMENT, handler(self, RSP.forgeEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_GET_EQUIPMENT, handler(self, RSP.getEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DISASSEMBLE_EQUIPMENT, handler(self, RSP.disassembleEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_STRENGTHEN_EQUIPMENT, handler(self, RSP.strengthenEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_REMAKE_EQUIPMENT, handler(self, RSP.remakeEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_CONFIRM_REMAKE_PROPERTY, handler(self, RSP.confirmRemakePropertyRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_REMAKE_EQUIPMENT_TEN, handler(self, RSP.remakeEquipmentTenRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_CONFIRM_REMAKE_TEN_PROPERTY, handler(self, RSP.confirmRemakeTenPropertyRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DELETE_REMAKE_PROPERTY, handler(self, RSP.deleteRemakePropertyRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_WEAR_EQUIPMENT, handler(self, RSP.wearEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_TAKE_OFF_EQUIPMENT, handler(self, RSP.takeOffEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_MERGE_MATERIAL, handler(self, RSP.mergeMeterialRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_EQUIPMENT_SHOW_OR_HIDE, handler(self, RSP.setEquipmentShowOrHideRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FREE_REMAKING, handler(self, RSP.freeRemakeEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_MERGE_MATERIAL_AS_POSSIBLE, handler(self, RSP.mergeMeterialAsPossibleRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SHARE_EQUIPMENT_TO_ALLIANCE_CHAT, handler(self, RSP.shareEquipmentToAllianceChatRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_ACTIVE_EQUIPMENTSET, handler(self, RSP.activeEquipmentSetRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_RESET_EQUIPMENTSET, handler(self, RSP.resetEquipmentSetRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_EQUIPMENTSET_TITLE, handler(self, RSP.setEquipmentTitleRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_DISASSEMBLE_MATERIAL, handler(self, RSP.disassembleMaterialRSp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_BUY_RING, handler(self, RSP.shopRingRSp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FORGE_ORANGE_EQUIPMENT, handler(self, RSP.forgeOrangeEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_LEGEND_EQUIP_LEVEL_UP, handler(self, RSP.legendEquipmentRefineRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_SET_ATTRIBUTE_GROUP_INFO, handler(self, RSP.setAttributeGroupInfoRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_ONE_KEY_DISASSEMBLE_EQUIPMENT, handler(self, RSP.oneKeyDisassembleRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_RECAST_EQUIPMENT, handler(self, RSP.recastEquipmentRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_EXCHANGE, handler(self, RSP.equipmentExchangeRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_OVERDUE_RETURN, handler(self, RSP.equipmentOverdueReturnRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_NEBULA_EXCHANGE, handler(self, RSP.equipmentNebulaExchangeRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_LOCK, handler(self, RSP.equipmentLockRsp))
	msgCtrl.register(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_EQUIPMENT_UNLOCK, handler(self, RSP.equipmentUnlockRsp))
	equipmentMgr.init()
end
function equipmentCtrl:resetData()
	equipmentMgr.clean()
	equipmentAdditionMgr.clean()
	equipmentAdditionMgr.clean.quality, equipmentMgr, equipmentMgr, self.isShow = nil, nil, equipmentAdditionMgr.clean, nil
	equipmentAdditionMgr.clean.minLvIndex = 0
	equipmentAdditionMgr.clean.maxLvIndex = 0
	equipmentAdditionMgr.clean.strength = false
	self.nebulaExchangeInfo, equipmentMgr, self.overdueEquipments, equipmentMgr, gEquipResolveData, equipmentAdditionMgr.clean.suit = equipmentAdditionMgr.clean, equipmentAdditionMgr.clean, equipmentAdditionMgr.clean, equipmentAdditionMgr.clean, equipmentAdditionMgr.clean, false
end
function equipmentCtrl:Logout()
	equipmentCtrl.super.Logout(self)
	self:resetData()
end
function equipmentCtrl:initClientData(data)
	self.isShow = data.isShow
	self.countOfFreeRemaking = data.countOfFreeRemaking
	if data.equipment_array then
		dump(data.equipment_array, "data.equipment_array")
		for _, v in ipairs(data.equipment_array) do
			local equipment = equipmentCell.new(v)
			local epid = equipment:getEPID()
			equipmentMgr.addEquipment(epid, equipment, true)
			if equipment:isWearing() then
				local part = equipment:getEquipmentPart()
				equipmentMgr.setPartEquipment(part, equipment)
				equipment:wearEquipment(true)
			end
		end
	end
	if data.attributeGroupInfo then
		self.attributeGroupInfo = data.attributeGroupInfo
	end
	if data.fe then
		local forgingEquipment = equipmentCell.new(data.fe)
		equipmentMgr.setForgingEquipment(forgingEquipment)
	end
	if data.ringStore then
		self.limitRingShop = data.ringStore.limitItemsInfo
	end
	if data.overdueEquipments then
		self.overdueEquipments = data.overdueEquipments
	end
	if data.nebulaExchangeInfo then
		self.nebulaExchangeInfo = data.nebulaExchangeInfo
	end
	equipmentSetMgr:initialize(data.setData)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.EQUIPMENT, handler(self, RSP.noitfyDataRsp))
end
return equipmentCtrl

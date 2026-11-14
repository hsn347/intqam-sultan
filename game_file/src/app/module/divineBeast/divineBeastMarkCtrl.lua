local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local divineBeastMarkCtrl = class("divineBeastMarkCtrl", GameModule)
local divineBeastRead = include("divineBeastRead")
local constantRead = include("constantRead")
local divineBeastMarkRead = include("divineBeastMarkRead")
function divineBeastMarkCtrl:ctor(properties)
	divineBeastMarkCtrl.super.ctor(self, properties)
	self.lockCityLv = constantRead.getConstValue("DIVINE_BEAST_MARK_LOCK_CITYLV", 5)
	self.maxQuality = divineBeastMarkRead.getMaxQuality()
end
function divineBeastMarkCtrl:EnterGame()
	print("divineBeastMarkCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DATA, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MOUNT_IN_BEAST, handler(self, self.sendMountRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DISMOUNT_IN_BEAST, handler(self, self.sendDisMountRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_UPGRADE, handler(self, self.sendUpgradeRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_UP_STAR, handler(self, self.sendUpStarRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_BUFF, handler(self, self.sendModifyRandomBuffRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF, handler(self, self.sendRefineRandomBuffRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF_ACCEPT, handler(self, self.sendRefineRandomBuffAcceptRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF_REJECT, handler(self, self.sendRefineRandomBuffRejectRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_LOCK, handler(self, self.sendLockRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_RECYCLE, handler(self, self.sendRecycleRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_CHANGE, handler(self, self.sendMarkChangeRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MOUNT_IN_SET, handler(self, self.sendMountInSetRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DISMOUNT_IN_SET, handler(self, self.sendDisMountInSetRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_USE_SET, handler(self, self.sendUseSetRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_RENAME_SET, handler(self, self.sendRenameRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_SUIT_REWARD, handler(self, self.sendSuitRewardRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_ELEM, handler(self, self.sendRefineRandomElemRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_ELEM, handler(self, self.sendModifyRandomElemRsp))
	self:resetData()
	self:registerNotify()
end
function divineBeastMarkCtrl:onLoginFinish()
end
function divineBeastMarkCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DIVINE_BEAST_MARK, handler(self, self.notifyHandler))
end
function divineBeastMarkCtrl:notifyHandler(event)
	dump(event.data, "divineBeastMarkCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:dealRspData(content)
		if content.data and content.data.bag ~= nil or content.delIds then
			_ENV = self
			self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
			self.type = "bag"
			SoraDSendMessage(self)
		end
	end
end
function divineBeastMarkCtrl:initClientData(data)
	dump(data, "divineBeastMarkCtrl:initClientData", 10)
	if data then
		self:resetData()
		self:setData(data, true)
	end
end
function divineBeastMarkCtrl:dealRspData(rspdata)
	self:setData(rspdata.data, false)
	self:handleDeletedMarkIds(rspdata.delIds)
end
function divineBeastMarkCtrl:setData(data, isFromInit)
	local isNeedUpdateBuffs = self:setBagData(data.bag)
	isNeedUpdateBuffs = self:setBeastData(data.beast) or isNeedUpdateBuffs
	if isNeedUpdateBuffs then
		self:calculateBuffsAndPower()
	end
	self:setGroupData(data.set)
	_UPVALUE3_ = self
	self[1] = self.expCount
	self[2] = data.expCount
	self[3] = isFromInit
	dump(self, "self.expCount ~= data.expCount ")
	if data.expCount ~= nil then
		local isExpChange = self.expCount ~= data.expCount
		self.expCount = data.expCount
		if not isFromInit and isExpChange then
			_ENV = "self.expCount ~= data.expCount "
			;("self.expCount ~= data.expCount ").msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
			;("self.expCount ~= data.expCount ").type = "exp"
			SoraDSendMessage("self.expCount ~= data.expCount ")
		end
	end
	if data.energy ~= nil then
		local isEnergyChange = self.energy ~= data.energy
		self.energy = data.energy
		if not isFromInit and isEnergyChange then
			_ENV = "self.expCount ~= data.expCount "
			;("self.expCount ~= data.expCount ").msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
			;("self.expCount ~= data.expCount ").type = "energy"
			SoraDSendMessage("self.expCount ~= data.expCount ")
		end
	end
	if data.gotSuitReward ~= nil then
		self.gotSuitReward = data.gotSuitReward
	end
	if data.refineRandomBuffCount ~= nil then
		self.refineRandomBuffCount = data.refineRandomBuffCount
	end
	if self.useSet ~= data.useSet and data.useSet ~= nil then
		self.useSet = data.useSet
		_ENV = data.useSet
		data.useSet.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		data.useSet.type = "useSetChange"
		SoraDSendMessage(data.useSet)
	end
end
function divineBeastMarkCtrl:Logout()
	self:resetData()
	divineBeastMarkCtrl.super.Logout(self)
end
function divineBeastMarkCtrl:resetData()
	self.expCount = 0
	self.bagMarkList, _ENV, self.mountMarkList, _ENV, self.refineRandomBuffCount, _ENV, self.powerMap, _ENV, self.qualityLvsCount, _ENV, self.elementLvsCount, _ENV, self.dispatchBuffDatas, _ENV, self.groupData, _ENV, self.bagData, _ENV, self.beastData, _ENV, self.useSet, _ENV, self.gotSuitReward, _ENV, self.energy = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	print("divineBeastMarkCtrl:resetData")
end
function divineBeastMarkCtrl:setBeastData(data)
	if data == nil then
		return false
	end
	if self.beastData == nil or next(self.beastData) == nil then
		self.beastData = data
	else
		for beastId, _ in pairs(data) do
			if not self.beastData[beastId] then
				_UPVALUE6_ = nil
				self.beastData[beastId], (nil)[1] = nil, 0
				self.beastData[beastId], (nil)[2] = nil, 0
				self.beastData[beastId], (nil)[3] = nil, 0
				self.beastData[beastId], (nil)[4] = nil, 0
				self.beastData[beastId], (nil)[5] = nil, 0
				self.beastData[beastId], (nil)[6] = nil, 0
			end
		end
		for beastId, _ in pairs(self.beastData) do
			beastId = tostring(beastId)
			local beastData = data[beastId] or data[tonumber(beastId)]
			if beastData then
				self.beastData[beastId] = beastData
				for i = 1, 6 do
					self.beastData[beastId][i] = beastData[i] or 0
				end
			else
				_UPVALUE6_ = 6
				self.beastData[beastId], (6)[1] = 6, 0
				self.beastData[beastId], (6)[2] = 6, 0
				self.beastData[beastId], (6)[3] = 6, 0
				self.beastData[beastId], (6)[4] = 6, 0
				self.beastData[beastId], (6)[5] = 6, 0
				self.beastData[beastId], (6)[6] = 6, 0
			end
		end
	end
	dump(self.beastData, "mountMarkList self.beastData")
	for beastIdStr, slotIds in pairs(self.beastData) do
		local beastId = tonumber(beastIdStr)
		if not self.mountMarkList[beastId] then
			local _ENV, beastMountMarkList = self.mountMarkList[beastId], self.mountMarkList[beastId]
		end
		for slotIndex, bagMarkId in ipairs(slotIds) do
			local oldMountMark = beastMountMarkList[slotIndex]
			if oldMountMark ~= nil then
				oldMountMark.slot = nil
				oldMountMark.beastId = nil
			end
		end
	end
	for beastIdStr, slotIds in pairs(self.beastData) do
		local beastId = tonumber(beastIdStr)
		if not self.mountMarkList[beastId] then
			local _ENV, beastMountMarkList = self.mountMarkList[beastId], self.mountMarkList[beastId]
		end
		for slotIndex, bagMarkId in ipairs(slotIds) do
			local newMountmark = self:getMarkByBagMarkId(bagMarkId)
			if newMountmark then
				newMountmark.slot = slotIndex
				newMountmark.beastId = beastId
			end
			beastMountMarkList[slotIndex] = newMountmark
		end
		self.mountMarkList[beastId] = beastMountMarkList
	end
	return true
end
function divineBeastMarkCtrl:calculateBuffsAndPower()
	self.powerMap, _ENV, self.qualityLvsCount, _ENV, self.elementLvsCount, _ENV, self.dispatchBuffDatas, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	for beastId, markList in pairs(self.mountMarkList) do
		local _ENV, buffMap
		self.elementLvsCount[beastId], _ENV = nil, nil
		self.qualityLvsCount[beastId], _ENV = nil, nil
		self.powerMap[beastId] = 0
		for k, mark in pairs(markList) do
			local lvCfg = mark.lvCfg
			if not lvCfg then
				dump(mark, "mark.lvCfg is nil")
			end
			local markCfg = mark.markCfg
			self.powerMap[beastId] = self.powerMap[beastId] + lvCfg.power
			local starCfg = divineBeastMarkRead.getStarCfg(mark.star)
			if starCfg then
				self.powerMap[beastId] = self.powerMap[beastId] + starCfg.power
			end
			for _, buff in pairs(lvCfg.buff) do
				buffMap[buff.buffType] = (buffMap[buff.buffType] or 0) + buff.value
			end
			if mark.randomBuffCfg1 then
				buffMap[mark.randomBuff1] = (buffMap[mark.randomBuff1] or 0) + mark.randomBuffCfg1.value[markCfg.randombuff_type]
			end
			if mark.randomBuffCfg2 then
				buffMap[mark.randomBuff2] = (buffMap[mark.randomBuff2] or 0) + mark.randomBuffCfg2.value[markCfg.randombuff_type]
			end
			for i, element in ipairs(markCfg.elements) do
				if (markCfg.elements_lv[i] or 999) <= mark.lv then
					local finalElement = element == 5 and mark.randomElem or element
					self.elementLvsCount[beastId][finalElement] = (self.elementLvsCount[beastId][finalElement] or 0) + 1
				end
			end
			self.qualityLvsCount[beastId][markCfg.quality] = (self.qualityLvsCount[beastId][markCfg.quality] or 0) + mark.lv
		end
		for element, count in pairs(self.elementLvsCount[beastId]) do
			local elementEffectCfg = divineBeastMarkRead.getElementsEffect(beastId, element, count)
			if elementEffectCfg then
				for _, buff in ipairs(elementEffectCfg.buff) do
					buffMap[buff.buffType] = (buffMap[buff.buffType] or 0) + buff.value
				end
				self.powerMap[beastId] = self.powerMap[beastId] + elementEffectCfg.power
			end
		end
		for quality, totalLv in pairs(self.qualityLvsCount[beastId]) do
			local suitBuffCfgList = divineBeastMarkRead.getSuitBuffList(quality, totalLv, beastId)
			for _, suitCfg in ipairs(suitBuffCfgList) do
				for _, buff in ipairs(suitCfg.buff) do
					buffMap[buff.buffType] = (buffMap[buff.buffType] or 0) + buff.value
				end
				self.powerMap[beastId] = self.powerMap[beastId] + suitCfg.power
			end
		end
		self.dispatchBuffDatas[beastId] = buffMap
	end
	dump(self.elementLvsCount, "self.elementLvsCount")
	dump(self.qualityLvsCount, "self.qualityLvsCount")
end
function divineBeastMarkCtrl:setBagData(data)
	if data == nil then
		return false
	end
	local isRefreshMountMark = self:updateBagMarkListCache(data)
	return isRefreshMountMark
end
function divineBeastMarkCtrl:updateBagMarkListCache(newBagData)
	if not newBagData then
		return
	end
	local isUpdateMountMark = false
	for bagMarkIdStr, newBagMark in pairs(newBagData) do
		bagMarkIdStr = tostring(bagMarkIdStr)
		self.bagData[bagMarkIdStr] = newBagMark
		local bagMarkId = tostring(bagMarkIdStr)
		local mark = self.bagMarkList[bagMarkId]
		mark = self:getMarkFromBagDirectly(bagMarkId, newBagMark, mark)
		if mark then
			self.bagMarkList[bagMarkId] = mark
			isUpdateMountMark = isUpdateMountMark or mark.slot ~= nil
		end
	end
	return isUpdateMountMark
end
function divineBeastMarkCtrl:getMarkFromBagDirectly(bagMarkId, bagMark, mark)
	if not mark then
		mark, divineBeastMarkRead = nil, nil
	end
	mark.bagMarkId = bagMarkId
	mark.key = bagMarkId
	mark.markId = bagMark.markId
	mark.lv = bagMark.level or 0
	mark.lock = bagMark.lock or 0
	mark.star = bagMark.star or 0
	mark.randomElem = bagMark.randomElem or 0
	mark.refineElemCount = bagMark.refineElemCount or 0
	mark.randomBuff1 = bagMark.randomBuffs and bagMark.randomBuffs[1] or 0
	mark.randomBuff2 = bagMark.randomBuffs and bagMark.randomBuffs[2] or 0
	mark.markCfg = divineBeastMarkRead.getDbMarkCfg(mark.markId)
	mark.lvCfg = divineBeastMarkRead.getLvCfg(mark.markId, mark.lv)
	if mark.markCfg then
		mark.randomBuffCfg1 = divineBeastMarkRead.getRandomEffect(mark.randomBuff1, mark.markCfg.quality, mark.lv)
		mark.randomBuffCfg2 = divineBeastMarkRead.getRandomEffect(mark.randomBuff2, mark.markCfg.quality, mark.lv)
		mark.isCanChange = mark.markCfg.ChangeSelling_itemid ~= 0
	end
	if not bagMark.refineBuffs then
		_UPVALUE2_ = bagMark.refineBuffs
		bagMark.refineBuffs[1] = 0
		bagMark.refineBuffs[2] = 0
	end
	mark.refineBuffs = bagMark.refineBuffs
	return mark
end
function divineBeastMarkCtrl:setGroupData(data)
	if data == nil then
		return
	end
	self.groupData = data
end
function divineBeastMarkCtrl:mergeMark(dest, src)
	for k, v in pairs(src) do
		dest[k] = v
	end
end
function divineBeastMarkCtrl:getBagMarkList()
	return self.bagMarkList
end
function divineBeastMarkCtrl:handleDeletedMarkIds(delIds)
	if not delIds or #delIds == 0 then
		return
	end
	dump(delIds, "divineBeastMarkCtrl:handleDeletedMarkIds")
	for _, delId in ipairs(delIds) do
		delId = tostring(delId)
		if self.bagMarkList[delId] then
			self.bagMarkList[delId] = nil
			dump("Removed mark from bagMarkList: " .. tostring(delId), "handleDeletedMarkIds")
		end
		if self.bagData[delId] then
			self.bagData[delId] = nil
			dump("Removed mark from bagData: " .. delId, "handleDeletedMarkIds")
		end
	end
	dump("Deleted marks processed successfully", "handleDeletedMarkIds")
end
function divineBeastMarkCtrl:getMarkByBagMarkId(bagMarkId)
	if not bagMarkId then
		return nil
	end
	bagMarkId = tostring(bagMarkId)
	if bagMarkId == "0" or bagMarkId == "" then
		return nil
	end
	local mark = self.bagMarkList[bagMarkId]
	if mark then
		return mark
	end
	local bagMark = self.bagData[bagMarkId]
	if not bagMark then
		return nil
	end
	mark = self:getMarkFromBagDirectly(bagMarkId, bagMark, mark)
	if mark then
		self.bagMarkList[bagMarkId] = mark
	end
	return mark
end
function divineBeastMarkCtrl:sendReqInitDataMsg()
	print("divineBeastMarkCtrl:sendReqInitDataMsg")
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DATA)
end
function divineBeastMarkCtrl:sendMount(bagMarkId, beastId, slot)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).beastId = beastId
	;(nil).slot = slot
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MOUNT_IN_BEAST, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendDisMount(beastId, slot)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).slot = slot
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DISMOUNT_IN_BEAST, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendUpgrade(bagMarkId)
	serverproxy = nil
	;(nil).id = bagMarkId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_UPGRADE, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendUpStar(bagMarkId, useIds)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).useIds = useIds
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_UP_STAR, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRandomElementInBeast(beastId, slot, elem, bagMarkId, key)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).slot = slot
	;(nil).elem = elem
	;(nil).bagMarkId = bagMarkId
	;(nil).key = key
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_ELEM_IN_BEAST, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRandomElementInBag(key, elem, bagMarkId)
	serverproxy = nil
	;(nil).key = key
	;(nil).elem = elem
	;(nil).bagMarkId = bagMarkId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_ELEM_IN_BAG, nil)
end
function divineBeastMarkCtrl:sendLock(bagMarkId, lock)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).lock = lock
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_LOCK, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRecycle(keys)
	serverproxy = nil
	;(nil).ids = keys
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_RECYCLE, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendModifyRandomBuff(bagMarkId, buffIdx, buff)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).buffIdx = buffIdx
	;(nil).buff = buff
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_BUFF, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendMountInSet(bagMarkId, setId, slot)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).setId = setId
	;(nil).slot = slot
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MOUNT_IN_SET, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendDisMountInSet(setId, slot)
	serverproxy = nil
	;(nil).setId = setId
	;(nil).slot = slot
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_DISMOUNT_IN_SET, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendSaveSet(setId)
	serverproxy = nil
	;(nil).setId = setId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_SAVE_SET, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendUseSet(setId, beastId)
	serverproxy = nil
	;(nil).setId = setId
	;(nil).beastId = beastId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_USE_SET, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRename(setId, name)
	serverproxy = nil
	;(nil).setId = setId
	;(nil).name = name
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_RENAME_SET, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendMarkChange(bagMarkId, toMarkId)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).toMarkId = toMarkId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_CHANGE, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendSuitReward(beastId, quality, needLv)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).quality = quality
	;(nil).needLv = needLv
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_SUIT_REWARD, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRefineRandomElem(bagMarkId)
	serverproxy = nil
	;(nil).id = bagMarkId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_ELEM, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendModifyRandomElem(bagMarkId, elem)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).elem = elem
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_MODIFY_RANDOM_ELEM, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRefineRandomBuff(bagMarkId, buffIdx)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).buffIdx = buffIdx
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRefineRandomBuffAccept(bagMarkId, buffIdx)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).buffIdx = buffIdx
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF_ACCEPT, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendRefineRandomBuffReject(bagMarkId, buffIdx)
	serverproxy = nil
	;(nil).id = bagMarkId
	;(nil).buffIdx = buffIdx
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MARK_MODULE, gCmd.REQ_DIVINE_BEAST_MARK_REFINE_RANDOM_BUFF_REJECT, nil)
	SoraDShowLoading()
end
function divineBeastMarkCtrl:sendReqInitRsp(content)
	dump(content, "divineBeastMarkCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		self:resetData()
		self:setData(content.rspdata)
	end
end
function divineBeastMarkCtrl:sendMountRsp(content)
	dump(content, "==sendMountRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		if not self.useSet then
			_ENV = self.useSet
		end
		self.useSet = self.useSet
		self.useSet[tostring(content.data.beastId)] = nil
		_ENV = tostring(content.data.beastId)
		tostring(content.data.beastId).msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		tostring(content.data.beastId).type = "mount"
		tostring(content.data.beastId).bagMarkId = bagMarkId
		SoraDSendMessage((tostring(content.data.beastId)))
		return
	end
end
function divineBeastMarkCtrl:sendDisMountRsp(content)
	dump(content, "==sendDisMount==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:dealRspData(content.rspdata)
		if not self.useSet then
			_ENV = self.useSet
		end
		self.useSet = self.useSet
		self.useSet[tostring(content.data.beastId)] = nil
		_ENV = tostring(content.data.beastId)
		tostring(content.data.beastId).msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		tostring(content.data.beastId).type = "dismount"
		SoraDSendMessage((tostring(content.data.beastId)))
		return
	end
end
function divineBeastMarkCtrl:sendUpgradeRsp(content)
	dump(content, "==sendUpgradeRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "upgrade"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendUpStarRsp(content)
	dump(content, "==sendUpStarRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "star"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendLockRsp(content)
	dump(content, "==sendLockRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "lock"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendRecycleRsp(content)
	dump(content, "==sendRecycleRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self:setData(data, false)
		self:handleDeletedMarkIds(content.rspdata.delIds)
		if content.rspdata.recycleItems and #content.rspdata.recycleItems > 0 then
			local _ENV, newList = #content.rspdata.recycleItems, #content.rspdata.recycleItems
			for i, v in ipairs(content.rspdata.recycleItems) do
				if v.count ~= 0 then
					table.insert(newList, v)
				end
			end
			SoraDMailGainItems(newList, true)
		end
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		SoraDMailGainItems.type = "recycle"
		SoraDSendMessage(SoraDMailGainItems)
		return
	end
end
function divineBeastMarkCtrl:sendModifyRandomBuffRsp(content)
	dump(content, "==sendModifyRandomBuffRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "modify"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendMountInSetRsp(content)
	dump(content, "==sendMountInSetRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "mountInset"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendDisMountInSetRsp(content)
	dump(content, "==sendDisMountInSetRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "mountInset"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendUseSetRsp(content)
	dump(content, "==sendUseSetRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "set"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendRenameRsp(content)
	dump(content, "==sendRenameRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "rename"
		self.setId = content.data.setId
		self.name = content.data.name
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendMarkChangeRsp(content)
	dump(content, "==sendMarkChangeRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.newId)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "change"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendSuitRewardRsp(content)
	dump(content, "==sendSuitRewardRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		if data.gotSuitReward ~= nil then
			self.gotSuitReward = data.gotSuitReward
		end
		local lv = content.data.needLv
		local quality = content.data.quality
		local cfg = divineBeastMarkRead.getSuitBuffCfg(quality, lv, content.data.beastId)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		SoraDMailGainItems(serviceFunctions.tableFormat(cfg.reward, nil), true)
		_ENV = serviceFunctions.tableFormat(cfg.reward, nil)
		serviceFunctions.tableFormat(cfg.reward, nil).msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		serviceFunctions.tableFormat(cfg.reward, nil).type = "reward"
		SoraDSendMessage((serviceFunctions.tableFormat(cfg.reward, nil)))
		return
	end
end
function divineBeastMarkCtrl:sendRefineRandomElemRsp(content)
	dump(content, "==sendRefineRandomElemRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "element"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendModifyRandomElemRsp(content)
	dump(content, "==sendModifyRandomElemRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "element"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendRefineRandomBuffRsp(content)
	dump(content, "==sendRefineRandomBuffRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		if content.rspdata.data.refineRandomBuffCount ~= nil then
			self.refineRandomBuffCount = content.rspdata.data.refineRandomBuffCount
		end
		self:dealRspData(content.rspdata)
		dump(self.refineRandomBuffCount, "self.refineRandomBuffCount")
		_ENV = self.refineRandomBuffCount
		self.refineRandomBuffCount.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.refineRandomBuffCount.type = "refine"
		self.refineRandomBuffCount.bagMarkId = bagMarkId
		SoraDSendMessage(self.refineRandomBuffCount)
		return
	end
end
function divineBeastMarkCtrl:sendRefineRandomBuffAcceptRsp(content)
	dump(content, "==sendRefineRandomBuffAcceptRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "refine"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:sendRefineRandomBuffRejectRsp(content)
	dump(content, "==sendRefineRandomBuffRejectRsp==", 20)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local bagMarkId = tostring(content.data.id)
		self:dealRspData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST_MARK"
		self.type = "refine"
		self.bagMarkId = bagMarkId
		SoraDSendMessage(self)
		return
	end
end
function divineBeastMarkCtrl:getIsShowBubble(beastId, stepLv)
	beastId = tonumber(beastId)
	if not self:getIsFuncOpen(beastId) then
		return false
	end
	if self:getIsHaveQualityLvReward(beastId) then
		return true
	end
	local isHaveEmpty = false
	local _ENV, slotMarkTypeMap = self, self
	for i = 1, 6 do
		local unlockLv = divineBeastMarkRead.getSlotUnlock(beastId, i)
		if stepLv >= unlockLv and self:getSlotMileStoneUnlock(beastId, i) then
			local mark = self:getBeastMarkData(beastId, i)
			isHaveEmpty = isHaveEmpty or mark == nil
			if mark and mark.markCfg then
				slotMarkTypeMap[mark.markCfg.type] = true
			end
		end
	end
	if not isHaveEmpty then
		return false
	end
	self.slotMarkTypeMap = slotMarkTypeMap
	local bagMarkList = self:getBagMarkList()
	for _, mark in pairs(bagMarkList) do
		if mark.markCfg and not slotMarkTypeMap[mark.markCfg.type] then
			return true
		end
	end
	return false
end
_ENV, divineBeastMarkCtrl.getIsHaveQualityLvReward = function(self, beastId)
	if not self.qualityLvsCount[beastId] then
		local _ENV, qualityLvsCount = self.qualityLvsCount[beastId], self.qualityLvsCount[beastId]
	end
	for k, v in pairs(qualityLvsCount) do
		local suitBuffList = divineBeastMarkRead.getSuitBuffCfgs(k, beastId)
		for i2, v2 in ipairs(suitBuffList) do
			if v >= v2.need_lv and not self:getIsGotSuitReward(beastId, k, v2.need_lv) then
				return true
			end
		end
	end
	return false
end, function(self, beastId)
	if not self.qualityLvsCount[beastId] then
		local _ENV, qualityLvsCount = self.qualityLvsCount[beastId], self.qualityLvsCount[beastId]
	end
	for k, v in pairs(qualityLvsCount) do
		local suitBuffList = divineBeastMarkRead.getSuitBuffCfgs(k, beastId)
		for i2, v2 in ipairs(suitBuffList) do
			if v >= v2.need_lv and not self:getIsGotSuitReward(beastId, k, v2.need_lv) then
				return true
			end
		end
	end
	return false
end
;(function(self, beastId)
	if not self.qualityLvsCount[beastId] then
		local _ENV, qualityLvsCount = self.qualityLvsCount[beastId], self.qualityLvsCount[beastId]
	end
	for k, v in pairs(qualityLvsCount) do
		local suitBuffList = divineBeastMarkRead.getSuitBuffCfgs(k, beastId)
		for i2, v2 in ipairs(suitBuffList) do
			if v >= v2.need_lv and not self:getIsGotSuitReward(beastId, k, v2.need_lv) then
				return true
			end
		end
	end
	return false
end)[1900] = gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_1900_MARK_SLOT
local (function(self, beastId)
	if not self.qualityLvsCount[beastId] then
		local _ENV, qualityLvsCount = self.qualityLvsCount[beastId], self.qualityLvsCount[beastId]
	end
	for k, v in pairs(qualityLvsCount) do
		local suitBuffList = divineBeastMarkRead.getSuitBuffCfgs(k, beastId)
		for i2, v2 in ipairs(suitBuffList) do
			if v >= v2.need_lv and not self:getIsGotSuitReward(beastId, k, v2.need_lv) then
				return true
			end
		end
	end
	return false
end)[1901], beastIDNebulaMileStoneMap = gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_1901_MARK_SLOT, function(self, beastId)
	if not self.qualityLvsCount[beastId] then
		local _ENV, qualityLvsCount = self.qualityLvsCount[beastId], self.qualityLvsCount[beastId]
	end
	for k, v in pairs(qualityLvsCount) do
		local suitBuffList = divineBeastMarkRead.getSuitBuffCfgs(k, beastId)
		for i2, v2 in ipairs(suitBuffList) do
			if v >= v2.need_lv and not self:getIsGotSuitReward(beastId, k, v2.need_lv) then
				return true
			end
		end
	end
	return false
end
function divineBeastMarkCtrl:getSlotMileStoneUnlock(beastId, slot)
	beastId = beastId or 1900
	local nebulaMileStoneUnlockType = beastIDNebulaMileStoneMap[beastId]
	if not nebulaMileStoneUnlockType then
		return true
	end
	if slot == 1 then
		return true
	end
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local value = nebulaMileStoneCtrl:getPlusByUnlockType(nebulaMileStoneUnlockType)
	return value and slot <= value
end
function divineBeastMarkCtrl:getMilStoneTaskName(beastId, slot)
	beastId = beastId or 1900
	local isUnlock = self:getSlotMileStoneUnlock(beastId, slot)
	if isUnlock then
		return nil
	end
	local nebulaMileStoneUnlockType = beastIDNebulaMileStoneMap[beastId]
	if not nebulaMileStoneUnlockType then
		return nil
	end
	local nebulaMileStoneRead = include("nebulaMileStoneRead")
	local unlockMileStoneTask = nebulaMileStoneRead.getConfigByUnlockType(nebulaMileStoneUnlockType, slot)
	dump(unlockMileStoneTask, "unlockMileStoneTask")
	return unlockMileStoneTask and nebulaMileStoneRead.getName(unlockMileStoneTask.milestoneID) or nil
end
function divineBeastMarkCtrl:getSlotMarkTypeMap()
	if not self.slotMarkTypeMap then
		_UPVALUE0_ = self.slotMarkTypeMap
	end
	return self.slotMarkTypeMap
end
function divineBeastMarkCtrl:getIsFuncOpen(divineID)
	divineID = divineID or divineBeastRead.getDefaultDivineID()
	local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
	local stepLv = divineBeastCtrl:getStepLv(divineID)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local isNebulaMileStoneUnlock = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_MARK)
	local lockStepLv = divineBeastRead.getMarkUnlockStepLv(divineID)
	_UPVALUE4_ = nil
	;(nil)[1] = isNebulaMileStoneUnlock
	;(nil)[2] = gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_MARK
	;(nil)[3] = lockStepLv
	;(nil)[4] = stepLv
	dump(nil, "==isNebulaMileStoneUnlock==", 20)
	return self.lockCityLv <= SoraDGetCastleLv() and stepLv >= lockStepLv and isNebulaMileStoneUnlock == 1, lockStepLv == stepLv
end
function divineBeastMarkCtrl:getBeastMarkData(beastId, slot)
	if beastId == nil then
		return self.mountMarkList
	end
	beastId = tonumber(beastId)
	local markList = self.mountMarkList[beastId]
	if not markList and not slot then
		_ENV = beastId
		return beastId
	end
	if not slot then
		return markList
	end
	return markList and markList[slot] or nil
end
function divineBeastMarkCtrl:getDispatchAddCount(beastId, effectType)
	local effectValue = self.dispatchBuffDatas[tonumber(beastId)] and self.dispatchBuffDatas[tonumber(beastId)][effectType] or 0
	return effectValue / 10
end
function divineBeastMarkCtrl:getPower(beastId)
	local power = self.powerMap[beastId] or 0
	return power
end
function divineBeastMarkCtrl:getElementLvCount(beastId)
	if not self.elementLvsCount[beastId] then
		_UPVALUE0_ = self.elementLvsCount[beastId]
	end
	return self.elementLvsCount[beastId]
end
function divineBeastMarkCtrl:getExpCount()
	return self.expCount or 0
end
function divineBeastMarkCtrl:getEnergyCount()
	return self.energy
end
function divineBeastMarkCtrl:getGroupName(setId)
	if setId == nil or setId == 0 then
		return i18n("Divine_beast_mark_text_91")
	end
	setId = tonumber(setId)
	if not self.groupData[setId] or not self.groupData[setId].name then
		_ENV = nil
		;(nil).name = setId
	end
	return (i18n("lordskill_page_01", nil))
end
function divineBeastMarkCtrl:getUseSet(beastId)
	return self.useSet[tostring(beastId)] or nil
end
function divineBeastMarkCtrl:getGroupMarkData(setId)
	if not (self.groupData and self.groupData[setId]) or not self.groupData[setId].marks then
		_ENV = self.groupData[setId].marks
		return self.groupData[setId].marks
	end
	local _ENV, markData = self.groupData[setId].marks, self.groupData[setId].marks
	for i, bagMarkId in ipairs(self.groupData[setId].marks) do
		if bagMarkId and bagMarkId ~= 0 then
			local mark = self:getMarkByBagMarkId(bagMarkId)
			markData[i] = mark
		end
	end
	return markData
end
function divineBeastMarkCtrl:getQualityLvsCount(beastId, quality)
	return self.qualityLvsCount[beastId] and self.qualityLvsCount[beastId][quality] or 0
end
function divineBeastMarkCtrl:getIsGotSuitReward(beastId, quality, lv)
	beastId = tostring(beastId)
	quality = tostring(quality)
	lv = tostring(lv)
	if not self.gotSuitReward[beastId] or not self.gotSuitReward[beastId][quality] then
		return false
	end
	return self.gotSuitReward[beastId][quality][lv] or false
end
function divineBeastMarkCtrl:getRefineCount(key, buffIdx)
	return self.refineRandomBuffCount[tostring(key)] and self.refineRandomBuffCount[tostring(key)][buffIdx] or 0
end
return divineBeastMarkCtrl

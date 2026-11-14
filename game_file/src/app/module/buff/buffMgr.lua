local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffSourceList = include("buffSourceList")
local buffLogic = include("buffLogic")
local buffMgr = class("buffMgr")
local buffFinishListener = function(self, source, buff, count)
	print("=====》buff结束了")
	print("source:", source)
	print("buffid:", buff:getProperty("id"))
	print("count = ", count)
	if gBuffSource.CITY == source or gBuffSource.HALLOWEEN == source then
		_ENV = "count = "
		;("count = ").msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
		;("count = ").buffid = buff:getProperty("effectType")
		SoraDSendMessage("count = ")
	elseif buff:getProperty("id") == 5436 or buff:getProperty("id") == 5446 then
		_ENV = buff
		buff.msg = "MESSAGE_REFRESH_TIME_END_FOR_SKILL"
		SoraDSendMessage(buff)
	end
end
function buffMgr:ctor()
	self.buffSources, buffLogic = nil, nil
	local list = buffLogic.getBuffSourceList()
	for _, source in pairs(list) do
		self.buffSources[source] = buffSourceList.new(source)
		self.buffSources[source]:setBuffFinishListener(handler(self, buffFinishListener))
	end
end
function buffMgr:openBuff(buffID, beginTime, extra, time)
	local source = buffltCtrl:getBuffSource(buffID)
	local list = self:getBuffSourceList(source)
	if list then
		local buff = list:openBuff(buffID, beginTime, extra, time)
		if buff and (gBuffSource.CITY == source or gBuffSource.HALLOWEEN == source) then
			buffltCtrl = buffID
			buffltCtrl, buffID.msg = beginTime, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD"
			buffID.data, beginTime.effectType = beginTime, buff:getProperty("effectType")
			SoraDSendMessage(buffID)
		elseif buff and gBuffSource.VIP == source then
			buffltCtrl = buffID
			buffID.msg = "MESSAGE_LORDVALUE_VIP_ACTIVATE"
			SoraDSendMessage(buffID)
			buffltCtrl = buffID
			buffID.msg = "MESSAGE_VIP_UPDATE"
			SoraDSendMessage(buffID)
		end
		return buff
	end
end
function buffMgr:closeBuff(effectType)
	local _ENV, ret
	for source, list in pairs(self.buffSources) do
		local buff = list:closeBuff(effectType)
		if buff then
			table.insert(ret, buff)
		end
	end
	return ret
end
function buffMgr:closeSource(source, effectType)
	local list = self.buffSources[source]
	if list then
		if effectType then
			list:closeBuff(effectType)
		else
			return list:close()
		end
	end
end
function buffMgr:getBuffSourceList(source)
	return self.buffSources[source]
end
function buffMgr:getAllBuffData()
	local _ENV, ret
	for source, list in pairs(self.buffSources) do
		local buffs = list:getAllBuff()
		local _ENV, d = list, list
		for effectType, buff in pairs(buffs) do
			d.id = buff:getProperty("id")
			d.beginTime = buff:getProperty("beginTime")
			table.insert(ret, d)
		end
	end
	return ret
end
function buffMgr:queryBuff(source, effectType)
	if not source or not effectType then
		return
	end
	local list = self:getBuffSourceList(source)
	if list then
		return list:queryBuff(effectType)
	end
end
function buffMgr:queryBuffSource(source)
	if not source then
		return
	end
	return self:getBuffSourceList(source)
end
function buffMgr:getBuffEffect(effectType, source)
	if source then
		local list = self:getBuffSourceList(source)
		local effect = list and list:queryBuffEffect(effectType)
		return effect
	else
		local _ENV, bufflist = self:getBuffSourceList(source), self:getBuffSourceList(source)
		local totalEffect
		for source, list in pairs(self.buffSources) do
			local buff = list:queryBuff(effectType)
			if buff then
				local effect = buff:getProperty("effect")
				table.insert(bufflist, buff:getProperties())
				if "boolean" == type(effect) then
					totalEffect = effect
				elseif "number" == type(effect) then
					totalEffect = totalEffect or 0
					totalEffect = totalEffect + effect
				end
			end
		end
		return totalEffect, bufflist
	end
end
function buffMgr:getBuffList(effectType)
	for source, list in pairs(self.buffSources) do
		local buff = list:queryBuff(effectType)
		if buff then
			local effect = buff:getProperty("effect")
			table.insert(bufflist, buff:getProperties())
		end
	end
end
function buffMgr:dump()
	print("=====> buffMgr: buffSourceList")
	for source, list in pairs(self.buffSources) do
		list:dump()
	end
end
return buffMgr

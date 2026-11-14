local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffLogic = include("buffLogic")
local buffClass = include("buff")
local buffSourceList = class("buffSourceList")
local finishBuffListener = function(self, buff, count)
	local effectType = buff:getProperty("effectType")
	self.buffs[effectType] = nil
	if "function" == type(self.listener) then
		self.listener(self.source, buff, count)
	end
end
function buffSourceList:ctor(source)
	self.buffs, _UPVALUE0_ = nil, nil
	self.source = source
	self.open = true
end
function buffSourceList:isOpening()
	return self.open
end
function buffSourceList:open()
	self.open = true
end
function buffSourceList:close()
	local _ENV, ret
	self.open = false
	for _, buff in pairs(self.buffs) do
		buff:closeBuff()
		_ENV = nil
		;(nil).effectType = buff:getProperty("effectType")
		;(nil).buffID = buff:getProperty("id")
		table.insert(ret, nil)
	end
	return ret
end
function buffSourceList:openBuff(buffID, beginTime, extra, time)
	local effectType = buffltCtrl:getEffectType(buffID)
	if effectType == gBuffEffect.FOOD_OUTPUT_BOOST or effectType == gBuffEffect.WOOD_OUTPUT_BOOST or effectType == gBuffEffect.IRON_OUTPUT_BOOST or effectType == gBuffEffect.MITHRIL_OUTPUT_BOOST or effectType == gBuffEffect.CRYSTAL_OUTPUT_BOOST then
		local buffltCtrl, extra = gBuffEffect.CRYSTAL_OUTPUT_BOOST, extra or gBuffEffect.CRYSTAL_OUTPUT_BOOST
		local bid, iid = extra.bid, extra.iid
		effectType = effectType .. "@" .. "bid" .. "_" .. bid .. "_" .. "iid" .. "_" .. iid
	end
	local curBuff = self.buffs[effectType]
	if curBuff then
		if not buffLogic.canReplace(self.source) then
			return false
		else
			curBuff:cancelBuff()
			curBuff = nil
			self.buffs[effectType] = nil
		end
	end
	local buff = buffClass.create(buffID, handler(self, finishBuffListener))
	if beginTime then
		buff:setProperty("beginTime", beginTime)
	end
	if time then
		buff:setProperty("time", time)
	end
	self.buffs[effectType] = buff
	buff:openBuff()
	buff:setProperty("effectType", effectType)
	return buff
end
function buffSourceList:closeBuff(effectType)
	if buffLogic.canInterrupt(self.source) then
		local buff = self:queryBuff(effectType)
		if buff then
			buff:closeBuff()
			return buff
		end
	end
end
function buffSourceList:queryBuff(effectType)
	return self.buffs[effectType]
end
function buffSourceList:queryBuffEffect(effectType)
	local buff = self:queryBuff(effectType)
	if buff then
		return buff:getProperty("effect")
	end
end
function buffSourceList:getAllBuff()
	return self.buffs
end
function buffSourceList:setBuffFinishListener(listener)
	self.listener = listener
end
function buffSourceList:dump()
	print("=====> source:", self.source)
	print("open:", self.open)
	print("=====> bufflist")
	for _, buff in pairs(self.buffs) do
		buff:dump()
	end
	print("\n")
end
return buffSourceList

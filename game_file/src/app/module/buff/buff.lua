local timerModule = gModuleMgr.getObject("timerList")
local customModelBase = include("customModelBase")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buff = class("buff", customModelBase)
_ENV = "buff"
;("buff").id = 0
;("buff").beginTime = 0
;("buff").time = 0
;("buff").effectType = 0
;("buff").effect = 0
local ("buff").source, property = 0, "buff"
function buff:ctor(properties, listener)
	buff.super.ctor(self, property)
	self:setProperties(properties)
	local id = self.property.id
	self:setProperty("time", buffltCtrl:getTime(id))
	self:setProperty("effectType", buffltCtrl:getEffectType(id))
	self:setProperty("effect", buffltCtrl:getEffect(id))
	self:setProperty("source", buffltCtrl:getBuffSource(id))
	self.isOpen = false
	self:setFinishBuffListener(listener)
	self.duration = false
	local time = self:getProperty("time")
	if 0 < time then
		self.duration = true
	end
end
local finishBuffEvent = function(self, count)
	if "function" == type(self.finishBuffListener) then
		self.finishBuffListener(self, count)
	end
	if count <= 0 then
		self.timerNode = nil
		self.isOpen = false
	end
end
function buff.create(id, listener)
	buff = nil
	;(nil).id = id
	return buff.new(nil, listener)
end
function buff:isOpen()
	return self.isOpen
end
function buff:openBuff()
	if self.isOpen then
		return
	end
	local ok, node
	if self:isDuration() then
		ok, node = timerModule:createTimer(self:getProperty("time"), timerHandler(finishBuffEvent, self))
		local beginTime = self:getProperty("beginTime")
		if 0 < beginTime then
			node.timer:resetStartTime(beginTime)
		else
			local beginTime = node.timer:getStartTime()
			self:setProperty("beginTime", beginTime)
		end
		if ok then
			self:setTimerNode(node)
		end
	end
	self.isOpen = true
	return ok, node
end
function buff:cancelBuff()
	if self.duration and self.timerNode then
		timerModule:cancelTimer(self.timerNode)
		self.timerNode = nil
	end
	self.isOpen = false
end
function buff:closeBuff()
	self:cancelBuff()
	finishBuffEvent(self, 0)
	self.isOpen = false
end
function buff:setTimerNode(node)
	self.timerNode = node
end
function buff:getTimerNode()
	return self.timerNode
end
function buff:getRemainTime()
	if self:isDuration() then
		local node = self:getTimerNode()
		if node then
			return node.timer:getRemainTime()
		end
	end
end
function buff:isDuration()
	return self.duration
end
function buff:setFinishBuffListener(listener)
	self.finishBuffListener = listener
end
function buff:dump()
	if self:isDuration() and self.timerNode then
		self.timerNode.timer:dump()
	end
end
return buff

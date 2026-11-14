if nil == ccs then
	return
end
if not json then
	require("cocos.cocos2d.json")
end
if not ccs then
	_ENV = ccs
end
ccs = ccs
require("cocos.cocostudio.StudioConstants")
function ccs.sendTriggerEvent(event)
	local triggerObjArr = ccs.TriggerMng.getInstance():get(event)
	if nil == triggerObjArr then
		return
	end
	for i = 1, table.getn(triggerObjArr) do
		local triObj = triggerObjArr[i]
		if nil ~= triObj and triObj:detect() then
			triObj:done()
		end
	end
end
function ccs.registerTriggerClass(className, createFunc)
	ccs.TInfo.new(className, createFunc)
end
ccs.TInfo = class("TInfo")
ccs.TInfo._className = ""
ccs.TInfo._fun = nil
function ccs.TInfo:ctor(c, f)
	if nil ~= f then
		self._className = c
		self._fun = f
	else
		self._className = c._className
		self._fun = c._fun
	end
	ccs.ObjectFactory.getInstance():registerType(self)
end
ccs.ObjectFactory = class("ObjectFactory")
ccs.ObjectFactory._typeMap = nil
ccs.ObjectFactory._instance = nil
function ccs.ObjectFactory:ctor()
	self._typeMap, _UPVALUE0_ = nil, nil
end
function ccs.ObjectFactory.getInstance()
	if nil == ccs.ObjectFactory._instance then
		ccs.ObjectFactory._instance = ccs.ObjectFactory.new()
	end
	return ccs.ObjectFactory._instance
end
function ccs.ObjectFactory.destroyInstance()
	ccs.ObjectFactory._instance = nil
end
function ccs.ObjectFactory:createObject(classname)
	local obj
	local t = self._typeMap[classname]
	if nil ~= t then
		obj = t._fun()
	end
	return obj
end
function ccs.ObjectFactory:registerType(t)
	self._typeMap[t._className] = t
end
ccs.TriggerObj = class("TriggerObj")
ccs.TriggerObj._cons, _ENV = class("TriggerObj"), class("TriggerObj")
ccs.TriggerObj._acts, _ENV = class("TriggerObj"), class("TriggerObj")
ccs.TriggerObj._enable = false
ccs.TriggerObj._id = 0
ccs.TriggerObj._vInt, _ENV = class("TriggerObj"), class("TriggerObj")
function ccs.TriggerObj.extend(target)
	local t = tolua.getpeer(target)
	if not t then
		t, _ENV = target, target
		tolua.setpeer(target, t)
	end
	setmetatable(t, TriggerObj)
	return target
end
function ccs.TriggerObj:ctor()
	self:init()
end
function ccs.TriggerObj:init()
	self._id = 0
	self._vInt, _UPVALUE0_, self._acts, _UPVALUE0_, self._cons, _UPVALUE0_, self._enable = nil, nil, nil, nil, nil, nil, true
end
function ccs.TriggerObj:detect()
	if not self._enable or table.getn(self._cons) == 0 then
		return true
	end
	local ret = true
	local obj
	for i = 1, table.getn(self._cons) do
		obj = self._cons[i]
		if nil ~= obj and nil ~= obj.detect and ret then
			ret = obj:detect()
		end
	end
	return ret
end
function ccs.TriggerObj:done()
	if not self._enable or table.getn(self._acts) == 0 then
		return
	end
	local obj
	for i = 1, table.getn(self._acts) do
		obj = self._acts[i]
		if nil ~= obj and obj.done then
			obj:done()
		end
	end
end
function ccs.TriggerObj:removeAll()
	local obj
	for i = 1, table.getn(self._cons) do
		obj = self._cons[i]
		if nil ~= obj then
			obj:removeAll()
		end
	end
	self._cons, _ENV = 1, (for index)
	for i = 1, table.getn(self._acts) do
		obj = self._acts[i]
		if nil ~= obj then
			obj:removeAll()
		end
	end
	self._acts, _ENV = 1, (for index)
end
function ccs.TriggerObj:serialize(jsonValue)
	self._id = jsonValue.id
	local count = 0
	local cons = jsonValue.conditions
	if nil ~= cons then
		count = table.getn(cons)
		for i = 1, count do
			local subDict = cons[i]
			local className = subDict.classname
			if nil ~= className then
				local obj = ccs.ObjectFactory.getInstance():createObject(className)
				assert(nil ~= obj, string.format("class named %s can not implement!", className))
				obj:serialize(subDict)
				obj:init()
				table.insert(self._cons, obj)
			end
		end
	end
	local actions = jsonValue.actions
	if nil ~= actions then
		count = table.getn(actions)
		for i = 1, count do
			local subAction = actions[i]
			local className = subAction.classname
			if nil ~= className then
				local act = ccs.ObjectFactory.getInstance():createObject(className)
				assert(nil ~= act, string.format("class named %s can not implement!", className))
				act:serialize(subAction)
				act:init()
				table.insert(self._acts, act)
			end
		end
	end
	local events = jsonValue.events
	if nil ~= events then
		count = table.getn(events)
		for i = 1, count do
			local subEveent = events[i]
			local eventID = subEveent.id
			if 0 <= eventID then
				table.insert(self._vInt, eventID)
			end
		end
	end
end
function ccs.TriggerObj:getId()
	return self._id
end
function ccs.TriggerObj:setEnable(enable)
	self._enable = enable
end
function ccs.TriggerObj:getEvents()
	return self._vInt
end
ccs.TriggerMng = class("TriggerMng")
ccs.TriggerMng._eventTriggers = nil
ccs.TriggerMng._triggerObjs = nil
ccs.TriggerMng._movementDispatches = nil
ccs.TriggerMng._instance = nil
function ccs.TriggerMng:ctor()
	self._eventTriggers, _UPVALUE0_, self._movementDispatches, _UPVALUE0_, self._triggerObjs, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
end
function ccs.TriggerMng.getInstance()
	if ccs.TriggerMng._instance == nil then
		ccs.TriggerMng._instance = ccs.TriggerMng.new()
	end
	return ccs.TriggerMng._instance
end
function ccs.TriggerMng.destroyInstance()
	if ccs.TriggerMng._instance ~= nil then
		ccs.TriggerMng._instance:removeAll()
		ccs.TriggerMng._instance = nil
	end
end
function ccs.TriggerMng:triggerMngVersion()
	return "1.0.0.0"
end
function ccs.TriggerMng:parse(jsonStr)
	local parseTable = json.decode(jsonStr, 1)
	if nil == parseTable then
		return
	end
	local count = table.getn(parseTable)
	for i = 1, count do
		local subDict = parseTable[i]
		local triggerObj = ccs.TriggerObj.new()
		triggerObj:serialize(subDict)
		local events = triggerObj:getEvents()
		for j = 1, table.getn(events) do
			local event = events[j]
			self:add(event, triggerObj)
		end
		self._triggerObjs[triggerObj:getId()] = triggerObj
	end
end
function ccs.TriggerMng:get(event)
	return self._eventTriggers[event]
end
function ccs.TriggerMng:getTriggerObj(id)
	return self._triggerObjs[id]
end
function ccs.TriggerMng:add(event, triggerObj)
	local eventTriggers = self._eventTriggers[event]
	if nil == eventTriggers then
		eventTriggers, _ENV = nil, nil
	end
	local exist = false
	for i = 1, table.getn(eventTriggers) do
		if eventTriggers[i] == triggers then
			exist = true
			break
		end
	end
	if not exist then
		table.insert(eventTriggers, triggerObj)
		self._eventTriggers[event] = eventTriggers
	end
end
function ccs.TriggerMng:removeAll()
	for k in pairs(self._eventTriggers) do
		local triObjArr = self._eventTriggers[k]
		for j = 1, table.getn(triObjArr) do
			local obj = triObjArr[j]
			obj:removeAll()
		end
	end
	self._eventTriggers, _ENV = pairs(self._eventTriggers)
end
function ccs.TriggerMng:remove(event, obj)
	if nil ~= obj then
		return self:removeObjByEvent(event, obj)
	end
	assert(0 <= event, "event must be larger than 0")
	if nil == self._eventTriggers then
		return false
	end
	local triObjects = self._eventTriggers[event]
	if nil == triObjects then
		return false
	end
	for i = 1, table.getn(triObjects) do
		local triObject = triggers[i]
		if nil ~= triObject then
			triObject:remvoeAll()
		end
	end
	self._eventTriggers[event] = nil
	return true
end
function ccs.TriggerMng:removeObjByEvent(event, obj)
	assert(0 <= event, "event must be larger than 0")
	if nil == self._eventTriggers then
		return false
	end
	local triObjects = self._eventTriggers[event]
	if nil == triObjects then
		return false
	end
	for i = 1, table.getn(triObjects) do
		local triObject = triObjects[i]
		if nil ~= triObject and triObject == obj then
			triObject:remvoeAll()
			table.remove(triObjects, i)
			return true
		end
	end
end
function ccs.TriggerMng:removeTriggerObj(id)
	local obj = self.getTriggerObj(id)
	if nil == obj then
		return false
	end
	local events = obj:getEvents()
	for i = 1, table.getn(events) do
		self:remove(events[i], obj)
	end
	return true
end
function ccs.TriggerMng:isEmpty()
	return nil ~= self._eventTriggers or table.getn(self._eventTriggers) <= 0
end
function __onParseConfig(configType, jasonStr)
	if configType == cc.ConfigType.COCOSTUDIO then
		ccs.TriggerMng.getInstance():parse(jasonStr)
	end
end
function ccs.AnimationInfo(_name, _startIndex, _endIndex)
	assert(nil ~= _name and type(_name) == "string" and _startIndex ~= nil and type(_startIndex) == "number" and _endIndex ~= nil and type(_endIndex) == "number", "ccs.AnimationInfo() - invalid input parameters")
	_ENV = assert
	assert.name = _name
	assert.startIndex = _startIndex
	assert.endIndex = _endIndex
	return assert
end

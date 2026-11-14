local setmetatable = setmetatable
local pcall = pcall
local assert = assert
local error = error
local traceback = debug.traceback
local list = require("framework.common.list")
local ilist = list.ilist
local event_err_handle = function(msg)
	error(msg, 2)
end
_ENV = nil
;(nil).__call = function(self, ...)
	local status, err
	if not self.obj then
		status, err = pcall(self.func, ...)
	else
		status, err = pcall(self.func, self.obj, ...)
	end
	if not status then
		event_err_handle(err .. "\n" .. traceback())
	end
	return status
end
local (nil).__eq, _pcall = function(lhs, rhs)
	return lhs.func == rhs.func and lhs.obj == rhs.obj
end, nil
local functor = function(func, obj)
	setmetatable = nil
	;(nil).func = func
	;(nil).obj = obj
	return setmetatable(nil, _pcall)
end
local _ENV, _event
_event.__index = _event
function _event:CreateListener(func, obj)
	functor, func = functor(func, obj), functor(func, obj)
	functor(func, obj).value = func
	functor(func, obj)._prev = 0
	functor(func, obj)._next = 0
	functor(func, obj).removed = true
	return (functor(func, obj))
end
function _event:AddListener(handle)
	assert(handle)
	if self.lock then
		table.insert(self.opList, function()
			self.list:pushnode(handle)
		end)
	else
		self.list:pushnode(handle)
	end
end
function _event:RemoveListener(handle)
	assert(handle)
	if self.lock then
		table.insert(self.opList, function()
			self.list:remove(handle)
		end)
	else
		self.list:remove(handle)
	end
end
function _event:Count()
	return self.list.length
end
function _event:Clear()
	self.list:clear()
	self.opList, _UPVALUE0_ = self.list.clear, self.list.clear
	self.lock = false
	self.current = nil
end
function _event:__call(...)
	local _list = self.list
	self.lock = true
	for i, f in ilist(_list) do
		self.current = i
		if not f(...) then
			_list:remove(i)
			self.lock = false
		end
	end
	local opList = self.opList
	self.lock = false
	for i, op in ipairs(opList) do
		op()
		opList[i] = nil
	end
end
function _event.new(name)
	setmetatable = nil
	;(nil).name = name
	;(nil).opList, setmetatable, (nil).lock = nil, nil, false
	;(nil).list = list:new()
	return setmetatable(nil, _event)
end
return _event

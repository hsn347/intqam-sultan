function clone(object)
	local _ENV, lookup_table
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local _ENV, new_table = lookup_table[object], lookup_table[object]
		lookup_table[object] = new_table
		for key, value in pairs(object) do
			new_table[_copy(key)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end
function classEx(classname, super)
	local superType = type(super)
	local cls
	if superType ~= "function" and superType ~= "table" then
		super = nil
		superType = nil
	end
	if superType == "function" or super and super.__ctype == 1 then
		cls, _ENV = super.__ctype, super.__ctype
		if superType == "table" then
			for k, v in pairs(super) do
				cls[k] = v
			end
			cls.__create = super.__create
			cls.super = super
		else
			cls.__create = super
		end
		function cls.ctor()
		end
		cls.__cname = classname
		cls.__ctype = 1
		function cls.new(...)
			local instance = cls.__create(...)
			for k, v in pairs(cls) do
				instance[k] = v
			end
			instance.class = cls
			instance:ctor(...)
			return instance
		end
	else
		if super then
			cls = clone(super)
			cls.super = super
		else
			_ENV = clone(super)
			cls, clone(super).ctor = clone(super), function()
			end
		end
		cls.__cname = classname
		cls.__ctype = 2
		cls.__index = cls
		function cls.new(...)
			_ENV = nil
			local instance = setmetatable(nil, cls)
			instance.class = cls
			instance:ctor(...)
			return instance
		end
	end
	return cls
end
local setmetatableindex_
function createPeer()
	;(nil).__superPeer, _ENV, _ENV = nil, nil, nil
	local peer
	_ENV = nil
	;(nil).__index = function(tb, key)
		local supers = tb.__superPeer
		for i = #supers, 1, -1 do
			local super = supers[i]
			if super[key] then
				return super[key]
			end
		end
	end
	setmetatable(peer, nil)
	return peer
end
function setmetatableindex_(t, index)
	if type(t) == "userdata" then
		local peer = xlua.getpeer(t)
		if not peer then
			peer = createPeer()
			xlua.setpeer(t, peer)
			local peerFun = t.SetLuaPeer
			if peerFun then
				peer.__ins = t
				peerFun(t, peer)
			end
		end
		local superPeer = peer.__superPeer
		if not superPeer then
			local nPeer = createPeer()
			superPeer = nPeer.__superPeer
			superPeer[1] = peer
			xlua.setpeer(t, nPeer)
		end
		superPeer[#superPeer + 1] = index
	else
		local mt = getmetatable(t)
		if not mt then
			mt, _ENV = t, t
		end
		if not mt.__index then
			mt.__index = index
			setmetatable(t, mt)
		elseif mt.__index ~= index then
			setmetatableindex_(mt, index)
		end
	end
end
setmetatableindex = setmetatableindex_
function class(classname, father1, father2, ...)
	_ENV = nil
	local (nil).__cname, cls = classname, nil
	local _UPVALUE2_, isDebugT = nil, classname == "loginView"
	;(nil)[1] = father1
	;(nil)[2] = father2
	;(nil)[3] = ...
	;(nil)[4] = ...
	;(nil)[5] = ...
	;(nil)[6] = ...
	;(nil)[7] = ...
	;(nil)[8] = ...
	;(nil)[9] = ...
	;(nil)[10] = ...
	;(nil)[11] = ...
	local (nil)[12], supers = ...
	for _, super in ipairs(supers) do
		local superType = type(super)
		assert(superType == "nil" or superType == "table" or superType == "function", string.format("class() - create class \"%s\" with invalid super class type \"%s\"", classname, superType))
		if superType == "function" then
			assert(cls.__create == nil, string.format("class() - create class \"%s\" with more than one creating function", classname))
			cls.__create = super
		elseif superType == "table" then
			if super.UnderlyingSystemType then
				assert(cls.__create == nil, string.format("class() - create class \"%s\" with more than one creating function or native class", classname))
				function cls.__create()
					return super()
				end
			else
				if not cls.__supers then
					_ENV = cls.__supers
				end
				cls.__supers = cls.__supers
				cls.__supers[#cls.__supers + 1] = super
				if not cls.super then
					cls.super = super
				end
			end
		else
			error(string.format("class() - create class \"%s\" with invalid super type", classname), 0)
		end
	end
	cls.__index = cls
	if not cls.__supers or #cls.__supers == 1 then
		_ENV = ipairs(supers)
		ipairs(supers).__index = cls.super
		setmetatable(cls, ipairs(supers))
	else
		_ENV = ipairs(supers)
		ipairs(supers).__index = function(_, key)
			local supers = cls.__supers
			for i = 1, #supers do
				local super = supers[i]
				if super[key] then
					return super[key]
				end
			end
		end
		setmetatable(cls, ipairs(supers))
	end
	if not cls.ctor then
		function cls.ctor()
		end
	end
	function cls.new(...)
		local instance
		if cls.__create then
			instance = cls.__create(...)
		else
			instance, cls = cls.__create(...), cls.__create(...)
		end
		setmetatableindex(instance, cls)
		instance.class = cls
		instance:ctor(...)
		return instance
	end
	function cls.create(_, ...)
		return cls.new(...)
	end
	return cls
end
function schedule(node, callback, delay)
	local delay = cc.DelayTime:create(delay)
	local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
	local action = cc.RepeatForever:create(sequence)
	node:runAction(action)
	return action
end
function performWithDelay(node, callback, delay)
	local delay = cc.DelayTime:create(delay)
	local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
	node:runAction(sequence)
	return sequence
end

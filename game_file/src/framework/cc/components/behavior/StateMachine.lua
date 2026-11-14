local Component = requireLocal("..Component")
local StateMachine = class("StateMachine", Component)
StateMachine.VERSION = "2.2.0"
StateMachine.SUCCEEDED = 1
StateMachine.NOTRANSITION = 2
StateMachine.CANCELLED = 3
StateMachine.PENDING = 4
StateMachine.FAILURE = 5
StateMachine.INVALID_TRANSITION_ERROR = "INVALID_TRANSITION_ERROR"
StateMachine.PENDING_TRANSITION_ERROR = "PENDING_TRANSITION_ERROR"
StateMachine.INVALID_CALLBACK_ERROR = "INVALID_CALLBACK_ERROR"
StateMachine.WILDCARD = "*"
StateMachine.ASYNC = "ASYNC"
function StateMachine:ctor()
	StateMachine.super.ctor(self, "StateMachine")
end
function StateMachine:setupState(cfg)
	assert(type(cfg) == "table", "StateMachine:ctor() - invalid config")
	if type(cfg.initial) == "string" then
		_ENV = type(cfg.initial)
		self.initial_, type(cfg.initial).state = type(cfg.initial), cfg.initial
	else
		self.initial_ = clone(cfg.initial)
	end
	self.terminal_ = cfg.terminal or cfg.final
	if not cfg.events then
		_ENV = cfg.events
	end
	self.events_ = cfg.events
	if not cfg.callbacks then
		_ENV = cfg.callbacks
	end
	self.map_, _ENV, self.callbacks_ = cfg.callbacks, cfg.callbacks, cfg.callbacks
	self.current_ = "none"
	self.inTransition_ = false
	if self.initial_ then
		self.initial_.event = self.initial_.event or "startup"
		_ENV = "StateMachine:ctor() - invalid config"
		;("StateMachine:ctor() - invalid config").name = self.initial_.event
		;("StateMachine:ctor() - invalid config").from = "none"
		;("StateMachine:ctor() - invalid config").to = self.initial_.state
		self:addEvent_("StateMachine:ctor() - invalid config")
	end
	for _, event in ipairs(self.events_) do
		self:addEvent_(event)
	end
	if self.initial_ and not self.initial_.defer then
		self:doEvent(self.initial_.event)
	end
	return self.target_
end
function StateMachine:isReady()
	return self.current_ ~= "none"
end
function StateMachine:getState()
	return self.current_
end
function StateMachine:isState(state)
	if type(state) == "table" then
		for _, s in ipairs(state) do
			if s == self.current_ then
				return true
			end
		end
		return false
	else
		return self.current_ == state
	end
end
function StateMachine:canDoEvent(eventName)
	return not self.inTransition_ and (self.map_[eventName][self.current_] ~= nil or self.map_[eventName][StateMachine.WILDCARD] ~= nil)
end
function StateMachine:cannotDoEvent(eventName)
	return not self:canDoEvent(eventName)
end
function StateMachine:isFinishedState()
	return self:isState(self.terminal_)
end
function StateMachine:doEventForce(name, ...)
	local from = self.current_
	local map = self.map_[name]
	local StateMachine, to = nil, map[from] or map[StateMachine.WILDCARD] or from
	StateMachine, (nil)[1] = ...
	StateMachine, (nil)[2] = ...
	StateMachine, (nil)[3] = ...
	local StateMachine, (nil)[4], args = ...
	....name = name
	....from = from
	....to = to
	local ....args, event = args, ...
	if self.inTransition_ then
		self.inTransition_ = false
	end
	self:beforeEvent_(event)
	if from == to then
		self:afterEvent_(event)
		return StateMachine.NOTRANSITION
	end
	self.current_ = to
	self:enterState_(event)
	self:changeState_(event)
	self:afterEvent_(event)
	return StateMachine.SUCCEEDED
end
function StateMachine:doEvent(name, ...)
	assert(self.map_[name] ~= nil, string.format("StateMachine:doEvent() - invalid event %s", tostring(name)))
	local from = self.current_
	local map = self.map_[name]
	local _ENV, to = string.format("StateMachine:doEvent() - invalid event %s", tostring(name))
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[1] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[2] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[3] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[4] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[5] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[6] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[7] = ...
	_ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[8] = ...
	local _ENV, string.format("StateMachine:doEvent() - invalid event %s", tostring(name))[9], args = ...
	....name = name
	....from = from
	....to = to
	local ....args, event = args, ...
	if self.inTransition_ then
		self:onError_(event, StateMachine.PENDING_TRANSITION_ERROR, "event " .. name .. " inappropriate because previous transition did not complete")
		return StateMachine.FAILURE
	end
	if self:cannotDoEvent(name) then
		self:onError_(event, StateMachine.INVALID_TRANSITION_ERROR, "event " .. name .. " inappropriate in current state " .. self.current_)
		return StateMachine.FAILURE
	end
	if self:beforeEvent_(event) == false then
		return StateMachine.CANCELLED
	end
	if from == to then
		self:afterEvent_(event)
		return StateMachine.NOTRANSITION
	end
	function event.transition()
		self.inTransition_ = false
		self.current_ = to
		self:enterState_(event)
		self:changeState_(event)
		self:afterEvent_(event)
		return StateMachine.SUCCEEDED
	end
	function event.cancel()
		event.transition = nil
		self:afterEvent_(event)
	end
	self.inTransition_ = true
	local leave = self:leaveState_(event)
	if leave == false then
		event.transition = nil
		event.cancel = nil
		self.inTransition_ = false
		return StateMachine.CANCELLED
	elseif string.upper(tostring(leave)) == StateMachine.ASYNC then
		return StateMachine.PENDING
	elseif event.transition then
		return event.transition()
	else
		self.inTransition_ = false
	end
end
function StateMachine:exportMethods()
	_UPVALUE9_ = nil
	;(nil)[1] = "setupState"
	;(nil)[2] = "isReady"
	;(nil)[3] = "getState"
	;(nil)[4] = "isState"
	;(nil)[5] = "canDoEvent"
	;(nil)[6] = "cannotDoEvent"
	;(nil)[7] = "isFinishedState"
	;(nil)[8] = "doEventForce"
	;(nil)[9] = "doEvent"
	self:exportMethods_(nil)
	return self.target_
end
function StateMachine:onBind_()
end
function StateMachine:onUnbind_()
end
function StateMachine:addEvent_(event)
	local _ENV, from
	if type(event.from) == "table" then
		for _, name in ipairs(event.from) do
			from[name] = true
		end
	elseif event.from then
		from[event.from] = true
	else
		from[StateMachine.WILDCARD] = true
	end
	if not self.map_[event.name] then
		_ENV = self.map_[event.name]
	end
	self.map_[event.name] = self.map_[event.name]
	local map = self.map_[event.name]
	for fromName, _ in pairs(from) do
		map[fromName] = event.to or fromName
	end
end
local doCallback_ = function(callback, event)
	if callback then
		return callback(event)
	end
end
function StateMachine:beforeAnyEvent_(event)
	return doCallback_(self.callbacks_.onbeforeevent, event)
end
function StateMachine:afterAnyEvent_(event)
	return doCallback_(self.callbacks_.onafterevent or self.callbacks_.onevent, event)
end
function StateMachine:leaveAnyState_(event)
	return doCallback_(self.callbacks_.onleavestate, event)
end
function StateMachine:enterAnyState_(event)
	return doCallback_(self.callbacks_.onenterstate or self.callbacks_.onstate, event)
end
function StateMachine:changeState_(event)
	return doCallback_(self.callbacks_.onchangestate, event)
end
function StateMachine:beforeThisEvent_(event)
	return doCallback_(self.callbacks_["onbefore" .. event.name], event)
end
function StateMachine:afterThisEvent_(event)
	return doCallback_(self.callbacks_["onafter" .. event.name] or self.callbacks_["on" .. event.name], event)
end
function StateMachine:leaveThisState_(event)
	return doCallback_(self.callbacks_["onleave" .. event.from], event)
end
function StateMachine:enterThisState_(event)
	return doCallback_(self.callbacks_["onenter" .. event.to] or self.callbacks_["on" .. event.to], event)
end
function StateMachine:beforeEvent_(event)
	if self:beforeThisEvent_(event) == false or self:beforeAnyEvent_(event) == false then
		return false
	end
end
function StateMachine:afterEvent_(event)
	self:afterThisEvent_(event)
	self:afterAnyEvent_(event)
end
function StateMachine:leaveState_(event, transition)
	local specific = self:leaveThisState_(event, transition)
	local general = self:leaveAnyState_(event, transition)
	if specific == false or general == false then
		return false
	elseif string.upper(tostring(specific)) == StateMachine.ASYNC or string.upper(tostring(general)) == StateMachine.ASYNC then
		return StateMachine.ASYNC
	end
end
function StateMachine:enterState_(event)
	self:enterThisState_(event)
	self:enterAnyState_(event)
end
function StateMachine:onError_(event, error, message)
	printf("%s [StateMachine] ERROR: error %s, event %s, from %s to %s", tostring(self.target_), tostring(error), event.name, event.from, event.to)
	printError(message)
end
return StateMachine

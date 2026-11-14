local gameFlow = class("gameFlow")
local cocosContext = require("app.common.tabMachine.cocosContext")
local tabDebugger = require("app.common.tabMachine.tabDebugger")
local gameFlowContext = class("gameFlowContext", cocosContext)
function gameFlow:ctor()
	self._tabMachine = require("app.common.tabMachine.cocosTabMachine").new()
end
function gameFlow:getObject(path)
	if path == nil then
		return self._tabMachine:getObject("")
	end
	return self._tabMachine:getObject(path)
end
function gameFlow:start()
	self._tabMachine:installTab(gameFlowContext)
	self._tabMachine:start(gameFlow)
end
function gameFlow:reset()
	self._tabMachine:stop()
	self:start()
end
function gameFlow:getRootContext()
	return self._tabMachine and self._tabMachine._rootContext
end
function gameFlowContext:s1()
	self._G = _G
	self:call(self:tabStage(), "stage")
	self._stage = self:getSub("stage")
	self:call(require("app.game.gameFlow.resMgr"), "resMgr")
	self._resMgr = self:getSub("resMgr")
end
function gameFlowContext:tabStage()
	_ENV = nil
	;(nil).s1 = g_t.empty_fun
	;(nil).event = g_t.empty_event
	return nil
end
function gameFlowContext:callTabOnStage(tab, name, needStop)
	if name == nil then
		name = "stage_animation"
	end
	if needStop then
		self._stage:stop(name)
	end
	self._stage:call(tab, name)
end
gameFlowContext.event = g_t.empty_event
return gameFlow

local worldMapCom = class("worldMapCom", cc.Component)
function worldMapCom:ctor(name, depends)
	local _ENV, dependsFix
	if depends then
		for _, v in ipairs(depends) do
			local com = getfullname(v)
			if com then
				table.insert(dependsFix, com)
			end
		end
	end
	worldMapCom.super.ctor(self, name, dependsFix)
end
function worldMapCom:onMessageListener()
end
function worldMapCom:onEnter()
end
function worldMapCom:onExit()
	SoraDRemoveMessageByTarget(self)
end
function worldMapCom:init()
	self:resetData()
end
function worldMapCom:relogin()
end
function worldMapCom:doReqestData()
end
function worldMapCom:doClearData()
	self:cleanData()
	self:resetData()
end
function worldMapCom:resetData()
end
function worldMapCom:cleanData()
end
function worldMapCom:exportMethods()
end
function worldMapCom:callTargetFuncArgs(name, ...)
	local target = self.target_
	local fun = target[name]
	if fun then
		fun(target, ...)
	end
end
function worldMapCom:addEventListener(eventName, listener, tag)
	self:callTargetFuncArgs("addEventListener", eventName, listener, tag)
end
function worldMapCom:dispatchEvent(event)
	self:callTargetFuncArgs("dispatchEvent", event)
end
function worldMapCom:removeEventListener(handleToRemove)
	self:callTargetFuncArgs("removeEventListener", handleToRemove)
end
function worldMapCom:removeEventListenersByEvent(eventName)
	self:callTargetFuncArgs("removeEventListenersByEvent", eventName)
end
return worldMapCom

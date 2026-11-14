local GameModule = class("GameModule", cc.mvc.ModelBase)
GameModule.schema = clone(cc.mvc.ModelBase.schema)
_UPVALUE1_ = cc.mvc.ModelBase.schema
GameModule.schema.isDataReady, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "boolean"
function GameModule:ctor(properties)
	GameModule.super.ctor(self, properties)
	self:addComponents()
end
function GameModule:autoRegister(cmdModule, cmdList)
	local msgCtrl = include("msgCtrl")
	for k, v in pairs(cmdList) do
		local tmp = string.lower(k)
		local nameTable = SoraDStringSplit(tmp, "_")
		local eventName = "send"
		for _, str in ipairs(nameTable) do
			eventName = eventName .. string.ucfirst(str)
		end
		print(eventName)
		if self[eventName] then
			msgCtrl.register(cmdModule, gCmd[k], handler(self, self[eventName]))
		end
	end
end
function GameModule:EnterGame()
end
function GameModule:Logout()
	self:removeAllEventListeners()
end
function GameModule:addComponents()
end
function GameModule:addCustomComponent(componentName)
	return self:addComponent(getfullname(componentName), componentName):exportMethods()
end
function GameModule:getCustomCompnent(componentName)
	return self:getComponent(getfullname(componentName))
end
return GameModule

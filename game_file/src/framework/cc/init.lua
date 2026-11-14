local CURRENT_MODULE_NAME = (...)
cc.Registry = requireLocal(".Registry")
cc.GameObject = requireLocal(".GameObject")
cc.EventProxy = requireLocal(".EventProxy")
_UPVALUE5_, cc.Component = cc, requireLocal(".components.Component")
cc[1] = "components.behavior.StateMachine"
cc[2] = "components.behavior.EventProtocol"
cc[3] = "components.ui.BasicLayoutProtocol"
cc[4] = "components.ui.LayoutProtocol"
local cc[5], components = "components.ui.DraggableProtocol", cc
for _, packageName in ipairs(components) do
	cc.Registry.add(requireLocal("." .. packageName, CURRENT_MODULE_NAME), packageName)
end
local GameObject = cc.GameObject
local ccmt = clone(getmetatable(cc))
function ccmt:__call(target)
	if target then
		return GameObject.extend(target)
	end
	printError("cc() - invalid target")
end
setmetatable(cc, ccmt)
cc.mvc = requireLocal(".mvc.init")
cc.ui = requireLocal(".ui.init")
cc.uiloader = requireLocal(".uiloader.init")

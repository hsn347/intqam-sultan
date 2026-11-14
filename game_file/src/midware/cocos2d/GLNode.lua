local GLNode = class("GLNode", cc.Node)
function GLNode:create()
	local glnode = GLNode.new()
	glnode:autoRelease()
	return glnode
end
function GLNode:getDesciption()
	return "GLNode"
end
function GLNode:registerScriptDrawHandler(callback)
	print_warn("GLNode:registerScriptDrawHandler")
end
return GLNode

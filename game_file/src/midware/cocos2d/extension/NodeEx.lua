local Node = cc.Node
function Node:create()
	return Node.CreateNode()
end
function Node:getDesciption()
	return "Node"
end
return Node

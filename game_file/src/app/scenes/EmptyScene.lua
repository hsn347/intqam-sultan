local EmptyScene = class("EmptyScene", function()
	return display.newPhysicsScene("EmptyScene")
end)
function EmptyScene:ctor()
	print("empty scene ctor ")
end
function EmptyScene:onEnter()
	print("empty scene  enter ")
end
function EmptyScene:onExit()
	print("empty scene  exit ")
end
return EmptyScene

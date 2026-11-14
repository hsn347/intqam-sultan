local rechargePresentActivity = class("rechargePresentActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargePresentActivity")
	end
	return target
end)
function rechargePresentActivity:ctor()
	self.isHideCurrentSceneView = true
end
function rechargePresentActivity:onMessageListener()
end
return rechargePresentActivity

local unityEditorTestView = class("unityEditorTestView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("unityEditorTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function unityEditorTestView:ctor()
	self.isHideCurrentSceneView = true
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_cheatview")
end
return unityEditorTestView

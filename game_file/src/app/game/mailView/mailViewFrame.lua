local mailViewFrame = class("mailViewFrame", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailViewFrame"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailViewFrame:ctor()
	self.topFrame = SoraDGetChildByName(self, "Top_Frame")
	self.frameL = SoraDGetChildByName(self, "Top_Size_Frame_L")
	self.frameR = SoraDGetChildByName(self, "Top_Size_Frame_R")
end
return mailViewFrame

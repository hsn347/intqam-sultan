local nodeBg = class("nodeBg", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeBg")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeBg:ctor()
	self:createUI()
	self.Size_Tile_bg_pinpu = SoraDGetChildByName(self, "Size_Tile_bg_pinpu")
	self.Size_frame_sheer_items_L = SoraDGetChildByName(self, "Size_frame_sheer_items_L")
	self.Size_frame_sheer_items_R = SoraDGetChildByName(self, "Size_frame_sheer_items_R")
	self.Size_Tile_bg_pinpu:setFillType(1)
end
function nodeBg:createUI()
end
function nodeBg:init(data)
end
function nodeBg:onMessageListener()
end
return nodeBg

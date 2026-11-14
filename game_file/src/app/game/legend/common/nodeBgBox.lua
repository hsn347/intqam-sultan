local nodeBgBox = class("nodeBgBox", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeBgBox")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeBgBox:ctor()
	self:createUI()
	self.node_Tile = SoraDGetChildByName(self, "node_Tile")
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.glow_grey_frame = SoraDGetChildByName(self, "glow_grey_frame")
	self.Sprite_top_bg_R = SoraDGetChildByName(self, "Sprite_top_bg_R")
	self.Sprite_top_bg_L = SoraDGetChildByName(self, "Sprite_top_bg_L")
	self.Image_Bg_R = SoraDGetChildByName(self, "Image_Bg_R")
	self.Image_Bg_L = SoraDGetChildByName(self, "Image_Bg_L")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
end
function nodeBgBox:createUI()
end
function nodeBgBox:init(data)
end
function nodeBgBox:setTitle(strTitle)
	self.Text_title:setString(strTitle)
end
function nodeBgBox:onMessageListener()
end
return nodeBgBox

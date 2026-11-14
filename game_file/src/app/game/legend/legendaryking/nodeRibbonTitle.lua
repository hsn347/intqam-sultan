local NodeRibbonTitle = class("NodeRibbonTitle", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("NodeRibbonTitle")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function NodeRibbonTitle:ctor()
	self:createUI()
	self.frame_lord = SoraDGetChildByName(self, "frame_lord")
	self.frame_sheer_items_title = SoraDGetChildByName(self, "frame_sheer_items_title")
	self.frame_LegendaryKing_red_02_2 = SoraDGetChildByName(self, "frame_LegendaryKing_red_02_2")
	self.frame_LegendaryKing_red_02_3 = SoraDGetChildByName(self, "frame_LegendaryKing_red_02_3")
	self.Image_LegendaryKing_zhuzi_R = SoraDGetChildByName(self, "Image_LegendaryKing_zhuzi_R")
	self.frame_throne_contend_01_4 = SoraDGetChildByName(self, "frame_throne_contend_01_4")
	self.frame_throne_contend_01_5 = SoraDGetChildByName(self, "frame_throne_contend_01_5")
	self.frame_LegendaryKing_red_01_6 = SoraDGetChildByName(self, "frame_LegendaryKing_red_01_6")
	self.frame_LegendaryKing_red_01_7 = SoraDGetChildByName(self, "frame_LegendaryKing_red_01_7")
	self.Image_LegendaryKing_zhuzi_L = SoraDGetChildByName(self, "Image_LegendaryKing_zhuzi_L")
end
function NodeRibbonTitle:createUI()
end
function NodeRibbonTitle:init(data)
end
function NodeRibbonTitle:onMessageListener()
end
return NodeRibbonTitle

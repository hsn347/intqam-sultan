local node_attacked_effect = class("node_attacked_effect", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("node_attacked_effect")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function node_attacked_effect:ctor()
	self:createUI()
	self.shouji = SoraDGetChildByName(self, "shouji")
	self.sp1 = SoraDGetChildByName(self, "Sprite_1")
	self.dhGongjian022 = SoraDGetChildByName(self, "dh_gongjian_02_2")
	self.sp10 = SoraDGetChildByName(self, "Sprite_1_0")
	self.dhGongjian034 = SoraDGetChildByName(self, "dh_gongjian_03_4")
	self.dhGongjian0340 = SoraDGetChildByName(self, "dh_gongjian_03_4_0")
	self.dhGongjian037 = SoraDGetChildByName(self, "dh_gongjian_03_7")
	self.dhGongjian038 = SoraDGetChildByName(self, "dh_gongjian_03_8")
	self.dhGongjian0380 = SoraDGetChildByName(self, "dh_gongjian_03_8_0")
	self.dhGongjian0310 = SoraDGetChildByName(self, "dh_gongjian_03_10")
end
function node_attacked_effect:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function node_attacked_effect:init(data)
end
function node_attacked_effect:onMessageListener()
end
return node_attacked_effect

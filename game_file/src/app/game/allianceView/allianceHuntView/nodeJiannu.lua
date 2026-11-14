local nodeJiannu = class("nodeJiannu", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeJiannu")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeJiannu:ctor()
	self:createUI()
	self.dh_nushi_light = SoraDGetChildByName(self, "dh_nushi_light")
	self.nushi = SoraDGetChildByName(self, "nushi")
	self.nushiP1 = SoraDGetChildByName(self, "nushi_p1")
	self.nushiP2 = SoraDGetChildByName(self, "nushi_p2")
end
function nodeJiannu:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeJiannu:init(data)
	self.powerMode = data.powerMode
end
function nodeJiannu:getPowerMode()
	return self.powerMode
end
function nodeJiannu:setPowerMode(powerMode)
	self.powerMode = powerMode
end
function nodeJiannu:onMessageListener()
end
function nodeJiannu:setPowerVisible(isVisible)
	self.nushiP1:setVisible(isVisible)
	self.nushiP2:setVisible(isVisible)
	self.dh_nushi_light:setVisible(isVisible)
end
return nodeJiannu

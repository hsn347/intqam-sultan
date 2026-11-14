local loudlyDressedCtrl = SoraDGetCtrl("loudlyDressedCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_dress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ThemTake/Com_dress", Com_dress)
function Com_dress:onInit()
	self.fields.n10:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	self.fields.n10:setVisible(false)
end
function Com_dress:onShow()
end
function Com_dress:initData(index, isFromMsg)
	self.fields.icon_grayed:setSpriteFrame(string.format("frame_LoudlyDressed_bujian%.2d.png", index))
	self.fields.icon_normal:setSpriteFrame(string.format("frame_LoudlyDressed_bujian%.2d.png", index))
	self.fields.icon_grayed:setGrayed(true)
	self.fields.icon_normal:setGrayed(false)
	local rCount = loudlyDressedCtrl:getRechargeRecordCount()
	local isGot = index <= rCount
	if isFromMsg and isGot then
		self:playUnlockAct()
	else
		self.fields.n6:setAlpha(isGot and 1 or 0)
		self.fields.icon_normal:setAlpha(isGot and 1 or 0)
		self.fields.n11:setAlpha(isGot and 0 or 1)
		self.fields.icon_grayed:setAlpha(isGot and 0 or 0.7)
		self.fields.n9:setAlpha(isGot and 0 or 1)
	end
end
function Com_dress:playUnlockAct()
	self.transitions.t0:play()
	self.fields.n10:setVisible(true)
	self.fields.n10:setPlaySettings(0, -1, 1, -1, function()
		self.fields.n10:setVisible(false)
	end)
end
return Com_dress

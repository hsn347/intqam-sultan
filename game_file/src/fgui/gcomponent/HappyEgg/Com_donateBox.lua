local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_donateBox = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HappyEgg/Com_donateBox", Com_donateBox)
function Com_donateBox:onInit()
	self:addClickListener(handler(self, self.onClickItemm))
end
function Com_donateBox:onShow()
end
_UPVALUE8_, Com_donateBox.initData = function(self)
end, function(self)
end
;(function(self)
end)[1] = 1
;(function(self)
end)[2] = 2
;(function(self)
end)[3] = 3
;(function(self)
end)[4] = 4
;(function(self)
end)[5] = 7
;(function(self)
end)[6] = 8
;(function(self)
end)[7] = 8
local (function(self)
end)[8], index2PngIndex = 8, function(self)
end
function Com_donateBox:initData(data, index)
	self.data = data
	self.status = happyEggCtrl:getStageStatus(data.stage, data.num)
	print("self.status", self.status)
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self.fields.title:setString(string.formatnumberthousands(data.num))
	self.fields.icon:setURL(string.format("icon_KingGroupbuy_lv%d_small%s.png", index2PngIndex[index] or 8, 5 <= index and "_new" or ""))
end
function Com_donateBox:onClickItemm()
	SoraDPlaySound()
	uiManager:show("HappyEggStageReward", self.data)
end
return Com_donateBox

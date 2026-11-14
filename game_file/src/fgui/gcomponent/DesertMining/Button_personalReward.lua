local DesertMiningCtrl = SoraDGetCtrl("DesertMiningCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_personalReward = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://DesertMining/Button_personalReward", Button_personalReward)
function Button_personalReward:onInit()
	self:addClickListener(handler(self, self.onClickItemm))
end
_UPVALUE8_, Button_personalReward.onShow = function(self)
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
function Button_personalReward:initData(data, index)
	self.data = data
	dump(self.data, "stageConfig")
	self.status = DesertMiningCtrl:getStageStatus(data.stage, data.num)
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self.fields.title:setString(string.formatnumberthousands(data.num))
	self.fields.icon:setURL(string.format("icon_KingGroupbuy_lv%d_small%s.png", index2PngIndex[index] or 8, 5 <= index and "_new" or ""))
end
function Button_personalReward:onClickItemm()
	SoraDPlaySound()
	uiManager:show("DesertMiningStageReward", self.data)
end
return Button_personalReward

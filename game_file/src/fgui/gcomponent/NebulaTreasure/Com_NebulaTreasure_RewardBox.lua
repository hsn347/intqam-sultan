local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTreasure_RewardBox = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaTreasure/Com_NebulaTreasure_RewardBox", Com_NebulaTreasure_RewardBox)
function Com_NebulaTreasure_RewardBox:onInit()
	self.fields.btn:addClickEventListener(handler(self, self.onClick))
	self.fields.shine:setAllFrameName("dh_xingyunbxklq_%02d.png", 1)
	self.fields.shine:setPlaySettings(0, -1, -1)
end
function Com_NebulaTreasure_RewardBox:onShow()
end
function Com_NebulaTreasure_RewardBox:initData(cfg, isOpen, isGot)
	self.cfg = cfg
	self.isOpen = isOpen
	self.isGot = isGot
	self.controllers.c1:setSelectedIndex(self.isGot and 1 or isOpen and 0 or 2)
	self.fields.box_txt:setString(cfg.rate)
end
function Com_NebulaTreasure_RewardBox:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).cfg = self.cfg
	;(nil).isOpen = self.isOpen
	;(nil).isGot = self.isGot
	uiManager:show("NebulaTreasureAward", nil)
end
return Com_NebulaTreasure_RewardBox

local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_RankProxy = class("RoaringFlame_RankProxy", baseProxy)
function RoaringFlame_RankProxy:onRegisterEvent()
	print("=======RoaringFlame_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_RANKLIST", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_UI_RANKSELECT", handler(self, self.selectBack))
end
function RoaringFlame_RankProxy:initView(target, data)
	self.view:initView(target, data)
end
function RoaringFlame_RankProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
return RoaringFlame_RankProxy

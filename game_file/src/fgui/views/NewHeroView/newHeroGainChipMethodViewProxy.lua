local baseProxy = require("fgui.base.baseProxy")
local newHeroGainChipMethodViewProxy = class("newHeroGainChipMethodViewProxy", baseProxy)
function newHeroGainChipMethodViewProxy:onRegisterEvent()
	print("=======newHeroGainChipMethodViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_EXIT_STAGE", handler(self, self.showTip))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
end
function newHeroGainChipMethodViewProxy:showTip(target, data)
	SoraDShowMsgTip(i18n("hero_text_46"))
end
function newHeroGainChipMethodViewProxy:recevieItemChangeMsg(target, data)
	if data and data.itemType and gItemType.HERO_CHIP == data.itemType then
		self.view:initView()
	end
end
return newHeroGainChipMethodViewProxy

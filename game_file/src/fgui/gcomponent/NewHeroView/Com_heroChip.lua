local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroChip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroChip", Com_heroChip)
function Com_heroChip:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_heroChip:onShow()
end
function Com_heroChip:initData(itemID, needCount, heroID, isDress)
	self.itemID = itemID
	self.needCount = needCount
	self.heroID = heroID
	self.isDress = isDress
	self.fields.Sprite_chip:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.fields.Sprite_headBg:setSpriteFrame(publicRead.getBg(self.itemID))
end
function Com_heroChip:onClick()
	SoraDPlaySound()
	if not self.isDress then
		_ENV = nil
		;(nil).itemID = self.itemID
		;(nil).needCount = self.needCount
		;(nil).heroID = self.heroID
		uiManager:show("newHeroGainChipView", nil)
	end
end
return Com_heroChip

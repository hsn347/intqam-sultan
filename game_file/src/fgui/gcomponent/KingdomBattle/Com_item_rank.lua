local baseComponent = require("fgui.base.baseComponent")
local Com_item_rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_item_rank", Com_item_rank)
function Com_item_rank:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_item_rank:onShow()
end
function Com_item_rank:initData(data)
	self.enum = data
	local config = RANK_TITLE_CONFIG[self.enum]
	self.fields.title:setString(i18n(config.title))
	self.fields.icon:setSpriteFrame(config.img)
end
function Com_item_rank:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = self.enum
	;(nil).isKingdomBattle = true
	uiManager:show("rankingsScrollView", nil)
end
return Com_item_rank

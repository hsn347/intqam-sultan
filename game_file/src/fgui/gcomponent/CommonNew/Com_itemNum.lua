local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_itemNum", Com_itemNum)
function Com_itemNum:onInit()
	self:fixChildrenPos()
	self.fields.btnAdd:addClickListener(handler(self, self.onClickAdd))
	self:setString(i18n("sheepFeed_text_10"))
end
function Com_itemNum:updateItemCount()
	self.fields.textNum:setString(string.formatnumberthousands(publicUtil.getCount(self.itemID)))
end
function Com_itemNum:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemCount))
end
function Com_itemNum:initData(itemID, handler)
	self.itemID = itemID
	self.addBtnHandler = handler
	self:updateItemCount()
	self.fields.icon:setURL(include("publicRead").getIcon(self.itemID))
end
function Com_itemNum:onClickAdd()
	SoraDPlaySound()
	if self.addBtnHandler then
		self.addBtnHandler(self.itemID)
		return
	end
	local sources = include("itemDesRead").getOutput(self.itemID)
	_ENV = nil
	;(nil).sources = sources
	uiManager:show("CommonSourceGuide", nil)
end
return Com_itemNum

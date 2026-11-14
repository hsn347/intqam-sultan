local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local shopItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://bagView/shopItem", shopItem)
function shopItem:onInit()
	self.fields.spriteHot:setVisible(false)
	self.fields.spriteNew:setVisible(false)
	self:addLongPressListener(handler(self, self.onLongPress))
	self.fields.spriteHot:fixPos()
	self.fields.spriteNew:fixPos()
end
function shopItem:onShow()
end
function shopItem:initData(data, isDiscount)
	self.id = data.itemId or data.id
	self.controllers.c1:setSelectedIndex(isDiscount and 1 or 0)
	self.fields.imgBg:setSpriteFrame(publicRead.getBg(self.id))
	self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.id))
	local isNew = shopltCtrl:isNew(data.shopItemID)
	self.fields.spriteNew:setVisible(isNew or false)
	self.fields.spriteHot:setVisible(data.hot and not isNew)
	if isDiscount and data.cur and data.max then
		publicRead = publicRead.getIcon(self.id)
		publicRead.getIcon(self.id).member = data.cur
		publicRead.getIcon(self.id).total = data.max
		self.fields.Text_limit:setString(i18n("common_text_155", publicRead.getIcon(self.id)))
	end
end
function shopItem:onLongPress(button, startPos, endPos)
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.id
	;(nil).pos = startPos
	SoraDSendMessage(nil)
end
return shopItem

local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local ExchangeItemOwnNew = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ExchangeItemOwnNew", ExchangeItemOwnNew)
function ExchangeItemOwnNew:onInit()
	self:fixChildrenPos()
	self:addClickEventListener(handler(self, self.onClick))
end
function ExchangeItemOwnNew:initData(itemId, scale, type)
	dump(data, "ExchangeItemOwn")
	self.itemId = itemId
	if scale then
		self:setScale(scale)
	end
	local count = backpackCtrl:getItemCount(itemId)
	self.fields.icon:setURL(publicRead.getIcon(itemId))
	if type == 1 then
		_ENV = publicRead.getIcon(itemId)
		publicRead.getIcon(itemId).count = count
		self.fields.text:setString(i18n("common_text_1377", publicRead.getIcon(itemId)))
	else
		self.fields.text:setString(count)
	end
end
function ExchangeItemOwnNew:posToCenter(offset)
	self.fields.text:setPositionX(offset + self.fields.text:getPositionX())
	self.fields.icon:setPositionX(offset + self.fields.icon:getPositionX())
end
function ExchangeItemOwnNew:onShow()
end
function ExchangeItemOwnNew:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemId
	uiManager:show("CommonSourceGuide", nil)
end
return ExchangeItemOwn

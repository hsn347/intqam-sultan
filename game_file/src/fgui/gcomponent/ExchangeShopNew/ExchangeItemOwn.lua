local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local publicRead = include("publicRead")
local ExchangeItemOwn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ExchangeItemOwn", ExchangeItemOwn)
fgui.register_extension("ui://ExchangeShopNew/ExchangeItemOwnFix", ExchangeItemOwn)
local publicUtil = include("publicUtil")
function ExchangeItemOwn:onInit()
	self:fixChildrenPos()
end
function ExchangeItemOwn:initData(itemId, scale, type)
	if scale then
		self:setScale(scale)
	end
	local count = publicUtil.getCount(itemId)
	self.fields.icon:setURL(publicRead.getIcon(itemId))
	if type == 1 then
		publicUtil = publicRead.getIcon(itemId)
		publicRead.getIcon(itemId).count = count
		self.fields.text:setString(i18n("common_text_1377", publicRead.getIcon(itemId)))
	else
		self.fields.text:setString(count)
	end
end
function ExchangeItemOwn:posToCenter(offset)
	self.fields.text:setPositionX(offset + self.fields.text:getPositionX())
	self.fields.icon:setPositionX(offset + self.fields.icon:getPositionX())
end
function ExchangeItemOwn:onShow()
end
return ExchangeItemOwn

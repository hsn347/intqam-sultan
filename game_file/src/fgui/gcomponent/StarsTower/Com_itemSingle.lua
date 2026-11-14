local publicRead = include("publicRead")
local starlightPavilionCtrl = SoraDGetCtrl("starlightPavilionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarsTower/Com_itemSingle", Com_itemSingle)
function Com_itemSingle:onInit()
	self.fields.n0:fixPos()
	self.fields.item:fixPos()
	self.fields.Lab_dis:fixPos()
	self.fields.Text_limit:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Btn_buy:fixPos()
end
function Com_itemSingle:onShow()
end
function Com_itemSingle:initData(data)
	self.fields.item:initData(data.itemID, data.num > 1 and data.num or 0)
	_ENV = nil
	;(nil).discount = data.discount
	self.fields.Lab_dis:setString(i18n("%{discount}%", nil))
	self.fields.Text_des:setString(publicRead.getName(data.itemID))
	local boughtNum = starlightPavilionCtrl:getExchangeCount(data.index)
	local leftNum = data.limitNum - boughtNum
	_ENV = publicRead.getName(data.itemID)
	publicRead.getName(data.itemID).var1 = fguiHelper.getColorString(0 < leftNum and "#FFFFFF" or "#FF0000", leftNum)
	publicRead.getName(data.itemID).var2 = data.limitNum
	self.fields.Text_limit:setString(i18n("%{var1}/%{var2}", publicRead.getName(data.itemID)))
	self.fields.Btn_buy:setBright(0 < leftNum)
	self.fields.Btn_buy:initData(data)
end
return Com_itemSingle

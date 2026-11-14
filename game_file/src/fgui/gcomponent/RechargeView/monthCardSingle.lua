local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local monthCardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/monthCardSingle", monthCardSingle)
function monthCardSingle:onInit()
	self:fixChildrenPos()
end
function monthCardSingle:onShow()
end
function monthCardSingle:initData(data)
	self.id = data.id
	local itemInfo = rechargeRead.getBuffMonthInfoByID(self.id)
	self.fields.Image_buffMonthSingleItemIcon:setSpriteFrame(itemInfo.pictureName)
	self.fields.Text_buffMonthSingleTitle:setString(i18n(itemInfo.rewardName))
	self.fields.Text_buffMonthSingleDes:setString(itemInfo.rewardBonus)
end
return monthCardSingle

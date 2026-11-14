local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local takeBuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/takeBuffSingle", takeBuffSingle)
function takeBuffSingle:onInit()
end
function takeBuffSingle:onShow()
end
function takeBuffSingle:initData(data)
	local itemInfo = rechargeRead.getBuffMonthInfoByID(data.id)
	self.fields.icon:setSpriteFrame(itemInfo.pictureName)
	self.fields.Text_title:setString(i18n(itemInfo.rewardName))
	self.fields.Text_des:setString(itemInfo.rewardBonus)
end
return takeBuffSingle

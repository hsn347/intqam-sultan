local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local monthCardSingle = class("monthCardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("monthCardSingle")
	end
	return target
end)
function monthCardSingle:ctor()
	self.Text_buffMonthSingleTitle = SoraDGetChildByName(self, "Text_buffMonthSingleTitle")
	self.Text_buffMonthSingleDes = SoraDGetChildByName(self, "Text_buffMonthSingleDes")
	self.Image_buffMonthSingleItemIcon = SoraDGetChildByName(self, "Image_buffMonthSingleItemIcon")
end
function monthCardSingle:initData(data)
	self.id = data.id
	local itemInfo = rechargeRead.getBuffMonthInfoByID(self.id)
	self.Image_buffMonthSingleItemIcon:loadTexture(itemInfo.pictureName, ccui.TextureResType.plistType)
	self.Text_buffMonthSingleTitle:setString(i18n(itemInfo.rewardName))
	self.Text_buffMonthSingleDes:setString(itemInfo.rewardBonus)
end
return monthCardSingle

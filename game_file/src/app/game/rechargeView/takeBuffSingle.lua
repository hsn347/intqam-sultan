local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local takeBuffSingle = class("takeBuffSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("takeBuffSingle")
	end
	return target
end)
function takeBuffSingle:ctor()
	self.singleItemIcon = SoraDGetChildByName(self, "Image_singleItemIcon")
	self.singleDes = SoraDGetChildByName(self, "Text_singleDes")
	self.singleTitle = SoraDGetChildByName(self, "Text_singleTitle")
end
function takeBuffSingle:initData(data)
	local itemInfo = rechargeRead.getBuffMonthInfoByID(data.id)
	self.singleItemIcon:loadTexture(itemInfo.pictureName, ccui.TextureResType.plistType)
	self.singleTitle:setString(i18n(itemInfo.rewardName))
	self.singleDes:setString(itemInfo.rewardBonus)
end
return takeBuffSingle

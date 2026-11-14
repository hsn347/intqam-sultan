local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
_ENV, _ENV = nil, "rechargeRead"
_ENV, ("rechargeRead")[7210278], (nil).des = nil, nil, "rechargeGift_text_04"
;("rechargeRead")[7210279], (nil).des = nil, "rechargeGift_text_05"
local giftDescribe = "rechargeRead"
local baseComponent = require("fgui.base.baseComponent")
local Com_vipGiftSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_vipGiftSingle", Com_vipGiftSingle)
function Com_vipGiftSingle:onInit()
	self.fields.item:fixPos()
	self.fields.Text_ItemName:fixPos()
	self.fields.Text_num:fixPos()
end
function Com_vipGiftSingle:onShow()
end
function Com_vipGiftSingle:initData(data)
	local rewardList = rechargeActivityCtrl:getRechargeGift(data.rechargeID)
	self.fields.item:initData(rewardList[1].id)
	self.fields.Text_ItemName:setString(i18n(publicRead.getName(rewardList[1].id)))
	self.fields.Text_num:setString("x" .. string.formatnumberthousands(rewardList[1].count))
	if giftDescribe[data.rechargeID] then
		self.fields.Text_Title:setString(i18n(giftDescribe[data.rechargeID].des))
	elseif data.price then
		rechargeActivityCtrl = i18n(giftDescribe[data.rechargeID].des)
		i18n(giftDescribe[data.rechargeID].des).price = data.price
		self.fields.Text_Title:setString(i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des)))
	else
		local rechargeInfo = rechargeRead.getPageViewData(data.rechargeID)
		rechargeActivityCtrl = i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des))
		i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des)).giftName = i18n(rechargeInfo.activeName)
		self.fields.Text_Title:setString(i18n("rechargeGift_text_03", i18n("rechargeGift_text_06", i18n(giftDescribe[data.rechargeID].des))))
	end
end
return Com_vipGiftSingle

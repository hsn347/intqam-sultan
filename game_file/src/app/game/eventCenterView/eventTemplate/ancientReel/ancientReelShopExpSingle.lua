local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelShopExpSingle = class("ancientReelShopExpSingle", function(target)
	local commonTaskSingle = include("royalSummonsShopExpSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function ancientReelShopExpSingle:ctor()
end
function ancientReelShopExpSingle:initData(data)
	self.data = data
	local itemdata = self.data.itemdata
	local exp = itemdata.exp
	self.commonItemNode:initData(gIDType.ANCIENT_REEL_LV_EXP_POINT, exp)
	self.Button_buy:setGoldText(string.formatnumberthousands(itemdata.coin[2]))
	local expStr = string.formatnumberthousands(exp)
	_ENV = string.formatnumberthousands(itemdata.coin[2])
	string.formatnumberthousands(itemdata.coin[2]).num = expStr
	self.textDes:setString(i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2])))
	local lv = ancientReelCtrl:getLevelAddExp(exp)
	local awardCur = ancientReelCtrl:getAwardNum()
	local awardAdd = ancientReelCtrl:getAwardNum(nil, lv)
	_ENV = i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2]))
	i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2])).exp = expStr
	i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2])).lv = lv
	i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2])).num = math.max(0, awardAdd - awardCur)
	self.textLimit:setString(i18n("Ancient_reel_text_07", i18n("item_resName_1612", string.formatnumberthousands(itemdata.coin[2]))))
end
function ancientReelShopExpSingle:sureBuy(num)
	print("选择了数量:", num)
	ancientReelCtrl:reqActivityBuyExp(self.data.itemdata.shopID, num)
	if self.parentView then
		self.parentView:showLoading()
	end
end
return ancientReelShopExpSingle

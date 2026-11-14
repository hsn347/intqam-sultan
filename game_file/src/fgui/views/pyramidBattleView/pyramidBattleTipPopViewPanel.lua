local pyramidwarShopCtrl = SoraDGetCtrl("pyramidwarShopCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local pyramidBattleTipPopViewPanel = class("pyramidBattleTipPopViewPanel", baseFguiPanel)
function pyramidBattleTipPopViewPanel:ctor(...)
	pyramidBattleTipPopViewPanel.super.ctor(self, ...)
	print("pyramidBattleTipPopViewPanel:ctor", self.viewName)
end
function pyramidBattleTipPopViewPanel:onInit()
	print("=======pyramidBattleTipPopViewPanel:onInit")
	self.listData, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("allianceWar_shopPoint_details"))
	self.fields.Text_ins:setString(i18n("allianceWar_shopPoint_Remark"))
	self.fields.List:setItemRenderer(handler(self, self.onSingleRenderer))
end
function pyramidBattleTipPopViewPanel:onSingleRenderer(index, obj)
	obj:initData(self.listData[index + 1])
end
function pyramidBattleTipPopViewPanel:onShow()
	print("=======pyramidBattleTipPopViewPanel:onShow")
	self.listData, _ENV, self.matchType = self.param.matchType, self.param.matchType, self.param.matchType
	local detailData = pyramidwarShopCtrl:getScoreDetail(self.matchType)
	_UPVALUE3_ = pyramidwarShopCtrl
	pyramidwarShopCtrl[1] = gPyramidwarShopPointAddType.OCCUPY_BUILDING
	pyramidwarShopCtrl[2] = gPyramidwarShopPointAddType.KILL_SOLDIER
	local pyramidwarShopCtrl[3], enumCfg = gPyramidwarShopPointAddType.SOLDIER_DIE, pyramidwarShopCtrl
	for k, v in pairs(enumCfg) do
		local score = detailData[tostring(v)] and math.floor(detailData[tostring(v)]) or 0
		_ENV = nil
		;(nil).targetType = v
		;(nil).targetScore = score
		table.insert(self.listData, nil)
	end
	self.fields.List:setNumItems(#self.listData)
end
return pyramidBattleTipPopViewPanel

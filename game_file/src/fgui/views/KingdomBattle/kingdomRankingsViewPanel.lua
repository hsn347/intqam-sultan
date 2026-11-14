local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomRankingsViewPanel = class("kingdomRankingsViewPanel", baseFguiPanel)
function kingdomRankingsViewPanel:ctor(...)
	kingdomRankingsViewPanel.super.ctor(self, ...)
	print("kingdomRankingsViewPanel:ctor", self.viewName)
end
function kingdomRankingsViewPanel:onInit()
	print("=======kingdomRankingsViewPanel:onInit")
	_UPVALUE3_, self.rankList, _ENV = print, print, print
	self.rankCfg, print[1] = print, lordRankingsDef.alliancePower
	self.rankCfg, print[2] = print, lordRankingsDef.lordPower
	self.rankCfg, print[3] = print, lordRankingsDef.lordKill
	self.fields.Com_title:initData(i18n("common_btn_01"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function kingdomRankingsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function kingdomRankingsViewPanel:onShow()
	print("=======kingdomRankingsViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.rankList, _ENV = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor
	for i = 1, #self.rankCfg, 3 do
		_ENV = nil
		;(nil).data1 = self.rankCfg[i]
		;(nil).data2 = self.rankCfg[i + 1]
		;(nil).data3 = self.rankCfg[i + 2]
		table.insert(self.rankList, nil)
	end
	self.fields.List:setNumItems(#self.rankList)
	self.fields.List:setScrollEnable(#self.rankList >= math.ceil(self.fields.List:getHeight() / 282))
end
return kingdomRankingsViewPanel

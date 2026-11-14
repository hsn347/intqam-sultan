local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleWarRankPanel = class("kingdomBattleWarRankPanel", baseFguiPanel)
function kingdomBattleWarRankPanel:ctor(...)
	self.isLRU = true
	kingdomBattleWarRankPanel.super.ctor(self, ...)
	print("kingdomBattleWarRankPanel:ctor", self.viewName)
end
function kingdomBattleWarRankPanel:onInit()
	print("=======kingdomBattleWarRankPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("atlantiswar_text_0047"), handler(self, self.onClickClose))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_score:setString(i18n("common_text_1764"))
	self.fields.Text_none:setString(i18n("fishingmaster_text_07"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function kingdomBattleWarRankPanel:onItemRender(index, obj)
	obj:initData(self.rankData[index + 1], index + 1, self.redKid)
end
function kingdomBattleWarRankPanel:endShow()
	print("=======kingdomBattleWarRankPanel:endShow")
	self.kid = self.param.kid
	conquestWarCtrl:getConquestWarRankReq(self.kid)
end
function kingdomBattleWarRankPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.rankData = data.data.ranklist
	self.redKid = 0
	for k, v in ipairs(self.rankData) do
		if v.kid >= self.redKid then
			self.redKid = v.kid
		end
	end
	self.fields.List:setNumItems(#self.rankData)
	self.fields.Text_none:setVisible(#self.rankData == 0)
end
return kingdomBattleWarRankPanel

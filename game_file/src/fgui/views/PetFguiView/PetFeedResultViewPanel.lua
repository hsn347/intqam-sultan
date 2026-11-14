local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetFeedResultViewPanel = class("PetFeedResultViewPanel", baseFguiPanel)
function PetFeedResultViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetFeedResultViewPanel:ctor", self.viewName)
end
function PetFeedResultViewPanel:onInit()
	print("=======PetFeedResultViewPanel:onInit")
	self.fields.text_title:setString(i18n("pet_title_02"))
	self.fields.text_feed_title:setString(i18n("pet_text_14"))
	self.fields.text_gold_title:setString(i18n("common_text_4340"))
	self.fields.text_exp_title:setString(i18n("common_text_4341"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function PetFeedResultViewPanel:onShow()
	print("=======PetFeedResultViewPanel:onShow")
	if not self.param or not self.param.result then
		_ENV = self.param.result
	end
	self:init(self.param.result)
end
function PetFeedResultViewPanel:init(data)
	local totalTimes = #data
	local totalGold = 0
	local totalExp = 0
	for i, v in ipairs(data) do
		totalGold = totalGold + v.gold
		totalExp = totalExp + v.exp
	end
	self.fields.text_feed_value:setString(totalTimes)
	self.fields.text_gold_value:setString(totalGold)
	self.fields.text_exp_value:setString(totalExp)
end
return PetFeedResultViewPanel

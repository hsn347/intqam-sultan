local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRankHelpPanel = class("NebulaEmperorRankHelpPanel", baseFguiPanel)
function NebulaEmperorRankHelpPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorRankHelpPanel:ctor", self.viewName)
end
function NebulaEmperorRankHelpPanel:onInit()
	print("=======NebulaEmperorRankHelpPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_001"))
	self.fields.Text_des:setString(i18n("nebulaemperor_text_100"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.scoreList = nebulaEmperorRead.getRankHelpScoreList()
	self.fields.List:setNumItems(#self.scoreList)
end
function NebulaEmperorRankHelpPanel:onShow()
	print("=======NebulaEmperorRankHelpPanel:onShow")
end
function NebulaEmperorRankHelpPanel:onItemRenderer(index, obj)
	local cfg = self.scoreList[index + 1]
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).num = string.formatnumberthousands(cfg.num)
	_fields.Text_name:setString(i18n(cfg.text, nil))
	_ENV = i18n(cfg.text, nil)
	i18n(cfg.text, nil).point = string.formatnumberthousands(cfg.score)
	_fields.Text_value:setString(i18n("common_text_2200", i18n(cfg.text, nil)))
	_fields.Image_line:setVisible(index % 2 ~= 0)
end
return NebulaEmperorRankHelpPanel

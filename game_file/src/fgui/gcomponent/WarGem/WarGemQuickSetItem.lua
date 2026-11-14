local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemQuickSetItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemQuickSetItem", WarGemQuickSetItem)
function WarGemQuickSetItem:onInit()
	self:fixChildrenPos()
	self.ctype = combinationCtrl.COMBINATION_TYPE.WARGEM
	self.fields.Button_use:setString(i18n("gemEnchant_text_72"))
	self.fields.Button_use:addClickListener(handler(self, self.onClickUse))
end
function WarGemQuickSetItem:onClickUse()
	local panelInfo = warGemCtrl:getGemPanel(self.panelId)
	local hasGem = false
	for k, v in pairs(panelInfo) do
		for k1, v1 in pairs(v) do
			if 0 < v1 then
				print("hasGem", k, k1, v1)
				hasGem = true
				break
			end
		end
		if hasGem then
			break
		end
	end
	if not hasGem then
		SoraDShowMsgTip(i18n("gemEnchant_text_70"))
		return
	end
	warGemCtrl = i18n("gemEnchant_text_70")
	i18n("gemEnchant_text_70").content = i18n("gemEnchant_text_68")
	i18n("gemEnchant_text_70").confirmFunc = function()
		warGemCtrl:reqCopyPanel(self.panelId, warGemCtrl:getEditPanelId())
		SoraDShowLoading(self.panel:displayObject())
	end
	uiManager:show("MessageBox", i18n("gemEnchant_text_70"))
end
function WarGemQuickSetItem:onShow()
end
function WarGemQuickSetItem:initData(panelId, panel)
	self.panelId = panelId
	self.panel = panel
	local title = combinationCtrl:getSetName(self.ctype, panelId)
	combinationCtrl = nil
	;(nil).var = title
	self.fields.Text_name:setString(i18n("gemEnchant_text_71", nil))
end
return WarGemQuickSetItem

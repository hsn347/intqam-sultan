local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local remainsGroupPopPanel = class("remainsGroupPopPanel", baseFguiPanel)
function remainsGroupPopPanel:ctor(...)
	self.isLRU = true
	remainsGroupPopPanel.super.ctor(self, ...)
	print("remainsGroupPopPanel:ctor", self.viewName)
end
function remainsGroupPopPanel:onInit()
	print("=======remainsGroupPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("remains_text_386"))
	self.fields.Text_tip:setString(i18n("remains_text_387"))
end
function remainsGroupPopPanel:endShow()
	print("=======remainsGroupPopPanel:endShow")
	local kids, myKid = remainsTeamCtrl:getGroups()
	local _ENV, kStr
	for _, v in ipairs(kids) do
		table.insert(kStr, fguiHelper.getColorString(v == myKid and "#E02B2B" or "#FFFBD5", "#" .. v))
	end
	self.fields.Text_kids:setString(table.concat(kStr, ","))
end
return remainsGroupPopPanel

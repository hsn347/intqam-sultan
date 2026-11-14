local activity_9001596_Read = include("activity_9001596_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001596_Ctrl = SoraDGetCtrl("activity_9001596_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_part = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001596/Btn_part", Btn_part)
function Btn_part:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.n1:fix()
end
function Btn_part:onShow()
end
function Btn_part:initData(part, curPart)
	self.part = part
	self.fields.Text_name:setString(activity_9001596_Read.getPartName(part))
	self.fields.icon:setSpriteFrame(activity_9001596_Read.getPartIcon(part))
	local num = backpackCtrl:getItemCount(activity_9001596_Read.getPartID(part))
	local need = activity_9001596_Read.getPartNum(part)
	local isMerged = activity_9001596_Ctrl:isMerged(self.part)
	self.fields.Label_reddot:setVisible(false)
	if isMerged then
		self.fields.Text_progress:setString(i18n("Ramadan_2024_text51"))
	else
		activity_9001596_Read = i18n("Ramadan_2024_text51")
		i18n("Ramadan_2024_text51").var1 = fguiHelper.getColorString(num >= need and "#FFC887" or "#FF0000", num)
		i18n("Ramadan_2024_text51").var2 = need
		self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", i18n("Ramadan_2024_text51")))
		self.fields.Label_reddot:setVisible(num >= need)
	end
	self.controllers.c1:setSelectedIndex(part == curPart and 1 or 0)
end
function Btn_part:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001596_UI_PART_SELECT"
	;(nil).part = self.part
	SoraDSendMessage(nil)
end
return Btn_part

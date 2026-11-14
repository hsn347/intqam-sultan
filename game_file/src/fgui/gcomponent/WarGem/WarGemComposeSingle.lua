local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemComposeSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/WarGemComposeSingle", WarGemComposeSingle)
function WarGemComposeSingle:onInit()
	self:addEventListener(fgui.UIEventType.TouchBegin, function()
		print("WarGemComposeSingle touch began!!!!!!!!")
	end)
	self:addLongPressListener(handler(self, self.onLongPress))
end
function WarGemComposeSingle:onLongPress(button, touchPos)
	if self.id > 0 then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		;(nil).id = self.id
		;(nil).num = nil
		;(nil).pos = touchPos
		SoraDSendMessage(nil)
	end
end
function WarGemComposeSingle:onShow()
end
function WarGemComposeSingle:initData(id, curCount, costCount)
	self.id = id
	self.controllers.Ctrl_status:setSelectedIndex(id == 0 and 1 or 0)
	if 0 < id then
		local lv = wargemResRead.getLevel(id)
		self.fields.Text_lv:setString("LV." .. lv)
		local icon = wargemResRead.getIcon(id)
		self.fields.Icon_gem:setURL(icon)
		local color = wargemResRead.getQuality(id)
		self.fields.Com_color:setColor(color)
		self.fields.Text_num:setString(curCount .. "/" .. costCount)
		self.controllers.c1:setSelectedIndex(costCount <= curCount and 0 or 1)
	end
end
return WarGemComposeSingle

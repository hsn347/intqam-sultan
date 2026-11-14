local baseComponent = require("fgui.base.baseComponent")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local Com_MC_head = fgui.extension_class(fgui.GLabel, baseComponent)
local divineBeastRead = include("divineBeastRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_head", Com_MC_head)
function Com_MC_head:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Com_MC_head:onShow()
end
function Com_MC_head:initData(beastID)
	self.controllers.c1:setSelectedIndex(1)
	self.divineID = beastID
	local beastData = divineBeastCtrl:getBeastData(self.divineID)
	self.divineBeastData = divineBeastCtrl:getBeastData(self.divineID)
	divineBeastCtrl = nil
	;(nil).num = beastData.stepLv or 0
	self.fields.Text_db_lv:setString(i18n("Divine_beast_text_66", nil))
	local starLv = beastData.starLv or 0
	self.fields.starLv:setString("" .. starLv)
	self:setIcon(divineBeastRead.getIcon(self.divineID))
end
function Com_MC_head:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_MC_head:onClick()
	if self.clickCallback then
		self.clickCallback(self.divineID)
	end
end
function Com_MC_head:setSelected(selected)
	self.controllers.c2:setSelectedIndex(selected and 1 or 0)
end
return Com_MC_head

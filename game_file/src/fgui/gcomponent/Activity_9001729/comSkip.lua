local baseComponent = require("fgui.base.baseComponent")
local comSkip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/comSkip", comSkip)
function comSkip:onInit()
	self.fields.Text_tip:setString(i18n("Ramadan_treasure_hunt_text_05"))
	_ENV = i18n("Ramadan_treasure_hunt_text_05")
	i18n("Ramadan_treasure_hunt_text_05").byUID = true
	self.isAuto = SoraDConfigGet("Game:CrescentTreasureHuntView:isAuto~bool", i18n("Ramadan_treasure_hunt_text_05")) or false
	self.fields.CheckBox_Box:setSelected(self.isAuto)
	self.fields.CheckBox_Box:addClickEventListener(handler(self, self.btnActCallBack))
end
function comSkip:onShow()
	_ENV = nil
	;(nil).byUID = true
	self.isAuto = SoraDConfigGet("Game:CrescentTreasureHuntView:isAuto~bool", nil) or false
	self.fields.CheckBox_Box:setSelected(self.isAuto)
end
function comSkip:btnActCallBack(context)
	SoraDPlaySound()
	self.isAuto = self.fields.CheckBox_Box:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CrescentTreasureHuntView:isAuto~bool", self.isAuto, nil)
end
function comSkip:getIsAuto()
	return self.isAuto
end
function comSkip:closeAuto()
	self.isAuto = false
	self.fields.CheckBox_Box:setSelected(false)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CrescentTreasureHuntView:isAuto~bool", self.isAuto, nil)
	local proxy = uiManager:getProxy("Activity_9001729_View")
	if proxy then
		proxy.view.fields.stopAuto:setVisible(false)
	end
end
return comSkip

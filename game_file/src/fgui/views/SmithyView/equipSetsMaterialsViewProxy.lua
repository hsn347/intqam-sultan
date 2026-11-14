local baseProxy = require("fgui.base.baseProxy")
local equipSetsMaterialsViewProxy = class("equipSetsMaterialsViewProxy", baseProxy)
function equipSetsMaterialsViewProxy:onRegisterEvent()
	print("=======equipSetsMaterialsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_MATERIAL_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_METERIAL_MERGE_BACK", handler(self, self.margeBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_MERGE_SELECT", handler(self, self.selectBack))
end
function equipSetsMaterialsViewProxy:initData()
	self.view:initData()
end
function equipSetsMaterialsViewProxy:margeBack()
	SoraDShowMsgTip(i18n("common_text_3896"))
	self.view:initData(true)
end
function equipSetsMaterialsViewProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
return equipSetsMaterialsViewProxy

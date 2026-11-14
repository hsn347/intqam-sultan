local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_armsAdd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_armsAdd", Com_armsAdd)
function Com_armsAdd:onInit()
	self.fields.Text_tip:setString("点击选择神器")
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
end
function Com_armsAdd:onShow()
end
function Com_armsAdd:initData(armsID)
	self.armsID = armsID
	if self.armsID then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.icon:setSpriteFrame(equipDesRead.getArtifactIcon(self.armsID))
		self.fields.Text_name:setString(equipDesRead.getArtifactName(self.armsID))
		self.fields.Text_id:setString(self.armsID)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_armsAdd:btnTouchClick()
	SoraDPlaySound()
	uiManager:show("CheatArmsChoose")
end
function Com_armsAdd:btnRemoveClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMS"
	;(nil).armsID = nil
	SoraDSendMessage(nil)
end
return Com_armsAdd

local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_runeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_runeSingle", Com_runeSingle)
function Com_runeSingle:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Button_delete:addClickListener(handler(self, self.btnDeleteClick))
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
end
function Com_runeSingle:onShow()
end
function Com_runeSingle:initData(index, editData)
	self.index = index
	self.runeInfo = editData.godArmsRune.runeList[index]
	if self.runeInfo then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.icon:setSpriteFrame(artifactRuneRead.getRuneIcon(self.runeInfo.rid))
		self.fields.Text_name:setString(artifactRuneRead.getRuneName(self.runeInfo.rid))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_index:setString("战纹" .. index)
	end
end
function Com_runeSingle:btnTouchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	uiManager:show("CheatRuneChoose", nil)
end
function Com_runeSingle:btnDeleteClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_RUNE"
	;(nil).index = self.index
	;(nil).runeInfo = nil
	SoraDSendMessage(nil)
end
function Com_runeSingle:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).runeInfo = self.runeInfo
	uiManager:show("CheatRuneBuffPop", nil)
end
return Com_runeSingle

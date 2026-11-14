local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_armySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_armySingle", Com_armySingle)
function Com_armySingle:onInit()
	self.fields.Button_delete:addClickListener(handler(self, self.btnDelClick))
	self.input = self.fields.input:getChild("input")
	self.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
end
function Com_armySingle:onShow()
end
function Com_armySingle:initData(index, editData)
	self.index = index
	self.editData = editData
	self.id = self.editData.armyDataInfo[self.index].id
	self.num = self.editData.armyDataInfo[self.index].num
	self.fields.Com_item:initData(self.id)
	local alv = armyLogic.getArmyLV(self.id)
	local wlv = armyDesRead.getWarLv(self.id)
	if 0 < wlv then
		self.fields.Text_name:setString("战" .. wlv .. " Lv." .. alv .. armyDesRead.getName(self.id))
	else
		self.fields.Text_name:setString("Lv." .. alv .. armyDesRead.getName(self.id))
	end
	self.fields.Text_id:setString(self.id)
	self.input:setText(self.num)
end
function Com_armySingle:btnDelClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMY"
	;(nil).id = self.id
	;(nil).value = 0
	SoraDSendMessage(nil)
end
function Com_armySingle:onSubmit()
	local value = tonumber(self.input:getText())
	if value then
		_ENV = self.input:getText()
		self.input:getText().msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMY"
		self.input:getText().id = self.id
		self.input:getText().value = value
		SoraDSendMessage(self.input:getText())
	else
		SoraDShowMsgTip("输入数量不对")
	end
end
return Com_armySingle

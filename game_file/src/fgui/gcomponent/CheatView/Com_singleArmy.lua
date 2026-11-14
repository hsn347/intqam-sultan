local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_singleArmy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_singleArmy", Com_singleArmy)
function Com_singleArmy:onInit()
	self.fields.Text_name:setAlign(0)
	self:addClickListener(handler(self, self.btnClick))
end
function Com_singleArmy:onShow()
end
function Com_singleArmy:initData(id)
	self.id = id
	self.fields.Com_item:initData(self.id)
	self.fields.Com_item:setTouchEnabled(false)
	self.fields.Text_id:setString(self.id)
	local alv = armyLogic.getArmyLV(self.id)
	local wlv = armyDesRead.getWarLv(self.id)
	if 0 < wlv then
		self.fields.Text_name:setString("战" .. wlv .. " Lv." .. alv .. armyDesRead.getName(self.id))
	else
		self.fields.Text_name:setString("Lv." .. alv .. armyDesRead.getName(self.id))
	end
end
function Com_singleArmy:addArmy(id, value)
	print("添加士兵 id,value=======", id, value)
	_ENV = "添加士兵 id,value======="
	;("添加士兵 id,value=======").msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMY"
	;("添加士兵 id,value=======").id = id
	;("添加士兵 id,value=======").value = value
	SoraDSendMessage("添加士兵 id,value=======")
end
function Com_singleArmy:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemId = self.id
	;(nil).handle = handler(self, self.addArmy)
	uiManager:show("CheatItemGetView", nil)
end
return Com_singleArmy

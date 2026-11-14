local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local soldierRushRead = include("soldierRushRead")
_ENV = "soldierRushRead"
;("soldierRushRead")[0] = 0.25
;("soldierRushRead")[1] = 0.5
;("soldierRushRead")[2] = 0.75
local ("soldierRushRead")[3], indexToPercentCfg = 1, "soldierRushRead"
local baseComponent = require("fgui.base.baseComponent")
local Com_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_progress", Com_progress)
function Com_progress:onInit()
	for i = 0, 3 do
		self.fields["Btn_" .. i]:setString(indexToPercentCfg[i] * 100 .. "%")
		self.fields["Btn_" .. i]:setTag(i)
		self.fields["Btn_" .. i]:addClickListener(handler(self, self.onClick))
	end
end
function Com_progress:onShow()
end
function Com_progress:getIndexByVal(val)
	for k, v in pairs(indexToPercentCfg) do
		if v * 100 == val then
			return k
		end
	end
end
function Com_progress:initData(val)
	if val then
		self.index = self:getIndexByVal(val)
	else
		_ENV = val
		val.byUID = true
		local recordVal = SoraDConfigGet("Game:SoldierRush:dispatchPro~integer", val)
		if not recordVal or recordVal == 0 then
			local cstVal = soldierRushRead.getConstantVal("Send_Soldier_Ratio_default")
			self.index = self:getIndexByVal(cstVal)
		else
			self.index = self:getIndexByVal(recordVal)
		end
	end
	self.controllers.c1:setSelectedIndex(self.index)
	soldierRushCtrl:setDispatchPro(indexToPercentCfg[self.index])
end
function Com_progress:onClick(context)
	SoraDPlaySound()
	local tag = context:getSender():getTag()
	self.index = tag
	self.controllers.c1:setSelectedIndex(self.index)
	soldierRushCtrl:setDispatchPro(indexToPercentCfg[self.index])
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:SoldierRush:dispatchPro~integer", indexToPercentCfg[self.index] * 100, nil)
end
function Com_progress:getBtnIndex(index)
	return self.fields["Btn_" .. index]
end
return Com_progress

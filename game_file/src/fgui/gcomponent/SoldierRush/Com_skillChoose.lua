local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillChoose = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_skillChoose", Com_skillChoose)
function Com_skillChoose:onInit()
end
function Com_skillChoose:onShow()
end
function Com_skillChoose:updateData(index, skillID)
	self.fields["skill_" .. index]:updateData(index, skillID)
end
function Com_skillChoose:updateIndex(index)
	self.controllers.c1:setSelectedIndex(index - 1)
end
function Com_skillChoose:initData(index)
	self.controllers.c1:setSelectedIndex(index - 1)
	for i = 1, 4 do
		local cfgID = soldierRushRead.getConstantVal("Unlock_Hero_Slot" .. i)
		local skillID = soldierRushCtrl:getSkillSlotRecord(i)
		local status = 2
		if cfgID == 0 or soldierRushCtrl:getGateRecord(cfgID) then
			status = skillID and 0 or 1
		end
		self.fields["skill_" .. i]:initData(i, status, skillID)
	end
end
function Com_skillChoose:outPutData()
	local _ENV, data
	for i = 1, 4 do
		local status, skillID = self.fields["skill_" .. i]:getData()
		if status == 0 and skillID then
			data[tostring(i)] = skillID
		end
	end
	return data
end
return Com_skillChoose

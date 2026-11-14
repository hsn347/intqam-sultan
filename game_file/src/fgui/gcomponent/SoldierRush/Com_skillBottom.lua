local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_skillBottom", Com_skillBottom)
function Com_skillBottom:onInit()
	self.fields.Text_tip:setString(i18n("soldier_rush_text_15"))
end
function Com_skillBottom:onShow()
end
function Com_skillBottom:initData()
	local minCfgID = 0
	for i = 1, 4 do
		local cfgID = soldierRushRead.getConstantVal("Unlock_Hero_Slot" .. i)
		local skillID = soldierRushCtrl:getSkillSlotRecord(i)
		local status = 2
		if cfgID == 0 or soldierRushCtrl:getGateRecord(cfgID) then
			status = skillID and 0 or 1
		elseif minCfgID == 0 then
			minCfgID = cfgID
		else
			minCfgID = math.min(minCfgID, cfgID)
		end
		self.fields["skill_" .. i]:initData(i, status, skillID, self.controllers.c1:getSelectedIndex() == 1, minCfgID)
	end
end
return Com_skillBottom

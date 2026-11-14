local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_gateTarget = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_gateTarget", Com_gateTarget)
function Com_gateTarget:onInit()
	self:fixChildrenPos()
end
function Com_gateTarget:onShow()
end
function Com_gateTarget:initData(data, gate, isHistory)
	local record = soldierRushCtrl:getCurStarInfo()
	if isHistory then
		record = soldierRushCtrl:getGateRecord(gate)
	end
	if record and record[data.index] == 1 then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	if data.index == 1 then
		soldierRushCtrl = data.index
		data.index[1] = i18n("soldier_rush_text_105")
		data.index[2] = i18n("soldier_rush_text_32")
		local data.index[3], strCfg = i18n("soldier_rush_text_33"), data.index
		self.fields.title:setString(strCfg[data.val])
	else
		soldierRushCtrl = data.index
		data.index[1] = i18n("soldier_rush_build_1")
		data.index[2] = i18n("soldier_rush_build_2")
		local data.index[3], nameCfg = i18n("soldier_rush_build_3"), data.index
		if data.key == 1 then
			soldierRushCtrl = nil
			;(nil).num = data.val1
			self.fields.title:setString(i18n("soldier_rush_text_101", nil))
		elseif data.key == 2 then
			soldierRushCtrl = i18n("soldier_rush_text_101", nil)
			i18n("soldier_rush_text_101", nil).num1 = data.val1
			i18n("soldier_rush_text_101", nil).name = data.val2 == 0 and i18n("soldier_rush_text_45") or nameCfg[data.val2]
			i18n("soldier_rush_text_101", nil).num2 = data.val3
			self.fields.title:setString(i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil)))
		elseif data.key == 3 then
			soldierRushCtrl = i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil))
			i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil)).num = data.val1
			self.fields.title:setString(i18n("soldier_rush_text_103", i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil))))
		elseif data.key == 4 then
			soldierRushCtrl = i18n("soldier_rush_text_103", i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil)))
			i18n("soldier_rush_text_103", i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil))).name = data.val1 == 0 and i18n("soldier_rush_text_45") or nameCfg[data.val1]
			i18n("soldier_rush_text_103", i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil))).num = data.val2
			self.fields.title:setString(i18n("soldier_rush_text_104", i18n("soldier_rush_text_103", i18n("soldier_rush_text_102", i18n("soldier_rush_text_101", nil)))))
		end
	end
end
return Com_gateTarget

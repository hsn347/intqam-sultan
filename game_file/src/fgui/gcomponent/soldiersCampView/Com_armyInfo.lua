local armyltCtrl = include("armyltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_armyInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_armyInfo", Com_armyInfo)
function Com_armyInfo:onInit()
	self.fields.Text_speed:setString(i18n("common_text_323"))
	self.fields.Text_weight:setString(i18n("common_text_324"))
	self.fields.Text_distance:setString(i18n("common_text_322"))
	self:fixChildrenPos()
end
function Com_armyInfo:onShow()
end
function Com_armyInfo:hideOther(ret)
	self.fields.Text_speed:setVisible(ret)
	self.fields.Text_weight:setVisible(ret)
	self.fields.Text_distance:setVisible(ret)
	self.fields.Text_speed_value:setVisible(ret)
	self.fields.Text_weight_value:setVisible(ret)
	self.fields.Text_distance_value:setVisible(ret)
end
function Com_armyInfo:initData(armyid, isTarget, curArmyid, isTrap)
	local power = armyltCtrl.getArmyAttrAndSp(armyid, ARMY_ATTR.POWER)
	armyltCtrl = nil
	;(nil).count = power
	self.fields.Text_power:setString(i18n("common_text_555", nil))
	local bid = armyltCtrl.armyAttr(armyid, ARMY_ATTR.BARRACK_ID)
	for i = 1, 3 do
		self.fields["n" .. i]:initData(bid, armyid, isTrap and TRAIN_TYPE.TRAP or TRAIN_TYPE.SOLDIERS, i)
	end
	if isTrap then
		self:hideOther(false)
		return
	end
	self:hideOther(true)
	local speed_cur = armyltCtrl.getArmyAttrAndSp(armyid, ARMY_ATTR.SPEED)
	local weight_cur = armyltCtrl.getArmyAttrAndSp(armyid, ARMY_ATTR.FREE_WEIGHT)
	local distance_cur = armyltCtrl.getArmyAttrAndSp(armyid, ARMY_ATTR.ATK_DISTANCE)
	self.fields.Text_speed_value:setString(speed_cur)
	self.fields.Text_weight_value:setString(weight_cur)
	self.fields.Text_distance_value:setString(distance_cur)
	if isTarget then
		local speed_ori = armyltCtrl.getArmyAttrAndSp(curArmyid, ARMY_ATTR.SPEED)
		local weight_ori = armyltCtrl.getArmyAttrAndSp(curArmyid, ARMY_ATTR.FREE_WEIGHT)
		local distance_ori = armyltCtrl.getArmyAttrAndSp(curArmyid, ARMY_ATTR.ATK_DISTANCE)
		self.fields.Text_speed_value:setColor(speed_cur > speed_ori and cc.c3b(0, 190, 30) or cc.c3b(255, 251, 213))
		self.fields.Text_weight_value:setColor(weight_cur > weight_ori and cc.c3b(0, 190, 30) or cc.c3b(255, 251, 213))
		self.fields.Text_distance_value:setColor(distance_cur > distance_ori and cc.c3b(0, 190, 30) or cc.c3b(255, 251, 213))
	end
end
return Com_armyInfo

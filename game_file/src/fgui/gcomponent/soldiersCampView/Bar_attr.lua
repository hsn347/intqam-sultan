local armyltCtrl = include("armyltCtrl")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Bar_attr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Bar_attr", Bar_attr)
fgui.register_extension("ui://soldiersCampView/Bar_attrSp", Bar_attr)
function Bar_attr:onInit()
	_ENV = nil
	_UPVALUE3_, _ENV = nil, nil
	_UPVALUE3_, (nil).tableKey, (nil)[1] = nil, nil, ARMY_ATTR.ATTACK
	_UPVALUE3_, (nil).tableKey, (nil)[2] = nil, nil, ARMY_ATTR.DEFENSE
	_UPVALUE3_, (nil).tableKey, (nil)[3] = nil, nil, ARMY_ATTR.LIFE
	;(nil)[TRAIN_TYPE.SOLDIERS], (nil).tableI18nKey, (nil)[1] = nil, nil, "common_text_319"
	;(nil)[TRAIN_TYPE.SOLDIERS], (nil).tableI18nKey, (nil)[2] = nil, nil, "common_text_320"
	;(nil)[TRAIN_TYPE.SOLDIERS], (nil).tableI18nKey, (nil)[3] = nil, nil, "common_text_321"
	_UPVALUE3_, _ENV = nil, nil
	_UPVALUE3_, (nil).tableKey, (nil)[1] = nil, nil, ARMY_ATTR.ATTACK
	_UPVALUE3_, (nil).tableKey, (nil)[2] = nil, nil, ARMY_ATTR.ATK_DISTANCE
	_UPVALUE3_, (nil).tableKey, (nil)[3] = nil, nil, ARMY_ATTR.POWER
	self.cfg, (nil)[TRAIN_TYPE.TRAP], (nil).tableI18nKey, (nil)[1] = nil, nil, nil, "common_text_319"
	self.cfg, (nil)[TRAIN_TYPE.TRAP], (nil).tableI18nKey, (nil)[2] = nil, nil, nil, "common_text_322"
	self.cfg, (nil)[TRAIN_TYPE.TRAP], (nil).tableI18nKey, (nil)[3] = nil, nil, nil, "common_text_097"
	self:fixChildrenPos()
end
function Bar_attr:onShow()
end
function Bar_attr:initData(bid, armyID, trainType, index)
	local cfg = self.cfg[trainType]
	local value = armyltCtrl.getArmyAttrAndSp(armyID, cfg.tableKey[index])
	local attrValue = armyltCtrl.armyAttr(armyID, cfg.tableKey[index])
	local max = armyltCtrl.getMostAttrByBid(bid, cfg.tableKey[index])
	self.fields.Text_val:setString(i18n(cfg.tableI18nKey[index]) .. " " .. tostring(attrValue))
	self.fields.Text_add:setString("")
	if trainType == TRAIN_TYPE.SOLDIERS then
		local newValue = armyLogic.getArmyShowADH(armyID, index)
		local addValue = SoraDPreciseDecimal(newValue - attrValue, 1)
		if 0 < addValue then
			self.fields.Text_add:setString("+" .. addValue)
		end
	end
	self.controllers.c1:setSelectedIndex(index - 1)
	self.fields["n" .. index]:setWidth(math.min(100, value * 100 / max))
end
return Bar_attr

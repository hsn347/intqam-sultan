local armyltCtrl = include("armyltCtrl")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillAttrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_skillAttrSingle", Com_skillAttrSingle)
function Com_skillAttrSingle:onInit()
	self:fixChildrenPos()
end
function Com_skillAttrSingle:onShow()
end
function Com_skillAttrSingle:initData(data, armyID)
	self.fields.Text_name:setString(i18n(data.title))
	local value = armyltCtrl.getArmyAttrAndSp(armyID, data.attrEnum)
	if data.bType then
		local attrValue = armyltCtrl.armyAttr(armyID, data.attrEnum)
		local newValue = armyLogic.getArmyShowADH(armyID, data.bType)
		local addValue = SoraDPreciseDecimal(newValue - attrValue, 1)
		_ENV = i18n(data.title)
		i18n(data.title).var1 = value
		i18n(data.title).var2 = fguiHelper.getColorString("#4CE61A", "+" .. addValue)
		self.fields.Text_value:setString(i18n("%{var1} %{var2}", i18n(data.title)))
	else
		local greenValue = armyltCtrl.getSpecialityAddition(armyID)
		self.fields.Text_value:setString(value)
		self.fields.Text_value:setColor(greenValue[data.attrEnum] and cc.c3b(70, 210, 70) or cc.c3b(240, 230, 210))
	end
end
return Com_skillAttrSingle

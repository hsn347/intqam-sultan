local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local RuneAttrSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Chaser/RuneAttrSingle", RuneAttrSingle)
function RuneAttrSingle:onInit()
	self:fixChildrenPos()
end
function RuneAttrSingle:onShow()
end
function RuneAttrSingle:initData(data, rid, index)
	dump(data, "RuneAttrSingle data")
	local propertyArray, quality = artifactRuneRead.getPropertyArray(data[1])
	local des = ""
	for k, v in ipairs(propertyArray) do
		local pLvCfg = artifactRuneRead.getPropertiesLvCfg(v.growType, data[2])
		if k == #propertyArray then
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode)
		else
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode) .. ","
		end
	end
	if not data[3] then
		if rid and index then
			local needClass = artifactRuneRead.getPropertyActivationClass(rid, index)
			_ENV = nil
			;(nil).num = needClass
			des = des .. i18n("Weapon_Rune_tips_056", nil)
		else
			des = des .. i18n("Weapon_Rune_tips_056")
		end
	end
	self.fields.title:setString(des)
	self.fields.title:setColor(artifactRuneRead.getColor(quality, data[3]))
	self.fields.spot:setColor(artifactRuneRead.getColor(quality, data[3]))
end
return RuneAttrSingle

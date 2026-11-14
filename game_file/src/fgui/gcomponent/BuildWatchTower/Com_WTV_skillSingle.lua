local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_skillSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_skillSingle", Com_WTV_skillSingle)
local lordSkillDesRead = include("lordSkillDesRead")
local collegeDesRead = include("collegeDesRead")
_ENV = "collegeDesRead"
;("collegeDesRead").SKILL = 1
local ("collegeDesRead").TECH, NAME_TYPE = 2, "collegeDesRead"
function Com_WTV_skillSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
end
function Com_WTV_skillSingle:onShow()
end
function Com_WTV_skillSingle:initData(data, data2, index, type)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.name1:setString(self:geTxtName(data[1], type))
	self.fields.lv1:setString("Lv" .. data[2])
	self.fields.name2:setVisible(data2 ~= nil)
	self.fields.lv2:setVisible(data2 ~= nil)
	if data2 then
		self.fields.name2:setString(self:geTxtName(data2[1], type))
		self.fields.lv2:setString("Lv" .. data2[2])
	end
end
function Com_WTV_skillSingle:geTxtName(value, type)
	if type == NAME_TYPE.TECH then
		return collegeDesRead.getName(value)
	else
		return lordSkillDesRead.getName(value)
	end
end
return Com_WTV_skillSingle

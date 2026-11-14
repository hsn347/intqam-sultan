local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildConditionSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildConditionSingle", allianceBuildConditionSingle)
function allianceBuildConditionSingle:onInit()
	self.singleData, _ENV = nil, nil
	self.spriteIcon = self.fields.Sprite_icon
	self.labelDes = self.fields.Text_des
	self.nodeAim = self.fields.bar
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.bar:fixChildrenPos()
	end
end
function allianceBuildConditionSingle:onShow()
end
function allianceBuildConditionSingle:initData(singleData)
	self.singleData = singleData
	self.labelDes:setString(allianceDesRead.getBuildConditionDes(self.singleData.id, self.singleData.aim))
	self.spriteIcon:setURL(allianceDesRead.getBuildConditionIcon(self.singleData.id))
	local maxValue = self.singleData.aim
	local curValue = math.min(self.singleData.cur, maxValue)
	self.nodeAim:setMax(maxValue)
	self.nodeAim:setValue(curValue)
end
return allianceBuildConditionSingle

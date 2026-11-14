local mailFunctions = include("mailFunctions")
local mailWorldBossSummary = include("mailWorldBossSummary")
local mailAlliancePetSummary = class("mailAlliancePetSummary", mailWorldBossSummary)
function mailAlliancePetSummary:ctor()
	self:setCascadeOpacityEnabled(true)
	mailAlliancePetSummary.super.ctor(self)
end
function mailAlliancePetSummary:initWithData(data)
	local content = data.content
	local coordinate = content.coordinate
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	self.text_coordinate:setString(strCoordinate)
	local killPercent = string.format("%.1f%%", content.killHP)
	self.text_kill_percent_value:setString(killPercent)
	local remainPercent = string.format("%.1f%%", content.remainHP)
	self.text_remain_percent_value:setString(remainPercent)
	local petType = content.beastType
	local alliancePetRead = include("alliancePetRead")
	local petName = alliancePetRead.getName(petType)
	mailFunctions = nil
	;(nil).lv = content.beastLv
	;(nil).name = petName
	self.text_world_boss:setString(i18n("common_text_134", nil))
	if self.img_icon then
		self.img_icon:loadTexture(alliancePetRead.getIcon(petType), ccui.TextureResType.plistType)
	end
	mailFunctions = i18n("common_text_134", nil)
	i18n("common_text_134", nil).name = petName
	self.text_kill_percent:setString(i18n("common_text_2118", i18n("common_text_134", nil)))
	mailFunctions = i18n("common_text_2118", i18n("common_text_134", nil))
	i18n("common_text_2118", i18n("common_text_134", nil)).name = petName
	self.text_remain_percent:setString(i18n("common_text_2119", i18n("common_text_2118", i18n("common_text_134", nil))))
end
return mailAlliancePetSummary

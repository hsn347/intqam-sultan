local mailFunctions = include("mailFunctions")
local mailWorldBossSummary = include("mailWorldBossSummary")
local mailWrathBeastSummary = class("mailWrathBeastSummary", mailWorldBossSummary)
function mailWrathBeastSummary:ctor()
	self:setCascadeOpacityEnabled(true)
	mailWrathBeastSummary.super.ctor(self)
end
function mailWrathBeastSummary:initWithData(data)
	local content = data.content
	if not content.coordinate then
		mailFunctions = content.coordinate
		content.coordinate.x = 0
		local content.coordinate.y, coordinate = 0, content.coordinate
	end
	local leftLife = content.leftLife
	local orgLifeNum = content.orgLifeNum
	local lastHP = content.lastHP
	local normalHP = content.normalHP
	local lifeNum = content.lifeNum
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	self.text_coordinate:setString(strCoordinate)
	local maxLife = lastHP + (orgLifeNum - 1) * normalHP
	local leftLifeTotal = string.format("%.2f%%", leftLife / maxLife * 100)
	self.text_kill_percent_value:setString(leftLifeTotal)
	local percent = 1
	if leftLife <= lastHP then
		percent = leftLife / lastHP * 100
	else
		leftLife = leftLife - lastHP - (lifeNum - 2) * normalHP
		percent = leftLife / normalHP * 100
	end
	local remainPercent = string.format("%.2f%%", percent or 32)
	self.text_remain_percent_value:setString(remainPercent)
	local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
	local beastData = wrathBeastCtrl:getWrathBeastData(content.objId)
	local bossType = beastData.bossType
	local bossShow = worldMapDefine.getWorldBossShow(bossType)
	self.text_world_boss:setString(i18n(bossShow.name))
	if self.img_icon then
		self.img_icon:loadTexture(bossShow.icon, ccui.TextureResType.plistType)
	end
	self.text_kill_percent:setString(i18n("mail_god_beast_text_04"))
	self.text_remain_percent:setString(i18n("mail_god_beast_text_05"))
end
return mailWrathBeastSummary

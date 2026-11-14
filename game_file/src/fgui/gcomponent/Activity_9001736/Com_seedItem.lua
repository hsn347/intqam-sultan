local activity_9001736_Read = include("activity_9001736_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_seedItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_seedItem", Com_seedItem)
function Com_seedItem:onInit()
	self.fields.Text_in:setString(i18n("football_match_text_076"))
	if not SoraDFIsRA() then
		self.fields.Image_pos:fixPos()
		self.fields.Image_lvBg:fix()
		self.fields.Image_powerBg:fix()
	end
end
function Com_seedItem:onShow()
end
function Com_seedItem:initData(data)
	local seedID = data.id
	self.seedID = seedID
	local seedQuality = data.quality
	local bgName = activity_9001736_Read.getSeedQualityBg(seedQuality)
	self.fields.Image_quality:setURL(bgName)
	local imageName = activity_9001736_Read.getSeedImage(seedID)
	self.fields.Image_icon:setIcon(imageName)
	local seedLv = data.lv
	activity_9001736_Read = nil
	;(nil).lv = seedLv
	local lvStr = i18n("common_text_100", nil)
	activity_9001736_Read = nil
	;(nil).lv = seedLv
	self.fields.Text_lv:setString(i18n("common_text_100", nil))
	local posType = activity_9001736_Read.getSeedPosition(seedID)
	local typeIcon = activity_9001736_Read.getPosTypeIcon(posType)
	self.fields.Image_pos:setURL(typeIcon)
	local isIn = data.isIn
	self.controllers.c_in:setSelectedIndex(isIn and 1 or 0)
	local seedPower = data.power
	local powerStr = string.formatnumberthousands(seedPower)
	self.fields.Text_power:setString(powerStr)
end
function Com_seedItem:setCurSeedId(curSeedId)
	if curSeedId == self.seedID then
		self.fields.Text_in:setString(i18n("football_match_text_084"))
	else
		self.fields.Text_in:setString(i18n("football_match_text_076"))
	end
end
return Com_seedItem

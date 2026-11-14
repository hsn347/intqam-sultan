local activity_9001736_Read = include("activity_9001736_Read")
local resDesRead = include("resDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_seed102 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_seed96", Com_seed102)
fgui.register_extension("ui://Activity_9001736/Com_seed102", Com_seed102)
fgui.register_extension("ui://Activity_9001736/Com_seedReward", Com_seed102)
function Com_seed102:onInit()
	self.fields = fguiHelper.get_fields(self.fields.item)
end
function Com_seed102:onShow()
end
function Com_seed102:onHide()
	if self.transitions.t_expSeed then
		self.transitions.t_expSeed:stop()
	end
end
function Com_seed102:initData(data)
	local seedID = data.id
	local activity_9001736_Read, info
	local seedQuality = activity_9001736_Read.getSeedQuality(seedID)
	info.bgName = activity_9001736_Read.getSeedQualityBg(seedQuality)
	info.imageName = activity_9001736_Read.getSeedImage(seedID)
	local posType = activity_9001736_Read.getSeedPosition(seedID)
	info.typeIcon = activity_9001736_Read.getPosTypeIcon(posType)
	info.count = data.count
	info.lv = data.lv
	self:initItemInfo(info)
end
function Com_seed102:initItemInfo(info)
	local bgName = info.bgName
	self.fields.Image_quality:setURL(bgName)
	local imageName = info.imageName
	self.fields.Image_icon:setIcon(imageName)
	local typeIcon = info.typeIcon
	if typeIcon then
		self.fields.Image_pos:setURL(typeIcon)
		self.fields.Image_pos:setVisible(true)
	else
		self.fields.Image_pos:setVisible(false)
	end
	local seedCount = info.count
	if seedCount then
		self.fields.Text_num:setString(seedCount)
		self.fields.Text_num:setVisible(true)
		self.fields.Image_numBg:setVisible(true)
	else
		self.fields.Text_num:setVisible(false)
		self.fields.Image_numBg:setVisible(false)
	end
	local seedLv = info.lv
	if seedLv then
		_ENV = nil
		;(nil).lv = seedLv
		local lvStr = i18n("common_text_100", nil)
		self.fields.Text_lv:setString(lvStr)
		self.fields.Text_lv:setVisible(true)
		self.fields.Image_lvBg:setVisible(true)
	else
		self.fields.Text_lv:setVisible(false)
		self.fields.Image_lvBg:setVisible(false)
	end
end
function Com_seed102:showExpSeed(expId, expCount)
	self.transitions.t_expSeed:play()
	self.transitions.t_expSeed:setHook("exchange", function()
		print("Com_seed102:showExpSeed:exchange")
		self:initExpData(expId, expCount)
	end)
end
function Com_seed102:initExpData(expId, expCount)
	local resDesRead, info
	local seedQuality = resDesRead.getQuality(expId)
	local bgName = activity_9001736_Read.getSeedQualityBg(seedQuality)
	info.bgName = bgName
	info.imageName = resDesRead.getIcon(expId)
	info.count = expCount or 0
	self:initItemInfo(info)
end
return Com_seed102

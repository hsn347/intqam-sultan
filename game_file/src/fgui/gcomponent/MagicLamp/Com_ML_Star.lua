local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Star = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Star", Com_ML_Star)
function Com_ML_Star:onInit()
	self.isLightInited = false
	self.isWillLightInited = false
end
function Com_ML_Star:onShow()
end
function Com_ML_Star:initData(isLight, isWillLight)
	local starUrl = isLight and "frame_sdxt_ylbz_01.png" or isWillLight and "frame_sdxt_xx_03.png" or "frame_sdxt_ylbz_02.png"
	self.fields.star_1:setURL(starUrl)
	self.fields.star_normal:setVisible(isLight)
	self.fields.star_unlock:setVisible(isWillLight)
	if isLight and not self.isLightInited then
		self.fields.star_normal:setAllFrameName("dh_shendengjmxx2_%02d.png", 1)
		self.fields.star_normal:setPlaySettings(0, -1, -1)
	end
	if isWillLight and not self.isWillLightInited then
		self.fields.star_unlock:setAllFrameName("dh_shendengjmxx1_%02d.png", 1)
		self.fields.star_unlock:setPlaySettings(0, -1, -1)
	end
end
return Com_ML_Star

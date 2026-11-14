local baseComponent = require("fgui.base.baseComponent")
local Com_MLMP_Skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampMaigcPower/Com_MLMP_Skill", Com_MLMP_Skill)
function Com_MLMP_Skill:onInit()
end
function Com_MLMP_Skill:onShow()
end
function Com_MLMP_Skill:initData(data, previewCfg)
	if type(data) == "table" then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.title:setTitle(data.title)
		self.fields.title:setIcon(data.bg)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_skill:initByType(data)
		self.fields.Com_skill:setClickShowDetail()
		self:updateSpAni(data, previewCfg)
	end
end
function Com_MLMP_Skill:updateSpAni(id, previewCfg)
	if previewCfg and previewCfg.magicSign then
		for i, v in ipairs(previewCfg.magicSign) do
			if v == id then
				self.fields.Ani_Sp:setVisible(true)
				self.fields.Ani_Sp:setAllFrameNameOnce("dh_sdsl_js_ss_%02d.png", 1, true)
				return
			end
		end
	end
	self.fields.Ani_Sp:setVisible(false)
end
return Com_MLMP_Skill

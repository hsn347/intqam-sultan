local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Power = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Power", Com_ML_Power)
function Com_ML_Power:onInit()
end
function Com_ML_Power:onShow()
	self.fields.ani:setAllFrameName("dh_sdxt_jhsl_jntbdk_%02d.png", 1)
	self.fields.ani:setPlaySettings(0, -1, -1)
end
function Com_ML_Power:initData(data)
	self.controllers.Ctrl_status:setSelectedIndex(data == nil and 0 or 1)
	if data then
		self.fields.Com_skill:initData(data)
	end
end
return Com_ML_Power

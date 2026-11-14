local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_MC_StarInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_StarInfoSingle", Com_MC_StarInfoSingle)
fgui.register_extension("ui://MythicalCreatures/Com_MC_StarInfoSingle2", Com_MC_StarInfoSingle)
function Com_MC_StarInfoSingle:onInit()
	self:fixChildrenPos()
end
function Com_MC_StarInfoSingle:onShow()
end
function Com_MC_StarInfoSingle:initData(growDesCfg)
	self:setVisible(growDesCfg ~= nil)
	if growDesCfg == nil then
		return
	end
	self.fields.title:setString(i18n(growDesCfg.growDes))
	self.fields.icon:setURL(growDesCfg.icon)
	self.fields.quality:setURL(heroltCtrl.getSkillBg(growDesCfg.quality))
end
return Com_MC_StarInfoSingle

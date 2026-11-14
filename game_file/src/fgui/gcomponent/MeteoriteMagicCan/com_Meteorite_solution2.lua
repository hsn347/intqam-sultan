local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_solution2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_solution2", com_Meteorite_solution2)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function com_Meteorite_solution2:onInit()
	self:fixChildrenPos()
end
function com_Meteorite_solution2:onShow()
end
function com_Meteorite_solution2:initData(config, isCurSelected, isUnlock)
	self.config = config
	local projectData = meteorMagicCtrl:getProjectData(config.id)
	local isActive = meteorMagicCtrl:getProjectIsActive(config.id)
	if projectData.name == "" or projectData.name == tostring(self.config.id) or not projectData.name then
		meteorMagicCtrl = self.config.id
		self.config.id.num = self.config.id
		local projectName = i18n("meteoritesmagic_text_12", self.config.id)
	end
	if isUnlock then
		self.controllers.c1:setSelectedIndex(0)
		if isActive then
			local strActive = fguiHelper.getColorString("#68DE21", "(" .. i18n("privilege_text_130") .. ")")
			meteorMagicCtrl = i18n("privilege_text_130")
			i18n("privilege_text_130").var1 = projectName
			i18n("privilege_text_130").var2 = strActive
			projectName = i18n("gemEnchant_text_60", (i18n("privilege_text_130")))
		end
		self.fields.Text_name:setString(projectName)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_unlock:setString(projectName)
	end
	self.controllers.button:setSelectedIndex(isCurSelected and 1 or 0)
end
return com_Meteorite_solution2

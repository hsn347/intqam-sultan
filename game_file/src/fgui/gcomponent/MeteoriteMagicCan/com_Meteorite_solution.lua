local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_solution = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_solution", com_Meteorite_solution)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function com_Meteorite_solution:onInit()
	self.fields.button_main:addClickEventListener(handler(self, self.onChooseClick))
	self.fields.button_rename:addClickEventListener(handler(self, self.onRenameClick))
end
function com_Meteorite_solution:onShow()
end
function com_Meteorite_solution:initData(config, isCurSelected, isUnlock)
	self.config = config
	local projectData = meteorMagicCtrl:getProjectData(config.id)
	if projectData.name == "" or not projectData.name then
		meteorMagicCtrl = nil
		;(nil).num = self.config.id
		local projectName = i18n("meteoritesmagic_text_12", nil)
	end
	self.fields.title:setString(projectName)
	self.isUnlock = isUnlock
	self.controllers.c1:setSelectedIndex(isCurSelected and 2 or isUnlock and 0 or 1)
	if isCurSelected then
		self.fields.movie:setAllFrameName("dh_baoshiyh_%02d.png", 0)
		self.fields.movie:setPlaySettings(0, -1, 0)
	end
end
function com_Meteorite_solution:setClickHandler(handler)
	self.handler = handler
end
function com_Meteorite_solution:onChooseClick()
	if not self.isUnlock then
		_ENV = nil
		;(nil).name = i18n("buildDes_name_305")
		;(nil).lv = self.config.activateLv
		SoraDShowMsgTip(i18n("meteoritesmagic_text_11", nil))
		return
	end
	SoraDPlaySound()
	if self.handler then
		self.handler(self.config.id)
	end
end
function com_Meteorite_solution:onRenameClick()
	if not self.isUnlock then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.config.id
	;(nil).renameType = 5
	uiManager:show("lordEquipRename", nil)
end
return com_Meteorite_solution

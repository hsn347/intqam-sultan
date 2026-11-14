local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_build = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_build", Com_build)
_ENV, _ENV = "ui://TowerDefend/Com_build", fgui.register_extension
;("ui://TowerDefend/Com_build").iconURL = "8422.png"
_ENV, fgui.register_extension[1], ("ui://TowerDefend/Com_build").skillName = "ui://TowerDefend/Com_build", "ui://TowerDefend/Com_build", "建造"
;("ui://TowerDefend/Com_build").iconURL = "8421.png"
_ENV, fgui.register_extension[2], ("ui://TowerDefend/Com_build").skillName = "ui://TowerDefend/Com_build", "ui://TowerDefend/Com_build", "EP_button_tips_0001"
;("ui://TowerDefend/Com_build").iconURL = "8422.png"
_ENV, fgui.register_extension[3], ("ui://TowerDefend/Com_build").skillName = "ui://TowerDefend/Com_build", "ui://TowerDefend/Com_build", "EP_button_tips_0002"
;("ui://TowerDefend/Com_build").iconURL = "8422.png"
fgui.register_extension[4], ("ui://TowerDefend/Com_build").skillName = "ui://TowerDefend/Com_build", "升级"
local config = fgui.register_extension
function Com_build:onInit()
	self:addClickListener(handler(self, self.onClickBuild))
end
function Com_build:initData(index, info, btnHandle)
	self.info = info
	self.btnHandle = btnHandle
	self.controllers.c1:setSelectedIndex(index - 1)
	if index == 2 or index == 3 then
		self.fields.Text_skill:setString(i18n(config[index].skillName))
	else
		self.fields.Text_skill:setString("")
	end
	self.fields.Text_cost:setString(info.cost)
	self:setCostTextColor()
end
function Com_build:setCostTextColor()
	if not self.info then
		return
	end
	if towerDefendRead.gold < self.info.cost then
		self.fields.Text_cost:setColor(cc.c3b(255, 0, 0))
	else
		self.fields.Text_cost:setColor(cc.c3b(255, 255, 255))
	end
end
function Com_build:onClickBuild()
	self.btnHandle(self.info)
end
function Com_build:onShow()
end
return Com_build

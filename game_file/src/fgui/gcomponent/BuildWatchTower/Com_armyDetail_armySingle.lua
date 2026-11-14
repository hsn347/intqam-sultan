local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_armySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_armySingle", Com_armyDetail_armySingle)
local lordLocalData = include("lordLocalData")
function Com_armyDetail_armySingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.armyData, _ENV = self.fixChildrenPos, self.fixChildrenPos
end
function Com_armyDetail_armySingle:onShow()
end
function Com_armyDetail_armySingle:initData(armyData)
	self.armyData = armyData
	if self.armyData.name then
		self.fields.txtName:setString(self.armyData.name)
	else
		self.fields.txtName:setString("")
	end
	if self.armyData.level then
		_ENV = nil
		;(nil).lv = self.armyData.level
		self.fields.txtLevel:setString(i18n("common_text_2485", nil))
	else
		_ENV = i18n("common_text_2485", nil)
		i18n("common_text_2485", nil).level = WATCH_TOWER_VIEW_LORD_LV
		self.fields.txtLevel:setString(i18n("common_text_596", i18n("common_text_2485", nil)))
	end
	if self.armyData.headid then
		SoraDGetHeadFromManager(self.fields.imgHead, self.armyData.headid, self.armyData.avatar)
	end
	if self.armyData.totalCount then
		self.fields.txtTotalPower:setString(self.armyData.totalCount)
	else
		_ENV = i18n("common_text_596", i18n("common_text_2485", nil))
		i18n("common_text_596", i18n("common_text_2485", nil)).level = WATCH_TOWER_VIEW_ARMYTOTALCOUNT
		self.fields.txtTotalPower:setString(i18n("common_text_596", i18n("common_text_596", i18n("common_text_2485", nil))))
	end
end
return Com_armyDetail_armySingle

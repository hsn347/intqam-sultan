local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteSolutionsPanel = class("MeteoriteSolutionsPanel", baseFguiPanel)
local cityCtrl = SoraDGetCtrl("cityCtrl")
local meteorMagicRead = include("meteorMagicRead")
function MeteoriteSolutionsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MeteoriteSolutionsPanel:ctor", self.viewName)
end
function MeteoriteSolutionsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteSolutionsPanel:onInit()
	print("=======MeteoriteSolutionsPanel:onInit")
	self.buildLv = cityCtrl:getBuildMaxLv(BUILDID.NEBULA_PALACE)
	self.curProjectID = self.param.curProjectID
	self.changeHandler = self.param.changeHandler
	self.fields.Panel_bg:setTitle(i18n("meteoritesmagic_text_10"))
	self.configs = meteorMagicRead.getMagicPlans()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function MeteoriteSolutionsPanel:onShow()
	print("=======MeteoriteSolutionsPanel:onShow")
	self:updateView()
end
function MeteoriteSolutionsPanel:updateView()
	self.fields.scroll:setNumItems(#self.configs)
end
function MeteoriteSolutionsPanel:onItemRenderer(index, obj)
	obj:initData(self.configs[index + 1], self.curProjectID == index + 1, self.buildLv >= self.configs[index + 1].activateLv)
	obj:setClickHandler(handler(self, self.onChoosePorject))
end
function MeteoriteSolutionsPanel:onChoosePorject(projectID)
	if self.changeHandler and self.curProjectID ~= projectID then
		self.changeHandler(projectID)
	end
	self:close()
end
return MeteoriteSolutionsPanel

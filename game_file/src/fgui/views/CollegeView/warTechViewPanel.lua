local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local warTechViewPanel = class("warTechViewPanel", baseFguiPanel)
function warTechViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("warTechViewPanel:ctor", self.viewName)
end
function warTechViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function warTechViewPanel:onInit()
	print("=======warTechViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.fields.Com_title:initData(i18n("common_text_3905"), handler(self, self.onClickClose))
end
function warTechViewPanel:onShow()
	print("=======warTechViewPanel:onShow")
	self:initTechType()
end
function warTechViewPanel:endShow()
	guideCtrl:updateGuideModule(gGuideModule.WAR_TECH)
end
function warTechViewPanel:initTechType()
	if IsArClient then
		_UPVALUE5_ = IsArClient
		IsArClient[1] = TECHNOLOGY_ATTR.wartechnology
		IsArClient[2] = TECHNOLOGY_ATTR.warbattle
		IsArClient[3] = TECHNOLOGY_ATTR.warmilitary
		IsArClient[4] = TECHNOLOGY_ATTR.warcommand
		local IsArClient[5], techArrar = TECHNOLOGY_ATTR.warlight, IsArClient
		for i = 1, 5 do
			self.fields["n" .. i]:initData(techArrar[i])
		end
	else
		_UPVALUE3_ = IsArClient
		IsArClient[1] = TECHNOLOGY_ATTR.wartechnology
		IsArClient[2] = TECHNOLOGY_ATTR.warbattle
		local IsArClient[3], techArrar = TECHNOLOGY_ATTR.warcommand, IsArClient
		self.fields.n1:setVisible(false)
		self.fields.n5:setVisible(false)
		for i = 1, 3 do
			self.fields["n" .. i + 1]:initData(techArrar[i])
		end
	end
	self:updateStudy()
end
function warTechViewPanel:updateStudy(target, data)
	self.tableStuding, self.studyingType = technologyCtrl:studyingTechnology(gQueueTypeDef.war_tech_research)
	self.fields.Com_studying:setVisible(self.tableStuding ~= nil)
	if self.tableStuding then
		self.fields.Com_studying:initData(self.tableStuding, self.studyingType)
	end
	if data then
		for i = 1, 5 do
			if self.fields["n" .. i]:isVisible() then
				self.fields["n" .. i]:refresh()
			end
		end
	end
end
function warTechViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "wartechnology" then
		for i = 1, 5 do
			if self.fields["n" .. i]:isVisible() and self.fields["n" .. i]:getTechType() == TECHNOLOGY_ATTR.wartechnology then
				return self.fields["n" .. i]
			end
		end
	end
	return self.fields[itemName]
end
return warTechViewPanel

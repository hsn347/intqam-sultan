local collegeDesRead = include("collegeDesRead")
local buildDescribeRead = include("buildDescribeRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local warTechTypeSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CollegeView/warTechTypeSingle", warTechTypeSingle)
function warTechTypeSingle:onInit()
	self.buildTip = nil
	self.starTip = nil
	self.lockStatus = false
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function warTechTypeSingle:onShow()
end
function warTechTypeSingle:initData(techType)
	self.techType = techType
	self.fields.Sprite_icon:setSpriteFrame(collegeDesRead.getTechTypeIcon(self.techType))
	self.fields.Text_name:setString(i18n(collegeDesRead.getTechTypeName(self.techType)))
	self.techData = technologyCtrl:getTechnologyDataByType(self.techType)
	self.tableStuding, self.studyingType = technologyCtrl:studyingTechnology(gQueueTypeDef.war_tech_research)
	self.lockStatus = false
	if self.tableStuding then
		if self.studyingType == self.techType then
			self:setStudying()
		elseif self:checkIsUnlock(self.techType) then
			self:setCanStudy()
		else
			self:setCannotStudy()
			self.lockStatus = true
		end
	elseif self:checkIsUnlock(self.techType) then
		self:setCanStudy()
	else
		self:setCannotStudy()
		self.lockStatus = true
	end
end
function warTechTypeSingle:refresh()
	self:initData(self.techType)
end
function warTechTypeSingle:setCanStudy()
	self.controllers.c1:setSelectedIndex(0)
end
function warTechTypeSingle:setStudying()
	self.controllers.c1:setSelectedIndex(1)
end
function warTechTypeSingle:setCannotStudy()
	self.controllers.c1:setSelectedIndex(2)
end
function warTechTypeSingle:updateData(techType)
	self.techType = techType or self.techType
	self:initData(self.techType)
end
function warTechTypeSingle:checkIsUnlock(techType)
	local ret = true
	buildDescribeRead = techType
	techType[1] = "bid"
	techType[2] = "lv"
	local buildConfig = serviceFunctions.tableFormat(collegeDesRead.getTechTypeBuild(techType), techType)
	buildDescribeRead = techType
	techType[1] = "bid"
	techType[2] = "lv"
	local starBuildConfig = serviceFunctions.tableFormat(collegeDesRead.getTechTypeStarBuild(techType), techType)
	for k, v in ipairs(buildConfig) do
		local curLv = SoraDGetBuildLv(v.bid)
		if curLv < v.lv then
			ret = false
			local buildLogic = include("buildLogic")
			local warLv = buildLogic.transformBuildLvToWarLv(v.lv)
			if 0 < warLv then
				_ENV = nil
				;(nil).build = buildDescribeRead.getName(v.bid)
				_ENV = nil
				;(nil).lv = warLv
				;(nil).lv = i18n("common_text_1948", nil)
				self.buildTip = i18n("overview_text_01", nil)
				break
			end
			_ENV = nil
			;(nil).build = buildDescribeRead.getName(v.bid)
			;(nil).lv = v.lv
			self.buildTip = i18n("overview_text_01", nil)
			break
		end
	end
	if ret then
		for k, v in ipairs(starBuildConfig) do
			local curLv = SoraDGetBuildStarLv(v.bid)
			if curLv < v.lv then
				ret = false
				_ENV = i18n("overview_text_01", nil)
				i18n("overview_text_01", nil).lv = v.lv
				self.starTip = i18n("gemEnchant_text_13", (i18n("overview_text_01", nil)))
				break
			end
		end
	end
	return ret
end
function warTechTypeSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.lockStatus then
		if self.buildTip then
			SoraDShowMsgTip(self.buildTip)
		elseif self.starTip then
			SoraDShowMsgTip(self.starTip)
		end
	else
		_ENV = nil
		;(nil).techType = self.techType
		uiManager:show("warTechnologyView", nil)
	end
end
function warTechTypeSingle:getTechType()
	return self.techType
end
return warTechTypeSingle

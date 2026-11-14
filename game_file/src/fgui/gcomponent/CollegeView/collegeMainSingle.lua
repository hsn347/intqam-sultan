local collegeDesRead = include("collegeDesRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local collegeMainSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CollegeView/collegeMainSingle", collegeMainSingle)
function collegeMainSingle:onInit()
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function collegeMainSingle:onShow()
end
function collegeMainSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.unlock))
end
function collegeMainSingle:initData(techType)
	self.techType = techType
	local cfg = collegeDesRead.getTypeTitleIcon(self.techType)
	if cfg then
		self.fields.Sprite_icon:setSpriteFrame(cfg.icon)
		self.fields.Text_name:setString(i18n(cfg.title))
	end
	self:unlock()
	self:setEffectVisible()
end
function collegeMainSingle:getTechType()
	return self.techType
end
function collegeMainSingle:setEffectVisible()
	local tableStuding, studyingType = technologyCtrl:studyingTechnology()
	if self:unlock() and tableStuding and studyingType == self.techType then
		self.controllers.c1:setSelectedIndex(1)
	end
end
function collegeMainSingle:unlock()
	local ret = true
	if self.techType == TECHNOLOGY_ATTR.soldier then
		if SoraDGetCastleLv() < CASTLE_LV16_LIMITED then
			self.controllers.c1:setSelectedIndex(2)
			ret = false
		end
	elseif self.techType == TECHNOLOGY_ATTR.leader then
		if SoraDGetBuildLv(BUILDID.COLLEGE) < CASTLE_LV40_LIMITED then
			self.controllers.c1:setSelectedIndex(2)
			ret = false
		end
	elseif self.techType == TECHNOLOGY_ATTR.hero then
		if SoraDGetCastleLv() < CASTLE_LV7_LIMITED then
			self.controllers.c1:setSelectedIndex(2)
			ret = false
		end
	elseif self.techType == TECHNOLOGY_ATTR.advancedmilitary then
		if SoraDGetBuildLv(BUILDID.COLLEGE) < CASTLE_LV40_LIMITED then
			self.controllers.c1:setSelectedIndex(2)
			ret = false
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	return ret
end
function collegeMainSingle:btnClickCallBack()
	SoraDPlaySound()
	local collegeType = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("collegeMainSingle", "collegeType")
	if collegeType and collegeType ~= self.techType then
		gModuleMgr.sharedMgr("mildGuideManager"):clean()
	end
	if self:unlock() then
		_ENV = nil
		;(nil).techType = self.techType
		uiManager:show("collegeStudyingView", nil)
	elseif self.techType == TECHNOLOGY_ATTR.soldier then
		_ENV = nil
		;(nil).build = i18n("common_text_3129")
		SoraDShowMsgTip(i18n("common_text_3296", nil))
	elseif self.techType == TECHNOLOGY_ATTR.leader then
		SoraDShowMsgTip(i18n("common_text_4039"))
	elseif self.techType == TECHNOLOGY_ATTR.hero then
		_ENV = i18n("common_text_4039")
		i18n("common_text_4039").lv = CASTLE_LV7_LIMITED
		SoraDShowMsgTip(i18n("common_text_3868", i18n("common_text_4039")))
	elseif self.techType == TECHNOLOGY_ATTR.advancedmilitary then
		SoraDShowMsgTip(i18n("common_text_4039"))
	end
end
return collegeMainSingle

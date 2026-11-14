local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillSelectPanel = class("RoaringFlame_SkillSelectPanel", baseFguiPanel)
function RoaringFlame_SkillSelectPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_SkillSelectPanel.super.ctor(self, ...)
	print("RoaringFlame_SkillSelectPanel:ctor", self.viewName)
end
function RoaringFlame_SkillSelectPanel:onInit()
	print("=======RoaringFlame_SkillSelectPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Promise_Summit_text_41"))
	self.fields.List:setItemRenderer(handler(self, self.onGroupRenderer))
end
function RoaringFlame_SkillSelectPanel:endShow()
	print("=======RoaringFlame_SkillSelectPanel:endShow")
	self.curSortType = 1
	self.warType = self.param.warType or gKingdomClassType.roaringFlame
	self.maxNum = self:getSkillTimesMax()
	_ENV = nil
	;(nil).color = "#FFD43E"
	local maxNumStr = SoraDWrapHtmlTagByStyle(self.maxNum, nil)
	_ENV = nil
	;(nil).num = maxNumStr
	self.fields.Text_tip:setString(i18n("flames_dunes_text368", nil))
	self:updateProgress()
	self:updateGroupList()
end
function RoaringFlame_SkillSelectPanel:onGroupRenderer(index, obj)
	local key = self.groupKeys[index + 1]
	obj:initData2(self.groupList[key], key, self.curSortType, self.param.skillIdx, self.warType)
end
function RoaringFlame_SkillSelectPanel:updateGroupList(...)
	self.groupList = self:getShowData()
	self.groupKeys = table.keys(self.groupList)
	table.sort(self.groupKeys)
	self.fields.List:setNumItems(#self.groupKeys)
end
function RoaringFlame_SkillSelectPanel:getShowData()
	local _ENV, newConfig
	if self.warType == gKingdomClassType.atlantis then
		local atlantisActivityRead = include("atlantisActivityRead")
		local config = atlantisActivityRead.getSkillDisplay()
		for k, v in pairs(config) do
			if atlantisActivityRead.getIsAddSkill(v.skillID) then
				newConfig[k] = v
			end
		end
	else
		local config = roaringFlameWarRead.getSkillDisplay()
		for k, v in pairs(config) do
			if roaringFlameWarRead.getIsAddSkill(v.skillID) then
				newConfig[k] = v
			end
		end
	end
	return roaringFlameWarRead.getSkillShowData(self.curSortType, newConfig)
end
function RoaringFlame_SkillSelectPanel:updateProgress()
	local curNum = self:getUsedSkillTimes()
	local curNumStr = ""
	local maxNumStr = tostring(self.maxNum)
	self.isEnough = curNum >= self.maxNum
	if self.isEnough then
		_ENV = nil
		;(nil).color = "#00FF00"
		curNumStr = SoraDWrapHtmlTagByStyle(curNum, nil)
		_ENV = nil
		;(nil).color = "#00FF00"
		maxNumStr = SoraDWrapHtmlTagByStyle(self.maxNum, nil)
	else
		_ENV = nil
		;(nil).color = "#FFD43E"
		curNumStr = SoraDWrapHtmlTagByStyle(curNum, nil)
	end
	_ENV = nil
	;(nil).num = curNumStr
	;(nil).maxnum = maxNumStr
	self.fields.Text_progress:setString(i18n("flames_dunes_text364", nil))
end
function RoaringFlame_SkillSelectPanel:getSkillTimesMax()
	if self.warType == gKingdomClassType.atlantis then
		local atlantisActivityRead = include("atlantisActivityRead")
		return atlantisActivityRead.getConstValue("ATLANTISWAR_SKILL_TIME", 60)
	else
		return roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_TIME", 100)
	end
end
function RoaringFlame_SkillSelectPanel:getUsedSkillTimes()
	if self.warType == gKingdomClassType.atlantis then
		local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
		return atlantisActivityCtrl:getUsedSkillTimes()
	else
		return roaringFlameWarCtrl:getUsedSkillTimes()
	end
end
return RoaringFlame_SkillSelectPanel

local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushSkillChoosePanel = class("SoldierRushSkillChoosePanel", baseFguiPanel)
function SoldierRushSkillChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushSkillChoosePanel:ctor", self.viewName)
end
function SoldierRushSkillChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushSkillChoosePanel:onInit()
	print("=======SoldierRushSkillChoosePanel:onInit")
	self.curIndex = 1
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_17"))
	self.fields.Text_title:setString(i18n("携带技能"))
	self.fields.Text_tip:setString(i18n("soldier_rush_text_13"))
	self.fields.Com_info:setVisible(false)
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.onClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO"
		SoraDSendMessage(nil)
	end)
end
function SoldierRushSkillChoosePanel:onItemRenderer(index, obj)
	obj:initData(self.skillList[index + 1])
end
function SoldierRushSkillChoosePanel:updateSlotIndex(target, data)
	self.curIndex = data.index
	self.fields.Com_skill:updateIndex(self.curIndex)
end
function SoldierRushSkillChoosePanel:updateSkill(target, data)
	if data and data.index then
		self.fields.Com_skill:updateData(self.curIndex, data.index)
	else
		self.fields.Com_skill:updateData(self.curIndex)
	end
end
function SoldierRushSkillChoosePanel:showSkillInfo(target, data)
	if data and data.index then
		self.fields.Com_info:setVisible(true)
		self.fields.Com_info:initData(data.index)
	else
		self.fields.Com_info:setVisible(false)
	end
end
function SoldierRushSkillChoosePanel:onShow()
	print("=======SoldierRushSkillChoosePanel:onShow")
	self.curIndex = self.param.index
	self.fields.Com_skill:initData(self.curIndex)
	local skillCfgList = soldierRushRead.getAllSkillCfg()
	self.skillList, _ENV = self.fields.Com_skill, self.fields.Com_skill
	for k, v in ipairs(skillCfgList) do
		local heroInfo = heroCtrl:getHeroInfoByID(v.HeroId)
		if heroInfo then
			if v.SkillQuality == heroInfo.quality then
				table.insert(self.skillList, v)
			end
		elseif v.SkillQuality == gHeroQuality.WHITE then
			v.none = true
			table.insert(self.skillList, v)
		end
	end
	local skillSlotData = soldierRushCtrl:getSkillSlot()
	table.sort(self.skillList, function(a, b)
		if not a.none and not b.none then
			if skillSlotData[a.Index] and skillSlotData[b.Index] then
				if a.SkillQuality == b.SkillQuality then
					return a.Index < b.Index
				else
					return a.SkillQuality > b.SkillQuality
				end
			else
			end
		elseif a.none and b.none then
			return a.Index < b.Index
		else
			return not a.none
		end
	end)
	self.fields.List:setNumItems(#self.skillList)
end
function SoldierRushSkillChoosePanel:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("是否保存该技能配置")
	;(nil).confirmString = i18n("common_text_195")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		local skillSlotData = self.fields.Com_skill:outPutData()
		soldierRushCtrl:setSkillSlot(skillSlotData)
		self:close()
	end
	uiManager:show("MessageBox", nil)
end
return SoldierRushSkillChoosePanel

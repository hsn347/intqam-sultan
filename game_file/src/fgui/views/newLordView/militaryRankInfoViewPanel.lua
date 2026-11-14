local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local lordLocalData = include("lordLocalData")
local militaryRankRead = include("militaryRankRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryRankInfoViewPanel = class("militaryRankInfoViewPanel", baseFguiPanel)
function militaryRankInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryRankInfoViewPanel:ctor", self.viewName)
end
function militaryRankInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function militaryRankInfoViewPanel:onInit()
	print("=======militaryRankInfoViewPanel:onInit")
	self.skillList, _ENV, self.effectList, _ENV, self.tableRankData, _ENV, self.tablePlayerInfo, _ENV = print, print, print, print, print, print, print, print
	self.fields.Com_title:initData(i18n("common_text_2396"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_touchPopupLevel:addClickListener(handler(self, self.onBtnRankClick))
	self.fields.title_1:setString(i18n("common_text_2396"))
	self.fields.title_2:setString(i18n("common_text_2401"))
	self.fields.Text_no1:setString(i18n("common_text_2403"))
	self.fields.Text_no1:setVisible(false)
	self.fields.Text_no2:setString(i18n("common_text_2404"))
	self.fields.Text_no2:setVisible(false)
	self.fields.List_1:setItemRenderer(handler(self, self.onAddRenderer))
	self.fields.List_2:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.Text_rank:fixPos()
	self.fields.Sprite_rank:fixPos()
end
function militaryRankInfoViewPanel:onShow()
	print("=======militaryRankInfoViewPanel:onShow")
	self:initData()
end
function militaryRankInfoViewPanel:initData()
	self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
	self.tableRankData = militaryRankCtrl:getMilitaryEffectData()
	SoraDGetHeadFromManager(self.fields.Com_head, self.tablePlayerInfo.base.imageId, self.tablePlayerInfo.base.avatar)
	self.fields.Text_rank:setString(militaryRankRead.getRankNameByLv(self.tablePlayerInfo.militaryRankInfo.level))
	self.fields.Sprite_rank:setSpriteFrame(militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level))
	self.effectList, lordInfoCtrl = self.fields.Sprite_rank.setSpriteFrame, self.fields.Sprite_rank.setSpriteFrame
	for i, v in ipairs(self.tableRankData.effect) do
		lordInfoCtrl = militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level)
		militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level).name = buffDesRead.getTitleWithValue(v.id, nil) .. "  :"
		militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level).value = buffDesRead.getTitleValueWithValue(v.id, v.num)
		table.insert(self.effectList, militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level))
	end
	self.fields.Text_no1:setVisible(#self.effectList == 0)
	self.fields.List_1:setNumItems(#self.effectList)
	self.skillList = self.tableRankData.skills
	self.fields.Text_no2:setVisible(#self.skillList == 0)
	self.fields.List_2:setNumItems(#self.skillList)
end
function militaryRankInfoViewPanel:onAddRenderer(index, obj)
	obj:initData(self.effectList[index + 1], index + 1)
end
function militaryRankInfoViewPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillList[index + 1])
end
function militaryRankInfoViewPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("militaryRankLevelView")
end
function militaryRankInfoViewPanel:onBtnRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).level = self.tablePlayerInfo.militaryRankInfo.level
	uiManager:show("militaryRankLevelView", nil)
end
return militaryRankInfoViewPanel

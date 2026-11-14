local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local lordLocalData = include("lordLocalData")
local militaryRankRead = include("militaryRankRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryRankViewPanel = class("militaryRankViewPanel", baseFguiPanel)
function militaryRankViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryRankViewPanel:ctor", self.viewName)
end
function militaryRankViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function militaryRankViewPanel:onInit()
	print("=======militaryRankViewPanel:onInit")
	self.rewardList, _ENV, self.titleList, _ENV, self.tablePlayerInfo, _ENV = print, print, print, print, print, print
	if IsArClient then
		self.fields.Com_title:initData(i18n("common_text_2393"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	else
		self.fields.Com_title:initData(i18n("common_text_2393"), handler(self, self.onClickClose))
	end
	self.fields.Button_military_rank_effect:setString(i18n("Military_btn_01"))
	self.fields.Button_military_rank_effect:addClickListener(handler(self, self.onBtnEffectClick))
	self.fields.Button_military_rank_exchange:setString(i18n("Military_btn_02"))
	self.fields.Button_military_rank_exchange:addClickListener(handler(self, self.onBtnExchangeClick))
	self.fields.btn_marshalSetting:addClickListener(handler(self, self.onBtnMarshalSetClick))
	self.fields.Button_touchPopupLevel:addClickListener(handler(self, self.onBtnRankClick))
	self.fields.Com_rewardTitle:setString(i18n("common_text_854"))
	self.fields.Text_noReward:setString(i18n("common_text_2479"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_title:setItemRenderer(handler(self, self.onTitleRenderer))
	self.fields.Button_list:setString(i18n("common_text_2395"))
	self.fields.Button_list:addClickListener(handler(self, self.onBtnListClick))
	self.fields.Button_get:setString(i18n("common_text_2394"))
	self.fields.Button_get:addClickListener(handler(self, self.onBtnGetClick))
	self.fields.Button_military_rank_effect:fixPos()
	self.fields.Button_military_rank_exchange:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Sprite_rank:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.nfrom:fixPos()
	self.fields.nto:fixPos()
	self.fields.Text_fromLv:fixPos()
	self.fields.Text_toLv:fixPos()
	self.fields.Button_list:fixPos()
	self.fields.Button_get:fixPos()
	self.fields.btn_marshalSetting:fixPos()
end
function militaryRankViewPanel:onShow()
	print("=======militaryRankViewPanel:onShow")
	militaryRankCtrl:sendOpenPage()
end
function militaryRankViewPanel:initData()
	SoraDCloseLoading(self)
	self:initBaseView()
	self:initReward()
	self:setTitleList()
end
function militaryRankViewPanel:onItemRenderer(index, obj)
	local itemData = self.rewardList[index + 1]
	obj:initData(itemData.id, itemData.count)
end
function militaryRankViewPanel:onTitleRenderer(index, obj)
	obj:initData(self.titleList[index + 1])
end
function militaryRankViewPanel:initBaseView()
	self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
	SoraDGetHeadFromManager(self.fields.Com_head, self.tablePlayerInfo.base.imageId, self.tablePlayerInfo.base.avatar)
	self.fields.Text_rank:setString(militaryRankRead.getRankNameByLv(self.tablePlayerInfo.militaryRankInfo.level))
	self.fields.Sprite_rank:setSpriteFrame(militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level))
	local nextLv = math.min(militaryRankRead.getRankMax(), self.tablePlayerInfo.militaryRankInfo.level + 1)
	local curLv = nextLv - 1
	self.fields.Text_fromLv:setString(tostring(curLv))
	self.fields.Text_toLv:setString(tostring(nextLv))
	self.fields.Bar:setMax(militaryRankRead.getRankNeedPoint(nextLv))
	self.fields.Bar:setValue(self.tablePlayerInfo.militaryRankInfo.totalpoints)
	lordInfoCtrl = militaryRankRead.getRankNeedPoint(nextLv)
	militaryRankRead.getRankNeedPoint(nextLv).member = string.formatnumberthousands(self.tablePlayerInfo.militaryRankInfo.totalpoints)
	militaryRankRead.getRankNeedPoint(nextLv).total = string.formatnumberthousands(militaryRankRead.getRankNeedPoint(nextLv))
	self.fields.Text_pro:setString(i18n("common_text_155", militaryRankRead.getRankNeedPoint(nextLv)))
end
function militaryRankViewPanel:initReward()
	self.rewardList, _ENV = nil, nil
	local lastRank = self.tablePlayerInfo.militaryRankInfo.lastRank or 0
	local curRank = self.tablePlayerInfo.militaryRankInfo.curRank
	local level = self.tablePlayerInfo.militaryRankInfo.level
	local lastLevel = self.tablePlayerInfo.militaryRankInfo.lastLevel
	lastRank = lastRank < 0 and 0 or lastRank
	if lastRank <= 0 then
		self.fields.Text_noReward:setVisible(true)
		self.fields.List_reward:setVisible(false)
	else
		self.fields.Text_noReward:setVisible(false)
		self.fields.List_reward:setVisible(true)
		lastRank = lastRank and 0 < lastRank and lastRank <= RANK_MILITARY_MAX_SHOW and self.tablePlayerInfo.militaryRankInfo.lastRank or RANK_MILITARY_MAX_SHOW + 1
		self.rewardList = militaryRankRead.getRewardCfg(lastRank)
		self.fields.List_reward:setNumItems(#self.rewardList)
	end
	self.fields.Button_get:setEnabled(not self.tablePlayerInfo.militaryRankInfo.gotReward and self.tablePlayerInfo.militaryRankInfo.lastRank > 0)
	self.fields.Button_get:setString(self.tablePlayerInfo.militaryRankInfo.gotReward and self.tablePlayerInfo.militaryRankInfo.lastRank > 0 and i18n("common_text_1892") or i18n("common_text_2394"))
end
function militaryRankViewPanel:setTitleList()
	local curRankStr = militaryRankRead.getRankStr(self.tablePlayerInfo.militaryRankInfo.curRank)
	local lastRankStr = militaryRankRead.getRankStr(self.tablePlayerInfo.militaryRankInfo.lastRank, 200)
	militaryRankRead, militaryRankRead = 200, self.tablePlayerInfo.militaryRankInfo.lastRank
	militaryRankRead = nil
	;(nil).lv = ""
	;(200).name = i18n("common_text_2392", nil)
	;(200).value = self.tablePlayerInfo.militaryRankInfo.level
	militaryRankRead, self.tablePlayerInfo.militaryRankInfo.lastRank[1], (200).model = 200, 200, 0
	militaryRankRead = nil
	;(nil).point = ""
	;(200).name = i18n("common_text_2803", nil)
	;(200).value = string.formatnumberthousands(self.tablePlayerInfo.militaryRankInfo.points)
	militaryRankRead, self.tablePlayerInfo.militaryRankInfo.lastRank[2], (200).model = 200, 200, 0
	militaryRankRead = nil
	;(nil).rank = ""
	;(200).name = i18n("common_text_2397", nil)
	;(200).value = curRankStr
	militaryRankRead, self.tablePlayerInfo.militaryRankInfo.lastRank[3], (200).model = 200, 200, 0
	militaryRankRead = nil
	;(nil).rank = ""
	;(200).name = i18n("common_text_2398", nil)
	;(200).value = lastRankStr
	militaryRankRead, self.tablePlayerInfo.militaryRankInfo.lastRank[4], (200).model = 200, 200, 0
	militaryRankRead = nil
	;(nil).point = ""
	;(200).name = i18n("common_text_2399", nil)
	;(200).value = string.formatnumberthousands(self.tablePlayerInfo.militaryRankInfo.totalpoints)
	;(200).icon = "icon_military_level.png"
	militaryRankRead, self.tablePlayerInfo.militaryRankInfo.lastRank[5], (200).model = 200, 200, 1
	militaryRankRead = nil
	;(nil).point = ""
	;(200).name = i18n("common_text_2400", nil)
	;(200).value = string.formatnumberthousands(self.tablePlayerInfo.militaryRankInfo.exploit)
	;(200).icon = "icon_military_point.png"
	self.titleList, self.tablePlayerInfo.militaryRankInfo.lastRank[6], (200).model = self.tablePlayerInfo.militaryRankInfo.lastRank, 200, 1
	local level = self.tablePlayerInfo.militaryRankInfo.level
	local lastLevel = self.tablePlayerInfo.militaryRankInfo.lastLevel
	local lastRank = self.tablePlayerInfo.militaryRankInfo.lastRank or 0
	lastRank = lastRank < 0 and 0 or lastRank
	if lastLevel and lastRank and level < lastLevel then
		local lastRankName = militaryRankRead.getRankNameByLv(lastLevel)
		local curRankName = militaryRankRead.getRankNameByLv(level)
		militaryRankRead = nil
		militaryRankRead = nil
		;(nil).rank = lastRank
		;(nil).militaryRank = lastRankName
		;(nil).curMilitary = curRankName
		;(nil).name = i18n("Military_text_01", nil)
		;(nil).model = 2
		table.insert(self.titleList, nil)
	end
	self.fields.List_title:setNumItems(#self.titleList)
end
function militaryRankViewPanel:onBtnEffectClick()
	SoraDPlaySound()
	uiManager:show("militaryRankInfoView")
end
function militaryRankViewPanel:onBtnExchangeClick()
	SoraDPlaySound()
	uiManager:show("militaryRankSkillView")
end
function militaryRankViewPanel:onBtnRankClick()
	SoraDPlaySound()
	if self.tablePlayerInfo and self.tablePlayerInfo.militaryRankInfo then
		_ENV = nil
		;(nil).level = self.tablePlayerInfo.militaryRankInfo.level
		uiManager:show("militaryRankLevelView", nil)
	end
end
function militaryRankViewPanel:onBtnListClick()
	SoraDPlaySound()
	uiManager:show("militaryRankRewardView")
end
function militaryRankViewPanel:onBtnGetClick()
	SoraDPlaySound()
	militaryRankCtrl:sendGetReward()
	SoraDShowLoading(self)
end
function militaryRankViewPanel:onBtnMarshalSetClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isMarshal = self.tablePlayerInfo.militaryRankInfo.level >= MILITARY_MAX_LV
	uiManager:show("militaryMarshalSettingView", nil)
end
function militaryRankViewPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.MILITARY_RANK)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.MILITARY_RANK)
	end
end
return militaryRankViewPanel

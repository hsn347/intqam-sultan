local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_RewardViewPanel = class("RoaringFlame_RewardViewPanel", baseFguiPanel)
function RoaringFlame_RewardViewPanel:ctor(...)
	RoaringFlame_RewardViewPanel.super.ctor(self, ...)
	print("RoaringFlame_RewardViewPanel:ctor", self.viewName)
end
function RoaringFlame_RewardViewPanel:onInit()
	print("=======RoaringFlame_RewardViewPanel:onInit")
	self.tag = 1
	self.weekTag = 1
	self.seasonTag = 1
	self.rankList, _ENV, self.isInit = print, print, true
	self.fields.Com_title:initData(i18n("common_text_2194"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_weekCamp:setItemRenderer(handler(self, self.onWeekCampRenderer))
	self.fields.List_seasonCamp:setItemRenderer(handler(self, self.onSeasonCampRenderer))
	_ENV = self.fields.List_seasonCamp.setItemRenderer
	self.fields.List_seasonCamp.setItemRenderer[1] = i18n("flames_dunes_text329")
	self.fields.List_seasonCamp.setItemRenderer[2] = i18n("flames_dunes_text330")
	self.fields.List_seasonCamp.setItemRenderer[3] = i18n("flames_dunes_text332")
	_ENV, self.weekTipCfg, self.fields.List_seasonCamp.setItemRenderer[4] = self.fields.List_seasonCamp.setItemRenderer, self.fields.List_seasonCamp.setItemRenderer, i18n("flames_dunes_text331")
	self.fields.List_seasonCamp.setItemRenderer[1] = i18n("flames_dunes_text333")
	self.fields.List_seasonCamp.setItemRenderer[2] = i18n("flames_dunes_text334")
	self.fields.List_seasonCamp.setItemRenderer[3] = i18n("flames_dunes_text336")
	self.fields.List_seasonCamp.setItemRenderer[4] = i18n("flames_dunes_text335")
	_ENV, _ENV, self.seasonTipCfg, self.fields.List_seasonCamp.setItemRenderer[5] = i18n("flames_dunes_text337"), self.fields.List_seasonCamp.setItemRenderer, self.fields.List_seasonCamp.setItemRenderer, i18n("flames_dunes_text337")
	i18n("flames_dunes_text337").title = i18n("flames_dunes_text39")
	_ENV, self.fields.List_seasonCamp.setItemRenderer[1], i18n("flames_dunes_text337").icon = i18n("flames_dunes_text337"), i18n("flames_dunes_text337"), "icon_shmc_title_01.png"
	i18n("flames_dunes_text337").title = i18n("flames_dunes_text36")
	_ENV, self.fields.List_seasonCamp.setItemRenderer[2], i18n("flames_dunes_text337").icon = i18n("flames_dunes_text337"), i18n("flames_dunes_text337"), "icon_shmc_title_02.png"
	i18n("flames_dunes_text337").title = i18n("flames_dunes_text35")
	self.titleCfg, self.fields.List_seasonCamp.setItemRenderer[3], i18n("flames_dunes_text337").icon = self.fields.List_seasonCamp.setItemRenderer, i18n("flames_dunes_text337"), "icon_shmc_title_04.png"
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("flames_dunes_text314", nil)
	end)
	self.fields.Label_time:setTimeEndListener(function()
		self:refreshList()
	end)
	self.fields.Label_time:setVisible(false)
end
function RoaringFlame_RewardViewPanel:onItemProvider(index)
	if self.isPersonHonor then
		return "ui://RoaringFlame/Com_weekCampSingle"
	else
		return "ui://RoaringFlame/Com_rankSingle"
	end
end
function RoaringFlame_RewardViewPanel:onItemRenderer(index, obj)
	_UPVALUE0_ = index + 1
	;(index + 1).isPersonHonor = self.isPersonHonor
	obj:initData(self.rankList[index + 1], index + 1)
end
function RoaringFlame_RewardViewPanel:onWeekCampRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1)
end
function RoaringFlame_RewardViewPanel:onSeasonCampRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1)
end
function RoaringFlame_RewardViewPanel:onShow()
	print("=======RoaringFlame_RewardViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	self.weekTag = self.param and self.param.weekTag or 1
	self.seasonTag = self.param and self.param.seasonTag or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("flames_dunes_text37")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("flames_dunes_text38")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_Tab:initView(nil)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = self, self.weekTag, self.weekTag
	self.title = i18n("flames_dunes_text39")
	_ENV, self.weekTag[1], self.tag = self, self, 1
	self.title = i18n("flames_dunes_text36")
	_ENV, self.weekTag[2], self.tag = self, self, 2
	self.title = i18n("flames_dunes_text35")
	_ENV, self.weekTag[3], self.tag = self, self, 3
	self.title = i18n("flames_dunes_text34")
	;(nil).tabsetArray, self.weekTag[4], self.tag = self.weekTag, self, 4
	;(nil).callback = handler(self, self.onTabWeekClick)
	self.fields.Com_Tab_week:initView(nil)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = self, self.seasonTag, self.seasonTag
	self.title = i18n("flames_dunes_text39")
	_ENV, self.seasonTag[1], self.tag = self, self, 1
	self.title = i18n("flames_dunes_text36")
	_ENV, self.seasonTag[2], self.tag = self, self, 2
	self.title = i18n("flames_dunes_text35")
	_ENV, self.seasonTag[3], self.tag = self, self, 3
	self.title = i18n("flames_dunes_text34")
	_ENV, self.seasonTag[4], self.tag = self, self, 4
	self.title = i18n("flames_dunes_text45")
	;(nil).tabsetArray, self.seasonTag[5], self.tag = self.seasonTag, self, 5
	;(nil).callback = handler(self, self.onTabSeasonClick)
	self.fields.Com_Tab_season:initView(nil)
end
function RoaringFlame_RewardViewPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if not self.isInit then
		self:refreshList()
	end
	self.isInit = false
end
function RoaringFlame_RewardViewPanel:onTabWeekClick(tag)
	self.weekTag = tag
	if self.tag == 1 then
		self:refreshList()
	end
end
function RoaringFlame_RewardViewPanel:onTabSeasonClick(tag)
	self.seasonTag = tag
	if self.tag == 2 then
		self:refreshList()
	end
end
function RoaringFlame_RewardViewPanel:refreshList()
	local detailTag = self.tag == 1 and self.weekTag or self.seasonTag
	self.isPersonHonor = self.tag == 1 and self.weekTag == 2 or self.tag == 2 and self.seasonTag == 2
	local tipCfg = self.tag == 1 and self.weekTipCfg or self.seasonTipCfg
	local isOther3 = detailTag <= 3
	self.controllers.c2:setSelectedIndex(isOther3 and 0 or 1)
	self.fields.List:setPositionY(isOther3 and 254 or 192)
	self.fields.List:setHeight(isOther3 and self.view:getHeight() - 353 or self.view:getHeight() - 291)
	if not roaringFlameWarRead.getRankList(self.tag, detailTag) then
		roaringFlameWarRead = roaringFlameWarRead.getRankList(self.tag, detailTag)
	end
	self.rankList = roaringFlameWarRead.getRankList(self.tag, detailTag)
	self.fields.Label_time:setVisible(false)
	if self.tag == 1 and detailTag == 1 then
		self.fields.List:setNumItems(0)
		self.fields.List:setVisible(false)
		self.fields.List_seasonCamp:setNumItems(0)
		self.fields.List_seasonCamp:setVisible(false)
		self.fields.List_weekCamp:setVisible(true)
		self.fields.List_weekCamp:setNumItems(#self.rankList)
	elseif self.tag == 2 and detailTag == 5 then
		self.fields.List:setNumItems(0)
		self.fields.List:setVisible(false)
		self.fields.List_weekCamp:setNumItems(0)
		self.fields.List_weekCamp:setVisible(false)
		self.fields.List_seasonCamp:setVisible(true)
		self.fields.List_seasonCamp:setNumItems(#self.rankList)
	else
		self.fields.List_weekCamp:setNumItems(0)
		self.fields.List_weekCamp:setVisible(false)
		self.fields.List_seasonCamp:setNumItems(0)
		self.fields.List_seasonCamp:setVisible(false)
		if self.tag == 1 and detailTag == 3 then
			local weekKillBeginTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE) + 604800
			local leftTime = weekKillBeginTime - serviceFunctions.systemTime()
			if 0 < leftTime then
				self.fields.List:setVisible(false)
				self.fields.List:setNumItems(0)
				self.fields.Label_time:setVisible(true)
				self.fields.Label_time:beginTime(leftTime)
			else
				self.fields.List:setVisible(true)
				self.fields.List:setNumItems(#self.rankList)
			end
		else
			self.fields.List:setVisible(true)
			self.fields.List:setNumItems(#self.rankList)
		end
	end
	self.fields.Text_tip:setString(tipCfg[detailTag])
	if detailTag <= 3 then
		self.fields.Lab_title:setTitle(self.titleCfg[detailTag].title)
		self.fields.Lab_title:setIcon(self.titleCfg[detailTag].icon)
	end
end
return RoaringFlame_RewardViewPanel

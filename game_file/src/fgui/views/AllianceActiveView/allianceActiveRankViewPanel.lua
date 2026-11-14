local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceActiveRankViewPanel = class("allianceActiveRankViewPanel", baseFguiPanel)
function allianceActiveRankViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceActiveRankViewPanel:ctor", self.viewName)
end
function allianceActiveRankViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceActiveRankViewPanel:onInit()
	print("=======allianceActiveRankViewPanel:onInit")
	self.rankList, _ENV = print, print
	self.bigTag = 1
	self.smallTag = 1
	self.fields.Panel_bg:setString(i18n("alliance_active_text_001"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_score:setString(i18n("alliance_active_text_005"))
	self.fields.Text_noRecrod:setString(i18n("herobattle_text_05"))
	self.fields.Text_noRecrod:setVisible(false)
	self.fields.Button_price:addClickListener(handler(self, self.btnPriceClick))
	self.fields.Button_price:setVisible(false)
	self.fields.Text_Tips:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
	self.fields.Button_price:fixPos()
end
function allianceActiveRankViewPanel:onShow()
	print("=======allianceActiveRankViewPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.bigTag, self.bigTag
	;(nil).title = i18n("common_text_069")
	_ENV, self.bigTag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("pyramid_btn_35")
	;(nil).tabsetArray, self.bigTag[2], (nil).tag = self.bigTag, nil, 2
	;(nil).callback = handler(self, self.onTabBigClick)
	self.fields.Com_tab:initView(nil)
end
function allianceActiveRankViewPanel:onTabBigClick(tag)
	self.bigTag = tag
	local _ENV, tabsetArray
	if self.bigTag == 1 then
		_ENV, _ENV = nil, self.bigTag
		;(nil).title = i18n("alliance_active_text_004")
		_ENV, self.bigTag[1], (nil).tag = nil, nil, 1
		;(nil).title = i18n("alliance_active_text_003")
		tabsetArray, self.bigTag[2], (nil).tag = self.bigTag, nil, 2
	else
		_ENV, _ENV = nil, self.bigTag
		;(nil).title = i18n("alliance_active_text_002")
		_ENV, self.bigTag[1], (nil).tag = nil, nil, 1
		;(nil).title = i18n("alliance_active_text_003")
		_ENV, self.bigTag[2], (nil).tag = nil, nil, 2
		;(nil).title = i18n("alliance_active_text_004")
		tabsetArray, self.bigTag[3], (nil).tag = self.bigTag, nil, 3
	end
	self.smallTag = 1
	_ENV = i18n("alliance_active_text_004")
	i18n("alliance_active_text_004").defaultClick = self.smallTag
	i18n("alliance_active_text_004").tabsetArray = tabsetArray
	i18n("alliance_active_text_004").callback = handler(self, self.onTabSmallClick)
	self.fields.com_TabW:initView((i18n("alliance_active_text_004")))
end
function allianceActiveRankViewPanel:onTabSmallClick(tag)
	self.smallTag = tag
	local isBoxShow = self.bigTag == 1 and self.smallTag == 2 or self.bigTag == 2 and self.smallTag < 3
	self.fields.Button_price:setVisible(isBoxShow)
	self.fields.Text_Tips:setVisible(isBoxShow)
	if self.bigTag == 2 then
		if self.smallTag == 1 then
			_ENV = nil
			;(nil).num = constantRead.getConstValue("ALLIANCE_DAYREWARD_RANK")
			if i18n("alliance_active_text_007", nil) then
				goto lbl_53
			end
		end
		_ENV = nil
		;(nil).num = constantRead.getConstValue("ALLIANCE_WEEKREWARD_RANK")
		::lbl_53::
		self.fields.Text_Tips:setString((i18n("alliance_active_text_009", nil)))
	end
	if self.bigTag == 1 then
		allianceActiveCtrl:getRank(self.smallTag)
	else
		allianceActiveCtrl:getMemberRank(self.smallTag)
	end
	SoraDShowLoading(self)
end
function allianceActiveRankViewPanel:onItemRenderer(index, obj)
	obj:setHeight(self.bigTag == 1 and 102 or 92)
	obj:initData(self.rankList[index + 1])
end
function allianceActiveRankViewPanel:updateRank(target, data)
	SoraDCloseLoading(self)
	if not data.rankData.rankInfo then
		_ENV = data.rankData.rankInfo
	end
	self.rankList = data.rankData.rankInfo
	if not data.rankData.selfInfo then
		local _ENV, selfInfo = data.rankData.selfInfo, data.rankData.selfInfo
	end
	self.fields.List:setNumItems(#self.rankList)
	self.fields.List:jumpToTop()
	self.fields.Text_noRecrod:setVisible(#self.rankList <= 0)
	self.fields.Com_self:setHeight(self.bigTag == 1 and 102 or 92)
	self.fields.Com_self:initData(selfInfo)
end
function allianceActiveRankViewPanel:btnPriceClick(target, eventType)
	SoraDPlaySound()
	if self.bigTag == 1 and self.smallTag == 2 then
		uiManager:show("allianceActiveRandRewardView")
	elseif self.smallTag < 3 then
		_ENV = nil
		;(nil).title = i18n(self.smallTag == 1 and "alliance_active_text_006" or "alliance_active_text_008")
		;(nil).awardList = allianceActiveltCtrl.getActiveMemberRankAward(self.smallTag)
		uiManager:show("CommonRankStageView", nil)
	end
end
return allianceActiveRankViewPanel

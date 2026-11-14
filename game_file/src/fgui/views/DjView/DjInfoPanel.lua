local djCtrl = SoraDGetCtrl("djCtrl")
local djRead = include("djRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjInfoPanel = class("DjInfoPanel", baseFguiPanel)
function DjInfoPanel:ctor(...)
	self.isLRU = true
	DjInfoPanel.super.ctor(self, ...)
	print("DjInfoPanel:ctor", self.viewName)
end
function DjInfoPanel:onInit()
	print("=======DjInfoPanel:onInit")
	self.fields.Com_title:initData(i18n("Anchor_text_73"), handler(self, self.onClickClose))
	self.fields.Text_cumuTitle:setString(i18n("Anchor_text_74"))
	self.fields.Text_cumuTitle:fixPos()
	self.fields.Text_cumuTime:fixPos()
end
function DjInfoPanel:endShow()
	print("=======DjInfoPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("Anchor_text_86")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Anchor_text_87")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
	djCtrl:reqGetselfInfo()
	SoraDShowLoading(self)
end
function DjInfoPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
end
function DjInfoPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.selfInfo = data.info
	self.fields.Text_cumuTime:setString(SoraDConvertSecondToString(self.selfInfo.listenTotalTime))
	_ENV, _ENV = self.fields.Text_cumuTime, self.fields.Text_cumuTime.setString
	self.fields.Text_cumuTime.title = i18n("Anchor_text_75")
	self.fields.Text_cumuTime.val = djRead.getMonthLvByExp(self.selfInfo.monthExp)
	self.fields.Text_cumuTime.enum = djRead.detailEnum.month_lv
	_ENV, self.fields.Text_cumuTime.setString[1], self.fields.Text_cumuTime.style = self.fields.Text_cumuTime, self.fields.Text_cumuTime, 1
	self.fields.Text_cumuTime.title = i18n("Anchor_text_76")
	_ENV, self.fields.Text_cumuTime.setString[2], self.fields.Text_cumuTime.val = self.fields.Text_cumuTime, self.fields.Text_cumuTime, string.formatnumberthousands(self.selfInfo.monthExp)
	self.fields.Text_cumuTime.title = i18n("Anchor_text_77")
	self.fields.Text_cumuTime.val = self.selfInfo.monthRank == 0 and "--" or self.selfInfo.monthRank
	self.fields.Text_cumuTime.setString[3], self.fields.Text_cumuTime.enum = self.fields.Text_cumuTime, djRead.detailEnum.mohth_rank
	local monthCfg = self.fields.Text_cumuTime.setString
	self.fields.group_month:initData(monthCfg)
	_ENV, _ENV = self.fields.group_month, self.fields.group_month.initData
	self.fields.group_month.title = i18n("Anchor_text_78")
	self.fields.group_month.val = djRead.getLifeLvByExp(self.selfInfo.exp)
	self.fields.group_month.enum = djRead.detailEnum.live_honor
	_ENV, self.fields.group_month.initData[1], self.fields.group_month.style = self.fields.group_month, self.fields.group_month, 2
	self.fields.group_month.title = i18n("Anchor_text_79")
	_ENV, self.fields.group_month.initData[2], self.fields.group_month.val = self.fields.group_month, self.fields.group_month, string.formatnumberthousands(self.selfInfo.exp)
	self.fields.group_month.title = i18n("Anchor_text_80")
	self.fields.group_month.val = self.selfInfo.totalRank == 0 and "--" or self.selfInfo.totalRank
	self.fields.group_month.initData[3], self.fields.group_month.enum = self.fields.group_month, djRead.detailEnum.live_rank
	local liveCfg = self.fields.group_month.initData
	self.fields.group_live:initData(liveCfg)
	self.fields.Com_month:initData(self.selfInfo)
	self.fields.Com_live:initData(self.selfInfo)
end
return DjInfoPanel

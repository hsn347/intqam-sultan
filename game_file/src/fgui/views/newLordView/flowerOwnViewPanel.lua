local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local flowerSysCtrl = SoraDGetCtrl("flowerSysCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local flowerOwnViewPanel = class("flowerOwnViewPanel", baseFguiPanel)
function flowerOwnViewPanel:ctor(...)
	self.isLRU = true
	flowerOwnViewPanel.super.ctor(self, ...)
	print("flowerOwnViewPanel:ctor", self.viewName)
end
function flowerOwnViewPanel:onInit()
	print("=======flowerOwnViewPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_2302"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).num = ""
	self.fields.Text_cur:setString(i18n("common_text_2310", handler(self, self.onClickHelp)))
	self.fields.Label_rank:setString(i18n("common_text_2193"))
	self.fields.Label_reward:setString(i18n("common_text_2313"))
	self.fields.Btn_rank:setString(i18n("common_text_2306"))
	self.fields.Btn_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_record:setString(i18n("common_text_2315"))
	self.fields.Button_record:addClickListener(handler(self, self.btnRecordClick))
	self.fields.Btn_rank:fixPos()
	self.fields.Text_curRank:fixPos()
	self.fields.Text_lastRank:fixPos()
end
function flowerOwnViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1], self.lordInfo.flowerSysInfo.rewardscfg)
end
function flowerOwnViewPanel:endShow()
	print("=======flowerOwnViewPanel:endShow")
	_UPVALUE3_ = print
	self.rankList, print[1] = print, 1
	self.rankList, print[2] = print, 2
	self.rankList, print[3] = print, 3
	self.fields.Com_head:setSelfHead()
	flowerSysCtrl:sendOpenPage()
	SoraDShowLoading(self)
end
function flowerOwnViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.lordInfo = lordInfoCtrl:getLordInfo()
	self.fields.Text_name:setString(textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName))
	local giftednums = self.lordInfo.flowerSysInfo.giftednums or 0
	self.fields.Text_flower:setString(giftednums)
	local curRank = self.lordInfo.flowerSysInfo.curRank < 1 and "5000+" or self.lordInfo.flowerSysInfo.curRank
	local preRank = 1 > self.lordInfo.flowerSysInfo.preRank and "5000+" or self.lordInfo.flowerSysInfo.preRank
	_ENV = textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName)
	textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName).rank = fguiHelper.getColorString("#FFD43E", curRank)
	self.fields.Text_curRank:setString(i18n("common_text_4874", textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName)))
	_ENV = i18n("common_text_4874", textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName))
	i18n("common_text_4874", textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName)).rank = fguiHelper.getColorString("#FFD43E", preRank)
	self.fields.Text_lastRank:setString(i18n("common_text_4875", i18n("common_text_4874", textParser.formatPlayerName(self.lordInfo.abbr, self.lordInfo.base.nickName))))
	self.fields.List:setNumItems(#self.rankList)
	self.fields.List:setScrollEnable(self.fields.List:getHeight() < 467)
end
function flowerOwnViewPanel:btnRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = lordRankingsDef.flowerNum
	uiManager:show("rankingsScrollView", nil)
end
function flowerOwnViewPanel:btnRecordClick()
	SoraDPlaySound()
	uiManager:show("flowerRecordView")
end
function flowerOwnViewPanel:onClickHelp()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.FLOWER_HELP)
end
return flowerOwnViewPanel

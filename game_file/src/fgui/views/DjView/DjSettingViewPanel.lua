local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjSettingViewPanel = class("DjSettingViewPanel", baseFguiPanel)
function DjSettingViewPanel:ctor(...)
	self.isLRU = true
	DjSettingViewPanel.super.ctor(self, ...)
	print("DjSettingViewPanel:ctor", self.viewName)
end
function DjSettingViewPanel:onInit()
	print("=======DjSettingViewPanel:onInit")
	self.fields.Com_title:initData(i18n("Anchor_btn_01"), handler(self, self.onClickClose))
	self.fields.Button_dj:setString(i18n("Anchor_text_119"))
	self.fields.Button_dj:addClickListener(handler(self, self.onClick_Button_dj))
	self.fields.Button_set:setString(i18n("Anchor_text_170"))
	self.fields.Button_set:addClickListener(handler(self, self.onClick_Button_set))
end
function DjSettingViewPanel:endShow()
	print("=======DjSettingViewPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("Anchor_text_108")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Anchor_text_109")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
	if djCtrl.isBroadcastDJ then
		self.fields.Button_dj:setVisible(false)
		self.fields.Button_set:setPositionX(self.view:getWidth() / 2)
	else
		self.fields.Button_dj:setVisible(true)
		self.fields.Button_dj:setPositionX(SoraDFPosX(self.view:getWidth() / 2 - 140, self.view:getWidth()))
		self.fields.Button_set:setPositionX(SoraDFPosX(self.view:getWidth() / 2 + 140, self.view:getWidth()))
	end
end
function DjSettingViewPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 2 then
		djCtrl:reqGetAnchorInfo()
	end
end
function DjSettingViewPanel:initView(target, data)
	_ENV, _ENV, self.selfInfo = nil, data.info, data.info
	;(nil).title = i18n("Anchor_text_120")
	;(nil).val = djRead.getAnchorLvByExp(self.selfInfo.contributeCount)
	;(nil).enum = djRead.detailEnum.anchor_lv
	_ENV, data.info[1], (nil).style = nil, nil, 3
	;(nil).title = i18n("Anchor_text_121")
	;(nil).val = djCtrl:getCurDJLiveBeginTime()
	data.info[2], (nil).isTime = nil, true
	local baseCfg = data.info
	self.fields.info_base:initData(baseCfg)
	_ENV, _ENV = self.fields.info_base, self.fields.info_base.initData
	self.fields.info_base.title = i18n("Anchor_text_122")
	_ENV, self.fields.info_base.initData[1], self.fields.info_base.val = self.fields.info_base, self.fields.info_base, self.selfInfo.liveTotalCount
	self.fields.info_base.title = i18n("Anchor_text_123")
	_ENV, self.fields.info_base.initData[2], self.fields.info_base.val = self.fields.info_base, self.fields.info_base, SoraDConvertSecondToString(self.selfInfo.liveTotalTime)
	self.fields.info_base.title = i18n("Anchor_text_124")
	_ENV, self.fields.info_base.initData[3], self.fields.info_base.val = self.fields.info_base, self.fields.info_base, string.formatnumberthousands(self.selfInfo.contributeCount)
	self.fields.info_base.title = i18n("Anchor_text_125")
	self.fields.info_base.val = self.selfInfo.monthRank == 0 and "--" or self.selfInfo.monthRank
	self.fields.info_base.enum = djRead.detailEnum.mohth_rank
	_ENV, self.fields.info_base.initData[4], self.fields.info_base.isDJ = self.fields.info_base, self.fields.info_base, true
	self.fields.info_base.title = i18n("Anchor_text_126")
	self.fields.info_base.val = self.selfInfo.totalRank == 0 and "--" or self.selfInfo.totalRank
	self.fields.info_base.enum = djRead.detailEnum.live_rank
	self.fields.info_base.initData[5], self.fields.info_base.isDJ = self.fields.info_base, true
	local otherCfg = self.fields.info_base.initData
	self.fields.info_other:initData(otherCfg)
end
function DjSettingViewPanel:getSetParam()
	_UPVALUE0_ = nil
	;(nil).topic = self.fields.info_djSet:getTopic()
	;(nil).title = self.fields.info_djSet:getTitle()
	;(nil).msgModeIndex = self.fields.info_djSet:getModelIndex()
	;(nil).msgCastleLvModeIndex = self.fields.info_djSet:getLvIndex()
	local (nil).msgCDModeIndex, param = self.fields.info_djSet:getSpeedIndex(), nil
	return param
end
function DjSettingViewPanel:onClick_Button_set(context)
	SoraDPlaySound()
	local param = self:getSetParam()
	djCtrl:reqRoomSet(param)
end
function DjSettingViewPanel:onClick_Button_dj(context)
	SoraDPlaySound()
	local param = self:getSetParam()
	_ENV = nil
	;(nil).content = i18n("Anchor_text_184")
	;(nil).confirmFunc = function()
		djCtrl:sendDJOpen(param)
		self:close()
	end
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	uiManager:show("MessageBox", nil)
end
return DjSettingViewPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_RankSelectPanel = class("RoaringFlame_RankSelectPanel", baseFguiPanel)
function RoaringFlame_RankSelectPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_RankSelectPanel.super.ctor(self, ...)
	print("RoaringFlame_RankSelectPanel:ctor", self.viewName)
end
function RoaringFlame_RankSelectPanel:onInit()
	print("=======RoaringFlame_RankSelectPanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text26"))
	self.fields.Label_time:setString(i18n("common_text_289"))
	self.fields.Label_camp:setString(i18n("nebula_war_text_0001"))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	_ENV = self.fields.Button_ok.addClickListener
	self.fields.Button_ok.addClickListener[1] = i18n("flames_dunes_text27")
	self.fields.Button_ok.addClickListener[2] = i18n("flames_dunes_text28")
	self.fields.Button_ok.addClickListener[3] = i18n("flames_dunes_text29")
	self.fields.Button_ok.addClickListener[4] = i18n("flames_dunes_text30")
	_ENV, self.timeCfg, self.fields.Button_ok.addClickListener[5] = self.fields.Button_ok.addClickListener, self.fields.Button_ok.addClickListener, i18n("flames_dunes_text31")
	self.fields.Button_ok.addClickListener[1] = i18n("flames_dunes_text32")
	self.campCfg, self.fields.Button_ok.addClickListener[2] = self.fields.Button_ok.addClickListener, i18n("flames_dunes_text33")
	self.fields.List_time:setItemRenderer(handler(self, self.onTimeRenderer))
	self.fields.List_time:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseTime))
	self.fields.List_camp:setItemRenderer(handler(self, self.onCampRenderer))
	self.fields.List_camp:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseCamp))
end
function RoaringFlame_RankSelectPanel:onTimeRenderer(index, obj)
	obj:fixChildrenPos()
	obj:setTitle(self.timeCfg[index + 1])
	obj:setSelected(index + 1 == self.selTimeIndex)
end
function RoaringFlame_RankSelectPanel:onChooseTime()
	SoraDPlaySound()
	self.selTimeIndex = self.fields.List_time:getSelectedIndex() + 1
end
function RoaringFlame_RankSelectPanel:onCampRenderer(index, obj)
	obj:fixChildrenPos()
	obj:setTitle(self.campCfg[index + 1])
	obj:setSelected(index + 1 == self.selCampIndex)
end
function RoaringFlame_RankSelectPanel:onChooseCamp()
	SoraDPlaySound()
	self.selCampIndex = self.fields.List_camp:getSelectedIndex() + 1
end
function RoaringFlame_RankSelectPanel:endShow()
	print("=======RoaringFlame_RankSelectPanel:endShow")
	self.week = self.param.week
	self.camp = self.param.camp
	self.isCamp = self.param.isCamp
	self.controllers.c1:setSelectedIndex(self.isCamp and 1 or 0)
	self.selTimeIndex = self.week and self.week + 1 or 1
	self.selCampIndex = self.camp and 2 or 1
	self.fields.List_time:setNumItems(#self.timeCfg)
	self.fields.List_camp:setNumItems(#self.campCfg)
end
function RoaringFlame_RankSelectPanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ROARINGFLAMEWAR_UI_RANKSELECT"
	;(nil).week = self.selTimeIndex
	;(nil).camp = self.selCampIndex
	SoraDSendMessage(nil)
	self:close()
end
return RoaringFlame_RankSelectPanel

local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local angerSnowWolfMainPanel = class("angerSnowWolfMainPanel", baseFguiPanel)
function angerSnowWolfMainPanel:ctor(...)
	angerSnowWolfMainPanel.super.ctor(self, ...)
	print("angerSnowWolfMainPanel:ctor", self.viewName)
end
function angerSnowWolfMainPanel:onInit()
	print("=======angerSnowWolfMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001578"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_exchange:setString(i18n("Challenge_SnowWolf_text_06"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self.fields.Btn_left:addClickListener(handler(self, self.btnLeftGoClick))
	self.fields.Btn_right:addClickListener(handler(self, self.btnRightGoClick))
	self.fields.Button_exchange:fixPos()
end
function angerSnowWolfMainPanel:onShow()
	print("=======angerSnowWolfMainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	SoraDShowLoading(self)
	angrySnowWolfKingCtrl:entranceinfoReq()
end
function angerSnowWolfMainPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.initInfo = angrySnowWolfKingCtrl:getInitInfo()
	self.fields.Com_bottom:initData(self.initInfo)
	self.fields.Button_exchange:setRedVisible(angrySnowWolfKingCtrl:judgeIsEnough())
end
function angerSnowWolfMainPanel:btnLeftGoClick()
	SoraDPlaySound()
	if angrySnowWolfKingCtrl:judgeTimesOut(gAngrySnowWolfKingBattletype.NORMAL_BATTLE) then
		SoraDShowMsgTip(i18n("common_text_3280"))
	else
		_ENV = i18n("common_text_3280")
		i18n("common_text_3280").battleType = gAngrySnowWolfKingBattletype.NORMAL_BATTLE
		uiManager:show("angerMapView", i18n("common_text_3280"))
	end
end
function angerSnowWolfMainPanel:btnRightGoClick()
	SoraDPlaySound()
	if angrySnowWolfKingCtrl:judgeTimesOut(gAngrySnowWolfKingBattletype.ELITE_BATTLE) then
		SoraDShowMsgTip(i18n("common_text_3281"))
	else
		_ENV = i18n("common_text_3281")
		i18n("common_text_3281").battleType = gAngrySnowWolfKingBattletype.ELITE_BATTLE
		uiManager:show("angerMapView", i18n("common_text_3281"))
	end
end
function angerSnowWolfMainPanel:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("angerSnowWolfExchangeView")
end
return angerSnowWolfMainPanel

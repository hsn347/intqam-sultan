local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_main_bottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://angerSnowWolf/Com_main_bottom", Com_main_bottom)
function Com_main_bottom:onInit()
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.Text_leftName:setAlign(0)
	self.fields.Text_leftName:setString(i18n("Challenge_SnowWolf_text_01"))
	self.fields.Text_rightName:setAlign(2)
	self.fields.Text_rightName:setString(i18n("Challenge_SnowWolf_text_01"))
	self.fields.Text_tip:setString(i18n("common_text_1774"))
	self.fields.Text_barLeft:setAlign(0)
	self.fields.Text_barRight:setAlign(2)
	self.fields.Button_leftChallenge:addClickListener(handler(self, self.btnLeftGoClick))
	self.fields.Button_rightChallenge:addClickListener(handler(self, self.btnRightGoClick))
end
function Com_main_bottom:onShow()
end
function Com_main_bottom:initData(initInfo)
	self.initInfo = initInfo
	self.fields.LoadingBar_left:setMax(self.initInfo.normalmaxhp)
	self.fields.LoadingBar_left:setValue(self.initInfo.normalmaxhp - self.initInfo.normaldechp)
	self.fields.LoadingBar_right:setMax(self.initInfo.elitemaxhp)
	self.fields.LoadingBar_right:setValue(self.initInfo.elitemaxhp - self.initInfo.elitedechp)
	self.fields.Text_barLeft:setString((self.initInfo.normalmaxhp - self.initInfo.normaldechp) / self.initInfo.normalmaxhp * 100 .. "%")
	self.fields.Text_barRight:setString((self.initInfo.elitemaxhp - self.initInfo.elitedechp) / self.initInfo.elitemaxhp * 100 .. "%")
	local itemCount = angrySnowWolfKingCtrl:getItemCount()
	self.fields.red_left:setVisible(itemCount >= MONSTERPALACE_NORMAL_COSTHORN)
	self.fields.red_right:setVisible(itemCount >= MONSTERPALACE_ELITE_COSTHORN)
end
function Com_main_bottom:btnLeftGoClick()
	SoraDPlaySound()
	if angrySnowWolfKingCtrl:judgeTimesOut(gAngrySnowWolfKingBattletype.NORMAL_BATTLE) then
		SoraDShowMsgTip(i18n("common_text_3280"))
	else
		_ENV = i18n("common_text_3280")
		i18n("common_text_3280").battleType = gAngrySnowWolfKingBattletype.NORMAL_BATTLE
		uiManager:show("angerMapView", i18n("common_text_3280"))
	end
end
function Com_main_bottom:btnRightGoClick()
	SoraDPlaySound()
	if angrySnowWolfKingCtrl:judgeTimesOut(gAngrySnowWolfKingBattletype.ELITE_BATTLE) then
		SoraDShowMsgTip(i18n("common_text_3281"))
	else
		_ENV = i18n("common_text_3281")
		i18n("common_text_3281").battleType = gAngrySnowWolfKingBattletype.ELITE_BATTLE
		uiManager:show("angerMapView", i18n("common_text_3281"))
	end
end
return Com_main_bottom

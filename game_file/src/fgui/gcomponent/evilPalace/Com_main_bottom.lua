local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local evilPalaceRead = include("evilPalaceRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_main_bottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://evilPalace/Com_main_bottom", Com_main_bottom)
function Com_main_bottom:onInit()
	self.fields.Text_leftName:setString(evilPalaceRead.getMonsterName(gMonsterpalaceBattletype.NORMAL_BATTLE))
	self.fields.Text_rightName:setString(evilPalaceRead.getMonsterName(gMonsterpalaceBattletype.ELITE_BATTLE))
	self.fields.LoadingBar_left:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.LoadingBar_right:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Button_leftChallenge:setString(i18n("common_text_3272"))
	self.fields.Button_leftChallenge:addClickListener(handler(self, self.btnLeftGoClick))
	self.fields.Button_rightChallenge:setString(i18n("common_text_3273"))
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
	self.fields.Text_leftPercent:setString((self.initInfo.normalmaxhp - self.initInfo.normaldechp) / self.initInfo.normalmaxhp * 100 .. "%")
	self.fields.Text_rightPercent:setString((self.initInfo.elitemaxhp - self.initInfo.elitedechp) / self.initInfo.elitemaxhp * 100 .. "%")
	self.isOpenElite = MONSTERPALACE_ELITE_STATUS_OPEN == self.initInfo.elitestatus
	self.fields.Button_rightChallenge:setBright(self.isOpenElite)
end
function Com_main_bottom:setRed()
	local itemCount = backpackCtrl:getItemCount(MONSTERPALACE_HORNID)
	local lPoint = itemCount >= MONSTERPALACE_NORMAL_COSTHORN
	local rPoint = itemCount >= MONSTERPALACE_ELITE_COSTHORN
	self.fields.Button_leftChallenge:setReddot(lPoint)
	self.fields.Button_rightChallenge:setReddot(self.isOpenElite and rPoint)
end
function Com_main_bottom:judgeTimesOut(battleType)
	local isOut = false
	if self.initInfo and gMonsterpalaceBattletype.NORMAL_BATTLE == battleType then
		isOut = self.initInfo.normalkilltimes == nil or self.initInfo.normalkilltimes <= 0
	elseif self.initInfo and gMonsterpalaceBattletype.ELITE_BATTLE == battleType then
		isOut = self.initInfo.elitekilltimes == nil or 0 >= self.initInfo.elitekilltimes
	end
	return isOut
end
function Com_main_bottom:btnLeftGoClick()
	SoraDPlaySound()
	if self:judgeTimesOut(gMonsterpalaceBattletype.NORMAL_BATTLE) then
		SoraDShowMsgTip(i18n("common_text_3280"))
	else
		_ENV = i18n("common_text_3280")
		i18n("common_text_3280").battleType = gMonsterpalaceBattletype.NORMAL_BATTLE
		uiManager:show("evilPalaceMapView", i18n("common_text_3280"))
	end
end
function Com_main_bottom:btnRightGoClick()
	SoraDPlaySound()
	if self.isOpenElite then
		if self:judgeTimesOut(gMonsterpalaceBattletype.ELITE_BATTLE) then
			SoraDShowMsgTip(i18n("common_text_3281"))
		else
			_ENV = i18n("common_text_3281")
			i18n("common_text_3281").battleType = gMonsterpalaceBattletype.ELITE_BATTLE
			uiManager:show("evilPalaceMapView", i18n("common_text_3281"))
		end
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function Com_main_bottom:getTarget(name)
	return self.fields[name]
end
return Com_main_bottom

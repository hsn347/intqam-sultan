local baseFguiPanel = require("fgui.base.baseFguiPanel")
local starLampCeremonyCtrl = SoraDGetCtrl("starLampCeremonyCtrl")
local constantRead = include("constantRead")
local StarLampCeremonyMainPanel = class("StarLampCeremonyMainPanel", baseFguiPanel)
function StarLampCeremonyMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarLampCeremonyMainPanel:ctor", self.viewName)
end
function StarLampCeremonyMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarLampCeremonyMainPanel:onInit()
	print("=======StarLampCeremonyMainPanel:onInit")
	self.itemID = constantRead.getConstValue("STARLIGHT_CEREMONY_ITEM", 859901)
	print(self.itemID, "self.itemID")
	self.fields.Com_have:initData(self.itemID)
	self.activityID = gActivityTimeActivityID.STAR_LAMP_CEREMONY_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.button_useOne:setTitle(i18n("Starlight_ceremony_01"))
	self.fields.button_useOne:addClickEventListener(handler(self, self.onUseClick), false)
	self.fields.button_useAll:setTitle(i18n("Starlight_ceremony_02"))
	self.fields.button_useAll:addClickEventListener(handler(self, self.onUseClick), true)
	self.fields.btn_rank:setTitle(i18n("common_text_851"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick))
end
function StarLampCeremonyMainPanel:onShow()
	print("=======StarLampCeremonyMainPanel:onShow")
	starLampCeremonyCtrl:sendReqInitDataMsg()
	self:updateView()
end
function StarLampCeremonyMainPanel:updateView()
	self.haveNum = self.fields.Com_have:updateNum()
end
function StarLampCeremonyMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Starlight_ceremony_03")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function StarLampCeremonyMainPanel:onUseClick(sender, param)
	SoraDPlaySound()
	if self.haveNum > 0 then
		starLampCeremonyCtrl:reqStarLampCeremonyFire(param)
		self.fields.Effect_1:stopAllActions()
		self.fields.Effect_1:clearEffect()
		local dt = 2.0
		if param then
			dt = 5.0
			self.fields.Effect_1:setEffectPath("xingdengdianli_yici", true)
		else
			self.fields.Effect_1:setEffectPath("xingdengdianli_quanburanfang", true)
		end
		self.fields.Effect_1:setAlpha(0)
		_UPVALUE3_ = true
		;(true)[1] = ffa.fadeIn(0.1)
		;(true)[2] = ffa.delay(dt)
		;(true)[3] = ffa.fadeOut(0.1)
		;(true)[4] = ffa.callFunc(function()
			self.fields.Effect_1:clearEffect()
		end)
		;(true)[5] = ffa.callFunc(function()
			self.fields.Effect_1:clearEffect()
		end)
		self.fields.Effect_1:runAction(ffa.seq(true))
	else
		_ENV = ffa.seq(true)
		ffa.seq(true).itemID = self.itemID
		uiManager:show("CommonSourceGuide", ffa.seq(true))
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	end
end
function StarLampCeremonyMainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("StarLampCeremonyRank"):setOwnerKey(self)
end
return StarLampCeremonyMainPanel

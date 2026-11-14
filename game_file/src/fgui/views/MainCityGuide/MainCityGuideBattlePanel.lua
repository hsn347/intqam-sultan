local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideBattlePanel = class("MainCityGuideBattlePanel", baseFguiPanel)
function MainCityGuideBattlePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideBattlePanel:ctor", self.viewName)
end
function MainCityGuideBattlePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideBattlePanel:onInit()
	print("=======MainCityGuideBattlePanel:onInit")
	self.fields.btn:addClickEventListener(function()
		gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect()
		if self.param.clickCallback then
			self.controllers.c1:setSelectedIndex(2)
			SoraDPlaySound("mainCityGuide", "newplayer_flash")
			self:runAction(ffa.seq(ffa.delay(1), ffa.callFunc(function()
				self.param.clickCallback()
				SoraDPlaySound("mainCityGuide", "newplayer_masterskill")
			end)))
			self.fields.top:showProgressAction2()
		end
	end)
end
function MainCityGuideBattlePanel:onShow()
	print("=======MainCityGuideBattlePanel:onShow")
	self:setAlpha(0)
	self:runAction(ffa.fadeIn(0.2))
	_ENV = self
	self.msg = "MESSAGE_MAIN_UI_HIDDLE"
	self.isHiddle = true
	SoraDSendMessage(self)
end
function MainCityGuideBattlePanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_UI_HIDDLE"
	;(nil).isHiddle = false
	SoraDSendMessage(nil)
end
function MainCityGuideBattlePanel:showSkillBtn()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.effect:setAllFrameName("dh_chengqujntb_%02d.png", 1)
	self.fields.effect:setPlaySettings(0, -1, -1)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:setVisible(false)
	end)
	_ENV = -1
	_ENV, (-1).z = -1, 0
	;(-1).x = 0
	;(-1).offset, (-1).y = -1, 0
	gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.btn, -1)
end
return MainCityGuideBattlePanel

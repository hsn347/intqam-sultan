local baseFguiPanel = require("fgui.base.baseFguiPanel")
local caracalLockPanel = class("caracalLockPanel", baseFguiPanel)
local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local friendsCallbackRead = include("friendsCallbackRead")
local publicRead = include("publicRead")
function caracalLockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("caracalLockPanel:ctor", self.viewName)
end
function caracalLockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function caracalLockPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======caracalLockPanel:onInit")
	self.isUnlock = friendPetCtrl:getInitData().isUnlock
	self.curPetLv = friendPetCtrl:getInitData().curPetLv
	_UPVALUE3_ = false
	;(false)[1] = "ar"
	;(false)[2] = "en"
	;(false)[3] = "ko"
	local iconName = SoraDGetImageNameByLang("frame_lingchong_youmao_%s.png", false)
	if self.isUnlock then
		_UPVALUE3_ = "ar"
		;("ar")[1] = "ar"
		;("ar")[2] = "en"
		;("ar")[3] = "ko"
		iconName = SoraDGetImageNameByLang("frame_lingchong_zhanmao_%s.png", "ar")
	end
	self.fields.Sprite_name:setURL(iconName)
	_ENV = "en"
	;("en").lv = self.curPetLv
	self.fields.Text_lv:setString(i18n("common_text_100", "en"))
	self.fields.Text_reward:setString(i18n("god_beast_text_04"))
end
function caracalLockPanel:onShow()
	print("=======caracalLockPanel:onShow")
end
function caracalLockPanel:onHide()
	print("=======caracalLockPanel:onHide")
end
function caracalLockPanel:onDispose()
	print("=======caracalLockPanel:onDispose")
end
function caracalLockPanel:initLevelUpReward(reward)
	self:initReward(reward)
	self.controllers.setSelectedIndex(0)
end
function caracalLockPanel:initReward(reward, isUnlock)
	if not reward or not next(reward) then
		return
	end
end
return caracalLockPanel

local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisBattleAreaAttack = class("atlantisBattleAreaAttack", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisBattleAreaAttack")
	end
	return target
end)
function atlantisBattleAreaAttack:ctor()
	self:initWidget()
end
function atlantisBattleAreaAttack:initWidget(...)
	SoraDCreatAnimation(self.__cname, self._ccsView, false)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	_UPVALUE2_ = self
	self[1] = "ar"
	self[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_qzzc_%s.png", self)
	self.Sprite_title:setSpriteFrame(icon)
	self.Text_go:setString(i18n("atlantiswar_text_0175"))
	self.Text_go:enableShadow(cc.c3b(0, 0, 0), cc.size(0, 0), 3)
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	self.Button_go:setTitleText(i18n("common_text_477"))
	SoraDAutoSizeButtonTextByContent(self.Button_go)
	self:initCriSpriteEffect()
end
function atlantisBattleAreaAttack:initCriSpriteEffect(...)
	local criSprite = cc.criSprite.createCriSprite("sp_zdtc_001.usm", false, true, nil)
	criSprite:addTo(self.Node_effect)
	criSprite:setPosition(320, 0)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function atlantisBattleAreaAttack:btnGoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		atlantisWarUtil.jumpToBuild(901)
		SoraDRemoveAllPanelFromManager()
	end
end
return atlantisBattleAreaAttack

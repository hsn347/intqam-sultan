local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_attack = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_attack", Com_attack)
_ENV, _ENV = "ui://TowerDefend/Com_attack", fgui.register_extension
;("ui://TowerDefend/Com_attack").paodanSprite = "dh_Tex_XL_mnytf05_0%02d.png"
_ENV, fgui.register_extension[101], ("ui://TowerDefend/Com_attack").paodanFrameCount = "ui://TowerDefend/Com_attack", "ui://TowerDefend/Com_attack", 46
;("ui://TowerDefend/Com_attack").paodanSprite = "dh_xiaopaogj_%02d.png"
_ENV, fgui.register_extension[102], ("ui://TowerDefend/Com_attack").paodanFrameCount = "ui://TowerDefend/Com_attack", "ui://TowerDefend/Com_attack", 46
;("ui://TowerDefend/Com_attack").paodanSprite = "dh_Tex_XL_mnytf04_0%02d.png"
_ENV, fgui.register_extension[103], ("ui://TowerDefend/Com_attack").paodanFrameCount = "ui://TowerDefend/Com_attack", "ui://TowerDefend/Com_attack", 46
;("ui://TowerDefend/Com_attack").paodanSprite = "dh_tf_bz_%02d.png"
_ENV, fgui.register_extension[104], ("ui://TowerDefend/Com_attack").paodanFrameCount = "ui://TowerDefend/Com_attack", "ui://TowerDefend/Com_attack", 29
local paodanConfig = fgui.register_extension
;("ui://TowerDefend/Com_attack").IN = 1
local ("ui://TowerDefend/Com_attack").OUT, AttackState = 2, "ui://TowerDefend/Com_attack"
function Com_attack:onInit()
	self.fields.Ani_lei:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_attack:initData(towerID, instance)
	if not self.info then
		self.info, AttackState = self.info, self.info
	end
	self.towerID = towerID
	self.info.state = AttackState.IN
	self.info.instance = instance
	self.fields.Ani_load:setVisible(false)
end
function Com_attack:releaseBoom()
	local framesAttack = display.newFrames(paodanConfig[self.towerID].paodanSprite, 1, paodanConfig[self.towerID].paodanFrameCount)
	local animationAttack = display.newAnimation(framesAttack, 0.03333333333333333)
	self.fields.Ani_load:setAnimation(animationAttack)
	self.fields.Ani_load:setVisible(true)
	self.fields.Ani_load:setPlaying(true)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self.fields.Ani_load:setVisible(false)
		self.fields.Ani_load:setPlaying(false)
		self.callBackFunc()
		towerDefendRead.addAttackObject(self.info.instance)
	end)
end
function Com_attack:releaseBoomShizi()
	towerDefendRead = nil
	;(nil)[1] = ffa.delay(0.1)
	;(nil)[2] = ffa.callFunc(function()
		local framesNpc = display.newFrames("dh_Tex_XL_mnytf03_%03d.png", 0, 11)
		local animationNpc = display.newAnimation(framesNpc, 0.03333333333333333)
		self.fields.Ani_lei:setAnimation(animationNpc)
		self.fields.Ani_lei:setVisible(true)
		self.fields.Ani_lei:setPlaying(true)
		self.fields.Ani_lei:setPlaySettings(1, -1, 1, -1, function()
			self.fields.Ani_lei:setVisible(false)
			self.fields.Ani_lei:setPlaying(false)
			self.callBackFunc()
			towerDefendRead.addAttackObject(self.info.instance)
		end)
	end)
	;(nil)[3] = ffa.callFunc(function()
		local framesNpc = display.newFrames("dh_Tex_XL_mnytf03_%03d.png", 0, 11)
		local animationNpc = display.newAnimation(framesNpc, 0.03333333333333333)
		self.fields.Ani_lei:setAnimation(animationNpc)
		self.fields.Ani_lei:setVisible(true)
		self.fields.Ani_lei:setPlaying(true)
		self.fields.Ani_lei:setPlaySettings(1, -1, 1, -1, function()
			self.fields.Ani_lei:setVisible(false)
			self.fields.Ani_lei:setPlaying(false)
			self.callBackFunc()
			towerDefendRead.addAttackObject(self.info.instance)
		end)
	end)
	self.fields.Ani_lei:runAction(ffa.seq(nil))
end
function Com_attack:setAniCallBack(backHandle)
	self.callBackFunc = backHandle
end
function Com_attack:setSlownDownEffectRange(r)
	local curWidth = 225
	local curHeight = 160
	self.fields.Ani_load:setScaleX((r + 30) * 2 / curWidth)
	self.fields.Ani_load:setScaleY((r - 15) * 2 / curHeight)
end
function Com_attack:setTowerAttackRange(r1)
	local curWidth = 200
	local curHeight = 160
	self.fields.Ani_load:setScaleX(r1 * 2 / curWidth)
	self.fields.Ani_load:setScaleY(r1 * 2 / curHeight)
end
function Com_attack:getInfo()
	return self.info
end
function Com_attack:onShow()
end
return Com_attack

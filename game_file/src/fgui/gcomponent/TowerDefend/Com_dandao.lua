local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_dandao = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_dandao", Com_dandao)
fgui.register_extension("ui://TowerDefend/Com_dandao_refer", Com_dandao)
_ENV, _ENV = "ui://TowerDefend/Com_dandao_refer", fgui.register_extension
;("ui://TowerDefend/Com_dandao_refer").paodanSprite = "dh_tf_hqdd_%02d.png"
_ENV, fgui.register_extension[102], ("ui://TowerDefend/Com_dandao_refer").paodanFrameCount = "ui://TowerDefend/Com_dandao_refer", "ui://TowerDefend/Com_dandao_refer", 21
;("ui://TowerDefend/Com_dandao_refer").paodanSprite = "dh_tf_hqdd_%02d.png"
_ENV, fgui.register_extension[104], ("ui://TowerDefend/Com_dandao_refer").paodanFrameCount = "ui://TowerDefend/Com_dandao_refer", "ui://TowerDefend/Com_dandao_refer", 21
local dandaoConfig = fgui.register_extension
;("ui://TowerDefend/Com_dandao_refer").IN = 1
local ("ui://TowerDefend/Com_dandao_refer").OUT, FlyState = 2, "ui://TowerDefend/Com_dandao_refer"
function Com_dandao:onInit()
end
function Com_dandao:initData(towerID, instance, data)
	self:stopAllActions()
	if not self.info then
		self.info, FlyState = self.info, self.info
	end
	self.data = data
	self.towerID = towerID
	self.info.state = FlyState.IN
	self.info.instance = instance
	if self.towerID == 102 then
		self.fields.Ani_load:setScale(0.75)
	else
		self.fields.Ani_load:setScale(1)
	end
end
function Com_dandao:initFly(time)
	if self.towerID == 101 then
		self.fields.Image_jian:setVisible(true)
		self.fields.Ani_load:setVisible(false)
		return
	else
		self.fields.Image_jian:setVisible(false)
	end
	local framesAttack = display.newFrames(dandaoConfig[self.towerID].paodanSprite, 1, dandaoConfig[self.towerID].paodanFrameCount)
	local frameRate = time and time / 21 or 0.03333333333333333
	local animationAttack = display.newAnimation(framesAttack, frameRate)
	self.fields.Ani_load:setAnimation(animationAttack)
	self.fields.Ani_load:setVisible(true)
	self.fields.Ani_load:setPlaying(true)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self.fields.Ani_load:setVisible(false)
	end)
end
function Com_dandao:endFly()
	self.info.state = FlyState.OUT
	self.fields.Ani_load:setPlaying(false)
	self:stopAllActions()
	_ENV = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		towerDefendRead.addShootLineObject(self.info.instance)
	end)
	;(nil)[3] = ffa.callFunc(function()
		towerDefendRead.addShootLineObject(self.info.instance)
	end)
	self:runAction(ffa.seq(nil))
end
function Com_dandao:onShow()
end
return Com_dandao

local constantRead = include("constantRead")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local activity_9001703_Read = include("activity_9001703_Read")
local GUN_LEN = 100
local baseComponent = require("fgui.base.baseComponent")
local Com_hunter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_hunter", Com_hunter)
function Com_hunter:onInit()
	_UPVALUE2_ = nil
	;(nil)[1] = 1500
	;(nil)[2] = 1000
	self.bulletCfg = constantRead.getConstValueArray("BALLOON_HUNTER_MAX_HIT_RANGE", nil)
	self.extraCfg = constantRead.getConstValue("BALLOON_HUNTER_DOUBLEHIT_TIME", 0.04)
	self.maxHP = constantRead.getConstValue("BALLOON_HUNTER_PLAYER_HP", 3000)
	self.fields.Bar_hp:setMax(100)
	self.gunRootNode = display.newNode()
	self.gunRootNode:setZ(250)
	self.gunRootNode:setName("gunRootNode")
	self.fields.Loader3D:setContent(self.gunRootNode)
	self.sprite3DGun = cc.Sprite3D:create("3d/activity/9001703/qiqiulieren.c3b")
	self.sprite3DGun:setScale(2)
	self.sprite3DGun:setPosition(cc.p(0, 0))
	self.sprite3DGun:addTo(self.gunRootNode)
	constantRead = self.gunRootNode
	self.gunRootNode.x = 12
	self.gunRootNode.y = 0
	self.gunRootNode.z = 0
	self.sprite3DGun:setRotation3D(self.gunRootNode)
	self.fields.Bar_hp:fix()
end
function Com_hunter:onShow()
	self.isPause = false
	self.bulletPool, _ENV, self.hunterRotation = nil, nil, 0
	self.fields.Text_hurt:setVisible(false)
	_ENV = false
	;(false).x = 0
	;(false).y = 0
	;(false).z = 0
	self.gunRootNode:setRotation3D(false)
	self.fields.Com_source:setPosition(cc.p(50, 50 - GUN_LEN))
	self.fields.Com_source:removeAllChildren()
	self.timeDt = 0
	self:updateBuff()
	self.timer = SoradCreateTimer(self, handler(self, self.updateUI), true)
end
function Com_hunter:updateBuff()
	self.fireSpeed = activity_9001703_Ctrl:getPowerVal(2)
	self.fireExtra = activity_9001703_Ctrl:getSkillLvEffect(5)
end
function Com_hunter:updateHp()
	local hp = activity_9001703_Ctrl:getBlood()
	local val = 18 + hp / self.maxHP * 64
	self.fields.Bar_hp:setValue(val)
	self.fields.Text_hp:setString(hp)
end
function Com_hunter:updateUI(dt)
	if self.isPause then
		self:pauseGame()
	else
		self:continueGame()
		self.timeDt = self.timeDt + dt
		if self.timeDt >= 1 / self.fireSpeed then
			self.timeDt = 0
			self:fire()
			self:combo()
		end
	end
end
function Com_hunter:combo()
	if self.fireExtra > 0 then
		local _ENV, actTab = self.fireExtra, self.fireExtra
		for i = 1, self.fireExtra do
			table.insert(actTab, ffa.delay(self.extraCfg))
			table.insert(actTab, ffa.callFunc(function()
				self:fire()
			end))
		end
		self:runAction(ffa.seq(actTab))
	end
end
function Com_hunter:pauseGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:pause()
		v:getActionManager():pauseTarget(v)
	end
end
function Com_hunter:continueGame()
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		v:resume()
		v:getActionManager():resumeTarget(v)
	end
end
function Com_hunter:fire()
	local fireNum = 1 + activity_9001703_Ctrl:getSkillLvEffect(4)
	local angle = 0
	self.sprite3DGun:play("qiqiulieren01")
	for i = 1, fireNum do
		do
			local bullet = self:getFromPool()
			if not bullet then
				bullet = fguiHelper.createObject("Activity_9001703", "Com_bullet")
				bullet:addTo(self.fields.Com_source)
			end
			local pos = self.fields.Com_source:globalToLocal(self:getGunPos())
			bullet:setPosition(cc.p(-pos.x, pos.y))
			bullet:initData(self)
			bullet:setVisible(true)
			local pascal = -5 * (fireNum - 1) + 10 * (i - 1)
			local toRotation = math.rad(self.hunterRotation) + math.rad(pascal)
			bullet:stopAllActions()
			_UPVALUE2_ = cc.p(-pos.x, pos.y)
			cc.p(-pos.x, pos.y)[1] = ffa.moveTo(self.bulletCfg[1] / self.bulletCfg[2], self.bulletCfg[1] * math.sin(toRotation), -self.bulletCfg[1] * math.cos(toRotation))
			cc.p(-pos.x, pos.y)[2] = ffa.delay(0.016666666666666666)
			cc.p(-pos.x, pos.y)[3] = ffa.callFunc(function()
				self:addToPool(bullet)
			end)
			cc.p(-pos.x, pos.y)[4] = ffa.callFunc(function()
				self:addToPool(bullet)
			end)
			cc.p(-pos.x, pos.y)[5] = ffa.callFunc(function()
				self:addToPool(bullet)
			end)
			cc.p(-pos.x, pos.y)[6] = ffa.callFunc(function()
				self:addToPool(bullet)
			end)
			bullet:runAction(ffa.seq(cc.p(-pos.x, pos.y)))
		end
	end
end
function Com_hunter:addToPool(bullet)
	bullet:setVisible(false)
	bullet:stopAllActions()
	bullet:resetData()
	table.insert(self.bulletPool, bullet)
end
function Com_hunter:getFromPool()
	return table.remove(self.bulletPool)
end
function Com_hunter:setPause(isPause)
	self.isPause = isPause
end
function Com_hunter:setHunterRotation(rotate)
	self.hunterRotation = rotate
	_UPVALUE0_ = nil
	;(nil).x = 0
	;(nil).y = -self.hunterRotation
	;(nil).z = 0
	self.gunRootNode:setRotation3D(nil)
end
function Com_hunter:getGunPos()
	return self.sprite3DGun:getGameObjectPosition("paokou")
end
function Com_hunter:getShowBullet()
	local _ENV, ret
	for _, v in ipairs(self.fields.Com_source:getChildren()) do
		if v:isVisible() then
			table.insert(ret, v)
		end
	end
	return ret
end
function Com_hunter:beHit(monster)
	local cfg = activity_9001703_Read.getMonsterCfg(monster)
	self.fields.Text_hurt:setString(-cfg.atk)
	self.fields.Text_hurt:stopAllActions()
	self.fields.Text_hurt:setPosition(cc.p(137, 55))
	self.fields.Text_hurt:setAlpha(0)
	self.fields.Text_hurt:setScale(0.8)
	self.fields.Text_hurt:setVisible(true)
	_UPVALUE2_ = cc.p(137, 55)
	_ENV = cc.p(137, 55)
	cc.p(137, 55)[1] = ffa.fadeIn(0.5)
	cc.p(137, 55)[2] = ffa.scaleTo(0.5, 1, 1)
	cc.p(137, 55)[3] = ffa.scaleTo(0.5, 1, 1)
	cc.p(137, 55)[4] = ffa.scaleTo(0.5, 1, 1)
	cc.p(137, 55)[5] = ffa.scaleTo(0.5, 1, 1)
	cc.p(137, 55)[6] = ffa.scaleTo(0.5, 1, 1)
	_ENV = ffa.fadeIn(0.5)
	ffa.fadeIn(0.5)[1] = ffa.fadeOut(0.5)
	ffa.fadeIn(0.5)[2] = ffa.moveTo(0.5, 137, 75)
	ffa.fadeIn(0.5)[3] = ffa.moveTo(0.5, 137, 75)
	ffa.fadeIn(0.5)[4] = ffa.moveTo(0.5, 137, 75)
	ffa.fadeIn(0.5)[5] = ffa.moveTo(0.5, 137, 75)
	cc.p(137, 55)[1] = ffa.spawn(cc.p(137, 55))
	cc.p(137, 55)[2] = ffa.spawn((ffa.fadeIn(0.5)))
	cc.p(137, 55)[3] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	cc.p(137, 55)[4] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	cc.p(137, 55)[5] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	cc.p(137, 55)[6] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	cc.p(137, 55)[7] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	cc.p(137, 55)[8] = ffa.callFunc(function()
		self.fields.Text_hurt:setVisible(false)
		self.fields.Text_hurt:setPosition(cc.p(137, 55))
	end)
	self.fields.Text_hurt:runAction(ffa.seq(cc.p(137, 55)))
end
return Com_hunter

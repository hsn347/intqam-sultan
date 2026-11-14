local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_balloon = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_balloon", Com_balloon)
function Com_balloon:onInit()
end
function Com_balloon:onShow()
end
function Com_balloon:initData(data, parent)
	self.monster = data.monster
	self.parent = parent
	self.hp = data.hp
	self.status = 0
	self.fields.bar:setMax(self.hp)
	self.fields.bar:setVisible(false)
end
function Com_balloon:setBalloonTag(tag)
	self.tag = tag
end
function Com_balloon:getBalloonTag()
	return self.tag
end
function Com_balloon:getMonster()
	return self.monster
end
function Com_balloon:getHp()
	return self.hp
end
function Com_balloon:setStatus(status)
	self.status = status
end
function Com_balloon:getStatus()
	return self.status
end
function Com_balloon:beHit(parent, pos, expPos, hitPool, handler)
	local critVal = activity_9001703_Ctrl:getSkillLvEffect(3)
	local isCrit = critVal >= math.random(1, 100)
	local val = activity_9001703_Ctrl:getPowerVal(1)
	local realVal = math.floor(val * (isCrit and 1.75 or 1))
	self.hp = self.hp - realVal
	local beHitNum
	if 0 < #hitPool then
		beHitNum = table.remove(hitPool)
		beHitNum.isInPool = false
		beHitNum:setVisible(true)
	else
		beHitNum = fguiHelper.createObject("Activity_9001703", "Com_beHit")
		beHitNum:addTo(parent)
	end
	beHitNum:setPosition(parent:globalToLocal(pos))
	beHitNum:beHit(isCrit, realVal, self.hp <= 0, expPos, handler)
	if self.hp <= 0 then
		self.status = 1
		_ENV = isCrit
		isCrit[1] = self.monster
		activity_9001703_Ctrl:reqKillMonster(isCrit)
		if self.parent then
			self.parent:addToPool(self)
		end
	else
		self.fields.bar:setValue(self.hp)
		self.fields.bar:setVisible(true)
		_UPVALUE2_ = self.monster
		self.monster[1] = ffa.tintTo(0.1, 1.0, 0.396078431372549, 0.4980392156862745)
		self.monster[2] = ffa.delay(0.3)
		self.monster[3] = ffa.tintTo(0.1, 1, 1, 1)
		self.monster[4] = ffa.tintTo(0.1, 1, 1, 1)
		self.monster[5] = ffa.tintTo(0.1, 1, 1, 1)
		self.monster[6] = ffa.tintTo(0.1, 1, 1, 1)
		self.monster[7] = ffa.tintTo(0.1, 1, 1, 1)
		self.fields.icon:runAction(ffa.seq(self.monster))
	end
end
return Com_balloon

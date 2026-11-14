local baseComponent = require("fgui.base.baseComponent")
local Com_9001649_game = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001649_Read = include("activity_9001649_Read")
fgui.register_extension("ui://Activity_9001649/Com_9001649_game", Com_9001649_game)
_ENV = fgui.register_extension
fgui.register_extension.GOLD = 1
local _ENV, fgui.register_extension.SILVER, mineType = "ui://Activity_9001649/Com_9001649_game", 2, fgui.register_extension
;("ui://Activity_9001649/Com_9001649_game")[mineType.GOLD] = "icon_jk_01.png"
local ("ui://Activity_9001649/Com_9001649_game")[mineType.SILVER], mineIcon = "icon_yk_02.png", "ui://Activity_9001649/Com_9001649_game"
local hookSpeed = 250
local hookStartLong = 420
local mineR = 35
local hookR = 30
function Com_9001649_game:onInit()
	self.isDirection = false
	self.hook = fguiHelper.get_fields(self.fields.Com_9001649_hook).point
	self.hookFields = fguiHelper.get_fields(self.fields.Com_9001649_hook)
	self.hookIcon = self.hookFields.icon
	self.hookAni = self.hookFields.Spine_1
	dump(self.hookAni, "self.hookAni")
	self.curRandomMine = nil
	self.rebackspeed = activity_9001649_Read.getItemCfg().rebackspeed / 1000 or 1
end
function Com_9001649_game:onShow()
	self.timer = SoradCreateTimer(self, handler(self, self.updateUI), true)
end
function Com_9001649_game:getHook()
	return self.fields.Com_9001649_hook
end
function Com_9001649_game:getGuideRect()
	return self.fields.guide_rect
end
function Com_9001649_game:setHookCallback(callback)
	self.hookCallback = callback
end
function Com_9001649_game:initData(randomMine, minesData)
	randomMine = randomMine == 0 and 1 or randomMine
	self.hookAni:setEffectPath("spine/dxtx_zhuazi.skel", "animation01", false)
	self.isInAni = false
	self.fields.Com_9001649_hook:setHeight(hookStartLong)
	self.hookAni:stopAllActions()
	self.hookIcon:setVisible(false)
	self.mineObjects, hookStartLong, self.isHooking = self.hookIcon.setVisible, self.hookIcon.setVisible, false
	if self.curRandomMine ~= randomMine then
		self.fields.mineLoader:setURL("ui://Activity_9001649/Component" .. randomMine)
		self.mineComponent = self.fields.mineLoader:getComponent()
	end
	local mineFields = fguiHelper.get_fields(self.mineComponent)
	local childrenCount = self.mineComponent:getChildrenCount()
	local hookStartLong, mineList = self.mineComponent, self.mineComponent
	for i = 1, childrenCount do
		self.mineObjects[i] = mineFields[tostring(i)]
		local isGot = minesData[tostring(i)] == 1
		self.mineObjects[i]:setVisible(not isGot)
		if not isGot then
			hookStartLong = not isGot
			;(not isGot).id = i
			;(not isGot).node = self.mineObjects[i]
			table.insert(mineList, not isGot)
			if not self.mineObjects[i].addedClick then
				self.mineObjects[i].addedClick = true
				self.mineObjects[i]:addClickListener(handler(self, self.onMineClick))
			end
		end
	end
	self.minesData = clone(minesData)
	self.mineList = mineList
end
function Com_9001649_game:updateUI(dt)
	if self.isHooking then
		self:updateHook(dt)
	else
		self:updateRotate(dt)
	end
end
function Com_9001649_game:updateHook(dt)
	if self.isInAni then
		return
	end
	local pos = self:getHookPosition()
	local hookLong = self.fields.Com_9001649_hook:getHeight()
	if self.isReturning then
		hookLong = hookLong - hookSpeed * dt * self.rebackspeed
		if hookLong <= hookStartLong then
			hookLong = hookStartLong
			self:hookFinish()
		end
	else
		hookLong = hookLong + hookSpeed * dt
		if pos.x <= 0 or pos.x >= 640 or 0 >= pos.y then
			self.isReturning = true
			self.hookAni:start("animation01", false)
			print("updateHook 撞到墙壁")
			return
		end
		for i, mineData in pairs(self.mineList) do
			local minePos = mineData.node:getPosition()
			minePos.y = 640 - minePos.y - mineR
			local dis = math.sqrt((pos.x - minePos.x) ^ 2 + (pos.y - minePos.y) ^ 2)
			if dis <= mineR + hookR then
				self:onHitMine(mineData)
				table.remove(self.mineList, i)
				return
			end
		end
	end
	self.fields.Com_9001649_hook:setHeight(hookLong)
end
function Com_9001649_game:onHitMine(mineData)
	self.isInAni = true
	self.curMine = mineData
	print("updateHook 抓到矿")
	self.hookAni:start("animation01", false)
	self.hookAni:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.isInAni = false
		self.curMine.node:setVisible(false)
		self.hookIcon:setVisible(true)
		self.hookIcon:setScale(mineData.id > 3 and 1 or 0.8)
		self.hookIcon:setURL(mineIcon[mineData.id > 3 and 2 or 1])
		self.isReturning = true
	end)))
end
function Com_9001649_game:hookStart(isAuto)
	if self.isHooking then
		self:hookFinish()
	end
	if isAuto then
		local hookPos = cc.p(276, -318)
		for k, v in pairs(self.mineList) do
			if v ~= nil and v.id <= 3 then
				local minePos = v.node:getPosition()
				local radian = math.atan2(minePos.x - hookPos.x, minePos.y - hookPos.y)
				local rotate = -math.deg(radian)
				self.fields.Com_9001649_hook:setRotation(rotate)
				self.isHooking = true
				self.isReturning = false
				self.hookAni:start("animation02", false)
				return true
			end
		end
	else
		self.hookAni:start("animation02", false)
		self.isHooking = true
		self.isReturning = false
	end
	return false
end
function Com_9001649_game:getNextGoldMine()
	for k, v in pairs(self.mineList) do
		if v ~= nil and v.id <= 3 then
			return v
		end
	end
	return nil
end
function Com_9001649_game:hookFinish()
	self.isHooking = false
	if self.hookCallback then
		if self.curMine and not self.minesData[tostring(self.curMine.id)] then
			self.hookCallback(self.curMine)
			self.minesData[tostring(self.curMine.id)] = true
		else
			self.hookCallback()
		end
	end
	self.hookIcon:setVisible(false)
	self.curMine = nil
	self.isReturning = false
end
function Com_9001649_game:getHookPosition()
	local height = self.fields.Com_9001649_hook:getHeight()
	local rotate = self.fields.Com_9001649_hook:getRotation()
	local radian = math.rad(rotate)
	local x = self.fields.Com_9001649_hook:getPosition().x - height * math.sin(radian)
	local y = self.fields.Com_9001649_hook:getPosition().y + height * math.cos(radian)
	return cc.p(x, 640 - y)
end
local ratateSpeed = 20
function Com_9001649_game:updateRotate(dt)
	local hookRotate = self.fields.Com_9001649_hook:getRotation()
	if 20 <= hookRotate then
		self.isDirection = true
	end
	if hookRotate <= -20 then
		self.isDirection = false
	end
	if self.isDirection then
		hookRotate = hookRotate - ratateSpeed * dt
	else
		hookRotate = hookRotate + ratateSpeed * dt
	end
	self.fields.Com_9001649_hook:setRotation(hookRotate)
end
function Com_9001649_game:getIsHooking()
	return self.isHooking
end
function Com_9001649_game:onMineClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001649_Pop")
end
return Com_9001649_game

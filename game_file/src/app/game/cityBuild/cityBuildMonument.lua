local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local mileStoneCtrl = gametop.playertop_:getModule("mileStoneCtrl")
local cityBuildMonument = class("cityBuildMonument", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildMonument:ctor()
	self.isFixedBuild = true
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_Monument)
	self.bid = BUILDID.MONUMENT
	print("create cityBuildMonument ", self.bid)
	self:showEffect()
end
function cityBuildMonument:showEffect()
	if not self.effectNode then
		self.effectNode = display.newNode()
		self.effectNode:setPosition(-25, 260)
		self.effectNode:addTo(self, 10)
		local sprite = display.newSprite("#dh_xwxuzhuang_01.png")
		SoraDMixtureGLONE(sprite)
		sprite:setName("sprite_xw")
		local frames = display.newFrames("dh_xwxuzhuang_%.2d.png", 1, 15)
		local animation = display.newAnimation(frames, 0.1111111111111111)
		print("cityBuildMonument:showEffect()---------------------------")
		sprite:setScaleX(1.475)
		sprite:setScaleY(1.695)
		sprite:setRotation(-28.15)
		sprite:playAnimationForever(animation)
		sprite:addTo(self.effectNode, 1)
		sprite:setOpacity(76.5)
		_ENV, _ENV = sprite, sprite.setOpacity
		_ENV, sprite.plist = 76.5, "et_kohbiannianshi_01.plist"
		;(76.5).x = 1.34
		sprite.scale, (76.5).y = 76.5, 1.32
		_ENV, sprite.rotate = 76.5, -38
		;(76.5).x = 3
		_UPVALUE2_, sprite.pos, (76.5).y = 76.5, 76.5, -20
		_ENV, sprite.setOpacity[1], sprite.blend, (76.5)[1] = sprite, sprite, 76.5, gl.SRC_ALPHA
		_ENV, sprite.setOpacity[1], sprite.blend, (76.5)[2] = sprite, sprite, 76.5, gl.ONE
		_ENV, sprite.plist = 76.5, "et_kohbiannianshi_02.plist"
		;(76.5).x = 1.092
		sprite.scale, (76.5).y = 76.5, 1.296
		_ENV, sprite.rotate = 76.5, -10
		;(76.5).x = 3
		_UPVALUE2_, sprite.pos, (76.5).y = 76.5, 76.5, -10
		sprite.setOpacity[2], sprite.blend, (76.5)[1] = sprite, 76.5, gl.ONE
		sprite.setOpacity[2], sprite.blend, (76.5)[2] = sprite, 76.5, gl.ONE
		local param = sprite.setOpacity
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self.effectNode, 2)
	else
		self.effectNode:setVisible(true)
	end
	local dayPeriod = SoraDGetDayPeriod()
	self.effectNode:getChildByName("sprite_xw"):setVisible(true)
end
function cityBuildMonument:hideEffect()
	if self.effectNode then
		self.effectNode:setVisible(false)
	end
end
function cityBuildMonument:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_TOGGLE_DARK", handler(self, self.showEffect))
end
function cityBuildMonument:onAfterInitWithoutBuildCell()
	self:updateView()
end
function cityBuildMonument:loadView()
	print("-----------cityBuildMonument:loadView()")
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("history_name_11"), i18n("history_name_11")
	i18n("history_name_11").x = 0
	;(nil).pos, i18n("history_name_11").y = i18n("history_name_11"), -80
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildMonument:msgUpdateView(target, data)
	print("MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW")
	self:updateView()
end
function cityBuildMonument:updateView()
	self:updateIsLock()
	self:checkHasReward()
end
function cityBuildMonument:isCustomIdle()
	local isLock = self:getIsLocked()
	local isIdle = true
	if isLock then
		return false
	end
	if self:hasReward() > 0 then
		isIdle = false
	end
	return isIdle
end
function cityBuildMonument:checkHasReward()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	local hasBuildReward = legendMCtrl:getHasBuildReward()
	local hasMileStone = mileStoneCtrl:isHaveGift()
	if hasBuildReward or hasMileStone then
		legendMCtrl = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;(nil).buildIndex = self.buildIndex
		;(nil).buildEntity = self
		;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_MONUMENT
		SoraDSendMessage(nil)
	else
		legendMCtrl = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;(nil).buildIndex = self.buildIndex
		;(nil).buildEntity = self
		;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_MONUMENT
		SoraDSendMessage(nil)
	end
end
return cityBuildMonument

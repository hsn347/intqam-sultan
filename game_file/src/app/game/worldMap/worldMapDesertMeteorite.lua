local gametop = gModuleMgr.getObject("gametop")
local worldMapDesertMeteorite = class("worldMapDesertMeteorite", function(target)
	local target = include("worldMapInstance").new("worldMapDesertMeteorite")
	return target
end)
function worldMapDesertMeteorite:ctor()
	self.bgImage = display.newSprite("#dh_dizuo_01.png")
	self:addChild(self.bgImage, -1)
	local cw, ch = 208, 130
	self.fireBall = display.newSprite("#dh_guaiwuball_01.png")
	local frames = display.newFrames("dh_guaiwuball_%02d.png", 1, 30)
	local animation = display.newAnimation(frames, 0.08333333333333333)
	self.fireBall:playAnimationForever(animation)
	self.bgImage:addChild(self.fireBall, 1)
	self.fireBall:setPosition(219, 254)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveBy(1.1666666666666667, 0, -4)
	;(nil)[2] = cca.moveBy(1.1666666666666667, 0, 4)
	;(nil)[3] = cca.moveBy(1.1666666666666667, 0, 4)
	;(nil)[4] = cca.moveBy(1.1666666666666667, 0, 4)
	;(nil)[5] = cca.moveBy(1.1666666666666667, 0, 4)
	self.fireBall:runAction(cca.repeatForever(cca.seq(nil)))
	self.lightImg = display.newSprite("#dh_guaiwuball1_01.png")
	local frames = display.newFrames("dh_guaiwuball1_%02d.png", 1, 30)
	local animation = display.newAnimation(frames, 0.08333333333333333)
	self.lightImg:playAnimationForever(animation)
	self.bgImage:addChild(self.lightImg, 2)
	self.lightImg:setPosition(218, 175)
	self.bgImage:setScale(0.9)
	self.bgImage:setPosition(0, -23)
	self:_initData()
end
function worldMapDesertMeteorite:_initData()
end
function worldMapDesertMeteorite:addCacheBefore()
end
function worldMapDesertMeteorite:setBatchNodeGroupID(groupID)
end
function worldMapDesertMeteorite:initInstanceData(remainsData)
	self:updateData(remainsData)
end
function worldMapDesertMeteorite:updateData(data)
	if not data then
		return
	end
end
function worldMapDesertMeteorite:onClickInstance(onShowView)
	self:playClickSound()
	local myKindomID = gametop.playertop_:getMapID()
	local isSelfKindom = myKindomID == self.kingdomID
	print("worldMapDesertMeteorite:onClickInstance", myKindomID, self.kingdomID, isSelfKindom)
	if isSelfKindom then
	end
	SoraDShowMsgTip(i18n("pickup_star_025"))
	return nil, false
end
function worldMapDesertMeteorite:playClickSound()
	SoraDPlaySound("worldmap", 7)
end
function worldMapDesertMeteorite:checkIsSelfIn()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl.kingdomMapCell:hasMyQueueToMapObj(self.instanceID, gMapMoveLineServerType.exploreDesertMeteorite, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
		return true
	end
end
return worldMapDesertMeteorite

local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local worldMapDailySaluteBuild = class("worldMapDailySaluteBuild", function()
	local target = include("worldMapInstance").new("worldMapDailySaluteBuild")
	return target
end)
function worldMapDailySaluteBuild:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapDailySaluteBuild:_initData()
end
function worldMapDailySaluteBuild:_initUI()
	local obj = fguiHelper.createObject("Activity_9001688", "worldMapFastGun")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.controllers = fguiHelper.get_controllers(obj)
	self.fields.Label_time:setTimeEndListener(function()
		self:updateData(self.data)
		self.fields.mv:setPlaying(true)
		self:showEffect()
	end)
	self.fields.mv:setAllFrameName("Nzypc_gj_w_%.2d.png", 1)
	self.fields.mv:Rewind()
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("daily_salute_text26", nil)
	end)
end
function worldMapDailySaluteBuild:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self:updateData(siteData)
end
function worldMapDailySaluteBuild:showEffect()
	self:removeChildByName("effect", true)
	self:stopActionByTag(996)
	local _ENV, seqActions = self.stopActionByTag, self.stopActionByTag
	for i = 1, 3 do
		table.insert(seqActions, cca.callFunc(function()
			self.fields.mv:setPlaySettings(0, -1, 1, -1)
		end))
		table.insert(seqActions, cca.delay(0.7))
		table.insert(seqActions, cca.callFunc(function()
			self:createEffect(2)
		end))
	end
	local seq = cca.seq(seqActions)
	seq:setTag(996)
	self:runAction(seq)
end
function worldMapDailySaluteBuild:createEffect(effectType)
	local imgName = effectType == 1 and "dh_9001597_firelv1_%02d.png" or "dh_9001597_firelv2_%02d.png"
	local sp = display.newSprite(string.format("#%s", string.format(imgName, 1)))
	sp:setName("effect")
	sp:setOpacity(0)
	_UPVALUE2_ = string.format("#%s", string.format(imgName, 1))
	string.format("#%s", string.format(imgName, 1))[1] = cca.delay(0.016666666666666666)
	string.format("#%s", string.format(imgName, 1))[2] = cca.fadeIn(0)
	string.format("#%s", string.format(imgName, 1))[3] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 29)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		sp:playAnimationOnce(animation, true)
	end)
	string.format("#%s", string.format(imgName, 1))[4] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 29)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		sp:playAnimationOnce(animation, true)
	end)
	sp:runAction(cca.seq(string.format("#%s", string.format(imgName, 1))))
	self:addChild(sp, 5)
	if effectType == 1 then
		sp:setPosition(cc.p(-160, 85))
	else
		sp:setPosition(cc.p(-180, 93))
	end
	return sp
end
function worldMapDailySaluteBuild:updateData(data)
	dump(data, "worldMapDailySaluteBuild:updateData")
	if not data then
		return
	end
	self.data = data
	local state, nextStateTime = activity_9001688_Ctrl:getCycleState()
	if state == 0 and 0 < nextStateTime then
		self.fields.Label_time:beginTime(nextStateTime)
	else
		local nextTime = activity_9001688_Ctrl:getNextFireTime()
		self.fields.Label_time:beginTime(nextTime)
	end
end
function worldMapDailySaluteBuild:onClickInstance()
	SoraDPlaySound()
	local isSelfKindom = SoraDGetKid() == worldMapDefine.currentMapKindomID
	if isSelfKindom and SoraDGetCtrl("lordInfoCtrl"):isInSelfKid() then
		uiManager:show("Activity_9001688_Pop")
	end
end
return worldMapDailySaluteBuild

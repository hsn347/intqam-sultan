local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local activity_9001721_Read = include("activity_9001721_Read")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local worldMapCaptureMonkey = class("worldMapCaptureMonkey", function()
	local target = include("worldMapInstance").new("worldMapCaptureMonkey")
	return target
end)
function worldMapCaptureMonkey:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapCaptureMonkey:_initData()
	self.warStatus = gKingdomWarStatusType.close
end
function worldMapCaptureMonkey:_initUI()
	local obj = fguiHelper.createObject("Activity_9001721", "worldMapMonkeyBoss")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.controllers = fguiHelper.get_controllers(obj)
	self.transtions = fguiHelper.get_transitions(obj)
	self.fields.Bar:setMax(100)
	self.fields.Text_name:setString(i18n("worldboss_monkey_08"))
	self.fields.Label_time:setTimeEndListener(function()
		self.fields.Label_time:setVisible(false)
	end)
	self.fields.Bar:setScaleX(SoraDFIsRA() and 1 or -1)
	self.transtions.t1:setHook("show", function()
		self.fields.prefabEx:setVisible(true)
	end)
	self.transtions.t1:setHook("hide", function()
		self.fields.prefabEx:setVisible(false)
	end)
end
function worldMapCaptureMonkey:addCacheBefore()
	self:doStopAllActions()
end
function worldMapCaptureMonkey:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001721_UPDATE", handler(self, self.updateData))
end
function worldMapCaptureMonkey:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self:updateData()
end
function worldMapCaptureMonkey:updateData(data)
	local isAlive = activity_9001721_Ctrl:isBossAlive()
	local leftLift = activity_9001721_Ctrl:getBossLeftLife()
	self.fields.Bar:setValue(isAlive and leftLift or 100)
	local leftATKNum = activity_9001721_Ctrl:getBossLeftAttackNum()
	local leftTime = activity_9001721_Ctrl:getBossResetTime()
	if 0 < leftTime and 0 < leftATKNum then
		self.fields.Label_time:setVisible(true)
		self.fields.Label_time:beginTime(leftTime)
	else
		self.fields.Label_time:setVisible(false)
	end
end
function worldMapCaptureMonkey:addFireEffect(fightTime)
	self:beginAttack()
	_UPVALUE1_ = self
	self[1] = ffa.delay(fightTime)
	self[2] = ffa.callFunc(function()
		self:doStandingAnimation()
	end)
	self[3] = ffa.callFunc(function()
		self:doStandingAnimation()
	end)
	local seq = ffa.seq(self)
	self.fields.boss_gj:runAction(seq)
end
function worldMapCaptureMonkey:beginAttack()
	self:doStopAllActions()
	self:doFightingAnimation()
	SoraDPlaySound("worldmap", 3)
end
function worldMapCaptureMonkey:doFightingAnimation()
	self.controllers.c1:setSelectedIndex(1)
end
function worldMapCaptureMonkey:doStandingAnimation()
	self:doStopAllActions()
	self.controllers.c1:setSelectedIndex(0)
end
function worldMapCaptureMonkey:doStopAllActions()
	self.fields.boss_gj:stopAllActions()
end
function worldMapCaptureMonkey:onClickInstance()
	SoraDPlaySound()
	local gametop = gModuleMgr.getObject("gametop")
	local isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	if not isSelfKindom then
		return
	end
	if lordInfoCtrl:getSourceKid() > 0 then
		SoraDShowMsgTip(i18n("worldboss_monkey_19"))
		return
	end
	_ENV = i18n("worldboss_monkey_19")
	i18n("worldboss_monkey_19").instanceID = self:getInstanceID()
	uiManager:show("Activity_9001721_Info", i18n("worldboss_monkey_19"))
end
return worldMapCaptureMonkey

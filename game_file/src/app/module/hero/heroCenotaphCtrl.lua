local GameModule = include("GameModule")
local heroCenotaphCtrl = class("heroCenotaphCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
function heroCenotaphCtrl:ctor(properties)
	heroCenotaphCtrl.super.ctor(self, properties)
	heroCenotaphCtrl = heroCenotaphCtrl.super.ctor
	heroCenotaphCtrl.super.ctor[gBuffEffect.TROOP_ATTACK_BOOST] = BUILD_LVINFO.ATTACK
	heroCenotaphCtrl.super.ctor[gBuffEffect.TROOP_DEFENSE_BOOST] = BUILD_LVINFO.DEFENSE
	heroCenotaphCtrl.super.ctor[gBuffEffect.TROOP_HP_BOOST] = BUILD_LVINFO.LIFE
	self.buff2BuildAttr, heroCenotaphCtrl.super.ctor[gBuffEffect.MARCH_SPEED_BOOST] = heroCenotaphCtrl.super.ctor, BUILD_LVINFO.BSPEED
end
function heroCenotaphCtrl:EnterGame()
	self:resetData()
	self:registerNotify()
end
function heroCenotaphCtrl:resetData()
	self.handle_notify = nil
end
function heroCenotaphCtrl:Logout()
	self:resetData()
	heroCenotaphCtrl.super.Logout(self)
end
function heroCenotaphCtrl:initClientData(data)
	dump(data, "heroCenotaphCtrl:initClientData====", 10)
	if not data then
		return
	end
end
function heroCenotaphCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_CENOTAPH, handler(self, self.notifyHandler))
end
function heroCenotaphCtrl:notifyHandler(event)
	if event and type(event.data) == "table" and next(event.data) then
		for _, content in pairs(event.data) do
			if type(content) == "table" then
				local queueCtrl = gametop.playertop_:getModule("queueCtrl")
				local queuetype = gQueueTypeDef.hero_cenotaph
				if content.nType == 1 then
					local queueData = content.queueData
					if queueData and queueData.starttime and queueData.totaltime and queueData.ottime then
						queueCtrl:removeQueue(queuetype)
						local starttime = queueData.starttime
						local totaltime = queueData.totaltime
						local ottime = queueData.ottime
						local nowtime = serviceFunctions.systemTime()
						local lasttime = nowtime - starttime
						local lefttime = totaltime - lasttime
						if lefttime <= 0 then
							lefttime = 0
						end
						queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime)
						local queue = queueCtrl:queryQueue(queuetype)
						if queue then
							queue.ottime = ottime
						end
					end
					_ENV = queueData.totaltime
					queueData.totaltime.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW"
					SoraDSendMessage(queueData.totaltime)
				elseif content.nType == 2 then
					queueCtrl:removeQueue(queuetype)
					_ENV = queueCtrl
					queueCtrl.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW"
					SoraDSendMessage(queueCtrl)
				end
			end
		end
	end
end
function heroCenotaphCtrl:isOpenBlessing()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	return queueCtrl:queryQueue(gQueueTypeDef.hero_cenotaph)
end
function heroCenotaphCtrl:getAttributeList()
	local _ENV, _ENV, array
	;(nil).key = gBuffEffect.TROOP_ATTACK_BOOST
	_ENV, array[1], (nil).value = nil, nil, self:getHeroCenotaphBuffEffect(gBuffEffect.TROOP_ATTACK_BOOST, true)
	;(nil).key = gBuffEffect.TROOP_DEFENSE_BOOST
	_ENV, array[2], (nil).value = nil, nil, self:getHeroCenotaphBuffEffect(gBuffEffect.TROOP_DEFENSE_BOOST, true)
	;(nil).key = gBuffEffect.TROOP_HP_BOOST
	_ENV, array[3], (nil).value = nil, nil, self:getHeroCenotaphBuffEffect(gBuffEffect.TROOP_HP_BOOST, true)
	;(nil).key = gBuffEffect.MARCH_SPEED_BOOST
	array[4], (nil).value = nil, self:getHeroCenotaphBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, true)
	return array
end
function heroCenotaphCtrl:getHeroCenotaphBuffEffect(effectType, noNeedOpen)
	if not self:isOpenBlessing() and not noNeedOpen then
		return
	end
	local tmpAttr = self.buff2BuildAttr[effectType]
	if tmpAttr then
		local bid = BUILDID.HERO_PRISON
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local blv = cityCtrl:getBuildMaxLv(bid)
		local buildLogic = include("buildLogic")
		local ret = buildLogic.getBuildBaseValue(bid, tmpAttr)
		print("heroCenotaphCtrl:getHeroCenotaphBuffEffect ", effectType, blv, tmpAttr, ret)
		return ret
	end
end
return heroCenotaphCtrl

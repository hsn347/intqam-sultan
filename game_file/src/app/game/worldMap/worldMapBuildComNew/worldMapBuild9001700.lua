local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuild9001700 = class("worldMapBuild9001700", worldMapBuildComNew)
function worldMapBuild9001700:ctor(...)
	worldMapBuild9001700.super.ctor(self, ...)
end
function worldMapBuild9001700:_initData(...)
	self.playerID = 0
end
function worldMapBuild9001700:_initUI(...)
end
function worldMapBuild9001700:addCacheBefore(...)
	self:removeFireWork()
end
function worldMapBuild9001700:updateData(data)
	if data.playerID then
		self.playerID = data.playerID
	end
	local eidalSalute = data.eidalSalute
	if eidalSalute then
		if self:checkIsShield() then
			return
		end
		if self.fireworkObj then
			return
		end
		self:initFireWork()
		self:initDataFireWorkList(eidalSalute)
		local delayTime = activity_9001700_Read.getFireWorksDuration()
		local endTime = eidalSalute.eidalSaluteEndTime
		local remainTime = math.max(0, endTime - serviceFunctions.systemTime())
		local remainCount = math.floor(remainTime / delayTime)
		local curIndex = #self.fireWorkList - remainCount
		_ENV = nil
		;(nil)[1] = ffa.callFunc(function(...)
			local _data = self.fireWorkList[curIndex]
			self:updateFireWork(_data)
		end)
		;(nil)[2] = ffa.delay(delayTime)
		;(nil)[3] = ffa.delay(delayTime)
		self.fireworkObj:runAction(ffa.repeatForever(ffa.seq(nil)))
	else
		self:removeFireWork()
	end
end
function worldMapBuild9001700:initDataFireWorkList(eidalSalute)
	local _ENV, ret
	if not eidalSalute.recievedSaluteList then
		local _ENV, recievedSaluteList = eidalSalute.recievedSaluteList, eidalSalute.recievedSaluteList
	end
	for i, v in ipairs(recievedSaluteList) do
		v.idx = i
		v.fireType = activity_9001700_Read.getFireWorksType(v.saluteId)
	end
	table.sort(recievedSaluteList, function(a, b)
		if a.fireType ~= b.fireType then
			return a.fireType > b.fireType
		end
		return a.idx < b.idx
	end)
	table.insertto(ret, recievedSaluteList)
	if not eidalSalute.makedSaluteMap then
		local _ENV, makedSaluteMap = eidalSalute.makedSaluteMap, eidalSalute.makedSaluteMap
	end
	local _ENV, temp = ret, ret
	for k, count in pairs(makedSaluteMap) do
		local saluteId = tonumber(k)
		_ENV = nil
		;(nil).saluteId = saluteId
		;(nil).fireType = activity_9001700_Read.getFireWorksType(saluteId)
		;(nil).count = count
		table.insert(temp, nil)
	end
	table.sort(temp, function(a, b)
		if a.fireType ~= b.fireType then
			return a.fireType > b.fireType
		end
		return a.saluteId < b.saluteId
	end)
	for __, v in ipairs(temp) do
		for i = 1, v.count do
			_ENV = nil
			;(nil).saluteId = v.saluteId
			;(nil).fireType = v.fireType
			table.insert(ret, nil)
		end
	end
	self.fireWorkList = ret
	dump(self.fireWorkList, "==worldMapBuild9001700 self.fireWorkList==")
end
function worldMapBuild9001700:initFireWork(...)
	local obj = fguiHelper.createObject("Activity_9001700", "worldMapBuilding_9001700")
	obj:addTo(self.target_, 11)
	obj:setPosition(self.centerPoint.x, self.centerPoint.y - 200)
	obj:setGroupID(worldMapDefine.GROU_ID.group_animate_object_top)
	self.fireworkObj = obj
	self.fields = fguiHelper.get_fields(obj)
end
function worldMapBuild9001700:updateFireWork(data)
	if not data then
		self:removeFireWork()
		return
	end
	if self:checkIsShield() then
		self.fireworkObj:setVisible(false)
		return
	else
		self.fireworkObj:setVisible(true)
	end
	self:initFireWorksID(data.saluteId)
	if data.uid then
		self.fields.Image_from:setVisible(true)
		self.fields.Text_from:setVisible(true)
		local nickName = data.nickName or data.uid
		local playerName = textParser.formatPlayerName(nil, nickName, data.kid)
		_ENV = nil
		;(nil).name = playerName
		self.fields.Text_from:setString(i18n("eid_fireworks_032", nil))
		self.fields.Image_from:setAlpha(0)
		self.fields.Text_from:setAlpha(0)
		local cfg = activity_9001700_Read.getFireWorksActionConfig()
		_UPVALUE3_ = 0
		;(0)[1] = ffa.delay(cfg[1])
		;(0)[2] = ffa.fadeIn(cfg[2])
		;(0)[3] = ffa.delay(cfg[3])
		;(0)[4] = ffa.fadeOut(cfg[4])
		;(0)[5] = ffa.fadeOut(cfg[4])
		local action = ffa.seq(0)
		self.fields.Image_from:runAction(action)
		self.fields.Text_from:runAction(action)
	else
		self.fields.Image_from:setVisible(false)
		self.fields.Text_from:setVisible(false)
	end
end
function worldMapBuild9001700:removeFireWork(...)
	if self.fireworkObj then
		self.fireworkObj:removeFromParent()
		self.fireworkObj = nil
	end
end
function worldMapBuild9001700:checkIsShield(...)
	local gametop = gModuleMgr.getObject("gametop")
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	if selfPlayerID == self.playerID then
		return false
	end
	return activity_9001700_Ctrl:getIsShieldOther()
end
function worldMapBuild9001700:initFireWorksID(fireWorksID)
	local fileName = ""
	local fireType = activity_9001700_Read.getFireWorksType(fireWorksID)
	if fireType == 2 then
		fileName = "fx_9001700_max.prefab"
	else
		fileName = "fx_9001700_min.prefab"
	end
	self.fields.prefabEx:clearEffect()
	self.fields.prefabEx:setEffectPath(fileName)
	self.fields.prefabEx:setScale(1.1)
	activity_9001700_Read = self.fields.prefabEx.setScale
	self.fields.prefabEx.setScale.dw = 1
	self.fields.prefabEx.setScale.zs = 2
	local self.fields.prefabEx.setScale.zf, select_type = 3, self.fields.prefabEx.setScale
	local fireWorksNeeds = activity_9001700_Read.getFireWorksNeeds(fireWorksID)
	local select1 = fireWorksNeeds[select_type.dw]
	local select2 = fireWorksNeeds[select_type.zs]
	local select3 = fireWorksNeeds[select_type.zf]
	local resource1 = activity_9001700_Read.getFireworkResource(fireType, select_type.dw, select1)
	local resource2 = activity_9001700_Read.getFireworkResource(fireType, select_type.zs, select2)
	local resource3 = activity_9001700_Read.getFireworkResource(fireType, select_type.zf, select3)
	self.fields.prefabEx:setSprite("C_frame", resource1)
	self.fields.prefabEx:setSprite("C_icon", resource2)
	self.fields.prefabEx:setSprite("C_text", resource3)
end
return worldMapBuild9001700

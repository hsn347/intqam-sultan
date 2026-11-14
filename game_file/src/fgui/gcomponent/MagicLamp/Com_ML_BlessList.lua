local baseComponent = require("fgui.base.baseComponent")
local magicLampRead = include("magicLampRead")
local Com_ML_BlessList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_BlessList_1", Com_ML_BlessList)
fgui.register_extension("ui://MagicLamp/Com_ML_BlessList_2", Com_ML_BlessList)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
_ENV = "magicLampCtrl"
;("magicLampCtrl").lamp1 = "dh_zndzf_js_%02d.png"
local _ENV, ("magicLampCtrl").lamp2, aniNames1 = Com_ML_BlessList, "dh_xiagubk_%02d.png", "magicLampCtrl"
Com_ML_BlessList.lamp1 = "G_dh_sdchongzhi_%02d.png"
local Com_ML_BlessList.lamp2, aniNames2 = "dh_zbhd1_%02d.png", Com_ML_BlessList
function Com_ML_BlessList:onInit()
	self.blessIndexMap, _UPVALUE0_ = nil, nil
end
function Com_ML_BlessList:setCustomData(data)
	self.customData = data
end
function Com_ML_BlessList:createItems(blessList, maxLv, curType)
	if self.isCreated then
		return
	end
	self.firstBigBless = nil
	self.isCreated = true
	local _ENV, _ENV, _exName = nil, nil, curType == 1 and "" or 2
	_ENV, (nil)[1], (nil)[7] = nil, nil, true
	;(nil)[2], (nil)[59] = nil, true
	local spIndex
	local _ENV, mapCfgs
	local _ENV, RMaps
	local _ENV, pointIDMap
	local _ENV, pointRMap
	local _ENV, lineRMap
	local curLine = 1
	local index = 1
	for i, v in ipairs(blessList) do
		local blessCfg = v.lv1Cfg
		if maxLv >= blessCfg.PreJinnLv then
			mapCfgs[blessCfg.BlessID] = index
			local preBless1 = blessCfg.PreBlessID[1]
			if spIndex[curType] and spIndex[curType][index] or preBless1 ~= nil and RMaps[preBless1.BlessID] == curLine then
				curLine = curLine + 1
			end
			RMaps[blessCfg.BlessID] = curLine
			local point
			if blessCfg.PointType == 1 then
				point = fgui.UIPackage:createObject("MagicLamp", "Com_ML_Bless_S" .. _exName)
			else
				point = fgui.UIPackage:createObject("MagicLamp", "Com_ML_Bless_M" .. _exName)
				if self.firstBigBless == nil then
					self.firstBigBless = point
				end
			end
			point:setLampType("lamp" .. curType)
			point:setAnchorPoint(cc.p(0.5, 0.5))
			point:setName("bless_" .. index)
			point:addTo(self, 1)
			if not pointRMap[curLine] then
				_ENV = pointRMap[curLine]
			end
			pointRMap[curLine] = pointRMap[curLine]
			_ENV = self
			self.cfg = blessCfg
			self.item = point
			table.insert(pointRMap[curLine], self)
			for i2, v2 in ipairs(blessCfg.PreBlessID) do
				local preBlessRow = RMaps[v2.BlessID] or curLine
				_UPVALUE2_ = cc.p(0.5, 0.5)
				cc.p(0.5, 0.5)[1] = RMaps[v2.BlessID]
				cc.p(0.5, 0.5)[2] = v2.BlessID
				dump(cc.p(0.5, 0.5))
				for i3 = 1, curLine - preBlessRow do
					local line = fgui.UIPackage:createObject("MagicLamp", "Com_ML_Line" .. _exName)
					if i3 == 1 then
						line:setName(string.format("line_%d_%d", mapCfgs[v2.BlessID], index))
					else
						line:setName(string.format("line_%d_%d_%d", mapCfgs[v2.BlessID], index, i3 - 1))
					end
					line:setLampType("lamp" .. curType)
					line:setAnchorPoint(cc.p(0.5, 1))
					line:addTo(self)
					if not lineRMap[preBlessRow + i3 - 1] then
						_ENV = lineRMap[preBlessRow + i3 - 1]
					end
					lineRMap[preBlessRow + i3 - 1] = lineRMap[preBlessRow + i3 - 1]
					_ENV = self
					self.preID = v2.BlessID
					self.ID = blessCfg.BlessID
					self.item = line
					self.index = i3
					self.skip = curLine - preBlessRow
					table.insert(lineRMap[preBlessRow + i3 - 1], self)
				end
			end
			pointIDMap[blessCfg.BlessID] = point
			index = index + 1
		end
	end
	dump(lineRMap, " lineRMap")
	_ENV, _ENV = lineRMap, dump
	lineRMap[65] = 308
	lineRMap[66] = 4
	lineRMap[70] = 308
	_UPVALUE4_, dump[1], lineRMap[71] = lineRMap, lineRMap, 4
	local spPoses = dump
	_UPVALUE3_, lineRMap[1] = 461, 461
	_UPVALUE3_, lineRMap[2] = 461, 308
	_UPVALUE3_, lineRMap[3] = 461, 157
	local _UPVALUE3_, lineRMap[4], poses = 461, 4, lineRMap
	_UPVALUE2_, (461)[1] = 386, 386
	_UPVALUE2_, (461)[2] = 386, 235
	local _UPVALUE2_, (461)[3], poses2 = 386, 82, 461
	;(386)[1] = 308
	local (386)[2], poses3 = 157, 386
	for i, v in ipairs(pointRMap) do
		local pointCount = #v
		for i2, v2 in ipairs(v) do
			local x = 0
			local y = 0
			local cfg = v2.cfg
			local item = v2.item
			if spPoses[curType] and spPoses[curType][mapCfgs[cfg.BlessID]] then
				x = spPoses[curType][mapCfgs[cfg.BlessID]]
			elseif pointCount == 1 then
				x = 235
			elseif pointCount == 4 then
				x = poses[i2]
			elseif pointCount == 3 then
				x = poses2[i2]
			elseif pointCount == 2 then
				x = poses3[i2]
			else
				x = pointIDMap[cfg.BlessID]:getPositionX()
			end
			y = (i - 1) * 180 + 150
			item:setPosition(x + 30, y)
		end
	end
	for i, v in ipairs(lineRMap) do
		for i2, v2 in ipairs(v) do
			local x = 0
			local y = 0
			local point = pointIDMap[v2.preID]
			local point2 = pointIDMap[v2.ID]
			local pos1 = point:getPosition()
			local pos2 = point2:getPosition()
			x = point:getPositionX()
			y = (i - 1) * 180 + 150
			if v2.skip ~= 1 then
				local tmpX = (pos2.x > 269 or pos2.x < 269) and pos2.x or pos1.x
				if v2.index == 1 then
					pos2.y = y + 180
					pos2.x = tmpX
				elseif 2 <= v2.index then
					x = tmpX
					pos1.x = x
					pos1.y = y
				end
			end
			v2.item:setPosition(x, y)
			local length = cc.pGetDistance(pos1, pos2)
			v2.item:setSize(cc.size(23, length + 20))
			local angle = SoraDGetAngleByPos1(pos1, pos2)
			v2.item:setRotation(angle - 90)
		end
	end
end
function Com_ML_BlessList:initData(blessList, maxLv, isFirstIn, scrollToBlessID)
	self.lastActiveObj = nil
	self.scrollToObj = nil
	local lastLightDelayTime = 0
	if self.jinnMaxLv == nil then
		self.jinnMaxLv = maxLv
	end
	local height = 0
	for i, v in ipairs(blessList) do
		local blessObj = self.fields["bless_" .. i]
		self.blessIndexMap[v.BlessID] = i
		if blessObj then
			local isShow = self.jinnMaxLv >= v.lv1Cfg.PreJinnLv
			local delayTime = self:updateLine(v, i, isShow, lastLightDelayTime)
			if isShow then
				height = blessObj:getY() + 150
				local isCanActive, isUpgrade, isReset = blessObj:initData(v, delayTime)
				if isCanActive then
					self.lastActiveObj = blessObj
				end
				blessObj:setBlessClick(handler(self, self.onBlessClick))
				if isUpgrade then
					self:showUnlockAni(blessObj, delayTime)
					lastLightDelayTime = delayTime
				end
				if isReset then
					self:showResetAni(blessObj, delayTime)
				end
				if v.BlessID == scrollToBlessID then
					self._scrollToObj = blessObj
				end
			else
				self.fields["bless_" .. i] = nil
				blessObj:removeFromParent()
			end
		else
		end
	end
	self.fields.bottom:setY(height)
	self.fields.n153:ensureBoundsCorrect()
	self:ensureBoundsCorrect()
	if self._scrollToObj then
		self:scrollToCenter(self._scrollToObj, false)
	elseif isFirstIn and self.lastActiveObj then
		self:scrollToCenter(self.lastActiveObj, false)
	end
end
function Com_ML_BlessList:scrollToCenter(obj, ani)
	local scrollPanel = self:getScrollPane()
	scrollPanel:setPosY(obj:getY() - self:getSize().height / 2 - 100, ani)
end
function Com_ML_BlessList:updateLine(data, index, isShow, lastLightDelayTime)
	local delayTime = 0
	for k, v in pairs(data.lv1Cfg.PreBlessID) do
		local starIdx = self.blessIndexMap[v.BlessID]
		if data.lv ~= 0 then
			delayTime = math.max(self:setLine(starIdx, index, true, false, isShow), delayTime)
		else
			local lv = magicLampCtrl:getBlessLv(data.lv1Cfg.JinnType, v.BlessID)
			if lv == nil or lv < v.lv then
				delayTime = math.max(self:setLine(starIdx, index, false, false, isShow), delayTime)
			else
				delayTime = math.max(self:setLine(starIdx, index, false, true, isShow, lastLightDelayTime), delayTime)
			end
		end
	end
	return delayTime
end
function Com_ML_BlessList:setLine(startIdx, toIdx, isLight, isGray, isShow, lastLightDelayTime)
	if startIdx == toIdx or startIdx == nil or toIdx == nil then
		return 0
	end
	lastLightDelayTime = lastLightDelayTime and lastLightDelayTime or 0
	local name1 = string.format("line_%d_%d", startIdx, toIdx)
	local line1 = self.fields[name1]
	if not line1 then
		return 0
	end
	if line1 and not isShow then
		self.fields[name1] = nil
		line1:removeFromParent()
	end
	local delayTime = 0
	local name2 = string.format("line_%d_%d_1", startIdx, toIdx)
	local line2 = self.fields[name2]
	if line2 and not isShow then
		self.fields[name2] = nil
		line2:removeFromParent()
	end
	local pointName = string.format("point_%d_%d", startIdx, toIdx)
	local point = self.fields[pointName]
	if point and not isShow then
		self.fields[pointName] = nil
		point:removeFromParent()
	end
	if not isShow then
		return 0
	end
	if line1 then
		local isShowAni = line1:initData(isLight, isGray, 1 + lastLightDelayTime * 2)
		if isShowAni then
			delayTime = delayTime + 0.5
		end
	end
	if line2 then
		local isShowAni = line2:initData(isLight, isGray, 2 + lastLightDelayTime * 2)
		if isShowAni then
			delayTime = delayTime + 0.5
		end
		if isLight == false or point == nil or point:isVisible() then
			return delayTime
		end
		point:setVisible(true)
		if isShowAni then
			point:stopAllActions()
			point:runAction(ffa.seq(ffa.delay(0.5), ffa.callFunc(function()
				point:setAllFrameName("dh_zndzf_ljd_%02d.png", 1)
				point:setPlaySettings(0, -1, -1)
			end)))
		else
			point:setAllFrameName("dh_zndzf_ljd_%02d.png", 1)
			point:setPlaySettings(0, -1, -1)
		end
	end
	return delayTime
end
function Com_ML_BlessList:showUnlockAni(obj, delayTime)
	self:showAnimation(self.fields.ani_unlock, aniNames1[self.customData], obj, delayTime)
end
function Com_ML_BlessList:showResetAni(obj, delayTime)
	self:showAnimation(self.fields.ani_reset, aniNames2[self.customData], obj, delayTime)
end
function Com_ML_BlessList:showAnimation(ani_widget, frameName, obj, delayTime)
	ani_widget:setVisible(false)
	local pos = obj:getPosition()
	local addY = obj.data.cfg.PointType == 2 and -10 or 0
	ani_widget:setPosition(cc.p(pos.x, pos.y + addY))
	ani_widget:stopAllActions()
	ani_widget:runAction(ffa.seq(ffa.delay(delayTime), ffa.callFunc(function()
		ani_widget:setVisible(true)
		ani_widget:setAllFrameName(frameName, 1)
		ani_widget:setPlaySettings(0, -1, 1, -1, function()
			ani_widget:setVisible(false)
		end)
	end)))
end
function Com_ML_BlessList:setBlessClick(callback)
	self.callback = callback
end
function Com_ML_BlessList:onBlessClick(data, startPos, obj)
	if self.callback then
		self.callback(data, startPos, obj)
	end
end
function Com_ML_BlessList:gameGuide_getTarget(itemName, parameters)
	if itemName == "bless" then
		return self.firstBigBless or self.fields.bless_24
	end
	return self.fields[itemName]
end
return Com_ML_BlessList

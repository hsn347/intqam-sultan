local manorCityRead = include("manorCityRead")
local instanceFactory = include("instanceFactory")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local allianceHelp = SoraDGetCtrl("allianceHelp")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ManorCityInstance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/ManorCityInstance", ManorCityInstance)
function ManorCityInstance:onInit()
	self:setTouchable(false)
end
function ManorCityInstance:onShow()
end
function ManorCityInstance:initInstanceData(data, player, isInLayout)
	dump(data, "==ManorCityInstance:initInstanceData==")
	self.data = data
	self.isInVisit = player ~= nil
	self.player = player
	self.isInLayout = isInLayout
	self.buildID = data.id
	self.tilePos = cc.p(data.x, data.y)
	self.buildType = manorCityRead.getBuildType(data.id)
	local buildSize = manorCityRead.getBuildSize(self.buildID)
	self.holdSize = buildSize[1]
	self.tilesArray = instanceFactory.getTilesArrayByInstace(self.tilePos, self.holdSize)
	local buildIcon = manorCityRead.getBuildImage(self.buildID, data.extra)
	self.fields.Image_build:setURL(buildIcon)
	_ENV = self.fields.Image_build.setURL
	self.fields.Image_build.setURL[3101] = cc.p(0, -128)
	self.fields.Image_build.setURL[3102] = cc.p(0, -74)
	self.fields.Image_build.setURL[3103] = cc.p(0, -78)
	self.fields.Image_build.setURL[3104] = cc.p(0, -32)
	self.fields.Image_build.setURL[3105] = cc.p(0, -40)
	self.fields.Image_build.setURL[3201] = cc.p(0, 0)
	self.fields.Image_build.setURL[3202] = cc.p(0, 0)
	self.fields.Image_build.setURL[3203] = cc.p(0, -20)
	self.fields.Image_build.setURL[3204] = cc.p(0, -70)
	self.fields.Image_build.setURL[3205] = cc.p(0, -8)
	self.fields.Image_build.setURL[3206] = cc.p(0, -14)
	self.fields.Image_build.setURL[3207] = cc.p(0, -45)
	self.fields.Image_build.setURL[3301] = cc.p(-90, -96)
	self.fields.Image_build.setURL[3302] = cc.p(0, -38)
	self.fields.Image_build.setURL[3303] = cc.p(-16, -68)
	self.fields.Image_build.setURL[3304] = cc.p(-46, -48)
	self.fields.Image_build.setURL[3305] = cc.p(0, -32)
	self.fields.Image_build.setURL[3306] = cc.p(-8, -90)
	self.fields.Image_build.setURL[3307] = cc.p(0, -46)
	self.fields.Image_build.setURL[3308] = cc.p(-58, -117)
	self.fields.Image_build.setURL[3309] = cc.p(-56, -118)
	local self.fields.Image_build.setURL[3310], offsetConfig = cc.p(-44, -94), self.fields.Image_build.setURL
	local offset = offsetConfig[self.buildID] or cc.p(0, 0)
	self.fields.Image_build:setPosition(offset)
	if self.isInLayout then
		return
	end
	if self.buildID == MANOR_BUILD_ID.BUILD_3302 then
		self.fields.Image_build:setVisible(false)
		local Com_build = fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")
		Com_build:addTo(self)
		self.Com_build = Com_build
		local mv_top = Com_build:getChild("mv_top")
		mv_top:setAllFrameName("Manor_Architecture_20_%02d.png", 1)
	end
	_ENV = Com_build
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3301] = cc.p(0, -56)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3302] = cc.p(0, -80)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3303] = cc.p(12, -70)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3304] = cc.p(-15, -55)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3305] = cc.p(12, -22)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3306] = cc.p(0, -84)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3307] = cc.p(0, -46)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3308] = cc.p(4, -113)
	fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3309] = cc.p(0, -114)
	local _ENV, fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")[3310], offsetConfig = cc.p(4, -89), cc.p(4, -89), fgui.UIPackage:createObject("ManorCity", "Manor_Architecture_20")
	cc.p(4, -89)[3306] = 1.4
	cc.p(4, -89)[3308] = 1.4
	cc.p(4, -89)[3309] = 1.4
	local cc.p(4, -89)[3310], scaleConfig = 1.4, cc.p(4, -89)
	if self.buildType == MANOR_BUILD_TYPE.COLLECTION then
		local effectPath = manorCityRead.getDressEffectPath(self.buildID)
		if effectPath then
			local obj = fgui.UIPackage:createObject("CommonNew", "Com_prefabEX")
			obj:addTo(self)
			obj:setEffectPath(effectPath)
			local offset = offsetConfig[self.buildID] or cc.p(0, 0)
			obj:setPosition(offset)
			local scale = scaleConfig[self.buildID] or 1.67
			obj:setScale(scale)
			self.effectObj = obj
		end
	end
	if self.buildID == MANOR_BUILD_ID.FARM and data.iid then
		self:updateFarm()
	end
end
function ManorCityInstance:updateInstance(data)
	self.data = data
	if self.buildID == MANOR_BUILD_ID.FARM then
		self:updateFarm()
	end
end
function ManorCityInstance:getInstanceData()
	return self.data
end
function ManorCityInstance:setInstanceData(data)
	self.data = data
end
function ManorCityInstance:getRealId()
	return self.data.realId
end
function ManorCityInstance:getBuildID()
	return self.buildID
end
function ManorCityInstance:getTilePos()
	return self.tilePos
end
function ManorCityInstance:setTilePos(tilePos)
	self.tilePos = tilePos
end
function ManorCityInstance:getHoldSize()
	return self.holdSize
end
function ManorCityInstance:getTilesArray()
	return self.tilesArray
end
function ManorCityInstance:setTilesArray(tilesArray)
	self.tilesArray = tilesArray
end
function ManorCityInstance:getFarmType()
	return self.data.farmType
end
function ManorCityInstance:getExtra()
	return self.data.extra
end
function ManorCityInstance:getiid()
	return self.data.iid or 0
end
function ManorCityInstance:getFarmUI()
	return self.farmUI
end
function ManorCityInstance:updateZOrder()
	local tilePos = self:getTilePos()
	local zorder = tilePos.x + self.holdSize / 2 + tilePos.y + self.holdSize / 2
	self:setSortingOrder(zorder)
end
function ManorCityInstance:getQueue()
	local bid = self.data.id
	local iid = self.data.iid
	local queue = queueCtrl:queryQueue(gQueueTypeDef.garden_build_upgrade)
	if not queue then
		return nil
	end
	local _data = queue.data
	if _data.bid == bid and _data.iid == iid then
		return queue
	end
end
function ManorCityInstance:getQueueType()
	local queue = self:getQueue()
	if queue then
		return tonumber(queue.qtype)
	end
end
function ManorCityInstance:getIsNeedReqHelp()
	if not self:getReqHelpQueueTypeList() then
		local _UPVALUE0_, queueTypeList = self:getReqHelpQueueTypeList(), self:getReqHelpQueueTypeList()
	end
	return 0 < #queueTypeList
end
function ManorCityInstance:getIsFarmPlanted()
	if not self.data.extra.plant then
		_ENV = self.data.extra.plant
	end
	return not serviceFunctions.isNilOrZero(self.data.extra.plant.seedId)
end
function ManorCityInstance:getIsFarmCanHelp()
	local isPlanted = self:getIsFarmPlanted()
	if not isPlanted then
		return false
	else
		local planting = serviceFunctions.systemTime() < self.data.extra.plant.fruitTime
		if not planting then
			return false
		elseif manorCityCtrl:getTodayFarmHelped(self.player.uid, self.data.iid) then
			return false
		else
			return true
		end
	end
end
function ManorCityInstance:getReqHelpQueueTypeList()
	local queueCtrl, ret
	local queueType = self:getQueueType()
	if queueType and queueCtrl:isNeedReqHelp(queueType) then
		table.insert(ret, queueType)
	end
	if self.buildID == MANOR_BUILD_ID.SMART_PALACE then
		local queueType = gQueueTypeDef.garden_technology
		local queue = queueCtrl:queryQueue(queueType)
		if queue and queueCtrl:isNeedReqHelp(queueType) then
			table.insert(ret, queueType)
		end
	end
	return ret
end
function ManorCityInstance:doReqHelp()
	local queueTypeList = self:getReqHelpQueueTypeList()
	for i, queueType in ipairs(queueTypeList) do
		self:doReqHelpByQueueType(queueType)
	end
	self:hideTopTipEffect()
	self:checkShowTopTip()
end
function ManorCityInstance:doReqHelpByQueueType(queueType)
	local _ENV, data
	if queueType == gQueueTypeDef.garden_build_upgrade then
		local buildLv = manorCityCtrl:getBuildLv(self.data.realId)
		_ENV = manorCityCtrl
		manorCityCtrl.bid = self.data.id
		data, manorCityCtrl.blv = manorCityCtrl, buildLv + 1
	elseif queueType == gQueueTypeDef.garden_technology then
		local collegeData = technologyCtrl:studyingTechnology(queueType)
		_ENV = technologyCtrl
		data, technologyCtrl.techid = technologyCtrl, tonumber(collegeData.technologyID)
	end
	dump(data, "==ManorCityInstance:doReqHelpByQueueType==")
	allianceHelp:reqAllianceHelp(queueType, data)
end
function ManorCityInstance:checkShowTopTip()
	local tipType
	if self.isInVisit then
		if self.buildID == MANOR_BUILD_ID.FARM then
			if manorCityUtil.checkFuncUnlockVisit("GARDEN_UNLOCK_FARMLAND", false) and self:getIsFarmCanHelp() then
				tipType = MANOR_TOPTIP_TYPE.FARM_HELP
			end
		elseif self.buildID == MANOR_BUILD_ID.BANQUET then
			tipType = MANOR_TOPTIP_TYPE.BANQUET
		end
	else
		if self.buildID == MANOR_BUILD_ID.FARM then
			tipType = MANOR_TOPTIP_TYPE.FARM
		elseif self.buildID == MANOR_BUILD_ID.FARM_RESEARCH then
			if manorCityCtrl:getFirstReadyMergeSeedData() then
				tipType = MANOR_TOPTIP_TYPE.MERGE_SEED
			end
		elseif self.buildID == MANOR_BUILD_ID.BANQUET then
			tipType = MANOR_TOPTIP_TYPE.BANQUET
		end
		if self:getIsNeedReqHelp() then
			tipType = MANOR_TOPTIP_TYPE.HELP
		end
	end
	if tipType then
		self:showTopTipEffect(tipType)
	else
		self:hideTopTipEffect()
	end
end
function ManorCityInstance:showTopTipEffect(tipType)
	self.tipType = tipType
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_BUILD_TOP_TIP_ADD"
	;(nil).data = self.data
	;(nil).tipType = tipType
	SoraDSendMessage(nil)
end
function ManorCityInstance:hideTopTipEffect()
	self.tipType = nil
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_BUILD_TOP_TIP_REMOVE"
	;(nil).data = self.data
	SoraDSendMessage(nil)
end
function ManorCityInstance:updateFarm()
	if self.isInLayout then
		return
	end
	local plantData = self.data.extra.plant
	if self:getIsFarmPlanted() then
		local stage, progress = manorFarmRead.getFarmStage(plantData.seedTime, plantData.fruitTime)
		self.fields.Image_build:setURL(stage.icon)
	else
		local buildIcon = manorCityRead.getBuildImage(self.buildID)
		self.fields.Image_build:setURL(buildIcon)
		self:checkShowTopTip()
	end
end
function ManorCityInstance:showFarmUI()
	if self.isInLayout then
		return
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_BUILD_FARMUI_ADD"
	;(nil).data = self.data
	;(nil).isInVisit = self.isInVisit
	SoraDSendMessage(nil)
end
function ManorCityInstance:showBanquetUI()
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_BUILD_BANQUETUI_ADD"
	;(nil).data = self.data
	;(nil).isInVisit = self.isInVisit
	SoraDSendMessage(nil)
end
function ManorCityInstance:onClickInstance()
	if self:getIsNeedReqHelp() then
		self:doReqHelp()
		return true
	end
end
function ManorCityInstance:playAppearEffect()
	self:stopAllActions()
	self:setScale(1)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.1, 1.04)
	;(nil)[2] = ffa.scaleTo(0.13333333333333333, 1)
	;(nil)[3] = ffa.scaleTo(0.13333333333333333, 1)
	;(nil)[4] = ffa.scaleTo(0.13333333333333333, 1)
	self:runAction(ffa.seq(nil))
end
return ManorCityInstance

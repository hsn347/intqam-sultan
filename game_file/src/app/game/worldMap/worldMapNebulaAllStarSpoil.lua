local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local worldMapNebulaAllStarSpoil = class("worldMapNebulaAllStarSpoil", function()
	local target = include("worldMapInstance").new("worldMapNebulaAllStarSpoil")
	return target
end)
function worldMapNebulaAllStarSpoil:ctor()
	self.ignoreRequest = true
	self:_initData()
	self:_initUI()
end
function worldMapNebulaAllStarSpoil:_initData()
	self.instanceType = gMapObjTypeDef.nebulaAllStarWarBuilding
	self.subType = gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil
end
function worldMapNebulaAllStarSpoil:_initUI()
	self.modelImage = display.newSprite("#icon_qmx_zhanlipin.png")
	self.modelImage:setPositionY(35)
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_monster)
	_ENV = self.modelImage
	self.modelImage.subType = self.subType
	self.modelImage.parent = self
	self.modelImage.pos = cc.p(0, 35)
	self.modelImage.Sprite_build = self.modelImage
	self.modelImage.groupID = worldMapDefine.GROU_ID.group_level_monster
	nebulaAllStarUtil.getBuildSpriteEffect(self.modelImage)
	self.image_count_bg = display.newSprite("#frame_SJDT_mingpai.png")
	self.image_count_bg:setContentSize(cc.size(231, 25))
	self.image_count_bg:setOpacity(178.5)
	self.image_count_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_count_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 30))
	self.image_count_bg:addTo(self, 1)
	self.image_count_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_count_bg
	self.image_count_bg.UILabelType = 2
	self.image_count_bg.text = ""
	self.image_count_bg.size = 18
	self.text_Count = SoraDCreateLabel(self.image_count_bg)
	self.text_Count:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Count:setColor(cc.c3b(255, 212, 62))
	self.text_Count:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 31))
	self.text_Count:addTo(self, 1)
	self.text_Count:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_name_bg = display.newSprite("#frame_SJDT_mingpai.png")
	self.image_name_bg:setContentSize(cc.size(231, 25))
	self.image_name_bg:setOpacity(178.5)
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 60))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = i18n("NebulaAllstar_154")
	self.image_name_bg.size = 18
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setColor(cc.c3b(255, 235, 185))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 61))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_time_bg = display.newSprite("#frame_SJDT_mingpai.png")
	self.image_time_bg:setContentSize(cc.size(173, 25))
	self.image_time_bg:setOpacity(178.5)
	self.image_time_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_time_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 90))
	self.image_time_bg:addTo(self, 1)
	self.image_time_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_time_bg
	self.image_time_bg.UILabelType = 2
	self.image_time_bg.text = "00:00:00"
	self.image_time_bg.size = 18
	self.text_time = cc.ui.UILabel.new(self.image_time_bg)
	self.text_time:setColor(cc.c3b(255, 235, 185))
	self.text_time:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_time:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 91))
	self.text_time:addTo(self, 1)
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.icon_hourglass = display.newSprite("#icon_hourglass.png")
	self.icon_hourglass:setAnchorPoint(cc.p(0.5, 0.5))
	self.icon_hourglass:setPosition(cc.p(SoraDFIsRA() and self.centerPoint.x + 50 or self.centerPoint.x - 50, self.text_time:getPositionY()))
	self.icon_hourglass:setScale(0.5)
	self.icon_hourglass:addTo(self, 1)
	self.icon_hourglass:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.PlunderSpanTime = nebulaAllStarRead.getConstValue("PlunderSpanTime", 600)
	self.PickPlunderMax = nebulaAllStarRead.getConstValue("PickPlunderMax", 2)
	self.PlunderRewardTimes = nebulaAllStarRead.getConstValue("PlunderRewardTimes", 20)
end
function worldMapNebulaAllStarSpoil:initInstanceData(data)
	dump(data, "==worldMapNebulaAllStarSpoil:initInstanceData==")
	self:updateData(data)
end
function worldMapNebulaAllStarSpoil:updateData(data)
	self.data = data
	self:updateCollectData()
end
function worldMapNebulaAllStarSpoil:updateCollectData()
	self.lastTime = self.data.t + self.PlunderSpanTime - serviceFunctions.systemTime()
	self.text_time:removeTime()
	self.isCollecting = nebulaAllStarCtrl:getCollectingTime(self.data.id) ~= nil
	_UPVALUE2_ = nebulaAllStarCtrl
	nebulaAllStarCtrl[1] = self.lastTime
	nebulaAllStarCtrl[2] = self.isCollecting
	dump(nebulaAllStarCtrl, "self.lastTime")
	if not self.isCollecting then
		self.text_time:beginTime(self.lastTime)
	else
		self.text_time:setString(SoraDConvertSecondToString(self.lastTime))
	end
	local collectCount = nebulaAllStarCtrl:getCollectCount()
	_ENV = SoraDConvertSecondToString(self.lastTime)
	SoraDConvertSecondToString(self.lastTime).num = math.max(0, self.PlunderRewardTimes - collectCount)
	self.text_Count:setString(i18n("NebulaAllstar_157", SoraDConvertSecondToString(self.lastTime)))
end
function worldMapNebulaAllStarSpoil:showCollecting(delay)
	local size = self:getContentSize()
	local pos = cc.p(self.centerPoint.x, self.centerPoint.y + 140)
	local bgSp = display.newSprite("#frame_main_receive.png")
	bgSp:setPosition(pos.x, pos.y)
	bgSp:addTo(self, 2)
	local iconSp = display.newSprite("#icon_map_operate_21.png")
	iconSp:setScale(0.5)
	iconSp:setPosition(pos.x, pos.y + 4)
	iconSp:addTo(self, 2)
	self.progress = display.newProgressTimer("#framer_yd_jdt_01.png", display.PROGRESS_TIMER_RADIAL)
	self.progress:setScale(0.75)
	self.progress:setPosition(pos.x, pos.y + 5)
	self.progress:addTo(self, 2)
	function self.progress.setPercent(target, value)
		target:setPercentage(value)
	end
	self.progress = SoraDCreateScoreBar(self.progress)
	self.progress:runScoreAnimation(0, 100, 100, delay)
end
function worldMapNebulaAllStarSpoil:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if SoraDFIsRA() then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_shiqu
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
	else
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_shiqu
		table.insert(buttonTypeArray, nil)
	end
	dump(self.data, "worldMapNebulaAllStarSpoil:onClickTipButton")
	dump(buttonTypeArray, "worldMapNebulaAllStarSpoil:getInstanceOp")
	return buttonTypeArray
end
function worldMapNebulaAllStarSpoil:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	dump(tipButtonType, "tipButtonType")
	if tipButtonType == worldMapDefine.worldMapTipButtonType_shuoMing then
		nebulaAllStarUtil.showSingleFAQ("viewerGift")
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_nebulaAllStar_shiqu then
		if self.isCollecting then
			SoraDShowMsgTip(i18n("NebulaAllstar_265"))
			return true
		end
		local collectingNum = nebulaAllStarCtrl:getCollectSpoilQueueCount()
		if collectingNum >= self.PickPlunderMax then
			SoraDShowMsgTip(i18n("NebulaAllstar_264"))
			return true
		end
		nebulaAllStarCtrl:reqViewerCollectSpoil(self.data.id)
		return true
	end
	return false
end
function worldMapNebulaAllStarSpoil:getSpoilId(...)
	return self.data.id
end
return worldMapNebulaAllStarSpoil

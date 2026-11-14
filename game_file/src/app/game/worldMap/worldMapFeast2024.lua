local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
local activity_9001625_Read = include("activity_9001625_Read")
local worldMapFeast2024 = class("worldMapFeast2024", function()
	local target = include("worldMapInstance").new("worldMapFeast2024")
	return target
end)
function worldMapFeast2024:ctor()
	self.modelImage = display.newSprite("#shengyan_maotang.png")
	self.modelImage:setPosition(cc.p(0, 0))
	self:addChild(self.modelImage, -1)
	self.image_LeagueFlag = display.newSprite()
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 90, self.centerPoint.y - 80))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 2)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_name = display.newSprite("#frame_map_07.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_name:addTo(self, 3)
	self.image_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 20
	self.text_Name = SoraDCreateLabel(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 85))
	self.text_Name:setColor(cc.c3b(98, 185, 235))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	local effectLast = SoraDCreatAnimation("hjyt_map_last", nil, true)
	effectLast:setPosition(cc.p(0, 0))
	self:addChild(effectLast, 10)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 115))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	self.progressBar:setVisible(false)
end
function worldMapFeast2024:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", function(target, data)
		self:updateData(self.feastData)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", function(target, data)
		self:updateData(self.feastData)
	end)
end
function worldMapFeast2024:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapFeast2024:initInstanceData(feastClassID, feastData)
	self.feastClassID = feastClassID
	self:updateData(feastData)
end
function worldMapFeast2024:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapFeast2024:updateData==")
	self.feastData = data
	if data.allianceFlag then
		self.image_LeagueFlag:setVisible(true)
		self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(data.allianceFlag))
	end
	local feastId = data.objId
	local allianceAbbr = data.allianceAbbr
	if feastId and allianceAbbr then
		_ENV = allianceDesRead.getFlagIcon(data.allianceFlag)
		allianceDesRead.getFlagIcon(data.allianceFlag).var1 = allianceAbbr
		allianceDesRead.getFlagIcon(data.allianceFlag).var2 = feastId
		self.text_Name:setString(i18n("activity_feastLv_name02", allianceDesRead.getFlagIcon(data.allianceFlag)))
	end
	if data.aid then
		local selfLeagueID = allianceMgr:getOwnAid() or 0
		self.text_Name:setColor(selfLeagueID ~= data.aid and cc.c3b(200, 200, 200) or cc.c3b(98, 185, 235))
	end
	local lastRemainTime = activity_9001625_Ctrl:getRemainTime(data)
	if 0 < lastRemainTime then
		local lastTime = activity_9001625_Ctrl:getFeastLastTime()
		self.progressBar:setTimeValue(lastRemainTime, lastTime)
	end
	self.progressBar:setVisible(0 < lastRemainTime)
	self:updateFinishCount(data)
end
function worldMapFeast2024:updateFinishCount(data)
	_UPVALUE6_ = nil
	_UPVALUE5_, (nil)[1] = 1, 1
	_UPVALUE5_, (nil)[2] = 1, 6
	_UPVALUE5_, (nil)[3] = 1, 2
	_UPVALUE5_, (nil)[4] = 1, 5
	_UPVALUE5_, (nil)[5] = 1, 4
	local _UPVALUE5_, (nil)[6], index2resId = 1, 3, nil
	;(1)[1] = cc.p(-12.46, 80.87)
	;(1)[2] = cc.p(52.69, -11.57)
	;(1)[3] = cc.p(-92.9, 29.36)
	;(1)[4] = cc.p(-46.13, -16.02)
	;(1)[5] = cc.p(102.83, 32.22)
	;(1)[6] = cc.p(53.58, 56.84)
	;(1)[7] = cc.p(53.58, 56.84)
	;(1)[8] = cc.p(53.58, 56.84)
	;(1)[9] = cc.p(53.58, 56.84)
	;(1)[10] = cc.p(53.58, 56.84)
	;(1)[11] = cc.p(53.58, 56.84)
	;(1)[12] = cc.p(53.58, 56.84)
	;(1)[13] = cc.p(53.58, 56.84)
	;(1)[14] = cc.p(53.58, 56.84)
	;(1)[15] = cc.p(53.58, 56.84)
	;(1)[16] = cc.p(53.58, 56.84)
	;(1)[17] = cc.p(53.58, 56.84)
	;(1)[18] = cc.p(53.58, 56.84)
	local (1)[19], index2Pos = cc.p(53.58, 56.84)
	local finishCount = data.finishCount or 0
	local modelType = activity_9001625_Read.getFeastModelType(finishCount)
	_UPVALUE5_ = finishCount
	finishCount[1] = 0
	finishCount[2] = 1
	finishCount[3] = 2
	finishCount[4] = 4
	local finishCount[5], modelType2people = 6, finishCount
	local peopleMax = modelType2people[#modelType2people]
	local people = modelType2people[modelType] or 0
	for i = 1, people do
		local sprite = self:getChildByName("sprite_" .. i)
		if sprite then
			sprite:setVisible(true)
		else
			local resId = index2resId[i]
			local frameName = string.format("shengyan%02d", resId)
			local imageName = string.format("#shengyan%02d_%02d.png", resId, 1)
			local sprite_1 = display.newSprite(imageName)
			sprite_1:setPosition(index2Pos[i])
			sprite_1:addTo(self, -1)
			sprite_1:setName("sprite_" .. i)
			local frames = display.newFrames(frameName .. "_%02d.png", 1, 12)
			local animation = display.newAnimation(frames, 0.13333333333333333)
			sprite_1:playAnimationForever(animation)
		end
	end
	for i = people + 1, peopleMax do
		local sprite = self:getChildByName("sprite_" .. i)
		if sprite then
			sprite:setVisible(false)
		end
	end
end
function worldMapFeast2024:onClickInstance()
	self:playClickSound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	end
	if allianceMgr:getOwnAid() ~= self.feastData.aid then
		SoraDShowMsgTip(i18n("tips_activity_hjyt_viewOtherUnion"))
		return
	end
	local selectShowPanel = uiManager:show("WorldMapFeastView").view
	selectShowPanel:initData(self.feastData, self.instanceID)
	return selectShowPanel, false
end
function worldMapFeast2024:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
return worldMapFeast2024

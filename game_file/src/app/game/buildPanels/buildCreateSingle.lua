include("cityBuildingInfo")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buildRead = include("buildDescribeRead")
local timerList = gModuleMgr.getObject("timerList")
local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
BUILD_CONDITION_TYPE_BUILD = 1
BUILD_CONDITION_TYPE_RES = 2
BUILD_CONDITION_TYPE_TOOL = 3
BUILD_CONDITION_TYPE_TIME = 4
BUILD_CONDITION_TYPE_WE = 5
BUILD_CONDITION_TYPE_STAR = 6
BUILD_CONDITION_TYPE_ITEM = 7
BUILD_CONDITION_TYPE_NEBULATOWER = 8
local BuildCreateSingle = class("buildCreateSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("buildCreateSingle")
	end
	return SoraDCreateCloneBasePanel(target, "buildCreateSingle")
end)
function BuildCreateSingle:ctor()
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.imgState = SoraDGetChildByName(self, "Image_state")
	self.spriteLuckLine = SoraDGetChildByName(self, "Sprite_luckLine")
	self.labelLuckValue = SoraDGetChildByName(self, "Text_luckValue")
	self.handleCallBack = nil
	self.timer = nil
	self.isMet = false
	self.spriteLuckLine:setPositionY(13)
	self.tableInfoSingleData, _ENV = self.spriteLuckLine.setPositionY, self.spriteLuckLine.setPositionY
	if self.btnJump then
		self.btnJump:addTouchEventListener(handler(self, self.btnJumpCallBack))
	end
end
function BuildCreateSingle:setBtnCallBcak(handle)
	self.handleCallBack = handle
end
function BuildCreateSingle:setScroll(scroll)
	self.scroll = scroll
end
function BuildCreateSingle:collegeOpen()
	local resReducePercent = technologyCtrl:getTechnologyPower(gTechnologyType.BRIGHT_STRENGTHEN_COST_REDUCE) or 0
	local haveRes = cityCtrl:getResCount(self.tableInfoSingleData.singleData.resid)
	local needRes = self.tableInfoSingleData.singleData.rescount * (1 - resReducePercent)
	if not IsArClient and self.tableInfoSingleData.isNormal then
		needRes = self.tableInfoSingleData.singleData.rescount
	end
	if haveRes < needRes then
		self:isConditionMet(false)
		self.isMet = false
	else
		self:isConditionMet(true)
		self.isMet = true
	end
	self.tableInfoSingleData.singleData.rescount = needRes
	self.labelDes:setString(string.formatnumberthousands(needRes))
end
function BuildCreateSingle:luckBlessOpen(open)
	local resCount = 0
	local haveRes = 0
	if open then
		local labelW = self.labelDes:getVirtualRendererSize().width
		haveRes = cityCtrl:getResCount(self.tableInfoSingleData.singleData.resid)
		resCount = luckyBlessCtrl:getResult(self.tableInfoSingleData.singleData.rescount)
		local subPercent = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW) or 0
		resCount = math.ceil(resCount * (1 - subPercent / 1000))
		if resCount == self.tableInfoSingleData.singleData.rescount and subPercent == 0 then
			return
		end
		self.spriteLuckLine:setVisible(true)
		self.labelLuckValue:setVisible(true)
		self.spriteLuckLine:setScaleX(labelW / 616)
		self.labelLuckValue:setString(string.formatnumberthousands(resCount))
		self.labelLuckValue:setPositionX(SoraDFPosX(534 - (labelW + 60), self.labelLuckValue))
		if haveRes < resCount then
			self.labelLuckValue:setColor(display.COLOR_RED)
			self:isConditionMet(false)
			self.isMet = false
		else
			self.labelLuckValue:setColor(display.COLOR_GREEN)
			self:isConditionMet(true)
			self.isMet = true
		end
	else
		self.spriteLuckLine:setVisible(false)
		self.labelLuckValue:setVisible(false)
	end
	return haveRes >= resCount
end
function BuildCreateSingle:radiantBlessOpen(open, isStatue, luckyBlessIsOpen)
	local resCount = 0
	local haveRes = 0
	if open then
		self.spriteLuckLine:setVisible(true)
		self.labelLuckValue:setVisible(true)
		local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
		local labelW = self.labelDes:getVirtualRendererSize().width
		local toolid = self.tableInfoSingleData.singleData.toolid
		local subPercent = 0
		if self.tableInfoSingleData.singleType == BUILD_CONDITION_TYPE_ITEM and toolid == 311001 or toolid == 311101 then
			local backpackCtrl = SoraDGetCtrl("backpackCtrl")
			haveRes = backpackCtrl:getItemCount(self.tableInfoSingleData.singleData.toolid)
			resCount = self.tableInfoSingleData.singleData.toolcount
			local effect, source = radiantDecreeCtrl:getEffectSouce(toolid == 311001 and 3 or 4, isStatue)
			subPercent = buffCtrl:getBuffEffect(effect, source) or 0
			local extremlyPer = buffCtrl:getBuffEffect(effect, gBuffSource.PALACE_OF_WISDOM_ACTIVITY) or 0
			if subPercent == 0 and extremlyPer == 0 then
				self.spriteLuckLine:setVisible(false)
				self.labelLuckValue:setVisible(false)
			end
			resCount = math.ceil(resCount * (1 - subPercent / 1000) * (1 - extremlyPer / 1000))
		else
			haveRes = cityCtrl:getResCount(self.tableInfoSingleData.singleData.resid)
			resCount = luckyBlessIsOpen and luckyBlessCtrl:getResult(self.tableInfoSingleData.singleData.rescount) or self.tableInfoSingleData.singleData.rescount
			subPercent = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW) or 0
			local effect, source = radiantDecreeCtrl:getEffectSouce(1, isStatue)
			local radiantPer = buffCtrl:getBuffEffect(effect, source) or 0
			local extremlyPer = buffCtrl:getBuffEffect(effect, gBuffSource.PALACE_OF_WISDOM_ACTIVITY) or 0
			subPercent = subPercent + radiantPer
			if subPercent == 0 and extremlyPer == 0 then
				self.spriteLuckLine:setVisible(false)
				self.labelLuckValue:setVisible(false)
			end
			resCount = math.ceil(resCount * (1 - subPercent / 1000) * (1 - extremlyPer / 1000))
		end
		if subPercent ~= 0 or extremlyPer ~= 0 then
			self.spriteLuckLine:setScaleX(labelW / 616)
			self.labelLuckValue:setString(string.formatnumberthousands(resCount))
			self.labelLuckValue:setPositionX(SoraDFPosX(534 - (labelW + 60), self.labelLuckValue))
		end
		if haveRes < resCount then
			self.labelLuckValue:setColor(display.COLOR_RED)
			self:isConditionMet(false)
			self.isMet = false
		else
			self.labelLuckValue:setColor(display.COLOR_GREEN)
			self:isConditionMet(true)
			self.isMet = true
		end
	else
		self.spriteLuckLine:setVisible(false)
		self.labelLuckValue:setVisible(false)
	end
	return haveRes >= resCount
end
function BuildCreateSingle:initData(tableInfoSingleData)
	self.tableInfoSingleData = tableInfoSingleData
	self:isConditionMet(self.tableInfoSingleData.singleData.isreach)
	self.isMet = self.tableInfoSingleData.singleData.isreach
	local singleType = self.tableInfoSingleData.singleType
	if singleType == BUILD_CONDITION_TYPE_TIME then
		self:needSpeedUp()
	elseif singleType == BUILD_CONDITION_TYPE_BUILD or singleType == BUILD_CONDITION_TYPE_STAR then
		self:needUpgrade()
	elseif singleType == BUILD_CONDITION_TYPE_RES then
		self:needResource()
		self:collegeOpen()
	elseif singleType == BUILD_CONDITION_TYPE_TOOL or singleType == BUILD_CONDITION_TYPE_WE or singleType == BUILD_CONDITION_TYPE_ITEM then
		self:needTools()
	elseif singleType == BUILD_CONDITION_TYPE_NEBULATOWER then
		self:needNebulaTower()
	end
end
function BuildCreateSingle:needSpeedUp()
	self.btnJump:setTitleText(i18n("common_text_018"))
	local qtype = tonumber(self.tableInfoSingleData.singleData.qtype)
	if gQueueTypeDef.build_mastery == qtype then
		self.imgIcon:loadTexture("icon_tiny_paper.png", ccui.TextureResType.plistType)
		self:openTimeUpMastery()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpMastery))
	elseif gQueueTypeDef.build_star_queue == qtype then
		self.imgIcon:loadTexture("icon_hourglass.png", ccui.TextureResType.plistType)
		self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
		self:openTimeUpStar()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpStar))
	elseif gQueueTypeDef.build_star_queue_privilege == qtype then
		self.imgIcon:loadTexture("icon_hourglass.png", ccui.TextureResType.plistType)
		self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
		self:openTimeUpStarSecond()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpStarSecond))
	else
		self.imgIcon:loadTexture("icon_hourglass.png", ccui.TextureResType.plistType)
		self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
		self:openTimeUp()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
end
function BuildCreateSingle:buildTimerEnd()
	if self.tableInfoSingleData.singleType == BUILD_CONDITION_TYPE_TIME then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		if self.handleCallBack then
			self.handleCallBack(self.tableInfoSingleData)
		end
	end
end
function BuildCreateSingle:openTimeUp(dt)
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	local buildCell = cityCtrl:getBuildCell(self.tableInfoSingleData.singleData.data.bid, self.tableInfoSingleData.singleData.data.iid)
	local queueType = tonumber(buildCell.info.state)
	local typeStr
	if queueType == BUILD_STATE.BUILDING then
		typeStr = "common_text_753"
	elseif queueType == BUILD_STATE.DEMOLISHING then
		typeStr = "common_text_754"
	else
		typeStr = "common_text_755"
	end
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).name = buildName
	local labelLongDes = i18n(typeStr, tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildLogic = include("buildLogic")
	local freeTime = buildLogic.getFreeSpeedUpTime(self.tableInfoSingleData.singleData.blv)
	if leftTime <= freeTime then
		self.btnJump:setTitleText(i18n("common_text_049"))
		self.btnJump:loadTextureNormal("btn_alliance_green.png", ccui.TextureResType.plistType)
		self.btnJump:setCapInsets(cc.rect(5, 5, 47, 47))
	else
		self.btnJump:setTitleText(i18n("common_text_018"))
		self.btnJump:loadTextureNormal("btn_alliance_red.png", ccui.TextureResType.plistType)
		self.btnJump:setCapInsets(cc.rect(5, 5, 47, 47))
	end
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function BuildCreateSingle:openTimeUpMastery(...)
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).name = buildName
	local labelLongDes = i18n("common_text_755", tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	self.btnJump:setTitleText(i18n("common_text_018"))
	self.btnJump:loadTextureNormal("btn_alliance_red.png", ccui.TextureResType.plistType)
	self.btnJump:setCapInsets(cc.rect(5, 5, 47, 47))
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function BuildCreateSingle:openTimeUpStar()
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).bulid = buildName
	local labelLongDes = i18n("Glory_text_13", tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	self.btnJump:setTitleText(i18n("common_text_018"))
	self.btnJump:loadTextureNormal("btn_alliance_red.png", ccui.TextureResType.plistType)
	self.btnJump:setCapInsets(cc.rect(5, 5, 47, 47))
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function BuildCreateSingle:openTimeUpStarSecond()
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).bulid = buildName
	local labelLongDes = i18n("Glory_text_13", tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	self.btnJump:setTitleText(i18n("common_text_018"))
	self.btnJump:loadTextureNormal("btn_alliance_red.png", ccui.TextureResType.plistType)
	self.btnJump:setCapInsets(cc.rect(5, 5, 47, 47))
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function BuildCreateSingle:refreshLabelDes(labelLongDes)
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	self.labelDes:setString(labelLongDes .. " " .. SoraDConvertSecondToString(leftTime))
	self.labelDes:setFontSize(20)
	if self.labelDes:getContentSize().width > 230 then
		self.labelDes:setString(labelLongDes .. "\n" .. SoraDConvertSecondToString(leftTime))
		self.labelDes:setFontSize(16)
	end
end
function BuildCreateSingle:needUpgrade()
	self.btnJump:setTitleText(i18n("common_text_382"))
	self.imgIcon:loadTexture(buildRead.getIcon(self.tableInfoSingleData.singleData.bid), ccui.TextureResType.plistType)
	self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
	local buildName = buildRead.getName(self.tableInfoSingleData.singleData.bid)
	if self.tableInfoSingleData.singleType == BUILD_CONDITION_TYPE_STAR then
		if self.tableInfoSingleData.singleData.bid == BUILDID.STAR_BRAVE_STATUE then
			local cityltCtrl = include("cityltCtrl")
			self.labelDes:setString(cityltCtrl.getStarBraveStatueLvStr(self.tableInfoSingleData.singleData.starLv))
		else
			_ENV = cityltCtrl.getStarBraveStatueLvStr(self.tableInfoSingleData.singleData.starLv)
			cityltCtrl.getStarBraveStatueLvStr(self.tableInfoSingleData.singleData.starLv).lv = self.tableInfoSingleData.singleData.starLv
			self.labelDes:setString(string.format("%s %s", buildName, i18n("Glory_text_24", cityltCtrl.getStarBraveStatueLvStr(self.tableInfoSingleData.singleData.starLv))))
		end
	else
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(self.tableInfoSingleData.singleData.blv)
		if self.tableInfoSingleData.singleData.bid == BUILDID.MIRACLE and self.tableInfoSingleData.singleData.blv == CASTLE_MAXLV_NOWAR then
			self.labelDes:setString(i18n("common_text_2007"))
		elseif 0 < warLv then
			_ENV = i18n("common_text_2007")
			i18n("common_text_2007").build = buildName
			i18n("common_text_2007").lv = warLv
			self.labelDes:setString(i18n("common_text_1957", i18n("common_text_2007")))
		else
			_ENV = i18n("common_text_1957", i18n("common_text_2007"))
			i18n("common_text_1957", i18n("common_text_2007")).name = buildName
			i18n("common_text_1957", i18n("common_text_2007")).lv = self.tableInfoSingleData.singleData.blv
			self.labelDes:setString(i18n("common_text_334", i18n("common_text_1957", i18n("common_text_2007"))))
		end
	end
end
function BuildCreateSingle:needTools()
	local itemDesRead = include("itemDesRead")
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	self.btnJump:setTitleText(i18n("common_text_337"))
	self.imgIcon:loadTexture(itemDesRead.getIcon(self.tableInfoSingleData.singleData.toolid), ccui.TextureResType.plistType)
	self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
	self.labelDes:setString(itemDesRead.getName(self.tableInfoSingleData.singleData.toolid) .. "   " .. string.formatnumberthousands(self.tableInfoSingleData.singleData.curcount) .. "/" .. string.formatnumberthousands(self.tableInfoSingleData.singleData.toolcount))
	if self.tableInfoSingleData.singleData.oriCount and self.tableInfoSingleData.singleData.oriCount ~= self.tableInfoSingleData.singleData.toolcount then
		self.labelDes:setString(itemDesRead.getName(self.tableInfoSingleData.singleData.toolid) .. "   " .. string.formatnumberthousands(self.tableInfoSingleData.singleData.curcount) .. "/" .. string.formatnumberthousands(self.tableInfoSingleData.singleData.oriCount))
		local labelW = self.labelDes:getVirtualRendererSize().width
		self.spriteLuckLine:setVisible(true)
		self.labelLuckValue:setVisible(true)
		self.spriteLuckLine:setScaleX(labelW / 616)
		self.labelLuckValue:setString(string.formatnumberthousands(self.tableInfoSingleData.singleData.toolcount))
		self.labelLuckValue:setPositionX(SoraDFPosX(534 - (labelW + 60), self.labelLuckValue))
		if self.tableInfoSingleData.singleData.isreach then
			self.labelLuckValue:setColor(display.COLOR_GREEN)
		else
			self.labelLuckValue:setColor(display.COLOR_RED)
		end
	else
		self.spriteLuckLine:setVisible(false)
		self.labelLuckValue:setVisible(false)
	end
end
function BuildCreateSingle:needResource()
	local resDesRead = include("resDesRead")
	self.btnJump:setTitleText(i18n("common_text_337"))
	self.imgIcon:loadTexture(resDesRead.getIcon(self.tableInfoSingleData.singleData.resid), ccui.TextureResType.plistType)
	self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
	self.labelDes:setString(string.formatnumberthousands(self.tableInfoSingleData.singleData.rescount))
end
function BuildCreateSingle:btnJumpCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handleCallBack then
			self.handleCallBack(self.tableInfoSingleData)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function BuildCreateSingle:needNebulaTower()
	self.btnJump:setTitleText(i18n("common_text_477"))
	self.imgIcon:loadTexture("icon_xyqy_xyt.png", ccui.TextureResType.plistType)
	self.imgIcon:setScale(40 / self.imgIcon:getContentSize().height)
	_ENV = i18n("common_text_477")
	i18n("common_text_477").name = i18n("nebula_war_text_0152")
	i18n("common_text_477").lv = self.tableInfoSingleData.singleData.needlv
	self.labelDes:setString(i18n("common_text_334", i18n("common_text_477")))
end
function BuildCreateSingle:isConditionMet(isMet)
	if isMet then
		self.imgState:loadTexture("icon_yes.png", ccui.TextureResType.plistType)
		self.labelDes:setColor(display.COLOR_WHITE)
	else
		self.imgState:loadTexture("icon_no.png", ccui.TextureResType.plistType)
		self.labelDes:setColor(display.COLOR_RED)
	end
	self.btnJump:setVisible(not isMet)
end
function BuildCreateSingle:getIsMet()
	return self.isMet
end
return BuildCreateSingle

local cityCtrl = SoraDGetCtrl("cityCtrl")
local buildRead = include("buildDescribeRead")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local buildCreateSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildViewCommon/buildCreateSingle", buildCreateSingle)
BUILD_CONDITION_TYPE_BUILD = 1
BUILD_CONDITION_TYPE_RES = 2
BUILD_CONDITION_TYPE_TOOL = 3
BUILD_CONDITION_TYPE_TIME = 4
BUILD_CONDITION_TYPE_WE = 5
BUILD_CONDITION_TYPE_STAR = 6
BUILD_CONDITION_TYPE_ITEM = 7
BUILD_CONDITION_TYPE_NEBULATOWER = 8
BUILD_CONDITION_TYPE_MAGIC = 9
function buildCreateSingle:onInit()
	self.imgIcon = self.fields.Image_icon
	self.labelDes = self.fields.Text_des
	self.spriteLuckLine = self.fields.Sprite_luckLine
	self.spriteLuckLine:setVisible(false)
	self.labelLuckValue = self.fields.Text_luckValue
	self.labelLuckValue:setVisible(false)
	self.btnJump = self.fields.Button_jump
	self.btnJump:addClickEventListener(handler(self, self.btnJumpCallBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function buildCreateSingle:onShow()
end
function buildCreateSingle:setBtnCallBcak(handle)
	self.handleCallBack = handle
end
function buildCreateSingle:initData(tableInfoSingleData)
	self.tableInfoSingleData = tableInfoSingleData
	self:isConditionMet(self.tableInfoSingleData.singleData.isreach)
	local singleType = self.tableInfoSingleData.singleType
	if singleType == BUILD_CONDITION_TYPE_TIME then
		self:needSpeedUp()
	elseif singleType == BUILD_CONDITION_TYPE_BUILD or singleType == BUILD_CONDITION_TYPE_STAR then
		self:needUpgrade()
	elseif singleType == BUILD_CONDITION_TYPE_RES then
		self:needResource()
	elseif singleType == BUILD_CONDITION_TYPE_TOOL or singleType == BUILD_CONDITION_TYPE_WE or singleType == BUILD_CONDITION_TYPE_ITEM then
		self:needTools()
	elseif singleType == BUILD_CONDITION_TYPE_NEBULATOWER then
		self:needNebulaTower()
	elseif singleType == BUILD_CONDITION_TYPE_MAGIC then
		self:needMagic()
	end
end
function buildCreateSingle:needSpeedUp()
	self.btnJump:setTitleText(i18n("common_text_018"))
	local qtype = tonumber(self.tableInfoSingleData.singleData.qtype)
	if gQueueTypeDef.build_mastery == qtype then
		self.imgIcon:setURL("icon_tiny_paper.png")
		self:openTimeUpMastery()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpMastery))
	elseif gQueueTypeDef.build_star_queue == qtype or gQueueTypeDef.build_star_queue_privilege == qtype then
		self.imgIcon:setURL("icon_hourglass.png")
		self:openTimeUpStar()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUpStar))
	else
		self.imgIcon:setURL("icon_hourglass.png")
		self:openTimeUp()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
end
function buildCreateSingle:buildTimerEnd()
	if self.tableInfoSingleData.singleType == BUILD_CONDITION_TYPE_TIME then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		if self.handleCallBack then
			self.handleCallBack(self.tableInfoSingleData)
		end
	end
end
function buildCreateSingle:openTimeUp(dt)
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
	local freeTime = buildLogic.getFreeSpeedUpTime(self.tableInfoSingleData.singleData.blv)
	if leftTime <= freeTime then
		self.btnJump:setTitleText(i18n("common_text_049"))
		local c1 = self.btnJump:getController("c1")
		c1:setSelectedIndex(0)
	else
		self.btnJump:setTitleText(i18n("common_text_018"))
		local c1 = self.btnJump:getController("c1")
		c1:setSelectedIndex(1)
	end
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function buildCreateSingle:openTimeUpMastery(...)
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).name = buildName
	local labelLongDes = i18n("common_text_755", tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	self.btnJump:setTitleText(i18n("common_text_018"))
	local c1 = self.btnJump:getController("c1")
	c1:setSelectedIndex(1)
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function buildCreateSingle:openTimeUpStar()
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	local buildName = buildRead.getName(tonumber(self.tableInfoSingleData.singleData.data.bid))
	buildRead = tonumber(self.tableInfoSingleData.singleData.data.bid)
	tonumber(self.tableInfoSingleData.singleData.data.bid).bulid = buildName
	local labelLongDes = i18n("Glory_text_13", tonumber(self.tableInfoSingleData.singleData.data.bid))
	self:refreshLabelDes(labelLongDes)
	self.btnJump:setTitleText(i18n("common_text_018"))
	local c1 = self.btnJump:getController("c1")
	c1:setSelectedIndex(1)
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function buildCreateSingle:refreshLabelDes(labelLongDes)
	local leftTime = self.tableInfoSingleData.singleData.timerNode.timer:getRemainTime()
	self.labelDes:setString(labelLongDes .. " " .. SoraDConvertSecondToString(leftTime))
end
function buildCreateSingle:needUpgrade()
	self.btnJump:setTitleText(i18n("common_text_382"))
	self.imgIcon:setURL(buildRead.getIcon(self.tableInfoSingleData.singleData.bid))
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
function buildCreateSingle:needTools()
	local itemDesRead = include("itemDesRead")
	local singleData = self.tableInfoSingleData.singleData
	self.btnJump:setTitleText(i18n("common_text_337"))
	self.imgIcon:setURL(itemDesRead.getIcon(singleData.toolid))
	local itemName = itemDesRead.getName(singleData.toolid)
	self.labelDes:setString(itemName .. "   " .. string.formatnumberthousands(singleData.curcount) .. "/" .. string.formatnumberthousands(singleData.toolcount))
	if singleData.oriCount and singleData.oriCount > singleData.toolcount then
		self.labelDes:setString(itemName .. "   " .. string.formatnumberthousands(singleData.curcount) .. "/" .. string.formatnumberthousands(singleData.oriCount))
		if singleData.isreach then
			self.labelLuckValue:setColor(cc.c3b(240, 230, 210))
		else
			self.labelLuckValue:setColor(cc.c3b(234, 23, 22))
		end
		local labelW = self.labelDes:getTextAreaWidth()
		self.spriteLuckLine:setWidth(labelW)
		self.labelLuckValue:setString(string.formatnumberthousands(singleData.toolcount))
		self.spriteLuckLine:setVisible(true)
		self.labelLuckValue:setVisible(true)
	else
		self.spriteLuckLine:setVisible(false)
		self.labelLuckValue:setVisible(false)
	end
end
function buildCreateSingle:needResource()
	local resDesRead = include("resDesRead")
	self.btnJump:setTitleText(i18n("common_text_337"))
	self.imgIcon:setURL(resDesRead.getIcon(self.tableInfoSingleData.singleData.resid))
	self.labelDes:setString(string.formatnumberthousands(self.tableInfoSingleData.singleData.rescount))
end
function buildCreateSingle:needNebulaTower()
	self.btnJump:setTitleText(i18n("common_text_477"))
	self.imgIcon:setURL("icon_xyqy_xyt.png")
	_ENV = i18n("common_text_477")
	i18n("common_text_477").name = i18n("nebula_war_text_0152")
	i18n("common_text_477").lv = self.tableInfoSingleData.singleData.needlv
	self.labelDes:setString(i18n("common_text_334", i18n("common_text_477")))
end
function buildCreateSingle:needMagic()
	local magicLampRead = include("magicLampRead")
	local singleData = self.tableInfoSingleData.singleData
	self.btnJump:setTitleText(i18n("common_text_477"))
	local jinnIcon = magicLampRead.getJinnIcon(singleData.jinnType)
	self.imgIcon:setURL(jinnIcon)
	local jinnName = magicLampRead.getJinnName(singleData.jinnType)
	_ENV = i18n("common_text_477")
	i18n("common_text_477").lv = singleData.jinnLv
	local jinnLvStr = i18n("common_text_100", i18n("common_text_477"))
	self.labelDes:setString(string.format("%s %s", jinnName, jinnLvStr))
end
function buildCreateSingle:btnJumpCallBack()
	SoraDPlaySound()
	if self.handleCallBack then
		self.handleCallBack(self.tableInfoSingleData)
	end
end
function buildCreateSingle:isConditionMet(isMet)
	if isMet then
		self.controllers.c_met:setSelectedIndex(0)
	else
		self.controllers.c_met:setSelectedIndex(1)
	end
	self.isMet = isMet
end
function buildCreateSingle:luckBlessOpen(luckyBlessIsOpen)
	local resCount = self.tableInfoSingleData.singleData.rescount
	local haveRes = cityCtrl:getResCount(self.tableInfoSingleData.singleData.resid)
	if luckyBlessIsOpen then
		resCount = luckyBlessCtrl:getResult(self.tableInfoSingleData.singleData.rescount)
	end
	local buildData = self.tableInfoSingleData.buildData
	local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, buildData)
	resCount = math.ceil(resCount * subPercent)
	print("resCount", resCount, self.tableInfoSingleData.singleData.rescount, subPercent, luckyBlessIsOpen)
	if resCount == self.tableInfoSingleData.singleData.rescount and subPercent == 1 then
		self.spriteLuckLine:setVisible(false)
		self.labelLuckValue:setVisible(false)
		return haveRes >= resCount
	end
	self.spriteLuckLine:setVisible(true)
	self.labelLuckValue:setVisible(true)
	local labelW = self.labelDes:getTextAreaWidth()
	self.spriteLuckLine:setWidth(labelW)
	self.labelLuckValue:setString(string.formatnumberthousands(resCount))
	if haveRes < resCount then
		self.labelLuckValue:setColor(cc.c3b(234, 23, 22))
		self:isConditionMet(false)
	else
		self.labelLuckValue:setColor(cc.c3b(240, 230, 210))
		self:isConditionMet(true)
		self.labelDes:setColor(cc.c3b(180, 180, 180))
	end
	return haveRes >= resCount
end
function buildCreateSingle:radiantBlessOpen(isStatue, luckyBlessIsOpen)
	local resCount = 0
	local haveRes = 0
	self.spriteLuckLine:setVisible(true)
	self.labelLuckValue:setVisible(true)
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local toolid = self.tableInfoSingleData.singleData.toolid
	local buildData = self.tableInfoSingleData.buildData
	local subPercent = 1
	local oldCount = 0
	if self.tableInfoSingleData.singleType == BUILD_CONDITION_TYPE_ITEM then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		haveRes = backpackCtrl:getItemCount(toolid)
		resCount = self.tableInfoSingleData.singleData.toolcount
		oldCount = resCount
		if isStatue then
			if toolid == gBadgeItemID.AMBER_ID then
				subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_AMBER_REDUCE_STATUE, buildData)
			elseif toolid == gBadgeItemID.STELLAR_ID then
				subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE_STATUE, buildData)
			end
		elseif toolid == gBadgeItemID.AMBER_ID then
			subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_AMBER_REDUCE, buildData)
		elseif toolid == gBadgeItemID.STELLAR_ID then
			subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE, buildData)
		end
		resCount = math.ceil(resCount * subPercent)
	else
		haveRes = cityCtrl:getResCount(self.tableInfoSingleData.singleData.resid)
		resCount = self.tableInfoSingleData.singleData.rescount
		oldCount = resCount
		if luckyBlessIsOpen then
			resCount = luckyBlessCtrl:getResult(self.tableInfoSingleData.singleData.rescount)
		end
		if isStatue then
			subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE_STATUE, buildData)
		else
			subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE, buildData)
		end
		resCount = math.ceil(resCount * subPercent)
	end
	if resCount ~= oldCount or subPercent ~= 1 then
		local labelW = self.labelDes:getTextAreaWidth()
		self.spriteLuckLine:setWidth(labelW)
		self.labelLuckValue:setString(string.formatnumberthousands(resCount))
	else
		local singleData = self.tableInfoSingleData.singleData
		if not singleData.oriCount or not (singleData.oriCount > singleData.toolcount) then
			self.spriteLuckLine:setVisible(false)
			self.labelLuckValue:setVisible(false)
		end
	end
	if haveRes < resCount then
		self.labelLuckValue:setColor(cc.c3b(234, 23, 22))
		self:isConditionMet(false)
	else
		self.labelLuckValue:setColor(cc.c3b(240, 230, 210))
		self:isConditionMet(true)
	end
	return haveRes >= resCount
end
function buildCreateSingle:getIsMet()
	return self.isMet
end
return buildCreateSingle

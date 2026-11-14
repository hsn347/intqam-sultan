local baseFguiPanel = require("fgui.base.baseFguiPanel")
local nebulaMileStoneRead = include("nebulaMileStoneRead")
local MagicLampBreakPanel = class("MagicLampBreakPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local collegeDesRead = include("collegeDesRead")
local buildLogic = include("buildLogic")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local buildDescribeRead = include("buildDescribeRead")
function MagicLampBreakPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampBreakPanel:ctor", self.viewName)
end
function MagicLampBreakPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampBreakPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampBreakPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_02"))
	self.fields.text_tip1:setString(i18n("magic_lamp_text_011"))
	self.fields.title:setString(i18n("magic_lamp_text_014"))
	self.fields.text_title1:setString(i18n("magic_lamp_text_013"))
	self.fields.list_star:setItemRenderer(handler(self, self.onStarsRender))
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	self.fields.list_res:setItemRenderer(handler(self, self.onItemsRender))
	self.fields.button_normal:setTitle(i18n("magic_lamp_text_015"))
	self.fields.button_normal:addClickEventListener(handler(self, self.onNormalClick))
	self.fields.button_gold:setTitle(i18n("magic_lamp_text_020"))
	self.fields.button_gold:addClickEventListener(handler(self, self.onGoldClick))
end
function MagicLampBreakPanel:onShow()
	print("=======MagicLampBreakPanel:onShow")
	self:updateView()
end
function MagicLampBreakPanel:updateView()
	local nebulaTowerLv = nebulaActivityCtrl:getTowerLv()
	self.curType = self.param.jinnType
	self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	self.curStar = self.jinnData.starLv
	self.maxStar = magicLampRead.getMaxStar(self.curType)
	self.breakCfg = magicLampRead.getBreakThroughCfg(self.curType, self.curStar)
	self.nextCfg = magicLampRead.getBreakThroughCfg(self.curType, self.curStar + 1)
	self.nebulaMileStoneLimit = self:getNebulaMileStoneData(self.nextCfg.NebulaMilestone)
	self.fields.list_star:setNumItems(self.curStar + 1)
	nebulaActivityCtrl = nil
	;(nil).lv = self.nextCfg.MaxLv
	self.fields.text_tip2:setString(i18n("magic_lamp_text_012", nil))
	self.oldAttCfgs = self.breakCfg.buff
	self.attCfgs = self.nextCfg.buff
	self.fields.list_att:setNumItems(#self.attCfgs)
	local isAllSpxEnough = true
	local needDatas = clone(self.nextCfg.need)
	dump(self.nextCfg, "self.nextCfg")
	dump(#needDatas, "needDatas")
	self.nebulamileStoneNum = 0
	if #needDatas == 0 then
		local NebulaMilestone = self.nextCfg.NebulaMilestone
		if NebulaMilestone ~= nil and 0 < NebulaMilestone then
			local nextStarUnlockTask = nebulaMileStoneRead.getConfigByUnlockType(self.nextCfg.NebulaMilestone, self.curStar + 1, true)
			local isEnough = self.curStar + 1 <= self.nebulaMileStoneLimit
			dump(self.nebulaMileStoneLimit, "self.nebulaMileStoneLimit")
			if nextStarUnlockTask ~= nil then
				local nebulaActivityCtrl, need = dump, dump
				need.isEnough = isEnough
				nebulaActivityCtrl = i18n("magic_lamp_text_012", nil)
				i18n("magic_lamp_text_012", nil).name = nebulaMileStoneRead.getName(nextStarUnlockTask.milestoneID)
				need.name = i18n("common_text_4784", i18n("magic_lamp_text_012", nil))
				need.icon = "icon_xyqy_dw4.png"
				self.nebulaMileNeed = need
				self.nebulamileStoneNum = 1
				isAllSpxEnough = isAllSpxEnough and need.isEnough
			elseif not isEnough then
				local nebulaActivityCtrl, need = dump, dump
				need.isEnough = isEnough
				need.name = i18n("magic_lamp_text_160")
				need.icon = "icon_xyqy_dw4.png"
				self.nebulaMileNeed = need
				self.nebulamileStoneNum = 1
				isAllSpxEnough = isAllSpxEnough and need.isEnough
			end
		end
	end
	self.needTechs, nebulaActivityCtrl = self.nextCfg.NebulaMilestone, NebulaMilestone
	_ENV = true
	;(true)[1] = "needType"
	;(true)[2] = "value1"
	;(true)[3] = "value2"
	self.needTechBuffs = serviceFunctions.tableFormat(self.nextCfg.Jump, true)
	self.nebulaTowerNeed = nil
	self.buildNeed = nil
	for i, v in ipairs(needDatas) do
		if v.needType == 1 then
			v.isEnough = self.curStar + 1 <= self.nebulaMileStoneLimit or technologyCtrl:getTechnologyPower(v.value1) >= v.value2
			local techName = collegeDesRead.getName(math.floor(self.needTechBuffs[i].value1)) or ""
			v.techId = self.needTechBuffs[i].value1
			nebulaActivityCtrl = math.floor(self.needTechBuffs[i].value1)
			math.floor(self.needTechBuffs[i].value1).lv = self.needTechBuffs[i].value2
			v.name = techName .. " " .. i18n("common_text_100", math.floor(self.needTechBuffs[i].value1))
			isAllSpxEnough = isAllSpxEnough and v.isEnough
			v.icon = "quest_building_305.png"
			v.getBtnTitle = i18n("common_text_477")
			table.insert(self.needTechs, v)
		elseif v.needType == 2 then
			v.isEnough = self.curStar + 1 <= self.nebulaMileStoneLimit or nebulaTowerLv >= v.value1
			nebulaActivityCtrl = "common_text_100"
			;("common_text_100").lv = self.needTechBuffs[i].value1
			v.name = i18n("nebula_war_text_0152") .. " " .. i18n("common_text_100", "common_text_100")
			isAllSpxEnough = isAllSpxEnough and v.isEnough
			v.icon = "icon_xyqy_xyt.png"
			self.nebulaTowerNeed = v
		end
	end
	self.techNum = #self.needTechs
	self.nebulaTowerNeedNum = self.nebulaTowerNeed == nil and 0 or 1
	if next(self.nextCfg.NeedBuildStar) ~= nil then
		local bid = self.nextCfg.NeedBuildStar[1]
		local starLv = self.nextCfg.NeedBuildStar[2]
		nebulaActivityCtrl = ipairs(needDatas)
		ipairs(needDatas).bid = bid
		self.buildNeed, ipairs(needDatas).needType = ipairs(needDatas)
		self.buildNeed.getBtnTitle = i18n("common_text_477")
		self.buildNeed.isEnough = starLv <= SoraDGetBuildStarLv(bid)
		self.buildNeed.icon = buildDescribeRead.getIcon(bid)
		local buildName = buildDescribeRead.getName(bid)
		if bid == BUILDID.STAR_BRAVE_STATUE then
			local cityltCtrl = include("cityltCtrl")
			self.buildNeed.name = cityltCtrl.getStarBraveStatueLvStr(starLv)
		else
			nebulaActivityCtrl = "common_text_100"
			;("common_text_100").lv = starLv
			self.buildNeed.name = string.format("%s %s", buildName, i18n("Glory_text_24", "common_text_100"))
		end
		isAllSpxEnough = isAllSpxEnough and self.buildNeed.isEnough
	end
	self.buildNeedNum = self.buildNeed == nil and 0 or 1
	self.spxCostRes = clone(self.nextCfg.cost)
	for i, v in ipairs(self.spxCostRes) do
		local itemNum = backpackCtrl:getItemCount(v.id)
		v.haveNum = itemNum
		local itemSubBuff = magicLampCtrl:getCostBuffValue(self.curType, v.id, self.jinnData, "break")
		local itemBaseBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, v.id, self.jinnData, "break")
		local needcount = v.num
		needcount = math.ceil(needcount * itemSubBuff * itemBaseBuff)
		v.needcount = needcount
		v.isEnough = itemNum >= v.needcount
		isAllSpxEnough = isAllSpxEnough and v.isEnough
	end
	self.fields.list_res:setNumItems(#self.spxCostRes + #self.needTechs + self.nebulaTowerNeedNum + self.buildNeedNum + self.nebulamileStoneNum)
	self.needTime = self.nextCfg.Time
	local baseEffectBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, -2, self.jinnData, "break")
	local timeSubBuff = magicLampCtrl:getCostBuffValue(self.curType, -2, self.jinnData, "break")
	self.needTime = math.floor(self.needTime * timeSubBuff * baseEffectBuff)
	print("timeSubBuff", timeSubBuff, self.needTime, self.nextCfg.Time)
	self.fields.button_normal:setCostTitle(SoraDConvertSecondToString(self.needTime))
	self.fields.button_normal:setTouchEnabled(isAllSpxEnough)
	self.fields.button_normal:setBtnBgGray(not isAllSpxEnough)
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	self.timeToGold = serviceFunctions.timeConvertToGold(self.needTime)
	self.fields.button_gold:setCostNum(self.timeToGold, haveGold)
	self.fields.button_gold:setTouchEnabled(isAllSpxEnough)
	self.fields.button_gold:setBtnBgGray(not isAllSpxEnough)
end
function MagicLampBreakPanel:onStarsRender(index, obj)
	obj:initData(index < self.curStar, index == self.curStar)
end
function MagicLampBreakPanel:onAttsRender(index, obj)
	obj:initData(self.oldAttCfgs[index + 1], self.attCfgs[index + 1], self.jinnData.lv, index)
end
function MagicLampBreakPanel:onItemsRender(index, obj)
	print(self.buildNeedNum, self.techNum, index + self.nebulaTowerNeedNum, self.nebulamileStoneNum, "self.buildNeedNum == 1 and self.techNum == index + self.nebulaTowerNeedNum self.nebulamileStoneNum")
	if index < self.techNum then
		obj:initByData(self.needTechs[index + 1], index)
	elseif self.nebulaTowerNeedNum == 1 and self.techNum == index then
		obj:initByData(self.nebulaTowerNeed, index)
	elseif self.buildNeedNum == 1 and self.techNum + self.nebulaTowerNeedNum == index then
		obj:initByData(self.buildNeed, index)
	elseif self.nebulamileStoneNum == 1 and self.techNum + self.nebulaTowerNeedNum + self.buildNeedNum == index then
		obj:initByData(self.nebulaMileNeed, index)
	else
		obj:initByItem(self.spxCostRes[index + 1 - self.techNum - self.nebulaTowerNeedNum - self.buildNeedNum - self.nebulamileStoneNum], index)
	end
	obj:setGetClickCallback(handler(self, self.onGetClick))
end
function MagicLampBreakPanel:onGetClick(res, data, itemData)
	if data then
		SoraDRemoveAllPanelFromManager()
		dump(data, "data")
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if data.needType == 1 then
			_ENV = nil
			mildGuideManager:starToNebulaTech(nil)
			_ENV = nil
			;(nil).techId = data.techId
			gModuleMgr.sharedMgr("mildGuideManager"):setVariate("NebulaAreaTechPanel", nil)
		elseif data.needType == -1 then
			if data.bid == BUILDID.STAR_BRAVE_STATUE then
				_ENV = "NebulaAreaTechPanel"
				;("NebulaAreaTechPanel").bid = data.bid
				;("NebulaAreaTechPanel").key = "OpstatueBrave"
				mildGuideManager:starToStatueBrave("NebulaAreaTechPanel")
			else
				_ENV = "NebulaAreaTechPanel"
				;("NebulaAreaTechPanel").bid = data.bid
				mildGuideManager:starToUpgradeStar("NebulaAreaTechPanel")
			end
		end
	elseif itemData then
		_ENV = "NebulaAreaTechPanel"
		;("NebulaAreaTechPanel").itemID = itemData.id
		uiManager:show("CommonSourceGuide", "NebulaAreaTechPanel")
	end
end
function MagicLampBreakPanel:onNormalClick()
	SoraDPlaySound()
	local coolingTip = magicLampCtrl:getCoolingTip("break")
	if coolingTip ~= nil then
		SoraDShowMsgTip(coolingTip)
		self:close()
		return
	end
	self:updateNormal()
end
function MagicLampBreakPanel:onGoldClick()
	SoraDPlaySound()
	if not SoraDEnoughGold(self.timeToGold) then
		return
	end
	if IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_BREAK then
		SoraDShowBuyBox(i18n("magic_lamp_text_025"), self.timeToGold, i18n("magic_lamp_text_022"), function(callType, data)
			if MSGBOX_CALLBACK_YES == callType then
				IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_BREAK = not data.isCheck
				self:upgradeNow()
			end
		end, nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), IS_SELECT_LOGIN_NOTICE, true)
	else
		self:upgradeNow()
	end
end
function MagicLampBreakPanel:updateNormal()
	print("MagicLampBreakPanel:updateNormal")
	magicLampCtrl:reqMagicLampUpgradeStar(self.curType, 1)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queuetype = gQueueTypeDef.magic_lamp_jinn_star
	local totaltime = tonumber(self.needTime)
	local lefttime = tonumber(self.needTime)
	local starttime = serviceFunctions.systemTime() + 1
	_ENV = nil
	;(nil).bid = tostring(BUILDID.MAGIC_LAMP)
	;(nil).jinnID = self.curType
	queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
	self:close()
end
function MagicLampBreakPanel:upgradeNow()
	magicLampCtrl:reqMagicLampUpgradeStar(self.curType, 2)
	self:close()
end
function MagicLampBreakPanel:getNebulaMileStoneData(nType)
	local nebulaMileStoneLimit
	local tmp, nebulaMileStoneData = nebulaMileStoneCtrl:getPlusByUnlockType(nType)
	if nebulaMileStoneData and nebulaMileStoneData.value2 and nebulaMileStoneData.value2 ~= 0 then
		nebulaMileStoneLimit = nebulaMileStoneData.value2
	else
		nebulaMileStoneLimit = nebulaMileStoneData and nebulaMileStoneData.value or 0
	end
	return nebulaMileStoneLimit
end
return MagicLampBreakPanel

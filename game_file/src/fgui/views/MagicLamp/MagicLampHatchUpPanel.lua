local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local magicLampRead = include("magicLampRead")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampHatchRead = include("magicLampHatchRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local buildDescribeRead = include("buildDescribeRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local MagicLampHatchUpPanel = class("MagicLampHatchUpPanel", baseFguiPanel)
function MagicLampHatchUpPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MagicLampHatchUpPanel:ctor", self.viewName)
end
function MagicLampHatchUpPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampHatchUpPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampHatchUpPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Jinn_hatch_text_18"))
	self.fields.title:setString(i18n("Jinn_hatch_text_23"))
	self.fields.list_res:setItemRenderer(handler(self, self.onItemsRender))
	self.fields.button_normal:setTitle(i18n("Jinn_hatch_text_18"))
	self.fields.button_normal:addClickEventListener(handler(self, self.onNormalClick))
	self.fields.button_gold:setTitle(i18n("Jinn_hatch_text_24"))
	self.fields.button_gold:addClickEventListener(handler(self, self.onGoldClick))
end
function MagicLampHatchUpPanel:onShow()
	print("=======MagicLampHatchUpPanel:onShow")
	self:updateView()
end
function MagicLampHatchUpPanel:updateView()
	self.hatchType = self.param.hatchType
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	self.curLv = self.hatchData.lv
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.curLv)
	self.nextCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.curLv + 1)
	local isAllSpxEnough = true
	self.allNeeds, magicLampHatchCtrl = self.hatchType, self.hatchType
	local buildNeed
	for i, v in ipairs(self.nextCfg.buildLv) do
		local bid = v.bid
		local starLv = v.lv
		magicLampHatchCtrl = nil
		;(nil).bid = bid
		buildNeed, (nil).needType = nil, -1
		buildNeed.getBtnTitle = i18n("common_text_477")
		buildNeed.isEnough = starLv <= SoraDGetBuildStarLv(bid)
		buildNeed.icon = buildDescribeRead.getIcon(bid)
		local buildName = buildDescribeRead.getName(bid)
		if bid == BUILDID.STAR_BRAVE_STATUE then
			local cityltCtrl = include("cityltCtrl")
			buildNeed.name = cityltCtrl.getStarBraveStatueLvStr(starLv)
		else
			magicLampHatchCtrl = nil
			;(nil).lv = starLv
			buildNeed.name = string.format("%s %s", buildName, i18n("Glory_text_24", nil))
		end
		isAllSpxEnough = isAllSpxEnough and buildNeed.isEnough
		buildNeed.func = "initByData"
		table.insert(self.allNeeds, buildNeed)
	end
	for i, v in ipairs(self.nextCfg.jinnLv) do
		local jinnType = v.jinnType
		magicLampHatchCtrl = v.lv
		local v.lv.jinnType, jinnNeed = jinnType, v.lv
		jinnNeed.isEnough = magicLampCtrl:getJinnLv(jinnType) >= v.lv
		jinnNeed.icon = magicLampRead.getJinnIcon(jinnType)
		jinnNeed.getBtnTitle = i18n("common_text_382")
		jinnNeed.needType = "jinnType"
		magicLampHatchCtrl = i18n("Glory_text_24", nil)
		i18n("Glory_text_24", nil).lv = v.lv
		jinnNeed.name = string.format("%s %s", magicLampRead.getJinnName(jinnType), i18n("common_text_100", i18n("Glory_text_24", nil)))
		isAllSpxEnough = isAllSpxEnough and jinnNeed.isEnough
		jinnNeed.func = "initByData"
		table.insert(self.allNeeds, jinnNeed)
	end
	self.spxCostRes = clone(self.nextCfg.costItem)
	for i, v in ipairs(self.spxCostRes) do
		local itemNum = backpackCtrl:getItemCount(v.id)
		local needcount = v.num
		local itemSubBuff = magicLampHatchCtrl:getCostBuffValue(self.hatchType, v.id, self.hatchData)
		needcount = math.ceil(needcount * itemSubBuff)
		v.needcount = needcount
		v.isEnough = itemNum >= needcount
		v.haveNum = itemNum
		isAllSpxEnough = isAllSpxEnough and v.isEnough
		v.func = "initByItem"
		table.insert(self.allNeeds, v)
	end
	self.tableResNeedBuy, magicLampHatchCtrl, self.costRes = clone(self.nextCfg.costRes), clone(self.nextCfg.costRes), clone(self.nextCfg.costRes)
	self.resToGold = 0
	for i, v in ipairs(self.costRes) do
		local isEnough, curRes = SoraDEnoughRes(v.id, v.num)
		v.isEnough = isEnough
		v.haveNum = curRes
		v.func = "initByRes"
		if not v.isEnough then
			local needBuyRes = v.num - v.haveNum
			if 0 < needBuyRes then
				magicLampHatchCtrl = v
				v.resid = v.id
				v.rescount = v.num
				table.insert(self.tableResNeedBuy, v)
				self.resToGold = self.resToGold + serviceFunctions.resConvertToGold(v.id, needBuyRes)
			end
		end
		table.insert(self.allNeeds, v)
	end
	self.fields.list_res:setNumItems(#self.allNeeds)
	self.fields.button_normal:setCostTitle(SoraDConvertSecondToString(self.nextCfg.costTime))
	self.fields.button_normal:setTouchEnabled(isAllSpxEnough)
	self.fields.button_normal:setBtnBgGray(not isAllSpxEnough)
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	self.timeToGold = serviceFunctions.timeConvertToGold(self.nextCfg.costTime)
	self.fields.button_gold:setCostNum(self.timeToGold + self.resToGold, haveGold)
	self.fields.button_gold:setTouchEnabled(isAllSpxEnough)
	self.fields.button_gold:setBtnBgGray(not isAllSpxEnough)
end
function MagicLampHatchUpPanel:onItemsRender(index, obj)
	local data = self.allNeeds[index + 1]
	obj[data.func](obj, data, index)
	obj:setGetClickCallback(handler(self, self.onGetClick))
end
function MagicLampHatchUpPanel:onGetClick(needRes, data, itemData)
	if needRes then
		_ENV = nil
		;(nil).rid = needRes.id
		;(nil).needResData = self.tableResNeedBuy
		uiManager:show("resourceBuyView", nil)
	elseif data then
		SoraDRemoveAllPanelFromManager()
		dump(data, "data")
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if data.needType == 1 then
			_ENV = nil
			mildGuideManager:starToNebulaTech(nil)
			_ENV = self.tableResNeedBuy
			self.tableResNeedBuy.techId = data.techId
			gModuleMgr.sharedMgr("mildGuideManager"):setVariate("NebulaAreaTechPanel", self.tableResNeedBuy)
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
		elseif data.needType == "jinnType" then
			SoraDRemoveAllPanelFromManager()
			_ENV = data.bid
			data.bid.curType = data.jinnType
			uiManager:show("MagicLampMain", data.bid)
		end
	elseif itemData then
		local quickuseitem = require_data("quickuseitem").data
		local toolid = itemData.id
		local toolcount = itemData.num
		if quickuseitem[toolid] then
			_ENV = nil
			;(nil).needID = toolid
			;(nil).needCount = toolcount
			uiManager:show("commonQuickUseView", nil)
		else
			_ENV = nil
			;(nil).itemID = itemData.id
			uiManager:show("CommonSourceGuide", nil)
		end
	end
end
function MagicLampHatchUpPanel:onNormalClick()
	SoraDPlaySound()
	local coolingTip = magicLampCtrl:getCoolingTip("hatch")
	if coolingTip ~= nil then
		SoraDShowMsgTip(coolingTip)
		self:close()
		return
	end
	if self.resToGold ~= 0 then
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(self.tableResNeedBuy) then
			uiManager:show("CommonQuicklyadd")
		else
			_ENV, _ENV = nil, nil
			;(nil).resToGold = self.resToGold
			;(nil).needResData, (nil).retCostRes = nil, self.tableResNeedBuy
			;(nil).viewType = RESBUYVIEW_TYPE.MGAGIC_LAMP_HATCH
			;(nil).handle = handler(self, self.updateNormal)
			uiManager:show("buildCreateResBuy", nil)
		end
		return
	end
	self:updateNormal(true)
end
function MagicLampHatchUpPanel:onGoldClick()
	SoraDPlaySound()
	if not SoraDEnoughGold(self.timeToGold + self.resToGold) then
		return
	end
	if IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_HATCH then
		SoraDShowBuyBox(i18n("Jinn_hatch_text_36"), self.timeToGold + self.resToGold, i18n("Jinn_hatch_text_3"), function(callType, data)
			if MSGBOX_CALLBACK_YES == callType then
				IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_HATCH = not data.isCheck
				self:upgradeNow()
			end
		end, nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), IS_SELECT_LOGIN_NOTICE, true)
	else
		self:upgradeNow()
	end
end
function MagicLampHatchUpPanel:updateNormal(isNoGold)
	print("MagicLampHatchUpPanel:updateNormal")
	magicLampHatchCtrl:reqMagicLampHatchUpgrade(self.hatchData.id, isNoGold and 1 or 3)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queuetype = gQueueTypeDef.magic_lamp_hatch_level
	local totaltime = tonumber(self.nextCfg.costTime)
	local lefttime = tonumber(self.nextCfg.costTime)
	local starttime = serviceFunctions.systemTime() + 1
	_ENV = nil
	;(nil).bid = tostring(BUILDID.MAGIC_LAMP)
	;(nil).hatchID = self.hatchType
	queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
	self:close()
end
function MagicLampHatchUpPanel:upgradeNow()
	magicLampHatchCtrl:reqMagicLampHatchUpgrade(self.hatchData.id, 2)
	self:close()
end
return MagicLampHatchUpPanel

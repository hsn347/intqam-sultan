local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampStrengthPanel = class("MagicLampStrengthPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
function MagicLampStrengthPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampStrengthPanel:ctor", self.viewName)
end
function MagicLampStrengthPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampStrengthPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampStrengthPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_03"))
	self.fields.title:setString(i18n("magic_lamp_text_024"))
	self.fields.list_res:setItemRenderer(handler(self, self.onItemsRender))
	self.fields.button_normal:setTitle(i18n("magic_lamp_text_006"))
	self.fields.button_normal:addClickEventListener(handler(self, self.onNormalClick))
	self.fields.button_gold:setTitle(i18n("magic_lamp_text_022"))
	self.fields.button_gold:addClickEventListener(handler(self, self.onGoldClick))
end
function MagicLampStrengthPanel:onShow()
	print("=======MagicLampStrengthPanel:onShow")
	self:updateView()
end
function MagicLampStrengthPanel:updateView()
	self.curType = self.param.jinnType
	self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	self.strengthCfg = magicLampRead.getStrengthenCfg(self.curType, self.jinnData.lv)
	self.nextCfg = magicLampRead.getStrengthenCfg(self.curType, self.jinnData.lv + 1)
	magicLampCtrl = nil
	;(nil).lv = self.jinnData.lv
	self.fields.lv_now:setString(i18n("common_text_100", nil))
	magicLampCtrl = i18n("common_text_100", nil)
	i18n("common_text_100", nil).lv = self.jinnData.lv + 1
	self.fields.lv_to:setString(i18n("common_text_100", i18n("common_text_100", nil)))
	magicLampCtrl = i18n("common_text_100", i18n("common_text_100", nil))
	i18n("common_text_100", i18n("common_text_100", nil)).num = self.nextCfg.BlessPoint
	self.fields.text_get:setString(i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil))))
	_ENV = i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))
	i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))[1] = "id"
	i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))[2] = "num"
	self.tableResNeedBuy, magicLampCtrl, self.costRes = serviceFunctions.tableFormat(self.nextCfg.Cost, i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))), serviceFunctions.tableFormat(self.nextCfg.Cost, i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))), serviceFunctions.tableFormat(self.nextCfg.Cost, i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil))))
	self.resToGold = 0
	for i, v in ipairs(self.costRes) do
		local isEnough, curRes = SoraDEnoughRes(v.id, v.num)
		v.isEnough = isEnough
		v.haveNum = curRes
		if not v.isEnough then
			local needBuyRes = v.num - v.haveNum
			if 0 < needBuyRes then
				magicLampCtrl = i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil)))
				i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil))).resid = v.id
				i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil))).rescount = v.num
				table.insert(self.tableResNeedBuy, i18n("magic_lamp_text_023", i18n("common_text_100", i18n("common_text_100", nil))))
				self.resToGold = self.resToGold + serviceFunctions.resConvertToGold(v.id, needBuyRes)
			end
		end
	end
	_ENV = ipairs(self.costRes)
	ipairs(self.costRes)[1] = "id"
	ipairs(self.costRes)[2] = "num"
	self.spxCostRes = serviceFunctions.tableFormat(self.nextCfg.SpxCost, ipairs(self.costRes))
	local isAllSpxEnough = true
	for i, v in ipairs(self.spxCostRes) do
		local itemNum = backpackCtrl:getItemCount(v.id)
		v.isEnough = itemNum >= v.num
		v.haveNum = itemNum
		isAllSpxEnough = isAllSpxEnough and v.isEnough
	end
	self.spxNum = #self.spxCostRes
	self.fields.list_res:setNumItems(#self.spxCostRes + #self.costRes)
	self.fields.button_normal:setCostTitle(SoraDConvertSecondToString(self.nextCfg.Time))
	self.fields.button_normal:setTouchEnabled(isAllSpxEnough)
	self.fields.button_normal:setBtnBgGray(not isAllSpxEnough)
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	self.timeToGold = serviceFunctions.timeConvertToGold(self.nextCfg.Time)
	self.fields.button_gold:setCostNum(self.timeToGold + self.resToGold, haveGold)
	self.fields.button_gold:setTouchEnabled(isAllSpxEnough)
	self.fields.button_gold:setBtnBgGray(not isAllSpxEnough)
end
function MagicLampStrengthPanel:onItemsRender(index, obj)
	if index < self.spxNum then
		obj:initByItem(self.spxCostRes[index + 1], index)
	else
		obj:initByRes(self.costRes[index + 1 - self.spxNum], index)
	end
	obj:setGetClickCallback(handler(self, self.onGetClick))
end
function MagicLampStrengthPanel:onGetClick(needRes, data, itemData)
	if needRes then
		_ENV = nil
		;(nil).rid = needRes.id
		;(nil).needResData = self.tableResNeedBuy
		uiManager:show("resourceBuyView", nil)
	elseif itemData then
		_ENV = nil
		;(nil).itemID = itemData.id
		uiManager:show("CommonSourceGuide", nil)
	end
end
function MagicLampStrengthPanel:onNormalClick()
	SoraDPlaySound()
	if self.resToGold ~= 0 then
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(self.tableResNeedBuy) then
			uiManager:show("CommonQuicklyadd")
		else
			_ENV, _ENV = nil, nil
			;(nil).resToGold = self.resToGold
			;(nil).needResData, (nil).retCostRes = nil, self.tableResNeedBuy
			;(nil).viewType = RESBUYVIEW_TYPE.MGAGIC_LAMP_STRENGTH
			;(nil).handle = handler(self, self.updateNormal)
			uiManager:show("buildCreateResBuy", nil)
		end
		return
	end
	self:updateNormal(true)
end
function MagicLampStrengthPanel:onGoldClick()
	SoraDPlaySound()
	if not SoraDEnoughGold(self.timeToGold + self.resToGold) then
		return
	end
	if IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_STRENGTH then
		SoraDShowBuyBox(i18n("magic_lamp_text_025"), self.timeToGold + self.resToGold, i18n("magic_lamp_text_022"), function(callType, data)
			if MSGBOX_CALLBACK_YES == callType then
				IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_STRENGTH = not data.isCheck
				self:upgradeNow()
			end
		end, nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), IS_SELECT_LOGIN_NOTICE, true)
	else
		self:upgradeNow()
	end
end
function MagicLampStrengthPanel:updateNormal(isNoGold)
	print("MagicLampStrengthPanel:updateNormal")
	magicLampCtrl:reqMagicLampUpgradeLv(self.curType, isNoGold and 1 or 3)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queuetype = gQueueTypeDef.magic_lamp_jinn_level
	local totaltime = tonumber(self.nextCfg.Time)
	local lefttime = tonumber(self.nextCfg.Time)
	local starttime = serviceFunctions.systemTime() + 1
	_ENV = nil
	;(nil).bid = tostring(BUILDID.MAGIC_LAMP)
	queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
	self:close()
end
function MagicLampStrengthPanel:upgradeNow()
	magicLampCtrl:reqMagicLampUpgradeLv(self.curType, 2)
	self:close()
end
return MagicLampStrengthPanel

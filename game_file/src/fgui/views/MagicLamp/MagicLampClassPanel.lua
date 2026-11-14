local buffCtrl = SoraDGetCtrl("buffCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampClassPanel = class("MagicLampClassPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
function MagicLampClassPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampClassPanel:ctor", self.viewName)
end
function MagicLampClassPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampClassPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampClassPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_04"))
	self.fields.text_tip2:setString(i18n("magic_lamp_text_027"))
	self.fields.title:setString(i18n("magic_lamp_text_028"))
	self.fields.list_item:setItemRenderer(handler(self, self.onItemsRender))
	self.fields.list_res:setItemRenderer(handler(self, self.onResesRender))
	self.fields.button_normal:setTitle(i18n("magic_lamp_text_008"))
	self.fields.button_normal:addClickEventListener(handler(self, self.onNormalClick))
	self.fields.button_gold:setTitle(i18n("magic_lamp_text_029"))
	self.fields.button_gold:addClickEventListener(handler(self, self.onGoldClick))
	self.fields.btn_more:setTitle(i18n("common_text_337"))
	self.fields.btn_more:addClickEventListener(handler(self, self.onGetClick))
end
function MagicLampClassPanel:onShow()
	print("=======MagicLampClassPanel:onShow")
	self:updateView()
end
function MagicLampClassPanel:updateView()
	self.curType = self.param.jinnType
	self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	self.classCfg = magicLampRead.getClassCfg(self.curType, self.jinnData.classLv)
	self.nextCfg = magicLampRead.getClassCfg(self.curType, self.jinnData.classLv + 1)
	magicLampCtrl = nil
	;(nil).num = self.jinnData.classLv
	self.fields.lv_now:setString(i18n("magic_lamp_text_026", nil))
	magicLampCtrl = i18n("magic_lamp_text_026", nil)
	i18n("magic_lamp_text_026", nil).num = self.jinnData.classLv + 1
	self.fields.lv_to:setString(i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))
	magicLampCtrl = i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil))
	i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)).num = self.nextCfg.BlessPoint
	self.fields.text_tip1:setString(i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil))))
	self.tableResNeedBuy, magicLampCtrl, self.costRes = clone(self.nextCfg.resource), clone(self.nextCfg.resource), clone(self.nextCfg.resource)
	self.resToGold = 0
	local baseEffectBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, -1, self.jinnData, "class")
	local resSubBuff = magicLampCtrl:getCostBuffValue(self.curType, -1, self.jinnData, "class")
	for i, v in ipairs(self.costRes) do
		local needcount = v.num
		lordInfoCtrl = i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))
		i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))[1] = v
		i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))[2] = needcount
		i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))[3] = resSubBuff
		i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil)))[4] = baseEffectBuff
		dump(i18n("magic_lamp_text_023", i18n("magic_lamp_text_026", i18n("magic_lamp_text_026", nil))))
		needcount = math.ceil(needcount * resSubBuff * baseEffectBuff)
		local isEnough, curRes = SoraDEnoughRes(v.id, needcount)
		print("...,v.id", v.id, curRes, needcount)
		v.isEnough = isEnough
		v.haveNum = curRes
		v.needcount = needcount
		dump(v, "MagicLampClassPanel:updateView2")
		if not v.isEnough then
			local needBuyRes = needcount - v.haveNum
			if 0 < needBuyRes then
				magicLampCtrl = curRes
				curRes.resid = v.id
				curRes.rescount = needcount
				table.insert(self.tableResNeedBuy, curRes)
				self.resToGold = self.resToGold + serviceFunctions.resConvertToGold(v.id, needBuyRes)
			end
		end
	end
	local baseEffectBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, -3, self.jinnData, "class")
	self.spxCostRes = clone(self.nextCfg.cost)
	local isAllSpxEnough = true
	for i, v in ipairs(self.spxCostRes) do
		local itemNum = backpackCtrl:getItemCount(v.id)
		local needcount = v.num
		local itemSubBuff = magicLampCtrl:getCostBuffValue(self.curType, v.id, self.jinnData, "class")
		local itemBaseBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, v.id, self.jinnData, "class")
		needcount = math.ceil(needcount * itemSubBuff * baseEffectBuff * itemBaseBuff)
		v.needcount = needcount
		v.isEnough = itemNum >= needcount
		v.haveNum = itemNum
		isAllSpxEnough = isAllSpxEnough and v.isEnough
		self.fields.btn_more:setVisible(not v.isEnough)
	end
	self.spxNum = #self.spxCostRes
	self.fields.list_item:setNumItems(#self.spxCostRes)
	self.fields.list_res:setNumItems(#self.costRes)
	self.needTime = self.nextCfg.Time
	local baseEffectBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, -2, self.jinnData, "class")
	local timeSubBuff = magicLampCtrl:getCostBuffValue(self.curType, -2, self.jinnData, "class")
	self.needTime = math.floor(self.needTime * timeSubBuff * baseEffectBuff)
	print("timeSubBuff", timeSubBuff, self.needTime, self.nextCfg.Time)
	self.fields.button_normal:setCostTitle(SoraDConvertSecondToString(self.needTime))
	self.fields.button_normal:setTouchEnabled(isAllSpxEnough)
	self.fields.button_normal:setBtnBgGray(not isAllSpxEnough)
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	self.timeToGold = serviceFunctions.timeConvertToGold(self.needTime)
	self.fields.button_gold:setCostNum(self.timeToGold + self.resToGold, haveGold)
	self.fields.button_gold:setTouchEnabled(isAllSpxEnough)
	self.fields.button_gold:setBtnBgGray(not isAllSpxEnough)
end
function MagicLampClassPanel:onItemsRender(index, obj)
	obj:initByItem(self.spxCostRes[index + 1])
end
function MagicLampClassPanel:onResesRender(index, obj)
	obj:initByRes(self.costRes[index + 1], index)
	obj:setGetClickCallback(handler(self, self.onResGetClick))
end
function MagicLampClassPanel:onNormalClick()
	SoraDPlaySound()
	local coolingTip = magicLampCtrl:getCoolingTip("class")
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
			;(nil).viewType = RESBUYVIEW_TYPE.MGAGIC_LAMP_CLASS
			;(nil).handle = handler(self, self.updateNormal)
			uiManager:show("buildCreateResBuy", nil)
		end
		return
	end
	self:updateNormal(true)
end
function MagicLampClassPanel:onGetClick(sender, param)
	SoraDPlaySound()
	local itemData = self.spxCostRes[1]
	if itemData then
		_ENV = nil
		;(nil).itemID = itemData.id
		uiManager:show("CommonSourceGuide", nil)
	end
end
function MagicLampClassPanel:onResGetClick(needRes, data, itemData)
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
function MagicLampClassPanel:onGoldClick()
	SoraDPlaySound()
	if not SoraDEnoughGold(self.timeToGold + self.resToGold) then
		return
	end
	if IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_CLASS then
		SoraDShowBuyBox(i18n("magic_lamp_text_030"), self.timeToGold + self.resToGold, i18n("magic_lamp_text_029"), function(callType, data)
			if MSGBOX_CALLBACK_YES == callType then
				IS_FIRST_TIME_COST_GOLD_MAGIC_LAMP_CLASS = not data.isCheck
				self:upgradeNow()
			end
		end, nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), IS_SELECT_LOGIN_NOTICE, true)
	else
		self:upgradeNow()
	end
end
function MagicLampClassPanel:updateNormal(isNoGold)
	magicLampCtrl:reqMagicLampUpgradeClass(self.curType, isNoGold and 1 or 3)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queuetype = gQueueTypeDef.magic_lamp_jinn_class
	local totaltime = tonumber(self.needTime)
	local lefttime = tonumber(self.needTime)
	local starttime = serviceFunctions.systemTime() + 1
	magicLampCtrl = nil
	;(nil).bid = tostring(BUILDID.MAGIC_LAMP)
	;(nil).jinnID = self.curType
	queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
	self:close()
end
function MagicLampClassPanel:upgradeNow()
	magicLampCtrl:reqMagicLampUpgradeClass(self.curType, 2)
	self:close()
end
return MagicLampClassPanel

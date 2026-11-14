local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local armyChangeRead = include("armyChangeRead")
local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local publicUtil = include("publicUtil")
local publicRead = include("publicRead")
local armyltCtrl = include("armyltCtrl")
local armyTransferCtrl = SoraDGetCtrl("armyTransferCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local armyTransferMainPanel = class("armyTransferMainPanel", basePanel)
function armyTransferMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function armyTransferMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function armyTransferMainPanel:onInit()
	self.chooseNum = 1
	self.fields.Com_title:initData(i18n("activity_name_9001371"), handler(self, self.onClickClose), handler(self, self.helpCallback))
	self.fields.btn_Log:addClickListener(handler(self, self.onClickLog))
	self.fields.btn_Log:setString(i18n("common_text_836"))
	self.fields.btn_Log:fixPos()
	self.fields.btn_Transfer1:setTag(1)
	self.fields.btn_Transfer1:addClickListener(handler(self, self.onClickTranfer))
	self.fields.btn_Transfer1:setString(i18n("armyExchange_text_034"))
	self.fields.btn_Transfer2:setTag(2)
	self.fields.btn_Transfer2:addClickListener(handler(self, self.onClickTranfer))
	self.fields.btn_Transfer2:setString(i18n("armyExchange_text_034"))
	self.fields.targetArmyNode:addClickListener(handler(self, self.onClickChooseTarget))
	self.fields.orignArmyNode:addClickListener(handler(self, self.onClickChooseOrign))
	self.fields.targetArmyNode:setExchangeHandler(handler(self, self.onClickChooseTarget))
	self.fields.orignArmyNode:setExchangeHandler(handler(self, self.onClickChooseOrign))
	self.fields.com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.soldierOriPos = self.fields.imgSoldier:getPosition()
	_UPVALUE12_ = self.fields.imgSoldier
	self.fields.imgSoldier[1] = "targetArmyNode"
	self.fields.imgSoldier[2] = "orignArmyNode"
	self.fields.imgSoldier[3] = "btn_Transfer1"
	self.fields.imgSoldier[4] = "btn_Transfer2"
	self.fields.imgSoldier[5] = "armyTarget"
	self.fields.imgSoldier[6] = "com_Slider"
	self.fields.imgSoldier[7] = "textGetNum1"
	self.fields.imgSoldier[8] = "textGetNum2"
	self.fields.imgSoldier[9] = "text_targetName"
	self.fields.imgSoldier[10] = "text_orignName"
	self.fields.imgSoldier[11] = "n54"
	self.fields.imgSoldier[12] = "n52"
	for _, name in ipairs(self.fields.imgSoldier) do
		self.fields[name]:fixPos()
	end
end
function armyTransferMainPanel:onShow()
	self:initActivityTime()
	self:updateOrignArmy()
	self:updateTargetArmy()
end
function armyTransferMainPanel:updateItemsInfo()
	if self.chooseArmyType and self.chooseArmyLevel then
		self.costInfo = armyChangeRead.getArmyTranferCost(self.chooseArmyType, self.chooseArmyLevel)
		local maxNum = math.floor(SoraDGetCtrl("armyCtrl"):getArmyCount(self.origArmyId, ARMY_OPTYPE.NORMAL_ARMY) / self.costInfo[1].armyCostNum)
		if maxNum < 1 then
			self.origArmyId = nil
			self:updateOrignArmy()
			return
		end
		self.chooseNum = 1
		armyChangeRead = self.origArmyId
		self.origArmyId.maxValue = maxNum
		self.origArmyId.minValue = 1
		self.origArmyId.curValue = self.chooseNum
		self.origArmyId.moduleValue = self.costInfo[1].armyCostNum
		self.fields.com_Slider:initData(self.origArmyId)
		self:updateNum()
	end
end
function armyTransferMainPanel:updateNum()
	self.fields.btn_Transfer1:setCost(self.costInfo[1].cost[1].id, self.chooseNum * self.costInfo[1].cost[1].count, true)
	self.fields.btn_Transfer2:setCost(self.costInfo[2].cost[1].id, self.chooseNum * self.costInfo[2].cost[1].count, true)
	_ENV = true
	_ENV, _ENV, (true).num = self.chooseNum * self.costInfo[1].armyGetNum, string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum), string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum)
	string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum).num, (self.chooseNum * self.costInfo[1].armyGetNum).color = self.chooseNum * self.costInfo[1].armyGetNum, "#EBC369"
	self.fields.textGetNum1:setString(i18n_html("armyExchange_text_035", true, (string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum))))
	_ENV = i18n_html("armyExchange_text_035", true, (string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum)))
	_ENV, _ENV, i18n_html("armyExchange_text_035", true, (string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum))).num = self.chooseNum * self.costInfo[2].armyGetNum, string.formatnumberthousands(self.chooseNum * self.costInfo[2].armyGetNum), string.formatnumberthousands(self.chooseNum * self.costInfo[2].armyGetNum)
	string.formatnumberthousands(self.chooseNum * self.costInfo[2].armyGetNum).num, (self.chooseNum * self.costInfo[2].armyGetNum).color = self.chooseNum * self.costInfo[2].armyGetNum, "#EBC369"
	self.fields.textGetNum2:setString(i18n_html("armyExchange_text_035", i18n_html("armyExchange_text_035", true, (string.formatnumberthousands(self.chooseNum * self.costInfo[1].armyGetNum)))))
end
function armyTransferMainPanel:updateOrignArmy()
	if self.origArmyId then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.text_orignName:setString(armyDesRead.getName(self.origArmyId))
		self.fields.orignArmyNode:setIcon(self.origArmyId)
		self.fields.armyTarget:setIcon(self.origArmyId)
		self.fields.orignArmyNode:setState(1)
		self:updateItemsInfo()
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.text_orignName:setString(i18n("armyExchange_text_021"))
		self.fields.orignArmyNode:setState(0)
	end
end
function armyTransferMainPanel:updateTargetArmy()
	if self.targetArmyId then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.text_targetName:setString(armyDesRead.getName(self.targetArmyId))
		self.fields.targetArmyNode:setIcon(self.targetArmyId)
		self.fields.targetArmyNode:setState(1)
		self:updateArmySpine()
		self:updateOrignArmy()
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.text_targetName:setString(i18n("armyExchange_text_020"))
		self.fields.text_orignName:setString(i18n("armyExchange_text_031"))
		self.fields.targetArmyNode:setState(0)
		self.fields.orignArmyNode:setState(2)
	end
end
function armyTransferMainPanel:initActivityTime()
	self.fields.Labe_Time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.Labe_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function armyTransferMainPanel:updateArmySpine()
	local modelType = armyDesRead.getModelType(self.targetArmyId)
	local alv = armyLogic.getArmyLV(self.targetArmyId)
	local armyLv = serviceFunctions.getArmyViewLev(self.targetArmyId)
	if armyltCtrl.getSoldierType(self.targetArmyId) == gSoldierType.SOLDIER_TYPE_ELITE then
		local spine, _ = include("eliteSoldiersDef").getSpineByModelType(modelType, alv)
		if spine then
			self.fields.imgSoldier:setVisible(false)
			self.fields.spineLoader3D:setVisible(true)
			self.fields.spineLoader3D:clearContent()
			self.fields.spineLoader3D:setContent(spine)
			spine:setAnimation(0, "animation", true)
		end
		return
	elseif armyLogic.isStarArmy(self.targetArmyId) or 110 <= armyLv then
		local _, spine = armyDesRead.getSpecialArmyCfg(self.targetArmyId, true)
		if spine then
			self.fields.imgSoldier:setVisible(false)
			self.fields.spineLoader3D:setVisible(true)
			self.fields.spineLoader3D:clearContent()
			self.fields.spineLoader3D:setContent(spine)
			spine:setAnimation(0, "animation", true)
		end
		return
	end
	self.fields.spineLoader3D:setVisible(false)
	self.fields.imgSoldier:setVisible(true)
	self.fields.imgSoldier:setURL(armyDesRead.getPortrait(self.targetArmyId))
end
function armyTransferMainPanel:onClickTranfer(eventContext)
	SoraDPlaySound()
	local type = tonumber(eventContext:getSender():getTag())
	local costid = self.costInfo[type].cost[1].id
	local costNum = self.chooseNum * self.costInfo[type].cost[1].count
	if self.costInfo and costNum > publicUtil.getCount(costid) then
		_ENV = eventContext:getSender():getTag()
		eventContext:getSender():getTag().itemID = costid
		uiManager:show("CommonSourceGuide", eventContext:getSender():getTag())
		return
	end
	_ENV = eventContext:getSender():getTag()
	_ENV = eventContext:getSender():getTag()
	eventContext:getSender():getTag().name1 = publicRead.getName(costid)
	eventContext:getSender():getTag().name2 = armyDesRead.getName(self.origArmyId)
	eventContext:getSender():getTag().name3 = armyDesRead.getName(self.targetArmyId)
	eventContext:getSender():getTag().num1 = string.formatnumberthousands(costNum)
	eventContext:getSender():getTag().num2 = string.formatnumberthousands(self.chooseNum * self.costInfo[type].armyCostNum)
	eventContext:getSender():getTag().num3 = string.formatnumberthousands(self.chooseNum * self.costInfo[type].armyGetNum)
	eventContext:getSender():getTag().content = i18n("armyExchange_text_011", eventContext:getSender():getTag())
	eventContext:getSender():getTag().confirmFunc = function()
		SoraDShowLoading()
		_ENV = nil
		;(nil).origArmyId = self.origArmyId
		;(nil).targetArmyId = self.targetArmyId
		;(nil).count = self.chooseNum
		;(nil).type = type
		armyTransferCtrl:reqArmyTransferTrans(nil)
	end
	uiManager:show("MessageBox", eventContext:getSender():getTag()):setOwnerKey(self)
end
function armyTransferMainPanel:onClickLog()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 1
	uiManager:show("troopsExchangeLog", nil)
end
function armyTransferMainPanel:helpCallback(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("armyExchange_text_003")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function armyTransferMainPanel:onClickChooseTarget()
	SoraDPlaySound()
	local haveArmy = false
	for index = 4, 7 do
		local armyList = armyChangeRead.getTargetArmyIDList(index)
		if 0 < #armyList then
			haveArmy = true
			break
		end
	end
	if not haveArmy then
		SoraDShowMsgTip(i18n("armyExchange_text_037"))
		return
	end
	_ENV = i18n("armyExchange_text_037")
	i18n("armyExchange_text_037").handler = handler(self, self.chooseTargetBack)
	uiManager:show("armyTransferTarget", i18n("armyExchange_text_037"))
end
function armyTransferMainPanel:onClickChooseOrign()
	SoraDPlaySound()
	if not self.targetArmyId then
		SoraDShowMsgTip(i18n("armyExchange_text_007"))
		return
	end
	local idList = armyChangeRead.getOrignArmyIDList(self.chooseArmyType, self.chooseArmyLevel)
	if not idList or #idList <= 0 then
		SoraDShowMsgTip(i18n("armyExchange_text_038"))
		return
	end
	_ENV = i18n("armyExchange_text_038")
	i18n("armyExchange_text_038").level = self.chooseArmyLevel
	i18n("armyExchange_text_038").armyType = self.chooseArmyType
	i18n("armyExchange_text_038").handler = handler(self, self.chooseOrignBack)
	uiManager:show("armyTransferOrign", i18n("armyExchange_text_038"))
end
function armyTransferMainPanel:chooseOrignBack(armyid)
	print("chooseOrignBack", armyid)
	self.origArmyId = armyid
	self:updateOrignArmy()
end
function armyTransferMainPanel:chooseTargetBack(armyid)
	if self.targetArmyId ~= armyid then
		self.origArmyId = nil
	end
	self.targetArmyId = armyid
	self.chooseArmyLevel = armyLogic.getArmyLV(armyid)
	self.chooseArmyType = math.floor(armyid % 1000 / 100)
	print("chooseTargetBack", armyid, self.chooseArmyLevel, self.chooseArmyType)
	self:updateTargetArmy()
end
function armyTransferMainPanel:sliderCallBack(curValue)
	self.chooseNum = curValue
	self:updateNum()
end
return armyTransferMainPanel

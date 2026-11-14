local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampRead = include("magicLampRead")
local magicLampHatchRead = include("magicLampHatchRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local MagicLampHatchPanel = class("MagicLampHatchPanel", baseFguiPanel)
function MagicLampHatchPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("MagicLampHatchPanel:ctor", self.viewName)
end
function MagicLampHatchPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
		self._packageList, self._packageList[2] = self._packageList, "BuildViewCommon"
	end
	return self._packageList
end
function MagicLampHatchPanel:onInit()
	print("=======MagicLampHatchPanel:onInit")
	self.fields.Com_title:initData(i18n("Jinn_hatch_text_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.text_lv_tip2:setString(i18n("Jinn_hatch_text_54"))
	self.fields.text_tip4:setString(i18n("Jinn_hatch_text_55"))
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	_ENV = handler(self, self.onAttsRender)
	_ENV, _ENV, handler(self, self.onAttsRender).defaultClick = handler(self, self.onAttsRender)
	handler(self, self.onAttsRender).title = i18n("runningSheep_text_06")
	_ENV, handler(self, self.onAttsRender)[1], handler(self, self.onAttsRender).tag = handler(self, self.onAttsRender)
	handler(self, self.onAttsRender).title = i18n("lampWish_text_11")
	handler(self, self.onAttsRender).tabsetArray, handler(self, self.onAttsRender)[2], handler(self, self.onAttsRender).tag = handler(self, self.onAttsRender)
	handler(self, self.onAttsRender).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(handler(self, self.onAttsRender))
	self.curTag = 1
	self.jinnType = self.param.jinnType
	self.hatchType = self.param.hatchType
	self.wishCfg = magicLampHatchRead.getWishCfg()
	self.itemID = self.wishCfg.promoteItem[1]
	self.fields.Com_have:initData(self.itemID)
	self.fields.Com_have:setAddCallback(handler(self, self.onMoreClick))
	self.fields.Button_pray:setCost(self.itemID, self.wishCfg.promoteItem[2])
	self.bigBlessCfgs = magicLampRead.getBigBlessList(self.jinnType)
	self.maxLv = magicLampHatchRead.getMaxLv(self.hatchType)
	self.hatchCfg = magicLampHatchRead.getHatchCfg(self.hatchType)
	_ENV = handler(self, self.onMoreClick)
	handler(self, self.onMoreClick).name = i18n(self.hatchCfg.name)
	self.fields.text_lv_tip1:setString(i18n("Jinn_hatch_text_19", handler(self, self.onMoreClick)))
	self.fields.Button_oneKey:setTitle(i18n("Jinn_hatch_text_58"))
	self.fields.Button_oneKey:addClickEventListener(handler(self, self.onOneKeyClick))
	self.fields.Button_pray:setTitle(i18n("lampWish_text_11"))
	self.fields.Button_pray:addClickEventListener(handler(self, self.onPrayClick))
	self.fields.Button_up:setTitle(i18n("Jinn_hatch_text_18"))
	self.fields.Button_up:addClickEventListener(handler(self, self.onUpClick))
	self.fields.btn_add:addClickEventListener(handler(self, self.onChooseClick))
	self.fields.com_item:setClickCallback(handler(self, self.onChooseClick))
	self.fields.button_speed:setTitle(i18n("Jinn_hatch_text_33"))
	self.fields.button_speed:addClickEventListener(handler(self, self.onAddSpeed))
	self.fields.desire:setTitle(i18n("Jinn_hatch_text_12"))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.lv_now:fixPos()
	self.fields.lv_to:fixPos()
end
function MagicLampHatchPanel:onTabClick(tag)
	self.curTag = tag
	self:updateView()
end
function MagicLampHatchPanel:onShow()
	print("=======MagicLampHatchPanel:onShow")
	self:updateView()
	magicLampHatchCtrl:sendReqInitDataMsg()
end
function MagicLampHatchPanel:updateView()
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	if self.hatchData == nil then
		return
	end
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv)
	self.nextCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv + 1)
	self.desireItems = self.desireCfg.getItem
	self.isJinnTwoLock = not magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_TWO)
	self.fields.Com_ML_JinnSkill:setVisible(self.isJinnTwoLock)
	self.fields.text_lv_tip2:setVisible(self.isJinnTwoLock)
	if self.isJinnTwoLock then
		self.fields.Com_ML_JinnSkill:initData(self.jinnType, self.bigBlessCfgs[1])
		self.fields.Com_ML_JinnSkill:setClickCallback(handler(self, self.onJinnSkillClick))
	end
	magicLampHatchCtrl = handler(self, self.onJinnSkillClick)
	handler(self, self.onJinnSkillClick).lv = self.hatchData.lv
	self.fields.text_lvdes:setString(i18n("common_text_100", handler(self, self.onJinnSkillClick)))
	if self.oldLv ~= nil and self.oldLv < self.hatchData.lv then
		self.fields.Usm_2:setCompleteCallback(function()
			self.fields.Usm_2:setVisible(false)
		end)
		self.fields.Usm_2:play(false)
	end
	self.oldLv = self.hatchData.lv
	self:updateTimers()
	self:updateRedPoint()
	if self.curTag == 1 and not self.isMaxLv then
		self:updateLvUpView()
	else
		self:updatePrayView()
	end
	self:updateListBuffData()
end
function MagicLampHatchPanel:updateLvUpView()
	if self.isMaxLv then
		return
	end
	self.controllers.c2:setSelectedIndex(1)
	self.hatchUps, _ENV = self.controllers.c2.setSelectedIndex, self.controllers.c2.setSelectedIndex
	do
		local _ENV, hatchUp = self.controllers.c2.setSelectedIndex, self.controllers.c2.setSelectedIndex
		hatchUp.icon = "icon_xssd_rktb_01.png"
		hatchUp.desc = i18n("Jinn_hatch_text_56")
		table.insert(self.hatchUps, hatchUp)
	end
	if self.nextCfg.desireItem ~= 0 then
		local _ENV, hatchUp = self.nextCfg.desireItem, self.nextCfg.desireItem
		hatchUp.icon = "icon_xssd_tsbx.png"
		_ENV, _UPVALUE1_, hatchUp.desc = "Jinn_hatch_text_21", i18n("Jinn_hatch_text_21"), i18n("Jinn_hatch_text_21")
		;("Jinn_hatch_text_21").id = self.nextCfg.desireItem
		hatchUp.items, i18n("Jinn_hatch_text_21")[1] = i18n("Jinn_hatch_text_21"), "Jinn_hatch_text_21"
		table.insert(self.hatchUps, hatchUp)
	end
	do
		local _ENV, hatchUp = hatchUp, self.nextCfg.desireItem
		hatchUp.icon = "icon_xssd_ywz_xy_01.png"
		hatchUp.desc = i18n("Jinn_hatch_text_57")
		table.insert(self.hatchUps, hatchUp)
	end
	self.fields.list_att:setNumItems(#self.hatchUps)
	_ENV = nil
	;(nil).lv = self.hatchData.lv
	self.fields.lv_now:setString(i18n("common_text_2567", nil))
	_ENV = i18n("common_text_2567", nil)
	i18n("common_text_2567", nil).lv = self.hatchData.lv + 1
	self.fields.lv_to:setString(i18n("common_text_2567", i18n("common_text_2567", nil)))
end
function MagicLampHatchPanel:updatePrayView()
	self.controllers.c2:setSelectedIndex(0)
	self.desireInfo = self.hatchData.desireInfo
	self.chooseItemID = self.desireInfo.chooseItemID
	if self.chooseItemID ~= 0 then
		_ENV = nil
		;(nil).item = publicRead.getName(self.chooseItemID)
		self.fields.text_tip1:setString(i18n("Jinn_hatch_text_41", nil))
		self.fields.com_item:setVisible(true)
		self.fields.icon_switch:setVisible(true)
		self.fields.btn_add:setVisible(false)
		self:setChooseItem(nil)
	else
		self.fields.text_tip1:setString(i18n("Jinn_hatch_text_8"))
		self.fields.com_item:setVisible(false)
		self.fields.icon_switch:setVisible(false)
		self.fields.btn_add:setVisible(true)
		self.fields.btn_add:setReddot(true)
	end
	self.fields.progress:setMax(self.desireCfg.desire)
	self.fields.progress:setValue(self.desireInfo.desire)
	self.fields.Com_have:updateNum(self.desireInfo.disireResCount)
	_ENV = i18n("Jinn_hatch_text_8")
	i18n("Jinn_hatch_text_8").num1 = self.desireInfo.donateCount
	i18n("Jinn_hatch_text_8").num2 = self.desireCfg.wishTimes
	self.fields.text_tip3:setString(i18n("Jinn_hatch_text_51", i18n("Jinn_hatch_text_8")))
	self.fields.Button_pray:setCostNum(self.wishCfg.promoteItem[2], self.desireInfo.disireResCount)
end
function MagicLampHatchPanel:setChooseItem(data)
	if data == nil then
		for i, v in ipairs(self.desireItems) do
			if v.id == self.chooseItemID then
				data = v
				break
			end
		end
	end
	if data == nil then
		return
	end
	local realNum = magicLampHatchCtrl:getRealItemNum(self.hatchData.desireInfo.desire, data.num)
	self.fields.com_item:initData(data.id, realNum)
end
function MagicLampHatchPanel:updateTimers()
	self.isMaxLv = self.hatchData.lv >= self.maxLv
	self.controllers.c3:setSelectedIndex(self.isMaxLv and 1 or 0)
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_hatch_level)
	self.lastTime = self.queue ~= nil and self.queue.timerNode.timer:getRemainTime() or 0
	self.fields.Button_up:setVisible(not self.isMaxLv and self.lastTime == 0)
	self.fields.button_speed:setVisible(0 < self.lastTime)
	if not self.fields.button_speed:isVisible() then
		self.fields.button_speed:endTime()
	else
		self.fields.button_speed:setBeginTime(self.lastTime)
	end
end
function MagicLampHatchPanel:updateRedPoint()
	local isCanUp = magicLampHatchCtrl:getIsCanHatchUp(self.hatchType)
	self.fields.Button_up:setReddot(isCanUp, 0)
end
function MagicLampHatchPanel:onAttsRender(index, obj)
	obj:initData(self.hatchUps[index + 1], index)
end
function MagicLampHatchPanel:onDesireItemsRender(index, obj)
	local desireItem = self.desireItems[index + 1]
	obj:initData(desireItem, self.hatchData)
	obj:setClickCallback(handler(self, self.onDesireItemsClick))
end
function MagicLampHatchPanel:onDesireItemsClick(item)
	local itemid = item.id
	if itemid == self.chooseItemID then
		return
	end
	magicLampHatchCtrl:reqMagicLampHatchDesireItem(self.hatchType, itemid)
end
function MagicLampHatchPanel:onOneKeyClick()
	SoraDPlaySound()
	if not self.chooseItemID then
		SoraDShowMsgTip(i18n("Jinn_hatch_text_14"))
		return
	end
	_ENV = i18n("Jinn_hatch_text_14")
	i18n("Jinn_hatch_text_14").hatchType = self.hatchType
	uiManager:show("MaigcLampOneKey", i18n("Jinn_hatch_text_14"))
end
function MagicLampHatchPanel:onPrayClick()
	SoraDPlaySound()
	if self.desireInfo.disireResCount < self.wishCfg.promoteItem[2] then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	if not self.chooseItemID then
		SoraDShowMsgTip(i18n("Jinn_hatch_text_14"))
		return
	end
	if self.desireInfo.donateCount >= self.desireCfg.wishTimes then
		local nextDayUTC = serviceFunctions.getTomorrowZeroHourUTC()
		_ENV = i18n("Jinn_hatch_text_14")
		i18n("Jinn_hatch_text_14").time = SoraDConvertSecondToString(nextDayUTC - serviceFunctions.systemTime())
		SoraDShowMsgTip(i18n("Jinn_hatch_text_50", i18n("Jinn_hatch_text_14")))
		return
	end
	magicLampHatchCtrl:reqMagicLampHatchDonate(self.hatchType, 1)
end
function MagicLampHatchPanel:onUpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	uiManager:show("MagicLampHatchUp", nil)
end
function MagicLampHatchPanel:onChooseClick()
	if self.isCanReceive then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	;(nil).desireItems = self.desireCfg.getItem
	uiManager:show("MagicLampHatchChoose", nil)
end
function MagicLampHatchPanel:onAddSpeed()
	SoraDPlaySound()
	local queue = self.queue
	if queue == nil then
		return
	end
	local speedUpItemList = backpackCtrl:getSpeedUpItemList(queue.qtype)
	if 0 < #speedUpItemList then
		SoraDShowSpeedUpByItemBox(queue.qtype)
	else
		SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
	end
end
function MagicLampHatchPanel:onMoreClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	uiManager:show("MagicLampHatchGet", nil)
end
function MagicLampHatchPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Jinn_hatch_text_4")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MagicLampHatchPanel:onJinnSkillClick(data, blessLv)
	if blessLv == nil or blessLv <= 0 then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.jinnType
	;(nil).blessID = data.BlessID
	uiManager:show("MagicLampPower", nil)
end
function MagicLampHatchPanel:onBuffItemRenderer(index, obj)
	local activityID = self.buffDataList[index + 1]
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).handle = function()
		self:updateListBuffData()
	end
	;(nil).buffBuildType = BUILD_ENUM.MAGIC_LAMP_HATCH
	obj:initData(nil)
end
function MagicLampHatchPanel:updateListBuffData(...)
	if not self.buffData then
		_ENV = self.buffData
	end
	_UPVALUE1_, self.buffData = self.buffData, self.buffData
	local self.buffData[1], config = gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY, self.buffData
	for __, activityID in ipairs(config) do
		self:updateBuffByActivityID(activityID)
	end
	self:updateListBuff()
end
function MagicLampHatchPanel:updateListBuff()
	_ENV, self.buffDataList = table.keys(self.buffData), table.keys(self.buffData)
	local table.keys(self.buffData)[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY], sortValue = 1, table.keys(self.buffData)
	table.sort(self.buffDataList, function(eid1, eid2)
		return sortValue[eid1] < sortValue[eid2]
	end)
	self.fields.List_buff:setNumItems(#self.buffDataList)
end
function MagicLampHatchPanel:updateBuffByActivityID(activityID)
	if self.hatchType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.MAGIC_LAMP_HATCH) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
return MagicLampHatchPanel

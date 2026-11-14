local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroTrainGroundCtrl = SoraDGetCtrl("heroTrainGroundCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonSpeedUpByItemBoxPanel = class("commonSpeedUpByItemBoxPanel", baseFguiPanel)
function commonSpeedUpByItemBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonSpeedUpByItemBoxPanel:ctor", self.viewName)
end
function commonSpeedUpByItemBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonSpeedUpByItemBoxPanel:onInit()
	print("=======commonSpeedUpByItemBoxPanel:onInit")
	self.tableItemData, _ENV = print, print
	self.callBackHandle = self.param.handle
	self.type = tonumber(self.param.type)
	self.queue = queueCtrl:queryQueue(self.type)
	self.sType = self.param.sType
	self.position = self.param.position
	self.isHaveGift = false
	_ENV = self.type
	self.type.byUID = true
	self.chooseType = SoraDConfigGet("Game:commonSpeedUp:choose~integer", self.type) or 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function commonSpeedUpByItemBoxPanel:onShow()
	print("=======commonSpeedUpByItemBoxPanel:onShow")
	self:checkGift()
	self:initData()
end
function commonSpeedUpByItemBoxPanel:onItemRenderer(index, obj)
	obj:initData(self.tableItemData[index + 1], self.type, self.itemType, self, self.position)
end
function commonSpeedUpByItemBoxPanel:updateData(target, data)
	SoraDCloseLoading(self)
	if self.position then
		local _cur, _total = heroTrainGroundCtrl:getPositionTrainTime(self.position)
		if not _cur or _cur <= 0 then
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
		self.tableItemData = backpackCtrl:getSpeedUpItemList(self.itemType, true)
		self.fields.List:setNumItems(#self.tableItemData)
		self.fields.Com_time:initData(self, self.type, self.itemType, self.queue, i18n("common_text_314"), self.position)
		self:updateShowIndex(true)
		return
	end
	self.queue = queueCtrl:queryQueue(self.type)
	if not self.queue or self.queue.timerNode.timer:getRemainTime() < 1 or data and data.isTimeEnd then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:checkGift()
	self.tableItemData = backpackCtrl:getSpeedUpItemList(self.itemType, true)
	self.fields.List:setNumItems(#self.tableItemData)
	self.fields.Com_time:initData(self, self.type, self.itemType, self.queue)
	if not self.fields.Com_time:isFreeModel() then
		self.fields.Com_best:initData(self.type, self.itemType, self.queue, self, true)
	end
	self:updateShowIndex(true)
end
function commonSpeedUpByItemBoxPanel:checkGift()
	self.isHaveGift = false
	if self.type == gQueueTypeDef.free_build_queue or self.type == gQueueTypeDef.charge_build_queue then
		local giftID = 14308
		local giftList = include("rechargeViewLimitGiftNode"):getLimitData()
		local _ENV, giftData = include("rechargeViewLimitGiftNode"), include("rechargeViewLimitGiftNode")
		for k, v in ipairs(giftList) do
			if v.rid == giftID then
				local buyTimes = (v.payType == gRechargeActivityBuyType.LIMIT or v.payType == gRechargeActivityBuyType.LIMIT_DAILY) and tonumber(v.extraData) or 1
				if 0 < buyTimes then
					self.isHaveGift = true
					giftData = v
					break
				end
			end
		end
		if self.isHaveGift then
			self.fields.Com_gift:initData(giftID, giftData)
		end
	end
end
function commonSpeedUpByItemBoxPanel:initData()
	if self.queue then
		local title = ""
		local speed = ""
		if self.type == gQueueTypeDef.free_build_queue or self.type == gQueueTypeDef.charge_build_queue then
			title = i18n("common_text_767")
			speed = i18n("common_text_379")
			self.itemType = gAbbrSpeedUpType.BUILD_UPGRADE
		elseif queueCtrl:isHospitalQueue(self.type) then
			title = i18n("common_text_768")
			speed = i18n("common_text_402")
			self.itemType = backpackCtrl:getSpeedUpTypeByQueueType(self.type)
		elseif self.type == gQueueTypeDef.elite_queue or self.type == gQueueTypeDef.chariot_plant_queue or self.type == gQueueTypeDef.stables_queue or self.type == gQueueTypeDef.range_queue or self.type == gQueueTypeDef.barracks_queue then
			title = i18n("common_text_769")
			speed = i18n("common_text_317")
			self.itemType = gAbbrSpeedUpType.TRAIN_TROOP
		elseif self.type == gQueueTypeDef.frotress_queue then
			title = i18n("common_text_770")
			speed = i18n("common_text_379")
			self.itemType = gAbbrSpeedUpType.BUILD_TRAP
		elseif self.type == gQueueTypeDef.technology_upgrade_queue then
			title = i18n("common_text_771")
			speed = i18n("common_text_335")
			self.itemType = gAbbrSpeedUpType.TECH
		elseif self.type == gQueueTypeDef.nebula_palace_technology then
			title = i18n("common_text_771")
			speed = i18n("common_text_335")
			self.itemType = gAbbrSpeedUpType.TECH
		elseif self.type == gQueueTypeDef.war_tech_research then
			title = i18n("common_text_771")
			speed = i18n("common_text_335")
			self.itemType = gAbbrSpeedUpType.TECH
		elseif self.type == gQueueTypeDef.garden_technology then
			title = i18n("common_text_771")
			speed = i18n("common_text_335")
			self.itemType = gAbbrSpeedUpType.TECH
		elseif self.type == gQueueTypeDef.forge_equipment then
			title = i18n("common_text_1419")
			speed = i18n("common_text_2219")
		elseif self.type == gQueueTypeDef.hero_upgrade then
			title = sType and i18n("hero_btn_04") or i18n("hero_text_66")
			speed = sType and i18n("hero_btn_05") or i18n("hero_text_67")
		elseif self.type == gQueueTypeDef.prompt_army then
			title = i18n("arms_promotion_text_04")
			speed = i18n("arms_promotion_btn_02")
			self.itemType = gAbbrSpeedUpType.TRAIN_TROOP
		elseif self.type == gQueueTypeDef.miraculous_weapon_unlock then
			title = i18n("weapon_text_22")
			speed = i18n("weapon_btn_01")
		elseif self.type == gQueueTypeDef.armor_forging then
			title = i18n("Soldiers_armor_text_6")
			speed = i18n("common_text_2219")
			self.itemType = gAbbrSpeedUpType.WARFRAME_FORG
		elseif self.type == gQueueTypeDef.craft_study then
			title = i18n("Soldiers_armor_text_7")
			speed = i18n("Soldiers_armor_text_10")
			self.itemType = gAbbrSpeedUpType.CRAFT_STUDY
		elseif self.type == gQueueTypeDef.build_mastery then
			title = i18n("specialization_text_11")
			speed = i18n("common_text_378")
			self.itemType = gAbbrSpeedUpType.MASTERY_UPGRADE
		elseif self.type == gQueueTypeDef.magic_lamp_jinn_level then
			title = i18n("magic_lamp_title_06")
			speed = i18n("magic_lamp_text_022")
			self.itemType = gAbbrSpeedUpType.GENERAL
		elseif self.type == gQueueTypeDef.magic_lamp_jinn_star then
			title = i18n("magic_lamp_title_05")
			speed = i18n("magic_lamp_text_020")
			self.itemType = gAbbrSpeedUpType.GENERAL
		elseif self.type == gQueueTypeDef.magic_lamp_jinn_class then
			title = i18n("magic_lamp_title_07")
			speed = i18n("magic_lamp_text_029")
			self.itemType = gAbbrSpeedUpType.GENERAL
		elseif self.type == gQueueTypeDef.magic_lamp_hatch_level then
			title = i18n("Jinn_hatch_text_2")
			speed = i18n("Jinn_hatch_text_24")
			self.itemType = gAbbrSpeedUpType.GENERAL
		elseif self:checkIsUpgradeStar() then
			local buildDescribeRead = include("buildDescribeRead")
			local name = buildDescribeRead.getName(self.queue.data.bid)
			_ENV = nil
			;(nil).build = name
			title = i18n("Glory_text_31", nil)
			speed = i18n("Glory_text_14")
			if self.type == gQueueTypeDef.glorious_upgrade then
				title = i18n("Soldiers_armor_text_70")
				speed = i18n("Soldiers_armor_btn_01")
			end
			self.itemType = gAbbrSpeedUpType.BUILD_UPGRADE
		elseif self.type == gQueueTypeDef.garden_build_upgrade then
			title = i18n("common_text_767")
			speed = i18n("common_text_379")
			self.itemType = gAbbrSpeedUpType.BUILD_UPGRADE
		end
		self.tableItemData = backpackCtrl:getSpeedUpItemList(self.itemType, true)
		self.fields.List:setNumItems(#self.tableItemData)
		self.fields.Panel_bg:setString(title)
		self.fields.Com_time:initData(self, self.type, self.itemType, self.queue, speed)
		if not self.fields.Com_time:isFreeModel() then
			self.fields.Com_best:initData(self.type, self.itemType, self.queue, self)
		end
		self:updateShowIndex()
	elseif self.position then
		self.itemType = gAbbrSpeedUpType.HERO_TRAIN
		self.tableItemData = backpackCtrl:getSpeedUpItemList(self.itemType, true)
		self.fields.List:setNumItems(#self.tableItemData)
		self.fields.Panel_bg:setString(i18n("war_stone_name_20"))
		self.fields.Com_time:initData(self, self.type, self.itemType, self.queue, i18n("common_text_314"), self.position)
		self:updateShowIndex()
	end
end
function commonSpeedUpByItemBoxPanel:checkIsUpgradeStar()
	if self.type == gQueueTypeDef.build_star_queue or self.type == gQueueTypeDef.build_star_queue_privilege or self.type == gQueueTypeDef.glorious_upgrade then
		return true
	end
end
function commonSpeedUpByItemBoxPanel:updateShowIndex(isFromMsg)
	if self.position then
		self.showIndex = 2
	else
		self.showIndex = 0
		self.tableItemData = backpackCtrl:getSpeedUpItemList(self.itemType, true)
		if #self.tableItemData == 0 and isFromMsg then
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
		if self.isHaveGift then
			self.showIndex = (self.fields.Com_time:isFreeModel() or #self.tableItemData == 0) and 3 or 1
		else
			self.showIndex = (self.fields.Com_time:isFreeModel() or #self.tableItemData == 0) and 2 or 0
		end
	end
	self.controllers.c1:setSelectedIndex(self.showIndex)
end
function commonSpeedUpByItemBoxPanel:onHide()
	if self.callBackHandle then
		self.callBackHandle()
	end
end
function commonSpeedUpByItemBoxPanel:onMsgUpdateQueue(target, event)
	if event.qtype == self.type then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function commonSpeedUpByItemBoxPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_use" then
		return self.fields.Com_best:getBtnUse()
	else
		return self.fields[itemName]
	end
end
return commonSpeedUpByItemBoxPanel

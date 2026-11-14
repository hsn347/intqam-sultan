local itemLogic = include("itemLogic")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemDesRead = include("itemDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local itemSingleInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/itemSingleInfo", itemSingleInfo)
_ENV = fgui.register_extension
fgui.register_extension.NORMAL = 1
fgui.register_extension.WARGEM = 2
fgui.register_extension.WARFRAME = 3
local fgui.register_extension.HEROCHIP, BAG_TYPE = 4, fgui.register_extension
function itemSingleInfo:onInit()
	self.searchPanel = nil
	self.fields.Text_time:setVisible(false)
	self.fields.Button_search:setVisible(false)
	self.fields.Button_use:setVisible(false)
	self.fields.Button_use:addClickListener(handler(self, self.onBtnUseClick))
	self.fields.Button_search:addClickListener(handler(self, self.onBtnSearchClick))
	self.fields.Button_compose:setTitle(i18n("common_text_1352"))
	self.fields.Button_compose:setVisible(false)
	self.fields.Button_compose:addClickListener(handler(self, self.onBtnComposeClick))
	self.fields.Text_title:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Text_time:fixPos()
	self.fields.Button_search:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Button_compose:fixPos()
	self.fields.lock:fixPos()
end
function itemSingleInfo:onShow()
end
function itemSingleInfo:getBtnUse()
	return self.fields.Button_use
end
function itemSingleInfo:openTimer()
	if not self.timer then
		self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
	end
	self:updateTime()
end
function itemSingleInfo:updateTime(dt)
	if self.leftTime <= 0 then
		self:closeTimer()
		self.fields.Text_time:setVisible(false)
		return
	end
	if self.data.isInUseLimitedItem then
		if self.leftTime < 1800 then
			_ENV = nil
			_ENV, _ENV, (nil).time = self.leftTime, SoraDConvertSecondToString(self.leftTime), SoraDConvertSecondToString(self.leftTime)
			_ENV, SoraDConvertSecondToString(self.leftTime).time, self.leftTime.color = self.leftTime, self.leftTime, "#ff0000"
			SoraDConvertSecondToString(self.leftTime).__default, self.leftTime.color = self.leftTime, "#ffffff"
			self.fields.Text_time:setString("(" .. i18n_html("treasure_crystal_title_02", nil, (SoraDConvertSecondToString(self.leftTime))) .. ")")
		else
			_ENV = nil
			;(nil).time = SoraDConvertSecondToString(self.leftTime)
			self.fields.Text_time:setString("(" .. i18n("treasure_crystal_title_02", nil) .. ")")
		end
	elseif self.data.isLimitedItem then
		if self.leftTime < 1800 then
			_ENV = nil
			_ENV, _ENV, (nil).time = self.leftTime, SoraDConvertSecondToString(self.leftTime), SoraDConvertSecondToString(self.leftTime)
			_ENV, SoraDConvertSecondToString(self.leftTime).time, self.leftTime.color = self.leftTime, self.leftTime, "#ff0000"
			SoraDConvertSecondToString(self.leftTime).__default, self.leftTime.color = self.leftTime, "#ffffff"
			self.fields.Text_time:setString("(" .. i18n_html("common_text_3604", nil, (SoraDConvertSecondToString(self.leftTime))) .. ")")
		else
			_ENV = nil
			;(nil).time = SoraDConvertSecondToString(self.leftTime)
			self.fields.Text_time:setString("(" .. i18n("common_text_3604", nil) .. ")")
		end
	elseif self.itemType == gItemType.HERO_CHIP then
		_ENV = ")"
		;(")").time = SoraDConvertSecondToString(self.leftTime)
		self.fields.Text_time:setString(i18n("notactivate_text_2", ")"))
	else
		_ENV = i18n("notactivate_text_2", ")")
		i18n("notactivate_text_2", ")").time = SoraDConvertSecondToString(self.leftTime)
		self.fields.Text_time:setString("(" .. i18n("valentine_text_01", i18n("notactivate_text_2", ")")) .. ")")
	end
	self.leftTime = self.leftTime - 1
end
function itemSingleInfo:closeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function itemSingleInfo:initData(data, index, otherData)
	self.data = data
	self.itemID = self.data.id
	self.searchPanel = nil
	self.fields.Image_arr:setPositionX(SoraDFPosX(620 - 126 * index + 55, 588))
	self.invalidtime = self.data.invalidtime or self.data.isLimitedItem or self.data.isInUseLimitedItem
	self.bagType = otherData and otherData.bagType
	if self.bagType == BAG_TYPE.WARGEM then
		self:initWarGemData(data)
		return
	elseif self.bagType == BAG_TYPE.WARFRAME then
		self:initWarframeData(data)
		return
	elseif self.bagType == BAG_TYPE.HEROCHIP then
		self:initHeroChipData(data)
		return
	end
	self.itemType = backpackltCtrl:getItemType(self.itemID)
	self.isUnlockHero = false
	local spInvalidTime = itemLogic.getSpecailItemInvalidTime(self.itemID)
	if spInvalidTime ~= false then
		self.invalidtime = spInvalidTime or 0
	end
	if self.invalidtime and self.invalidtime > serviceFunctions.systemTime() then
		self.fields.Text_time:setVisible(true)
		self.leftTime = self.invalidtime - serviceFunctions.systemTime()
		self:openTimer()
	elseif self.itemType == gItemType.HERO_CHIP then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = heroltCtrl:getHeroIDByItemID(self.itemID)
		local activeTime = heroltCtrl:getUpgradeActiveTime(heroID)
		if activeTime and 0 < activeTime and activeTime > serviceFunctions.systemTime() then
			self.isUnlockHero = true
			self.fields.Text_time:setVisible(true)
			self.leftTime = activeTime - serviceFunctions.systemTime()
			self:openTimer()
		else
			self.isUnlockHero = false
			self:closeTimer()
			self.fields.Text_time:setVisible(false)
		end
	else
		self:closeTimer()
		self.fields.Text_time:setVisible(false)
	end
	if backpackltCtrl:canUse(self.itemID) then
		if backpackltCtrl:getResultType(self.itemID) == gItemEffectDef.MERGE_FRAGMENG then
			self.fields.Button_use:setTitleText(i18n("common_text_1352"))
		elseif backpackltCtrl:getResultType(self.itemID) == gItemEffectDef.CHEST then
			self.fields.Button_use:setTitleText(i18n("common_text_246_ros"))
		elseif backpackltCtrl:getResultType(self.itemID) == gItemEffectDef.EXCHANGE then
			self.fields.Button_use:setTitleText(i18n("common_text_1889"))
		else
			self.fields.Button_use:setTitleText(i18n("common_text_314"))
		end
		self.fields.Button_use:setVisible(true)
		self.fields.Text_des:setSize(cc.size(420, 120))
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Text_des:setSize(cc.size(570, 120))
	end
	local isBtnUseVisible = self.fields.Button_use:isVisible()
	if backpackltCtrl:canCompose(self.itemID) then
		self.fields.Button_compose:setVisible(true)
		local btnUsePosX = self.fields.Button_use:getPositionX()
		if isBtnUseVisible then
			self.fields.Button_compose:setPositionX(SoraDFIsRA() and btnUsePosX + 160 or btnUsePosX - 160)
			self.fields.Text_des:setSize(cc.size(520, 63))
		else
			self.fields.Button_compose:setPositionX(self.fields.Button_use:getPositionX())
			self.fields.Text_des:setSize(cc.size(420, 120))
		end
	else
		self.fields.Button_compose:setVisible(false)
		self.fields.Text_des:setSize(isBtnUseVisible and cc.size(420, 120) or cc.size(570, 120))
	end
	if self.data.isInUseLimitedItem or self.data.isLimitedItem then
		self.fields.Text_time:setColor(cc.c3b(255, 255, 255))
		if self.data.isInUseLimitedItem then
			self.fields.Button_use:setTitleText(i18n("common_text_829"))
		end
	end
	local resultType = backpackltCtrl:getResultType(self.itemID)
	if resultType == gItemEffectDef.OPTIONAL_HERO then
		self.fields.Text_des:setColor(cc.c3b(255, 255, 255))
		_ENV = cc.c3b(255, 255, 255)
		cc.c3b(255, 255, 255).name = i18n("Endless_trial_text_22")
		_ENV, _ENV, cc.c3b(255, 255, 255).num = self.itemID, itemDesRead.getDes(self.itemID), itemDesRead.getDes(self.itemID)
		_ENV, itemDesRead.getDes(self.itemID).name, self.itemID.color = self.itemID, self.itemID, "#ff0000"
		itemDesRead.getDes(self.itemID).num, self.itemID.color = self.itemID, "#E4B194"
		self.fields.Text_des:setString(i18n_html("common_text_036", cc.c3b(255, 255, 255)))
	else
		self.fields.Text_des:setString(itemDesRead.getDes(self.itemID))
	end
	self.fields.Text_title:setString(itemDesRead.getName(self.itemID))
	fguiHelper.setTextWidthHeight2(self.fields.Text_title, cc.size(380, 40))
	self.fields.Button_use:setBright(true)
	if resultType == gItemEffectDef.BUFF then
		local buffID = backpackltCtrl:getResult(self.itemID)
		local buffEffect = buffltCtrl:getEffectType(buffID)
		if buffEffect == gBuffEffect.MASSACRE and worldMapDefine.isInPyramid() then
			self.fields.Button_use:setBright(false)
		end
	end
	if self.isUnlockHero then
		self.fields.Text_time:setPositionY(165)
		self.fields.Text_time:setPositionX(self.fields.Text_title:getPositionX())
	end
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(self.itemID)
	if ret and next(ret) and isShow then
		self.fields.Button_search:setVisible(true)
		self.searchPanel = "CommonItemShowBox"
	else
		local isDressShow = backpackltCtrl:isSkinShow(self.itemID)
		if isDressShow then
			self.fields.Button_search:setVisible(true)
			self.searchPanel = "commonDressPreview"
		elseif backpackltCtrl:getResultType(self.itemID) == gItemEffectDef.HERO_DRESS then
			self.fields.Button_search:setVisible(true)
			self.searchPanel = "HeroDressPreview"
		else
			self.fields.Button_search:setVisible(false)
		end
	end
	self.fields.lock:setVisible(backpackCtrl:isItemLock(self.itemID))
end
function itemSingleInfo:onBtnUseClick()
	if self.bagType == BAG_TYPE.WARGEM then
		self:onBtnUseGemClick()
		return
	elseif self.bagType == BAG_TYPE.WARFRAME then
		self:onBtnUseWarFrameClick()
		return
	elseif self.bagType == BAG_TYPE.HEROCHIP then
		self:onBtnUseHeroChipClick()
		return
	end
	SoraDPlaySound()
	if backpackCtrl:isItemLock(self.itemID) then
		SoraDShowMsgTip(i18n("Safety_lock_text_36"))
		return
	end
	local itemType = backpackltCtrl:getItemType(self.itemID)
	backpackCtrl = backpackltCtrl
	backpackltCtrl[1] = gItemType.VIP_POINT
	local backpackltCtrl[2], vipList = gItemType.S_VIP_POINT, backpackltCtrl
	if SoraDisInList(itemType, vipList) and SoraDGetVipLv() >= SVIP_LV10_LIMITED then
		SoraDShowMsgBox(i18n("circus_text_25"), i18n("common_text_204"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).isInUseLimitedItem = self.data.isInUseLimitedItem
				;(nil).isLimitedItem = self.data.isLimitedItem
				;(nil).pandoraIndex = self.data.pandoraIndex
				include("itemLogic").useItemsLine(self.itemID, self.data.count, nil)
			end
		end)
	else
		BAG_TYPE = nil
		;(nil).isInUseLimitedItem = self.data.isInUseLimitedItem
		;(nil).isLimitedItem = self.data.isLimitedItem
		;(nil).pandoraIndex = self.data.pandoraIndex
		include("itemLogic").useItemsLine(self.itemID, self.data.count, nil)
	end
end
function itemSingleInfo:onBtnComposeClick()
	SoraDPlaySound()
	if backpackCtrl:isItemLock(self.itemID) then
		SoraDShowMsgTip(i18n("Safety_lock_text_36"))
		return
	end
	_ENV = i18n("Safety_lock_text_36")
	i18n("Safety_lock_text_36").itemID = self.itemID
	uiManager:show("ItemComposeView", i18n("Safety_lock_text_36"))
end
function itemSingleInfo:onBtnSearchClick()
	SoraDPlaySound()
	if self.searchPanel then
		if self.searchPanel == "CommonItemShowBox" then
			_ENV = nil
			;(nil).itemID = self.itemID
			uiManager:show(self.searchPanel, nil)
		elseif self.searchPanel == "HeroDressPreview" then
			_ENV = nil
			;(nil).itemID = self.itemID
			uiManager:show(self.searchPanel, nil)
		elseif self.searchPanel == "commonDressPreview" then
			_ENV = nil
			;(nil).itemID = self.itemID
			uiManager:show(self.searchPanel, nil)
		else
			local panel = SoraDCreatePanel(self.searchPanel)
			panel:initData(self.itemID)
			panel:show()
		end
	end
end
function itemSingleInfo:initWarGemData(data)
	self.data = data
	self.itemID = self.data.id
	local wargemResRead = include("wargemResRead")
	local warGemltCtrl = include("warGemltCtrl")
	local isEnchantedItem = warGemltCtrl:isEnchantedItem(self.itemID)
	if isEnchantedItem then
		self.fields.Button_use:setVisible(false)
		self.fields.Text_des:setSize(cc.size(570, 120))
		self.fields.Text_des:setString(wargemResRead.getDes(self.itemID))
	else
		self.fields.Button_use:setVisible(true)
		self.fields.Button_use:setTitleText(i18n("common_text_1352"))
		self.fields.Text_des:setSize(cc.size(420, 120))
		self.fields.Text_des:setString(wargemResRead.getAttrByID(self.itemID))
	end
	self.fields.Text_title:setString(wargemResRead.getName(self.itemID))
end
function itemSingleInfo:initHeroChipData(data)
	self.data = data
	self.itemID = self.data.id
	local publicRead = include("publicRead")
	self.fields.Text_title:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	self.fields.Button_use:setVisible(true)
	self.fields.Button_use:setTitleText(i18n("Hero_reshape_7"))
end
function itemSingleInfo:onBtnUseGemClick(...)
	SoraDPlaySound()
	local wargemltCtrl = include("warGemltCtrl")
	local toMid = wargemltCtrl:getGemMaterialIDAfterMerge(self.itemID)
	if 0 ~= toMid then
		_ENV = nil
		;(nil).gemID = self.itemID
		uiManager:show("WarGemCompose", nil)
	else
		SoraDShowMsgTip(i18n("common_text_3900"))
	end
end
function itemSingleInfo:onBtnUseHeroChipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	;(nil).mode = 1
	uiManager:show("HeroChipExchange", nil)
end
function itemSingleInfo:initWarframeData()
	local itemDesRead = include("publicRead")
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armyNum = armorSystemCtrl:getArmyNumByArmorId(self.itemID)
	self:closeTimer()
	self.fields.Text_time:setVisible(false)
	self.fields.Button_use:setTitleText(i18n("Soldiers_armor_text_26"))
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local cfg = armorSystemRead:getArmorRefSoldierInfo(tonumber(self.itemID))
	if cfg.newLv == 14 then
		_ENV = tonumber(self.itemID)
		tonumber(self.itemID).isArmorID = true
		tonumber(self.itemID).armorID = tonumber(self.itemID)
		self.fields.Button_use:setVisible(SoraDIsGildedArmorOpen(tonumber(self.itemID)) and commonCheck.GILT_ARMOR_WEAR and 0 < armyNum)
	else
		_ENV = tonumber(self.itemID)
		tonumber(self.itemID).isArmorID = true
		tonumber(self.itemID).armorID = tonumber(self.itemID)
		self.fields.Button_use:setVisible(SoraDIsBrave8Level(tonumber(self.itemID)) and commonCheck.WARFRAME_WEAR and 0 < armyNum)
	end
	self.fields.Text_des:setString(itemDesRead.getDes(self.itemID))
	self.fields.Text_title:setString(itemDesRead.getName(self.itemID))
end
function itemSingleInfo:onBtnUseWarFrameClick()
	SoraDPlaySound()
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local armyLogic = include("armyLogic")
	local barrackID = armorSystemRead:getProperty(tonumber(self.itemID), "barrackID")
	local trainList = armyLogic.getCanTrainList(barrackID)
	local _ENV, armyData = barrackID, barrackID
	armyData.armyid = trainList[12].armyid
	_ENV = nil
	;(nil).armyData = armyData
	;(nil).armorId = tonumber(self.itemID)
	uiManager:show("soldiersPromoteDetailView", nil)
end
function itemSingleInfo:initData_manorFarmFruit(data)
	self.fields.Button_search:setVisible(false)
	self.fields.Button_use:setVisible(false)
	self.fields.Button_compose:setVisible(false)
	self.fields.lock:setVisible(false)
	self.fields.Text_time:setVisible(false)
	self.fields.Text_title:setString(i18n(data.fruitData.name))
	self.fields.Text_des:setString(i18n(data.fruitData.des))
end
return itemSingleInfo

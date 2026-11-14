local armyDes = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_warframeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/Com_warframeSingle", Com_warframeSingle)
_ENV = fgui.register_extension
fgui.register_extension.normal = 1
fgui.register_extension.forging = 2
local fgui.register_extension.canUp, itemStatus = 3, fgui.register_extension
function Com_warframeSingle:onInit()
	self.status = itemStatus.normal
	self.queueType = gQueueTypeDef.armor_forging
	self.textTime = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.textTime:setTimeEndListener(function(...)
		self:updateStatus()
	end)
	self.textTime:setTimeLast(function(time)
		return string.format("%s %s", i18n("suit_btn_text_03"), time)
	end)
	self.fields.Button_OpenDetail:addClickListener(handler(self, self.btnOpenDetailClick))
	self.fields.Node_Up:getTransition("t0"):play(-1, 0, 0, -1)
	self.fields.Node_Up:setRotation(SoraDFIsRA() and 90 or -90)
	self.fields.icon_promote:setVisible(false)
end
function Com_warframeSingle:onShow()
end
function Com_warframeSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateTimeLabel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.showNewForTime))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_NOTIFY", handler(self, self.showNewForTime))
end
function Com_warframeSingle:initData(armorId)
	self.armorId = armorId
	self.fields.Label_Name:setString(i18n(armorSystemRead:getProperty(self.armorId, "name")))
	self.fields.Image_Warframe:setURL(armorSystemRead:getProperty(self.armorId, "herIcon"))
	self.fields.Label_Name:setIcon(armorSystemRead:getProperty(self.armorId, "armyIcon"))
	print("armorSystemCtrl:getArmyIdByArmorId(self.armorId),", armorSystemCtrl:getArmyIdByArmorIdEx(self.armorId))
	self.fields.Lable_OwnSolider:setIcon(armyDes.getIcon(armorSystemCtrl:getArmyIdByArmorIdEx(self.armorId)))
	self:updateStatus()
end
function Com_warframeSingle:updateStatus()
	local havaNum = self:updateItemNum()
	local leftTime = self:getForgQueueTime(self.armorId)
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	armorSystemRead = self.armorId
	self.armorId.isArmorID = true
	self.armorId.armorID = self.armorId
	self.isUnlock = SoraDIsBrave8Level(self.armorId)
	self.fields.icon_promote:setVisible(false)
	if cfg.newLv == 14 then
		armorSystemRead = self.fields.icon_promote
		self.fields.icon_promote.isArmorID = true
		self.fields.icon_promote.armorID = self.armorId
		self.isUnlock = SoraDIsGildedArmorOpen(self.fields.icon_promote)
		local limitTechNum = technologyCtrl:getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
		local sourceArmyID = armorSystemCtrl:getArmyIdByArmorId(self.armorId, 13)
		local canPromoteCount = armyCtrl:getNormalArmyCount(sourceArmyID)
		local leftPNum = armorSystemCtrl:getMothyPromoteNum()
		self.fields.icon_promote:setVisible(self.isUnlock and 0 < limitTechNum and 0 < canPromoteCount and 0 < leftPNum and SoraDIsTWarframeOpen(self.armorId))
	end
	if leftTime then
		self.status = itemStatus.forging
		self.textTime:beginTime(leftTime)
	elseif havaNum and self.isUnlock and (cfg.newLv == 14 and commonCheck.GILT_ARMOR_WEAR or cfg.newLv == 13 and commonCheck.WARFRAME_WEAR) then
		self.status = itemStatus.canUp
	else
		self.status = itemStatus.normal
	end
	self:updateEffectShow()
	self:updateLock()
end
function Com_warframeSingle:updateEffectShow()
	self.fields.Node_Up:setVisible(self.status == itemStatus.canUp)
	self.fields.Particle_1:setVisible(self.status == itemStatus.forging)
	self.textTime:setVisible(self.status == itemStatus.forging)
end
function Com_warframeSingle:updateItemNum()
	local armorNum = armorSystemCtrl:getArmorNumByID(self.armorId)
	armorSystemCtrl = nil
	;(nil).num = string.formatnumberthousands(armorNum)
	self.fields.Text_OwnWarframe:setString(i18n("common_text_063", nil))
	local soldierNum = armorSystemCtrl:getArmyNumByArmorId(self.armorId)
	armorSystemCtrl = i18n("common_text_063", nil)
	i18n("common_text_063", nil).num = string.formatnumberthousands(soldierNum)
	self.fields.Lable_OwnSolider:setString(i18n("common_text_063", i18n("common_text_063", nil)))
	return 0 < armorNum and 0 < soldierNum
end
function Com_warframeSingle:getForgQueueTime(armorId)
	local forgQueue = queueCtrl:queryQueue(self.queueType)
	if forgQueue and tonumber(forgQueue.data.armorId) == armorId then
		return forgQueue.timerNode.timer:getRemainTime()
	end
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function Com_warframeSingle:updateLock()
	self.fields.Com_Lock:setVisible(not self.isUnlock)
	if not self.isUnlock then
		self.fields.Image_Warframe:setColor(colorGray)
	else
		self.fields.Image_Warframe:setColor(colorNormal)
	end
end
function Com_warframeSingle:showNewForTime(target, data)
	if data and data.armorId == self.armorId then
		self:updateStatus()
	end
end
function Com_warframeSingle:updateTimeLabel(target, data)
	if tonumber(data.qtype) == self.queueType and self.textTime:isVisible() then
		self:updateStatus()
	end
end
function Com_warframeSingle:btnOpenDetailClick()
	SoraDPlaySound()
	if self.isUnlock then
		_ENV = nil
		;(nil).armorId = self.armorId
		uiManager:show("WarframeForgDetail", nil)
	else
		SoraDShowMsgTip(i18n("Soldiers_armor_text_78"))
	end
end
return Com_warframeSingle

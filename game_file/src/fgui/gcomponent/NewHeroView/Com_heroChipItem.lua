local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroChipItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroChipItem", Com_heroChipItem)
function Com_heroChipItem:onInit()
	self:addClickListener(handler(self, self.onClick))
	self.fields.speedup:setAllFrameName("image_jiasusg_%.2d.png", 1)
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
end
function Com_heroChipItem:onShow()
end
function Com_heroChipItem:initData(heroID, isToOrange, buttonType, needNum, itemNum)
	self.heroID = heroID
	self.isToOrange = isToOrange
	self.buttonType = buttonType
	self.needNum = needNum
	self.itemNum = itemNum
	self.controllers.c1:setSelectedIndex(isToOrange and 1 or 0)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if isToOrange then
		local awakeSkillID = heroltCtrl:getAwakeSkill(self.heroID).skillID
		self.fields.Sprite_icon:setIcon(heroltCtrl.getSkillDesInfo(awakeSkillID).herIcon)
		local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
		local itemNum = backpackCtrl:getItemCount(awakeInfo.item)
		if itemNum < awakeInfo.itemCount then
			itemNum = fguiHelper.getColorString("#FF0000", itemNum)
			self.fields.Effect_arrow:setVisible(false)
		else
			itemNum = fguiHelper.getColorString("#FFEBB9", itemNum)
			self.fields.Effect_arrow:setVisible(self.buttonType <= gHeroButtonType.WAKING)
		end
		heroCtrl = nil
		;(nil).total = awakeInfo.itemCount
		;(nil).member = itemNum
		self.fields.Text_count:setString(i18n("common_text_155", nil))
		if self.heroInfo.isAwake then
			self.fields.Text_count:setVisible(false)
		else
			self.fields.Text_count:setVisible(true)
		end
	else
		self.fields.Sprite_icon:setIcon(heroltCtrl.getHeroChip(heroID))
		if itemNum < needNum then
			itemNum = fguiHelper.getColorString("#FF0000", itemNum)
			self.fields.Effect_arrow:setVisible(false)
		else
			itemNum = fguiHelper.getColorString("#FFEBB9", itemNum)
			self.fields.Effect_arrow:setVisible(true)
		end
		heroCtrl = heroltCtrl.getHeroChip(heroID)
		heroltCtrl.getHeroChip(heroID).total = needNum
		heroltCtrl.getHeroChip(heroID).member = itemNum
		self.fields.Text_count:setString(i18n("common_text_155", heroltCtrl.getHeroChip(heroID)))
		self.fields.Text_count:setVisible(true)
	end
end
function Com_heroChipItem:setChipIcon(png)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Text_count:setVisible(false)
	self.fields.Sprite_icon:setIcon(png)
end
function Com_heroChipItem:updateSpeedModel()
	local queue = heroCtrl:getUpgradeQueue(self.heroID)
	if queue then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Effect_arrow:setVisible(false)
		self.fields.Sprite_icon:setColor(cc.c3b(120, 120, 120))
		local curTime = queue.timerNode.timer:getRemainTime()
		local totalTime = queue.totaltime
		self.fields.Text_time:setTimeLast(function(showTime)
			if queue.data.upgradeType == gHeroSysUpType.AWAKE then
				queue = nil
				;(nil).time = showTime
				return i18n("hero_text_108", nil)
			else
				queue = nil
				;(nil).time = showTime
				return i18n("hero_text_40", nil)
			end
		end)
		self.fields.Text_time:beginTime(curTime)
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Text_time:endTime()
		self.fields.Sprite_icon:setColor(cc.c3b(255, 255, 255))
	end
end
function Com_heroChipItem:judgeIsCanFeedAndUpgrade()
	local ret = false
	if self.heroInfo and self.heroInfo.state ~= gHeroState.HERO_STATE_DEAD and self.heroInfo.state ~= gHeroState.HERO_STATE_CAPTURED then
		ret = true
	end
	return ret
end
function Com_heroChipItem:onClick()
	SoraDPlaySound("pyramid", 5)
	if self.heroInfo and not self:judgeIsCanFeedAndUpgrade() then
		SoraDShowMsgTip(i18n("hero_text_39"))
		return
	end
	local obj = heroCtrl:getUpgradeQueue()
	local ret = obj ~= self.heroID
	if self.buttonType == gHeroButtonType.NONE then
		print("无响应")
	elseif self.buttonType == gHeroButtonType.GAINCHIP then
		self.heroNextUpgradeInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality + 1)
		local itemID = self.heroNextUpgradeInfo.heroCard[1]
		local needNum = self.heroNextUpgradeInfo.heroCard[2]
		local itemNum = backpackCtrl:getItemCount(itemID)
		_ENV = i18n("hero_text_39")
		i18n("hero_text_39").itemID = itemID
		i18n("hero_text_39").needCount = needNum
		uiManager:show("newHeroGainChipMethodView", i18n("hero_text_39"))
	elseif self.buttonType == gHeroButtonType.GAINHERO then
		local panel = SoraDCreatePanel("heroPreviewView")
		panel:initData(self.heroID)
		panel:show()
	elseif self.buttonType == gHeroButtonType.UPGRADE then
		_ENV = self.heroID
		self.heroID.heroID = self.heroID
		uiManager:show("newHeroAwakePopChooseView", self.heroID)
	elseif self.buttonType == gHeroButtonType.SPEEDUP or self.buttonType == gHeroButtonType.WAKING then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.hero_upgrade)
		if queue then
			local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.GENERAL)
			if next(itemList) then
				SoraDShowSpeedUpByItemBox(gQueueTypeDef.hero_upgrade, nil, self.buttonType == gHeroButtonType.WAKING)
			else
				SoraDShowSpeedUpBox(queue)
			end
		end
	elseif self.buttonType == gHeroButtonType.LIMITLV or self.buttonType == gHeroButtonType.LIMITCHIP or self.buttonType == gHeroButtonType.WAKED or self.buttonType == gHeroButtonType.MAXLV then
		_ENV = queue
		queue.heroID = self.heroID
		uiManager:show("newHeroMasteryPopView", queue)
	elseif self.buttonType == gHeroButtonType.WAKEUP then
		_ENV = queue
		queue.heroID = self.heroID
		queue.upgradeType = gHeroSysUpType.AWAKE
		uiManager:show("newHeroAwakePopChooseView", queue)
	end
end
return Com_heroChipItem

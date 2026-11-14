local manorTechRead = include("manorTechRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local techSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorTech/techSingle", techSingle)
function techSingle:onInit()
	self.techType = "manor"
	self.queueType = gQueueTypeDef.garden_technology
	self:setEffectShow(false)
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function techSingle:onShow()
end
function techSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateView))
end
function techSingle:init(technologyID)
	self.techID = technologyID
	local cfg = manorTechRead.getTechShowCfg(technologyID)
	self.fields.Image_icon:setURL(cfg.techIcon)
	self.fields.Image_techBg:setURL(cfg.techBase)
	self.fields.Text_name:setString(i18n(cfg.techName))
end
function techSingle:initData()
	self:updateView()
end
function techSingle:initShow(technologyID, showLv)
	self:init(technologyID)
	local tData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	self.controllers.c3:setSelectedIndex(tData.isOpened and 1 or 0)
	if showLv then
		technologyCtrl = nil
		;(nil).lv1 = tData.currentLevel
		;(nil).lv2 = tData.maxLevel
		self.fields.Text_lv:setString(i18n("garden_text_13", nil))
		self.fields.Text_lv:setColor(tData.currentLevel >= tData.maxLevel and cc.c3b(112, 199, 35) or cc.c3b(240, 230, 210))
	end
end
function techSingle:getTechID()
	return self.techID
end
function techSingle:setEffectShow(ret)
	self.fields.studying:setVisible(ret)
end
function techSingle:updateView()
	self.tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	self.tableSingleDetails = technologyCtrl:getTechnologyDetails(self.techID, self.tableSingleData and self.tableSingleData.currentLevel or 0)
	technologyCtrl = nil
	;(nil).lv1 = self.tableSingleData.currentLevel
	;(nil).lv2 = self.tableSingleData.maxLevel
	self.fields.Text_lv:setString(i18n("garden_text_13", nil))
	if self.tableSingleData.isOpened then
		self.controllers.c3:setSelectedIndex(1)
		self:updateOtherUI()
	else
		self.controllers.c3:setSelectedIndex(0)
		self:setEffectShow(false)
	end
end
function techSingle:updateOtherUI()
	local labelColor = cc.c3b(240, 230, 210)
	self.controllers.c2:setSelectedIndex(0)
	self:setEffectShow(false)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		labelColor = cc.c3b(112, 199, 35)
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		local queue = queueCtrl:queryQueue(self.queueType)
		if queue and self.controllers.c1:getSelectedIndex() == 0 then
			self.controllers.c2:setSelectedIndex(1)
			self:setEffectShow(true)
			local leftTime = queue.timerNode.timer:getRemainTime()
			self.fields.lab_timer:beginTime(leftTime)
		end
	elseif not self:canStudy() then
		labelColor = cc.c3b(190, 40, 40)
	end
	if not next(self.tableSingleDetails.upgradeIngTechnology) then
		self.controllers.c2:setSelectedIndex(0)
	end
	self.fields.Text_name:setColor(labelColor)
	self.fields.Text_lv:setColor(labelColor)
end
function techSingle:canStudy()
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented then
				return false
			end
		end
	end
	if self.tableSingleDetails.resources then
		for i, v in ipairs(self.tableSingleDetails.resources) do
			if not v.isContentmented then
				return false
			end
		end
	end
	return true
end
function techSingle:btnClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("ManorTechDetail", nil)
end
return techSingle

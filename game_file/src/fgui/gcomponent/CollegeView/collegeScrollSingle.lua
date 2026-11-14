local collegeDesRead = include("collegeDesRead")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local collegeScrollSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CollegeView/collegeScrollSingle", collegeScrollSingle)
function collegeScrollSingle:onInit()
	self:setEffectShow(false)
	self:addClickListener(handler(self, self.btnClickCallBack))
end
function collegeScrollSingle:onShow()
end
function collegeScrollSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_JUMPTO_TID_EFFECT", handler(self, self.addHightlight))
end
function collegeScrollSingle:initData(techID, techType, queueType)
	self.techID = techID
	self.techType = techType or collegeDesRead.getType(self.techID)
	self.queueType = queueType or gQueueTypeDef.technology_upgrade_queue
	self:updateView()
end
function collegeScrollSingle:getTechID()
	return self.techID
end
function collegeScrollSingle:setEffectShow(ret)
	self.fields.studying:setVisible(ret)
end
function collegeScrollSingle:updateView()
	if self.techID and self.techType then
		self.tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
		self.tableSingleDetails = technologyCtrl:getTechnologyDetails(self.techID, self.tableSingleData.currentLevel)
		self.fields.Image_techBg:setSpriteFrame(collegeDesRead.getBg(self.techID))
		self.fields.Image_icon:setSpriteFrame(collegeDesRead.getIcon(self.techID))
		self.fields.Text_name:setString(collegeDesRead.getName(self.techID))
		self.fields.Text_lv:setString(tostring(self.tableSingleData.currentLevel) .. "/" .. tostring(self.tableSingleData.maxLevel))
		if self.tableSingleData.isOpened then
			self:updateOtherUI()
			self.controllers.c3:setSelectedIndex(1)
		else
			self:setEffectShow(false)
			self.controllers.c3:setSelectedIndex(0)
		end
	end
end
function collegeScrollSingle:updateOtherUI()
	local labelColor = cc.c3b(240, 230, 210)
	self.controllers.c2:setSelectedIndex(0)
	self:setEffectShow(false)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		labelColor = display.COLOR_GREEN
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		local queue = queueCtrl:queryQueue(self.queueType)
		if queue and self.controllers.c1:getSelectedIndex() == 0 then
			self.controllers.c2:setSelectedIndex(1)
			self:setEffectShow(true)
			local leftTime = queue.timerNode.timer:getRemainTime()
			self.fields.lab_timer:beginTime(leftTime)
		end
	elseif not self:canStudy() then
		labelColor = display.COLOR_RED
	end
	if not next(self.tableSingleDetails.upgradeIngTechnology) then
		self.controllers.c2:setSelectedIndex(0)
	end
	self.fields.Text_name:setColor(labelColor)
	self.fields.Text_lv:setColor(labelColor)
end
function collegeScrollSingle:canStudy()
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented and v.bid ~= BUILDID.NEBULA_PALACE then
				return false
			end
		end
	end
	if self.tableSingleDetails.resources then
		for i, v in ipairs(self.tableSingleDetails.resources) do
			if not v.isContentmented and not v.isLuckyContentmented then
				return false
			end
		end
	end
	return true
end
function collegeScrollSingle:btnClickCallBack()
	SoraDPlaySound()
	if waitQueueCtrl:checkIsWaiting(self.queueType, self.techID) then
		_ENV = self.techID
		self.techID.techID = self.techID
		uiManager:show("collegeWaitCancelView", self.techID)
	else
		_ENV = self.techID
		self.techID.techID = self.techID
		self.techID.techType = self.techType
		self.techID.queueType = self.queueType
		uiManager:show("collegeDetailsView", self.techID)
	end
end
function collegeScrollSingle:addHightlight(target, data)
	if data.tid == tonumber(self.techID) then
	end
end
return collegeScrollSingle

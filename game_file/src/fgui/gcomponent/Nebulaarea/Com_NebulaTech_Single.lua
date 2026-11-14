local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTech_Single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTech_Single", Com_NebulaTech_Single)
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local collegeDesRead = include("collegeDesRead")
local technologyLocalData = include("technologyLocalData")
function Com_NebulaTech_Single:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.tid = 0
	self.tableSingleDetails, _ENV, self.tableSingleData, _ENV, self.type = self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos, nil
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.time)
	self.fields.bgBtn:addClickEventListener(handler(self, self.onClick))
end
function Com_NebulaTech_Single:onShow()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
end
function Com_NebulaTech_Single:initData(tid, isLock)
	self.tid = tid
	if tid == 0 then
		self:setVisible(false)
		return
	end
	self:setVisible(true)
	self.isLock = isLock
	self.fields.lock:setVisible(isLock)
	self.type = "nebula"
	self:updateView()
end
function Com_NebulaTech_Single:updateView()
	self.fields.time:setVisible(false)
	if self.tid and self.tid ~= 0 and self.type then
		self.tableSingleData = technologyCtrl:getTechnoDataByID(self.tid, self.type)
		if self.tableSingleData ~= nil then
			self.tableSingleDetails = technologyCtrl:getTechnologyDetails(self.tid, self.tableSingleData.currentLevel)
			self.lineTableSingleDetails = self.tableSingleDetails
			if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
				self.lineTableSingleDetails = technologyCtrl:getTechnologyDetails(self.tid, self.tableSingleData.currentLevel - 1)
			end
			self.fields.level:setString(tostring(self.tableSingleData.currentLevel) .. "/" .. tostring(self.tableSingleData.maxLevel))
			self.fields.icon:setURL(collegeDesRead.getIcon(self.tid))
			self.fields.bg:setURL(SoraDCheckPNG(collegeDesRead.getBg(self.tid), "frame_round_tech_01.png"))
			self.fields.name:setString(collegeDesRead.getName(self.tid))
			self.controllers.c1:setSelectedIndex(self.isLock and 1 or 0)
			self.fields.level:setVisible(not self.isLock)
			self.Text_time:setVisible(false)
			self.fields.time_bg:setVisible(false)
		else
			local debugStr = "Com_NebulaTech_Single:updateView tid error:" .. self.tid
			_G.sendTraceBackLog(debugStr, nil, nil, true)
		end
		if not self.isLock then
			self:updateOtherUI()
		end
		self:updateLine()
	end
end
function Com_NebulaTech_Single:updateLine()
	self.fields.top_line:setVisible(false)
	self.fields.right_line:setVisible(false)
	if technologyLocalData.getNebulaTechShowPreTech(self.tid) == 0 then
		return
	end
	local top_line_y = fguiHelper.get_fields(self.fields.top_line).bar
	local right_line_y = fguiHelper.get_fields(self.fields.right_line).bar
	if self.lineTableSingleDetails and self.lineTableSingleDetails.tech then
		local myLv = self:getTechUnlockLv(self.tid)
		for k, v in pairs(self.lineTableSingleDetails.tech) do
			local techLv = self:getTechUnlockLv(v.tid)
			if myLv > techLv then
				local lvMin = myLv - techLv
				self.fields.top_line:setPositionY(-(221 * lvMin))
				self.fields.top_line:setSize(cc.size(5, 221 * lvMin))
				self.fields.top_line:setVisible(true)
				if not top_line_y:isVisible() and v.isContentmented then
					top_line_y:setScaleY(0)
					top_line_y:setScaleX(1)
					top_line_y:runAction(ffa.scaleTo(0.5, 1, 1))
				end
				top_line_y:setVisible(v.isContentmented)
			else
				self.fields.right_line:setVisible(true)
				if not top_line_y:isVisible() and v.isContentmented then
					right_line_y:setScaleY(1)
					right_line_y:setScaleX(0)
					right_line_y:runAction(ffa.scaleTo(0.5, 1, 1))
				end
				right_line_y:setVisible(v.isContentmented)
			end
		end
	end
end
function Com_NebulaTech_Single:getTechUnlockLv(tid)
	return technologyLocalData.getNebulaTechUnlockLv(tid)
end
function Com_NebulaTech_Single:updateOtherUI()
	local labelColor = cc.c3b(218, 184, 91)
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_2:setVisible(false)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		labelColor = display.COLOR_GREEN
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		local queue = queueCtrl:queryQueue(gQueueTypeDef.nebula_palace_technology)
		if queue then
			local leftTime = queue.timerNode.timer:getRemainTime()
			self.Text_time:setVisible(true)
			self.fields.time_bg:setVisible(true)
			self.Text_time:beginTime(leftTime)
			self:showParticle()
		end
	elseif not self:canStudy() then
		labelColor = display.COLOR_RED
	end
	self.fields.name:setColor(labelColor)
	self.fields.level:setColor(labelColor)
end
function Com_NebulaTech_Single:showParticle()
	self.fields.Particle_1:setVisible(true)
	for k, v in pairs(self.fields.Particle_1:getChildren()) do
		v:resetSystem()
	end
	self.fields.Particle_2:setVisible(true)
end
function Com_NebulaTech_Single:canStudy()
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented then
				self.fields.lock:setVisible(true)
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
	self.fields.lock:setVisible(false)
	return true
end
function Com_NebulaTech_Single:onClick()
	SoraDPlaySound()
	if waitQueueCtrl:checkIsWaiting(gQueueTypeDef.nebula_palace_technology, self.tid) then
		_ENV = self.tid
		self.tid.techID = self.tid
		uiManager:show("collegeWaitCancelView", self.tid)
	else
		_ENV = self.tid
		self.tid.techID = self.tid
		self.tid.techType = self.type
		self.tid.queueType = gQueueTypeDef.nebula_palace_technology
		uiManager:show("collegeDetailsView", self.tid)
	end
end
return Com_NebulaTech_Single

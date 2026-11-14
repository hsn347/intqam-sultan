local baseComponent = require("fgui.base.baseComponent")
local spoilTroopsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
fgui.register_extension("ui://MainUI/spoilTroopsSingle", spoilTroopsSingle)
function spoilTroopsSingle:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(handler(self, self.updateTroopBar))
	self.Text_time:setTimeEndListener(handler(self, self.updateTimeEnd))
	self.fields.Button_jump:addClickListener(handler(self, self.OnBtnJumpClick))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.Bar_et:setScaleX(SoraDFIsRA() and 1 or -1)
end
function spoilTroopsSingle:registerEvent()
end
function spoilTroopsSingle:onMsgUpdateShowCollected(target, data)
end
function spoilTroopsSingle:onHide()
	if self.showingData and self.showingData.reward and next(self.showingData.reward) then
		SoraDMailGainItems(self.showingData.reward, true)
	end
	self.showingData = nil
end
function spoilTroopsSingle:initData(queueData, _list)
	self.queueData = queueData
	self.parentUI = _list
	self.controllers.c1:setSelectedIndex(0)
	self:updateData()
end
function spoilTroopsSingle:updateData()
	self.fields.Bar_et:setIconIndex(0)
	if self.queueData ~= nil then
		if self.queueData.isGoback then
			self.fields.Text_state:setString(i18n("NebulaAllstar_205"))
			self:showQueue(true)
		else
			self.fields.Text_state:setString(i18n("NewYear_Gift_02"))
			self:showQueue(true)
		end
	else
		self.fields.Text_state:setString(i18n("NebulaAllstar_206"))
		self:showQueue(false)
	end
end
function spoilTroopsSingle:showQueue(isShow)
	if isShow then
		local totalTime = self.queueData.totalTime
		local time_remain = self.queueData.statusStartTime + totalTime - serviceFunctions.systemTime()
		self.Text_time:beginTime(time_remain)
		self.totalTime = totalTime
		self:updateTroopBar(time_remain)
		if time_remain == 0 then
			self:updateTimeEnd()
		end
	else
		self.Text_time:endTime()
	end
	self.Text_time:setVisible(isShow)
	self.fields.Text_state:setPositionY(isShow and 10 or 20)
	self.fields.Bar_et:setVisible(isShow)
end
function spoilTroopsSingle:updateTroopBar(times)
	local totalTime = self.totalTime or 1
	local percent = (totalTime - times) / totalTime
	self.fields.Bar_et:setPercent(percent)
end
function spoilTroopsSingle:updateTimeEnd(...)
	if self.queueData and not self.queueData.isGoback then
		self.fields.Text_state:setString(i18n("NebulaAllstar_375"))
	end
end
function spoilTroopsSingle:OnBtnJumpClick()
	if self.queueData == nil then
		return
	end
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(self.queueData.to.x, self.queueData.to.y), true)
end
return spoilTroopsSingle

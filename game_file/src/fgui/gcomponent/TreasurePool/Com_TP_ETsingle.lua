local baseComponent = require("fgui.base.baseComponent")
local Com_TP_ETsingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TreasurePool/Com_TP_ETsingle", Com_TP_ETsingle)
local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
local endlessTreasureRead = include("endlessTreasureRead")
function Com_TP_ETsingle:onInit()
	self.data, _ENV = nil, nil
	self.status = gEndlessTreasureStatus.NONE
	self.fields.Text_none:setString(i18n("endless_treasures_text_45"))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self:addClickEventListener(handler(self, self.btnTouchClick))
	self.Node_js = self.fields.Node_js
	self.Node_js:setVisible(false)
	self.Node_lq_bg = self.fields.Node_lq_bg
	self.Node_lq_bg:setVisible(false)
	self.Node_lq = self.fields.Node_lq
end
function Com_TP_ETsingle:onShow()
end
function Com_TP_ETsingle:showDiggingQueue()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if queue then
		self.Text_time:beginTime(queue.timerNode.timer:getRemainTime())
		self.Text_time:setTimeEndListener(function()
			local data = endlessTreasureCtrl:getTreasureInfoByIndex(self.index)
			self:initData(self.index, data)
		end)
	end
end
function Com_TP_ETsingle:showDark()
	self.fields.Text_name:setColor(cc.c3b(200, 200, 200))
	self.fields.Image_bg:setColor(cc.c3b(200, 200, 200))
	self.fields.Image_box:setColor(cc.c3b(200, 200, 200))
end
function Com_TP_ETsingle:showNoraml()
	self.fields.Text_name:setColor(cc.c3b(255, 255, 255))
	self.fields.Image_bg:setColor(cc.c3b(255, 255, 255))
	self.fields.Image_box:setColor(cc.c3b(255, 255, 255))
end
function Com_TP_ETsingle:initData(index, data)
	self.data = data
	self.index = index
	self.Node_js:setVisible(false)
	self.Node_lq_bg:setVisible(false)
	if not next(self.data) then
		self.status = gEndlessTreasureStatus.NONE
		self.fields.Text_name:setString(i18n("endless_treasures_text_05") .. self.index)
	else
		self.status = endlessTreasureCtrl:getTreasureStatus(self.index)
		self.fields.Image_box:setURL(endlessTreasureRead.getTreasureIcon(self.data.tID))
		self.fields.Text_name:setString(endlessTreasureRead.getTreasureName(self.data.tID))
	end
	if self.status == gEndlessTreasureStatus.NONE then
		self.controllers.c1:setSelectedIndex(0)
	elseif self.status ~= gEndlessTreasureStatus.REWARD then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(2)
	end
	self:showNoraml()
	if self.status == gEndlessTreasureStatus.NONE then
		self:showDark()
	elseif self.status == gEndlessTreasureStatus.READY then
		local isUnableQueue = endlessTreasureCtrl:isUnableQueue(self.index)
		if not isUnableQueue then
			self.fields.Text_status:setString(i18n("endless_treasures_text_26"))
			self.fields.Text_status:setColor(cc.c3b(240, 230, 210))
		else
			self.fields.Text_status:setString(i18n("endless_treasures_text_29"))
			self.fields.Text_status:setColor(cc.c3b(255, 51, 51))
			self:showDark()
		end
		local time = endlessTreasureRead.getTreasureTime(self.data.tID)
		self.Text_time:removeTime()
		self.Text_time:setString(SoraDConvertSecondToString(time))
	elseif self.status == gEndlessTreasureStatus.DIG then
		self.fields.Text_status:setString(i18n("endless_treasures_text_07"))
		self.fields.Text_status:setColor(cc.c3b(255, 204, 55))
		self:showDiggingQueue()
		self.Node_js:setVisible(true)
	elseif self.status == gEndlessTreasureStatus.QUEUE then
		self.fields.Text_status:setString(i18n("endless_treasures_text_14"))
		self.fields.Text_status:setColor(cc.c3b(240, 230, 210))
		self:showDiggingQueue()
		self:showDark()
	elseif self.status == gEndlessTreasureStatus.REWARD then
		self.fields.Text_status:setString(i18n("endless_treasures_text_37"))
		self.fields.Text_status:setColor(cc.c3b(51, 255, 102))
		self.Node_lq_bg:setVisible(true)
	end
end
function Com_TP_ETsingle:btnTouchClick()
	SoraDPlaySound()
	if self.status == gEndlessTreasureStatus.NONE then
		SoraDShowMsgBox(i18n("endless_treasures_text_06"), i18n("common_text_477"), nil, function(backType)
			if backType == MSGBOX_CALLBACK_YES then
				SoraDRemoveAllPanelFromManager()
				uiManager:show("TreasureHuntView")
			end
		end)
	else
		local panel = uiManager:show("EndlessTreasureDigView")
		panel:initData(self.index, self.status, self.data)
	end
end
return Com_TP_ETsingle

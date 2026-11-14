local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_promoteQueue = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://troopFlagView/Com_promoteQueue", Com_promoteQueue)
function Com_promoteQueue:onInit()
	self.fields.Text_promote:setString(i18n("arms_promotion_title_01"))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.updateTime))
	self.fields.Button_delete:addClickListener(handler(self, self.btnDeleteClick))
	self.fields.Btn_speed:setString(i18n("arms_promotion_btn_02"))
	self.fields.Btn_speed:addClickListener(handler(self, self.btnSpeedClick))
	self:fixChildrenPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_promoteQueue:onShow()
end
function Com_promoteQueue:initData(queue)
	self.promoteQueue = queue
	local armyID = queue.data.toArmyID
	local armyNum = queue.data.count
	self.fields.army:initData(armyID)
	self.fields.Text_army:setString(armyDesRead.getName(armyID) .. ":" .. string.formatnumberthousands(armyNum))
	self.totaltime = queue.ottime or queue.totaltime
	self.fields.Bar:setMax(self.totaltime)
	local leftTime = queue.timerNode.timer:getRemainTime()
	self.fields.Text_time:beginTime(leftTime)
	self.itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.TRAIN_TROOP)
	if next(self.itemList) then
		self.fields.Btn_speed:setString(i18n("common_text_018"))
	else
		self.fields.Btn_speed:setString(i18n("arms_promotion_btn_02"))
	end
end
function Com_promoteQueue:updateTime(time)
	self.fields.Bar:setValue(self.totaltime - time)
end
function Com_promoteQueue:btnSpeedClick()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	if next(self.itemList) then
		SoraDShowSpeedUpByItemBox(gQueueTypeDef.prompt_army)
	else
		SoraDShowSpeedUpBox(self.promoteQueue, function(type)
			if type == MSGBOX_CALLBACK_SPEEDUP then
				queueCtrl:speedUpQueueReq(gQueueTypeDef.prompt_army, SPEEDUP_TYPE.GOLD)
			end
		end, i18n("common_text_765"))
	end
end
function Com_promoteQueue:btnDeleteClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("arms_promotion_text_01"), i18n("common_text_204"), i18n("common_text_185"), function(event)
		if event == MSGBOX_CALLBACK_YES then
			queueCtrl:cancelQueueReq(gQueueTypeDef.prompt_army)
		end
	end)
end
return Com_promoteQueue

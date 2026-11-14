local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local treasureCrystalRead = include("treasureCrystalRead")
local treasureCrystalCtrl = gametop.playertop_:getModule("treasureCrystalCtrl")
local itemDesRead = include("itemDesRead")
local treasureCrystalView = class("treasureCrystalView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureCrystalView")
	end
	return target
end)
local REFRESHTIME = 15
function _ENV(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureCrystalView")
	end
	return target
end
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureCrystalView")
	end
	return target
end).NOTBIND = 1
local (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureCrystalView")
	end
	return target
end).BINDTASK, ItemStatus = 2, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureCrystalView")
	end
	return target
end
local MAXTASK = 5
function treasureCrystalView:ctor()
	self.taskTable, _ENV = nil, nil
	self.titleName = SoraDGetChildByName(self, "Text_name")
	self.taskName = SoraDGetChildByName(self, "Text_TaskName")
	self.taskExplain = SoraDGetChildByName(self, "Text_TaskExplain")
	self.textTaskInfo = SoraDGetChildByName(self, "Text_Task")
	self.textTaskInfo = SoraDChangeTextToHtml(self.textTaskInfo)
	self.textWaring = SoraDGetChildByName(self, "Text_Warning")
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
	self.textTime = SoraDGetChildByName(self, "Text_LeftTime")
	self.imageLast = SoraDGetChildByName(self, "Image_LastInfo")
	self.nodeCenterTask = SoraDGetChildByName(self, "Node_TaskSchedule")
	self.crysatlIcon = SoraDGetChildByName(self.nodeCenterTask, "Image_Crystal")
	self.textTip:setFontSize(16)
	SoraDSetTextWidthHeight(self.textTip, cc.size(512, 21))
	self.boxIcon = SoraDGetChildByName(self.nodeCenterTask, "Image_Box")
	self.taskSingle = SoraDGetChildByName(self.nodeCenterTask, "Node_TaskSingle")
	self.taskSingle:setVisible(false)
	SoraDGetChildByName(self, "Text_LastTask"):setString(i18n("treasure_crystal_text_32"))
	self.btnOpenAndBind = SoraDGetChildByName(self, "Button_Open")
	self.btnOpenAndBind:addTouchEventListener(handler(self, self.btnClickOpen))
	self.btnOpenAndBind:setPositionX(271)
	self.btnRefresh = SoraDGetChildByName(self, "Button_Refresh")
	self.btnRefresh:addTouchEventListener(handler(self, self.btnClickRefresh))
	self.btnRefresh:setVisible(false)
	self.textRefreshTime = SoraDGetChildByName(self.btnRefresh, "Text_RefreshTime")
	self.textRefreshTime = SoraDCreateTimerLabel(self, self.textRefreshTime)
	self.textRefreshTime:setTimeEndListener(handlerEx(self, self.refreshTimeEnd, true))
	self.textRefreshTime:setTimeLast(function(ticket)
		return i18n("common_text_911") .. "\n" .. ticket
	end)
	self:refreshTimeEnd(false)
	self.boxIcon:setVisible(false)
	self.boxIcon:loadTexture("icon_crazy_score_rank_gold.png", ccui.TextureResType.plistType)
	self.imageLast:setVisible(false)
	self.titleName:setString(i18n("treasure_crystal_title_01"))
	self.taskExplain:setString(i18n("treasure_crystal_text_03"))
	self.textWaring:setString(i18n("treasure_crystal_text_12"))
	self.textTip:setString(i18n("treasure_crystal_text_04"))
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	self.textTime:setTimeEndListener(function()
		self:close(self, ccui.TouchEventType.ended)
	end)
	self.taskEffect = SoraDCreatAnimation("treasureTaskEffect", nil, true)
	SoraDMixtureGLONEByParent(self.taskEffect)
	self.taskEffect:addTo(self.nodeCenterTask)
	self.taskEffect:setLocalZOrder(10)
	local ret = _G.SoraDIsFileExistByKey("treasureCrystal")
	if ret then
		display.addSpriteFrames("Common/treasureCrystal.plist", getImageFileNameByPlatform("Common/treasureCrystal"))
	end
	self.crystalEffect = SoraDCreatAnimationEx("treasureCrystalShowEffect", nil, false)
	SoraDMixtureGLONEByParent(self.crystalEffect)
	SoraDMixtureGLONE(SoraDGetChildByName(self.crystalEffect, "G_dh_xunbaoshuij_01_3"))
	self.crystalEffect:setVisible(false)
	self.crystalEffect:setPosition(display.cx, display.cy)
	self.crystalEffect:addTo(self, 999)
	if not SoraDFIsRA() then
		print("======= Node_getGold:setScaleX")
		self.imageLast:setFlippedX(false)
		self.imageLast:getChildByName("icon"):setFlippedX(true)
	end
end
_ENV, treasureCrystalView.refreshTimeEnd = function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end, function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end
;(function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end)["1"] = "treasure_crystal_text_07"
;(function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end)["2"] = "treasure_crystal_text_08"
;(function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end)["3"] = "treasure_crystal_text_09"
;(function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end)["4"] = "treasure_crystal_text_10"
local (function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end)["5"], taskInfoStr = "treasure_crystal_text_11", function(self, control)
	self.btnRefresh:setBright(control)
	self.btnRefresh:setTitleText(control and i18n("alliance_mobilize_text_10") or "")
	self.textRefreshTime:setVisible(not control)
	self.btnRefresh:setTouchEnabled(control)
end
function treasureCrystalView:setItemData(itemID, otherData)
	dump(otherData, "otherData", 10)
	self.itemID = itemID
	self.crysatlIcon:loadTexture(itemDesRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.itemStatus = otherData.dataFromItem.isInUseLimitedItem and ItemStatus.BINDTASK or ItemStatus.NOTBIND
	self.itemLimitedTime = otherData.dataFromItem.isInUseLimitedItem or otherData.dataFromItem.isLimitedItem
	local crystalData = treasureCrystalRead.getCrystalConfig(self.itemID)
	self.taskStage = crystalData.lv
	self.itemQuality = crystalData.quality
	self.textTip:setString(i18n(self.itemQuality == 1 and "treasure_crystal_text_04" or "treasure_crystal_text_05"))
	_ENV = i18n(self.itemQuality == 1 and "treasure_crystal_text_04" or "treasure_crystal_text_05")
	i18n(self.itemQuality == 1 and "treasure_crystal_text_04" or "treasure_crystal_text_05").stage = self.taskStage
	self.taskName:setString(i18n("treasure_crystal_text_02", i18n(self.itemQuality == 1 and "treasure_crystal_text_04" or "treasure_crystal_text_05")))
	self.taskInfo = treasureCrystalCtrl:getTaskInfo(self.itemID, self.itemLimitedTime)
	SoraDGetChildByName(self, "Right_Pandect"):setPositionX(self.taskName:getPositionX() + 80 + self.taskName:getContentSize().width / 2)
	SoraDGetChildByName(self, "Left_Pandect"):setPositionX(self.taskName:getPositionX() - 80 - self.taskName:getContentSize().width / 2)
	self:judgeClose()
	self:refreshData()
	self:initTaskStage()
end
function treasureCrystalView:initTaskStage()
	local offsetX = SoraDFIsRA() and 60 or -60
	local beginPosX = math.floor(self.taskStage / 2) * offsetX
	self.crysatlIcon:setPositionX(beginPosX + offsetX / 2 + (SoraDFIsRA() and 48 or 0))
	local posY = self.taskSingle:getPositionY()
	for i = 1, self.taskStage + 1 do
		if i == MAXTASK + 1 then
			self.boxIcon:setVisible(true)
			self.boxIcon:setPositionX(beginPosX - (i - 1) * offsetX)
			local boxEffect = SoraDCreatAnimation("treasureBoxEffect", nil, true)
			SoraDMixtureGLONEByParent(boxEffect)
			boxEffect:setPosition(self.boxIcon:getPositionX(), self.boxIcon:getPositionY())
			boxEffect:addTo(self.nodeCenterTask)
			self.imageLast:setVisible(true)
			self.imageLast:setGlobalZOrder(2)
			self.imageLast:setScale(3)
			_ENV = self.boxIcon:getPositionY()
			self.boxIcon:getPositionY()[1] = cca.scaleTo(0.1, 1)
			self.boxIcon:getPositionY()[2] = cca.scaleTo(0.1, 1)
			self.boxIcon:getPositionY()[3] = cca.scaleTo(0.1, 1)
			self.imageLast:runAction(cca.seq(self.boxIcon:getPositionY()))
			SoraDGetChildByName(self.taskTable[i - 1], "progressbar_main"):setVisible(false)
			return
		end
		print("···", i, self.taskStage)
		local single = self.taskSingle:clone()
		single:addTo(self.nodeCenterTask)
		single:setPosition(beginPosX - (i - 1) * offsetX, posY)
		single:setVisible(true)
		SoraDGetChildByName(single, "progressbar_main"):setPositionX(SoraDFIsRA() and -35 or 35)
		local imageTaskStatus = SoraDGetChildByName(single, "Task_Status")
		if i == self.taskStage + 1 then
			SoraDGetChildByName(single, "progressbar_main"):setVisible(false)
			imageTaskStatus:setSpriteFrame("icon_challenge_wh.png")
		elseif i == self.taskStage then
			self.taskEffect:setPosition(beginPosX - (i - 1) * offsetX - 1, posY + 2)
			imageTaskStatus:setSpriteFrame("frame_font_0" .. self.taskStage .. ".png")
		else
			imageTaskStatus:setSpriteFrame("icon_czhl_g.png")
		end
		self.taskTable[i] = single
	end
end
function treasureCrystalView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_TREASURECRYSTAL_REFRESH", handler(self, self.useItemCallBack))
end
function treasureCrystalView:refreshData()
	self.taskExplain:setVisible(self.itemStatus == ItemStatus.NOTBIND)
	self.textWaring:setVisible(self.itemStatus == ItemStatus.BINDTASK)
	self.btnOpenAndBind:setTitleText(i18n(self.itemStatus == ItemStatus.NOTBIND and "common_text_246" or "treasure_crystal_btn_01"))
	self.itemLimitedTime = self.itemLimitedTime or serviceFunctions.systemTime()
	self.textTime:setVisible(self.itemStatus == ItemStatus.BINDTASK)
	self.textTime:beginTime(self.itemLimitedTime - serviceFunctions.systemTime())
	if self.itemStatus == ItemStatus.BINDTASK then
		self.taskType = self.taskInfo.taskType
		local str
		if self.taskType == gTreasureCrystalTaskType.KILL_MONSTER then
			ItemStatus = self.taskType
			ItemStatus, ItemStatus, self.taskType.site = self.taskInfo.x, "(" .. self.taskInfo.x .. "," .. self.taskInfo.y .. ")", "(" .. self.taskInfo.x .. "," .. self.taskInfo.y .. ")"
			self.taskInfo.x.color = "#ffff00"
			self.taskInfo.x.u = "true"
			self.taskInfo.x.c = "true"
			ItemStatus, ("(" .. self.taskInfo.x .. "," .. self.taskInfo.y .. ")").site, self.taskInfo.x.name = self.taskInfo.x, self.taskInfo.x, "posXY"
			;("(" .. self.taskInfo.x .. "," .. self.taskInfo.y .. ")").__default, self.taskInfo.x.color = self.taskInfo.x, "#ffffff"
			str = i18n_html(taskInfoStr[tostring(self.taskType)], self.taskType, "(" .. self.taskInfo.x .. "," .. self.taskInfo.y .. ")")
		else
			ItemStatus = self.taskType
			self.taskType.site = "(" .. (self.taskInfo.x or 1) - 1 .. "," .. (self.taskInfo.y or 1) - 1 .. ")"
			ItemStatus, ItemStatus, self.taskType.time = self.taskInfo.taskAim, SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim), SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim)
			self.taskInfo.taskAim.color = "#ffff00"
			self.taskInfo.taskAim.u = "true"
			self.taskInfo.taskAim.c = "true"
			ItemStatus, SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim).site, self.taskInfo.taskAim.name = self.taskInfo.taskAim, self.taskInfo.taskAim, "posXY"
			ItemStatus, SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim).time, self.taskInfo.taskAim.color = self.taskInfo.taskAim, self.taskInfo.taskAim, "#ffff00"
			SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim).__default, self.taskInfo.taskAim.color = self.taskInfo.taskAim, "#ffffff"
			str = i18n_html(taskInfoStr[tostring(self.taskType)], self.taskType, (SoraDConvertSecondToStringNoDayNoHour(self.taskInfo.taskAim)))
		end
		self.textTaskInfo:setString(str)
		self.textTaskInfo:setTouchEnabled(true)
		self.textTaskInfo:addTouchEventListener(handler(self, self.btnClickText))
		self.btnRefresh:setVisible(true)
		self.btnOpenAndBind:setPositionX(402)
		local lastRefreshTime = self.taskInfo.refreshTime or 0
		local deltaTime = serviceFunctions.systemTime() - lastRefreshTime
		deltaTime = 0 < deltaTime and deltaTime or 0
		print("deltaTime", deltaTime)
		if deltaTime > REFRESHTIME then
			self:refreshTimeEnd(true)
		else
			self:refreshTimeEnd(false)
			self.textRefreshTime:beginTime(REFRESHTIME - deltaTime)
		end
	end
end
function treasureCrystalView:useItemCallBack(target, data)
	if data.infoData then
		self.taskInfo = data.infoData
		self.itemLimitedTime = self.taskInfo.taskEndTime
		self.itemStatus = ItemStatus.BINDTASK
		self:refreshData()
	else
		self:judgeClose()
	end
end
function treasureCrystalView:btnClickOpen(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.itemStatus == ItemStatus.NOTBIND then
			_ENV = nil
			;(nil).time = self.itemLimitedTime
			backpackCtrl:reqUseItem(self.itemID, 1, nil)
			local panel = ccui.Layout:create()
			panel:setAnchorPoint(0.5, 0.5)
			panel:setContentSize(display.width, display.height)
			panel:setPosition(display.cx, display.cy)
			panel:setBackGroundColorType(1)
			panel:setBackGroundColor(cc.c3b(0, 0, 0))
			panel:setBackGroundColorOpacity(204.0)
			panel:setTouchEnabled(true)
			panel:setSwallowTouches(true)
			panel:addTo(self, 900)
			ItemStatus = 900
			;(900)[1] = cca.delay(1.8833333333333333)
			;(900)[2] = cca.callFunc(function()
				panel:removeFromParent()
				self.crystalEffect:setVisible(false)
			end)
			;(900)[3] = cca.callFunc(function()
				panel:removeFromParent()
				self.crystalEffect:setVisible(false)
			end)
			panel:runAction(cca.seq(900))
			local icon = SoraDGetChildByName(self.crystalEffect, "Sprite_2")
			icon:setSpriteFrame(itemDesRead.getIcon(self.itemID))
			self.crystalEffect.action:gotoFrameAndPlay(0, false)
			self.crystalEffect:setVisible(true)
		else
			SoraDGotoWorldMapPoint(cc.p((self.taskInfo.x or 1) - 1, (self.taskInfo.y or 1) - 1), true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function treasureCrystalView:btnClickRefresh(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("treasure_crystal_text_30"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType and self.taskInfo then
				_ENV = nil
				;(nil).itemId = self.itemID
				;(nil).refreshTime = self.taskInfo.refreshTime
				;(nil).objId = self.taskInfo.objId
				;(nil).x = self.taskInfo.x
				;(nil).y = self.taskInfo.y
				treasureCrystalCtrl:sendReqRefresh(nil)
			end
		end)
	end
end
function treasureCrystalView:btnClickText(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local metaInfo = button:getTouchMetaInfo(button:getTouchEndPosition())
		if metaInfo and metaInfo.name == "posXY" then
			SoraDGotoWorldMapPoint(cc.p((self.taskInfo.x or 1) - 1, (self.taskInfo.y or 1) - 1), true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function treasureCrystalView:judgeClose()
	if nil == next(treasureCrystalCtrl:getTaskInfo(self.itemID, self.itemLimitedTime)) and self.itemStatus == ItemStatus.BINDTASK then
		self:close(self, ccui.TouchEventType.ended)
	end
end
return treasureCrystalView

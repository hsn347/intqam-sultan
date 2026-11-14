local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local allianceTaskItem = class("allianceTaskItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskItem")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local colorGreen = cc.c3b(35, 255, 15)
local colorRed = cc.c3b(208, 46, 28)
local colorBlue = cc.c3b(50, 200, 200)
function allianceTaskItem:ctor()
	self.btn = SoraDGetChildByName(self, "btn")
	self.btn:setZoomScale(0.05)
	self.bg_score = SoraDGetChildByName(self, "bg_score")
	self.bg_icon = SoraDGetChildByName(self, "bg_icon")
	self.icon_item = SoraDGetChildByName(self, "icon_item")
	self.icon_yes = SoraDGetChildByName(self, "icon_yes")
	self.frame_progress = SoraDGetChildByName(self, "frame_progress")
	self.bg_L = SoraDGetChildByName(self, "bg_L")
	self.bg_R = SoraDGetChildByName(self, "bg_R")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.text_name_bg = SoraDGetChildByName(self, "text_name_bg")
	self.title_name_bg_self = SoraDGetChildByName(self, "title_name_bg_self")
	self.text_f_score = SoraDGetChildByName(self, "text_f_score")
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	self.button_delete = SoraDGetChildByName(self, "button_delete")
	self.icon_delete = SoraDGetChildByName(self, "icon_delete")
	self.icon_prepare = SoraDGetChildByName(self, "icon_prepare")
	self.text_self_tip_bg = SoraDGetChildByName(self, "text_self_tip_bg")
	self.text_self_tip = SoraDGetChildByName(self, "text_self_tip")
	SoraDGetChildByName(self, "Panel_1"):setSwallowTouches(false)
	self.btn:addTouchEventListener(handler(self, self.onClick_btn))
	self.button_delete:addTouchEventListener(handler(self, self.onClick_button_delete))
	self.itemSize = cc.size(205, 250)
	self.itemWidth = self.itemSize.width
	self.itemHeight = self.itemSize.height
	self.btn:setSwallowTouches(false)
	self:setTouchEnabled(false)
	self:setNodeEventEnabled(true)
end
function allianceTaskItem:hideCommon()
	_UPVALUE11_ = nil
	;(nil)[1] = self.text_self_tip_bg
	;(nil)[2] = self.text_self_tip
	;(nil)[3] = self.text_tip
	;(nil)[4] = self.text_f_score
	;(nil)[5] = self.title_name_bg_self
	;(nil)[6] = self.icon_yes
	;(nil)[7] = self.icon_prepare
	;(nil)[8] = self.text_name_bg
	;(nil)[9] = self.bg_L
	;(nil)[10] = self.bg_R
	local (nil)[11], array = self.button_delete, nil
	table.walk(array, function(v, k)
		v:setVisible(false)
	end)
end
function allianceTaskItem:showCommon()
	_UPVALUE2_ = nil
	;(nil)[1] = self.icon_item
	local (nil)[2], showArray = self.bg_icon, nil
	SoraDSetNodeArrayVisible(showArray, true)
end
function allianceTaskItem:init(data)
	self:endTime()
	self.itemData = data
	self:hideCommon()
	self:showCommon()
	self.icon_item:setPosition(cc.p(93, 142))
	if self.itemData.taskType == gMobilizationTaskType.USER then
		self.text_title:setVisible(true)
		colorRed = self.text_title.setVisible
		self.text_title.setVisible[1] = self.bg_L
		local self.text_title.setVisible[2], arrayWidget = self.bg_R, self.text_title.setVisible
		table.walk(arrayWidget, function(v, k)
			v:setVisible(true)
		end)
		self.text_title:setString(i18n("common_text_3563"))
		self.text_title:setColor(cc.c3b(255, 200, 100))
		_UPVALUE6_ = self.text_title.setColor
		self.text_title.setColor[1] = self.bg_L
		self.text_title.setColor[2] = self.bg_R
		self.text_title.setColor[3] = self.title_name_bg_self
		self.text_title.setColor[4] = self.text_f_score
		self.text_title.setColor[5] = self.bg_icon
		local self.text_title.setColor[6], grayTable = self.icon_item, self.text_title.setColor
		if self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TASK_NIL then
			self.title_name_bg_self:setVisible(true)
			self.text_tip:setString(i18n("common_text_3625"))
			self.text_tip:setColor(cc.c3b(225, 65, 25))
			self.icon_item:loadTexture("icon_saleRoom_symbol.png", ccui.TextureResType.plistType)
			self.text_f_score:setVisible(false)
			self.text_title:setString(i18n("common_text_3563"))
			SoraDSetArrayGray(grayTable, false)
			colorRed = SoraDSetArrayGray
			SoraDSetArrayGray[1] = self.text_tip
			local SoraDSetArrayGray[2], widgetArray = self.text_name_bg, SoraDSetArrayGray
			table.walk(widgetArray, function(v, k)
				v:setVisible(true)
			end)
			self.icon_item:setPosition(cc.p(98, 122))
		elseif self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING then
			local mission = self.itemData.mission
			memberMgr = gMobilizationTaskStatus.TASK_STATUS_DOING
			gMobilizationTaskStatus.TASK_STATUS_DOING[1] = self.text_f_score
			gMobilizationTaskStatus.TASK_STATUS_DOING[2] = self.text_self_tip
			gMobilizationTaskStatus.TASK_STATUS_DOING[3] = self.title_name_bg_self
			local gMobilizationTaskStatus.TASK_STATUS_DOING[4], widgetArray = self.text_self_tip_bg, gMobilizationTaskStatus.TASK_STATUS_DOING
			table.walk(widgetArray, function(v, k)
				v:setVisible(true)
			end)
			self.text_f_score:setString(mission.point)
			self.text_tip:setColor(cc.c3b(255, 255, 255))
			local timeStr = SoraDConvertSecondToString(mission.endtime.timer:getRemainTime())
			self.text_self_tip:setString(timeStr)
			self.text_self_tip:setColor(colorGreen)
			self.text_f_score:setString(mission.point)
			self:updateIcon(mission.tasktypeid)
			SoraDSetArrayGray(grayTable, false)
			self.timer = mission.endtime.timer
			self:beginTime()
		elseif self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TIME_OUT then
			local mission = self.itemData.mission
			memberMgr = gMobilizationTaskStatus.TASK_STATUS_TIME_OUT
			gMobilizationTaskStatus.TASK_STATUS_TIME_OUT[1] = self.text_f_score
			gMobilizationTaskStatus.TASK_STATUS_TIME_OUT[2] = self.text_self_tip
			gMobilizationTaskStatus.TASK_STATUS_TIME_OUT[3] = self.title_name_bg_self
			local gMobilizationTaskStatus.TASK_STATUS_TIME_OUT[4], widgetArray = self.text_self_tip_bg, gMobilizationTaskStatus.TASK_STATUS_TIME_OUT
			table.walk(widgetArray, function(v, k)
				v:setVisible(true)
			end)
			self.text_f_score:setString(mission.point)
			self.text_tip:setColor(cc.c3b(255, 255, 255))
			self.text_self_tip:setColor(colorRed)
			self.text_self_tip:setString(i18n("common_text_3627"))
			self.text_f_score:setString(mission.point)
			self:updateIcon(mission.tasktypeid)
			SoraDSetArrayGray(grayTable, true)
		elseif self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
			local mission = self.itemData.mission
			memberMgr = gMobilizationTaskStatus.TASK_STATUS_COMPLETE
			gMobilizationTaskStatus.TASK_STATUS_COMPLETE[1] = self.text_f_score
			gMobilizationTaskStatus.TASK_STATUS_COMPLETE[2] = self.text_self_tip
			gMobilizationTaskStatus.TASK_STATUS_COMPLETE[3] = self.title_name_bg_self
			local gMobilizationTaskStatus.TASK_STATUS_COMPLETE[4], widgetArray = self.text_self_tip_bg, gMobilizationTaskStatus.TASK_STATUS_COMPLETE
			table.walk(widgetArray, function(v, k)
				v:setVisible(true)
			end)
			self.text_f_score:setString(mission.point)
			self.text_self_tip:setString(i18n("common_text_3636"))
			self.text_self_tip:setColor(colorGreen)
			self.text_f_score:setString(mission.point)
			self:updateIcon(mission.tasktypeid)
			SoraDSetArrayGray(grayTable, false)
		end
	elseif self.itemData.taskType == gMobilizationTaskType.ALLIANCE then
		self.text_title:setVisible(false)
		self.text_title:setColor(cc.c3b(255, 255, 255))
		_UPVALUE6_ = self.text_title.setColor
		self.text_title.setColor[1] = self.bg_L
		self.text_title.setColor[2] = self.bg_R
		self.text_title.setColor[3] = self.title_name_bg_self
		self.text_title.setColor[4] = self.text_f_score
		self.text_title.setColor[5] = self.bg_icon
		local self.text_title.setColor[6], grayTable = self.icon_item, self.text_title.setColor
		SoraDSetArrayGray(grayTable, false)
		if self.itemData.mission.deltime > 0 then
			self.title_name_bg_self:setVisible(true)
			memberMgr = self.title_name_bg_self.setVisible
			self.title_name_bg_self.setVisible[1] = self.text_self_tip
			self.title_name_bg_self.setVisible[2] = self.text_self_tip_bg
			self.title_name_bg_self.setVisible[3] = self.icon_item
			local self.title_name_bg_self.setVisible[4], hideArray = self.bg_icon, self.title_name_bg_self.setVisible
			SoraDSetNodeArrayVisible(hideArray, false)
			colorBlue = SoraDSetNodeArrayVisible
			SoraDSetNodeArrayVisible[1] = self.icon_prepare
			SoraDSetNodeArrayVisible[2] = self.text_tip
			local SoraDSetNodeArrayVisible[3], showArray = self.text_name_bg, SoraDSetNodeArrayVisible
			SoraDSetNodeArrayVisible(showArray, true)
			self.text_title:setString(i18n("common_text_3564"))
			self.timer = self.itemData.mission.generatetime.timer
			self.text_tip:setString(SoraDConvertSecondToString(self.itemData.mission.generatetime.timer:getRemainTime()))
			self.text_tip:setColor(colorBlue)
			self:beginTime()
		else
			colorRed = self.title_name_bg_self.setVisible
			self.title_name_bg_self.setVisible[1] = self.text_f_score
			local self.title_name_bg_self.setVisible[2], widgetArray = self.text_name_bg, self.title_name_bg_self.setVisible
			table.walk(widgetArray, function(v, k)
				v:setVisible(true)
			end)
			self.title_name_bg_self:setVisible(true)
			local mission = self.itemData.mission
			self:updateTitle(mission.tasktypeid)
			self:updateIcon(mission.tasktypeid)
			self.text_f_score:setString(mission.point)
			local member = memberMgr:getOwnMember()
			local rank = member:getProperty("rank")
			if rank >= gAllianceRank.R4 then
				self.button_delete:setVisible(true)
			end
		end
	end
end
function allianceTaskItem:updateTitle(tasktypeid)
	local keyName = mobilizationltCtrl:getTaskName(tasktypeid)
	if keyName then
		self.text_title:setString(i18n(keyName))
	else
		dump(self.itemData, "Error! ")
		print("Error! tasktypeid = ", tasktypeid)
		self.text_title:setString("undefined")
	end
end
function allianceTaskItem:updateIcon(tasktypeid)
	local iconName = mobilizationltCtrl:getTaskIcon(tasktypeid)
	if iconName then
		self.icon_item:loadTexture(iconName, ccui.TextureResType.plistType)
		if "Map_build_gold.png" == iconName then
			self.icon_item:setPositionY(142)
			self.icon_item:setScale(1.3)
		end
	end
end
function allianceTaskItem:onMessageListener()
end
function allianceTaskItem:onClick_btn(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			return
		end
		SoraDPlaySound()
		if self.itemData.taskType == gMobilizationTaskType.USER then
			if self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TASK_NIL then
				SoraDShowMsgTip(i18n("common_text_3635"))
				return
			end
		elseif self.itemData.taskType == gMobilizationTaskType.ALLIANCE and self.itemData.mission.deltime > 0 then
			SoraDShowMsgTip(i18n("common_text_3564"))
			return
		end
		local panel = SoraDCreatePanel("allianceTaskItemDetail")
		panel:init(self.itemData)
		panel:show()
	end
end
function allianceTaskItem:onClick_button_delete(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			return
		end
		local taskindex = self.itemData.mission.index
		_ENV = TOUCH_MOVED_ERROR_VALUE
		TOUCH_MOVED_ERROR_VALUE.time = 30
		SoraDShowMsgBox(i18n("common_text_3562", TOUCH_MOVED_ERROR_VALUE), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				SoraDShowLoading()
				print("删除任务:", taskindex)
				playerMobilizationCtrl:reqMissionDelete(taskindex)
			end
		end)
	end
end
function allianceTaskItem:getItemWidth()
	return self.itemSize.width
end
function allianceTaskItem:getItemHeight()
	return self.itemSize.height
end
function allianceTaskItem:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function allianceTaskItem:updateTime()
	if self.itemData.taskType == gMobilizationTaskType.USER then
		if self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING then
			local timeStr = SoraDConvertSecondToString(self.timer:getRemainTime())
			self.text_self_tip:setString(timeStr)
		end
	elseif self.itemData.taskType == gMobilizationTaskType.ALLIANCE and self.itemData.mission.generatetime.timer:getRemainTime() > 0 then
		self.text_tip:setString(SoraDConvertSecondToString(self.itemData.mission.generatetime.timer:getRemainTime()))
	end
end
function allianceTaskItem:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function allianceTaskItem:onExit()
	SoraDManagerRemoveTimerByTarget(self)
end
function allianceTaskItem:setScroll(scroll)
	self.scroll = scroll
end
return allianceTaskItem

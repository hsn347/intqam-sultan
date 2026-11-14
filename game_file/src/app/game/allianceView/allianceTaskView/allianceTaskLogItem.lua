local colorGreen = cc.c3b(60, 120, 80)
local colorRed = cc.c3b(149, 72, 72)
local colorBlue = cc.c3b(34, 107, 131)
local colorYellow = cc.c3b(255, 255, 0)
local bgGreen = "frame_square_25_green.png"
local bgBlue = "frame_square_25_blue.png"
local bgRed = "frame_square_25_red.png"
local bgYellow = "frame_square_25_red.png"
_ENV = nil
_ENV = nil
;(nil).formatText = "common_text_3623"
;(nil).textColor = colorGreen
;(nil)[gMobilizationOperateType.OPERATE_COMMIT], (nil).bgImg = nil, bgGreen
_ENV = nil
;(nil).formatText = "common_text_3622"
;(nil).textColor = colorBlue
;(nil)[gMobilizationOperateType.OPERATE_ACCEPT], (nil).bgImg = nil, bgBlue
_ENV = nil
;(nil).formatText = "common_text_3624"
;(nil).textColor = colorRed
;(nil)[gMobilizationOperateType.OPERATE_ABORT], (nil).bgImg = nil, bgRed
_ENV = nil
;(nil).formatText = "common_text_3637"
;(nil).textColor = colorYellow
;(nil)[gMobilizationOperateType.OPERATE_DELETE], (nil).bgImg = nil, bgYellow
_ENV = nil
;(nil).formatText = "common_text_3674"
;(nil).textColor = colorBlue
;(nil)[gMobilizationOperateType.OPERATE_BUYTIMES], (nil).bgImg = nil, bgBlue
local styleTb
local maxTextWidth = 350
local widthCell = 590
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceTaskLogItem = class("allianceTaskLogItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskLogItem")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskLogItem:ctor()
	self.img_bg = SoraDGetChildByName(self, "img_bg")
	self.txt_content = SoraDGetChildByName(self, "txt_content")
	self.txt_time = SoraDGetChildByName(self, "txt_time")
	self.img_icon_bg = SoraDGetChildByName(self, "img_icon_bg")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.itemSize = cc.size(widthCell, 74)
	self.itemWidth = self.itemSize.width
	self.itemHeight = self.itemSize.height
	self:setTouchEnabled(false)
	self.img_icon:setTouchEnabled(true)
	self.img_icon:setSwallowTouches(false)
	self.img_icon:addTouchEventListener(handler(self, self.onBtnIcon))
end
function allianceTaskLogItem:init(logItem)
	local data = logItem.logData
	if not data or data.tasktypeid == nil then
		self.txt_content:setString(i18n("common_text_3629"))
		local autoRenderSize = self.txt_content:getContentSize()
		local autoHeight = self.txt_content:getContentSize().height
		if autoRenderSize.width > maxTextWidth then
			autoHeight = SoraDGetAutoHeightLabel(self.txt_content, maxTextWidth)
		end
		if autoHeight < 30 then
			autoHeight = 30
		end
		local bgSize = cc.size(515, autoHeight + 30)
		self.img_bg:setContentSize(cc.size(515, autoHeight + 30))
		self.txt_time:setPositionY(bgSize.height / 2)
		self.itemSize = cc.size(widthCell, bgSize.height)
		self.itemWidth = self.itemSize.width
		self.itemHeight = self.itemSize.height
		self.txt_time:setVisible(false)
	else
		self.txt_content:ignoreContentAdaptWithSize(true)
		self.txt_content:setTextAreaSize(cc.size(0, 0))
		local tasktypeid = data.tasktypeid
		local formatText = styleTb[data.operateType] and styleTb[data.operateType].formatText or ""
		local taskName = ""
		local taskInfo
		if formatText ~= "" and formatText and tasktypeid and data.operateType ~= gMobilizationOperateType.OPERATE_BUYTIMES then
			print("tasktypeid = ", tasktypeid, "taskName = ", mobilizationltCtrl:getTaskName(tasktypeid))
			if mobilizationltCtrl:getTaskName(tasktypeid) then
				taskName = i18n(mobilizationltCtrl:getTaskName(tasktypeid))
			end
			taskInfo = mobilizationltCtrl:getTaskInfo(tasktypeid)
		else
		end
		if not taskInfo then
			taskInfo, _ENV = mobilizationltCtrl:getTaskInfo(tasktypeid), mobilizationltCtrl:getTaskInfo(tasktypeid)
		end
		local strContent
		if formatText == "" then
			strContent = "undefined"
		else
			_ENV = mobilizationltCtrl:getTaskName(tasktypeid)
			mobilizationltCtrl:getTaskName(tasktypeid).name = data.name
			mobilizationltCtrl:getTaskName(tasktypeid).task = taskName
			mobilizationltCtrl:getTaskName(tasktypeid).score = taskInfo.point
			mobilizationltCtrl:getTaskName(tasktypeid).time = 1
			strContent = i18n(formatText, mobilizationltCtrl:getTaskName(tasktypeid))
		end
		self.txt_content:setString(strContent)
		self.txt_content:setColor(styleTb[data.operateType].textColor)
		self.img_bg:loadTexture(styleTb[data.operateType].bgImg, ccui.TextureResType.plistType)
		local timeStr = os.date("%m-%d %H:%M", data.time)
		self.txt_time:setString(timeStr)
		local autoRenderSize = self.txt_content:getContentSize()
		local autoHeight = self.txt_content:getContentSize().height
		if autoRenderSize.width > maxTextWidth then
			autoHeight = SoraDGetAutoHeightLabel(self.txt_content, maxTextWidth)
		end
		if autoHeight < 30 then
			autoHeight = 30
		end
		local bgSize = cc.size(515, autoHeight + 30)
		self.img_bg:setContentSize(cc.size(515, autoHeight + 30))
		self.txt_time:setPositionY(bgSize.height / 2)
		self.itemSize = cc.size(widthCell, bgSize.height)
		self.itemWidth = self.itemSize.width
		self.itemHeight = self.itemSize.height
	end
end
function allianceTaskLogItem:setScroll(scroll)
	self.scroll = scroll
end
function allianceTaskLogItem:onMessageListener()
end
function allianceTaskLogItem:getItemWidth()
	return self.itemWidth
end
function allianceTaskLogItem:getItemHeight()
	return self.itemHeight
end
function allianceTaskLogItem:onBtnIcon(sender, event)
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
		print("发送消息------")
		_ENV = "发送消息------"
		;("发送消息------").msg = "MESSAGE_ALLIANCE_HIDE_LOGS"
		SoraDSendMessage("发送消息------")
	end
end
function allianceTaskLogItem:disableEvent()
	self.img_icon:setTouchEnabled(false)
end
return allianceTaskLogItem

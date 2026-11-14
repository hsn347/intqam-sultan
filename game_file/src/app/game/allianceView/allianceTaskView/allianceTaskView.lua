local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mailFunctions = include("mailFunctions")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceTaskView = class("allianceTaskView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskView")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local colorGreen = cc.c3b(60, 120, 80)
local colorRed = cc.c3b(149, 72, 72)
local colorBlue = cc.c3b(34, 107, 131)
local colorYellow = cc.c3b(255, 255, 0)
_ENV = 255
_ENV = 0
;(0).formatText = "common_text_3623"
;(255)[gMobilizationOperateType.OPERATE_COMMIT], (0).textColor = 0, colorGreen
_ENV = 0
;(0).formatText = "common_text_3622"
;(255)[gMobilizationOperateType.OPERATE_ACCEPT], (0).textColor = 0, colorBlue
_ENV = 0
;(0).formatText = "common_text_3624"
;(255)[gMobilizationOperateType.OPERATE_ABORT], (0).textColor = 0, colorRed
_ENV = 0
;(0).formatText = "common_text_3637"
;(255)[gMobilizationOperateType.OPERATE_DELETE], (0).textColor = 0, colorYellow
_ENV = 0
;(0).formatText = "common_text_3674"
;(255)[gMobilizationOperateType.OPERATE_BUYTIMES], (0).textColor = 0, colorBlue
local styleTb = 255
function allianceTaskView:ctor()
	self.isHideCurrentSceneView = true
	self.Size_Image_bg = SoraDGetChildByName(self, "Size_Image_bg")
	self.Top_Size_ScrollView_events = SoraDGetChildByName(self, "ScrollView_events")
	self.Top_Img_Head = SoraDGetChildByName(self, "Top_Img_Head")
	self.log_node = SoraDGetChildByName(self, "Top_log_node")
	self.log_bg = SoraDGetChildByName(self, "log_bg")
	self.log_bg2 = SoraDGetChildByName(self, "log_bg2")
	self.log_bg_bottom = SoraDGetChildByName(self, "log_bg_bottom")
	self.text_time = SoraDGetChildByName(self, "text_time")
	self.text_accept_count = SoraDGetChildByName(self, "text_accept_count")
	self.btn_add = SoraDGetChildByName(self, "btn_add")
	self.Top_Size_Image_R = SoraDGetChildByName(self, "Top_Size_Image_R")
	self.Top_Size_Image_L = SoraDGetChildByName(self, "Top_Size_Image_L")
	self.Size_Tile_L = SoraDGetChildByName(self, "Size_Tile_L")
	self.Size_Tile_R = SoraDGetChildByName(self, "Size_Tile_R")
	self.Top_Info_Node = SoraDGetChildByName(self, "Top_Info_Node")
	self.text_total = SoraDGetChildByName(self, "text_total")
	self.text_cur = SoraDGetChildByName(self, "text_cur")
	self.icon_level = SoraDGetChildByName(self, "icon_level")
	self.text_level_bg = SoraDGetChildByName(self, "text_level_bg")
	self.text_level = SoraDGetChildByName(self, "text_level")
	self.btn_award = SoraDGetChildByName(self, "btn_award")
	self.btn_rank = SoraDGetChildByName(self, "btn_rank")
	self.sprite_lace_L = SoraDGetChildByName(self, "sprite_lace_L")
	self.sprite_lace_R = SoraDGetChildByName(self, "sprite_lace_R")
	self.sprite_lace_LT = SoraDGetChildByName(self, "sprite_lace_LT")
	self.sprite_lace_RT = SoraDGetChildByName(self, "sprite_lace_RT")
	self.Top_Image_headBar = SoraDGetChildByName(self, "Top_Image_headBar")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.Top_Node_head = SoraDGetChildByName(self, "Top_Node_head")
	self.btn_help_tip = SoraDGetChildByName(self, "btn_help_tip")
	self.frame_bottom_line = SoraDGetChildByName(self, "frame_bottom_line")
	self.frame_bl_lace = SoraDGetChildByName(self, "frame_bl_lace")
	self.frame_br_lace = SoraDGetChildByName(self, "frame_br_lace")
	self.Top_Tip = SoraDGetChildByName(self, "Top_Tip")
	self.Top_Button_Join = SoraDGetChildByName(self, "Top_Button_Join")
	self.Top_remainTime = SoraDGetChildByName(self, "Top_remainTime")
	self.nodeReceiveTimes = SoraDGetChildByName(self, "Node_receive_times")
	self.nodeUncommonState = SoraDGetChildByName(self, "Node_uncommon_state")
	self.nodeMiddle = SoraDGetChildByName(self, "Middle_Node")
	self.nodeReceive = SoraDGetChildByName(self.nodeMiddle, "Node_receive")
	self.nodeUnreceive = SoraDGetChildByName(self.nodeMiddle, "Node_unReceive")
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeLeftTime = SoraDGetChildByName(self, "Node_leftTime")
	self.nodeBottomBg = SoraDGetChildByName(self, "Node_bottom_bg")
	self.btnControl = SoraDGetChildByName(self.nodeReceive, "Button_control")
	self.btnReceive = SoraDGetChildByName(self.nodeReceive, "Button_receive")
	self.btnUnreceive = SoraDGetChildByName(self.nodeUnreceive, "Button_unReceive")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	self.panelLog = SoraDGetChildByName(self, "Panel_26")
	self.progressTime = SoraDGetChildByName(self.nodeReceive, "LoadingBar_1")
	self.progressTimeBg = SoraDGetChildByName(self.nodeReceive, "Image_bg")
	self.progressExp = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_exp")
	self.text_timePersent = SoraDGetChildByName(self.nodeReceive, "Text_progress")
	self.text_f_score = SoraDGetChildByName(self.nodeReceive, "text_f_score")
	self.text_f_score_key = SoraDGetChildByName(self.nodeReceive, "Text_f_score_key")
	self.text_alter = SoraDGetChildByName(self.nodeReceive, "Text_alter")
	self.text_log_time = SoraDGetChildByName(self, "txt_time")
	self.text_log_contnet = SoraDGetChildByName(self, "txt_content")
	self.icon_item = SoraDGetChildByName(self.nodeReceive, "icon_item")
	self.img_scroll_bg = SoraDGetChildByName(self, "Size_Tile_Image_bg")
	self.panelBg = SoraDGetChildByName(self, "Panel_1")
	self.btn_add:addTouchEventListener(handler(self, self.onClick_btn_add))
	self.btn_award:addTouchEventListener(handler(self, self.onClick_btn_award))
	self.btn_rank:addTouchEventListener(handler(self, self.onClick_btn_rank))
	self.btn_help_tip:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	self.Top_Button_Join:addTouchEventListener(handler(self, self.onClick_Top_Button_Join))
	self.btnControl:addTouchEventListener(handler(self, self.onClick_receive_task_btn))
	self.btnReceive:addTouchEventListener(handler(self, self.onClick_icon_btn))
	self.btnUnreceive:addTouchEventListener(handler(self, self.onClick_icon_btn))
	self.btnLog:setPressedActionEnabled(false)
	self.btnLog:setSwallowTouches(false)
	self.btnReceive:setSwallowTouches(true)
	self.btnUnreceive:setSwallowTouches(true)
	self.panelLog:addTouchEventListener(handler(self, self.onClick_btn_log))
	SoraDGetChildByName(self, "Image_center_top"):setFillType(1)
	self.img_scroll_bg:setFillType(1)
	self.text_f_score_key:setString(i18n("common_text_623"))
	_ENV = i18n("common_text_623")
	i18n("common_text_623").time = " "
	SoraDGetChildByName(self, "text_time_key"):setString(i18n("common_text_766", i18n("common_text_623")))
	SoraDGetChildByName(self.nodeUnreceive, "Text_tips"):setString(i18n("common_text_4401"))
	self.Top_Button_Join:setTitleText(i18n("common_text_167"))
	self.commonFramTitle_node:setTitle(i18n("mail_text_417"))
	self:fitDevice()
	self.Top_Size_ScrollView_events:setListenAllScrollingEnabled(true)
	self.Top_Size_ScrollView_events:addEventListener(handler(self, self.scrollEventCallBack))
	self.icon_level:setTouchEnabled(true)
	self.icon_level:addTouchEventListener(handler(self, self.onClick_icon_level))
	self:hideCommon()
	self:initStates()
	self.tableSpare, _ENV, self.itemsData, _ENV = self.initStates, self.initStates, self.initStates, self.initStates
	self.eventItemSize = cc.size(205, 240)
	self:init()
	SoraDCreateFireEffectNode(self.frame_bl_lace, self.frame_br_lace)
end
function allianceTaskView:init(data)
	self.personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
	self.alliancemissionInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	local mobiAliStatus = playerMobilizationCtrl:getUserMobiAliStatus()
	local status = playerMobilizationCtrl:getActivityStatus().status
	dump(mobiAliStatus, "mobiAliStatus = ", 10)
	dump(status, "activityStatus", 10)
	self.status = status
	self.state = self.stateTb[self.status]
	self:updateView()
end
function allianceTaskView:msgHideLogs()
	self:showEvents()
end
function allianceTaskView:hideEvents()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(0.3, 320, 0)
	;(nil)[2] = cca.callFunc(function()
		print("隐藏")
		self.Top_Size_ScrollView_events:setVisible(false)
	end)
	;(nil)[3] = cca.callFunc(function()
		print("隐藏")
		self.Top_Size_ScrollView_events:setVisible(false)
	end)
	;(nil)[4] = cca.callFunc(function()
		print("隐藏")
		self.Top_Size_ScrollView_events:setVisible(false)
	end)
	local act = cca.seq(nil)
	act:setTag(1)
	self.Top_Size_ScrollView_events:stopActionByTag(1)
	self.Top_Size_ScrollView_events:runAction(act)
end
function allianceTaskView:showEvents()
	self.Bottom_Node:setVisible(true)
	self.Top_Size_ScrollView_events:setVisible(true)
	local act = cca.moveTo(0.3, 320, self.Top_Size_ScrollView_events:getContentSize().height)
	act:setTag(1)
	self.Top_Size_ScrollView_events:stopActionByTag(1)
	self.Top_Size_ScrollView_events:runAction(act)
end
function allianceTaskView:hideCommon()
	_UPVALUE14_ = nil
	;(nil)[1] = self.Top_Button_Join
	;(nil)[2] = self.Top_Size_ScrollView_events
	;(nil)[3] = self.Bottom_Node
	;(nil)[4] = self.Top_Tip
	;(nil)[5] = self.text_level_bg
	;(nil)[6] = self.btn_rank
	;(nil)[7] = self.Top_remainTime
	;(nil)[8] = self.nodeReceiveTimes
	;(nil)[9] = self.nodeUncommonState
	;(nil)[10] = self.nodeMiddle
	;(nil)[11] = self.nodeBottom
	;(nil)[12] = self.nodeLeftTime
	;(nil)[13] = self.img_scroll_bg
	local (nil)[14], tbHide = self.panelBg, nil
	table.walk(tbHide, function(v, k)
		v:setVisible(false)
	end)
	function _ENV(v, k)
		v:setVisible(false)
	end
	;(function(v, k)
		v:setVisible(false)
	end).maxValue = 0
	;(function(v, k)
		v:setVisible(false)
	end).curValue = 0
	self.progressExp:setProgressDate(function(v, k)
		v:setVisible(false)
	end)
	_ENV = self.text_level_bg
	self.text_level_bg.member = " "
	self.text_level_bg.total = 0
	self.text_total:setString(i18n("common_text_155", self.text_level_bg))
	self.text_cur:setString(0)
end
function allianceTaskView:updateView()
	self:hideCommon()
	self.state.updateView()
	SoraDGetAutoHeightLabel(self.Top_Tip, 570)
end
function allianceTaskView:initCurAliStatus()
	_ENV = nil
	;(nil).updateView = function()
		_UPVALUE2_ = nil
		;(nil)[1] = self.text_level_bg
		local (nil)[2], tbShow = self.btn_rank, nil
		SoraDSetNodeArrayVisible(tbShow, true)
		self:updateScore()
	end
	_ENV, self.curAliStateActive, (nil).updateTime = nil, nil, function()
	end
	;(nil).updateView = function()
		_UPVALUE2_ = nil
		;(nil)[1] = self.text_level_bg
		local (nil)[2], tbHide = self.btn_rank, nil
		SoraDSetNodeArrayVisible(tbHide, false)
	end
	self.curAliInvalid, (nil).updateTime = nil, function()
	end
end
function allianceTaskView:getCurAliState()
	if not self.curAliStateActive then
		self:initCurAliStatus()
	end
	local curAliStatus = playerMobilizationCtrl:getCurAliStatus()
	print("curAliStatus = ", curAliStatus)
	playerMobilizationCtrl = print
	print[gMobiCurAliStatus.CUR_ALI_ACTIVE] = self.curAliStateActive
	local print[gMobiCurAliStatus.CUR_ALI_INVALID], tbStateIndex = self.curAliInvalid, print
	return tbStateIndex[curAliStatus]
end
function allianceTaskView:initUserStatus()
	_ENV = nil
	;(nil).updateView = function()
		_UPVALUE2_ = nil
		;(nil)[1] = self.Top_Tip
		local (nil)[2], tbShow = self.nodeUncommonState, nil
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		self = nil
		;(nil).num = 25
		self.Top_Tip:setString(i18n("common_text_3558", nil))
		local curAliState = self:getCurAliState()
		curAliState:updateView()
		self.text_level:setString(i18n("common_text_279") .. "0")
		self = i18n("common_text_3558", nil)
		i18n("common_text_3558", nil).member = " "
		i18n("common_text_3558", nil).total = 0
		self.text_total:setString(i18n("common_text_155", i18n("common_text_3558", nil)))
		self.text_cur:setString(0)
	end
	;(nil).updateTime = function()
	end
	_ENV, self.userStateAllianceUnorganized, (nil).onClick_btn_award = nil, nil, function()
		_ENV = nil
		;(nil).num = 25
		SoraDShowMsgTip(i18n("common_text_3558", nil))
	end
	;(nil).updateView = function()
		print("self.userStateNotOriginAlliance -----")
		_UPVALUE4_ = print
		print[1] = self.Top_Tip
		print[2] = self.btn_rank
		print[3] = self.text_level_bg
		local print[4], tbShow = self.nodeUncommonState, print
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local allianceInfo = personalMissionData.allianceinfo
		dump(allianceInfo)
		local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
		_ENV = nil
		;(nil).abbr = allianceName
		self.Top_Tip:setString(i18n("common_text_3559", nil))
		local curAliState = self:getCurAliState()
		curAliState:updateView()
	end
	;(nil).updateTime = function()
	end
	_ENV, self.userStateNotOriginAlliance, (nil).onClick_btn_award = nil, nil, function()
		local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local allianceInfo = personalMissionData.allianceinfo
		local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
		playerMobilizationCtrl = nil
		;(nil).abbr = allianceName
		SoraDShowMsgTip(i18n("common_text_3559", nil))
	end
	;(nil).updateView = function()
		print("userState = self.userStateNotOriginAllianceAndNoAlliance")
		playerMobilizationCtrl = print
		print[1] = self.Top_Tip
		local print[2], tbShow = self.nodeUncommonState, print
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local allianceInfo = personalMissionData.allianceinfo
		local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
		_ENV = nil
		;(nil).abbr = allianceName
		self.Top_Tip:setString(i18n("common_text_3559", nil))
		local curAliState = self:getCurAliState()
		curAliState:updateView()
	end
	;(nil).updateTime = function()
	end
	_ENV, self.userStateNotOriginAllianceAndNoAlliance, (nil).onClick_btn_award = nil, nil, function()
		local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local allianceInfo = personalMissionData.allianceinfo
		local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
		playerMobilizationCtrl = nil
		;(nil).abbr = allianceName
		SoraDShowMsgTip(i18n("common_text_3559", nil))
	end
	;(nil).updateView = function()
		_UPVALUE4_ = nil
		;(nil)[1] = self.Top_Tip
		;(nil)[2] = self.btn_rank
		;(nil)[3] = self.text_level_bg
		local (nil)[4], tbShow = self.nodeUncommonState, nil
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		self.Top_Tip:setString(i18n("common_text_3587"))
		local curAliState = self:getCurAliState()
		curAliState:updateView()
	end
	;(nil).updateTime = function()
	end
	_ENV, self.userStateCastleNotSatisfy, (nil).onClick_btn_award = nil, nil, function()
		SoraDShowMsgTip(i18n("common_text_3587"))
	end
	;(nil).updateView = function()
		_UPVALUE9_ = nil
		;(nil)[1] = self.Top_Size_ScrollView_events
		;(nil)[2] = self.btn_rank
		;(nil)[3] = self.text_level_bg
		;(nil)[4] = self.nodeMiddle
		;(nil)[5] = self.nodeReceiveTimes
		;(nil)[6] = self.nodeBottom
		;(nil)[7] = self.nodeLeftTime
		;(nil)[8] = self.img_scroll_bg
		local (nil)[9], tbShow = self.panelBg, nil
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		local curAliState = self:getCurAliState()
		curAliState:updateView()
		local activityStatus = playerMobilizationCtrl:getActivityStatus()
		local remainTime = activityStatus.calculatetime.timer:getRemainTime()
		self.text_time:setString(SoraDConvertSecondToString(remainTime))
		self:beginTime()
		self:updateBuyTimes()
		self.itemsData = self:getEventDatas()
		print("当前有事件个数：", #self.itemsData)
		dump(self.itemsData, "self.itemsData", 10)
		self:updateOwnMisson()
		self:updateScrollView()
		self:updateOneLog()
	end
	;(nil).updateTime = function()
		local activityStatus = playerMobilizationCtrl:getActivityStatus()
		local remainTime = activityStatus.calculatetime.timer:getRemainTime()
		self.text_time:setString(SoraDConvertSecondToString(remainTime))
	end
	_ENV, self.userStateNormal, (nil).onClick_btn_award = nil, nil, function()
		SoraDCreatePanel("allianceTaskReward"):show()
	end
	;(nil).updateView = function()
		print("self.userStateNotJoinWhenStart = {  --开始时无联盟")
		_UPVALUE3_ = print
		print[1] = self.Top_Tip
		print[2] = self.nodeUncommonState
		local print[3], tbShow = self.text_level_bg, print
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		self.Top_Tip:setString(i18n("common_text_3557"))
		self.text_level:setString(i18n("common_text_279") .. "0")
		local curAliState = self:getCurAliState()
		curAliState:updateView()
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		print("allianceMgr:hasJoinAlliance() = ", allianceMgr:hasJoinAlliance())
		if allianceMgr:hasJoinAlliance() then
			self.Top_Button_Join:setVisible(false)
		else
			self.Top_Button_Join:setVisible(true)
		end
	end
	;(nil).updateTime = function()
	end
	self.userStateNotJoinWhenStart, (nil).onClick_btn_award = nil, function()
		SoraDShowMsgTip(i18n("common_text_3557"))
	end
end
function allianceTaskView:updateIcon(tasktypeid)
	local iconName = mobilizationltCtrl:getTaskIcon(tasktypeid)
	if iconName then
		self.icon_item:loadTexture(iconName, ccui.TextureResType.plistType)
		if "Map_build_gold.png" == iconName then
			self.icon_item:setPositionY(115)
			self.icon_item:setScale(1.3)
		end
	end
end
function allianceTaskView:updateOwnMisson()
	SoraDCloseLoading(self.btnControl)
	local updateTaskTime = function(...)
		local passTime = self.curmission.endtime.timer:getTotalTime() - self.curmission.endtime.timer:getRemainTime()
		local percent = passTime * 100 / self.curmission.endtime.timer:getTotalTime()
		if percent < 3 then
			percent = 3
		end
		self.progressTime:setPercent(percent)
		local timeStr = SoraDConvertSecondToString(self.curmission.endtime.timer:getRemainTime())
		self.text_timePersent:setString(timeStr)
	end
	local beginTaskTime = function(...)
		if self.timeHandlerTask then
			SoraDManagerRemoveTimer(self, self.timeHandlerTask)
		end
		self.timeHandlerTask = SoradCreateTimer(self, updateTaskTime)
	end
	local setTextGrey = function(isGrey)
		self.text_f_score:setColor(isGrey and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
		self.text_alter:setColor(isGrey and cc.c3b(120, 120, 120) or cc.c3b(0, 128, 0))
		self.text_f_score_key:setColor(isGrey and cc.c3b(120, 120, 120) or cc.c3b(230, 200, 165))
	end
	local personData = playerMobilizationCtrl:getPersonalMissionData()
	_UPVALUE2_, self.curmission = personData.curmission, personData.curmission
	personData.curmission[1] = self.icon_item
	local personData.curmission[2], arrayGray = self.btnReceive, personData.curmission
	if self.curmission.conditiontype > 0 then
		self.nodeReceive:setVisible(true)
		self.nodeUnreceive:setVisible(false)
	else
		self.nodeReceive:setVisible(false)
		self.nodeUnreceive:setVisible(true)
	end
	if self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING then
		self.progressTime:setVisible(true)
		self.progressTimeBg:setVisible(true)
		self.text_alter:setVisible(false)
		_ENV = nil
		;(nil).value = self.curmission.point
		self.text_f_score:setString(i18n("common_text_1952", nil))
		local passTime = self.curmission.endtime.timer:getTotalTime() - self.curmission.endtime.timer:getRemainTime()
		local percent = passTime * 100 / self.curmission.endtime.timer:getTotalTime()
		if percent < 3 then
			percent = 3
		end
		self.progressTime:setPercent(percent)
		local timeStr = SoraDConvertSecondToString(self.curmission.endtime.timer:getRemainTime())
		self.text_timePersent:setString(timeStr)
		self.btnControl:loadTextures("btn_red_small_01.png", "", "", ccui.TextureResType.plistType)
		self.btnControl:setTitleText(i18n("common_text_3626"))
		self:updateIcon(self.curmission.tasktypeid)
		SoraDSetArrayGray(arrayGray, false)
		setTextGrey(false)
		self.timer = self.curmission.endtime.timer
		beginTaskTime()
	elseif self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TIME_OUT then
		self.progressTime:setVisible(false)
		self.progressTimeBg:setVisible(false)
		_ENV = false
		;(false).value = self.curmission.point
		self.text_f_score:setString(i18n("common_text_1952", false))
		self.text_alter:setString(i18n("common_text_3627"))
		self:updateIcon(self.curmission.tasktypeid)
		self.btnControl:loadTextures("btn_red_small_01.png", "", "", ccui.TextureResType.plistType)
		self.btnControl:setTitleText(i18n("common_text_3626"))
		SoraDSetArrayGray(arrayGray, true)
		setTextGrey(true)
	elseif self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
		self.progressTime:setVisible(false)
		self.progressTimeBg:setVisible(false)
		_ENV = i18n("common_text_3626")
		i18n("common_text_3626").value = self.curmission.point
		self.text_f_score:setString(i18n("common_text_1952", i18n("common_text_3626")))
		self.text_alter:setString(i18n("common_text_2601"))
		self.text_alter:setColor(cc.c3b(35, 255, 15))
		self:updateIcon(self.curmission.tasktypeid)
		self.btnControl:loadTextures("btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
		self.btnControl:setTitleText(i18n("common_text_3628"))
		SoraDSetArrayGray(arrayGray, false)
		setTextGrey(false)
	end
end
function allianceTaskView:updateBuyTimes()
	local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local buymissiontimes = personalMissionData.buymissiontimes
	if 1 <= buymissiontimes then
		self.btn_add:setVisible(false)
		self.text_accept_count:setPositionX(68)
	else
		self.text_accept_count:setPositionX(9)
		self.btn_add:setVisible(true)
	end
	local canAcceptTime = personalMissionData.missiontimes + personalMissionData.buymissiontimes - personalMissionData.totalmissiontimes
	playerMobilizationCtrl = nil
	;(nil).num = canAcceptTime
	self.text_accept_count:setString(i18n("common_text_3634", nil))
	SoraDSetTextWidthHeight(self.text_accept_count, cc.size(180, 60))
end
function allianceTaskView:getUserState()
	local userStatus = playerMobilizationCtrl:getUserMobiAliStatus()
	playerMobilizationCtrl = playerMobilizationCtrl
	playerMobilizationCtrl[gMobilizationAliStatus.STATUS_NORMAL] = self.userStateNormal
	playerMobilizationCtrl[gMobilizationAliStatus.STATUS_NOT_CASTLE_NOTENOUGH] = self.userStateCastleNotSatisfy
	playerMobilizationCtrl[gMobilizationAliStatus.STATUS_ALLIANCE_UNORGANIZED] = self.userStateAllianceUnorganized
	playerMobilizationCtrl[gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE] = self.userStateNotOriginAlliance
	playerMobilizationCtrl[gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE_AND_NO_ALI] = self.userStateNotOriginAllianceAndNoAlliance
	local playerMobilizationCtrl[gMobilizationAliStatus.STATUS_NOT_JOIN_WHEN_START], tbStateIndex = self.userStateNotJoinWhenStart, playerMobilizationCtrl
	return tbStateIndex[userStatus]
end
function allianceTaskView:initStates()
	_ENV = nil
	;(nil).updateView = function()
		_UPVALUE4_ = nil
		;(nil)[1] = self.nodeBottomBg
		;(nil)[2] = self.nodeUncommonState
		;(nil)[3] = self.Top_Tip
		local (nil)[4], tbShow = self.Top_remainTime, nil
		table.walk(tbShow, function(v, k)
			v:setVisible(true)
		end)
		function self(v, k)
			v:setVisible(true)
		end
		;(function(v, k)
			v:setVisible(true)
		end).maxValue = 0
		;(function(v, k)
			v:setVisible(true)
		end).curValue = 0
		self.progressExp:setProgressDate(function(v, k)
			v:setVisible(true)
		end)
		self = nil
		;(nil).member = " "
		;(nil).total = 0
		self.text_total:setString(i18n("common_text_155", nil))
		self.text_cur:setString(0)
		local icon = mobilizationltCtrl:getMobilizationIconByLv(1)
		self.icon_level:loadTexture(icon, ccui.TextureResType.plistType)
		local preparetime = playerMobilizationCtrl:getActivityStatus().preparetime
		self = i18n("common_text_155", nil)
		i18n("common_text_155", nil).time = os.date("!%Y-%m-%d %H:%M:%S", preparetime.timer:getFinishTime())
		self.Top_Tip:setString(i18n("common_text_3556", i18n("common_text_155", nil)))
		self.text_level:setString(i18n("common_text_279") .. "1")
		self.Top_remainTime:setString(SoraDConvertSecondToString(preparetime.timer:getRemainTime()))
		self:beginTime()
	end
	;(nil).updateTime = function()
		local timerNode = playerMobilizationCtrl:getActivityStatus().preparetime
		if timerNode then
			self.Top_remainTime:setString(SoraDConvertSecondToString(timerNode.timer:getRemainTime()))
		end
	end
	self.statePrepare, (nil).onClick_btn_award = nil, function()
		local preparetime = playerMobilizationCtrl:getActivityStatus().preparetime
		playerMobilizationCtrl = nil
		;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", preparetime.timer:getFinishTime())
		SoraDShowMsgTip(i18n("common_text_3556", nil))
	end
	self:initCurAliStatus()
	self:initUserStatus()
	_ENV = self.initUserStatus
	function self.initUserStatus.updateView()
		local userState = self:getUserState()
		userState:updateView()
	end
	function self.initUserStatus.updateTime()
		local userState = self:getUserState()
		userState:updateTime()
	end
	_ENV, self.stateOpen, self.initUserStatus.onClick_btn_award = self.initUserStatus, self.initUserStatus, function()
		local userState = self:getUserState()
		if userState.onClick_btn_award then
			userState.onClick_btn_award()
		end
	end
	function self.initUserStatus.updateView()
	end
	function self.initUserStatus.updateTime()
	end
	_ENV, self.stateCalculate, self.initUserStatus.onClick_btn_award = self.initUserStatus, self.initUserStatus, function()
	end
	function self.initUserStatus.updateView()
	end
	function self.initUserStatus.updateTime()
	end
	_ENV, self.stateClose, self.initUserStatus.onClick_btn_award = self.initUserStatus, self.initUserStatus, function()
	end
	self.initUserStatus[gMobilizationActivityStatus.ACTIVITY_PREPAREING] = self.statePrepare
	self.initUserStatus[gMobilizationActivityStatus.ACTIVITY_OPEN] = self.stateOpen
	self.initUserStatus[gMobilizationActivityStatus.ACTIVITY_CALCULATE] = self.stateCalculate
	self.stateTb, self.initUserStatus[gMobilizationActivityStatus.ACTIVITY_CLOSE] = self.initUserStatus, self.stateClose
end
function allianceTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HIDE_LOGS", handler(self, self.msgHideLogs))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_NEW_TASK_LOG", handler(self, self.msgNewTaskLog))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ADD_TIME_BACK", handler(self, self.sMsgAddTimeBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_UPDATE_EVENTS", handler(self, self.sMsgUpdateEvents))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_DELETE_BACK", handler(self, self.sMsgDelteEventBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_UPDATE_STATE", handler(self, self.sMsgTaskUpdateState))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_UPDATE_SCORE", handler(self, self.sMsgUpdateScore))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ENTER_CALCULATE", handler(self, self.sMsgEnterCalculate))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ADD_SCORE_ANIM", handler(self, self.sMsgAddScore))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ACTIVITY_CLOSE", handler(self, self.sMsgActivityClose))
end
function allianceTaskView:msgNewTaskLog(target, data)
	print("allianceTaskView:msgNewTaskLog 接收到日志--------")
	self:updateOneLog()
end
function allianceTaskView:getPrepareTime()
	return 0
end
function allianceTaskView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.state:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function allianceTaskView:updateTime()
	self.state.updateTime()
end
function allianceTaskView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function allianceTaskView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	end
end
function allianceTaskView:fitDevice()
	local dis = display.height - 960
	local scrollContentSize = self.Top_Size_ScrollView_events:getContentSize()
	_UPVALUE3_ = self.Top_Size_ScrollView_events
	self.Top_Size_ScrollView_events[1] = self.Top_Tip
	self.Top_Size_ScrollView_events[2] = self.Top_remainTime
	local self.Top_Size_ScrollView_events[3], tbShow = self.Top_Button_Join, self.Top_Size_ScrollView_events
	if 80 < dis then
		self.Top_Size_ScrollView_events:setContentSize(cc.size(scrollContentSize.width, scrollContentSize.height + dis))
		self.img_scroll_bg:setContentSize(cc.size(640, scrollContentSize.height + dis + 10))
		self.panelBg:setContentSize(cc.size(640, scrollContentSize.height + dis + 10))
	elseif dis < 0 then
		self.nodeBottomBg:setVisible(false)
		for k, v in ipairs(tbShow) do
			v:setPositionY(v:getPositionY() + math.abs(dis))
		end
	end
end
function allianceTaskView:updateScrollView()
	for i, v in ipairs(self.itemsData) do
		if (v.itemWidth == nil or v.itemWidth == 0) and (v.itemHeight == nil or v.itemHeight == 0) then
			v.itemWidth = self.eventItemSize.width
			v.itemHeight = self.eventItemSize.height
		else
		end
	end
	self:updateScrollSize()
	self:updateScrollCell()
end
function allianceTaskView:updateScrollSize()
	local scrollInner = self.Top_Size_ScrollView_events:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollContentSize = self.Top_Size_ScrollView_events:getContentSize()
	local scrollWidth = scrollContentSize.width
	local accumulateHeight = 0
	local NUMCOL = 3
	local numRows = math.floor((#self.itemsData - 1 + NUMCOL - 1) / NUMCOL)
	local accumulateHeight = self.eventItemSize.height * numRows
	accumulateHeight = accumulateHeight + 80
	for i, v in ipairs(self.itemsData) do
		if v.taskType == 1 then
		else
			v.itemPosY = accumulateHeight - math.floor((i - 1 + NUMCOL - 1) / NUMCOL) * self.eventItemSize.height
			if SoraDFIsRA() then
				v.itemPosX = scrollWidth - (i - 2) % 3 * self.eventItemSize.width - self.eventItemSize.width / 2 - 10
			else
				v.itemPosX = (i - 2) % 3 * self.eventItemSize.width + self.eventItemSize.width / 2 + 10
			end
			if v.itemNode then
				v.itemNode:setPositionY(v.itemPosY)
				v.itemNode:setPositionX(v.itemPosX)
			end
		end
	end
	local totalCellHeight = accumulateHeight
	if totalCellHeight < scrollContentSize.height then
		local deltaY = scrollContentSize.height - totalCellHeight
		totalCellHeight = scrollContentSize.height
		for i, v in ipairs(self.itemsData) do
			if v.taskType == 1 then
			else
				v.itemPosY = v.itemPosY + deltaY
				if v.itemNode then
					v.itemNode:setPositionY(v.itemPosY)
				end
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.Top_Size_ScrollView_events:setInnerContainerSize(cc.size(scrollWidth, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function allianceTaskView:updateScrollCell()
	local scrollInner = self.Top_Size_ScrollView_events:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.Top_Size_ScrollView_events:getContentSize().height
	_ENV = self.Top_Size_ScrollView_events
	self.Top_Size_ScrollView_events.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.Top_Size_ScrollView_events.endY, tableShowH = offsetY + 1.5 * scrollH, self.Top_Size_ScrollView_events
	for i, v in ipairs(self.itemsData) do
		if v.taskType == 1 then
			self.curItemData = v
		elseif v.itemNode then
			if v.itemPosY + v.itemHeight < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				v.itemNode:setVisible(false)
				table.insert(self.tableSpare, v.itemNode)
				v.itemNode = nil
			end
		else
			if tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
				if 0 < #self.tableSpare then
					v.itemNode = table.remove(self.tableSpare)
					v.itemNode:init(v)
					v.itemNode:setVisible(true)
				else
					v.itemNode = self:createEventItem(v)
					v.itemNode:addTo(self.Top_Size_ScrollView_events)
				end
				v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			else
			end
		end
	end
end
function allianceTaskView:createEventItem(itemData)
	local taskItemNode = self:newNode("allianceTaskItem")
	taskItemNode:init(itemData)
	taskItemNode:setScroll(self.Top_Size_ScrollView_events)
	return taskItemNode
end
function allianceTaskView:newNode(nodeType)
	if nodeType == "allianceTaskItem" then
		local allianceTaskItem = include("allianceTaskItem")
		if self.allianceTaskItemNode == nil then
			self.allianceTaskItemNode = cc.uiloader:load(getCCSPath("allianceTaskItem"))
			return allianceTaskItem.new(self.allianceTaskItemNode)
		else
			return allianceTaskItem.new(self.allianceTaskItemNode:clone())
		end
	else
	end
end
function allianceTaskView:getEventDatas()
	local playerMobilizationCtrl, ret
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local allianceMissionData = playerMobilizationCtrl:getAllianceMobiInfo()
	playerMobilizationCtrl = nil
	;(nil).mission = userMissionData.curmission
	;(nil).taskType = gMobilizationTaskType.USER
	table.insert(ret, nil)
	local missionData = allianceMissionData.MissionData
	for i, v in ipairs(missionData) do
		playerMobilizationCtrl = nil
		;(nil).mission = v
		;(nil).taskType = gMobilizationTaskType.ALLIANCE
		table.insert(ret, nil)
	end
	return ret
end
function allianceTaskView:updateOneLog()
	local operateLog = playerMobilizationCtrl:getOperateLog()
	local newLog = operateLog and operateLog[1] or nil
	if newLog then
		local timeStr = os.date("%m-%d %H:%M", newLog.time)
		self.text_log_time:setString(timeStr)
		local tasktypeid = newLog.tasktypeid
		local formatText = styleTb[newLog.operateType] and styleTb[newLog.operateType].formatText or ""
		local taskName = ""
		local taskInfo
		if formatText ~= "" and formatText and tasktypeid and newLog.operateType ~= gMobilizationOperateType.OPERATE_BUYTIMES then
			print("tasktypeid = ", tasktypeid, "taskName = ", mobilizationltCtrl:getTaskName(tasktypeid))
			if mobilizationltCtrl:getTaskName(tasktypeid) then
				taskName = i18n(mobilizationltCtrl:getTaskName(tasktypeid))
			end
			taskInfo = mobilizationltCtrl:getTaskInfo(tasktypeid)
		else
		end
		if not taskInfo then
			taskInfo, playerMobilizationCtrl = mobilizationltCtrl:getTaskInfo(tasktypeid), mobilizationltCtrl:getTaskInfo(tasktypeid)
		end
		local strContent
		if formatText == "" then
			strContent = "undefined"
		else
			playerMobilizationCtrl = mobilizationltCtrl:getTaskName(tasktypeid)
			mobilizationltCtrl:getTaskName(tasktypeid).name = newLog.name
			mobilizationltCtrl:getTaskName(tasktypeid).task = taskName
			mobilizationltCtrl:getTaskName(tasktypeid).score = taskInfo.point
			mobilizationltCtrl:getTaskName(tasktypeid).time = 1
			strContent = i18n(formatText, mobilizationltCtrl:getTaskName(tasktypeid))
		end
		self.text_log_contnet:setString(strContent)
		self.text_log_contnet:setColor(styleTb[newLog.operateType].textColor)
	else
		self.text_log_contnet:setString(i18n("common_text_3629"))
		self.text_log_contnet:setColor(cc.c3b(120, 120, 120))
	end
end
function allianceTaskView:updateScore()
	local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local allianceMobiInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	local matchlev = allianceMobiInfo.matchlev
	local icon = mobilizationltCtrl:getMobilizationIconByLv(matchlev)
	local name = mobilizationltCtrl:getMobilizationNameByLv(matchlev)
	self.icon_level:loadTexture(icon, ccui.TextureResType.plistType)
	local currentScore = allianceMobiInfo.score
	print("currentScore = ", currentScore)
	local currentStage, currentStageMax, isReachMax = mobilizationltCtrl:getCurrentStageMax(currentScore, matchlev)
	print("currentStage = ", currentStage)
	print("currentStageMax = ", currentStageMax)
	self.text_level:setString(i18n("common_text_279") .. currentStage)
	if isReachMax then
		local percent, delta, stageDelta = mobilizationltCtrl:getCurrentStagePercent(currentScore, matchlev)
		playerMobilizationCtrl = nil
		;(nil).maxValue = stageDelta
		;(nil).curValue = delta
		self.progressExp:setProgressDate(nil)
		local percentStr = "MAX"
		self.text_total:setVisible(false)
		self.text_cur:setString(percentStr)
	else
		local percent, delta, stageDelta = mobilizationltCtrl:getCurrentStagePercent(currentScore, matchlev)
		playerMobilizationCtrl = self.text_cur
		self.text_cur.maxValue = stageDelta
		self.text_cur.curValue = delta
		self.progressExp:setProgressDate(self.text_cur)
		playerMobilizationCtrl = nil
		;(nil).member = " "
		;(nil).total = stageDelta
		self.text_total:setString(i18n("common_text_155", nil))
		self.text_cur:setString(delta)
	end
end
function allianceTaskView:onClick_btn_add(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).num = 1
		SoraDShowBuyBox(i18n("common_text_3561", nil), playerMobilizationCtrl:getBuyCost(), i18n("common_text_204"), handler(self, self.confirmAdd))
	end
end
function allianceTaskView:confirmAdd(event)
	if event == MSGBOX_CALLBACK_YES then
		print("发起请求添加次数-------")
		SoraDShowLoading(self)
		playerMobilizationCtrl:reqAddTimes()
	end
end
function allianceTaskView:sMsgAddTimeBack(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		self:updateBuyTimes()
	else
		SoraDShowMsgTip("Add Times Error! error = " .. data.err)
	end
end
function allianceTaskView:sMsgUpdateEvents(target, data)
	print("收到刷新事件消息------")
	self:recycleAllEventNodes()
	self:updateBuyTimes()
	self.itemsData = self:getEventDatas()
	self:updateOwnMisson()
	self:updateScrollView()
end
function allianceTaskView:sMsgDelteEventBack(target, data)
	print("sMsgDelteEventBack")
	SoraDCloseLoading()
end
function allianceTaskView:sMsgTaskUpdateState(target, data)
	print("sMsgTaskUpdateState")
	self:initStates()
	self:init()
end
function allianceTaskView:sMsgUpdateScore(target, data)
	print("sMsgUpdateScore")
	self:updateScore()
end
function allianceTaskView:sMsgEnterCalculate(target, data)
	SoraDRemoveAllPanelFromManager()
end
function allianceTaskView:recycleAllEventNodes()
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			v.itemNode:setVisible(false)
			table.insert(self.tableSpare, v.itemNode)
			v.itemNode = nil
		end
	end
end
function allianceTaskView:onClick_btn_award(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.state.onClick_btn_award then
			self.state.onClick_btn_award()
		else
			assert(false, "state.onClick_btn_award not defined!")
		end
	end
end
function allianceTaskView:onClick_btn_rank(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceTaskRankingsView"):show()
	end
end
function allianceTaskView:onClick_btn_help_tip(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_MOBILIZATION)
	end
end
function allianceTaskView:onClick_Top_Button_Join(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
		;(nil).info = "From AllianceTask"
		SoraDSendMessage(nil)
	end
end
function allianceTaskView:onClickLogArea(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showLogs()
		self:hideEvents()
	end
end
function allianceTaskView:onClick_icon_level(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("commonInstruction"):show()
	end
end
function allianceTaskView:onClick_receive_task_btn(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tasktypeid = self.curmission.tasktypeid
		print("请求放弃任务-----", tasktypeid)
		if self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING or self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TIME_OUT then
			_ENV = nil
			;(nil).num = 1
			SoraDShowMsgBox(i18n("common_text_3591", nil), i18n("common_text_204"), i18n("common_text_185"), function(event)
				if event == MSGBOX_CALLBACK_YES then
					playerMobilizationCtrl:reqMissionAbort(tasktypeid)
					local loading = SoraDShowLoading(self.btnControl, self.btnControl:getContentSize())
					if loading.loadingImg then
						loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
					end
					loading:setPosition(cc.p(self.btnControl:getContentSize().width / 2, self.btnControl:getContentSize().height / 2))
				end
			end)
		elseif self.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
			print("请求提交任务-----", tasktypeid)
			playerMobilizationCtrl:reqMissionComplete(tasktypeid)
			do
				local loading = SoraDShowLoading(self.btnControl, self.btnControl:getContentSize())
				if loading.loadingImg then
					loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
				end
				loading:setPosition(cc.p(self.btnControl:getContentSize().width / 2, self.btnControl:getContentSize().height / 2))
			end
		end
	end
end
function allianceTaskView:onClick_icon_btn(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnReceive then
			local panel = SoraDCreatePanel("allianceTaskItemDetail")
			panel:init(self.curItemData)
			panel:show()
		elseif button == self.btnUnreceive then
			SoraDShowMsgTip(i18n("common_text_3635"))
		end
	end
end
function allianceTaskView:onClick_btn_log(button, event)
	if event == ccui.TouchEventType.ended then
		local panel = SoraDCreatePanel("allianceTaskLogView")
		panel:show()
	end
end
function allianceTaskView:sMsgAddScore(target, data)
end
function allianceTaskView:sMsgActivityClose(target, data)
	SoraDRemoveAllPanelFromManager()
end
return allianceTaskView

local publicRead = include("publicRead")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local sinbadTreasureView = class("sinbadTreasureView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sinbadTreasureView")
	end
	return target
end)
_UPVALUE5_ = "sinbadTreasureView"
;("sinbadTreasureView")[1] = "icon_Sinbad_box_01.png"
;("sinbadTreasureView")[2] = "icon_Sinbad_box_02.png"
;("sinbadTreasureView")[3] = "icon_Sinbad_box_03.png"
;("sinbadTreasureView")[4] = "icon_Sinbad_box_04.png"
local ("sinbadTreasureView")[5], boxIndex = "icon_Sinbad_box_05.png", "sinbadTreasureView"
function sinbadTreasureView:ctor()
	self:initControls()
	self:fitDevice()
end
function sinbadTreasureView:showMapPieceEffect()
	local effectLamp = SoraDCreatAnimation("Node_Effect_xbdmz01", nil, false)
	self.effectLamp = effectLamp
	effectLamp:setPosition(cc.p(320, -220))
	self.Node_map:addChild(effectLamp, 1)
	local activityData = sinbadTreasureCtrl:getActivityData()
	local level = activityData.notifiedKingdomDecorateLv
	local img1 = SoraDGetChildByName(effectLamp, "dh_Tex_XL_xbdmz01")
	local img2 = SoraDGetChildByName(effectLamp, "dh_Tex_XL_xbdmz02")
	local img3 = SoraDGetChildByName(effectLamp, "dh_Tex_XL_xbdmz03")
	local img4 = SoraDGetChildByName(effectLamp, "dh_Tex_XL_xbdmz04")
	local img5 = SoraDGetChildByName(effectLamp, "dh_Tex_XL_xbdmz05")
	_UPVALUE5_ = "dh_Tex_XL_xbdmz05"
	;("dh_Tex_XL_xbdmz05")[1] = img1
	;("dh_Tex_XL_xbdmz05")[2] = img2
	;("dh_Tex_XL_xbdmz05")[3] = img3
	;("dh_Tex_XL_xbdmz05")[4] = img4
	;("dh_Tex_XL_xbdmz05")[5] = img5
	for i, v in ipairs("dh_Tex_XL_xbdmz05") do
		v:setVisible(level >= i)
	end
end
function sinbadTreasureView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_INIT", function(target, data)
		SoraDCloseLoading(self)
		self.boxInfo = sinbadTreasureRead.getStageRewardInfo(sinbadTreasureCtrl:getClassType())
		dump(self.boxInfo, "self.boxInfo")
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_UPDATE_LV_POP_WINDOW", function(target, data)
		self:showMapPieceEffect()
		_ENV = self
		self[1] = cca.delay(0.75)
		self[2] = cca.callFunc(function()
			self:refreshMapDisplay()
		end)
		self[3] = cca.callFunc(function()
			self:refreshMapDisplay()
		end)
		local seq = cca.seq(self)
		self:runAction(seq)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_SCORE_UPDATE", function(target, data)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_STAGE_REWARD_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function sinbadTreasureView:fitDevice()
	self.Size_Tile_Image_bg:setHeight(1386)
	if device.isIphoneXMode() then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 320)
		self.Text_global_rice_num:setPositionY(self.Text_global_rice_num:getPositionY() + 50)
		self.Sprite_icon_global:setPositionY(self.Sprite_icon_global:getPositionY() + 50)
		self.Node_progress:setPositionY(self.Node_progress:getPositionY() + 50)
		return
	end
	if display.height > 1136 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 310)
		self.Text_global_rice_num:setPositionY(self.Text_global_rice_num:getPositionY() + 50)
		self.Sprite_icon_global:setPositionY(self.Sprite_icon_global:getPositionY() + 50)
		self.Node_progress:setPositionY(self.Node_progress:getPositionY() + 50)
		return
	end
	if display.height > 960 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 180)
		self.Text_global_rice_num:setPositionY(self.Text_global_rice_num:getPositionY() + 50)
		self.Sprite_icon_global:setPositionY(self.Sprite_icon_global:getPositionY() + 50)
		self.Node_progress:setPositionY(self.Node_progress:getPositionY() + 50)
	elseif display.height <= 960 then
		self.frame_text_ins_one:setVisible(false)
	end
end
function sinbadTreasureView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.cellList, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001349"))
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	self.Button_get:setTitleText(i18n("Sinbad_text_09"))
	self.btnHelpTip:addTouchEventListener(handler(self, self.btnTipClick))
	self.Button_get:addTouchEventListener(handler(self, self.btnFindClick))
	self.tableMapPiece = SoraDGetChildsArrayByName(self, "bg_map_", 5, 1)
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(false)
	end
	self.LoadingBar_progress_0:setPercent(100)
	self.Text_time = SoraDChangeTextToHtml(self.Text_time)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, ticket
			_ENV, (nil).time, (nil).color = nil, nil, "#5AB440"
			;(nil).__default, (nil).color = nil, "#FFC864"
			return i18n_html("Sinbad_text_05", nil, nil)
		end)
		self.Text_time:setTimeEndListener(function()
		end)
		self.Text_time:beginTime(leftTime)
		self.icon_hourglass_10:setPositionX(self.Text_time:getPositionX() + SoraDFSign(self.Text_time:getContentSize().width / 2) + SoraDFSign(30))
	end
	sinbadTreasureCtrl:reqInitInfo()
	SoraDShowLoading(self)
end
function sinbadTreasureView:initData()
	if not self.boxInfo then
		return
	end
	local activityData = sinbadTreasureCtrl:getActivityData()
	local kingdomPoint = activityData.kingdomDecoratePoint
	local selfPoint = activityData.selfDecoratePoint
	sinbadTreasureCtrl = nil
	;(nil).var = string.formatnumberthousands(selfPoint)
	self.Text_own_rice_num:setString(i18n("Sinbad_text_30", nil))
	sinbadTreasureCtrl = i18n("Sinbad_text_30", nil)
	i18n("Sinbad_text_30", nil).var = string.formatnumberthousands(kingdomPoint)
	self.Text_global_rice_num:setString(i18n("Sinbad_text_10", i18n("Sinbad_text_30", nil)))
	self.Sprite_icon_global:setPositionX(self.Text_global_rice_num:getPositionX() + SoraDFSign(self.Text_global_rice_num:getContentSize().width / 2) + SoraDFSign(30))
	self.Sprite_icon:setPositionX(self.Text_own_rice_num:getPositionX() + SoraDFSign(self.Text_own_rice_num:getContentSize().width / 2) + SoraDFSign(30))
	self:initProgress(kingdomPoint)
	self:refreshRedPoint()
	self:refreshMapDisplay()
end
function sinbadTreasureView:refreshMapDisplay()
	local activityData = sinbadTreasureCtrl:getActivityData()
	local level = activityData.notifiedKingdomDecorateLv
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(i <= level)
	end
end
function sinbadTreasureView:refreshRedPoint()
	local isShow, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	self.Image_redPoint:setVisible(isShow)
	self.Text_redPointInt:setString(num)
end
function sinbadTreasureView:initProgress(kingdomPoint)
	local passIndex = 0
	local singlePassPercent = 1 / (#self.boxInfo - 1) * 100
	for _, v in ipairs(self.cellList) do
		v:setVisible(false)
	end
	for i, v in ipairs(self.boxInfo) do
		local cell
		local _cell = self.cellList[i]
		if _cell then
			cell = _cell
		else
			cell = self.node_single:clone()
			cell:addTo(self.LoadingBar_progress)
			table.insert(self.cellList, cell)
		end
		local posX = SoraDFIsRA() and 510 - 510 / (#self.boxInfo - 1) * (i - 1) or 510 / (#self.boxInfo - 1) * (i - 1)
		cell:setPosition(posX, 11)
		cell:setVisible(true)
		if i == 1 then
			cell:setPositionX(cell:getPositionX() - SoraDFSign(15))
		elseif i == 5 then
			cell:setPositionX(cell:getPositionX() + SoraDFSign(15))
		end
		local imgIcon = SoraDGetChildByName(cell, "imgIcon")
		local Text_num = SoraDGetChildByName(cell, "Text_num")
		local Text_box_name = SoraDGetChildByName(cell, "Text_box_name")
		local btnPreview = SoraDGetChildByName(cell, "btnPreview")
		local Sprite_xwjyd = SoraDGetChildByName(cell, "Sprite_xwjyd")
		local icon_czhl_g_4 = SoraDGetChildByName(cell, "icon_czhl_g_4")
		local isClaimed = sinbadTreasureCtrl:isClaimedReward(i)
		imgIcon:setSpriteFrame(boxIndex[i])
		imgIcon:setScale(1.0)
		imgIcon:setPositionY(0)
		icon_czhl_g_4:setVisible(false)
		imgIcon:setColor(cc.c3b(255, 255, 255))
		Sprite_xwjyd:setVisible(false)
		Sprite_xwjyd:stopAllActions()
		Sprite_xwjyd:setRotation(0)
		imgIcon:stopAllActions()
		imgIcon:setRotation(0)
		if kingdomPoint >= v.num and not isClaimed then
			Sprite_xwjyd:setVisible(true)
			Sprite_xwjyd:stopAllActions()
			Sprite_xwjyd:setRotation(0)
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255)[1] = cca.rotateBy(2.25, 360)
			cc.c3b(255, 255, 255)[2] = cca.rotateBy(2.25, 360)
			cc.c3b(255, 255, 255)[3] = cca.rotateBy(2.25, 360)
			cc.c3b(255, 255, 255)[4] = cca.rotateBy(2.25, 360)
			cc.c3b(255, 255, 255)[5] = cca.rotateBy(2.25, 360)
			Sprite_xwjyd:runAction(cca.repeatForever(cca.seq(cc.c3b(255, 255, 255))))
			imgIcon:stopAllActions()
			imgIcon:setRotation(0)
			_UPVALUE6_ = imgIcon
			imgIcon[1] = cca.rotateTo(0.25, 12)
			imgIcon[2] = cca.rotateTo(0.2, -8)
			imgIcon[3] = cca.rotateTo(0.2, 6)
			imgIcon[4] = cca.rotateTo(0.15, -3)
			imgIcon[5] = cca.rotateTo(0.15, 1)
			imgIcon[6] = cca.rotateTo(0.15, 0)
			imgIcon[7] = cca.delay(0.6)
			imgIcon[8] = cca.delay(0.6)
			local seq = cca.seq(imgIcon)
			imgIcon:runAction(cc.RepeatForever:create(seq))
		end
		if isClaimed then
			icon_czhl_g_4:setVisible(true)
			imgIcon:setColor(cc.c3b(123, 123, 123))
		end
		Text_num:setString(string.formatnumberthousands(v.num))
		Text_box_name:setString(i18n(v.name))
		btnPreview:addTouchEventListener(handler(self, self.buttonGetRewardCallBack))
		btnPreview:setTag(i)
		if kingdomPoint >= v.num then
			passIndex = passIndex + 1
		end
	end
	if kingdomPoint <= self.boxInfo[1].num then
		self.LoadingBar_progress:setPercent(0)
	elseif passIndex < #self.boxInfo then
		local littlePercent = (kingdomPoint - self.boxInfo[passIndex].num) / (self.boxInfo[passIndex + 1].num - self.boxInfo[passIndex].num) * singlePassPercent
		self.LoadingBar_progress:setPercent(singlePassPercent * (passIndex - 1) + littlePercent)
	else
		self.LoadingBar_progress:setPercent(100)
	end
end
function sinbadTreasureView:buttonGetRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sinbadTreasurePreviewRewardView")
		panel:initData(button:getTag())
		panel:show()
	end
end
function sinbadTreasureView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Sinbad_text_04"
		;("Sinbad_text_04").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Sinbad_text_04"), "Sinbad_text_04")
	end
end
function sinbadTreasureView:btnFindClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sinbadTreasureTaskView")
		panel:show()
	end
end
function sinbadTreasureView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
	end
end
return sinbadTreasureView

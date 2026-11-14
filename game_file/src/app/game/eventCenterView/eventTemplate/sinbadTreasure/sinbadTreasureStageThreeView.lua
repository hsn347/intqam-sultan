local publicRead = include("publicRead")
local sinbadTreasureRead = include("sinbadTreasureRead")
local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local sinbadTreasureStageThreeView = class("sinbadTreasureStageThreeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sinbadTreasureStageThreeView")
	end
	return target
end)
function sinbadTreasureStageThreeView:ctor()
	self:initControls()
	self:fitDevice()
	self:initEffect()
end
function sinbadTreasureStageThreeView:initEffect()
	local effectOne = SoraDCreatAnimation("xinbade", nil, true)
	effectOne:setPosition(cc.p(0, -45))
	self.Node_rank_1:addChild(effectOne)
	local img1 = SoraDGetChildByName(effectOne, "Sprite_10")
	local img2 = SoraDGetChildByName(effectOne, "Sprite_10_0")
	local img3 = SoraDGetChildByName(effectOne, "Sprite_12")
	img1:setPositionX(img1:getPositionX() - 5)
	img2:setPositionX(img2:getPositionX() + 5)
	img3:setPositionY(img3:getPositionY() - 5)
end
function sinbadTreasureStageThreeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_GLOBAL_RANK_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function sinbadTreasureStageThreeView:fitDevice()
	self.Size_Tile_Image_bg:setHeight(1386)
	if device.isIphoneXMode() then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 320)
		return
	end
	if display.height > 1136 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 340)
		return
	end
	if display.height > 960 then
		self.Size_Tile_Image_bg:setPositionY(self.Size_Tile_Image_bg:getPositionY() + 180)
	elseif display.height <= 960 then
	end
end
function sinbadTreasureStageThreeView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001349"))
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	self.Text_rank:setString(i18n("common_text_851"))
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
			return i18n_html("Sinbad_text_25", nil, nil)
		end)
		self.Text_time:setTimeEndListener(function()
		end)
		self.Text_time:beginTime(leftTime)
		self.icon_hourglass_10:setPositionX(self.Text_time:getPositionX() + SoraDFSign(self.Text_time:getContentSize().width / 2) + SoraDFSign(30))
	end
	self.Text_name:setString(i18n("Sinbad_text_24"))
	self.Button_rank:addTouchEventListener(handler(self, self.btnRankClick))
	self.Image_head_1:addTouchEventListener(handler(self, self.btnHeadClick))
	self.btnHelpTip:addTouchEventListener(handler(self, self.btnTipClick))
	sinbadTreasureCtrl:reqInitInfo()
	sinbadTreasureCtrl:reqGlobalRank()
	SoraDShowLoading(self)
end
function sinbadTreasureStageThreeView:initData()
	local topRankInfo, remainRankInfo = sinbadTreasureCtrl:getAllianceRankInfo()
	self.Image_head_1:setContentSize(cc.size(68, 86))
	self.Image_head_1:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Text_score_1:setString(i18n("herobattle_text_05"))
	if topRankInfo[1] then
		self.Image_head_1:setContentSize(cc.size(120, 120))
		SoraDGetHeadFromManager(self.Image_head_1, topRankInfo[1].headid, topRankInfo[1].avatar)
		local firstName = topRankInfo[1].name
		self.Text_player_name:setString(firstName .. " " .. "#" .. topRankInfo[1].kid)
		if topRankInfo[1].allianceAbb then
			self.Text_player_alliance:setString(_q(topRankInfo[1].allianceAbb))
		end
		self.Text_score_1:setString(i18n("Sinbad_text_21"))
		self.Text_score_1_Value:setString(string.formatnumberthousands(topRankInfo[1].score))
	end
end
function sinbadTreasureStageThreeView:btnHeadClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local topRankInfo, remainRankInfo = sinbadTreasureCtrl:getAllianceRankInfo()
		if topRankInfo and topRankInfo[1] then
			_ENV = nil
			;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;(nil).playerID = topRankInfo[1].uid
			;(nil).kid = topRankInfo[1].kid
			SoraDSendMessage(nil)
		end
	end
end
function sinbadTreasureStageThreeView:btnRankClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sinbadTreasureRankView")
		panel:show()
	end
end
function sinbadTreasureStageThreeView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Sinbad_text_04"
		;("Sinbad_text_04").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Sinbad_text_04"), "Sinbad_text_04")
	end
end
function sinbadTreasureStageThreeView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
	end
end
return sinbadTreasureStageThreeView

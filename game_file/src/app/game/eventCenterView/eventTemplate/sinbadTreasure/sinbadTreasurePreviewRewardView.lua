local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sinbadTreasureRead = include("sinbadTreasureRead")
local publicRead = include("publicRead")
local sinbadTreasurePreviewRewardView = class("sinbadTreasurePreviewRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sinbadTreasurePreviewRewardView")
	end
	return target
end)
_UPVALUE5_ = "sinbadTreasurePreviewRewardView"
;("sinbadTreasurePreviewRewardView")[1] = "frame_Sinbad_box_01.png"
;("sinbadTreasurePreviewRewardView")[2] = "frame_Sinbad_box_02.png"
;("sinbadTreasurePreviewRewardView")[3] = "frame_Sinbad_box_03.png"
;("sinbadTreasurePreviewRewardView")[4] = "frame_Sinbad_box_04.png"
local ("sinbadTreasurePreviewRewardView")[5], boxImage = "frame_Sinbad_box_05.png", "sinbadTreasurePreviewRewardView"
function sinbadTreasurePreviewRewardView:ctor()
	self:initWidget()
	self:fitDevice()
end
function sinbadTreasurePreviewRewardView:fitDevice()
	self.Panel_cut:setPositionY(display.height / 2)
end
function sinbadTreasurePreviewRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_STAGE_REWARD_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		SoraDShowMsgTip(i18n("Outstanding_text_07"))
		self:refreshButtonState()
	end)
end
function sinbadTreasurePreviewRewardView:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_Finish:setString(i18n("common_text_1892"))
	SoraDSetTextWidthHeight(self.Text_cur_reward, cc.size(500, 60))
	self.Button_go:addTouchEventListener(handler(self, self.buttonGetCallBack))
	self.tableOpenReward = SoraDGetChildsArrayByName(self.Panel_cut, "btn_reward_", 8, 1)
	self.tableImageNode = SoraDGetChildsArrayByName(self.Panel_cut, "Image_reward_", 8, 1)
	for i, v in ipairs(self.tableOpenReward) do
		v:addTouchEventListener(handler(self, self.OnTreasureClick))
	end
	self.tableMapPiece = SoraDGetChildsArrayByName(self, "bg_map_", 5, 1)
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(false)
	end
end
function sinbadTreasurePreviewRewardView:initData(index)
	local boxInfo = sinbadTreasureRead.getStageRewardInfo(sinbadTreasureCtrl:getClassType())
	local curBoxInfo = boxInfo[index]
	if not curBoxInfo then
		return
	end
	self.rewardIndex = index
	self.curBoxInfo = curBoxInfo
	self.Button_box_reward:loadTextures(boxImage[index], boxImage[index], boxImage[index], ccui.TextureResType.plistType)
	self.Text_name:setString(i18n(curBoxInfo.name))
	sinbadTreasureRead = i18n(curBoxInfo.name)
	i18n(curBoxInfo.name).var = i18n(curBoxInfo.name)
	self.Text_ins:setString(i18n("Sinbad_text_06", i18n(curBoxInfo.name)))
	sinbadTreasureRead = i18n("Sinbad_text_06", i18n(curBoxInfo.name))
	i18n("Sinbad_text_06", i18n(curBoxInfo.name)).var = i18n(curBoxInfo.name)
	self.Text_cur_reward:setString(i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name))))
	_ENV = i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name)))
	i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name)))[1] = "id"
	i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name)))[2] = "count"
	i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name)))[3] = "rate"
	local rewardList = serviceFunctions.tableFormat(curBoxInfo.lotteryValue, i18n("Sinbad_text_07", i18n("Sinbad_text_06", i18n(curBoxInfo.name))))
	for i, v in ipairs(rewardList) do
		self.tableImageNode[i]:setSpriteFrame(publicRead.getIcon(v.id))
		self.tableImageNode[i]:setScale(0.8)
	end
	for i, v in ipairs(rewardList) do
		self.tableOpenReward[i]:setEnabled(true)
		self.tableOpenReward[i]:setTag(v.id)
	end
	local activityData = sinbadTreasureCtrl:getActivityData()
	for i, v in ipairs(self.tableMapPiece) do
		v:setVisible(i <= self.rewardIndex)
	end
	boxImage = ipairs(self.tableMapPiece)
	ipairs(self.tableMapPiece)[1] = "id"
	ipairs(self.tableMapPiece)[2] = "count"
	local globalRewardList = serviceFunctions.tableFormat(curBoxInfo.reward, ipairs(self.tableMapPiece))
	for k, v in ipairs(globalRewardList) do
		local rewardCell = include("commonItemAward").new()
		rewardCell:setScale(0.8)
		rewardCell:setBaseScale(1.0)
		rewardCell:setOwnView(self)
		rewardCell:initData(v.id, v.count)
		if SoraDFIsRA() then
			rewardCell:setPosition(450 - (k - 1) * 120, 140)
		else
			rewardCell:setPosition(90 + (k - 1) * 120, 140)
		end
		rewardCell:addTo(self.Panel_cut)
	end
	self:refreshButtonState()
end
function sinbadTreasurePreviewRewardView:refreshButtonState()
	local activityData = sinbadTreasureCtrl:getActivityData()
	local kingdomPoint = activityData.kingdomDecoratePoint
	local isClaimed = sinbadTreasureCtrl:isClaimedReward(self.rewardIndex)
	self.Button_go:setEnabled(kingdomPoint >= self.curBoxInfo.num and not isClaimed)
	self.Button_go:setBright(kingdomPoint >= self.curBoxInfo.num and not isClaimed)
	if kingdomPoint >= self.curBoxInfo.num then
		self.Button_go:setTitleText(not isClaimed and i18n("common_text_1146") or i18n("common_text_1892"))
	else
		self.Button_go:setTitleText(i18n("common_text_4120"))
	end
	self.Button_go:setVisible(not isClaimed)
	self.Node_Finish:setVisible(isClaimed)
end
function sinbadTreasurePreviewRewardView:OnTreasureClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCloseCommonTips()
	elseif eventType == ccui.TouchEventType.began then
		SoraDPlaySound()
		SoraDShowCommonTips(button, button:getTag())
	end
end
function sinbadTreasurePreviewRewardView:buttonGetCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityData = sinbadTreasureCtrl:getActivityData()
		local level = activityData.activityStage + 1
		if 1 < level then
			SoraDShowMsgTip(i18n("Sinbad_text_08"))
			SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("EventCenterView"))
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
			return
		end
		sinbadTreasureCtrl:reqStageOneReward(self.rewardIndex)
		SoraDShowLoading(self)
	end
end
return sinbadTreasurePreviewRewardView

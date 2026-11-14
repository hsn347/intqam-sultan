local MAX_AWARD_NUM = 4
local publicRead = include("publicRead")
local allianceActiveltCtrl = include("allianceActiveltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
_ENV = "mildGuideManager"
;("mildGuideManager")[1] = "frame_duihuanshangcheng_biaoti.png"
;("mildGuideManager")[2] = "frame_jwzjlyh_dhsd_dhtx.png"
;("mildGuideManager")[3] = "frame_duihuanshangcheng_biaoti01.png"
local ("mildGuideManager")[4], titlePng = "frame_duihuanshangcheng_biaoti02.png", "mildGuideManager"
local allianceActiveSingle = class("allianceActiveSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveSingle")
	end
	return target
end)
function allianceActiveSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Text_acceptNum = SoraDGetChildByName(self, "Text_acceptNum")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Image_shadow = SoraDGetChildByName(self, "Image_shadow")
	self.Image_shadow:setVisible(false)
	self.Button_publish = SoraDGetChildByName(self, "Button_publish")
	self.Button_publish = include("commonBtnInstance").new(self.Button_publish)
	self.Button_publish:setSwallowTouches(false)
	self.Button_publish:setTitleText(i18n("alliance_btn_01"))
	self.Button_accept = SoraDGetChildByName(self, "Button_accept")
	self.Button_accept = include("commonBtnInstance").new(self.Button_accept)
	self.Button_accept:setSwallowTouches(false)
	self.Button_accept:setTitleText(i18n("alliance_btn_02"))
	self.Button_accept:setVisible(false)
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go = include("commonBtnInstance").new(self.Button_go)
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:setVisible(false)
	self.Button_receive = SoraDGetChildByName(self, "Button_receive")
	self.Button_receive = include("commonBtnInstance").new(self.Button_receive)
	self.Button_receive:setSwallowTouches(false)
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:setVisible(false)
	self.ccs_btnRefresh = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_refresh")
	self.ccs_btnRefresh:setSwallowTouches(false)
	self.Button_publish:setHandle(handler(self, self.onPublishClick))
	self.Button_accept:setHandle(handler(self, self.onAcceptClick))
	self.Button_go:setHandle(handler(self, self.onGoClick))
	self.Button_receive:setHandle(handler(self, self.onReceiveClick))
	self.ccs_btnRefresh:addTouchEventListener(handler(self, self.onRefreshClick))
end
function allianceActiveSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	self.isPublish = otherData.isPublish or false
	self.Button_publish:setScroll(self.ownScroll)
	self.Button_accept:setScroll(self.ownScroll)
	self.Button_publish:setVisible(self.isPublish)
	self.ccs_btnRefresh:setVisible(self.isPublish)
	self.Button_go:setVisible(not self.isPublish)
	self.Button_accept:setVisible(not self.isPublish)
	self.Button_receive:setVisible(not self.isPublish)
	self.Text_status:setVisible(not self.isPublish)
	if not self.isPublish then
		self.Button_accept:setVisible(self.data.status == 1)
		self.Button_receive:setVisible(self.data.status == 3)
		self.Button_go:setVisible(self.data.status == 2)
		self.Text_status:setVisible(self.data.status == 0)
		self.Text_status:setString(i18n("common_text_2601"))
		self.Text_status:setColor(cc.c3b(0, 190, 30))
		self.Image_shadow:setVisible(self.data.status == 0)
		local isDoing = allianceActiveCtrl:isHaveDoingTask()
		self.Button_accept:setBright(not isDoing)
		self.Button_accept:setTouchEnabled(not isDoing)
		self.Text_acceptNum:setVisible(self.data.status == 2 or self.data.status == 1)
		if self.data.status == 2 then
			local curCount = allianceActiveCtrl:getCurTaskProgress(self.data.index)
			_ENV = cc.c3b(0, 190, 30)
			cc.c3b(0, 190, 30).count = string.formatnumberthousands(curCount)
			cc.c3b(0, 190, 30).total = string.formatnumberthousands(self.data.aim)
			self.Text_acceptNum:setString(i18n("common_text_3683", cc.c3b(0, 190, 30)))
		elseif self.data.status == 1 then
			_ENV = i18n("common_text_3683", cc.c3b(0, 190, 30))
			i18n("common_text_3683", cc.c3b(0, 190, 30)).num = allianceActiveCtrl:getTaskAcceptCount(self.data.index)
			i18n("common_text_3683", cc.c3b(0, 190, 30)).max = self.data.task.acceptLimit
			self.Text_acceptNum:setString(i18n("alliance_text_33", i18n("common_text_3683", cc.c3b(0, 190, 30))))
		end
	else
		self.Image_shadow:setVisible(false)
		self.Text_acceptNum:setVisible(true)
		_ENV = i18n("alliance_text_33", i18n("common_text_3683", cc.c3b(0, 190, 30)))
		i18n("alliance_text_33", i18n("common_text_3683", cc.c3b(0, 190, 30))).num = self.data.task.acceptLimit
		self.Text_acceptNum:setString(i18n("alliance_text_28", i18n("alliance_text_33", i18n("common_text_3683", cc.c3b(0, 190, 30)))))
	end
	self.Image_title:loadTexture(titlePng[self.data.task.quality], ccui.TextureResType.plistType)
	self.Text_title:setString(i18n(self.data.des))
	self.needGold = allianceActiveltCtrl.getActiveGold(allianceActiveCtrl:getRefreshCount() + 1)
	_ENV = allianceActiveCtrl
	allianceActiveCtrl.gold = self.needGold
	allianceActiveCtrl.title = i18n("common_text_911")
	self.ccs_btnRefresh:initData(allianceActiveCtrl)
	self.Button_publish:setEnabled(allianceActiveCtrl:getCurPublishNum() < ALLIANCE_ACTIVE_MAX_PUBLISH_NUM)
	self.Button_publish:setBright(allianceActiveCtrl:getCurPublishNum() < ALLIANCE_ACTIVE_MAX_PUBLISH_NUM)
	self.ccs_btnRefresh:setBright(allianceActiveCtrl:getCurPublishNum() < ALLIANCE_ACTIVE_MAX_PUBLISH_NUM)
	self.ccs_btnRefresh:setEnabled(allianceActiveCtrl:getCurPublishNum() < ALLIANCE_ACTIVE_MAX_PUBLISH_NUM)
	self:setReward()
end
function allianceActiveSingle:onPublishClick(button, event)
	if allianceActiveCtrl:getCurPublishNum() >= ALLIANCE_ACTIVE_MAX_PUBLISH_NUM then
		SoraDShowMsgTip(i18n("alliance_text_29"))
	else
		allianceActiveCtrl:publishTask(self.data.index)
	end
end
function allianceActiveSingle:onAcceptClick(button, event)
	if allianceActiveCtrl:getMyTodayAcceptNum() >= ALLIANCE_ACTIVE_PERSON_DAILY_MAX_ACCEPT_NUM then
		SoraDShowMsgTip(i18n("alliance_text_35"))
	elseif allianceActiveCtrl:getTaskAcceptCount(self.data.index) >= self.data.task.acceptLimit then
		SoraDShowMsgTip(i18n("alliance_text_34"))
	else
		local isAccepted = allianceActiveCtrl:isAcceptedTask(self.data.index, gametop.playertop_:getPlayerID())
		if isAccepted then
			SoraDShowMsgTip(i18n("alliance_text_51"))
		else
			allianceActiveCtrl:acceptTask(self.data.index)
		end
	end
end
function allianceActiveSingle:onGoClick(button, event)
	dump(self.data, "self.data=======")
	local ret = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
	if ret ~= false then
		SoraDRemoveAllPanelFromManager()
	end
end
function allianceActiveSingle:onReceiveClick(button, event)
	allianceActiveCtrl:receiveReward(self.data.index)
end
function allianceActiveSingle:onRefreshClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.ownScroll and not SoraDIsNodeVisibleOnScroll(button, self.ownScroll, event) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if SoraDEnoughGold(self.needGold) then
			allianceActiveCtrl:refreshTask(self.data.index)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function allianceActiveSingle:setReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(self.data.task.reward, nil)
	for k, v in ipairs(rewardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(-(k - 1) * 90, 0), 0)
			self.awardArray[k]:addTo(self.Node_item)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #rewardList then
		for i = #self.awardArray, #rewardList + 1, -1 do
			self.awardArray[i]:setVisible(false)
		end
	end
end
return allianceActiveSingle

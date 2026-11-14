local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local weaponSprctrumCtrl = SoraDGetCtrl("weaponSprctrumCtrl")
local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityMainView = class("equipActivityMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityMainView")
	end
	return target
end)
function equipActivityMainView:ctor()
	self.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("activity_name_9001258"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Node_percent = SoraDGetChildByName(self, "Node_percent")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.icon_g = SoraDGetChildByName(self, "icon_g")
	self.icon_g:setVisible(false)
	self.Node_spineBox = SoraDGetChildByName(self, "Node_spineBox")
	self.spine_box = sp.SkeletonAnimation:create("spine/baoxiang.skel", "spine/baoxiang.atlas", 1)
	self.spine_box:setPosition(0, 0)
	self.spine_box:addTo(self.Node_spineBox)
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.Node_barEffect = SoraDGetChildByName(self, "Node_barEffect")
	self.totalBar = display.newProgressTimer("#frame_bqp_bar_02.png", display.PROGRESS_TIMER_RADIAL)
	self.totalBar:setPosition(0, 0)
	self.totalBar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.totalBar:addTo(self.Node_bar)
	self.Text_leftTime = SoraDGetChildByName(self, "Text_leftTime")
	self.Text_leftTime:setString(i18n("rides_text_09"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("spectrum_text_02"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("equipActivityMainSingle")
	self.scroll:setVisbileShowScale(1.0)
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch = include("commonBtnInstance").new(self.Panel_touch)
	self.Panel_touch:setHandle(handler(self, self.onRewardTouchClick))
	self.Node_unity = SoraDGetChildByName(self, "Node_unity")
	self.Panel_tcut = SoraDGetChildByName(self, "Panel_tcut")
	self.Node_shader = SoraDGetChildByName(self, "Node_shader")
	self:initData()
	self:initTime()
	self:initEffect()
end
function equipActivityMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function equipActivityMainView:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function equipActivityMainView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function equipActivityMainView:initEffect()
	local et_jinzitaloading = SoraDGetChildByName(self, "et_jinzitaloading")
	et_jinzitaloading:setAutoCull(false)
	local et_jinzitaloading_09 = SoraDGetChildByName(self, "et_jinzitaloading_09")
	et_jinzitaloading_09:setAutoCull(false)
	local Node_etBgBox = SoraDGetChildByName(self, "Node_etBgBox")
	local et_bgBox = SoraDCreatAnimation("animationEquipTopBox")
	et_bgBox:addTo(Node_etBgBox)
	local Node_etBottom = SoraDGetChildByName(self, "Node_etBottom")
	local et_bottom = SoraDCreatAnimation("animationEquipBottom")
	et_bottom:addTo(Node_etBottom)
	local Node_rongyan = SoraDGetChildByName(self, "Node_rongyan")
	local et_ry = SoraDCreatAnimation("animationEquipRY")
	et_ry:addTo(Node_rongyan)
	local frame_round = SoraDGetChildByName(self, "frame_round")
	_ENV = nil
	;(nil)[1] = cca.rotateBy(120, 360)
	;(nil)[2] = cca.rotateBy(120, 360)
	;(nil)[3] = cca.rotateBy(120, 360)
	frame_round:runAction(cc.RepeatForever:create(cca.seq(nil)))
	self:initUnityEffect()
end
function equipActivityMainView:initUnityEffect()
	for k, v in pairs(weaponSprctrumRead.rongyanCfg) do
		SoraDCreateShaderEffect(v, self.Node_unity)
	end
	for k, v in pairs(weaponSprctrumRead.UICfg) do
		SoraDCreateShaderEffect(v, self.Node_shader)
	end
end
function equipActivityMainView:initData()
	self:suitData()
	_ENV = nil
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(189, 282), self.showData, 3, nil)
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	self:setTotalPercent()
end
function equipActivityMainView:suitData()
	self.showData, activityTaskComponentCtrl = nil, nil
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	for k, v in pairs(gWeaponTaskType) do
		local questList = weaponSprctrumRead.getTypeTask(v)
		local cur = 0
		for ki, vi in ipairs(questList) do
			if questData and questData.finishedQuest[tostring(vi.questID)] then
				cur = cur + 1
			end
		end
		activityTaskComponentCtrl = ipairs(questList)
		ipairs(questList).eType = v
		ipairs(questList).cur = cur
		ipairs(questList).total = #questList
		ipairs(questList).isClaimed = weaponSprctrumCtrl:getClaimStatus(v)
		table.insert(self.showData, ipairs(questList))
	end
	table.sort(self.showData, function(a, b)
		return a.eType < b.eType
	end)
end
function equipActivityMainView:setTotalPercent()
	local curPoint = weaponSprctrumCtrl:getWeaponPoint()
	local finalPoint = weaponSprctrumRead.getFinalRewardNum()
	weaponSprctrumCtrl = nil
	;(nil).member = string.formatnumberthousands(curPoint)
	;(nil).total = string.formatnumberthousands(finalPoint)
	self.Text_percent:setString(i18n("common_text_155", nil))
	SoraDToCenter(self.Node_percent, 2)
	local percent = curPoint * 100 / finalPoint
	local showPercent = 0.67 * percent + 16.5
	local showRotaion = SoraDFIsRA() and -2.4 * percent + 210 or 2.4 * percent - 30
	self.totalBar:setPercentage(showPercent)
	self.Node_barEffect:setRotation(showRotaion)
	local ret = false
	if curPoint >= finalPoint and not weaponSprctrumCtrl:isFinalRewardReceived() then
		ret = true
	end
	if weaponSprctrumCtrl:isFinalRewardReceived() then
		self.spine_box:clearTracks()
		self.spine_box:setColor(cc.c3b(120, 120, 120))
		self.icon_g:setVisible(true)
	else
		self.spine_box:clearTracks()
		self.spine_box:setAnimation(0, ret and "animation02" or "animation01", true)
		self.spine_box:setColor(cc.c3b(255, 255, 255))
		self.icon_g:setVisible(false)
	end
end
function equipActivityMainView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_3657"
		;("common_text_3657")[1] = i18n("spectrum_text_01")
		;("common_text_3657")[2] = i18n("spectrum_text_01")
		SoraDShowFixWindow(i18n("common_text_3657"), "common_text_3657")
	end
end
function equipActivityMainView:onRewardTouchClick(target, event)
	if weaponSprctrumCtrl:isFinalRewardReceived() then
		local panel = SoraDCreatePanel("equipActivityFinalView")
		panel:show()
	else
		local curPoint = weaponSprctrumCtrl:getWeaponPoint()
		local finalPoint = weaponSprctrumRead.getFinalRewardNum()
		if curPoint < finalPoint then
			local panel = SoraDCreatePanel("equipActivityFinalView")
			panel:show()
		else
			weaponSprctrumCtrl:sendReqGetWeaponFinalReward()
		end
	end
end
return equipActivityMainView

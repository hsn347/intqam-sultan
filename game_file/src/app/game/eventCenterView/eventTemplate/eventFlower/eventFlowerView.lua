local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventFlowerView = class("eventFlowerView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventFlowerView")
	end
	return target
end)
function eventFlowerView:ctor()
	_ENV = nil
	;(nil).aroma = 1
	_ENV, self.singleStyle, (nil).charm = nil, nil, 2
	;(nil).noReach = 1
	;(nil).received = 2
	self.awardData, _ENV, self.charmSingles, _ENV, self.aromaSingles, _ENV, self.personalData, _ENV, self.singleState, (nil).canReceive = nil, nil, nil, nil, nil, nil, nil, nil, nil, 3
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventFlowerFight")
	self.ccs_title:setTitle(i18n("common_text_3430"))
	self.ccs_title:setFontSize(24)
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_activity_show_flower.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.node_bg_effect = SoraDGetChildByName(self, "Node_bg_effect")
	self.node_bg_effect:setVisible(true)
	self.zhuzi = SoraDGetChildByName(self, "Bottom_Tile_Size_Image_zhuzi")
	self.zhuzi:setFillType(1)
	self.frame_lace = SoraDGetChildByName(self.zhuzi, "frame_lace")
	self.frame_lace:setPositionY(self.zhuzi:getContentSize().height - 25)
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_leftTime = SoraDGetChildByName(self.node_time, "Text_leftTime")
	self.text_leftTime:setString(i18n("common_text_943"))
	self.text_time = SoraDGetChildByName(self.node_time, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.lab_tip = SoraDGetChildByName(self, "Text_tip")
	self.lab_tip:setString(i18n("common_text_3437"))
	self.node_aroma = SoraDGetChildByName(self, "Node_label_left")
	local lab_aroma = SoraDGetChildByName(self.node_aroma, "Text_aroma")
	lab_aroma:setString(i18n("common_text_3433"))
	self.lab_sendFlower = SoraDGetChildByName(self.node_aroma, "Text_sendFlower")
	self.lab_rank_aroma = SoraDGetChildByName(self.node_aroma, "Text_rank")
	self.node_charm = SoraDGetChildByName(self, "Node_label_right")
	local lab_charm = SoraDGetChildByName(self.node_charm, "Text_charm")
	lab_charm:setString(i18n("common_text_3432"))
	self.lab_receiveFlower = SoraDGetChildByName(self.node_charm, "Text_receiveFlower")
	self.lab_rank_charm = SoraDGetChildByName(self.node_charm, "Text_rank")
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btn_aroma_rank = SoraDGetChildByName(self, "Button_aroma")
	self.btn_aroma_rank:setTitleText(i18n("common_text_3436"))
	SoraDAutoSizeButtonText(self.btn_aroma_rank, cc.size(194, 55))
	self.btn_aroma_rank:addTouchEventListener(handler(self, self.btnAromaClickCallBack))
	self.btn_charm_rank = SoraDGetChildByName(self, "Button_charm")
	self.btn_charm_rank:setTitleText(i18n("common_text_3435"))
	SoraDAutoSizeButtonText(self.btn_charm_rank, cc.size(194, 55))
	self.btn_charm_rank:addTouchEventListener(handler(self, self.btnCharmClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rewards")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH", handler(self, self.initData))
	self:initTime()
	self:initScroll()
	self:initAnimation()
	local personalData = newActivityCtrl:getFlowerActivityPersonalData()
	if not next(personalData) then
		newActivityCtrl:reqFlowerActivityInfo()
		SoraDShowLoading(self)
	else
		self:initData()
	end
end
function eventFlowerView:initTime()
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FLOWER_ACTIVITY_RANK)
	if activityTime then
		self.node_time:setVisible(true)
		self.text_time:beginTime(activityTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.node_time)
	end
end
function eventFlowerView:initData(target, data)
	SoraDCloseLoading(self)
	self.personalData = newActivityCtrl:getFlowerActivityPersonalData()
	local send_num = self.personalData.sendNum or 0
	_ENV = nil
	;(nil).num = send_num
	self.lab_sendFlower:setString(i18n("common_text_2304", nil))
	local rank_send = self.personalData.curSendRank or 0
	if rank_send < 1 then
		self.lab_rank_aroma:setString(i18n("common_text_827"))
	else
		_ENV = i18n("common_text_827")
		i18n("common_text_827").rank = rank_send
		self.lab_rank_aroma:setString(i18n("common_text_3409", i18n("common_text_827")))
	end
	local receive_num = self.personalData.receiveNum or 0
	_ENV = i18n("common_text_3409", i18n("common_text_827"))
	i18n("common_text_3409", i18n("common_text_827")).num = receive_num
	self.lab_receiveFlower:setString(i18n("common_text_3434", i18n("common_text_3409", i18n("common_text_827"))))
	local rank_receive = self.personalData.curReceiveRank or 0
	if rank_receive < 1 then
		self.lab_rank_charm:setString(i18n("common_text_827"))
	else
		_ENV = i18n("common_text_827")
		i18n("common_text_827").rank = rank_receive
		self.lab_rank_charm:setString(i18n("common_text_3409", i18n("common_text_827")))
	end
	self:initView()
	if data and data.index and data.style then
		self:showGetAwards(data.style, data.index)
	end
end
function eventFlowerView:initScroll()
	self.aromaData = newActivityCtrl:getFlowerActivityAward(self.singleStyle.aroma)
	self.charmData = newActivityCtrl:getFlowerActivityAward(self.singleStyle.charm)
	self.awardData[self.singleStyle.aroma] = self.aromaData
	self.awardData[self.singleStyle.charm] = self.charmData
	local aromaGrade = table.nums(self.aromaData)
	local charmGrade = table.nums(self.charmData)
	local singleHeight = 150
	local scrollH = math.max(self.scroll:getContentSize().height, singleHeight * math.max(aromaGrade, charmGrade))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	local offsetY = 0
	if self.scroll:getContentSize().height > singleHeight * math.max(aromaGrade, charmGrade) then
		offsetY = (self.scroll:getContentSize().height - singleHeight * math.max(aromaGrade, charmGrade)) / 2
	end
	for k = aromaGrade, 1, -1 do
		local data = self.aromaData[k]
		local single = self:getSingleByStyle(self.singleStyle.aroma)
		single:setPosition(cc.p(15, scrollH - singleHeight * (aromaGrade - k + 1) - offsetY))
		single.isLast(k == aromaGrade)
		single.setScore(data.gears)
		single.setIndex(data.index)
		single:addTo(self.scroll, aromaGrade - k)
		self.aromaSingles[k] = single
		self.aromaSingles[k].setAward(data.award)
	end
	for k = charmGrade, 1, -1 do
		local data = self.charmData[k]
		local single = self:getSingleByStyle(self.singleStyle.charm)
		single:setPosition(cc.p(self.scroll:getContentSize().width - 15, scrollH - singleHeight * (charmGrade - k + 1) - offsetY))
		single.isLast(k == charmGrade)
		single.setScore(data.gears)
		single.setIndex(data.index)
		single:addTo(self.scroll, charmGrade - k)
		self.charmSingles[k] = single
		self.charmSingles[k].setAward(data.award)
	end
	self:initView()
end
function eventFlowerView:initView()
	self.personalData = newActivityCtrl:getFlowerActivityPersonalData()
	if next(self.personalData) then
		for k, v in ipairs(self.aromaSingles) do
			v.isFull(v.score <= self.personalData.sendNum, k == #self.aromaSingles)
			local percent = self:getPercentInListByNum(self.personalData.sendNum, k, self.aromaData)
			v.setPercent(percent)
			if self.personalData.awardFlag[v.index] then
				v.setStatus(self.singleState.received)
			elseif percent == 1 then
				v.setStatus(self.singleState.canReceive)
			else
				v.setStatus(self.singleState.noReach)
			end
		end
		for k, v in ipairs(self.charmSingles) do
			v.isFull(v.score <= self.personalData.receiveNum, k == #self.charmSingles)
			local percent = self:getPercentInListByNum(self.personalData.receiveNum, k, self.charmData)
			v.setPercent(percent)
			if self.personalData.awardFlag[v.index] then
				v.setStatus(self.singleState.received)
			elseif percent == 1 then
				v.setStatus(self.singleState.canReceive)
			else
				v.setStatus(self.singleState.noReach)
			end
		end
	end
end
function eventFlowerView:showGetAwards(style, index)
	local awardStyle = self.awardData[style]
	local _ENV, award
	for k, v in pairs(awardStyle) do
		if v.index == index then
			award = v.award
			break
		end
	end
	local _ENV, listItem = (for generator), pairs(awardStyle)
	for i = 1, table.nums(award) - 1, 2 do
		listItem[tostring(award[i])] = award[i + 1]
	end
	SoraDMailGainItems(listItem)
end
function eventFlowerView:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDShowHelpMsgTip(i18n("common_text_3431"))
	end
end
function eventFlowerView:btnAromaClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventFlowerRankView")
		panel:initView(self.singleStyle.aroma)
		panel:addTo(self, 99)
	end
end
function eventFlowerView:btnCharmClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventFlowerRankView")
		panel:initView(self.singleStyle.charm)
		panel:addTo(self, 99)
	end
end
function eventFlowerView:initAnimation()
	local spine_01 = sp.SkeletonAnimation:create("spine/cao01.skel", "spine/cao01.atlas", 1)
	spine_01:setPosition(cc.p(40, 20))
	spine_01:setAnimation(0, "animation", true)
	spine_01:addTo(SoraDGetChildByName(self, "Node_cao_left"))
	local spine_02 = sp.SkeletonAnimation:create("spine/cao01.skel", "spine/cao01.atlas", 1)
	spine_02:setScaleX(-1)
	spine_02:setPosition(cc.p(-40, 20))
	spine_02:setAnimation(0, "animation", true)
	spine_02:addTo(SoraDGetChildByName(self, "Node_cao_right"))
	local spine_03 = sp.SkeletonAnimation:create("spine/zuohua.skel", "spine/zuohua.atlas", 1)
	spine_03:setPosition(cc.p(-20, -100))
	spine_03:setAnimation(0, "animation", true)
	spine_03:addTo(SoraDGetChildByName(self, "Node_hua_left"), -1)
	local spine_04 = sp.SkeletonAnimation:create("spine/youhua.skel", "spine/youhua.atlas", 1)
	spine_04:setPosition(cc.p(-40, -100))
	spine_04:setAnimation(0, "animation", true)
	spine_04:addTo(SoraDGetChildByName(self, "Node_hua_right"), -1)
end
function eventFlowerView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FLOWER_ACTIVITY_RANK) then
		self:removeFromParent()
	end
end
function eventFlowerView:getPercentInListByNum(num, index, list)
	local percent = 0
	if index == 1 then
		percent = math.min(1, num / list[index].gears)
	elseif num >= list[index].gears then
		percent = 1
	elseif num == 0 or num < list[index - 1].gears then
		percent = 0
	else
		percent = (num - list[index - 1].gears) / (list[index].gears - list[index - 1].gears)
	end
	return percent
end
function eventFlowerView:getSingleByStyle(style)
	local single
	if style == self.singleStyle.aroma then
		single = SoraDGetChildByName(self, "Panel_single_left"):clone()
	elseif style == self.singleStyle.charm then
		single = SoraDGetChildByName(self, "Panel_single_right"):clone()
	end
	local btn_touch = SoraDGetChildByName(single, "Button_touch")
	btn_touch:addTouchEventListener(function(btn, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("rewardDetailView")
			panel:initData(single.awrad)
			panel:setBtnStatus(single.status)
			panel:setHandle(function()
				newActivityCtrl:reqGetFlowerRankAward(style, single.score)
			end)
			panel:addTo(self, 99)
		end
	end)
	local light = SoraDGetChildByName(single, "Image_light")
	local lab_score = SoraDGetChildByName(single, "Text_score")
	local flower = SoraDGetChildByName(single, "Image_flower")
	local img_get = SoraDGetChildByName(single, "Image_get")
	img_get:setVisible(false)
	function single.isLast(isLast)
		local line = SoraDGetChildByName(single, "Image_line")
		line:setVisible(not isLast)
		light:setVisible(not isLast)
	end
	function single.isFull(isFull, isLast)
		light:setVisible(isFull and not isLast)
		if isFull then
			lab_score:setColor(cc.c3b(45, 221, 53))
			flower:loadTexture("frame_flowerFight_blossom.png", ccui.TextureResType.plistType)
		else
			lab_score:setColor(cc.c3b(145, 145, 145))
			flower:loadTexture("frame_flowerFight_bud.png", ccui.TextureResType.plistType)
		end
	end
	function single.setScore(score)
		lab_score:setString(score)
		single.score = score
	end
	function single.setPercent(percent)
		local percent = percent or 0
		local Panel_score = single:getChildByName("Panel_score")
		Panel_score:setContentSize(cc.size(80, 80 * percent))
	end
	function single.setAward(award)
		single.awrad = award
	end
	function single.setIndex(index)
		single.index = index
	end
	function single.setStatus(status)
		single.removeEffect()
		if self.singleState.noReach == status then
			flower:getVirtualRenderer():setState(0)
			img_get:setVisible(false)
			img_get:stopAllActions()
		elseif self.singleState.received == status then
			flower:getVirtualRenderer():setState(1)
			img_get:setVisible(false)
			img_get:stopAllActions()
		elseif self.singleState.canReceive == status then
			flower:getVirtualRenderer():setState(0)
			img_get:setVisible(true)
			img_get:runAction(cc.RepeatForever:create(cca.rotateBy(2, 360)))
			single.showEffect()
		end
		single.status = status
	end
	function single.showEffect()
		single, single = nil, nil
		;(nil).plist = "et_huabanzds_06.plist"
		single, (nil).scale = nil, 1.33
		;(nil).x = 35
		single, single, (nil)[1], (nil).pos, (nil).y = nil, nil, nil, nil, 30
		local param_bg
		;(nil).plist = "et_huabanzds_07.plist"
		single, (nil).scale = nil, 1.17
		;(nil).x = 35
		;(nil)[1], (nil).pos, (nil).y = nil, nil, 30
		local param_top
		single.et_node_bg = SoraDCreateEffectNode(param_bg)
		single.et_node_bg:addTo(flower, -1)
		single.et_node_top = SoraDCreateEffectNode(param_top)
		single.et_node_top:addTo(flower, 1)
	end
	function single.removeEffect()
		if not tolua.isnull(single.et_node_bg) then
			single.et_node_bg:removeFromParent()
			single.et_node_bg = nil
		end
		if not tolua.isnull(single.et_node_top) then
			single.et_node_top:removeFromParent()
			single.et_node_top = nil
		end
	end
	return single
end
return eventFlowerView

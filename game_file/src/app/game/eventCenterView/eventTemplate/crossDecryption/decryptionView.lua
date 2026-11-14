local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local crossDecryptionCtrl = gametop.playertop_:getModule("crossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
_ENV = "crossDecryptionRead"
;("crossDecryptionRead").DOING = 1
;("crossDecryptionRead").COMLIETE = 2
local ("crossDecryptionRead").COMLIETE_DONE, taskStatus = 3, "crossDecryptionRead"
local decryptionView = class("decryptionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("decryptionView")
	elseif type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function decryptionView:ctor(target, eid)
	self.activityID = eid or gActivityTimeActivityID.CROSS_MISSION
	if gActivityTimeActivityID.NEW_CROSS_MISSION == self.activityID then
	elseif gActivityTimeActivityID.CROSS_MISSION == self.activityID then
	end
	crossDecryptionRead.init(self.activityID)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.text_alter_bottom = SoraDGetChildByName(self, "Text_alter")
	self.node_bottom_reward = SoraDGetChildByName(self, "Node_rewards")
	self.node_bottom_box = SoraDGetChildByName(self, "Node_box")
	self.node_content = SoraDGetChildByName(self, "Node_content")
	self.node_single_item = SoraDGetChildByName(self, "Node_single_item")
	self.node_single_box = SoraDGetChildByName(self, "Node_single_box")
	self.node_items = SoraDGetChildByName(self, "Node_items")
	self.node_high_fix = SoraDGetChildByName(self, "Node_high_fix")
	self.node_bottom = SoraDGetChildByName(self, "Bottom_Node")
	self.node_bottom_top = SoraDGetChildByName(self, "Node_bottom_top")
	self.img_pillar_l = SoraDGetChildByName(self, "Image_33")
	self.img_pillar_r = SoraDGetChildByName(self, "Image_33_0")
	self.img_carpet_l = SoraDGetChildByName(self, "Image_1")
	self.img_carpet_r = SoraDGetChildByName(self, "Image_1_0")
	self.img_bg_r = SoraDGetChildByName(self, "Image_18_0")
	self.img_bg_l = SoraDGetChildByName(self, "Image_18")
	self.img_bottom_bg = SoraDGetChildByName(self, "Image_4")
	self.img_bottom_frame = SoraDGetChildByName(self, "Image_144")
	self.img_frame_top = SoraDGetChildByName(self, "Image_76")
	self.img_bottom_sheer = SoraDGetChildByName(self, "Image_75")
	self.panel_sheer = SoraDGetChildByName(self, "Panel_5")
	self.panel_alter = SoraDGetChildByName(self, "Panel_3")
	self.panel_time = SoraDGetChildByName(self, "Panel_6")
	self.ccs_title:setTitle(i18n("activity_name_05"))
	self.text_alter_bottom:setString(i18n("decrypt_text_01"))
	self.itemSize = cc.size(115, 115)
	self.btn_help:addTouchEventListener(handler(self, self.btnRuleClick))
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	if self.Node_fire_L then
		local nodeFireL = SoraDGetCommonJetFireNode(true)
		nodeFireL:setPositionY(100)
		nodeFireL:addTo(self.Node_fire_L)
	end
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	if self.Node_fire_R then
		local nodeFireR = SoraDGetCommonJetFireNode(true)
		nodeFireR:setPositionY(100)
		nodeFireR:addTo(self.Node_fire_R)
	end
	self.boxTable, _ENV, self.taskTable, _ENV, self.bigRewardData, _ENV, self.taskData, _ENV = SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), SoraDGetCommonJetFireNode(true), nodeFireR
	self.curRow = nil
	self.timeLabel = nil
	self.lineVisible = true
	self:initData()
	self:initCommonView()
	self:fitDevice()
end
function decryptionView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_CROSS_GET_REWARD", function(target, data)
		self:initData()
		if data.index then
			self:setBoxAction(tostring(data.index), false)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_CROSS_UPDATE_TASK", function(target, data)
		print("MESSAGE_SERVER_CROSS_UPDATE_TASK")
		dump(data)
		if data.data then
			self:commitTaskAnimation(data.data)
		elseif data.taskChange then
			self:initData()
			self:refleshSingleView(data.taskChange)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if not clientEventMgr.judgeIsOpen(self.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function decryptionView:fitDevice()
	local dis = display.height - 960
	if 0 < dis then
		self.node_high_fix:setVisible(true)
		self.timeLabel:setPositionY(self.timeLabel:getPositionY() - 10)
		local pSize = self.img_pillar_l:getContentSize()
		self.img_pillar_l:setContentSize(cc.size(pSize.width, pSize.height + dis / 2))
		self.img_pillar_r:setContentSize(cc.size(pSize.width, pSize.height + dis / 2))
		self.img_carpet_l:setPositionY(self.img_carpet_l:getPositionY() - dis / 1.5)
		self.img_carpet_r:setPositionY(self.img_carpet_r:getPositionY() - dis / 1.5)
		local bSize = self.img_bg_r:getContentSize()
		self.img_bg_r:setContentSize(cc.size(bSize.width, bSize.height + dis / 1.5))
		self.img_bg_l:setContentSize(cc.size(bSize.width, bSize.height + dis / 1.5))
		self.node_bottom_top:setPositionY(self.node_bottom_top:getPositionY() + 60)
		local bBSize = self.img_bottom_bg:getContentSize()
		self.img_bottom_bg:setContentSize(cc.size(bBSize.width, bBSize.height + 60))
		local fSize = self.img_bottom_frame:getContentSize()
		self.img_bottom_frame:setContentSize(cc.size(fSize.width, fSize.height + 60))
		local pSize = self.panel_sheer:getContentSize()
		self.panel_sheer:setContentSize(cc.size(pSize.width, pSize.height + dis))
		self.panel_alter:setPositionY(self.panel_alter:getPositionY() - 10)
		self.node_content:setPositionY(self.node_content:getPositionY() - dis / 2.5)
		self.img_bottom_sheer:setPositionY(self.img_bottom_sheer:getPositionY() - dis + 80)
	elseif dis == 0 then
		self.node_high_fix:setVisible(false)
		self.node_content:setPositionY(self.node_content:getPositionY() + 30)
	else
		self.node_high_fix:setVisible(false)
		self.node_bottom:setPositionY(-20)
		self.img_frame_top:setVisible(false)
		self.timeLabel:setPositionY(self.timeLabel:getPositionY() + 40)
		self.panel_time:setPositionY(self.panel_time:getPositionY() + 40)
		self.node_content:setPositionY(self.node_content:getPositionY() + 86)
		self.img_bottom_sheer:setPositionY(self.img_bottom_sheer:getPositionY() - dis)
	end
end
function decryptionView:initData()
	self.taskData = crossDecryptionCtrl:getTaskData()
	if not crossDecryptionCtrl:getRewardData() then
		crossDecryptionCtrl = crossDecryptionCtrl:getRewardData()
	end
	self.rewardData = crossDecryptionCtrl:getRewardData()
	self.curRow = crossDecryptionCtrl:getRowNum()
	self.bigRewardData = crossDecryptionRead.getBigReward(crossDecryptionCtrl:getActivityType())
	crossDecryptionCtrl:checkFinishRowAndCol()
	table.sort(self.taskData, function(a, b)
		return a.index < b.index
	end)
end
function decryptionView:initCommonView()
	if self.bigRewardData then
		for k, v in ipairs(self.bigRewardData) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(self.node_bottom_reward)
			single:setOwnView(self)
			single:setScale(0.8)
			single:setBaseScale(1.0)
			local pos = 70 + k * 100
			if SoraDFIsRA() then
				pos = 570 - k * 100
			end
			single:setPositionX(pos)
			local posY = math.floor(k / 5) - 15
			if display.height - 960 > 0 then
				posY = math.floor(k / 5) + 15
			end
			single:setPositionY(posY)
			single:initData(v.id, v.count)
		end
	end
	if not self.timeLabel then
		local dis = display.height - 130
		_ENV, _ENV = nil, ipairs(self.bigRewardData)
		;(nil).x = 320
		ipairs(self.bigRewardData).pos, (nil).y = nil, dis
		ipairs(self.bigRewardData).fontSize = 20
		self.timeLabel = SoraDCreateHtmlRichText(ipairs(self.bigRewardData))
		self.timeLabel:addTo(self, 5)
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		local str
		local remainTime = eventTime.timerNode.timer:getRemainTime()
		_ENV = 570 - k * 100
		_ENV, _ENV, (570 - k * 100).time = remainTime, SoraDConvertSecondToString(remainTime), SoraDConvertSecondToString(remainTime)
		_ENV, SoraDConvertSecondToString(remainTime).time, remainTime.color = remainTime, remainTime, "#00FF00"
		SoraDConvertSecondToString(remainTime).__default, remainTime.color = remainTime, "#00FF00"
		str = i18n_html("common_text_4415", 570 - k * 100, (SoraDConvertSecondToString(remainTime)))
		_ENV = 570 - k * 100
		;(570 - k * 100).param = "#icon_hourglass.png"
		;(570 - k * 100).name = ""
		;(570 - k * 100).width = 30
		;(570 - k * 100).height = 31.4
		;(570 - k * 100).custom = "Sprite"
		;(570 - k * 100).offsety = 12
		;(570 - k * 100).scale = 0.7
		str = str .. SoraDWrapReplaceTag(570 - k * 100)
		self.timeLabel:setString(str)
		self.timeLabel:setVisible(true)
	end
	self:beginTime()
	self:initView()
end
function decryptionView:initView()
	if self.taskData then
		for k, v in pairs(self.taskData) do
			local single = self:createSingleItem(v, v.index)
			local posX = (v.index - 1) % self.curRow * self.itemSize.width + 58
			local posY = -math.floor((v.index - 1) / self.curRow) * self.itemSize.height - 60
			_ENV = nil
			;(nil).x = posX
			;(nil).y = posY
			single:setPosition(nil)
			if v.index % self.curRow == 0 and v.index ~= 0 then
				local box = self:createSingleBox(true, v.index)
				box:setPosition(posX + 100, posY)
			end
			if math.floor((v.index - 1) / self.curRow) == self.curRow - 1 then
				local box = self:createSingleBox(false, v.index)
				box:setPosition(posX, posY - 100)
			end
			self.taskTable[tostring(v.taskID)] = single
		end
	end
	self:refleshSingleView()
end
function decryptionView:refleshSingleView(changeTable)
	print("decryptionView:refleshSingleView")
	if crossDecryptionCtrl:checkBigAward() then
		local panel = SoraDCreatePanel("decryptionSpecialPopView")
		panel:initData(self.curRow * 2 + 1, crossDecryptionCtrl, crossDecryptionRead)
		panel:addTo(self, 100)
	end
	local changeSingleSatus = function(single, status)
		if status == taskStatus.DOING then
			single:setTaskCanReceive(false)
		elseif status == taskStatus.COMLIETE then
			single:setTaskCanReceive(true)
		elseif status == taskStatus.COMLIETE_DONE then
			single.touchBtn:setTouchEnabled(false)
			single.node_line:setVisible(true)
			single.node_first:setVisible(false)
			single:setTaskCanReceive(false)
		end
	end
	if not changeTable then
		for k, v in pairs(self.taskTable) do
			local status = self.taskData[k].taskStatus
			changeSingleSatus(v, status)
		end
	else
		for k, v in pairs(changeTable) do
			changeSingleSatus(self.taskTable[tostring(k)], v.taskStatus)
		end
	end
	if crossDecryptionCtrl:checkAllTaskComplete() and self.lineVisible then
		for k, v in pairs(self.taskTable) do
			v.node_line:setVisible(false)
		end
		self.lineVisible = false
	end
	self:reflashRowAndColStatus()
end
function decryptionView:reflashRowAndColStatus()
	crossDecryptionCtrl:checkFinishRowAndCol()
	local needReceiveBox = crossDecryptionCtrl:getNeedReceiveBox()
	dump(needReceiveBox, "needReceiveBox===", 10)
	if needReceiveBox then
		for k, v in ipairs(needReceiveBox) do
			self:setBoxAction(tostring(v), true)
		end
	end
end
function decryptionView:setBoxAction(idx, isReceiving)
	self:createRowAndLineAnimation()
	local single = self.boxTable[idx]
	if not single then
		return
	end
	single.nodeEffect:setVisible(isReceiving)
	if not isReceiving then
		self:setBoxSpriteFrame(single, true)
	end
	single.touchBox:setTouchEnabled(isReceiving)
end
function decryptionView:commitTaskAnimation(data)
	if self.taskTable[tostring(data.taskID)] then
		local single = self.taskTable[tostring(data.taskID)]
		single.touchBtn:setTouchEnabled(false)
		single.node_first:setVisible(false)
		local Sprite_aniTask = SoraDGetChildByName(single, "Sprite_aniTask")
		local frames = display.newFrames("dh_jiemikoh_%.2d.png", 1, 10)
		local animation = display.newAnimation(frames, 0.5 / #frames)
		Sprite_aniTask:playAnimationOnce(animation, true, function()
			self:initData()
			self = nil
			;(nil)[tostring(data.taskID)] = data
			self:refleshSingleView(nil)
		end)
	end
end
function decryptionView:createRowAndLineAnimation()
	local finishRow, finishCol = crossDecryptionCtrl:checkReceivedRowAndCol()
	for k, v in ipairs(finishRow) do
		local single = self.boxTable[tostring(k * 2 - 1)]
		if v >= self.curRow and not self.rewardData[tostring(k * 2 - 1)] then
			local frames = display.newFrames("dh_jiemikoh1_%.2d.png", 1, 12)
			local animation = display.newAnimation(frames, 1.3 / #frames)
			single.spriteAni:setVisible(true)
			single.spriteAni:setPositionX(-280)
			single.spriteAni:setScale(2.0, 1.68)
			single.spriteAni:stopAllActions()
			single.spriteAni:playAnimationForever(animation)
			single.aniPriti:setVisible(true)
			single.aniPriti:setPositionX(-250)
		else
			single.spriteAni:setVisible(false)
			single.aniPriti:setVisible(false)
			single.spriteAni:stopAllActions()
		end
	end
	for k, v in ipairs(finishCol) do
		local single = self.boxTable[tostring(k * 2)]
		if v >= self.curRow and not self.rewardData[tostring(k * 2)] then
			local frames = display.newFrames("dh_jiemikoh1_%.2d.png", 1, 12)
			local animation = display.newAnimation(frames, 1.3 / #frames)
			single.spriteAni:setVisible(true)
			single.spriteAni:setPositionY(280)
			single.spriteAni:setScale(2.0, 1.68)
			single.spriteAni:setRotation(90)
			single.spriteAni:stopAllActions()
			single.spriteAni:playAnimationForever(animation)
			single.aniPriti:setVisible(true)
			single.aniPriti:setPositionY(250)
			single.aniPriti:setRotation(180)
		else
			single.spriteAni:setVisible(false)
			single.aniPriti:setVisible(false)
			single.spriteAni:stopAllActions()
		end
	end
end
function decryptionView:createSingleItem(data, idx)
	local itemSingle = self.node_single_item:clone()
	local node_font = SoraDGetChildByName(itemSingle, "Node_font")
	itemSingle.text_idx = cc.Label:createWithCharMap("fonts/hzlh_font.png", 42, 60, 48)
	itemSingle.text_idx:setAnchorPoint(cc.p(0.5, 0.5))
	itemSingle.text_idx:addTo(node_font)
	itemSingle.text_idx:setString(tostring(idx))
	itemSingle.node_line = SoraDGetChildByName(itemSingle, "Node_line")
	itemSingle.node_first = SoraDGetChildByName(itemSingle, "Node_first")
	itemSingle.sprite_round = SoraDGetChildByName(itemSingle, "Sprite_1")
	itemSingle.sprite_square = SoraDGetChildByName(itemSingle, "Sprite_2")
	itemSingle.sprite_square:setVisible(false)
	itemSingle.sprite_round:setVisible(false)
	itemSingle.touchBtn = SoraDGetChildByName(itemSingle, "Image_touch")
	itemSingle.touchBtn:setTouchEnabled(true)
	itemSingle.touchBtn:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			local panel = SoraDCreatePanel("decryptionPopView")
			panel:initData(data, crossDecryptionCtrl, crossDecryptionRead)
			panel:show()
		end
	end)
	function itemSingle:setTaskCanReceive(_bool)
		itemSingle.sprite_round:setVisible(_bool)
		itemSingle.sprite_square:setVisible(_bool)
		if _bool then
			itemSingle.sprite_round:stopAllActions()
			itemSingle.sprite_square:stopAllActions()
			itemSingle.sprite_round:runAction(cca.repeatForever(cca.rotateBy(2, 360)))
			_ENV = cca.repeatForever(cca.rotateBy(2, 360))
			cca.repeatForever(cca.rotateBy(2, 360))[1] = cca.fadeTo(1, 0.5)
			cca.repeatForever(cca.rotateBy(2, 360))[2] = cca.fadeIn(0.5)
			cca.repeatForever(cca.rotateBy(2, 360))[3] = cca.fadeIn(0.5)
			itemSingle.sprite_square:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.rotateBy(2, 360)))))
		else
			itemSingle.sprite_round:stopAllActions()
			itemSingle.sprite_square:stopAllActions()
		end
	end
	itemSingle:addTo(self.node_items)
	return itemSingle
end
function decryptionView:createSingleBox(isHideTop, idx)
	local itemBox = self.node_single_box:clone()
	itemBox:addTo(self.node_items)
	if isHideTop then
		itemBox:setTag(math.floor(idx / 2) - 1)
	else
		itemBox:setTag(idx % 6 * 2)
	end
	itemBox.spriteBox = SoraDGetChildByName(itemBox, "Sprite_box")
	itemBox.spriteAni = SoraDGetChildByName(itemBox, "Sprite_animation") or display.newNode()
	itemBox.aniPriti = SoraDGetChildByName(itemBox, "Particle_27") or display.newNode()
	itemBox.aniPriti:setVisible(false)
	itemBox.nodeEffect = SoraDGetChildByName(itemBox, "Node_effect")
	itemBox.nodeEffect:setVisible(false)
	itemBox.touchBox = SoraDGetChildByName(itemBox, "Image_touch")
	itemBox.touchBox:setTouchEnabled(true)
	itemBox.touchBox:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			local curTag = itemBox:getTag()
			local panel = SoraDCreatePanel("decryptionRewardsPopView")
			_ENV = nil
			;(nil).idx = curTag
			;(nil).canReceived = crossDecryptionCtrl:checkCurBoxStatus(curTag)
			panel:initData(nil, crossDecryptionCtrl, crossDecryptionRead)
			panel:show()
		end
	end)
	self:setBoxSpriteFrame(itemBox, crossDecryptionCtrl:checkCurBoxOpen(itemBox:getTag()))
	local index = tostring(itemBox:getTag())
	if not self.boxTable[index] then
		self.boxTable[index], _ENV = itemBox:getTag()
	end
	self.boxTable[index] = itemBox
	local particle = SoraDGetChildByName(itemBox.nodeEffect, "Particle_15")
	SoraDMixtureGLONE(particle)
	return itemBox
end
function decryptionView:setBoxSpriteFrame(itemBox, open)
	local box = itemBox.spriteBox
	if open then
		box:setSpriteFrame("icon_Daily_reward_treasure_S_open.png")
	else
		box:setSpriteFrame("icon_Daily_reward_treasure_S_close.png")
	end
end
function decryptionView:btnRuleClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "activity_name_05"
		;("activity_name_05")[1] = i18n("decrypt_text_04")
		;("activity_name_05")[2] = i18n("decrypt_text_04")
		SoraDShowFixWindow(i18n("activity_name_05"), "activity_name_05")
	end
end
function decryptionView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function decryptionView:updateTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	local str
	local remainTime = eventTime.timerNode.timer:getRemainTime()
	if remainTime then
		activityShowCtrl = nil
		activityShowCtrl, activityShowCtrl, (nil).time = remainTime, SoraDConvertSecondToString(remainTime), SoraDConvertSecondToString(remainTime)
		activityShowCtrl, SoraDConvertSecondToString(remainTime).time, remainTime.color = remainTime, remainTime, "#00FF00"
		SoraDConvertSecondToString(remainTime).__default, remainTime.color = remainTime, "#00FF00"
		str = i18n_html("common_text_4415", nil, (SoraDConvertSecondToString(remainTime)))
		activityShowCtrl = nil
		;(nil).param = "#icon_hourglass.png"
		;(nil).name = ""
		;(nil).width = 30
		;(nil).height = 31.4
		;(nil).custom = "Sprite"
		;(nil).offsety = 12
		;(nil).scale = 0.7
		str = str .. SoraDWrapReplaceTag(nil)
	end
	if self.timeLabel then
		self.timeLabel:setString(str)
	end
end
function decryptionView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
return decryptionView

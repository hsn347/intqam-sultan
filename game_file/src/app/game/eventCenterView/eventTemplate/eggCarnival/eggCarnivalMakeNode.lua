local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local paintedEggCrazyCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
local eggCarnivalRead = include("eggCarnivalRead")
local eggCarnivalMakeNode = class("eggCarnivalMakeNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalMakeNode")
end)
function eggCarnivalMakeNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY
	self.mergeItem = 838301
	self.cemterNode = SoraDGetChildByName(self, "Center_Node")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("easterEgg_text_02"))
	self.textTime = SoraDGetChildByName(self.topNode, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.btnMake = SoraDGetChildByName(self.bottomNode, "Button_Make")
	self.btnMake:setTitleText(i18n("christmas_tree_btn_01"))
	self.btnMake:getTitleRenderer():setPositionY(45)
	self.btnMake:addTouchEventListener(handler(self, self.btnMakeClick))
	self.textNum = SoraDGetChildByName(self.btnMake, "Text_Num")
	self.itemNodeList = SoraDGetChildsArrayByName(self.cemterNode, "Node_", 4, 1)
	self.centerEffectNode = SoraDGetChildByName(self, "Center_Effect")
	self.downEffectNode = SoraDGetChildByName(self, "Down_Effect")
	self:initData()
end
function eggCarnivalMakeNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateFood))
	SoraDAddMessage(self, "MESSAGE_SERVER_MADELE_MAKEBACK", handler(self, self.runMergeAction))
end
function eggCarnivalMakeNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function eggCarnivalMakeNode:initEffect()
	SoraDGetChildByName(self, "Top_Particle_18"):setAutoCull(false)
	SoraDGetChildByName(self, "Top_Particle_11"):setAutoCull(false)
	local loop = true
	local cssFilePath = getCCSPath("eggCarnivalMakeNode")
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	self.centerEffect = SoraDCreatAnimationEx("eggCarnivalCenterEffect", nil, false)
	self.centerEffect:addTo(self.centerEffectNode)
	self.centerEffect.action:gotoFrameAndPause(0)
	self.downEffect = SoraDCreatAnimationEx("eggCarnivalDownEffect", nil, false)
	self.downEffect:addTo(self.downEffectNode)
	self.downEffect.action:gotoFrameAndPause(0)
	_ENV, _UPVALUE8_, self.fadeActionTag = self.downEffect.action, self.downEffect.action.gotoFrameAndPause, 301
	_ENV, self.downEffect.action.name = 0, "bg_cddkh_zs05"
	_ENV, (0).name = false, "bg_cddkh_zs03"
	_ENV, (false).name = nil, "bg_cddkh_zs03"
	_ENV, (nil).name = nil, "frame_cddkh_bk03"
	_ENV, (nil).name = nil, "frame_cddkh_bk01"
	_ENV, (nil).name = nil, "frame_cddkh_bk02"
	;(nil).name = "frame_cddkh_bk05"
	_ENV, (nil).scale = nil, -1
	;(nil).name = "frame_tree_zhuangshi03"
	;(nil).scale = -1
	self.downEffect.action.gotoFrameAndPause[1] = self.downEffect.action
	self.downEffect.action.gotoFrameAndPause[2] = 0
	self.downEffect.action.gotoFrameAndPause[3] = false
	self.downEffect.action.gotoFrameAndPause[4] = nil
	self.downEffect.action.gotoFrameAndPause[5] = nil
	self.downEffect.action.gotoFrameAndPause[6] = nil
	self.downEffect.action.gotoFrameAndPause[7] = nil
	local self.downEffect.action.gotoFrameAndPause[8], skelList = nil, self.downEffect.action.gotoFrameAndPause
	for i, v in ipairs(skelList) do
		local spine_zs05 = sp.SkeletonAnimation:create(string.format("spine/%s.skel", v.name), string.format("spine/%s.atlas", v.name), 1)
		if v.scale then
			spine_zs05:setScaleX(v.scale)
		end
		spine_zs05:setAnimation(0, "animation", true)
		spine_zs05:addTo(SoraDGetChildByName(self, "Node_spine_" .. i))
	end
end
function eggCarnivalMakeNode:initData()
	self:initEffect()
	self:initActivityTime()
	self.mergeConfig = backpackltCtrl:getMaterialOfMergeItem(self.mergeItem)
	for i, itemNode in ipairs(self.itemNodeList) do
		local itemIcon = SoraDGetChildByName(itemNode, "Sprite_Icon")
		local id = self.mergeConfig[i].id
		itemIcon:setSpriteFrame(publicRead.getIcon(id))
		local posY = itemIcon:getPositionY()
		_ENV = publicRead.getIcon(id)
		publicRead.getIcon(id)[1] = cca.moveTo(0.75, itemIcon:getPositionX(), posY + 8)
		publicRead.getIcon(id)[2] = cca.moveTo(0.75, itemIcon:getPositionX(), posY)
		publicRead.getIcon(id)[3] = cca.moveTo(0.75, itemIcon:getPositionX(), posY)
		publicRead.getIcon(id)[4] = cca.moveTo(0.75, itemIcon:getPositionX(), posY)
		publicRead.getIcon(id)[5] = cca.moveTo(0.75, itemIcon:getPositionX(), posY)
		itemIcon:runAction(cca.repeatForever(cca.seq(publicRead.getIcon(id))))
		local btnItem = SoraDGetChildByName(itemNode, "Button_ItemClick")
		btnItem:setTag(id)
		btnItem:addTouchEventListener(handler(self, self.btnClickItem))
		SoraDGetChildByName(itemNode, "Text_Name"):setString(i18n(publicRead.getName(id)))
		local textNum = SoraDGetChildByName(itemNode, "Text_Num")
		itemNode.textNum = SoraDChangeTextToHtml(textNum)
		itemNode.itemIcon = itemIcon
	end
	self:updateFood()
end
function eggCarnivalMakeNode:updateFood()
	local itemNum = backpackCtrl:getItemCount(self.mergeItem)
	backpackCtrl = nil
	;(nil).num = string.formatnumberthousands(itemNum)
	self.textNum:setString(i18n("common_text_063", nil))
	self.minHave = 1
	self.isCanMerge = true
	for i, itemNode in ipairs(self.itemNodeList) do
		itemNode.itemIcon:setOpacity(255)
		local have = backpackCtrl:getItemCount(self.mergeConfig[i].id)
		local textColor
		if have < self.mergeConfig[i].count then
			textColor = cc.c3b(245, 55, 55)
			self.isCanMerge = false
			itemNode.itemIcon:stopActionByTag(self.fadeActionTag)
			itemNode.itemIcon:setOpacity(38.25)
			_ENV = 38.25
			;(38.25)[1] = cca.fadeTo(0.75, 0.43)
			;(38.25)[2] = cca.fadeTo(0.75, 0.15)
			;(38.25)[3] = cca.fadeTo(0.75, 0.15)
			;(38.25)[4] = cca.fadeTo(0.75, 0.15)
			local action = cca.repeatForever(cca.seq(38.25))
			action:setTag(self.fadeActionTag)
			itemNode.itemIcon:runAction(action)
		else
			textColor = cc.c3b(255, 255, 255)
		end
		backpackCtrl = cca.seq(38.25)
		cca.seq(38.25).member = have
		backpackCtrl, backpackCtrl, cca.seq(38.25).total = cca.seq(38.25)
		backpackCtrl, self.mergeConfig[i].count.member, cca.seq(38.25).color = cca.seq(38.25)
		self.mergeConfig[i].count.__default, cca.seq(38.25).color = cca.seq(38.25)
		itemNode.textNum:setString(i18n_html("common_text_155", cca.seq(38.25)))
		if i == 1 then
			self.minHave = math.ceil(have / self.mergeConfig[i].count)
		else
			self.minHave = math.min(self.minHave, have / self.mergeConfig[i].count)
		end
	end
end
function eggCarnivalMakeNode:btnMakeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.isRunningAction then
			return
		end
		if not self.isCanMerge then
			SoraDShowMsgTip(i18n("madeleine_feast_text_04"))
			return
		end
		_ENV, _ENV = i18n("madeleine_feast_text_04")
		i18n("madeleine_feast_text_04").id = self.mergeItem
		i18n("madeleine_feast_text_04").itemData, i18n("madeleine_feast_text_04").count = i18n("madeleine_feast_text_04")
		i18n("madeleine_feast_text_04").msg = i18n("madeleine_feast_text_05")
		i18n("madeleine_feast_text_04").btnTitle = i18n("common_btn_20")
		i18n("madeleine_feast_text_04").handle = function(targe, data)
			paintedEggCrazyCtrl = nil
			;(nil).index = 45
			local (nil).count, data = data.num, nil
			paintedEggCrazyCtrl:reqPaintedEggCrazyShareMerge(data)
		end
		uiManager:show("newItemSingleUse", i18n("madeleine_feast_text_04"))
	end
end
function eggCarnivalMakeNode:btnClickItem(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local id = button:getTag()
		_ENV = button
		button[837901] = "easterEgg_text_08"
		button[838501] = "common_text_4439"
		local button[838001], msgTbl = "common_text_4450", button
		SoraDShowMsgTip(i18n(msgTbl[id]))
	end
end
function eggCarnivalMakeNode:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function eggCarnivalMakeNode:runMergeAction()
	self.isRunningAction = true
	self.centerEffectNode:stopAllActions()
	self.centerEffectNode:setPositionY(self:getPanelOffsetHeight() / 2)
	self.centerEffectNode:setScale(1)
	self.centerEffect.action:gotoFrameAndPlay(0, false)
	self.downEffect.action:gotoFrameAndPlay(0, false)
	_UPVALUE3_ = false
	;(false)[1] = cca.delay(0.6)
	;(false)[2] = cca.callFunc(function()
		for i, itemNode in ipairs(self.itemNodeList) do
			self = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.1)
			;(nil)[2] = cca.callFunc(function()
				itemNode.itemIcon:setVisible(false)
			end)
			;(nil)[3] = cca.callFunc(function()
				itemNode.itemIcon:setVisible(false)
			end)
			itemNode.itemIcon:runAction(cca.seq(nil))
		end
	end)
	;(false)[3] = cca.delay(1.2333333333333334)
	;(false)[4] = cca.callFunc(function()
		self = nil
		self = nil
		;(nil)[1] = cc.EaseExponentialIn:create(cca.moveTo(0.5, 320, -100))
		;(nil)[2] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[3] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[4] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[5] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[7] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[1] = cca.spawn(nil)
		;(nil)[2] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[3] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[4] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[5] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[6] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[7] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[8] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		local (nil)[9], action = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		self = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[1] = cca.moveTo(0.5, 320, self:getPanelOffsetHeight() / 2 + 70)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[2] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[3] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[4] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[5] = cca.scaleTo(0.5, 0.9)
		_ENV = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end).easing = "BACKOUT"
		transition.execute(self.centerEffectNode, cca.spawn(cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)), cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end))
		self.centerEffectNode:runAction(cca.seq(action))
	end)
	;(false)[5] = cca.callFunc(function()
		self = nil
		self = nil
		;(nil)[1] = cc.EaseExponentialIn:create(cca.moveTo(0.5, 320, -100))
		;(nil)[2] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[3] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[4] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[5] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[7] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.1))
		;(nil)[1] = cca.spawn(nil)
		;(nil)[2] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[3] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[4] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[5] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[6] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[7] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		;(nil)[8] = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		local (nil)[9], action = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		self = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[1] = cca.moveTo(0.5, 320, self:getPanelOffsetHeight() / 2 + 70)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[2] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[3] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[4] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)[5] = cca.scaleTo(0.5, 0.9)
		_ENV = cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)
		cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end).easing = "BACKOUT"
		transition.execute(self.centerEffectNode, cca.spawn(cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end)), cca.callFunc(function()
			for i, itemNode in ipairs(self.itemNodeList) do
				itemNode.itemIcon:setVisible(true)
				itemNode.itemIcon:setScale(1)
			end
			self.isRunningAction = false
		end))
		self.centerEffectNode:runAction(cca.seq(action))
	end)
	self:runAction(cca.seq(false))
end
return eggCarnivalMakeNode

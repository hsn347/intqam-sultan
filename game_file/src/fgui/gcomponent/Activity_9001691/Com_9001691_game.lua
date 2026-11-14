local baseComponent = require("fgui.base.baseComponent")
local Com_9001691_game = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001691_Read = include("activity_9001691_Read")
local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
fgui.register_extension("ui://Activity_9001691/Com_9001691_game", Com_9001691_game)
_ENV = fgui.register_extension
fgui.register_extension.ME = 1
local _ENV, fgui.register_extension.AI, SURPRISE_BOX_PLAYER = "ui://Activity_9001691/Com_9001691_game", 2, fgui.register_extension
;("ui://Activity_9001691/Com_9001691_game").KNOW = 1
;("ui://Activity_9001691/Com_9001691_game").HP = 2
local _ENV, ("ui://Activity_9001691/Com_9001691_game").LOCK, SURPRISE_BOX_ITEM = Com_9001691_game, 3, "ui://Activity_9001691/Com_9001691_game"
Com_9001691_game.AWARD = 1
local Com_9001691_game.TRAP, SURPRISE_BOX_TYPE = 2, Com_9001691_game
function Com_9001691_game:onInit()
	self:fixChildrenPos()
	self.fields.talkBg:fix()
	self.fields.n18:fix()
	self.fields.box:fix()
	self.fields.table:fix()
	self.spineScaleX = SoraDFIsRA() and 1 or -1
	self.fields.Usm_1:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Spine_1:setScaleX(self.spineScaleX)
	self.actionList, _ENV = self.fields.Spine_1.setScaleX, self.fields.Spine_1.setScaleX
	self.fields.my_item1:addClickEventListener(handler(self, self.onUseItemClick), 1)
	self.fields.my_item2:addClickEventListener(handler(self, self.onUseItemClick), 2)
	self.fields.my_item3:addClickEventListener(handler(self, self.onUseItemClick), 3)
	self.fields.Com_9001691_guideMask:addClickEventListener(handler(self, self.oGuideMaskClick))
	self.fields.list_myhp:setItemRenderer(handler(self, self.onMyHpRenderer))
	self.fields.list_aihp:setItemRenderer(handler(self, self.onAIHpRenderer))
	self.fields.list_myhpbg:setItemRenderer(handler(self, self.onHPBgRender))
	self.fields.list_aihpbg:setItemRenderer(handler(self, self.onHPBgRender))
	self.fields.button_open:setTitle(i18n("surprise_box_078"))
	self.fields.button_open:addClickEventListener(handler(self, self.onOpenBoxClick), 1)
	self.fields.button_switch:setTitle(i18n("surprise_box_079"))
	self.fields.button_switch:addClickEventListener(handler(self, self.onOpenBoxClick), 2)
	self.fields.text_open1:setString(i18n("surprise_box_054"))
	self.fields.text_open2:setString(i18n("surprise_box_055"))
	self.controllers.c1:setSelectedIndex(1)
end
function Com_9001691_game:onShow()
end
function Com_9001691_game:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001691_UPDATE", handler(self, self.onAddAction))
end
_ENV, Com_9001691_game.onShowAniEnd = function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end, function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end
;(function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end).useItem = true
;(function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end).openBox = true
;(function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end).aiUseItem = true
;(function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end).aiOpenBox = true
local (function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end).gameQuit, MSG_TYPE = true, function(self)
	self.fields.n43:setVisible(true)
	self.fields.n44:setVisible(true)
	self.fields.table:setVisible(true)
	self.fields.box:setVisible(true)
	self.fields.Spine_1:setVisible(true)
	self.fields.Spine_1:clearEffect()
	self.fields.Spine_1:setEffectPath("spine/jingxihezi.skel", "idle", true)
	self.fields.Spine_1:start("idle", true)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "hit" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
end
function Com_9001691_game:onAddAction(target, data)
	dump(data, "Com_9001691_game:onAddAction", 10)
	SoraDCloseLoading(self)
	if MSG_TYPE[data.msgType] then
		_UPVALUE2_ = self
		self[1] = self.isPlayerQuit
		self[2] = data.msgType
		dump(self, "Com_9001691_game:onAddAction")
		if self.isPlayerQuit then
			if data.msgType == "gameQuit" then
				self:gameQuit(data.msgData)
			end
			return
		end
		table.insert(self.actionList, data)
	end
end
function Com_9001691_game:startGame(data, hasGuided, quitCallback)
	self.curGuideIndex = nil
	self.transitions.t0:play(1, 0, 0, -1)
	self.quitCallback = quitCallback
	dump(data, "Com_9001691_game:startGame")
	self.curAction = data.msgData
	self.curLevel = self.curAction.level
	self.actionList, _ENV, self.lvCfg = activity_9001691_Read.getMainCfg(self.curLevel), activity_9001691_Read.getMainCfg(self.curLevel), activity_9001691_Read.getMainCfg(self.curLevel)
	self.isInGame = true
	self.isPlayerQuit = false
	self:stopTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:setActionEnd(true)
	self.isInAction = true
	self.isMyTurn = false
	self.lastScore = nil
	self.fields.Usm_1:clearEffect()
	self.fields.Spine_1:setVisible(false)
	self.fields.text_talk:setVisible(false)
	self.fields.talkBg:setVisible(false)
	self.fields.text_talk1:setVisible(false)
	self.fields.talkBg1:setVisible(false)
	self.fields.Com_hold1:setVisible(false)
	self.fields.Com_hold2:setVisible(false)
	self.fields.Com_item1Effect:setVisible(false)
	self.fields.my_hp_effect:setVisible(false)
	self.fields.ai_hp_effect:setVisible(false)
	self.fields.lightAni1:setVisible(false)
	self.fields.light1:setVisible(false)
	self.fields.lightAni2:setVisible(false)
	self.fields.light2:setVisible(false)
	self.fields.table:setVisible(false)
	self.fields.box:setVisible(false)
	self.fields.n43:setVisible(false)
	self.fields.n44:setVisible(false)
	self.fields.ani1:setVisible(false)
	self.fields.ani2:setVisible(false)
	self.fields.ani3:setVisible(false)
	self.fields.Spine_1:setScaleX(self.spineScaleX)
	self.fields.Spine_1:setScaleY(1)
	self:setIsInAction(false, true)
	if not hasGuided then
		self:showGuideStep()
	end
end
function Com_9001691_game:stopTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
end
function Com_9001691_game:setIsInAction(isInAction, isStartGame)
	local gameData = self.curAction.data.game
	_UPVALUE4_ = nil
	;(nil)[1] = self.isInAction
	;(nil)[2] = isInAction
	;(nil)[3] = #self.actionList
	;(nil)[4] = gameData.currPlayer
	dump(nil, "self.isInAction ~= isInAction")
	if self.isInAction ~= isInAction then
		if not isInAction and #self.actionList == 0 and gameData.currPlayer == SURPRISE_BOX_PLAYER.ME then
			if not self.isMyTurn then
				self.isMyTurn = true
				SoraDShowMsgTip(i18n("surprise_box_076"))
				dump(isStartGame, "isStartGame")
				self.isCanUseItem = true
				self.controllers.c1:setSelectedIndex(1)
				self.controllers.c2:setSelectedIndex(1)
				self.transitions.t2:play()
				self.fields.lightAni1:setVisible(false)
				self.fields.lightAni2:setVisible(false)
				self.fields.light1:setVisible(false)
				self.fields.light2:setVisible(false)
				self:showTalk(i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042"))
				local rewardCount = gameData.me.awardCount + gameData.ai.awardCount
				local trapCount = gameData.me.trapCount + gameData.ai.trapCount
				if not gameData.boxes then
					_ENV = gameData.boxes
				end
				for i, v in ipairs(gameData.boxes) do
					if v == 1 then
						rewardCount = rewardCount + 1
					elseif v == 2 then
						trapCount = trapCount + 1
					end
				end
				local round = math.ceil(gameData.boxIdx / (self.lvCfg.randomProp[1] + self.lvCfg.randomProp[2]))
				_ENV = i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")
				_ENV, _ENV, i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042").num = i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")
				;(self.lvCfg.randomProp[1] * round - rewardCount).num, i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042").size = i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")
				self.fields.text_reward:setString(i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")))
				_ENV = i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042"))
				_ENV, _ENV, i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")).num = i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042"))
				;(self.lvCfg.randomProp[2] * round - trapCount).num, i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042")).size = i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042"))
				self.fields.text_trap:setString(i18n_html("surprise_box_057", i18n_html("surprise_box_056", i18n(math.random(2) == 1 and "surprise_box_041" or "surprise_box_042"))))
				if not isStartGame then
					self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX * 0.95, 0.95))
					if self.lastRound ~= round then
						self.fields.ani1:setAllFrameNameOnce("dh_baoshi_add_%02d.png", 1, false)
						self.fields.ani2:setAllFrameNameOnce("dh_baoshi_add_%02d.png", 1, false)
						self.fields.ani3:setAllFrameNameOnce("dh_Tex_XL_bcxt0801_0%02d.png", 1, false)
						self.transitions.t5:play(1, 0, 0, -1)
					end
				end
				self.lastRound = round
			end
		elseif gameData.currPlayer ~= SURPRISE_BOX_PLAYER.ME and self.isMyTurn then
			self.isMyTurn = false
			self.fields.Spine_1:runAction(ffa.scaleTo(0.5, self.spineScaleX, 1.0))
			self.transitions.t3:play(1, 0, 0, -1, function()
				self.controllers.c1:setSelectedIndex(0)
				self.controllers.c2:setSelectedIndex(0)
			end)
			self:showTalk(i18n("surprise_box_044"))
			SoraDShowMsgTip(i18n("surprise_box_077"))
		end
	end
	self.isInAction = isInAction
end
function Com_9001691_game:updateTime(dt)
	if not self.isInGame then
		return
	end
	if self.isInAction or #self.actionList == 0 then
		return
	end
	self:setIsInAction(true)
	self.lastAction = self.curAction
	local action = self.actionList[1]
	self.curAction = action.msgData
	dump(action, "self.curAction", 10)
	table.remove(self.actionList, 1)
	local actionType = action.msgType
	if actionType == "useItem" then
		self:useItem(self.curAction)
	elseif actionType == "openBox" then
		self:openBox(self.curAction)
	elseif actionType == "aiUseItem" then
		self:aiUseItem(self.curAction)
	elseif actionType == "aiOpenBox" then
		self:aiOpenBox(self.curAction)
	elseif actionType == "gameQuit" then
		self:gameQuit(self.curAction)
	else
		self:setActionEnd()
	end
end
function Com_9001691_game:setActionEnd(isStartGame)
	local gameData = self.curAction.data.game
	local curScore = gameData.me.awardCount * self.lvCfg.score[4]
	local myHP = gameData.me.hp
	local myItems = gameData.me.items
	local aiHP = gameData.ai.hp
	local aiItems = gameData.ai.items
	_UPVALUE7_ = nil
	;(nil)[1] = gameData.me.awardCount
	;(nil)[2] = self.lvCfg.score[4]
	;(nil)[3] = curScore
	;(nil)[4] = myHP
	;(nil)[5] = myItems
	;(nil)[6] = aiHP
	;(nil)[7] = aiItems
	dump(nil, "setActionEnd")
	_ENV = curScore
	curScore.score = curScore
	self.fields.text_score:setString(i18n("surprise_box_021", curScore))
	if self.lastScore ~= nil and self.lastScore ~= curScore and not isStartGame then
		self.fields.text_add:setString("+" .. curScore - self.lastScore)
		self.transitions.t4:play(1, 0, 0, -1)
	end
	self.lastScore = curScore
	self.fields.my_item1:setTitle(myItems[1])
	self.fields.my_item2:setTitle(myItems[2])
	self.fields.my_item3:setTitle(myItems[3])
	self.fields.ai_item1:setTitle(aiItems[1])
	self.fields.ai_item2:setTitle(aiItems[2])
	self.fields.ai_item3:setTitle(aiItems[3])
	self.fields.list_myhp:setNumItems(myHP)
	self.fields.list_aihp:setNumItems(aiHP)
	if isStartGame then
		self.fields.list_myhpbg:setNumItems(myHP)
		self.fields.list_aihpbg:setNumItems(aiHP)
	end
	self:setIsInAction(false, isStartGame)
	self.fields.box:setVisible(true)
end
function Com_9001691_game:useItem(msgData)
	dump(msgData, "Com_9001691_game:useItem")
	self.fields.button_open:setEnabled(false)
	self.fields.button_switch:setEnabled(false)
	local gameData = msgData.data.game
	local box = msgData.box
	local currUseItem = gameData.me.currUseItem
	self.isCanUseItem = false
	local _ENV, seq
	local itemShowTime = 1.5
	local itemShowTime2 = 1.0
	if currUseItem == SURPRISE_BOX_ITEM.KNOW then
		itemShowTime = 1.5
		itemShowTime2 = 1.0
	elseif currUseItem == SURPRISE_BOX_ITEM.HP then
		itemShowTime = 1.5
		itemShowTime2 = 1.0
	elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
		itemShowTime = 1.5
		itemShowTime2 = 1.0
	end
	local myItems = gameData.me.items
	self.fields.my_item1:setTitle(myItems[1])
	self.fields.my_item2:setTitle(myItems[2])
	self.fields.my_item3:setTitle(myItems[3])
	table.insert(seq, ffa.delay(0.1))
	table.insert(seq, ffa.callFunc(function()
		if currUseItem == SURPRISE_BOX_ITEM.KNOW then
			self.fields.Com_item1Effect:setVisible(true)
			fguiHelper.get_transitions(self.fields.Com_item1Effect).t0:play(1, 0, 0, -1, function()
				self.fields.Com_item1Effect:setVisible(false)
			end)
		elseif currUseItem == SURPRISE_BOX_ITEM.HP then
			self.fields.my_hp_effect:setAllFrameNameOnce("G_9001691_huixueguang_%02d.png", 1, false)
		elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
			self.fields.Com_hold2:setVisible(true)
			fguiHelper.get_transitions(self.fields.Com_hold2).t0:play(-1, 0, 0, -1)
		end
	end))
	table.insert(seq, ffa.delay(itemShowTime))
	table.insert(seq, ffa.callFunc(function()
		if currUseItem == SURPRISE_BOX_ITEM.KNOW then
			self.fields.button_open:setEnabled(true)
			self.fields.button_switch:setEnabled(true)
			if box == SURPRISE_BOX_TYPE.AWARD then
				print("#当前箱子里的是奖励 推荐自己开")
				self.fields.lightAni1:setAllFrameNameOnce("G_9001691_saoguang_%02d.png", 1, true)
				self.fields.light1:setVisible(true)
				self.fields.text_talk1:setVisible(true)
				self.fields.talkBg1:setVisible(true)
				self.fields.text_talk1:setString(i18n("surprise_box_066"))
			elseif box == SURPRISE_BOX_TYPE.TRAP then
				print("#当前箱子里的是陷阱 推荐对方开")
				self.fields.text_talk1:setVisible(true)
				self.fields.talkBg1:setVisible(true)
				self.fields.text_talk1:setString(i18n("surprise_box_034"))
				self.fields.lightAni2:setAllFrameNameOnce("G_9001691_saoguang_%02d.png", 1, true)
				self.fields.light2:setVisible(true)
			end
		elseif currUseItem == SURPRISE_BOX_ITEM.HP then
			print("#回复血量")
			local myHp = gameData.me.hp
			self.showAniHpIdx = myHp
			self.fields.list_myhp:setNumItems(myHp)
		elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
		end
	end))
	table.insert(seq, ffa.delay(itemShowTime2))
	table.insert(seq, ffa.callFunc(function()
		self.fields.button_open:setEnabled(true)
		self.fields.button_switch:setEnabled(true)
		self:setActionEnd()
	end))
	self:runAction(ffa.seq(seq))
end
function Com_9001691_game:openBox(msgData)
	dump(msgData, "Com_9001691_game:openBox")
	self.fields.Com_hold2:setVisible(false)
	local gameData = msgData.data.game
	local lastGameData = self.lastAction.data.game
	local openPlayer = msgData.openPlayer
	local _ENV, seq
	table.insert(seq, ffa.delay(0.5))
	table.insert(seq, ffa.callFunc(function()
		self.fields.Usm_1:setPrepareCallback(function(crisp)
			self.fields.box:setVisible(false)
			crisp:start()
		end)
		if openPlayer == SURPRISE_BOX_PLAYER.ME then
			local hp = gameData.me.hp
			local lastHp = lastGameData.me.hp
			if hp < lastHp then
				print("#玩家开到了陷阱")
				self.fields.Usm_1:setEffectPath("9001691_dpm_01.usm", false)
				self:showTalk(i18n("surprise_box_043"))
			else
				print("#玩家开到了奖励")
				self.fields.Usm_1:setEffectPath("9001691_kbx_01.usm", false)
				self:showTalk(i18n("surprise_box_052"))
			end
		elseif openPlayer == SURPRISE_BOX_PLAYER.AI then
			local hp = gameData.ai.hp
			local lastHp = lastGameData.ai.hp
			SURPRISE_BOX_PLAYER = self
			self[1] = hp
			self[2] = lastHp
			dump(self, "openBox")
			if hp < lastHp then
				print("#AI开到了陷阱")
				self.fields.Usm_1:setEffectPath("9001691_dnpc_01.usm", false)
				self.fields.Spine_1:start("hit", false)
				self:showTalk(i18n("surprise_box_051"))
			else
				print("#AI开到了奖励")
				self.fields.Usm_1:setEffectPath("9001691_kbx_01.usm", false)
				self:showTalk(i18n("surprise_box_080"))
			end
		end
	end))
	table.insert(seq, ffa.delay(2))
	table.insert(seq, ffa.callFunc(function()
		self.isMyTurn = gameData.currPlayer == SURPRISE_BOX_PLAYER.AI
		activity_9001691_Ctrl:reqSurpriseBoxOpenBoxEnd()
		self.fields.Usm_1:clearEffect()
		self:setActionEnd()
	end))
	self:runAction(ffa.seq(seq))
end
function Com_9001691_game:aiUseItem(msgData)
	dump(msgData, "Com_9001691_game:aiUseItem")
	local gameData = msgData.data.game
	local currUseItem = gameData.ai.currUseItem
	local myItems = gameData.me.items
	local aiItems = gameData.ai.items
	self.fields.ai_item1:setTitle(aiItems[1])
	self.fields.ai_item2:setTitle(aiItems[2])
	self.fields.ai_item3:setTitle(aiItems[3])
	local _ENV, seq = self.fields.ai_item3.setTitle, self.fields.ai_item3.setTitle
	local itemShowTime = 1.5
	local itemShowTime2 = 2.0
	if currUseItem == SURPRISE_BOX_ITEM.KNOW then
		itemShowTime = 1.5
		itemShowTime2 = 2.0
	elseif currUseItem == SURPRISE_BOX_ITEM.HP then
		itemShowTime = 1.5
		itemShowTime2 = 2.0
	elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
		itemShowTime = 1.5
		itemShowTime2 = 2.0
	end
	table.insert(seq, ffa.delay(1.5))
	table.insert(seq, ffa.callFunc(function()
		if currUseItem == SURPRISE_BOX_ITEM.KNOW then
			self.fields.Com_item1Effect:setVisible(true)
			fguiHelper.get_transitions(self.fields.Com_item1Effect).t0:play(1, 0, 0, -1, function()
				self.fields.Com_item1Effect:setVisible(false)
			end)
			self:showTalk(i18n("surprise_box_045"))
		elseif currUseItem == SURPRISE_BOX_ITEM.HP then
			self.fields.ai_hp_effect:setAllFrameNameOnce("G_9001691_huixueguang_%02d.png", 1, false)
		elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
			self.fields.Com_hold1:setVisible(true)
			fguiHelper.get_transitions(self.fields.Com_hold1).t0:play(-1, 0, 0, -1)
		end
	end))
	table.insert(seq, ffa.delay(itemShowTime))
	table.insert(seq, ffa.callFunc(function()
		if currUseItem == SURPRISE_BOX_ITEM.KNOW then
			print("#AI查看了箱子的内容")
		elseif currUseItem == SURPRISE_BOX_ITEM.HP then
			local aiHP = gameData.ai.hp
			self.showAniHpIdx = aiHP
			self.fields.list_aihp:setNumItems(aiHP)
		elseif currUseItem == SURPRISE_BOX_ITEM.LOCK then
			self:showTalk(i18n("surprise_box_047"))
			print("#锁定我方")
		end
	end))
	table.insert(seq, ffa.delay(itemShowTime2))
	table.insert(seq, ffa.callFunc(function()
		self:setActionEnd()
	end))
	self:runAction(ffa.seq(seq))
end
function Com_9001691_game:aiOpenBox(msgData)
	dump(msgData, "Com_9001691_game:aiOpenBox")
	self.fields.Com_hold1:setVisible(false)
	local lastGameData = self.lastAction.data.game
	local openPlayer = msgData.openPlayer
	local gameData = msgData.data.game
	local _ENV, seq
	table.insert(seq, ffa.delay(1.5))
	table.insert(seq, ffa.callFunc(function()
		if openPlayer == SURPRISE_BOX_PLAYER.ME then
			print("#AI选择玩家开箱子")
			self:showTalk(i18n("surprise_box_048"))
		else
			print("#AI选择自己开箱子")
			self:showTalk(i18n("surprise_box_049"))
		end
	end))
	table.insert(seq, ffa.delay(2.5))
	table.insert(seq, ffa.callFunc(function()
		self.fields.Usm_1:setPrepareCallback(function(crisp)
			self.fields.box:setVisible(false)
			crisp:start()
		end)
		if openPlayer == SURPRISE_BOX_PLAYER.ME then
			local hp = gameData.me.hp
			local lastHp = lastGameData.me.hp
			if hp < lastHp then
				print("#玩家开到了陷阱")
				self.fields.Usm_1:setEffectPath("9001691_dpm_01.usm", false)
				self:showTalk(i18n("surprise_box_043"))
			else
				print("#玩家开到了奖励")
				self.fields.Usm_1:setEffectPath("9001691_kbx_01.usm", false)
				self:showTalk(i18n("surprise_box_052"))
			end
		elseif openPlayer == SURPRISE_BOX_PLAYER.AI then
			local hp = gameData.ai.hp
			local lastHp = lastGameData.ai.hp
			if hp < lastHp then
				print("#AI开到了陷阱")
				self.fields.Usm_1:setEffectPath("9001691_dnpc_01.usm", false)
				self:showTalk(i18n("surprise_box_050"))
				self.fields.Spine_1:start("hit", false)
			else
				print("#AI开到了奖励")
				self.fields.Usm_1:setEffectPath("9001691_kbx_01.usm", false)
				self:showTalk(i18n("surprise_box_053"))
			end
		end
	end))
	table.insert(seq, ffa.delay(3.0))
	table.insert(seq, ffa.callFunc(function()
		self.fields.Usm_1:clearEffect()
		self:setActionEnd()
	end))
	self:runAction(ffa.seq(seq))
end
function Com_9001691_game:gameQuit(msgData)
	self.actionList, _ENV = nil, nil
	self.isInGame = false
	self.isInAction = false
	_ENV = nil
	;(nil).scoreMap = msgData.scoreMap
	;(nil).reward = msgData.rewards or msgData.reward
	uiManager:show("Activity_9001691_Result", nil)
	self:stopAllActions()
	if self.quitCallback then
		self.quitCallback()
	end
end
function Com_9001691_game:getIsGameStart()
	return self.isInGame
end
function Com_9001691_game:finishGame()
	if #self.actionList > 0 then
		local actionData = self.actionList[#self.actionList]
		if actionData.msgType == "gameQuit" then
			self:gameQuit(actionData.msgData)
			return
		end
	end
	self.isPlayerQuit = true
	SoraDShowLoading(self, nil, nil, true, 5)
	activity_9001691_Ctrl:reqSurpriseBoxGameQuit()
end
function Com_9001691_game:onUseItemClick(btn, param)
	SoraDPlaySound()
	local useItem = param
	local gameData = self.curAction.data.game
	if not self.isCanUseItem then
		SoraDShowMsgTip(i18n("surprise_box_073"))
		return
	end
	if gameData.me.items[useItem] <= 0 then
		SoraDShowMsgTip(i18n("surprise_box_022"))
		return
	end
	if useItem == SURPRISE_BOX_ITEM.HP and gameData.me.hp >= self.lvCfg.playerHp then
		SoraDShowMsgTip(i18n("surprise_box_023"))
		return
	end
	_ENV = i18n("surprise_box_023")
	i18n("surprise_box_023").useItem = useItem
	i18n("surprise_box_023").useCallback = function()
		SoraDShowLoading(self, nil, nil, true, 5)
		activity_9001691_Ctrl:reqSurpriseUseItem(useItem)
	end
	uiManager:show("Activity_9001691_ItemUse", i18n("surprise_box_023"))
end
function Com_9001691_game:showTalk(msg)
	self.fields.talkBg:setVisible(true)
	self.fields.text_talk:setVisible(true)
	self.fields.text_talk:setString(msg)
end
function Com_9001691_game:onOpenBoxClick(btn, param)
	if not self.isMyTurn or self.curGuideIndex ~= nil then
		return
	end
	SoraDPlaySound()
	self.isMyTurn = false
	self.fields.text_talk1:setVisible(false)
	self.fields.talkBg1:setVisible(false)
	self.transitions.t3:play(1, 0, 0, -1, function()
		self.controllers.c1:setSelectedIndex(0)
	end)
	SoraDShowLoading(self, nil, nil, true, 5)
	activity_9001691_Ctrl:reqSurpriseBoxOpenBox(param)
end
function Com_9001691_game:onMyHpRenderer(index, obj)
	if self.showAniHpIdx and index == self.showAniHpIdx - 1 then
		self.showAniHpIdx = nil
		fguiHelper.get_fields(obj).ani:setAllFrameNameOnce("G_9001691_baodian_%02d.png", 1, false)
		fguiHelper.get_transitions(obj).t0:play(1, 0, 0, -1)
	else
		fguiHelper.get_fields(obj).ani:setVisible(false)
	end
end
function Com_9001691_game:onAIHpRenderer(index, obj)
	if self.showAniHpIdx and index == 0 then
		self.showAniHpIdx = nil
		fguiHelper.get_fields(obj).ani:setAllFrameNameOnce("G_9001691_baodian_%02d.png", 1, false)
		fguiHelper.get_transitions(obj).t0:play(1, 0, 0, -1)
	else
		fguiHelper.get_fields(obj).ani:setVisible(false)
	end
end
function Com_9001691_game:onHPBgRender()
end
function Com_9001691_game:showGuideStep()
	if self.lastHighLightUIS ~= nil then
		for i, v in ipairs(self.lastHighLightUIS) do
			local target = self.fields[v]
			target:setSortingOrder(0)
		end
		self.lastHighLightUIS = nil
	end
	self.curGuideIndex = self.curGuideIndex and self.curGuideIndex + 1 or 1
	local guideStep = activity_9001691_Read.getGuideStep(self.curGuideIndex)
	if guideStep == nil then
		self.curGuideIndex = nil
		self.fields.text_talk:setVisible(false)
		self.fields.talkBg:setVisible(false)
		self.fields.Com_9001691_guideMask:setVisible(false)
		self.fields.talkBg:setSortingOrder(0)
		self.fields.text_talk:setSortingOrder(0)
		self.fields.Usm_1:setSortingOrder(1)
		self.fields.Com_item1Effect:setSortingOrder(1)
		return
	end
	local talk = guideStep.talk
	local mask = guideStep.mask
	local highLightUIs = guideStep.highLightUIs
	self.fields.Com_9001691_guideMask:setVisible(true)
	self.fields.text_talk:stopAllActions()
	self.fields.text_talk:setVisible(true)
	self.fields.talkBg:setVisible(true)
	self.fields.Com_9001691_guideMask:setAlpha((highLightUIs ~= nil or mask ~= nil) and 1 or 0)
	self.fields.text_talk:setString(i18n(talk))
	if mask then
		local focus = fguiHelper.get_fields(self.fields.Com_9001691_guideMask).focus
		local target = self.fields[mask]
		focus:setXY(target:getX(), target:getY())
		focus:setSize(target:getWidth(), target:getHeight())
	end
	if highLightUIs then
		self.fields.Com_9001691_guideMask:setSortingOrder(1)
		self.fields.talkBg:setSortingOrder(1)
		self.fields.text_talk:setSortingOrder(1)
		local focus = fguiHelper.get_fields(self.fields.Com_9001691_guideMask).focus
		focus:setXY(0, 0)
		focus:setSize(1, 1)
		for i, v in ipairs(highLightUIs) do
			local target = self.fields[v]
			target:setSortingOrder(2)
		end
		self.lastHighLightUIS = highLightUIs
	end
end
function Com_9001691_game:oGuideMaskClick()
	self:showGuideStep()
end
return Com_9001691_game

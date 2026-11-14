local eliminateGameCommon = include("starsWishingGameCommon")
local starsWishingGameCtrl = SoraDGetCtrl("starsWishingGameCtrl")
local constantRead = include("constantRead")
local msgNotice = include("msgNotice")
local activity_9001629_Read = include("activity_9001629_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EliminateGameViewPanel = class("EliminateGameViewPanel", baseFguiPanel)
local Swap_Distance_Value = 50
_ENV = baseFguiPanel
baseFguiPanel.red = 1
baseFguiPanel.yellow = 2
baseFguiPanel.purple = 3
local baseFguiPanel.green, ChessColorDef = 4, baseFguiPanel
function EliminateGameViewPanel:ctor(...)
	self.debug = true
	EliminateGameViewPanel.super.ctor(self, ...)
	print("EliminateGameViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629
	self.needCallBack2SDK = true
	self.row = 5
	self.atkDetail, EliminateGameViewPanel, self.chessList, EliminateGameViewPanel, self.col = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629, gActivityTimeActivityID.NORMAL_ACTIVITY_9001629, gActivityTimeActivityID.NORMAL_ACTIVITY_9001629, gActivityTimeActivityID.NORMAL_ACTIVITY_9001629, 5
	self.autoAtkCount = 0
	self.stepNum = 30
	self.level = 1
	self.atk = 0
	self.mulNum = 1
	self.isHideCurrentSceneView = true
	self.maxAttackCount = constantRead.getConstValue("STARS_BATTLE_CONTINUOUS_MAX", 15)
	self.comboAtk = constantRead.getConstValue("STARS_BATTLE_CONTINUOUS_POINT", 0)
	local chessboard = include("chessboard")
	EliminateGameViewPanel = "chessboard"
	;("chessboard").gameCommon = eliminateGameCommon
	;("chessboard").minNum = 3
	local ("chessboard").isNeedSlant, param = false, "chessboard"
	self.chessboard = chessboard.new(param)
	serviceFunctions.setRandomSeed()
end
function EliminateGameViewPanel:onInit()
	print("=======EliminateGameViewPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_stars_wishing_text1"), handler(self, self.onClickClose), handler(self, self.onHelp))
	self.Panel_monster = self.fields.Panel_monster
	self.monster = self.Panel_monster:getChild("node_monster")
	self.fields.text_tip:setString(i18n("nebula_stars_wishing_text26"))
	self.fields.text_double_on:setString(i18n("nebula_stars_wishing_text38"))
	if not SoraDFIsRA() then
		self.fields.Node_bar:getChild("bar"):setFillOrigin(fgui.FillOrigin.Left)
		self.fields.Button_replay:fixPos()
		self.fields.stepBtn:fixPos()
	end
end
function EliminateGameViewPanel:onShow()
	print("=======EliminateGameViewPanel:onShow")
	self:initData(starsWishingGameCtrl.dataTable)
end
function EliminateGameViewPanel:updateFreeTip()
	local isHaveFreeTimes = starsWishingGameCtrl:getIsHaveFreePlusTimes()
	self.fields.stepBtn:setReddot(isHaveFreeTimes, 0)
end
function EliminateGameViewPanel:initData(data)
	self.levelConfig = activity_9001629_Read.getLevelList()
	activity_9001629_Read, self.atkHarmConfig = require("app." .. LocalTblPath .. ".config_server.stars_wishing_damage"), require("app." .. LocalTblPath .. ".config_server.stars_wishing_damage")
	require("app." .. LocalTblPath .. ".config_server.stars_wishing_damage")[4] = self.atkHarmConfig[4].harm or 2000
	self.atkConfig, require("app." .. LocalTblPath .. ".config_server.stars_wishing_damage")[5] = require("app." .. LocalTblPath .. ".config_server.stars_wishing_damage"), self.atkHarmConfig[5].harm or 3000
	if self.atkHarmConfig[3] then
		self.chessboard:setProperties("minNum", 3)
		self.atkConfig[3] = self.atkHarmConfig[3].harm or 1000
	end
	if data then
		self.level = data.level or 1
		self.stepNum = data.mysteps or 30
		if data.atkPlusID ~= 0 then
			self.mulNum = 2
		else
			self.mulNum = 1
		end
	end
	self.isAllFinish = false
	if self.level > #self.levelConfig then
		self.controllers.c1:setSelectedIndex(1)
		self.isAllFinish = true
		self.level = #self.levelConfig
	end
	self.totalHP = self.levelConfig[self.level].score
	self.curHP = self.totalHP
	self:loadData(data)
end
function EliminateGameViewPanel:saveData(isExit)
	_ENV = nil
	;(nil).level = self.level
	local (nil).chessboard, data = self.chessboard, nil
	if isExit then
		data, _ENV = self.chessboard, self.chessboard
	end
	local key = "Game:EliminateGameViewPanel:saveData~table"
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet(key, data, nil)
end
function EliminateGameViewPanel:loadData(serverData)
	local key = "Game:EliminateGameViewPanel:saveData~table"
	_ENV = nil
	;(nil).byUID = true
	local data = SoraDConfigGet(key, nil)
	local guideStep = SoraDIsGameGuide()
	local level = data and data.level
	local chessboard = data and data.chessboard
	if level and level == self.level and chessboard and self.chessboard:checkValid(chessboard) then
		self.chessboard:update(chessboard)
	else
		self:initChessboard()
	end
	self:initUI()
	self:enterLevel(self.level)
	if data and data.hp and data.damageList then
		self.curHP = data.hp
		starsWishingGameCtrl:sendDamageList(data.damageList)
	else
		self.curHP = serverData.hp or self.totalHP
	end
	self.curHpPercent = self.curHP / self.totalHP
	self:_updateHpBar(self.curHpPercent)
end
function EliminateGameViewPanel:calculateAtk(isFromSwap)
	local atk = 0
	if #self.atkDetail >= self.maxAttackCount then
		return atk
	end
	local list = self.chessboard:calculateAtk()
	if 0 < #list then
		atk = atk + (isFromSwap and 0 or self.comboAtk)
		self.autoAtkCount = self.autoAtkCount + (isFromSwap and 0 or 1)
	end
	for i, v in ipairs(list) do
		if #self.atkDetail >= self.maxAttackCount then
			return atk
		end
		atk = atk + self.atkConfig[v]
		table.insert(self.atkDetail, v)
	end
	return atk
end
function EliminateGameViewPanel:playAttack(atk, moveTime, attackTime)
	return
end
function EliminateGameViewPanel:enterLevel(level)
	self.level = level
	self:initMonster(self.level)
	self.totalHP = self.levelConfig[self.level].score
	self.atkDetail, _ENV, self.curHP = self.totalHP, self.totalHP, self.totalHP
	self.autoAtkCount = 0
	self:setHpBar(1)
	_ENV = nil
	;(nil).lv = self.level
	self.txtMonsterLv:setString(i18n("common_text_100", nil))
end
function EliminateGameViewPanel:initMonster(level)
	local monsterImg = self.levelConfig[self.level].monster
	dump(monsterImg, "monsterImg")
	if self.preMonster and self.preMonster == monsterImg then
		return
	end
	self.preMonster = monsterImg
	local _ENV, config = self.preMonster, self.preMonster
	if display.height <= 900 then
		_ENV, _ENV = "monsterImg", display.height
		_ENV, display.height["gwdzz_b_bust.png"], ("monsterImg").pos = "monsterImg", "monsterImg", cc.p(0, -20)
		_ENV, display.height["gwdzz_anbs_bust.png"], ("monsterImg").pos = "monsterImg", "monsterImg", cc.p(0, -20)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], ("monsterImg").pos = "monsterImg", "monsterImg", cc.p(0, 0)
		config, display.height["gwdzz_bhnt_bust.png"], ("monsterImg").pos = display.height, "monsterImg", cc.p(0, -20)
	elseif display.height <= 960 then
		_ENV, _ENV = "monsterImg", display.height
		;("monsterImg").pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_b_bust.png"], ("monsterImg").scale = "monsterImg", "monsterImg", 1
		;("monsterImg").pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_anbs_bust.png"], ("monsterImg").scale = "monsterImg", "monsterImg", 1
		;("monsterImg").pos = cc.p(0, 0)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], ("monsterImg").scale = "monsterImg", "monsterImg", 1.1
		;("monsterImg").pos = cc.p(0, -20)
		config, display.height["gwdzz_bhnt_bust.png"], ("monsterImg").scale = display.height, "monsterImg", 1.1
	elseif display.height > 1200 then
		_ENV, _ENV = "monsterImg", display.height
		_ENV, display.height["gwdzz_b_bust.png"], ("monsterImg").pos = "monsterImg", "monsterImg", cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], ("monsterImg").pos = "monsterImg", "monsterImg", cc.p(0, 20)
		;("monsterImg").pos = cc.p(0, 30)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], ("monsterImg").scale = "monsterImg", "monsterImg", 0.9
		;("monsterImg").pos = cc.p(0, 0)
		config, display.height["gwdzz_bhnt_bust.png"], ("monsterImg").scale = display.height, "monsterImg", 1.0
	end
	local data = config[monsterImg]
	if data then
		local pos = cc.p(self.Panel_monster:getContentSize().width / 2 + data.pos.x, data.pos.y)
		self.monster:setPosition(pos)
		if data.scale then
			self.monster:setScale(data.scale)
		end
	end
	self.monster:setURL(monsterImg)
	self.monster:setVisible(false)
	if self.spine_npc then
		if self.spine_npc.animShaker then
			self.spine_npc.animShaker:stop()
			self.spine_npc.animShaker = nil
		end
		self.spine_npc:removeFromParent()
		self.spine_npc = nil
	end
	local _ENV, config = self.spine_npc.removeFromParent, self.spine_npc.removeFromParent
	if display.height <= 900 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, -20)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 25)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).pos = false, false, cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).pos = display.height, false, cc.p(0, 35)
	elseif display.height <= 960 then
		_ENV, _ENV = false, display.height
		;(false).pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_b_bust.png"], (false).scale = false, false, 1
		;(false).pos = cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).scale = false, false, 1
		;(false).pos = cc.p(0, 40)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).scale = false, false, 1.1
		;(false).pos = cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).scale = display.height, false, 1.1
	elseif display.height <= 1200 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, 0)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 40)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).pos = false, false, cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).pos = display.height, false, cc.p(0, 50)
	elseif display.height > 1200 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 65)
		;(false).pos = cc.p(0, 70)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).scale = false, false, 0.9
		;(false).pos = cc.p(0, 65)
		config, display.height["gwdzz_bhnt_bust.png"], (false).scale = display.height, false, 1.0
	end
	local data = config[monsterImg]
	_ENV, _ENV = cc.p(0, 65), false
	cc.p(0, 65).skel = "spine/gwdzz_b_bust.skel"
	_ENV, (false)["gwdzz_b_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_b_bust.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_anubisi.skel"
	_ENV, (false)["gwdzz_anbs_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_anubisi.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_bajilisike.skel"
	_ENV, (false)["gwdzz_bjlsk_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_bajilisike.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_shendeng.skel"
	;(false)["gwdzz_bhnt_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), "spine/gwdzz_shendeng.atlas"
	local spineConfig = false
	local spine_npc = spineConfig[monsterImg] and sp.SkeletonAnimation:create(spineConfig[monsterImg].skel, spineConfig[monsterImg].atlas, 1) or display.newNode()
	if spineConfig[monsterImg] then
		spine_npc:setAnimation(0, "animation", true)
	end
	spine_npc:setScale(0.8)
	if data then
		local pos = cc.p(self.Panel_monster:getContentSize().width / 2 + data.pos.x, data.pos.y)
		spine_npc:setPosition(pos)
		if data.scale then
			spine_npc:setScale(data.scale)
		end
	else
		spine_npc:setPosition(cc.p(self.Panel_monster:getContentSize().width / 2, 0))
	end
	spine_npc:addTo(self.Panel_monster)
	self.spine_npc = spine_npc
end
function EliminateGameViewPanel:initUI(...)
	self.touchMask = self.fields.touchMask
	self.layout = self.fields.panel_chessboard
	self.fields.Button_award:setTitle(i18n("devilvalley_text_27"))
	self.fields.Button_award:addTouchEventListener(handler(self, self.onBtnAward))
	self.stepBtn = self.fields.stepBtn
	self.stepBtn:addTouchEventListener(handler(self, self.onStep))
	self.stepTip = self.stepBtn:getChild("title")
	self.stepWord = self.stepBtn:getChild("stepWord")
	self.Node_stepGold = self.stepBtn:getChild("Node_stepGold")
	self.stepGoldTip = self.Node_stepGold:getChild("Text_gold")
	self.doubleBtn = self.fields.doubleBtn
	self.doubleBtn:addTouchEventListener(handler(self, self.onDouble))
	self.doubleTip = self.doubleBtn:getChild("doubleTip")
	self.Node_doubleGold = self.doubleBtn:getChild("Node_doubleGold")
	self.doubleGoldTip = self.Node_doubleGold:getChild("Text_gold")
	self.fields.Button_replay:addTouchEventListener(handler(self, self.onRetry))
	self.fields.Button_replay:setString(i18n("common_text_2541"))
	self.txtMonsterLv = self.fields.node_monster_info
	self.nodeMain = self.fields.panel_chessboard
	local effect_normal = self.doubleBtn:getChild("effect_normal")
	local effect = SoraDCreatAnimation("gwdzz_normal")
	effect:addTo(effect_normal)
	self.et_btn_double = SoraDGetChildByName(effect, "Node_double")
	self.et_btn_double:setVisible(false)
	self:layoutChessboard()
	self.touchMask:setTouchEnabled(false)
	_ENV, _ENV = self.touchMask, self.touchMask.setTouchEnabled
	_ENV, self.touchMask.plist = false, "et_Par_llkgw_001.plist"
	;(false).x = 30
	_ENV, self.touchMask.pos, (false).y = false, false, 10
	;(false).x = 4
	self.touchMask.scale, (false).y = false, 8
	self.touchMask.setTouchEnabled[1], self.touchMask.rotate = self.touchMask, -15
	local effectParam = self.touchMask.setTouchEnabled
	local effectNode = SoraDCreateEffectNode(effectParam)
	effectNode:addTo(self.Panel_monster, -1)
	effectNode:setPosition(self.Panel_monster:getContentSize().width / 2, 0)
	self:updateUI()
end
function EliminateGameViewPanel:updateUI(...)
	self.stepWord:setString(self.stepNum)
	if self.stepNum == 0 then
		self:stepZeroEffect()
	else
		self:stepZeroEffect(true)
	end
	if self.stepNum <= 3 and self.stepNum > 0 then
		self:stepLessEffect()
	else
		self:stepLessEffect(true)
	end
	if self.mulNum > 1 then
		self:doubleAttackEffect()
		self:doubleChessEffect()
		if not self.soundLightning then
			self.soundLightning = AudioEngine.playEffect(getAudioFileNameByPlatform("game_chargeLightning", "Sound"), true)
		end
	else
		self:doubleAttackEffect(true)
		self:doubleChessEffect(true)
		if self.soundLightning then
			AudioEngine.stopEffect(self.soundLightning)
			self.soundLightning = nil
		end
	end
	local curDoubles = starsWishingGameCtrl:getCurDoubles()
	if curDoubles < 1 then
		self.doubleTip:setVisible(false)
		self.Node_doubleGold:setVisible(true)
		self.doubleGoldTip:setString(eliminateGameCommon.getDoubleCost())
	else
		_ENV = eliminateGameCommon.getDoubleCost()
		eliminateGameCommon.getDoubleCost().times = curDoubles
		self.doubleTip:setString(i18n("nebula_stars_wishing_text35", eliminateGameCommon.getDoubleCost()))
		self.doubleTip:setVisible(true)
		self.Node_doubleGold:setVisible(false)
	end
	if self.stepNum > 0 then
		self.stepTip:setString(i18n("common_text_2545"))
		self.stepTip:setVisible(true)
		self.Node_stepGold:setVisible(false)
	else
		self.stepTip:setVisible(false)
		self.Node_stepGold:setVisible(true)
		self.stepGoldTip:setString(starsWishingGameCtrl:getStepsCost())
	end
	self:updateFreeTip()
end
function EliminateGameViewPanel:conv(row, col)
	return eliminateGameCommon.conv(row, col)
end
function EliminateGameViewPanel:initFirstFightChessboard()
	local chessboard = eliminateGameCommon.initFirstFightChessboard()
	self.chessboard:update(chessboard)
end
function EliminateGameViewPanel:initChessboard()
	self.chessboard:initChessboard()
end
function EliminateGameViewPanel:updateStep(isFromSwap)
	self.chessboard:scanLinks()
	self.chessboard:removeLinks()
	local emptyList = self.chessboard:getProperties("emptyList")
	if 0 < #emptyList then
		self.isInUpdateStep = true
		self.touchMask:setTouchEnabled(true)
		self.doubleBtn:setTouchEnabled(false)
		_UPVALUE5_ = self.doubleBtn
		self.doubleBtn[1] = ffa.callFunc(function()
			self:playDispose(0.5, isFromSwap)
		end)
		self.doubleBtn[2] = ffa.delay(0.5)
		self.doubleBtn[3] = ffa.callFunc(function()
			local moveList = self.chessboard:fillEmpty()
			self:fillChessboard(moveList, 0.3)
		end)
		self.doubleBtn[4] = ffa.delay(0.33)
		self.doubleBtn[5] = ffa.callFunc(function()
			self.atk = self.atk + self:calculateAtk(isFromSwap)
		end)
		self.doubleBtn[6] = ffa.callFunc(function()
			self:updateStep(false)
		end)
		self.doubleBtn[7] = ffa.callFunc(function()
			self:updateStep(false)
		end)
		local action = ffa.seq(self.doubleBtn)
		self:runAction(action)
	else
		self.isInUpdateStep = false
		if 0 < self.atk then
			self:saveData()
			_ENV = self
			self.atkDetail = self.atkDetail
			self.autoAtkCount = self.autoAtkCount
			starsWishingGameCtrl:sendAttackDetail(self)
			self.atkDetail, _ENV = starsWishingGameCtrl.sendAttackDetail, starsWishingGameCtrl.sendAttackDetail
			self.autoAtkCount = 0
			self:playAttack(self.atk, 0.2, 0.7)
			self.atk = 0
			self.playHurtFinish = false
			starsWishingGameCtrl = 0.2
			;(0.2)[1] = ffa.delay(0.5)
			;(0.2)[2] = ffa.callFunc(function()
				self.playHurtFinish = true
				self:playHurt()
				self.touchMask:setTouchEnabled(false)
				self.doubleBtn:setTouchEnabled(true)
			end)
			;(0.2)[3] = ffa.callFunc(function()
				self.playHurtFinish = true
				self:playHurt()
				self.touchMask:setTouchEnabled(false)
				self.doubleBtn:setTouchEnabled(true)
			end)
			;(0.2)[4] = ffa.callFunc(function()
				self.playHurtFinish = true
				self:playHurt()
				self.touchMask:setTouchEnabled(false)
				self.doubleBtn:setTouchEnabled(true)
			end)
			;(0.2)[5] = ffa.callFunc(function()
				self.playHurtFinish = true
				self:playHurt()
				self.touchMask:setTouchEnabled(false)
				self.doubleBtn:setTouchEnabled(true)
			end)
			self:runAction(ffa.seq(0.2))
		else
			self.touchMask:setTouchEnabled(false)
			self.doubleBtn:setTouchEnabled(true)
			self:saveData()
		end
	end
end
function EliminateGameViewPanel:createChess(color)
	local chessIcon = eliminateGameCommon.getChessIcon(color)
	local chess = display.newSprite("#" .. chessIcon)
	chess.color = color
	chess:addTo(self.layout)
	util.addTouch(chess, handler(self, self.touch))
	return chess
end
function EliminateGameViewPanel:layoutChessboard()
	local chess, color
	for i = 1, self.row do
		for j = 1, self.col do
			color = self.chessboard:getChessboard(i, j)
			chess = self.chessList[self:conv(i, j)]
			if not chess then
				chess = self:createChess(color)
				self.chessList[self:conv(i, j)] = chess
			else
				local chessIcon = eliminateGameCommon.getChessIcon(color)
				chess:setSpriteFrame(chessIcon)
				chess.color = color
			end
			eliminateGameCommon = chessIcon
			eliminateGameCommon.getChessIcon(color).row = i
			chess.point, eliminateGameCommon.getChessIcon(color).col = eliminateGameCommon.getChessIcon(color), j
			chess:setPosition(self:convertToPos(chess.point))
		end
	end
	if self.isBlackChessBoardInit == nil then
		local size = self.layout:getContentSize()
		local cellSize = cc.size(size.width / self.col, size.height / self.row)
		for i = 1, self.row do
			for j = 1, self.col do
				if i % 2 == 1 and j % 2 == 1 or i % 2 == 0 and j % 2 == 0 then
					local blackChessBg = display.newSprite("#frame_9001629_gwdzz_04.png")
					blackChessBg:addTo(self.layout, -2)
					blackChessBg:setPosition(self:convertToPos(i, j))
					blackChessBg:setScale(cellSize.width / blackChessBg:getContentSize().width)
				end
			end
		end
		self.isBlackChessBoardInit = true
	end
	self.layout:stopAllActions()
	local posy = self.layout:getPositionY()
	self.layout:setPositionY(posy + self.layout:getContentSize().height)
	eliminateGameCommon = self.layout
	self.layout[1] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[2] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[3] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[4] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[5] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[6] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[7] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[8] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[9] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[10] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[11] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[12] = ffa.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout:runAction(ffa.seq(self.layout))
end
function EliminateGameViewPanel:convertToPos(row, col)
	local rowNum, colNum
	if type(row) == "table" then
		rowNum = row.row
		colNum = row.col
	else
		rowNum = row
		colNum = col
	end
	local size = self.layout:getContentSize()
	local cellSize = cc.size(size.width / self.col, size.height / self.row)
	local x = cellSize.width * colNum - cellSize.width / 2
	local y = cellSize.height * rowNum - cellSize.height / 2
	return cc.p(x, size.height - y)
end
function EliminateGameViewPanel:touch(sender, type, pos)
	if self.isInUpdateStep then
		return
	end
	print("==EliminateGameViewPanel:touch==", sender, type, pos)
	if type == ccui.TouchEventType.began then
		self.touchBeginPos = pos
		if self.curChess and self.curChess == sender then
			self.curChess:stopAllActions()
			self.curChess:setRotation(0)
			self.curChess = nil
		elseif self.curChess == nil then
			eliminateGameCommon = pos
			pos[1] = cca.rotateTo(0.6, 15)
			pos[2] = cca.rotateTo(0.6, -15)
			pos[3] = cca.rotateTo(0.6, -15)
			pos[4] = cca.rotateTo(0.6, -15)
			pos[5] = cca.rotateTo(0.6, -15)
			pos[6] = cca.rotateTo(0.6, -15)
			sender:runAction(cca.repeatForever(cca.seq(pos)))
			self.curChess = sender
		elseif not tolua.isnull(self.curChess) then
			if eliminateGameCommon.isNeighbour(self.curChess.point, sender.point) then
				self.curChess:stopAllActions()
				self.curChess:setRotation(0)
				self:swapChess(sender, self.curChess)
				self.curChess = nil
			else
				self.curChess:stopAllActions()
				eliminateGameCommon = cca.repeatForever(cca.seq(pos))
				cca.repeatForever(cca.seq(pos))[1] = cca.rotateTo(0.6, 15)
				cca.repeatForever(cca.seq(pos))[2] = cca.rotateTo(0.6, -15)
				cca.repeatForever(cca.seq(pos))[3] = cca.rotateTo(0.6, -15)
				cca.repeatForever(cca.seq(pos))[4] = cca.rotateTo(0.6, -15)
				cca.repeatForever(cca.seq(pos))[5] = cca.rotateTo(0.6, -15)
				cca.repeatForever(cca.seq(pos))[6] = cca.rotateTo(0.6, -15)
				sender:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(pos)))))
				self.curChess = sender
			end
		end
	elseif type == ccui.TouchEventType.moved then
		if self.curChess ~= sender then
			return
		end
		self.touchMovePos = pos
		local touchBeganPoint = self.touchBeginPos
		local touchMovePoint = self.touchMovePos
		local distance = cc.pGetDistance(touchBeganPoint, touchMovePoint)
		if tonumber(distance) < Swap_Distance_Value then
			return
		end
		local angle = SoraDGetAngleByPos(touchBeganPoint, touchMovePoint)
		local dstVec = eliminateGameCommon.getDirectionVec(angle)
		if not dstVec then
			return
		end
		_ENV = angle
		angle.row = dstVec[1] + sender.point.row
		local angle.col, dst = dstVec[2] + sender.point.col, angle
		local chess = self.chessList[self:conv(dst.row, dst.col)]
		if not tolua.isnull(chess) and util.hitTest(chess, pos) then
			self.curChess:stopAllActions()
			self.curChess:setRotation(0)
			self:swapChess(sender, chess)
			self.curChess = nil
			return
		end
	end
end
function EliminateGameViewPanel:swapChess(chess1, chess2)
	if self.stepNum < 1 then
		self:buyStepBox()
		return
	end
	if SoraDIsGameGuide() == 18001 then
		local spriteHand = SoraDGetChildByName(self, "spriteHand")
		if spriteHand then
			spriteHand:stopAllActions()
			spriteHand:removeFromParent()
		end
		_ENV = spriteHand
		spriteHand.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		spriteHand.step = 18001
		SoraDSendMessage(spriteHand)
	end
	self.touchMask:setTouchEnabled(true)
	starsWishingGameCtrl:sendUseStep()
	self.stepNum = self.stepNum - 1
	self.stepWord:setString(self.stepNum)
	local pos1 = cc.p(chess1:getPosition())
	local pos2 = cc.p(chess2:getPosition())
	local point = chess1.point
	chess1.point = chess2.point
	chess2.point = point
	self.chessList[self:conv(chess1.point)] = chess1
	self.chessList[self:conv(chess2.point)] = chess2
	local moveTime = 0.2
	chess1:runAction(cca.moveTo(moveTime, pos2))
	chess1:runAction(cca.rotateTo(moveTime, 0))
	chess2:runAction(cca.moveTo(moveTime, pos1))
	chess2:runAction(cca.rotateTo(moveTime, 0))
	starsWishingGameCtrl = cca.rotateTo(moveTime, 0)
	cca.rotateTo(moveTime, 0)[1] = ffa.delay(moveTime)
	cca.rotateTo(moveTime, 0)[2] = ffa.callFunc(function()
		self:swap(chess1.point, chess2.point)
		self.touchMask:setTouchEnabled(false)
		self:updateStep(true)
	end)
	cca.rotateTo(moveTime, 0)[3] = ffa.callFunc(function()
		self:swap(chess1.point, chess2.point)
		self.touchMask:setTouchEnabled(false)
		self:updateStep(true)
	end)
	self:runAction(ffa.seq(cca.rotateTo(moveTime, 0)))
	SoraDPlaySound("elimiateGame", 1)
	self:updateUI()
end
function EliminateGameViewPanel:swap(p1, p2)
	self.chessboard:swap(p1, p2)
end
_ENV, EliminateGameViewPanel.fillChessboard = function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end, function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end
;(function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end)[ChessColorDef.red] = "red"
;(function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end)[ChessColorDef.yellow] = "yellow"
;(function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end)[ChessColorDef.purple] = "purple"
local (function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end)[ChessColorDef.green], nodeNameTab = "green", function(self, moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard:getChessboard(v[2]))
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end
function EliminateGameViewPanel:createBreakLineEffect(chessPos, lineLength, rotate)
	local startChess = self.chessList[self:conv(chessPos)]
	local imgName = string.format("dh_9001629_lx_%s_%s.png", nodeNameTab[startChess.color], "%02d")
	local sp = display.newSprite(string.format("#%s", string.format(imgName, 1)))
	sp:setName("break_line")
	sp:stopAllActions()
	sp:setOpacity(0)
	_UPVALUE2_ = string.format("#%s", string.format(imgName, 1))
	string.format("#%s", string.format(imgName, 1))[1] = cca.delay(0.3)
	string.format("#%s", string.format(imgName, 1))[2] = cca.fadeIn(0)
	string.format("#%s", string.format(imgName, 1))[3] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 19)
		local animation = display.newAnimation(frames, 0.05)
		sp:playAnimationOnce(animation, true)
	end)
	string.format("#%s", string.format(imgName, 1))[4] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 19)
		local animation = display.newAnimation(frames, 0.05)
		sp:playAnimationOnce(animation, true)
	end)
	sp:runAction(cca.seq(string.format("#%s", string.format(imgName, 1))))
	sp:addTo(self.layout, 2)
	sp:setAnchorPoint(cc.p(0, 0.5))
	if rotate == 90 then
		sp:setPosition(cc.p(startChess:getPositionX(), startChess:getPositionY() + 90))
	else
		sp:setPosition(cc.p(startChess:getPositionX() - 90, startChess:getPositionY()))
	end
	sp:setScaleX(2 * lineLength / 5)
	sp:setScaleY(2)
	sp:setRotation(rotate)
	sp:setBlendFunc(gl.ONE, gl.ONE)
	return sp
end
function EliminateGameViewPanel:playDispose(time, isFromSwap)
	local emptyList = self.chessboard:getProperties("emptyList")
	local rowChain = self.chessboard:getProperties("rowChain")
	local colChain = self.chessboard:getProperties("colChain")
	for k, v in pairs(rowChain) do
		for i2, v2 in ipairs(v) do
			if 3 < #v2 then
				self:createBreakLineEffect(v2[1], #v2, 0)
			end
		end
	end
	for k, v in pairs(colChain) do
		for i2, v2 in ipairs(v) do
			if 3 < #v2 then
				self:createBreakLineEffect(v2[1], #v2, 90)
			end
		end
	end
	for i, v in ipairs(emptyList) do
		local chess = self.chessList[self:conv(v)]
		if chess ~= nil and not tolua.isnull(chess) then
			local effect = self:getDisposeEffectSingle()
			effect:setPosition(cc.p(chess:getPosition()))
			effect.showColor(chess.color)
			_UPVALUE1_ = cc.p(chess:getPosition())
			cc.p(chess:getPosition())[1] = cca.delay(0.8833333333333333)
			cc.p(chess:getPosition())[2] = cca.callFunc(function()
				effect.recycleSingle()
			end)
			cc.p(chess:getPosition())[3] = cca.callFunc(function()
				effect.recycleSingle()
			end)
			cc.p(chess:getPosition())[4] = cca.callFunc(function()
				effect.recycleSingle()
			end)
			effect:runAction(cca.seq(cc.p(chess:getPosition())))
			chess:removeFromParent(true)
			SoraDPlaySound("elimiateGame", 2)
		end
	end
	dump(isFromSwap, "isFromSwap")
	if not isFromSwap then
		self:showComboEffect()
	end
	_UPVALUE3_ = nil
	;(nil)[1] = cca.delay(0.5)
	;(nil)[2] = cca.callFunc(function()
		self:showMonsterEffect(self.monster)
	end)
	;(nil)[3] = cca.delay(0.16666666666666666)
	;(nil)[4] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[5] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[6] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[7] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[8] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[9] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[10] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[11] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	self.spine_npc:runAction(cca.seq(nil))
	SoraDPlaySound("elimiateGame", 3)
end
function EliminateGameViewPanel:showComboEffect()
	local spName = SoraDFIsRA() and "#font_9001629_ayu.png" or "#font_9001629_yingyu.png"
	local spCritical = display.newSprite(spName)
	spCritical:setPosition(cc.p(270, 270))
	spCritical:addTo(self.layout, 3)
	local baseScale = 1
	spCritical:setScale(0.1 * baseScale)
	spCritical:setOpacity(0)
	local durationT = 0.3
	_UPVALUE6_ = 0
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[6] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[7] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[8] = cca.scaleTo(0.06666666666666667, 2)
	;(0)[1] = cca.delay(0.5)
	;(0)[2] = cca.fadeTo(0.016666666666666666, 0.24)
	;(0)[3] = cca.spawn(0.24)
	;(0)[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	;(0)[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	;(0)[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	;(0)[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	;(0)[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	;(0)[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	;(0)[10] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	;(0)[11] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	;(0)[12] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(0)
	_UPVALUE3_ = cca.delay(0.5)
	cca.delay(0.5)[1] = seqPrepare
	cca.delay(0.5)[2] = cca.delay(durationT * 0.5)
	cca.delay(0.5)[3] = cca.fadeOut(durationT * 0.6)
	cca.delay(0.5)[4] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[5] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[6] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[7] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[8] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[9] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[10] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	cca.delay(0.5)[11] = cca.callFunc(function()
		spCritical:removeFromParent()
	end)
	local seqAct = cca.seq((cca.delay(0.5)))
	spCritical:stopAllActions()
	spCritical:runAction(seqAct)
	local waveLabel = display.newSprite("#font_9001629_shuzi.png")
	waveLabel:setPosition(cc.p(270, 340))
	waveLabel:addTo(self.layout, 3)
	waveLabel:setScale(0.1 * baseScale)
	waveLabel:setOpacity(0)
	_UPVALUE6_ = waveLabel
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	waveLabel[1] = cca.delay(0.5)
	waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
	waveLabel[3] = cca.spawn(0.24)
	waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(waveLabel)
	local moveBy = cca.moveBy(durationT, 0, 100)
	local fadeTo = cca.fadeTo(durationT, 0)
	_UPVALUE2_ = 0
	;(0)[1] = moveBy
	;(0)[2] = fadeTo
	local spawn = cca.spawn(0)
	local callFunc = cca.callFunc(function()
		waveLabel:removeFromParent()
	end)
	_UPVALUE3_ = fadeTo
	fadeTo[1] = seqPrepare
	fadeTo[2] = spawn
	fadeTo[3] = callFunc
	local seq = cca.seq(fadeTo)
	waveLabel:runAction(seq)
end
function EliminateGameViewPanel:setHpBar(percent)
	self.curHpPercent = percent
	self:_updateHpBar(self.curHpPercent)
end
function EliminateGameViewPanel:_updateHpBar(percent)
	if 0 < percent then
		self:bloodEffect()
	else
		self:bloodEffect(true)
	end
	self.fields.Node_bar:setMax(self.totalHP)
	self.fields.Node_bar:setValue(self.curHP)
end
function EliminateGameViewPanel:playNext(rewards)
	local panel = SoraDCreatePanel("eliminateGamePopView")
	panel:initDataBy9001629()
	panel:initData(rewards)
	panel:setConfirmHandle(function()
		self:enterLevel(self.level)
		self:saveData()
	end)
	panel:show()
end
function EliminateGameViewPanel:playWin(rewards)
	local panel = SoraDCreatePanel("eliminateGamePopView")
	panel:initDataBy9001629()
	local retryCb = function()
		self.controllers.c1:setSelectedIndex(1)
		self.isAllFinish = true
		self.level = self.level - 1
		self:enterLevel(self.level)
		self:saveData()
	end
	local exitCb = function()
		self:saveData(true)
		self:close(self, ccui.TouchEventType.ended)
	end
	panel:initData(rewards, "winView")
	panel:setRetryHandle(retryCb)
	panel:setExitHandle(exitCb)
	panel:show()
end
function EliminateGameViewPanel:playBlood(atk)
	_ENV = nil
	;(nil).color = cc.c3b(255, 0, 0)
	;(nil).fontSize = 50
	;(nil).pos = cc.p(0, 0)
	;(nil).zOrder = 1
	;(nil).duration = 1
	;(nil).moveH = 120
	;(nil).scale = 1.5
	local (nil).font, param = "res/fonts/Arial_Bold_Border.fnt", nil
	self:SoraDCreateWaveBMP("-" .. atk, self.fields.Node_boom, param)
end
function EliminateGameViewPanel:playKO(rewards)
	if self.isAllFinish then
		self:enterLevel(self.level)
		self:saveData()
		return
	end
	self.level = self.level + 1
	if self.level > #self.levelConfig then
		self:playWin(rewards)
	else
		self:playNext(rewards)
	end
end
function EliminateGameViewPanel:playHurt(...)
	if self.hurtRewards then
		local hurtRewards = self.hurtRewards
		SoraDShowLoading()
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(0.3)
		;(nil)[2] = ffa.callFunc(function()
			SoraDCloseLoading()
			self:playKO(hurtRewards)
		end)
		;(nil)[3] = ffa.callFunc(function()
			SoraDCloseLoading()
			self:playKO(hurtRewards)
		end)
		self:runAction(ffa.seq(nil))
	end
	if self.killSum then
		self:playBlood(self.killSum)
		local percent = self.curHP / self.totalHP
		self:setHpBar(percent)
		self.mulNum = 1
		self:updateUI()
	end
	self.hurtRewards = nil
	self.killSum = nil
end
function EliminateGameViewPanel:resetGame()
	self.stepNum = 30
	self.mulNum = 1
	self:initChessboard()
	self:layoutChessboard()
	self:enterLevel(1)
	self:updateUI()
	self:saveData()
end
function EliminateGameViewPanel:onHide(...)
	print("=======EliminateGameViewPanel:onHide")
	if self.spine_npc and self.spine_npc.animShaker then
		self.spine_npc.animShaker:stop()
	end
	if self.soundLightning then
		AudioEngine.stopEffect(self.soundLightning)
		self.soundLightning = nil
	end
	_ENV = self.soundLightning
	self.soundLightning.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.soundLightning.eventID = self.activityID
	SoraDSendMessage(self.soundLightning)
end
function EliminateGameViewPanel:SoraDCreateWaveBMP(text, parent, params)
	local text = text or "NA"
	if params == nil then
		params, _ENV = nil, nil
	end
	local color = params.color or display.COLOR_GREEN
	local pos = params.pos or cc.p(0, 0)
	local zOrder = params.zOrder or 1
	local scale = params.scale or 1
	local dt = params.duration or 1
	local moveH = params.moveH or 80
	local font = params.font
	if not font then
		return nil
	end
	_ENV = nil
	;(nil).text = text
	;(nil).font = font
	local waveLabel = display.newBMFontLabel(nil)
	waveLabel:setColor(color)
	waveLabel:setScale(scale)
	waveLabel:addTo(parent, zOrder)
	waveLabel:setPosition(pos)
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		waveLabel:removeFromParent()
	end)
	_UPVALUE2_ = moveH
	moveH[1] = moveBy
	moveH[2] = callFunc
	local seq = cca.seq(moveH)
	waveLabel:runAction(seq)
	return waveLabel
end
function EliminateGameViewPanel:doubleAttackChessBgEffect(isHide)
	local needAdd = self:setEffectShow(self.nodeMain, "et_node_double_bg", isHide)
	self.fields.double_on_bg:setVisible(not isHide)
	self.fields.text_double_on:setVisible(not isHide)
	if not needAdd then
		return
	end
	local et_node = SoraDCreatAnimation("gwdzz_double")
	local nodeSize = self.nodeMain:getContentSize()
	et_node:setPosition(cc.p(nodeSize.width / 2, nodeSize.height / 2))
	et_node:addTo(self.nodeMain, 11)
	et_node:setName("et_node_double_bg")
end
function EliminateGameViewPanel:setEffectShow(parent, widgetName, isHide)
	if not parent then
		return
	end
	local et_node = parent:displayObject():getChildByName(widgetName)
	if isHide then
		if et_node then
			et_node:setVisible(false)
		end
		return
	end
	if et_node then
		et_node:setVisible(true)
		return
	end
	return true
end
function EliminateGameViewPanel:stepZeroEffect(isHide)
	if not self.stepBtn then
		return
	end
	local et_node_bg = self.stepBtn:displayObject():getChildByName("et_node_bg_zero")
	local et_node_top = self.stepBtn:displayObject():getChildByName("et_node_top_zero")
	if isHide == true then
		if et_node_bg then
			et_node_bg:setVisible(false)
		end
		if et_node_top then
			et_node_top:setVisible(false)
		end
		return
	end
	local size = self.stepBtn:getContentSize()
	_ENV, _ENV = false, self.stepBtn
	;(false).plist = "et_monsterfight06_01.plist"
	_ENV, _ENV, self.stepBtn[1], (false).scale = nil, false, false, 1.9
	local param_bg = self.stepBtn
	;(nil).plist = "et_monsterfight06_02.plist"
	;(nil).scale = 1.7
	_ENV, (false)[1], (nil).zorder = nil, nil, 1
	;(nil).plist = "et_monsterfight06_03.plist"
	;(nil).scale = 1.26
	;(false)[2], (nil).zorder = nil, 2
	local param_top = false
	if et_node_bg then
		et_node_bg:setVisible(true)
	else
		et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_bg:addTo(self.stepBtn, -1)
		et_node_bg:setName("et_node_bg_zero")
	end
	if et_node_top then
		et_node_top:setVisible(true)
	else
		et_node_top = SoraDCreateEffectNode(param_top)
		et_node_top:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_top:addTo(self.stepBtn, 1)
		et_node_top:setName("et_node_top_zero")
	end
end
function EliminateGameViewPanel:stepLessEffect(isHide)
	if not self.stepBtn then
		return
	end
	local et_node_bg = self.stepBtn:displayObject():getChildByName("et_node_bg_less")
	local et_node_top = self.stepBtn:displayObject():getChildByName("et_node_top_less")
	if isHide == true then
		if et_node_bg then
			et_node_bg:setVisible(false)
		end
		if et_node_top then
			et_node_top:setVisible(false)
		end
		return
	end
	local size = self.stepBtn:getContentSize()
	_ENV, _ENV = false, self.stepBtn
	;(false).plist = "et_monsterfight05_01.plist"
	_ENV, _ENV, self.stepBtn[1], (false).scale = nil, false, false, 1.26
	local param_bg = self.stepBtn
	;(nil).plist = "et_monsterfight05_02.plist"
	;(nil).scale = 1.7
	_ENV, (false)[1], (nil).zorder = nil, nil, 1
	;(nil).plist = "et_monsterfight05_03.plist"
	;(nil).scale = 1.26
	;(false)[2], (nil).zorder = nil, 2
	local param_top = false
	if et_node_bg then
		et_node_bg:setVisible(true)
	else
		et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_bg:addTo(self.stepBtn, -1)
		et_node_bg:setName("et_node_bg_less")
	end
	if et_node_top then
		et_node_top:setVisible(true)
	else
		et_node_top = SoraDCreateEffectNode(param_top)
		et_node_top:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_top:addTo(self.stepBtn, 1)
		et_node_top:setName("et_node_top_less")
	end
end
function EliminateGameViewPanel:doubleAttackEffect(isHide)
	if not self.doubleBtn then
		return
	end
	self.et_btn_double:setVisible(not isHide)
end
function EliminateGameViewPanel:doubleChessEffect(isRemove)
	if isRemove == nil then
		self:doubleAttackChessBgEffect()
	else
		self:doubleAttackChessBgEffect(true)
	end
end
function EliminateGameViewPanel:shakeEffect(target, time, params)
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function EliminateGameViewPanel:showMonsterEffect(target)
	local imgName = "dh_9001629_hit_%02d.png"
	local sp = display.newSprite(string.format("#%s", string.format(imgName, 1)))
	sp:setName("attack_effect")
	sp:stopAllActions()
	local frames = display.newFrames(imgName, 1, 29)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	sp:playAnimationOnce(animation, true)
	sp:addTo(self.fields.Node_boom)
	sp:setPosition(cc.p((0.5 - math.random(10) / 10) * 150, 50 + (0.5 - math.random(10) / 10) * 150))
	sp:setScale(1.8)
	sp:setBlendFunc(gl.ONE, gl.ONE)
end
function EliminateGameViewPanel:bloodEffect(isHide)
	return
end
function EliminateGameViewPanel:getDisposeEffectSingle(...)
	if not self.disposeEffectList then
		self.disposeEffectList, _ENV = self.disposeEffectList, self.disposeEffectList
	end
	if #self.disposeEffectList > 0 then
		local effect = table.remove(self.disposeEffectList)
		effect:setVisible(true)
		return effect
	end
	local effect = SoraDCreatAnimationEx("gwdzz_xiaochu", nil, false)
	effect:addTo(self.layout)
	effect.nodeList, _ENV = effect.addTo, effect.addTo
	for i, v in ipairs(effect:getChildren()) do
		v:setVisible(false)
	end
	_ENV = (for generator)
	ipairs(effect:getChildren())[ChessColorDef.red] = "red"
	ipairs(effect:getChildren())[ChessColorDef.yellow] = "yellow"
	ipairs(effect:getChildren())[ChessColorDef.purple] = "purple"
	local ipairs(effect:getChildren())[ChessColorDef.green], nodeNameTab = "green", ipairs(effect:getChildren())
	for k, v in pairs(nodeNameTab) do
		local node = effect:getChildByName(v)
		node:setPosition(cc.p(0, 0))
		effect.nodeList[k] = node
	end
	function effect.showColor(color)
		effect.action:gotoFrameAndPlay(0, false)
		for k, node in pairs(effect.nodeList) do
			node:setVisible(k == color)
		end
	end
	function effect.recycleSingle()
		effect:setVisible(false)
		table.insert(self.disposeEffectList, effect)
	end
	return effect
end
function EliminateGameViewPanel:onHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_stars_wishing_text31")
	uiManager:show("RuleView", nil)
end
function EliminateGameViewPanel:onDouble()
	SoraDPlaySound()
	if self.mulNum == 1 then
		local curDoubles = starsWishingGameCtrl:getCurDoubles()
		if curDoubles < 1 then
			local doubleCost = eliminateGameCommon.getDoubleCost()
			if SoraDEnoughGold(doubleCost) then
				local number = eliminateGameCommon.getAddDouble()
				_ENV = nil
				;(nil).gold = doubleCost
				;(nil).times = number
				local text = i18n("common_text_2546", nil)
				SoraDShowBuyBox(text, doubleCost, i18n("common_text_204"), function(event)
					if event == MSGBOX_CALLBACK_YES then
						starsWishingGameCtrl:sendDouble()
						self.doubleBtn:setTouchEnabled(false)
					end
				end)
			end
		else
			starsWishingGameCtrl:sendUseDouble()
			self.mulNum = 2
			self:updateUI()
			self:saveData()
		end
	else
		starsWishingGameCtrl:sendUseDouble()
		self.mulNum = 1
		self:updateUI()
		self:saveData()
	end
end
function EliminateGameViewPanel:onStep()
	SoraDPlaySound()
	self:buyStepBox()
end
function EliminateGameViewPanel:buyStepBox()
	local stepsCost = starsWishingGameCtrl:getStepsCost()
	local addStep = eliminateGameCommon.getAddStep()
	starsWishingGameCtrl = nil
	;(nil).remainStep = self.stepNum
	;(nil).gold = stepsCost
	;(nil).addStep = addStep
	local text = i18n("common_text_2547", nil)
	text = text .. "\n" .. i18n("common_text_2625")
	if starsWishingGameCtrl:getIsHaveFreePlusTimes() then
		starsWishingGameCtrl = "common_text_2625"
		;("common_text_2625").msg = text
		;("common_text_2625").handle = function(event)
			starsWishingGameCtrl:sendPlusStep(self.stepNum)
		end
		;("common_text_2625").gold = stepsCost
		uiManager:show("EliminateFreeView", "common_text_2625")
	else
		SoraDShowBuyBox(text, stepsCost, i18n("common_text_204"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				starsWishingGameCtrl:sendPlusStep(self.stepNum)
			end
		end)
	end
end
function EliminateGameViewPanel:onRetry()
	SoraDPlaySound()
	if starsWishingGameCtrl:getIsDayLimit() then
		SoraDShowMsgTip(i18n("common_text_2538"))
		return
	end
	eliminateGameCommon.restartGame(handler(self, self.resetGame))
end
function EliminateGameViewPanel:onBtnAward()
	SoraDPlaySound()
	print("TODO: 打开奖励预览界面-------")
	_ENV = nil
	;(nil).level = self.isAllFinish and self.level + 1 or self.level
	;(nil).levelCfgs = self.levelConfig
	uiManager:show("EliminateGamePreview", nil)
end
function EliminateGameViewPanel:onKO(target, data)
	SoraDCloseLoading(self)
	if data.errCode == gErrDef.Err_None then
		if self.isAllFinish then
			self:enterLevel(self.level)
			self:saveData()
			return
		end
		self.level = self.level + 1
		if self.level > #self.levelConfig then
			self:playWin(data.rewards)
		else
			self:playNext(data.rewards)
		end
	else
		self.stepNum = starsWishingGameCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		_ENV = self
		self.err = data.errCode
		msgNotice.rspNotice(self)
	end
end
function EliminateGameViewPanel:onDoubleBack(target, data)
	self.doubleBtn:setTouchEnabled(true)
	if data.errCode == gErrDef.Err_None then
		self.mulNum = 2
		starsWishingGameCtrl:sendUseDouble()
		self:updateUI()
		self:saveData()
	else
		_ENV = self
		self.err = data.errCode
		msgNotice.rspNotice(self)
	end
end
function EliminateGameViewPanel:onStepBack(target, data)
	if data.errCode == gErrDef.Err_None then
		self.stepNum = data.step
		self:updateUI()
		self:saveData()
	end
end
function EliminateGameViewPanel:onHurtBack(target, data)
	if data.errCode == gErrDef.Err_None then
		self.killSum = data.killSum
		self.curHP = starsWishingGameCtrl.dataTable.hp
		if data.rewards then
			self.hurtRewards = data.rewards
			self.curHP = 0
		end
		if self.playHurtFinish then
			self:playHurt()
			self.playHurtFinish = false
		end
	else
		self.stepNum = starsWishingGameCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		_ENV = self
		self.err = data.errCode
		msgNotice.rspNotice(self)
	end
end
function EliminateGameViewPanel:onOldDamageBack(target, data)
	if data.errCode == gErrDef.Err_None then
		self:saveData()
	end
end
function EliminateGameViewPanel:onUseStepBack(target, data)
	if data.errCode == gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR or data.errCode == gErrDef.Err_SIEGE_COMBAT_CHECK_STEPS_ERROR then
		self.stepNum = starsWishingGameCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		_ENV = self
		self.err = data.errCode
		msgNotice.rspNotice(self)
	end
end
function EliminateGameViewPanel:gameGuide_getTarget(itemName, parameters)
	local chess1, chess2
	if itemName == "chessListSingle" then
		chess1 = self.chessList[self:conv(parameters.chessPos[1][1], parameters.chessPos[1][2])]
		chess2 = self.chessList[self:conv(parameters.chessPos[2][1], parameters.chessPos[2][2])]
		if chess1 and chess2 and chess1:getParent():getChildByName("spriteHand") == nil then
			local chess1Pos = cc.p(chess1:getPositionX(), chess1:getPositionY())
			local chess2Pos = cc.p(chess2:getPositionX(), chess2:getPositionY())
			local spriteHand = SoraDFingerAction(true, true)
			spriteHand:setName("spriteHand")
			spriteHand:addTo(chess1:getParent(), 1)
			_UPVALUE7_ = chess2:getPositionY()
			chess2:getPositionY()[1] = cca.callFunc(function(...)
				spriteHand:setPosition(cc.p(chess1Pos.x, chess1Pos.y))
				spriteHand:setVisible(true)
			end)
			chess2:getPositionY()[2] = cca.fadeIn(0.1)
			chess2:getPositionY()[3] = cca.moveTo(1, chess2Pos.x, chess2Pos.y)
			chess2:getPositionY()[4] = cca.delay(0.2)
			chess2:getPositionY()[5] = cca.fadeOut(0.1)
			chess2:getPositionY()[6] = cca.callFunc(function(...)
				spriteHand:setVisible(false)
			end)
			chess2:getPositionY()[7] = cca.delay(0.5)
			chess2:getPositionY()[8] = cca.callFunc(function(target)
				if SoraDIsGameGuide() ~= 18001 then
					spriteHand:removeFromParent()
				end
			end)
			chess2:getPositionY()[9] = cca.callFunc(function(target)
				if SoraDIsGameGuide() ~= 18001 then
					spriteHand:removeFromParent()
				end
			end)
			spriteHand:runAction(cca.repeatForever(cca.seq(chess2:getPositionY())))
		end
	end
	return self.touchMask
end
return EliminateGameViewPanel

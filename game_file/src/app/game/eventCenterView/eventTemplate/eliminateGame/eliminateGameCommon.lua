local gametop = gModuleMgr.getObject("gametop")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local _ENV, eliminateGameCommon = gametop.playertop_, gametop.playertop_
function eliminateGameCommon.enterGame()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	local castleLV = castleBcell.info.lv
	if tonumber(castleLV) < CASTLE_LV8_LIMITED then
		gametop = nil
		;(nil).blv = CASTLE_LV8_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
		return
	else
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SIEGE_COMBAT)
		if eventState ~= gActivityState.OPEN then
			SoraDShowMsgTip(i18n("common_text_699"))
			return
		end
	end
	local openView = function()
		local panel = SoraDCreatePanel("eliminateGameView")
		panel:initData(siegeCombatCtrl.dataTable)
		panel:show()
	end
	if siegeCombatCtrl:isOpen() then
		openView()
	else
		eliminateGameCommon.restartGame(openView)
	end
end
function eliminateGameCommon.restartGame(cb)
	local ticketCost = siegeCombatCtrl:getTicketCost()
	local ticketNum = backpackCtrl:getItemCount(803601)
	local box = SoraDCreatePanel("eliminateGameBox")
	local content = i18n("common_text_2536")
	local sendFinish = true
	if ticketCost == 0 then
		siegeCombatCtrl = nil
		;(nil).text = i18n("common_text_2537")
		;(nil).cb = function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(1)
			end
		end
		local (nil).notClose, param1 = true, nil
		box:initData(1, content, param1, nil)
		box:show()
	elseif 0 < ticketNum then
		siegeCombatCtrl = nil
		;(nil).text = "X" .. 1
		;(nil).icon = "8036.png"
		;(nil).cb = function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end
		local siegeCombatCtrl, (nil).notClose, param1 = function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end, true, nil
		;(function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end).text = "X" .. ticketCost
		;(function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end).icon = "icon_small_gold.png"
		;(function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end).cb = function()
			if SoraDEnoughGold(ticketCost) and sendFinish then
				siegeCombatCtrl:sendEnter(3)
			end
		end
		local (function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end).notClose, param2 = true, function()
			if sendFinish then
				siegeCombatCtrl:sendEnter(2)
			end
		end
		box:initData(2, content, param1, param2)
		box:show()
	else
		siegeCombatCtrl = nil
		;(nil).text = "X" .. 1
		;(nil).textColor = cc.c3b(255, 0, 0)
		;(nil).icon = "8036.png"
		;(nil).cb = function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
		local siegeCombatCtrl, (nil).notClose, param1 = function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end, true, nil
		;(function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end).text = "X" .. ticketCost
		;(function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end).icon = "icon_small_gold.png"
		;(function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end).cb = function()
			if SoraDEnoughGold(ticketCost) and sendFinish then
				siegeCombatCtrl:sendEnter(3)
			end
		end
		local (function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end).notClose, param2 = true, function()
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
		box:initData(2, content, param1, param2)
		box:show()
	end
	box:addMessage("MESSAGE_SERVER_ELIMINATEGAME_ENTER", function(target, data)
		if data.errCode == gErrDef.Err_None then
			cb()
			target:close(target, ccui.TouchEventType.ended)
		elseif data.errCode == gErrDef.Err_SIEGE_COMBAT_MAX_ENTER_COUNT then
			SoraDShowMsgTip(i18n("common_text_2538"))
		elseif data.errCode == gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED then
			sendFinish = i18n("common_text_2538")
			i18n("common_text_2538").level = CASTLE_LV8_LIMITED
			SoraDShowMsgTip(i18n("common_text_2417", i18n("common_text_2538")))
		end
	end)
end
function eliminateGameCommon.getStepCost()
	local stepCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_step")
	local buyCount = siegeCombatCtrl:getSteps() + 1
	if buyCount > #stepCostConfig then
		buyCount = #stepCostConfig
	end
	return stepCostConfig[buyCount].price
end
function eliminateGameCommon.getDoubleCost()
	local doubleCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_exp")
	local buyCount = siegeCombatCtrl:getDoubles() + 1
	if buyCount > #doubleCostConfig then
		buyCount = #doubleCostConfig
	end
	return doubleCostConfig[buyCount].price
end
function eliminateGameCommon.getAddStep()
	local stepCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_step")
	local buyCount = siegeCombatCtrl:getSteps() + 1
	if buyCount > #stepCostConfig then
		buyCount = #stepCostConfig
	end
	return stepCostConfig[buyCount].step
end
function eliminateGameCommon.getAddDouble()
	local doubleCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_exp")
	local buyCount = siegeCombatCtrl:getDoubles() + 1
	if buyCount > #doubleCostConfig then
		buyCount = #doubleCostConfig
	end
	return doubleCostConfig[buyCount].number
end
function eliminateGameCommon.getRewardPrice()
	local RewardTbl = require("app." .. LocalTblPath .. ".config_client.attack_activity_show")
	return RewardTbl
end
function eliminateGameCommon.conv(row, col)
	if type(row) == "table" then
		return row.row .. "," .. row.col
	end
	return row .. "," .. col
end
function eliminateGameCommon.initFirstFightChessboard()
	local firstFightConfig = require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight")
	local _ENV, chessboard = "app." .. LocalTblPath .. ".config_client.attack_monster_first_fight", "app." .. LocalTblPath .. ".config_client.attack_monster_first_fight"
	for row, rowData in ipairs(firstFightConfig) do
		for col = 1, #rowData do
			chessboard[eliminateGameCommon.conv(row, col)] = rowData[col]
		end
	end
	return chessboard
end
function eliminateGameCommon.getChessIcon(color)
	_UPVALUE4_ = nil
	;(nil)[1] = "icon_attack_monster_red.png"
	;(nil)[2] = "icon_attack_monster_yellow.png"
	;(nil)[3] = "icon_attack_monster_purple.png"
	local (nil)[4], icons = "icon_attack_monster_green.png", nil
	return icons[color]
end
_ENV, eliminateGameCommon.isNeighbour = function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end, function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).NONE = -1
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).LEFT = 0
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).UP = 1
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).RIGHT = 2
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).DOWN = 3
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).UP_LEFT = 4
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).UP_RIGHT = 5
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).DOWN_RIGHT = 6
local _ENV, (function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end).DOWN_LEFT, SwapDirection = nil, 7, function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end
_ENV = nil
;(nil).judgeType = 0
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), 0
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil)[SwapDirection.LEFT], (nil).desc = nil, "SwapDirection.LEFT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), 0
;(nil)[SwapDirection.UP], (nil).desc = nil, "SwapDirection.UP"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), 0
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), 1
;(nil)[SwapDirection.RIGHT], (nil).desc = nil, "SwapDirection.RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), 0
;(nil)[SwapDirection.DOWN], (nil).desc = nil, "SwapDirection.DOWN"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil)[SwapDirection.UP_LEFT], (nil).desc = nil, "SwapDirection.UP_LEFT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), 1
;(nil)[SwapDirection.UP_RIGHT], (nil).desc = nil, "SwapDirection.UP_RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), 1
;(nil)[SwapDirection.DOWN_RIGHT], (nil).desc = nil, "SwapDirection.DOWN_RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), -1
;(nil)[SwapDirection.DOWN_LEFT], (nil).desc = nil, "SwapDirection.DOWN_LEFT"
local AngleSec
function eliminateGameCommon.judgeDirection(angle)
	for k, v in pairs(SwapDirection) do
		local angleSec = AngleSec[v]
		if angleSec then
			local min = angleSec.min
			local max = angleSec.max
			local judgeType = angleSec.judgeType
			if judgeType == 0 then
				if angle < min or angle >= max then
					return v
				end
			elseif angle < max and angle >= min then
				return v
			end
		end
	end
	return SwapDirection.NONE
end
function eliminateGameCommon.getDirectionVec(angle)
	local direction = eliminateGameCommon.judgeDirection(angle)
	if direction == SwapDirection.NONE then
		return
	end
	return AngleSec[direction].directionVec
end
function eliminateGameCommon.creataBloodEffect()
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_monsterfight03_01.plist"
	;(nil).scale = 1.452
	_ENV, (nil).rotate = nil, 90
	;(nil).x = 16
	_ENV, (nil)[1], (nil).pos, (nil).y = nil, nil, nil, -2
	;(nil).plist = "et_monsterfight03_02.plist"
	;(nil).scale = 0.972
	_ENV, (nil).rotate = nil, 90
	;(nil).x = 4
	_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, -2
	;(nil).plist = "et_monsterfight03_03.plist"
	;(nil).scale = 3.168
	;(nil)[3], (nil).rotate = nil, -90
	local param
	local et_node = SoraDCreateEffectNode(param)
	if not SoraDFIsRA() then
		et_node:setScaleX(-1)
	end
	return et_node
end
return eliminateGameCommon

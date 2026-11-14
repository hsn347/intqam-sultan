local gametop = gModuleMgr.getObject("gametop")
local starsWishingGameCtrl = gametop.playertop_:getModule("starsWishingGameCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local _ENV, starsWishingGameCommon = gametop.playertop_, gametop.playertop_
function starsWishingGameCommon.enterGame()
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
		local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001629)
		if eventState ~= gActivityState.OPEN then
			SoraDShowMsgTip(i18n("common_text_699"))
			return
		end
	end
	local openView = function()
		uiManager:show("EliminateGameView")
	end
	if starsWishingGameCtrl:isOpen() then
		openView()
	else
		starsWishingGameCtrl:sendEnter(1)
	end
end
function starsWishingGameCommon.restartGame(cb)
	if cb then
		cb()
	end
end
function starsWishingGameCommon.getStepCost()
	local stepCostConfig = require("app." .. LocalTblPath .. ".config_server.stars_wishing_steps_gold")
	local buyCount = starsWishingGameCtrl:getSteps() + 1
	if buyCount > #stepCostConfig then
		buyCount = #stepCostConfig
	end
	return stepCostConfig[buyCount].price
end
function starsWishingGameCommon.getDoubleCost()
	local doubleCostConfig = require("app." .. LocalTblPath .. ".config_server.stars_wishing_double_gold")
	local buyCount = starsWishingGameCtrl:getDoubles() + 1
	if buyCount > #doubleCostConfig then
		buyCount = #doubleCostConfig
	end
	return doubleCostConfig[buyCount].price
end
function starsWishingGameCommon.getAddStep()
	local stepCostConfig = require("app." .. LocalTblPath .. ".config_server.stars_wishing_steps_gold")
	local buyCount = starsWishingGameCtrl:getSteps() + 1
	if buyCount > #stepCostConfig then
		buyCount = #stepCostConfig
	end
	return stepCostConfig[buyCount].step
end
function starsWishingGameCommon.getAddDouble()
	local doubleCostConfig = require("app." .. LocalTblPath .. ".config_server.stars_wishing_double_gold")
	local buyCount = starsWishingGameCtrl:getDoubles() + 1
	if buyCount > #doubleCostConfig then
		buyCount = #doubleCostConfig
	end
	return doubleCostConfig[buyCount].number
end
function starsWishingGameCommon.getRewardPrice()
	local RewardTbl = require("app." .. LocalTblPath .. ".config_server.stars_wishing_special_reward")
	return RewardTbl
end
function starsWishingGameCommon.conv(row, col)
	if type(row) == "table" then
		return row.row .. "," .. row.col
	end
	return row .. "," .. col
end
function starsWishingGameCommon.getChessIcon(color)
	_UPVALUE4_ = nil
	;(nil)[1] = "icon_attack_monster_red.png"
	;(nil)[2] = "icon_attack_monster_yellow.png"
	;(nil)[3] = "icon_attack_monster_purple.png"
	local (nil)[4], icons = "icon_attack_monster_green.png", nil
	return icons[color]
end
_ENV, starsWishingGameCommon.isNeighbour = function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end, function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end).NONE = -1
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end).LEFT = 0
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end).UP = 1
;(function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end).RIGHT = 2
local _ENV, (function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
		return true
	else
		return false
	end
end).DOWN, SwapDirection = nil, 3, function(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and math.abs(p1.col - p2.col) == 0 or 1 >= math.abs(p1.col - p2.col) and math.abs(p1.row - p2.row) == 0 then
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
local AngleSec
function starsWishingGameCommon.judgeDirection(angle)
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
function starsWishingGameCommon.getDirectionVec(angle)
	local direction = starsWishingGameCommon.judgeDirection(angle)
	if direction == SwapDirection.NONE then
		return
	end
	return AngleSec[direction].directionVec
end
function starsWishingGameCommon.creataBloodEffect()
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
return starsWishingGameCommon

local PLAYER_COUNT = 3
local PLAYER_SELF_INDEX = 3
local POKER_COUNT = 54
local POKER_PER_PLAYER = POKER_COUNT / PLAYER_COUNT
local POKER_SUIT_COUNT = 4
local AI_OUT_CARD_TIME = 5
local PLAYER_OUT_CARD_TIME = 15
_ENV = nil
;(nil).Kings = 0
;(nil).Spades = 1
;(nil).Hearts = 2
;(nil).Clubs = 3
local _ENV, (nil).Diamonds, POKER_SUIT = nil, 4, nil
;(nil)["3"] = 3
;(nil)["4"] = 4
;(nil)["5"] = 5
;(nil)["6"] = 6
;(nil)["7"] = 7
;(nil)["8"] = 8
;(nil)["9"] = 9
;(nil)["10"] = 10
;(nil).J = 11
;(nil).Q = 12
;(nil).K = 13
;(nil).A = 14
;(nil)["2"] = 15
;(nil).JK1 = 16
local _ENV, (nil).JK2, POKER_RANK = nil, 17, nil
;(nil).ONE = 1
;(nil).TWO = 2
;(nil).THREE = 3
;(nil).STRAIGHT = 4
;(nil).STRAIGHT_PAIR = 5
;(nil).PLANE = 6
;(nil).PLANE_ONE = 7
;(nil).PLANE_TWO = 8
;(nil).THREE_ONE = 9
;(nil).THREE_PAIR = 10
;(nil).FOUR_TWO = 11
;(nil).FOUR_TWO_PAIR = 12
;(nil).BOMB_510K = 13
;(nil).BOMB_NORMAL = 14
;(nil).BOMB_REAL_510K = 15
local _ENV, (nil).BOMB_KING, CARD_TYPE = nil, 16, nil
;(nil)["5"] = 5
;(nil)["10"] = 10
local _UPVALUE3_, (nil).K, SCORE_CARD_RANK = nil, 10, nil
_UPVALUE4_, (nil)[1] = "大你", "大你"
_UPVALUE4_, (nil)[2] = "大你", "管上"
local _UPVALUE4_, (nil)[3], BIGGER_TALK = "大你", "压死", nil
_ENV, ("大你")[1] = "过", "过"
_ENV, ("大你")[2] = "过", "不要"
_ENV, ("大你")[3] = "过", "要不起"
local _ENV, ("大你")[4], PASS_TALK = "过", "Pass", "大你"
;("过")[CARD_TYPE.BOMB_510K] = "510K"
;("过")[CARD_TYPE.BOMB_NORMAL] = "炸弹"
;("过")[CARD_TYPE.BOMB_REAL_510K] = "真510K"
local ("过")[CARD_TYPE.BOMB_KING], BOMB_TALK = "王炸", "过"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FiveTenKGamePanel = class("FiveTenKGamePanel", baseFguiPanel)
function FiveTenKGamePanel:ctor(...)
	self.isLRU = true
	FiveTenKGamePanel.super.ctor(self, ...)
	print("FiveTenKGamePanel:ctor", self.viewName)
end
function FiveTenKGamePanel:onInit()
	print("=======FiveTenKGamePanel:onInit")
	self.fields.List_self:setRotation(SoraDFIsRA() and 180 or 0)
	self.fields.List_show:setRotation(SoraDFIsRA() and 180 or 0)
	self.fields.List_self:setItemRenderer(handler(self, self.itemRenderer_List_self))
	self.fields.List_show:setItemRenderer(handler(self, self.itemRenderer_List_show))
	self.fields.Com_title:initData(i18n("510K"), handler(self, self.onClickClose))
	self.fields.Btn_refresh:setString(i18n("我要验牌"))
	self.fields.Btn_refresh:addClickListener(handler(self, self.btnClickRefresh))
	self.fields.Btn_out:setString(i18n("出牌"))
	self.fields.Btn_out:addClickListener(handler(self, self.btnClickOut))
	self.fields.Btn_skip:setString(i18n("跳过"))
	self.fields.Btn_skip:addClickListener(handler(self, self.btnClickSkip))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeEndListener(handler(self, self.onOutCardTimeEnd))
	self.fields.Text_curTurnScore:setString("本轮分牌:")
	self.fields.List_score:setRotation(SoraDFIsRA() and 180 or 0)
	self.fields.List_score:setItemRenderer(handler(self, self.itemRenderer_List_score))
end
function FiveTenKGamePanel:onOutCardTimeEnd()
	if self.isGameOver then
		return
	end
	if self.turnIndex ~= PLAYER_SELF_INDEX then
		self:doAiTurn()
	elseif not self.isAiTurn then
		self.isAiTurn = true
		SoraDShowMsgTip(i18n("出牌时间到，您已被托管"))
		self:checkIsTurnSelf()
		self:startTurnTimer()
	else
		self:doAiTurn()
	end
end
function FiveTenKGamePanel:stopTurnTimer()
	self.Text_time:endTimeNoCauseEndCallBack()
end
function FiveTenKGamePanel:startTurnTimer()
	if self.isGameOver then
		self:stopTurnTimer()
		return
	end
	local sec = AI_OUT_CARD_TIME
	if self.turnIndex ~= PLAYER_SELF_INDEX then
		sec = AI_OUT_CARD_TIME
	elseif self.isAiTurn then
		sec = AI_OUT_CARD_TIME
	else
		sec = PLAYER_OUT_CARD_TIME
	end
	self.Text_time:beginTime(sec, false, true)
end
function FiveTenKGamePanel:endShow()
	print("=======FiveTenKGamePanel:endShow")
	self:init()
end
function FiveTenKGamePanel:initPokerList()
	self.pokerList, POKER_SUIT = nil, nil
	POKER_SUIT = nil
	;(nil).suit = POKER_SUIT.Kings
	;(nil).key = "JK2"
	self.pokerList[#self.pokerList + 1], (nil).rank = nil, POKER_RANK.JK2
	POKER_SUIT = nil
	;(nil).suit = POKER_SUIT.Kings
	;(nil).key = "JK1"
	self.pokerList[#self.pokerList + 1], (nil).rank = nil, POKER_RANK.JK1
	for _, suit in pairs(POKER_SUIT) do
		if suit > POKER_SUIT.Kings then
			for key, value in pairs(POKER_RANK) do
				if value ~= POKER_RANK.JK1 and value ~= POKER_RANK.JK2 then
					POKER_SUIT = nil
					;(nil).suit = suit
					;(nil).key = key
					self.pokerList[#self.pokerList + 1], (nil).rank = nil, value
				end
			end
		end
	end
	self:initPlayerPokerList()
end
function FiveTenKGamePanel:initPlayerPokerList()
	for i = 1, PLAYER_COUNT do
		self.playerPokerList[i], PLAYER_COUNT = nil, nil
	end
	local deck = self.pokerList
	if #deck ~= POKER_COUNT then
		print("[FiveTenKGamePanel] initPlayerPokerList deck size mismatch:", #deck, "expected", POKER_COUNT)
		return
	end
	for i = #deck, 2, -1 do
		local j = math.random(1, i)
		deck[i], deck[j] = deck[j], deck[i]
	end
	local idx = 1
	for p = 1, PLAYER_COUNT do
		for c = 1, POKER_PER_PLAYER do
			self.playerPokerList[p][c] = deck[idx]
			idx = idx + 1
		end
	end
	for p = 1, PLAYER_COUNT do
		table.sort(self.playerPokerList[p], function(a, b)
			if a.rank == b.rank then
				return a.suit < b.suit
			else
				return a.rank > b.rank
			end
		end)
	end
	self.pokerList, PLAYER_COUNT = 1, (for index)
end
function FiveTenKGamePanel:updateOtherPlayerPokerCount()
	for p = 1, PLAYER_COUNT do
		if p ~= PLAYER_SELF_INDEX then
			self.fields["Lab_num" .. tostring(p)]:setTitle(#self.playerPokerList[p])
		end
	end
end
function FiveTenKGamePanel:triggerTalk(index, isPass, cardType)
	local talkTarget = self.fields["Com_talk" .. index]
	if talkTarget then
		talkTarget:setVisible(true)
		local talkMsg
		if isPass then
			talkMsg = PASS_TALK[math.random(1, #PASS_TALK)]
		elseif cardType and BOMB_TALK[cardType] then
			talkMsg = BOMB_TALK[cardType]
		else
			talkMsg = BIGGER_TALK[math.random(1, #BIGGER_TALK)]
		end
		talkTarget:setTitle(talkMsg)
		_ENV = nil
		;(nil)[1] = ffa.delay(2)
		;(nil)[2] = ffa.callFunc(function()
			talkTarget:setVisible(false)
		end)
		;(nil)[3] = ffa.callFunc(function()
			talkTarget:setVisible(false)
		end)
		talkTarget:runAction(ffa.seq(nil))
	end
end
function FiveTenKGamePanel:updateSelfPlayerPoker()
	self.fields.List_self:setNumItems(#self.playerPokerList[PLAYER_SELF_INDEX])
end
function FiveTenKGamePanel:switchTurnIndex(index)
	if self.isGameOver then
		return
	end
	local prevTurnIndex = self.turnIndex
	local passCount = 0
	for p = 1, PLAYER_COUNT do
		if self.turnPass[p] then
			passCount = passCount + 1
		end
	end
	if 2 <= passCount and self.lastOutIndex then
		self:updateScore(self.lastOutIndex)
		self.showPokerList, PLAYER_COUNT, self.turnScoreList, PLAYER_COUNT, self.turnCardList, PLAYER_COUNT, self.turnPass, PLAYER_COUNT = self.updateScore, self.updateScore, self.updateScore, self.updateScore, self.updateScore, self.updateScore, self.updateScore, self.updateScore
		self:updateShowPokerList()
		self:updateTurnScoreList()
		self.turnIndex = self.lastOutIndex
		self.lastOutIndex = nil
	else
		self.turnIndex = index or self.turnIndex + 1
		if self.turnIndex > PLAYER_COUNT then
			self.turnIndex = 1
		end
	end
	if self.turnIndex == PLAYER_SELF_INDEX and prevTurnIndex ~= PLAYER_SELF_INDEX then
		self.isAiTurn = false
	end
	self:checkIsTurnSelf()
	self:startTurnTimer()
end
function FiveTenKGamePanel:updateTurnScoreList()
	if #self.turnScoreList > 0 then
		self.fields.List_score:setVisible(true)
		self.fields.Text_curTurnScore:setVisible(true)
		self.fields.List_score:setNumItems(#self.turnScoreList)
	else
		self.fields.List_score:setVisible(false)
		self.fields.Text_curTurnScore:setVisible(false)
	end
end
function FiveTenKGamePanel:init()
	self.turnPass, PLAYER_COUNT, self.turnScoreList, PLAYER_COUNT, self.turnCardList, PLAYER_COUNT, self.playerScore, PLAYER_COUNT, self.curChooseCard, PLAYER_COUNT, self.showPokerList, PLAYER_COUNT, self.playerPokerList, PLAYER_COUNT, self.pokerList, PLAYER_COUNT = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.lastOutIndex = nil
	self.isGameOver = false
	self.isAiTurn = false
	for p = 1, PLAYER_COUNT do
		self.playerScore[p] = 0
		self.fields["Lab_score" .. p]:setString("得分:" .. (self.playerScore[p] or 0))
		self.fields["Com_talk" .. p]:setVisible(false)
	end
	self:initPokerList()
	self:updateOtherPlayerPokerCount()
	self:updateSelfPlayerPoker()
	self:updateShowPokerList()
	self:updateTurnScoreList()
	self:countPoker()
	self.turnIndex = self:checkBlock3Player()
	PLAYER_COUNT = nil
	;(nil).index = self.turnIndex
	SoraDShowMsgTip(i18n("手上有方块3的玩家%{index}先出牌", nil))
	self:checkIsTurnSelf()
	self:startTurnTimer()
end
function FiveTenKGamePanel:onCardChoose(target, data)
	local isChoose = false
	for k, v in ipairs(self.curChooseCard) do
		if v.suit == data.data.suit and v.rank == data.data.rank then
			table.remove(self.curChooseCard, k)
			isChoose = true
			break
		end
	end
	if not isChoose then
		table.insert(self.curChooseCard, data.data)
	end
	self:updateSelfPlayerPoker()
end
function FiveTenKGamePanel:btnClickRefresh()
	self:init()
end
function FiveTenKGamePanel:btnClickSkip()
	if self.isGameOver then
		return
	end
	if self.turnIndex ~= PLAYER_SELF_INDEX or self.isAiTurn then
		return
	end
	if self.showPokerList and #self.showPokerList > 0 then
		self:triggerTalk(self.turnIndex, true)
	end
	self:stopTurnTimer()
	self.isAiTurn = false
	self.turnPass[self.turnIndex] = true
	self:switchTurnIndex()
end
function FiveTenKGamePanel:checkBlock3Player()
	for p = 1, PLAYER_COUNT do
		for _, card in ipairs(self.playerPokerList[p]) do
			if card.suit == POKER_SUIT.Diamonds and card.rank == POKER_RANK["3"] then
				return p
			end
		end
	end
	return PLAYER_SELF_INDEX
end
function FiveTenKGamePanel:checkIsTurnSelf()
	local isTurnSelf = self.turnIndex == PLAYER_SELF_INDEX
	self.fields.Btn_out:setVisible(isTurnSelf)
	self.fields.Btn_skip:setVisible(isTurnSelf)
	print("checkIsTurnSelf self.turnIndex:", self.turnIndex)
	for i = 1, 2 do
		self.fields["Lab_num" .. i]:getChild("sheer"):setVisible(i == self.turnIndex)
	end
end
function FiveTenKGamePanel:updateScore(scoreTo)
	local score = 0
	if not self.turnCardList then
		_ENV = self.turnCardList
	end
	for _, card in ipairs(self.turnCardList) do
		local v = SCORE_CARD_RANK[card.key]
		if v then
			score = score + v
		end
	end
	self.playerScore[scoreTo] = (self.playerScore[scoreTo] or 0) + score
	self.fields["Lab_score" .. scoreTo]:setString("得分:" .. tostring(self.playerScore[scoreTo]))
end
function FiveTenKGamePanel:itemRenderer_List_score(index, obj)
	local data = self.turnScoreList[index + 1]
	obj:initData(data)
end
local cloneCards = function(cards)
	local _UPVALUE0_, t
	for i = 1, #cards do
		t[#t + 1] = cards[i]
	end
	return t
end
local isJokerRank = function(rank)
	return rank == POKER_RANK.JK1 or rank == POKER_RANK.JK2
end
local countRanks = function(cardList)
	local _ENV, rankCount
	local _ENV, jokers
	for _, card in ipairs(cardList) do
		local r = card.rank
		if isJokerRank(r) then
			jokers[#jokers + 1] = r
		else
			rankCount[r] = (rankCount[r] or 0) + 1
		end
	end
	return rankCount, jokers
end
local countValuesDesc = function(rankCount)
	local _ENV, vals
	for _, c in pairs(rankCount) do
		vals[#vals + 1] = c
	end
	table.sort(vals, function(a, b)
		return b < a
	end)
	return vals
end
local isRankStraight = function(rankCount, num)
	local _ENV, ranks
	local need = num or 1
	for r, v in pairs(rankCount) do
		if v >= need then
			ranks[#ranks + 1] = r
		end
	end
	table.sort(ranks, function(a, b)
		return a < b
	end)
	if #ranks < 2 then
		return #ranks == 1 and ranks[1] <= POKER_RANK.A
	end
	for i = 1, #ranks - 1 do
		if ranks[i] ~= ranks[i + 1] - 1 or ranks[i] > POKER_RANK.A then
			return false
		end
	end
	return true
end
local is510KThreeCards = function(cardList)
	if #cardList ~= 3 then
		return false
	end
	POKER_RANK = false
	;(false)[POKER_RANK["5"]] = 1
	;(false)[POKER_RANK["10"]] = 1
	local (false)[POKER_RANK.K], need = 1, false
	for _, card in ipairs(cardList) do
		if isJokerRank(card.rank) then
			return false
		end
		local n = need[card.rank]
		if not n or n < 1 then
			return false
		end
		need[card.rank] = n - 1
	end
	for _, v in pairs(need) do
		if v ~= 0 then
			return false
		end
	end
	return true
end
local isReal510K = function(cardList)
	if not is510KThreeCards(cardList) then
		return false
	end
	local s = cardList[1].suit
	if s < 1 or 4 < s then
		return false
	end
	for i = 2, 3 do
		if cardList[i].suit ~= s then
			return false
		end
	end
	return true
end
local isStraight = function(cardList)
	local rankCount, jokers = countRanks(cardList)
	if 0 < #jokers then
		return false
	end
	if #cardList < 5 then
		return false
	end
	if not isRankStraight(rankCount, 1) then
		return false
	end
	local vals = countValuesDesc(rankCount)
	for i = 1, #vals do
		if vals[i] ~= 1 then
			return false
		end
	end
	return true
end
local isStraightPair = function(cardList)
	local rankCount, jokers = countRanks(cardList)
	if 0 < #jokers then
		return false
	end
	if #cardList < 6 or #cardList % 2 ~= 0 then
		return false
	end
	if not isRankStraight(rankCount, 2) then
		return false
	end
	local vals = countValuesDesc(rankCount)
	for i = 1, #vals do
		if vals[i] ~= 2 then
			return false
		end
	end
	return true
end
local getValueCount = function(vals, value)
	local count = 0
	for _, v in ipairs(vals) do
		if v == value then
			count = count + 1
		end
	end
	return count
end
local isPlane = function(cardList)
	local rankCount, jokers = countRanks(cardList)
	if 0 < #jokers then
		return false
	end
	if #cardList < 6 or #cardList % 3 ~= 0 then
		return false
	end
	if not isRankStraight(rankCount, 3) then
		return false
	end
	local vals = countValuesDesc(rankCount)
	return getValueCount(vals, 3) >= 2
end
local isPlaneOne = function(cardList)
	local rankCount, jokers = countRanks(cardList)
	if 0 < #jokers then
		return false
	end
	if #cardList < 8 or #cardList % 4 ~= 0 then
		return false
	end
	if not isRankStraight(rankCount, 3) then
		return false
	end
	local vals = countValuesDesc(rankCount)
	return getValueCount(vals, 3) == getValueCount(vals, 1)
end
local isPlaneTwo = function(cardList)
	local rankCount, jokers = countRanks(cardList)
	if 0 < #jokers then
		return false
	end
	if #cardList < 10 or #cardList % 5 ~= 0 then
		return false
	end
	if not isRankStraight(rankCount, 3) then
		return false
	end
	local vals = countValuesDesc(rankCount)
	return getValueCount(vals, 3) == getValueCount(vals, 2)
end
function FiveTenKGamePanel:checkCardType(cardList)
	if not cardList or #cardList == 0 then
		return nil
	end
	local n = #cardList
	local rankCount, jokers = countRanks(cardList)
	local jn = #jokers
	if n == 1 then
		return CARD_TYPE.ONE
	end
	local vals = countValuesDesc(rankCount)
	if n == 2 then
		if jn == 2 then
			return CARD_TYPE.BOMB_KING
		end
		if #vals == 1 and vals[1] == 2 then
			return CARD_TYPE.TWO
		end
	end
	if n == 3 then
		if is510KThreeCards(cardList) then
			return isReal510K(cardList) and CARD_TYPE.BOMB_REAL_510K or CARD_TYPE.BOMB_510K
		end
		if #vals == 1 and vals[1] == 3 then
			return CARD_TYPE.THREE
		end
	end
	if n == 4 then
		if #vals == 1 and vals[1] == 4 then
			return CARD_TYPE.BOMB_NORMAL
		end
		if #vals == 2 and vals[1] == 3 and vals[2] == 1 then
			return CARD_TYPE.THREE_ONE
		end
	end
	if n == 5 and #vals == 2 and vals[1] == 3 and vals[2] == 2 then
		return CARD_TYPE.THREE_PAIR
	end
	if n == 6 and #vals == 3 and vals[1] == 4 and vals[2] == 1 and vals[3] == 1 then
		return CARD_TYPE.FOUR_TWO
	end
	if n == 8 and #vals == 3 and vals[1] == 4 and vals[2] == 2 and vals[3] == 2 then
		return CARD_TYPE.FOUR_TWO_PAIR
	end
	if isStraight(cardList) then
		return CARD_TYPE.STRAIGHT
	end
	if isStraightPair(cardList) then
		return CARD_TYPE.STRAIGHT_PAIR
	end
	if isPlane(cardList) then
		return CARD_TYPE.PLANE
	end
	if isPlaneOne(cardList) then
		return CARD_TYPE.PLANE_ONE
	end
	if isPlaneTwo(cardList) then
		return CARD_TYPE.PLANE_TWO
	end
	return nil
end
function FiveTenKGamePanel:countPoker()
	self.fields.Com_num:initData(self.playerPokerList)
end
function FiveTenKGamePanel:aiOutCard()
	local hand = self.playerPokerList and self.playerPokerList[self.turnIndex]
	if not hand or #hand == 0 then
		return nil
	end
	local buildRankBuckets = function(cards)
		local _ENV, buckets
		for _, c in ipairs(cards) do
			if not buckets[c.rank] then
				_ENV = buckets[c.rank]
			end
			buckets[c.rank] = buckets[c.rank]
			buckets[c.rank][#buckets[c.rank] + 1] = c
		end
		for _, list in pairs(buckets) do
			table.sort(list, function(a, b)
				return a.suit < b.suit
			end)
		end
		return buckets
	end
	local sortedRanksByCount = function(buckets, needCount, minRank, maxRank)
		local _ENV, ranks
		for r, list in pairs(buckets) do
			if needCount <= #list and (not minRank or minRank <= r) and (not maxRank or r <= maxRank) then
				ranks[#ranks + 1] = r
			end
		end
		table.sort(ranks, function(a, b)
			return a < b
		end)
		return ranks
	end
	local removeUsedFromBuckets = function(buckets, usedCards)
		local _ENV, used
		for _, c in ipairs(usedCards) do
			used[c] = (used[c] or 0) + 1
		end
		local _ENV, copyBuckets = (for generator), ipairs(usedCards)
		for r, list in pairs(buckets) do
			copyBuckets[r], _ENV = nil, nil
			for _, c in ipairs(list) do
				if used[c] and 0 < used[c] then
					used[c] = used[c] - 1
				else
					copyBuckets[r][#copyBuckets[r] + 1] = c
				end
			end
		end
		return copyBuckets
	end
	local pickSingles = function(buckets, n)
		local sortedRanksByCount, ret
		local ranks = sortedRanksByCount(buckets, 1)
		for _, r in ipairs(ranks) do
			for i = 1, #buckets[r] do
				ret[#ret + 1] = buckets[r][i]
				if #ret == n then
					return ret
				end
			end
		end
		return nil
	end
	local pickPairs = function(buckets, n)
		local sortedRanksByCount, ret
		local ranks = sortedRanksByCount(buckets, 2)
		for _, r in ipairs(ranks) do
			ret[#ret + 1] = buckets[r][1]
			ret[#ret + 1] = buckets[r][2]
			if #ret == n * 2 then
				return ret
			end
		end
		return nil
	end
	local concatCards = function(a, b)
		local ret = cloneCards(a)
		for _, c in ipairs(b) do
			ret[#ret + 1] = c
		end
		return ret
	end
	local findBestStraight = function(buckets, needEach, seqLen, minHighRank)
		local ranks = sortedRanksByCount(buckets, needEach, POKER_RANK["3"], POKER_RANK.A)
		if #ranks == 0 then
			return nil
		end
		local i = 1
		while i <= #ranks do
			local j = i
			while j < #ranks and ranks[j + 1] == ranks[j] + 1 do
				j = j + 1
			end
			local runLen = j - i + 1
			if seqLen <= runLen then
				for start = i, j - seqLen + 1 do
					local highRank = ranks[start + seqLen - 1]
					if not minHighRank or minHighRank < highRank then
						local sortedRanksByCount, ret
						for k = 0, seqLen - 1 do
							local rr = ranks[start + k]
							for c = 1, needEach do
								ret[#ret + 1] = buckets[rr][c]
							end
						end
						return ret
					end
				end
			end
			i = j + 1
		end
		return nil
	end
	local findPlanePlay = function(buckets, groupCount, minHighRank, attachMode)
		local tripRanks = sortedRanksByCount(buckets, 3, POKER_RANK["3"], POKER_RANK.A)
		if #tripRanks == 0 then
			return nil
		end
		local i = 1
		while i <= #tripRanks do
			local j = i
			while j < #tripRanks and tripRanks[j + 1] == tripRanks[j] + 1 do
				j = j + 1
			end
			if groupCount <= j - i + 1 then
				for start = i, j - groupCount + 1 do
					local highRank = tripRanks[start + groupCount - 1]
					if not minHighRank or minHighRank < highRank then
						local sortedRanksByCount, body
						for k = 0, groupCount - 1 do
							local rr = tripRanks[start + k]
							body[#body + 1] = buckets[rr][1]
							body[#body + 1] = buckets[rr][2]
							body[#body + 1] = buckets[rr][3]
						end
						if not attachMode then
							return body
						end
						local remain = removeUsedFromBuckets(buckets, body)
						if attachMode == "one" then
							local singles = pickSingles(remain, groupCount)
							if singles then
								return concatCards(body, singles)
							end
						elseif attachMode == "pair" then
							local pairs = pickPairs(remain, groupCount)
							if pairs then
								return concatCards(body, pairs)
							end
						end
					end
				end
			end
			i = j + 1
		end
		return nil
	end
	local buildBombCandidates = function(buckets)
		local _ENV, bombs
		for _, r in ipairs(sortedRanksByCount(buckets, 4)) do
			_ENV = sortedRanksByCount(buckets, 4)
			_UPVALUE4_, sortedRanksByCount(buckets, 4).cardType = CARD_TYPE.BOMB_NORMAL, CARD_TYPE.BOMB_NORMAL
			sortedRanksByCount(buckets, 4).cards, CARD_TYPE.BOMB_NORMAL[1] = CARD_TYPE.BOMB_NORMAL, buckets[r][1]
			sortedRanksByCount(buckets, 4).cards, CARD_TYPE.BOMB_NORMAL[2] = CARD_TYPE.BOMB_NORMAL, buckets[r][2]
			sortedRanksByCount(buckets, 4).cards, CARD_TYPE.BOMB_NORMAL[3] = CARD_TYPE.BOMB_NORMAL, buckets[r][3]
			sortedRanksByCount(buckets, 4).cards, CARD_TYPE.BOMB_NORMAL[4] = CARD_TYPE.BOMB_NORMAL, buckets[r][4]
			bombs[#bombs + 1], sortedRanksByCount(buckets, 4).mainRank = sortedRanksByCount(buckets, 4)
		end
		for s = 1, 4 do
			local c5, c10, cK
			if not buckets[POKER_RANK["5"]] then
				_ENV = buckets[POKER_RANK["5"]]
			end
			for _, c in ipairs(buckets[POKER_RANK["5"]]) do
				if c.suit == s then
					c5 = c
					break
				end
			end
			if not buckets[POKER_RANK["10"]] then
				_ENV = buckets[POKER_RANK["10"]]
			end
			for _, c in ipairs(buckets[POKER_RANK["10"]]) do
				if c.suit == s then
					c10 = c
					break
				end
			end
			if not buckets[POKER_RANK.K] then
				_ENV = buckets[POKER_RANK.K]
			end
			for _, c in ipairs(buckets[POKER_RANK.K]) do
				if c.suit == s then
					cK = c
					break
				end
			end
			if c5 and c10 and cK then
				_ENV = ipairs(buckets[POKER_RANK.K])
				POKER_RANK, ipairs(buckets[POKER_RANK.K]).cardType = CARD_TYPE.BOMB_REAL_510K, CARD_TYPE.BOMB_REAL_510K
				ipairs(buckets[POKER_RANK.K]).cards, CARD_TYPE.BOMB_REAL_510K[1] = CARD_TYPE.BOMB_REAL_510K, c5
				ipairs(buckets[POKER_RANK.K]).cards, CARD_TYPE.BOMB_REAL_510K[2] = CARD_TYPE.BOMB_REAL_510K, c10
				ipairs(buckets[POKER_RANK.K]).cards, CARD_TYPE.BOMB_REAL_510K[3] = CARD_TYPE.BOMB_REAL_510K, cK
				bombs[#bombs + 1], ipairs(buckets[POKER_RANK.K]).mainRank = ipairs(buckets[POKER_RANK.K])
			end
		end
		if not buckets[POKER_RANK["5"]] then
			local _ENV, fiveList = buckets[POKER_RANK["5"]], buckets[POKER_RANK["5"]]
		end
		if not buckets[POKER_RANK["10"]] then
			local _ENV, tenList = buckets[POKER_RANK["10"]], buckets[POKER_RANK["10"]]
		end
		if not buckets[POKER_RANK.K] then
			local _ENV, kList = buckets[POKER_RANK.K], buckets[POKER_RANK.K]
		end
		if 0 < #fiveList and 0 < #tenList and 0 < #kList then
			for _, c5 in ipairs(fiveList) do
				for _, c10 in ipairs(tenList) do
					for _, cK in ipairs(kList) do
						if c5.suit ~= c10.suit or c10.suit ~= cK.suit then
							local mainSuit = math.max(c5.suit, c10.suit, cK.suit)
							_ENV = c10.suit
							POKER_RANK, c10.suit.cardType = CARD_TYPE.BOMB_510K, CARD_TYPE.BOMB_510K
							c10.suit.cards, CARD_TYPE.BOMB_510K[1] = CARD_TYPE.BOMB_510K, c5
							c10.suit.cards, CARD_TYPE.BOMB_510K[2] = CARD_TYPE.BOMB_510K, c10
							c10.suit.cards, CARD_TYPE.BOMB_510K[3] = CARD_TYPE.BOMB_510K, cK
							bombs[#bombs + 1], c10.suit.mainRank = c10.suit, mainSuit
						end
					end
				end
			end
		end
		if buckets[POKER_RANK.JK1] and 0 < #buckets[POKER_RANK.JK1] and buckets[POKER_RANK.JK2] and 0 < #buckets[POKER_RANK.JK2] then
			_ENV = ipairs(fiveList)
			CARD_TYPE, ipairs(fiveList).cardType = CARD_TYPE.BOMB_KING, CARD_TYPE.BOMB_KING
			ipairs(fiveList).cards, CARD_TYPE.BOMB_KING[1] = CARD_TYPE.BOMB_KING, buckets[POKER_RANK.JK1][1]
			ipairs(fiveList).cards, CARD_TYPE.BOMB_KING[2] = CARD_TYPE.BOMB_KING, buckets[POKER_RANK.JK2][1]
			bombs[#bombs + 1], ipairs(fiveList).mainRank = ipairs(fiveList)
		end
		table.sort(bombs, function(a, b)
			if a.cardType == b.cardType then
				return (a.mainRank or 0) < (b.mainRank or 0)
			end
			return a.cardType < b.cardType
		end)
		return bombs
	end
	local firstNonBombByPriority = function(buckets)
		local findPlanePlay, candidates
		local planeTwo = findPlanePlay(buckets, 2, nil, "pair")
		if planeTwo then
			findPlanePlay = 2
			;(2).cardType = CARD_TYPE.PLANE_TWO
			candidates[#candidates + 1], (2).cards = 2, planeTwo
		end
		local planeOne = findPlanePlay(buckets, 2, nil, "one")
		if planeOne then
			findPlanePlay = 2
			;(2).cardType = CARD_TYPE.PLANE_ONE
			candidates[#candidates + 1], (2).cards = 2, planeOne
		end
		local plane = findPlanePlay(buckets, 2)
		if plane then
			findPlanePlay = 2
			;(2).cardType = CARD_TYPE.PLANE
			candidates[#candidates + 1], (2).cards = 2, plane
		end
		local pairRun = findBestStraight(buckets, 2, 3)
		if pairRun then
			findPlanePlay = 2
			;(2).cardType = CARD_TYPE.STRAIGHT_PAIR
			candidates[#candidates + 1], (2).cards = 2, pairRun
		end
		local straight = findBestStraight(buckets, 1, 5)
		if straight then
			findPlanePlay = 1
			;(1).cardType = CARD_TYPE.STRAIGHT
			candidates[#candidates + 1], (1).cards = 1, straight
		end
		for _, r in ipairs(sortedRanksByCount(buckets, 3)) do
			_ENV = sortedRanksByCount(buckets, 3)
			sortedRanksByCount(buckets, 3)[1] = buckets[r][1]
			sortedRanksByCount(buckets, 3)[2] = buckets[r][2]
			local sortedRanksByCount(buckets, 3)[3], triple = buckets[r][3], sortedRanksByCount(buckets, 3)
			local remain = removeUsedFromBuckets(buckets, triple)
			local one = pickSingles(remain, 1)
			if one then
				findPlanePlay = 1
				;(1).cardType = CARD_TYPE.THREE_ONE
				candidates[#candidates + 1], (1).cards = 1, concatCards(triple, one)
			end
			local pair = pickPairs(remain, 1)
			if pair then
				findPlanePlay = 1
				;(1).cardType = CARD_TYPE.THREE_PAIR
				candidates[#candidates + 1], (1).cards = 1, concatCards(triple, pair)
			end
			findPlanePlay = 1
			;(1).cardType = CARD_TYPE.THREE
			candidates[#candidates + 1], (1).cards = 1, triple
		end
		for _, r in ipairs(sortedRanksByCount(buckets, 2)) do
			findPlanePlay = sortedRanksByCount(buckets, 2)
			findBestStraight, sortedRanksByCount(buckets, 2).cardType = CARD_TYPE.TWO, CARD_TYPE.TWO
			candidates[#candidates + 1], sortedRanksByCount(buckets, 2).cards, CARD_TYPE.TWO[1] = sortedRanksByCount(buckets, 2)
			candidates[#candidates + 1], sortedRanksByCount(buckets, 2).cards, CARD_TYPE.TWO[2] = sortedRanksByCount(buckets, 2)
		end
		for _, r in ipairs(sortedRanksByCount(buckets, 1)) do
			findPlanePlay = sortedRanksByCount(buckets, 1)
			CARD_TYPE, sortedRanksByCount(buckets, 1).cardType = CARD_TYPE.ONE, CARD_TYPE.ONE
			candidates[#candidates + 1], sortedRanksByCount(buckets, 1).cards, CARD_TYPE.ONE[1] = sortedRanksByCount(buckets, 1)
		end
		if #candidates == 0 then
			return nil
		end
		local maxCount = 0
		for _, c in ipairs(candidates) do
			if maxCount < #c.cards then
				maxCount = #c.cards
			end
		end
		local findPlanePlay, maxSet = (for generator), ipairs(candidates)
		for _, c in ipairs(candidates) do
			if #c.cards == maxCount then
				maxSet[#maxSet + 1] = c
			end
		end
		return maxSet[math.random(1, #maxSet)]
	end
	local buckets = buildRankBuckets(hand)
	local lastCards = self.showPokerList
	if not lastCards or #lastCards == 0 then
		local p = firstNonBombByPriority(buckets)
		if p then
			return p
		end
		local bombs = buildBombCandidates(buckets)
		if 0 < #bombs then
			_ENV = #bombs
			;(#bombs).cardType = bombs[1].cardType
			;(#bombs).cards = bombs[1].cards
			return #bombs
		end
		return nil
	end
	local _ENV, tryList = p, firstNonBombByPriority(buckets)
	local p = firstNonBombByPriority(buckets)
	if p then
		tryList[#tryList + 1] = p
	end
	for _, r in ipairs(sortedRanksByCount(buckets, 1)) do
		_ENV = sortedRanksByCount(buckets, 1)
		cloneCards, sortedRanksByCount(buckets, 1).cardType = CARD_TYPE.ONE, CARD_TYPE.ONE
		tryList[#tryList + 1], sortedRanksByCount(buckets, 1).cards, CARD_TYPE.ONE[1] = sortedRanksByCount(buckets, 1)
	end
	for _, r in ipairs(sortedRanksByCount(buckets, 2)) do
		_ENV = sortedRanksByCount(buckets, 2)
		POKER_RANK, sortedRanksByCount(buckets, 2).cardType = CARD_TYPE.TWO, CARD_TYPE.TWO
		tryList[#tryList + 1], sortedRanksByCount(buckets, 2).cards, CARD_TYPE.TWO[1] = sortedRanksByCount(buckets, 2)
		tryList[#tryList + 1], sortedRanksByCount(buckets, 2).cards, CARD_TYPE.TWO[2] = sortedRanksByCount(buckets, 2)
	end
	for _, r in ipairs(sortedRanksByCount(buckets, 3)) do
		_ENV = sortedRanksByCount(buckets, 3)
		CARD_TYPE, sortedRanksByCount(buckets, 3).cardType = CARD_TYPE.THREE, CARD_TYPE.THREE
		tryList[#tryList + 1], sortedRanksByCount(buckets, 3).cards, CARD_TYPE.THREE[1] = sortedRanksByCount(buckets, 3)
		tryList[#tryList + 1], sortedRanksByCount(buckets, 3).cards, CARD_TYPE.THREE[2] = sortedRanksByCount(buckets, 3)
		tryList[#tryList + 1], sortedRanksByCount(buckets, 3).cards, CARD_TYPE.THREE[3] = sortedRanksByCount(buckets, 3)
	end
	for _, cand in ipairs(tryList) do
		if self:checkCardType(cand.cards) and self:isPlayBigger(cand.cards, lastCards) then
			return cand
		end
	end
	local bombs = buildBombCandidates(buckets)
	for _, b in ipairs(bombs) do
		if self:checkCardType(b.cards) and self:isPlayBigger(b.cards, lastCards) then
			_ENV = self:isPlayBigger(b.cards, lastCards)
			self:isPlayBigger(b.cards, lastCards).cardType = b.cardType
			self:isPlayBigger(b.cards, lastCards).cards = b.cards
			return (self:isPlayBigger(b.cards, lastCards))
		end
	end
	return nil
end
local containsDiamond3 = function(cards)
	for _, c in ipairs(cards) do
		if c.suit == POKER_SUIT.Diamonds and c.rank == POKER_RANK["3"] then
			return true
		end
	end
	return false
end
local getMainRankForCompare = function(cards, cardType)
	local _ENV, rankCount
	for _, c in ipairs(cards) do
		rankCount[c.rank] = (rankCount[c.rank] or 0) + 1
	end
	if cardType == CARD_TYPE.ONE or cardType == CARD_TYPE.TWO or cardType == CARD_TYPE.THREE then
		return cards[1].rank
	end
	if cardType == CARD_TYPE.THREE_ONE or cardType == CARD_TYPE.THREE_PAIR then
		for r, c in pairs(rankCount) do
			if c == 3 then
				return r
			end
		end
	end
	if cardType == CARD_TYPE.FOUR_TWO or cardType == CARD_TYPE.FOUR_TWO_PAIR or cardType == CARD_TYPE.BOMB_NORMAL then
		for r, c in pairs(rankCount) do
			if c == 4 then
				return r
			end
		end
	end
	if cardType == CARD_TYPE.STRAIGHT then
		local maxR = 0
		for r, _ in pairs(rankCount) do
			if r > maxR then
				maxR = r
			end
		end
		return maxR
	end
	if cardType == CARD_TYPE.STRAIGHT_PAIR then
		local maxR = 0
		for r, _ in pairs(rankCount) do
			if r > maxR then
				maxR = r
			end
		end
		return maxR
	end
	if cardType == CARD_TYPE.PLANE or cardType == CARD_TYPE.PLANE_ONE or cardType == CARD_TYPE.PLANE_TWO then
		local maxTrip = 0
		for r, c in pairs(rankCount) do
			if 3 <= c and r > maxTrip then
				maxTrip = r
			end
		end
		return maxTrip
	end
	if cardType == CARD_TYPE.BOMB_REAL_510K or cardType == CARD_TYPE.BOMB_510K then
		local maxSuit = 0
		for _, c in ipairs(cards) do
			if maxSuit < c.suit then
				maxSuit = c.suit
			end
		end
		return maxSuit
	end
	if cardType == CARD_TYPE.BOMB_KING then
		return POKER_RANK.JK2
	end
	return 0
end
function FiveTenKGamePanel:isPlayBigger(newCards, lastCards)
	if not lastCards or #lastCards == 0 then
		return true
	end
	local lastType = self:checkCardType(lastCards)
	local newType = self:checkCardType(newCards)
	if not newType then
		return false
	end
	if not lastType then
		return true
	end
	if lastType == CARD_TYPE.BOMB_KING then
		return false
	end
	if lastType >= CARD_TYPE.BOMB_510K then
		return lastType < newType
	end
	if newType >= CARD_TYPE.BOMB_510K then
		if lastType >= CARD_TYPE.BOMB_510K then
			if newType ~= lastType then
				return lastType < newType
			end
			return getMainRankForCompare(newCards, newType) > getMainRankForCompare(lastCards, lastType)
		end
		return true
	end
	if lastType ~= newType then
		return false
	end
	if #newCards ~= #lastCards then
		return false
	end
	return getMainRankForCompare(newCards, newType) > getMainRankForCompare(lastCards, lastType)
end
function FiveTenKGamePanel:removeCardsFromHand(playerIndex, outCards)
	local hand = self.playerPokerList[playerIndex]
	if not hand or #hand == 0 then
		return
	end
	for _, oc in ipairs(outCards) do
		for i = #hand, 1, -1 do
			local c = hand[i]
			if c.suit == oc.suit and c.rank == oc.rank then
				table.remove(hand, i)
				break
			end
		end
	end
end
function FiveTenKGamePanel:checkGameOverAndSettle()
	for p = 1, PLAYER_COUNT do
		if #self.playerPokerList[p] == 0 then
			self.isGameOver = true
			self:updateScore(p)
			self.playerScore[p] = (self.playerScore[p] or 0) + 30
			for op = 1, PLAYER_COUNT do
				if op ~= p then
					local minus = 0
					for _, c in ipairs(self.playerPokerList[op]) do
						local v = SCORE_CARD_RANK[c.key]
						if v then
							minus = minus + v
						end
					end
					self.playerScore[op] = (self.playerScore[op] or 0) - minus
				end
			end
			for i = 1, PLAYER_COUNT do
				self.fields["Lab_score" .. i]:setString("得分:" .. tostring(self.playerScore[i] or 0))
			end
			PLAYER_COUNT = nil
			;(nil).index = p
			SoraDShowMsgTip(i18n("游戏结束，玩家%{index}先出完牌", nil))
			self:stopTurnTimer()
			self:checkIsTurnSelf()
			return true
		end
	end
	return false
end
function FiveTenKGamePanel:applyOutPlay(playerIndex, outCards)
	local outCardType = self:checkCardType(outCards)
	if self.showPokerList and #self.showPokerList > 0 or outCardType and BOMB_TALK[outCardType] then
		self:triggerTalk(playerIndex, false, outCardType)
	end
	self.showPokerList = cloneCards(outCards)
	for _, c in ipairs(outCards) do
		self.turnCardList[#self.turnCardList + 1] = c
		if SCORE_CARD_RANK[c.key] then
			self.turnScoreList[#self.turnScoreList + 1] = c
		end
	end
	self:updateShowPokerList()
	self:updateTurnScoreList()
	self:removeCardsFromHand(playerIndex, outCards)
	if playerIndex == PLAYER_SELF_INDEX then
		self.curChooseCard, BOMB_TALK = PLAYER_SELF_INDEX, PLAYER_SELF_INDEX
		self:updateSelfPlayerPoker()
	else
		self:updateOtherPlayerPokerCount()
	end
	self.turnPass[playerIndex] = nil
	self.lastOutIndex = playerIndex
	self:countPoker()
	if self:checkGameOverAndSettle() then
		return
	end
	self:switchTurnIndex()
end
function FiveTenKGamePanel:btnClickOut()
	if self.isGameOver then
		return
	end
	if not self.curChooseCard then
		cloneCards = self.curChooseCard
	end
	local outCards = cloneCards(self.curChooseCard)
	local cardType = self:checkCardType(outCards)
	if not cardType then
		SoraDShowMsgTip(i18n("出牌不符合规则"))
		return
	end
	if not self:isPlayBigger(outCards, self.showPokerList) then
		SoraDShowMsgTip(i18n("出牌不符合规则"))
		return
	end
	self:stopTurnTimer()
	self.isAiTurn = false
	self:applyOutPlay(PLAYER_SELF_INDEX, outCards)
end
function FiveTenKGamePanel:doAiTurn()
	local result = self:aiOutCard()
	if result and result.cards and #result.cards > 0 and self:checkCardType(result.cards) and (#self.showPokerList == 0 or self:isPlayBigger(result.cards, self.showPokerList)) then
		self:applyOutPlay(self.turnIndex, result.cards)
		return
	end
	if self.showPokerList and 0 < #self.showPokerList then
		self:triggerTalk(self.turnIndex, true)
	end
	self.turnPass[self.turnIndex] = true
	self:switchTurnIndex()
end
function FiveTenKGamePanel:updateShowPokerList()
	self.fields.List_show:setNumItems(#self.showPokerList)
end
function FiveTenKGamePanel:itemRenderer_List_self(index, obj)
	local data = self.playerPokerList[PLAYER_SELF_INDEX][index + 1]
	obj:initData(data, self.curChooseCard)
end
function FiveTenKGamePanel:itemRenderer_List_show(index, obj)
	local data = self.showPokerList[index + 1]
	obj:initData(data)
end
return FiveTenKGamePanel

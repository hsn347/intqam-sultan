_ENV, SoraDWindowKeyTab, _ENV = nil, nil, nil
;(nil).POP_0 = 0
;(nil).POP_1 = 1
;(nil).POP_2 = 2
;(nil).POP_3 = 3
;(nil).POP_4 = 4
uiDequeType, (nil).POP_5 = nil, 5
UIBOXMAX = 100
local pop2Index = 0
local getPop2Index = function()
	return uiDequeType.POP_2 * UIBOXMAX + pop2Index
end
local _ENV, popIndex
local getPopIndex = function(popType)
	local index = popIndex[popType] or 0
	index = index + 1
	popIndex[popType] = index
	return popType * UIBOXMAX + index
end
_ENV = nil
;(nil).AGREEMENT = getPopIndex(uiDequeType.POP_0)
;(nil).CHCECKGUIDE = getPopIndex(uiDequeType.POP_0)
;(nil).NEWSTART_ASKREWARD = getPopIndex(uiDequeType.POP_0)
;(nil).ROSKOCHOICE = getPopIndex(uiDequeType.POP_0)
;(nil).KOH_MIGRATE = getPopIndex(uiDequeType.POP_0)
;(nil).ACTIVITY_9001657_1 = getPopIndex(uiDequeType.POP_0)
;(nil).ACTIVITY_9001657_2 = getPopIndex(uiDequeType.POP_0)
;(nil).PAYBACKPOP = getPopIndex(uiDequeType.POP_0)
;(nil).ROARING_FLAME_KICK = getPopIndex(uiDequeType.POP_0)
;(nil).NEWSERVER_CORRELATION = getPopIndex(uiDequeType.POP_0)
;(nil).OPENCHAPTER = getPopIndex(uiDequeType.POP_1)
;(nil).NEWWEEKCARD = getPopIndex(uiDequeType.POP_1)
;(nil).MAGICLAMPLVUP = getPopIndex(uiDequeType.POP_1)
;(nil).CASTLELVUP = getPopIndex(uiDequeType.POP_1)
;(nil).BUILDUNLOCK = getPopIndex(uiDequeType.POP_1)
;(nil).WALLLVUP = getPopIndex(uiDequeType.POP_1)
;(nil).GIFTWALL = getPopIndex(uiDequeType.POP_1)
;(nil).LORDLVUP = getPopIndex(uiDequeType.POP_1)
;(nil).GIFTCASTLE = getPopIndex(uiDequeType.POP_1)
;(nil).NEWSERVERRETURN = getPopIndex(uiDequeType.POP_1)
;(nil).RAMADANLETTER = getPopIndex(uiDequeType.POP_1)
;(nil).MAGICLAMPSKILLDRAW = getPopIndex(uiDequeType.POP_1)
;(nil).ACITIVITY_9001492 = getPopIndex(uiDequeType.POP_1)
;(nil).ACITIVITY_9001575 = getPopIndex(uiDequeType.POP_1)
;(nil).ACITIVITY_9001606 = getPopIndex(uiDequeType.POP_1)
;(nil).ACTIVITY_9001613 = getPopIndex(uiDequeType.POP_1)
;(nil).ACTIVITY_9001622 = getPopIndex(uiDequeType.POP_1)
;(nil).ACITIVITYPOP2_1 = getPopIndex(uiDequeType.POP_2)
;(nil).ACITIVITYPOP2_2 = getPopIndex(uiDequeType.POP_2)
;(nil).ACITIVITYPOP2_3 = getPopIndex(uiDequeType.POP_2)
;(nil).ACITIVITYPOP2_4 = getPopIndex(uiDequeType.POP_2)
;(nil).ACITIVITYPOP2_5 = getPopIndex(uiDequeType.POP_2)
;(nil).KINGSORDER = getPopIndex(uiDequeType.POP_2)
;(nil).RECHARGEMONTHLY = getPopIndex(uiDequeType.POP_2)
;(nil).HEROTRIAL = getPopIndex(uiDequeType.POP_2)
;(nil).DAILYAWARD = getPopIndex(uiDequeType.POP_2)
;(nil).SULTANSWELBACK = getPopIndex(uiDequeType.POP_2)
;(nil).CRAZYTRIO = getPopIndex(uiDequeType.POP_2)
;(nil).HONORBACKGIFT = getPopIndex(uiDequeType.POP_2)
;(nil).BUBBLEACTIVITY = getPopIndex(uiDequeType.POP_2)
;(nil).GROWUPFUND = getPopIndex(uiDequeType.POP_2)
;(nil).RATESTAR = getPopIndex(uiDequeType.POP_2)
;(nil).KINGRISE = getPopIndex(uiDequeType.POP_2)
;(nil).CELEBRATE = getPopIndex(uiDequeType.POP_2)
;(nil).HEROGIFT = getPopIndex(uiDequeType.POP_2)
;(nil).DAILYGOOD = getPopIndex(uiDequeType.POP_2)
;(nil).RECHARGE27 = getPopIndex(uiDequeType.POP_2)
;(nil).SINBADTREASURE = getPopIndex(uiDequeType.POP_2)
;(nil).RECHARGE = getPopIndex(uiDequeType.POP_2)
;(nil).RAMADANCALENDAR = getPopIndex(uiDequeType.POP_2)
;(nil).ACTIVITYPOP = getPopIndex(uiDequeType.POP_3)
;(nil).RECHARGEPOP = getPopIndex(uiDequeType.POP_4)
;(nil).PRINCEGIFT = getPopIndex(uiDequeType.POP_5)
;(nil).HERO = getPopIndex(uiDequeType.POP_5)
uiDequeTypeTab, (nil).PET = nil, getPopIndex(uiDequeType.POP_5)
function SoraDCheckIsCanAdd(priorityKey)
	local ret = true
	local pType = math.floor(priorityKey / UIBOXMAX)
	if SoraDCheckTypeWindow(pType) and pType > uiDequeType.POP_1 then
		ret = false
	end
	return ret
end
function SoraDAddPopupWindow(_fun, priorityKey, isForce, ...)
	print("SoraDAddPopupWindow", priorityKey)
	local priorityKey = priorityKey or getPopIndex(uiDequeType.POP_5)
	local pType = math.floor(priorityKey / UIBOXMAX)
	dump(SoraDWindowKeyTab, "SoraDWindowKeyTab111_" .. priorityKey, 10)
	if not isForce then
		local _ret, _key = SoraDCheckOwnTypeWindow(priorityKey)
		if _ret and _key then
			return
		end
	end
	local key = uiDeque:getInstance():addDeque(pType, priorityKey, _fun, ...)
	table.insert(SoraDWindowKeyTab, priorityKey)
end
function SoraDCheckOwnTypeWindow(priorityKey)
	local ret = false
	local key
	for k, v in pairs(SoraDWindowKeyTab) do
		if v == priorityKey then
			ret = true
			key = k
			break
		end
	end
	return ret, key
end
function SoraDCheckPopupWindow(priorityKey)
	return uiDeque:getInstance():checkDeque(priorityKey)
end
function SoraDCheckTypeWindow(pType)
	local ret = false
	for k, v in pairs(SoraDWindowKeyTab) do
		local _pType = math.floor(v / UIBOXMAX)
		if _pType == pType then
			ret = true
			break
		end
	end
	return ret
end
function SoraDCheckIsWindowOpen()
	return uiDeque:getInstance().isOpenDeque
end
function SoraDGetCurOpenBoxKey()
	return uiDeque:getInstance().uiDequeOpenKey
end
function SoraDDeletePopupWindow(priorityKey)
	local ret, index = SoraDCheckOwnTypeWindow(priorityKey)
	table.remove(SoraDWindowKeyTab, index)
	dump(SoraDWindowKeyTab, "SoraDWindowKeyTab222_" .. priorityKey, 10)
	uiDeque:getInstance():closeDeque(priorityKey)
end
function SoraDDeleteTopWindow()
	local priorityKey = SoraDGetCurOpenBoxKey()
	if priorityKey and 0 < priorityKey then
		SoraDDeletePopupWindow(priorityKey)
	end
end
function SoraDCleanPopupWindowManager()
	uiDeque:getInstance():clean()
	SoraDWindowKeyTab, _ENV = uiDeque:getInstance().clean, uiDeque:getInstance().clean
end

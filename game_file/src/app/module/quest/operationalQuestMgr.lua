local questCell = include("questCell")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local operationalQuestMgr.list, _ENV, _ENV, operationalQuestMgr = nil, nil, "questltCtrl", "questltCtrl"
function operationalQuestMgr.init(questArray)
	if "table" ~= type(questArray) or 0 == #questArray then
		return
	end
	for i, v in ipairs(questArray) do
		if questltCtrl:isOperationalQuest(v.questID) then
			local cell = questCell.new(v)
			operationalQuestMgr.list[v.questID] = cell
		end
	end
end
function operationalQuestMgr.release()
	operationalQuestMgr.list, operationalQuestMgr = nil, nil
end
function operationalQuestMgr.addQuest(property)
	local questID = property and property.questID
	if not questID then
		return false
	end
	if operationalQuestMgr.list[questID] then
		return false
	end
	local cell = questCell.new(property)
	operationalQuestMgr.list[questID] = cell
	return true
end
function operationalQuestMgr.removeQuest(questID)
	if not questID or not operationalQuestMgr.list[questID] then
		return false
	end
	operationalQuestMgr.list[questID] = nil
	return true
end
function operationalQuestMgr.getListOfTop()
	local _ENV, ret
	for questID, cell in pairs(operationalQuestMgr.list) do
		if cell:isPerforming() then
			local rangeMin, rangeMax = questltCtrl:getActiveRangeOfOperatinQuest(questID)
			local gameModule = include("GameModule")
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if rangeMin <= castleLevel and rangeMax >= castleLevel then
				table.insert(ret, cell)
			end
		elseif cell:canCommit() then
			table.insert(ret, cell)
		end
	end
	if 2 <= #ret then
		table.sort(ret, function(l, r)
			if l:canCommit() and r:canCommit() then
				return questltCtrl:getPriorityOfOperatinQuest(l:getQuestID()) >= questltCtrl:getPriorityOfOperatinQuest(r:getQuestID())
			elseif l:isPerforming() and r:isPerforming() then
				return questltCtrl:getPriorityOfOperatinQuest(l:getQuestID()) >= questltCtrl:getPriorityOfOperatinQuest(r:getQuestID())
			elseif l:canCommit() then
				return true
			else
				return false
			end
		end)
	end
	return ret
end
function operationalQuestMgr.getListOfBottom()
	local _ENV, ret
	for questID, cell in pairs(operationalQuestMgr.list) do
		if cell:isPerforming() then
			local rangeMin, rangeMax = questltCtrl:getActiveRangeOfOperatinQuest(questID)
			local gameModule = include("GameModule")
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if rangeMin > castleLevel or rangeMax < castleLevel then
				table.insert(ret, cell)
			end
		end
	end
	if 2 <= #ret then
		table.sort(ret, function(l, r)
			return questltCtrl:getPriorityOfOperatinQuest(l:getQuestID()) >= questltCtrl:getPriorityOfOperatinQuest(r:getQuestID())
		end)
	end
	return ret
end
function operationalQuestMgr.completeQuest(questID)
	local cell = operationalQuestMgr.list[questID]
	if not cell or not cell:isPerforming() then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	cell:setProgress(1)
	return gErrDef.Err_None
end
function operationalQuestMgr.commitQuest(questID)
	if not operationalQuestMgr.whetherQuestCanCommit(questID) then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local cell = operationalQuestMgr.list[questID]
	cell:finish()
	operationalQuestMgr.list[questID] = nil
	return gErrDef.Err_None
end
function operationalQuestMgr.whetherQuestCanComplete(questID)
	local cell = operationalQuestMgr.list[questID]
	if not cell then
		return false
	end
	return cell:isPerforming()
end
function operationalQuestMgr.whetherQuestCanCommit(questID)
	local cell = operationalQuestMgr.list[questID]
	if not cell then
		return false
	end
	return cell:canCommit()
end
function operationalQuestMgr.getCommitQuestNum()
	local num = 0
	for questID, cell in pairs(operationalQuestMgr.list) do
		if cell:canCommit() then
			num = num + 1
		end
	end
	return num
end
function operationalQuestMgr:getCanCommitQuest()
	local quest
	for questID, cell in pairs(operationalQuestMgr.list) do
		if cell:canCommit() then
			quest = cell
			break
		end
	end
	return quest
end
return operationalQuestMgr

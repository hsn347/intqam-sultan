local questDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	questDesRead = nil
	;(nil)[1] = "quest_describe_new"
	questDesRead:defineValue("describe", nil)
	questDesRead:defineValue("questTypeNotice", function()
		_ENV = nil
		;(nil)[25] = nil
		;(nil)[26] = nil
		;(nil)[27] = i18n("common_text_1652")
		;(nil)[28] = i18n("common_text_1649")
		;(nil)[29] = i18n("common_text_1657")
		;(nil)[30] = i18n("common_text_1654")
		;(nil)[31] = i18n("common_text_1651")
		;(nil)[32] = i18n("common_text_1656")
		;(nil)[33] = i18n("common_text_1655")
		;(nil)[34] = i18n("common_text_1653")
		;(nil)[35] = i18n("common_text_1658")
		;(nil)[36] = i18n("common_text_1650")
		;(nil)[37] = i18n("common_text_1659")
		;(nil)[38] = nil
		;(nil)[39] = i18n("common_text_1660")
		;(nil)[40] = nil
		;(nil)[41] = i18n("common_text_3522")
		;(nil)[42] = i18n("task_completion_tips_01")
		return nil
	end)
end
function questDesRead.getTypeNotice(questTpye)
	init()
	return questDesRead.questTypeNotice[questTpye]
end
function questDesRead.getAllQuestID()
	init()
	local init, ret = init, init
	for k, v in pairs(questDesRead.describe) do
		table.insert(ret, v.questID)
	end
	return ret
end
function questDesRead.getName(qid)
	init()
	qid = tonumber(qid)
	return questDesRead.describe[qid] and i18n(questDesRead.describe[qid].questName) or nil
end
function questDesRead.getDes(qid)
	init()
	qid = tonumber(qid)
	return questDesRead.describe[qid] and i18n(questDesRead.describe[qid].questDes) or nil
end
function questDesRead.getIcon(qid, fromMemory)
	init()
	qid = tonumber(qid)
	if fromMemory then
		return "#" .. questDesRead.describe[qid].questIcon
	end
	return questDesRead.describe[qid].questIcon
end
function questDesRead.getTypeIcon(qid, fromMemory)
	init()
	qid = tonumber(qid)
	if fromMemory then
		return questDesRead.describe[qid].questTypeIcon ~= "" and "#" .. questDesRead.describe[qid].questTypeIcon or nil
	end
	return questDesRead.describe[qid].questTypeIcon ~= "" and questDesRead.describe[qid].questTypeIcon or nil
end
return questDesRead

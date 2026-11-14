local mainCityGuideRead = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "new_player_guide_dialogue"
mainCityGuideRead:defineValue("dialogue", nil)
_UPVALUE2_ = nil
;(nil)[1] = "new_player_guide_step"
;(nil)[2] = true
mainCityGuideRead:defineValue("step", nil)
mainCityGuideRead:defineValue("dialogueMap", function()
	mainCityGuideRead.dialogueMap, mainCityGuideRead = nil, nil
	for k, v in pairs(mainCityGuideRead.dialogue) do
		local dialogueID = v.dialogue
		if not mainCityGuideRead.dialogueMap[dialogueID] then
			mainCityGuideRead.dialogueMap[dialogueID], mainCityGuideRead = nil, nil
		end
		table.insert(mainCityGuideRead.dialogueMap[dialogueID], v)
	end
	for k, v in pairs(mainCityGuideRead.dialogueMap) do
		table.sort(v, function(a, b)
			return a.order < b.order
		end)
	end
	return mainCityGuideRead.dialogueMap
end)
function mainCityGuideRead:getDialogues(dialogueID)
	return mainCityGuideRead.dialogueMap[dialogueID]
end
function mainCityGuideRead:getReward(guideStep)
	for k, v in pairs(mainCityGuideRead.step) do
		if v.guideID == guideStep then
			_UPVALUE2_ = nil
			;(nil)[1] = "itemID"
			;(nil)[2] = "itemCount"
			return serviceFunctions.tableFormat(v.award, nil)
		end
	end
end
return mainCityGuideRead

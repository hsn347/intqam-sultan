local kingsOrderRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingsOrderRead = nil
	;(nil)[1] = "limitactivities_section"
	kingsOrderRead:defineValue("section", nil)
	kingsOrderRead = nil
	;(nil)[1] = "limitactivities_event"
	kingsOrderRead:defineValue("event", nil)
	kingsOrderRead = nil
	;(nil)[1] = "limitactivities_armydes"
	kingsOrderRead:defineValue("armyList", nil)
end
init()
function kingsOrderRead.getSectionName(sectionID)
	sectionID = tonumber(sectionID)
	if kingsOrderRead.section[sectionID] then
		return kingsOrderRead.section[sectionID].sectionTitle
	else
		return nil
	end
end
function kingsOrderRead.getSectionEventContent(eventID)
	eventID = tonumber(eventID)
	return kingsOrderRead.event[eventID].eventContent
end
function kingsOrderRead.getSectionEventDesc(eventID)
	eventID = tonumber(eventID)
	return kingsOrderRead.event[eventID].eventDesc
end
function kingsOrderRead.getSectionEventDescArmy(level)
	level = tonumber(level)
	if kingsOrderRead.armyList[level] then
		return kingsOrderRead.armyList[level].armyList
	else
		return kingsOrderRead.armyList[1].armyList
	end
end
return kingsOrderRead

local worldMapDefine = include("worldMapDefine")
local GROU_ID = worldMapDefine.GROU_ID
local worldMapAnimate = class("worldMapAnimate", function(instanceName)
	local target = display.newNode()
	return target
end)
function worldMapAnimate:ctor()
end
function worldMapAnimate:initData(configData)
end
function worldMapAnimate:setNodeGroupID(node, configData, autoGroup)
	local groupID
	if configData.layer then
		if 0 == configData.layer then
			groupID = GROU_ID.group_animate_object_bg
		elseif 2 == configData.layer then
			groupID = GROU_ID.group_animate_object_top
		else
			groupID = GROU_ID.group_animate_object_fg
		end
	else
		groupID = GROU_ID.group_animate_object_bg
	end
	if node then
		node:setGroupID(groupID)
		if autoGroup then
			node:setGroupAuto(autoGroup)
		end
	end
end
return worldMapAnimate

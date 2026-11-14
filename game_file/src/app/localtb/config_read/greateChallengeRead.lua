local greateChallengeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	greateChallengeRead = nil
	;(nil)[1] = "great_challenge_des"
	greateChallengeRead:defineValue("greatChallengeDes", nil)
end
init()
function greateChallengeRead.getActivityName(activityID)
	local activityName
	for k, v in pairs(greateChallengeRead.greatChallengeDes) do
		if activityID == k then
			activityName = v.name
		end
	end
	return activityName
end
function greateChallengeRead.getActivityContent(activityID)
	local activityContent
	for k, v in pairs(greateChallengeRead.greatChallengeDes) do
		if activityID == k then
			activityContent = v.content
		end
	end
	return activityContent
end
function greateChallengeRead.getActivityDes(activityID)
	local activityDes
	for k, v in pairs(greateChallengeRead.greatChallengeDes) do
		if activityID == k then
			activityDes = v.des[1]
		end
	end
	return activityDes
end
function greateChallengeRead.getactivityButtonImg(activityID)
	local activityImg
	for k, v in pairs(greateChallengeRead.greatChallengeDes) do
		if activityID == k then
			activityImg = v.buttn
		end
	end
	return activityImg
end
return greateChallengeRead

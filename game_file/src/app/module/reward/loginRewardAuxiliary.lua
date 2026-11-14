local loginRewardAuxiliary = class("loginRewardAuxiliary")
function loginRewardAuxiliary:ctor()
	self.loginReward = include("loginreward")
end
function loginRewardAuxiliary:handleData(data)
	if data and next(data) ~= nil then
		local sequence = data.sequence
		local reward = self.loginReward[sequence].reward
		data.reward = reward
	end
	return data
end
return loginRewardAuxiliary

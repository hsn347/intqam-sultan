local allianceActiveRankRewardSingle = class("allianceActiveRankRewardSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("allianceActiveRankRewardSingle")
	end
	local commonRankAwardSingle = include("commonRankAwardSingle")
	target = commonRankAwardSingle.new(target)
	return target
end)
function allianceActiveRankRewardSingle:ctor(properties)
end
return allianceActiveRankRewardSingle

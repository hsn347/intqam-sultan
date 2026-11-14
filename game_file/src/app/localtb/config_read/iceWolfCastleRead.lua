local _ENV, iceWolfCastleRead
iceWolfCastleRead.rankAwardList = require_data("ice_dragon_rewards", true).data
function iceWolfCastleRead.getRankAward(rankType)
	local _ENV, tmp
	for i, v in ipairs(iceWolfCastleRead.rankAwardList) do
		if v.type == rankType then
			table.insert(tmp, v)
		end
	end
	return tmp
end
return iceWolfCastleRead

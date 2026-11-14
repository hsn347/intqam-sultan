if not utils then
	_ENV = utils
end
utils = utils
function utils.CastEnumToInt(value)
	return value:toInt()
end
if xlua.setpeerhook then
	local setpeer_fix = function(t)
		if type(t) == "userdata" then
			local peer = xlua.getpeer(t)
			if peer then
				local peerFun = t.SetLuaPeer
				if peerFun then
					peer.__ins = t
					peerFun(t, peer)
				end
			end
		end
	end
	xlua.setpeerhook(setpeer_fix)
end

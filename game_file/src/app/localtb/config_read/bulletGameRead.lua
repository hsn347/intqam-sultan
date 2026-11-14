local bulletGameRead = include("aAReadClass").new()
function bulletGameRead.init()
	_UPVALUE1_ = nil
	;(nil)[1] = "shoot_game_level"
	bulletGameRead:defineValue("shoot_game_level", nil)
end
function bulletGameRead.getBulletMaxNum(level)
	if bulletGameRead.shoot_game_level[tonumber(level)] then
		return bulletGameRead.shoot_game_level[tonumber(level)].Bullet
	else
		return 10
	end
end
bulletGameRead.init()
return bulletGameRead

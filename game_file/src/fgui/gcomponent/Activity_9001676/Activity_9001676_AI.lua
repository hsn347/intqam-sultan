local _ENV, Activity_9001676_AI
function is_ballNewPos_between_ball_coin(ballPosNew, coinPos, ballPos, ballR, coinR)
	if math.abs(ballPos.x - coinPos.x) + math.abs(ballPos.y - coinPos.y) > math.abs(ballPos.x - ballPosNew.x) + math.abs(ballPos.y - ballPosNew.y) then
		return true
	end
	return false
end
function normalize(v)
	local mag = math.sqrt(v.x ^ 2 + v.y ^ 2)
	_ENV = v.x ^ 2 + v.y ^ 2
	;(v.x ^ 2 + v.y ^ 2).x = v.x / mag
	;(v.x ^ 2 + v.y ^ 2).y = v.y / mag
	return v.x ^ 2 + v.y ^ 2
end
function calculate_reflection_angle(ballPos, coinPos, holePos, ballR, coinR)
	_ENV = nil
	;(nil).x = coinPos.x - holePos.x
	;(nil).y = coinPos.y - holePos.y
	local normal1 = normalize(nil)
	_ENV = nil
	;(nil).x = coinPos.x + normal1.x * (ballR + coinR)
	local (nil).y, ballPosNew = coinPos.y + normal1.y * (ballR + coinR), nil
	_ENV = normal1.y * (ballR + coinR)
	;(normal1.y * (ballR + coinR)).x = ballPosNew.x - ballPos.x
	;(normal1.y * (ballR + coinR)).y = ballPosNew.y - ballPos.y
	local normal2 = normalize(normal1.y * (ballR + coinR))
	_UPVALUE3_ = ballPosNew.y - ballPos.y
	;(ballPosNew.y - ballPos.y)[1] = ballPosNew
	;(ballPosNew.y - ballPos.y)[2] = ballPos
	;(ballPosNew.y - ballPos.y)[3] = coinPos
	dump(ballPosNew.y - ballPos.y, "checkAI velocity1")
	return normal2.x, -normal2.y, ballPosNew
end
function Activity_9001676_AI:getAIVelocity(holePositions, coinPos, coinR, ballPos, ballR)
	for i, v in ipairs(holePositions) do
		local bestVelocityX, bestVelocityY, ballPosNew = calculate_reflection_angle(ballPos, coinPos, v, ballR, coinR)
		if is_ballNewPos_between_ball_coin(ballPosNew, coinPos, ballPos, ballR, coinR) or i == #holePositions then
			dump(v, "checkAI velocity1")
			return cc.p(bestVelocityX, bestVelocityY)
		end
	end
end
return Activity_9001676_AI

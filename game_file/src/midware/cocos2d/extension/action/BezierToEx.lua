local BezierToEx = cc.BezierTo
local BezierTo_create = cc.BezierTo.create
function BezierToEx:create(time, arrPos)
	return BezierTo_create(self, time, unpack(arrPos))
end

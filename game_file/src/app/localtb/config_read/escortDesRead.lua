local escortDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	escortDesRead = nil
	;(nil)[1] = "escort_gharry_data"
	escortDesRead:defineValue("carData", nil)
	escortDesRead:defineValue("qualityColor", function()
		_ENV = nil
		;(nil)[0] = cc.c3b(255, 255, 255)
		;(nil)[1] = cc.c3b(15, 135, 5)
		;(nil)[2] = cc.c3b(20, 100, 200)
		;(nil)[3] = cc.c3b(190, 20, 230)
		;(nil)[4] = cc.c3b(255, 255, 0)
		return nil
	end)
end
init()
function escortDesRead.getCar(lv)
	for i, v in ipairs(escortDesRead.carData) do
		if v.gharry_lv == lv then
			return v
		end
	end
end
function escortDesRead.getCarName(lv)
	for i, v in ipairs(escortDesRead.carData) do
		if v.gharry_lv == lv then
			return v.name
		end
	end
end
function escortDesRead.getCarImg(lv)
	for i, v in ipairs(escortDesRead.carData) do
		if v.gharry_lv == lv then
			return v.image
		end
	end
end
function escortDesRead.getCarQuality(lv)
	for i, v in ipairs(escortDesRead.carData) do
		if v.gharry_lv == lv then
			return v.quality
		end
	end
	if lv < BG_MIN_QUALITY then
		return gQualityDef.WHITE
	end
	if lv >= BG_MAX_QUALITY then
		return gQualityDef.ORANGE
	end
end
function escortDesRead.getCarColor(lv)
	local quality = escortDesRead.getCarQuality(lv)
	if escortDesRead.qualityColor[quality] then
		return escortDesRead.qualityColor[quality]
	else
		return escortDesRead.qualityColor[0]
	end
end
return escortDesRead

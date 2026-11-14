local _UPVALUE1_, _ENV, _ENV, filter
_UPVALUE3_, (nil).GRAY, (nil)[1] = nil, nil, cc.GrayFilter
_UPVALUE3_ = nil
;(nil)[1] = 1
;(nil)[2] = 1
;(nil)[3] = 1
_UPVALUE3_, (nil).RGB, (nil)[1] = nil, nil, cc.RGBFilter
_UPVALUE3_, (nil).RGB, (nil)[2] = nil, nil, 3
_UPVALUE3_, (nil).RGB, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 0
_UPVALUE3_, (nil).HUE, (nil)[1] = nil, nil, cc.HueFilter
_UPVALUE3_, (nil).HUE, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).HUE, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 0
_UPVALUE3_, (nil).BRIGHTNESS, (nil)[1] = nil, nil, cc.BrightnessFilter
_UPVALUE3_, (nil).BRIGHTNESS, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).BRIGHTNESS, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 1
_UPVALUE3_, (nil).SATURATION, (nil)[1] = nil, nil, cc.SaturationFilter
_UPVALUE3_, (nil).SATURATION, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).SATURATION, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 1
_UPVALUE3_, (nil).CONTRAST, (nil)[1] = nil, nil, cc.ContrastFilter
_UPVALUE3_, (nil).CONTRAST, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).CONTRAST, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 0
_UPVALUE3_, (nil).EXPOSURE, (nil)[1] = nil, nil, cc.ExposureFilter
_UPVALUE3_, (nil).EXPOSURE, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).EXPOSURE, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 1
_UPVALUE3_, (nil).GAMMA, (nil)[1] = nil, nil, cc.GammaFilter
_UPVALUE3_, (nil).GAMMA, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).GAMMA, (nil)[3] = nil, nil, nil
_UPVALUE2_ = nil
;(nil)[1] = 0
;(nil)[2] = 0
_UPVALUE1_, (nil).HAZE, (nil)[1] = nil, nil, cc.HazeFilter
_UPVALUE1_, (nil).HAZE, (nil)[2] = nil, nil, 2
_UPVALUE1_, (nil).HAZE, (nil)[3] = nil, nil, nil
_UPVALUE3_, (nil).SEPIA, (nil)[1] = nil, nil, cc.SepiaFilter
_UPVALUE1_ = nil
;(nil)[1] = 0
_UPVALUE3_, (nil).GAUSSIAN_VBLUR, (nil)[1] = nil, nil, cc.GaussianVBlurFilter
_UPVALUE3_, (nil).GAUSSIAN_VBLUR, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).GAUSSIAN_VBLUR, (nil)[3] = nil, nil, nil
_UPVALUE1_ = nil
;(nil)[1] = 0
_UPVALUE3_, (nil).GAUSSIAN_HBLUR, (nil)[1] = nil, nil, cc.GaussianHBlurFilter
_UPVALUE3_, (nil).GAUSSIAN_HBLUR, (nil)[2] = nil, nil, 1
_UPVALUE3_, (nil).GAUSSIAN_HBLUR, (nil)[3] = nil, nil, nil
_UPVALUE3_ = nil
;(nil)[1] = 1
;(nil)[2] = 0.5
;(nil)[3] = 0.5
_UPVALUE3_, (nil).ZOOM_BLUR, (nil)[1] = nil, nil, cc.ZoomBlurFilter
_UPVALUE3_, (nil).ZOOM_BLUR, (nil)[2] = nil, nil, 3
_UPVALUE3_, (nil).ZOOM_BLUR, (nil)[3] = nil, nil, nil
_UPVALUE2_ = nil
;(nil)[1] = 1
;(nil)[2] = 0
_UPVALUE3_, (nil).MOTION_BLUR, (nil)[1] = nil, nil, cc.MotionBlurFilter
_UPVALUE3_, (nil).MOTION_BLUR, (nil)[2] = nil, nil, 2
_UPVALUE3_, (nil).MOTION_BLUR, (nil)[3] = nil, nil, nil
_UPVALUE2_ = nil
;(nil)[1] = 0
;(nil)[2] = 0
_UPVALUE2_, (nil).SHARPEN, (nil)[1] = nil, nil, cc.SharpenFilter
_UPVALUE2_, (nil).SHARPEN, (nil)[2] = nil, nil, 2
_UPVALUE2_, (nil).SHARPEN, (nil)[3] = nil, nil, nil
_UPVALUE2_, (nil).MASK, (nil)[1] = nil, nil, cc.MaskFilter
_UPVALUE2_, (nil).MASK, (nil)[2] = nil, nil, 1
_UPVALUE2_, (nil).DROP_SHADOW, (nil)[1] = nil, nil, cc.DropShadowFilter
_UPVALUE2_, (nil).DROP_SHADOW, (nil)[2] = nil, nil, 1
;(nil).GAUSSIAN_BLUR, _ENV, _ENV, (nil).CUSTOM, (nil)[1] = cc.CustomFilter, cc.CustomFilter, nil, nil, cc.CustomFilter
;(nil).GAUSSIAN_BLUR, _ENV, _ENV, (nil).CUSTOM, (nil)[2] = cc.CustomFilter, cc.CustomFilter, nil, nil, 1
local FILTERS
local MULTI_FILTERS
function filter.newFilter(__filterName, __param)
	local __filterData = FILTERS[__filterName]
	assert(__filterData, "filter.newFilter() - filter " .. __filterName .. " is not found.")
	local __cls, __count, __default = unpack(__filterData)
	if "CUSTOM" == __filterName then
		return __cls:create(__param)
	end
	local __paramCount = __param and #__param or 0
	print("filter.newFilter:", __paramCount, __filterName, __count)
	print("filter.newFilter __param:", __param)
	if __count == nil then
		if __paramCount == 0 then
			return __cls:create()
		end
	elseif __count == 0 then
		return __cls:create()
	else
		if __paramCount == 0 then
			return __cls:create(unpack(__default))
		end
		assert(__paramCount == __count, string.format("filter.newFilter() - the parameters have a wrong amount! Expect %d, get %d.", __count, __paramCount))
	end
	return __cls:create(unpack(__param))
end
function filter.newFilters(__filterNames, __params)
	assert(#__filterNames == #__params, "filter.newFilters() - Please ensure the filters and the parameters have the same amount.")
	local _ENV, __filters = assert, assert
	for i in ipairs(__filterNames) do
		table.insert(__filters, filter.newFilter(__filterNames[i], __params[i]))
	end
	return __filters
end
return filter

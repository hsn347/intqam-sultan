local _ENV, display
local sharedDirector = cc.Director:getInstance()
local sharedTextureCache = cc.Director:getInstance():getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local sharedAnimationCache = cc.AnimationCache:getInstance()
local glview = sharedDirector:getOpenGLView()
if nil == glview then
	glview = cc.GLViewImpl:createWithRect("QuickCocos", cc.rect(0, 0, CONFIG_SCREEN_WIDTH or 900, CONFIG_SCREEN_HEIGHT or 640))
	sharedDirector:setOpenGLView(glview)
end
local size = glview:getFrameSize()
_ENV = glview
glview.width = size.width
display.sizeInPixels, glview.height = glview, size.height
local w = display.sizeInPixels.width
local h = display.sizeInPixels.height
if CONFIG_SCREEN_WIDTH == nil or CONFIG_SCREEN_HEIGHT == nil then
	CONFIG_SCREEN_WIDTH = w
	CONFIG_SCREEN_HEIGHT = h
end
display.iPadOffset = device.isIpadMode() and 128 or 0
if CONFIG_SCREEN_WIDTH then
	CONFIG_SCREEN_WIDTH = CONFIG_SCREEN_WIDTH + display.iPadOffset
end
if not CONFIG_SCREEN_AUTOSCALE then
	if w > h then
		CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
	else
		CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
	end
else
	CONFIG_SCREEN_AUTOSCALE = string.upper(CONFIG_SCREEN_AUTOSCALE)
end
local scale, scaleX, scaleY
if CONFIG_SCREEN_AUTOSCALE and CONFIG_SCREEN_AUTOSCALE ~= "NONE" then
	if type(CONFIG_SCREEN_AUTOSCALE_CALLBACK) == "function" then
		scaleX, scaleY = CONFIG_SCREEN_AUTOSCALE_CALLBACK(w, h, device.model)
	end
	if CONFIG_SCREEN_AUTOSCALE == "FILL_ALL" then
		CONFIG_SCREEN_WIDTH = w
		CONFIG_SCREEN_HEIGHT = h
		scale = 1.0
		if cc.bPlugin_ then
			glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.NO_BORDER)
		else
			glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.FILL_ALL)
		end
	else
		if not scaleX or not scaleY then
			scaleX, scaleY = w / CONFIG_SCREEN_WIDTH, h / CONFIG_SCREEN_HEIGHT
		end
		if CONFIG_SCREEN_AUTOSCALE == "FIXED_WIDTH" then
			scale = scaleX
			CONFIG_SCREEN_HEIGHT = h / scale
		elseif CONFIG_SCREEN_AUTOSCALE == "FIXED_HEIGHT" then
			scale = scaleY
			CONFIG_SCREEN_WIDTH = w / scale
		else
			scale = 1.0
			printError(string.format("display - invalid CONFIG_SCREEN_AUTOSCALE \"%s\"", CONFIG_SCREEN_AUTOSCALE))
		end
		glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.NO_BORDER)
	end
else
	CONFIG_SCREEN_WIDTH = w
	CONFIG_SCREEN_HEIGHT = h
	scale = 1.0
end
local winSize = sharedDirector:getWinSize()
local safeArea = CS.UnityEngine.Screen.safeArea
local isHaveSaveArea = safeArea.height ~= CS.UnityEngine.Screen.height
local getIphoneXOffset = function()
	if not device.isIphoneXMode() then
		return 0
	end
	if device.platform == "ios" then
		return 95
	end
	local rScale = winSize.height / winSize.width
	local minValue = math.floor(640 * (rScale - 2.165625))
	if isHaveSaveArea then
		local uiScale = CS.FairyGUI.UIContentScaler.scaleFactor
		local saveAreaValue = math.floor((CS.UnityEngine.Screen.height - safeArea.height) / uiScale)
		if minValue > saveAreaValue then
			return math.floor(minValue)
		else
			return saveAreaValue
		end
	else
		return math.floor(minValue)
	end
end
local getIphoneXBottom = function()
	if not device.isIphoneXMode() then
		return 0
	end
	if device.platform == "ios" then
		return 37
	end
	local rScale = winSize.height / winSize.width
	local minValue = math.floor(640 * (rScale - 2.165625))
	if isHaveSaveArea then
		local uiScale = CS.FairyGUI.UIContentScaler.scaleFactor
		local saveAreaValue = math.floor((CS.UnityEngine.Screen.height - safeArea.height) / uiScale)
		if minValue > saveAreaValue then
			return math.floor(minValue / 2)
		else
			return math.floor(safeArea.y * uiScale)
		end
	else
		return math.floor(minValue / 2)
	end
end
display.iPhoneXOffset = getIphoneXOffset()
display.iPhoneXBottom = getIphoneXBottom()
display.screenScale = 2.0
_ENV, display.contentScaleFactor = getIphoneXBottom(), scale
getIphoneXBottom().width = winSize.width
_ENV, display.realSize, getIphoneXBottom().height = getIphoneXBottom(), getIphoneXBottom(), winSize.height
getIphoneXBottom().width = winSize.width - display.iPadOffset
display.size, getIphoneXBottom().height = getIphoneXBottom(), winSize.height - display.iPhoneXOffset
display.width = display.size.width
display.height = display.size.height
display.rwidth = display.realSize.width
display.rheight = display.realSize.height
display.cx = display.width / 2
display.cy = display.height / 2 + display.iPhoneXBottom
display.rcy = display.realSize.height / 2
display.rcx = display.realSize.width / 2
display.ocy = display.height / 2
display.c_left = -display.width / 2
display.c_right = display.width / 2
display.c_top = display.height / 2
display.c_bottom = -display.height / 2
display.left = 0
display.right = display.width
display.top = display.height
display.bottom = 0
display.widthInPixels = display.sizeInPixels.width
display.heightInPixels = display.sizeInPixels.height
printInfo(string.format("# CONFIG_SCREEN_AUTOSCALE      = %s", CONFIG_SCREEN_AUTOSCALE))
printInfo(string.format("# CONFIG_SCREEN_WIDTH          = %0.2f", CONFIG_SCREEN_WIDTH))
printInfo(string.format("# CONFIG_SCREEN_HEIGHT         = %0.2f", CONFIG_SCREEN_HEIGHT))
printInfo(string.format("# display.widthInPixels        = %0.2f", display.widthInPixels))
printInfo(string.format("# display.heightInPixels       = %0.2f", display.heightInPixels))
printInfo(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
printInfo(string.format("# display.width                = %0.2f", display.width))
printInfo(string.format("# display.height               = %0.2f", display.height))
printInfo(string.format("# display.cx                   = %0.2f", display.cx))
printInfo(string.format("# display.cy                   = %0.2f", display.cy))
printInfo(string.format("# display.rcy                  = %0.2f", display.rcy))
printInfo(string.format("# display.ocy                  = %0.2f", display.ocy))
printInfo(string.format("# display.left                 = %0.2f", display.left))
printInfo(string.format("# display.right                = %0.2f", display.right))
printInfo(string.format("# display.top                  = %0.2f", display.top))
printInfo(string.format("# display.bottom               = %0.2f", display.bottom))
printInfo(string.format("# display.c_left               = %0.2f", display.c_left))
printInfo(string.format("# display.c_right              = %0.2f", display.c_right))
printInfo(string.format("# display.c_top                = %0.2f", display.c_top))
printInfo(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
printInfo("#")
display.COLOR_WHITE = cc.c3b(255, 255, 255)
display.COLOR_BLACK = cc.c3b(0, 0, 0)
display.COLOR_RED = cc.c3b(255, 0, 0)
display.COLOR_GREEN = cc.c3b(0, 255, 0)
display.COLOR_BLUE = cc.c3b(0, 0, 255)
display.COLOR_YELLOW = cc.c3b(255, 255, 0)
display.AUTO_SIZE = 0
display.FIXED_SIZE = 1
display.LEFT_TO_RIGHT = 0
display.RIGHT_TO_LEFT = 1
display.TOP_TO_BOTTOM = 2
display.BOTTOM_TO_TOP = 3
display.CENTER = 1
display.LEFT_TOP = 2
display.TOP_LEFT = 2
display.CENTER_TOP = 3
display.TOP_CENTER = 3
display.RIGHT_TOP = 4
display.TOP_RIGHT = 4
display.CENTER_LEFT = 5
display.LEFT_CENTER = 5
display.CENTER_RIGHT = 6
display.RIGHT_CENTER = 6
display.BOTTOM_LEFT = 7
display.LEFT_BOTTOM = 7
display.BOTTOM_RIGHT = 8
display.RIGHT_BOTTOM = 8
display.BOTTOM_CENTER = 9
_UPVALUE8_, display.CENTER_BOTTOM = cc.c3b(255, 255, 0), 9
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[1] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0.5)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[2] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0, 1)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[3] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 1)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[4] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(1, 1)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[5] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0, 0.5)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[6] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(1, 0.5)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[7] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0, 0)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[8] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(1, 0)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[9] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[10] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0)
_UPVALUE2_, _ENV, display.ANCHOR_POINTS, cc.c3b(255, 255, 0)[11] = cc.p(0.5, 0.5), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).CROSSFADE, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionCrossFade
_UPVALUE2_, cc.c3b(255, 255, 0).CROSSFADE, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFade
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[4] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[5] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[6] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[7] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[8] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[9] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADE, cc.p(0.5, 0.5)[10] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.c3b(0, 0, 0)
_UPVALUE2_, cc.c3b(255, 255, 0).FADEBL, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFadeBL
_UPVALUE2_, cc.c3b(255, 255, 0).FADEBL, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).FADEDOWN, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFadeDown
_UPVALUE2_, cc.c3b(255, 255, 0).FADEDOWN, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).FADETR, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFadeTR
_UPVALUE2_, cc.c3b(255, 255, 0).FADETR, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE3_, cc.c3b(255, 255, 0).FADEUP, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFadeUp
_UPVALUE3_, cc.c3b(255, 255, 0).FADEUP, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPANGULAR, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFlipAngular
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPANGULAR, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPANGULAR, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TRANSITION_ORIENTATION_LEFT_OVER
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPX, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFlipX
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPX, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE3_, cc.c3b(255, 255, 0).FLIPX, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TRANSITION_ORIENTATION_LEFT_OVER
_UPVALUE2_, cc.c3b(255, 255, 0).FLIPY, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionFlipY
_UPVALUE2_, cc.c3b(255, 255, 0).FLIPY, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE2_, cc.c3b(255, 255, 0).FLIPY, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TRANSITION_ORIENTATION_UP_OVER
_UPVALUE2_, cc.c3b(255, 255, 0).JUMPZOOM, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionJumpZoom
_UPVALUE2_, cc.c3b(255, 255, 0).JUMPZOOM, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINB, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionMoveInB
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINB, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINL, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionMoveInL
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINL, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINR, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionMoveInR
_UPVALUE2_, cc.c3b(255, 255, 0).MOVEINR, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE3_, cc.c3b(255, 255, 0).MOVEINT, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionMoveInT
_UPVALUE3_, cc.c3b(255, 255, 0).MOVEINT, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).PAGETURN, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionPageTurn
_UPVALUE2_, cc.c3b(255, 255, 0).PAGETURN, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE2_, cc.c3b(255, 255, 0).PAGETURN, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), false
_UPVALUE2_, cc.c3b(255, 255, 0).ROTOZOOM, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionRotoZoom
_UPVALUE2_, cc.c3b(255, 255, 0).ROTOZOOM, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SHRINKGROW, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionShrinkGrow
_UPVALUE2_, cc.c3b(255, 255, 0).SHRINKGROW, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINB, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSlideInB
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINB, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINL, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSlideInL
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINL, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINR, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSlideInR
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINR, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINT, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSlideInT
_UPVALUE2_, cc.c3b(255, 255, 0).SLIDEINT, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SPLITCOLS, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSplitCols
_UPVALUE2_, cc.c3b(255, 255, 0).SPLITCOLS, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).SPLITROWS, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionSplitRows
_UPVALUE2_, cc.c3b(255, 255, 0).SPLITROWS, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE2_, cc.c3b(255, 255, 0).TURNOFFTILES, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionTurnOffTiles
_UPVALUE2_, cc.c3b(255, 255, 0).TURNOFFTILES, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE3_, cc.c3b(255, 255, 0).ZOOMFLIPANGULAR, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionZoomFlipAngular
_UPVALUE3_, cc.c3b(255, 255, 0).ZOOMFLIPANGULAR, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 2
_UPVALUE3_, cc.c3b(255, 255, 0).ZOOMFLIPX, cc.p(0.5, 0.5)[1] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TransitionZoomFlipX
_UPVALUE3_, cc.c3b(255, 255, 0).ZOOMFLIPX, cc.p(0.5, 0.5)[2] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), 3
_UPVALUE3_, cc.c3b(255, 255, 0).ZOOMFLIPX, cc.p(0.5, 0.5)[3] = cc.p(0.5, 0.5), cc.p(0.5, 0.5), cc.TRANSITION_ORIENTATION_LEFT_OVER
display.TEXTURES_PIXEL_FORMAT, _ENV, display.SCENE_TRANSITIONS, cc.c3b(255, 255, 0).ZOOMFLIPY, cc.p(0.5, 0.5)[1] = cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0.5), cc.TransitionZoomFlipY
display.TEXTURES_PIXEL_FORMAT, _ENV, display.SCENE_TRANSITIONS, cc.c3b(255, 255, 0).ZOOMFLIPY, cc.p(0.5, 0.5)[2] = cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0.5), 3
display.TEXTURES_PIXEL_FORMAT, _ENV, display.SCENE_TRANSITIONS, cc.c3b(255, 255, 0).ZOOMFLIPY, cc.p(0.5, 0.5)[3] = cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.c3b(255, 255, 0), cc.p(0.5, 0.5), cc.TRANSITION_ORIENTATION_UP_OVER
display.DEFAULT_TTF_FONT = ""
display.DEFAULT_TTF_FONT_SIZE = 24
function display.newScene(name)
	local scene = cc.Scene:create()
	scene:setNodeEventEnabled(true)
	scene:setAutoCleanupEnabled()
	scene.name = name or "<unknown-scene>"
	return scene
end
function display.newPhysicsScene(name)
	local scene = cc.Scene:createWithPhysics()
	scene:setNodeEventEnabled(true)
	scene.name = name or "<unknown-scene>"
	return scene
end
function display.wrapSceneWithTransition(scene, transitionType, time, more)
	return scene
end
function display.replaceScene(newScene, transitionType, time, more)
	if sharedDirector:getRunningScene() then
		if transitionType then
			newScene = display.wrapSceneWithTransition(newScene, transitionType, time, more)
		end
		sharedDirector:replaceScene(newScene)
	else
		sharedDirector:runWithScene(newScene)
	end
end
function display.getRunningScene()
	return sharedDirector:getRunningScene()
end
function display.pause()
	sharedDirector:pause()
end
function display.resume()
	sharedDirector:resume()
end
function display.newLayer()
	local layer
	if cc.bPlugin_ then
		layer = display.newNode()
		layer:setContentSize(display.width, display.height)
		layer:setTouchEnabled(true)
	else
		layer = cc.Layer:create()
	end
	return layer
end
function display.newColorLayer(color)
	local node
	if cc.bPlugin_ then
		node = display.newNode()
		local layer = cc.LayerColor:create(color)
		node:addChild(layer)
		node:setTouchEnabled(true)
		node:setTouchSwallowEnabled(true)
		node.setContentSize = layer.setContentSize
		node.getContentSize = layer.getContentSize
	else
		node = cc.LayerColor:create(color)
	end
	return node
end
function display.newNode()
	return cc.Node:create()
end
if cc.ClippingRectangleNode then
	cc.ClippingRegionNode = cc.ClippingRectangleNode
else
	cc.ClippingRectangleNode = cc.ClippingRegionNode
end
function display.newClippingRectangleNode(rect)
	if rect then
		return cc.ClippingRegionNode:create(rect)
	else
		return cc.ClippingRegionNode:create()
	end
end
display.newClippingRegionNode = display.newClippingRectangleNode
_ENV, display.newSprite = function(filename, x, y, params)
	local spriteClass, size, rect, noChild
	if params then
		spriteClass = params.class
		size = params.size
		rect = params.capInsets
		noChild = params.noChild
	end
	spriteClass = spriteClass or cc.Sprite
	local t = type(filename)
	if t == "userdata" then
		t = tolua.type(filename)
	end
	local sprite
	if not filename then
		sprite = spriteClass:create()
	elseif t == "string" then
		if string.byte(filename) == 35 then
			local frame = string.sub(filename, 2)
			if frame then
				sprite = spriteClass:createWithSpriteFrame(frame, rect, noChild)
			end
		elseif display.TEXTURES_PIXEL_FORMAT[filename] then
			cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[filename])
			sprite = spriteClass:create(filename)
			cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
		else
			sprite = spriteClass:create(filename, rect, noChild)
		end
	elseif t == "cc.SpriteFrame" then
		sprite = spriteClass:createWithSpriteFrame(filename, rect, noChild)
	elseif t == "cc.Texture2D" then
		sprite = spriteClass:createWithTexture(filename, rect, noChild)
	else
		print_warn("display.newSprite() - invalid filename value type")
		sprite = spriteClass:create()
	end
	if sprite then
		if x and y then
			sprite:setPosition(x, y)
		end
		if size then
			sprite:setContentSize(size)
		end
	else
		print_warn("display.newSprite() - create sprite failure, filename %s", tostring(filename))
		sprite = spriteClass:create()
	end
	return sprite
end, function(filename, x, y, params)
	local spriteClass, size, rect, noChild
	if params then
		spriteClass = params.class
		size = params.size
		rect = params.capInsets
		noChild = params.noChild
	end
	spriteClass = spriteClass or cc.Sprite
	local t = type(filename)
	if t == "userdata" then
		t = tolua.type(filename)
	end
	local sprite
	if not filename then
		sprite = spriteClass:create()
	elseif t == "string" then
		if string.byte(filename) == 35 then
			local frame = string.sub(filename, 2)
			if frame then
				sprite = spriteClass:createWithSpriteFrame(frame, rect, noChild)
			end
		elseif display.TEXTURES_PIXEL_FORMAT[filename] then
			cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[filename])
			sprite = spriteClass:create(filename)
			cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
		else
			sprite = spriteClass:create(filename, rect, noChild)
		end
	elseif t == "cc.SpriteFrame" then
		sprite = spriteClass:createWithSpriteFrame(filename, rect, noChild)
	elseif t == "cc.Texture2D" then
		sprite = spriteClass:createWithTexture(filename, rect, noChild)
	else
		print_warn("display.newSprite() - invalid filename value type")
		sprite = spriteClass:create()
	end
	if sprite then
		if x and y then
			sprite:setPosition(x, y)
		end
		if size then
			sprite:setContentSize(size)
		end
	else
		print_warn("display.newSprite() - create sprite failure, filename %s", tostring(filename))
		sprite = spriteClass:create()
	end
	return sprite
end
local (function(filename, x, y, params)
	local spriteClass, size, rect, noChild
	if params then
		spriteClass = params.class
		size = params.size
		rect = params.capInsets
		noChild = params.noChild
	end
	spriteClass = spriteClass or cc.Sprite
	local t = type(filename)
	if t == "userdata" then
		t = tolua.type(filename)
	end
	local sprite
	if not filename then
		sprite = spriteClass:create()
	elseif t == "string" then
		if string.byte(filename) == 35 then
			local frame = string.sub(filename, 2)
			if frame then
				sprite = spriteClass:createWithSpriteFrame(frame, rect, noChild)
			end
		elseif display.TEXTURES_PIXEL_FORMAT[filename] then
			cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[filename])
			sprite = spriteClass:create(filename)
			cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
		else
			sprite = spriteClass:create(filename, rect, noChild)
		end
	elseif t == "cc.SpriteFrame" then
		sprite = spriteClass:createWithSpriteFrame(filename, rect, noChild)
	elseif t == "cc.Texture2D" then
		sprite = spriteClass:createWithTexture(filename, rect, noChild)
	else
		print_warn("display.newSprite() - invalid filename value type")
		sprite = spriteClass:create()
	end
	if sprite then
		if x and y then
			sprite:setPosition(x, y)
		end
		if size then
			sprite:setContentSize(size)
		end
	else
		print_warn("display.newSprite() - create sprite failure, filename %s", tostring(filename))
		sprite = spriteClass:create()
	end
	return sprite
end).noChild, paramsNoChild = true, function(filename, x, y, params)
	local spriteClass, size, rect, noChild
	if params then
		spriteClass = params.class
		size = params.size
		rect = params.capInsets
		noChild = params.noChild
	end
	spriteClass = spriteClass or cc.Sprite
	local t = type(filename)
	if t == "userdata" then
		t = tolua.type(filename)
	end
	local sprite
	if not filename then
		sprite = spriteClass:create()
	elseif t == "string" then
		if string.byte(filename) == 35 then
			local frame = string.sub(filename, 2)
			if frame then
				sprite = spriteClass:createWithSpriteFrame(frame, rect, noChild)
			end
		elseif display.TEXTURES_PIXEL_FORMAT[filename] then
			cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[filename])
			sprite = spriteClass:create(filename)
			cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
		else
			sprite = spriteClass:create(filename, rect, noChild)
		end
	elseif t == "cc.SpriteFrame" then
		sprite = spriteClass:createWithSpriteFrame(filename, rect, noChild)
	elseif t == "cc.Texture2D" then
		sprite = spriteClass:createWithTexture(filename, rect, noChild)
	else
		print_warn("display.newSprite() - invalid filename value type")
		sprite = spriteClass:create()
	end
	if sprite then
		if x and y then
			sprite:setPosition(x, y)
		end
		if size then
			sprite:setContentSize(size)
		end
	else
		print_warn("display.newSprite() - create sprite failure, filename %s", tostring(filename))
		sprite = spriteClass:create()
	end
	return sprite
end
function display.newSpriteNoChild(filename)
	return display.newSprite(filename, nil, nil, paramsNoChild)
end
function display.newScale9Sprite(filename, x, y, size, capInsets)
	local scale9sp = ccui.Scale9Sprite or cc.Scale9Sprite
	_ENV = nil
	;(nil).class = scale9sp
	;(nil).size = size
	;(nil).capInsets = capInsets
	return display.newSprite(filename, x, y, nil)
end
function display.newTilesSprite(filename, rect, nochild)
	rect = rect or cc.rect(0, 0, display.width, display.height)
	local sprite = cc.Sprite:create(filename, rect, nochild)
	if not sprite then
		printError("display.newTilesSprite() - create sprite failure, filename %s", tostring(filename))
		return
	end
	sprite:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
	sprite:setTile(true)
	display.align(sprite, display.LEFT_BOTTOM, 0, 0)
	return sprite
end
function display.newTiledBatchNode(filename, plistFile, size, hPadding, vPadding)
	size = size or cc.size(display.width, display.height)
	hPadding = hPadding or 0
	vPadding = vPadding or 0
	local __sprite = display.newSprite(filename)
	local __sliceSize = __sprite:getContentSize()
	__sliceSize.width = __sliceSize.width - hPadding
	__sliceSize.height = __sliceSize.height - vPadding
	local __xRepeat = math.ceil(size.width / __sliceSize.width)
	local __yRepeat = math.ceil(size.height / __sliceSize.height)
	local __capacity = __xRepeat * __yRepeat
	local __batch = display.newBatchNode(plistFile, __capacity)
	local __newSize = cc.size(0, 0)
	for y = 0, __yRepeat - 1 do
		for x = 0, __xRepeat - 1 do
			__sprite = display.newSprite(filename):align(display.LEFT_BOTTOM, x * __sliceSize.width, y * __sliceSize.height):addTo(__batch)
		end
	end
	__newSize.width = __xRepeat * __sliceSize.width
	__newSize.height = __yRepeat * __sliceSize.height
	__batch:setContentSize(__newSize)
	return __batch, __newSize.width, __newSize.height
end
function display.newFilteredSprite(filename, filters, params)
	_ENV = nil
	local _ENV, (nil).class, __one = cc.FilteredSpriteWithOne, cc.FilteredSpriteWithOne, nil
	local cc.FilteredSpriteWithOne.class, __multi = cc.FilteredSpriteWithMulti, cc.FilteredSpriteWithOne
	if not filters then
		return display.newSprite(filtename, nil, nil, __one)
	end
	local __sp
	local __type = type(filters)
	if __type == "userdata" then
		__type = tolua.type(filters)
	end
	if __type == "string" then
		__sp = display.newSprite(filename, nil, nil, __one)
		filters = filter.newFilter(filters, params)
		__sp:setFilter(filters)
	elseif __type == "table" then
		assert(1 < #filters, "display.newFilteredSprite() - Please give me 2 or more filters!")
		__sp = display.newSprite(filename, nil, nil, __multi)
		if type(filters[1]) == "string" then
			__sp:setFilters(filter.newFilters(filters, params))
		else
			local __filters = cc.Array:create()
			for i in ipairs(filters) do
				__filters:addObject(filters[i])
			end
			__sp:setFilters(__filters)
		end
	elseif __type == "Array" then
		__sp = display.newSprite(filename, nil, nil, __multi)
		__sp:setFilters(filters)
	else
		__sp = display.newSprite(filename, nil, nil, __one)
		__sp:setFilter(filters)
	end
	return __sp
end
function display.newGraySprite(filename)
	local sprite = display.newSprite(filename)
	sprite:setGrayed(true)
	return sprite
end
function display.newDrawNode()
	return cc.DrawNode:create()
end
function display.newDrawSolidFan(params)
	local solidFan = display.newDrawNode()
	solidFan:drawSolidFan(cc.p(params.x or 0, params.y or 0), params.radius or 0, params.from or 0, params.angle or 0, params.segments or 32, params.color or cc.c4f(0, 0, 0, 1))
	return solidFan
end
function display.newSolidCircle(radius, params)
	local circle = display.newDrawNode()
	circle:drawDot(cc.p(params.x or 0, params.y or 0), radius or 0, params.color or cc.c4f(0, 0, 0, 1))
	return circle
end
function display.newCircle(radius, params)
	params = checktable(params)
	local makeVertexs = function(radius)
		local segments = params.segments or 32
		local startRadian = 0
		local endRadian = math.pi * 2
		local posX = params.x or 0
		local posY = params.y or 0
		if params.startAngle then
			startRadian = math.angle2radian(params.startAngle)
		end
		if params.endAngle then
			endRadian = startRadian + math.angle2radian(params.endAngle)
		end
		local radianPerSegm = 2 * math.pi / segments
		local params, points = params.endAngle, params.endAngle
		for i = 1, segments do
			local radii = startRadian + i * radianPerSegm
			if endRadian < radii then
				break
			end
			_UPVALUE2_ = nil
			points[#points + 1], (nil)[1] = nil, posX + radius * math.cos(radii)
			points[#points + 1], (nil)[2] = nil, posY + radius * math.sin(radii)
		end
		return points
	end
	local points = makeVertexs(radius)
	local circle = display.newPolygon(points, params)
	if circle then
		circle.radius = radius
		circle.params = params
		function circle:setRadius(radius)
			self:clear()
			local points = makeVertexs(radius)
			display.newPolygon(points, params, self)
		end
		function circle:setLineColor(color)
			self:clear()
			local points = makeVertexs(radius)
			params.borderColor = color
			display.newPolygon(points, params, self)
		end
	end
	return circle
end
function display.newRect(rect, params)
	local x, y, width, height = 0, 0
	x = rect.x or 0
	y = rect.y or 0
	height = rect.height
	_UPVALUE2_, _UPVALUE4_, width = nil, rect.y, rect.width
	_UPVALUE2_, (nil)[1] = x, x
	_UPVALUE2_, (nil)[2] = x, y
	_UPVALUE2_, x[1] = x, x
	_UPVALUE2_, x[2] = x, y + height
	_UPVALUE2_, x[1] = x + width, x + width
	_UPVALUE2_, x[2] = x + width, y + height
	;(x + width)[1] = x + width
	;(x + width)[2] = y
	rect.y[1] = nil
	rect.y[2] = x
	rect.y[3] = x
	local rect.y[4], points = x + width, rect.y
	return display.newPolygon(points, params)
end
function display.newLine(points, params)
	local radius, borderColor, scale
	if not params then
		borderColor = cc.c4f(0, 0, 0, 1)
		radius = 0.5
		scale = 1.0
	else
		borderColor = params.borderColor or cc.c4f(0, 0, 0, 1)
		radius = params.borderWidth and params.borderWidth / 2 or 0.5
		scale = checknumber(params.scale or 1.0)
	end
	for i, p in ipairs(points) do
		p = cc.p(p[1] * scale, p[2] * scale)
		points[i] = p
	end
	local drawNode = cc.DrawNode:create()
	drawNode:drawSegment(points[1], points[2], radius, borderColor)
	return drawNode
end
function display.newPolygon(points, params, drawNode)
	params = checktable(params)
	local scale = checknumber(params.scale or 1.0)
	local borderWidth = checknumber(params.borderWidth or 0.5)
	local fillColor = params.fillColor or cc.c4f(1, 1, 1, 1)
	local borderColor = params.borderColor or cc.c4f(0, 0, 0, 1)
	local _ENV, pts = 0, 0
	for i, p in ipairs(points) do
		_ENV = nil
		;(nil).x = p[1] * scale
		pts[i], (nil).y = nil, p[2] * scale
	end
	drawNode = drawNode or cc.DrawNode:create()
	_ENV = nil
	;(nil).fillColor = fillColor
	;(nil).borderWidth = borderWidth
	;(nil).borderColor = borderColor
	drawNode:drawPolygon(pts, nil)
	if drawNode then
		function drawNode:setLineStipple()
		end
		function drawNode:setLineStippleEnabled()
		end
		function drawNode:setLineColor(color)
		end
	end
	return drawNode
end
function display.newBMFontLabel(params)
	assert(type(params) == "table", "[framework.display] newBMFontLabel() invalid params")
	local text = tostring(params.text)
	local font = params.font
	local textAlign = params.align or cc.TEXT_ALIGNMENT_LEFT
	local maxLineW = params.maxLineWidth or 0
	local offsetX = params.offsetX or 0
	local offsetY = params.offsetY or 0
	local x, y = params.x, params.y
	assert(font ~= nil, "framework.display.newBMFontLabel() - not set font")
	local label = cc.Label:createWithBMFont(font, text, textAlign, maxLineW, cc.p(offsetX, offsetY))
	if not label then
		return
	end
	if type(x) == "number" and type(y) == "number" then
		label:setPosition(x, y)
	end
	return label
end
function display.newTTFLabel(params)
	assert(type(params) == "table", "[framework.display] newTTFLabel() invalid params")
	local text = tostring(params.text)
	local font = params.font or display.DEFAULT_TTF_FONT
	local size = params.size or display.DEFAULT_TTF_FONT_SIZE
	local color = params.color or display.COLOR_WHITE
	local textAlign = params.align or cc.TEXT_ALIGNMENT_LEFT
	local textValign = params.valign or cc.VERTICAL_TEXT_ALIGNMENT_TOP
	local x, y = params.x, params.y
	local dimensions = params.dimensions or cc.size(0, 0)
	assert(type(size) == "number", "[framework.display] newTTFLabel() invalid params.size")
	local label
	if params.font and cc.FileUtils:getInstance():isFileExist(font) then
		label = cc.Label:createWithTTF(text, font, size, dimensions, textAlign, textValign)
	else
		label = cc.Label:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
	end
	if label then
		label:setColor(color)
		if x and y then
			label:setPosition(x, y)
		end
	end
	return label
end
function display.align(target, anchorPoint, x, y)
	target:setAnchorPoint(display.ANCHOR_POINTS[anchorPoint])
	if x and y then
		target:setPosition(x, y)
	end
end
function display.addImageAsync(imagePath, callback)
	sharedTextureCache:addImageAsync(imagePath, callback)
end
function display.addSpriteFrames(plistFilename, image, handler)
	local async = type(handler) == "function"
	local asyncHandler
	if async then
		function asyncHandler(texture)
			handler(plistFilename)
		end
	end
	if display.TEXTURES_PIXEL_FORMAT[image] then
		cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[image])
		if async then
			sharedTextureCache:addImageAsync(image, asyncHandler)
		else
			sharedSpriteFrameCache:addSpriteFrame(plistFilename, image)
		end
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
	elseif async then
		sharedSpriteFrameCache:addSpriteFramesWithFileAsync(plistFilename, asyncHandler)
	else
		sharedSpriteFrameCache:addSpriteFrame(plistFilename, image)
	end
end
function display.removeSpriteFramesWithFile(plistFilename, imageName)
	sharedSpriteFrameCache:removeSpriteFramesFromFile(plistFilename)
	if imageName then
		display.removeSpriteFrameByImageName(imageName)
	end
end
function display.setTexturePixelFormat(filename, format)
	display.TEXTURES_PIXEL_FORMAT[filename] = format
end
function display.removeSpriteFrameByImageName(imageName)
	sharedSpriteFrameCache:removeSpriteFrameByName(imageName)
	cc.Director:getInstance():getTextureCache():removeTextureForKey(imageName)
end
function display.newBatchNode(image, capacity)
	return display.newNode()
end
function display.newSpriteFrame(frameName)
	local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
	if not frame then
		print_warn("display.newSpriteFrame() - invalid frameName %s", tostring(frameName))
	end
	return frame
end
function display.newFrames(pattern, begin, length, isReversed)
	local _ENV, frames
	local step = 1
	local last = begin + length - 1
	if isReversed then
		last, begin = begin, last
		step = -1
	end
	for index = begin, last, step do
		local frameName = string.format(pattern, index)
		local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	return frames
end
function display.newFramesEx(pattern, begin, length, maxIndex, isReversed)
	local _ENV, frames
	local step = 1
	local index = begin
	for i = 1, length do
		local frameName = string.format(pattern, index)
		print("frameName", frameName)
		local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		index = math.fmod(index + 1, maxIndex)
		frames[#frames + 1] = frame
	end
	return frames
end
function display.newAnimation(frames, time)
	local count = #frames
	time = time or 1.0 / count
	return cc.Animation:createWithSpriteFrames(frames, time)
end
function display.newAnimationEx(frameName, startIndex, frameCount, time, beginFrame)
	time = time or 1.0 / frameCount
	beginFrame = (beginFrame and beginFrame or 1) - startIndex
	return cc.Animation:createWithSpriteFrameName(frameName, startIndex, frameCount, beginFrame, time)
end
function display.setAnimationCache(name, animation)
	sharedAnimationCache:addAnimation(animation, name)
end
function display.getAnimationCache(name)
	return sharedAnimationCache:getAnimation(name)
end
function display.removeAnimationCache(name)
	sharedAnimationCache:removeAnimation(name)
end
function display.removeUnusedSpriteFrames()
	print("display.removeUnusedSpriteFrames")
	sharedSpriteFrameCache:removeUnusedSpriteFrames()
	sharedTextureCache:removeUnusedTextures()
end
function display.checkTextureMemory()
	if not sharedTextureCache.getTotalTexMemory then
		display.removeUnusedSpriteFrames()
		return
	end
	if not imageManager.isMemoryNotEnough("check") then
		return
	end
	local maxMem = 500
	if device.platform == "android" then
		local versions = userSDKManager.getAndroidSDKVersion() or 0
		if versions <= 21 then
			maxMem = 300
		end
	end
	local mem = sharedTextureCache:getTotalTexMemory()
	local memMb = mem / 1048576
	print(string.format("total mem %.2f Mb", memMb))
	if maxMem < memMb then
		display.removeUnusedSpriteFrames()
	end
end
display.PROGRESS_TIMER_BAR = 1
display.PROGRESS_TIMER_RADIAL = 0
function display.newProgressTimer(image, progresssType)
	if type(image) == "string" then
		image = display.newSprite(image)
	end
	local progress = cc.ProgressTimer:create(image)
	progress:setType(progresssType)
	return progress
end
function display.captureScreen(callback, fileName)
	cc.utils:captureScreen(callback, fileName)
end
return display

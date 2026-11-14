local GridView = class("GridView", function()
	return display.newNode()
end)
local TAG = "[GridView]"
local Log = Log
local math_floor = math.floor
local math_ceil = math.ceil
local math_max = math.max
local math_min = math.min
local pairs = pairs
local ipairs = ipairs
GridView.FILL_LEFT_RIGHT = 1
GridView.FILL_TOP_DOWN = 2
GridView.FILL_RIGHT_LEFT = 3
GridView.SIZE_MODE_LIMIT = 1
GridView.SIZE_MODE_WIDTH_LIMIT = 2
GridView.SIZE_MODE_HEIGHT_LIMIT = 3
local RECT_FOR_CHECK
function GridView:ctor(params)

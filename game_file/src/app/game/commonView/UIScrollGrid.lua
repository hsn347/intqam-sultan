local UIScrollGrid = class("UIScrollGrid", cc.ui.UIScrollView)
local GridView = requireLocal(".GridView")
UIScrollGrid.LOCATE_MODE_NONE = -1
UIScrollGrid.LOCATE_MODE_TOP = 0
UIScrollGrid.LOCATE_MODE_LEFT = 1
UIScrollGrid.LOCATE_MODE_CENTER = 2
local math_ceil = math.ceil
local math_abs = math.abs
local table_insert = table.insert
local ipairs = ipairs
function UIScrollGrid:ctor(params)

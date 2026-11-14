local publicRead = include("publicRead")
local activity_9001746_Read = include("activity_9001746_Read")
local activity_9001746_Ctrl = SoraDGetCtrl("activity_9001746_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_game = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_game", Com_game)
local ACTIVITY_PKG = "Activity_9001746"
local CELL_SIZE = 88
local CELL_GAP_X = 2
local CELL_GAP_Y = 1
local GRID_COL = 6
local GRID_ROW = 6
local GRID_COUNT = 36
local BOMB_ICON_URL = "6663.png"
local NORMAL_BOX_ICON_URL = "icon_9001746_box1.png"
local RARE_BOX_ICON_URL = "icon_9001746_box2.png"
local getRewardFromList = function(rewardList, useLast)
	if not rewardList then
		rewardList, _UPVALUE0_ = nil, nil
	end
	local reward = useLast and rewardList[#rewardList] or rewardList[1]
	if not reward then
		return nil
	end
	_UPVALUE0_ = nil
	;(nil).id = reward.id or reward.itemID or reward[1] or 0
	;(nil).count = reward.count or reward.num or reward[2] or 0
	return nil
end
local normalizeRewardList = function(rewardList)

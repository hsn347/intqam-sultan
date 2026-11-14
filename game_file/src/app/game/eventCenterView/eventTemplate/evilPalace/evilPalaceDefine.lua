local _ENV, _ENV, _ENV, evilPalaceDefine
;(nil).file = "yanba1_dj_"
;(nil).sn = 1
_ENV, (nil).dj, (nil).en = nil, nil, 16
;(nil).file = "yanba1_gj_"
;(nil).sn = 1
_ENV, (nil).gj, (nil).en = nil, nil, 16
;(nil).file = "yanba1_sw_"
;(nil).sn = 1
_ENV, (nil).sw, (nil).en = nil, nil, 16
_ENV, _ENV, evilPalaceDefine.smallBossAction, (nil).sj, (nil).arryFiles = nil, nil, nil, nil, "yanba1_dj_01,yanba1_dj_02,yanba1_dj_03,yanba1_sw_01,yanba1_sw_02,yanba1_sw_03,yanba1_sw_04,yanba1_sw_03,yanba1_sw_02,yanba1_sw_01,yanba1_dj_03,yanba1_dj_02,yanba1_dj_01"
;(nil).file = "yanba2_dj_"
;(nil).sn = 1
_ENV, (nil).dj, (nil).en = nil, nil, 16
;(nil).file = "yanba2_gj_"
;(nil).sn = 1
_ENV, (nil).gj, (nil).en = nil, nil, 16
;(nil).file = "yanba2_sw_"
;(nil).sn = 1
_ENV, (nil).sw, (nil).en = nil, nil, 16
evilPalaceDefine.bigBossAction, (nil).sj, (nil).arryFiles = nil, nil, "yanba2_dj_01,yanba2_dj_02,yanba2_dj_03,yanba2_sw_01,yanba2_sw_02,yanba2_sw_03,yanba2_sw_04,yanba2_sw_03,yanba2_sw_02,yanba2_sw_01,yanba2_dj_03,yanba2_dj_02,yanba2_dj_01"
function evilPalaceDefine.getBossActionArray(isBigBoss, actionFlag)
	local actionInfo
	if isBigBoss then
		actionInfo = evilPalaceDefine.bigBossAction[actionFlag]
	else
		actionInfo = evilPalaceDefine.smallBossAction[actionFlag]
	end
	if actionInfo then
		if actionInfo.arryFiles then
			local oriTbl = SoraDStringSplit(actionInfo.arryFiles, ",")
			local evilPalaceDefine, frms = actionInfo.arryFiles, actionInfo.arryFiles
			for i, v in ipairs(oriTbl) do
				table.insert(frms, display.newSpriteFrame(v .. ".png"))
			end
			return frms
		else
			return display.newFrames(actionInfo.file .. "%.2d.png", actionInfo.sn, actionInfo.en)
		end
	else
		return nil
	end
end
_ENV, _ENV, evilPalaceDefine.getRewardBox = nil, function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end, function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end
;(nil).file = "langguai_dj_ws_"
;(nil).sn = 1
_ENV, (function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end).dj, (nil).en = nil, nil, 24
;(nil).file = "langguai_gj_ws_"
;(nil).sn = 1
_ENV, (function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end).gj, (nil).en = nil, nil, 24
;(nil).file = "langguai_sw_ws_"
;(nil).sn = 1
_ENV, (function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end).sw, (nil).en = nil, nil, 24
evilPalaceDefine.snowWolfAction, (function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end).sj, (nil).arryFiles = function(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	else
		return nil
	end
end, nil, "langguai_dj_ws_01,langguai_dj_ws_02,langguai_dj_ws_03,langguai_sw_ws_01,langguai_sw_ws_02,langguai_sw_ws_03,langguai_sw_ws_04,langguai_sw_ws_03,langguai_sw_ws_02,langguai_sw_ws_01,langguai_dj_ws_03,langguai_dj_ws_02,langguai_dj_ws_01"
function evilPalaceDefine.getSnowWolfActionArray(actionFlag)
	local actionInfo = evilPalaceDefine.snowWolfAction[actionFlag]
	if actionInfo.arryFiles then
		local oriTbl = SoraDStringSplit(actionInfo.arryFiles, ",")
		local evilPalaceDefine, frms = actionInfo.arryFiles, actionInfo.arryFiles
		for i, v in ipairs(oriTbl) do
			table.insert(frms, display.newSpriteFrame(v .. ".png"))
		end
		return frms
	else
		return display.newFrames(actionInfo.file .. "%.2d.png", actionInfo.sn, actionInfo.en)
	end
end
function evilPalaceDefine.getSnowWolfRewardBox(isBigBoss)
	local actionInfo
	if isBigBoss then
		actionInfo = "mwdgx01_0"
	else
		actionInfo = "mwdgx02_0"
	end
	if actionInfo then
		return display.newFrames(actionInfo .. "%d.png", 1, 8)
	end
end
return evilPalaceDefine

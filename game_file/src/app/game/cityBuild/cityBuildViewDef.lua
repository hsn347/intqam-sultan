local cityBuildConstDef = include("cityBuildConstDef")
local _ENV, cityBuildViewDef = "cityBuildConstDef", "cityBuildConstDef"
local imgLvBg = "icon_main_build_lv.png"
local imgUpgrade = "icon_main_build_upgrade.png"
local imgTopBg1 = "frame_main_receive.png"
local imgTopBg2 = "frame_main_receive.png"
local imgTopBg3 = "frame_main_receive.png"
local scaleLvBg = 1
local scaleImgUpgrade = 1
local colorTextLv = cc.c3b(235, 255, 20)
local colorTextTopTip = cc.c3b(208, 181, 126)
local opacityBuildBtn = 180
local colorBuildBtn
local sizeTopCollect = cc.size(108, 124)
local sizeTopFree = cc.size(106, 103)
local sizeTopTrain = cc.size(90, 85)
local dLvBgPos = cc.p(110, -17)
local getImgUpgradePos = function(basePos)
	_UPVALUE0_ = nil
	;(nil).x = basePos.x + 46
	;(nil).y = basePos.y + 22
	return nil
end
local getTextLvPos = function(basePos)
	_UPVALUE0_ = nil
	;(nil).x = basePos.x + 20
	;(nil).y = basePos.y + 1
	return nil
end
_ENV, cityBuildViewDef.cityBuildLvPosInfo = require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"), require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")
require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").sprite = true
require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").animation = true
cityBuildViewDef.tblCanAddToBatchNode, require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").action = require("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"), true
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.isCanAddToBatchNode = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "zhucheng.png"
;(nil).x = -119
;(nil).offset, (nil).y = nil, 118.7
;(nil).alone = true
_ENV, (nil).zOrder = nil, -1
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 400
_ENV, (nil).size, (nil).height = nil, nil, 320
;(nil).x = -101.0
;(nil).offset, (nil).y = nil, 86
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).x = 0.5
_ENV, (nil).anchor, (nil).y = nil, nil, 0.5
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = 125
;(nil).y = -28
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = 125
getImgUpgradePos(nil).offset, (nil).y = nil, -33
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = nil, "textLv"
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
_ENV = nil
;(nil).x = 125
;(nil).y = -33
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCastle, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCastle, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCastle, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCastle, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCastle, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "cangku.png"
;(nil).x = 8
;(nil).offset, (nil).y = nil, 35
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 180
_ENV, (nil).size, (nil).height = nil, nil, 170
;(nil).x = 16
;(nil).offset, (nil).y = nil, 39
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).x = 0.5
_ENV, (nil).anchor, (nil).y = nil, nil, 0.5
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;(nil).anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildDepot, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildDepot, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildDepot, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildDepot, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildDepot, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "chengmen_lv1.png"
;(nil).x = 0
;(nil).offset, (nil).y = nil, 0
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 250
_ENV, (nil).size, (nil).height = nil, nil, 220
;(nil).x = 15
;(nil).offset, (nil).y = nil, 6
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).x = 0.5
_ENV, (nil).anchor, (nil).y = nil, nil, 0.5
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = 110
;(nil).y = -97
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = 110
getImgUpgradePos(nil).offset, (nil).y = nil, -110
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(nil).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = nil
;(nil).x = 110
;(nil).y = -110
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWall, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWall, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWall, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWall, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWall, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "jianta_lv1.png"
;(nil).x = 0
;(nil).offset, (nil).y = nil, 0
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 100
_ENV, (nil).size, (nil).height = nil, nil, 130
;(nil).x = 0
;(nil).offset, (nil).y = nil, -30
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).x = 0.5
_ENV, (nil).anchor, (nil).y = nil, nil, 0.5
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = 85
;(nil).y = -152
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = 85
getImgUpgradePos(nil).offset, (nil).y = nil, -152
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(nil).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = nil
;(nil).x = 85
;(nil).y = -152
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildTurret, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildTurret, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildTurret, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildTurret, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildTurret, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "liaowangta.png"
;(nil).x = -13
_ENV, (nil).offset, (nil).y = nil, nil, 52
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 110
_ENV, (nil).size, (nil).height = nil, nil, 210
;(nil).x = 0
;(nil).offset, (nil).y = nil, 0
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).x = 0.5
_ENV, (nil).anchor, (nil).y = nil, nil, 0.5
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = 70
;(nil).y = -122
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = 70
getImgUpgradePos(nil).offset, (nil).y = nil, -122
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(nil).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = nil
;(nil).x = 70
;(nil).y = -122
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWatchTower, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWatchTower, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWatchTower, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWatchTower, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildWatchTower, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "dashiguan.png"
;(nil).x = 2
;(nil).offset, (nil).y = nil, 46
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 180
_ENV, (nil).size, (nil).height = nil, nil, 170
;(nil).x = 3
_ENV, (nil).offset, (nil).y = nil, nil, 55
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;(nil).anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildEmbassy, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildEmbassy, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildEmbassy, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildEmbassy, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildEmbassy, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "shichang.png"
;(nil).x = 0
;(nil).offset, (nil).y = nil, 37
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 200
_ENV, (nil).size, (nil).height = nil, nil, 160
;(nil).x = 9
_ENV, (nil).offset, (nil).y = nil, nil, 43
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;(nil).anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildMarket, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildMarket, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildMarket, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildMarket, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildMarket, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, _ENV, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "xueyuan.png"
;(nil).x = -2
;(nil).offset, (nil).y = nil, 64
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 190
_ENV, (nil).size, (nil).height = nil, nil, 160
;(nil).x = 1
_ENV, (nil).offset, (nil).y = nil, nil, 80
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;(nil).anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, (nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = nil, "z.png"
;(nil).x = 66
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, (nil).y = nil, 92
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE1_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = nil, "et_xueyuan.png"
;(nil).x = 9.67
;(nil).offset, (nil).y = nil, 71
;(nil).actionKey = "Glow"
;(nil).alone = true
_ENV, _UPVALUE5_, _ENV, cityBuildViewDef.tblBuildCollege, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "baozangzhichi.png"
;(nil).x = 0
;(nil).offset, (nil).y = nil, 38
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 180
_ENV, (nil).size, (nil).height = nil, nil, 150
;(nil).x = 2
_ENV, (nil).offset, (nil).y = nil, nil, 41
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;(nil).anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x
;(nil).y = dLvBgPos.y
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE14_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE14_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE14_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE14_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE14_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleNormal_1"
;(nil).x = 5
;(nil).offset, (nil).y = nil, 100
;(nil).scaleX = 0.4615
;(nil).scaleY = 0.4286
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_01.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleNormal_2"
;(nil).x = 7.6
;(nil).offset, (nil).y = nil, 60
;(nil).scaleX = 1.4936
;(nil).scaleY = 1.109
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_03.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = getImgUpgradePos(nil), "buildParticleNormal_3"
getImgUpgradePos(nil).x = 8.8
;(nil).offset, getImgUpgradePos(nil).y = getImgUpgradePos(nil), 100
;(nil).scale = 1.13
;(nil).positionType = "relative"
_ENV, (nil).particleFile = getImgUpgradePos(nil), "Particle/et_xyc_03.plist"
getImgUpgradePos(nil).nodeType = "particle"
_ENV, getImgUpgradePos(nil).nodeName = nil, "buildParticleNormal_4"
;(nil).x = 8.4
getImgUpgradePos(nil).offset, (nil).y = nil, -6
getImgUpgradePos(nil).scaleX = 1.71
getImgUpgradePos(nil).scaleY = 1.7315
getImgUpgradePos(nil).positionType = "relative"
_ENV, getImgUpgradePos(nil).particleFile = nil, "Particle/et_xyc_05.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "buildParticleNormal_5"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 6
;(nil).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0
;(nil).scaleX = 0.4
;(nil).scaleY = 0.3726
;(nil).positionType = "relative"
_ENV, (nil).particleFile = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "Particle/et_xyc_06.plist"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "particle"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = nil, "buildParticleBright_1"
;(nil).x = 5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, (nil).y = nil, 100
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.scaleX = 0.4615
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.scaleY = 0.4286
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.positionType = "relative"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.particleFile = nil, "Particle/et_xyc_01.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = dLvBgPos.y, "buildParticleBright_2"
dLvBgPos.y.x = 5
;(nil).offset, dLvBgPos.y.y = dLvBgPos.y, 30
;(nil).scale = 1
;(nil).positionType = "relative"
_ENV, (nil).particleFile = dLvBgPos.y, "Particle/et_xyc_02.plist"
dLvBgPos.y.nodeType = "particle"
_ENV, dLvBgPos.y.nodeName = nil, "buildParticleBright_3"
;(nil).x = 5
dLvBgPos.y.offset, (nil).y = nil, 62
dLvBgPos.y.scale = 1.1282
dLvBgPos.y.positionType = "relative"
_ENV, dLvBgPos.y.particleFile = nil, "Particle/et_xyc_03.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_4"
;(nil).x = 57
;(nil).offset, (nil).y = nil, -8
;(nil).scale = 0.47
;(nil).rotation = -4.3
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_04.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_5"
;(nil).x = 54
;(nil).offset, (nil).y = nil, 40.5
;(nil).scale = 0.35
;(nil).rotation = -14.96
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_04.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_6"
;(nil).x = -48
;(nil).offset, (nil).y = nil, -8
;(nil).scaleX = -0.47
;(nil).scaleY = 0.4712
;(nil).rotation = 4.3
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_04.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_7"
;(nil).x = -46
;(nil).offset, (nil).y = nil, 45
;(nil).scaleX = -0.35
;(nil).scaleY = 0.35
;(nil).rotation = 14.96
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_04.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_8"
;(nil).x = 6
;(nil).offset, (nil).y = nil, -7
;(nil).scale = 3.2
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_xyc_05.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleBright_9"
;(nil).x = 5
;(nil).offset, (nil).y = nil, -2
;(nil).scaleX = 0.4675
;(nil).scaleY = 0.4354
;(nil).positionType = "relative"
;(nil).particleFile = "Particle/et_xyc_06.plist"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[7] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[8] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", dLvBgPos.y
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[9] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[10] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[11] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[12] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[13] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildWishWell, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[14] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "tiejiangpu.png"
;(nil).x = 2
;(nil).offset, (nil).y = nil, 38
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 220
_ENV, (nil).size, (nil).height = nil, nil, 160
;(nil).x = 5
_ENV, (nil).offset, (nil).y = nil, nil, 37
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = dLvBgPos.x - 66
;(nil).y = dLvBgPos.y - 22
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = dLvBgPos.x - 66
getImgUpgradePos(nil).offset, (nil).y = nil, dLvBgPos.y - 22
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = dLvBgPos.y - 22, "textLv"
;(dLvBgPos.y - 22).x = 0.5
;(nil).anchor, (dLvBgPos.y - 22).y = dLvBgPos.y - 22, 0.5
_ENV = nil
;(nil).x = dLvBgPos.x - 66
;(nil).y = dLvBgPos.y - 22
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, (nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = nil, "z.png"
;(nil).x = 50
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, (nil).y = nil, 90
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = nil, "et_tiejiangpu.png"
;(nil).x = 9
;(nil).offset, (nil).y = nil, 25
;(nil).actionKey = "Glow"
_ENV, (nil).alone = nil, true
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = nil, "buildParticleNormal_1"
;(nil).x = -80
;(nil).offset, (nil).y = nil, 121
;(nil).scale = 1
;(nil).rotation = -10.76
;(nil).positionType = "relative"
_ENV, (nil).particleFile = nil, "Particle/et_tiejiangpuyan_01.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = getImgUpgradePos(nil), "buildParticleNormal_2"
getImgUpgradePos(nil).x = 68
;(nil).offset, getImgUpgradePos(nil).y = getImgUpgradePos(nil), 93
;(nil).scale = 0.9
;(nil).rotation = -4.85
;(nil).positionType = "relative"
_ENV, (nil).particleFile = getImgUpgradePos(nil), "Particle/et_tiejiangpuyan_01.plist"
getImgUpgradePos(nil).nodeType = "particle"
_ENV, getImgUpgradePos(nil).nodeName = nil, "buildParticleNormal_3"
;(nil).x = -42
getImgUpgradePos(nil).offset, (nil).y = nil, -12
getImgUpgradePos(nil).scaleX = 0.9576
getImgUpgradePos(nil).scaleY = 1.0924
getImgUpgradePos(nil).rotation = 7.56
getImgUpgradePos(nil).positionType = "relative"
_ENV, getImgUpgradePos(nil).particleFile = nil, "Particle/et_tiejiangpuyan_02.plist"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "buildParticleNormal_4"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 34
;(nil).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 10
;(nil).scaleX = 0.2818
;(nil).scaleY = 0.6099
;(nil).rotation = 0.17
;(nil).positionType = "relative"
;(nil).particleFile = "Particle/et_tiejiangpuyan_02.plist"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildBlackSmith, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildBlackSmith, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildBlackSmith, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildBlackSmith, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE6_, _ENV, cityBuildViewDef.tblBuildBlackSmith, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = nil, "qibingying.png"
;(nil).x = 3
;(nil).offset, (nil).y = nil, 33
_ENV, (nil).alone = nil, true
;(nil).nodeType = "layout"
_ENV, (nil).nodeName = nil, "buildBtn"
;(nil).width = 230
_ENV, (nil).size, (nil).height = nil, nil, 180
;(nil).x = 2
_ENV, (nil).offset, (nil).y = nil, nil, 45
;(nil).x = 0.5
;(nil).anchor, (nil).y = nil, 0.5
;(nil).color = colorBuildBtn
_ENV, (nil).opacity = nil, opacityBuildBtn
;(nil).nodeType = "sprite"
;(nil).nodeName = "imgUpgrade"
;(nil).nodeImg = imgUpgrade
_ENV = nil
;(nil).x = 117
;(nil).y = -8
;(nil).offset = getImgUpgradePos(nil)
;(nil).scale = scaleImgUpgrade
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(nil).nodeImg = nil, imgLvBg
;(nil).x = 117
getImgUpgradePos(nil).offset, (nil).y = nil, -8
getImgUpgradePos(nil).scale = scaleLvBg
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "text"
_ENV, (nil).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(nil).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = nil
;(nil).x = 117
;(nil).y = -8
;(nil).offset = getTextLvPos(nil)
;(nil).skewY = 25
;(nil).color = colorTextLv
;(nil).default = "0"
;(nil).fontSize = 18
;(nil).hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, (nil).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = nil, "z.png"
;(nil).x = 19
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, (nil).y = nil, 90
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE7_, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).baseView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = nil, "et_majiu.png"
;(nil).x = 67
;(nil).offset, (nil).y = nil, 14
;(nil).actionKey = "Glow"
_ENV, (nil).alone = nil, true
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlowWar"
_ENV, (nil).nodeImg = nil, "image_qiby.png"
;(nil).x = 2
;(nil).offset, (nil).y = nil, 14
;(nil).actionKey = "Glow"
_ENV, (nil).alone = nil, true
;(nil).nodeType = "animation"
;(nil).nodeName = "buildAnimationType1_1"
_ENV, (nil).isFlipX = getImgUpgradePos(nil), false
getImgUpgradePos(nil).x = -18
;(nil).offset, getImgUpgradePos(nil).y = getImgUpgradePos(nil), 16
;(nil).nodeFormat = "shibing2_%02d.png"
;(nil).nodeStart = 1
;(nil).nodeEnd = 8
_ENV, (nil).alone = getImgUpgradePos(nil), true
getImgUpgradePos(nil).nodeType = "animation"
getImgUpgradePos(nil).nodeName = "buildAnimationType1_2"
_ENV, getImgUpgradePos(nil).isFlipX = nil, false
;(nil).x = -42
getImgUpgradePos(nil).offset, (nil).y = nil, 4
getImgUpgradePos(nil).nodeFormat = "shibing2_%02d.png"
getImgUpgradePos(nil).nodeStart = 1
getImgUpgradePos(nil).nodeEnd = 8
_ENV, getImgUpgradePos(nil).alone = nil, true
;(nil).nodeType = "animation"
;(nil).nodeName = "buildAnimationType1_3"
_ENV, (nil).isFlipX = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, false
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 21
;(nil).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0
;(nil).nodeFormat = "shibing2_%02d.png"
;(nil).nodeStart = 1
;(nil).nodeEnd = 8
_ENV, (nil).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "animation"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildAnimationType1_4"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.isFlipX = "buildAnimationType1_4", false
;("buildAnimationType1_4").x = -7
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("buildAnimationType1_4").y = "buildAnimationType1_4", -11
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeFormat = "shibing2_%02d.png"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeStart = 1
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeEnd = 8
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = "buildAnimationType1_4", true
;("buildAnimationType1_4").nodeType = "sprite"
;("buildAnimationType1_4").nodeName = "iconMiracle"
_ENV, ("buildAnimationType1_4").nodeImg = "armyicon_b_510.png", "armyicon_b_510.png"
;("armyicon_b_510.png").x = 45
;("buildAnimationType1_4").offset, ("armyicon_b_510.png").y = "armyicon_b_510.png", 0
;("buildAnimationType1_4").zOrder = 10
;("buildAnimationType1_4").alone = true
;("buildAnimationType1_4").scale = 0.3
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", getImgUpgradePos(nil)
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblBuildStables, (function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end).otherView, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[7] = function(nodeType)
	if cityBuildViewDef.tblCanAddToBatchNode[nodeType] then
		return true
	end
	return false
end, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "buildAnimationType1_4"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "gongbingying.png", "gongbingying.png"
;("gongbingying.png").x = 0
;(nil).offset, ("gongbingying.png").y = "gongbingying.png", 38
_ENV, (nil).alone = "gongbingying.png", true
;("gongbingying.png").nodeType = "layout"
_ENV, ("gongbingying.png").nodeName = getImgUpgradePos(nil), "buildBtn"
getImgUpgradePos(nil).width = 230
_ENV, ("gongbingying.png").size, getImgUpgradePos(nil).height = getImgUpgradePos(nil), getImgUpgradePos(nil), 180
getImgUpgradePos(nil).x = 7
_ENV, ("gongbingying.png").offset, getImgUpgradePos(nil).y = getImgUpgradePos(nil), getImgUpgradePos(nil), 50
getImgUpgradePos(nil).x = 0.5
;("gongbingying.png").anchor, getImgUpgradePos(nil).y = getImgUpgradePos(nil), 0.5
;("gongbingying.png").color = colorBuildBtn
_ENV, ("gongbingying.png").opacity = getImgUpgradePos(nil), opacityBuildBtn
getImgUpgradePos(nil).nodeType = "sprite"
getImgUpgradePos(nil).nodeName = "imgUpgrade"
getImgUpgradePos(nil).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = dLvBgPos.x
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = dLvBgPos.y
getImgUpgradePos(nil).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
getImgUpgradePos(nil).scale = scaleImgUpgrade
_ENV, getImgUpgradePos(nil).alone = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), true
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeType = "sprite"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = dLvBgPos.x
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, dLvBgPos.y
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).scale = scaleLvBg
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = 0.3
;(0.3).x = dLvBgPos.x
;(0.3).y = dLvBgPos.y
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos(0.3)
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = 0.3, "z.png"
;(0.3).x = 79
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, (0.3).y = 0.3, 90
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "gongbingying.png"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, getImgUpgradePos(nil)
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = "et_bachang.png", "et_bachang.png"
;("et_bachang.png").x = 42
;(nil).offset, ("et_bachang.png").y = "et_bachang.png", 50.67
;(nil).actionKey = "Glow"
_ENV, (nil).alone = "et_bachang.png", true
;("et_bachang.png").nodeType = "action"
;("et_bachang.png").nodeName = "buildGlowWar"
_ENV, ("et_bachang.png").nodeImg = "image_gongby.png", "image_gongby.png"
;("image_gongby.png").x = -5
;("et_bachang.png").offset, ("image_gongby.png").y = "image_gongby.png", 50
;("et_bachang.png").actionKey = "Glow"
_ENV, ("et_bachang.png").alone = "image_gongby.png", true
;("image_gongby.png").nodeType = "animation"
;("image_gongby.png").nodeName = "buildAnimationType1_1"
_ENV, ("image_gongby.png").isFlipX = -5, false
;(-5).x = -18
;("image_gongby.png").offset, (-5).y = -5, 29
;("image_gongby.png").nodeFormat = "shibing3_%02d.png"
;("image_gongby.png").nodeStart = 1
;("image_gongby.png").nodeEnd = 8
_ENV, ("image_gongby.png").alone = "shibing3_%02d.png", true
;("shibing3_%02d.png").nodeType = "animation"
;("shibing3_%02d.png").nodeName = "buildAnimationType1_2"
_ENV, ("shibing3_%02d.png").isFlipX = 29, false
;(29).x = -38
;("shibing3_%02d.png").offset, (29).y = 29, 18
;("shibing3_%02d.png").nodeFormat = "shibing3_%02d.png"
;("shibing3_%02d.png").nodeStart = 1
;("shibing3_%02d.png").nodeEnd = 8
_ENV, ("shibing3_%02d.png").alone = "shibing3_%02d.png", true
;("shibing3_%02d.png").nodeType = "animation"
;("shibing3_%02d.png").nodeName = "buildAnimationType1_3"
_ENV, ("shibing3_%02d.png").isFlipX = -38, false
;(-38).x = 8
;("shibing3_%02d.png").offset, (-38).y = -38, 14
;("shibing3_%02d.png").nodeFormat = "shibing3_%02d.png"
;("shibing3_%02d.png").nodeStart = 1
;("shibing3_%02d.png").nodeEnd = 8
_ENV, ("shibing3_%02d.png").alone = "shibing3_%02d.png", true
;("shibing3_%02d.png").nodeType = "animation"
;("shibing3_%02d.png").nodeName = "buildAnimationType1_4"
_ENV, ("shibing3_%02d.png").isFlipX = "buildAnimationType1_4", false
;("buildAnimationType1_4").x = -11
;("shibing3_%02d.png").offset, ("buildAnimationType1_4").y = "buildAnimationType1_4", 5
;("shibing3_%02d.png").nodeFormat = "shibing3_%02d.png"
;("shibing3_%02d.png").nodeStart = 1
;("shibing3_%02d.png").nodeEnd = 8
_ENV, ("shibing3_%02d.png").alone = "shibing3_%02d.png", true
;("shibing3_%02d.png").nodeType = "sprite"
;("shibing3_%02d.png").nodeName = "iconMiracle"
_ENV, ("shibing3_%02d.png").nodeImg = "armyicon_b_610.png", "armyicon_b_610.png"
;("armyicon_b_610.png").x = 45
;("shibing3_%02d.png").offset, ("armyicon_b_610.png").y = "armyicon_b_610.png", 0
;("shibing3_%02d.png").zOrder = 10
;("shibing3_%02d.png").alone = true
;("shibing3_%02d.png").scale = 0.3
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "et_bachang.png"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "image_gongby.png"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing3_%02d.png"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing3_%02d.png"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing3_%02d.png"
cityBuildViewDef.tblBuildRange, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[7] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing3_%02d.png"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "bubingying.png", "bubingying.png"
;("bubingying.png").x = -6
;(nil).offset, ("bubingying.png").y = "bubingying.png", 32
_ENV, (nil).alone = "bubingying.png", true
;("bubingying.png").nodeType = "layout"
_ENV, ("bubingying.png").nodeName = 32, "buildBtn"
;(32).width = 240
_ENV, ("bubingying.png").size, (32).height = 32, 32, 170
;(32).x = 4
_ENV, ("bubingying.png").offset, (32).y = 32, 32, 29
;(32).x = 0.5
;("bubingying.png").anchor, (32).y = 32, 0.5
;("bubingying.png").color = colorBuildBtn
_ENV, ("bubingying.png").opacity = 32, opacityBuildBtn
;(32).nodeType = "sprite"
;(32).nodeName = "imgUpgrade"
;(32).nodeImg = imgUpgrade
_ENV = "shibing3_%02d.png"
;("shibing3_%02d.png").x = 111
;("shibing3_%02d.png").y = -14
;(32).offset = getImgUpgradePos("shibing3_%02d.png")
;(32).scale = scaleImgUpgrade
_ENV, (32).alone = getImgUpgradePos("shibing3_%02d.png"), true
getImgUpgradePos("shibing3_%02d.png").nodeType = "sprite"
getImgUpgradePos("shibing3_%02d.png").nodeName = "buildLvBg"
_ENV, getImgUpgradePos("shibing3_%02d.png").nodeImg = "shibing3_%02d.png", imgLvBg
;("shibing3_%02d.png").x = 111
getImgUpgradePos("shibing3_%02d.png").offset, ("shibing3_%02d.png").y = "shibing3_%02d.png", -14
getImgUpgradePos("shibing3_%02d.png").scale = scaleLvBg
_ENV, getImgUpgradePos("shibing3_%02d.png").alone = "shibing3_%02d.png", true
;("shibing3_%02d.png").nodeType = "text"
_ENV, ("shibing3_%02d.png").nodeName = -14, "textLv"
;(-14).x = 0.5
;("shibing3_%02d.png").anchor, (-14).y = -14, 0.5
_ENV = "shibing3_%02d.png"
;("shibing3_%02d.png").x = 111
;("shibing3_%02d.png").y = -14
;("shibing3_%02d.png").offset = getTextLvPos("shibing3_%02d.png")
;("shibing3_%02d.png").skewY = 25
;("shibing3_%02d.png").color = colorTextLv
;("shibing3_%02d.png").default = "0"
;("shibing3_%02d.png").fontSize = 18
;("shibing3_%02d.png").hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, ("shibing3_%02d.png").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "shibing3_%02d.png", "z.png"
;("shibing3_%02d.png").x = 80
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("shibing3_%02d.png").y = "shibing3_%02d.png", 98
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "bubingying.png"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, 32
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, getImgUpgradePos("shibing3_%02d.png")
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, "shibing3_%02d.png"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = "et_bingying.png", "et_bingying.png"
;("et_bingying.png").x = -8
;(nil).offset, ("et_bingying.png").y = "et_bingying.png", 34
;(nil).actionKey = "Glow"
_ENV, (nil).alone = "et_bingying.png", true
;("et_bingying.png").nodeType = "action"
;("et_bingying.png").nodeName = "buildGlowWar"
_ENV, ("et_bingying.png").nodeImg = "image_buby.png", "image_buby.png"
;("image_buby.png").x = 16
;("et_bingying.png").offset, ("image_buby.png").y = "image_buby.png", 29
;("et_bingying.png").actionKey = "Glow"
_ENV, ("et_bingying.png").alone = "image_buby.png", true
;("image_buby.png").nodeType = "animation"
;("image_buby.png").nodeName = "buildAnimationType1_1"
_ENV, ("image_buby.png").isFlipX = 29, false
;(29).x = -20
;("image_buby.png").offset, (29).y = 29, 10
;("image_buby.png").nodeFormat = "shibing1_%02d.png"
;("image_buby.png").nodeStart = 1
;("image_buby.png").nodeEnd = 8
_ENV, ("image_buby.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "animation"
;("shibing1_%02d.png").nodeName = "buildAnimationType1_2"
_ENV, ("shibing1_%02d.png").isFlipX = -20, false
;(-20).x = -41
;("shibing1_%02d.png").offset, (-20).y = -20, -3
;("shibing1_%02d.png").nodeFormat = "shibing1_%02d.png"
;("shibing1_%02d.png").nodeStart = 1
;("shibing1_%02d.png").nodeEnd = 8
_ENV, ("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "animation"
;("shibing1_%02d.png").nodeName = "buildAnimationType1_3"
_ENV, ("shibing1_%02d.png").isFlipX = -3, false
;(-3).x = -19
;("shibing1_%02d.png").offset, (-3).y = -3, -16
;("shibing1_%02d.png").nodeFormat = "shibing1_%02d.png"
;("shibing1_%02d.png").nodeStart = 1
;("shibing1_%02d.png").nodeEnd = 8
_ENV, ("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "animation"
;("shibing1_%02d.png").nodeName = "buildAnimationType1_4"
_ENV, ("shibing1_%02d.png").isFlipX = "buildAnimationType1_4", false
;("buildAnimationType1_4").x = 8
;("shibing1_%02d.png").offset, ("buildAnimationType1_4").y = "buildAnimationType1_4", -3
;("shibing1_%02d.png").nodeFormat = "shibing1_%02d.png"
;("shibing1_%02d.png").nodeStart = 1
;("shibing1_%02d.png").nodeEnd = 8
_ENV, ("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "sprite"
;("shibing1_%02d.png").nodeName = "iconMiracle"
_ENV, ("shibing1_%02d.png").nodeImg = "armyicon_b_410.png", "armyicon_b_410.png"
;("armyicon_b_410.png").x = 45
;("shibing1_%02d.png").offset, ("armyicon_b_410.png").y = "armyicon_b_410.png", 0
;("shibing1_%02d.png").zOrder = 10
;("shibing1_%02d.png").scale = 0.3
;("shibing1_%02d.png").alone = true
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "et_bingying.png"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "image_buby.png"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing1_%02d.png"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing1_%02d.png"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing1_%02d.png"
cityBuildViewDef.tblChariotPlant, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[7] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "shibing1_%02d.png"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "chebingying.png", "chebingying.png"
;("chebingying.png").x = 0
;(nil).offset, ("chebingying.png").y = "chebingying.png", 39
_ENV, (nil).alone = "chebingying.png", true
;("chebingying.png").nodeType = "layout"
_ENV, ("chebingying.png").nodeName = "image_buby.png", "buildBtn"
;("image_buby.png").width = 240
_ENV, ("chebingying.png").size, ("image_buby.png").height = "image_buby.png", "image_buby.png", 200
;("image_buby.png").x = 0
_ENV, ("chebingying.png").offset, ("image_buby.png").y = "image_buby.png", "image_buby.png", 52
;("image_buby.png").x = 0.5
;("chebingying.png").anchor, ("image_buby.png").y = "image_buby.png", 0.5
;("chebingying.png").color = colorBuildBtn
;("chebingying.png").opacity = opacityBuildBtn
_ENV, ("chebingying.png").alone = "image_buby.png", true
;("image_buby.png").nodeType = "sprite"
;("image_buby.png").nodeName = "imgUpgrade"
;("image_buby.png").nodeImg = imgUpgrade
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("image_buby.png").offset = getImgUpgradePos("shibing1_%02d.png")
;("image_buby.png").scale = scaleImgUpgrade
;("image_buby.png").alone = true
_ENV, ("image_buby.png").zOrder = getImgUpgradePos("shibing1_%02d.png"), 5
getImgUpgradePos("shibing1_%02d.png").nodeType = "sprite"
getImgUpgradePos("shibing1_%02d.png").nodeName = "buildLvBg"
_ENV, getImgUpgradePos("shibing1_%02d.png").nodeImg = "shibing1_%02d.png", imgLvBg
;("shibing1_%02d.png").x = dLvBgPos.x
getImgUpgradePos("shibing1_%02d.png").offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", dLvBgPos.y
getImgUpgradePos("shibing1_%02d.png").scale = scaleLvBg
getImgUpgradePos("shibing1_%02d.png").alone = true
_ENV, getImgUpgradePos("shibing1_%02d.png").zOrder = "shibing1_%02d.png", 4
;("shibing1_%02d.png").nodeType = "text"
_ENV, ("shibing1_%02d.png").nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;("shibing1_%02d.png").anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("shibing1_%02d.png").offset = getTextLvPos("shibing1_%02d.png")
;("shibing1_%02d.png").skewY = 25
;("shibing1_%02d.png").color = colorTextLv
;("shibing1_%02d.png").default = "0"
;("shibing1_%02d.png").fontSize = 18
;("shibing1_%02d.png").hAlign = cc.TEXT_ALIGNMENT_CENTER
;("shibing1_%02d.png").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, ("shibing1_%02d.png").zOrder = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 6
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "shibing1_%02d.png", "z.png"
;("shibing1_%02d.png").x = 44
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", 97
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "chebingying.png"
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, "image_buby.png"
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, getImgUpgradePos("shibing1_%02d.png")
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, "shibing1_%02d.png"
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = "et_toushiche.png", "et_toushiche.png"
;("et_toushiche.png").x = -16
;(nil).offset, ("et_toushiche.png").y = "et_toushiche.png", 55
;(nil).actionKey = "Glow"
_ENV, (nil).alone = "et_toushiche.png", true
;("et_toushiche.png").nodeType = "action"
;("et_toushiche.png").nodeName = "buildGlowWar"
_ENV, ("et_toushiche.png").nodeImg = "image_xiangby.png", "image_xiangby.png"
;("image_xiangby.png").x = 5
;("et_toushiche.png").offset, ("image_xiangby.png").y = "image_xiangby.png", 43
;("et_toushiche.png").actionKey = "Glow"
_ENV, ("et_toushiche.png").alone = "image_xiangby.png", true
;("image_xiangby.png").nodeType = "sprite"
;("image_xiangby.png").nodeName = "iconMiracle"
_ENV, ("image_xiangby.png").nodeImg = "armyicon_s_10004711.png", "armyicon_s_10004711.png"
;("armyicon_s_10004711.png").x = 80
;("image_xiangby.png").offset, ("armyicon_s_10004711.png").y = "armyicon_s_10004711.png", 18
;("image_xiangby.png").zOrder = 3
;("image_xiangby.png").scale = 1.0
;("image_xiangby.png").alone = true
cityBuildViewDef.tblBarracks, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblBarracks, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "et_toushiche.png"
cityBuildViewDef.tblBarracks, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "image_xiangby.png"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "zhanzhengbaolei.png", "zhanzhengbaolei.png"
;("zhanzhengbaolei.png").x = -8
;(nil).offset, ("zhanzhengbaolei.png").y = "zhanzhengbaolei.png", 43
_ENV, (nil).alone = "zhanzhengbaolei.png", true
;("zhanzhengbaolei.png").nodeType = "layout"
_ENV, ("zhanzhengbaolei.png").nodeName = "image_xiangby.png", "buildBtn"
;("image_xiangby.png").width = 200
_ENV, ("zhanzhengbaolei.png").size, ("image_xiangby.png").height = "image_xiangby.png", "image_xiangby.png", 170
;("image_xiangby.png").x = 0
_ENV, ("zhanzhengbaolei.png").offset, ("image_xiangby.png").y = "image_xiangby.png", "image_xiangby.png", 46
;("image_xiangby.png").x = 0.5
;("zhanzhengbaolei.png").anchor, ("image_xiangby.png").y = "image_xiangby.png", 0.5
;("zhanzhengbaolei.png").color = colorBuildBtn
_ENV, ("zhanzhengbaolei.png").opacity = "image_xiangby.png", opacityBuildBtn
;("image_xiangby.png").nodeType = "sprite"
;("image_xiangby.png").nodeName = "imgUpgrade"
;("image_xiangby.png").nodeImg = imgUpgrade
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("image_xiangby.png").offset = getImgUpgradePos("shibing1_%02d.png")
;("image_xiangby.png").scale = scaleImgUpgrade
_ENV, ("image_xiangby.png").alone = getImgUpgradePos("shibing1_%02d.png"), true
getImgUpgradePos("shibing1_%02d.png").nodeType = "sprite"
getImgUpgradePos("shibing1_%02d.png").nodeName = "buildLvBg"
_ENV, getImgUpgradePos("shibing1_%02d.png").nodeImg = "shibing1_%02d.png", imgLvBg
;("shibing1_%02d.png").x = dLvBgPos.x
getImgUpgradePos("shibing1_%02d.png").offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", dLvBgPos.y
getImgUpgradePos("shibing1_%02d.png").scale = scaleLvBg
_ENV, getImgUpgradePos("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "text"
_ENV, ("shibing1_%02d.png").nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;("shibing1_%02d.png").anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("shibing1_%02d.png").offset = getTextLvPos("shibing1_%02d.png")
;("shibing1_%02d.png").skewY = 25
;("shibing1_%02d.png").color = colorTextLv
;("shibing1_%02d.png").default = "0"
;("shibing1_%02d.png").fontSize = 18
;("shibing1_%02d.png").hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, ("shibing1_%02d.png").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "sprite"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "shibing1_%02d.png", "z.png"
;("shibing1_%02d.png").x = 20
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", 116
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "zhanzhengbaolei.png"
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, "image_xiangby.png"
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, getImgUpgradePos("shibing1_%02d.png")
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, "shibing1_%02d.png"
_ENV, _UPVALUE1_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = "et_zhanzhengbaolei.png", "et_zhanzhengbaolei.png"
;("et_zhanzhengbaolei.png").x = -14
;(nil).offset, ("et_zhanzhengbaolei.png").y = "et_zhanzhengbaolei.png", 17
;(nil).actionKey = "Glow"
;(nil).alone = true
cityBuildViewDef.tblFortress, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
_ENV, _UPVALUE5_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "jiaochang.png", "jiaochang.png"
;("jiaochang.png").x = -4
;(nil).offset, ("jiaochang.png").y = "jiaochang.png", 38
_ENV, (nil).alone = "jiaochang.png", true
;("jiaochang.png").nodeType = "layout"
_ENV, ("jiaochang.png").nodeName = -4, "buildBtn"
;(-4).width = 200
_ENV, ("jiaochang.png").size, (-4).height = -4, -4, 170
;(-4).x = 2
_ENV, ("jiaochang.png").offset, (-4).y = -4, -4, 47
;(-4).x = 0.5
;("jiaochang.png").anchor, (-4).y = -4, 0.5
;("jiaochang.png").color = colorBuildBtn
_ENV, ("jiaochang.png").opacity = -4, opacityBuildBtn
;(-4).nodeType = "sprite"
;(-4).nodeName = "imgUpgrade"
;(-4).nodeImg = imgUpgrade
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;(-4).offset = getImgUpgradePos("shibing1_%02d.png")
;(-4).scale = scaleImgUpgrade
_ENV, (-4).alone = getImgUpgradePos("shibing1_%02d.png"), true
getImgUpgradePos("shibing1_%02d.png").nodeType = "sprite"
getImgUpgradePos("shibing1_%02d.png").nodeName = "buildLvBg"
_ENV, getImgUpgradePos("shibing1_%02d.png").nodeImg = "shibing1_%02d.png", imgLvBg
;("shibing1_%02d.png").x = dLvBgPos.x
getImgUpgradePos("shibing1_%02d.png").offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", dLvBgPos.y
getImgUpgradePos("shibing1_%02d.png").scale = scaleLvBg
_ENV, getImgUpgradePos("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "text"
_ENV, ("shibing1_%02d.png").nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;("shibing1_%02d.png").anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("shibing1_%02d.png").offset = getTextLvPos("shibing1_%02d.png")
;("shibing1_%02d.png").skewY = 25
;("shibing1_%02d.png").color = colorTextLv
;("shibing1_%02d.png").default = "0"
;("shibing1_%02d.png").fontSize = 18
;("shibing1_%02d.png").hAlign = cc.TEXT_ALIGNMENT_CENTER
;("shibing1_%02d.png").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblDrillGrounds, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblDrillGrounds, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "jiaochang.png"
cityBuildViewDef.tblDrillGrounds, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, -4
cityBuildViewDef.tblDrillGrounds, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos("shibing1_%02d.png")
cityBuildViewDef.tblDrillGrounds, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "shibing1_%02d.png"
_ENV, _UPVALUE5_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "zhanzhengdating.png", "zhanzhengdating.png"
;("zhanzhengdating.png").x = -8
;(nil).offset, ("zhanzhengdating.png").y = "zhanzhengdating.png", 35
_ENV, (nil).alone = "zhanzhengdating.png", true
;("zhanzhengdating.png").nodeType = "layout"
_ENV, ("zhanzhengdating.png").nodeName = -4, "buildBtn"
;(-4).width = 200
_ENV, ("zhanzhengdating.png").size, (-4).height = -4, -4, 180
;(-4).x = 3
_ENV, ("zhanzhengdating.png").offset, (-4).y = -4, -4, 45
;(-4).x = 0.5
;("zhanzhengdating.png").anchor, (-4).y = -4, 0.5
;("zhanzhengdating.png").color = colorBuildBtn
_ENV, ("zhanzhengdating.png").opacity = -4, opacityBuildBtn
;(-4).nodeType = "sprite"
;(-4).nodeName = "imgUpgrade"
;(-4).nodeImg = imgUpgrade
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;(-4).offset = getImgUpgradePos("shibing1_%02d.png")
;(-4).scale = scaleImgUpgrade
_ENV, (-4).alone = getImgUpgradePos("shibing1_%02d.png"), true
getImgUpgradePos("shibing1_%02d.png").nodeType = "sprite"
getImgUpgradePos("shibing1_%02d.png").nodeName = "buildLvBg"
_ENV, getImgUpgradePos("shibing1_%02d.png").nodeImg = "shibing1_%02d.png", imgLvBg
;("shibing1_%02d.png").x = dLvBgPos.x
getImgUpgradePos("shibing1_%02d.png").offset, ("shibing1_%02d.png").y = "shibing1_%02d.png", dLvBgPos.y
getImgUpgradePos("shibing1_%02d.png").scale = scaleLvBg
_ENV, getImgUpgradePos("shibing1_%02d.png").alone = "shibing1_%02d.png", true
;("shibing1_%02d.png").nodeType = "text"
_ENV, ("shibing1_%02d.png").nodeName = dLvBgPos.y, "textLv"
dLvBgPos.y.x = 0.5
;("shibing1_%02d.png").anchor, dLvBgPos.y.y = dLvBgPos.y, 0.5
_ENV = "shibing1_%02d.png"
;("shibing1_%02d.png").x = dLvBgPos.x
;("shibing1_%02d.png").y = dLvBgPos.y
;("shibing1_%02d.png").offset = getTextLvPos("shibing1_%02d.png")
;("shibing1_%02d.png").skewY = 25
;("shibing1_%02d.png").color = colorTextLv
;("shibing1_%02d.png").default = "0"
;("shibing1_%02d.png").fontSize = 18
;("shibing1_%02d.png").hAlign = cc.TEXT_ALIGNMENT_CENTER
;("shibing1_%02d.png").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblHallOfWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblHallOfWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "zhanzhengdating.png"
cityBuildViewDef.tblHallOfWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, -4
cityBuildViewDef.tblHallOfWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos("shibing1_%02d.png")
cityBuildViewDef.tblHallOfWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "shibing1_%02d.png"
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "BG_SPR.png", "BG_SPR.png"
;("BG_SPR.png").x = 0.5
;(nil).offset, ("BG_SPR.png").y = "BG_SPR.png", 14
_ENV, (nil).alone = "BG_SPR.png", true
;("BG_SPR.png").nodeType = "layout"
_ENV, ("BG_SPR.png").nodeName = -4, "buildBtn"
;(-4).width = 220
_ENV, ("BG_SPR.png").size, (-4).height = -4, -4, 200
;(-4).x = 64
_ENV, ("BG_SPR.png").offset, (-4).y = -4, -4, 130
;(-4).x = 0.5
;("BG_SPR.png").anchor, (-4).y = -4, 0.5
;("BG_SPR.png").color = colorBuildBtn
;("BG_SPR.png").opacity = opacityBuildBtn
_ENV, _UPVALUE5_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE5_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "BG_SPR.png"
;(nil).nodeType = "action"
;(nil).nodeName = "buildGlow"
_ENV, (nil).nodeImg = "image_pyramid_building.png", "image_pyramid_building.png"
;("image_pyramid_building.png").x = -10
;(nil).offset, ("image_pyramid_building.png").y = "image_pyramid_building.png", 0
;(nil).actionKey = "Glow"
_ENV, (nil).alone = "image_pyramid_building.png", true
;("image_pyramid_building.png").nodeType = "particle"
_ENV, ("image_pyramid_building.png").nodeName = -10, "buildParticleBright_1"
;(-10).x = 44
;("image_pyramid_building.png").offset, (-10).y = -10, 80
;("image_pyramid_building.png").scale = 1
;("image_pyramid_building.png").rotation = -11.22
;("image_pyramid_building.png").positionType = "relative"
_ENV, ("image_pyramid_building.png").particleFile = "Particle/et_pyramid_building_01.plist", "Particle/et_pyramid_building_01.plist"
;("Particle/et_pyramid_building_01.plist").nodeType = "particle"
_ENV, ("Particle/et_pyramid_building_01.plist").nodeName = 44, "buildParticleBright_2"
;(44).x = 44.7
;("Particle/et_pyramid_building_01.plist").offset, (44).y = 44, 57
;("Particle/et_pyramid_building_01.plist").scaleX = 1.37
;("Particle/et_pyramid_building_01.plist").scaleY = 1.533
;("Particle/et_pyramid_building_01.plist").positionType = "relative"
_ENV, ("Particle/et_pyramid_building_01.plist").particleFile = "Particle/et_pyramid_building_02.plist", "Particle/et_pyramid_building_02.plist"
;("Particle/et_pyramid_building_02.plist").nodeType = "particle"
_ENV, ("Particle/et_pyramid_building_02.plist").nodeName = 44.7, "buildParticleBright_3"
;(44.7).x = -13.3
;("Particle/et_pyramid_building_02.plist").offset, (44.7).y = 44.7, -135
;("Particle/et_pyramid_building_02.plist").scaleX = 1.723
;("Particle/et_pyramid_building_02.plist").scaleY = 1.532
;("Particle/et_pyramid_building_02.plist").rotation = -118.93
;("Particle/et_pyramid_building_02.plist").positionType = "relative"
_ENV, ("Particle/et_pyramid_building_02.plist").particleFile = "Particle/et_pyramid_building_03.plist", "Particle/et_pyramid_building_03.plist"
;("Particle/et_pyramid_building_03.plist").nodeType = "particle"
_ENV, ("Particle/et_pyramid_building_03.plist").nodeName = -135, "buildParticleBright_4"
;(-135).x = 122.7
;("Particle/et_pyramid_building_03.plist").offset, (-135).y = -135, 50
;("Particle/et_pyramid_building_03.plist").scaleX = 2.515
;("Particle/et_pyramid_building_03.plist").scaleY = 3.708
;("Particle/et_pyramid_building_03.plist").positionType = "relative"
;("Particle/et_pyramid_building_03.plist").particleFile = "Particle/et_pyramid_building_03.plist"
cityBuildViewDef.tblLeisureCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblLeisureCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "image_pyramid_building.png"
cityBuildViewDef.tblLeisureCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_pyramid_building_01.plist"
cityBuildViewDef.tblLeisureCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_pyramid_building_02.plist"
cityBuildViewDef.tblLeisureCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_pyramid_building_03.plist"
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "huochuan.png", "huochuan.png"
;("huochuan.png").x = 7
;(nil).offset, ("huochuan.png").y = "huochuan.png", 17
_ENV, (nil).alone = "huochuan.png", true
;("huochuan.png").nodeType = "layout"
_ENV, ("huochuan.png").nodeName = 17, "buildBtn"
;(17).width = 220
_ENV, ("huochuan.png").size, (17).height = 17, 17, 160
;(17).x = 0
_ENV, ("huochuan.png").offset, (17).y = 17, 17, 0
;(17).x = 0.5
;("huochuan.png").anchor, (17).y = 17, 0.5
;("huochuan.png").color = colorBuildBtn
;("huochuan.png").opacity = opacityBuildBtn
cityBuildViewDef.tblHuoChuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblHuoChuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "huochuan.png"
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "gonggaolan.png", "gonggaolan.png"
;("gonggaolan.png").x = 1.5
;(nil).offset, ("gonggaolan.png").y = "gonggaolan.png", 10
_ENV, (nil).alone = "gonggaolan.png", true
;("gonggaolan.png").nodeType = "layout"
_ENV, ("gonggaolan.png").nodeName = 1.5, "buildBtn"
;(1.5).width = 260
_ENV, ("gonggaolan.png").size, (1.5).height = 1.5, 1.5, 160
;(1.5).x = 0
_ENV, ("gonggaolan.png").offset, (1.5).y = 1.5, 1.5, 0
;(1.5).x = 0.5
;("gonggaolan.png").anchor, (1.5).y = 1.5, 0.5
;("gonggaolan.png").color = colorBuildBtn
;("gonggaolan.png").opacity = opacityBuildBtn
cityBuildViewDef.tblServiceCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblServiceCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "gonggaolan.png"
_ENV, _UPVALUE3_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "chongwuguan.png", "chongwuguan.png"
;("chongwuguan.png").x = 5
;(nil).offset, ("chongwuguan.png").y = "chongwuguan.png", 27
;(nil).alone = true
_ENV, (nil).zOrder = "chongwuguan.png", 2
;("chongwuguan.png").nodeType = "sprite"
;("chongwuguan.png").nodeName = "buildImg"
_ENV, ("chongwuguan.png").nodeImg = "frame_chongwuguan_shadow.png", "frame_chongwuguan_shadow.png"
;("frame_chongwuguan_shadow.png").x = -25
;("chongwuguan.png").offset, ("frame_chongwuguan_shadow.png").y = "frame_chongwuguan_shadow.png", 25
;("chongwuguan.png").alone = true
_ENV, ("chongwuguan.png").zOrder = "frame_chongwuguan_shadow.png", 1
;("frame_chongwuguan_shadow.png").nodeType = "layout"
_ENV, ("frame_chongwuguan_shadow.png").nodeName = -25, "buildBtn"
;(-25).width = 93
_ENV, ("frame_chongwuguan_shadow.png").size, (-25).height = -25, -25, 160
;(-25).x = 35
_ENV, ("frame_chongwuguan_shadow.png").offset, (-25).y = -25, -25, 60
;(-25).x = 0.5
;("frame_chongwuguan_shadow.png").anchor, (-25).y = -25, 0.5
;("frame_chongwuguan_shadow.png").color = colorBuildBtn
;("frame_chongwuguan_shadow.png").opacity = opacityBuildBtn
cityBuildViewDef.tblPetCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblPetCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "chongwuguan.png"
cityBuildViewDef.tblPetCenter, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "frame_chongwuguan_shadow.png"
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "fuhuoquanshui.png", "fuhuoquanshui.png"
;("fuhuoquanshui.png").x = 4
;(nil).offset, ("fuhuoquanshui.png").y = "fuhuoquanshui.png", 73
_ENV, (nil).alone = "fuhuoquanshui.png", true
;("fuhuoquanshui.png").nodeType = "layout"
_ENV, ("fuhuoquanshui.png").nodeName = 73, "buildBtn"
;(73).width = 160
_ENV, ("fuhuoquanshui.png").size, (73).height = 73, 73, 160
;(73).x = 0
_ENV, ("fuhuoquanshui.png").offset, (73).y = 73, 73, 80
;(73).x = 0.5
;("fuhuoquanshui.png").anchor, (73).y = 73, 0.5
;("fuhuoquanshui.png").color = colorBuildBtn
;("fuhuoquanshui.png").opacity = opacityBuildBtn
cityBuildViewDef.tblResurrectionHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblResurrectionHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "fuhuoquanshui.png"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "nt_base.png", "nt_base.png"
;("nt_base.png").x = 0
;(nil).offset, ("nt_base.png").y = "nt_base.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_lvmiao"
_ENV, ("batchKey").nodeImg = "nt_lvmiao_01.png", "nt_lvmiao_01.png"
;("nt_lvmiao_01.png").x = 0
;("batchKey").offset, ("nt_lvmiao_01.png").y = "nt_lvmiao_01.png", 0
;("batchKey").zOrder = 1
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = "Particle/et_pyramid_building_03.plist"
;("Particle/et_pyramid_building_03.plist").x = 64
;("Particle/et_pyramid_building_03.plist").y = -6
;("batchKey").offset = getImgUpgradePos("Particle/et_pyramid_building_03.plist")
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = "Particle/et_pyramid_building_03.plist", imgLvBg
;("Particle/et_pyramid_building_03.plist").x = 64
;(7).offset, ("Particle/et_pyramid_building_03.plist").y = "Particle/et_pyramid_building_03.plist", -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = "Particle/et_pyramid_building_03.plist", true
;("Particle/et_pyramid_building_03.plist").nodeType = "text"
_ENV, ("Particle/et_pyramid_building_03.plist").nodeName = "Particle/et_pyramid_building_03.plist", "textLv"
;("Particle/et_pyramid_building_03.plist").x = 0.5
;("Particle/et_pyramid_building_03.plist").anchor, ("Particle/et_pyramid_building_03.plist").y = "Particle/et_pyramid_building_03.plist", 0.5
_ENV = 122.7
;(122.7).x = 64
;(122.7).y = -6
;("Particle/et_pyramid_building_03.plist").offset = getTextLvPos(122.7)
;("Particle/et_pyramid_building_03.plist").zOrder = 8
;("Particle/et_pyramid_building_03.plist").skewY = 25
;("Particle/et_pyramid_building_03.plist").color = colorTextLv
;("Particle/et_pyramid_building_03.plist").default = "0"
;("Particle/et_pyramid_building_03.plist").fontSize = 18
;("Particle/et_pyramid_building_03.plist").hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, ("Particle/et_pyramid_building_03.plist").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "animation"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildAnimationNormalType1_1"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.isFlipX = "buildAnimationNormalType1_1", false
;("buildAnimationNormalType1_1").x = 40
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("buildAnimationNormalType1_1").y = "buildAnimationNormalType1_1", 24
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.zOrder = 5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeFormat = "nongmin_%02d.png"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeStart = 1
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeEnd = 8
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, 7
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, "Particle/et_pyramid_building_03.plist"
_ENV, _UPVALUE8_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "sprite"
;(nil).nodeName = "nt_lvmiao"
_ENV, (nil).nodeImg = "nt_lvmiao_01.png", "nt_lvmiao_01.png"
;("nt_lvmiao_01.png").x = 0
;(nil).offset, ("nt_lvmiao_01.png").y = "nt_lvmiao_01.png", 0
;(nil).zOrder = 1
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_maizi_01"
_ENV, ("batchKey").nodeImg = "nt_maizi_01.png", "nt_maizi_01.png"
;("nt_maizi_01.png").x = 0
;("batchKey").offset, ("nt_maizi_01.png").y = "nt_maizi_01.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_maizi_02"
_ENV, ("batchKey").nodeImg = "nt_maizi_02.png", "nt_maizi_02.png"
;("nt_maizi_02.png").x = 0
;("batchKey").offset, ("nt_maizi_02.png").y = "nt_maizi_02.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_shuiqu"
_ENV, ("batchKey").nodeImg = "nt_shuiqu.png", "nt_shuiqu.png"
;("nt_shuiqu.png").x = 0
;("batchKey").offset, ("nt_shuiqu.png").y = "nt_shuiqu.png", 0
;("batchKey").zOrder = 3
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_decorate_02"
_ENV, ("batchKey").nodeImg = "nt_decorate_02.png", "nt_decorate_02.png"
;("nt_decorate_02.png").x = 0
;("batchKey").offset, ("nt_decorate_02.png").y = "nt_decorate_02.png", 0
;("batchKey").zOrder = 4
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_decorate_03"
_ENV, ("batchKey").nodeImg = "nt_decorate_03.png", "nt_decorate_03.png"
;("nt_decorate_03.png").x = 0
;("batchKey").offset, ("nt_decorate_03.png").y = "nt_decorate_03.png", 0
;("batchKey").zOrder = 4
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_decorate_04"
_ENV, ("batchKey").nodeImg = "nt_decorate_04.png", "nt_decorate_04.png"
;("nt_decorate_04.png").x = 0
;("batchKey").offset, ("nt_decorate_04.png").y = "nt_decorate_04.png", 0
;("batchKey").zOrder = 4
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "nt_decorate_05"
_ENV, ("batchKey").nodeImg = "nt_decorate_05.png", "nt_decorate_05.png"
;("nt_decorate_05.png").x = 0
;("batchKey").offset, ("nt_decorate_05.png").y = "nt_decorate_05.png", 0
;("batchKey").zOrder = 4
;("batchKey").batchKey = "mainCityOuter"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[7] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[8] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "fmc_base.png", "fmc_base.png"
;("fmc_base.png").x = 0
;(nil).offset, ("fmc_base.png").y = "fmc_base.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_tree_01"
_ENV, ("batchKey").nodeImg = "fmc_tree_01.png", "fmc_tree_01.png"
;("fmc_tree_01.png").x = 0
;("batchKey").offset, ("fmc_tree_01.png").y = "fmc_tree_01.png", 0
;("batchKey").zOrder = 1
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = "batchKey"
;("batchKey").x = 64
;("batchKey").y = -6
;("batchKey").offset = getImgUpgradePos("batchKey")
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = "batchKey", imgLvBg
;("batchKey").x = 64
;(7).offset, ("batchKey").y = "batchKey", -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = "batchKey", true
;("batchKey").nodeType = "text"
_ENV, ("batchKey").nodeName = "batchKey", "textLv"
;("batchKey").x = 0.5
;("batchKey").anchor, ("batchKey").y = "batchKey", 0.5
_ENV = "batchKey"
;("batchKey").x = 64
;("batchKey").y = -6
;("batchKey").offset = getTextLvPos("batchKey")
;("batchKey").zOrder = 8
;("batchKey").skewY = 25
;("batchKey").color = colorTextLv
;("batchKey").default = "0"
;("batchKey").fontSize = 18
;("batchKey").hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, ("batchKey").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "animation"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildAnimationNormalType1_1"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.isFlipX = "buildAnimationNormalType1_1", false
;("buildAnimationNormalType1_1").x = 30
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("buildAnimationNormalType1_1").y = "buildAnimationNormalType1_1", 10
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.zOrder = 3
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeFormat = "fuma_%02d.png"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeStart = 1
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeEnd = 8
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, 7
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE7_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
;(nil).nodeType = "sprite"
;(nil).nodeName = "fmc_tree_01"
_ENV, (nil).nodeImg = "fmc_tree_01.png", "fmc_tree_01.png"
;("fmc_tree_01.png").x = 0
;(nil).offset, ("fmc_tree_01.png").y = "fmc_tree_01.png", 0
;(nil).zOrder = 1
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_tree_02"
_ENV, ("batchKey").nodeImg = "fmc_tree_02.png", "fmc_tree_02.png"
;("fmc_tree_02.png").x = 0
;("batchKey").offset, ("fmc_tree_02.png").y = "fmc_tree_02.png", 0
;("batchKey").zOrder = 1
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_house_01"
_ENV, ("batchKey").nodeImg = "fmc_house_01.png", "fmc_house_01.png"
;("fmc_house_01.png").x = 0
;("batchKey").offset, ("fmc_house_01.png").y = "fmc_house_01.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_house_02"
_ENV, ("batchKey").nodeImg = "fmc_house_02.png", "fmc_house_02.png"
;("fmc_house_02.png").x = 0
;("batchKey").offset, ("fmc_house_02.png").y = "fmc_house_02.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_house_03"
_ENV, ("batchKey").nodeImg = "fmc_house_03.png", "fmc_house_03.png"
;("fmc_house_03.png").x = 0
;("batchKey").offset, ("fmc_house_03.png").y = "fmc_house_03.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_house_04"
_ENV, ("batchKey").nodeImg = "fmc_house_04.png", "fmc_house_04.png"
;("fmc_house_04.png").x = 0
;("batchKey").offset, ("fmc_house_04.png").y = "fmc_house_04.png", 0
;("batchKey").zOrder = 2
_ENV, ("batchKey").batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "fmc_wood"
_ENV, ("batchKey").nodeImg = "fmc_wood.png", "fmc_wood.png"
;("fmc_wood.png").x = 0
;("batchKey").offset, ("fmc_wood.png").y = "fmc_wood.png", 0
;("batchKey").zOrder = 4
;("batchKey").batchKey = "mainCityOuter"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
cityBuildViewDef.tblSawmill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[7] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "batchKey"
_ENV, _UPVALUE4_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "tiekuangchang.png", "tiekuangchang.png"
;("tiekuangchang.png").x = 0
;(nil).offset, ("tiekuangchang.png").y = "tiekuangchang.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = "batchKey"
;("batchKey").x = 64
;("batchKey").y = -6
;("batchKey").offset = getImgUpgradePos("batchKey")
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = "batchKey", imgLvBg
;("batchKey").x = 64
;(7).offset, ("batchKey").y = "batchKey", -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = "batchKey", true
;("batchKey").nodeType = "text"
_ENV, ("batchKey").nodeName = "batchKey", "textLv"
;("batchKey").x = 0.5
;("batchKey").anchor, ("batchKey").y = "batchKey", 0.5
_ENV = "batchKey"
;("batchKey").x = 64
;("batchKey").y = -6
;("batchKey").offset = getTextLvPos("batchKey")
;("batchKey").zOrder = 8
;("batchKey").skewY = 25
;("batchKey").color = colorTextLv
;("batchKey").default = "0"
;("batchKey").fontSize = 18
;("batchKey").hAlign = cc.TEXT_ALIGNMENT_CENTER
;("batchKey").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblIronMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblIronMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "batchKey"
cityBuildViewDef.tblIronMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
cityBuildViewDef.tblIronMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "batchKey"
_ENV, _UPVALUE5_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "shuijingkuan.png", "shuijingkuan.png"
;("shuijingkuan.png").x = -25
;(nil).offset, ("shuijingkuan.png").y = "shuijingkuan.png", 45
;(nil).zOrder = 0
_ENV, (nil).alone = "shuijingkuan.png", true
;("shuijingkuan.png").nodeType = "layout"
_ENV, ("shuijingkuan.png").nodeName = -25, "buildBtn"
;(-25).width = 110
_ENV, ("shuijingkuan.png").size, (-25).height = -25, -25, 200
;(-25).x = 0
_ENV, ("shuijingkuan.png").offset, (-25).y = -25, -25, 55
;(-25).x = 0.5
;("shuijingkuan.png").anchor, (-25).y = -25, 0.5
;("shuijingkuan.png").color = colorBuildBtn
_ENV, ("shuijingkuan.png").opacity = -25, opacityBuildBtn
;(-25).nodeType = "sprite"
;(-25).nodeName = "imgUpgrade"
;(-25).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 110
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = 6
;(-25).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(-25).zOrder = 7
;(-25).scale = scaleImgUpgrade
_ENV, (-25).alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 110
;(7).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "batchKey", "textLv"
;("batchKey").x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, ("batchKey").y = "batchKey", 0.5
_ENV = "batchKey"
;("batchKey").x = 110
;("batchKey").y = 6
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos("batchKey")
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.zOrder = 8
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblCrystalMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblCrystalMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "shuijingkuan.png"
cityBuildViewDef.tblCrystalMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, -25
cityBuildViewDef.tblCrystalMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
cityBuildViewDef.tblCrystalMine, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE4_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "miyinkuangchang.png", "miyinkuangchang.png"
;("miyinkuangchang.png").x = 0
;(nil).offset, ("miyinkuangchang.png").y = "miyinkuangchang.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = 7
;(7).x = 64
;(7).y = -6
;("batchKey").offset = getImgUpgradePos(7)
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = 7, imgLvBg
;(7).x = 64
;(7).offset, (7).y = 7, -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = 7, true
;(7).nodeType = "text"
_ENV, (7).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(7).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 64
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -6
;(7).offset = getTextLvPos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(7).zOrder = 8
;(7).skewY = 25
;(7).color = colorTextLv
;(7).default = "0"
;(7).fontSize = 18
;(7).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(7).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "batchKey"
cityBuildViewDef.tblSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
cityBuildViewDef.tblSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
_ENV, _UPVALUE4_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "xingjunzhangpeng.png", "xingjunzhangpeng.png"
;("xingjunzhangpeng.png").x = 0
;(nil).offset, ("xingjunzhangpeng.png").y = "xingjunzhangpeng.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = 7
;(7).x = 64
;(7).y = -6
;("batchKey").offset = getImgUpgradePos(7)
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = 7, imgLvBg
;(7).x = 64
;(7).offset, (7).y = 7, -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = 7, true
;(7).nodeType = "text"
_ENV, (7).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(7).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 64
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -6
;(7).offset = getTextLvPos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(7).zOrder = 8
;(7).skewY = 25
;(7).color = colorTextLv
;(7).default = "0"
;(7).fontSize = 18
;(7).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(7).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblMilitaryTent, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMilitaryTent, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "batchKey"
cityBuildViewDef.tblMilitaryTent, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
cityBuildViewDef.tblMilitaryTent, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
_ENV, _UPVALUE4_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "yiliaozhangpeng.png", "yiliaozhangpeng.png"
;("yiliaozhangpeng.png").x = 0
;(nil).offset, ("yiliaozhangpeng.png").y = "yiliaozhangpeng.png", 0
;(nil).zOrder = 0
_ENV, (nil).batchKey = "batchKey", "mainCityOuter"
;("batchKey").nodeType = "sprite"
;("batchKey").nodeName = "imgUpgrade"
;("batchKey").nodeImg = imgUpgrade
_ENV = 7
;(7).x = 64
;(7).y = -6
;("batchKey").offset = getImgUpgradePos(7)
;("batchKey").zOrder = 7
;("batchKey").scale = scaleImgUpgrade
_ENV, ("batchKey").alone = 7, true
;(7).nodeType = "sprite"
;(7).nodeName = "buildLvBg"
_ENV, (7).nodeImg = 7, imgLvBg
;(7).x = 64
;(7).offset, (7).y = 7, -6
;(7).zOrder = 6
;(7).scale = scaleLvBg
_ENV, (7).alone = 7, true
;(7).nodeType = "text"
_ENV, (7).nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
;(7).anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 64
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -6
;(7).offset = getTextLvPos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(7).zOrder = 8
;(7).skewY = 25
;(7).color = colorTextLv
;(7).default = "0"
;(7).fontSize = 18
;(7).hAlign = cc.TEXT_ALIGNMENT_CENTER
;(7).vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "batchKey"
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = nil, nil, nil, 7
_ENV, _UPVALUE3_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = nil, nil, nil, 7
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = "batchKey", "buildParticleNormal_1"
;("batchKey").x = -4.5
;(nil).offset, ("batchKey").y = "batchKey", 14
;(nil).positionType = "relative"
;(nil).particleFile = "Particle/et_yiyuan_01.plist"
;(nil).scaleX = 1.77
_ENV, (nil).scaleY = 3.36, 3.36
;(3.36).nodeType = "particle"
_ENV, (3.36).nodeName = -4.5, "buildParticleNormal_2"
;(-4.5).x = -7
;(3.36).offset, (-4.5).y = -4.5, 43
;(3.36).positionType = "relative"
;(3.36).particleFile = "Particle/et_yiyuan_02.plist"
;(3.36).scaleX = 0.67
_ENV, (3.36).scaleY = 2.1, 2.1
;(2.1).nodeType = "particle"
_ENV, (2.1).nodeName = 7, "buildParticleNormal_3"
;(7).x = 0
;(2.1).offset, (7).y = 7, 0
;(2.1).positionType = "relative"
;(2.1).particleFile = "Particle/et_yiyuan_03.plist"
;(2.1).scaleX = 2.4
;(2.1).scaleY = 1.22
cityBuildViewDef.tblHosptial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblHosptial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, 3.36
cityBuildViewDef.tblHosptial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, 2.1
_ENV, _UPVALUE5_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "BG_statue.png", "BG_statue.png"
;("BG_statue.png").x = -29
;(nil).offset, ("BG_statue.png").y = "BG_statue.png", 105
_ENV, (nil).alone = "BG_statue.png", true
;("BG_statue.png").nodeType = "layout"
_ENV, ("BG_statue.png").nodeName = 105, "buildBtn"
;(105).width = 200
_ENV, ("BG_statue.png").size, (105).height = 105, 105, 170
;(105).x = 2
_ENV, ("BG_statue.png").offset, (105).y = 105, 105, 47
;(105).x = 0.5
;("BG_statue.png").anchor, (105).y = 105, 0.5
;("BG_statue.png").color = colorBuildBtn
_ENV, ("BG_statue.png").opacity = 105, opacityBuildBtn
;(105).nodeType = "sprite"
;(105).nodeName = "imgUpgrade"
;(105).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 50
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -9
;(105).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(105).scale = scaleImgUpgrade
_ENV, (105).alone = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), true
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeType = "sprite"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 50
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, -9
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).scale = scaleLvBg
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = -9, "textLv"
;(-9).x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, (-9).y = -9, 0.5
_ENV = "batchKey"
;("batchKey").x = 50
;("batchKey").y = -9
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos("batchKey")
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblMiracle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMiracle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "BG_statue.png"
cityBuildViewDef.tblMiracle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 105
cityBuildViewDef.tblMiracle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
cityBuildViewDef.tblMiracle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "jingyingdiantang.png", "jingyingdiantang.png"
;("jingyingdiantang.png").x = 7
;(nil).offset, ("jingyingdiantang.png").y = "jingyingdiantang.png", 38
_ENV, (nil).alone = "jingyingdiantang.png", true
;("jingyingdiantang.png").nodeType = "layout"
_ENV, ("jingyingdiantang.png").nodeName = 7, "buildBtn"
;(7).width = 200
_ENV, ("jingyingdiantang.png").size, (7).height = 7, 7, 170
;(7).x = 2
_ENV, ("jingyingdiantang.png").offset, (7).y = 7, 7, 47
;(7).x = 0.5
;("jingyingdiantang.png").anchor, (7).y = 7, 0.5
;("jingyingdiantang.png").color = colorBuildBtn
_ENV, ("jingyingdiantang.png").opacity = 7, opacityBuildBtn
;(7).nodeType = "sprite"
;(7).nodeName = "imgUpgrade"
;(7).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 135
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -15
;(7).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(7).scale = scaleImgUpgrade
_ENV, (7).alone = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), true
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeType = "sprite"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 135
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, -15
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).scale = scaleLvBg
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = -15, "textLv"
;(-15).x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, (-15).y = -15, 0.5
_ENV = "batchKey"
;("batchKey").x = 135
;("batchKey").y = -15
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos("batchKey")
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "action"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "batchKey", "z.png"
;("batchKey").x = 20
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("batchKey").y = "batchKey", 116
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "jingyingdiantang.png"
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 7
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblElitePalace, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "altar.png", "altar.png"
;("altar.png").x = -15
;(nil).offset, ("altar.png").y = "altar.png", 59
_ENV, (nil).alone = "altar.png", true
;("altar.png").nodeType = "layout"
_ENV, ("altar.png").nodeName = 59, "buildBtn"
;(59).width = 240
_ENV, ("altar.png").size, (59).height = 59, 59, 280
;(59).x = 0
_ENV, ("altar.png").offset, (59).y = 59, 59, 0
;(59).x = 0.5
;("altar.png").anchor, (59).y = 59, 0.5
;("altar.png").color = colorBuildBtn
;("altar.png").opacity = opacityBuildBtn
cityBuildViewDef.tblEpicBattle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblEpicBattle, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "altar.png"
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "train.png", "train.png"
;("train.png").x = 0.5
;(nil).offset, ("train.png").y = "train.png", -12.5
;(nil).scale = 1.085
_ENV, (nil).alone = 1.085, true
;(1.085).nodeType = "layout"
_ENV, (1.085).nodeName = -12.5, "buildBtn"
;(-12.5).width = 270
_ENV, (1.085).size, (-12.5).height = -12.5, -12.5, 270
;(-12.5).x = 0
_ENV, (1.085).offset, (-12.5).y = -12.5, -12.5, 0
;(-12.5).x = 0.5
;(1.085).anchor, (-12.5).y = -12.5, 0.5
;(1.085).color = colorBuildBtn
_ENV, (1.085).opacity = -12.5, opacityBuildBtn
;(-12.5).nodeType = "sprite"
;(-12.5).nodeName = "imgUpgrade"
;(-12.5).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 135
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -90
;(-12.5).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(-12.5).scale = scaleImgUpgrade
_ENV, (-12.5).alone = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), true
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeType = "sprite"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 135
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, -90
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).scale = scaleLvBg
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = -90, "textLv"
;(-90).x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, (-90).y = -90, 0.5
_ENV = "batchKey"
;("batchKey").x = 135
;("batchKey").y = -90
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos("batchKey")
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "action"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "batchKey", "z.png"
;("batchKey").x = 20
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("batchKey").y = "batchKey", 116
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 1.085
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, -12.5
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblTrainHall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE6_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "prison.png", "prison.png"
;("prison.png").x = 3
;(nil).offset, ("prison.png").y = "prison.png", 15.5
_ENV, (nil).alone = "prison.png", true
;("prison.png").nodeType = "layout"
_ENV, ("prison.png").nodeName = 15.5, "buildBtn"
;(15.5).width = 270
_ENV, ("prison.png").size, (15.5).height = 15.5, 15.5, 230
;(15.5).x = 0
_ENV, ("prison.png").offset, (15.5).y = 15.5, 15.5, 0
;(15.5).x = 0.5
;("prison.png").anchor, (15.5).y = 15.5, 0.5
;("prison.png").color = colorBuildBtn
_ENV, ("prison.png").opacity = 15.5, opacityBuildBtn
;(15.5).nodeType = "sprite"
;(15.5).nodeName = "imgUpgrade"
;(15.5).nodeImg = imgUpgrade
_ENV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = -110
;(15.5).offset = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
;(15.5).scale = scaleImgUpgrade
_ENV, (15.5).alone = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), true
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeType = "sprite"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeName = "buildLvBg"
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).nodeImg = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, imgLvBg
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 25
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).offset, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, -110
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).scale = scaleLvBg
_ENV, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "text"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, "textLv"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.y = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0.5
_ENV = "batchKey"
;("batchKey").x = 25
;("batchKey").y = -110
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset = getTextLvPos("batchKey")
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.skewY = 25
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorTextLv
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.default = "0"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.fontSize = 18
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.hAlign = cc.TEXT_ALIGNMENT_CENTER
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "action"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "buildZ"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeImg = "batchKey", "z.png"
;("batchKey").x = 20
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("batchKey").y = "batchKey", 116
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.actionKey = "zAction"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.alone = true
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "prison.png"
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, 15.5
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblPrison, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, _UPVALUE2_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "gongfang.png", "gongfang.png"
;("gongfang.png").x = -2
;(nil).offset, ("gongfang.png").y = "gongfang.png", 38
_ENV, (nil).alone = "gongfang.png", true
;("gongfang.png").nodeType = "layout"
_ENV, ("gongfang.png").nodeName = 15.5, "buildBtn"
;(15.5).width = 210
_ENV, ("gongfang.png").size, (15.5).height = 15.5, 15.5, 160
;(15.5).x = 0
_ENV, ("gongfang.png").offset, (15.5).y = 15.5, 15.5, 37
;(15.5).x = 0.5
;("gongfang.png").anchor, (15.5).y = 15.5, 0.5
;("gongfang.png").color = colorBuildBtn
;("gongfang.png").opacity = opacityBuildBtn
_ENV, _UPVALUE5_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = nil, nil, nil, nil
_ENV, _UPVALUE5_, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = nil, nil, nil, "gongfang.png"
;(nil).nodeType = "particle"
_ENV, (nil).nodeName = "gongfang.png", "buildParticleNormal_1"
;("gongfang.png").x = -5
;(nil).offset, ("gongfang.png").y = "gongfang.png", 0
;(nil).scaleX = 2.7
;(nil).scaleY = 1.34
;(nil).positionType = "relative"
_ENV, (nil).particleFile = "Particle/et_gongfang_working_01.plist", "Particle/et_gongfang_working_01.plist"
;("Particle/et_gongfang_working_01.plist").nodeType = "particle"
_ENV, ("Particle/et_gongfang_working_01.plist").nodeName = -5, "buildParticleNormal_2"
;(-5).x = 5
;("Particle/et_gongfang_working_01.plist").offset, (-5).y = -5, -7
;("Particle/et_gongfang_working_01.plist").scaleX = 2.8
;("Particle/et_gongfang_working_01.plist").scaleY = 2.7
;("Particle/et_gongfang_working_01.plist").positionType = "relative"
_ENV, ("Particle/et_gongfang_working_01.plist").particleFile = "Particle/et_gongfang_working_02.plist", "Particle/et_gongfang_working_02.plist"
;("Particle/et_gongfang_working_02.plist").nodeType = "particle"
_ENV, ("Particle/et_gongfang_working_02.plist").nodeName = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), "buildParticleBright_1"
getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).x = -5
;("Particle/et_gongfang_working_02.plist").offset, getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER).y = getImgUpgradePos(cc.VERTICAL_TEXT_ALIGNMENT_CENTER), 0
;("Particle/et_gongfang_working_02.plist").scaleX = 2.11
;("Particle/et_gongfang_working_02.plist").scaleY = 1.04
;("Particle/et_gongfang_working_02.plist").positionType = "relative"
_ENV, ("Particle/et_gongfang_working_02.plist").particleFile = "Particle/et_gongfang_complete_01.plist", "Particle/et_gongfang_complete_01.plist"
;("Particle/et_gongfang_complete_01.plist").nodeType = "particle"
_ENV, ("Particle/et_gongfang_complete_01.plist").nodeName = -5, "buildParticleBright_2"
;(-5).x = 10
;("Particle/et_gongfang_complete_01.plist").offset, (-5).y = -5, 20
;("Particle/et_gongfang_complete_01.plist").scaleX = 1.76
;("Particle/et_gongfang_complete_01.plist").scaleY = 1.76
;("Particle/et_gongfang_complete_01.plist").positionType = "relative"
_ENV, ("Particle/et_gongfang_complete_01.plist").particleFile = "Particle/et_gongfang_complete_02.plist", "Particle/et_gongfang_complete_02.plist"
;("Particle/et_gongfang_complete_02.plist").nodeType = "particle"
_ENV, ("Particle/et_gongfang_complete_02.plist").nodeName = 20, "buildParticleBright_3"
;(20).x = 0
;("Particle/et_gongfang_complete_02.plist").offset, (20).y = 20, 10
;("Particle/et_gongfang_complete_02.plist").scaleX = 1.99
;("Particle/et_gongfang_complete_02.plist").scaleY = 1.99
;("Particle/et_gongfang_complete_02.plist").positionType = "relative"
;("Particle/et_gongfang_complete_02.plist").particleFile = "Particle/et_gongfang_complete_03.plist"
cityBuildViewDef.tblMaterialWorkShop, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMaterialWorkShop, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_gongfang_working_01.plist"
cityBuildViewDef.tblMaterialWorkShop, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_gongfang_working_02.plist"
cityBuildViewDef.tblMaterialWorkShop, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_gongfang_complete_01.plist"
cityBuildViewDef.tblMaterialWorkShop, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, (nil)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, "Particle/et_gongfang_complete_02.plist"
_ENV, _UPVALUE3_, _ENV = nil, nil, "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;(nil).nodeType = "sprite"
;(nil).nodeName = "buildImg"
_ENV, (nil).nodeImg = "map_build_history.png", "map_build_history.png"
;("map_build_history.png").x = -5
;(nil).offset, ("map_build_history.png").y = "map_build_history.png", 64
;(nil).alone = true
_ENV, (nil).zOrder = "map_build_history.png", 2
;("map_build_history.png").nodeType = "sprite"
;("map_build_history.png").nodeName = "buildImg"
_ENV, ("map_build_history.png").nodeImg = "bg_map_history.png", "bg_map_history.png"
;("bg_map_history.png").x = -45
;("map_build_history.png").offset, ("bg_map_history.png").y = "bg_map_history.png", 12
;("map_build_history.png").alone = true
_ENV, ("map_build_history.png").zOrder = "bg_map_history.png", 1
;("bg_map_history.png").nodeType = "layout"
_ENV, ("bg_map_history.png").nodeName = 12, "buildBtn"
;(12).width = 240
_ENV, ("bg_map_history.png").size, (12).height = 12, 12, 280
;(12).x = 0
_ENV, ("bg_map_history.png").offset, (12).y = 12, 12, 0
;(12).x = 0.5
;("bg_map_history.png").anchor, (12).y = 12, 0.5
;("bg_map_history.png").color = colorBuildBtn
;("bg_map_history.png").opacity = opacityBuildBtn
cityBuildViewDef.tblMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "map_build_history.png"
cityBuildViewDef.tblMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, (nil)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", nil, nil, nil, "bg_map_history.png"
_ENV = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.WALLS)] = cityBuildViewDef.tblBuildWall
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.TURRET)] = cityBuildViewDef.tblBuildTurret
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.WATCH_TOWER)] = cityBuildViewDef.tblBuildWatchTower
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.CASTLE)] = cityBuildViewDef.tblBuildCastle
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.DEPOT)] = cityBuildViewDef.tblBuildDepot
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.EMBASSY)] = cityBuildViewDef.tblBuildEmbassy
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.MARKET)] = cityBuildViewDef.tblBuildMarket
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.COLLEGE)] = cityBuildViewDef.tblBuildCollege
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.WISHING_WELL)] = cityBuildViewDef.tblBuildWishWell
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.BLACK_SMITH)] = cityBuildViewDef.tblBuildBlackSmith
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.STABLES)] = cityBuildViewDef.tblBuildStables
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.RANGE)] = cityBuildViewDef.tblBuildRange
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.CHARIOT_PLANT)] = cityBuildViewDef.tblChariotPlant
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.BARRACKS)] = cityBuildViewDef.tblBarracks
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.FORTRESS)] = cityBuildViewDef.tblFortress
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.DRILL_GROUDS)] = cityBuildViewDef.tblDrillGrounds
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.HALL_OF_WAR)] = cityBuildViewDef.tblHallOfWar
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.FARM)] = cityBuildViewDef.tblFarm
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.SAWMILL)] = cityBuildViewDef.tblSawmill
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.IRON_MINE)] = cityBuildViewDef.tblIronMine
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.CRYSTAL_MINE)] = cityBuildViewDef.tblCrystalMine
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.STEEL)] = cityBuildViewDef.tblSteel
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.MILITARY_TENT)] = cityBuildViewDef.tblMilitaryTent
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.HOSTPITAL)] = cityBuildViewDef.tblHosptial
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.MATERIAL_WORKSHOP)] = cityBuildViewDef.tblMaterialWorkShop
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.LeisureCenter)] = cityBuildViewDef.tblLeisureCenter
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.MIRACLE)] = cityBuildViewDef.tblMiracle
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.HuoChuang)] = cityBuildViewDef.tblHuoChuang
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.ServiceCenter)] = cityBuildViewDef.tblServiceCenter
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.PetCenter)] = cityBuildViewDef.tblPetCenter
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.ELITE_PALACE)] = cityBuildViewDef.tblElitePalace
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.ResurrectionHall)] = cityBuildViewDef.tblResurrectionHall
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.fixedBuildDef.EpicBattle)] = cityBuildViewDef.tblEpicBattle
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.HERO_TRAIN_GROUND)] = cityBuildViewDef.tblTrainHall
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.HERO_PRISON)] = cityBuildViewDef.tblPrison
cityBuildViewDef.tblBuildViewCfg, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(BUILDID.MONUMENT)] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cityBuildViewDef.tblMonument
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg3
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "text"
;("topTipEffect").nodeName = "textTip"
_ENV, ("topTipEffect").zOrder = "textTip", 2
;("textTip").x = 0.5
_ENV, ("topTipEffect").anchor, ("textTip").y = "textTip", "textTip", 0.5
;("textTip").x = 0
;("topTipEffect").offset, ("textTip").y = "textTip", 47
;("topTipEffect").color = colorTextLv
;("topTipEffect").default = "0"
;("topTipEffect").fontSize = 24
;("topTipEffect").hAlign = cc.TEXT_ALIGNMENT_CENTER
;("topTipEffect").vAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
_ENV, ("topTipEffect").alone = cc.VERTICAL_TEXT_ALIGNMENT_CENTER, true
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeType = "layout"
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.nodeName = "btn"
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.zOrder = "btn", 3
;("btn").width = 128
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.size, ("btn").height = "btn", "btn", 133
;("btn").x = 0
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.offset, ("btn").y = "btn", "btn", 60
;("btn").x = 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.anchor, ("btn").y = "btn", 0.5
cc.VERTICAL_TEXT_ALIGNMENT_CENTER.color = colorBuildBtn
_ENV, cc.VERTICAL_TEXT_ALIGNMENT_CENTER.opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeFree, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeFree, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeFree, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cc.VERTICAL_TEXT_ALIGNMENT_CENTER
cityBuildViewDef.tblTopTypeFree, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg3
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_building_help.png"
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 2
;("topTipEffect").offset, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").scale = 0.8, 0.8
;(0.8).x = 0.5
;("topTipEffect").anchor, (0.8).y = 0.8, 0
_ENV, ("topTipEffect").alone = 0.8, true
;(0.8).nodeType = "layout"
;(0.8).nodeName = "btn"
_ENV, (0.8).zOrder = "btn", 3
;("btn").width = 128
_ENV, (0.8).size, ("btn").height = "btn", "btn", 133
;("btn").x = 0
_ENV, (0.8).offset, ("btn").y = "btn", "btn", 60
;("btn").x = 0.5
;(0.8).anchor, ("btn").y = "btn", 0.5
;(0.8).color = colorBuildBtn
_ENV, (0.8).opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeHelpAll, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeHelpAll, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHelpAll, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), 0.8
cityBuildViewDef.tblTopTypeHelpAll, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg3
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_building_askforhelp.png", "icon_building_askforhelp.png"
;("icon_building_askforhelp.png").x = 2
;("topTipEffect").offset, ("icon_building_askforhelp.png").y = "icon_building_askforhelp.png", -10
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
_ENV, ("topTipEffect").zOrder = "btn", 3
;("btn").width = 128
_ENV, ("topTipEffect").size, ("btn").height = "btn", "btn", 133
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", 60
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 0.5
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeReqHelp, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeReqHelp, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeReqHelp, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeReqHelp, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_building_training_finish.png", "icon_building_training_finish.png"
;("icon_building_training_finish.png").x = 2
;("topTipEffect").offset, ("icon_building_training_finish.png").y = "icon_building_training_finish.png", 2
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
_ENV, ("topTipEffect").zOrder = "btn", 3
;("btn").width = 128
_ENV, ("topTipEffect").size, ("btn").height = "btn", "btn", 133
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", 68
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 0.5
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeTrainFinish, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeTrainFinish, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainFinish, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainFinish, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_building_trap_finish.png", "icon_building_trap_finish.png"
;("icon_building_trap_finish.png").x = 6
;("topTipEffect").offset, ("icon_building_trap_finish.png").y = "icon_building_trap_finish.png", -2
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
_ENV, ("topTipEffect").zOrder = "btn", 3
;("btn").width = 128
_ENV, ("topTipEffect").size, ("btn").height = "btn", "btn", 133
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", 65
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 0.5
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeTrainTrap, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeTrainTrap, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainTrap, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainTrap, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg2
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_middle_food.png"
_ENV, ("topTipEffect").scale = "icon_middle_food.png", 1
;("icon_middle_food.png").x = 0
;("topTipEffect").offset, ("icon_middle_food.png").y = "icon_middle_food.png", 15
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopCollect
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopCollect.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectFood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectFood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectFood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectFood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg2
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_middle_wood.png"
_ENV, ("topTipEffect").scale = "icon_middle_wood.png", 1
;("icon_middle_wood.png").x = 2
;("topTipEffect").offset, ("icon_middle_wood.png").y = "icon_middle_wood.png", 20
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopCollect
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopCollect.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectWood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectWood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectWood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectWood, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg2
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_middle_iron.png"
_ENV, ("topTipEffect").scale = "icon_middle_iron.png", 1
;("icon_middle_iron.png").x = 2
;("topTipEffect").offset, ("icon_middle_iron.png").y = "icon_middle_iron.png", 15
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopCollect
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopCollect.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectIron, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectIron, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectIron, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectIron, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg2
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_middle_crystal.png"
_ENV, ("topTipEffect").scale = "icon_middle_crystal.png", 1
;("icon_middle_crystal.png").x = 2
;("topTipEffect").offset, ("icon_middle_crystal.png").y = "icon_middle_crystal.png", 15
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopCollect
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopCollect.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectCrystal, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectCrystal, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectCrystal, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectCrystal, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg2
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
;("topTipEffect").nodeImg = "icon_middle_silver.png"
_ENV, ("topTipEffect").scale = "icon_middle_silver.png", 1
;("icon_middle_silver.png").x = -2
;("topTipEffect").offset, ("icon_middle_silver.png").y = "icon_middle_silver.png", 15
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopCollect
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopCollect.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectSteel, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_goods_box.png", "icon_goods_box.png"
;("icon_goods_box.png").x = 0
;("topTipEffect").offset, ("icon_goods_box.png").y = "icon_goods_box.png", 10
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCollectGangkou, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCollectGangkou, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectGangkou, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCollectGangkou, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "btn_community.png", "btn_community.png"
;("btn_community.png").x = -2
;("topTipEffect").offset, ("btn_community.png").y = "btn_community.png", 10
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCommunityBBS, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCommunityBBS, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCommunityBBS, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCommunityBBS, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "btn_customer_service.png", "btn_customer_service.png"
;("btn_customer_service.png").x = -2
;("topTipEffect").offset, ("btn_customer_service.png").y = "btn_customer_service.png", 10
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCommunityService, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCommunityService, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCommunityService, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCommunityService, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_equip_box2.png", "icon_equip_box2.png"
;("icon_equip_box2.png").x = 0
;("topTipEffect").offset, ("icon_equip_box2.png").y = "icon_equip_box2.png", 0
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeTrainEquip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeTrainEquip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainEquip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainEquip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_alliancewar.png", "icon_alliancewar.png"
;("icon_alliancewar.png").x = 2
;("topTipEffect").offset, ("icon_alliancewar.png").y = "icon_alliancewar.png", 22
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeAllianceWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeAllianceWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeAllianceWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeAllianceWar, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE5_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_equip_box2.png", "icon_equip_box2.png"
;("icon_equip_box2.png").x = 0
;("topTipEffect").offset, ("icon_equip_box2.png").y = "icon_equip_box2.png", 20
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "sprite"
;("topTipEffect").nodeName = "imgIcon2"
;("topTipEffect").zOrder = 3
;("topTipEffect").nodeImg = "icon_yes2.png"
_ENV, ("topTipEffect").scale = 1.1, 1.1
;(1.1).x = 4
;("topTipEffect").offset, (1.1).y = 1.1, 64
_ENV, ("topTipEffect").alone = 1.1, true
;(1.1).nodeType = "layout"
;(1.1).nodeName = "btn"
;(1.1).zOrder = 4
_ENV, (1.1).size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, (1.1).offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;(1.1).anchor, ("btn").y = "btn", 1
;(1.1).color = colorBuildBtn
_ENV, (1.1).opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeTrainMaterial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeTrainMaterial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainMaterial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeTrainMaterial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), 1.1
cityBuildViewDef.tblTopTypeTrainMaterial, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "btn_dailyreward.png", "btn_dailyreward.png"
;("btn_dailyreward.png").x = 0
;("topTipEffect").offset, ("btn_dailyreward.png").y = "btn_dailyreward.png", 10
;("topTipEffect").scale = 1.0
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeHuochuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeHuochuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHuochuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHuochuang, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_notice_board_limit.png", "icon_notice_board_limit.png"
;("icon_notice_board_limit.png").x = -2
;("topTipEffect").offset, ("icon_notice_board_limit.png").y = "icon_notice_board_limit.png", 26
;("topTipEffect").scale = 0.8
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeBulletInBoard, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeBulletInBoard, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeBulletInBoard, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeBulletInBoard, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_goods_box.png", "icon_goods_box.png"
;("icon_goods_box.png").x = 0
;("topTipEffect").offset, ("icon_goods_box.png").y = "icon_goods_box.png", 7
;("topTipEffect").scale = 0.48
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeActivity, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeActivity, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeActivity, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeActivity, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_saleRoom_symbol.png", "icon_saleRoom_symbol.png"
;("icon_saleRoom_symbol.png").x = 3
;("topTipEffect").offset, ("icon_saleRoom_symbol.png").y = "icon_saleRoom_symbol.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypePrompt, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypePrompt, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePrompt, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePrompt, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_building_gold_speedup.png", "icon_building_gold_speedup.png"
;("icon_building_gold_speedup.png").x = 3
;("topTipEffect").offset, ("icon_building_gold_speedup.png").y = "icon_building_gold_speedup.png", -10
;("topTipEffect").scale = 1
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeGold, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeGold, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeGold, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeGold, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_wharf_Extreme_shop.png", "icon_wharf_Extreme_shop.png"
;("icon_wharf_Extreme_shop.png").x = 0
;("topTipEffect").offset, ("icon_wharf_Extreme_shop.png").y = "icon_wharf_Extreme_shop.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypePremiumVipMall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypePremiumVipMall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePremiumVipMall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePremiumVipMall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_assistant_npc.png", "icon_assistant_npc.png"
;("icon_assistant_npc.png").x = 0
;("topTipEffect").offset, ("icon_assistant_npc.png").y = "icon_assistant_npc.png", -5
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeNpcTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeNpcTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeNpcTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeNpcTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "allitreas_box_01.png", "allitreas_box_01.png"
;("allitreas_box_01.png").x = 0
;("topTipEffect").offset, ("allitreas_box_01.png").y = "allitreas_box_01.png", 10
;("topTipEffect").scale = 0.5
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeAllianceTreasureTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeAllianceTreasureTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeAllianceTreasureTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeAllianceTreasureTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_coinbox_close.png", "icon_coinbox_close.png"
;("icon_coinbox_close.png").x = 0
;("topTipEffect").offset, ("icon_coinbox_close.png").y = "icon_coinbox_close.png", 10
;("topTipEffect").scale = 0.5
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopEndlessTreasure, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopEndlessTreasure, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopEndlessTreasure, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopEndlessTreasure, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_castleLv_privilege.png", "icon_castleLv_privilege.png"
;("icon_castleLv_privilege.png").x = -5
;("topTipEffect").offset, ("icon_castleLv_privilege.png").y = "icon_castleLv_privilege.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeCastleGiftTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeCastleGiftTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCastleGiftTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeCastleGiftTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_building_gold_speedup.png", "icon_building_gold_speedup.png"
;("icon_building_gold_speedup.png").x = 3
;("topTipEffect").offset, ("icon_building_gold_speedup.png").y = "icon_building_gold_speedup.png", 10
;("topTipEffect").scale = 1
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopArenaTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopArenaTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopArenaTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopArenaTip, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_pet_unlock.png", "icon_pet_unlock.png"
;("icon_pet_unlock.png").x = 0
;("topTipEffect").offset, ("icon_pet_unlock.png").y = "icon_pet_unlock.png", 0
;("topTipEffect").scale = 1
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopPetUnlock, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopPetUnlock, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopPetUnlock, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopPetUnlock, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_pet_skillreceice.png", "icon_pet_skillreceice.png"
;("icon_pet_skillreceice.png").x = 0
;("topTipEffect").offset, ("icon_pet_skillreceice.png").y = "icon_pet_skillreceice.png", 0
;("topTipEffect").scale = 1
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopPetSkillSend, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopPetSkillSend, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopPetSkillSend, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopPetSkillSend, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "3106.png", "3106.png"
;("3106.png").x = 0
;("topTipEffect").offset, ("3106.png").y = "3106.png", 10
;("topTipEffect").scale = 0.6
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopEpicwarFull, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopEpicwarFull, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopEpicwarFull, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopEpicwarFull, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "3106.png", "3106.png"
;("3106.png").x = 0
;("topTipEffect").offset, ("3106.png").y = "3106.png", 10
;("topTipEffect").scale = 0.6
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopFriendApply, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopFriendApply, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopFriendApply, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopFriendApply, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_bzjs.png", "icon_bzjs.png"
;("icon_bzjs.png").x = 0
;("topTipEffect").offset, ("icon_bzjs.png").y = "icon_bzjs.png", 12
;("topTipEffect").scale = 0.95
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypePromote, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypePromote, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePromote, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypePromote, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "btn_hero_prison_01.png", "btn_hero_prison_01.png"
;("btn_hero_prison_01.png").x = 0
;("topTipEffect").offset, ("btn_hero_prison_01.png").y = "btn_hero_prison_01.png", 0
;("topTipEffect").scale = 1
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeHasPrisoner, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeHasPrisoner, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHasPrisoner, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHasPrisoner, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_saleRoom_symbol.png", "icon_saleRoom_symbol.png"
;("icon_saleRoom_symbol.png").x = 3
;("topTipEffect").offset, ("icon_saleRoom_symbol.png").y = "icon_saleRoom_symbol.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeHeroReward, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeHeroReward, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHeroReward, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeHeroReward, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_saleRoom_symbol.png", "icon_saleRoom_symbol.png"
;("icon_saleRoom_symbol.png").x = 3
;("topTipEffect").offset, ("icon_saleRoom_symbol.png").y = "icon_saleRoom_symbol.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeDefendEmptySite, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeDefendEmptySite, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeDefendEmptySite, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeDefendEmptySite, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV, _UPVALUE4_, _ENV = cityBuildViewDef.tblMonument, tostring(BUILDID.MONUMENT), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
cityBuildViewDef.tblMonument.nodeType = "action"
cityBuildViewDef.tblMonument.nodeName = "imgBg"
cityBuildViewDef.tblMonument.zOrder = 1
_ENV, cityBuildViewDef.tblMonument.nodeImg = "imgBg", imgTopBg1
;("imgBg").x = 0
cityBuildViewDef.tblMonument.offset, ("imgBg").y = "imgBg", 0
_ENV, cityBuildViewDef.tblMonument.actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
cityBuildViewDef.tblMonument.anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, cityBuildViewDef.tblMonument.alone = "topTipEffect", true
;("topTipEffect").nodeType = "action"
;("topTipEffect").nodeName = "imgIcon"
;("topTipEffect").zOrder = 2
_ENV, ("topTipEffect").nodeImg = "icon_saleRoom_symbol.png", "icon_saleRoom_symbol.png"
;("icon_saleRoom_symbol.png").x = 3
;("topTipEffect").offset, ("icon_saleRoom_symbol.png").y = "icon_saleRoom_symbol.png", 10
;("topTipEffect").scale = 0.65
_ENV, ("topTipEffect").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("topTipEffect").anchor, ("topTipEffect").y = "topTipEffect", 0
_ENV, ("topTipEffect").alone = "topTipEffect", true
;("topTipEffect").nodeType = "layout"
;("topTipEffect").nodeName = "btn"
;("topTipEffect").zOrder = 3
_ENV, ("topTipEffect").size = "btn", sizeTopTrain
;("btn").x = 0
_ENV, ("topTipEffect").offset, ("btn").y = "btn", "btn", sizeTopTrain.height
;("btn").x = 0.5
;("topTipEffect").anchor, ("btn").y = "btn", 1
;("topTipEffect").color = colorBuildBtn
_ENV, ("topTipEffect").opacity = "btn", opacityBuildBtn
;("btn").nodeType = "ownAction"
;("btn").nodeName = "ownAction"
_ENV, ("btn").actionKey = "topTipEffect", "topTipEffect"
;("topTipEffect").x = 0.5
;("btn").anchor, ("topTipEffect").y = "topTipEffect", 0
cityBuildViewDef.tblTopTypeMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), cityBuildViewDef.tblMonument
cityBuildViewDef.tblTopTypeMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "topTipEffect"
cityBuildViewDef.tblTopTypeMonument, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").otherView, _ENV, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo").baseView, tostring(BUILDID.MONUMENT)[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), tostring(BUILDID.MONUMENT), "btn"
_ENV = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_FREE)] = cityBuildViewDef.tblTopTypeFree
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_HELP_ALL)] = cityBuildViewDef.tblTopTypeHelpAll
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_REQ_HELP)] = cityBuildViewDef.tblTopTypeReqHelp
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_TRAIN_FINISH)] = cityBuildViewDef.tblTopTypeTrainFinish
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_TRAIN_TRAP)] = cityBuildViewDef.tblTopTypeTrainTrap
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COLLECT_FOOD)] = cityBuildViewDef.tblTopTypeCollectFood
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COLLECT_WOOD)] = cityBuildViewDef.tblTopTypeCollectWood
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COLLECT_IRON)] = cityBuildViewDef.tblTopTypeCollectIron
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_CRYSTAL)] = cityBuildViewDef.tblTopTypeCollectCrystal
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COLLECT_STEEL)] = cityBuildViewDef.tblTopTypeCollectSteel
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COLLECT_GANGKOU)] = cityBuildViewDef.tblTopTypeCollectGangkou
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_BBS)] = cityBuildViewDef.tblTopTypeCommunityBBS
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_SERVICE)] = cityBuildViewDef.tblTopTypeCommunityService
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_TRAIN_EQUIP)] = cityBuildViewDef.tblTopTypeTrainEquip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_ALLIANCE_WAR)] = cityBuildViewDef.tblTopTypeAllianceWar
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_TRAIN_MATERIAL)] = cityBuildViewDef.tblTopTypeTrainMaterial
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_HUOCHUANG)] = cityBuildViewDef.tblTopTypeHuochuang
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_BULLETIN_BOARD)] = cityBuildViewDef.tblTopTypeBulletInBoard
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_ACTIVITY)] = cityBuildViewDef.tblTopTypeActivity
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_PROMPT)] = cityBuildViewDef.tblTopTypePrompt
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_PRIMIUM_VIP_MALL)] = cityBuildViewDef.tblTopTypePremiumVipMall
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_NPC_TIP)] = cityBuildViewDef.tblTopTypeNpcTip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_CASTLE_GIFT)] = cityBuildViewDef.tblTopTypeCastleGiftTip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_GOLD)] = cityBuildViewDef.tblTopTypeGold
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_ARENA)] = cityBuildViewDef.tblTopArenaTip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_ALLIANCETREASURE)] = cityBuildViewDef.tblTopTypeAllianceTreasureTip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_PET_UNLOCK)] = cityBuildViewDef.tblTopPetUnlock
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_PET_SKILL_SEND)] = cityBuildViewDef.tblTopPetSkillSend
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_EPICWAR_FULL)] = cityBuildViewDef.tblTopEpicwarFull
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_HAS_PRISONER)] = cityBuildViewDef.tblTopTypeHasPrisoner
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_HERO_REWARD)] = cityBuildViewDef.tblTopTypeHeroReward
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_DEFEND_EMPTYSITE)] = cityBuildViewDef.tblTopTypeDefendEmptySite
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_PROMOTE_ARMY)] = cityBuildViewDef.tblTopTypePromote
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_GOD_EQUIP_PROMPT)] = cityBuildViewDef.tblTopTypePrompt
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_MONUMENT)] = cityBuildViewDef.tblTopTypeMonument
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_FRIEND_APPLY)] = cityBuildViewDef.tblTopFriendApply
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_GOD_UNLOCK)] = cityBuildViewDef.tblTopTypeGodUnlock
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_EXCLUSIVE_VIP)] = cityBuildViewDef.tblTopTypeExclusiveVip
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_ENDLESS_TREASURE)] = cityBuildViewDef.tblTopEndlessTreasure
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_REWARD)] = cityBuildViewDef.tblTopNebulaTechReward
;("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_UP)] = cityBuildViewDef.tblTopNebulaTechUp
cityBuildViewDef.tblBuildTopCfg, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", cityBuildViewDef.tblTopWarShelterApply
_ENV, _UPVALUE5_ = tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).minLv = 0
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).maxLv = 2
_ENV, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
;("viewModel").minLv = 3
;("viewModel").maxLv = 5
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_2
;("viewModel").minLv = 6
;("viewModel").maxLv = 10
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_3
;("viewModel").minLv = 11
;("viewModel").maxLv = 14
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_4
;("viewModel").minLv = 15
;("viewModel").maxLv = 30
;("viewModel").viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_5
cityBuildViewDef.tblViewModelFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)
cityBuildViewDef.tblViewModelFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelFarm, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
_ENV, _UPVALUE5_ = tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).minLv = 0
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).maxLv = 2
_ENV, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
;("viewModel").minLv = 3
;("viewModel").maxLv = 5
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_2
;("viewModel").minLv = 6
;("viewModel").maxLv = 10
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_3
;("viewModel").minLv = 11
;("viewModel").maxLv = 14
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_4
;("viewModel").minLv = 15
;("viewModel").maxLv = 30
;("viewModel").viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_5
cityBuildViewDef.tblViewModelSawMill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)
cityBuildViewDef.tblViewModelSawMill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelSawMill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelSawMill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelSawMill, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
_ENV, _UPVALUE3_ = tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).minLv = 0
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).maxLv = 5
_ENV, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
;("viewModel").minLv = 6
;("viewModel").maxLv = 14
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_2
;("viewModel").minLv = 15
;("viewModel").maxLv = 130
;("viewModel").viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_3
cityBuildViewDef.tblViewModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)
cityBuildViewDef.tblViewModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
_ENV, _UPVALUE8_ = tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER), "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo"
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).minLv = 0
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).maxLv = 2
_ENV, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
;("viewModel").minLv = 3
;("viewModel").maxLv = 6
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_2
;("viewModel").minLv = 7
;("viewModel").maxLv = 10
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_3
;("viewModel").minLv = 11
;("viewModel").maxLv = 14
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_4
;("viewModel").minLv = 15
;("viewModel").maxLv = 30
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_5
;("viewModel").minLv = 31
;("viewModel").maxLv = 79
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_6
;("viewModel").minLv = 80
;("viewModel").maxLv = 129
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_7
;("viewModel").minLv = 130
;("viewModel").maxLv = 130
;("viewModel").viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_8
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[1] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[2] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[3] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[4] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[5] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[6] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[7] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
cityBuildViewDef.tblViewBZTModelWall, ("app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo")[8] = "app.game.cityBuild.cityBuildPosInfo.cityBuildLvPosInfo", "viewModel"
function cityBuildViewDef.getCityWallModelByLv(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end
_ENV, _UPVALUE5_ = tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER), function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).minLv = 0
tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).maxLv = 2
_ENV, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER).viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
;("viewModel").minLv = 3
;("viewModel").maxLv = 6
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_2
;("viewModel").minLv = 7
;("viewModel").maxLv = 10
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_3
;("viewModel").minLv = 11
;("viewModel").maxLv = 14
_ENV, ("viewModel").viewModel = "viewModel", cityBuildConstDef.VIEWMODEL.VIEWMODEL_4
;("viewModel").minLv = 15
;("viewModel").maxLv = 130
;("viewModel").viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_5
cityBuildViewDef.tblViewModelTurret, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[1] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, tostring(cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER)
cityBuildViewDef.tblViewModelTurret, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[2] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, "viewModel"
cityBuildViewDef.tblViewModelTurret, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[3] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, "viewModel"
cityBuildViewDef.tblViewModelTurret, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[4] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, "viewModel"
cityBuildViewDef.tblViewModelTurret, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[5] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, "viewModel"
function _ENV(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.WALLS)] = cc.p(20, -90)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.TURRET)] = cc.p(0, -90)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.WATCH_TOWER)] = cc.p(0, -115)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.CASTLE)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.DEPOT)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.EMBASSY)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.MARKET)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.COLLEGE)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.WISHING_WELL)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.BLACK_SMITH)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.STABLES)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.RANGE)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.CHARIOT_PLANT)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.BARRACKS)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.FORTRESS)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.DRILL_GROUDS)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.HALL_OF_WAR)] = cc.p(0, -30)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.FARM)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.SAWMILL)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.IRON_MINE)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.STEEL)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.MILITARY_TENT)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.HOSTPITAL)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.CRYSTAL_MINE)] = cc.p(0, 45)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.HERO_TRAIN_GROUND)] = cc.p(0, -70)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.HERO_CENOTAPH)] = cc.p(0, -60)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(BUILDID.HERO_PRISON)] = cc.p(0, -15)
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(cityBuildConstDef.fixedBuildDef.LeisureCenter)] = cc.p(20, -30)
cityBuildViewDef.tblBuildTipOffset, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[tostring(cityBuildConstDef.fixedBuildDef.HuoChuang)] = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, cc.p(0, -15)
_ENV, _ENV = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_1.png"
_ENV = "jianta_lv_1.png"
;("jianta_lv_1.png").x = 81.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_1.png").y = "jianta_lv_1.png", 47
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).rotate = -90
_ENV = -90
;(-90).x = 90
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, (-90).y = -90, 184.5
_ENV = -90
;(-90).x = 245.5
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[1], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, (-90).y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), -90, 260
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_2.png"
_ENV = "jianta_lv_2.png"
;("jianta_lv_2.png").x = 79.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_2.png").y = "jianta_lv_2.png", 47
_ENV = "jianta_lv_2.png"
;("jianta_lv_2.png").x = 88
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, ("jianta_lv_2.png").y = "jianta_lv_2.png", 193
_ENV = "jianta_lv_2.png"
;("jianta_lv_2.png").x = 244
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[2], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, ("jianta_lv_2.png").y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), "jianta_lv_2.png", 270
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_3.png"
_ENV = "jianta_lv_3.png"
;("jianta_lv_3.png").x = 63.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_3.png").y = "jianta_lv_3.png", 45
_ENV = "jianta_lv_3.png"
;("jianta_lv_3.png").x = 73
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, ("jianta_lv_3.png").y = "jianta_lv_3.png", 183
_ENV = "jianta_lv_3.png"
;("jianta_lv_3.png").x = 221
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[3], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, ("jianta_lv_3.png").y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), "jianta_lv_3.png", 255
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_4.png"
_ENV = "jianta_lv_4.png"
;("jianta_lv_4.png").x = 65.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_4.png").y = "jianta_lv_4.png", 42.5
_ENV = "jianta_lv_4.png"
;("jianta_lv_4.png").x = 73.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, ("jianta_lv_4.png").y = "jianta_lv_4.png", 185.5
_ENV = "jianta_lv_4.png"
;("jianta_lv_4.png").x = 223
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[4], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, ("jianta_lv_4.png").y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), "jianta_lv_4.png", 258.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_5.png"
_ENV = "jianta_lv_5.png"
;("jianta_lv_5.png").x = 66
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_5.png").y = "jianta_lv_5.png", 28.5
_ENV = "jianta_lv_5.png"
;("jianta_lv_5.png").x = 74.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, ("jianta_lv_5.png").y = "jianta_lv_5.png", 171.5
_ENV = "jianta_lv_5.png"
;("jianta_lv_5.png").x = 223
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[5], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, ("jianta_lv_5.png").y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), "jianta_lv_5.png", 244.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).png = "jianta_lv_6.png"
_ENV = "jianta_lv_6.png"
;("jianta_lv_6.png").x = 68.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).pos, ("jianta_lv_6.png").y = "jianta_lv_6.png", 39
_ENV = "jianta_lv_6.png"
;("jianta_lv_6.png").x = 74.5
tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscml, ("jianta_lv_6.png").y = "jianta_lv_6.png", 182
_ENV = "jianta_lv_6.png"
;("jianta_lv_6.png").x = 214.5
;(function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[6], tostring(cityBuildConstDef.fixedBuildDef.HuoChuang).poscmr, ("jianta_lv_6.png").y = tostring(cityBuildConstDef.fixedBuildDef.HuoChuang), "jianta_lv_6.png", 250.5
_ENV = "poscmr"
;("poscmr").png = "jianta_lv_7.png"
_ENV = "jianta_lv_7.png"
;("jianta_lv_7.png").x = 68.75
;("poscmr").pos, ("jianta_lv_7.png").y = "jianta_lv_7.png", 59.75
_ENV = "jianta_lv_7.png"
;("jianta_lv_7.png").x = 125.5
;("poscmr").poscml, ("jianta_lv_7.png").y = "jianta_lv_7.png", 231
_ENV = "jianta_lv_7.png"
;("jianta_lv_7.png").x = 276.5
_ENV, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[7], ("poscmr").poscmr, ("jianta_lv_7.png").y = 7, "poscmr", "jianta_lv_7.png", 303.5
;(7).png = "jianta_lv_8.png"
_ENV = "jianta_lv_8.png"
;("jianta_lv_8.png").x = 66
;(7).pos, ("jianta_lv_8.png").y = "jianta_lv_8.png", 65
_ENV = "jianta_lv_8.png"
;("jianta_lv_8.png").x = 67
;(7).poscml, ("jianta_lv_8.png").y = "jianta_lv_8.png", 238
_ENV = "jianta_lv_8.png"
;("jianta_lv_8.png").x = 288
cityBuildViewDef.curretConfig, (function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end)[8], (7).poscmr, ("jianta_lv_8.png").y = function(lv)
	local model = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	for k, v in pairs(cityBuildViewDef.tblViewModelWall) do
		if lv >= v.minLv and lv <= v.maxLv then
			model = v.viewModel
		end
	end
	return model
end, 7, "jianta_lv_8.png", 346
function cityBuildViewDef.getCurrentLampByModel(modelLv)
	return cityBuildViewDef.curretConfig[modelLv]
end
function cityBuildViewDef.getBuildTipOffset(bid)
	local BTBLD = require_data("build_tips_btn_list_data")
	local offset = BTBLD.data[bid].offset
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		offset = BTBLD.data[bid].offset_byzantine
	end
	if offset ~= nil and next(offset) then
		return offset
	end
	return cc.p(0, 0)
end
function cityBuildViewDef.getViewModelByLv(lv, tblViewModelCfg)
	local minLv = 0
	local maxLv = 1
	local maxViewModel = 1
	for i, v in ipairs(tblViewModelCfg) do
		if lv >= v.minLv and lv <= v.maxLv then
			minLv = math.min(v.minLv, minLv)
			maxLv = math.max(v.maxLv, maxLv)
			maxViewModel = math.max(maxViewModel, v.viewModel)
			return v.viewModel
		elseif lv > v.maxLv then
			maxLv = v.maxLv
			maxViewModel = math.max(maxViewModel, v.viewModel)
		end
	end
	if lv >= maxLv then
		return maxViewModel
	end
	return 1
end
function cityBuildViewDef.getBuildLvPosByIndex(buildIndex)
	local posLvBg, posUpgrade, posTextLv
	posLvBg = cityBuildViewDef.cityBuildLvPosInfo[tostring(buildIndex)]
	if posLvBg then
		posUpgrade = getImgUpgradePos(posLvBg)
		posTextLv = getTextLvPos(posLvBg)
	end
	return posLvBg, posUpgrade, posTextLv
end
function cityBuildViewDef.getBuildTopCfg(topType, factionType)
	return cityBuildViewDef.getBuildViewCfg(topType + 100000, factionType)
end
function cityBuildViewDef.getBuildViewCfg(bid, factionType)
	local factionCtrl = SoraDGetCtrl("factionCtrl")
	return factionCtrl:getBuildViewCfg(bid, factionType)
end
return cityBuildViewDef

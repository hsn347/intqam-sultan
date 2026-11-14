local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local worldMapFaceToDistance = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/worldMapFaceToDistance", worldMapFaceToDistance)
function worldMapFaceToDistance:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
end
function worldMapFaceToDistance:onShow()
end
function worldMapFaceToDistance:onClickSelf(...)
	SoraDPlaySound()
	local toTilePos = roaringFlameWarRead.getBuildCoord(self.toObjId)
	SoraDGotoWorldMapPoint(toTilePos, true)
	_ENV = toTilePos
	toTilePos.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(toTilePos)
end
function worldMapFaceToDistance:initData(params)
	local toObjId = params.toObjId
	local connect = params.connect
	self.toObjId = toObjId
	if not connect[tostring(toObjId)] then
		local _ENV, campInfo = connect[tostring(toObjId)], connect[tostring(toObjId)]
	end
	local camp = campInfo.camp or 0
	local faceImage = roaringFlameWarRead.getCampBuildFaceImage(camp)
	self.fields.icon:setURL(faceImage)
	local distance = params.distance
	_ENV = nil
	;(nil).color = "#FFFFFF"
	local distanceStr = string.format("%s KM", SoraDWrapHtmlTagByStyle(distance, nil))
	self.fields.title:setString(distanceStr)
	local rotation = params.rotation
	self.fields.node_arrow:setRotation(rotation)
end
return worldMapFaceToDistance

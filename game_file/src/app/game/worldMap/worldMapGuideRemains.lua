local gametop = gModuleMgr.getObject("gametop")
local worldMapGuideRemains = class("worldMapGuideRemains", function(target)
	local target = include("worldMapInstance").new("worldMapGuideRemains")
	return target
end)
function worldMapGuideRemains:ctor()
	self.bgImage = display.newSpriteNoChild("#Map_build_relic.png")
	self:addChild(self.bgImage, -1)
	self.guideName = "guideRemainsBuilding"
	self:_initData()
end
function worldMapGuideRemains:_initData()
	self.ignoreRequest = true
end
function worldMapGuideRemains:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapGuideRemains:initInstanceData(remainsData)
	self:updateData(remainsData)
end
function worldMapGuideRemains:onClickInstance(onShowView)
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapGuideRemains:playClickSound()
	SoraDPlaySound("worldmap", 7)
end
function worldMapGuideRemains:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_tanXian then
		return true
	end
end
function worldMapGuideRemains:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_tanXian
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
return worldMapGuideRemains

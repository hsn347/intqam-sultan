local mainCityDefine = include("mainCityDefine")
local cityBuildName = class("cityBuildBase", function()
	return display.newNode()
end)
function cityBuildName:ctor()
	self:createUI()
end
function cityBuildName:createUI()
	local nameBg = ccui.ImageView:create()
	nameBg:loadTexture("title_main_build_01.png", ccui.TextureResType.plistType)
	nameBg:ignoreContentAdaptWithSize(false)
	nameBg:setAnchorPoint(cc.p(0.5, 0.5))
	nameBg:setPosition(cc.p(4, 0))
	nameBg:setFlippedX(true)
	nameBg:setLocalZOrder(1)
	self:addChild(nameBg)
	self.nameBg = nameBg
	self.nameBg:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_BUILD_SHOW_NAME_BG)
	local name = ccui.Text:create()
	name:setFontSize(20)
	name:setColor(cc.c3b(220, 215, 180))
	name:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	name:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(name, 2)
	name:setPosition(cc.p(0, 0))
	self.name = name
	self.name:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_BUILD_SHOW_NAME)
	self.name:setGroupAuto(true)
end
function cityBuildName:init(data)
	local name = data.name
	if not name then
		return
	end
	self.name:setString(name)
end
return cityBuildName

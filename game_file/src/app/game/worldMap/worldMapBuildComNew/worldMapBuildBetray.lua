local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildBetray = class("worldMapBuildBetray", worldMapBuildComNew)
function worldMapBuildBetray:ctor(...)
	worldMapBuildBetray.super.ctor(self, ...)
end
function worldMapBuildBetray:_initData(...)
	self.betray = 0
end
function worldMapBuildBetray:updateData(data)
	if data.betray then
		self.betray = data.betray
		if data.betray > 0 then
			if conquestWarCtrl:getConquestWarState() == gConquestWarState.OPENING then
				local head = self:returnHeadImg()
				head:setVisible(true)
			end
		else
			local headIcon = self.target_:getChildByName("Image_betrayFrm")
			if headIcon then
				headIcon:setVisible(false)
			end
		end
	end
end
function worldMapBuildBetray:returnHeadImg(...)
	local headIcon = self.target_:getChildByName("Image_betrayFrm")
	if not headIcon then
		headIcon = ccui.Button:create("icon_alliance_traitor.png", "icon_alliance_traitor.png", "icon_alliance_traitor.png", ccui.TextureResType.plistType)
		headIcon:setScale(0.5)
		headIcon:setPosition(cc.p(self.centerPoint.x + 100, self.centerPoint.y - 82))
		headIcon:addTo(self.target_, 2)
		headIcon:setName("Image_betrayFrm")
		headIcon:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDShowMsgBox(i18n("common_text_4144"), i18n("common_text_204"))
			end
		end)
	end
	return headIcon
end
return worldMapBuildBetray

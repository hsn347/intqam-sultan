local gametop = gModuleMgr.getObject("gametop")
local socket = require("socket")
local worldMapMiniMapBase = class("worldMapMiniMapBase", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapMiniMapBase")
	elseif type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
_ENV = "worldMapMiniMapBase"
;("worldMapMiniMapBase").OP_TYPE_NONE = 1
;("worldMapMiniMapBase").OP_TYPE_JUMP = 2
worldMapMiniMapBase.OP_TYPE, ("worldMapMiniMapBase").OP_TYPE_TIPS = "worldMapMiniMapBase", 3
local OP_TYPE = worldMapMiniMapBase.OP_TYPE
function worldMapMiniMapBase:ctor()
	self.memberSpare, _UPVALUE0_, self.cityPolygonPtArray, _UPVALUE0_, self.buildingsArray, _UPVALUE0_, self.teamMembersArray, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.focusPosCdTime = 1.0
	self:initWidget()
end
function worldMapMiniMapBase:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.changeMainScene))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_FOCUS_POS", handler(self, self.updateFocusInfo))
end
function worldMapMiniMapBase:changeMainScene(target, data)
	if data.viewType ~= VIEW_TYPE_MAP then
		self:removeFromParent()
	end
end
function worldMapMiniMapBase:initWidget(...)
	SoraDGetChildByName(self, "Panel_touch"):setVisible(false)
	self.Slider_opacity = SoraDGetChildByName(self, "Slider_opacity")
	self.Slider_opacity:setScale9Enabled(true)
	self.Slider_opacity:addEventListener(handler(self, self.sliderValueChange))
	self.Slider_opacity:setOpacity(153.0)
	self.Slider_opacity:setCascadeOpacityEnabled(true)
	self.nodeBtn = SoraDGetChildByName(self, "Node_button")
	self.nodeBtn:setCascadeOpacityEnabled(true)
	self.btnOpJump = SoraDGetChildByName(self, "Button_2")
	self.btnOpJump:addTouchEventListener(handler(self, self.btnOpJumpClick))
	self.btnOpTip = SoraDGetChildByName(self, "Button_1")
	self.btnOpTip:addTouchEventListener(handler(self, self.btnOpTipClick))
	self.image_map = SoraDGetChildByName(self, "Image_map")
	self.image_map:setPreciseTouchEnabled(true)
	self.image_map:addTouchEventListener(handler(self, self.buttonSwitchClick))
	self.containerView = SoraDGetChildByName(self, "Panel_info")
	self.containerView:setCascadeOpacityEnabled(true)
	self.containerViewSize = self.containerView:getContentSize()
	self.containerViewCenterPoint = cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2)
	local containerViewSize = self.containerViewSize
	local offsetX = 0
	local offsetY = 28
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(containerViewSize.width / 2, containerViewSize.height - offsetY)
	local maxNum = worldMapDefine.getMaxCoordinateByKid()
	maxNum = maxNum + 1
	self.tileW = self.mapwidth / maxNum
	_UPVALUE2_, _UPVALUE4_, self.tileH = containerViewSize.height - offsetY, self.mapheight / maxNum, self.mapheight / maxNum
	_UPVALUE2_, (containerViewSize.height - offsetY)[1] = offsetX, offsetX
	_UPVALUE2_, (containerViewSize.height - offsetY)[2] = offsetX, containerViewSize.height / 2
	_UPVALUE2_, offsetX[1] = containerViewSize.width / 2, containerViewSize.width / 2
	_UPVALUE2_, offsetX[2] = containerViewSize.width / 2, containerViewSize.height - offsetY
	_UPVALUE2_, (containerViewSize.width / 2)[1] = containerViewSize.width - offsetX, containerViewSize.width - offsetX
	_UPVALUE2_, (containerViewSize.width / 2)[2] = containerViewSize.width - offsetX, containerViewSize.height / 2
	;(containerViewSize.width - offsetX)[1] = containerViewSize.width / 2
	;(containerViewSize.width - offsetX)[2] = offsetY
	;(self.mapheight / maxNum)[1] = containerViewSize.height - offsetY
	;(self.mapheight / maxNum)[2] = offsetX
	;(self.mapheight / maxNum)[3] = containerViewSize.width / 2
	local (self.mapheight / maxNum)[4], resourcePoints = containerViewSize.width - offsetX, self.mapheight / maxNum
	self.resourcePolygonPtArray, _ENV, self.resourcePoints = containerViewSize.height - offsetY, containerViewSize.height - offsetY, resourcePoints
	for _, v in pairs(resourcePoints) do
		self.resourcePolygonPtArray[#self.resourcePolygonPtArray + 1] = cc.p(v[1], v[2])
	end
	self:initNode()
	self:initSliderOpacity()
	self:initView()
end
function worldMapMiniMapBase:initNode()
	self.nodeBuilding = display.newNode()
	self.nodeBuilding:addTo(self.containerView, 9)
	self.nodeMember = display.newNode()
	self.nodeMember:addTo(self.containerView, 9)
	self.nodeWar = display.newNode()
	self.nodeWar:addTo(self.containerView, 9)
	_UPVALUE3_ = self.nodeWar
	self.nodeWar[1] = self.nodeBuilding
	self.nodeWar[2] = self.nodeMember
	self.nodeWar[3] = self.nodeWar
	for i, v in ipairs(self.nodeWar) do
		v:setCascadeOpacityEnabled(true)
	end
end
function worldMapMiniMapBase:initSliderOpacity(...)
	_ENV = nil
	;(nil).byUID = true
	local opacity = SoraDConfigGet("Game:worldMapMiniMapBase:opacity~integer", nil) or 70
	self.Slider_opacity:setPercent(opacity)
	self:updateOpacity(self.Slider_opacity)
end
function worldMapMiniMapBase:addPolygonPoint(point, weight, height)
	_UPVALUE2_, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil)[1] = point.x - weight, point.x - weight
	_UPVALUE2_, (nil)[2] = point.x - weight, point.y
	_UPVALUE2_, (point.x - weight)[1] = point.x, point.x
	_UPVALUE2_, (point.x - weight)[2] = point.x, point.y - height
	_UPVALUE2_, point.x[1] = point.x + weight, point.x + weight
	_UPVALUE2_, point.x[2] = point.x + weight, point.y
	;(point.x + weight)[1] = point.x
	;(point.x + weight)[2] = point.y + height
	;(nil)[1] = nil
	;(nil)[2] = point.x - weight
	;(nil)[3] = point.x
	local (nil)[4], cityPoints = point.x + weight, nil
	local _ENV, cityPolygonPtArray
	for _, v in pairs(cityPoints) do
		cityPolygonPtArray[#cityPolygonPtArray + 1] = cc.p(v[1], v[2])
	end
	_ENV = pairs(cityPoints)
	pairs(cityPoints).cityPolygonPtArray = cityPolygonPtArray
	pairs(cityPoints).point = point
	table.insert(self.cityPolygonPtArray, pairs(cityPoints))
end
function worldMapMiniMapBase:initView()
	self:initOpType()
end
function worldMapMiniMapBase:initOpType()
	_ENV = nil
	;(nil).byUID = true
	local ret = SoraDConfigGet("Game:worldMapMiniMapBase:optype~integer", nil) or OP_TYPE.OP_TYPE_NONE
	self:setOpType(ret, true)
end
function worldMapMiniMapBase:setNodePos(node, pos, size)
	size = size or 1
	local offset = size * 0.5
	local tilex = pos.x + offset
	local tiley = pos.y + offset
	local x = self.zeroPoint.x + (tilex - tiley) * self.tileW / 2
	local y = self.zeroPoint.y + -(tilex + tiley) * self.tileH / 2
	local point = cc.p(x, y)
	node:setPosition(point)
end
function worldMapMiniMapBase:buttonSwitchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.opType == OP_TYPE.OP_TYPE_JUMP then
			SoraDPlaySound()
			self:opJump(button)
		elseif self.opType == OP_TYPE.OP_TYPE_TIPS then
			SoraDPlaySound()
			self:opTips(button)
		else
			local touchEndPoint = button:getTouchEndPosition()
			local covertPoint = self.containerView:convertToNodeSpace(touchEndPoint)
			local subPoint = cc.pSub(self.containerViewCenterPoint, covertPoint)
			local ratio = worldMapDefine.worldMapViewSize.width / self.mapwidth
			subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
		end
	end
end
function worldMapMiniMapBase:opJump(button)
	local touchEndPoint = button:getTouchEndPosition()
	local covertPoint = self.containerView:convertToNodeSpace(touchEndPoint)
	local isTouchInMember = false
	if self.teamMembersArray then
		for _, v in pairs(self.teamMembersArray) do
			if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
				local x, y = v:getPosition()
				covertPoint = cc.p(x, y)
				isTouchInMember = true
				break
			end
		end
	end
	if self.buildingsArray then
		for _, v in pairs(self.buildingsArray) do
			if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
				local x, y = v:getPosition()
				covertPoint = cc.p(x, y)
				isTouchInMember = true
				break
			end
		end
	end
	if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
		if not isTouchInMember then
			for _, v in ipairs(self.cityPolygonPtArray) do
				if SorDIsPointInPolygon(v.cityPolygonPtArray, covertPoint) then
					covertPoint = v.point
				end
			end
		end
		local subPoint = cc.pSub(self.containerViewCenterPoint, covertPoint)
		local ratio = worldMapDefine.worldMapViewSize.width / self.mapwidth
		subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
		_ENV = subPoint.x * ratio
		;(subPoint.x * ratio).msg = "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT"
		;(subPoint.x * ratio).subPoint = subPoint
		;(subPoint.x * ratio).kingdomID = worldMapDefine.currentMapKindomID
		SoraDSendMessage(subPoint.x * ratio)
	end
end
function worldMapMiniMapBase:isInCd()
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < self.focusPosCdTime then
			return true
		end
	end
	self.preClockTime = curTime
	return false
end
function worldMapMiniMapBase:showFocusPosInCdMsgTip(...)
	SoraDShowMsgTip(i18n("common_text_046"))
end
function worldMapMiniMapBase:opTips(button)
	local touchEndPoint = button:getTouchEndPosition()
	local covertPoint = self.containerView:convertToNodeSpace(touchEndPoint)
	if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
		if self:isInCd() then
			self:showFocusPosInCdMsgTip()
			return
		end
		local subPoint = covertPoint
		local mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
		self:reqNotifyFocusPos(subPoint, mapId)
	end
end
function worldMapMiniMapBase:reqNotifyFocusPos(subPoint, mapId)
end
function worldMapMiniMapBase:updateFocusInfo(target, data)
	if data and data.info then
		self:addFocusInfo(data.info)
	end
end
function worldMapMiniMapBase:addFocusInfo(info)
	dump(info, "info", 10)
	local effect = SoraDCreatAnimation("nodeEffect_tip")
	effect:addTo(self.nodeWar)
	effect:setPosition(cc.p(info.x, info.y))
	local _ENV, actions = effect.setPosition, effect.setPosition
	actions[#actions + 1] = cc.DelayTime:create(3)
	actions[#actions + 1] = cc.RemoveSelf:create()
	local action = transition.sequence(actions)
	effect:runAction(action)
end
function worldMapMiniMapBase:setOpType(opType, config)
	if self.opType == opType then
		return
	end
	self.opType = opType
	self.image_map:setSwallowTouches(true)
	self:showEffect()
	if not config then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:worldMapMiniMapBase:optype~integer", opType, nil)
	end
end
function worldMapMiniMapBase:btnOpJumpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.opType == OP_TYPE.OP_TYPE_JUMP then
			self:setOpType(OP_TYPE.OP_TYPE_NONE)
		else
			self:setOpType(OP_TYPE.OP_TYPE_JUMP)
			SoraDShowMsgTip(i18n("remains_text_370"))
		end
	end
end
function worldMapMiniMapBase:btnOpTipClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.opType == OP_TYPE.OP_TYPE_TIPS then
			self:setOpType(OP_TYPE.OP_TYPE_NONE)
		else
			self:setOpType(OP_TYPE.OP_TYPE_TIPS)
			SoraDShowMsgTip(i18n("remains_text_371"))
		end
	end
end
function worldMapMiniMapBase:sliderValueChange(slider, eventType)
	if eventType == 0 then
		self:updateOpacity(slider)
	end
end
function worldMapMiniMapBase:updateOpacity(slider)
	local opacity = slider:getPercent() / 100 * 255
	self:updateOpacity_imp(opacity)
	_ENV = slider
	slider.byUID = true
	SoraDConfigSet("Game:worldMapMiniMapBase:opacity~integer", slider:getPercent(), slider)
end
function worldMapMiniMapBase:updateOpacity_imp(opacity)
	self.containerView:setOpacity(opacity)
	self.nodeBtn:setOpacity(opacity)
	if opacity < 10 then
		self.nodeBtn:setVisible(false)
	else
		self.nodeBtn:setVisible(true)
	end
end
function worldMapMiniMapBase:showEffect()
	if self.opType == OP_TYPE.OP_TYPE_NONE then
		if self.et_guide_effect then
			self.et_guide_effect:setVisible(false)
		end
		return
	end
	local ocx = self.btnOpTip
	if self.opType == OP_TYPE.OP_TYPE_JUMP then
		ocx = self.btnOpJump
	end
	if not self.et_guide_effect then
		local et_guide_effect = display.newNode()
		et_guide_effect:addTo(self.nodeBtn, 99)
		local sprite = display.newSprite("#dh_pyramid_active_01.png")
		sprite:addTo(et_guide_effect, 2)
		sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
		OP_TYPE, OP_TYPE = sprite, sprite.runAction
		sprite.runAction[1], sprite.plist = sprite, "et_xwjyd_01.plist"
		local param1 = sprite.runAction
		local et_node1 = SoraDCreateEffectNode(param1)
		et_node1:addTo(et_guide_effect, 1)
		OP_TYPE, OP_TYPE = et_node1, et_node1.addTo
		et_node1.addTo[1], et_node1.plist = et_node1, "et_xwjyd_02.plist"
		local param2 = et_node1.addTo
		local et_node2 = SoraDCreateEffectNode(param2)
		et_node2:addTo(et_guide_effect, 3)
		et_guide_effect:setName("et_effect_lowguide")
		et_guide_effect:setScale(0.45)
		et_guide_effect:setCascadeOpacityEnabled(true)
		self.et_guide_effect = et_guide_effect
	end
	self.et_guide_effect:setVisible(true)
	self.et_guide_effect:setPosition(cc.p(ocx:getPosition()))
end
return worldMapMiniMapBase

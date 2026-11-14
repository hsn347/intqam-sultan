local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local remainsWarRead = include("remainsWarRead")
local socket = require("socket")
local remainsWarUtil = include("remainsWarUtil")
local RW_CAMP = _G.RW_CAMP
_ENV = nil
;(nil).OP_TYPE_NONE = 1
;(nil).OP_TYPE_JUMP = 2
local (nil).OP_TYPE_TIPS, OP_TYPE = 3, nil
local remainsMiniMap = class("remainsMiniMap", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("remainsMiniMap")
	end
	if target ~= nil then
		local baseClass = include("allianceWarBase")
		target = baseClass.new(target)
	end
	return target
end)
function remainsMiniMap:ctor()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.aid = allianceMgr:getOwnTeamID()
	SoraDGetChildByName(self, "Panel_touch"):setVisible(false)
	SoraDGetChildByName(self, "Panel_touch"):setTouchEnabled(false)
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
	self.node_refresh_time = SoraDGetChildByName(self, "Node_refresh_time")
	self.node_refresh_my = SoraDGetChildByName(self, "Image_my_bg")
	self.node_refresh_my:setVisible(false)
	self.node_refresh_zjssg = SoraDGetChildByName(self, "Image_zjssg_bg")
	self.node_refresh_zjssg:setVisible(false)
	self.image_map = SoraDGetChildByName(self, "Image_map")
	self.image_map:setPreciseTouchEnabled(true)
	self.image_map:addTouchEventListener(handler(self, self.buttonSwitchClick))
	self.containerView = SoraDGetChildByName(self, "Panel_info")
	self.containerView:setCascadeOpacityEnabled(true)
	self.containerViewSize = self.containerView:getContentSize()
	self.cityPolygonPtArray, gametop, self.containerViewCenterPoint = cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2), cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2), cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2)
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
	self.resourcePolygonPtArray, gametop, self.resourcePoints = containerViewSize.height - offsetY, containerViewSize.height - offsetY, resourcePoints
	for _, v in pairs(resourcePoints) do
		self.resourcePolygonPtArray[#self.resourcePolygonPtArray + 1] = cc.p(v[1], v[2])
	end
	self:initNode()
	self:addPolygonPoint(self.containerViewCenterPoint, 25, 25)
	self:addPolygonPoint(cc.p(self.containerViewCenterPoint.x, self.containerViewSize.height - offsetY - 30), 25, 25)
	self:addPolygonPoint(cc.p(self.containerViewCenterPoint.x, offsetY + 30), 25, 25)
	self:initQueue(0)
	self:initView()
end
function remainsMiniMap:onMessageListener()
	self:addWarBaseMsg()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_PLAYER_CITY", handler(self, self.updateTeamMembers))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_CAMP_DATA", handler(self, self.updateTeamMembers))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.updateOccupyView))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.reqOccupyInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.reqOccupyInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_FOCUS_POS", handler(self, self.updateFocusInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BOSS_REFRESH_TIME", handler(self, self.updateStatues))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.updateStatues))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.changeMainScene))
end
function remainsMiniMap:initNode()
	self.nodeMember = display.newNode()
	self.nodeMember:addTo(self.containerView, 9)
	self.tableSpare, _ENV, self.tableSingleUI, _ENV, self.teamMembersArray, _ENV = self.nodeMember.addTo, self.nodeMember.addTo, self.nodeMember.addTo, self.nodeMember.addTo, self.nodeMember.addTo, self.nodeMember.addTo
	self.nodeWar = display.newNode()
	self.nodeWar:addTo(self.containerView, 9)
	self.image_LeagueFlag = SoraDGetChildByName(self, "image_LeagueFlag")
	if not self.image_LeagueFlag then
		self.image_LeagueFlag = display.newSprite("#frame_yjzz_sign_01.png")
		self.image_LeagueFlag:addTo(self.containerView, 8)
		self.image_LeagueFlag:setPosition(self.containerViewCenterPoint)
		self.image_LeagueFlag:setVisible(false)
	end
	_ENV = false
	;(false).byUID = true
	local opacity = SoraDConfigGet("Game:remainsMiniMap:opacity~integer", false) or 70
	self.Slider_opacity:setPercent(opacity)
	self:updateOpacity(self.Slider_opacity)
end
function remainsMiniMap:initView()
	_ENV = nil
	;(nil).byUID = true
	local ret = SoraDConfigGet("Game:remainsMiniMap:optype~integer", nil) or OP_TYPE.OP_TYPE_NONE
	self:setOpType(ret, true)
	self:initQueueView()
	self:updateTeamMembers()
	self:reqOccupyInfo()
end
function remainsMiniMap:setNodePos(node, pos, size)
	size = size or 1
	local offset = size * 0.5
	local tilex = pos.x + offset
	local tiley = pos.y + offset
	local x = self.zeroPoint.x + (tilex - tiley) * self.tileW / 2
	local y = self.zeroPoint.y + -(tilex + tiley) * self.tileH / 2
	local point = cc.p(x, y)
	node:setPosition(point)
end
function remainsMiniMap:updateTeamMembers()
	local data = remainsWarCtrl:getRemainsWarData()
	if not data.warCampData then
		local remainsWarCtrl, warData = data.warCampData, data.warCampData
	end
	if not warData[RW_CAMP.SOUTH_KEY] then
		local remainsWarCtrl, southData = warData[RW_CAMP.SOUTH_KEY], warData[RW_CAMP.SOUTH_KEY]
	end
	if not warData[RW_CAMP.NORTH_KEY] then
		local remainsWarCtrl, northData = warData[RW_CAMP.NORTH_KEY], warData[RW_CAMP.NORTH_KEY]
	end
	if southData.teamId == self.aid then
		self:addTeamMembersInfo(southData)
	elseif northData.teamId == self.aid then
		self:addTeamMembersInfo(northData)
	end
end
function remainsMiniMap:addTeamMembersInfo(campData)
	dump(campData, "campData", 10)
	if not campData or not campData.memberMap then
		local _ENV, memberArray = campData.memberMap, campData.memberMap
	end
	for uid, v in pairs(memberArray) do
		self:addTeamMembers(tonumber(uid), v)
	end
end
function remainsMiniMap:addTeamMembers(uid, pos)
	local member = self.teamMembersArray[uid]
	if not member then
		local memberSprite, scale
		local uid_self = lordInfoCtrl:getLordInfo().base.uid
		if uid_self == uid then
			scale = 1.0
			memberSprite = display.newSprite("#frame_yjzz_sign_01.png")
		else
			scale = 1.0
			memberSprite = display.newSprite("#frame_yjzz_sign_02.png")
		end
		self.teamMembersArray[uid] = memberSprite
		memberSprite:setScale(scale)
		memberSprite:addTo(self.nodeMember)
		member = memberSprite
	end
	self:setNodePos(member, pos)
end
function remainsMiniMap:initQueueView()
	self:initQueueData()
	for _, v in pairs(gAllianceQueueClassType) do
		self:updateQueueData(v)
	end
end
function remainsMiniMap:updateQueueData(classType)
	local warData = self:getQueue(classType)
	local tableData = warData:getTableData()
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for _, v in ipairs(queueData) do
			if v.isMass then
				local point = self.tableSingleUI[v]
				if not point then
					local single
					if #self.tableSpare > 0 then
						single = table.remove(self.tableSpare)
						single:setVisible(true)
					else
						single = SoraDCreatePanel("remainsMiniMapRally")
						single:setMainView(self, self.queueRoot)
						single:addTo(self.nodeWar)
					end
					single:initData(v.indexID, v.data, v.isFilter)
					self.tableSingleUI[v] = single
				end
			end
		end
	end
end
function remainsMiniMap:clearQueueData()
	for _, v in pairs(self.tableSingleUI) do
		self:reuseSingle(v)
	end
	self.tableSingleUI, _ENV = pairs(self.tableSingleUI)
end
function remainsMiniMap:reuseSingle(single)
	if single then
		single:setVisible(false)
		single:resetData()
		table.insert(self.tableSpare, single)
	end
end
function remainsMiniMap:refreshByData(classType, queue, isDelete)
	if isDelete then
		local point = self.tableSingleUI[queue]
		if point then
			self:reuseSingle(point)
			self.tableSingleUI[queue] = nil
		end
	end
	self:updateQueueData(classType)
end
function remainsMiniMap:refreshSinggleByData(classType, queue)
	local point = self.tableSingleUI[queue]
	if point then
		point:updateData(queue.indexID, queue.data, queue.isFilter)
	end
end
function remainsMiniMap:addPolygonPoint(point, weight, height)
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
function remainsMiniMap:buttonSwitchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.opType == OP_TYPE.OP_TYPE_JUMP then
			SoraDPlaySound()
			self:opJump(button)
		elseif self.opType == OP_TYPE.OP_TYPE_TIPS then
			SoraDPlaySound()
			self:opTips(button)
		end
	end
end
function remainsMiniMap:opJump(button)
	local touchEndPoint = button:getTouchEndPosition()
	local covertPoint = self.containerView:convertToNodeSpace(touchEndPoint)
	local isTouchInMember = false
	for _, v in pairs(self.teamMembersArray) do
		if cc.rectContainsPoint(v:getCascadeBoundingBox(), touchEndPoint) then
			local x, y = v:getPosition()
			covertPoint = cc.p(x, y)
			isTouchInMember = true
			break
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
local MIN_TIME = 1.0
function remainsMiniMap:isInCd()
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < MIN_TIME then
			return true
		end
	end
	self.preClockTime = curTime
	return false
end
function remainsMiniMap:opTips(button)
	local touchEndPoint = button:getTouchEndPosition()
	local covertPoint = self.containerView:convertToNodeSpace(touchEndPoint)
	if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
		if self:isInCd() then
			SoraDShowMsgTip(i18n("common_text_046"))
			return
		end
		local subPoint = covertPoint
		local mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
		remainsWarCtrl:reqNotifyFocusPos(mapId, subPoint.x, subPoint.y)
	end
end
function remainsMiniMap:refreshOccupyNode()
	local warStatus = remainsWarCtrl:getWarStatus()
	print("遗迹之战状态：", warStatus)
	if gKingdomWarStatusType.inWar == warStatus then
		local occupyUsrData = self.myPlaceInfo
		dump(occupyUsrData, "占领者")
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			if occupyUsrData.camp then
				self.image_LeagueFlag:setVisible(true)
				self.image_LeagueFlag:setSpriteFrame(remainsWarRead.getCampIcon(occupyUsrData.camp))
				if 1 == occupyUsrData.camp then
					self.image_LeagueFlag:setScale(0.25)
				else
					self.image_LeagueFlag:setScale(0.5)
				end
			else
				self.image_LeagueFlag:setVisible(false)
			end
		end
	end
end
function remainsMiniMap:updateOccupyView(target, data)
	if data then
		self.myPlaceInfo = data.retdata
		dump(self.myPlaceInfo, "self.myPlaceInfo===========")
		self:refreshOccupyNode()
	end
end
function remainsMiniMap:reqOccupyInfo(target, data)
	local warStatus = remainsWarCtrl:getWarStatus()
	print("遗迹之战状态：", warStatus)
	if gKingdomWarStatusType.inWar == warStatus then
		kingdomMapCtrl:getPlaceOwnerInfo(33, 33)
	end
	self:updateStatues()
end
function remainsMiniMap:updateFocusInfo(target, data)
	if data and data.info then
		self:addFocusInfo(data.info)
	end
end
function remainsMiniMap:addFocusInfo(info)
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
function remainsMiniMap:setOpType(opType, config)
	if self.opType == opType then
		return
	end
	self.opType = opType
	self.image_map:setSwallowTouches(self.opType ~= OP_TYPE.OP_TYPE_NONE)
	self:showEffect()
	if not config then
		OP_TYPE = OP_TYPE.OP_TYPE_NONE
		OP_TYPE.OP_TYPE_NONE.byUID = true
		SoraDConfigSet("Game:remainsMiniMap:optype~integer", opType, OP_TYPE.OP_TYPE_NONE)
	end
end
function remainsMiniMap:btnOpJumpClick(button, eventType)
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
function remainsMiniMap:btnOpTipClick(button, eventType)
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
function remainsMiniMap:sliderValueChange(slider, eventType)
	if eventType == 0 then
		self:updateOpacity(slider)
	end
end
function remainsMiniMap:updateOpacity(slider)
	local opacity = slider:getPercent() / 100 * 255
	self:updateOpacity_imp(opacity)
	_ENV = slider
	slider.byUID = true
	SoraDConfigSet("Game:remainsMiniMap:opacity~integer", slider:getPercent(), slider)
end
function remainsMiniMap:updateOpacity_imp(opacity)
	self.containerView:setOpacity(opacity)
	self.nodeBtn:setOpacity(opacity)
	self.node_refresh_time:setOpacity(opacity)
end
function remainsMiniMap:updateRefreshTime()
	local timeMy = remainsWarCtrl:getBossRefreshTime_My()
	self:updateRefreshTime_imp(self.node_refresh_my, timeMy)
	local timeZjssg = remainsWarCtrl:getBossRefreshTime_Zjssg()
	self:updateRefreshTime_imp(self.node_refresh_zjssg, timeZjssg)
end
function remainsMiniMap:updateRefreshTime_imp(node, time)
	node:stopAllActions()
	if time <= 0 then
		node:setVisible(true)
	else
		node:setVisible(false)
		local _ENV, actions = node.setVisible, node.setVisible
		actions[#actions + 1] = cc.DelayTime:create(time)
		actions[#actions + 1] = cc.Show:create()
		local action = transition.sequence(actions)
		node:runAction(action)
	end
end
function remainsMiniMap:updateStatues()
	local isOpen = remainsWarCtrl:isInWar() and not remainsWarUtil.checkIsInRemainsXianXia()
	if isOpen then
		self.node_refresh_time:setVisible(true)
		self:updateRefreshTime()
	else
		self.node_refresh_time:setVisible(false)
		self.node_refresh_my:setVisible(false)
		self.node_refresh_zjssg:setVisible(false)
	end
end
function remainsMiniMap:showEffect()
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
		self.et_guide_effect = et_guide_effect
	end
	self.et_guide_effect:setVisible(true)
	self.et_guide_effect:setPosition(cc.p(ocx:getPosition()))
end
function remainsMiniMap:changeMainScene(target, data)
	if data.viewType ~= VIEW_TYPE_MAP then
		self:removeFromParent()
	end
end
return remainsMiniMap

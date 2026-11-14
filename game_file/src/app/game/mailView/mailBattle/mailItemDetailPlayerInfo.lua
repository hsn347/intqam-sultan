local itemDesRead = include("itemDesRead")
local worldMapDefine = include("worldMapDefine")
local mailUIConstDef = include("mailUIConstDef")
local mailFunctions = include("mailFunctions")
local armyDesRead = include("armyDesRead")
local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local mailItemDetailPlayerInfo = class("mailItemDetailPlayerInfo", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailPlayerInfo"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailPlayerInfo:ctor()
	self:setCascadeOpacityEnabled(true)
	_ENV, self.singleIsMoved = self.setCascadeOpacityEnabled, false
	self.setCascadeOpacityEnabled.x = 0
	self.coordinate, self.setCascadeOpacityEnabled.y = self.setCascadeOpacityEnabled, 0
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	if self.text_coordinate then
		self.text_coordinate:setSwallowTouches(false)
		self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	end
	self.playerAvatarBox = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBox:setCascadeOpacityEnabled(true)
	self.playerAvatarBox:addTo(self.layout_content)
	self.playerAvatarBox:setScroll(gModuleMgr.sharedMgr("mailMgr"):getScrollParent())
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_lv = SoraDGetChildByName(self, "text_lv")
	self.text_power = SoraDGetChildByName(self, "text_power")
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.playerAvatarBox:setContentSize(cc.size(self.playerAvatarBox:getItemWidth(), self.playerAvatarBox:getItemHeight()))
	self.playerAvatarBox:setAnchorPoint(SoraDFAP(0, 0))
	self.playerAvatarBox:setPosition(SoraDFPoint(380, 15, self.itemWidth))
end
function mailItemDetailPlayerInfo:initWithData(contentData)
	if nil == contentData then
		return
	end
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local targetMapObj = contentData.targetMapObj
	local uinfo = contentData.uinfo
	local allianceInfo = contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, _ENV = nil, nil
	end
	if targetMapObj and next(targetMapObj) ~= nil and (uinfo == nil or uinfo.nickName == nil) then
		self.coordinate.x = targetMapObj.x
		self.coordinate.y = targetMapObj.y
		local mapType = targetMapObj.mapType
		local subMapType = targetMapObj.subMapType
		local buildName = mailFunctions:getMapBuildName(targetMapObj)
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, buildName)
		self.text_name:setString(strName)
		local strCoordinate = mailFunctions:getStrCoordinate(self.coordinate.x, self.coordinate.y)
		SoraDChangeTextToHtml(self.text_coordinate)
		_ENV = nil
		_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
		;(nil).commonStr, (nil).u = nil, true
		self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
		self.text_lv:setVisible(false)
		self.text_coordinate:setVisible(true)
		local flag
		if mapType == gMapObjTypeDef.mapObjTypeAllianceBuild and subMapType == gAllianceBuilding.FLAG then
			flag = allianceInfo.flag
		end
		local iconName = mailFunctions:getMapBuildIcon(mapType, subMapType)
		_ENV = subMapType
		subMapType.playerId = nil
		subMapType.imgPlayer = iconName
		subMapType.flag = flag
		self.playerAvatarBox:initWithData(subMapType)
	elseif uinfo ~= nil and next(uinfo) ~= nil then
		local coordinate = contentData.uinfo.coordinate
		self.coordinate.x = coordinate.x
		self.coordinate.y = coordinate.y
		self.coordinate.kid = coordinate.kid
		if allianceInfo == nil then
			allianceInfo, _ENV = self.coordinate, self.coordinate
		end
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		self.text_name:setString(strName)
		local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
		SoraDChangeTextToHtml(self.text_coordinate)
		_ENV = self.playerAvatarBox.initWithData
		_ENV, _ENV, self.playerAvatarBox.initWithData.commonStr = subMapType, self.playerAvatarBox, strCoordinate
		self.playerAvatarBox.commonStr, subMapType.u = subMapType, true
		self.text_coordinate:setString(i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox))
		local iconName = lordLocalData.getHead(uinfo.iconID)
		_ENV = i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox)
		i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox).playerId = uinfo.id
		i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox).imgPlayer = iconName
		i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox).imageId = uinfo.iconID
		i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox).avatar = uinfo.avatar
		self.playerAvatarBox:initWithData(i18n_html("common_text_034", self.playerAvatarBox.initWithData, self.playerAvatarBox))
		self.text_lv:setVisible(false)
		self.text_coordinate:setVisible(true)
	end
	if contentData.hideName then
		self.text_name:setVisible(false)
	end
	if contentData.hideLv then
		self.text_coordinate:setVisible(false)
	end
	if contentData.hideCoordinate then
		self.text_lv:setVisible(false)
	end
end
function mailItemDetailPlayerInfo:initWithCommonData(data)
	local playerId = data.id
	local iconID = data.iconID
	local name = data.name
	local lv = data.lv
	local power = data.power
	local avatar = data.avatar
	local isCastle = data.isCastle
	local iconName = lordLocalData.getHead(iconID)
	lordLocalData = nil
	;(nil).playerId = playerId
	;(nil).imageId = iconID
	;(nil).avatar = avatar
	;(nil).imgPlayer = iconName
	self.playerAvatarBox:initWithData(nil)
	self.text_name:setString(name)
	SoraDGetAutoHeightLabel(self.text_name, 350)
	if lv and lv ~= 0 then
		if isCastle then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(lv)
			lordLocalData = nil
			;(nil).lv = textLv
			self.text_lv:setString(i18n("common_text_3514", nil))
			self.text_lv:setVisible(true)
			if isShowWarLv and self.spriteWar == nil then
				self.spriteWar = display.newSprite("#301101.png")
				self.spriteWar:setScale(0.3)
				self.spriteWar:addTo(self.text_lv:getParent())
				if SoraDFIsRA() then
					self.spriteWar:setPosition(cc.p(self.text_lv:getPositionX() + 25, self.text_lv:getPositionY() - 10))
				else
					self.spriteWar:setPosition(cc.p(self.text_lv:getPositionX() - 25, self.text_lv:getPositionY() - 10))
				end
			end
		else
			self.text_lv:setString("Lv." .. tostring(lv))
			self.text_lv:setVisible(true)
		end
	else
		self.text_lv:setVisible(false)
	end
	self.text_coordinate:setVisible(false)
	if power and self.text_power then
		self.text_power:setString(tostring(power))
		self.text_power:setVisible(true)
	elseif self.text_power then
		self.text_power:setVisible(false)
	end
end
function mailItemDetailPlayerInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailPlayerInfo:getItemHeight()
	return self.itemHeight
end
function mailItemDetailPlayerInfo:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local targetPoint = cc.p(self.coordinate.x, self.coordinate.y)
		targetPoint.kid = self.coordinate.kid
		if SoraDGotoWorldMapPoint(targetPoint, true, targetPoint.kid) then
			_ENV = targetPoint
			targetPoint.msg = "MESSAGE_MAIL_CLOSE_VIEW"
			SoraDSendMessage(targetPoint)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return mailItemDetailPlayerInfo

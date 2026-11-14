local gametop = gModuleMgr.getObject("gametop")
local allianceDesRead = include("allianceDesRead")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local AllianceBuildListSingle = class("allianceBuildListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildListSingle")
	end
	return target
end)
function AllianceBuildListSingle:ctor()
	self.tableSingle, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.buildClass = nil
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	SoraDGetAllChildFromWidget(self, self)
	self.Panel_build:setSwallowTouches(false)
	self.Panel_touch:setSwallowTouches(false)
	self.Node_des:setVisible(false)
	self.desH = 100
	local posX = self.Text_build:getPositionX()
	self.Text_build:setPositionX(SoraDFIsRA() and posX - 15 or posX + 15)
	local sprite = SoraDCreatAnimation("chuizigx")
	sprite:setScale(0.4)
	sprite:addTo(self.Text_build:getParent(), 2)
	sprite:setPosition(SoraDFIsRA() and posX + 10 or posX - 10, 20)
	sprite:setVisible(false)
	self.buildingSp = sprite
	if self.Panel_touch then
		self.Panel_touch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.updateData))
end
function AllianceBuildListSingle:updateData(target, data)
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		self.tableSingleData = allianceTerritoryAPI:getAllianceMainBuildingInfo()
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		self.tableSingleData = allianceBuild:getBuildingList()
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		_ENV = self.buildClass
		self.tableSingleData, self.buildClass[1] = self.buildClass, allianceTerritoryAPI:getAllianceFlagInfo()
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		_ENV = self.buildClass
		self.tableSingleData, self.buildClass[1] = self.buildClass, allianceTerritoryAPI:getBurningBuildingList()
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		self.tableSingleData = allianceTerritoryAPI:getRecycleBuildings()
	end
	self:updateBuildCount()
	if self.isLaunched then
		self:removeBuild()
		self:createBuild()
		self:initBuild()
		self:refreshNodeDes()
	end
end
function AllianceBuildListSingle:updateBuildCount()
	local str = ""
	local isHaveBuidingInConstruction = false
	self.Text_count:setColor(cc.c3b(255, 210, 138))
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		local buildCount = 0
		for i, v in ipairs(self.tableSingleData) do
			v:update()
			if v.status ~= gAllianceBuildingStatus.NONE and v.status ~= gAllianceBuildingStatus.DESTROY then
				buildCount = buildCount + 1
			end
			if v.status == gAllianceBuildingStatus.BUILDING then
				isHaveBuidingInConstruction = true
			end
		end
		str = tostring(buildCount) .. "/" .. tostring(#self.tableSingleData)
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		local buildCount = 0
		for i, v in ipairs(self.tableSingleData) do
			if v:getBuildingStatus() == gAllianceBuildingStatus.BUILD or v:getBuildingStatus() == gAllianceBuildingStatus.COMPLETE then
				buildCount = buildCount + 1
			end
			if v:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
				isHaveBuidingInConstruction = true
			end
		end
		str = tostring(buildCount) .. "/1"
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		str = tostring(allianceTerritoryAPI:getAllianceFlagCount()) .. "/" .. tostring(allianceTerritoryAPI:getCurrentFlagLimit())
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		local buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
		isHaveBuidingInConstruction = 0 < #buildingFlags
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		str = tostring(allianceTerritoryAPI:getWellDestroyBuildingNum())
		if 0 < allianceTerritoryAPI:getWellDestroyBuildingNum() then
			self.Text_count:setColor(display.COLOR_RED)
		end
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		local buildCount = 0
		for i, v in ipairs(self.tableSingleData) do
			buildCount = buildCount + v.count
		end
		str = tostring(buildCount)
	end
	self.isHaveBuidingInConstruction = isHaveBuidingInConstruction
	self.buildingSp:setVisible(isHaveBuidingInConstruction)
	self.Text_count:setString(str)
end
function AllianceBuildListSingle:initData(buildClass, buildData, spare)
	self.tableSingleData = buildData
	self.buildClass = buildClass
	self.tableSpare = spare
	if self.tableSpare[self.buildClass] == nil then
		self.tableSpare[self.buildClass], _ENV = nil, nil
	end
	self:removeBuild()
	for i, v in ipairs(self.tableSingleData) do
		_ENV = nil
		;(nil).data = v
		;(nil).point = nil
		;(nil).pos = cc.p(0, 0)
		table.insert(self.tableSingle, nil)
	end
	self:updateOtherUI()
	if self.isLaunched then
		self:createBuild()
	end
end
function AllianceBuildListSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeBuild()
		self.Sprite_arr:setRotation(SoraDFPosX(90, 0))
	else
		self:createBuild()
		self.Sprite_arr:setRotation(0)
	end
	self.isLaunched = state
	self:refreshNodeDes()
end
function AllianceBuildListSingle:updateOtherUI()
	self.Text_build:setString(allianceDesRead.getBuildClassName(self.buildClass))
	self:updateBuildCount()
	if self.buildClass == gAllianceBuildUIListType.RECYCLE then
		self.Text_des:setString(i18n("alliance_stronghold_text_080"))
	end
	self:refreshNodeDes()
end
function AllianceBuildListSingle:createBuild()
	local panelH = 0
	if 0 < #self.tableSingleData then
		panelH = self:getBuildShowH()
		self.Panel_build:setContentSize(cc.size(640, panelH))
		self.Panel_build:setVisible(false)
		for i, v in ipairs(self.tableSingleData) do
			if self.tableSingle[i] == nil then
				_ENV = cc.size(640, panelH)
				cc.size(640, panelH).data = v
				cc.size(640, panelH).point = nil
				self.tableSingle[i], cc.size(640, panelH).pos = cc.size(640, panelH)
			end
			self.tableSingle[i].pos = self:getBuildPos(i, panelH)
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
			end
		end
	end
	if 0 < panelH then
		self.Panel_build:setVisible(true)
	end
end
function AllianceBuildListSingle:refreshNodeDes(...)
	if self.buildClass ~= gAllianceBuildUIListType.RECYCLE then
		return
	end
	self.Node_des:setVisible(self.isLaunched)
end
function AllianceBuildListSingle:getBuildShowH()
	local panelH = 0
	local singleH = 350
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		panelH = singleH * math.ceil(#self.tableSingleData / 2)
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		panelH = singleH * math.ceil(#self.tableSingleData / 2)
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
		local buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
		panelH = singleH * math.ceil(#buildingFlags / 2) + 785
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		panelH = 610
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		panelH = singleH * math.ceil(#self.tableSingleData / 2) + self.desH
	end
	return panelH
end
function AllianceBuildListSingle:getBuildPos(index, showH)
	local x, y = 0, 0
	local singleH = 350
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		x = SoraDFPosX(160 + index % 2 * 320)
		y = showH - math.floor((index - 1) / 2) * singleH
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		x = SoraDFPosX(160 + index % 2 * 320)
		y = showH - math.floor((index - 1) / 2) * singleH
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		x = 320
		y = showH
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		x = 320
		y = showH
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		x = SoraDFPosX(160 + index % 2 * 320)
		y = showH - math.floor((index - 1) / 2) * singleH - self.desH
	end
	local tmpPos = self.Panel_build:convertToWorldSpace(cc.p(x, y))
	tmpPos = self.scroll:getInnerContainer():convertToNodeSpace(tmpPos)
	return tmpPos
end
function AllianceBuildListSingle:getBuildClassName()
	local name = ""
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		name = "allianceBuildMainSingle"
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		name = "allianceBuildSingle"
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		name = "allianceBuildFlagNode"
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		name = "allianceBuildStateNode"
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		name = "allianceBuildRecycleSingle"
	end
	return name
end
function AllianceBuildListSingle:initBuild()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local innerH = scrollInner:getContentSize().height
	_ENV = scrollInner
	scrollInner.beginY = math.max(0, offsetY - 2 * scrollH)
	local scrollInner.endY, tableShowH = offsetY + 2 * innerH, scrollInner
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare[self.buildClass], v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if self.tableSpare[self.buildClass] and 0 < #self.tableSpare[self.buildClass] then
				single = table.remove(self.tableSpare[self.buildClass])
				single:setVisible(true)
			else
				single = SoraDCreatePanel(self:getBuildClassName())
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function AllianceBuildListSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createBuild()
		end
		self:initBuild()
	end
end
function AllianceBuildListSingle:removeBuild()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare[self.buildClass], v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.Panel_build:setVisible(false)
	self.Panel_build:setContentSize(cc.size(640, 0))
	self.Node_des:setVisible(false)
end
function AllianceBuildListSingle:getSingleH()
	return self.Panel_touch:getContentSize().height + self.Panel_build:getContentSize().height
end
function AllianceBuildListSingle:getLaunched()
	return self.isLaunched
end
function AllianceBuildListSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceBuildListSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if button and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:setState(not self.isLaunched)
		if self.handl then
			self.handl(self.buildClass, self.isLaunched)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceBuildListSingle

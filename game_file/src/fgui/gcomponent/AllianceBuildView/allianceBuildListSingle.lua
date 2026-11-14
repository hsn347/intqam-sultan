local allianceDesRead = include("allianceDesRead")
local allianceBuild = SoraDGetCtrl("allianceBuild")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildListSingle", allianceBuildListSingle)
function allianceBuildListSingle:onInit()
	self.tableSingle, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.buildClass = nil
	self.handl = nil
	self.scroll = nil
	self.fields.Node_des:setVisible(false)
	self.desH = 100
	if self.fields.Panel_touch then
		self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	end
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Sprite_arr:fix()
	end
end
function allianceBuildListSingle:onShow()
end
function allianceBuildListSingle:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.updateData))
end
function allianceBuildListSingle:updateData(target, data)
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
function allianceBuildListSingle:updateBuildCount()
	local str = ""
	local isHaveBuidingInConstruction = false
	self.fields.Text_count:setColor(cc.c3b(255, 210, 138))
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
		local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
		local buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
		isHaveBuidingInConstruction = 0 < #buildingFlags
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		str = tostring(allianceTerritoryAPI:getWellDestroyBuildingNum())
		if 0 < allianceTerritoryAPI:getWellDestroyBuildingNum() then
			self.fields.Text_count:setColor(display.COLOR_RED)
		end
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		local buildCount = 0
		for i, v in ipairs(self.tableSingleData) do
			buildCount = buildCount + v.count
		end
		str = tostring(buildCount)
	end
	self.isHaveBuidingInConstruction = isHaveBuidingInConstruction
	self.fields.buildingSp:setVisible(isHaveBuidingInConstruction)
	self.fields.Text_count:setString(str)
end
function allianceBuildListSingle:initData(buildClass, buildData, spare)
	self.buildClass = buildClass
	self.tableSingleData = buildData
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
function allianceBuildListSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeBuild()
		self.fields.Sprite_arr:setRotation(SoraDFPosX(90, 0))
	else
		self:createBuild()
		self.fields.Sprite_arr:setRotation(0)
	end
	self.isLaunched = state
	self:refreshNodeDes()
end
function allianceBuildListSingle:updateOtherUI()
	self.fields.Text_build:setString(allianceDesRead.getBuildClassName(self.buildClass))
	self:updateBuildCount()
	if self.buildClass == gAllianceBuildUIListType.RECYCLE then
		self.fields.Text_des:setString(i18n("alliance_stronghold_text_080"))
	end
	self:refreshNodeDes()
end
function allianceBuildListSingle:createBuild()
	local panelH = 0
	if 0 < #self.tableSingleData then
		panelH = self:getBuildShowH()
		self.fields.Panel_build:setContentSize(cc.size(640, panelH))
		self.fields.Panel_build:setVisible(false)
		for i, v in ipairs(self.tableSingleData) do
			if self.tableSingle[i] == nil then
				_ENV = cc.size(640, panelH)
				cc.size(640, panelH).data = v
				cc.size(640, panelH).point = nil
				self.tableSingle[i], cc.size(640, panelH).pos = cc.size(640, panelH)
			end
			self.tableSingle[i].pos = self:getBuildPos(i, 0)
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
			end
		end
	end
	if 0 < panelH then
		self.fields.Panel_build:setVisible(true)
	end
end
function allianceBuildListSingle:refreshNodeDes(...)
	if self.buildClass ~= gAllianceBuildUIListType.RECYCLE then
		return
	end
	self.fields.Node_des:setVisible(self.isLaunched)
	if self.isLaunched then
		self:setSize(self:getWidth(), 162)
	else
		self:setSize(self:getWidth(), 62)
	end
end
function allianceBuildListSingle:getBuildShowH()
	local panelH = 0
	local singleH = 350
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		panelH = singleH * math.ceil(#self.tableSingleData / 2)
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		panelH = singleH * math.ceil(#self.tableSingleData / 2)
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
		local buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
		panelH = singleH * math.ceil(#buildingFlags / 2) + 764
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		panelH = 610
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		panelH = singleH * math.ceil(#self.tableSingleData / 2) + self.desH
	end
	return panelH
end
function allianceBuildListSingle:getBuildPos(index, showH)
	local x, y = 0, 0
	local singleH = 350
	if self.buildClass == gAllianceBuildUIListType.MAIN_BUILD then
		x = SoraDFPosX(160 + index % 2 * 320) - 142
		y = math.floor((index - 1) / 2) * singleH
	elseif self.buildClass == gAllianceBuildUIListType.RESOURCE then
		x = SoraDFPosX(160 + index % 2 * 320) - 142
		y = math.floor((index - 1) / 2) * singleH
	elseif self.buildClass == gAllianceBuildUIListType.FLAG then
		x = 0
		y = showH
	elseif self.buildClass == gAllianceBuildUIListType.STATE then
		x = 0
		y = showH
	elseif self.buildClass == gAllianceBuildUIListType.RECYCLE then
		x = SoraDFPosX(160 + index % 2 * 320) - 142
		y = math.floor((index - 1) / 2) * singleH + self.desH
	end
	local posy = self:getPositionY() + self.fields.Panel_build:getPositionY() + y
	return cc.p(x, posy)
end
function allianceBuildListSingle:getBuildClassName()
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
function allianceBuildListSingle:initBuild()
	for i, v in ipairs(self.tableSingle) do
		if not v.point then
			local single
			if self.tableSpare[self.buildClass] and #self.tableSpare[self.buildClass] > 0 then
				single = table.remove(self.tableSpare[self.buildClass])
				single:setVisible(true)
			else
				single = fgui.UIPackage:createObject("AllianceBuildView", self:getBuildClassName())
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function allianceBuildListSingle:updateScrollSingle(updateSize)
	print("==allianceBuildListSingle:updateScrollSingle==", updateSize, #self.tableSingle, self.isLaunched)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createBuild()
		end
		self:initBuild()
	end
end
function allianceBuildListSingle:removeBuild()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			v.point:setPosition(cc.p(0, 0))
			table.insert(self.tableSpare[self.buildClass], v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.fields.Panel_build:setVisible(false)
	self.fields.Panel_build:setContentSize(cc.size(640, 0))
	self.fields.Node_des:setVisible(false)
end
function allianceBuildListSingle:getSingleH()
	return self.fields.Panel_touch:getContentSize().height + self.fields.Panel_build:getContentSize().height
end
function allianceBuildListSingle:getLaunched()
	return self.isLaunched
end
function allianceBuildListSingle:setClickCallBack(handle)
	self.handl = handle
end
function allianceBuildListSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildListSingle:btnClickCallBack()
	SoraDPlaySound()
	self:setState(not self.isLaunched)
	if self.handl then
		self.handl(self.buildClass, self.isLaunched)
	end
end
return allianceBuildListSingle

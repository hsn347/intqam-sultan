local pyramidBuildingRead = include("pyramidBuildingRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local pyramidBattleResOccupyViewPanel = class("pyramidBattleResOccupyViewPanel", baseFguiPanel)
function pyramidBattleResOccupyViewPanel:ctor(...)
	self.isLRU = true
	pyramidBattleResOccupyViewPanel.super.ctor(self, ...)
	print("pyramidBattleResOccupyViewPanel:ctor", self.viewName)
end
function pyramidBattleResOccupyViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WorldMap"
	end
	return self._packageList
end
function pyramidBattleResOccupyViewPanel:onInit()
	print("=======pyramidBattleResOccupyViewPanel:onInit")
	self.fields.Text_pointTip:setString(i18n("pyramid_text_126"))
	self.fields.Text_collectPersonTip:setString(i18n("common_text_2909"))
	self.fields.Text_collectSpeedTip:setString(i18n("common_text_572"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function pyramidBattleResOccupyViewPanel:endShow()
	print("=======pyramidBattleResOccupyViewPanel:endShow")
	local reData = self.param and self.param.initData
	if reData then
		self:initData(reData)
	end
end
function pyramidBattleResOccupyViewPanel:initData(reData)
	if not reData.occupyData then
		local _ENV, occupyData = reData.occupyData, reData.occupyData
	end
	local buildType = occupyData.buildType or 0
	local buildID = occupyData.buildID or 0
	local resName = worldMapDefine.getPyramidbuildingName(buildType, buildID)
	local posX = reData.resPos.x
	local posY = reData.resPos.y
	_ENV = nil
	;(nil).name = resName
	;(nil).posX = posX
	;(nil).posY = posY
	self.fields.Panel_bg:setString(i18n("pyramid_text_124", nil))
	local resImage = worldMapDefine.getPyramidbuildingImage(buildType)
	self.fields.Image_res:setURL(resImage)
	if not reData.tipButtonData then
		local _ENV, tipButtonData = reData.tipButtonData, reData.tipButtonData
	end
	local resCount = tipButtonData.resCount or 0
	_ENV = resCount
	resCount.color = "#FFEBB9"
	local pointStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(resCount), resCount)
	_ENV = i18n("pyramid_text_124", nil)
	i18n("pyramid_text_124", nil).num = pointStr
	self.fields.Text_point:setString(i18n("pyramid_text_125", i18n("pyramid_text_124", nil)))
	local occupyTime = pyramidBuildingRead.getOccupyTime(buildID)
	local point = pyramidBuildingRead.getContinueCaptainPoints(buildID)
	_ENV = i18n("pyramid_text_125", i18n("pyramid_text_124", nil))
	i18n("pyramid_text_125", i18n("pyramid_text_124", nil)).time = occupyTime
	i18n("pyramid_text_125", i18n("pyramid_text_124", nil)).point = point
	self.fields.Text_collectSpeed:setString(i18n("pyramid_text_127", i18n("pyramid_text_125", i18n("pyramid_text_124", nil))))
	local leagueID = occupyData.leagueID or 0
	if leagueID ~= 0 then
		local playerName = occupyData.playerName
		local leagueName = occupyData.leagueName
		local nameStr = textParser.formatPlayerName(leagueName, playerName)
		self.fields.Text_collectPerson:setString(nameStr)
		local playerID = occupyData.playerID or 0
		if playerID == SoraDGetPlayerID() then
			if not tipButtonData.army then
				local _ENV, army = tipButtonData.army, tipButtonData.army
			end
			if not army[1] or not army[1].armyList then
				_ENV = army[1].armyList
			end
			self.armyList = army[1].armyList
			local totalArmyCount = 0
			for i, v in ipairs(self.armyList) do
				totalArmyCount = totalArmyCount + v.num
			end
			local armyCountStr = string.formatnumberthousands(totalArmyCount)
			_ENV = v.num
			v.num.count = armyCountStr
			self.fields.Label_title:setString(i18n("common_text_466", v.num))
			self.fields.List:setNumItems(#self.armyList)
		else
			_ENV = self.fields.List
			self.fields.List.count = "???"
			self.fields.Label_title:setString(i18n("common_text_466", self.fields.List))
			self.fields.List:setNumItems(0)
		end
	else
		self.fields.Text_collectPerson:setString(i18n("common_text_480"))
		self.fields.Label_title:setString(i18n("common_text_2911"))
		self.fields.List:setNumItems(0)
	end
end
function pyramidBattleResOccupyViewPanel:onItemRenderer(index, obj)
	local armyData = self.armyList[index + 1]
	obj:initData(armyData)
end
return pyramidBattleResOccupyViewPanel

local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local constantRead = include("constantRead")
local allianceDesRead = include("allianceDesRead")
local changeTerritoryColorNode = class("changeTerritoryColorNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeTerritoryColorNode")
	end
	return target
end)
function changeTerritoryColorNode:ctor()
	self.singleList, allianceMgr = nil, nil
	local alliance = allianceMgr:getAlliance()
	self.isTerritoryColorSet = alliance:getProperty("isTerritoryColorSet")
	self.territoryColorId = alliance:getProperty("territoryColorId") or 0
	self.selectIndex = 0
	self.cost = constantRead.getConstValue("ALLIANCE_TERRITORY_COLOR_COST", 1000)
	self:initWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateView))
end
function changeTerritoryColorNode:updateView()
	SoraDCloseLoading(self)
	if self.selectIndex > 0 then
		local selectSingle = self.singleList[self.selectIndex]
		selectSingle.Sprite_select:setVisible(false)
		self.selectIndex = 0
	end
	if 0 < self.territoryColorId then
		local selectSingle = self.singleList[self.territoryColorId]
		selectSingle.Sprite_cur:setVisible(false)
	end
	local alliance = allianceMgr:getAlliance()
	self.territoryColorId = alliance:getProperty("territoryColorId") or 0
	if 0 < self.territoryColorId then
		local selectSingle = self.singleList[self.territoryColorId]
		selectSingle.Sprite_cur:setVisible(true)
	end
	self.isTerritoryColorSet = alliance:getProperty("isTerritoryColorSet")
	if self.isTerritoryColorSet then
		_ENV = "isTerritoryColorSet"
		;("isTerritoryColorSet").title = i18n("common_text_243")
		;("isTerritoryColorSet").gold = self.cost
		self.btnChange:initData("isTerritoryColorSet", 1)
		self.btnChange:checkEnoughGold(self.cost)
	end
end
function changeTerritoryColorNode:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Node_single:setVisible(false)
	self.Node_flag:setLocalZOrder(1)
	self.btnChange = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_change")
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	if not self.isTerritoryColorSet then
		_ENV = handler(self, self.btnChangeClickCallBack)
		handler(self, self.btnChangeClickCallBack).text = i18n("common_text_049")
		self.btnChange:initData(handler(self, self.btnChangeClickCallBack))
	else
		_ENV = handler(self, self.btnChangeClickCallBack)
		handler(self, self.btnChangeClickCallBack).title = i18n("common_text_243")
		handler(self, self.btnChangeClickCallBack).gold = self.cost
		self.btnChange:initData(handler(self, self.btnChangeClickCallBack))
		self.btnChange:checkEnoughGold(self.cost)
	end
end
function changeTerritoryColorNode:initData()
	self.Text_preview:setString(i18n("alliance_landSet_003"))
	self.Text_color:setString(i18n("alliance_landSet_004"))
	self.Text_tip:setString(i18n("alliance_landSet_007"))
	for i, v in ipairs(allianceDesRead.landcolor) do
		local color = v.color
		local single = self.Node_single:clone()
		single:setVisible(true)
		single:addTo(self.Node_colors)
		local row = math.ceil(i / 4)
		local col = i - (row - 1) * 4
		single:setPosition((col - 2.5) * 68, -10 - 65 * (row - 1))
		SoraDGetAllChildFromWidget(single, single)
		single.Panel_color:setColor(cc.c3b(color[1] * 255, color[2] * 255, color[3] * 255))
		single.Panel_color:setTag(i)
		single.Panel_color = SoraDCreatePanelByCloneNode(single.Panel_color, "commonBtnInstance")
		single.Panel_color:setHandle(handler(self, self.btnSelectCallBack))
		single.Panel_color:setSwallowTouches(false)
		single.Sprite_select:setVisible(false)
		single.Sprite_cur:setVisible(i == self.territoryColorId)
		table.insert(self.singleList, single)
	end
	local tilesRolygon = include("worldMapTilesRolygon").new(3)
	local rolygonColor
	if self.territoryColorId > 0 then
		rolygonColor = allianceDesRead.getTerritoryColor(self.territoryColorId)
	else
		rolygonColor = worldMapDefine.getLeagueManorLineColor(true)
	end
	tilesRolygon:setRolygonColor(rolygonColor)
	tilesRolygon:addTo(self.Node_preview)
	tilesRolygon:setScale(0.3)
	tilesRolygon:setPosition(0, -168)
	self.tilesRolygon = tilesRolygon
end
function changeTerritoryColorNode:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.selectIndex == 0 or self.selectIndex == self.territoryColorId then
			SoraDShowMsgTip(i18n("alliance_landSet_008"))
			return
		end
		if self.isTerritoryColorSet and not SoraDEnoughGold(self.cost, true) then
			SoraDShowMsgTip(i18n("alliance_landSet_006"))
			return
		end
		local msg = ""
		if not self.isTerritoryColorSet then
			msg = i18n("alliance_landSet_009")
		else
			_ENV = i18n("alliance_landSet_006")
			i18n("alliance_landSet_006").num = string.formatnumberthousands(self.cost)
			msg = i18n("alliance_landSet_005", i18n("alliance_landSet_006"))
		end
		SoraDShowMsgBox(msg, nil, nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				allianceTerritoryCtrl:modifyTerritoryColor(self.selectIndex)
			end
		end)
	end
end
function changeTerritoryColorNode:btnSelectCallBack(button, type)
	SoraDPlaySound()
	self.selectIndex = button:getTag()
	for i, v in ipairs(self.singleList) do
		v.Sprite_select:setVisible(i == self.selectIndex)
	end
	local rolygonColor = allianceDesRead.getTerritoryColor(self.selectIndex)
	self.tilesRolygon:changeRolygonColor(rolygonColor)
end
function changeTerritoryColorNode:getSingleH()
	return 510
end
return changeTerritoryColorNode

local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local constantRead = include("constantRead")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local changeTerritoryColorNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeTerritoryColorNode", changeTerritoryColorNode)
function changeTerritoryColorNode:onInit()
	self.landcolorList, allianceMgr = nil, nil
	local alliance = allianceMgr:getAlliance()
	self.isTerritoryColorSet = alliance:getProperty("isTerritoryColorSet")
	self.territoryColorId = alliance:getProperty("territoryColorId") or 0
	self.selectIndex = 0
	self.cost = constantRead.getConstValue("ALLIANCE_TERRITORY_COLOR_COST", 1000)
	self.fields.icon_flag:setSpriteFrame(allianceDesRead.getFlagIcon())
	self.fields.Text_preview:setString(i18n("alliance_landSet_003"))
	self.fields.Text_color:setString(i18n("alliance_landSet_004"))
	self.fields.Text_tip:setString(i18n("alliance_landSet_007"))
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:addClickListener(handler(self, self.btnChangeClickCallBack))
	self.fields.Button_free:setString(i18n("common_text_049"))
	self.fields.Button_free:addClickListener(handler(self, self.btnChangeClickCallBack))
	self:setBtnChange()
	self.fields.List_color:setItemRenderer(handler(self, self.onColorRenderer))
	self:fixChildrenPos()
end
function changeTerritoryColorNode:onColorRenderer(index, obj)
	obj:initData(self.landcolorList[index + 1], self.selectIndex, self.territoryColorId)
end
function changeTerritoryColorNode:setBtnChange()
	if not self.isTerritoryColorSet then
		self.fields.Button_change:setVisible(false)
		self.fields.Button_free:setVisible(true)
	else
		self.fields.Button_change:setCostNum(self.cost, SoraDGetGold())
		self.fields.Button_change:setVisible(true)
		self.fields.Button_free:setVisible(false)
	end
end
function changeTerritoryColorNode:onShow()
end
function changeTerritoryColorNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_COLOR_SELECT", handler(self, self.colorSelect))
end
function changeTerritoryColorNode:colorSelect(target, data)
	self.selectIndex = data.index
	self.fields.List_color:setNumItems(#self.landcolorList)
	local rolygonColor = self.selectIndex > 0 and allianceDesRead.getTerritoryColor(self.selectIndex) or worldMapDefine.getLeagueManorLineColor(true)
	self.rolygon:changeRolygonColor(rolygonColor)
end
function changeTerritoryColorNode:updateView()
	SoraDCloseLoading(self)
	self.selectIndex = 0
	local alliance = allianceMgr:getAlliance()
	self.territoryColorId = alliance:getProperty("territoryColorId") or 0
	self.fields.List_color:setNumItems(#self.landcolorList)
	self.isTerritoryColorSet = alliance:getProperty("isTerritoryColorSet")
	self:setBtnChange()
	self:setPreRolygonColor()
end
function changeTerritoryColorNode:setPreRolygonColor(preColorID)
	local colorID = preColorID or self.territoryColorId
	local rolygonColor = 0 < colorID and allianceDesRead.getTerritoryColor(colorID) or worldMapDefine.getLeagueManorLineColor(true)
	self.fields.Csd_rolygon:clearContent()
	local rolygon = include("worldMapTilesRolygon").new(3)
	rolygon:setPosition(self.fields.Csd_rolygon:getWidth() / 2, self.fields.Csd_rolygon:getHeight() / 2)
	rolygon:setScale(0.3)
	rolygon:setRolygonColor(rolygonColor)
	self.fields.Csd_rolygon:setContent(rolygon)
	self.rolygon = rolygon
end
function changeTerritoryColorNode:initData()
	self.landcolorList = allianceDesRead.landcolor
	self.fields.List_color:setNumItems(#self.landcolorList)
	self:setPreRolygonColor()
end
function changeTerritoryColorNode:btnChangeClickCallBack()
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
return changeTerritoryColorNode

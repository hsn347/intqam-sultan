local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceTerritoryCtrl = SoraDGetCtrl("allianceTerritoryCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildFlagNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildFlagNode", allianceBuildFlagNode)
_ENV = fgui.register_extension
fgui.register_extension[1] = "icon_ranking_1.png"
fgui.register_extension[2] = "icon_ranking_2.png"
local fgui.register_extension[3], flagConfig = "icon_ranking_3.png", fgui.register_extension
function allianceBuildFlagNode:onInit()
	self.buildingArray, _ENV, self.tableSpare, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil, nil, nil
	self.scroll = nil
	self.fields.Button_build:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.Button_build:setString(i18n("common_text_042"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_count:setString(i18n("common_text_3004"))
	self.fields.Text_member:setString(i18n("common_text_188"))
	self.scrollMember = self.fields.ScrollView_member
	self.scrollMember:setScrollEnable(false)
	self.scrollMember:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.fields.Text_rank:fixPos()
		self.fields.Text_count:fixPos()
		self.fields.Text_member:fixPos()
	end
end
function allianceBuildFlagNode:onShow()
end
function allianceBuildFlagNode:initData(data)
	if allianceTerritoryAPI:checkIsRecycleBuilding(gAllianceBuilding.FLAG) then
		self.fields.Button_build:setVisible(false)
		self.fields.Text_flagDes:setString(i18n("alliance_stronghold_text_084"))
	else
		self.fields.Button_build:setVisible(true)
		local size = 1.0
		local radioation = 1.0
		local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(gAllianceBuilding.FLAG)
		if allianceBuildInfo then
			size = allianceBuildInfo.size
			radioation = allianceBuildInfo.radioation
		end
		size = size + 2 * radioation
		size = size * size
		allianceTerritoryAPI = i18n("alliance_stronghold_text_084")
		i18n("alliance_stronghold_text_084").build = i18n("common_text_2903")
		i18n("alliance_stronghold_text_084").count = size
		self.fields.Text_flagDes:setString(i18n("common_text_3005", i18n("alliance_stronghold_text_084")))
	end
	allianceTerritoryAPI = self.fields.Text_flagDes
	self.fields.Text_flagDes.count = string.formatnumberthousands(allianceTerritoryAPI:getAllianceFlagCount())
	self.fields.Text_flagCur:setString(i18n("common_text_2989", self.fields.Text_flagDes))
	self.tableSingleData = data
	self.buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
	table.sort(self.buildingFlags, function(a, b)
		return a.createTime < b.createTime
	end)
	for k, v in ipairs(self.buildingArray) do
		v:setVisible(false)
	end
	local bHeight = math.ceil(#self.buildingFlags / 2) * 350
	for k, v in ipairs(self.buildingFlags) do
		if self.buildingArray[k] then
			self.buildingArray[k]:setVisible(true)
		else
			self.buildingArray[k] = fgui.UIPackage:createObject("AllianceBuildView", "allianceBuildMainSingle")
			self.buildingArray[k]:addTo(self.fields.Node_building)
		end
		self.buildingArray[k]:setScroll(self.scroll)
		local h = k % 2
		local l = math.ceil(k / 2)
		self.buildingArray[k]:setPosition(SoraDFPosX(h * 320 - 302, 0), l * 350 - 350)
		self.buildingArray[k]:initData(v)
	end
	self.fields.Node_base:setPositionY(bHeight)
	self:initScroll()
end
function allianceBuildFlagNode:initScroll()
	self.scrollMember:setNumItems(#self.tableSingleData)
	local innerH = self.scrollMember:getInnerContainerSize().height
	local scrollH = self.scrollMember:getContentSize().height
	self.scrollMember:setScrollEnable(innerH > scrollH)
end
function allianceBuildFlagNode:onItemRenderer(index, obj)
	local data = self.tableSingleData[index + 1]
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	local rank = index + 1
	_fields.Text_rank:setString(tostring(rank))
	if rank <= 3 then
		_fields.icon_qz:setURL(flagConfig[rank])
		_fields.icon_qz:setVisible(true)
		_fields.Text_rank:setVisible(false)
		_fields.n17:setVisible(false)
	else
		_fields.icon_qz:setVisible(false)
		_fields.Text_rank:setVisible(true)
		_fields.n17:setVisible(true)
	end
	_fields.Text_name:setString(data.nickname)
	_fields.Text_count:setString(tostring(data.count))
end
function allianceBuildFlagNode:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildFlagNode:getAlliancePlacePos()
	local pos
	local buildPosData = allianceTerritoryAPI:getAllBuildingPos()
	for i, v in ipairs(buildPosData) do
		if v.bid == gAllianceBuilding.PALACE then
			pos = v.pos
			break
		end
	end
	return pos
end
function allianceBuildFlagNode:btnClickCallBack(button, type)
	SoraDPlaySound()
	local curCount = allianceTerritoryAPI:getAllianceFlagCount()
	_ENV = nil
	;(nil).rank = "R4"
	if not allianceDesRead.checkRank(gAllianceRank.R4, true, i18n("common_text_3011", nil)) then
		return
	end
	if curCount >= allianceTerritoryAPI:getFlagLimit() then
		SoraDShowMsgTip(i18n("common_text_3003"))
	elseif curCount >= allianceTerritoryAPI:getCurrentFlagLimit() then
		SoraDShowMsgTip(i18n("common_text_3002"))
	elseif not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PRIMARY_PALACE) then
		SoraDShowMsgTip(i18n("common_text_3065"))
	elseif #self.buildingFlags >= include("constantRead").getConstValue("MAX_IN_BUILDING_FLAG_COUNT", 4) then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_095"))
	else
		local _ENV, pos = SoraDShowMsgTip, SoraDShowMsgTip
		local proxy = uiManager:getProxy("AllianceBuildView")
		if proxy then
			pos = proxy:getParam().buildMovePos
		end
		if table.nums(pos) <= 0 then
			local currentScene = display.getRunningScene()
			if currentScene.name == "MainScene" then
				local currentView = currentScene:currentSceneShowView()
				if currentView.__cname == "worldMapView" then
					pos = currentView:getDisplayCenterTilePoint()
				else
					local jumpPos = allianceMgr:getLeaderPos()
					if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
						SoraDShowMsgTip(i18n("common_text_3065"), nil, button)
						return
					end
					pos = jumpPos
				end
			end
		end
		_ENV = nil
		;(nil).buildClassID = gAllianceBuilding.FLAG
		;(nil).leagueFlag = allianceMgr:getAllianceProperty("flag")
		SoraDGotoWorldMapPoint(pos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceManor, nil)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
return allianceBuildFlagNode

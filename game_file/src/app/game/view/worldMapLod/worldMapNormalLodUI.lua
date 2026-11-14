local gametop = gModuleMgr.getObject("gametop")
local worldLodDef = worldMapDefine.worldLodDef
local worldMapViewDef = include("worldMapViewDef")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local nationalFlagRead = include("nationalFlagRead")
local worldMapNormalLodUI = class("worldMapNormalLodUI", function()
	return SoraDCreateBasePanel("worldMapNormalLodUI")
end)
function worldMapNormalLodUI:ctor()
	_UPVALUE0_, self.lodNodeList, _UPVALUE0_ = nil, nil, nil
	;(nil).x = 600
	self.coordinate, (nil).y = nil, 604
	self:initWidget()
end
function worldMapNormalLodUI:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_CHANGE", handler(self, self.updateKingdomLv))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initKingdomInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.initKingdomInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", handler(self, self.initKingdomInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", function(target, data)
		if worldMapDefine.curSelectNodeInfo == worldMapViewDef.NODEINFO_TYPE_ALLIANCE then
			self:updateNodeInfo(worldMapViewDef.NODEINFO_TYPE_MANORLINE)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		if worldMapDefine.curSelectNodeInfo == worldMapViewDef.NODEINFO_TYPE_ALLIANCE then
			self:updateNodeInfo(worldMapViewDef.NODEINFO_TYPE_MANORLINE)
		end
	end)
end
function worldMapNormalLodUI:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Text_protect_time:enableOutline(cc.c3b(0, 0, 0), 1)
	self.Text_protect:enableOutline(cc.c3b(0, 0, 0), 1)
	self.lodMap = include("worldMapComLodMap").new(self.Panel_info)
	self.Button_worldSever:addTouchEventListener(handler(self, self.buttonWorldSeverCall))
	self:initNodeInfo()
	self.Text_protect_time = SoraDCreateTimerLabel(self, self.Text_protect_time)
	self.Text_kingdomlv:addTouchEventListener(handler(self, self.onCoordinate))
	self:initKingdomInfo()
	self.Top_Node_kingdomInfo:setPositionY(display.height)
end
function worldMapNormalLodUI:initLodConfig(...)
	local _ENV, config
	_ENV = nil
	;(nil).widget = self.lodMap
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).showLodMax = worldLodDef.LOD5
	;(nil).offset = cc.p(SoraDFSign(200), 0)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.Top_Node_kingdomInfo
	;(nil).showLodMin = worldLodDef.LOD6
	;(nil).offset = cc.p(0, 120)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.Node_mapInfo
	;(nil).showLodMin = worldLodDef.LOD4
	;(nil).offset = cc.p(SoraDFSign(-120), 0)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.Button_worldSever
	;(nil).showLodMin = worldLodDef.LOD4
	;(nil).offset = cc.p(SoraDFSign(110), 0)
	table.insert(config, nil)
	for i, v in ipairs(config) do
		if v.widget then
			local widget = SoraDCreatePanelByCloneNode(v.widget, "commonLODInstance")
			widget:initLODData(v)
			table.insert(self.lodNodeList, widget)
		end
	end
end
function worldMapNormalLodUI:initNodeInfo(...)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("common_text_4581")
	_ENV, _UPVALUE3_, (nil).height = "common_text_4581", i18n("common_text_4581"), 80
	;("common_text_4581").icon = "frame_wjsf_ld_dd.png"
	_ENV, ("common_text_4581").name = i18n("common_text_3078"), i18n("common_text_3078")
	i18n("common_text_3078").icon = "frame_wjsf_ld_tm.png"
	_ENV, i18n("common_text_3078").name = i18n("common_text_3076"), i18n("common_text_3076")
	i18n("common_text_3076").icon = "frame_wjsf_ld_ym.png"
	i18n("common_text_3076").name = i18n("common_text_3077")
	_ENV, (nil)[1], (nil).content, i18n("common_text_4581")[1] = nil, nil, i18n("common_text_4581"), "common_text_4581"
	_ENV, (nil)[1], (nil).content, i18n("common_text_4581")[2] = nil, nil, i18n("common_text_4581"), i18n("common_text_3078")
	_ENV, (nil)[1], (nil).content, i18n("common_text_4581")[3] = nil, nil, i18n("common_text_4581"), i18n("common_text_3076")
	;(nil).title = i18n("common_text_123")
	_ENV, _UPVALUE6_, (nil).height = "common_text_123", i18n("common_text_123"), 40
	;("common_text_123").icon = "frame_wjsf_zy1.png"
	_ENV = i18n("common_text_3077")
	i18n("common_text_3077").lv = 1
	_ENV, ("common_text_123").name = i18n("common_text_100", (i18n("common_text_3077"))), i18n("common_text_100", (i18n("common_text_3077")))
	i18n("common_text_100", (i18n("common_text_3077"))).icon = "frame_wjsf_zy2.png"
	_ENV = "common_text_3077"
	;("common_text_3077").lv = 2
	_ENV, i18n("common_text_100", (i18n("common_text_3077"))).name = i18n("common_text_100", "common_text_3077"), i18n("common_text_100", "common_text_3077")
	i18n("common_text_100", "common_text_3077").icon = "frame_wjsf_zy3.png"
	_ENV = nil
	;(nil).lv = 3
	_ENV, i18n("common_text_100", "common_text_3077").name = i18n("common_text_100", nil), i18n("common_text_100", nil)
	i18n("common_text_100", nil).icon = "frame_wjsf_zy4.png"
	_ENV = nil
	;(nil).lv = 4
	_ENV, i18n("common_text_100", nil).name = i18n("common_text_100", nil), i18n("common_text_100", nil)
	i18n("common_text_100", nil).icon = "frame_wjsf_zy5.png"
	_ENV = nil
	;(nil).lv = 5
	_ENV, i18n("common_text_100", nil).name = i18n("common_text_100", nil), i18n("common_text_100", nil)
	i18n("common_text_100", nil).icon = "frame_wjsf_zy6.png"
	_ENV = nil
	;(nil).lv = 6
	i18n("common_text_100", nil).name = i18n("common_text_100", nil)
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[1] = nil, nil, i18n("common_text_123"), "common_text_123"
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[2] = nil, nil, i18n("common_text_123"), i18n("common_text_100", (i18n("common_text_3077")))
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[3] = nil, nil, i18n("common_text_123"), i18n("common_text_100", "common_text_3077")
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[4] = nil, nil, i18n("common_text_123"), i18n("common_text_100", nil)
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[5] = nil, nil, i18n("common_text_123"), i18n("common_text_100", nil)
	_ENV, (nil)[2], (nil).content, i18n("common_text_123")[6] = nil, nil, i18n("common_text_123"), i18n("common_text_100", nil)
	;(nil).title = i18n("common_text_069")
	_ENV, _UPVALUE3_, (nil).height = "common_text_069", i18n("common_text_069"), 62
	;("common_text_069").icon = "lod_base_blue.png"
	_ENV, ("common_text_069").name = i18n("common_text_188"), i18n("common_text_188")
	i18n("common_text_188").icon = "lod_base_purple.png"
	_ENV, i18n("common_text_188").name = i18n("common_text_526"), i18n("common_text_526")
	i18n("common_text_526").icon = "lod_base_green.png"
	i18n("common_text_526").name = i18n("common_text_142")
	;(nil)[3], (nil).content, i18n("common_text_069")[1] = nil, i18n("common_text_069"), "common_text_069"
	;(nil)[3], (nil).content, i18n("common_text_069")[2] = nil, i18n("common_text_069"), i18n("common_text_188")
	;(nil)[3], (nil).content, i18n("common_text_069")[3] = nil, i18n("common_text_069"), i18n("common_text_526")
	local config
	self.Node_info_Single:setVisible(false)
	for i, data in ipairs(config) do
		local Node_select = self["Node_select" .. i]
		SoraDGetChildByName(Node_select, "Text_select"):setString(data.title)
		local Button_select = SoraDGetChildByName(Node_select, "Button_select")
		Button_select:setTag(i)
		Button_select:addTouchEventListener(handler(self, self.onClickBtnSelect))
		local count = #data.content
		for j, v in ipairs(data.content) do
			local single = self.Node_info_Single:clone()
			single:setVisible(true)
			single:addTo(self["Node_info" .. i])
			single:setPosition(0, ((count + 1) / 2 - j) * data.height)
			local Sprite_info = SoraDGetChildByName(single, "Sprite_info")
			Sprite_info:setSpriteFrame(v.icon)
			if data.autoScale then
				Sprite_info:setScale(45 / Sprite_info:getContentSize().height)
			end
			local Text_info = SoraDGetChildByName(single, "Text_info")
			Text_info:setString(v.name)
		end
	end
end
function worldMapNormalLodUI:initKingdomInfo(...)
	local mapKindomID = worldMapDefine.currentMapKindomID
	local isK, kingdomInfo = kingdomCtrl:isFoundKingdomID(mapKindomID)
	local kingdomName = i18n("common_text_479") .. "#0"
	local kingName, flagId
	if isK then
		kingdomName = kingdomInfo.kname
		kingName = kingdomInfo.uname
		flagId = kingdomInfo.flagid
	end
	worldMapDefine.currentKingdomKing = kingName
	if flagId then
		local flagImg = nationalFlagRead.getImgByID(flagId)
		if flagImg then
			self.Sprite_kingdomFlag:setSpriteFrame(flagImg)
		else
			self.Sprite_kingdomFlag:setVisible(false)
		end
	end
	self.Text_kingDomName:setString(kingdomName)
	self:updateKingdomLv()
	if worldMapDefine.currentKingdomKing then
		self.Image_king_bg:setVisible(true)
		_ENV = nil
		;(nil).kingName = worldMapDefine.currentKingdomKing
		self.Text_kingName:setString(i18n("common_text_529", nil))
		local bg_width = self.Image_king_bg:getContentSize().width
		nationalFlagRead = i18n("common_text_529", nil)
		i18n("common_text_529", nil)[1] = self.Text_protect
		i18n("common_text_529", nil)[2] = self.Text_protect_time
		SoraDToCenterEx(i18n("common_text_529", nil))
		nationalFlagRead = i18n("common_text_529", nil)
		i18n("common_text_529", nil)[1] = self.Sprite_kingdomFlag
		i18n("common_text_529", nil)[2] = self.Text_kingName
		SoraDToCenterEx(i18n("common_text_529", nil))
		nationalFlagRead = i18n("common_text_529", nil)
		i18n("common_text_529", nil)[1] = self.Sprite_kingdomFlag
		i18n("common_text_529", nil)[2] = self.Text_kingName
		for i, v in ipairs(i18n("common_text_529", nil)) do
			v:setPositionX(v:getPositionX() + bg_width / 2)
		end
	else
		self.Text_kingName:setString(i18n("common_text_480"))
	end
	local warStatus = kingdomMapCtrl:getWarStatus() or worldMapDefine.kingWarStatus
	local showWarStatusTime = kingdomMapCtrl:isShowWarStatusTime()
	print("warStatus=", warStatus, ",showWarStatusTime=", showWarStatusTime)
	if showWarStatusTime and warStatus then
		kingdomMapCtrl:reqRefreshKingdomWarTime()
		local warTime = kingdomMapCtrl:getWarStatusTime()
		if 0 < warTime then
			self.Image_king_bg:setVisible(false)
			self.Image_protect_bg:setVisible(true)
			self.Text_protect_time:beginTime(warTime)
		else
			self.Image_protect_bg:setVisible(false)
		end
		if warStatus == gKingdomWarStatusType.close then
			self.Image_king_bg:setVisible(false)
			self.Text_protect:setString(i18n("common_text_1215"))
			self.Text_protect:setColor(cc.c3b(0, 200, 0))
		elseif warStatus == gKingdomWarStatusType.inWar then
			self.Image_king_bg:setVisible(worldMapDefine.currentKingdomKing ~= nil)
			self.Text_protect:setString(i18n("common_text_1214"))
			self.Text_protect:setColor(cc.c3b(200, 0, 0))
		elseif warStatus == gKingdomWarStatusType.rule then
			self.Image_king_bg:setVisible(worldMapDefine.currentKingdomKing ~= nil)
			self.Text_protect:setString(i18n("common_text_1213"))
			self.Text_protect:setColor(cc.c3b(0, 200, 0))
		end
		local bg_width = self.Image_protect_bg:getContentSize().width
		nationalFlagRead = cc.c3b(0, 200, 0)
		cc.c3b(0, 200, 0)[1] = self.Text_protect
		cc.c3b(0, 200, 0)[2] = self.Text_protect_time
		SoraDToCenterEx(cc.c3b(0, 200, 0))
		nationalFlagRead = cc.c3b(0, 200, 0)
		cc.c3b(0, 200, 0)[1] = self.Text_protect
		cc.c3b(0, 200, 0)[2] = self.Text_protect_time
		for i, v in ipairs(cc.c3b(0, 200, 0)) do
			v:setPositionX(v:getPositionX() + bg_width / 2)
		end
	else
		self.Image_king_bg:setVisible(false)
		self.Image_protect_bg:setVisible(false)
	end
	if not self:checkInSameKingdomID() then
		self.Image_king_bg:setVisible(false)
		self.Image_protect_bg:setVisible(false)
	end
end
function worldMapNormalLodUI:checkInSameKingdomID(mapKindomID)
	mapKindomID = mapKindomID or worldMapDefine.currentMapKindomID
	return mapKindomID == gametop.playertop_:getMapID()
end
function worldMapNormalLodUI:updateKingdomLv()
	local mapKindomID = worldMapDefine.currentMapKindomID
	local curKingdomLv = kingdomCtrl:getKingdomLevel(mapKindomID)
	if curKingdomLv and 1 <= curKingdomLv then
		_ENV = nil
		;(nil).lv = curKingdomLv
		self.Text_kingdomlv:setString(i18n("common_text_100", nil))
		if self:checkInSameKingdomID() then
			SoraDDrawTextUnderLine(self.Text_kingdomlv, cc.c4b(255, 200, 100, 255), 2)
		else
			SoraDHideTextUnderLine(self.Text_kingdomlv, false)
		end
		self.Text_kingdomlv:setVisible(true)
		SoraDToCenter(self.kingdom_node, 5, SoraDFIsRA())
	else
		self.Text_kingdomlv:setVisible(false)
		SoraDToCenter(self.kingdom_node, 5, SoraDFIsRA())
	end
end
function worldMapNormalLodUI:setWorldMapView(worldMapView)
	self.worldMapView = worldMapView
	self.lodMap:setWorldMapView(worldMapView)
	self:updateNodeInfo(worldMapViewDef.NODEINFO_TYPE_MANORLINE)
end
function worldMapNormalLodUI:updateData(data)
	self.lodMap:updateData(data)
	if data.centerTilePoint then
		local kingdomID = worldMapDefine.currentMapKindomID
		if self.preKingdomID ~= kingdomID then
			self.preKingdomID = kingdomID
			if not self:checkInSameKingdomID() then
				if worldMapDefine.curSelectNodeInfo == worldMapViewDef.NODEINFO_TYPE_ALLIANCE then
					self:updateNodeInfo(worldMapViewDef.NODEINFO_TYPE_MANORLINE)
				end
				self.lodMap:setSpriteSelfVisible(false)
			else
				self.lodMap:setSpriteSelfVisible(true)
			end
			self:initKingdomInfo()
		end
	end
end
function worldMapNormalLodUI:updateMapLod(event)
	for i, node in ipairs(self.lodNodeList) do
		node:updateMapLod(event)
	end
end
function worldMapNormalLodUI:initMapLod(lod)
	for i, node in ipairs(self.lodNodeList) do
		node:initMapLod(lod)
	end
end
function worldMapNormalLodUI:onClickBtnSelect(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	local tag = button:getTag()
	if tag == worldMapViewDef.NODEINFO_TYPE_ALLIANCE then
		if not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("common_text_826"))
			return
		end
		if not permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_POS) then
			_ENV = i18n("common_text_826")
			i18n("common_text_826").des = i18n("common_text_2375")
			SoraDShowMsgTip(i18n("common_text_2371", i18n("common_text_826")))
			return
		end
	end
	self:updateNodeInfo(tag)
	SoraDShowLoading(self.Node_mapInfo, nil, nil, true, 0.1)
end
function worldMapNormalLodUI:updateNodeInfo(index)
	worldMapDefine.curSelectNodeInfo = index
	self.Sprite_select:setPositionY(self["Node_select" .. index]:getPositionY())
	for i = 1, 3 do
		self["Node_info" .. i]:setVisible(i == index)
	end
	_ENV = 3
	;(3).msg = "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE"
	;(3).index = index
	SoraDSendMessage(3)
end
function worldMapNormalLodUI:buttonWorldSeverCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local worldMapCell = self.worldMapView:getCurrentInMapViewCell()
		local kid = worldMapCell:getKingdomID()
		local regionId
		if 0 < kid then
			local __, rId = nebulaActivityCtrl:getKingdomRegionType(kid)
			regionId = rId
		else
			regionId = worldMapCell:getRegionId()
		end
		local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
		_ENV = nil
		;(nil).regionType = regionType
		;(nil).regionId = regionId
		uiManager:show("BigWorldView", nil)
	end
end
function worldMapNormalLodUI:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if not self:checkInSameKingdomID() then
			return
		end
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(self.coordinate)
	end
end
return worldMapNormalLodUI

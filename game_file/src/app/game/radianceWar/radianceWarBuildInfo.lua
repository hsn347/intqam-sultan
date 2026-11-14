local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceWarRead = include("radianceWarRead")
local scrollNode = include("scrollNode")
local radianceWarBuildInfo = class("radianceWarBuildInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("radianceWarBuildInfo")
	end
	return target
end)
function radianceWarBuildInfo:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("brightWar_text_144"))
	self.nodeSingle = SoraDGetChildByName(self, "Image_kingSIngleCopy")
	self.nodeSingle:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.initSingle))
	self.txtTileName = SoraDGetChildByName(self, "Text_title_name")
	self.txtTileName:setString(i18n("common_text_2037"))
	self.txtTileOccupy = SoraDGetChildByName(self, "Text_title_occupy")
	self.txtTileOccupy:setString(i18n("common_text_1426"))
end
function radianceWarBuildInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_BUILD_INFO", handler(self, self.updatePalace))
end
function radianceWarBuildInfo:createSingle()
	local single = self.nodeSingle:clone()
	local labelPower = SoraDGetChildByName(single, "Text_power")
	SoraDChangeTextToHtml(labelPower)
	local frame_rank = SoraDGetChildByName(single, "Panel_touch")
	if frame_rank then
		frame_rank:setSwallowTouches(false)
		scrollNode.new(frame_rank)
		frame_rank:setScroll(self.scroll)
	end
	single:setVisible(true)
	return single
end
local color_self = display.COLOR_GREEN
local color_other = cc.c3b(215, 195, 155)
local color_line = cc.c3b(105, 180, 230)
function radianceWarBuildInfo:initSingle(single, info)
	local labelName = SoraDGetChildByName(single, "Text_name")
	local labelBuildName = SoraDGetChildByName(single, "Text_build_name")
	local labelPower = SoraDGetChildByName(single, "Text_power")
	local frame_rank = SoraDGetChildByName(single, "Panel_touch")
	local node_bg = SoraDGetChildByName(single, "Node_bg")
	local strPos = string.format("%d,%d", info.x or 0, info.y or 0)
	_ENV = nil
	;(nil).u = "true"
	labelPower:setString(SoraDWrapHtmlTagByStyle(strPos, nil))
	local btnSelect = SoraDGetChildByName(single, "Button_select")
	local isSelf = info.buildId == self.argList.siteClassID
	local color = isSelf and color_self or color_other
	if isSelf then
		btnSelect:setVisible(false)
		node_bg:setVisible(true)
		labelPower:setColor(color_self)
	else
		btnSelect:setVisible(true)
		btnSelect:setGrayed(false)
		node_bg:setVisible(false)
		labelPower:setColor(color_line)
	end
	labelBuildName:setString(radianceWarRead.getBuildName(info.mapType, info.buildId))
	labelBuildName:setColor(color)
	frame_rank:addTouchEventListener(function()
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(info, true)
		SoraDRemoveAllPanelFromManager()
	end)
	local textName
	if info.allianceName then
		if info.allianceAbbr then
			_ENV = radianceWarRead.getBuildName(info.mapType, info.buildId)
			radianceWarRead.getBuildName(info.mapType, info.buildId).abbr = info.allianceAbbr
			radianceWarRead.getBuildName(info.mapType, info.buildId).name = info.allianceName
			textName = i18n("common_text_186", radianceWarRead.getBuildName(info.mapType, info.buildId))
		end
		if 0 < info.kid then
			textName = textName .. "#" .. tostring(info.kid)
		end
	else
		textName = i18n("devilvalley_text_21")
	end
	labelName:setString(textName)
	labelName:setColor(color)
	SoraDGetChildByName(single, "Image_Bg"):setVisible(info.index % 2 ~= 0)
end
function radianceWarBuildInfo:updatePalace(target, retdate)
	if retdate.reqdata and retdate.reqdata.buildId == self.argList.siteClassID then
		self:updateData(retdate.retdate)
		SoraDCloseLoading(self)
	end
end
function radianceWarBuildInfo:reqInfo(target, data)
	SoraDShowLoading(self)
	local kingdomID = worldMapDefine.currentMapKindomID
	radianceWarCtrl:reqRadianceWarBuildConnect(kingdomID, self.argList.siteClassID)
end
function radianceWarBuildInfo:initData(mapInstance, argList)
	self.argList = argList
	self.mapInstance = mapInstance
	self:reqInfo()
end
function radianceWarBuildInfo:updateData(data)
	if not data then
		data, _ENV = nil, nil
	end
	local _ENV, buildData
	for i, v in pairs(data) do
		v.mapType = v.mapType or gMapObjTypeDef.mapTypeRadianceWarBeacon
		v.buildId = tonumber(i)
		v.x = v.x - gPointClientPointPlus
		v.y = v.y - gPointClientPointPlus
		table.insert(buildData, v)
	end
	local id = self.argList.siteClassID
	table.sort(buildData, function(l, r)
		local is_self_l = l.buildId == id
		local is_self_r = r.buildId == id
		if is_self_l ~= is_self_r then
			return is_self_l
		end
		return l.buildId < r.buildId
	end)
	for i, v in pairs(buildData) do
		v.index = i
	end
	self.scroll:updateScrollView(cc.size(520, 80), buildData, 1)
end
return radianceWarBuildInfo

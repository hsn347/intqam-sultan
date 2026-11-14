local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local batteryStateViewLogBase = include("batteryStateViewLogBase")
local radianceWarRead = include("radianceWarRead")
local kingdomMapUtil = include("kingdomMapUtil")
local scrollNode = include("scrollNode")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local radianceWarStateViewLogRecord = class("radianceWarStateViewLogRecord", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("radianceWarStateViewLogRecord")
	end
	if target ~= nil then
		target = batteryStateViewLogBase.new(target)
	end
	return target
end)
local MAX_RECORD_NUM = 20
function _ENV(target)
	if target == nil then
		target = SoraDCreateTouchPanel("radianceWarStateViewLogRecord")
	end
	if target ~= nil then
		target = batteryStateViewLogBase.new(target)
	end
	return target
end
;(function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("radianceWarStateViewLogRecord")
	end
	if target ~= nil then
		target = batteryStateViewLogBase.new(target)
	end
	return target
end).RECORD_TYPE_OP = 1
local (function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("radianceWarStateViewLogRecord")
	end
	if target ~= nil then
		target = batteryStateViewLogBase.new(target)
	end
	return target
end).RECORD_TYPE_WAR, RECORD_TYPE = 2, function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("radianceWarStateViewLogRecord")
	end
	if target ~= nil then
		target = batteryStateViewLogBase.new(target)
	end
	return target
end
function radianceWarStateViewLogRecord:ctor()
	self.ccs_bg:setTitleName(i18n("common_text_836"))
	self.single = SoraDGetChildByName(self, "Image_kingSIngleCopy")
	self.single:setVisible(false)
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(520, 56))
	self.ccs_tab:setNewStyle()
end
function radianceWarStateViewLogRecord:createPanel(showViewType)
	self.isResOp = showViewType == RECORD_TYPE.RECORD_TYPE_OP
	if not self.isResOp then
		radianceWarCtrl:resetHasUnReadResWarLog()
	end
	if self._initInfo ~= nil then
		self:resetData()
		self:req4Info()
	end
end
function radianceWarStateViewLogRecord:initData(argList)
	self.selfSourceID = lordInfoCtrl:getMapSourceKid()
	self.isAllBuild = argList.isAllBuild
	self.instanceType = argList.instanceType
	if self.isAllBuild ~= true then
		self.buildName = radianceWarRead.getBuildName(self.instanceType)
		if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			self.moreMsg = true
		else
			self.moreMsg = false
		end
		self.ccs_tab:setVisible(false)
	else
		self.moreMsg = true
		if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			self.scroll:setContentSize(cc.size(520, 575))
			self.ccs_tab:setVisible(true)
			lordInfoCtrl = true
			;(true).tabNum = 2
			lordInfoCtrl, lordInfoCtrl, (true).defaultClick = cc.size(520, 575)
			cc.size(520, 575).title = i18n("brightWar_text_83")
			cc.size(520, 575).tag = RECORD_TYPE.RECORD_TYPE_OP
			lordInfoCtrl, cc.size(520, 575)[1], cc.size(520, 575).handle = cc.size(520, 575)
			cc.size(520, 575).title = i18n("common_text_285")
			cc.size(520, 575).tag = RECORD_TYPE.RECORD_TYPE_WAR
			;(true).tabsetArray, cc.size(520, 575)[2], cc.size(520, 575).handle = cc.size(520, 575)
			self.ccs_tab:initView(true)
			self:updateRedPoint()
		else
			self.ccs_tab:setVisible(false)
		end
	end
	self._initInfo = true
	batteryStateViewLogBase.initData(self, argList)
end
function radianceWarStateViewLogRecord:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE", handler(self, self.updatePalace))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_HAS_UNREAD_WAR_LOG", handler(self, self.updateRedPoint))
end
function radianceWarStateViewLogRecord:updateRedPoint()
	if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
		local hasUnReadResWarLog = radianceWarCtrl:isHasUnReadResWarLog()
		self.ccs_tab:setRedPointState(RECORD_TYPE.RECORD_TYPE_WAR, hasUnReadResWarLog)
	end
end
function radianceWarStateViewLogRecord:updatePalace(target, retdate)
	if retdate.reqdata then
		if self.isAllBuild then
			self:updateData(retdate.retdate)
		elseif retdate.reqdata.buildId == self.argList.siteClassID then
			if not retdate.retdate then
				local MAX_RECORD_NUM, record = retdate.retdate, retdate.retdate
			end
			if #record < MAX_RECORD_NUM then
				self.moreMsg = false
			end
			self:updateData(retdate.retdate)
		end
		SoraDCloseLoading(self)
	end
end
function radianceWarStateViewLogRecord:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.moreMsg then
		self:req4Info()
	end
end
function radianceWarStateViewLogRecord:req4Info()
	SoraDShowLoading(self)
	if self.isAllBuild then
		if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			if self.isResOp then
				radianceWarCtrl:radianceWarPlayerResLog(self.nextIndex, MAX_RECORD_NUM)
			else
				radianceWarCtrl:radianceWarPlayerResWarLog(self.nextIndex, MAX_RECORD_NUM)
			end
		else
			radianceWarCtrl:radianceWarTeamBuildOccupy(self.nextIndex, MAX_RECORD_NUM)
		end
	else
		local mapId = worldMapDefine.currentMapKindomID
		local buildId = self.argList.siteClassID
		if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			radianceWarCtrl:reqRadianceWarPalaceOccupyLog(mapId, buildId, self.nextIndex, MAX_RECORD_NUM)
		else
			radianceWarCtrl:reqRadianceWarBuildOccupyLog(mapId, buildId)
		end
	end
end
function radianceWarStateViewLogRecord:createNode()
	local single = self.single:clone()
	if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
		local labelContent = SoraDGetChildByName(single, "Text_content")
		_G.SoraDChangeTextToHtml(labelContent)
		labelContent:setSwallowTouches(false)
		scrollNode.new(labelContent)
		labelContent:setScroll(self.scroll)
	end
	return single
end
function radianceWarStateViewLogRecord:refreshNode(single, index, data)
	single:getChildByName("Image_Bg"):setVisible(index % 2 ~= 0)
	local text_content = single:getChildByName("Text_content")
	local strContent
	if self.isAllBuild then
		if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
			if self.isResOp then
				strContent = self:reRecordTextResBuild(data, text_content)
			else
				strContent = self:reRecordTextResWarBuild(data, text_content)
			end
			text_content:setTouchEnabled(true)
			text_content:addTouchEventListener(_G.handlerEx(self, self.btnClickText, data))
		else
			strContent = self:reRecordTextBuild(data, text_content)
		end
	elseif self.instanceType == gMapObjTypeDef.mapTypeRadianceWarPalace then
		strContent = self:reRecordTextPalace(data, text_content)
	else
		strContent = self:reRecordText(data, text_content)
	end
	local sourceKid = data.fromKid
	local color = display.COLOR_WHITE
	if sourceKid and 0 ~= sourceKid and self.selfSourceID ~= sourceKid then
		color = cc.c3b(190, 40, 40)
	end
	text_content:setColor(color)
	text_content:setString(strContent)
	single:getChildByName("Text_time"):setString(SoraDConvertTimeToDate(data.t, false, true))
end
function radianceWarStateViewLogRecord:reRecordTextResBuild(data, text_content)
	local name = lordInfoCtrl:getLordInfo().base.nickName
	local mapObj = data
	mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = kingdomMapUtil.gSplitId(data.mapObjId)
	mapObj.x = mapObj.x - gPointClientPointPlus
	mapObj.y = mapObj.y - gPointClientPointPlus
	lordInfoCtrl = kingdomMapUtil.gSplitId(data.mapObjId)
	kingdomMapUtil.gSplitId(data.mapObjId).playerName = name
	kingdomMapUtil.gSplitId(data.mapObjId).name = radianceWarRead.getResourceName(mapObj.objId)
	local reText = i18n("brightWar_text_59", kingdomMapUtil.gSplitId(data.mapObjId))
	lordInfoCtrl = mapObj.x
	mapObj.x.u = "true"
	reText = reText .. _G.SoraDWrapHtmlTagByStyle(" (X:" .. mapObj.x .. ",Y:" .. mapObj.y .. ")", mapObj.x)
	return reText
end
function radianceWarStateViewLogRecord:reRecordTextResWarBuild(data, text_content)
	local mapObj = data
	mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = kingdomMapUtil.gSplitId(data.mapObjId)
	mapObj.x = mapObj.x - gPointClientPointPlus
	mapObj.y = mapObj.y - gPointClientPointPlus
	local aName = data.name or ""
	local sourceKid = data.fromKid
	if aName and sourceKid and 0 ~= sourceKid then
		aName = aName .. "#" .. tostring(sourceKid)
	end
	kingdomMapUtil = tostring(sourceKid)
	tostring(sourceKid).playerName = aName
	tostring(sourceKid).name = radianceWarRead.getResourceName(mapObj.objId)
	local reText = i18n("brightWar_text_201", (tostring(sourceKid)))
	kingdomMapUtil = mapObj.x
	mapObj.x.u = "true"
	reText = reText .. _G.SoraDWrapHtmlTagByStyle(" (X:" .. mapObj.x .. ",Y:" .. mapObj.y .. ")", mapObj.x)
	return reText
end
function radianceWarStateViewLogRecord:reRecordTextBuild(data, text_content)
	local type = data.type
	local reText = ""
	local name = data.name
	if 1 == type then
		_ENV = nil
		;(nil).name = name
		;(nil).place = radianceWarRead.getBuildName(data.mapType)
		reText = i18n("common_text_1200", nil)
	elseif 2 == type then
		_ENV = nil
		;(nil).playerName = name
		;(nil).name = radianceWarRead.getBuildName(data.mapType)
		reText = i18n("brightWar_text_59", nil)
	end
	reText = reText .. " (X:" .. data.x .. ",Y:" .. data.y .. ")"
	return reText
end
function radianceWarStateViewLogRecord:reRecordText(data, text_content)
	local type = data.type
	local reText = ""
	local aName = data.aName
	local sourceKid = data.fromKid
	if aName and sourceKid and 0 ~= sourceKid then
		aName = aName .. "#" .. tostring(sourceKid)
	end
	if 1 == type then
		_ENV = tostring(sourceKid)
		tostring(sourceKid).name = aName
		tostring(sourceKid).place = self.buildName
		reText = i18n("common_text_1200", (tostring(sourceKid)))
	elseif 2 == type then
		_ENV = tostring(sourceKid)
		tostring(sourceKid).playerName = aName
		tostring(sourceKid).name = self.buildName
		reText = i18n("brightWar_text_59", (tostring(sourceKid)))
	end
	return reText
end
function radianceWarStateViewLogRecord:reRecordTextPalace(data, text_content)
	if data.abbr then
		_ENV = nil
		;(nil).name = data.name
		;(nil).abbr = data.abbr
		if i18n("common_text_186", nil) then
			goto lbl_15
		end
	end
	local aName = data.name
	::lbl_15::
	local sourceKid = data.fromKid
	if aName and sourceKid and 0 ~= sourceKid then
		aName = aName .. "#" .. tostring(sourceKid)
	end
	_ENV = tostring(sourceKid)
	tostring(sourceKid).name = aName
	tostring(sourceKid).place = self.buildName
	local reText = i18n("common_text_1200", (tostring(sourceKid)))
	return reText
end
function radianceWarStateViewLogRecord:btnClickText(data, button, type)
	if type == ccui.TouchEventType.ended then
		dump(data, "data", 10)
		SoraDPlaySound()
		if worldMapDefine.isInRadiance() then
			SoraDGotoWorldMapPoint(cc.p(data.x, data.y), true)
			SoraDRemoveAllPanelFromManager()
		else
			SoraDShowMsgTip(i18n("brightWar_text_79"))
		end
	end
end
return radianceWarStateViewLogRecord

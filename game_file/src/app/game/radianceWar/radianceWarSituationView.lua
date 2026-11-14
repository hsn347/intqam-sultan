local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local kingdomMapUtil = include("kingdomMapUtil")
local radianceWarDef = include("radianceWarDef")
local radianceWarRead = include("radianceWarRead")
local radianceWarUtil = include("radianceWarUtil")
local allianceMgr = _G.SoraDGetCtrl("allianceMgr")
local publicRead = include("publicRead")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
_ENV = nil
;(nil)["1"] = false
;(nil)["2"] = false
;(nil)["3"] = false
;(nil)["4"] = false
local _ENV, (nil)["5"], tableRadianceResState = nil, false, nil
;(nil)["36"] = true
;(nil)["37"] = true
local _UPVALUE3_, (nil)["38"], tableRadianceBuildState = nil, true, nil
;(nil)[1] = 5448
;(nil)[2] = 5450
local (nil)[3], buffArray = 5454, nil
local radianceWarSituationView = class("radianceWarSituationView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarSituationView")
	end
	return target
end)
function radianceWarSituationView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableSpareListState, _ENV, self.tableSpareList, _ENV, self.tableResList, _ENV, self.outSingleNode, _ENV, self.curTab = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1
	self.sortUp = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidBattleHistory")
	self.nodeTitle:setTitle(i18n("brightWar_title_11"))
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgBg:setFillType(1)
	self.scrollOut = SoraDGetChildByName(self, "Top_Size_ScrollView_out")
	self.scrollRes = SoraDGetChildByName(self, "Top_Size_ScrollView_res")
	self.topNodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.nodeRes = SoraDGetChildByName(self, "Node_res")
	self.spriteOut = SoraDGetChildByName(self, "Sprite_out")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelTime:setVisible(false)
	local obj = fguiHelper.createObject("radianceWar", "Node_situationView")
	obj:addTo(SoraDGetChildByName(self, "Top_Node_head"))
	obj:setAnchorPoint(0.5, 0.5)
	obj:setPosition(SoraDFSign(320), -self.labelTime:getPositionY())
	if not SoraDFIsRA() then
		obj:fixChildrenPos(true)
	end
	local _fields = fguiHelper.get_fields(obj)
	_fields.Button_sort:addClickListener(handler(self, self.onClickBtnSort))
	self.labelTime = _fields.Text_time
	self.btnSort = _fields.Button_sort
	self.btnSort:setString(i18n("common_btn_04"))
	self.ccs_buff = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarBuffNode_node")
	self.ccs_buff:setTimeEndHandle(function()
		local isActive = lightShiningCtrl:isBuffActive()
		self.ccs_buff:setVisible(isActive)
		self:initResScroll()
	end)
	self.ccs_buff:initData(buffArray)
	self.ccs_buff:setVisible(false)
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	self.nodeCopy = SoraDGetChildByName(self, "Node_copy")
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClickCallBack))
	self.btnLog:addTouchEventListener(handler(self, self.btnLogClickCallBack))
	self.redIcon = SoraDGetChildByName(self, "red_Icon")
	self.btnGet:setTitleText(i18n("common_text_3681"))
	self.btnLog:setTitleText(i18n("common_text_836"))
	self.scrollOut:setVisible(false)
	self.nodeRes:setVisible(false)
	self.spriteOut:setVisible(true)
	self.scrollRes:addEventListener(handler(self, self.scrollEventCallBack))
	self:initTab()
	radianceWarCtrl:radianceWarPlayerResList()
	if allianceMgr:hasJoinAlliance() then
		radianceWarCtrl:radianceWarTeamBuildList()
	end
	local lefttime = radianceActivityCtrl.radianceWarStateInfo.settleTime
	_ENV = handler(self, self.scrollEventCallBack)
	handler(self, self.scrollEventCallBack).time = os.date("%Y-%m-%d", lefttime)
	self.labelTime:setString(i18n("brightWar_text_32", handler(self, self.scrollEventCallBack)))
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	self:setBuffInfo()
	SoraDTestButton(self, function(...)
		local clip = cc.ClippingNode:create()
		local stencil = display.newSprite("#bg_JZT_zc3.png")
		stencil:setPosition(0, 0)
		clip:setStencil(stencil)
		clip:setInverted(false)
		clip:setAlphaThreshold(0)
		clip:addChild(display.newSprite("#Map_King_castle_02.png"), 0)
		clip:addTo(self, 10)
		clip:setPosition(320, 300)
	end)
end
function radianceWarSituationView:onClickBtnSort(...)
	SoraDPlaySound()
	self.sortUp = not self.sortUp
	if self.sortUp then
		self.btnSort:setString(i18n("common_btn_04"))
	else
		self.btnSort:setString(i18n("common_btn_03"))
	end
	self:updateResScroll()
end
function radianceWarSituationView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_RES_INFO_BACK", function(target, data)
		if self.curTab == 1 then
			self:updateResScroll()
			SoraDCloseLoading()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_BUILD_INFO_BACK", function(target, data)
		if self.curTab == 2 then
			self:updateResScroll()
			SoraDCloseLoading()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_HAS_UNREAD_WAR_LOG", handler(self, self.updateRedPoint))
end
function radianceWarSituationView:updateRedPoint()
	if self.curTab == 1 then
		local hasUnReadResWarLog = radianceWarCtrl:isHasUnReadResWarLog()
		self.redIcon:setVisible(hasUnReadResWarLog)
		self.nodeTab:setRedPointState(1, hasUnReadResWarLog)
	else
		self.redIcon:setVisible(false)
	end
end
function radianceWarSituationView:openTimeUp()
	if self.curTab == 1 then
		self.btnGet:setTouchEnabled(false)
		local curTime = serviceFunctions.systemTime()
		for _, resdata in pairs(self.tableResList) do
			for _, v in ipairs(resdata) do
				local curCount = radianceWarUtil.getResCount(v, curTime)
				if 1 <= curCount then
					self.btnGet:setTouchEnabled(true)
					return
				end
			end
		end
	end
end
function radianceWarSituationView:setBuffInfo()
	local isActive = lightShiningCtrl:isBuffActive()
	local isInBuff = lightShiningCtrl:isInBuffList(buffArray)
	self.ccs_buff:setVisible(isInBuff and isActive and self.curTab == 1)
	if isInBuff and isActive and self.curTab == 1 then
		self.ccs_buff:setVisible(true)
	else
		self.ccs_buff:setVisible(false)
	end
end
function radianceWarSituationView:initTab()
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("brightWar_text_56")
	;(nil).handle = handler(self, self.OnBtnChangeClick)
	_ENV, (nil)[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("brightWar_text_57")
	;(nil).handle = handler(self, self.OnBtnChangeClick)
	;(nil)[2], (nil).tag = nil, 2
	local tabData
	_ENV = self
	self.tabNum = 2
	self.defaultClick = self.curTab
	self.tabsetArray = tabData
	self.nodeTab:initView(self)
	self.nodeTab:openAutoSize()
end
function radianceWarSituationView:OnBtnChangeClick(tag, name)
	if tag == 2 and not allianceMgr:hasJoinAlliance() then
		self.nodeTab:switchTab(1)
		SoraDShowMsgTip(i18n("notice_0066"))
		return
	end
	self.curTab = tag
	self:updateView()
	self:updateRedPoint()
	local isActive = lightShiningCtrl:isBuffActive()
	local isInBuff = lightShiningCtrl:isInBuffList(buffArray)
	self.ccs_buff:setVisible(self.curTab == 1 and isInBuff and isActive)
	self.btnSort:setVisible(self.curTab == 1)
end
function radianceWarSituationView:changeToTab(tag, rank)
	self.nodeTab:clickByTag(tag)
	self:listSingleBack(rank, true)
end
function radianceWarSituationView:updateView()
	self:updateResScroll()
end
function radianceWarSituationView:updateResScroll()
	if self.curTab == 1 then
		self.tableResList, self.curTab["5"], radianceWarCtrl, self.curTab["4"], radianceWarCtrl, self.curTab["3"], radianceWarCtrl, self.curTab["2"], radianceWarCtrl, self.curTab["1"], radianceWarCtrl, radianceWarCtrl = self.curTab, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.curTab
		if radianceWarCtrl.radianceWarResInfoData then
			for k, v in pairs(radianceWarCtrl.radianceWarResInfoData) do
				local mapObj = v
				mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = kingdomMapUtil.gSplitId(k)
				mapObj.id = k
				if mapObj.type == gMapObjTypeDef.mapTypeRadianceWarResource then
					table.insert(self.tableResList[tostring(mapObj.subMapType)], mapObj)
				end
			end
		end
		if self.sortUp then
			for _, v in pairs(self.tableResList) do
				table.sort(v, function(l, r)
					local lv_l = l.objId
					local lv_r = r.objId
					if lv_l ~= lv_r then
						return lv_l > lv_r
					end
					return l.objId > r.objId
				end)
			end
		else
			for _, v in pairs(self.tableResList) do
				table.sort(v, function(l, r)
					local lv_l = l.objId
					local lv_r = r.objId
					if lv_l ~= lv_r then
						return lv_l < lv_r
					end
					return l.objId > r.objId
				end)
			end
		end
		self:openTimeUp()
	elseif self.curTab == 2 then
		self.tableResList, self.curTab["38"], radianceWarCtrl, self.curTab["37"], radianceWarCtrl, radianceWarCtrl = self.curTab, self, self, self, self, self.curTab
		if radianceWarCtrl.radianceWarBuildInfoData then
			for k, v in pairs(radianceWarCtrl.radianceWarBuildInfoData) do
				v.id = tonumber(k)
				table.insert(self.tableResList[tostring(v.mapType)], v)
			end
		end
		for _, v in pairs(self.tableResList) do
			table.sort(v, function(l, r)
				local lv_l = radianceWarRead.getBuildLv(l.id)
				local lv_r = radianceWarRead.getBuildLv(r.id)
				if lv_l ~= lv_r then
					return lv_l > lv_r
				end
				return l.id > r.id
			end)
		end
	end
	self:initResScroll()
	self:listSingleBack()
	self.btnGet:setVisible(self.curTab == 1)
	self.btnLog:setPositionX(self.curTab == 1 and SoraDFPosX(190, 640) or 320)
end
function radianceWarSituationView:initResScroll()
	_UPVALUE8_ = nil
	;(nil)[1] = "36"
	;(nil)[2] = "37"
	;(nil)[3] = "38"
	;(nil)[4] = "1"
	;(nil)[5] = "2"
	;(nil)[6] = "3"
	;(nil)[7] = "4"
	local (nil)[8], tableResListKey = "5", nil
	for i, v in ipairs(tableResListKey) do
		local rankData = self.tableResList[v]
		local single = self.tableSingle[i]
		if rankData then
			if single == nil then
				single = SoraDCreatePanel("radianceWarSituationListSingle")
				single:setClickCallBack(handler(self, self.listSingleBack))
				single:setScroll(self.scrollRes)
				single:addTo(self.scrollRes)
				table.insert(self.tableSingle, single)
			end
			single:initData(tonumber(v), rankData, self.tableSpare, self.curTab)
			if self.curTab == 2 then
				single:setState(tableRadianceBuildState[v])
			else
				single:setState(tableRadianceResState[v])
			end
			single:setVisible(true)
		elseif single ~= nil then
			single:removeMember()
			single:setVisible(false)
		end
	end
end
function radianceWarSituationView:listSingleBack(rank, state)
	if rank ~= nil then
		if self.curTab == 2 then
			tableRadianceBuildState[tostring(rank)] = state
		else
			tableRadianceResState[tostring(rank)] = state
		end
	end
	local scrollInner = self.scrollRes:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 50
	for i = 1, #self.tableSingle do
		local single = self.tableSingle[#self.tableSingle - i + 1]
		if single:isVisible() then
			scrollInnerNewH = scrollInnerNewH + single:getSingleH()
			single:setPosition(cc.p(320, scrollInnerNewH))
		end
	end
	scrollInnerNewH = scrollInnerNewH + 10
	if scrollInnerNewH < self.scrollRes:getContentSize().height then
		local upto = self.scrollRes:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			if v:isVisible() then
				v:setPositionY(v:getPositionY() + upto)
			end
		end
		scrollInnerNewH = self.scrollRes:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scrollRes:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function radianceWarSituationView:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function radianceWarSituationView:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
function radianceWarSituationView:btnGetClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		radianceWarCtrl:radianceWarDrawOutAllRes()
		button:setTouchEnabled(false)
	end
end
function radianceWarSituationView:btnLogClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curTab == 1 then
			local panel = SoraDCreatePanel("radianceWarStateViewLogRecord")
			_ENV = nil
			;(nil).isAllBuild = true
			;(nil).instanceType = gMapObjTypeDef.mapTypeRadianceWarPalace
			panel:initData(nil)
			panel:show()
		elseif self.curTab == 2 then
			local panel = SoraDCreatePanel("radianceWarStateViewLogRecord")
			_ENV = nil
			;(nil).isAllBuild = true
			;(nil).instanceType = gMapObjTypeDef.mapTypeRadianceWarGate
			panel:initData(nil)
			panel:show()
		end
	end
end
return radianceWarSituationView

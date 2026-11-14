local socket = require("socket")
local gAllianceQueueClassType = _G.gAllianceQueueClassType
local worldMapWarDef = include("worldMapWarDef")
local AllianceWarView = class("allianceWarView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("allianceWarView")
	end
	if target ~= nil then
		local baseClass = include("allianceWarBase")
		target = baseClass.new(target)
	end
	return target
end)
function AllianceWarView:onEnterOther()
	SoraDShowLoading(self)
	_ENV, _UPVALUE2_ = self, SoraDShowLoading
	_ENV, self.name = nil, "worldMap/worldMapBuilding"
	;(nil).name = "worldMap/worldMapCastle"
	SoraDShowLoading[1] = self
	local SoraDShowLoading[2], imgArray = nil, SoraDShowLoading
	local imageBoss = worldMapDefine.getBossImage()
	print(imageBoss, "imageBoss")
	for i, image in ipairs(imageBoss) do
		_ENV = nil
		;(nil).name = image
		table.insert(imgArray, nil)
	end
	self:loadImages(imgArray, function()
		self:initData()
		self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:addWarBaseMsg()
		SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING", handler(self, self.updateViewBySetting))
		SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH", handler(self, self.updateViewBySetting))
		SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
		SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
			self:removeFromParent()
		end)
		SoraDCloseLoading(self)
	end)
end
function AllianceWarView:ctor(target, isWar)
	self.isHideCurrentSceneView = true
	self.needCallBack2SDK = true
	if SoraDCurrentSceneShowView("worldMapView") then
		self.freeImagesOnExit = false
	else
		self.freeImagesOnExit = true
	end
	self.tableSingleUI, _ENV = SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView")
	self.curClassType = nil
	self.tableGreen, _ENV, self.tableBtn, _ENV, self.tableSpare_normal, _ENV, self.tableSpare_rally, _ENV, self.curWarData = SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), nil
	self.teamTabBtnNode = SoraDGetChildByName(self, "Node_btn_1")
	self.teamTabBtnNode:setVisible(false)
	self.tabBtnNode = SoraDGetChildByName(self, "Node_btn")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_war")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	self.ccs_tab:setChoosePng("btn_secondarybtn_long_01.png")
	self.ccs_tab:setUnChoosePng("btn_secondarybtn_long_02.png")
	_ENV = "btn_secondarybtn_long_02.png"
	_ENV, _ENV, ("btn_secondarybtn_long_02.png").tabNum = nil, nil, 2
	;(nil).title = i18n("common_text_299")
	;(nil).tag = gAllianceQueueClassType.pve
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.btn_onClick_btns)
	;(nil).title = i18n("common_text_3869")
	;(nil).tag = gAllianceQueueClassType.pve_moving
	;("btn_secondarybtn_long_02.png").tabsetArray, (nil)[2], (nil).handle = nil, nil, handler(self, self.btn_onClick_btns)
	;("btn_secondarybtn_long_02.png").unDefaultClick = true
	self.ccs_tab:initView("btn_secondarybtn_long_02.png")
	self.ccs_tab:setVisible(false)
	local offsety = 64
	self.sSize = self.scroll:getContentSize()
	self.sPositionY = self.scroll:getPositionY()
	self.scroll:setContentSize(cc.size(self.sSize.width, self.sSize.height - offsety))
	self.scroll:setPositionY(self.sPositionY - offsety)
	self.scrollH = self.scroll:getContentSize().height
	self.scrollInnerH = self.scrollH
	self:initQueue(self.scrollH, isWar)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_war")
	self.btnRecord = SoraDGetChildByName(self, "Bottom_Button_record")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.btnRecord:setTitleText(i18n("common_text_285"))
	self.btnRecord:addTouchEventListener(handler(self, self.btnClickCallBack))
	if self.queueRoot:isWarQueueRoot() then
		self.nodeTitle:setTitle(i18n("brightWar_text_21"))
		self.labelNotice:setString(i18n("common_text_305"))
		_ENV = i18n("common_text_305")
		i18n("common_text_305").byUID = true
		self.openWarning = SoraDConfigGet("Game:radianceWar:openWarning~bool", i18n("common_text_305"))
		self:refreshRecordText()
	else
		local title, notice = worldMapWarDef.getAllianceWarViewTitle()
		self.nodeTitle:setTitle(title)
		self.labelNotice:setString(notice)
	end
	if worldMapDefine.isInNewTrial() then
		self.btnRecord:setVisible(false)
	end
	self.nodeLine = SoraDGetChildByName(self, "Node_line")
	self.tableBtn[1] = SoraDGetChildByName(self, "Button_atk")
	self.tableBtn[1]:setTouchEnabled(false)
	self.tableBtn[1]:setBright(false)
	self.tableBtn[1]:setTitleColor(cc.c3b(255, 245, 176))
	self.tableBtn[2] = SoraDGetChildByName(self, "Button_def")
	self.tableBtn[3] = SoraDGetChildByName(self, "Button_activity")
	self.tableBtn[1]:setTitleText(i18n("common_text_008"))
	self.tableBtn[2]:setTitleText(i18n("common_text_041"))
	self.tableBtn[3]:setTitleText(i18n("common_text_835"))
	self.tableBtn[1]:setTag(gAllianceQueueClassType.pvp)
	self.tableBtn[2]:setTag(gAllianceQueueClassType.pvp_def)
	self.tableBtn[3]:setTag(gAllianceQueueClassType.pve)
	self.btnSetting = SoraDGetChildByName(self, "Button_setting")
	self.btnSetting:addTouchEventListener(handler(self, self.btnSettingClick))
	self.nodeFiler = SoraDGetChildByName(self, "Node_filer")
	self.nodeFiler:setVisible(false)
	SoraDGetChildByName(self, "Text_filer"):setString(i18n("commom_text_4300"))
	for i, v in ipairs(self.tableBtn) do
		_ENV = i18n("commom_text_4300")
		i18n("commom_text_4300").sprite = SoraDGetChildByName(v, "Sprite_green")
		self.tableGreen[i], i18n("commom_text_4300").label = i18n("commom_text_4300")
		self.tableGreen[i].sprite:setVisible(false)
	end
	self.tableBtn[1]:addTouchEventListener(handler(self, self.btnTabelClickCallBack))
	self.tableBtn[2]:addTouchEventListener(handler(self, self.btnTabelClickCallBack))
	self.tableBtn[3]:addTouchEventListener(handler(self, self.btnTabelClickCallBack))
	if not worldMapWarDef.showWarViewActivityTag() or self.queueRoot:isWarQueueRoot() then
		self.tableBtn[1]:setPositionX(SoraDFPosX(320, 0))
		self.tableGreen[1].sprite:setPositionX(SoraDFPosX(5, 280))
		self.tableBtn[1]:setContentSize(cc.size(320, 72))
		self.tableBtn[2]:setPositionX(SoraDFPosX(-160, 0))
		self.tableGreen[2].sprite:setPositionX(SoraDFPosX(5, 280))
		self.tableBtn[2]:setContentSize(cc.size(320, 72))
		self.tableBtn[3]:setVisible(false)
	end
	local cityBuildData = include("cityBuildData")
	cityBuildData:cleanFighting()
end
function AllianceWarView:setShowTeamTab(mapid)
	self.nodeTitle:setTitle(i18n("free_team_text_41"))
	self.teamTabBtnNode:setVisible(true)
	self.mapid = mapid
	self.tableBtn2, _ENV, self.isShowTeamTab = self.teamTabBtnNode.setVisible, self.teamTabBtnNode.setVisible, true
	self.tableBtn2[1] = SoraDGetChildByName(self, "Button_alliance")
	self.tableBtn2[1]:setTitleText(i18n("free_team_text_47"))
	self.tableBtn2[1]:setTitleColor(cc.c3b(255, 245, 176))
	self.tableBtn2[1]:setTouchEnabled(false)
	self.tableBtn2[1]:setBright(true)
	self.tableBtn2[2] = SoraDGetChildByName(self, "Button_team")
	self.tableBtn2[2]:setTitleText(i18n("remains_text_85"))
	self.tableBtn2[2]:setTitleColor(cc.c3b(144, 132, 97))
	self.tableBtn2[2]:setTouchEnabled(true)
	self.tableBtn2[2]:setBright(false)
	self.tableBtn2[2]:addTouchEventListener(handler(self, self.btnTeamClick))
	self.redNode1 = SoraDGetChildByName(self.tableBtn2[1], "Sprite_green")
	self.redNode1:setVisible(false)
	self.redNode2 = SoraDGetChildByName(self.tableBtn2[2], "Sprite_green")
	self.redNode2:setVisible(false)
	local offsety = 70
	self.tabBtnNode:setPositionY(0 - offsety)
	self.ccs_tab:setPositionY(770 - offsety)
	self.nodeLine:setPositionY(23 - offsety)
	local size = self.scroll:getContentSize()
	local sPositionY = self.scroll:getPositionY()
	self.scroll:setContentSize(cc.size(size.width, size.height - offsety))
	self.scroll:setPositionY(sPositionY - offsety)
	self.sSize.height = self.sSize.height - offsety
	self.sPositionY = self.sPositionY - offsety
	self.nodeWarRed = SoraDGetChildByName(self.tableBtn2[1], "Sprite_green")
	self.nodeWarRed:setVisible(false)
	self.txtWarRed = SoraDGetChildByName(self.tableBtn2[1], "Text_green")
end
function AllianceWarView:btn_onClick_btns(tag, name)
	self.curClassType = tag
	self.curWarData = self:getQueue(self.curClassType)
	if self.ignoreRefresh then
		self.ignoreRefresh = false
	else
		self:clearScrollData()
		self:refreshScroll(true)
	end
end
function AllianceWarView:updateGreenPointAlliance()
	if worldMapDefine.isInLegendLord() then
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local allianceCount = kingdomMapCtrl:getHallWarCount()
		self.txtWarRed:setString(allianceCount)
		self.nodeWarRed:setVisible(0 < allianceCount)
	end
end
function AllianceWarView:refreshScroll(toTop)
	self.offsetY = nil
	self.beginIndex = nil
	self.endIndex = nil
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	self:updateScrollSize()
	if self.labelNotice:isVisible() then
		self.scroll:jumpToTop()
	else
		if toTop then
			self.scroll:jumpToTop()
		end
		self:initWarOnScroll()
	end
end
function AllianceWarView:btnTabelClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:tabChange(button:getTag())
	end
end
function AllianceWarView:setCurClassType(classType)
	self.curClassType = classType
	if self.curClassType == gAllianceQueueClassType.pve then
		self.ccs_tab:setVisible(true)
		self.ignoreRefresh = true
		self.ccs_tab:clickByTag(1)
		local offsety = 64
		self.scroll:setContentSize(cc.size(self.sSize.width, self.sSize.height - offsety))
		self.scroll:setPositionY(self.sPositionY - offsety)
	else
		self.ccs_tab:setVisible(false)
		self.curWarData = self:getQueue(classType)
		self.scroll:setContentSize(self.sSize)
		self.scroll:setPositionY(self.sPositionY)
	end
	self.scrollH = self.scroll:getContentSize().height
	self.scrollInnerH = self.scrollH
	self:updateQueueScrollH(self.scrollH)
end
function AllianceWarView:initData()
	self:initQueueData()
	self:updateGreen()
	if not self.curClassType then
		local curClassType
		for i, v in ipairs(self.tableGreen) do
			if v.sprite:isVisible() then
				curClassType = self.tableBtn[i]:getTag()
				break
			end
		end
		curClassType = curClassType or gAllianceQueueClassType.pvp
		self:tabChange(curClassType, true)
	else
		self:tabChange(self.curClassType, true)
		if self.eventID then
			self:jumpToWarSingle_imp()
		end
	end
end
function AllianceWarView:updateGreen()
	local _ENV, greenCount
	greenCount[1] = self.queueRoot:getWarHallAttackCount()
	greenCount[2] = self.queueRoot:getWarHallDefendCount()
	greenCount[3] = self.queueRoot:getWarHallActivityCount()
	for i, v in ipairs(self.tableGreen) do
		v.sprite:setVisible(0 < greenCount[i])
		v.label:setString(string.formatnumberthousands(greenCount[i]))
	end
	_UPVALUE2_ = ipairs(self.tableGreen)
	ipairs(self.tableGreen)[1] = gAllianceQueueClassType.pve
	ipairs(self.tableGreen)[2] = gAllianceQueueClassType.pve_moving
	for __, classType in ipairs(ipairs(self.tableGreen)) do
		local count = self.queueRoot:getWarHallCountByClassType(classType)
		self.ccs_tab:setBigRedPointCount(classType, count)
	end
	self:updateGreenPointAlliance()
end
function AllianceWarView:jumpToWarSingle_imp()
	local scrollH = self.scrollH
	local innerH = self.scrollInnerH
	local posY = self.curWarData:getQueuePosByID(self.eventID)
	if posY then
		local offsetY = math.min(0, -math.min(innerH - scrollH, posY - 200 - 0.5 * scrollH))
		self.scroll:getInnerContainer():setPositionY(offsetY)
		self.offsetY = nil
		self:initWarOnScroll()
	end
	self.eventID = nil
end
function AllianceWarView:jumpToWarSingle(eventID, classType)
	classType = classType == nil and gAllianceQueueClassType.pvp or classType
	self:setCurClassType(classType)
	self.eventID = eventID
end
function AllianceWarView:tabChange(classType, force)
	if not force and self.curClassType == classType then
		return
	end
	for _, v in ipairs(self.tableBtn) do
		local btnTag = v:getTag()
		if btnTag == classType then
			v:setTitleColor(cc.c3b(255, 245, 176))
			self:setCurClassType(btnTag)
			v:setTouchEnabled(false)
			v:setBright(true)
		else
			v:setTitleColor(cc.c3b(144, 132, 97))
			v:setTouchEnabled(true)
			v:setBright(false)
		end
	end
	self:clearScrollData()
	self:refreshScroll(true)
end
function AllianceWarView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH, filterHeight = self.curWarData:getScrollMaxHeight()
	self.labelNotice:setVisible(not self.curWarData:isHasQueue())
	if 0 < filterHeight then
		self.nodeFiler:setVisible(true)
		self.nodeFiler:setPositionY(filterHeight)
	else
		self.nodeFiler:setVisible(false)
	end
	local minY = self.scrollH - scrollInnerNewH
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	if minY > offsetY then
		offsetY = minY
	elseif 0 < offsetY then
		offsetY = 0
	end
	self.scrollInnerH = scrollInnerNewH
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function AllianceWarView:initWarOnScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	self.offsetY = offsetY
	local scrollH = self.scrollH
	local scrollMaxH = self.scrollInnerH
	local beginY = math.max(0, offsetY - 200)
	local endY = math.min(scrollMaxH, offsetY + scrollH + 200)
	local beginIndex = self.curWarData:getQueueIndexByPos(endY, true)
	local endIndex = self.curWarData:getQueueIndexByPos(beginY, false)
	local iterBeginIndex = self.beginIndex and math.min(beginIndex, self.beginIndex) or beginIndex
	local iterEndIndex = self.endIndex and math.max(endIndex, self.endIndex) or endIndex
	self.beginIndex = beginIndex
	self.endIndex = endIndex
	local tableData = self.curWarData:getTableData()
	for _, queueCell in ipairs(tableData) do
		if iterBeginIndex > queueCell.endIndex then
		else
			if iterEndIndex < queueCell.beginIndex then
				break
			end
			local iterBegin = math.max(queueCell.beginIndex, iterBeginIndex)
			local iterEnd = math.min(queueCell.endIndex, iterEndIndex)
			local queueData = queueCell.queue
			for i = iterBegin, iterEnd do
				local index = i - queueCell.beginIndex
				local v = queueData[index + 1]
				if not v then
					break
				end
				if i < beginIndex or i > endIndex then
					local point = self.tableSingleUI[v]
					if point then
						self:reuseSingle(point)
						self.tableSingleUI[v] = nil
					end
				else
					local point = self.tableSingleUI[v]
					if point then
						local posY = queueCell.beginHeight - index * queueCell.singleH
						if posY ~= point:getPositionY() then
							point:setPosition(cc.p(320, posY))
						end
					else
						local posY = queueCell.beginHeight - index * queueCell.singleH
						local singleType, tableCur
						if v.isMass then
							singleType = "allianceWarListRallySingle"
							tableCur = self.tableSpare_rally
						else
							singleType = "allianceWarListSingle"
							tableCur = self.tableSpare_normal
						end
						local single
						if 0 < #tableCur then
							single = table.remove(tableCur)
							single:setVisible(true)
						else
							single = SoraDCreatePanel(singleType)
							single:setScroll(self.scroll, self.queueRoot)
							single:addTo(self.scroll)
						end
						single:initData(v.indexID, v.data, v.isFilter)
						single:setPosition(cc.p(320, posY))
						self.tableSingleUI[v] = single
					end
				end
			end
		end
	end
end
function AllianceWarView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		local scrollInner = self.scroll:getInnerContainer()
		local offsetY = -scrollInner:getPositionY()
		if self.offsetY and math.abs(self.offsetY - offsetY) < 230 then
			return
		end
		if self.is_delay then
			self.is_delay = false
			self:clearScrollData()
			self:refreshScroll()
		else
			self:initWarOnScroll()
		end
	end
end
function AllianceWarView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.queueRoot:isWarQueueRoot() then
			if self.openWarning then
				SoraDShowMsgBox(i18n("brightWar_text_114"), i18n("common_text_054"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						self.openWarning = not self.openWarning
						self:refreshOpenWarning()
					end
				end)
			else
				self.openWarning = not self.openWarning
				self:refreshOpenWarning()
			end
		else
			uiManager:show("AllianceWarHistory")
		end
	end
end
function AllianceWarView:refreshOpenWarning()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:radianceWar:openWarning~bool", self.openWarning, nil)
	self:refreshRecordText()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RADIANCE_WAR_WARNING"
	SoraDSendMessage(self)
end
function AllianceWarView:refreshRecordText()
	if self.openWarning then
		self.btnRecord:setTitleText(i18n("brightWar_text_146"))
	else
		self.btnRecord:setTitleText(i18n("brightWar_text_147"))
	end
end
function AllianceWarView:btnSettingClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).viewType = 2
		uiManager:show("AllianceWarSettingView", nil)
	end
end
function AllianceWarView:btnTeamClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openView(self.mapid)
		self:removeFromParent()
	end
end
function AllianceWarView:clearScrollData()
	for _, v in pairs(self.tableSingleUI) do
		self:reuseSingle(v)
	end
	self.tableSingleUI, _ENV = pairs(self.tableSingleUI)
end
function AllianceWarView:updateViewBySetting(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	self:clearScrollData()
	if self.curWarData then
		self.curWarData:clean()
	end
	self:initQueueData()
	self:refreshScroll()
end
function AllianceWarView:reuseSingle(single)
	if single then
		single:setVisible(false)
		single:resetData()
		if single.__cname == "allianceWarListSingle" then
			table.insert(self.tableSpare_normal, single)
		else
			table.insert(self.tableSpare_rally, single)
		end
	end
end
function AllianceWarView:refreshByData(classType, queue, isDelete)
	if self.curClassType ~= classType then
		return
	end
	if self:needRefresh() then
		if isDelete then
			local point = self.tableSingleUI[queue]
			if point then
				self:reuseSingle(point)
				self.tableSingleUI[queue] = nil
			end
		end
		self:refreshScroll()
	end
end
function AllianceWarView:refreshSinggleByData(classType, queue)
	if self.curClassType ~= classType then
		return
	end
	local point = self.tableSingleUI[queue]
	if point then
		point:updateData(queue.indexID, queue.data, queue.isFilter)
	end
end
function AllianceWarView:openTimeUp(dt)
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if self.delay_time <= 0 then
			self.is_delay = false
			self:clearScrollData()
			self:refreshScroll()
		end
	end
end
local MIN_TIME = 2.0
function AllianceWarView:needRefresh()
	if self.is_delay then
		return false
	end
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < MIN_TIME then
			self.is_delay = true
			self.delay_time = MIN_TIME
			return false
		end
	end
	self.preClockTime = curTime
	return true
end
function AllianceWarView:initAtlantisWarView(...)
	self.nodeTitle:setVisible(false)
	self.btnSetting:setVisible(false)
	local Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	local offsetY = 60
	local newH = Image_bg:getContentSize().height - offsetY
	Image_bg:setContentSize(cc.size(640, newH))
	Image_bg:setPositionY(newH)
	self.sSize = cc.size(self.sSize.width, self.sSize.height - offsetY)
	self.sPositionY = self.sPositionY - offsetY
end
return AllianceWarView

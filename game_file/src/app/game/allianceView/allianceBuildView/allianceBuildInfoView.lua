local gametop = gModuleMgr.getObject("gametop")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceBuildInfoView = class("allianceBuildInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildInfoView")
	end
	return target
end)
function AllianceBuildInfoView:ctor()
	self.buildSingle = nil
	self.timer = nil
	self.queueIds, _ENV, self.fromLoadText = nil, nil, false
	self.curLoad = 0
	self.cantJoin = true
	self.tableSpare, _ENV, self.memberListData, _ENV, self.buildState = gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	SoraDGetChildByName(self, "Image_tile_line"):setFillType(1)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelValue1 = SoraDGetChildByName(self, "Text_value_1")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.labelValue2 = SoraDGetChildByName(self, "Text_value_2")
	self.labelTitle3 = SoraDGetChildByName(self, "Text_title_3")
	self.labelValue3 = SoraDGetChildByName(self, "Text_value_3")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_troops")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setVisible(false)
	self.labelNotice:setString(i18n("common_text_089"))
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.img9 = SoraDGetChildByName(self, "Image_9")
	self.btnRemove = SoraDGetChildByName(self, "Button_remove")
	self.imgBgNoSize = SoraDGetChildByName(self, "Image_bg_noSize")
	self.labelLog = SoraDGetChildByName(self, "Text_log")
	self.spriteBuild = SoraDGetChildByName(self, "Sprite_build")
	self.btnRemove:setTitleText(i18n("common_text_728"))
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	if self.btnRemove then
		self.btnRemove:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceBuildInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILD_INFOLIST_UPDATE", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILD_INFOLIST_ADD", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEL", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILD_INFOLIST_REFRESH", function(...)
		self:initData(self.buildSingle:getBID(), self.buildSingle:getIID())
	end)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEMOLISH", function(target, data)
		if data.data.bid == self.buildSingle:getBID() and data.data.iid == self.buildSingle:getIID() then
			self:removeFromParent()
		end
	end)
end
function AllianceBuildInfoView:initScroll(allQueueIds)
	for i, v in ipairs(self.memberListData) do
		if v.point then
			table.insert(self.tableSpare, v.point)
			v.point:setVisible(false)
			v.point = nil
		end
	end
	self.memberListData, _ENV = ipairs(self.memberListData)
	self.queueIds = allQueueIds
	if self.buildState == gAllianceBuildingStatus.BUILD then
		local maxQueue = self.buildSingle:getMaxNumOfQueue() + 1
		for i = 1, maxQueue do
			_ENV = false
			;(false).data = nil
			;(false).isLaunched = false
			;(false).singleH = 120
			;(false).point = nil
			;(false).posY = 0
			;(false).type = i == 1 and gAWarRallyMemberType.LOCK or gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, false)
		end
	else
		local maxQueue = #self.queueIds
		for i = 1, maxQueue do
			_ENV = false
			;(false).data = nil
			;(false).isLaunched = false
			;(false).singleH = 120
			;(false).point = nil
			;(false).posY = 0
			;(false).type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, false)
		end
	end
	self.curLoad = 0
end
function AllianceBuildInfoView:updateScroll(target, data)
	dump(data.data, "AllianceBuildInfoView:updateScroll")
	if data.data.allQueueIds then
		self:initScroll(data.data.allQueueIds)
	end
	if data.msg == "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEL" then
		for i, v in ipairs(self.memberListData) do
			if v.data and data.data == v.data.queueId then
				if v.point then
					table.insert(self.tableSpare, v.point)
					v.point:setVisible(false)
					v.point = nil
				end
				table.remove(self.memberListData, i)
				break
			end
		end
		if self.queueIds and #self.queueIds > 0 then
			for i, v in ipairs(self.queueIds) do
				if v == data.data then
					table.remove(self.queueIds, i)
					break
				end
			end
		end
		if self.buildState == gAllianceBuildingStatus.BUILD then
			_ENV = nil
			;(nil).data = nil
			;(nil).isLaunched = false
			;(nil).singleH = 120
			;(nil).point = nil
			;(nil).posY = 0
			;(nil).type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, 2, nil)
		end
		self.curLoad = self.curLoad - 1
	elseif data.msg == "MESSAGE_ALLIANCE_BUILD_INFOLIST_ADD" then
		local index = #self.memberListData - self.curLoad
		if self.buildState == gAllianceBuildingStatus.COMPLETE then
			index = #self.memberListData
			if index == 0 or self.memberListData[index] and self.memberListData[index].type ~= gAWarRallyMemberType.OPEN then
				_ENV = nil
				;(nil).data = nil
				;(nil).isLaunched = false
				;(nil).singleH = 120
				;(nil).point = nil
				;(nil).posY = 0
				;(nil).type = gAWarRallyMemberType.OPEN
				table.insert(self.memberListData, nil)
				index = index + 1
			end
		end
		self.memberListData[index].data = data.data
		self.memberListData[index].type = gAWarRallyMemberType.FULL
		self.curLoad = self.curLoad + 1
	else
		local allianceBuildListData = data.data.queues
		local totalCount = #self.memberListData
		for i, v in ipairs(allianceBuildListData) do
			local index = totalCount - (i + self.curLoad) + 1
			if self.memberListData[index] then
				if self.buildState == gAllianceBuildingStatus.BUILD and self.memberListData[index].type == gAWarRallyMemberType.LOCK then
					_ENV = nil
					;(nil).data = nil
					;(nil).isLaunched = false
					;(nil).singleH = 120
					;(nil).point = nil
					;(nil).posY = 0
					;(nil).type = gAWarRallyMemberType.OPEN
					table.insert(self.memberListData, 2, nil)
					totalCount = #self.memberListData
					index = totalCount - (i + self.curLoad) + 1
				end
				self.memberListData[index].data = v
				self.memberListData[index].type = gAWarRallyMemberType.FULL
				if self.queueIds and #self.queueIds > 0 then
					self.memberListData[index].data.queueId = table.remove(self.queueIds, 1)
				end
			end
		end
		self.curLoad = self.curLoad + #allianceBuildListData
		self.labelNotice:setVisible(self.queueIds and #self.queueIds > 0)
		self.labelNotice:setString(i18n("common_text_089"))
	end
	if self.buildState == gAllianceBuildingStatus.COMPLETE and not kingdomMapCtrl:hasQueue2AllianceBuild(self.buildSingle:getIID()) then
		if #self.memberListData == 0 or self.memberListData[#self.memberListData] and self.memberListData[#self.memberListData].type ~= gAWarRallyMemberType.OPEN then
			_ENV = self.buildSingle:getIID()
			self.buildSingle:getIID().data = nil
			self.buildSingle:getIID().isLaunched = false
			self.buildSingle:getIID().singleH = 120
			self.buildSingle:getIID().point = nil
			self.buildSingle:getIID().posY = 0
			self.buildSingle:getIID().type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, self.buildSingle:getIID())
		end
		self.curLoad = self.curLoad + 1
	end
	self:updateScrollSize()
	self:initMemberList()
	SoraDCloseLoading(self.scroll)
end
function AllianceBuildInfoView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local noticeH = self.labelNotice:isVisible() and 40 or 0
	local scrollInnerNewH = noticeH
	for i, v in ipairs(self.memberListData) do
		if not self.labelNotice:isVisible() or v.data ~= nil then
			v.posY = scrollInnerNewH + v.singleH
			if v.point then
				v.point:initData(v.data, v.type, self.buildSingle)
				v.point:updateOpenShow(self.cantJoin)
				v.isLaunched = v.point:getState()
				v.singleH = v.point:getSingleH()
				v.posY = scrollInnerNewH + v.singleH
				v.point:setPositionY(v.posY)
			end
			scrollInnerNewH = v.posY
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.memberListData) do
			v.posY = v.posY + upto
			if v.point then
				v.point:setPositionY(v.posY)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function AllianceBuildInfoView:initMemberList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 3 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 3 * scrollH, self.scroll
	for i, v in ipairs(self.memberListData) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY and (not self.labelNotice:isVisible() or v.data and self.labelNotice:isVisible()) then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("allianceBuildInfoSingle")
				single:setScroll(self.scroll)
				single:setClickCallBack(handler(self, self.updateScrollSize))
				single:addTo(self.scroll)
			end
			v.point = single
			v.point:initData(v.data, v.type, self.buildSingle)
			v.point:setState(v.isLaunched)
			v.point:updateOpenShow(self.cantJoin)
			v.point:setPosition(cc.p(320, v.posY))
		end
	end
	if offsetY < -50 and self.labelNotice:isVisible() then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	end
end
function AllianceBuildInfoView:initData(bid, iid)
	local ret, building = allianceBuild:getBuilding(bid, iid)
	if gErrDef.Err_None == ret then
		self.buildSingle = building
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
			self:openTimeUp()
		end
		kingdomMapCtrl:reqSuperResQueuesByIds(self.buildSingle:getPos().x, self.buildSingle:getPos().y, self.buildSingle:getIID(), self.queueIds)
		self:updateNormal()
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getContentSize().height / 2))
		self.curLoad = 0
	end
end
function AllianceBuildInfoView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initMemberList()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.fromLoadText and self.queueIds and #self.queueIds > 0 then
			local _ENV, queueIds = #self.queueIds, #self.queueIds
			for i = 1, 8 do
				if self.queueIds[i] then
					table.insert(queueIds, self.queueIds[i])
				else
					break
				end
			end
			kingdomMapCtrl:reqSuperResQueuesByIds(self.buildSingle:getPos().x, self.buildSingle:getPos().y, self.buildSingle:getIID(), queueIds)
			self.fromLoadText = false
			self.labelNotice:setVisible(false)
			SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getContentSize().height / 2))
		end
		self:initMemberList()
	end
end
function AllianceBuildInfoView:updateNormal()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local alliacnePoint = allianceMgr:getAlliance()
	gametop = nil
	;(nil).abbr = alliacnePoint:getProperty("abbr")
	;(nil).name = allianceDesRead.getBuildName(self.buildSingle:getBID())
	self.nodeTitle:setTitle(i18n("common_text_186", nil))
	self.btnRemove:setBright(ownRank >= gAllianceRank.R4)
	self.spriteBuild:setSpriteFrame(allianceDesRead.getBuildIcon(self.buildSingle:getBID()))
end
function AllianceBuildInfoView:openTimeUp()
	if self.buildSingle then
		self.buildState = self.buildSingle:getBuildingStatus()
		if self.buildState == gAllianceBuildingStatus.BUILD then
			self:showBuilding()
		elseif self.buildState == gAllianceBuildingStatus.COMPLETE then
			self:showCollect()
		else
			print("状态出错")
		end
	elseif self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function AllianceBuildInfoView:showBuilding()
	_ENV = nil
	;(nil).point = ""
	self.labelTitle1:setString(i18n("common_text_2140", nil))
	local curValue, totalValue = self.buildSingle:getBuildValueInfo()
	_ENV = i18n("common_text_2140", nil)
	i18n("common_text_2140", nil).member = curValue
	i18n("common_text_2140", nil).total = totalValue
	self.labelValue1:setString(i18n("common_text_155", i18n("common_text_2140", nil)))
	self.labelTitle2:setString(i18n("common_text_2135"))
	_ENV = i18n("common_text_2135")
	i18n("common_text_2135").member = self.buildSingle:getCurNumOfSoldier()
	i18n("common_text_2135").total = self.buildSingle:getMaxNumOfSoldier()
	self.labelValue2:setString(i18n("common_text_155", i18n("common_text_2135")))
	if self.buildSingle:getMaxNumOfSoldier() == 0 then
		self.labelName:setString(i18n("common_text_2139"))
	else
		self.labelName:setString(i18n("common_text_043"))
	end
	local buildTime = self.buildSingle:getBuildRemainTime()
	if buildTime and 0 < buildTime then
		self.labelTitle3:setString(i18n("common_text_2136"))
		self.labelValue3:setString(SoraDConvertSecondToString(buildTime))
		self.labelTitle3:setVisible(true)
		self.labelValue3:setVisible(true)
	else
		self.labelTitle3:setVisible(false)
		self.labelValue3:setVisible(false)
	end
	_ENV = SoraDConvertSecondToString(buildTime)
	SoraDConvertSecondToString(buildTime).build = allianceDesRead.getBuildName(self.buildSingle:getBID())
	self.labelLog:setString(i18n("common_text_2137", SoraDConvertSecondToString(buildTime)))
	local massNum = self.buildSingle:getCurNumOfSoldier()
	local maxMassNum = self.buildSingle:getMaxNumOfSoldier()
	self.cantJoin = massNum >= maxMassNum and 0 < maxMassNum
	_ENV = i18n("common_text_2137", SoraDConvertSecondToString(buildTime))
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).msg = "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE"
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).massNum = massNum
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).maxMassNum = maxMassNum
	SoraDSendMessage(i18n("common_text_2137", SoraDConvertSecondToString(buildTime)))
end
function AllianceBuildInfoView:showCollect()
	local collectData = kingdomMapCtrl:getSuperResCollInfo(self.buildSingle:getIID(), self.buildSingle:getPos().x, self.buildSingle:getPos().y)
	local buildTime = self.buildSingle:getRemainLifeTime()
	kingdomMapCtrl = nil
	;(nil).time = ""
	self.labelTitle1:setString(i18n("common_text_766", nil))
	self.labelValue1:setString(SoraDConvertSecondToString(buildTime))
	self.labelTitle2:setString(i18n("common_text_572"))
	self.labelValue2:setString(string.formatnumberthousands(collectData.speed) .. "/h")
	self.labelTitle3:setString(i18n("common_text_573"))
	self.labelValue3:setString(string.formatnumberthousands(collectData.num))
	if collectData.num == 0 then
		self.labelName:setString(i18n("common_text_2224"))
	else
		self.labelName:setString(i18n("common_text_830"))
	end
	self.labelLog:setString(i18n("common_text_2142"))
end
function AllianceBuildInfoView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		local alliacnePoint = allianceMgr:getAlliance()
		local buildName = allianceDesRead.getBuildName(self.buildSingle:getBID())
		if ownRank >= gAllianceRank.R4 then
			_ENV = self.buildSingle:getBID()
			self.buildSingle:getBID().build = buildName
			SoraDShowMsgBox(i18n("common_text_2144", self.buildSingle:getBID()), i18n("common_text_490"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).build = buildName
					_ENV = nil
					;(nil).build = buildName
					SoraDShowMsgBox(i18n("common_text_2144", nil) .. "\n" .. i18n("common_text_2145", nil), i18n("common_text_490"), i18n("common_text_185"), function(type)
						if type == MSGBOX_CALLBACK_YES then
							allianceBuild:demolishBuilding(self.buildSingle:getBID(), self.buildSingle:getIID())
							self:removeFromParent()
						end
					end)
				end
			end)
		else
			SoraDShowMsgTip(i18n("notice_0073"), "#icon_alliance_R4.png", button)
		end
	end
end
return AllianceBuildInfoView

local socket = require("socket")
local AllianceWarListInfoView = class("allianceWarListInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceWarListInfoView")
	end
	return target
end)
function AllianceWarListInfoView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.tableSingleUI, _ENV, self.tableSpare, _ENV, self.tableShowData, _ENV, self.tableSingleData, _ENV, self.indexID = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), nil
	self.timer = nil
	self.is_delay = false
	self.delay_frame = 0
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeQuickTime = SoraDGetChildByName(self, "Node_quickTime")
	self.nodeQuickTime:setVisible(false)
	self.labelQuickTime = SoraDGetChildByName(self, "Text_quickTime")
	self.imgDefBg = SoraDGetChildByName(self, "Image_defBg")
	self.imgAtkBg = SoraDGetChildByName(self, "Image_atkBg")
	self.imgDefMember = SoraDGetChildByName(self, "Image_defMember")
	self.imgAtkMember = SoraDGetChildByName(self, "Image_atkMember")
	self.labelAtk = SoraDGetChildByName(self, "Text_atk")
	self.labelAtkCount = SoraDGetChildByName(self, "Text_atkCount")
	self.labelDef = SoraDGetChildByName(self, "Text_def")
	self.labelDefCount = SoraDGetChildByName(self, "Text_defCount")
	self.nodeDef = SoraDGetExtendChildFromCCSByName(self, "CCS_allianceWarListInfoSingle_def")
	self.scroll = SoraDGetChildByName(self, "ScrollView_atk")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollH = self.scroll:getContentSize().height
	self.scrollInnerH = self.scrollH
end
function AllianceWarListInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_ADD_NEW", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_UPDATE_STATUS_NEW", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH", handler(self, self.updateDataRefresh))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW", handler(self, self.updateDelete))
end
function AllianceWarListInfoView:updateStatus(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID and self:needRefresh() then
		self:dataSort()
	end
end
function AllianceWarListInfoView:updateDataRefresh(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot or data.indexID == nil then
		return
	end
	_UPVALUE2_ = self.queueRoot
	self.queueRoot[1] = data
	self.queueRoot[2] = self.indexID
	dump(self.queueRoot, "data.indexID == self.indexID", 10)
	if data.indexID == self.indexID then
		local hasQueue = self.queueRoot:isHasWarHallQueues(self.indexID)
		if not hasQueue then
			self:removeFromParent()
		elseif self:needRefresh() then
			self:dataSort()
		end
	else
		self:removeFromParent()
	end
end
function AllianceWarListInfoView:updateDelete(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID then
		local hasQueue = self.queueRoot:isHasWarHallQueues(self.indexID)
		if not hasQueue then
			self:removeFromParent()
		elseif self:needRefresh() then
			self:dataSort()
		end
	end
end
function AllianceWarListInfoView:dataSort(tableSingleData)
	local oldMemberNum = #self.tableSingleData
	self:recycleSprite()
	if tableSingleData then
		self.tableSingleData = tableSingleData
	else
		self.tableSingleData = self.queueRoot:getSortWarHallQueues(self.indexID)
	end
	local showData = self.tableSingleData and self.tableSingleData[1]
	if not showData then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return false
	end
	local showOldData = self.tableShowData
	self.tableShowData = showData
	if self.tableShowData ~= showOldData or oldMemberNum ~= #self.tableSingleData then
		self:initView()
	end
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	self.offsetY = nil
	self.beginIndex = nil
	self.endIndex = nil
	if oldMemberNum ~= #self.tableSingleData then
		self:updateScrollSize()
	end
	self:initMemberList()
	return true
end
function AllianceWarListInfoView:recycleSprite()
	for _, v in pairs(self.tableSingleUI) do
		v:setVisible(false)
		v:resetData()
		table.insert(self.tableSpare, v)
	end
	self.tableSingleUI, _ENV = pairs(self.tableSingleUI)
end
function AllianceWarListInfoView:initData(indexID, tableSingleData, queueRoot)
	self.indexID = indexID
	self.queueRoot = queueRoot
	local ret = self:dataSort(tableSingleData)
	if ret then
		self:showQueue()
	end
	return ret
end
function AllianceWarListInfoView:initView()
	local fromAid = self.tableShowData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local toAid = self.tableShowData:getToAid()
	if fromAid == toAid then
		self.ccs_bg:setTitleName(i18n("common_text_483"), cc.c3b(50, 180, 0))
		self.ccs_bg:setTitleBg("title_activity_lord.png")
	elseif fromAid == selfAid then
		self.ccs_bg:setTitleName(i18n("common_text_008"), cc.c3b(216, 8, 8))
		self.ccs_bg:setTitleBg("title_activity_lord.png")
	elseif toAid == selfAid then
		self.ccs_bg:setTitleName(i18n("common_text_306"), cc.c3b(55, 180, 190))
		self.ccs_bg:setTitleBg("title_battle_lan.png")
	end
	self.nodeDef:initData(self.tableShowData, gAWarViewMemberType.DEFENDER, self.queueRoot)
	self.labelAtk:setString(i18n("common_text_008"))
	self.labelAtkCount:setString(tostring(#self.tableSingleData))
	self.labelDef:setString(i18n("common_text_306"))
	self.labelDefCount:setString(self.tableShowData.to.helpCount or "1")
	if self.tableShowData.to.objType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		self.labelDefCount:setVisible(false)
		self.imgDefMember:setVisible(false)
	end
end
function AllianceWarListInfoView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = math.max(115 * #self.tableSingleData, self.scrollH)
	self.scrollInnerH = scrollInnerNewH
	local minY = self.scrollH - scrollInnerNewH
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	if minY > offsetY then
		offsetY = minY
	elseif 0 < offsetY then
		offsetY = 0
	end
	self.scroll:setInnerContainerSize(cc.size(530, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function AllianceWarListInfoView:initMemberList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if self.offsetY and math.abs(self.offsetY - offsetY) < 100 then
		return
	end
	self.offsetY = offsetY
	local scrollH = self.scrollH
	local scrollMaxH = self.scrollInnerH
	local beginY = math.max(0, offsetY - 115)
	local endY = math.min(scrollMaxH, offsetY + scrollH + 115)
	local beginIndex = math.floor((scrollMaxH - endY) / 115) + 1
	local endIndex = math.ceil((scrollMaxH - beginY) / 115) + 1
	local iterBeginIndex = self.beginIndex and math.min(beginIndex, self.beginIndex) or beginIndex
	local iterEndIndex = self.endIndex and math.max(endIndex, self.endIndex) or endIndex
	self.beginIndex = beginIndex
	self.endIndex = endIndex
	for i = iterBeginIndex, iterEndIndex do
		local v = self.tableSingleData[i]
		if not v then
			break
		end
		if i < beginIndex or i > endIndex then
			local point = self.tableSingleUI[v]
			if point then
				point:setVisible(false)
				table.insert(self.tableSpare, point)
				point:resetData()
				self.tableSingleUI[v] = nil
			end
		else
			local point = self.tableSingleUI[v]
			if point then
				local tag = point:getTag()
				if tag ~= i then
					local posY = scrollMaxH - i * 115
					point:setTag(i)
					v:setPosition(cc.p(293, posY))
				end
			else
				local posY = scrollMaxH - i * 115
				local single
				if 0 < #self.tableSpare then
					single = table.remove(self.tableSpare)
					single:setVisible(true)
				else
					single = SoraDCreatePanel("allianceWarListInfoSingle")
					single:setScroll(self.scroll)
					single:addTo(self.scroll)
				end
				single:initData(v, gAWarViewMemberType.ATTACKER, self.queueRoot)
				single:setPosition(cc.p(293, posY))
				single:setTag(i)
				self.tableSingleUI[v] = single
			end
		end
	end
end
function AllianceWarListInfoView:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self.nodeQuickTime:setVisible(true)
	self:openTimeUp()
end
function AllianceWarListInfoView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initMemberList()
	end
end
function AllianceWarListInfoView:openTimeUp(dt)
	local leftTime = self.tableShowData:getStatusRemainTime()
	if leftTime <= 0 then
		self.labelQuickTime:setString(i18n("endless_treasures_text_14"))
	else
		_ENV = i18n("endless_treasures_text_14")
		i18n("endless_treasures_text_14").time = SoraDConvertSecondToString(leftTime)
		self.labelQuickTime:setString(i18n("common_text_295", i18n("endless_treasures_text_14")))
	end
	SoraDToCenter(self.nodeQuickTime)
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if 0 >= self.delay_time then
			self:dataSort()
			self.is_delay = false
		end
	end
end
local MIN_TIME = 2.0
function AllianceWarListInfoView:needRefresh()
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
return AllianceWarListInfoView

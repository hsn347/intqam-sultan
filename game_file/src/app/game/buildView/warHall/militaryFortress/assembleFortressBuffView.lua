local textParser = include("textParser")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local militaryFortressRead = include("militaryFortressRead")
local assembleFortressBuffView = class("assembleFortressBuffView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("assembleFortressBuffView")
end)
function assembleFortressBuffView:ctor(properties)
	self.modulusList, _ENV = nil, nil
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_25"))
	self.scrollItem = SoraDGetChildByName(self.node, "ScrollView_item")
	SoraDGetChildByName(self.node, "Text_Tips"):setString(i18n("fortress_text_35"))
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeMemSingle = SoraDGetChildByName(self, "Node_MemberSingle")
end
function assembleFortressBuffView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MILITARY_FORTRESS_REFRESH", handler(self, self.msgCallBack))
end
function assembleFortressBuffView:initData(queueID, leaderQueue)
	militaryFortressCtrl = nil
	;(nil).queueID = queueID
	militaryFortressCtrl:reqMilitaryFortessQueueBuffList(nil)
	self.leaderQueue = leaderQueue
	self.queueRoot = kingdomMapCtrl:getQueueRootByWar()
	self.queueList = self.queueRoot:getMassQueuesAttackQueues(leaderQueue)
	dump(self.queueList, "queueList", 100)
end
function assembleFortressBuffView:updateScroll()
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	local index = 0
	local posY = self.totalHeight
	for i, v in ipairs(self.modulusList) do
		local single
		if v.isTitle then
			index = 0
		else
			index = index + 1
		end
		if v.isTitle then
			v.point = self.nodeTitle:clone()
			v.point:addTo(self.scrollItem)
			v.point:setPosition(0, posY - 40)
			posY = posY - 40
		elseif v.uid then
			v.point = self.nodeMemSingle:clone()
			v.point:addTo(self.scrollItem)
			v.point:setPosition(0, posY - 168)
			posY = posY - 168
		else
			v.point = self.nodeSingle:clone()
			v.point:addTo(self.scrollItem)
			v.point:setPosition(0, posY - 38)
			posY = posY - 38
		end
		self:updateItem(v, index)
	end
end
function assembleFortressBuffView:updateItem(v, index)
	local textTitle = SoraDGetChildByName(v.point, "Text_Title")
	local textModulus = SoraDGetChildByName(v.point, "Text_Modulus")
	local textBuffName = SoraDGetChildByName(v.point, "Text_BuffName")
	local textName = SoraDGetChildByName(v.point, "Text_Name")
	local buffScroll = SoraDGetChildByName(v.point, "ScrollView_Buff")
	local textNoMember = SoraDGetChildByName(v.point, "Text_NoMember")
	local btnQuestion = SoraDGetChildByName(v.point, "Button_Question")
	if btnQuestion then
		btnQuestion:setVisible(false)
		if v.showNoMember ~= nil then
			btnQuestion:setVisible(true)
			btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
		end
	end
	if textNoMember then
		textNoMember:setVisible(false)
	end
	if v.showNoMember and textNoMember then
		textNoMember:setVisible(true)
		textNoMember:setString(i18n("common_text_927"))
	end
	if v.isTitle then
		textTitle:setString(i18n(v.text))
	elseif v.uid then
		local head = SoraDGetExtendChildFromCCSByName(v.point, "CCS_commonHead")
		head:setPlayerID(tonumber(v.uid))
		head:setScale(0.72)
		head:setTouchEnabled(false)
		local userInfo = self:getUserInfo(v.uid)
		if userInfo then
			head:setHeadSprite(userInfo.from.headid, userInfo.from.avatar)
			textName:setString(textParser.formatPlayerName(userInfo.from.allianceAbb, userInfo.from.name))
		end
		buffScroll = include("buffScrollView").new(buffScroll)
		buffScroll:setProportion(0.7)
		buffScroll:updateScrollView(cc.size(360, 35), v.buffList, 1)
	else
		local titleStr, valueStr = militaryFortressRead.getTitleAndValueStr(v.attrID, v.attrValue)
		textBuffName:setString(titleStr)
		textModulus:setString(valueStr)
	end
	local spSheer = SoraDGetChildByName(v.point, "Image_2")
	if spSheer then
		spSheer:setVisible(index % 2 == 0)
	end
end
function assembleFortressBuffView:msgCallBack(target, data)
	dump(data.buffList, "msgCallBack", 10)
	local _ENV, totalMemberBuff = dump, dump
	local buffListData = data.buffList
	if buffListData == nil then
		return
	end
	for uid, buffList in pairs(buffListData) do
		if tonumber(uid) ~= self.leaderQueue.from.uid then
			for buffId, value in pairs(buffList) do
				if totalMemberBuff[buffId] then
					totalMemberBuff[buffId] = totalMemberBuff[buffId] + value
					local limit = militaryFortressRead.getBuffLimit(tonumber(buffId)) or 0
					if 0 < limit then
						totalMemberBuff[buffId] = math.min(totalMemberBuff[buffId], limit)
					end
				else
					totalMemberBuff[buffId] = value
				end
			end
		end
	end
	local totalHeight = 0
	_ENV = nil
	;(nil).isTitle = true
	;(nil).text = "fortress_text_26"
	table.insert(self.modulusList, nil)
	totalHeight = totalHeight + 40
	for buffId, value in pairs(data.buffList[tostring(self.leaderQueue.from.uid)]) do
		_ENV = nil
		;(nil).attrID = buffId
		;(nil).attrValue = value
		table.insert(self.modulusList, nil)
		totalHeight = totalHeight + 38
	end
	local haveMember = next(totalMemberBuff)
	_ENV = self.leaderQueue.from.uid
	self.leaderQueue.from.uid.isTitle = true
	self.leaderQueue.from.uid.text = "fortress_text_27"
	self.leaderQueue.from.uid.showNoMember = not haveMember
	table.insert(self.modulusList, self.leaderQueue.from.uid)
	totalHeight = totalHeight + (haveMember and 38 or 68)
	for buffId, value in pairs(totalMemberBuff) do
		_ENV = nil
		;(nil).attrID = buffId
		;(nil).attrValue = value
		table.insert(self.modulusList, nil)
		totalHeight = totalHeight + 38
	end
	if haveMember then
		_ENV = pairs(totalMemberBuff)
		pairs(totalMemberBuff).isTitle = true
		pairs(totalMemberBuff).text = "fortress_text_28"
		table.insert(self.modulusList, pairs(totalMemberBuff))
		totalHeight = totalHeight + 40
		for uid, buffList in pairs(data.buffList) do
			if tonumber(uid) ~= self.leaderQueue.from.uid then
				local _ENV, _buffList = tonumber(uid), tonumber(uid)
				for buffId, value in pairs(buffList) do
					_ENV = tonumber(buffId)
					tonumber(buffId).attrID = buffId
					tonumber(buffId).attrValue = value
					table.insert(_buffList, tonumber(buffId))
				end
				_ENV = pairs(buffList)
				pairs(buffList).uid = uid
				pairs(buffList).buffList = _buffList
				table.insert(self.modulusList, pairs(buffList))
				totalHeight = totalHeight + 168
			end
		end
	end
	self.totalHeight = math.max(600, totalHeight)
	self.scrollItem:setInnerContainerSize(cc.size(550, self.totalHeight))
	self:updateScroll()
end
function assembleFortressBuffView:getUserInfo(uid)
	for i, v in ipairs(self.queueList) do
		if tonumber(v.from.uid) == tonumber(uid) then
			return v
		end
	end
end
function assembleFortressBuffView:btnQuestionClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("fortress_text_31"))
	end
end
return assembleFortressBuffView

local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local HalloweenSendView = class("halloweenSendView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("halloweenSendView")
	end
	return target
end)
function HalloweenSendView:ctor()
	self.itemData, memberMgr, self.tableSpare, memberMgr, self.memberListSingle, memberMgr, self.memberListData, memberMgr, self.selectIndex, memberMgr, self.selectData, memberMgr = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.keyName = nil
	self.fromLoadText = false
	self.nextIndex = nil
	self.isLock = false
	self.canSelectOwn = false
	local ownmember = memberMgr:getOwnMember()
	self.aid = ownmember:getProperty("aid")
	self.isHaveTextField = true
	self.btnAnnounce = SoraDGetChildByName(self, "Button_announce")
	self.btnAnnounce:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNone = SoraDGetChildByName(self, "Text_none")
	self.labelNone:setString(i18n("common_text_963"))
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_invite")
	self.nodeTitle:setTitle(i18n("common_text_2234"))
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.tfdSearch = SoraDGetChildByName(self, "TextField_search")
	self.tfdSearch:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdSearch:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self:addEditBox()
	self.tfdSearch:removeFromParent()
	self.searchByList = SoraDGetChildByName(self, "Node_chooseList")
	self.Image_border = SoraDGetChildByName(self.searchByList, "Image_border")
	self.btnSearchChoose = SoraDGetChildByName(self.searchByList, "Button_choose")
	self.btnSearchChoose:setTitleText(i18n("common_text_2037"))
	self.frameArrow = SoraDGetChildByName(self.searchByList, "frame_arrow")
	self.btnSearchName = SoraDGetChildByName(self.searchByList, "Button_name")
	self.btnSearchName:setTitleText(i18n("common_text_2037"))
	self.btnSearchId = SoraDGetChildByName(self.searchByList, "Button_uid")
	self.btnSearchId:setTitleText("UID")
	self.btnSearchName:setVisible(false)
	self.btnSearchId:setVisible(false)
	display.newSprite("#frame_square_black_08.png", 479.8, 50):addTo(self, 1)
	local bottomBg = display.newSprite("#frame_square_black_08.png", 160.2, 50)
	bottomBg:setFlippedX(true)
	bottomBg:addTo(self, 1)
	self.btnSend = ccui.Button:create("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	self.btnSend:setPosition(cc.p(320, 45))
	self.btnSend:setTitleText(i18n("common_text_073"))
	self.btnSend:setTitleFontSize(20)
	self.btnSend:addTo(self, 1)
	self.scroll:setContentSize(cc.size(640, self.scroll:getContentSize().height - 110))
	self.labelNotice:setVisible(false)
	self.labelNone:setVisible(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
	self.btnSend:addTouchEventListener(handler(self, self.btnSendClickCallBack))
	self.btnSearchChoose:addTouchEventListener(handler(self, self.btnChooseClickCallBack))
	self.btnSearchName:addTouchEventListener(handler(self, self.btnItemClickCallBack))
	self.btnSearchId:addTouchEventListener(handler(self, self.btnItemClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.updateData))
	if self.aid and self.aid ~= 0 then
		allianceQuery:reqMemberList(self.aid)
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	else
		self.labelNone:setVisible(true)
		self.labelNone:setString(i18n("common_text_961"))
	end
	self:updateBtn()
	self.kingdomid = gametop.playertop_:getKingdomID()
	self.searchByUID = false
end
function HalloweenSendView:addEditBox()
	self.textField = ccui.EditBox:create(cc.size(293, 40), "bg_transparent.png", ccui.TextureResType.plistType)
	self.textField:addTo(self.tfdSearch:getParent())
	self.textField:setName("EditBox_textField")
	self.textField:setAnchorPoint(cc.p(0, 0))
	self.textField:setPosition(cc.p(2, 5))
	self.textField:setFontColor(cc.c3b(0, 0, 0))
	self.textField:setTextHorizontalAlignment(SoraDFLabelR())
	if self.textField.setControlType then
		self.textField:setControlType(1)
	end
	self.textField:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	local inputFontSize = 24
	self.textField:setFontSize(inputFontSize)
	self.textField:setPlaceholderFontSize(inputFontSize)
	function self.textField:getCharCount()
		return string.utf8len(self:getText())
	end
	self.textField:setPlaceholderFontColor(cc.c3b(115, 99, 68))
	self.textField:setText("")
	self.Image_border = SoraDGetChildByName(self, "Image_border")
	self.selectBg = display.newSprite("#frame_battlefield_base_grey_02.png")
	self.selectBg:addTo(self.Image_border)
	self.selectBg:setAnchorPoint(cc.p(0, 1))
	self.selectBg:setPosition(cc.p(0, 0))
	self.selectBg:setContentSize(cc.size(150, 0))
	self.selectBg:setOpacity(170)
end
function HalloweenSendView:initData(itemID, otherCon)
	self.itemData.id = itemID
	self.itemData.count = math.min(backpackCtrl:getItemCount(itemID), backpackltCtrl:getUseMax(itemID))
	if otherCon and next(otherCon) then
		self.otherCon = otherCon
	end
end
function HalloweenSendView:setOwnSelect(enable)
	self.canSelectOwn = enable
end
function HalloweenSendView:btnSendClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, tableUID = SoraDPlaySound, SoraDPlaySound
		for k, v in pairs(self.selectData) do
			table.insert(tableUID, tonumber(k))
		end
		backpackCtrl:reqUseItem(self.itemData.id, #tableUID, tableUID)
		self:removeFromParent()
	end
end
function HalloweenSendView:btnChooseClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.chooseListShow then
			self.frameArrow:setRotation(0)
			self.btnSearchName:setVisible(false)
			self.btnSearchId:setVisible(false)
			self.chooseListShow = false
		else
			self.frameArrow:setRotation(90)
			self.btnSearchName:setVisible(true)
			self.btnSearchId:setVisible(true)
			self.chooseListShow = true
		end
		if not tolua.isnull(self.selectBg) then
			self.selectBg:setContentSize(cc.size(150, self.chooseListShow and 110 or 0))
		end
	end
end
function HalloweenSendView:btnItemClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.btnSearchChoose:setTitleText(button == self.btnSearchName and i18n("common_text_2037") or "UID")
		if button == self.btnSearchName then
			self.searchByUID = false
		else
			self.searchByUID = true
		end
		self.frameArrow:setRotation(0)
		self.btnSearchName:setVisible(false)
		self.btnSearchId:setVisible(false)
		self.chooseListShow = false
		if not tolua.isnull(self.selectBg) then
			self.selectBg:setContentSize(cc.size(150, self.chooseListShow and 110 or 0))
		end
	end
end
function HalloweenSendView:btnSearchClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local key = string.match(self.textField:getText(), "%s*(.-)%s*$")
		local keyLen = string.utf8len(key)
		if keyLen >= SEARCH_MIN_LEN then
			self.keyname = key
			if self.searchByUID then
				lordInfoCtrl:searchLordInThisKingdomsReq("", self.kingdomid, tonumber(self.keyname) or 0, lordSearchType.PIGEON)
			else
				lordInfoCtrl:searchLordInThisKingdomsReq(self.keyname, self.kingdomid, nil, lordSearchType.PIGEON)
			end
			SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
		else
			SoraDShowMsgBox(i18n("common_text_961"), i18n("common_text_054"))
		end
	end
end
function HalloweenSendView:updateBtn()
	local haveData = table.nums(self.selectData) > 0
	self.btnSend:setTouchEnabled(haveData)
	self.btnSend:setBright(haveData)
end
function HalloweenSendView:recoverAllSingle()
	for i, v in ipairs(self.memberListSingle) do
		if v.single ~= nil then
			v.single:setVisible(false)
			table.insert(self.tableSpare, v.single)
			v.single = nil
		end
	end
	self.memberListSingle, _ENV = ipairs(self.memberListSingle)
end
function HalloweenSendView:updateData(target, data)
	if data.msg == "MESSAGE_ITEM_LORD_SEARCH_BACK" then
		local retdata = data.data
		self.nextIndex = retdata.nextindex
		if not self.fromLoadText then
			self:recoverAllSingle()
			self.memberListData, _ENV, self.selectIndex, _ENV = self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle, self.recoverAllSingle
			self.scroll:jumpToTop()
		end
		self.fromLoadText = false
		for i, v in ipairs(retdata.uinfolist) do
			if self.selectData[tostring(v.uid)] == nil then
				table.insert(self.memberListData, v)
			end
		end
		if table.nums(self.selectIndex) <= 0 and table.nums(self.selectData) > 0 then
			for k, v in pairs(self.selectData) do
				table.insert(self.memberListData, 1, v)
				self.selectIndex[tostring(table.nums(self.selectIndex) + 1)] = true
			end
		end
		self:updateNotice()
	else
		local allianceData = allianceMgr:getMemberList(self.aid)
		_UPVALUE6_ = allianceMgr
		allianceMgr[1] = "5"
		allianceMgr[2] = "6"
		allianceMgr[3] = "4"
		allianceMgr[4] = "3"
		allianceMgr[5] = "2"
		local allianceMgr[6], tableMemberListKey = "1", allianceMgr
		for i, v in ipairs(tableMemberListKey) do
			local rankData = allianceData[v]
			if rankData then
				for i, v in ipairs(rankData) do
					table.insert(self.memberListData, v)
				end
			end
		end
	end
	if not self.canSelectOwn then
		local ownuid = lordInfoCtrl:getLordInfo().base.uid
		for i, v in ipairs(self.memberListData) do
			local uid = v.uid or v:getProperty("uid")
			if uid == ownuid then
				table.remove(self.memberListData, i)
				break
			end
		end
	end
	self:updateScrollWithData()
	self:initSearchList()
	SoraDCloseLoading(self.scroll)
end
function HalloweenSendView:updateScrollWithData()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local needH = 230 * math.ceil(#self.memberListData / 2)
	local noticeH = self.labelNotice:isVisible() and 40 or 0
	local scrollInnerNewH = math.max(self.scroll:getContentSize().height, noticeH + needH)
	for i, v in ipairs(self.memberListData) do
		local single = self.memberListSingle[i]
		if single == nil then
			_ENV = nil
			;(nil).single = nil
			;(nil).pos = SoraDFPoint(160 + i % 2 * 320, scrollInnerNewH - math.floor((i - 1) / 2) * 230)
			;(nil).data = v
			table.insert(self.memberListSingle, nil)
		else
			single.pos = SoraDFPoint(160 + i % 2 * 320, scrollInnerNewH - math.floor((i - 1) / 2) * 230)
			if single.single then
				single.single:setPosition(single.pos)
			end
		end
	end
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function HalloweenSendView:updateNotice()
	self.labelNone:setVisible(#self.memberListData <= 0)
	self.labelNotice:setString(i18n("common_text_963"))
	self.labelNotice:setVisible(self.nextIndex ~= nil)
	self.labelNotice:setString(i18n("common_text_089"))
end
function HalloweenSendView:initSearchList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.memberListSingle) do
		if v.single then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.single:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.single = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("halloweenSendSingle")
				single:setHandle(handler(self, self.clickMemberBack))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			single:setTag(i)
			single:setCheck(self.selectIndex[tostring(i)] == true)
			_ENV = tostring(i)
			tostring(i).isLock = self.isLock
			single:lockSingle(nil, (tostring(i)))
			single:setlimitCon(self.otherCon)
			v.single = single
		end
	end
	if offsetY < -50 and self.labelNotice:isVisible() then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	end
end
function HalloweenSendView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.fromLoadText and self.keyname and self.nextIndex then
		if self.searchByUID then
			lordInfoCtrl:searchLordInThisKingdomsReq("", self.kingdomid, tonumber(self.keyname) or 0, lordSearchType.PIGEON)
		else
			lordInfoCtrl:searchLordInThisKingdomsReq(self.keyname, self.kingdomid, nil, lordSearchType.PIGEON)
		end
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	end
	self:initSearchList()
end
function HalloweenSendView:clickMemberBack(target, lordData)
	local uid = lordData.data.uid or lordData.data:getProperty("uid")
	local tag = target:getTag()
	if lordData.isSelect then
		self.selectData[tostring(uid)] = lordData.data
		self.selectIndex[tostring(tag)] = true
	else
		self.selectData[tostring(uid)] = nil
		self.selectIndex[tostring(tag)] = nil
	end
	local maxCount = self.itemData.count
	if 827901 == self.itemData.id then
		maxCount = math.min(20, self.itemData.count)
	end
	self.isLock = maxCount <= table.nums(self.selectData)
	_ENV = self.selectData
	self.selectData.msg = "MESSAGE_HALLOWEEN_LOCK"
	self.selectData.isLock = self.isLock
	SoraDSendMessage(self.selectData)
	self:updateBtn()
end
return HalloweenSendView

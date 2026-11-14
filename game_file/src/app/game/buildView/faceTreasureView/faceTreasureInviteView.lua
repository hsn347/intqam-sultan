local GridScrollView = include("GridScrollView")
local FaceTreasureInviteView = class("faceTreasureInviteView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("faceTreasureInviteView")
	end
	return target
end)
function FaceTreasureInviteView:ctor()
	self.ocxList, _ENV, self.reqRedata, _ENV = nil, nil, nil, nil
	self.isAnyOneSelected = true
	self.txtSearch = SoraDGetChildByName(self, "TextField_search")
	self.txtSearch:setTextHorizontalAlignment(SoraDFLabelR())
	self.txtSearch:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnCancel = SoraDGetChildByName(self, "Button_cancel")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_faceInvite")
	self.imgCopy = SoraDGetChildByName(self, "Image_head")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.scroll:addTouchEventListener(handler(self, self.scrollClick))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_ALLFRIENDS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_ALLNEXTFRIENDS", handler(self, self.refreshData))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnCancel:addTouchEventListener(handler(self, self.btnCancelClick))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnHelp:setTitleText(i18n("common_text_2245"))
	self.btnCancel:setTitleText(i18n("common_text_2246"))
	self.txtTip:setString(i18n("common_text_074"))
	self:addDoubleFireEffect()
	self:dropScroll()
	self:req4Info()
end
function FaceTreasureInviteView:req4Info(...)
	facebookFriendModule.getFBAllFriends()
	SoraDShowLoading(self)
end
function FaceTreasureInviteView:refreshData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.redata then
		self.reqRedata = json.decode(redata.redata)
		if self.reqRedata then
			self.state = tonumber(self.reqRedata.flag)
			local addList = self.reqRedata.friendList
			local addListKeys = table.keys(addList)
			for i, v in ipairs(addListKeys) do
				local item = self:createSingle()
				item:initData(addList[v])
				item:addTo(self.scroll)
				_ENV = self.scroll
				self.scroll.single = item
				table.insert(self.ocxList, self.scroll)
			end
			local mRow = math.ceil(#self.ocxList / 5)
			local sSize = self.scroll:getContentSize()
			local per = sSize.width / 5
			local sH = math.max(mRow * 170, sSize.height)
			self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
			self:dropScroll()
			for i, v in ipairs(self.ocxList) do
				local _x = sSize.width - (i - 1) % 5 * per - per / 2
				local _y = sH - math.floor((i - 1) / 5) * 170 - 61
				v.single:setPosition(_x, _y)
				v.pos = cc.p(_x, _y)
				v.isHide = false
				v.single:setVisible(true)
			end
		else
			self.txtTip:setString(i18n("common_text_2261"))
		end
	end
end
function FaceTreasureInviteView:initData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.redata then
		self.reqRedata = json.decode(redata.redata)
		if self.reqRedata then
			self.state = tonumber(self.reqRedata.flag)
			self.friendList = self.reqRedata.friendList
			self.friendListKeys = table.keys(self.friendList)
			self:initView()
		end
	end
end
function FaceTreasureInviteView:initView(...)
	local row = math.ceil(#self.friendListKeys / 5)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(row * 170, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self:dropScroll()
	local per = sSize.width / 5
	for i, v in ipairs(self.friendListKeys) do
		local item = self:createSingle()
		item:initData(self.friendList[v])
		item:addTo(self.scroll)
		local _x = sSize.width - (i - 1) % 5 * per - per / 2
		local _y = sH - math.floor((i - 1) / 5) * 170 - 61
		item:setPosition(_x, _y)
		_ENV = _x
		_x.single = item
		_x.pos = cc.p(_x, _y)
		_x.isHide = false
		table.insert(self.ocxList, _x)
	end
end
function FaceTreasureInviteView:createSingle(...)
	local headItem = self.imgCopy:clone()
	headItem = include("faceTreasureInviteHead").new(headItem)
	headItem:setFatherClickHandl(handler(self, self.headClick))
	return headItem
end
function FaceTreasureInviteView:dropScroll()
	local sSize = self.scroll:getContentSize()
	self.txtTip:setString(i18n("common_text_074"))
	self.txtTip:setPosition(sSize.width / 2, -25)
end
function FaceTreasureInviteView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScroll()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		print("触发底部")
		if self.isDisEnough then
			self:search4Match("", true)
			facebookFriendModule.getFBAllFriends(true)
			self:changeState(false)
		end
	end
end
function FaceTreasureInviteView:changeState(bool)
	if bool then
		self.isDisEnough = true
		self.txtTip:setString(i18n("common_text_084"))
	else
		self.isDisEnough = false
		self.txtTip:setString(i18n("common_text_074"))
	end
end
function FaceTreasureInviteView:scrollClick(target, eventType)
	local judgeDis = function(...)
		local ePos = target:getTouchMovePosition()
		local dis = cc.pGetDistance(self.sPos, ePos)
		if 100 < dis then
			self:changeState(true)
		end
	end
	if eventType == ccui.TouchEventType.ended then
	elseif eventType == ccui.TouchEventType.canceled then
	elseif eventType == ccui.TouchEventType.moved then
		judgeDis()
	elseif eventType == ccui.TouchEventType.began then
		self:changeState(false)
		self.sPos = target:getTouchBeganPosition()
	end
end
function FaceTreasureInviteView:updateScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for k, v in pairs(self.ocxList) do
		if v.pos then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				if v.single then
					v.single:setVisible(false)
				end
			elseif v.single and not v.isHide then
				v.single:setVisible(true)
			end
		end
	end
end
function FaceTreasureInviteView:btnSearchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("btn click")
		SoraDPlaySound()
		local sData = self.txtSearch:getString()
		if sData ~= "" then
			self:search4Match(sData)
			self.txtSearch:setString("")
		else
			self:search4Match(sData, true)
		end
	end
end
function FaceTreasureInviteView:search4Match(str, _allShow)
	local judgeSearch = function(_str, _ins)
		if _ins and _ins.single then
			local oriStr = string.lower(_ins.single:returnName())
			print("result:", string.find(oriStr, _str), "oriStr", oriStr, "_str", _str)
			if string.find(oriStr, string.lower(_str), 1, true) then
				return false
			else
				return true
			end
		end
	end
	local _ENV, tmpOcxTbl
	for i, v in ipairs(self.ocxList) do
		if _allShow then
			v.isHide = false
			table.insert(tmpOcxTbl, v)
		elseif judgeSearch(str, v) then
			v.isHide = true
			v.single:setVisible(false)
		else
			v.isHide = false
			table.insert(tmpOcxTbl, v)
		end
	end
	if next(tmpOcxTbl) ~= nil then
		local mRow = math.ceil(#tmpOcxTbl / 5)
		local sSize = self.scroll:getContentSize()
		local sH = math.max(mRow * 170, sSize.height)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		self:dropScroll(sSize)
		local per = sSize.width / 5
		for i, v in ipairs(tmpOcxTbl) do
			local _x = sSize.width - (i - 1) % 5 * per - per / 2
			local _y = sH - math.floor((i - 1) / 5) * 170 - 61
			v.single:setPosition(_x, _y)
			v.pos = cc.p(_x, _y)
			v.single:setVisible(true)
		end
	end
end
function FaceTreasureInviteView:btnHelpClick(button, eventType)
	local recordIn = function(num)
		local gametop = gModuleMgr.getObject("gametop")
		local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
		local gameinfo = fbTreasureCtrl:getData()
		_ENV = fbTreasureCtrl
		fbTreasureCtrl.type = 2
		fbTreasureCtrl.chestlv = gameinfo.lv
		fbTreasureCtrl.chestsc = gameinfo.cur
		fbTreasureCtrl.chestscMax = gameinfo.total
		local fbTreasureCtrl.postNum, postTbl = num, fbTreasureCtrl
		facebookFriendModule.recordInfo(postTbl)
	end
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).game = i18n("common_text_1012")
		local _msg = i18n("common_text_2260", nil)
		local userList = ""
		local isFirst = true
		for i, v in ipairs(self.ocxList) do
			if v.single and v.single:returnIsCheck() and not v.isHide then
				if isFirst then
					userList = v.single:getFID()
					isFirst = false
				else
					userList = userList .. "," .. v.single:getFID()
				end
			end
		end
		print("userList:", userList)
		if userList ~= "" then
			facebookFriendModule.call4HelpFB(_msg, userList)
			recordIn(#self.ocxList)
		else
			SoraDShowMsgTip(i18n("common_text_2266"))
		end
	end
end
function FaceTreasureInviteView:btnCancelClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isAnyOneSelected then
			for i, v in ipairs(self.ocxList) do
				if v.single then
					v.single:setMeCheck(false)
				end
			end
		else
			for i, v in ipairs(self.ocxList) do
				if v.single then
					v.single:setMeCheck(true)
				end
			end
		end
		self:headClick()
	end
end
function FaceTreasureInviteView:headClick()
	local selectFlag = false
	for i, v in ipairs(self.ocxList) do
		if v.single and v.single:returnIsCheck() then
			selectFlag = true
		end
	end
	self.isAnyOneSelected = selectFlag
	if selectFlag then
		self.btnCancel:setTitleText(i18n("common_text_2246"))
	else
		self.btnCancel:setTitleText(i18n("common_text_404"))
	end
end
function FaceTreasureInviteView:addDoubleFireEffect(...)
	SoraDCreateFireEffectNode(SoraDGetChildByName(self, "frame_lace_base_2"), SoraDGetChildByName(self, "frame_lace_base_3"))
end
return FaceTreasureInviteView

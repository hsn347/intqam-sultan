local AllianceInviteView = class("allianceInviteView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInviteView")
	end
	return target
end)
_ENV, _UPVALUE2_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInviteView")
	end
	return target
end, "allianceInviteView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInviteView")
	end
	return target
end).name = "common_text_3155"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInviteView")
	end
	return target
end).eventType = nil, 1
;(nil).name = "UID"
;(nil).eventType = 2
;("allianceInviteView")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInviteView")
	end
	return target
end
local ("allianceInviteView")[2], sortTypeList = nil, "allianceInviteView"
function AllianceInviteView:ctor()
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	self.tableSpare, _ENV, self.memberListData, _ENV = memberMgr, memberMgr, memberMgr, memberMgr
	self.keyName = nil
	self.pid = nil
	self.nextIndex = nil
	self.aid = ownmember:getProperty("aid")
	self.fromLoadText = false
	self.isHaveTextField = true
	self.switcher = false
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNone = SoraDGetChildByName(self, "Text_none")
	self.labelNone:setString(i18n("common_text_963"))
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_invite")
	self.nodeTitle:setTitle(i18n("common_text_202"))
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.txtFieldCode = SoraDGetChildByName(self, "TextField_search")
	self.txtFieldCode:setTextHorizontalAlignment(SoraDFLabelR())
	self.txtFieldCode:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.btnAnnounce = SoraDGetChildByName(self, "Button_announce")
	self.imgGold = SoraDGetChildByName(self, "Image_gold")
	self.labelAnnounce = SoraDGetChildByName(self, "Text_announce")
	self.labelAnnounce:setString(i18n("common_text_201"))
	self.labelGold = SoraDGetChildByName(self, "Text_gold")
	self.labelGold:setString(tostring(gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD))
	self.labelNotice:setVisible(false)
	self.labelNone:setVisible(false)
	self.Node_chooseList = SoraDGetChildByName(self, "Node_chooseList")
	self.Text_choose = SoraDGetChildByName(self.Node_chooseList, "Text_choose")
	self.Image_border = SoraDGetChildByName(self.Node_chooseList, "Image_border")
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.Button_choose:setTitleText(i18n("common_text_3155"))
	self.Button_name = SoraDGetChildByName(self, "Button_name")
	self.Button_name:setTitleText(i18n("common_text_3155"))
	self.Button_name:addTouchEventListener(handler(self, self.onNameClick))
	self.Button_uid = SoraDGetChildByName(self, "Button_uid")
	self.Button_uid:setTitleText(i18n("UID"))
	self.Button_uid:addTouchEventListener(handler(self, self.onUIDClick))
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnAnnounce:addTouchEventListener(handler(self, self.btnAnnounceClickCallBack))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_INVITE_LIST_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_NOTICE_INVITE_SUCCESS", function(...)
		SoraDCloseLoading(self.btnAnnounce)
	end)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	allianceQuery:queryAllianceInviteList(self.aid, 1, self.keyName)
	SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getContentSize().height / 2))
	self.curSortType = 1
	self:setSwitcher()
	self:changeToEditBox()
end
function AllianceInviteView:clearOld()
	for i, v in ipairs(self.memberListData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
			v.point = nil
		end
	end
	self.memberListData, _ENV = ipairs(self.memberListData)
	self.labelNotice:setVisible(false)
	self.labelNone:setVisible(false)
	self:updateScrollSize()
	self.scroll:jumpToTop()
end
function AllianceInviteView:initData(target, data)
	self.nextIndex = data.data.nextindex
	local allianceInviteListData = data.data.uinfolist
	self.labelNotice:setVisible(self.nextIndex ~= nil)
	self.labelNone:setVisible(#allianceInviteListData <= 0)
	for i, v in ipairs(allianceInviteListData) do
		_ENV = nil
		;(nil).data = v
		_ENV, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.memberListData, nil)
	end
	self.labelNotice:setString(i18n("common_text_089"))
	self:updateScrollSize()
	self:initMemberList()
	SoraDCloseLoading(self.scroll)
end
function AllianceInviteView:initMemberList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.memberListData) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("allianceMemberSingle")
				single:setScroll(self.scroll)
				single:setHandle(handler(self, self.inviteMemberBack))
				single:addTo(self.scroll)
			end
			single:initData(nil, v.data, nil)
			single:setPosition(v.pos)
			v.point = single
		end
	end
	if offsetY < -50 and self.labelNotice:isVisible() then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	end
end
function AllianceInviteView:inviteMemberBack(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank < gAllianceRank.R4 then
		SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_204"))
	else
		SoraDShowMsgBox(i18n("common_text_2301"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				local allianceMgr = gametop.playertop_:getModule("allianceMgr")
				allianceMgr:reqInviteJoin(data.uid)
				for i, v in ipairs(self.memberListData) do
					if v.point == target then
						v.point:setVisible(false)
						table.insert(self.tableSpare, v.point)
						table.remove(self.memberListData, i)
						break
					end
				end
				self:updateScrollSize()
				self:initMemberList()
			end
		end)
	end
end
function AllianceInviteView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local noticeH = self.labelNotice:isVisible() and 40 or 0
	local scrollInnerNewH = math.max(noticeH + 230 * math.ceil(#self.memberListData / 2), self.scroll:getContentSize().height)
	for i, v in ipairs(self.memberListData) do
		v.pos = SoraDFPoint(160 + i % 2 * 320, scrollInnerNewH - math.floor((i - 1) / 2) * 230)
		if v.point then
			v.point:setPosition(v.pos)
		end
	end
	scrollInnerNewH = scrollInnerNewH + 10
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
end
function AllianceInviteView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initMemberList()
	elseif event == ccui.ScrollviewEventType.bounceBottom and self.fromLoadText then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		print("sldkjflksdjflskdjf", self.keyName, self.pid)
		allianceQuery:queryAllianceInviteList(self.aid, self.nextIndex, self.keyName, self.pid)
		self.fromLoadText = false
		self.labelNotice:setVisible(false)
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getContentSize().height / 2))
	end
end
function AllianceInviteView:btnAnnounceClickCallBack(button, type)
	if type == ccui.TouchEventType.ended and SoraDEnoughGold(gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD) then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank < gAllianceRank.R4 then
			SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_204"))
		else
			SoraDShowMsgBox(i18n("common_text_855"), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					local allianceMgr = gametop.playertop_:getModule("allianceMgr")
					allianceMgr:reqNoticeInvite()
					local loading = SoraDShowLoading(button, cc.size(button:getContentSize().width * 2, button:getContentSize().height * 2))
					loading:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
					loading:setScale(0.5)
				end
			end)
		end
	end
end
function AllianceInviteView:btnSearchClickCallBack(button, ttype)
	if ttype == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		local keyname = self.txtFieldCode:getText()
		local pid = self.txtFieldCode:getText()
		if not keyname or type(keyname) ~= "string" or string.utf8len(keyname) <= 0 then
			return
		end
		if self.curSortType == 1 then
			self.keyName = keyname
			self.pid = nil
		else
			self.keyName = nil
			self.pid = pid
		end
		print("sjdhfsldkfsdkjhfjk", self.keyName, self.pid)
		allianceQuery:queryAllianceInviteList(self.aid, 1, self.keyName, self.pid)
		self:clearOld()
		SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getContentSize().height / 2))
	end
end
function AllianceInviteView:onChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = not self.switcher
		self:setSwitcher()
	end
end
function AllianceInviteView:onNameClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("按名字排序")
		self.switcher = false
		self.curSortType = 1
		self:setSwitcher()
	end
end
function AllianceInviteView:onUIDClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("按uid排序")
		self.switcher = false
		self.curSortType = 2
		self:setSwitcher()
	end
end
function AllianceInviteView:setSwitcher()
	self.Button_choose:setTitleText(i18n(sortTypeList[self.curSortType].name))
	self.Button_name:setVisible(self.switcher)
	self.Button_uid:setVisible(self.switcher)
	self.Image_border:setContentSize(cc.size(150, self.switcher and 150 or 60))
end
function AllianceInviteView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	end
end
function AllianceInviteView:changeToEditBox()
	if self.txtFieldCode then
		local size = self.txtFieldCode:getContentSize()
		local pos = cc.p(self.txtFieldCode:getPositionX(), self.txtFieldCode:getPositionY())
		local ap = self.txtFieldCode:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		editBox:setMaxLength(20)
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.txtFieldCode:getParent())
		if device.platform ~= "mac" then
			editBox:setTextHorizontalAlignment(SoraDFLabelR())
		end
		editBox:setPlaceHolder("")
		editBox:setPlaceholderFontColor(cc.c3b(170, 170, 170))
		editBox:setPlaceholderFontSize(20)
		self.txtFieldCode:removeFromParent()
		self.txtFieldCode = editBox
	end
end
function AllianceInviteView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		target:touchDownAction(target, type)
	end
end
return AllianceInviteView

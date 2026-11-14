local allianceTerritoryAPI = include("allianceTerritoryAPI")
local resDesRead = include("resDesRead")
local lordLocalData = include("lordLocalData")
local AllianceWarehouseLogView = class("allianceWarehouseLogView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceWarehouseLogView")
	end
	return target
end)
function AllianceWarehouseLogView:ctor()
	self.tableSpare, _ENV, self.memberListData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.keyName = nil
	self.nextIndex = nil
	self.fromLoadText = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3019"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_log")
	self.baseSingle = SoraDGetChildByName(self, "Image_single")
	self.tableSpare[1] = self.baseSingle
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.noTip = SoraDGetChildByName(self, "Center_no_tip")
	self.noTip:setString(i18n("god_beast_text_16"))
	self.tableSpare[1]:setVisible(false)
	self.labelNotice:setVisible(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS", handler(self, self.dataBack))
	SoraDShowLoading(self.scroll):setPosition(cc.p(self.scroll:getContentSize().width / 2, self.scroll:getContentSize().height / 2))
	allianceTerritoryAPI:loadTaxRecordList(nil, 10)
end
function AllianceWarehouseLogView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initMemberList()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.fromLoadText and self.nextIndex then
			allianceTerritoryAPI:loadTaxRecordList(self.nextIndex, 10)
			self.fromLoadText = false
			self.labelNotice:setVisible(false)
			SoraDShowLoading(self.scroll):setPosition(cc.p(self.scroll:getContentSize().width / 2, self.scroll:getContentSize().height / 2))
		end
		self:initMemberList()
	end
end
function AllianceWarehouseLogView:dataBack(target, data)
	self.nextIndex = data.nextReqFlag
	local allianceInviteListData = data.data
	self.labelNotice:setVisible(data.more)
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
function AllianceWarehouseLogView:initMemberList()
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
			else
				single = self.baseSingle:clone()
				single:addTo(self.scroll)
			end
			local labelName = SoraDGetChildByName(single, "Text_name")
			local labelTime = SoraDGetChildByName(single, "Text_time")
			local imgHead = SoraDGetChildByName(single, "Image_head")
			local labelValueTitle = SoraDGetChildByName(single, "Text_valueTitle")
			local labelValue = SoraDGetChildByName(single, "Text_value")
			local imgIcon = SoraDGetChildByName(single, "Image_icon")
			if v.data.uInfo.allianceAbbr then
				_ENV = nil
				;(nil).abbr = v.data.uInfo.allianceAbbr
				;(nil).name = v.data.uInfo.nickname
				labelName:setString(i18n("common_text_186", nil))
			else
				labelName:setString(v.data.uInfo.nickname)
			end
			labelTime:setString(SoraDConvertTimeToDate(v.data.t))
			labelValue:setString(string.formatnumberthousands(v.data.res.num))
			labelValueTitle:setString(i18n("common_text_3020"))
			SoraDGetHeadFromManager(imgHead, v.data.uInfo.userIcon, v.data.uInfo.avatar)
			imgIcon:loadTexture(resDesRead.getIcon(v.data.res.id), ccui.TextureResType.plistType)
			imgIcon:setPositionX(labelValueTitle:getPositionX() - SoraDFSign(labelValueTitle:getContentSize().width + 5))
			labelValue:setPositionX(imgIcon:getPositionX() - SoraDFSign(imgIcon:getContentSize().width + 5))
			single:setPosition(v.pos)
			single:setVisible(true)
			v.point = single
		end
	end
	self.noTip:setVisible(0 >= #self.memberListData)
	if offsetY < -50 and self.labelNotice:isVisible() then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	end
end
function AllianceWarehouseLogView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local noticeH = self.labelNotice:isVisible() and 40 or 0
	local scrollInnerNewH = math.max(noticeH + 90 * #self.memberListData, self.scroll:getContentSize().height)
	for i, v in ipairs(self.memberListData) do
		v.pos = cc.p(235, scrollInnerNewH - (i - 1) * 90 - 5)
		if v.point then
			v.point:setPosition(v.pos)
		end
	end
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(470, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
return AllianceWarehouseLogView

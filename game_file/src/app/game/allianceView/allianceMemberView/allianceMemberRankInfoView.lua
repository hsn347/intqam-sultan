local gametop = gModuleMgr.getObject("gametop")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local AllianceMemberRankInfoView = class("allianceMemberRankInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMemberRankInfoView")
	end
	return target
end)
function AllianceMemberRankInfoView:ctor()
	self.tableChangeData, _ENV, self.tabelBlackRect, _ENV, self.tabelSetRect, _ENV, self.tableRankData, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_rank")
	self.nodeTitle:setTitle(i18n("common_text_206"))
	self.tableImgRank = SoraDGetChildsArrayByName(self, "Image_rank_", 6, 1)
	self.tableImgLine = SoraDGetChildsArrayByName(self, "Image_line_", 6, 1)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.imgBg1 = SoraDGetChildByName(self, "Image_bg1")
	self.imgBg2 = SoraDGetChildByName(self, "Image_bg2")
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnChange:setTitleText(i18n("common_text_244"))
	self.btnChange:setTag(0)
	self.scroll:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
	self:initData()
end
function AllianceMemberRankInfoView:initData()
	local allianceDesRead = include("allianceDesRead")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	self.btnChange:setVisible(ownRank == gAllianceRank.R5)
	self.tableRankData = permissionCtrl:getShowList()
	self.labelDes:setString(i18n("common_text_223"))
	local rowNum = #self.tableRankData
	local singleW = 200
	local desH = SoraDGetAutoHeightLabel(self.labelDes)
	local btnH = self.btnChange:isVisible() and 100 or 0
	local scrollH = desH + btnH + 50
	self.labelDes:setPositionY(desH + 30)
	self.btnChange:setPositionY(desH + 80)
	for i, v in ipairs(self.tableRankData) do
		local maxH = 0
		local labelValue = ccui.Text:create("", "", 20)
		labelValue:ignoreContentAdaptWithSize(false)
		local tmpSingleW = singleW
		labelValue:setTextHorizontalAlignment(SoraDFLabelR())
		labelValue:setTextAreaSize(cc.size(tmpSingleW - 10, 0))
		labelValue:setString(allianceDesRead.getPermissionDes(v.key))
		labelValue:setAnchorPoint(cc.p(1, 0.5))
		labelValue:setTextColor(cc.c4b(205, 150, 75, 255))
		local tmpH = math.max(24, labelValue:getVirtualRendererSize().height)
		labelValue:setTextAreaSize(cc.size(tmpSingleW - 30, tmpH))
		if maxH < tmpH then
			maxH = tmpH
		end
		maxH = maxH + 14
		scrollH = scrollH + maxH
		labelValue:setPosition(cc.p(625, scrollH - 7 - 0.5 * tmpH))
		labelValue:addTo(self.scroll)
		local imgLine = ccui.ImageView:create("frame_line_14_01.png", ccui.TextureResType.plistType)
		imgLine:setAnchorPoint(cc.p(0.5, 0.5))
		imgLine:setPosition(cc.p(320, scrollH + 0.5))
		imgLine:setScale9Enabled(true)
		imgLine:setContentSize(cc.size(630, 8))
		imgLine:addTo(self.scroll)
		SoraDFTarget(labelValue)
		SoraDFTarget(imgLine)
		local _ENV, tableYesSprite = SoraDFTarget, SoraDFTarget
		local _ENV, tableStaticYesSprite = imgLine, imgLine
		for k, value in pairs(v.data) do
			local posX = self.tableImgRank[k]:getPositionX()
			local posY = scrollH - 6 - 0.5 * tmpH
			local spriteRight = cc.Sprite:createWithSpriteFrameName("icon_yes.png")
			spriteRight:setAnchorPoint(cc.p(0.5, 0.5))
			spriteRight:setPosition(cc.p(posX, posY))
			spriteRight:addTo(self.scroll)
			spriteRight:setVisible(value.status)
			if value.set then
				_ENV = value.status
				value.status.rect = cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH)
				value.status.single = spriteRight
				_ENV, value.status.bgSingle = cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH), nil
				cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH).permission = v.key
				cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH).rank = k
				value.status.data, cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH).status = cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH), value.status
				table.insert(self.tabelSetRect, value.status)
				tableYesSprite[k] = true
			else
				tableStaticYesSprite[k] = spriteRight
			end
		end
		for i, v in ipairs(self.tableImgRank) do
			if not tableYesSprite[i] then
				local posX = v:getPositionX()
				local posY = scrollH - 4 - 0.5 * tmpH
				_ENV = self.tabelSetRect
				self.tabelSetRect.rect = cc.rect(posX - 36.25, posY - 0.5 * maxH, 72.5, maxH)
				self.tabelSetRect.bgSingle = nil
				self.tabelSetRect.single = tableStaticYesSprite[i]
				table.insert(self.tabelBlackRect, self.tabelSetRect)
			end
		end
	end
	self.imgBg1:setPositionY(scrollH + 58.75)
	self.imgBg2:setPositionY(scrollH + 54.75)
	self.imgBg1:setContentSize(cc.size(640, scrollH + 15 - desH - btnH))
	self.imgBg2:setContentSize(cc.size(640, scrollH + 12 - desH - btnH))
	self.imgBg1:setLocalZOrder(1)
	for i, v in ipairs(self.tableImgRank) do
		v:setPositionY(scrollH + 25)
	end
	for i, v in ipairs(self.tableImgLine) do
		v:setPositionY(scrollH + 54.75)
		v:setContentSize(cc.size(4, scrollH + 8 - desH - btnH))
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollH + 80))
end
function AllianceMemberRankInfoView:changeDateInsert(data)
	if not self.tableChangeData[data.permission] then
		local _UPVALUE0_, singleData = self.tableChangeData[data.permission], self.tableChangeData[data.permission]
	end
	if singleData[data.rank] == nil then
		singleData[data.rank] = not data.status
	else
		singleData[data.rank] = not singleData[data.rank]
	end
	self.tableChangeData[data.permission] = singleData
end
function AllianceMemberRankInfoView:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended and self.btnChange:getTag() == 1 then
		local nodePoint = target:getTouchEndPosition()
		nodePoint = self.scroll:getInnerContainer():convertToNodeSpace(nodePoint)
		for i, v in ipairs(self.tabelSetRect) do
			if cc.rectContainsPoint(v.rect, nodePoint) then
				v.single:setVisible(not v.single:isVisible())
				self:changeDateInsert(v.data)
				break
			end
		end
	end
end
function AllianceMemberRankInfoView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		local closeFun = function(...)
			SoraCollectgarbage(self.__cname)
			self:removeFromParent()
		end
		if self.btnChange:getTag() == 1 then
			SoraDShowMsgBox(i18n("common_text_2472"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if MSGBOX_CALLBACK_YES == type then
					closeFun()
				end
			end)
		else
			closeFun()
		end
	end
end
function AllianceMemberRankInfoView:showBlack(isShow)
	for i, v in ipairs(self.tabelBlackRect) do
		local single = v.bgSingle
		if single == nil then
			single = self.imgBg2:clone()
			if single.setFill then
				single:setFill(fgui.LoaderFillType.SCALE_FREE)
			end
			single:setContentSize(cc.size(v.rect.width, v.rect.height))
			single:setAnchorPoint(cc.p(0, 0))
			single:setPosition(cc.p(v.rect.x, v.rect.y))
			single:addTo(self.scroll)
			v.bgSingle = single
		end
		if v.single then
			v.single:setColor(isShow and cc.c3b(75, 75, 75) or display.COLOR_WHITE)
		end
		v.bgSingle:setSwallowTouches(false)
		v.bgSingle:setVisible(isShow)
	end
	for i, v in ipairs(self.tabelSetRect) do
		local single = v.bgSingle
		if single == nil then
			single = self.imgBg2:clone()
			if single.setFill then
				single:setFill(fgui.LoaderFillType.SCALE_FREE)
			end
			single:setContentSize(cc.size(v.rect.width, v.rect.height))
			single:setAnchorPoint(cc.p(0, 0))
			single:setPosition(cc.p(v.rect.x, v.rect.y))
			single:addTo(self.scroll, -1)
			single:loadTexture("frame_mail_sheer_01.png", ccui.TextureResType.plistType)
			single:setColor(cc.c3b(0, 80, 0))
			single:setOpacity(178.5)
			v.bgSingle = single
		end
		v.bgSingle:setSwallowTouches(false)
		v.bgSingle:setVisible(isShow)
	end
end
function AllianceMemberRankInfoView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		end
		local tag = self.btnChange:getTag()
		if tag == 0 then
			self:showBlack(true)
			self.btnChange:setTitleText(i18n("common_text_195"))
			tag = 1
		else
			self:showBlack(false)
			self.btnChange:setTitleText(i18n("common_text_244"))
			tag = 0
			dump(self.tableChangeData, "self.tableChangeData======")
			permissionCtrl:reqModifyPermission(self.tableChangeData)
			SoraDShowMsgTip(i18n("common_text_2370"), nil, button)
		end
		self.btnChange:setTag(tag)
	end
end
return AllianceMemberRankInfoView

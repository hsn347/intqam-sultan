local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local AllianceGroupMemberSingle = class("allianceGroupMemberSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupMemberSingle")
	end
	return target
end)
function AllianceGroupMemberSingle:ctor()
	self.singleIsMoved = false
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.nodePbl = SoraDGetChildByName(self, "Node_pbl")
	self.labelPBL = SoraDGetChildByName(self, "Text_PBL")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.imgPower = SoraDGetChildByName(self, "Image_6")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.spriteCap = SoraDGetChildByName(self, "Sprite_cap")
	self.nodeHead = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.nodeHead:setTouchEnabled(false)
	self.imgBlack = SoraDGetChildByName(self, "Image_black")
	self.btnSelect = SoraDGetChildByName(self, "Button_select")
	self:initCastleLvStarLvNode()
	if self.btnSelect then
		self.btnSelect:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.layerTouch:addTouchEventListener(handler(self, self.btnBgClickCallBack))
	end
end
function AllianceGroupMemberSingle:initCastleLvStarLvNode(...)
	local node = SoraDCreatePanel("commonCastleLvStarLv")
	node:addTo(self.labelPower:getParent())
	node:setPosition(SoraDFSign(140), self.labelPower:getPositionY())
	self.node_lv = node
	self.imgPower:setPositionX(SoraDFSign(25))
	self.labelPower:setPositionX(SoraDFSign(-15))
end
function AllianceGroupMemberSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceGroupMemberSingle:setHandle(handle)
	self.handle = handle
end
function AllianceGroupMemberSingle:initData(rank, singleData, groupIndex)
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	self.tableSingleData = singleData
	self.rank = rank
	self.groupIndex = groupIndex
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self.curLegionInfo = self.legionInfoList[self.groupIndex]
	self.isFight = false
	local cur_s_uid = tostring(self.tableSingleData.minfo.uid)
	self.authority = 0
	if pyramidWarCtrl:isGroupCaptain(self.groupIndex) then
		self.authority = 1
	end
	if ownRank >= gAllianceRank.R5 then
		self.authority = 2
	end
	self.btnSelect:setVisible(false)
	self.labelState:setVisible(false)
	self.imgBlack:setVisible(false)
	self.nodePbl:setVisible(false)
	self.spriteCap:setVisible(self.tableSingleData.minfo.uid == self.curLegionInfo.captainID)
	self.labelName:setString(self.tableSingleData.uinfo.nickName)
	if self.curLegionInfo.memberList[cur_s_uid] then
		if self.authority > 0 then
			self.btnSelect:setVisible(true)
			self.btnSelect:setTitleText(i18n("common_text_184"))
			self.btnSelect:loadTextures("btn_alliance_red.png", "", "", ccui.TextureResType.plistType)
		else
			self.labelState:setVisible(true)
			self.labelState:setString(i18n("common_text_3333"))
			self.labelState:setColor(display.COLOR_GREEN)
		end
		if not self.curLegionInfo.lastRoundMember or not self.curLegionInfo.lastRoundMember[cur_s_uid] then
			self.labelName:setString(self.tableSingleData.uinfo.nickName .. [[

(]] .. i18n("common_text_665") .. ")")
		end
		self.isFight = true
	else
		local isFree = true
		for i, v in ipairs(self.legionInfoList) do
			if i ~= self.groupIndex and v.memberList[cur_s_uid] then
				if not v.lastRoundMember or not v.lastRoundMember[cur_s_uid] then
					self.labelName:setString(self.tableSingleData.uinfo.nickName .. [[

(]] .. i18n("common_text_665") .. ")")
				end
				self.imgBlack:setVisible(true)
				self.labelState:setVisible(true)
				self.labelState:setString(i18n("common_text_3333") .. [[

(]] .. v.legionName .. ")")
				self.labelState:setColor(display.COLOR_WHITE)
				self.isFight = true
				isFree = false
				break
			end
		end
		if isFree then
			if self.authority > 0 then
				self.btnSelect:setVisible(true)
				self.btnSelect:setTitleText(i18n("common_text_3333"))
				self.btnSelect:loadTextures("btn_alliance_green.png", "", "", ccui.TextureResType.plistType)
			else
				self.imgBlack:setVisible(true)
				self.labelState:setVisible(true)
				self.labelState:setString(i18n("pyramid_btn_16"))
				self.labelState:setColor(display.COLOR_RED)
			end
		end
	end
	local uinfo = self.tableSingleData.uinfo
	self.node_lv:initData(uinfo.cityLevel, uinfo.starLv)
	self.labelPower:setString(string.formatnumberthousands(uinfo.totalFc))
	self.nodeHead:setHeadSprite(uinfo.iconID, uinfo.avatar)
	self.isHiddle = false
end
function AllianceGroupMemberSingle:btnBgClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		pyramidWarCtrl = SoraDPlaySound
		local SoraDPlaySound[1], menuData = chatConst.OpId.OpViewInfo, SoraDPlaySound
		if pyramidWarCtrl:getGroupManagerRank() == 2 then
			if self.tableSingleData.minfo.uid == self.curLegionInfo.captainID then
				menuData[2] = chatConst.OpId.OpCancleCaptain
			elseif self.curLegionInfo.memberList[tostring(self.tableSingleData.minfo.uid)] then
				menuData[2] = chatConst.OpId.OpSetCaptain
			end
		end
		_ENV = nil
		;(nil).playerId = self.tableSingleData.minfo.uid
		;(nil).nickName = self.tableSingleData.uinfo.nickName
		SoraDShowPlayerOperatePanel(self.tableSingleData.uinfo.nickName, menuData, nil, function(tag)
			if tag == chatConst.OpId.OpSetCaptain then
				pyramidWarCtrl:newSetLegionCaptainReq(self.curLegionInfo.legionId, self.tableSingleData.minfo.uid)
			elseif tag == chatConst.OpId.OpCancleCaptain then
				pyramidWarCtrl:newCancleLegionCaptainReq(self.curLegionInfo.legionId)
			end
		end)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceGroupMemberSingle:setHiddle()
	self.isHiddle = true
end
function AllianceGroupMemberSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.isHiddle then
			return
		end
		SoraDPlaySound()
		if self.isFight then
			pyramidWarCtrl:newCancelAppointReq(self.curLegionInfo.legionId, self.tableSingleData.minfo.uid)
		else
			pyramidWarCtrl:newAppointReq(self.curLegionInfo.legionId, self.tableSingleData.minfo.uid)
		end
		SoraDShowLoading()
	end
end
return AllianceGroupMemberSingle

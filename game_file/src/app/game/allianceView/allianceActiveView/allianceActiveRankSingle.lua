local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceActiveRankSingle = class("allianceActiveRankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveRankSingle")
	end
	return target
end)
function allianceActiveRankSingle:ctor()
	self.Image_barBg = SoraDGetChildByName(self, "Image_curBg")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.onPanelTouchClick))
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_alliance = SoraDGetChildByName(self, "Text_alliance")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.imageHead = SoraDGetChildByName(self, "Image_Head")
end
function allianceActiveRankSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceActiveRankSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	if self.data.flag then
		self.imageHead:setVisible(false)
		self.Node_flag:setVisible(true)
		self.Node_flag:removeAllChildren()
		local flag = SoraDGetAllianceFlagByFid(self.data.flag or 1)
		flag:addTo(self.Node_flag)
		_ENV = nil
		;(nil).abbr = self.data.allianceAbbr
		;(nil).name = self.data.allianceName
		_ENV = nil
		;(nil).name = self.data.leaderName
		self.Text_name:setString(i18n("common_text_186", nil) .. "\n" .. i18n("common_text_926", nil))
	else
		self.Text_name:setString(self.data.nickName)
		self.imageHead:setVisible(true)
		self.Node_flag:setVisible(false)
		SoraDGetHeadFromManager(self.imageHead, self.data.iconID, self.data.avatar or "")
	end
	self.Text_num:setString(string.formatnumberthousands(self.data.point))
	local isTop3 = self.data.rank <= RANK_TOP_SPECIAL
	if isTop3 then
		self.Image_barBg:loadTexture(string.format("frame_alliance_pank_%.2d.png", self.data.rank), ccui.TextureResType.plistType)
		self.Sprite_index:setVisible(true)
		self.Sprite_index:setSpriteFrame(string.format("icon_ranking_%d.png", self.data.rank))
		self.Text_index:setVisible(false)
	else
		self.Sprite_index:setVisible(false)
		self.Text_index:setVisible(true)
		self.Text_index:setString(self.data.rank)
		if self.data.aid == allianceMgr:getOwnAid() or self.data.uid == gametop.playertop_:getPlayerID() then
			self.Image_barBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		else
			self.Image_barBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
	end
end
function allianceActiveRankSingle:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceActiveRankSingle" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceActiveRankSingle:onPanelTouchClick(target, event)
	if event == ccui.TouchEventType.ended then
		if self.ownScroll and not SoraDIsNodeVisibleOnScroll(target, self.ownScroll, event) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.data.aid then
			SoraDPlaySound()
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = event
			_ENV, event.aid = self.data.aid, self.data.aid
			self.data.aid.from = "allianceActiveRankSingle"
			allianceQuery:reqAllianceByID(event, self.data.aid)
			SoraDShowLoading(self)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
return allianceActiveRankSingle

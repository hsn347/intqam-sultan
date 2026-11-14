_ENV = nil
;(nil).player = 1
;(nil).alliance = 2
local _ENV, (nil).kingdom, singleType = nil, 3, nil
;(nil).one = 1
;(nil).two = 2
local _ENV, (nil).three, nameShowDef = nil, 3, nil
;(nil).one = 1
;(nil).two = 2
local _ENV, (nil).three, iconShowDef = nil, 3, nil
;(nil).panel_Click = 1
;(nil).head_Click = 2
local (nil).panel_Click_Lord, buttonClickType = 3, nil
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local commonRankingSingle = class("commonRankingSingle", function(luaFileName)
	if "userdata" == type(luaFileName) then
		return luaFileName
	elseif "string" == type(luaFileName) then
		return SoraDCreateBasePanel(luaFileName)
	else
		return SoraDCreateBasePanel("commonRankingSingle")
	end
end)
function commonRankingSingle:ctor()
	self.scroll = nil
	self.handle = nil
	self.viewType = nil
	self.singleData, buttonClickType, self.btnClickType = buttonClickType.panel_Click, buttonClickType.panel_Click, buttonClickType.panel_Click
	self.singleIsMoved = false
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	if self.Panel_touch then
		self.Panel_touch:setSwallowTouches(false)
		self.Panel_touch:addTouchEventListener(handler(self, self.onPanelClickCallBack))
	end
	self.Image_curBg = SoraDGetChildByName(self, "Image_curBg")
	if self.Image_curBg then
	end
	self.Image_frm = SoraDGetChildByName(self, "Image_frm")
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	if self.Node_flag then
		self.Node_flag:setVisible(false)
	end
	self.Sprite_head = SoraDGetChildByName(self, "Sprite_head")
	self.Button_head = SoraDGetChildByName(self, "Button_Head")
	if self.Button_head then
		self.Button_head:setSwallowTouches(false)
		self.Button_head:addTouchEventListener(handler(self, self.onPanelClickCallBack))
	end
	self.Sprite_fram = SoraDGetChildByName(self, "Sprite_fram")
	self.Sprite_rank = SoraDGetChildByName(self, "Sprite_rank")
	if self.Sprite_rank then
		self.Sprite_rank:setVisible(false)
	end
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	if self.Text_name then
		self.textNameOriPos = self.Text_name:getPositionX()
	end
	self.Text_alliance = SoraDGetChildByName(self, "Text_alliance")
	if self.Text_alliance then
		self.Text_alliance:setVisible(false)
	end
	self.Text_kingdom = SoraDGetChildByName(self, "Text_kingdom")
	if self.Text_kingdom then
		self.Text_kingdom:setVisible(false)
	end
	self.Node_donate = SoraDGetChildByName(self, "Node_donate")
	if self.Node_donate then
		self.Node_donate:setVisible(false)
	end
	self.Node_num = SoraDGetChildByName(self, "Node_num")
	if self.Node_num then
		self.Text_num = SoraDGetChildByName(self.Node_num, "Text_num")
		self.Text_honor = SoraDGetChildByName(self.Node_num, "Text_honor")
		if self.Text_honor then
			self.Text_honor:setVisible(false)
		end
		self.Sprite_war = SoraDGetChildByName(self.Node_num, "Sprite_war")
		if self.Sprite_war then
			self.Sprite_war:setVisible(false)
		end
	end
	self.Image_city = SoraDGetChildByName(self, "Image_city")
	if self.Image_city then
		self.Image_city:setVisible(false)
	end
end
function commonRankingSingle:initView(viewType)
	if self.viewType == singleType.kingdom and self.Text_name then
		self.Text_name:setPositionX(self.textNameOriPos + (SoraDFIsRA() and -20 or 20))
	end
	if self.Button_head then
		self.Button_head:setTouchEnabled(self.btnClickType == buttonClickType.head_Click)
		self.Button_head:setSwallowTouches(false)
	end
	if self.Panel_touch then
		self.Panel_touch:setTouchEnabled(self.btnClickType ~= buttonClickType.head_Click)
		self.Panel_touch:setSwallowTouches(false)
	end
end
function commonRankingSingle:setHeadFlagVisible(style)
	if self.Node_flag then
		self.Node_flag:setVisible(style == iconShowDef.two)
	end
	if self.Sprite_head then
		self.Sprite_head:setVisible(style == iconShowDef.one)
	end
	if self.Sprite_fram then
		self.Sprite_fram:setVisible(style == iconShowDef.one)
	end
	if self.Image_city then
		self.Image_city:setVisible(style == iconShowDef.three)
	end
end
function commonRankingSingle:setNameShowStyle(style)
	if style == nameShowDef.one then
		if self.Text_name then
			local posY = 56
			if self.Panel_touch then
				posY = self.Panel_touch:getContentSize().height / 2
			end
			self.Text_name:setPositionY(posY)
		end
		if self.Text_alliance then
			self.Text_alliance:setVisible(false)
		end
	elseif style == nameShowDef.two then
		if self.Text_alliance then
			self.Text_alliance:setVisible(true)
		end
		if self.Text_name then
			self.Text_name:setPositionY(75)
		end
		if self.Text_alliance then
			self.Text_alliance:setPositionY(37)
		end
	elseif style == nameShowDef.three then
		if self.Text_alliance then
			self.Text_alliance:setVisible(true)
		end
		if self.Text_kingdom then
			self.Text_kingdom:setVisible(true)
		end
		if self.Text_name then
			self.Text_name:setPositionY(82)
		end
		if self.Text_alliance then
			self.Text_alliance:setPositionY(56)
		end
		if self.Text_kingdom then
			self.Text_kingdom:setPositionY(30)
		end
	end
end
function commonRankingSingle:initData(data, otherData)
	self.singleData = data
	self.parentView = otherData.view
	if otherData and otherData.scroll then
		self:setScroll(otherData.scroll)
	end
	self:setNameShowStyle(self.singleData.nameShowType or 1)
	self.btnClickType = self.singleData.btnClickType or 1
	self.viewType = self.singleData.model or 1
	self:initView()
	if self.singleData.player then
		if self.singleData.player.iconID and self.Sprite_head then
			self:setHeadFlagVisible(iconShowDef.one)
			SoraDGetHeadFromManager(self.Sprite_head, self.singleData.player.iconID, self.singleData.player.avatar or "")
		end
		if self.singleData.player.flag and self.Node_flag then
			self:setHeadFlagVisible(iconShowDef.two)
			self.Node_flag:removeAllChildren()
			allianceDesRead.getFlagWithParticle(self.singleData.player.flag, self.Node_flag)
		end
		if self.singleData.player.palaceIcon and self.Image_city then
			self:setHeadFlagVisible(iconShowDef.three)
			self.Image_city:loadTexture(self.singleData.player.palaceIcon, ccui.TextureResType.plistType)
		end
		if self.Text_name and self.singleData.lineOneName then
			self.Text_name:setString(self.singleData.lineOneName)
		end
		if self.singleData.lineTwoName and self.Text_alliance then
			self.Text_alliance:setString(self.singleData.lineTwoName)
		end
		if self.singleData.lineThreeName and self.Text_kingdom then
			self.Text_kingdom:setString(self.singleData.lineThreeName)
		end
	end
	if self.singleData.rank then
		if type(self.singleData.rank) == "string" then
			if self.Text_index then
				self.Text_index:setVisible(true)
			end
			if self.Sprite_index then
				self.Sprite_index:setVisible(false)
			end
			if self.Text_index then
				self.Text_index:setString(self.singleData.rank)
			end
			if self.singleData.isCur then
				if self.Image_curBg then
					self.Image_curBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
				end
			elseif self.Image_curBg then
				self.Image_curBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
			end
		elseif type(self.singleData.rank) == "number" then
			if self.Text_index then
				self.Text_index:setVisible(self.singleData.rank > RANK_TOP_SPECIAL)
			end
			if self.Sprite_index then
				self.Sprite_index:setVisible(self.singleData.rank <= RANK_TOP_SPECIAL)
			end
			if self.singleData.rank <= RANK_TOP_SPECIAL then
				if self.Image_curBg then
					self.Image_curBg:loadTexture("frame_alliance_pank_0" .. self.singleData.rank .. ".png", ccui.TextureResType.plistType)
				end
				if self.Sprite_index then
					self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.singleData.rank .. ".png")
				end
			else
				if self.Text_index then
					self.Text_index:setString(self.singleData.rank)
				end
				if self.singleData.player.uid == lordInfoCtrl:getLordInfo().base.uid then
					if self.Image_curBg then
						self.Image_curBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
					end
				elseif self.Image_curBg then
					self.Image_curBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
				end
			end
		end
	end
	if self.singleData.score and self.Text_num then
		if type(self.singleData.score) == "string" then
			self.Text_num:setString(self.singleData.score)
		elseif type(self.singleData.score) == "number" then
			self.Text_num:setString(string.formatnumberthousands(self.singleData.score))
		end
	end
	if self.singleData.icon and self.Sprite_war then
		self.Sprite_war:setVisible(true)
		self.Sprite_war:setSpriteFrame(self.singleData.icon)
		self.Sprite_war:setScale(self.singleData.iconScale or 1)
	end
	if self.singleData.honor and self.Text_honor then
		self.Text_honor:setVisible(true)
		self.Text_honor:setString(string.formatnumberthousands(self.singleData.honor))
	end
	if self.Node_num and not self.singleData.notToCenter then
		SoraDToCenter(self.Node_num)
	end
	if self.singleData.donate then
		if self.Node_donate then
			self.Node_donate:setVisible(true)
			SoraDGetChildByName(self.Node_donate, "Text_honor"):setString(string.formatnumberthousands(self.singleData.donate.honor))
			SoraDGetChildByName(self.Node_donate, "Text_donate"):setString(string.formatnumberthousands(self.singleData.donate.score))
		end
		if self.Sprite_rank then
			self.Sprite_rank:setSpriteFrame(allianceDesRead.getIcon(self.singleData.donate.rank))
		end
	end
end
function commonRankingSingle:setHandle(handle)
	self.handle = handle
end
function commonRankingSingle:setScroll(scroll)
	self.scroll = scroll
end
function commonRankingSingle:getContentSize()
	return self.Panel_touch:getContentSize()
end
function commonRankingSingle:hideBgAndBorder()
	if self.Image_curBg then
		self.Image_curBg:setVisible(false)
	end
	if self.Image_frm then
		self.Image_frm:setVisible(false)
	end
end
function commonRankingSingle:onPanelClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.handle then
			SoraDPlaySound()
			self.handle(self.singleData)
		else
			print("............--------------.............", button:getName())
			if self.viewType == singleType.player then
				if self.singleData.selfRank == self.singleData.rank then
					self:showSelfInfoView()
				elseif self.btnClickType == buttonClickType.panel_Click then
					self:showOtherInfoView()
				else
					local kid = gametop.playertop_:getKingdomID()
					_ENV = button:getName()
					button:getName().targetName = self.parentView.__cname
					lordInfoCtrl:getLordInfoByUid(self.singleData.player.uid, self.singleData.player.kid or kid, button:getName())
					SoraDShowLoading(self.parentView)
				end
			end
			if self.viewType == singleType.alliance then
				print("............--------------.............")
				local allianceQuery = gametop.playertop_:getModule("allianceQuery")
				_ENV = self.singleData.player.uid
				self.singleData.player.uid.aid = self.singleData.player.aid
				_ENV, self.singleData.player.uid.kid = self.singleData.player.kid, self.singleData.player.kid
				self.singleData.player.kid.from = "commonRankingSingle"
				allianceQuery:reqAllianceByID(self.singleData.player.uid, self.singleData.player.kid)
				SoraDShowLoading(self.parentView)
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function commonRankingSingle:showOtherInfoView(data)
	local chatConst = include("chatConst")
	_UPVALUE3_ = "chatConst"
	;("chatConst")[1] = chatConst.OpId.OpSendEmail
	;("chatConst")[2] = chatConst.OpId.OpViewInfo
	local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel >= CASTLE_LV10_LIMITED then
		table.insert(menuData, chatConst.OpId.OpSendFlower)
	end
	_ENV = nil
	;(nil).playerId = tonumber(self.singleData.player.uid)
	;(nil).nickName = self.singleData.player.name
	;(nil).allianceAbbr = self.singleData.player.allianceAbbr
	SoraDShowPlayerOperatePanel(self.singleData.player.name, menuData, nil)
end
function commonRankingSingle:showSelfInfoView(...)
	SoraDOpenLordView(lordInfoCtrl:getLordInfo())
end
return commonRankingSingle

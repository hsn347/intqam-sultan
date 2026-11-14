local AllianceDonateRankingsSingle = class("allianceDonateRankingsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceDonateRankingsSingle")
	end
	return target
end)
function AllianceDonateRankingsSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.curMember = nil
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.spriteIndex = SoraDGetChildByName(self, "Sprite_index")
	self.spriteFram = SoraDGetChildByName(self, "Sprite_fram")
	self.spriteHead = SoraDGetChildByName(self, "Sprite_head")
	self.spriteRank = SoraDGetChildByName(self, "Sprite_rank")
	self.labelIndex = SoraDGetChildByName(self, "Text_index")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDonate = SoraDGetChildByName(self, "Text_donate")
	self.labelHonor = SoraDGetChildByName(self, "Text_honor")
	self.imgCurBg = SoraDGetChildByName(self, "Image_curBg")
	if self.layerTouch then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceDonateRankingsSingle:initData(data, index, type)
	local lordLocalData = include("lordLocalData")
	local allianceDesRead = include("allianceDesRead")
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.curMember = data
	self.labelIndex:setVisible(index > RANK_TOP_SPECIAL)
	self.spriteIndex:setVisible(index <= RANK_TOP_SPECIAL)
	self.labelIndex:setString(tostring(index))
	self.imgCurBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
	if index <= RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
		self.spriteIndex:setSpriteFrame("icon_ranking_" .. index .. ".png")
	end
	if self.curMember:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid and index > RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
	end
	SoraDGetHeadFromManager(self.spriteHead, self.curMember:getProperty("iconID"), self.curMember:getProperty("avatar"))
	self.spriteRank:setSpriteFrame(allianceDesRead.getIcon(self.curMember:getProperty("rank")))
	self.labelName:setString(self.curMember:getProperty("nickName"))
	local donateKey = "sciPointDay"
	local honorKey = "honorDay"
	if type == gARankType.WEEK then
		donateKey = "sciPointWeek"
		honorKey = "honorWeek"
	elseif type == gARankType.HISTORY then
		donateKey = "sciPointTotal"
		honorKey = "honorTotal"
	end
	self.labelDonate:setString(string.formatnumberthousands(self.curMember:getProperty(donateKey)))
	self.labelHonor:setString(string.formatnumberthousands(self.curMember:getProperty(honorKey)))
end
function AllianceDonateRankingsSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceDonateRankingsSingle:btnClickCallBack(button, type)
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
		local gametop = gModuleMgr.getObject("gametop")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		if self.curMember:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid then
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		else
			local chatConst = include("chatConst")
			local chatFunctions = include("chatFunctions")
			_UPVALUE2_ = "chatFunctions"
			;("chatFunctions")[1] = chatConst.OpId.OpSendEmail
			local ("chatFunctions")[2], menuData = chatConst.OpId.OpViewInfo, "chatFunctions"
			local bIsShield = chatFunctions.getIsShield(self.curMember:getProperty("uid"))
			if bIsShield == true then
				table.insert(menuData, chatConst.OpId.OpUnShield)
			elseif bIsShield == false then
				table.insert(menuData, chatConst.OpId.OpShield)
			end
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			local member = memberMgr:getOwnMember()
			local ownRank = member:getProperty("rank")
			local otherRank = self.curMember:getProperty("rank")
			if ownRank >= gAllianceRank.R4 and ownRank > otherRank then
				table.insert(menuData, chatConst.OpId.OnKickOutAlliance)
			end
			_ENV = "nickName"
			;("nickName").playerId = self.curMember:getProperty("uid")
			;("nickName").nickName = self.curMember:getProperty("nickName")
			;("nickName").allianceAbbr = lordInfoCtrl:getLordInfo().abbr
			SoraDShowPlayerOperatePanel(self.curMember:getProperty("nickName"), menuData, "nickName")
		end
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
return AllianceDonateRankingsSingle

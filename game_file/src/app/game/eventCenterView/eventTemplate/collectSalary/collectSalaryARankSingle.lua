local collectSalaryARankSingle = class("collectSalaryARankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("collectSalaryARankSingle")
	end
	return target
end)
function collectSalaryARankSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.curMember = nil
	self.spriteHead = SoraDGetChildByName(self, "Image_Head")
	self.labelName = SoraDGetChildByName(self, "Text_Name")
	self.textNum = SoraDGetChildByName(self, "Text_Num")
	SoraDSetTextWidthHeight(self.textNum, cc.size(self.textNum:getContentSize().width, 23))
	self.spriteIndex = SoraDGetChildByName(self, "icon_ranking_1_1")
	self.labelIndex = SoraDGetChildByName(self, "Text_Rank")
	self.imageBg = SoraDGetChildByName(self, "Image_1")
	self.imgCurBg = SoraDGetChildByName(self, "Image_1")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setTouchEnabled(true)
	self.layerTouch:setSwallowTouches(false)
	self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.spriteRank = SoraDGetChildByName(self, "Sprite_rank")
end
function collectSalaryARankSingle:initData(data, otherData)
	local lordLocalData = include("lordLocalData")
	local allianceDesRead = include("allianceDesRead")
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.curMember = data
	self.scroll = otherData.scroll
	local index = data.rank or 0
	self.labelIndex:setVisible(index > RANK_TOP_SPECIAL)
	self.spriteIndex:setVisible(index <= RANK_TOP_SPECIAL)
	self.labelIndex:setString(tostring(index))
	self.imgCurBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
	if index <= RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
		self.spriteIndex:setSpriteFrame("icon_ranking_" .. index .. ".png")
	end
	if data.uid == lordInfoCtrl:getLordInfo().base.uid and index > RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
	end
	SoraDGetHeadFromManager(self.spriteHead, data.uInfo.iconID, data.uInfo.avatar)
	self.spriteRank:setSpriteFrame(allianceDesRead.getIcon(data.uInfo.rank))
	self.labelName:setString(data.uInfo.nickName)
	self.textNum:setString(data.score)
	if 0 >= data.score then
		self.spriteIndex:setVisible(false)
		self.labelIndex:setVisible(true)
		self.labelIndex:setString(i18n("common_text_480"))
	end
end
function collectSalaryARankSingle:btnClickCallBack(button, type)
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
		if self.curMember.uid == lordInfoCtrl:getLordInfo().base.uid then
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		else
			local chatConst = include("chatConst")
			local chatFunctions = include("chatFunctions")
			_UPVALUE2_ = "chatFunctions"
			;("chatFunctions")[1] = chatConst.OpId.OpSendEmail
			local ("chatFunctions")[2], menuData = chatConst.OpId.OpViewInfo, "chatFunctions"
			local bIsShield = chatFunctions.getIsShield(self.curMember.uid)
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
			local otherRank = self.curMember.uInfo.rank
			if ownRank >= gAllianceRank.R4 and ownRank > otherRank then
				table.insert(menuData, chatConst.OpId.OnKickOutAlliance)
			end
			_ENV = lordInfoCtrl:getLordInfo()
			lordInfoCtrl:getLordInfo().playerId = self.curMember.uid
			lordInfoCtrl:getLordInfo().nickName = self.curMember.uInfo.nickName
			lordInfoCtrl:getLordInfo().allianceAbbr = lordInfoCtrl:getLordInfo().abbr
			SoraDShowPlayerOperatePanel(self.curMember.uInfo.nickName, menuData, lordInfoCtrl:getLordInfo())
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
return collectSalaryARankSingle

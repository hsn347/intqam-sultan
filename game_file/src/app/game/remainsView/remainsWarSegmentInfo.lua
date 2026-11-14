local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local remainsWarSegmentInfo = class("remainsWarSegmentInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarSegmentInfo")
	end
	return target
end)
function remainsWarSegmentInfo:ctor()
	self.Center_Button_left = SoraDGetChildByName(self, "Center_Button_left")
	self.Center_Button_right = SoraDGetChildByName(self, "Center_Button_right")
	self.Top_Size_Panel_touchPad = SoraDGetChildByName(self, "Top_Size_Panel_touchPad")
	self.Top_Size_Panel_touchPad:addTouchEventListener(handler(self, self.panelTouchPadClick))
	self.Center_Button_left:addTouchEventListener(handler(self, self.onClick_Center_Button_left))
	self.Center_Button_right:addTouchEventListener(handler(self, self.onClick_Center_Button_right))
	self.Top_Size_Panel_container = SoraDGetChildByName(self, "Top_Size_Panel_container")
	self.nodeInSide = SoraDGetChildByName(self, "Node_inSide")
	self.nodeOutSide = SoraDGetChildByName(self, "Node_outSide")
	self.scrollOutSide = self.nodeOutSide
	self.scrollInSide = self.nodeInSide
	self.panelContainer = self.Top_Size_Panel_container
	self.containerSize = self.panelContainer:getContentSize()
	self.scrollOutSide:setPositionX(-self.containerSize.width / 2)
	self.scrollInSide:setPositionX(self.containerSize.width / 2)
	self.curSegmentLv = remainsTeamCtrl:getPlayerSegment() or 1
	self.curStarLv = remainsTeamCtrl:getPlayerStar() or 0
	self.canClick = true
	self:updateScoreStatus(self.scrollInSide)
	self:setBuffLv()
	local _ENV, imgArray = self.setBuffLv, self.setBuffLv
	local ret = _G.SoraDIsFileExistByKey("xunzhang")
	if ret then
		_ENV = handler(self, self.onClick_Center_Button_right)
		handler(self, self.onClick_Center_Button_right).name = "worldMap/xunzhang"
		table.insert(imgArray, handler(self, self.onClick_Center_Button_right))
	end
	self:loadImages(imgArray, function()
		self.hasHDRes = true
	end)
end
function remainsWarSegmentInfo:onClick_Center_Button_left(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(false, SoraDFIsRA())
	end
end
function remainsWarSegmentInfo:onClick_Center_Button_right(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(true, not SoraDFIsRA())
	end
end
function remainsWarSegmentInfo:panelTouchPadClick(panel, eventType)
	if (eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled) and not self.isTurnning then
		local touchBeganPoint = panel:getTouchBeganPosition()
		local touchmovePoint = panel:getTouchEndPosition()
		if touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("右移")
			self:turnPage(false, SoraDFIsRA())
		elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("左移")
			self:turnPage(true, not SoraDFIsRA())
		end
	end
end
function remainsWarSegmentInfo:turnPage(actionFoward, small2big)
	if self.canClick then
		print("small2big", small2big)
		local curSegmentLv = self:returnLookLv(small2big)
		print("curSegmentLv = ", curSegmentLv)
		if curSegmentLv then
			local posY = self.scrollOutSide:getPositionY()
			local actionPage = function(bool)
				if bool then
					self.scrollOutSide:setPositionX(self.containerSize.width / 2 * 3)
					transition.execute(self.scrollOutSide, cca.moveTo(0.2, self.containerSize.width / 2, posY))
					transition.execute(self.scrollInSide, cca.moveTo(0.2, -self.containerSize.width / 2, posY))
				else
					self.scrollOutSide:setPositionX(-self.containerSize.width / 2)
					transition.execute(self.scrollOutSide, cca.moveTo(0.2, self.containerSize.width / 2, posY))
					transition.execute(self.scrollInSide, cca.moveTo(0.2, self.containerSize.width / 2 * 3, posY))
				end
			end
			self:updateScoreStatus()
			self.canClick = false
			actionPage(actionFoward)
			_ENV = nil
			;(nil).delay = 0.3
			;(nil).onComplete = function()
				self.scrollOutSide, self.scrollInSide = self.scrollInSide, self.scrollOutSide
				self:setBuffLv()
				self.canClick = true
			end
			transition.execute(self, nil, nil)
		end
	end
end
function remainsWarSegmentInfo:returnLookLv(small2big)
	local showSmall, showBig = self:getLookCurLv()
	_UPVALUE8_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	;(nil)[4] = 4
	;(nil)[5] = 5
	;(nil)[6] = 6
	;(nil)[7] = 8
	local (nil)[8], segmentList = 7, nil
	if small2big then
		if not showBig then
			return false
		end
		self.curStarLv = self.curStarLv + 1
		if 3 < self.curStarLv then
			self.curSegmentLv = segmentList[segmentList[self.curSegmentLv] + 1]
			if self.curSegmentLv == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_7 then
				self.curStarLv = 0
			else
				self.curStarLv = 1
			end
		end
		return self.curSegmentLv
	else
		if not showSmall then
			return false
		end
		self.curStarLv = self.curStarLv - 1
		if self.curStarLv <= 0 then
			self.curStarLv = 3
			self.curSegmentLv = segmentList[segmentList[self.curSegmentLv] - 1]
		end
		return self.curSegmentLv
	end
end
function remainsWarSegmentInfo:getLookCurLv()
	local showSmall, showBig = true, true
	if self.curSegmentLv == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_1 and self.curStarLv == 1 then
		showSmall = false
	end
	if self.curSegmentLv == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_7 then
		showBig = false
	end
	return showSmall, showBig
end
function remainsWarSegmentInfo:setBuffLv()
	local showSmall, showBig = self:getLookCurLv()
	local btn_smallLv = SoraDFIsRA() and self.Center_Button_right or self.Center_Button_left
	local btn_bigLv = SoraDFIsRA() and self.Center_Button_left or self.Center_Button_right
	btn_smallLv:setVisible(showSmall)
	btn_bigLv:setVisible(showBig)
end
function remainsWarSegmentInfo:updateDanImg(nodeDanBg, danID)
	if danID then
		nodeDanBg:removeChildByName("Node_dan", true)
		local resPath = "remainsWarxunzhang" .. danID
		local danNode
		if self.hasHDRes then
			danNode = SoraDCreatAnimation(resPath, nil, true)
		else
			danNode = SoraDCreateCSBNode(resPath)
		end
		if danNode then
			local node_content = SoraDGetChildByName(danNode, "Node_content")
			if node_content then
				local array = SoraDGetChildsArrayByName(node_content, "Sprite_additive_", 4, 1)
				_G.SoraDSetNodeArrayAdditive(array)
			end
			danNode:setName("Node_dan")
			danNode:addTo(nodeDanBg)
		end
	end
end
function remainsWarSegmentInfo:updateStarImg(nodeDanBg)
	if not self.startNode then
		local startNode = SoraDGetRemainsWarStartNodeEx(self.curStarLv)
		startNode:addTo(nodeDanBg, 1)
		startNode:setPosition(-15, 200)
		startNode:setName("Node_star")
		self.startNode = startNode
	else
		self.startNode.updateStar(self.curStarLv)
	end
end
function remainsWarSegmentInfo:updateScoreStatus(node)
	local nodeSide = node or self.scrollOutSide
	local spScoreTitle = SoraDGetChildByName(nodeSide, "Sprite_score_title")
	local nodeDanBg = SoraDGetChildByName(nodeSide, "Node_dan_bg")
	local txtTitleInfo = SoraDGetChildByName(nodeSide, "Text_title_info")
	local txtTitleTips = SoraDGetChildByName(nodeSide, "Text_title_tips")
	local danID = self.curSegmentLv or 1
	local danPoint = remainsWarltCtrl.getDanPoint(danID, self.curStarLv)
	local beginScore = danPoint and danPoint.min
	local endScore = danPoint and danPoint.max
	_ENV = nil
	;(nil).min = string.formatnumberthousands(beginScore)
	;(nil).max = string.formatnumberthousands(endScore)
	txtTitleInfo:setString(i18n("remains_text_320", nil))
	txtTitleTips:setVisible(false)
	if _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_6 == self.curSegmentLv or _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8 == self.curSegmentLv then
		_ENV = _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8
		_ENV = false
		_G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8[_G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_6], (false)[3] = false, "remains_text_340"
		_ENV = false
		;(false)[1] = "remains_text_341"
		;(false)[2] = "remains_text_342"
		_G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8[_G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8], (false)[3] = false, "remains_text_343"
		local rankDes = _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8
		local des = rankDes[self.curSegmentLv] and rankDes[self.curSegmentLv][self.curStarLv]
		if des then
			local score = endScore
			if self.curSegmentLv == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8 then
				score = beginScore
			end
			_ENV = i18n("remains_text_320", nil)
			i18n("remains_text_320", nil).point = string.formatnumberthousands(score)
			i18n("remains_text_320", nil).rank = rank
			txtTitleTips:setString(i18n(des, i18n("remains_text_320", nil)))
			txtTitleTips:setVisible(true)
		end
	elseif _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_7 == self.curSegmentLv then
		txtTitleTips:setString(i18n("remains_text_322"))
		txtTitleTips:setVisible(true)
	end
	if _G.IsArClient then
		local strTitleName = remainsWarRead.getDanNameIcon(danID)
		spScoreTitle:setSpriteFrame(strTitleName)
	else
		local txtScoreTitle = nodeSide.txtScoreTitle
		if not txtScoreTitle then
			txtScoreTitle = _G.SoraDChangeDanToText(spScoreTitle)
			nodeSide.txtScoreTitle = txtScoreTitle
		end
		local strTitle = remainsWarRead.getDanName(danID)
		txtScoreTitle:setString(strTitle)
		local color = remainsWarRead.getDanColor(danID)
		txtScoreTitle:setColor(color)
	end
	if nodeSide.danID ~= danID then
		nodeSide.danID = danID
		self:updateDanImg(nodeDanBg, danID)
	end
	self:updateStarImg(nodeDanBg)
end
return remainsWarSegmentInfo

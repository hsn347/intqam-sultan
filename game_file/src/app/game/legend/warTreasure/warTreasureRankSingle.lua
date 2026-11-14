local warTreasureRankSingle = class("warTreasureRankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("warTreasureRankSingle")
	end
	return target
end)
function warTreasureRankSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.curMember = nil
	self.itemIcon = SoraDGetChildByName(self, "item_Icon")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.textNum = SoraDGetChildByName(self, "Text_num")
	self.spriteIndex = SoraDGetChildByName(self, "Sprite_index")
	self.labelIndex = SoraDGetChildByName(self, "Text_index")
	self.imgCurBg = SoraDGetChildByName(self, "Image_curBg")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setTouchEnabled(true)
	self.layerTouch:setSwallowTouches(false)
	self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function warTreasureRankSingle:initData(data, otherData)
	local lordLocalData = include("lordLocalData")
	local allianceDesRead = include("allianceDesRead")
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.viewType = otherData.viewType
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
	self.labelName:setString(data.uInfo.nickName)
	self.textNum:setString(data.score)
	self.spriteIndex:setVisible(true)
	if 0 >= data.score then
		self.spriteIndex:setVisible(false)
		self.labelIndex:setVisible(true)
		self.labelIndex:setString(i18n("common_text_480"))
	end
	self.itemIcon:loadTexture(self.viewType == 1 and "8271.png" or "8272.png", ccui.TextureResType.plistType)
end
function warTreasureRankSingle:btnClickCallBack(button, type)
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
return warTreasureRankSingle

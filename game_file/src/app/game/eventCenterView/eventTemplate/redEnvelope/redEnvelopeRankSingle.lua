local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local redEnvelopeRankSingle = class("redEnvelopeRankSingle", function(target)
	if type(target) == "userData" then
		return target
	end
	return SoraDCreateBasePanel("redEnvelopeRankSingle")
end)
function redEnvelopeRankSingle:ctor()
	self.imageHead = SoraDGetChildByName(self, "Image_Head")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textNum = SoraDGetChildByName(self, "Text_Num")
	self.imageRank = SoraDGetChildByName(self, "icon_ranking_1_1")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.imageBg = SoraDGetChildByName(self, "Image_1")
	self.scroll = nil
	self.singleIsMoved = false
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:addTouchEventListener(handler(self, self.btnHeadClickCallBack))
	self.layerTouch:setTouchEnabled(true)
	self.layerTouch:setSwallowTouches(false)
end
function redEnvelopeRankSingle:initData(data, index, parent)
	self.scroll = parent
	self:setHeadSprite(data.iconID, data.avatar)
	self.nickName = data.nickName
	self.uid = data.uid
	self.allianceName = data.allianceName
	if 1 <= index and index <= RANK_TOP_SPECIAL then
		self.imageBg:loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
	else
		self.imageBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
	end
	if data.rank then
		local isTopThree = 1 <= data.rank and data.rank <= RANK_TOP_SPECIAL
		if isTopThree then
			self.imageRank:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		end
		self.imageRank:setVisible(isTopThree)
		self.textRank:setVisible(not isTopThree)
		self.textRank:setString(data.rank)
		self.textTime:setVisible(false)
		if SoraDFIsRA() then
			self.imageHead:setPositionX(385)
			self.textName:setPositionX(330)
		else
			self.imageHead:setPositionX(145)
			self.textName:setPositionX(200)
		end
	else
		self.imageRank:setVisible(false)
		self.textRank:setVisible(false)
		if SoraDFIsRA() then
			self.imageHead:setPositionX(470)
			self.textName:setPositionX(415)
		else
			self.imageHead:setPositionX(60)
			self.textName:setPositionX(115)
		end
		self.textTime:setVisible(true)
		self.textTime:setString(os.date("%m/%d %H:%M:%S", data.time))
	end
	if data.allianceAbbr and data.allianceAbbr ~= "" then
		_ENV = os.date("%m/%d %H:%M:%S", data.time)
		os.date("%m/%d %H:%M:%S", data.time).abbr = data.allianceAbbr
		os.date("%m/%d %H:%M:%S", data.time).name = data.nickName
		self.textName:setString(i18n("common_text_186", os.date("%m/%d %H:%M:%S", data.time)))
	else
		self.textName:setString(data.nickName)
	end
	self.textNum:setString(string.formatnumberthousands(data.gold))
end
function redEnvelopeRankSingle:btnHeadClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.uid == lordInfoCtrl:getLordInfo().base.uid then
			return
		end
		SoraDPlaySound()
		_UPVALUE3_ = SoraDPlaySound
		SoraDPlaySound[1] = chatConst.OpId.OpSendEmail
		SoraDPlaySound[2] = chatConst.OpId.OpViewInfo
		local SoraDPlaySound[3], menuData = chatConst.OpId.OpShield, SoraDPlaySound
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel >= CASTLE_LV10_LIMITED then
			table.insert(menuData, chatConst.OpId.OpSendFlower)
		end
		_ENV = nil
		;(nil).playerId = self.uid
		;(nil).nickName = self.nickName
		;(nil).allianceAbbr = self.allianceName
		SoraDShowPlayerOperatePanel(self.nickName, menuData, nil)
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
function redEnvelopeRankSingle:setHeadSprite(imageId, avatar)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local info = lordInfoCtrl:getBaseInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	SoraDGetHeadFromManager(self.imageHead, imageId, avatar)
end
return redEnvelopeRankSingle

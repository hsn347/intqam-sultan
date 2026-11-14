local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceMobASingle = class("allianceMobASingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobASingle")
	end
	return target
end)
function allianceMobASingle:ctor()
	self.Image_curBg = SoraDGetChildByName(self, "Image_curBg")
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_lord = SoraDGetChildByName(self, "Text_lord")
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function allianceMobASingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	if data.rank <= RANK_TOP_SPECIAL then
		self.Image_curBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
		self.Sprite_index:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		self.Sprite_index:setVisible(true)
		self.Text_index:setVisible(false)
	else
		local isMe = data.aid == allianceMgr:getOwnAid()
		self.Image_curBg:loadTexture(isMe and "frame_alliance_pank_05.png" or "frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		self.Sprite_index:setVisible(false)
		self.Text_index:setVisible(true)
		self.Text_index:setString(data.rank)
	end
	_ENV = ccui.TextureResType.plistType
	ccui.TextureResType.plistType.abbr = data.aInfo.allianceAbbr
	ccui.TextureResType.plistType.name = data.aInfo.allianceName
	local nameStr = string.format("%s#%d", i18n("common_text_186", ccui.TextureResType.plistType), data.aInfo.kid)
	self.Text_name:setString(nameStr)
	_ENV = data.aInfo.allianceName
	data.aInfo.allianceName.name = data.leadername or i18n("common_text_480")
	self.Text_lord:setString(i18n("common_text_926", data.aInfo.allianceName))
	self.Text_point:setString(string.formatnumberthousands(data.score))
	self.Node_flag:removeAllChildren()
	local flag = SoraDGetAllianceFlagByFid(data.aInfo.allianceFlag)
	flag:addTo(self.Node_flag)
end
function allianceMobASingle:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.data.aid and self.data.leadername then
			SoraDShowLoading(self.view)
			_ENV = self.scroll
			self.scroll.aid = self.data.aid
			_ENV, self.scroll.kid = self.data.aInfo.kid, self.data.aInfo.kid
			self.data.aInfo.kid.from = "mobilization"
			allianceQuery:reqAllianceByID(self.scroll, self.data.aInfo.kid)
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
return allianceMobASingle

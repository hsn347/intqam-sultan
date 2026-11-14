local achiDesRead = include("achiDesRead")
local medalSingle = class("medalSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("medalSingle")
	end
	return target
end)
function medalSingle:ctor()
	self.bindMedalClick = false
	self.scale = 1.0
	self.effectPos = cc.p(100, 100)
	self.starArray, _ENV, self.isShowModel = cc.p(100, 100), cc.p(100, 100), false
	self.Image_medal = SoraDGetChildByName(self, "Image_medal")
	self.Image_medal:setTouchEnabled(true)
	self.Image_medal:setSwallowTouches(false)
	self.Image_medal:addTouchEventListener(handler(self, self.medalClick))
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Image_sheer = SoraDGetChildByName(self, "Image_sheer")
	self.Node_star = SoraDGetChildByName(self, "Node_star")
	self.Button_star = SoraDGetChildByName(self, "Button_star")
	self.Button_star:setSwallowTouches(false)
	self.starArray[1] = self.Button_star
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Node_name = SoraDGetChildByName(self, "Node_name")
	self.Text_medalName = SoraDGetChildByName(self, "Text_medalName")
end
function medalSingle:getContentSize()
	return cc.size(200, 200)
end
function medalSingle:setAchiListModel()
	self.scale = 0.8
	self.effectPos = cc.p(100, 115)
	self.isShowModel = true
	self.Image_sheer:setVisible(false)
	self.Node_name:setVisible(false)
	self.Node_star:setPositionY(30)
	self.Image_medal:setTouchEnabled(false)
end
function medalSingle:setAchiListModelPosY()
	self.Image_sheer:setPositionY(20)
	self.Node_star:setPositionY(20)
	self.Node_name:setVisible(false)
end
function medalSingle:initData(data, scroll, isShowEffect, isOther)
	self.myIconData = data
	self.scroll = scroll
	self.isOther = isOther
	local medalInfo = achiDesRead.getMedalById(self.myIconData.medalID)
	local isGray = self.myIconData.star < MEDAL_MIN_STAR_SHOW
	if self.isShowModel then
		isGray = false
	end
	self:addMedal(self.myIconData.medalID, isGray)
	if isGray then
		self.Text_medalName:setString("???")
		self.Text_medalName:setColor(cc.c3b(120, 120, 120))
		self:setGray()
	else
		self.Text_medalName:setString(i18n(medalInfo.medalName))
		self.Text_medalName:setColor(cc.c3b(255, 255, 255))
	end
	for k, v in ipairs(self.starArray) do
		v:setVisible(false)
	end
	if self.myIconData.star <= MEDAL_MAX_STAR_SHOW then
		self.Text_num:setVisible(false)
		for i = 1, MEDAL_MAX_STAR_SHOW do
			if not self.starArray[i] then
				self.starArray[i] = self.Button_star:clone()
				self.starArray[i]:setPositionY(0)
				self.starArray[i]:addTo(self.Node_star)
			end
			self.starArray[i]:setVisible(true)
			self.starArray[i]:setBright(i > self.myIconData.star)
		end
		SoraDToCenter(self.Node_star, 0, SoraDFIsRA())
	else
		self.Text_num:setVisible(true)
		self.Text_num:setString("X" .. self.myIconData.star)
		self.starArray[1]:setVisible(true)
		self.starArray[1]:setBright(false)
		SoraDToCenter(self.Node_star, 5)
	end
	if self.myIconData.onWork and isShowEffect then
		if not self:getChildByName("open_node") then
			local et_node = SoraDCreatAnimation("Node_medal_open")
			et_node:setName("open_node")
			et_node:setPosition(cc.p(0, 11))
			et_node:addTo(self, -1)
		end
		if not self.Node_name:getChildByName("Node_medal_show") then
			local et_nodeShow = SoraDCreatAnimation("Node_medal_show")
			et_nodeShow:setName("Node_medal_show")
			et_nodeShow:setPosition(cc.p(0, 0))
			et_nodeShow:addTo(self.Node_name, 3)
		end
		self.Text_medalName:setColor(cc.c3b(255, 232, 38))
	else
		self.Text_medalName:setColor(cc.c3b(255, 255, 255))
		if self:getChildByName("open_node") then
			self:getChildByName("open_node"):removeFromParent()
		end
		if self.Node_name:getChildByName("Node_medal_show") then
			self.Node_name:getChildByName("Node_medal_show"):removeFromParent()
		end
	end
end
function medalSingle:setGray()
	local medalImg = SoraDGetChildByName(self.Node_effect, "Node_medal")
	if medalImg then
		SoraDCreateGraySprite(medalImg)
	end
end
function medalSingle:hideName()
	self.Text_medalName:setVisible(false)
end
function medalSingle:bindClick()
	self.bindMedalClick = true
end
function medalSingle:addMedal(_id, isGray)
	self.Node_effect:removeAllChildren()
	self.Node_effect:setPosition(self.effectPos)
	local node = achiDesRead.getShowMedalEffectNode(_id, isGray)
	node:setScale(self.scale)
	node:addTo(self.Node_effect)
end
function medalSingle:medalClick(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		if not self.isIgnoreMove and self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		self:realClick()
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
function medalSingle:realClick()
	if self.bindMedalClick then
		return
	end
	SoraDPlaySound("uicontrol", 31)
	if self.isOther then
		if self.myIconData.star >= MEDAL_MIN_STAR_SHOW then
			SoraDShowMsgTip(achiDesRead.getBuffStrByID(self.myIconData.id, self.myIconData.star))
		end
		return
	end
	if self.myIconData.star < MEDAL_MIN_STAR_SHOW then
		_ENV = achiDesRead.getBuffStrByID(self.myIconData.id, self.myIconData.star)
		achiDesRead.getBuffStrByID(self.myIconData.id, self.myIconData.star).myIconData = self.myIconData
		uiManager:show("achiToMedalPopView", achiDesRead.getBuffStrByID(self.myIconData.id, self.myIconData.star))
		return
	end
	if self.myIconData.isActive then
		if self.myIconData.onWork then
			self:popActive(false)
		else
			self:popActive(true)
		end
	else
		self:popPassive()
	end
end
function medalSingle:popActive(bool)
	_ENV = nil
	;(nil).myIconData = self.myIconData
	;(nil).isWork = bool
	uiManager:show("medalPopView", nil)
end
function medalSingle:popPassive()
	_ENV = nil
	;(nil).myIconData = self.myIconData
	;(nil).isWork = false
	uiManager:show("medalPopView", nil)
end
return medalSingle

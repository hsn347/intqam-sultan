local mailFunctions = include("mailFunctions")
local mailItemPyramidBattle = class("mailItemPyramidBattle", function(target)
	return include("ccsView").new(getCCSPath("mailItemPyramidBattle"))
end)
function mailItemPyramidBattle:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_content:setSwallowTouches(false)
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_soldier = SoraDGetChildByName(self, "text_soldier")
	self.text_killed = SoraDGetChildByName(self, "text_killed")
	self.text_killed_percent = SoraDGetChildByName(self, "text_killed_percent")
	self.text_soldier_value = SoraDGetChildByName(self, "text_soldier_value")
	self.text_killed_value = SoraDGetChildByName(self, "text_killed_value")
	self.text_killed_percent_value = SoraDGetChildByName(self, "text_killed_percent_value")
	self.img_bg = SoraDGetChildByName(self, "img_bg")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.text_lost_power = SoraDGetChildByName(self, "text_lost_power")
	self.text_wounded = SoraDGetChildByName(self, "text_wounded")
	self.text_wounded_value = SoraDGetChildByName(self, "text_wounded_value")
	self.text_lost_power_value = SoraDGetChildByName(self, "text_lost_power_value")
	self.text_soldier:setString(i18n("common_text_474"))
	self.text_killed:setString(i18n("common_text_1474"))
	self.text_killed_percent:setString(i18n("common_text_1475"))
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	self.text_lost_power:setString(i18n("common_text_1477"))
	self.text_wounded:setString(i18n("common_text_132"))
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.coordinate, _ENV = self.setContentSize, self.setContentSize
end
function mailItemPyramidBattle:initWithData(data, mailType)
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local ancientSoulInfo = data.ancientSoulInfo
	local scoreInfo = data.scoreInfo
	if scoreInfo then
		self.text_score_value:setString(scoreInfo.score or 0)
	end
	if self.img_icon then
		if mailType == gMailType.RUINS_BATTLE_REPORT then
			self.img_icon:loadTexture("myzh_full.png", ccui.TextureResType.plistType)
		elseif mailType == gMailType.DEVILVALLEY_BATTLE_REPORT then
			self.img_icon:loadTexture("qlzjt_full.png", ccui.TextureResType.plistType)
		else
			self.img_icon:loadTexture("ygzh_full.png", ccui.TextureResType.plistType)
		end
	end
	local ancientSoulInfo = data.ancientSoulInfo
	self.text_lost_power_value:setString(ancientSoulInfo.lostPower or 0)
	self.text_wounded_value:setString(ancientSoulInfo.wounded or 0)
	local coordinate = ancientSoulInfo.coordinate
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	self.text_soldier_value:setString(ancientSoulInfo.num)
	self.text_killed_value:setString(ancientSoulInfo.killed)
	local percent = string.format("%.1f%%", ancientSoulInfo.killed * 100 / ancientSoulInfo.num)
	self.text_killed_percent_value:setString(percent)
	local widthLayout = gMailDetaiViewWidth
	local heightLayout = 177
	heightLayout = heightLayout + 20
	self.layout_content:setContentSize(cc.size(widthLayout, heightLayout))
	self:setContentSize(cc.size(widthLayout, heightLayout))
	self.itemWidth = widthLayout
	self.itemHeight = heightLayout
	ccui.Helper:doLayout(self.layout_content)
end
function mailItemPyramidBattle:getItemWidth()
	return self.itemWidth
end
function mailItemPyramidBattle:getItemHeight()
	return self.itemHeight
end
function mailItemPyramidBattle:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local targetPoint = cc.p(self.coordinate.x, self.coordinate.y)
		targetPoint.kid = self.coordinate.kid
		_ENV = self.coordinate.y
		self.coordinate.y.msg = "MESSAGE_MAIL_CLOSE_VIEW"
		SoraDSendMessage(self.coordinate.y)
		SoraDGotoWorldMapPoint(targetPoint, true, targetPoint.kid)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return mailItemPyramidBattle

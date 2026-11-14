local mailFunctions = include("mailFunctions")
local worldMapDefine = include("worldMapDefine")
local mailWorldBossSummary = class("mailWorldBossSummary", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailWorldBossSummary")
	end
	return target
end)
function mailWorldBossSummary:ctor()
	self:setAnchorPoint(cc.p(0.5, 0))
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	if self.img_icon then
		self.img_icon:loadTexture("bhmt_full.png", ccui.TextureResType.plistType)
	end
	self.text_world_boss = SoraDGetChildByName(self, "text_world_boss")
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_kill_percent = SoraDGetChildByName(self, "text_kill_percent")
	self.text_kill_percent_value = SoraDGetChildByName(self, "text_kill_percent_value")
	self.text_remain_percent = SoraDGetChildByName(self, "text_remain_percent")
	self.text_remain_percent_value = SoraDGetChildByName(self, "text_remain_percent_value")
	self.text_coordinate = SoraDChangeTextToHtmlFgui(self.text_coordinate)
	self.text_world_boss:setString(i18n("common_text_474"))
	self.text_kill_percent:setString(i18n("common_text_1474"))
	self.text_remain_percent:setString(i18n("common_text_1475"))
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.coordinate, _ENV = self.setContentSize, self.setContentSize
end
function mailWorldBossSummary:initWithData(data)
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	local widthLayout = 500
	local heightLayout = 130
	local content = data.content
	if not content.coordinate then
		_ENV = content.coordinate
		content.coordinate.x = 0
		local content.coordinate.y, coordinate = 0, content.coordinate
	end
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	if content.killHP then
		local killPercent = string.format("%.2f%%", content.killHP)
		self.text_kill_percent_value:setString(killPercent)
		self.text_kill_percent_value:setVisible(true)
		self.text_kill_percent:setVisible(true)
	else
		self.text_kill_percent_value:setVisible(false)
		self.text_kill_percent:setVisible(false)
	end
	if content.remainHP then
		local remainPercent = string.format("%.2f%%", content.remainHP)
		self.text_remain_percent_value:setString(remainPercent)
		self.text_remain_percent_value:setVisible(true)
		self.text_remain_percent:setVisible(true)
	else
		self.text_remain_percent_value:setVisible(false)
		self.text_remain_percent:setVisible(false)
	end
	local lv = content.lv
	local bossType = content.bossType
	local bossName = worldMapDefine.getWorldBossName(bossType, lv)
	bossName = bossName and i18n(bossName)
	_ENV = i18n_html("common_text_034", nil, nil)
	i18n_html("common_text_034", nil, nil).lv = lv
	i18n_html("common_text_034", nil, nil).name = bossName
	local strBoss = i18n("common_text_134", i18n_html("common_text_034", nil, nil))
	self.text_world_boss:setString(strBoss)
	if bossType == gBossType.heroBattleBoss1 or bossType == gBossType.heroBattleBoss2 then
		self.text_world_boss:setString(bossName)
	elseif bossType == gBossType.monkeyBoss then
		self.text_world_boss:setString(i18n("worldboss_monkey_08"))
	end
	if self.text_world_boss:getContentSize().width > 345 - self.text_coordinate:getContentSize().width - 10 then
		SoraDSetTextWidthHeight(self.text_world_boss, cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30))
	end
	local bossData = worldMapDefine.getWorldBossShow(bossType, lv)
	if self.img_icon and bossData and bossData.icon then
		self.img_icon:loadTexture(bossData.icon, ccui.TextureResType.plistType)
	end
	if bossType == gBossType.monkeyBoss then
		self.img_icon:loadTexture("monkey_full.png", ccui.TextureResType.plistType)
	end
	_ENV = cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30)
	cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30).name = bossName
	self.text_kill_percent:setString(i18n("common_text_2118", cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30)))
	_ENV = i18n("common_text_2118", cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30))
	i18n("common_text_2118", cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30)).name = bossName
	self.text_remain_percent:setString(i18n("common_text_2119", i18n("common_text_2118", cc.size(345 - self.text_coordinate:getContentSize().width - 10, 30))))
	worldMapDefine = self.text_remain_percent
	self.text_remain_percent[1] = self.text_kill_percent
	self.text_remain_percent[2] = self.text_remain_percent
	for i, v in ipairs(self.text_remain_percent) do
		if v:getContentSize().width > 250 then
			SoraDSetTextWidthHeight(v, cc.size(250, 25))
		end
	end
end
function mailWorldBossSummary:getItemWidth()
	return self.itemWidth
end
function mailWorldBossSummary:getItemHeight()
	return self.itemHeight
end
function mailWorldBossSummary:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
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
return mailWorldBossSummary

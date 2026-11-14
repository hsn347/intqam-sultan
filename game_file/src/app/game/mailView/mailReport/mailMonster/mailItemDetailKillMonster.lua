local itemDesRead = include("itemDesRead")
local worldMapDefine = include("worldMapDefine")
local mailFunctions = include("mailFunctions")
local mailItemDetailKillMonster = class("mailItemDetailKillMonster", function(target)
	return include("ccsView").new(getCCSPath("mailItemDetailKillMonster"))
end)
function mailItemDetailKillMonster:ctor()
	self:setCascadeOpacityEnabled(true)
	self.contentPanel = SoraDGetChildByName(self, "layout_content")
	self.contentPanel:setCascadeOpacityEnabled(true)
	self.contentPanel:setSwallowTouches(false)
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.text_line = SoraDGetChildByName(self, "text_line")
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_monster = SoraDGetChildByName(self, "text_monster")
	self.text_fightNum = SoraDGetChildByName(self, "text_fightNum")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.text_coordinate = SoraDChangeTextToHtmlFgui(self.text_coordinate)
	self.text_coordinate:setSwallowTouches(false)
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	local itemSize = self.contentPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	_ENV = self.setContentSize
	self.setContentSize.x = 0
	self.coordinate, self.setContentSize.y = self.setContentSize, 0
	self.singleIsMoved = false
end
function mailItemDetailKillMonster:initWithData(data)
	local monsterInfo = data.monsterInfo
	if nil == monsterInfo then
		return
	end
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local npcImg = worldMapDefine.getMonsterImageName(monsterInfo.id)
	npcImg = npcImg .. "_full" .. ".png"
	if 3127 == monsterInfo.id then
		npcImg = "xueguai_dj_ws_full.png"
	end
	self.img_icon:loadTexture(npcImg, ccui.TextureResType.plistType)
	local strCoordinate = mailFunctions:getStrCoordinate(monsterInfo.coordinate.x, monsterInfo.coordinate.y)
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	self.coordinate.x = monsterInfo.coordinate.x
	self.coordinate.y = monsterInfo.coordinate.y
	self.coordinate.kid = monsterInfo.coordinate.kid
	if data.attackTimes ~= nil then
		_ENV = i18n_html("common_text_034", nil, nil)
		i18n_html("common_text_034", nil, nil).num = data.attackTimes
		self.text_fightNum:setString(i18n("CounterSystem_text_22", i18n_html("common_text_034", nil, nil)))
	else
		self.text_fightNum:setString("")
	end
	local lv
	if monsterInfo.armyGroupID then
		local commandHallUtil = include("commandHallUtil")
		lv = commandHallUtil.getMonsterLevel(monsterInfo.armyGroupID)
	else
		lv = worldMapDefine.getMonsterLevel(monsterInfo.id)
	end
	_ENV = monsterInfo.armyGroupID
	monsterInfo.armyGroupID.lv = lv
	monsterInfo.armyGroupID.name = worldMapDefine.getMonsterName(monsterInfo.id)
	local strMonsterName = i18n("common_text_134", monsterInfo.armyGroupID)
	self.text_monster:setString(strMonsterName)
	if data.fightResult ~= 0 then
	end
end
function mailItemDetailKillMonster:onCoordinate(target, event)
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
function mailItemDetailKillMonster:getItemWidth()
	return self.itemWidth
end
function mailItemDetailKillMonster:getItemHeight()
	return self.itemHeight
end
return mailItemDetailKillMonster

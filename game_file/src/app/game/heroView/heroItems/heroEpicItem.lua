local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local scrollNode = include("scrollNode")
local HeroEpicItem = class("heroEpicItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroEpicItem")
	end
	return target
end)
function HeroEpicItem:ctor()
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHead = SoraDGetChildByName(self, "Sprite_head")
	self.spState = SoraDGetChildByName(self, "Sprite_state")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.btnHead = SoraDGetChildByName(self, "Button_click")
	self.btnHead = scrollNode.new(self.btnHead)
	self.btnHead:addTouchEventListener(handler(self, self.btnHeadClick))
	self.btnHead:setSwallowTouches(false)
end
function HeroEpicItem:initData(info, scroll)
	self.heroID = tonumber(info.heroID)
	self.heroLevel = info.level
	self.heroQuality = info.quality
	self.dressID = info.dressID
	if scroll then
		self.btnHead:setScroll(scroll)
	end
	self:initView()
end
function HeroEpicItem:initView(...)
	local heroClassInfo = heroltCtrl.getHeroInfo(self.heroID)
	if self.heroID then
		if self.dressID and not heroltCtrl:isDefaultDress(self.dressID) then
			local herIcon = heroltCtrl.heroDressCfg[self.dressID].herIcon
			if herIcon == "" then
				herIcon = "Avatar_hero_1700.png"
			end
			self.spHead:setSpriteFrame(herIcon)
		else
			self.spHead:setSpriteFrame(heroltCtrl.getHeroInfoHerIcon(self.heroID) or "icon_LegendaryKing_question.png")
		end
		self.spClass:setSpriteFrame(heroClassInfo and heroClassInfo.icon or "bg_transparent.png")
	else
		self.spHead:setSpriteFrame("icon_LegendaryKing_question.png")
		self.spClass:setSpriteFrame("bg_transparent.png")
	end
	if self.heroLevel then
		self.spState:setVisible(true)
		self.txtLv:setString(self.heroLevel)
	else
		self.spState:setVisible(false)
	end
	if self.heroQuality then
		self.spHeadBg:setColor(cc.c3b(255, 255, 255))
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(self.heroQuality))
	else
		self.spHeadBg:setColor(cc.c3b(100, 100, 100))
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(gHeroQuality.WHITE))
	end
end
function HeroEpicItem:btnHeadClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.heroID and self.heroLevel and self.heroQuality then
			_ENV = nil
			;(nil).heroID = self.heroID
			;(nil).quality = self.heroQuality
			;(nil).level = self.heroLevel
			;(nil).dressID = self.dressID
			uiManager:show("HeroIntroduction", nil)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return HeroEpicItem

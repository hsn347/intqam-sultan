local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroHuntingItem = class("heroHuntingItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroHuntingItem")
	end
	return target
end)
function heroHuntingItem:ctor()
	self.stateList, _ENV = nil, nil
	self.spHeroBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHeroHead = SoraDGetChildByName(self, "Sprite_head")
	self.nodeLoadBar = SoraDGetChildByName(self, "Node_loadBar")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_loadBar")
	self.txtLoadBar = SoraDGetChildByName(self, "Text_loadBar")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.txtTip = SoraDGetChildByName(self, "Text_arg")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.btnItem:setSwallowTouches(false)
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function heroHuntingItem:initData(heroID)
	self.heroID = heroID
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function heroHuntingItem:initView(...)
	self.spHeroHead:setSpriteFrame(self.heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.spHeroBg:setSpriteFrame(heroltCtrl.getCubeBg(self.heroInfo.quality))
	self.txtLv:setString(self.heroInfo.level)
	heroltCtrl = self.heroInfo.level
	self.heroInfo.level.num = heroCtrl:getHeroHuntingRate(self.heroID)
	local strTip = i18n("common_text_4418", self.heroInfo.level)
	self.txtTip:setString(strTip)
end
function heroHuntingItem:judgeCanBeSelected(...)
	if not heroCtrl:judgeHeroInStates(self.heroID, self.stateList) then
		return self.heroInfo.state
	end
end
function heroHuntingItem:initState(...)
	if self:judgeCanBeSelected() then
		SoraDGetCSBFather(self):setColor(colorGray)
	else
		SoraDGetCSBFather(self):setColor(colorNormal)
	end
end
function heroHuntingItem:setClickCallBack(handle)
	self.clickHandler = handle
end
function heroHuntingItem:setCancelLightBack(handle)
	self.cancelLightHandler = handle
end
function heroHuntingItem:setMeCheck(bool)
	self.spLight:setVisible(bool)
end
function heroHuntingItem:setFilteHeroState(states)
	self.stateList = states
end
function heroHuntingItem:btnItemClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		return
	end
end
function heroHuntingItem:setScroll(scroll)
	self.scroll = scroll
end
return heroHuntingItem

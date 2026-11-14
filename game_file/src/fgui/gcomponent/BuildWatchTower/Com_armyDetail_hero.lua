local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_hero = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_hero", Com_armyDetail_hero)
function Com_armyDetail_hero:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.fields.spHeadBg:addEventListener(fgui.UIEventType.Click, handler(self, self.btnHeadClick))
end
function Com_armyDetail_hero:onShow()
end
function Com_armyDetail_hero:initData(info)
	self.heroID = tonumber(info.heroID)
	self.heroLevel = info.level
	self.heroQuality = info.quality
	self.dressID = info.dressID
	self:initView()
end
function Com_armyDetail_hero:initView(...)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroClassInfo = heroltCtrl.getHeroInfo(self.heroID)
	if self.heroID then
		if self.dressID and not heroltCtrl:isDefaultDress(self.dressID) then
			self.fields.spHead:setSpriteFrame(heroltCtrl.heroDressCfg[self.dressID].herIcon)
		else
			self.fields.spHead:setSpriteFrame(heroltCtrl.getHeroInfoHerIcon(self.heroID) or "icon_LegendaryKing_question.png")
		end
	else
		self.fields.spHead:setSpriteFrame("icon_LegendaryKing_question.png")
	end
	if self.heroLevel then
		self.fields.spState:setVisible(true)
		self.fields.txtLv:setString(self.heroLevel)
	else
		self.fields.spState:setVisible(false)
	end
	if self.heroQuality then
		self.fields.spHeadBg:setColor(cc.c3b(255, 255, 255))
		self.fields.spHeadBg:setSpriteFrame(heroltCtrl.getBg(self.heroQuality))
	else
		self.fields.spHeadBg:setColor(cc.c3b(100, 100, 100))
		self.fields.spHeadBg:setSpriteFrame(heroltCtrl.getBg(gHeroQuality.WHITE))
	end
end
function Com_armyDetail_hero:btnHeadClick(button, event)
	if self.heroID and self.heroLevel and self.heroQuality then
		SoraDPlaySound()
		_ENV = nil
		;(nil).heroID = self.heroID
		;(nil).quality = self.heroQuality
		;(nil).level = self.heroLevel
		;(nil).dressID = self.dressID
		uiManager:show("HeroIntroduction", nil)
	end
end
return Com_armyDetail_hero

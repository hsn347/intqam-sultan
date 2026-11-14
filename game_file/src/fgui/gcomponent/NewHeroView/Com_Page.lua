local heroBiographyRead = include("heroBiographyRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local publicRead = include("publicRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Page = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_Page", Com_Page)
function Com_Page:onInit()
	self.fields.Button_Right:setString(i18n("hero_text_120"))
	self.fields.Button_Left:setString(i18n("hero_text_119"))
	self.fields.Button_Right:addClickListener(handler(self, self.btnRightClick))
	self.fields.Button_Left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Text_GetAward:setString(i18n("common_text_1261"))
	self.fields.Com_Item:addClickListener(handler(self, self.btnGetAwardClick))
end
function Com_Page:onShow()
end
function Com_Page:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORYTASK_UPDATE", handler(self, self.msgCallBack))
end
function Com_Page:msgCallBack(target, data)
	if data.subMsg == "getReward" and self.heroID then
		self.fields.nodeAward:setVisible(not heroBiographyCtrl:isStoryAwardGot(self.heroID))
	end
end
function Com_Page:initData(info)
	self.heroID = info.heroID
	self.heroInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.fields.Text_TitleName:setString(i18n(self.heroInfo.herName))
	self.controllers.c1:setSelectedIndex(info.showImage and 0 or 1)
	self.fields.Text_Describe:setString(info.str)
	self.fields.nodeAward:setVisible(false)
	if not heroBiographyCtrl:isStoryAwardGot(self.heroID) then
		self.fields.nodeAward:setVisible(true)
		local reward = heroBiographyRead.getHeroUnlockTaskAward(self.heroID)
		self.fields.Com_Item:initData(reward[1].id, reward[1].count)
		self.fields.Label_reddot:setVisible(heroCtrl:getHeroInfoByID(self.heroID) and true or false)
	end
	self.fields.Button_Right:setVisible(info.showNextButton)
	self.fields.Button_Left:setVisible(info.showPrevButton)
	self.fields.Spine:initData(self.heroID, true, true)
	self.fields.Node_HeroInfo:initData(self.heroID)
	self.fields.Sprite_heroClass:setURL(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
end
function Com_Page:btnRightClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_HERO_STORYTASK_UPDATE"
	;(nil).subMsg = "turnNextPage"
	SoraDSendMessage(nil)
end
function Com_Page:btnLeftClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_HERO_STORYTASK_UPDATE"
	;(nil).subMsg = "turnPrevPage"
	SoraDSendMessage(nil)
end
function Com_Page:btnGetAwardClick()
	SoraDPlaySound()
	heroBiographyCtrl:reqInitData(heroBiographyRead.getHeroUnlockTaskID(self.heroID))
end
return Com_Page

local buildLogic = include("buildLogic")
local wiseTutorRead = include("wiseTutorRead")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local wiseTutorBlessLightSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/wiseTutorBlessLightSub", wiseTutorBlessLightSub)
function wiseTutorBlessLightSub:onInit()
	self:fixChildrenPos()
	self.fields.Text_Tips:setString(i18n("Battle_Towers_06"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Title3:setString(i18n("Battle_Towers_13"))
	_ENV = i18n("Battle_Towers_13")
	i18n("Battle_Towers_13").lv = buildLogic.getBuildLvStr(wiseTutorRead.getMaxEffectCastleLv())
	_ENV = i18n("Battle_Towers_13")
	i18n("Battle_Towers_13").param = "#btn_detail.png"
	i18n("Battle_Towers_13").width = 37
	i18n("Battle_Towers_13").height = 37
	i18n("Battle_Towers_13").custom = "Sprite"
	i18n("Battle_Towers_13").name = "detail"
	i18n("Battle_Towers_13").offsety = 10
	self.fields.Text_Describe:setString(i18n("Battle_Towers_10", i18n("Battle_Towers_13")) .. SoraDWrapReplaceTag(i18n("Battle_Towers_13")))
	self.fields.Text_Describe:setTouchEnabled(true)
	self.fields.Text_Describe:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
	self.fields.Text_Tips:setColorinfo("#006E00", "#66320C")
end
function wiseTutorBlessLightSub:onShow()
	self.isMaxLv = wiseTutorCtrl:isMaxLevel()
	self.controllers.c2:setSelectedIndex(self.isMaxLv and 0 or 1)
	self.giftInfo = wiseTutorRead.getGiftAwardInfo(wiseTutorCtrl:getLevelIndex())
	_ENV = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex()[1] = "id"
	wiseTutorCtrl:getLevelIndex()[2] = "count"
	self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, wiseTutorCtrl:getLevelIndex())
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(self.giftInfo.Gold))
	local _
	_, self.allSpecialAward = wiseTutorRead.getAllAwardByIndex(wiseTutorCtrl:getLevelIndex())
	_ENV = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex()[1] = "id"
	wiseTutorCtrl:getLevelIndex()[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.allSpecialAward, wiseTutorCtrl:getLevelIndex())
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
	self.fields.AllSpecialAward:resizeToFit(#self.allSpecialAward)
	local effectInfo = wiseTutorRead.getNowEffectInfo(SoraDGetCastleLv())
	self.fields.Buff_Item1:initData(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1])
	self.fields.Buff_Item2:initData(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2])
end
function wiseTutorBlessLightSub:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function wiseTutorBlessLightSub:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function wiseTutorBlessLightSub:onClickText(eventContext)
	SoraDPlaySound()
	uiManager:show("wiseTutorBuff")
end
return wiseTutorBlessLightSub

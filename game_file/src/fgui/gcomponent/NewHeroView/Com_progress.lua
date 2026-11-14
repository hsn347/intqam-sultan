local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroPowerSkillGiftCtrl = SoraDGetCtrl("heroPowerSkillGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_progress", Com_progress)
function Com_progress:onInit()
	self.fields.Text_title:setString(i18n("common_text_4818"))
	self.fields.Btn_box:addClickListener(handler(self, self.btnClick))
end
function Com_progress:onShow()
end
function Com_progress:initData(heroID)
	self.heroID = heroID
	local percent = heroCtrl:getHeroPowerSkillPercent(self.heroID)
	heroCtrl = nil
	;(nil).pro = percent
	self.fields.Text_val:setString(i18n("%{pro}%", nil))
	local perValue = 9 + percent / 100 * 82
	self.fields.Bar:setValue(perValue)
	local stageRewardNum = heroPowerSkillGiftCtrl:getCliamRewardNum(self.heroID)
	self.fields.Label_reddot:initData(0 < stageRewardNum, stageRewardNum)
end
function Com_progress:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroStagePop", nil)
end
return Com_progress

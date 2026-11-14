local heroTrialCommon = include("heroTrialCommon")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_content = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_content", Com_content)
function Com_content:onInit()
	self.fields.Button_fightDetail:setString(i18n("mail_text_01"))
	self.fields.Button_fightDetail:setVisible(false)
	self.fields.Button_fightDetail:addClickListener(handler(self, self.btnClick))
end
function Com_content:onShow()
end
function Com_content:initData(logData)
	local levelNum = heroTrialCommon.convertLevelToNum(logData.stageID)
	heroTrialCommon = nil
	;(nil).level = levelNum
	self.fields.Lab_gate:setString(i18n("common_text_1721", nil))
	self.fields.Com_reward:initData(logData.report.isAttackWin, logData.reward)
	self.fields.Com_attack:initData(i18n("common_text_125"), lordInfoCtrl:getLordInfo().base.nickName, logData.report.attackerDetail)
	self.fields.Com_attack:setPositionY(self.fields.Com_reward:getPositionY() + self.fields.Com_reward:getHeight() + 14)
	heroTrialCommon = i18n("common_text_1721", nil)
	i18n("common_text_1721", nil).level = levelNum
	self.fields.Com_defend:initData(i18n("common_text_126"), i18n("common_text_1769", i18n("common_text_1721", nil)), logData.report.defenderDetail)
	self.fields.Com_defend:setPositionY(self.fields.Com_attack:getPositionY() + self.fields.Com_attack:getHeight() + 14)
	if logData.report.fightDetail then
		self.fightDetail = logData.report.fightDetail
		self.fields.Button_fightDetail:setVisible(true)
		self.fields.Button_fightDetail:setPositionY(self.fields.Com_defend:getPositionY() + self.fields.Com_defend:getHeight() + 10)
	end
end
function Com_content:btnClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("mailItemDetailFightDefense")
	_ENV = nil
	;(nil).fightDetail = self.fightDetail
	panel:initWithFightDetail(nil)
	panel:show()
end
return Com_content

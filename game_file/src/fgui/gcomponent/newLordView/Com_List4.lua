local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local militaryRankRead = include("militaryRankRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_List4 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List4", Com_List4)
function Com_List4:onInit()
	self.fields.Button_study:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_List4:onShow()
end
function Com_List4:initData(data)
	self.data = data
	self.fields.com_item:setSpecialNum()
	self.fields.com_item:setIcon(militaryRankRead.getSkillIcon(self.data.cfgID))
	if not self.data.isFull or not "MAX" then
		militaryRankRead = militaryRankRead.getSkillIcon(self.data.cfgID)
		militaryRankRead.getSkillIcon(self.data.cfgID).lv = self.data.lv
	end
	self.fields.com_item:setNumText((i18n("common_text_100", militaryRankRead.getSkillIcon(self.data.cfgID))))
	self.fields.Text_name:setString(militaryRankRead.getSkillName(self.data.cfgID))
	self.fields.Text_des:setString(militaryRankRead.getSkillDes(self.data.cfgID))
	self.fields.Text_notice:setColor(self.data.isFull and cc.c3b(0, 195, 95) or cc.c3b(224, 43, 43))
	if not self.data.isFull or not i18n("common_text_283") then
		militaryRankRead = 43
		;(43).rank = militaryRankRead.getRankNameByLv(self.data.needRank)
	end
	self.fields.Text_notice:setString((i18n("common_text_2409", 43)))
	self.fields.Button_study:setIcon("icon_military_point.png")
	self.fields.Button_study:setTitle(self.data.needPoint)
	local curPoint = lordInfoCtrl:getLordInfo().militaryRankInfo.exploit
	local enableBtn = curPoint >= self.data.needPoint and lordInfoCtrl:getLordInfo().militaryRankInfo.level >= self.data.needRank
	self.fields.Text_notice:setVisible(self.data.isFull or lordInfoCtrl:getLordInfo().militaryRankInfo.level < self.data.needRank)
	self.fields.Button_study:setEnabled(enableBtn)
	self.fields.Button_study:setVisible(not self.data.isFull)
end
function Com_List4:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).point = string.formatnumberthousands(self.data.needPoint)
	;(nil).item = militaryRankRead.getSkillName(self.data.cfgID)
	_ENV = nil
	;(nil).icon = "icon_military_point.png"
	;(nil).isNeedJudge = false
	SoraDShowBuyBox(i18n("common_text_2677", nil), self.data.needPoint, i18n("common_text_1889"), function(callback)
		if callback == MSGBOX_CALLBACK_YES then
			militaryRankCtrl:sendLearnSkill(self.data.id)
		end
	end, true, nil)
end
return Com_List4

local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_commander = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LegendaryKing/Com_commander", Com_commander)
function Com_commander:onInit()
	self.fields.Text_tip:setString(i18n("legendary_commander_text5"))
	self:fixChildrenPos()
end
function Com_commander:onShow()
end
function Com_commander:initData(uid)
	if uid then
		self.controllers.c1:setSelectedIndex(1)
		local member = legendTeamCtrl:getTeamMemberInfo(uid)
		self.fields.head:initData(uid)
		if member then
			self.fields.Text_name:setString(member.nickName)
			self.fields.Text_score_num:setString(string.formatnumberthousands(member.totalFc))
			if not member.inBattleField then
				self.fields.Text_war_tips:setString(i18n("legendary_commander_text28"))
			else
				self.fields.Text_war_tips:setString("")
			end
			self.fields.Com_castleLv:setVisible(false)
			self.fields.Com_jinnBeastLv:initData(member)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.head:initData()
	end
end
return Com_commander

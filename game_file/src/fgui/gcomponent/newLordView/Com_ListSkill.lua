local militaryRankRead = include("militaryRankRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ListSkill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_ListSkill", Com_ListSkill)
function Com_ListSkill:onInit()
	self:fixChildrenPos()
end
function Com_ListSkill:onShow()
end
function Com_ListSkill:initData(data)
	self.fields.Text_name:setString(militaryRankRead.getSkillName(data.cfgID))
	self.fields.Text_des:setString(militaryRankRead.getSkillDes(data.cfgID))
	self.fields.Com_item:setIcon(militaryRankRead.getSkillIcon(data.cfgID))
	militaryRankRead = militaryRankRead.getSkillIcon(data.cfgID)
	militaryRankRead.getSkillIcon(data.cfgID).lv = data.lv
	self.fields.Com_item:setNumText(i18n("common_text_100", militaryRankRead.getSkillIcon(data.cfgID)))
	self.fields.Com_item:setSpecialNum()
end
return Com_ListSkill

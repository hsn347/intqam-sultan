local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_skillDetail", Com_skillDetail)
function Com_skillDetail:onInit()
	self:fixChildrenPos()
end
function Com_skillDetail:onShow()
end
function Com_skillDetail:initData(skillId)
	local showCfg = activity_9001703_Read.getSkillShow(skillId)
	self.fields.icon:setURL(showCfg.skillIcon)
	local val, valShow = activity_9001703_Ctrl:getSkillLvEffect(skillId)
	activity_9001703_Read = nil
	;(nil).num = valShow
	self.fields.Text_des:setString(i18n(showCfg.skillDes, nil))
end
return Com_skillDetail

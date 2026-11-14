local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_listRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_listRecord", Com_listRecord)
function Com_listRecord:onInit()
	self:fixChildrenPos()
	self.fields.nbg:fix()
end
function Com_listRecord:onShow()
end
function Com_listRecord:initData(data)
	self.controllers.c1:setSelectedIndex(data.prize and 1 or 0)
	self.fields.Com_head:setHeadSprite(data.imageId, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.Text_name:setString(data.userName)
	local camp = roaringFlameWarCtrl:getSelfCamp()
	local campName = roaringFlameWarRead.getCampName(camp)
	local campColor = roaringFlameWarRead.getCampColor(camp)
	roaringFlameWarCtrl = nil
	;(nil).camp = fguiHelper.getColorString(SoraDRGB2HtmlColor(campColor), campName)
	;(nil).kid = data.kid
	self.fields.Text_camp:setString(i18n("%{camp}#%{kid}", nil))
	self.fields.Com_item:initData(data.rewards[1].id, data.rewards[1].count)
end
return Com_listRecord

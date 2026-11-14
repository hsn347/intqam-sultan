local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(uid, rank)
	activity_9001731_Ctrl = nil
	;(nil).rank = rank
	self.fields.Com_rankBase:initRankBaseData(nil)
	local data = activity_9001731_Ctrl:getCampInfoByUid(uid)
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Text_name:setString(data.nickName)
end
return Com_rankSingle

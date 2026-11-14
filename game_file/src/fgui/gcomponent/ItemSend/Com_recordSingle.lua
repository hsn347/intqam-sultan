local baseComponent = require("fgui.base.baseComponent")
local Com_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ItemSend/Com_recordSingle", Com_recordSingle)
function Com_recordSingle:onInit()
	self:fixChildrenPos()
end
function Com_recordSingle:onShow()
end
function Com_recordSingle:initData(data, index)
	self.fields.sheer:setVisible(index % 2 == 1)
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Text_name:setString(data.nickName)
	_ENV = nil
	;(nil).var1 = string.formatnumberthousands(data.totalFc)
	self.fields.Text_power:setString(i18n("across_move_power_name", nil))
	self.fields.Text_num:setString(data.count)
	self.fields.Text_time:setString(os.date([[
%Y.%m.%d
%H:%M:%S]], data.time))
end
return Com_recordSingle

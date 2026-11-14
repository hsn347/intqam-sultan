local baseComponent = require("fgui.base.baseComponent")
local Com_9001629_member = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001629/Com_9001629_member", Com_9001629_member)
function Com_9001629_member:onInit()
	self.fields.button_wish:addClickListener(handler(self, self.onClick))
	self.fields.button_wish:setTitle(i18n("common_text_204"))
	self:fixChildrenPos()
end
function Com_9001629_member:onShow()
end
function Com_9001629_member:initData(data, selectedUid)
	_UPVALUE2_ = nil
	;(nil)[1] = selectedUid
	;(nil)[2] = data.uid
	dump(nil, "selectedUid == data.uid")
	self.controllers.c1:setSelectedIndex(selectedUid == data.uid and 1 or 0)
	self.data = data
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Text_name:setString(data.name)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(data.totalFc)
	self.fields.Text_show:setString(i18n("common_text_555", nil))
	if self.data.online then
		self.fields.Text_line:setVisible(true)
		if 0 < self.data.online then
			self.fields.Text_line:setString(SoraDConverSecondToDate(self.data.online, false, true))
			self.fields.Text_line:setColor(cc.c3b(215, 195, 155))
		else
			self.fields.Text_line:setString(i18n("common_text_224"))
			self.fields.Text_line:setColor(cc.c3b(0, 190, 30))
		end
	else
		self.fields.Text_line:setVisible(false)
	end
end
function Com_9001629_member:setClickHandler(callback)
	self.callback = callback
end
function Com_9001629_member:onClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(self.data.uid)
	end
end
return Com_9001629_member

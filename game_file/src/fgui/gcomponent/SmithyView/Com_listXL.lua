local baseComponent = require("fgui.base.baseComponent")
local Com_listXL = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_listXL", Com_listXL)
fgui.register_extension("ui://SmithyView/Com_listXLS", Com_listXL)
function Com_listXL:onInit()
	self.fields.lock:addClickListener(handler(self, self.btnLockClick))
	self:fixChildrenPos()
end
function Com_listXL:onShow()
end
function Com_listXL:initData(data, lockInfo, maxLockNum)
	self.data = data
	self.lockInfo = lockInfo
	self.maxLockNum = maxLockNum
	self.fields.Text_name:setString(data.name)
	self.fields.Text_name:setColor(data.color)
	self.fields.Text_val:setString(data.val)
	self.fields.Text_val:setColor(data.color)
	if data.buffID then
		self.fields.lock:setVisible(true)
		self.fields.lock:setSelected(self.lockInfo[tostring(data.buffID)] and true or false)
	else
		self.fields.lock:setVisible(false)
	end
end
function Com_listXL:btnLockClick()
	SoraDPlaySound()
	if not self.fields.lock:isSelected() then
		_ENV = self.fields.lock
		self.fields.lock.msg = "MESSAGE_UI_EQUIP_BAPTIZE_BUFF_SELECT"
		self.fields.lock.buffID = self.data.buffID
		self.fields.lock.isSelect = false
		SoraDSendMessage(self.fields.lock)
	elseif table.nums(self.lockInfo) >= self.maxLockNum then
		_ENV = nil
		;(nil).num = self.maxLockNum
		SoraDShowMsgTip(i18n("remake_lock_text_02", nil))
		self.fields.lock:setSelected(false)
	else
		_ENV = self.fields.lock
		self.fields.lock.msg = "MESSAGE_UI_EQUIP_BAPTIZE_BUFF_SELECT"
		self.fields.lock.buffID = self.data.buffID
		self.fields.lock.isSelect = true
		SoraDSendMessage(self.fields.lock)
	end
end
return Com_listXL

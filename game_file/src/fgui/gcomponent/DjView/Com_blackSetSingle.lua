local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_blackSetSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_blackSetSingle", Com_blackSetSingle)
function Com_blackSetSingle:onInit()
	self.fields.Check_tick_speek:addClickListener(handler(self, self.onClickCheck_speek))
	self.fields.Check_tick_chat:addClickListener(handler(self, self.onClickCheck_chat))
	self.fields.Check_tick_enter:addClickListener(handler(self, self.onClickCheck_enter))
	self:fixChildrenPos()
end
function Com_blackSetSingle:onShow()
end
function Com_blackSetSingle:initData(data, model)
	self.controllers.c1:setSelectedIndex(model)
	self.data = data
	self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Com_head:setKid(self.data.kid)
	self.fields.Text_name:setString(textParser.formatPlayerName(self.data.abbr, self.data.nikeName, self.data.kid))
	self.fields.Check_tick_speek:setSelected(self.data.permissionList[1] >= 3)
	self.fields.Check_tick_chat:setSelected(self.data.permissionList[2] ~= 0)
	self.fields.Check_tick_enter:setSelected(self.data.permissionList[3] ~= 0)
	self.fields.Check_tick_remove:setSelected(false)
end
function Com_blackSetSingle:getPermissonCfg()
	_UPVALUE3_ = nil
	;(nil)[1] = self.fields.Check_tick_speek:isSelected() and 6 or 0
	;(nil)[2] = self.fields.Check_tick_chat:isSelected() and 1 or 0
	;(nil)[3] = self.fields.Check_tick_enter:isSelected() and 1 or 0
	return self.data.uid, nil
end
function Com_blackSetSingle:getRemoveCfg()
	return self.data.uid, self.fields.Check_tick_remove:isSelected()
end
function Com_blackSetSingle:isAllRemove()
	return not self.fields.Check_tick_speek:isSelected() and not self.fields.Check_tick_chat:isSelected() and not self.fields.Check_tick_enter:isSelected()
end
function Com_blackSetSingle:onClickCheck_speek()
	SoraDPlaySound()
	if self:isAllRemove() then
		_ENV = nil
		;(nil).content = i18n("Anchor_text_137")
		;(nil).confirmFunc = function()
			_UPVALUE3_ = nil
			;(nil)[1] = 0
			;(nil)[2] = 0
			;(nil)[3] = 0
			djCtrl:reqSetUserBlack(self.data.uid, nil)
		end
		;(nil).cancelFunc = function()
			self.fields.Check_tick_speek:setSelected(true)
		end
		uiManager:show("MessageBox", nil)
	end
end
function Com_blackSetSingle:onClickCheck_chat()
	SoraDPlaySound()
	if self:isAllRemove() then
		_ENV = nil
		;(nil).content = i18n("Anchor_text_137")
		;(nil).confirmFunc = function()
			_UPVALUE3_ = nil
			;(nil)[1] = 0
			;(nil)[2] = 0
			;(nil)[3] = 0
			djCtrl:reqSetUserBlack(self.data.uid, nil)
		end
		;(nil).cancelFunc = function()
			self.fields.Check_tick_chat:setSelected(true)
		end
		uiManager:show("MessageBox", nil)
	end
end
function Com_blackSetSingle:onClickCheck_enter()
	SoraDPlaySound()
	if self:isAllRemove() then
		_ENV = nil
		;(nil).content = i18n("Anchor_text_137")
		;(nil).confirmFunc = function()
			_UPVALUE3_ = nil
			;(nil)[1] = 0
			;(nil)[2] = 0
			;(nil)[3] = 0
			djCtrl:reqSetUserBlack(self.data.uid, nil)
		end
		;(nil).cancelFunc = function()
			self.fields.Check_tick_enter:setSelected(true)
		end
		uiManager:show("MessageBox", nil)
	end
end
return Com_blackSetSingle

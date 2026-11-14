local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_djListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_djListSingle", Com_djListSingle)
function Com_djListSingle:onInit()
	self.fields.Button_operate:addClickListener(handler(self, self.onClick_Button_operate))
	self:fixChildrenPos()
end
function Com_djListSingle:onShow()
end
function Com_djListSingle:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(self.data.iconID, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Com_head:setKid(self.data.kid)
	self.fields.Text_name:setString(self.data.nick_name)
	self.fields.Text_title:setString(self.data.anchor_sign)
	self.controllers.c1:setSelectedIndex(self.data.anchorLiving and 0 or 1)
	self.fields.Text_status:setString(self.data.anchorLiving and i18n("Anchor_text_71") or i18n("Anchor_text_72"))
	if self.data.anchorLiving then
		self.fields.Text_num:setString(self.data.listenNum)
		self.fields.Button_operate:setString(i18n("Anchor_text_69"))
		self.fields.Button_operate:setBtnColorIndex(gBtnColorDef.GREEN)
	else
		self.isAttention = djCtrl:isAttentionDJ(self.data.uid)
		self.fields.Button_operate:setString(self.isAttention and i18n("Anchor_text_38") or i18n("Anchor_text_39"))
		self.fields.Button_operate:setBtnColorIndex(self.isAttention and gBtnColorDef.RED or gBtnColorDef.BLUE)
		self.fields.Text_time:setString(self:createTimeStr(self.data.liveBTime, self.data.liveETime))
	end
end
function Com_djListSingle:createTimeStr(liveBTime, liveETime)
	local str = ""
	local bt = string.format("%.2d:%.2d", math.floor(liveBTime / 3600), math.floor(liveBTime % 3600 / 60))
	local et = string.format("%.2d:%.2d", math.floor(liveETime / 3600), math.floor(liveETime % 3600 / 60))
	str = str .. bt .. "-" .. et
	return str
end
function Com_djListSingle:onClick_Button_operate(context)
	SoraDPlaySound()
	if self.data.anchorLiving then
		_ENV = nil
		;(nil).djUid = self.data.uid
		uiManager:show("DjView", nil)
	elseif self.isAttention then
		djCtrl:sendDJAttentionCancel(self.data.uid)
	else
		djCtrl:sendDJAttention(self.data.uid)
	end
end
return Com_djListSingle

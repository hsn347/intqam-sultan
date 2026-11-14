local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceRelationListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceRelationListSingle", allianceRelationListSingle)
function allianceRelationListSingle:onInit()
	_ENV = nil
	;(nil)[1] = i18n("common_text_3076")
	;(nil)[2] = i18n("common_text_3077")
	;(nil)[3] = i18n("common_text_3078")
	self.typeLang, (nil)[4] = nil, i18n("common_text_182")
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Sprite_arr:fixPos()
	self.fields.Text_title:fixPos()
	self.fields.Text_member:fixPos()
end
function allianceRelationListSingle:onShow()
end
function allianceRelationListSingle:onListRenderer(index, obj)
	obj:initData(self.tableSingleData[index + 1])
end
function allianceRelationListSingle:initData(data, relationType, curTag)
	self.tableSingleData = data
	self.relationType = relationType
	self.isOpen = self.relationType == curTag
	self.fields.Text_title:setString(self.typeLang[self.relationType])
	if self.relationType == gAllianceRelationType.FRIENDLY or self.relationType == gAllianceRelationType.ENEMY then
		self.fields.Text_member:setString(string.formatnumberthousands(#self.tableSingleData))
	elseif self.relationType == gAllianceRelationType.ALLY then
		self.fields.Text_member:setString(string.formatnumberthousands(#self.tableSingleData) .. "/" .. tostring(ALLIANCE_RELATION_ALLY_MAX))
	else
		self.fields.Text_member:setString(string.formatnumberthousands(allianceRelationCtrl:getAR():getSendInviteNum()) .. "/" .. string.formatnumberthousands(allianceRelationCtrl:getAR():getRecvInviteNum()))
	end
	self.fields.Sprite_arr:setRotation(self.isOpen and 0 or SoraDFIsRA() and 90 or -90)
	if self.isOpen then
		self.fields.List:setNumItems(#self.tableSingleData)
		self.fields.List:setHeight(#self.tableSingleData * 172)
		self:setHeight(#self.tableSingleData * 172 + 50)
	else
		self.fields.List:setNumItems(0)
		self.fields.List:setHeight(0)
		self:setHeight(50)
	end
end
function allianceRelationListSingle:btnClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_UI_RELATION_MENU_SELECT"
	;(nil).tag = self.relationType
	SoraDSendMessage(nil)
end
return allianceRelationListSingle

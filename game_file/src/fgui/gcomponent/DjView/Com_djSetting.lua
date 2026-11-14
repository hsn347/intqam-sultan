local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_djSetting = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_djSetting", Com_djSetting)
function Com_djSetting:onInit()
	self.fields.List_speed:setItemRenderer(handler(self, self.itemRenderer_List_speed))
	self.fields.List_speed:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickSpeedItem))
	self.fields.List_lv:setItemRenderer(handler(self, self.itemRenderer_List_lv))
	self.fields.List_lv:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickLvItem))
	self.fields.List_model:setItemRenderer(handler(self, self.itemRenderer_List_model))
	self.fields.List_model:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickModelItem))
	self.fields.Button_black:setTitle(i18n("Anchor_text_118"))
	self.fields.Button_black:addClickListener(handler(self, self.onClick_Button_black))
	self.fields.Label_dj:setString(i18n("Anchor_text_174"))
	self.fields.Text_dj_title:setString(i18n("Anchor_text_175"))
	self.fields.Text_dj_des:setString(i18n("Anchor_text_176"))
	self.input_title = self.fields.input_title:getChild("input")
	self.input_title:setPrompt(fguiHelper.getColorString("#746e65", i18n("alliance_mapmark_text_003")))
	self.input_title:setMaxLength(80)
	self.input_des = self.fields.input_des:getChild("input")
	self.input_des:setPrompt(fguiHelper.getColorString("#746e65", i18n("alliance_mapmark_text_003")))
	self.input_des:setMaxLength(200)
	self.fields.Label_speed:setString(i18n("Anchor_text_177"))
	self.fields.Label_lv:setString(i18n("Anchor_text_178"))
	self.fields.Label_model:setString(i18n("Anchor_text_179"))
	self.fields.Label_black:setString(i18n("Anchor_text_117"))
	self:fixChildrenPos()
end
function Com_djSetting:onShow()
	if not djCtrl:getRoomSetData() then
		local djCtrl, roomSetData = djCtrl:getRoomSetData(), djCtrl:getRoomSetData()
	end
	self.input_title:setText(roomSetData.title or "")
	self.input_des:setText(roomSetData.topic or "")
	self.speedCfg = djRead.getBlacklistCfg(1, 1)
	self.fields.List_speed:setNumItems(#self.speedCfg)
	self.speedIndex = roomSetData.msgCDModeIndex and roomSetData.msgCDModeIndex - 1 or 0
	self.fields.List_speed:setSelectedIndex(self.speedIndex)
	self.lvCfg = djRead.getBlacklistCfg(1, 2)
	self.fields.List_lv:setNumItems(#self.lvCfg)
	self.lvIndex = roomSetData.msgCastleLvModeIndex and roomSetData.msgCastleLvModeIndex - 1 or 0
	self.fields.List_lv:setSelectedIndex(self.lvIndex)
	self.modelCfg = djRead.getBlacklistCfg(1, 3)
	self.fields.List_model:setNumItems(#self.modelCfg)
	self.modelIndex = roomSetData.msgModeIndex and roomSetData.msgModeIndex - 1 or 0
	self.fields.List_model:setSelectedIndex(self.modelIndex)
end
function Com_djSetting:getTitle()
	return self.input_title:getText()
end
function Com_djSetting:getTopic()
	return self.input_des:getText()
end
function Com_djSetting:itemRenderer_List_speed(index, obj)
	local val = self.speedCfg[index + 1]
	obj:fixChildrenPos()
	if val ~= 0 or not i18n("flames_dunes_text275") then
		_ENV = nil
		;(nil).sec = val
	end
	obj:setTitle((i18n("common_text_666", nil)))
end
function Com_djSetting:getSpeedIndex()
	return self.speedIndex + 1
end
function Com_djSetting:onClickSpeedItem()
	SoraDPlaySound()
	if self.fields.List_speed:getSelectedIndex() == self.speedIndex then
		self.fields.List_speed:setSelectedIndex(self.speedIndex)
	else
		self.speedIndex = self.fields.List_speed:getSelectedIndex()
	end
end
function Com_djSetting:itemRenderer_List_lv(index, obj)
	local val = self.lvCfg[index + 1]
	obj:fixChildrenPos()
	if val ~= 0 or not i18n("flames_dunes_text275") then
		_ENV = nil
		;(nil).lv = val
	end
	obj:setTitle((i18n("Glory_text_24", nil)))
end
function Com_djSetting:getLvIndex()
	return self.lvIndex + 1
end
function Com_djSetting:onClickLvItem()
	SoraDPlaySound()
	if self.fields.List_lv:getSelectedIndex() == self.lvIndex then
		self.fields.List_lv:setSelectedIndex(self.lvIndex)
	else
		self.lvIndex = self.fields.List_lv:getSelectedIndex()
	end
end
function Com_djSetting:itemRenderer_List_model(index, obj)
	local val = self.modelCfg[index + 1]
	obj:fixChildrenPos()
	obj:setTitle(val == 1 and i18n("Anchor_text_182") or i18n("Anchor_text_135"))
end
function Com_djSetting:getModelIndex()
	return self.modelIndex + 1
end
function Com_djSetting:onClickModelItem()
	SoraDPlaySound()
	if self.fields.List_model:getSelectedIndex() == self.modelIndex then
		self.fields.List_model:setSelectedIndex(self.modelIndex)
	else
		self.modelIndex = self.fields.List_model:getSelectedIndex()
	end
end
function Com_djSetting:onClick_Button_black(context)
	SoraDPlaySound()
	if not djCtrl:isDJAnchor() then
		SoraDShowMsgTip(i18n("Anchor_text_189"))
		return
	end
	uiManager:show("DjBlackPop")
end
return Com_djSetting

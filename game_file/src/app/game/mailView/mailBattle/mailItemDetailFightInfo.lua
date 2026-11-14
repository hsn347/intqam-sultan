local mailItemDetailFightInfo = class("mailItemDetailFightInfo", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailFightInfo")
end)
function mailItemDetailFightInfo:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.panelContent = SoraDGetChildByName(self, "layout_content")
	self.textSiwang = SoraDGetChildByName(self.panelContent, "Text_siwang")
	self.textSiwang:setString(i18n("common_text_116"))
	self.textShoushang = SoraDGetChildByName(self.panelContent, "Text_shoushang")
	self.textShoushang:setString(i18n("battlelog_text_20"))
	self.textXiaomie = SoraDGetChildByName(self.panelContent, "Text_xiaomie")
	self.textXiaomie:setString(i18n("battlelog_text_19"))
	self.textZonshu = SoraDGetChildByName(self.panelContent, "Text_zonshu")
	self.textZonshu:setString(i18n("mail_2_text_36"))
	self.textTitle = SoraDGetChildByName(self.panelContent, "Text_Title")
	self.textTitle:setString(i18n("mail_2_text_35"))
	self.textCunhuo = SoraDGetChildByName(self.panelContent, "Text_cunhuo")
	self.textCunhuo:setString(i18n("battlelog_text_22"))
	self.itemHeight = self.panelContent:getContentSize().height
end
function mailItemDetailFightInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFightInfo:getItemHeight()
	return self.itemHeight
end
return mailItemDetailFightInfo

local nodePhbTitle = class("nodePhbTitle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("nodePhbTitle")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function nodePhbTitle:ctor()
	self.Node_info1 = SoraDGetChildByName(self, "Node_info1")
	self.text_date = SoraDGetChildByName(self, "text_date")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.Node_info2 = SoraDGetChildByName(self, "Node_info2")
	self.text_date_2 = SoraDGetChildByName(self, "text_date_2")
	self.text_time_2 = SoraDGetChildByName(self, "text_time_2")
	self.text_name_2 = SoraDGetChildByName(self, "text_name_2")
end
function nodePhbTitle:setType(nodeType)
	if nodeType == 1 then
		self.Node_info1:setVisible(true)
		self.Node_info2:setVisible(false)
		self.text_date:setString(i18n("legendaryking_title_01"))
		self.text_name:setString(i18n("common_text_264"))
	elseif nodeType == 2 then
		self.Node_info1:setVisible(false)
		self.Node_info2:setVisible(true)
		self.text_date_2:setString(i18n("legendaryking_title_02"))
		SoraDSetTextWidthHeight(self.text_date_2, cc.size(120, 50))
		self.text_time_2:setString(i18n("legendaryking_title_01"))
		SoraDSetTextWidthHeight(self.text_time_2, cc.size(120, 50))
		self.text_name_2:setString(i18n("common_text_264"))
	elseif nodeType == 3 then
		self.Node_info1:setVisible(true)
		self.Node_info2:setVisible(false)
		self.text_date:setString(i18n("legendaryking_title_06"))
		self.text_name:setString(i18n("common_text_264"))
	else
		self.Node_info1:setVisible(false)
		self.Node_info2:setVisible(false)
	end
end
return nodePhbTitle

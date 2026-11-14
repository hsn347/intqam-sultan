local CommonTitleValueButton = class("commonTitleValueButton", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonTitleValueButton")
	end
	return target
end)
function CommonTitleValueButton:ctor()
	self.tableBtnData, _ENV = nil, nil
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelValue = SoraDGetChildByName(self, "Text_value")
end
function CommonTitleValueButton:initData(btnData)
	self.tableBtnData = btnData
	if self.labelTitle then
		self.labelTitle:setString(self.labelTitle.title)
	end
	self.labelValue:setString(self.labelTitle.value)
end
return CommonTitleValueButton

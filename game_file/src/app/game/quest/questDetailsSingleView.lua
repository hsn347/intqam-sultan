local QuestDetailsSingleView = class("questDetailsSingleView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("questDetailsSingleView")
	end
	return target
end)
function QuestDetailsSingleView:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Image_bg = SoraDGetChildByName(self, "Image_bg_item")
end
function QuestDetailsSingleView:initDate(questStyle, index)
	local itemDesRead = include("itemDesRead")
	local resDesRead = include("resDesRead")
	self.tableSingleData = questStyle
	local targetFarme, targetName, targetBg
	self.Image_bg:setVisible(index % 2 == 1)
	self.Text_num:setString(string.formatnumberthousands(self.tableSingleData.count))
	if SoraDJudgeResOrItem(self.tableSingleData.id) then
		targetName = itemDesRead.getName(self.tableSingleData.id)
		targetFarme = itemDesRead.getIcon(self.tableSingleData.id)
		targetBg = itemDesRead.getBg(self.tableSingleData.id)
	else
		targetName = resDesRead.getName(self.tableSingleData.id)
		targetFarme = resDesRead.getIcon(self.tableSingleData.id)
		targetBg = resDesRead.getBg(self.tableSingleData.id)
	end
	self.Image_icon:loadTexture(targetFarme, ccui.TextureResType.plistType)
	self.Image_quality:loadTexture(targetBg, ccui.TextureResType.plistType)
	self.Text_name:setString(targetName)
end
return QuestDetailsSingleView

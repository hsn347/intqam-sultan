local baseComponent = require("fgui.base.baseComponent")
local commonGameOptionBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/commonGameOptionBox", commonGameOptionBox)
function commonGameOptionBox:onInit()
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function commonGameOptionBox:onShow()
end
function commonGameOptionBox:initData(curValue)
	self.curValue = curValue
	self.fields.title:setString(curValue.title)
	self.fields.List:setNumItems(0)
	self.fields.List:setNumItems(#self.curValue.tabName)
	self.fields.List:resizeToFit(#self.curValue.tabName)
	if self.curValue.tabName[1] == "noDisturb" then
		local object = fgui.UIPackage:createObjectFromURL("ui://newLordView/Com_noDisturbTime")
		object:addTo(self)
		object:setPivot(0.5, 0, true)
		object:addRelation(self, fgui.RelationType.Center_Center)
		object:setPosition(self:getWidth() / 2, self.fields.List:getPositionY() + self.fields.List:getHeight() + 10)
		self:setHeight(self:getHeight() + object:getHeight() + 10)
	end
end
function commonGameOptionBox:onItemProvider(index)
	if self.curValue.setType == "slider" then
		return "ui://newLordView/commonIconSlider"
	elseif self.curValue.setType == "quality" then
		return "ui://newLordView/commonSettingQuality"
	elseif self.curValue.setType == "choose" then
		return "ui://newLordView/commonSettingChoose"
	else
		return "ui://newLordView/commonSettingSwitch"
	end
end
function commonGameOptionBox:onItemRederer(index, target)
	local switchKey = self.curValue.tabName[index + 1]
	if switchKey == "demension" then
		local channel = userSDKManager.getChannel()
		if channel == "fa" then
			switchKey = "iran3d"
		end
	end
	target:initData(switchKey, self.curValue.data and self.curValue.data[index + 1] or self.curValue)
	target:setIsNeedToSave(self.curValue.isNeedToSave)
end
return commonGameOptionBox

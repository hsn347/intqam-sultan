local commonSearchTypeChoose = class("commonSearchTypeChoose", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSearchTypeChoose")
	end
	return target
end)
_ENV, _UPVALUE2_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSearchTypeChoose")
	end
	return target
end, "commonSearchTypeChoose"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSearchTypeChoose")
	end
	return target
end).name = "common_text_3155"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSearchTypeChoose")
	end
	return target
end).eventType = nil, 1
;(nil).name = "UID"
;(nil).eventType = 2
;("commonSearchTypeChoose")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSearchTypeChoose")
	end
	return target
end
local ("commonSearchTypeChoose")[2], searchTypeList = nil, "commonSearchTypeChoose"
commonSearchTypeChoose.searchType_name = 1
commonSearchTypeChoose.searchType_uid = 2
function commonSearchTypeChoose:ctor()
	self.switcher = false
	self.curSearchType = 1
	self:initWidget()
	self:setSwitcher()
end
function commonSearchTypeChoose:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.Button_name:setTitleText(i18n(searchTypeList[1].name))
	self.Button_name:addTouchEventListener(handler(self, self.onNameClick))
	self.Button_uid:setTitleText(i18n(searchTypeList[2].name))
	self.Button_uid:addTouchEventListener(handler(self, self.onUIDClick))
end
function commonSearchTypeChoose:onChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = not self.switcher
		self:setSwitcher()
	end
end
function commonSearchTypeChoose:onNameClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = false
		self.curSearchType = 1
		self:setSwitcher()
	end
end
function commonSearchTypeChoose:onUIDClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = false
		self.curSearchType = 2
		self:setSwitcher()
	end
end
function commonSearchTypeChoose:setSwitcher()
	self.Button_choose:setTitleText(i18n(searchTypeList[self.curSearchType].name))
	self.Button_name:setVisible(self.switcher)
	self.Button_uid:setVisible(self.switcher)
	self.Image_border:setContentSize(cc.size(150, self.switcher and 150 or 60))
end
function commonSearchTypeChoose:getSearchType(...)
	return self.curSearchType
end
return commonSearchTypeChoose

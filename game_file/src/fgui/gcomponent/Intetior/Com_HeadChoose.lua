local mailFunctions = include("mailFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Com_HeadChoose = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Intetior/Com_HeadChoose", Com_HeadChoose)
function Com_HeadChoose:onInit()
	self.fields.Button_Remove:addClickListener(handler(self, self.onClickRemove))
	self.fields.Button_Add:addClickListener(handler(self, self.onClickHead))
	self.fields.icon:setURL("frame_LegendaryKing_green_add.png")
	self.fields.title:setString(i18n("parliament_text_84"))
end
function Com_HeadChoose:onShow()
	self:initData()
end
function Com_HeadChoose:setHandle(addHandle, removeHandle, index)
	self.removeHandle = removeHandle
	self.addHandle = addHandle
	self.index = index
end
function Com_HeadChoose:initData(userInfo)
	if userInfo and next(userInfo) then
		self.userInfo = userInfo
		self.controllers.c1:setSelectedIndex(1)
		SoraDGetHeadFromManager(self.fields.icon, userInfo.iconID, userInfo.avatar)
		self.fields.title:setString(mailFunctions:getWrappedName(userInfo.abbr, userInfo.name))
	else
		self.userInfo = nil
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_HeadChoose:onClickHead(target, data)
	SoraDPlaySound()
	if self.addHandle then
		self.addHandle(self.index)
	end
end
function Com_HeadChoose:onClickRemove()
	SoraDPlaySound()
	if self.removeHandle then
		self.removeHandle(self.index)
	end
end
function Com_HeadChoose:getName()
	if self.userInfo then
		return mailFunctions:getWrappedName(self.userInfo.abbr, self.userInfo.name)
	else
		return
	end
end
return Com_HeadChoose

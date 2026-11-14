local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ownNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_ownNum", Com_ownNum)
fgui.register_extension("ui://Activity2112/Com_ownNum", Com_ownNum)
fgui.register_extension("ui://NebulaWonderland/Com_ownNumIcon", Com_ownNum)
function Com_ownNum:onInit()
	self:fixChildrenPos()
end
function Com_ownNum:initData(data)
	self.itemid = data.itemid
	self.handle = data.handle
	self.fields.Button_add:addClickListener(handler(self, self.onClickHandle))
	local count = backpackCtrl:getItemCount(data.itemid)
	self.fields.Text_num:setString(count)
	self.fields.icon:setURL(publicRead.getIcon(data.itemid))
end
function Com_ownNum:onClickHandle()
	self.handle()
end
function Com_ownNum:setAddButtonPos()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Button_add:setPositionX(self.fields.Text_num:getPositionX() + self.fields.Text_num:getWidth() + 5)
	end
end
function Com_ownNum:setNum(str)
	self.fields.Text_num:setString(str)
end
function Com_ownNum:refreshCount()
	local count = backpackCtrl:getItemCount(self.itemid)
	self.fields.Text_num:setString(count)
end
function Com_ownNum:onShow()
end
return Com_ownNum

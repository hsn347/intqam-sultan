local warShelterCtrl = SoraDGetCtrl("warShelterCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_applySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_applySingle", Com_applySingle)
function Com_applySingle:onInit()
	self.fields.Button_yes:addClickListener(handler(self, self.btnYesClick))
	self.fields.Button_no:addClickListener(handler(self, self.btnNoClick))
	self:fixChildrenPos()
end
function Com_applySingle:onShow()
end
function Com_applySingle:initData(data, parent)
	self.data = data
	self.parent = parent
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.Text_name:setString(textParser.formatPlayerName(nil, data.name, data.kid))
end
function Com_applySingle:btnYesClick()
	SoraDPlaySound()
	warShelterCtrl:reqRecvInviteAccept(self.data.uid)
	if self.parent then
		self.parent:close()
	end
end
function Com_applySingle:btnNoClick()
	SoraDPlaySound()
	warShelterCtrl:reqRecvInviteReject(self.data.uid)
end
return Com_applySingle

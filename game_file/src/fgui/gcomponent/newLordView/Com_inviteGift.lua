local baseComponent = require("fgui.base.baseComponent")
local Com_inviteGift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_inviteGift", Com_inviteGift)
function Com_inviteGift:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_Gift:addClickListener(handler(self, self.onClickGift))
end
function Com_inviteGift:onShow()
end
function Com_inviteGift:initData(title, dataList, type)
	self.viewType = type
	self.fields.Text_tip:setString(title)
	self.dataList = dataList
	self.fields.List:setNumItems(#self.dataList)
end
function Com_inviteGift:onItemRederer(index, target)
	target:initData(self.dataList[index + 1])
end
function Com_inviteGift:onClickGift()
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = self.viewType
	uiManager:show("gameInvitePriceDetail", nil)
end
return Com_inviteGift

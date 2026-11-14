local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_roomSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_roomSingle", Com_roomSingle)
function Com_roomSingle:onInit()
	self.fields.Button_join:setTitle(i18n("common_text_068"))
	self.fields.Button_join:addClickListener(handler(self, self.onClickBtnJoin))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_roomSingle:onShow()
end
function Com_roomSingle:onClickBtnJoin(context)
	SoraDPlaySound()
	local hasPassword = self.room.hasPassword
	if hasPassword then
		_ENV = nil
		;(nil).room = self.room
		uiManager:show("SimulatedDrillJoinRoom", nil)
	else
		local roomId = self.room.roomId
		local createTime = self.room.createTime
		simulatedDrillCtrl:reqRoomEnter(roomId, nil, nil, createTime, "roomList")
	end
end
function Com_roomSingle:initData(room)
	self.room = room
	local player = self.room.host
	self.fields.Com_head:setHeadSprite(player.iconID, player.avatar)
	local nameStr = textParser.formatPlayerName(player.allianceAbbr, player.nickName)
	self.fields.Text_name:setString(nameStr)
	_ENV = nil
	;(nil).kid = player.fromKid
	self.fields.Text_kingdom:setString(i18n("common_text_342", nil))
	local roomId = self.room.roomId
	self.fields.Text_room:setString(roomId)
	if self.room.related then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local playerCount = simulatedDrillCtrl:getRoomPlayerCount(self.room)
	local playerMax = simulatedDrillCtrl:getRoomPlayerMax()
	self.fields.Text_member:setString(playerCount .. "/" .. playerMax)
	local hasPassword = self.room.hasPassword
	if hasPassword then
		self.fields.Image_lock:setVisible(true)
	else
		self.fields.Image_lock:setVisible(false)
	end
end
return Com_roomSingle

local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_roomSeat = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_roomSeat", Com_roomSeat)
function Com_roomSeat:onInit()
	self.fields.Button_join:addClickListener(handler(self, self.onClickBtnJoin))
	self.fields.Button_kick:addClickListener(handler(self, self.onClickBtnKick))
	self.fields.Text_join:setString(i18n("simulated_drill_text_54"))
end
function Com_roomSeat:onShow()
end
function Com_roomSeat:onClickBtnJoin(context)
	SoraDPlaySound()
	simulatedDrillCtrl:reqRoomChangeSeat(self.data.camp, self.data.rank)
end
function Com_roomSeat:onClickBtnKick(context)
	SoraDPlaySound()
	local kickUid = self.player.uid
	_ENV = nil
	;(nil).content = i18n("simulated_drill_text_24")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		simulatedDrillCtrl:reqRoomKick(kickUid)
	end
	uiManager:show("MessageBox", nil)
end
function Com_roomSeat:initData(data)
	self.data = data
	local player = data.player
	self.player = player
	if player then
		self.controllers.state:setSelectedIndex(1)
		self:updatePlayerData(player)
	else
		self.controllers.state:setSelectedIndex(0)
	end
	if self.data.camp == SIMULATED_DRILL_WAR_CAMP.EAST and not self.isInit then
		self.isInit = true
		self:fixChildrenPos(false, true)
		self.fields.Text_name:setAlign(cc.TEXT_ALIGNMENT_LEFT)
		self.fields.Text_kid:setAlign(cc.TEXT_ALIGNMENT_LEFT)
		self.fields.Text_join:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	end
end
function Com_roomSeat:updatePlayerData(player)
	self.fields.Com_head:setHeadSprite(player.iconID, player.avatar)
	self.fields.Com_head:setPlayerID(player.uid)
	local nameStr = textParser.formatPlayerName(player.allianceAbbr, player.nickName)
	self.fields.Text_name:setString(nameStr)
	_ENV = nameStr
	nameStr.num = player.fromKid
	local kidStr = i18n("NebulaAllstar_61", nameStr)
	self.fields.Text_kid:setString(kidStr)
	if player.uid == SoraDGetPlayerID() then
		self.controllers.name:setSelectedIndex(2)
	elseif player.isHost then
		self.controllers.name:setSelectedIndex(1)
	else
		self.controllers.name:setSelectedIndex(0)
	end
	if player.isHost then
		self.controllers.host:setSelectedIndex(1)
	else
		self.controllers.host:setSelectedIndex(0)
		self.fields.Sprite_ready:setVisible(player.ready or false)
		local showKick = simulatedDrillCtrl:checkSelfIsHost() and player.uid ~= SoraDGetPlayerID()
		self.fields.Button_kick:setVisible(showKick)
	end
end
return Com_roomSeat

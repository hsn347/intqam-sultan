local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_gameHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_gameHead", Com_gameHead)
function Com_gameHead:onInit()
	self.fields.Btn_six:addClickListener(handler(self, self.onClick_Btn_six))
	self.fields.Btn_twice:addClickListener(handler(self, self.onClick_Btn_twice))
	self.fields.Com_head:setHandle(handler(self, self.onClick_Btn_head))
	self.fields.Button_invite:addClickListener(handler(self, self.onClick_Btn_invite))
	self.fields.Text_ready:setString(i18n("krone_text_33"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Text_time:setVisible(false)
	self.fields.mv_turn1:setAllFrameName("dh_wangcsj4_%.2d.png")
	self.fields.mv_turn2:setAllFrameName("dh_wangcsj4_%.2d.png")
	self:setTurnShow(false)
	local spriteFinger = SoraDFingerAction(true)
	spriteFinger:addTo(self.fields.Node_finger)
	self.fields.Node_finger:setVisible(false)
end
function Com_gameHead:onShow()
end
function Com_gameHead:timeUpdate(time)
	local isShowFinger = self.isTurn and activity_9001731_Ctrl:isGaming() and self.data.uid == SoraDGetPlayerID() and time <= 5 and 0 < time and self.fields.Text_time:isVisible()
	self.fields.Node_finger:setVisible(isShowFinger)
	if time <= 0 then
		self.fields.Node_finger:setVisible(false)
		self:setTurnShow(false)
	end
end
function Com_gameHead:init(player)
	self.items, _ENV, self.isTurn = nil, nil, false
	self.player = player
	self.fields.Btn_six:setTitle("x0")
	self.fields.Btn_twice:setTitle("x0")
	self.fields.Node_finger:setVisible(false)
	self.fields.Text_time:setVisible(false)
	self:setTurnShow(false)
	self.controllers.c3:setSelectedIndex(0)
	local isRight = self:getPositionX() > display.width / 2
	self.fields.Btn_six:setPositionX(isRight and -44 or 144)
	self.fields.Btn_twice:setPositionX(isRight and -44 or 144)
	self.fields.Lab_msg:setPositionX(isRight and -137 or 237)
	self.fields.Lab_msg:getController("c1"):setSelectedIndex(isRight and 1 or 0)
end
function Com_gameHead:setHeadStatus(c1Index, c2Index, c3Index, playerInfo)
	self.controllers.c1:setSelectedIndex(c1Index)
	self.controllers.c2:setSelectedIndex(c2Index)
	self.controllers.c3:setSelectedIndex(c3Index)
	if playerInfo then
		self.data.uid = playerInfo.uid
		self.data.nickName = playerInfo.nickName
		self.data.iconID = playerInfo.iconID
		self.data.avatar = playerInfo.avatar
		self.fields.Text_name:setString(playerInfo.nickName or "")
		self.fields.Text_name:setColor(playerInfo.uid == SoraDGetPlayerID() and "#70C723" or "#FFFBD5")
		self.fields.Com_head:setHeadSprite(playerInfo.iconID, playerInfo.avatar or "")
		self.fields.Text_status:setString(playerInfo.isHost and i18n("Ludo_test_039") or i18n("krone_text_45"))
	else
		self.fields.Text_status:setString("")
	end
end
function Com_gameHead:initHead(data)
	self.data = data
	self:setHeadStatus(self.data.c1Index, self.data.c2Index, self.data.c3Index)
	self.fields.Lab_msg:setVisible(false)
	self:setTurnShow(false)
	self.fields.Text_name:setString(self.data.nickName or "")
	self.fields.Text_name:setColor(self.data.uid == SoraDGetPlayerID() and "#70C723" or "#FFFBD5")
	self.fields.Com_head:setHeadSprite(self.data.iconID, self.data.avatar or "")
	self.fields.Text_status:setString(self.data.status or "")
end
function Com_gameHead:setTurnShow(isTurn)
	self.fields.turn:setVisible(isTurn)
	self.fields.turn1:setVisible(isTurn)
	self.fields.mv_turn1:setVisible(isTurn)
	self.fields.mv_turn2:setVisible(isTurn)
end
function Com_gameHead:update(isTurn, model)
	self.isTurn = isTurn
	self:setTurnShow(self.isTurn)
	if self.isTurn then
		self.fields.Com_head:setImage("frame_9001731_touzi.png")
	else
		if self.data then
			self.fields.Com_head:setHeadSprite(self.data.iconID, self.data.avatar)
		end
		self.fields.Node_finger:setVisible(false)
		self.fields.Text_time:setVisible(false)
	end
	self.fields.Btn_six:setEnabled(self.isTurn)
	self.fields.Btn_twice:setEnabled(self.isTurn)
	if model then
		self:setTurnTime(model)
	else
		self.fields.Text_time:setVisible(false)
	end
end
function Com_gameHead:setTurnTime(model)
	local time = constantRead.getConstValue(model == 1 and "LUDO_PLAYER_ROLL_LIMIT_TIME" or "LUDO_PLAYER_CHOOSE_LIMIT_TIME", 15)
	self.fields.Text_time:setVisible(true)
	self.fields.Text_time:beginTime(time, false, true)
end
function Com_gameHead:runRandom()
	self.controllers.c1:setSelectedIndex(2)
	self.controllers.c2:setSelectedIndex(2)
	self.controllers.c3:setSelectedIndex(0)
	self.fields.Text_name:setColor("#FFFBD5")
	local activity_9001676_Read = include("activity_9001676_Read")
	local cfg = activity_9001676_Read.getAIPlayers()
	local _ENV, action = "#FFFBD5", "#FFFBD5"
	for i = 1, 10 do
		table.insert(action, ffa.callFunc(function()
			local rIndex = math.random(1, #cfg)
			self.fields.Com_head:setImage(cfg[rIndex].head)
			self.fields.Text_name:setString(i18n(cfg[rIndex].name))
		end))
		table.insert(action, ffa.delay(0.5))
	end
	self:runAction(ffa.seq(action))
end
function Com_gameHead:showMsgPop(content, uid)
	if self.data.uid == uid then
		self.fields.Lab_msg:setVisible(true)
		self.fields.Lab_msg:setTitle(content)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(3)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.Lab_msg:setVisible(false)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.Lab_msg:setVisible(false)
		end)
		self.fields.Lab_msg:runAction(ffa.seq(nil))
	end
end
function Com_gameHead:initItems(items)

local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_mainUI = fgui.extension_class(fgui.GComponent, baseComponent)
local constantRead = include("constantRead")
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001676_Read = include("activity_9001676_Read")
fgui.register_extension("ui://Activity_9001676/Com_9001676_mainUI", Com_9001676_mainUI)
_ENV = fgui.register_extension
fgui.register_extension.SINGLE_ONE = 1
fgui.register_extension.SINGLE_FIVE = 5
fgui.register_extension.MATCH = 2
local fgui.register_extension.ROOM, PLAY_MODE = 3, fgui.register_extension
function Com_9001676_mainUI:onInit()
	self:fixChildrenPos()
	self.itemID = constantRead.getConstValue("KOREAN_CHESS_TICKET", 874501)
	self.rewardFactor = constantRead.getConstValue("KOREAN_CHESS_REWARD_FACTOR", 5)
	self.fields.Button_friend:setTitle(i18n("krone_text_05"))
	self.fields.Button_friend:addClickEventListener(handler(self, self.onClickFriend))
	self.fields.Button_battle:setTitle(i18n("krone_text_06"))
	self.fields.Button_battle:addClickEventListener(handler(self, self.onClickBattle))
	self.fields.Button_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickEventListener(handler(self, self.onClickReward))
	local itemName = publicRead.getName(self.itemID)
	constantRead = handler(self, self.onClickReward)
	handler(self, self.onClickReward).name = itemName
	handler(self, self.onClickReward).num = 1
	fguiHelper.get_fields(self.fields.Button_one).txt_cost:setString(i18n("disassemble_fast_14", handler(self, self.onClickReward)))
	self.fields.Button_one:setTitle(i18n("krone_text_03"))
	self.fields.Button_one:addClickEventListener(handler(self, self.onClickGameStart), 1)
	constantRead = self.onClickGameStart
	self.onClickGameStart.name = itemName
	self.onClickGameStart.num = self.rewardFactor
	fguiHelper.get_fields(self.fields.Button_multi).txt_cost:setString(i18n("disassemble_fast_14", self.onClickGameStart))
	self.fields.Button_multi:setTitle(i18n("krone_text_04"))
	self.fields.Button_multi:addClickEventListener(handler(self, self.onClickGameStart), self.rewardFactor)
	self.fields.Com_9001676_EnterGame:setGameEndCallback(handler(self, self.onGameEndCallback))
	self.fields.Com_have:initData(self.itemID, handler(self, self.onAddClick))
	self.fields.Button_rank:setTitle(i18n("common_text_851"))
	self.fields.Button_rank:addClickEventListener(handler(self, self.onClickRank))
end
function Com_9001676_mainUI:onAddClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001676_ItemGet")
end
function Com_9001676_mainUI:onShow()
end
function Com_9001676_mainUI:onHide()
	self:clearRoom()
end
function Com_9001676_mainUI:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001676_UPDATE", handler(self, self.onUpdateData))
end
function Com_9001676_mainUI:updateView()
	self.haveNum = self.fields.Com_have:updateNum()
end
function Com_9001676_mainUI:onUpdateData(target, data)
	if data.msgType == "Single" then
		self:playStartAni(data.betCount ~= self.rewardFactor and PLAY_MODE.SINGLE_ONE or PLAY_MODE.SINGLE_FIVE)
	elseif data.msgType == "RoomMode" then
		self:playStartAni(PLAY_MODE.ROOM)
	elseif data.msgType == "Match" then
		self:playStartAni(PLAY_MODE.MATCH)
	end
end
function Com_9001676_mainUI:updateRedDot()
	local redNum = 0
	local freeRewardNum = activity_9001676_Ctrl:getIsGetFreeReward() and 0 or 1
	self.fields.Com_have:setReddot(0 < freeRewardNum)
	return redNum
end
function Com_9001676_mainUI:onClickFriend(sender)
	SoraDPlaySound()
	local lastRoomModeTime = activity_9001676_Ctrl:getLastRoomModeTime()
	if lastRoomModeTime and 0 < lastRoomModeTime then
		local time = serviceFunctions.systemTime() - lastRoomModeTime
		if time < activity_9001676_Read.getRoomModeCD() then
			SoraDShowMsgTip(i18n("krone_text_41"))
			return
		end
	end
	_ENV = i18n("krone_text_41")
	i18n("krone_text_41").content = i18n("Korean_chess_optimization_03")
	i18n("krone_text_41").confirmString = i18n("common_text_204")
	i18n("krone_text_41").cancelString = i18n("common_text_185")
	i18n("krone_text_41").confirmFunc = function()
		uiManager:show("Activity_9001676_Share")
	end
	uiManager:show("MessageBox", i18n("krone_text_41"))
end
function Com_9001676_mainUI:onClickBattle(sender)
	SoraDPlaySound()
	local lastMatchModeTime = activity_9001676_Ctrl:getLastMatchModeTime()
	if lastMatchModeTime and 0 < lastMatchModeTime then
		local time = serviceFunctions.systemTime() - lastMatchModeTime
		if time < activity_9001676_Read.getMatchModeCD() then
			SoraDShowMsgTip(i18n("krone_text_52"))
			return
		end
	end
	_ENV = i18n("krone_text_52")
	i18n("krone_text_52").content = i18n("Korean_chess_optimization_03")
	i18n("krone_text_52").confirmString = i18n("common_text_204")
	i18n("krone_text_52").cancelString = i18n("common_text_185")
	i18n("krone_text_52").confirmFunc = function()
		activity_9001676_Ctrl:reqKoreanChessMatch()
	end
	uiManager:show("MessageBox", i18n("krone_text_52"))
end
function Com_9001676_mainUI:onClickReward(sender)
	SoraDPlaySound()
	uiManager:show("Activity_9001676_Reward")
end
function Com_9001676_mainUI:onClickRank(sender)
	SoraDPlaySound()
	uiManager:show("Activity_9001676_Rank")
end
function Com_9001676_mainUI:onClickGameStart(sender, times)
	SoraDPlaySound()
	if times > self.haveNum then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	if SoraDIsGameGuide() then
		activity_9001676_Ctrl:reqKoreanChessSingle(times)
	else
		_ENV = i18n("common_text_1806", nil)
		_ENV = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil).num = times
		i18n("common_text_1806", nil).content = i18n("Korean_chess_optimization_04", i18n("common_text_1806", nil))
		i18n("common_text_1806", nil).confirmString = i18n("common_text_204")
		i18n("common_text_1806", nil).cancelString = i18n("common_text_185")
		i18n("common_text_1806", nil).confirmFunc = function()
			activity_9001676_Ctrl:reqKoreanChessSingle(times)
		end
		uiManager:show("MessageBox", i18n("common_text_1806", nil))
	end
end
function Com_9001676_mainUI:playStartAni(playMode)
	self.fields.Usm_1:clearEffect()
	SoraDShowLoading(self, nil, nil, true)
	self.playingStartMode = playMode
	self.fields.Usm_1:setVisible(true)
	self.fields.Usm_1:setEffectPath("kelangqijinchangdonghua.usm", false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.playingStartMode = nil
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setVisible(false)
		SoraDCloseLoading(self)
		self.fields.bg:setURL("klqdh_zuihouzhen.png")
		self.fields.Com_9001676_EnterGame:startMatch(playMode)
		self.controllers.c1:setSelectedIndex(1)
	end)
	self.transitions.t1:play(1, 0, 0, -1)
	if self.gameStartCallback then
		self.gameStartCallback(playMode)
	end
end
function Com_9001676_mainUI:setGameStartCallback(callback)
	self.gameStartCallback = callback
end
function Com_9001676_mainUI:setGameEndCallback(callback)
	self.gameEndCallback = callback
end
function Com_9001676_mainUI:onGameEndCallback()
	self.fields.bg:setURL("klqdh_diyizhen.png")
	self.controllers.c1:setSelectedIndex(0)
	self.transitions.t1:play(1, 0, 0, 0)
	if self.gameEndCallback then
		self.gameEndCallback()
	end
end
function Com_9001676_mainUI:dealClose()
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setVisible(false)
	SoraDCloseLoading(self)
	self:clearRoom()
	self.fields.Com_9001676_EnterGame:dealClose()
end
function Com_9001676_mainUI:clearRoom()
	if self.playingStartMode ~= nil then
		if self.playingStartMode == PLAY_MODE.MATCH then
			activity_9001676_Ctrl:reqKoreanChessMatchCancel()
		else
			activity_9001676_Ctrl:reqKoreanChessRoomQuit()
		end
		self.playingStartMode = nil
	end
end
return Com_9001676_mainUI

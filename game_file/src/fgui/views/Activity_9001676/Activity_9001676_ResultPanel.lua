local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_ResultPanel = class("Activity_9001676_ResultPanel", baseFguiPanel)
local constantRead = include("constantRead")
_ENV = "constantRead"
;("constantRead").SINGLE_ONE = 1
;("constantRead").SINGLE_FIVE = 5
;("constantRead").MATCH = 2
local _ENV, ("constantRead").ROOM, PLAY_MODE = nil, 3, "constantRead"
;(nil).WHITE = 0
;(nil).BLACK = 1
;(nil).RED = 2
;(nil).STRIKER = 3
local (nil).BOARD, COIN_TAG = 4, nil
function Activity_9001676_ResultPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_ResultPanel.super.ctor(self, ...)
	print("Activity_9001676_ResultPanel:ctor", self.viewName)
end
function Activity_9001676_ResultPanel:onInit()
	print("=======Activity_9001676_ResultPanel:onInit")
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardFactor = constantRead.getConstValueArray("KOREAN_CHESS_REWARD_FACTOR", 5)
	self.fields.Label_title:setTitle(i18n("feast_the_world_text_14"))
	self.fields.button_close:setTitle(i18n("common_text_1146"))
	self.fields.button_close:addClickEventListener(handler(self, self.onClickClose))
end
function Activity_9001676_ResultPanel:endShow()
	print("=======Activity_9001676_ResultPanel:endShow")
	local isWin = self.param.isWin
	self.rewards = self.param.reward
	self.playMode = self.param.playMode
	if not self.param.msgData then
		_ENV = self.param.msgData
	end
	self.msgData = self.param.msgData
	if not self.param.hitResult then
		_ENV = self.param.hitResult
		self.param.hitResult[0] = 0
		self.param.hitResult[1] = 0
	end
	self.htiResult = self.param.hitResult
	self.myColor = self.param.myColor
	self.controllers.c2:setSelectedIndex(self.rewards == nil or #self.rewards == 0 and 0 or 1)
	if self.rewards == nil or #self.rewards == 0 then
		self.controllers.c2:setSelectedIndex(0)
		self.fields.button_close:setTitle(i18n("common_text_204"))
	else
		self.fields.button_close:setTitle(i18n("common_text_1146"))
		self.controllers.c2:setSelectedIndex(1)
		self.fields.List_reward:setNumItems(#self.rewards)
	end
	if isWin then
		self:playSuccessAni()
	else
		self:playFailAni()
	end
	local redCoinCount = isWin and 1 or 0
	if not self.msgData.gameOver then
		redCoinCount = 0
	end
	if isWin and self.msgData.oneShotClear then
		self.controllers.c3:setSelectedIndex(1)
		self.fields.text_onShotTitle:setString(i18n("krone_text_24"))
		self.fields.text_onShotDes:setString(i18n("krone_text_25"))
		return
	end
	self.controllers.c3:setSelectedIndex(0)
	local _ENV, coinCount = self.myColor, self.myColor == nil and 0 or 9 - self.htiResult.coinCount[self.myColor]
	self.myColor.num1 = coinCount
	local self.myColor.num2, i18nParam = redCoinCount, self.myColor
	local color = self.myColor or COIN_TAG.WHITE
	local str1 = color == COIN_TAG.WHITE and i18n("krone_text_22", i18nParam) or i18n("krone_text_21", i18nParam)
	if self.playMode == PLAY_MODE.SINGLE_ONE or self.playMode == PLAY_MODE.SINGLE_FIVE then
		local sacle = self.playMode == PLAY_MODE.SINGLE_ONE and 1 or self.rewardFactor
		_ENV = i18n("krone_text_25")
		i18n("krone_text_25").num1 = coinCount * sacle
		i18n("krone_text_25").num2 = redCoinCount * sacle
		local str2 = i18n("krone_text_23", i18n("krone_text_25"))
		local resultStr = string.format([[
%s
%s]], str1, str2)
		self.fields.text_desc:setString(resultStr)
	else
		self.fields.text_desc:setString(str1)
	end
end
function Activity_9001676_ResultPanel:playFailAni()
	SoraDPlaySound("innerbuildsound", 106)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Usm_lose:setVisible(true)
	self.fields.Image_lose:setVisible(true)
end
function Activity_9001676_ResultPanel:playSuccessAni()
	SoraDPlaySound("innerbuildsound", 106)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Usm_victory:setVisible(true)
	self.fields.Image_victory:setVisible(true)
end
function Activity_9001676_ResultPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return Activity_9001676_ResultPanel

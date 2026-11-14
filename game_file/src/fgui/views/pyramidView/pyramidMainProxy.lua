local baseProxy = require("fgui.base.baseProxy")
local pyramidMainProxy = class("pyramidMainProxy", baseProxy)
function pyramidMainProxy:onRegisterEvent()
	print("=======pyramidMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_UPDATE_COPPER", handler(self, self.msgUpdateCopper))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD", handler(self, self.msgShowReward))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_UPDATE_BTNS_AND_COPPER", handler(self, self.msgUpdateBtnsAndCopper))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_SET_PYRAMID_MASK", handler(self, self.msgSetPyramidMask))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_SHOW_LOADING", handler(self, self.msgShowLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_REFRESH_ITEMS_SUCCESS", handler(self, self.sMsgUpdateItemSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_DICE_SUCCESS", handler(self, self.sMsgDiceSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL", handler(self, self.sMsgBackPackIsFull))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_ONEKEY_THROW_BACK", handler(self, self.sMsgOnekeyThrow))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_INIT_DATA_BACK", handler(self, self.sMsgInitDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_UPDATE_LIMIT", handler(self, self.sMsgCheckLimit))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_RESET_SCORE", handler(self, self.msgResetScore))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.sMsgInitDataBack))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_SCORE_TO", handler(self, self.msgScoreTo))
end
function pyramidMainProxy:msgUpdateCopper()
	self.view:updateCopperNum()
end
function pyramidMainProxy:msgShowReward()
	self.view:updateState()
end
function pyramidMainProxy:msgUpdateBtnsAndCopper()
	self.view:updateCopperNum()
	self.view:updateBottom()
end
function pyramidMainProxy:msgSetPyramidMask(target, data)
	self.view:setPyramidMask(data.isMask)
end
function pyramidMainProxy:msgShowLoading(target, data)
	local isShow = data.isShow
	if isShow then
		SoraDShowLoading(self.view:displayObject())
	else
		SoraDCloseLoading(self.view:displayObject())
	end
end
function pyramidMainProxy:sMsgUpdateItemSuccess()
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateItem(true)
	self.view:updateCopperNum()
	self.view:updateBottom()
end
function pyramidMainProxy:sMsgDiceSuccess()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_PYRAMID_DICE_TO"
	SoraDSendMessage(nil)
	self.view:updateCopperNum()
	self.view:updateBottom()
end
function pyramidMainProxy:sMsgBackPackIsFull(target, data)
	SoraDShowMsgTip(i18n("notice_0119"))
	_ENV = i18n("notice_0119")
	i18n("notice_0119").msg = "MESSAGE_UI_PYRAMID_CLOSE_REWARD_VIEW"
	SoraDSendMessage(i18n("notice_0119"))
	self.view:close()
end
function pyramidMainProxy:sMsgOnekeyThrow(target, data)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateCopperNum()
	self.view:updateBottom()
	self.view:updateScore(true, true)
	self.view:resetScore()
end
function pyramidMainProxy:sMsgInitDataBack(target, data)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateItem(true)
	self.view:updateState()
	self.view:updatePrice()
	self.view:updateCopperNum()
	self.view:updateBottom()
	self.view:setScore()
end
function pyramidMainProxy:sMsgCheckLimit(target, data)
	self.view:checkMoreThanLimit()
end
function pyramidMainProxy:msgResetScore(target, data)
	self.view:resetScore()
end
function pyramidMainProxy:msgScoreTo(target, data)
	SoraDPlaySound("pyramid", 1)
	self.view:updateScore(false, false)
end
return pyramidMainProxy

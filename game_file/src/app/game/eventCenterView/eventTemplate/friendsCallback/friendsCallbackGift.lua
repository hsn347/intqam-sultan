local friendsCallbackGift = class("friendsCallbackGift", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("friendsCallbackGift")
	end
	return target
end)
local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
function friendsCallbackGift:ctor()
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
end
function friendsCallbackGift:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_RETURN_GIFT", function(target, data)
		SoraDCloseLoading(self)
		self = nil
		;(nil)[1] = cca.fadeOut(0.16666666666666666)
		;(nil)[2] = cca.callFunc(function()
			SoraDRemoveAllPanelFromManager()
			SoraDCreatePanel("friendsCallbackReceive"):show()
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDRemoveAllPanelFromManager()
			SoraDCreatePanel("friendsCallbackReceive"):show()
		end)
		self.scaleActTarget:runAction(cca.seq(nil))
	end)
end
function friendsCallbackGift:initWidget()
	SoraDCreatAnimation(self.__cname, self, true)
	SoraDGetAllChildFromWidget(self, self)
	SoraDMixtureGLONEByParent(self.Node_effect)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Particle_1:setAutoCull(false)
	self.Node_cells = SoraDGetChildsArrayByName(self.Node_gift, "Node_cell_", 3, 1)
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveClick))
	_UPVALUE3_ = handler(self, self.btnReceiveClick)
	handler(self, self.btnReceiveClick)[1] = "ar"
	handler(self, self.btnReceiveClick)[2] = "en"
	handler(self, self.btnReceiveClick)[3] = "ko"
	self.Sprite_title:setSpriteFrame(SoraDGetImageNameByLang("frame_hyzh_ysz_%s.png", handler(self, self.btnReceiveClick)))
	_UPVALUE3_ = self.Sprite_title.setSpriteFrame
	self.Sprite_title.setSpriteFrame[1] = "returnnew_text_004"
	self.Sprite_title.setSpriteFrame[2] = "returnnew_text_005"
	local self.Sprite_title.setSpriteFrame[3], nameTab = "returnnew_text_006", self.Sprite_title.setSpriteFrame
	local rewards = friendsCallbackRead.returnBackGiftConfig
	for i, cell in ipairs(self.Node_cells) do
		SoraDGetChildByName(cell, "Text_1"):setString(i18n(nameTab[i]))
		local Node_items = SoraDGetChildByName(cell, "Node_items")
		for k, v in ipairs(rewards[i]) do
			local item = SoraDCreatePanel("commonItemAward")
			item:setScale(0.9)
			item:setPosition(0, -100 * (k - 1))
			item:setOwnView(self)
			item:addTo(Node_items)
			item:initData(v.id, v.count)
		end
		local offsety = (#rewards[i] - 1) / 2 * 100
		Node_items:setPositionY(Node_items:getPositionY() + offsety)
	end
end
function friendsCallbackGift:btnReceiveClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		honorBackCtrl:reqHonorNewReturnGift()
	end
end
return friendsCallbackGift

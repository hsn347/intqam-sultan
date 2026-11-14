local friendsCallbackReceive = class("friendsCallbackReceive", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("friendsCallbackReceive")
	end
	return target
end)
local friendsCallbackRead = include("friendsCallbackRead")
function friendsCallbackReceive:ctor()
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
end
function friendsCallbackReceive:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Text_title:setString(i18n("Lucky_treasure_text_05"))
	self.Text_des:setString(i18n("returnnew_text_010"))
	self.Button_go:setTitleText(i18n("returnnew_text_011"))
	SoraDAutoSizeButtonText(self.Button_go)
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	self.itemList = SoraDGetChildsArrayByName(self, "CCS_commonItemAward_item", 5, 1, nil, true)
	local rewards = friendsCallbackRead.returnBackGiftConfig
	local index = 1
	for i, v in ipairs(rewards) do
		for m, n in ipairs(v) do
			local item = self.itemList[index]
			if item then
				index = index + 1
				item:setOwnView(self)
				item:initData(n.id, n.count)
			end
		end
	end
	SoraDCreatAnimationEx(self.__cname, self, false)
	self.action:gotoFrameAndPlay(38, false)
	SoraDMixtureGLONEByParent(self.scaleActTarget)
end
function friendsCallbackReceive:btnGoClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local panel = SoraDCreatePanel("honorBackView")
		panel:jumpToModel(gHonorBackType.LoginGift)
		panel:show()
	end
end
return friendsCallbackReceive

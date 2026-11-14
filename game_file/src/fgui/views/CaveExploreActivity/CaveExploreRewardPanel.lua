local baseFguiPanel = require("fgui.base.baseFguiPanel")
local caveExploreCtrl = SoraDGetCtrl("caveExploreCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local CaveExploreRewardPanel = class("CaveExploreRewardPanel", baseFguiPanel)
function CaveExploreRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CaveExploreRewardPanel:ctor", self.viewName)
end
function CaveExploreRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CaveExploreActivity"
	end
	return self._packageList
end
function CaveExploreRewardPanel:onInit()
	self.itemID = 841701
	self.giftID = 14480
	print("=======CaveExploreRewardPanel:onInit")
	local rewardDatas = self.proxy.param.rewards
	self.rewards, _ENV = "=======CaveExploreRewardPanel:onInit", "=======CaveExploreRewardPanel:onInit"
	for k, v in pairs(rewardDatas) do
		for k2, v2 in pairs(v) do
			v2.round = k
			table.insert(self.rewards, v2)
		end
	end
	self.fields.txt_title:setString(i18n("Mermaid_title_10"))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	_ENV = handler(self, self.onNormalItemRenderer)
	handler(self, self.onNormalItemRenderer).num = 10
	self.fields.Button_ten:setTitle(i18n("Canyon_Treasur_text_15", handler(self, self.onNormalItemRenderer)))
	self.fields.Button_ten:setCost(self.itemID, 10, true)
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.Button_ten:addClickEventListener(handler(self, self.onTakeClick), 10)
end
function CaveExploreRewardPanel:onShow()
	SoraDPlaySound("sixYear", "ui_award")
	print("=======CaveExploreRewardPanel:onShow")
	self.fields.scroll:setNumItems(#self.rewards)
end
function CaveExploreRewardPanel:onHide()
	print("=======CaveExploreRewardPanel:onHide")
	_ENV = "=======CaveExploreRewardPanel:onHide"
	;("=======CaveExploreRewardPanel:onHide").msg = "MESSAGE_CAVE_EXPLORE_REWARD_CLOSE"
	SoraDSendMessage("=======CaveExploreRewardPanel:onHide")
end
function CaveExploreRewardPanel:onDispose()
	print("=======CaveExploreRewardPanel:onDispose")
end
function CaveExploreRewardPanel:onTakeClick(sender, params)
	if not self.isCanCloseSelf then
		return
	end
	SoraDPlaySound()
	local isFree = caveExploreCtrl:getIsFree()
	if not isFree and params > self.itemNum or params == 10 and params > self.itemNum then
		_ENV = nil
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		;(nil).content = i18n("cave_explore_05", nil)
		;(nil).confirmFunc = function()
			self:onAddClick()
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
		return
	end
	caveExploreCtrl:reqCaveExlore(params == 10)
	self:close()
end
function CaveExploreRewardPanel:onAddClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = self.giftID
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:show()
		panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, self.giftID)
	end
end
function CaveExploreRewardPanel:onNormalItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	obj:initData(reward, index)
end
function CaveExploreRewardPanel:doShowAnimation()
	self.view:setScale(0.5)
	self.isCanCloseSelf = false
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1)
	;(nil)[2] = ffa.callFunc(function()
		self.isCanCloseSelf = true
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isCanCloseSelf = true
	end)
	self.view:runAction(ffa.seq(nil))
end
return CaveExploreRewardPanel

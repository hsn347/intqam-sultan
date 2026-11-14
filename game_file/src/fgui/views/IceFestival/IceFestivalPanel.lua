local cumulativeRecharge2021Read = include("cumulativeRecharge2021Read")
local iceCumuRechargeCtrl = SoraDGetCtrl("iceCumuRechargeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceFestivalPanel = class("IceFestivalPanel", baseFguiPanel)
function IceFestivalPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceFestivalPanel:ctor", self.viewName)
end
function IceFestivalPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceFestivalPanel:onInit()
	print("=======IceFestivalPanel:onInit")
	self.activityID = gActivityTimeActivityID.CUMU_RECHARGE_2023
	self.fields.Com_title:initData(i18n("activity_name_9001483"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.lockIcon:addClickEventListener(handler(self, self.onClickLock))
	self.fields.movie_Lock:setAllFrameName("dh_bxjlc_add_kjs_%02d.png", 1)
	self.fields.movie_unLock:setAllFrameName("dh_bxjlc_add_js_%02d.png", 1)
end
function IceFestivalPanel:onShow()
	print("=======IceFestivalPanel:onShow")
	iceCumuRechargeCtrl:sendReqInitDataMsg()
	self:updateCumuReward()
end
function IceFestivalPanel:updateView()
	self.taskList = iceCumuRechargeCtrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
	if iceCumuRechargeCtrl:getCurDay() >= self.cumuRewardConfig.days and not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index) and not self.fields.movie_Lock:isVisible() then
		self.fields.movie_Lock:setVisible(true)
		self.fields.movie_Lock:setPlaySettings(0, -1, -1)
	end
end
function IceFestivalPanel:updateCumuReward()
	self.cumuRewardConfig = cumulativeRecharge2021Read.getIceRechargeCumu()
	self.fields.lockIcon:setVisible(not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index))
	_ENV = not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index)
	;(not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index))[1] = "id"
	;(not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index))[2] = "count"
	local reward = serviceFunctions.tableFormat(self.cumuRewardConfig.reward, not iceCumuRechargeCtrl:isRewardClaim(self.cumuRewardConfig.Index))
	dump(reward, "reward")
	local num = table.nums(reward)
	local angleOffset = 360 / num
	local length = 180
	local oriAngle = -90
	local centerPos = self.fields.lockIcon:getPosition()
	for i = 1, math.min(num, 5) do
		local item = fgui.UIPackage:createObjectFromURL("ui://IceFestival/Com_item_ice2")
		item:addTo(self.view)
		item:setPosition(cc.p(centerPos.x + length * math.cos(math.rad(oriAngle)), centerPos.y + length * math.sin(math.rad(oriAngle))))
		oriAngle = oriAngle + angleOffset
		item:initData(reward[i].id, reward[i].count)
	end
	cumulativeRecharge2021Read = fgui.UIPackage:createObjectFromURL("ui://IceFestival/Com_item_ice2")
	fgui.UIPackage:createObjectFromURL("ui://IceFestival/Com_item_ice2").num = self.cumuRewardConfig.days
	self.fields.Text_Tips:setString(i18n("Loudlydressed_text_12", (fgui.UIPackage:createObjectFromURL("ui://IceFestival/Com_item_ice2"))))
end
function IceFestivalPanel:unLockBack(index, reward)
	if index and tonumber(index) == tonumber(self.cumuRewardConfig.Index) then
		self.fields.movie_Lock:setVisible(false)
		self.fields.movie_unLock:setVisible(true)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.lockIcon:setVisible(false)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.lockIcon:setVisible(false)
		end)
		self:runAction(ffa.seq(nil))
		self.fields.movie_unLock:setPlaySettings(0, 12, 1, -1, function()
			SoraDMailGainItems(reward, true)
		end)
	elseif reward then
		SoraDMailGainItems(reward, true)
	end
end
function IceFestivalPanel:onItemRederer(index, target)
	target:initData(self.taskList[index + 1])
end
function IceFestivalPanel:onClickLock()
	if iceCumuRechargeCtrl:getCurDay() >= self.cumuRewardConfig.days then
		SoraDShowLoading()
		iceCumuRechargeCtrl:reqCumuRecharge2023Claim(self.cumuRewardConfig.type, self.cumuRewardConfig.Index)
	end
end
return IceFestivalPanel

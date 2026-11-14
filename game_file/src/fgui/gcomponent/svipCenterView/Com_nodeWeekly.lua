local baseComponent = require("fgui.base.baseComponent")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local exclusiveVipRead = include("exclusiveVipRead")
local Com_nodeWeekly = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://svipCenterView/Com_nodeWeekly", Com_nodeWeekly)
function Com_nodeWeekly:onInit()
	self.txtWeeklyReward = self.fields.txtWeeklyReward
	self.txtWeeklyMax = self.fields.txtWeeklyMax
	self.nodeWeeklyUp = self.fields.nodeWeeklyUp
	self.txtWeeklyIns = self.fields.txtWeeklyIns
	self.scrollWeeklyUp = self.fields.scrollWeeklyUp
	self.txtWeeklyNeed = self.fields.txtWeeklyNeed
	self.nodeWeeklyDown = self.fields.nodeWeeklyDown
	self.scrollWeeklyDown = self.fields.scrollWeeklyDown
	self.com_TabW = self.fields.com_TabW
	self.txtWeeklyIns:setString(i18n("privilege_text_22"))
end
function Com_nodeWeekly:onShow()
end
function Com_nodeWeekly:initData()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local weekRecharge = exaltedPrivilegeCtrl:getWeekRechargeGold()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	print("totalRecharge====", totalRecharge)
	self.weekRechargeCfg = exclusiveVipRead:getWeekRechargeRewardCfg(totalRecharge)
	self.nextCfg = exclusiveVipRead:getWeekRechargeReward(totalRecharge)
	local tag = #self.weekRechargeCfg
	local isFind = false
	local premiumStoreCtrl, tabsetArray = totalRecharge, totalRecharge
	for k, v in ipairs(self.weekRechargeCfg) do
		premiumStoreCtrl = nil
		premiumStoreCtrl = nil
		;(nil).var = paymentManager.returnCurrencyByChannel() .. v.weekprice
		;(nil).title = i18n("cavalryrise_text_13", nil)
		;(nil).tag = k
		table.insert(tabsetArray, nil)
		if weekRecharge < v.weekprice and not isFind then
			tag = k
			isFind = true
		end
	end
	premiumStoreCtrl = ipairs(self.weekRechargeCfg)
	ipairs(self.weekRechargeCfg).defaultClick = tag
	ipairs(self.weekRechargeCfg).tabsetArray = tabsetArray
	ipairs(self.weekRechargeCfg).callback = handler(self, self.clickOAPTab)
	self.com_TabW:initView(ipairs(self.weekRechargeCfg))
	weekRecharge = math.min(weekRecharge, self.weekRechargeCfg[#self.weekRechargeCfg].weekprice)
	local weekNeedRechargeGold = self.weekRechargeCfg[tag].weekprice
	premiumStoreCtrl = self.clickOAPTab
	self.clickOAPTab.price = paymentManager.returnCurrencyByChannel() .. weekRecharge
	self.clickOAPTab.value = paymentManager.returnCurrencyByChannel() .. weekNeedRechargeGold
	self.txtWeeklyReward:setString(i18n("privilege_text_20", self.clickOAPTab))
	if next(self.nextCfg) then
		local nextHistoryPrice = self.nextCfg[1].historyprice
		local needRechargeWeekly = nextHistoryPrice - totalRecharge
		premiumStoreCtrl = i18n("privilege_text_20", self.clickOAPTab)
		i18n("privilege_text_20", self.clickOAPTab).value = paymentManager.returnCurrencyByChannel() .. needRechargeWeekly
		self.txtWeeklyNeed:setString(i18n("privilege_text_23", i18n("privilege_text_20", self.clickOAPTab)))
		self.nodeWeeklyDown:setVisible(true)
	else
		self.nodeWeeklyDown:setVisible(false)
	end
	self.nodeWeeklyUp:setVisible(true)
end
function Com_nodeWeekly:clickOAPTab(tag)
	self:setWeeklyReward(self.weekRechargeCfg[tag].award)
	if next(self.nextCfg) then
		self:setWeeklyNextReward(self.nextCfg[tag].award)
	end
end
function Com_nodeWeekly:setWeeklyReward(rewardList)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local _rewardList = serviceFunctions.tableFormat(rewardList, nil)
	self.scrollWeeklyUp:setItemRenderer(function(index, obj)
		local data = _rewardList[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.scrollWeeklyUp:setNumItems(#_rewardList)
end
function Com_nodeWeekly:setWeeklyNextReward(rewardList)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	rewardList = serviceFunctions.tableFormat(rewardList, nil)
	self.scrollWeeklyDown:setItemRenderer(function(index, obj)
		local data = rewardList[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.scrollWeeklyDown:setNumItems(#rewardList)
end
return Com_nodeWeekly

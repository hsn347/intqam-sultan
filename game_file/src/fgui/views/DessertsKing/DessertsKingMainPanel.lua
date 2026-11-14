local publicRead = include("publicRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local publicUtil = include("publicUtil")
local lordOfDessertRead = include("lordOfDessertRead")
local lordOfDessertCtrl = SoraDGetCtrl("lordOfDessertCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertsKingMainPanel = class("DessertsKingMainPanel", baseFguiPanel)
function DessertsKingMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DessertsKingMainPanel:ctor", self.viewName)
end
function DessertsKingMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertsKingMainPanel:onInit()
	print("=======DessertsKingMainPanel:onInit")
	self.curScore = lordOfDessertCtrl:getScore()
	_UPVALUE6_ = lordOfDessertCtrl
	lordOfDessertCtrl[1] = "Progress_Bar"
	lordOfDessertCtrl[2] = "Button_Box"
	lordOfDessertCtrl[3] = "Button_GoldCost"
	lordOfDessertCtrl[4] = "Button_ItemCost"
	lordOfDessertCtrl[5] = "Label_Item"
	lordOfDessertCtrl[6] = "Label_Extra"
	for i, v in ipairs(lordOfDessertCtrl) do
		self.fields[v]:fixPos()
	end
	self.fields.Label_Item:fixChildrenPos()
	self.fields.Label_Extra:fixChildrenPos()
	self.activityID = gActivityTimeActivityID.LORD_OF_DESSERT_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001538"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Rank:addClickListener(handler(self, self.onClickRank))
	self.fields.Button_GoldCost:addClickListener(handler(self, self.onClickGoldCost))
	self.fields.Button_ItemCost:addClickListener(handler(self, self.onClickItemCost))
	self.fields.Button_Box:addClickListener(handler(self, self.onClickAwardBox))
	self.maxPoint = lordOfDessertRead.getNeedIntegral(lordOfDessertCtrl:getActivityGroup())
	self.maxBoxNum = lordOfDessertRead.getBoxMax(lordOfDessertCtrl:getActivityGroup())
	self.item1 = lordOfDessertRead.getNeedItemByIndex(1)
	self.item2 = lordOfDessertRead.getNeedItemByIndex(2)
	self.fields.Progress_Bar:setMax(self.maxPoint)
	self.fields.Progress_Bar:setValue(0)
	self.fields.Progress_Bar:getChild("n7"):setAllFrameName("dh_tianpinzwjdt_%.2d.png", 0)
	self.fields.Progress_Bar:getChild("n7"):setPlaySettings(0, -1, 1)
	self.fields.Progress_Bar:fixChildrenPos()
	self.fields.Label_Item:setString(i18n("pet_text_08"))
	self.fields.Label_Extra:setString(i18n("pet_text_08"))
	self.fields.Button_Rank:setString(i18n("pyramid_btn_29"))
	self.fields.Button_ItemCost:setString(i18n("common_text_284"))
	self.fields.Button_GoldCost:setString(i18n("common_text_284"))
	self.fields.Button_GoldCost:setCost(self.item2[1], self.item2[2])
	self.fields.Button_ItemCost:setCost(self.item1[1], self.item1[2])
	local itemGet1 = lordOfDessertRead.getGetItemByIndex(1)
	local itemGet2 = lordOfDessertRead.getGetItemByIndex(2)
	self.fields.Label_Item:setIcon(publicRead.getIcon(itemGet1[1]))
	self.fields.Label_Extra:setIcon(publicRead.getIcon(itemGet2[1]))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function DessertsKingMainPanel:onItemRenderer(index, object)
	object:initData(self.rankAward[index + 1].id, self.rankAward[index + 1].count)
end
function DessertsKingMainPanel:updateRankAward()
	self.rankAward = lordOfDessertRead.getRewardFront2ByIndex(lordOfDessertCtrl:getActivityGroup(), lordOfDessertCtrl:getPlayerRank())
	if self.rankAward and next(self.rankAward) then
		if not self.rankAward then
			lordOfDessertRead = self.rankAward
		end
		self.fields.List_reward:setNumItems(table.nums(self.rankAward))
		if not self.rankAward then
			lordOfDessertRead = self.rankAward
		end
		self.fields.List_reward:resizeToFit(table.nums(self.rankAward), 50)
		self.fields.List_reward:setVisible(true)
		self.fields.n19:setVisible(true)
	else
		self.fields.List_reward:setVisible(false)
		self.fields.n19:setVisible(false)
	end
end
function DessertsKingMainPanel:onShow()
	print("=======DessertsKingMainPanel:onShow")
	lordOfDessertCtrl:sendReqInitDataMsg()
	lordOfDessertCtrl:reqLordOfDessertRank(1, 1)
	self:updateProgressBox()
	self:updateButton()
	self:updateRankAward()
end
function DessertsKingMainPanel:runEffect(data)
	self.fields.Usm_11:setVisible(true)
	self.fields.Usm_11:play()
	local str = ""
	local totalScore = 0
	local num = 0
	local _ENV, new
	for i = 1, 5 do
		new[i] = data.mulTable[tostring(i)] or 0
	end
	for i, v in ipairs(new) do
		print("DessertsKingMainProxy", i, v)
		totalScore = totalScore + tonumber(i) * v
		if i ~= 1 and v ~= 0 then
			num = num + 1
			if 2 <= num then
				str = str .. ", "
			end
			_ENV = v
			v.num = i
			v.times = v
			str = str .. i18n("Snowman_Activity_13", v)
		end
	end
	if str ~= "" then
		SoraDShowMsgTip(str)
	end
	if 1 < totalScore then
		self.fields.Text_incScore:setString("X" .. tostring(totalScore))
		self.transitions.scoreSlide:play()
	end
	SoraDMailGainItems(data.reward, true)
	self:updateProgressBox(true)
end
function DessertsKingMainPanel:updateProgressBox(showEffect)
	local lastCanGetNum = math.min(math.floor(self.curScore / self.maxPoint), self.maxBoxNum)
	self.curScore = lordOfDessertCtrl:getScore()
	local canGetNum = math.min(math.floor(self.curScore / self.maxPoint), self.maxBoxNum)
	if lastCanGetNum < canGetNum then
		self.fields.Progress_Bar:tweenValue(self.maxPoint, 0.5)
		lordOfDessertCtrl = 0.5
		;(0.5)[1] = ffa.delay(0.5)
		;(0.5)[2] = ffa.callFunc(function()
			self.fields.Progress_Bar:setValue(0)
			if canGetNum == self.maxBoxNum then
				self.fields.Progress_Bar:setValue(self.curScore - canGetNum * self.maxPoint)
				self.fields.Progress_Bar:getChild("title"):setString(i18n("common_text_2601"))
			else
				self.fields.Progress_Bar:tweenValue(self.curScore - canGetNum * self.maxPoint, 0.2)
				self.fields.Progress_Bar:getChild("n7"):setPlaySettings(0, -1, 1)
				self.fields.Progress_Bar:getChild("n7"):setVisible(true)
			end
		end)
		;(0.5)[3] = ffa.callFunc(function()
			self.fields.Progress_Bar:setValue(0)
			if canGetNum == self.maxBoxNum then
				self.fields.Progress_Bar:setValue(self.curScore - canGetNum * self.maxPoint)
				self.fields.Progress_Bar:getChild("title"):setString(i18n("common_text_2601"))
			else
				self.fields.Progress_Bar:tweenValue(self.curScore - canGetNum * self.maxPoint, 0.2)
				self.fields.Progress_Bar:getChild("n7"):setPlaySettings(0, -1, 1)
				self.fields.Progress_Bar:getChild("n7"):setVisible(true)
			end
		end)
		self:runAction(ffa.seq(0.5))
	else
		if showEffect then
			self.fields.Progress_Bar:getChild("n7"):setVisible(true)
			self.fields.Progress_Bar:getChild("n7"):setPlaySettings(0, -1, 1)
		end
		self.fields.Progress_Bar:setValue(self.curScore - canGetNum * self.maxPoint)
		if canGetNum == self.maxBoxNum then
			self.fields.Progress_Bar:getChild("title"):setString(i18n("common_text_2601"))
		end
	end
	print("canGetNum", canGetNum)
	local gotNum = lordOfDessertCtrl:getRewardCount()
	self.fields.Button_Box:setReddot(canGetNum > gotNum, canGetNum - gotNum)
	_ENV = i18n("common_text_2601")
	i18n("common_text_2601").member = gotNum
	i18n("common_text_2601").total = self.maxBoxNum
	self.fields.Button_Box:setString(i18n("common_text_155", i18n("common_text_2601")))
	self.fields.Button_Box:getController("c1"):setSelectedIndex(canGetNum > gotNum and 1 or 0)
end
function DessertsKingMainPanel:updateButton()
	self.fields.Button_GoldCost:setCost(self.item2[1], self.item2[2])
	self.fields.Button_ItemCost:setCost(self.item1[1], self.item1[2])
	local total2 = publicUtil.getCount(self.item2[1])
	local total1 = publicUtil.getCount(self.item1[1])
	self.fields.Button_GoldCost:setNumTotal(self.item2[2], total2, total2 >= self.item2[2] and "#FFFFFF" or "#F02828")
	self.fields.Button_ItemCost:setNumTotal(self.item1[2], total1, total1 >= self.item1[2] and "#FFFFFF" or "#F02828")
	self.fields.Button_GoldCost:setTitleColor(total2 >= self.item2[2] and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.fields.Button_ItemCost:setTitleColor(total1 >= self.item1[2] and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
end
function DessertsKingMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("EidalAdha_King_text_07")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function DessertsKingMainPanel:onClickRank()
	SoraDPlaySound()
	uiManager:show("DessertsKingRank")
end
function DessertsKingMainPanel:onClickGoldCost()
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	if SoraDEnoughGold(self.item2[2]) then
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").index = 2
		uiManager:show("DessertsKingShop", i18n("EidalAdha_King_text_09")):setOwnerKey(self)
	end
end
function DessertsKingMainPanel:onClickItemCost()
	SoraDPlaySound()
	if self.fields.Button_ItemCost:getController("Ctrl_status"):getSelectedIndex() == 1 then
		_ENV = nil
		;(nil).item = publicRead.getName(self.item1[1])
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
		return
	end
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	_ENV = i18n("EidalAdha_King_text_09")
	i18n("EidalAdha_King_text_09").index = 1
	uiManager:show("DessertsKingShop", i18n("EidalAdha_King_text_09")):setOwnerKey(self)
end
function DessertsKingMainPanel:onClickAwardBox()
	SoraDPlaySound()
	uiManager:show("DessertsKingGiftReward"):setOwnerKey(self)
end
return DessertsKingMainPanel

local gametop = gModuleMgr.getObject("gametop")
local knightsChargeCtrl = gametop.playertop_:getModule("knightsChargeCtrl")
local dynamicScroll = include("dynamicScroll")
local publicRead = include("publicRead")
local knightsChargePricePop = class("knightsChargePricePop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("knightsChargePricePop")
	end
	return target
end)
function knightsChargePricePop:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2194"))
	_UPVALUE3_ = self.ccs_bg.setTitleName
	self.ocxNum, self.ccs_bg.setTitleName[1] = self.ccs_bg.setTitleName, "icon_ranking_1.png"
	self.ocxNum, self.ccs_bg.setTitleName[2] = self.ccs_bg.setTitleName, "icon_ranking_2.png"
	self.ocxNum, self.ccs_bg.setTitleName[3] = self.ccs_bg.setTitleName, "icon_ranking_3.png"
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = dynamicScroll.new(self.scroll)
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.btnPersonal = SoraDGetChildByName(self, "Button_personal")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnPersonal:getChildByName("Text_name"):setString(i18n("common_text_3049"))
	self.btnAlliance:getChildByName("Text_name"):setString(i18n("common_text_3050"))
	self.btnPersonal:setPressedActionEnabled(false)
	self.btnAlliance:setPressedActionEnabled(false)
	self.btnPersonal:addTouchEventListener(handler(self, self.onBtnClick))
	self.btnAlliance:addTouchEventListener(handler(self, self.onBtnClick))
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
end
function knightsChargePricePop:initData(class)
	self.rewardList = knightsChargeCtrl.localClass.getPriceData(class)
	self:initView(class)
end
function knightsChargePricePop:initView(class)
	if not self.firstInitScroll then
		self.scroll:init(self.rewardList, handler(self, self.doSingle), cc.size(580, 100))
		self.firstInitScroll = true
	else
		self.scroll:setList(self.rewardList)
	end
	if class == 1 then
		_ENV = cc.size(580, 100)
		cc.size(580, 100).num = 100
		self.txtTip:setString(i18n("rides_text_14", cc.size(580, 100)))
	elseif class == 2 then
		_ENV = i18n("rides_text_14", cc.size(580, 100))
		i18n("rides_text_14", cc.size(580, 100)).num = 10
		self.txtTip:setString(i18n("rides_text_14", i18n("rides_text_14", cc.size(580, 100))))
	end
end
function knightsChargePricePop:doSingle(idx, info, ocx)
	ocx = ocx or self.nodeSingle:clone()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local award = serviceFunctions.tableFormat(info.reward, nil)
	local nodeItem = ocx:getChildByName("Node_item")
	local createNewItem = function(...)
		local perDis = 70
		local sPosX = -#award * perDis / 2
		for i, v in ipairs(award) do
			local item = include("commonItemAward").new()
			item:addTo(nodeItem)
			item:setName("item_child" .. i)
			item:setPosition(sPosX + (i - 1) * perDis + perDis / 2, 0)
			item:setScale(0.6)
			item:setBaseScale(1.0)
			item:setOwnView(self)
			item:initData(v.id, v.count)
		end
	end
	if nodeItem:getChildByName("item_child1") then
		local child = nodeItem:getChildren()
		if #child == #award then
			for i, v in ipairs(child) do
				v:initData(award[i].id, award[i].count)
			end
		else
			createNewItem()
		end
	else
		createNewItem()
	end
	local iconRank = ocx:getChildByName("icon_rank")
	local txtRank = ocx:getChildByName("Text_rank")
	if info.rank[1] == info.rank[2] and self.ocxNum[info.rank[1]] then
		iconRank:setVisible(true)
		iconRank:setSpriteFrame(self.ocxNum[info.rank[1]])
		txtRank:setVisible(false)
	else
		iconRank:setVisible(false)
		txtRank:setVisible(true)
		if info.rank[1] == info.rank[2] then
			txtRank:setString(info.rank[1])
		else
			txtRank:setString(info.rank[1] .. "-" .. info.rank[2])
		end
	end
	return ocx
end
function knightsChargePricePop:firstClick(class)
	if class == 1 then
		self:onBtnClick(self.btnPersonal, ccui.TouchEventType.ended)
	else
		self:onBtnClick(self.btnAlliance, ccui.TouchEventType.ended)
	end
	return self
end
function knightsChargePricePop:onBtnClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnAlliance then
			local btnName = self.btnPersonal:getChildByName("Text_name")
			btnName:setColor(cc.c3b(140, 130, 120))
			self.btnPersonal:setTouchEnabled(true)
			self.btnPersonal:setBright(true)
			self:initData(2)
		else
			local btnName = self.btnAlliance:getChildByName("Text_name")
			btnName:setColor(cc.c3b(140, 130, 120))
			self.btnAlliance:setTouchEnabled(true)
			self.btnAlliance:setBright(true)
			self:initData(1)
		end
		button:setTouchEnabled(false)
		button:setBright(false)
	end
end
return knightsChargePricePop

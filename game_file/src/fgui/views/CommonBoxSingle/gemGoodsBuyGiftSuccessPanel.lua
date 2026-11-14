local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local rechargePresentUtil = include("rechargePresentUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gemGoodsBuyGiftSuccessPanel = class("gemGoodsBuyGiftSuccessPanel", baseFguiPanel)
function gemGoodsBuyGiftSuccessPanel:ctor(...)
	self.isLRU = true
	gemGoodsBuyGiftSuccessPanel.super.ctor(self, ...)
	print("gemGoodsBuyGiftSuccessPanel:ctor", self.viewName)
end
function gemGoodsBuyGiftSuccessPanel:onInit()
	print("=======gemGoodsBuyGiftSuccessPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_receive:setTitle(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClick_Button_receive))
	self.fields.Text_title:setString(i18n("common_text_2666"))
	self.fields.Spine:setEffectPath("spine/goumailibao_renwu.skel", "animation2", true)
	self.fields.mv_1:setAllFrameName("dh_libaogoumai1_%.2d.png", 0)
	self.fields.mv_3:setAllFrameName("dh_libaogoumai3_%.2d.png", 0)
	self.fields.mv_2l:setAllFrameName("dh_libaogoumai2_%.2d.png", 1)
	self.fields.mv_2r:setAllFrameName("dh_libaogoumai2_%.2d.png", 1)
	self.fields.Text_gold:fixPos()
end
function gemGoodsBuyGiftSuccessPanel:endShow()
	print("=======gemGoodsBuyGiftSuccessPanel:endShow")
	self.itemList = self.param.itemList
	self.mailID = self.param.mailID
	self.rid = self.param.rid
	self:checkIsDetail()
	self:initView()
end
function gemGoodsBuyGiftSuccessPanel:checkIsDetail()
	self.isDetail = false
	for i, v in ipairs(self.itemList) do
		if type(v) == "table" then
			self.isDetail = true
			break
		end
	end
end
function gemGoodsBuyGiftSuccessPanel:initView()
	local gold = 0
	for i, v in ipairs(self.itemList) do
		if not self.isDetail then
			if v == gIDDef.GOLD then
				gold = self.itemList[i + 1]
				break
			end
		elseif v.id == gIDDef.GOLD then
			gold = v.count
			break
		end
	end
	if gold and 0 < gold then
		self.fields.Text_gold:setVisible(true)
		self.fields.Text_gold:setString(gold)
	else
		self.fields.Text_gold:setVisible(false)
	end
	self:initItemList()
	local nameStr = i18n("kindofwar_btn_01")
	local info = rechargeRead.getPageViewData(self.rid)
	if info and info.activeName then
		nameStr = i18n(info.activeName)
	end
	_ENV = gIDDef.GOLD
	gIDDef.GOLD.name = nameStr
	self.fields.Text_des:setString(i18n("dazzling_text_05", gIDDef.GOLD))
	local info = paymentManager.getPaymentBullets(self.rid)
	local isActive = info and info.isActive or 0
	if isActive == gBuyType.NEBULA_EMPEROR then
		self.Button_receive:setString(i18n("common_text_204"))
	end
end
function gemGoodsBuyGiftSuccessPanel:initItemList()
	local rechargePresentUtil = include("rechargePresentUtil")
	_ENV = nil
	local fixData = rechargePresentUtil.fixRechargePresentData(self.rid, nil)
	if fixData.isAdd then
		if not self.isDetail then
			table.insert(self.itemList, 1, fixData.isAdd.id)
			table.insert(self.itemList, 2, fixData.isAdd.count)
		else
			_ENV = fixData.isAdd.count
			fixData.isAdd.count.id = fixData.isAdd.id
			fixData.isAdd.count.count = fixData.isAdd.count
			table.insert(self.itemList, 1, fixData.isAdd.count)
		end
	end
	self.itemArray, _ENV = table.insert, table.insert
	local _ENV, itemids = table.insert, table.insert
	if not self.isDetail then
		_UPVALUE2_ = fixData.isAdd.count
		fixData.isAdd.count[1] = "id"
		fixData.isAdd.count[2] = "count"
		self.itemList = serviceFunctions.tableFormat(self.itemList, fixData.isAdd.count)
	end
	self.itemArray = SoraDMergeRewards(self.itemList, gIDDef.GOLD)
	self.fields.List:setNumItems(#self.itemArray)
	if #self.itemArray == 0 then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Mod_bg:getController("c1"):setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Mod_bg:getController("c1"):setSelectedIndex(0)
	end
end
function gemGoodsBuyGiftSuccessPanel:itemRenderer_List(index, obj)
	obj:fixChildrenPos()
	local data = self.itemArray[index + 1]
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Com_item"):initData(data.id)
	obj:getChild("Text_name"):setString(publicRead.getName(data.id))
	obj:getChild("Text_count"):setString("x" .. data.count)
end
function gemGoodsBuyGiftSuccessPanel:onClick_Button_receive()
	SoraDPlaySound()
	if self.mailID then
		local mailCtrl = SoraDGetCtrl("mailCtrl")
		mailCtrl:getExtraOfMail(self.mailID)
		SoraDShowMsgTip(i18n("sudanGift_text_03"))
	end
	self:close()
end
return gemGoodsBuyGiftSuccessPanel

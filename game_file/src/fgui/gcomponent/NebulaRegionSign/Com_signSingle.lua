local nebulaRegionSignCtrl = SoraDGetCtrl("nebulaRegionSignCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local signRewadRead = include("signRewadRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_signSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaRegionSign/Com_signSingle", Com_signSingle)
function Com_signSingle:onInit()
	self:fixChildrenPos()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRendererReward))
	self.fields.btn_get:addClickListener(handler(self, self.onClickGetReward))
end
function Com_signSingle:initData(index, data)
	self.day = index
	self.data = data
	self.fields.Text_day:setString(i18n("Nebula_sign_day_00" .. index))
	self.fields.Text_finish:setString(i18n("common_text_2601"))
	self.fields.scroll:setNumItems(table.nums(data.reward) / 2)
	self.fields.scroll:getChildAt(0):setAdvance()
	if SoraDFIsRA() then
		self.fields.scroll:getScrollPane():setPercX(1)
	else
		self.fields.scroll:getScrollPane():setPercX(0)
	end
	if index == data.curDay and not data.hadGot then
		self.fields.btn_get:setGrayed(false)
		self.fields.btn_get:setTitleText(i18n("common_text_2873"))
		self.fields.btn_get:getController("c1"):setSelectedIndex(0)
	elseif index <= data.curDay and data.hadGot then
		self.controllers.c1:setSelectedIndex(1)
	elseif index < data.curDay and not data.hadGot then
		self.fields.btn_get:setGrayed(false)
		self.fields.btn_get:setTitleText(i18n("common_text_2875"))
		self.fields.btn_get:getController("c1"):setSelectedIndex(2)
	else
		self.fields.btn_get:setTitleText(i18n("common_text_2873"))
		self.fields.btn_get:setGrayed(true)
		self.fields.btn_get:setTouchable(false)
	end
end
function Com_signSingle:onItemRendererReward(index, object)
	object:initData(self.data.reward[2 * index + 1], self.data.reward[2 * index + 2])
end
function Com_signSingle:onClickGetReward()
	SoraDPlaySound()
	lordInfoCtrl = nil
	;(nil)[1] = self.day
	;(nil)[2] = self.data.curDay
	;(nil)[3] = self.data.hadGot
	dump(nil, "fsfjdkfjkdfjkdfjk")
	if self.day == self.data.curDay and not self.data.hadGot then
		nebulaRegionSignCtrl:reqNormalSign()
	elseif self.day < self.data.curDay and not self.data.hadGot then
		_ENV = self.data.hadGot
		self.data.hadGot.content = "Nebula_sign_tips_006"
		self.data.hadGot.btnTitle = "common_text_2875"
		self.data.hadGot.num = signRewadRead.nebulaRegionSignRemedyPrice(self.day)
		self.data.hadGot.haveGold = lordInfoCtrl:getBaseInfo().gold
		local self.data.hadGot.btnHandle, param = function()
			if SoraDEnoughGold(signRewadRead.nebulaRegionSignRemedyPrice(self.day)) then
				nebulaRegionSignCtrl:reqGoldSign(self.day)
			end
		end, self.data.hadGot
		uiManager:show("MessageBoxCost", param):setOwnerKey(self)
	end
end
function Com_signSingle:onShow()
end
return Com_signSingle

local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001678_HelpPanel = class("Activity_9001678_HelpPanel", baseFguiPanel)
function Activity_9001678_HelpPanel:ctor(...)
	self.isLRU = true
	Activity_9001678_HelpPanel.super.ctor(self, ...)
	print("Activity_9001678_HelpPanel:ctor", self.viewName)
end
function Activity_9001678_HelpPanel:onInit()
	print("=======Activity_9001678_HelpPanel:onInit")
	self.forstyNum = constantRead.getConstValue("FORSTY_DISCOUNT_NUM", 3)
	self.fields.Panel_bg:setString(i18n("Frosty_Market_text_04"))
	self.fields.Text_none:setString(i18n("Frosty_Market_text_07"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_share:setString(i18n("Frosty_Market_text_11"))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.Button_price:addClickListener(handler(self, self.btnBuyClick))
end
function Activity_9001678_HelpPanel:onItemRenderer(index, obj)
	obj:initData(self.helperList[index + 1])
end
function Activity_9001678_HelpPanel:endShow()
	print("=======Activity_9001678_HelpPanel:endShow")
	self.data = self.param.data
	self.fields.Com_item:initData(self.data.goodCfg.id, self.data.goodCfg.count)
	self.fields.Text_name:setString(publicRead.getName(self.data.goodCfg.id))
	local discount, count = activity_9001678_Ctrl:getDayDiscount(self.data.goodsID)
	self.curPrice = math.max(0, self.data.oriPrice.count - discount)
	self.helpCount = count
	self.fields.Button_price:initData(self.data.oriPrice.id, i18n("common_text_282"), self.curPrice, self.data.oriPrice.count)
	self:updateShareBtn()
	self.helperList, _ENV = self.updateShareBtn, self.updateShareBtn
	activity_9001678_Ctrl:sendHelpersMsg(self.data.goodsID)
	SoraDShowLoading(self)
end
function Activity_9001678_HelpPanel:updateShareBtn()
	local shareCD = activity_9001678_Ctrl:getShareLeftTime()
	if 0 < shareCD then
		self.fields.Button_share:setTime(shareCD, "Frosty_Market_text_24", function()
			self.fields.Button_share:setString(i18n("Frosty_Market_text_11"))
		end)
	else
		self.fields.Button_share:setString(i18n("Frosty_Market_text_11"))
	end
end
function Activity_9001678_HelpPanel:updateView(target, data)
	SoraDCloseLoading(self)
	if data.key == "helpers" then
		self.helperList = data.helpers
	elseif data.key == "share" then
		self:updateShareBtn()
	end
	self.fields.List:setNumItems(#self.helperList)
	self.fields.Text_none:setVisible(#self.helperList == 0)
end
function Activity_9001678_HelpPanel:btnShareClick()
	SoraDPlaySound()
	local shareCD = activity_9001678_Ctrl:getShareLeftTime()
	if 0 < shareCD then
		SoraDShowMsgTip(i18n("Frosty_Market_text_12"))
		return
	end
	if self.helpCount >= self.forstyNum then
		SoraDShowMsgTip(i18n("Frosty_Market_text_13"))
		return
	end
	_ENV = i18n("Frosty_Market_text_13")
	i18n("Frosty_Market_text_13").goodId = self.data.goodsID
	uiManager:show("Activity_9001678_Share", i18n("Frosty_Market_text_13"))
end
function Activity_9001678_HelpPanel:btnBuyClick()
	SoraDPlaySound()
	if self.curPrice > backpackCtrl:getItemCount(self.data.oriPrice.id) then
		SoraDShowMsgTip(i18n("Frosty_Market_text_10"))
		return
	end
	if self.helpCount >= self.forstyNum then
		activity_9001678_Ctrl:sendBuyMsg(self.data.goodsID)
		self:close()
	else
		_ENV = i18n("Frosty_Market_text_10")
		i18n("Frosty_Market_text_10").content = i18n("Frosty_Market_text_8")
		i18n("Frosty_Market_text_10").cancelString = i18n("common_text_185")
		i18n("Frosty_Market_text_10").confirmFunc = function()
			activity_9001678_Ctrl:sendBuyMsg(self.data.goodsID)
			self:close()
		end
		uiManager:show("MessageBox", i18n("Frosty_Market_text_10"))
	end
end
return Activity_9001678_HelpPanel

local activity_9001678_Read = include("activity_9001678_Read")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001678_DiscountPanel = class("Activity_9001678_DiscountPanel", baseFguiPanel)
function Activity_9001678_DiscountPanel:ctor(...)
	self.isLRU = true
	Activity_9001678_DiscountPanel.super.ctor(self, ...)
	print("Activity_9001678_DiscountPanel:ctor", self.viewName)
end
function Activity_9001678_DiscountPanel:onInit()
	print("=======Activity_9001678_DiscountPanel:onInit")
	self.fields.mv_xz:setAllFrameName("9001678_zp_frame_%.2d.png", 1)
end
function Activity_9001678_DiscountPanel:endShow()
	print("=======Activity_9001678_DiscountPanel:endShow")
	self.goodsID = self.param.goodsID
	self.discount = self.param.discount
	self.cfg = activity_9001678_Read.getFrostyMarketCfg(self.goodsID)
	self.itemID = activity_9001678_Read.getFrostyMarketToolID()
	local position = 1
	for i = 1, 6 do
		local val = self.cfg.discount[i].val
		self.fields["Lab_dis" .. i]:setTitle("-" .. val)
		self.fields["Lab_dis" .. i]:setIcon(publicRead.getIcon(self.itemID))
		if val == self.discount then
			position = i
		end
	end
	self.fields.mv_xz:setVisible(false)
	self.fields.Com_zp:setVisible(true)
	local toRotation = (position - 1) * 60
	local actRotation = toRotation + 1080
	self.fields.Com_zp:setRotation(0)
	_UPVALUE4_ = self.discount
	self.discount[1] = ffa.exponentialInOut(ffa.rotateTo(2.4, actRotation))
	self.discount[2] = ffa.delay(0.3)
	self.discount[3] = ffa.callFunc(function()
		self.fields.Com_zp:setVisible(false)
		self.fields.mv_xz:setVisible(true)
		self.fields.mv_xz:setPlaySettings(0, -1, 1, -1)
		self.fields.mv_xz:setRotation(toRotation)
	end)
	self.discount[4] = ffa.delay(1)
	self.discount[5] = ffa.callFunc(function()
		self:close()
	end)
	self.discount[6] = ffa.callFunc(function()
		self:close()
	end)
	self.fields.Com_zp:runAction(ffa.seq(self.discount))
end
return Activity_9001678_DiscountPanel

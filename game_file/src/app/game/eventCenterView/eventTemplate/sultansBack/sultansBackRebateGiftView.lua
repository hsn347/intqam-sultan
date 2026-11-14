local privilegeGiftRead = include("privilegeGiftRead")
local sultansBackRebateUtil = include("sultansBackRebateUtil")
local sultansBackRebateGiftView = class("sultansBackRebateGiftView", function()
	local target = SoraDCreateBasePanel("sultansBackRebateGiftView")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackRebateGiftView:ctor()
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_Size_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCCS("sultansBackRebateGiftSingle")
end
function sultansBackRebateGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_RREBATE_REFRESH", handler(self, self.updataScroll))
end
function sultansBackRebateGiftView:init(payType)
	self.payType = payType
	self:updataScroll()
end
function sultansBackRebateGiftView:setParentView(parent)
	self.parentView = parent
end
function sultansBackRebateGiftView:updataScroll(target, data)
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		v.statues = sultansBackRebateUtil.getRechargeStatues(v)
	end
	table.sort(giftInfo, function(a, b)
		if a.statues ~= b.statues then
			return a.statues < b.statues
		end
		if a.extralimit ~= b.extralimit then
			return a.extralimit < b.extralimit
		end
		if a.price ~= b.price then
			return a.price < b.price
		end
		return a.rechargeID < b.rechargeID
	end)
	for i, v in ipairs(giftInfo) do
		v.index = i
	end
	self.scrollItem:jumpToTop()
	privilegeGiftRead = sultansBackRebateUtil.getRechargeStatues(v)
	sultansBackRebateUtil.getRechargeStatues(v).scroll = self.scrollItem
	sultansBackRebateUtil.getRechargeStatues(v).view = self.parentView
	sultansBackRebateUtil.getRechargeStatues(v).payType = self.payType
	self.scrollItem:updateScrollView(cc.size(640, 155), giftInfo, 1, (sultansBackRebateUtil.getRechargeStatues(v)))
end
function sultansBackRebateGiftView:resetSize(size)
	self.scrollItem:setContentSize(size)
end
return sultansBackRebateGiftView

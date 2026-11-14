local baseComponent = require("fgui.base.baseComponent")
local Com_recharge_tinyNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_recharge_tinyNode", Com_recharge_tinyNode)
local OCX_TYPE_PAGE = 0
local OCX_TYPE_BUTTON = 1
local OCX_TYPE_TEXT = 2
local OCX_TYPE_TIMER = 3
local OCX_TYPE_CLICKIMAGE = 4
local OCX_TYPE_CREATESPRITE = 5
function Com_recharge_tinyNode:onInit()
	self:fixChildrenPos()
	self.fields.Button_buy:addClickEventListener(handler(self, self.onBtnClick))
	self.fields.Panel_touch:addEventListener(fgui.UIEventType.Click, handler(self, self.onBtnClick))
end
function Com_recharge_tinyNode:onShow()
end
function Com_recharge_tinyNode:initPageData(pageData, tinyNode, size)
	self:setSize(size)
	self.tinyNode = tinyNode
	for i, v in ipairs(pageData) do
		if v.type == OCX_TYPE_BUTTON then
			self.fields.Button_buy:setTitle(v.val)
			self.fields.Button_buy:setTag(v.tag)
			self.fields.Button_buy:setVisible(not v.invisible)
			self.btnInfo = v.info
		elseif v.type == OCX_TYPE_TEXT then
			if self.fields[v.name] then
				self.fields[v.name]:setString(v.val)
			end
		elseif v.type == OCX_TYPE_TIMER then
			self.fields.Text_time:beginTime(v.val)
		elseif v.type == OCX_TYPE_CLICKIMAGE then
			self.btnInfo = v.info
		elseif v.type == OCX_TYPE_CREATESPRITE then
			self.fields.Text_time:setVisible(not v.unVisiable)
		end
	end
end
function Com_recharge_tinyNode:onBtnClick()
	if not self.btnInfo then
		return
	end
	SoraDPlaySound()
	self.tinyNode.timerInterval = 1
	self:openItemList(self.btnInfo)
end
function Com_recharge_tinyNode:openItemList(ocxTbl)
	local giftID = ocxTbl.ID or ocxTbl.luckyGiftID
	if giftID then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).id = giftID
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD05
			uiManager:show("rechargePopView", nil)
		else
			local panel = SoraDCreatePanel("rechargePopView")
			panel:initData(giftID, gRechargeActiveFromEnum.ROAD05)
			panel:show()
		end
	end
end
return Com_recharge_tinyNode

local rechargeRead = include("rechargeRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_gift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://commonSpeedUpByItemBox/Com_gift", Com_gift)
function Com_gift:onInit()
	self.fields.Btn_buy:setString(i18n("common_text_282"))
	self.fields.Btn_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.touch:addClickListener(handler(self, self.popGiftClick))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_gift:onShow()
end
function Com_gift:initData(giftID, giftData)
	self.giftID = giftID
	local giftStyle = rechargeRead.getPageViewData(self.giftID)
	self.fields.Text_name:setString(i18n(giftStyle.activeName))
	local timeCount = 0
	backpackltCtrl = i18n(giftStyle.activeName)
	i18n(giftStyle.activeName)[1] = "id"
	i18n(giftStyle.activeName)[2] = "count"
	local giftList = serviceFunctions.tableFormat(giftData.data.gift, i18n(giftStyle.activeName))
	for k, v in ipairs(giftList) do
		local itemType = backpackltCtrl:getItemType(tonumber(v.id))
		if itemType == gItemType.ABBR_BUILD_UPGRADE_SPEED_UP then
			local result = backpackltCtrl:getResult(tonumber(v.id))
			if result.key == gAbbrSpeedUpType.BUILD_UPGRADE then
				timeCount = timeCount + v.count * result.value
			end
		end
	end
	rechargeRead = i18n(giftStyle.activeName)
	rechargeRead = tonumber(v.id)
	tonumber(v.id).count = math.floor(timeCount / 3600)
	i18n(giftStyle.activeName).num = fguiHelper.getColorString("#4CE61A", i18n("common_text_552", tonumber(v.id)))
	self.fields.Text_des:setString(i18n("accelerate_text_007", i18n(giftStyle.activeName)))
end
function Com_gift:popGiftClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).id = self.giftID
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD45
		uiManager:show("rechargePopView", nil)
	else
		local panel = SoraDCreatePanel("rechargePopView")
		panel:initData(self.giftID, gRechargeActiveFromEnum.ROAD45)
		panel:show()
	end
end
function Com_gift:btnBuyClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).id = self.giftID
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD45
		uiManager:show("rechargePopView", nil)
	else
		local panel = SoraDCreatePanel("rechargePopView")
		panel:initData(self.giftID, gRechargeActiveFromEnum.ROAD45)
		panel:show()
	end
end
return Com_gift

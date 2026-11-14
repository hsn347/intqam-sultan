local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local heroTrialCommon = include("heroTrialCommon")
local htPointMgr = include("htPointMgr")
local htBattleMgr = include("htBattleMgr")
local heroTrialltCtrl = include("heroTrialltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_auto = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://heroTrial/Btn_auto", Btn_auto)
function Btn_auto:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_auto:onShow()
end
function Btn_auto:init(mapId, parent)
	self.mapId = mapId
	self.parent = parent
end
function Btn_auto:setStatus(isAuto)
	self.isAuto = isAuto
	self.fields.title:setString(self.isAuto and i18n("common_text_1767") or i18n("common_text_1766"))
end
function Btn_auto:checkVip()
	local vip_limited = IsArClient and _G.VIP_LV5_LIMITED or _G.VIP_LV4_LIMITED
	_ENV = nil
	;(nil).vip = vip_limited
	self.fields.autoTip:setString(i18n("common_text_1771", nil))
	local vipDetail = lordInfoCtrl:getVipDetails()
	self.controllers.c1:setSelectedIndex(1)
	if not vipDetail.isActivated or not (vip_limited <= vipDetail.level) then
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_auto:btnClick()
	SoraDPlaySound()
	if self.isAuto then
		SoraDShowMsgBox(i18n("common_text_1747"), i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
			if type == MSGBOX_CALLBACK_YES then
				heroTrialCtrl:quitAutoTrial()
				self:setStatus(false)
			end
		end)
	elseif self.controllers.c1:getSelectedIndex() == 0 then
		SoraDShowMsgBox(i18n("common_text_1837"), i18n("common_text_449"), i18n("common_text_1838"), handler(self, self.openVipView))
	else
		local queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
		if not queue then
			if not heroTrialCommon.isTrialStarted(self.mapId) then
				if htPointMgr.isPointEnough(heroTrialltCtrl.getCostPointOfTrial()) then
					self:checkOpenTrial()
				else
					local itemId = 800301
					local itemCount = backpackCtrl:getItemCount(itemId)
					if 0 < itemCount then
						_ENV, _ENV = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().id = itemId
						heroTrialltCtrl.getCostPointOfTrial().itemData, heroTrialltCtrl.getCostPointOfTrial().count = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().msg = i18n("common_text_3420")
						uiManager:show("newItemSingleUse", heroTrialltCtrl.getCostPointOfTrial())
					else
						_ENV = heroTrialltCtrl.getCostPointOfTrial()
						heroTrialltCtrl.getCostPointOfTrial().point = HEROTRIAL_COST_POINTS
						SoraDShowMsgTip(i18n("common_text_1743", heroTrialltCtrl.getCostPointOfTrial()))
					end
				end
			elseif self.parent and self.parent.openDispatch then
				self.parent:openDispatch()
			end
		else
			SoraDShowMsgTip(i18n("common_text_1745"))
		end
	end
end
function Btn_auto:openVipView(event)
	if event == MSGBOX_CALLBACK_YES then
		SoraDPlaySound()
		uiManager:show("vipCenterView")
	end
end
function Btn_auto:checkOpenTrial()
	local title = i18n("common_text_1742")
	if htBattleMgr.trialStatus then
		title = i18n("common_text_1836")
	end
	SoraDShowMsgBox(title, i18n("common_text_054"), i18n("common_text_185"), function(event)
		if event == MSGBOX_CALLBACK_YES then
			local armyIDList = armyCtrl:getArmyIDList()
			local count = 0
			for i, v in ipairs(armyIDList) do
				count = count + armyCtrl:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY)
			end
			if 0 < count then
				heroTrialCtrl:openTrial(self.mapId)
			else
				SoraDShowMsgBox(i18n("common_text_1744"), i18n("common_text_054"))
			end
		end
	end)
end
return Btn_auto
